
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
  800031:	e8 93 18 00 00       	call   8018c9 <libmain>
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
  800067:	e8 96 2e 00 00       	call   802f02 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 d9 2e 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 42 2c 00 00       	call   802d09 <malloc>
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
  8000df:	e8 1e 2e 00 00       	call   802f02 <sys_calculate_free_frames>
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
  800125:	68 a0 40 80 00       	push   $0x8040a0
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 43 1c 00 00       	call   801d74 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 14 2e 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 1c 41 80 00       	push   $0x80411c
  800150:	6a 0c                	push   $0xc
  800152:	e8 1d 1c 00 00       	call   801d74 <cprintf_colored>
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
  800174:	e8 89 2d 00 00       	call   802f02 <sys_calculate_free_frames>
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
  8001b9:	e8 44 2d 00 00       	call   802f02 <sys_calculate_free_frames>
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
  8001f8:	68 94 41 80 00       	push   $0x804194
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 70 1b 00 00       	call   801d74 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 41 2d 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 20 42 80 00       	push   $0x804220
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 43 1b 00 00       	call   801d74 <cprintf_colored>
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
  800270:	e8 4f 30 00 00       	call   8032c4 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 98 42 80 00       	push   $0x804298
  80028f:	6a 0c                	push   $0xc
  800291:	e8 de 1a 00 00       	call   801d74 <cprintf_colored>
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
  8002ae:	e8 4f 2c 00 00       	call   802f02 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 92 2c 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 60 80 00 	mov    0x806020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 66 2a 00 00       	call   802d37 <free>
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
  8002fc:	e8 4c 2c 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 d0 42 80 00       	push   $0x8042d0
  800318:	6a 0c                	push   $0xc
  80031a:	e8 55 1a 00 00       	call   801d74 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 db 2b 00 00       	call   802f02 <sys_calculate_free_frames>
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
  800342:	68 1c 43 80 00       	push   $0x80431c
  800347:	6a 0c                	push   $0xc
  800349:	e8 26 1a 00 00       	call   801d74 <cprintf_colored>
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
  8003a0:	e8 1f 2f 00 00       	call   8032c4 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 78 43 80 00       	push   $0x804378
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 ae 19 00 00       	call   801d74 <cprintf_colored>
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
  800416:	68 b0 43 80 00       	push   $0x8043b0
  80041b:	6a 03                	push   $0x3
  80041d:	e8 52 19 00 00       	call   801d74 <cprintf_colored>
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
  8004df:	68 e0 43 80 00       	push   $0x8043e0
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 89 18 00 00       	call   801d74 <cprintf_colored>
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
  8005b9:	68 e0 43 80 00       	push   $0x8043e0
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 af 17 00 00       	call   801d74 <cprintf_colored>
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
  800693:	68 e0 43 80 00       	push   $0x8043e0
  800698:	6a 0c                	push   $0xc
  80069a:	e8 d5 16 00 00       	call   801d74 <cprintf_colored>
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
  80076d:	68 e0 43 80 00       	push   $0x8043e0
  800772:	6a 0c                	push   $0xc
  800774:	e8 fb 15 00 00       	call   801d74 <cprintf_colored>
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
  800847:	68 e0 43 80 00       	push   $0x8043e0
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 21 15 00 00       	call   801d74 <cprintf_colored>
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
  800921:	68 e0 43 80 00       	push   $0x8043e0
  800926:	6a 0c                	push   $0xc
  800928:	e8 47 14 00 00       	call   801d74 <cprintf_colored>
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
  800a16:	68 e0 43 80 00       	push   $0x8043e0
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 52 13 00 00       	call   801d74 <cprintf_colored>
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
  800b14:	68 e0 43 80 00       	push   $0x8043e0
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 54 12 00 00       	call   801d74 <cprintf_colored>
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
  800c12:	68 e0 43 80 00       	push   $0x8043e0
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 56 11 00 00       	call   801d74 <cprintf_colored>
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
  800d10:	68 e0 43 80 00       	push   $0x8043e0
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 58 10 00 00       	call   801d74 <cprintf_colored>
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
  800dfd:	68 e0 43 80 00       	push   $0x8043e0
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 6b 0f 00 00       	call   801d74 <cprintf_colored>
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
  800eea:	68 e0 43 80 00       	push   $0x8043e0
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 7e 0e 00 00       	call   801d74 <cprintf_colored>
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
  800fd7:	68 e0 43 80 00       	push   $0x8043e0
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 91 0d 00 00       	call   801d74 <cprintf_colored>
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
  800ffa:	68 32 44 80 00       	push   $0x804432
  800fff:	6a 03                	push   $0x3
  801001:	e8 6e 0d 00 00       	call   801d74 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c e2 81 00 0d 	movl   $0xd,0x81e24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 e3 1e 00 00       	call   802f02 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 23 1f 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
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
  801055:	e8 af 1c 00 00       	call   802d09 <malloc>
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
  801084:	68 50 44 80 00       	push   $0x804450
  801089:	6a 0c                	push   $0xc
  80108b:	e8 e4 0c 00 00       	call   801d74 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 b5 1e 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 8c 44 80 00       	push   $0x80448c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 b8 0c 00 00       	call   801d74 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 3e 1e 00 00       	call   802f02 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c e2 81 00       	mov    0x81e24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 fc 44 80 00       	push   $0x8044fc
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 8c 0c 00 00       	call   801d74 <cprintf_colored>
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
  801103:	53                   	push   %ebx
  801104:	83 c4 80             	add    $0xffffff80,%esp
	sys_set_uheap_strategy(UHP_PLACE_CUSTOMFIT);
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	6a 05                	push   $0x5
  80110c:	e8 4e 21 00 00       	call   80325f <sys_set_uheap_strategy>
  801111:	83 c4 10             	add    $0x10,%esp

	//cprintf_colored(TEXT_TESTERR_CLR, "%~1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  801114:	a1 00 62 80 00       	mov    0x806200,%eax
  801119:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80111f:	a1 00 62 80 00       	mov    0x806200,%eax
  801124:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80112a:	39 c2                	cmp    %eax,%edx
  80112c:	72 14                	jb     801142 <_main+0x43>
			panic("Please increase the WS size");
  80112e:	83 ec 04             	sub    $0x4,%esp
  801131:	68 44 45 80 00       	push   $0x804544
  801136:	6a 17                	push   $0x17
  801138:	68 60 45 80 00       	push   $0x804560
  80113d:	e8 37 09 00 00       	call   801a79 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  801142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801149:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	int envID = sys_getenvid();
  801150:	e8 5d 1f 00 00       	call   8030b2 <sys_getenvid>
  801155:	89 45 ec             	mov    %eax,-0x14(%ebp)

	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801158:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)

	void* ptr_allocations[20] = {0};
  80115f:	8d 55 84             	lea    -0x7c(%ebp),%edx
  801162:	b9 14 00 00 00       	mov    $0x14,%ecx
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
  80116c:	89 d7                	mov    %edx,%edi
  80116e:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames, expected, expectedUpper, diff;
	int usedDiskPages;
	//[1] Allocate all
	cprintf_colored(TEXT_cyan, "\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR [20%]\n");
  801170:	83 ec 08             	sub    $0x8,%esp
  801173:	68 78 45 80 00       	push   $0x804578
  801178:	6a 03                	push   $0x3
  80117a:	e8 f5 0b 00 00       	call   801d74 <cprintf_colored>
  80117f:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  801182:	e8 7b 1d 00 00       	call   802f02 <sys_calculate_free_frames>
  801187:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80118a:	e8 be 1d 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  80118f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	6a 01                	push   $0x1
  801197:	68 00 00 10 00       	push   $0x100000
  80119c:	68 bb 45 80 00       	push   $0x8045bb
  8011a1:	e8 ab 1b 00 00       	call   802d51 <smalloc>
  8011a6:	83 c4 10             	add    $0x10,%esp
  8011a9:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if (ptr_allocations[0] != (uint32*)pagealloc_start)
  8011ac:	8b 55 84             	mov    -0x7c(%ebp),%edx
  8011af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011b2:	39 c2                	cmp    %eax,%edx
  8011b4:	74 19                	je     8011cf <_main+0xd0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	68 c0 45 80 00       	push   $0x8045c0
  8011c5:	6a 0c                	push   $0xc
  8011c7:	e8 a8 0b 00 00       	call   801d74 <cprintf_colored>
  8011cc:	83 c4 10             	add    $0x10,%esp
		expected = 256+1; /*256pages +1table*/
  8011cf:	c7 45 dc 01 01 00 00 	movl   $0x101,-0x24(%ebp)
		expectedUpper = expected
  8011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d9:	83 c0 04             	add    $0x4,%eax
  8011dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
						+2 /*KH Block Alloc: 1 for Share object, 1 for framesStorage*/
						+2 /*UH Block Alloc: max of 1 page & 1 table*/;
		diff = (freeFrames - sys_calculate_free_frames());
  8011df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8011e2:	e8 1b 1d 00 00       	call   802f02 <sys_calculate_free_frames>
  8011e7:	29 c3                	sub    %eax,%ebx
  8011e9:	89 d8                	mov    %ebx,%eax
  8011eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8011ee:	83 ec 04             	sub    $0x4,%esp
  8011f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8011f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8011f7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8011fa:	e8 39 ee ff ff       	call   800038 <inRange>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	75 2c                	jne    801232 <_main+0x133>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  801206:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80120d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801210:	e8 ed 1c 00 00       	call   802f02 <sys_calculate_free_frames>
  801215:	29 c3                	sub    %eax,%ebx
  801217:	89 d8                	mov    %ebx,%eax
  801219:	83 ec 0c             	sub    $0xc,%esp
  80121c:	ff 75 d8             	pushl  -0x28(%ebp)
  80121f:	ff 75 dc             	pushl  -0x24(%ebp)
  801222:	50                   	push   %eax
  801223:	68 30 46 80 00       	push   $0x804630
  801228:	6a 0c                	push   $0xc
  80122a:	e8 45 0b 00 00       	call   801d74 <cprintf_colored>
  80122f:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801232:	e8 16 1d 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  801237:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80123a:	74 19                	je     801255 <_main+0x156>
  80123c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	68 d0 46 80 00       	push   $0x8046d0
  80124b:	6a 0c                	push   $0xc
  80124d:	e8 22 0b 00 00       	call   801d74 <cprintf_colored>
  801252:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[1] = malloc(1*Mega-kilo);
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	68 00 fc 0f 00       	push   $0xffc00
  80125d:	e8 a7 1a 00 00       	call   802d09 <malloc>
  801262:	83 c4 10             	add    $0x10,%esp
  801265:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[1] != (pagealloc_start + 1*Mega))
  801268:	8b 45 88             	mov    -0x78(%ebp),%eax
  80126b:	89 c2                	mov    %eax,%edx
  80126d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801270:	05 00 00 10 00       	add    $0x100000,%eax
  801275:	39 c2                	cmp    %eax,%edx
  801277:	74 19                	je     801292 <_main+0x193>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801280:	83 ec 08             	sub    $0x8,%esp
  801283:	68 f0 46 80 00       	push   $0x8046f0
  801288:	6a 0c                	push   $0xc
  80128a:	e8 e5 0a 00 00       	call   801d74 <cprintf_colored>
  80128f:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB
		ptr_allocations[2] = malloc(1*Mega-kilo);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	68 00 fc 0f 00       	push   $0xffc00
  80129a:	e8 6a 1a 00 00       	call   802d09 <malloc>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[2] != (pagealloc_start + 2*Mega))
  8012a5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ad:	05 00 00 20 00       	add    $0x200000,%eax
  8012b2:	39 c2                	cmp    %eax,%edx
  8012b4:	74 19                	je     8012cf <_main+0x1d0>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8012b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012bd:	83 ec 08             	sub    $0x8,%esp
  8012c0:	68 f0 46 80 00       	push   $0x8046f0
  8012c5:	6a 0c                	push   $0xc
  8012c7:	e8 a8 0a 00 00       	call   801d74 <cprintf_colored>
  8012cc:	83 c4 10             	add    $0x10,%esp

		//Allocate 1 MB (New Table)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 00 fc 0f 00       	push   $0xffc00
  8012d7:	e8 2d 1a 00 00       	call   802d09 <malloc>
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[3] != (pagealloc_start + 3*Mega) )
  8012e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ea:	05 00 00 30 00       	add    $0x300000,%eax
  8012ef:	39 c2                	cmp    %eax,%edx
  8012f1:	74 19                	je     80130c <_main+0x20d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8012f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012fa:	83 ec 08             	sub    $0x8,%esp
  8012fd:	68 f0 46 80 00       	push   $0x8046f0
  801302:	6a 0c                	push   $0xc
  801304:	e8 6b 0a 00 00       	call   801d74 <cprintf_colored>
  801309:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[4] = malloc(2*Mega-kilo);
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	68 00 fc 1f 00       	push   $0x1ffc00
  801314:	e8 f0 19 00 00       	call   802d09 <malloc>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega))
  80131f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801322:	89 c2                	mov    %eax,%edx
  801324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801327:	05 00 00 40 00       	add    $0x400000,%eax
  80132c:	39 c2                	cmp    %eax,%edx
  80132e:	74 19                	je     801349 <_main+0x24a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801330:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	68 f0 46 80 00       	push   $0x8046f0
  80133f:	6a 0c                	push   $0xc
  801341:	e8 2e 0a 00 00       	call   801d74 <cprintf_colored>
  801346:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 2 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  801349:	e8 b4 1b 00 00       	call   802f02 <sys_calculate_free_frames>
  80134e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801351:	e8 f7 1b 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  801356:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  801359:	83 ec 04             	sub    $0x4,%esp
  80135c:	6a 01                	push   $0x1
  80135e:	68 00 00 20 00       	push   $0x200000
  801363:	68 22 47 80 00       	push   $0x804722
  801368:	e8 e4 19 00 00       	call   802d51 <smalloc>
  80136d:	83 c4 10             	add    $0x10,%esp
  801370:	89 45 98             	mov    %eax,-0x68(%ebp)
		if (ptr_allocations[5] != (uint32*)(pagealloc_start + 6*Mega))
  801373:	8b 45 98             	mov    -0x68(%ebp),%eax
  801376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801379:	81 c2 00 00 60 00    	add    $0x600000,%edx
  80137f:	39 d0                	cmp    %edx,%eax
  801381:	74 19                	je     80139c <_main+0x29d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  801383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	68 c0 45 80 00       	push   $0x8045c0
  801392:	6a 0c                	push   $0xc
  801394:	e8 db 09 00 00       	call   801d74 <cprintf_colored>
  801399:	83 c4 10             	add    $0x10,%esp
		expected = 512+1; /*512pages +1table*/
  80139c:	c7 45 dc 01 02 00 00 	movl   $0x201,-0x24(%ebp)
		expectedUpper = expected +1 /*KH Block Alloc: 1 for framesStorage*/;
  8013a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a6:	40                   	inc    %eax
  8013a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013ad:	e8 50 1b 00 00       	call   802f02 <sys_calculate_free_frames>
  8013b2:	29 c3                	sub    %eax,%ebx
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8013bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8013c2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013c5:	e8 6e ec ff ff       	call   800038 <inRange>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	75 2c                	jne    8013fd <_main+0x2fe>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  8013d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013d8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013db:	e8 22 1b 00 00       	call   802f02 <sys_calculate_free_frames>
  8013e0:	29 c3                	sub    %eax,%ebx
  8013e2:	89 d8                	mov    %ebx,%eax
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8013ea:	ff 75 dc             	pushl  -0x24(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	68 30 46 80 00       	push   $0x804630
  8013f3:	6a 0c                	push   $0xc
  8013f5:	e8 7a 09 00 00       	call   801d74 <cprintf_colored>
  8013fa:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  8013fd:	e8 4b 1b 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  801402:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801405:	74 19                	je     801420 <_main+0x321>
  801407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80140e:	83 ec 08             	sub    $0x8,%esp
  801411:	68 d0 46 80 00       	push   $0x8046d0
  801416:	6a 0c                	push   $0xc
  801418:	e8 57 09 00 00       	call   801d74 <cprintf_colored>
  80141d:	83 c4 10             	add    $0x10,%esp

		//Allocate 3 MB
		ptr_allocations[6] = malloc(3*Mega-kilo);
  801420:	83 ec 0c             	sub    $0xc,%esp
  801423:	68 00 fc 2f 00       	push   $0x2ffc00
  801428:	e8 dc 18 00 00       	call   802d09 <malloc>
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[6] != (pagealloc_start + 8*Mega))
  801433:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801436:	89 c2                	mov    %eax,%edx
  801438:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80143b:	05 00 00 80 00       	add    $0x800000,%eax
  801440:	39 c2                	cmp    %eax,%edx
  801442:	74 19                	je     80145d <_main+0x35e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801444:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80144b:	83 ec 08             	sub    $0x8,%esp
  80144e:	68 f0 46 80 00       	push   $0x8046f0
  801453:	6a 0c                	push   $0xc
  801455:	e8 1a 09 00 00       	call   801d74 <cprintf_colored>
  80145a:	83 c4 10             	add    $0x10,%esp

		//Allocate Shared 3 MB (New Table)
		freeFrames = sys_calculate_free_frames() ;
  80145d:	e8 a0 1a 00 00       	call   802f02 <sys_calculate_free_frames>
  801462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801465:	e8 e3 1a 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  80146a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	6a 00                	push   $0x0
  801472:	68 00 00 30 00       	push   $0x300000
  801477:	68 24 47 80 00       	push   $0x804724
  80147c:	e8 d0 18 00 00       	call   802d51 <smalloc>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[7] != (uint32*)(pagealloc_start + 11*Mega))
  801487:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80148a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80148d:	81 c2 00 00 b0 00    	add    $0xb00000,%edx
  801493:	39 d0                	cmp    %edx,%eax
  801495:	74 19                	je     8014b0 <_main+0x3b1>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  801497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	68 c0 45 80 00       	push   $0x8045c0
  8014a6:	6a 0c                	push   $0xc
  8014a8:	e8 c7 08 00 00       	call   801d74 <cprintf_colored>
  8014ad:	83 c4 10             	add    $0x10,%esp
		expected = 768+1; /*768pages +1table */
  8014b0:	c7 45 dc 01 03 00 00 	movl   $0x301,-0x24(%ebp)
		expectedUpper = expected +1 /*+1page for framesStorage by Kernel Page Allocator since it exceed 2KB size*/;
  8014b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ba:	40                   	inc    %eax
  8014bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8014be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8014c1:	e8 3c 1a 00 00       	call   802f02 <sys_calculate_free_frames>
  8014c6:	29 c3                	sub    %eax,%ebx
  8014c8:	89 d8                	mov    %ebx,%eax
  8014ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expectedUpper))
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8014d3:	ff 75 dc             	pushl  -0x24(%ebp)
  8014d6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8014d9:	e8 5a eb ff ff       	call   800038 <inRange>
  8014de:	83 c4 10             	add    $0x10,%esp
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	75 2c                	jne    801511 <_main+0x412>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong allocation (current=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expectedUpper);}
  8014e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014ec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8014ef:	e8 0e 1a 00 00       	call   802f02 <sys_calculate_free_frames>
  8014f4:	29 c3                	sub    %eax,%ebx
  8014f6:	89 d8                	mov    %ebx,%eax
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8014fe:	ff 75 dc             	pushl  -0x24(%ebp)
  801501:	50                   	push   %eax
  801502:	68 30 46 80 00       	push   $0x804630
  801507:	6a 0c                	push   $0xc
  801509:	e8 66 08 00 00       	call   801d74 <cprintf_colored>
  80150e:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) {is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong page file allocation: ");}
  801511:	e8 37 1a 00 00       	call   802f4d <sys_pf_calculate_allocated_pages>
  801516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801519:	74 19                	je     801534 <_main+0x435>
  80151b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	68 d0 46 80 00       	push   $0x8046d0
  80152a:	6a 0c                	push   $0xc
  80152c:	e8 43 08 00 00       	call   801d74 <cprintf_colored>
  801531:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)	eval+=20;
  801534:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801538:	74 04                	je     80153e <_main+0x43f>
  80153a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	is_correct = 1;
  80153e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//[2] Free some to create holes
	cprintf_colored(TEXT_cyan, "\n%~[2] Free some to create holes\n");
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	68 28 47 80 00       	push   $0x804728
  80154d:	6a 03                	push   $0x3
  80154f:	e8 20 08 00 00       	call   801d74 <cprintf_colored>
  801554:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[1]);
  801557:	8b 45 88             	mov    -0x78(%ebp),%eax
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	50                   	push   %eax
  80155e:	e8 d4 17 00 00       	call   802d37 <free>
  801563:	83 c4 10             	add    $0x10,%esp

		//2 MB Hole
		free(ptr_allocations[4]);
  801566:	8b 45 94             	mov    -0x6c(%ebp),%eax
  801569:	83 ec 0c             	sub    $0xc,%esp
  80156c:	50                   	push   %eax
  80156d:	e8 c5 17 00 00       	call   802d37 <free>
  801572:	83 c4 10             	add    $0x10,%esp

		//3 MB Hole
		free(ptr_allocations[6]);
  801575:	8b 45 9c             	mov    -0x64(%ebp),%eax
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	50                   	push   %eax
  80157c:	e8 b6 17 00 00       	call   802d37 <free>
  801581:	83 c4 10             	add    $0x10,%esp
	}

	//[3] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "\n%~[3] Allocate again [test custom fit] [40%]\n");
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	68 4c 47 80 00       	push   $0x80474c
  80158c:	6a 03                	push   $0x3
  80158e:	e8 e1 07 00 00       	call   801d74 <cprintf_colored>
  801593:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 512 KB - should be placed in 3rd hole [WORST FIT]
		is_correct = 1;
  801596:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[8] = smalloc("Cust1", 512*kilo - kilo, 1);
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	6a 01                	push   $0x1
  8015a2:	68 00 fc 07 00       	push   $0x7fc00
  8015a7:	68 7b 47 80 00       	push   $0x80477b
  8015ac:	e8 a0 17 00 00       	call   802d51 <smalloc>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if ((uint32) ptr_allocations[8] != (pagealloc_start + 8*Mega))
  8015b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8015ba:	89 c2                	mov    %eax,%edx
  8015bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015bf:	05 00 00 80 00       	add    $0x800000,%eax
  8015c4:	39 c2                	cmp    %eax,%edx
  8015c6:	74 19                	je     8015e1 <_main+0x4e2>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8015c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	68 f0 46 80 00       	push   $0x8046f0
  8015d7:	6a 0c                	push   $0xc
  8015d9:	e8 96 07 00 00       	call   801d74 <cprintf_colored>
  8015de:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  8015e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e5:	74 04                	je     8015eb <_main+0x4ec>
  8015e7:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  8015eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 2 MB - should be placed in 2nd hole [EXACT FIT]
		is_correct = 1;
  8015f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[9] = sget(envID, "y");
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	68 22 47 80 00       	push   $0x804722
  801601:	ff 75 ec             	pushl  -0x14(%ebp)
  801604:	e8 7c 17 00 00       	call   802d85 <sget>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 a8             	mov    %eax,-0x58(%ebp)
			if ((uint32) ptr_allocations[9] != (pagealloc_start + 4*Mega))
  80160f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801612:	89 c2                	mov    %eax,%edx
  801614:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801617:	05 00 00 40 00       	add    $0x400000,%eax
  80161c:	39 c2                	cmp    %eax,%edx
  80161e:	74 19                	je     801639 <_main+0x53a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801620:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801627:	83 ec 08             	sub    $0x8,%esp
  80162a:	68 f0 46 80 00       	push   $0x8046f0
  80162f:	6a 0c                	push   $0xc
  801631:	e8 3e 07 00 00       	call   801d74 <cprintf_colored>
  801636:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801639:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80163d:	74 04                	je     801643 <_main+0x544>
  80163f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801643:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 2 MB + 512 KB - should be placed in remaining of 3rd hole [EXACT FIT]
		is_correct = 1;
  80164a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[10] = smalloc("Cust2", 2*Mega + 512*kilo, 1);
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	6a 01                	push   $0x1
  801656:	68 00 00 28 00       	push   $0x280000
  80165b:	68 81 47 80 00       	push   $0x804781
  801660:	e8 ec 16 00 00       	call   802d51 <smalloc>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if ((uint32) ptr_allocations[10] != (pagealloc_start + 8*Mega + 512*kilo))
  80166b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80166e:	89 c2                	mov    %eax,%edx
  801670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801673:	05 00 00 88 00       	add    $0x880000,%eax
  801678:	39 c2                	cmp    %eax,%edx
  80167a:	74 19                	je     801695 <_main+0x596>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  80167c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801683:	83 ec 08             	sub    $0x8,%esp
  801686:	68 f0 46 80 00       	push   $0x8046f0
  80168b:	6a 0c                	push   $0xc
  80168d:	e8 e2 06 00 00       	call   801d74 <cprintf_colored>
  801692:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  801695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801699:	74 04                	je     80169f <_main+0x5a0>
  80169b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  80169f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared 512 KB - should be placed in 1st hole [WORST FIT]
		is_correct = 1;
  8016a6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[11] = sget(envID, "Cust1");
  8016ad:	83 ec 08             	sub    $0x8,%esp
  8016b0:	68 7b 47 80 00       	push   $0x80477b
  8016b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b8:	e8 c8 16 00 00       	call   802d85 <sget>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	89 45 b0             	mov    %eax,-0x50(%ebp)
			if ((uint32) ptr_allocations[11] != (pagealloc_start + 1*Mega))
  8016c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8016c6:	89 c2                	mov    %eax,%edx
  8016c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cb:	05 00 00 10 00       	add    $0x100000,%eax
  8016d0:	39 c2                	cmp    %eax,%edx
  8016d2:	74 19                	je     8016ed <_main+0x5ee>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8016d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016db:	83 ec 08             	sub    $0x8,%esp
  8016de:	68 f0 46 80 00       	push   $0x8046f0
  8016e3:	6a 0c                	push   $0xc
  8016e5:	e8 8a 06 00 00       	call   801d74 <cprintf_colored>
  8016ea:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=5;
  8016ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f1:	74 04                	je     8016f7 <_main+0x5f8>
  8016f3:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		is_correct = 1;
  8016f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate Shared 4 MB - should be placed in end of all allocations [EXTEND]
		is_correct = 1;
  8016fe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[12] = smalloc("Cust3", 4*Mega, 0);
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	6a 00                	push   $0x0
  80170a:	68 00 00 40 00       	push   $0x400000
  80170f:	68 87 47 80 00       	push   $0x804787
  801714:	e8 38 16 00 00       	call   802d51 <smalloc>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
			if ((uint32) ptr_allocations[12] != (pagealloc_start + 14*Mega))
  80171f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801722:	89 c2                	mov    %eax,%edx
  801724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801727:	05 00 00 e0 00       	add    $0xe00000,%eax
  80172c:	39 c2                	cmp    %eax,%edx
  80172e:	74 19                	je     801749 <_main+0x64a>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801737:	83 ec 08             	sub    $0x8,%esp
  80173a:	68 f0 46 80 00       	push   $0x8046f0
  80173f:	6a 0c                	push   $0xc
  801741:	e8 2e 06 00 00       	call   801d74 <cprintf_colored>
  801746:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  801749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80174d:	74 04                	je     801753 <_main+0x654>
  80174f:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801753:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	//[4] Free contiguous allocations
	cprintf_colored(TEXT_cyan, "%~\n%~[4] Free contiguous allocations\n");
  80175a:	83 ec 08             	sub    $0x8,%esp
  80175d:	68 90 47 80 00       	push   $0x804790
  801762:	6a 03                	push   $0x3
  801764:	e8 0b 06 00 00       	call   801d74 <cprintf_colored>
  801769:	83 c4 10             	add    $0x10,%esp
	{
		//1 MB Hole
		free(ptr_allocations[3]);
  80176c:	8b 45 90             	mov    -0x70(%ebp),%eax
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	50                   	push   %eax
  801773:	e8 bf 15 00 00       	call   802d37 <free>
  801778:	83 c4 10             	add    $0x10,%esp

		//1 MB Hole appended to previous 512 KB hole and next 1 MB Hole => 2MB + 512KB Hole
		free(ptr_allocations[2]);
  80177b:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80177e:	83 ec 0c             	sub    $0xc,%esp
  801781:	50                   	push   %eax
  801782:	e8 b0 15 00 00       	call   802d37 <free>
  801787:	83 c4 10             	add    $0x10,%esp
	}

	//[5] Allocate again [test custom fit]
	cprintf_colored(TEXT_cyan, "%~\n%~[5] Allocate again [test custom fit] [40%]\n");
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	68 b8 47 80 00       	push   $0x8047b8
  801792:	6a 03                	push   $0x3
  801794:	e8 db 05 00 00       	call   801d74 <cprintf_colored>
  801799:	83 c4 10             	add    $0x10,%esp
	{
		//Allocate Shared 2 MB + 1 KB - should be placed in the contiguous hole (512 KB + 2 MB)
		is_correct = 1;
  80179c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[13] = smalloc("Cust4", 2*Mega + 1*kilo, 0);
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	6a 00                	push   $0x0
  8017a8:	68 00 04 20 00       	push   $0x200400
  8017ad:	68 e9 47 80 00       	push   $0x8047e9
  8017b2:	e8 9a 15 00 00       	call   802d51 <smalloc>
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if ((uint32) ptr_allocations[13] != (pagealloc_start + 1*Mega + 512*kilo))
  8017bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c5:	05 00 00 18 00       	add    $0x180000,%eax
  8017ca:	39 c2                	cmp    %eax,%edx
  8017cc:	74 19                	je     8017e7 <_main+0x6e8>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  8017ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	68 f0 46 80 00       	push   $0x8046f0
  8017dd:	6a 0c                	push   $0xc
  8017df:	e8 90 05 00 00       	call   801d74 <cprintf_colored>
  8017e4:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  8017e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017eb:	74 04                	je     8017f1 <_main+0x6f2>
  8017ed:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  8017f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Get Shared of 1 MB [should be placed at the end of all allocations]
		is_correct = 1;
  8017f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[14] = sget(envID, "x");
  8017ff:	83 ec 08             	sub    $0x8,%esp
  801802:	68 bb 45 80 00       	push   $0x8045bb
  801807:	ff 75 ec             	pushl  -0x14(%ebp)
  80180a:	e8 76 15 00 00       	call   802d85 <sget>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if ((uint32) ptr_allocations[14] != (pagealloc_start + 18*Mega))
  801815:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801818:	89 c2                	mov    %eax,%edx
  80181a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181d:	05 00 00 20 01       	add    $0x1200000,%eax
  801822:	39 c2                	cmp    %eax,%edx
  801824:	74 19                	je     80183f <_main+0x740>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	68 f0 46 80 00       	push   $0x8046f0
  801835:	6a 0c                	push   $0xc
  801837:	e8 38 05 00 00       	call   801d74 <cprintf_colored>
  80183c:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=10;
  80183f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801843:	74 04                	je     801849 <_main+0x74a>
  801845:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		is_correct = 1;
  801849:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//Allocate shared of 508 KB [should be placed in the remaining part of the contiguous (512 KB + 2 MB) hole
		is_correct = 1;
  801850:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		{
			ptr_allocations[15] = smalloc("Cust5", 508*kilo, 0);
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	6a 00                	push   $0x0
  80185c:	68 00 f0 07 00       	push   $0x7f000
  801861:	68 ef 47 80 00       	push   $0x8047ef
  801866:	e8 e6 14 00 00       	call   802d51 <smalloc>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if ((uint32) ptr_allocations[15] != (pagealloc_start + 3*Mega + 512*kilo + 4*kilo))
  801871:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801874:	89 c2                	mov    %eax,%edx
  801876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801879:	05 00 10 38 00       	add    $0x381000,%eax
  80187e:	39 c2                	cmp    %eax,%edx
  801880:	74 19                	je     80189b <_main+0x79c>
			{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Wrong start address for the allocated space... ");}
  801882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	68 f0 46 80 00       	push   $0x8046f0
  801891:	6a 0c                	push   $0xc
  801893:	e8 dc 04 00 00       	call   801d74 <cprintf_colored>
  801898:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)	eval+=15;
  80189b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80189f:	74 04                	je     8018a5 <_main+0x7a6>
  8018a1:	83 45 f4 0f          	addl   $0xf,-0xc(%ebp)
		is_correct = 1;
  8018a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	cprintf_colored(TEXT_light_green, "%~\ntest Sharing CUSTOM FIT allocation (3) completed. Eval = %d%%\n\n", eval);
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	68 f8 47 80 00       	push   $0x8047f8
  8018b7:	6a 0a                	push   $0xa
  8018b9:	e8 b6 04 00 00       	call   801d74 <cprintf_colored>
  8018be:	83 c4 10             	add    $0x10,%esp

	return;
  8018c1:	90                   	nop
}
  8018c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c5:	5b                   	pop    %ebx
  8018c6:	5f                   	pop    %edi
  8018c7:	5d                   	pop    %ebp
  8018c8:	c3                   	ret    

008018c9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	57                   	push   %edi
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8018d2:	e8 f4 17 00 00       	call   8030cb <sys_getenvindex>
  8018d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8018da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8018dd:	89 d0                	mov    %edx,%eax
  8018df:	c1 e0 02             	shl    $0x2,%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	c1 e0 03             	shl    $0x3,%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8018f0:	01 d0                	add    %edx,%eax
  8018f2:	c1 e0 02             	shl    $0x2,%eax
  8018f5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018fa:	a3 00 62 80 00       	mov    %eax,0x806200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8018ff:	a1 00 62 80 00       	mov    0x806200,%eax
  801904:	8a 40 20             	mov    0x20(%eax),%al
  801907:	84 c0                	test   %al,%al
  801909:	74 0d                	je     801918 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80190b:	a1 00 62 80 00       	mov    0x806200,%eax
  801910:	83 c0 20             	add    $0x20,%eax
  801913:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801918:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80191c:	7e 0a                	jle    801928 <libmain+0x5f>
		binaryname = argv[0];
  80191e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801921:	8b 00                	mov    (%eax),%eax
  801923:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801928:	83 ec 08             	sub    $0x8,%esp
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	e8 c9 f7 ff ff       	call   8010ff <_main>
  801936:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801939:	a1 00 60 80 00       	mov    0x806000,%eax
  80193e:	85 c0                	test   %eax,%eax
  801940:	0f 84 01 01 00 00    	je     801a47 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801946:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80194c:	bb 34 49 80 00       	mov    $0x804934,%ebx
  801951:	ba 0e 00 00 00       	mov    $0xe,%edx
  801956:	89 c7                	mov    %eax,%edi
  801958:	89 de                	mov    %ebx,%esi
  80195a:	89 d1                	mov    %edx,%ecx
  80195c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80195e:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801961:	b9 56 00 00 00       	mov    $0x56,%ecx
  801966:	b0 00                	mov    $0x0,%al
  801968:	89 d7                	mov    %edx,%edi
  80196a:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80196c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801973:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801976:	83 ec 08             	sub    $0x8,%esp
  801979:	50                   	push   %eax
  80197a:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801980:	50                   	push   %eax
  801981:	e8 7b 19 00 00       	call   803301 <sys_utilities>
  801986:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801989:	e8 c4 14 00 00       	call   802e52 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	68 54 48 80 00       	push   $0x804854
  801996:	e8 ac 03 00 00       	call   801d47 <cprintf>
  80199b:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80199e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a1:	85 c0                	test   %eax,%eax
  8019a3:	74 18                	je     8019bd <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8019a5:	e8 75 19 00 00       	call   80331f <sys_get_optimal_num_faults>
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	50                   	push   %eax
  8019ae:	68 7c 48 80 00       	push   $0x80487c
  8019b3:	e8 8f 03 00 00       	call   801d47 <cprintf>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	eb 59                	jmp    801a16 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8019bd:	a1 00 62 80 00       	mov    0x806200,%eax
  8019c2:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8019c8:	a1 00 62 80 00       	mov    0x806200,%eax
  8019cd:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	68 a0 48 80 00       	push   $0x8048a0
  8019dd:	e8 65 03 00 00       	call   801d47 <cprintf>
  8019e2:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8019e5:	a1 00 62 80 00       	mov    0x806200,%eax
  8019ea:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8019f0:	a1 00 62 80 00       	mov    0x806200,%eax
  8019f5:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8019fb:	a1 00 62 80 00       	mov    0x806200,%eax
  801a00:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  801a06:	51                   	push   %ecx
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	68 c8 48 80 00       	push   $0x8048c8
  801a0e:	e8 34 03 00 00       	call   801d47 <cprintf>
  801a13:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801a16:	a1 00 62 80 00       	mov    0x806200,%eax
  801a1b:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801a21:	83 ec 08             	sub    $0x8,%esp
  801a24:	50                   	push   %eax
  801a25:	68 20 49 80 00       	push   $0x804920
  801a2a:	e8 18 03 00 00       	call   801d47 <cprintf>
  801a2f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	68 54 48 80 00       	push   $0x804854
  801a3a:	e8 08 03 00 00       	call   801d47 <cprintf>
  801a3f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801a42:	e8 25 14 00 00       	call   802e6c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801a47:	e8 1f 00 00 00       	call   801a6b <exit>
}
  801a4c:	90                   	nop
  801a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a50:	5b                   	pop    %ebx
  801a51:	5e                   	pop    %esi
  801a52:	5f                   	pop    %edi
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    

00801a55 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801a5b:	83 ec 0c             	sub    $0xc,%esp
  801a5e:	6a 00                	push   $0x0
  801a60:	e8 32 16 00 00       	call   803097 <sys_destroy_env>
  801a65:	83 c4 10             	add    $0x10,%esp
}
  801a68:	90                   	nop
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <exit>:

void
exit(void)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801a71:	e8 87 16 00 00       	call   8030fd <sys_exit_env>
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a7f:	8d 45 10             	lea    0x10(%ebp),%eax
  801a82:	83 c0 04             	add    $0x4,%eax
  801a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a88:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	74 16                	je     801aa7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a91:	a1 f8 e2 81 00       	mov    0x81e2f8,%eax
  801a96:	83 ec 08             	sub    $0x8,%esp
  801a99:	50                   	push   %eax
  801a9a:	68 98 49 80 00       	push   $0x804998
  801a9f:	e8 a3 02 00 00       	call   801d47 <cprintf>
  801aa4:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801aa7:	a1 04 60 80 00       	mov    0x806004,%eax
  801aac:	83 ec 0c             	sub    $0xc,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	68 a0 49 80 00       	push   $0x8049a0
  801abb:	6a 74                	push   $0x74
  801abd:	e8 b2 02 00 00       	call   801d74 <cprintf_colored>
  801ac2:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac8:	83 ec 08             	sub    $0x8,%esp
  801acb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ace:	50                   	push   %eax
  801acf:	e8 04 02 00 00       	call   801cd8 <vcprintf>
  801ad4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801ad7:	83 ec 08             	sub    $0x8,%esp
  801ada:	6a 00                	push   $0x0
  801adc:	68 c8 49 80 00       	push   $0x8049c8
  801ae1:	e8 f2 01 00 00       	call   801cd8 <vcprintf>
  801ae6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801ae9:	e8 7d ff ff ff       	call   801a6b <exit>

	// should not return here
	while (1) ;
  801aee:	eb fe                	jmp    801aee <_panic+0x75>

00801af0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801af6:	a1 00 62 80 00       	mov    0x806200,%eax
  801afb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b04:	39 c2                	cmp    %eax,%edx
  801b06:	74 14                	je     801b1c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	68 cc 49 80 00       	push   $0x8049cc
  801b10:	6a 26                	push   $0x26
  801b12:	68 18 4a 80 00       	push   $0x804a18
  801b17:	e8 5d ff ff ff       	call   801a79 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b2a:	e9 c5 00 00 00       	jmp    801bf4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b32:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	8b 00                	mov    (%eax),%eax
  801b40:	85 c0                	test   %eax,%eax
  801b42:	75 08                	jne    801b4c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b44:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b47:	e9 a5 00 00 00       	jmp    801bf1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b4c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b53:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801b5a:	eb 69                	jmp    801bc5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b5c:	a1 00 62 80 00       	mov    0x806200,%eax
  801b61:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b6a:	89 d0                	mov    %edx,%eax
  801b6c:	01 c0                	add    %eax,%eax
  801b6e:	01 d0                	add    %edx,%eax
  801b70:	c1 e0 03             	shl    $0x3,%eax
  801b73:	01 c8                	add    %ecx,%eax
  801b75:	8a 40 04             	mov    0x4(%eax),%al
  801b78:	84 c0                	test   %al,%al
  801b7a:	75 46                	jne    801bc2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b7c:	a1 00 62 80 00       	mov    0x806200,%eax
  801b81:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b8a:	89 d0                	mov    %edx,%eax
  801b8c:	01 c0                	add    %eax,%eax
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	c1 e0 03             	shl    $0x3,%eax
  801b93:	01 c8                	add    %ecx,%eax
  801b95:	8b 00                	mov    (%eax),%eax
  801b97:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	01 c8                	add    %ecx,%eax
  801bb3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bb5:	39 c2                	cmp    %eax,%edx
  801bb7:	75 09                	jne    801bc2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801bb9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801bc0:	eb 15                	jmp    801bd7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bc2:	ff 45 e8             	incl   -0x18(%ebp)
  801bc5:	a1 00 62 80 00       	mov    0x806200,%eax
  801bca:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd3:	39 c2                	cmp    %eax,%edx
  801bd5:	77 85                	ja     801b5c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801bd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bdb:	75 14                	jne    801bf1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	68 24 4a 80 00       	push   $0x804a24
  801be5:	6a 3a                	push   $0x3a
  801be7:	68 18 4a 80 00       	push   $0x804a18
  801bec:	e8 88 fe ff ff       	call   801a79 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801bf1:	ff 45 f0             	incl   -0x10(%ebp)
  801bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801bfa:	0f 8c 2f ff ff ff    	jl     801b2f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c0e:	eb 26                	jmp    801c36 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c10:	a1 00 62 80 00       	mov    0x806200,%eax
  801c15:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  801c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c1e:	89 d0                	mov    %edx,%eax
  801c20:	01 c0                	add    %eax,%eax
  801c22:	01 d0                	add    %edx,%eax
  801c24:	c1 e0 03             	shl    $0x3,%eax
  801c27:	01 c8                	add    %ecx,%eax
  801c29:	8a 40 04             	mov    0x4(%eax),%al
  801c2c:	3c 01                	cmp    $0x1,%al
  801c2e:	75 03                	jne    801c33 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c30:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c33:	ff 45 e0             	incl   -0x20(%ebp)
  801c36:	a1 00 62 80 00       	mov    0x806200,%eax
  801c3b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c44:	39 c2                	cmp    %eax,%edx
  801c46:	77 c8                	ja     801c10 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c4e:	74 14                	je     801c64 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	68 78 4a 80 00       	push   $0x804a78
  801c58:	6a 44                	push   $0x44
  801c5a:	68 18 4a 80 00       	push   $0x804a18
  801c5f:	e8 15 fe ff ff       	call   801a79 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	8b 00                	mov    (%eax),%eax
  801c73:	8d 48 01             	lea    0x1(%eax),%ecx
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	89 0a                	mov    %ecx,(%edx)
  801c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7e:	88 d1                	mov    %dl,%cl
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8a:	8b 00                	mov    (%eax),%eax
  801c8c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c91:	75 30                	jne    801cc3 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801c93:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801c99:	a0 24 62 80 00       	mov    0x806224,%al
  801c9e:	0f b6 c0             	movzbl %al,%eax
  801ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca4:	8b 09                	mov    (%ecx),%ecx
  801ca6:	89 cb                	mov    %ecx,%ebx
  801ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cab:	83 c1 08             	add    $0x8,%ecx
  801cae:	52                   	push   %edx
  801caf:	50                   	push   %eax
  801cb0:	53                   	push   %ebx
  801cb1:	51                   	push   %ecx
  801cb2:	e8 57 11 00 00       	call   802e0e <sys_cputs>
  801cb7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc6:	8b 40 04             	mov    0x4(%eax),%eax
  801cc9:	8d 50 01             	lea    0x1(%eax),%edx
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	89 50 04             	mov    %edx,0x4(%eax)
}
  801cd2:	90                   	nop
  801cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801ce1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ce8:	00 00 00 
	b.cnt = 0;
  801ceb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801cf2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d01:	50                   	push   %eax
  801d02:	68 67 1c 80 00       	push   $0x801c67
  801d07:	e8 5a 02 00 00       	call   801f66 <vprintfmt>
  801d0c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801d0f:	8b 15 fc e2 81 00    	mov    0x81e2fc,%edx
  801d15:	a0 24 62 80 00       	mov    0x806224,%al
  801d1a:	0f b6 c0             	movzbl %al,%eax
  801d1d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	51                   	push   %ecx
  801d26:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d2c:	83 c0 08             	add    $0x8,%eax
  801d2f:	50                   	push   %eax
  801d30:	e8 d9 10 00 00       	call   802e0e <sys_cputs>
  801d35:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801d38:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
	return b.cnt;
  801d3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801d4d:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	va_start(ap, fmt);
  801d54:	8d 45 0c             	lea    0xc(%ebp),%eax
  801d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	ff 75 f4             	pushl  -0xc(%ebp)
  801d63:	50                   	push   %eax
  801d64:	e8 6f ff ff ff       	call   801cd8 <vcprintf>
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801d7a:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	c1 e0 08             	shl    $0x8,%eax
  801d87:	a3 fc e2 81 00       	mov    %eax,0x81e2fc
	va_start(ap, fmt);
  801d8c:	8d 45 0c             	lea    0xc(%ebp),%eax
  801d8f:	83 c0 04             	add    $0x4,%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	83 ec 08             	sub    $0x8,%esp
  801d9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9e:	50                   	push   %eax
  801d9f:	e8 34 ff ff ff       	call   801cd8 <vcprintf>
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801daa:	c7 05 fc e2 81 00 00 	movl   $0x700,0x81e2fc
  801db1:	07 00 00 

	return cnt;
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801dbf:	e8 8e 10 00 00       	call   802e52 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801dc4:	8d 45 0c             	lea    0xc(%ebp),%eax
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	83 ec 08             	sub    $0x8,%esp
  801dd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd3:	50                   	push   %eax
  801dd4:	e8 ff fe ff ff       	call   801cd8 <vcprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801ddf:	e8 88 10 00 00       	call   802e6c <sys_unlock_cons>
	return cnt;
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	53                   	push   %ebx
  801ded:	83 ec 14             	sub    $0x14,%esp
  801df0:	8b 45 10             	mov    0x10(%ebp),%eax
  801df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801df6:	8b 45 14             	mov    0x14(%ebp),%eax
  801df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801dfc:	8b 45 18             	mov    0x18(%ebp),%eax
  801dff:	ba 00 00 00 00       	mov    $0x0,%edx
  801e04:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e07:	77 55                	ja     801e5e <printnum+0x75>
  801e09:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801e0c:	72 05                	jb     801e13 <printnum+0x2a>
  801e0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e11:	77 4b                	ja     801e5e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e13:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801e16:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801e19:	8b 45 18             	mov    0x18(%ebp),%eax
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	ff 75 f4             	pushl  -0xc(%ebp)
  801e26:	ff 75 f0             	pushl  -0x10(%ebp)
  801e29:	e8 06 20 00 00       	call   803e34 <__udivdi3>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	ff 75 20             	pushl  0x20(%ebp)
  801e37:	53                   	push   %ebx
  801e38:	ff 75 18             	pushl  0x18(%ebp)
  801e3b:	52                   	push   %edx
  801e3c:	50                   	push   %eax
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	ff 75 08             	pushl  0x8(%ebp)
  801e43:	e8 a1 ff ff ff       	call   801de9 <printnum>
  801e48:	83 c4 20             	add    $0x20,%esp
  801e4b:	eb 1a                	jmp    801e67 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801e4d:	83 ec 08             	sub    $0x8,%esp
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 20             	pushl  0x20(%ebp)
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	ff d0                	call   *%eax
  801e5b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e5e:	ff 4d 1c             	decl   0x1c(%ebp)
  801e61:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801e65:	7f e6                	jg     801e4d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801e67:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801e6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e75:	53                   	push   %ebx
  801e76:	51                   	push   %ecx
  801e77:	52                   	push   %edx
  801e78:	50                   	push   %eax
  801e79:	e8 c6 20 00 00       	call   803f44 <__umoddi3>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	05 f4 4c 80 00       	add    $0x804cf4,%eax
  801e86:	8a 00                	mov    (%eax),%al
  801e88:	0f be c0             	movsbl %al,%eax
  801e8b:	83 ec 08             	sub    $0x8,%esp
  801e8e:	ff 75 0c             	pushl  0xc(%ebp)
  801e91:	50                   	push   %eax
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	ff d0                	call   *%eax
  801e97:	83 c4 10             	add    $0x10,%esp
}
  801e9a:	90                   	nop
  801e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ea3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ea7:	7e 1c                	jle    801ec5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 00                	mov    (%eax),%eax
  801eae:	8d 50 08             	lea    0x8(%eax),%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 10                	mov    %edx,(%eax)
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	83 e8 08             	sub    $0x8,%eax
  801ebe:	8b 50 04             	mov    0x4(%eax),%edx
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	eb 40                	jmp    801f05 <getuint+0x65>
	else if (lflag)
  801ec5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ec9:	74 1e                	je     801ee9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8b 00                	mov    (%eax),%eax
  801ed0:	8d 50 04             	lea    0x4(%eax),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	89 10                	mov    %edx,(%eax)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	83 e8 04             	sub    $0x4,%eax
  801ee0:	8b 00                	mov    (%eax),%eax
  801ee2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee7:	eb 1c                	jmp    801f05 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	8d 50 04             	lea    0x4(%eax),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	89 10                	mov    %edx,(%eax)
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	8b 00                	mov    (%eax),%eax
  801efb:	83 e8 04             	sub    $0x4,%eax
  801efe:	8b 00                	mov    (%eax),%eax
  801f00:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    

00801f07 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801f0a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801f0e:	7e 1c                	jle    801f2c <getint+0x25>
		return va_arg(*ap, long long);
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	8b 00                	mov    (%eax),%eax
  801f15:	8d 50 08             	lea    0x8(%eax),%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	89 10                	mov    %edx,(%eax)
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	8b 00                	mov    (%eax),%eax
  801f22:	83 e8 08             	sub    $0x8,%eax
  801f25:	8b 50 04             	mov    0x4(%eax),%edx
  801f28:	8b 00                	mov    (%eax),%eax
  801f2a:	eb 38                	jmp    801f64 <getint+0x5d>
	else if (lflag)
  801f2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f30:	74 1a                	je     801f4c <getint+0x45>
		return va_arg(*ap, long);
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	8b 00                	mov    (%eax),%eax
  801f37:	8d 50 04             	lea    0x4(%eax),%edx
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	89 10                	mov    %edx,(%eax)
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	83 e8 04             	sub    $0x4,%eax
  801f47:	8b 00                	mov    (%eax),%eax
  801f49:	99                   	cltd   
  801f4a:	eb 18                	jmp    801f64 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	8d 50 04             	lea    0x4(%eax),%edx
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	89 10                	mov    %edx,(%eax)
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8b 00                	mov    (%eax),%eax
  801f5e:	83 e8 04             	sub    $0x4,%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	99                   	cltd   
}
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	56                   	push   %esi
  801f6a:	53                   	push   %ebx
  801f6b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f6e:	eb 17                	jmp    801f87 <vprintfmt+0x21>
			if (ch == '\0')
  801f70:	85 db                	test   %ebx,%ebx
  801f72:	0f 84 c1 03 00 00    	je     802339 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801f78:	83 ec 08             	sub    $0x8,%esp
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	53                   	push   %ebx
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	ff d0                	call   *%eax
  801f84:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f87:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8a:	8d 50 01             	lea    0x1(%eax),%edx
  801f8d:	89 55 10             	mov    %edx,0x10(%ebp)
  801f90:	8a 00                	mov    (%eax),%al
  801f92:	0f b6 d8             	movzbl %al,%ebx
  801f95:	83 fb 25             	cmp    $0x25,%ebx
  801f98:	75 d6                	jne    801f70 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801f9a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801f9e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801fa5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801fac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801fb3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801fba:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbd:	8d 50 01             	lea    0x1(%eax),%edx
  801fc0:	89 55 10             	mov    %edx,0x10(%ebp)
  801fc3:	8a 00                	mov    (%eax),%al
  801fc5:	0f b6 d8             	movzbl %al,%ebx
  801fc8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801fcb:	83 f8 5b             	cmp    $0x5b,%eax
  801fce:	0f 87 3d 03 00 00    	ja     802311 <vprintfmt+0x3ab>
  801fd4:	8b 04 85 18 4d 80 00 	mov    0x804d18(,%eax,4),%eax
  801fdb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801fdd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801fe1:	eb d7                	jmp    801fba <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801fe3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801fe7:	eb d1                	jmp    801fba <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801fe9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ff3:	89 d0                	mov    %edx,%eax
  801ff5:	c1 e0 02             	shl    $0x2,%eax
  801ff8:	01 d0                	add    %edx,%eax
  801ffa:	01 c0                	add    %eax,%eax
  801ffc:	01 d8                	add    %ebx,%eax
  801ffe:	83 e8 30             	sub    $0x30,%eax
  802001:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  802004:	8b 45 10             	mov    0x10(%ebp),%eax
  802007:	8a 00                	mov    (%eax),%al
  802009:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80200c:	83 fb 2f             	cmp    $0x2f,%ebx
  80200f:	7e 3e                	jle    80204f <vprintfmt+0xe9>
  802011:	83 fb 39             	cmp    $0x39,%ebx
  802014:	7f 39                	jg     80204f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802016:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802019:	eb d5                	jmp    801ff0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80201b:	8b 45 14             	mov    0x14(%ebp),%eax
  80201e:	83 c0 04             	add    $0x4,%eax
  802021:	89 45 14             	mov    %eax,0x14(%ebp)
  802024:	8b 45 14             	mov    0x14(%ebp),%eax
  802027:	83 e8 04             	sub    $0x4,%eax
  80202a:	8b 00                	mov    (%eax),%eax
  80202c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80202f:	eb 1f                	jmp    802050 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  802031:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802035:	79 83                	jns    801fba <vprintfmt+0x54>
				width = 0;
  802037:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80203e:	e9 77 ff ff ff       	jmp    801fba <vprintfmt+0x54>

		case '#':
			altflag = 1;
  802043:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80204a:	e9 6b ff ff ff       	jmp    801fba <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80204f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802054:	0f 89 60 ff ff ff    	jns    801fba <vprintfmt+0x54>
				width = precision, precision = -1;
  80205a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802060:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  802067:	e9 4e ff ff ff       	jmp    801fba <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80206c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80206f:	e9 46 ff ff ff       	jmp    801fba <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802074:	8b 45 14             	mov    0x14(%ebp),%eax
  802077:	83 c0 04             	add    $0x4,%eax
  80207a:	89 45 14             	mov    %eax,0x14(%ebp)
  80207d:	8b 45 14             	mov    0x14(%ebp),%eax
  802080:	83 e8 04             	sub    $0x4,%eax
  802083:	8b 00                	mov    (%eax),%eax
  802085:	83 ec 08             	sub    $0x8,%esp
  802088:	ff 75 0c             	pushl  0xc(%ebp)
  80208b:	50                   	push   %eax
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	ff d0                	call   *%eax
  802091:	83 c4 10             	add    $0x10,%esp
			break;
  802094:	e9 9b 02 00 00       	jmp    802334 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  802099:	8b 45 14             	mov    0x14(%ebp),%eax
  80209c:	83 c0 04             	add    $0x4,%eax
  80209f:	89 45 14             	mov    %eax,0x14(%ebp)
  8020a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a5:	83 e8 04             	sub    $0x4,%eax
  8020a8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8020aa:	85 db                	test   %ebx,%ebx
  8020ac:	79 02                	jns    8020b0 <vprintfmt+0x14a>
				err = -err;
  8020ae:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8020b0:	83 fb 64             	cmp    $0x64,%ebx
  8020b3:	7f 0b                	jg     8020c0 <vprintfmt+0x15a>
  8020b5:	8b 34 9d 60 4b 80 00 	mov    0x804b60(,%ebx,4),%esi
  8020bc:	85 f6                	test   %esi,%esi
  8020be:	75 19                	jne    8020d9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8020c0:	53                   	push   %ebx
  8020c1:	68 05 4d 80 00       	push   $0x804d05
  8020c6:	ff 75 0c             	pushl  0xc(%ebp)
  8020c9:	ff 75 08             	pushl  0x8(%ebp)
  8020cc:	e8 70 02 00 00       	call   802341 <printfmt>
  8020d1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8020d4:	e9 5b 02 00 00       	jmp    802334 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8020d9:	56                   	push   %esi
  8020da:	68 0e 4d 80 00       	push   $0x804d0e
  8020df:	ff 75 0c             	pushl  0xc(%ebp)
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	e8 57 02 00 00       	call   802341 <printfmt>
  8020ea:	83 c4 10             	add    $0x10,%esp
			break;
  8020ed:	e9 42 02 00 00       	jmp    802334 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8020f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f5:	83 c0 04             	add    $0x4,%eax
  8020f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8020fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8020fe:	83 e8 04             	sub    $0x4,%eax
  802101:	8b 30                	mov    (%eax),%esi
  802103:	85 f6                	test   %esi,%esi
  802105:	75 05                	jne    80210c <vprintfmt+0x1a6>
				p = "(null)";
  802107:	be 11 4d 80 00       	mov    $0x804d11,%esi
			if (width > 0 && padc != '-')
  80210c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802110:	7e 6d                	jle    80217f <vprintfmt+0x219>
  802112:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  802116:	74 67                	je     80217f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  802118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211b:	83 ec 08             	sub    $0x8,%esp
  80211e:	50                   	push   %eax
  80211f:	56                   	push   %esi
  802120:	e8 1e 03 00 00       	call   802443 <strnlen>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80212b:	eb 16                	jmp    802143 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80212d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  802131:	83 ec 08             	sub    $0x8,%esp
  802134:	ff 75 0c             	pushl  0xc(%ebp)
  802137:	50                   	push   %eax
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	ff d0                	call   *%eax
  80213d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802140:	ff 4d e4             	decl   -0x1c(%ebp)
  802143:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802147:	7f e4                	jg     80212d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802149:	eb 34                	jmp    80217f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80214b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80214f:	74 1c                	je     80216d <vprintfmt+0x207>
  802151:	83 fb 1f             	cmp    $0x1f,%ebx
  802154:	7e 05                	jle    80215b <vprintfmt+0x1f5>
  802156:	83 fb 7e             	cmp    $0x7e,%ebx
  802159:	7e 12                	jle    80216d <vprintfmt+0x207>
					putch('?', putdat);
  80215b:	83 ec 08             	sub    $0x8,%esp
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	6a 3f                	push   $0x3f
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	ff d0                	call   *%eax
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	eb 0f                	jmp    80217c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80216d:	83 ec 08             	sub    $0x8,%esp
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	53                   	push   %ebx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	ff d0                	call   *%eax
  802179:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80217c:	ff 4d e4             	decl   -0x1c(%ebp)
  80217f:	89 f0                	mov    %esi,%eax
  802181:	8d 70 01             	lea    0x1(%eax),%esi
  802184:	8a 00                	mov    (%eax),%al
  802186:	0f be d8             	movsbl %al,%ebx
  802189:	85 db                	test   %ebx,%ebx
  80218b:	74 24                	je     8021b1 <vprintfmt+0x24b>
  80218d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802191:	78 b8                	js     80214b <vprintfmt+0x1e5>
  802193:	ff 4d e0             	decl   -0x20(%ebp)
  802196:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80219a:	79 af                	jns    80214b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80219c:	eb 13                	jmp    8021b1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80219e:	83 ec 08             	sub    $0x8,%esp
  8021a1:	ff 75 0c             	pushl  0xc(%ebp)
  8021a4:	6a 20                	push   $0x20
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	ff d0                	call   *%eax
  8021ab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021ae:	ff 4d e4             	decl   -0x1c(%ebp)
  8021b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021b5:	7f e7                	jg     80219e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8021b7:	e9 78 01 00 00       	jmp    802334 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8021bc:	83 ec 08             	sub    $0x8,%esp
  8021bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8021c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8021c5:	50                   	push   %eax
  8021c6:	e8 3c fd ff ff       	call   801f07 <getint>
  8021cb:	83 c4 10             	add    $0x10,%esp
  8021ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021da:	85 d2                	test   %edx,%edx
  8021dc:	79 23                	jns    802201 <vprintfmt+0x29b>
				putch('-', putdat);
  8021de:	83 ec 08             	sub    $0x8,%esp
  8021e1:	ff 75 0c             	pushl  0xc(%ebp)
  8021e4:	6a 2d                	push   $0x2d
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	ff d0                	call   *%eax
  8021eb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	f7 d8                	neg    %eax
  8021f6:	83 d2 00             	adc    $0x0,%edx
  8021f9:	f7 da                	neg    %edx
  8021fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802201:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  802208:	e9 bc 00 00 00       	jmp    8022c9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80220d:	83 ec 08             	sub    $0x8,%esp
  802210:	ff 75 e8             	pushl  -0x18(%ebp)
  802213:	8d 45 14             	lea    0x14(%ebp),%eax
  802216:	50                   	push   %eax
  802217:	e8 84 fc ff ff       	call   801ea0 <getuint>
  80221c:	83 c4 10             	add    $0x10,%esp
  80221f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802222:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802225:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80222c:	e9 98 00 00 00       	jmp    8022c9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802231:	83 ec 08             	sub    $0x8,%esp
  802234:	ff 75 0c             	pushl  0xc(%ebp)
  802237:	6a 58                	push   $0x58
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	ff d0                	call   *%eax
  80223e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802241:	83 ec 08             	sub    $0x8,%esp
  802244:	ff 75 0c             	pushl  0xc(%ebp)
  802247:	6a 58                	push   $0x58
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	ff d0                	call   *%eax
  80224e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802251:	83 ec 08             	sub    $0x8,%esp
  802254:	ff 75 0c             	pushl  0xc(%ebp)
  802257:	6a 58                	push   $0x58
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	ff d0                	call   *%eax
  80225e:	83 c4 10             	add    $0x10,%esp
			break;
  802261:	e9 ce 00 00 00       	jmp    802334 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  802266:	83 ec 08             	sub    $0x8,%esp
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	6a 30                	push   $0x30
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	ff d0                	call   *%eax
  802273:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  802276:	83 ec 08             	sub    $0x8,%esp
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	6a 78                	push   $0x78
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	ff d0                	call   *%eax
  802283:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  802286:	8b 45 14             	mov    0x14(%ebp),%eax
  802289:	83 c0 04             	add    $0x4,%eax
  80228c:	89 45 14             	mov    %eax,0x14(%ebp)
  80228f:	8b 45 14             	mov    0x14(%ebp),%eax
  802292:	83 e8 04             	sub    $0x4,%eax
  802295:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  802297:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80229a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8022a1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8022a8:	eb 1f                	jmp    8022c9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022aa:	83 ec 08             	sub    $0x8,%esp
  8022ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8022b0:	8d 45 14             	lea    0x14(%ebp),%eax
  8022b3:	50                   	push   %eax
  8022b4:	e8 e7 fb ff ff       	call   801ea0 <getuint>
  8022b9:	83 c4 10             	add    $0x10,%esp
  8022bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8022bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8022c2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022c9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8022cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d0:	83 ec 04             	sub    $0x4,%esp
  8022d3:	52                   	push   %edx
  8022d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022d7:	50                   	push   %eax
  8022d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022db:	ff 75 f0             	pushl  -0x10(%ebp)
  8022de:	ff 75 0c             	pushl  0xc(%ebp)
  8022e1:	ff 75 08             	pushl  0x8(%ebp)
  8022e4:	e8 00 fb ff ff       	call   801de9 <printnum>
  8022e9:	83 c4 20             	add    $0x20,%esp
			break;
  8022ec:	eb 46                	jmp    802334 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8022ee:	83 ec 08             	sub    $0x8,%esp
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	53                   	push   %ebx
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	ff d0                	call   *%eax
  8022fa:	83 c4 10             	add    $0x10,%esp
			break;
  8022fd:	eb 35                	jmp    802334 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8022ff:	c6 05 24 62 80 00 00 	movb   $0x0,0x806224
			break;
  802306:	eb 2c                	jmp    802334 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802308:	c6 05 24 62 80 00 01 	movb   $0x1,0x806224
			break;
  80230f:	eb 23                	jmp    802334 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802311:	83 ec 08             	sub    $0x8,%esp
  802314:	ff 75 0c             	pushl  0xc(%ebp)
  802317:	6a 25                	push   $0x25
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	ff d0                	call   *%eax
  80231e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802321:	ff 4d 10             	decl   0x10(%ebp)
  802324:	eb 03                	jmp    802329 <vprintfmt+0x3c3>
  802326:	ff 4d 10             	decl   0x10(%ebp)
  802329:	8b 45 10             	mov    0x10(%ebp),%eax
  80232c:	48                   	dec    %eax
  80232d:	8a 00                	mov    (%eax),%al
  80232f:	3c 25                	cmp    $0x25,%al
  802331:	75 f3                	jne    802326 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802333:	90                   	nop
		}
	}
  802334:	e9 35 fc ff ff       	jmp    801f6e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802339:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80233a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    

00802341 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802347:	8d 45 10             	lea    0x10(%ebp),%eax
  80234a:	83 c0 04             	add    $0x4,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802350:	8b 45 10             	mov    0x10(%ebp),%eax
  802353:	ff 75 f4             	pushl  -0xc(%ebp)
  802356:	50                   	push   %eax
  802357:	ff 75 0c             	pushl  0xc(%ebp)
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	e8 04 fc ff ff       	call   801f66 <vprintfmt>
  802362:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802365:	90                   	nop
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80236b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236e:	8b 40 08             	mov    0x8(%eax),%eax
  802371:	8d 50 01             	lea    0x1(%eax),%edx
  802374:	8b 45 0c             	mov    0xc(%ebp),%eax
  802377:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	8b 10                	mov    (%eax),%edx
  80237f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802382:	8b 40 04             	mov    0x4(%eax),%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	73 12                	jae    80239b <sprintputch+0x33>
		*b->buf++ = ch;
  802389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	8d 48 01             	lea    0x1(%eax),%ecx
  802391:	8b 55 0c             	mov    0xc(%ebp),%edx
  802394:	89 0a                	mov    %ecx,(%edx)
  802396:	8b 55 08             	mov    0x8(%ebp),%edx
  802399:	88 10                	mov    %dl,(%eax)
}
  80239b:	90                   	nop
  80239c:	5d                   	pop    %ebp
  80239d:	c3                   	ret    

0080239e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	01 d0                	add    %edx,%eax
  8023b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8023bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c3:	74 06                	je     8023cb <vsnprintf+0x2d>
  8023c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023c9:	7f 07                	jg     8023d2 <vsnprintf+0x34>
		return -E_INVAL;
  8023cb:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d0:	eb 20                	jmp    8023f2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8023d2:	ff 75 14             	pushl  0x14(%ebp)
  8023d5:	ff 75 10             	pushl  0x10(%ebp)
  8023d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8023db:	50                   	push   %eax
  8023dc:	68 68 23 80 00       	push   $0x802368
  8023e1:	e8 80 fb ff ff       	call   801f66 <vprintfmt>
  8023e6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8023e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8023fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8023fd:	83 c0 04             	add    $0x4,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802403:	8b 45 10             	mov    0x10(%ebp),%eax
  802406:	ff 75 f4             	pushl  -0xc(%ebp)
  802409:	50                   	push   %eax
  80240a:	ff 75 0c             	pushl  0xc(%ebp)
  80240d:	ff 75 08             	pushl  0x8(%ebp)
  802410:	e8 89 ff ff ff       	call   80239e <vsnprintf>
  802415:	83 c4 10             	add    $0x10,%esp
  802418:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802426:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80242d:	eb 06                	jmp    802435 <strlen+0x15>
		n++;
  80242f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802432:	ff 45 08             	incl   0x8(%ebp)
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	8a 00                	mov    (%eax),%al
  80243a:	84 c0                	test   %al,%al
  80243c:	75 f1                	jne    80242f <strlen+0xf>
		n++;
	return n;
  80243e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802450:	eb 09                	jmp    80245b <strnlen+0x18>
		n++;
  802452:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802455:	ff 45 08             	incl   0x8(%ebp)
  802458:	ff 4d 0c             	decl   0xc(%ebp)
  80245b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80245f:	74 09                	je     80246a <strnlen+0x27>
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	8a 00                	mov    (%eax),%al
  802466:	84 c0                	test   %al,%al
  802468:	75 e8                	jne    802452 <strnlen+0xf>
		n++;
	return n;
  80246a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80247b:	90                   	nop
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	8d 50 01             	lea    0x1(%eax),%edx
  802482:	89 55 08             	mov    %edx,0x8(%ebp)
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	8d 4a 01             	lea    0x1(%edx),%ecx
  80248b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80248e:	8a 12                	mov    (%edx),%dl
  802490:	88 10                	mov    %dl,(%eax)
  802492:	8a 00                	mov    (%eax),%al
  802494:	84 c0                	test   %al,%al
  802496:	75 e4                	jne    80247c <strcpy+0xd>
		/* do nothing */;
	return ret;
  802498:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8024a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8024a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024b0:	eb 1f                	jmp    8024d1 <strncpy+0x34>
		*dst++ = *src;
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8d 50 01             	lea    0x1(%eax),%edx
  8024b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8024bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024be:	8a 12                	mov    (%edx),%dl
  8024c0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8024c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c5:	8a 00                	mov    (%eax),%al
  8024c7:	84 c0                	test   %al,%al
  8024c9:	74 03                	je     8024ce <strncpy+0x31>
			src++;
  8024cb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8024ce:	ff 45 fc             	incl   -0x4(%ebp)
  8024d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8024d7:	72 d9                	jb     8024b2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8024d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8024ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024ee:	74 30                	je     802520 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8024f0:	eb 16                	jmp    802508 <strlcpy+0x2a>
			*dst++ = *src++;
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8d 50 01             	lea    0x1(%eax),%edx
  8024f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8024fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  802501:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802504:	8a 12                	mov    (%edx),%dl
  802506:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802508:	ff 4d 10             	decl   0x10(%ebp)
  80250b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80250f:	74 09                	je     80251a <strlcpy+0x3c>
  802511:	8b 45 0c             	mov    0xc(%ebp),%eax
  802514:	8a 00                	mov    (%eax),%al
  802516:	84 c0                	test   %al,%al
  802518:	75 d8                	jne    8024f2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802520:	8b 55 08             	mov    0x8(%ebp),%edx
  802523:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802526:	29 c2                	sub    %eax,%edx
  802528:	89 d0                	mov    %edx,%eax
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80252f:	eb 06                	jmp    802537 <strcmp+0xb>
		p++, q++;
  802531:	ff 45 08             	incl   0x8(%ebp)
  802534:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	8a 00                	mov    (%eax),%al
  80253c:	84 c0                	test   %al,%al
  80253e:	74 0e                	je     80254e <strcmp+0x22>
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	8a 10                	mov    (%eax),%dl
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	8a 00                	mov    (%eax),%al
  80254a:	38 c2                	cmp    %al,%dl
  80254c:	74 e3                	je     802531 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	8a 00                	mov    (%eax),%al
  802553:	0f b6 d0             	movzbl %al,%edx
  802556:	8b 45 0c             	mov    0xc(%ebp),%eax
  802559:	8a 00                	mov    (%eax),%al
  80255b:	0f b6 c0             	movzbl %al,%eax
  80255e:	29 c2                	sub    %eax,%edx
  802560:	89 d0                	mov    %edx,%eax
}
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    

00802564 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802567:	eb 09                	jmp    802572 <strncmp+0xe>
		n--, p++, q++;
  802569:	ff 4d 10             	decl   0x10(%ebp)
  80256c:	ff 45 08             	incl   0x8(%ebp)
  80256f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802572:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802576:	74 17                	je     80258f <strncmp+0x2b>
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8a 00                	mov    (%eax),%al
  80257d:	84 c0                	test   %al,%al
  80257f:	74 0e                	je     80258f <strncmp+0x2b>
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	8a 10                	mov    (%eax),%dl
  802586:	8b 45 0c             	mov    0xc(%ebp),%eax
  802589:	8a 00                	mov    (%eax),%al
  80258b:	38 c2                	cmp    %al,%dl
  80258d:	74 da                	je     802569 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80258f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802593:	75 07                	jne    80259c <strncmp+0x38>
		return 0;
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
  80259a:	eb 14                	jmp    8025b0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	8a 00                	mov    (%eax),%al
  8025a1:	0f b6 d0             	movzbl %al,%edx
  8025a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a7:	8a 00                	mov    (%eax),%al
  8025a9:	0f b6 c0             	movzbl %al,%eax
  8025ac:	29 c2                	sub    %eax,%edx
  8025ae:	89 d0                	mov    %edx,%eax
}
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    

008025b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	83 ec 04             	sub    $0x4,%esp
  8025b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8025be:	eb 12                	jmp    8025d2 <strchr+0x20>
		if (*s == c)
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8a 00                	mov    (%eax),%al
  8025c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8025c8:	75 05                	jne    8025cf <strchr+0x1d>
			return (char *) s;
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	eb 11                	jmp    8025e0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8025cf:	ff 45 08             	incl   0x8(%ebp)
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	8a 00                	mov    (%eax),%al
  8025d7:	84 c0                	test   %al,%al
  8025d9:	75 e5                	jne    8025c0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8025ee:	eb 0d                	jmp    8025fd <strfind+0x1b>
		if (*s == c)
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	8a 00                	mov    (%eax),%al
  8025f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8025f8:	74 0e                	je     802608 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8025fa:	ff 45 08             	incl   0x8(%ebp)
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	8a 00                	mov    (%eax),%al
  802602:	84 c0                	test   %al,%al
  802604:	75 ea                	jne    8025f0 <strfind+0xe>
  802606:	eb 01                	jmp    802609 <strfind+0x27>
		if (*s == c)
			break;
  802608:	90                   	nop
	return (char *) s;
  802609:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80261a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80261e:	76 63                	jbe    802683 <memset+0x75>
		uint64 data_block = c;
  802620:	8b 45 0c             	mov    0xc(%ebp),%eax
  802623:	99                   	cltd   
  802624:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802627:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802630:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802634:	c1 e0 08             	shl    $0x8,%eax
  802637:	09 45 f0             	or     %eax,-0x10(%ebp)
  80263a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802643:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802647:	c1 e0 10             	shl    $0x10,%eax
  80264a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80264d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802656:	89 c2                	mov    %eax,%edx
  802658:	b8 00 00 00 00       	mov    $0x0,%eax
  80265d:	09 45 f0             	or     %eax,-0x10(%ebp)
  802660:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802663:	eb 18                	jmp    80267d <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802665:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802668:	8d 41 08             	lea    0x8(%ecx),%eax
  80266b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80266e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802674:	89 01                	mov    %eax,(%ecx)
  802676:	89 51 04             	mov    %edx,0x4(%ecx)
  802679:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80267d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802681:	77 e2                	ja     802665 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802683:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802687:	74 23                	je     8026ac <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  802689:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80268c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80268f:	eb 0e                	jmp    80269f <memset+0x91>
			*p8++ = (uint8)c;
  802691:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802694:	8d 50 01             	lea    0x1(%eax),%edx
  802697:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80269a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80269d:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80269f:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	75 e5                	jne    802691 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8026ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8026b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8026bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8026c3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8026c7:	76 24                	jbe    8026ed <memcpy+0x3c>
		while(n >= 8){
  8026c9:	eb 1c                	jmp    8026e7 <memcpy+0x36>
			*d64 = *s64;
  8026cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026ce:	8b 50 04             	mov    0x4(%eax),%edx
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8026d6:	89 01                	mov    %eax,(%ecx)
  8026d8:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8026db:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8026df:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8026e3:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8026e7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8026eb:	77 de                	ja     8026cb <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8026ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026f1:	74 31                	je     802724 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8026f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8026f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8026ff:	eb 16                	jmp    802717 <memcpy+0x66>
			*d8++ = *s8++;
  802701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802704:	8d 50 01             	lea    0x1(%eax),%edx
  802707:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80270a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270d:	8d 4a 01             	lea    0x1(%edx),%ecx
  802710:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802713:	8a 12                	mov    (%edx),%dl
  802715:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802717:	8b 45 10             	mov    0x10(%ebp),%eax
  80271a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80271d:	89 55 10             	mov    %edx,0x10(%ebp)
  802720:	85 c0                	test   %eax,%eax
  802722:	75 dd                	jne    802701 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80272f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802732:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80273b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802741:	73 50                	jae    802793 <memmove+0x6a>
  802743:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802746:	8b 45 10             	mov    0x10(%ebp),%eax
  802749:	01 d0                	add    %edx,%eax
  80274b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80274e:	76 43                	jbe    802793 <memmove+0x6a>
		s += n;
  802750:	8b 45 10             	mov    0x10(%ebp),%eax
  802753:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802756:	8b 45 10             	mov    0x10(%ebp),%eax
  802759:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80275c:	eb 10                	jmp    80276e <memmove+0x45>
			*--d = *--s;
  80275e:	ff 4d f8             	decl   -0x8(%ebp)
  802761:	ff 4d fc             	decl   -0x4(%ebp)
  802764:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802767:	8a 10                	mov    (%eax),%dl
  802769:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80276c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80276e:	8b 45 10             	mov    0x10(%ebp),%eax
  802771:	8d 50 ff             	lea    -0x1(%eax),%edx
  802774:	89 55 10             	mov    %edx,0x10(%ebp)
  802777:	85 c0                	test   %eax,%eax
  802779:	75 e3                	jne    80275e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80277b:	eb 23                	jmp    8027a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80277d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802780:	8d 50 01             	lea    0x1(%eax),%edx
  802783:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802786:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802789:	8d 4a 01             	lea    0x1(%edx),%ecx
  80278c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80278f:	8a 12                	mov    (%edx),%dl
  802791:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802793:	8b 45 10             	mov    0x10(%ebp),%eax
  802796:	8d 50 ff             	lea    -0x1(%eax),%edx
  802799:	89 55 10             	mov    %edx,0x10(%ebp)
  80279c:	85 c0                	test   %eax,%eax
  80279e:	75 dd                	jne    80277d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8027b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8027b7:	eb 2a                	jmp    8027e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8027b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027bc:	8a 10                	mov    (%eax),%dl
  8027be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027c1:	8a 00                	mov    (%eax),%al
  8027c3:	38 c2                	cmp    %al,%dl
  8027c5:	74 16                	je     8027dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8027c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ca:	8a 00                	mov    (%eax),%al
  8027cc:	0f b6 d0             	movzbl %al,%edx
  8027cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027d2:	8a 00                	mov    (%eax),%al
  8027d4:	0f b6 c0             	movzbl %al,%eax
  8027d7:	29 c2                	sub    %eax,%edx
  8027d9:	89 d0                	mov    %edx,%eax
  8027db:	eb 18                	jmp    8027f5 <memcmp+0x50>
		s1++, s2++;
  8027dd:	ff 45 fc             	incl   -0x4(%ebp)
  8027e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8027e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8027e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	75 c9                	jne    8027b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8027fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802800:	8b 45 10             	mov    0x10(%ebp),%eax
  802803:	01 d0                	add    %edx,%eax
  802805:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802808:	eb 15                	jmp    80281f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	8a 00                	mov    (%eax),%al
  80280f:	0f b6 d0             	movzbl %al,%edx
  802812:	8b 45 0c             	mov    0xc(%ebp),%eax
  802815:	0f b6 c0             	movzbl %al,%eax
  802818:	39 c2                	cmp    %eax,%edx
  80281a:	74 0d                	je     802829 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80281c:	ff 45 08             	incl   0x8(%ebp)
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802825:	72 e3                	jb     80280a <memfind+0x13>
  802827:	eb 01                	jmp    80282a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802829:	90                   	nop
	return (void *) s;
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80283c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802843:	eb 03                	jmp    802848 <strtol+0x19>
		s++;
  802845:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	8a 00                	mov    (%eax),%al
  80284d:	3c 20                	cmp    $0x20,%al
  80284f:	74 f4                	je     802845 <strtol+0x16>
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	8a 00                	mov    (%eax),%al
  802856:	3c 09                	cmp    $0x9,%al
  802858:	74 eb                	je     802845 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8a 00                	mov    (%eax),%al
  80285f:	3c 2b                	cmp    $0x2b,%al
  802861:	75 05                	jne    802868 <strtol+0x39>
		s++;
  802863:	ff 45 08             	incl   0x8(%ebp)
  802866:	eb 13                	jmp    80287b <strtol+0x4c>
	else if (*s == '-')
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	8a 00                	mov    (%eax),%al
  80286d:	3c 2d                	cmp    $0x2d,%al
  80286f:	75 0a                	jne    80287b <strtol+0x4c>
		s++, neg = 1;
  802871:	ff 45 08             	incl   0x8(%ebp)
  802874:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80287b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80287f:	74 06                	je     802887 <strtol+0x58>
  802881:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802885:	75 20                	jne    8028a7 <strtol+0x78>
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	8a 00                	mov    (%eax),%al
  80288c:	3c 30                	cmp    $0x30,%al
  80288e:	75 17                	jne    8028a7 <strtol+0x78>
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	40                   	inc    %eax
  802894:	8a 00                	mov    (%eax),%al
  802896:	3c 78                	cmp    $0x78,%al
  802898:	75 0d                	jne    8028a7 <strtol+0x78>
		s += 2, base = 16;
  80289a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80289e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8028a5:	eb 28                	jmp    8028cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8028a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028ab:	75 15                	jne    8028c2 <strtol+0x93>
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	8a 00                	mov    (%eax),%al
  8028b2:	3c 30                	cmp    $0x30,%al
  8028b4:	75 0c                	jne    8028c2 <strtol+0x93>
		s++, base = 8;
  8028b6:	ff 45 08             	incl   0x8(%ebp)
  8028b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8028c0:	eb 0d                	jmp    8028cf <strtol+0xa0>
	else if (base == 0)
  8028c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028c6:	75 07                	jne    8028cf <strtol+0xa0>
		base = 10;
  8028c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8a 00                	mov    (%eax),%al
  8028d4:	3c 2f                	cmp    $0x2f,%al
  8028d6:	7e 19                	jle    8028f1 <strtol+0xc2>
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	8a 00                	mov    (%eax),%al
  8028dd:	3c 39                	cmp    $0x39,%al
  8028df:	7f 10                	jg     8028f1 <strtol+0xc2>
			dig = *s - '0';
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	8a 00                	mov    (%eax),%al
  8028e6:	0f be c0             	movsbl %al,%eax
  8028e9:	83 e8 30             	sub    $0x30,%eax
  8028ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ef:	eb 42                	jmp    802933 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8a 00                	mov    (%eax),%al
  8028f6:	3c 60                	cmp    $0x60,%al
  8028f8:	7e 19                	jle    802913 <strtol+0xe4>
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	8a 00                	mov    (%eax),%al
  8028ff:	3c 7a                	cmp    $0x7a,%al
  802901:	7f 10                	jg     802913 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	8a 00                	mov    (%eax),%al
  802908:	0f be c0             	movsbl %al,%eax
  80290b:	83 e8 57             	sub    $0x57,%eax
  80290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802911:	eb 20                	jmp    802933 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	8a 00                	mov    (%eax),%al
  802918:	3c 40                	cmp    $0x40,%al
  80291a:	7e 39                	jle    802955 <strtol+0x126>
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	8a 00                	mov    (%eax),%al
  802921:	3c 5a                	cmp    $0x5a,%al
  802923:	7f 30                	jg     802955 <strtol+0x126>
			dig = *s - 'A' + 10;
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	8a 00                	mov    (%eax),%al
  80292a:	0f be c0             	movsbl %al,%eax
  80292d:	83 e8 37             	sub    $0x37,%eax
  802930:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	3b 45 10             	cmp    0x10(%ebp),%eax
  802939:	7d 19                	jge    802954 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80293b:	ff 45 08             	incl   0x8(%ebp)
  80293e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802941:	0f af 45 10          	imul   0x10(%ebp),%eax
  802945:	89 c2                	mov    %eax,%edx
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	01 d0                	add    %edx,%eax
  80294c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80294f:	e9 7b ff ff ff       	jmp    8028cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802954:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802955:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802959:	74 08                	je     802963 <strtol+0x134>
		*endptr = (char *) s;
  80295b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295e:	8b 55 08             	mov    0x8(%ebp),%edx
  802961:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802963:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802967:	74 07                	je     802970 <strtol+0x141>
  802969:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80296c:	f7 d8                	neg    %eax
  80296e:	eb 03                	jmp    802973 <strtol+0x144>
  802970:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <ltostr>:

void
ltostr(long value, char *str)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80297b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802982:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802989:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298d:	79 13                	jns    8029a2 <ltostr+0x2d>
	{
		neg = 1;
  80298f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802996:	8b 45 0c             	mov    0xc(%ebp),%eax
  802999:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80299c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80299f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8029aa:	99                   	cltd   
  8029ab:	f7 f9                	idiv   %ecx
  8029ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8029b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029b3:	8d 50 01             	lea    0x1(%eax),%edx
  8029b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8029b9:	89 c2                	mov    %eax,%edx
  8029bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029be:	01 d0                	add    %edx,%eax
  8029c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c3:	83 c2 30             	add    $0x30,%edx
  8029c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8029c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8029d0:	f7 e9                	imul   %ecx
  8029d2:	c1 fa 02             	sar    $0x2,%edx
  8029d5:	89 c8                	mov    %ecx,%eax
  8029d7:	c1 f8 1f             	sar    $0x1f,%eax
  8029da:	29 c2                	sub    %eax,%edx
  8029dc:	89 d0                	mov    %edx,%eax
  8029de:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8029e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e5:	75 bb                	jne    8029a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8029e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8029ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029f1:	48                   	dec    %eax
  8029f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8029f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029f9:	74 3d                	je     802a38 <ltostr+0xc3>
		start = 1 ;
  8029fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802a02:	eb 34                	jmp    802a38 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	8a 00                	mov    (%eax),%al
  802a0e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a17:	01 c2                	add    %eax,%edx
  802a19:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a1f:	01 c8                	add    %ecx,%eax
  802a21:	8a 00                	mov    (%eax),%al
  802a23:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2b:	01 c2                	add    %eax,%edx
  802a2d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802a30:	88 02                	mov    %al,(%edx)
		start++ ;
  802a32:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802a35:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a3e:	7c c4                	jl     802a04 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802a40:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a46:	01 d0                	add    %edx,%eax
  802a48:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802a4b:	90                   	nop
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
  802a51:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802a54:	ff 75 08             	pushl  0x8(%ebp)
  802a57:	e8 c4 f9 ff ff       	call   802420 <strlen>
  802a5c:	83 c4 04             	add    $0x4,%esp
  802a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802a62:	ff 75 0c             	pushl  0xc(%ebp)
  802a65:	e8 b6 f9 ff ff       	call   802420 <strlen>
  802a6a:	83 c4 04             	add    $0x4,%esp
  802a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802a70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802a77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802a7e:	eb 17                	jmp    802a97 <strcconcat+0x49>
		final[s] = str1[s] ;
  802a80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a83:	8b 45 10             	mov    0x10(%ebp),%eax
  802a86:	01 c2                	add    %eax,%edx
  802a88:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	01 c8                	add    %ecx,%eax
  802a90:	8a 00                	mov    (%eax),%al
  802a92:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802a94:	ff 45 fc             	incl   -0x4(%ebp)
  802a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a9d:	7c e1                	jl     802a80 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802a9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802aa6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802aad:	eb 1f                	jmp    802ace <strcconcat+0x80>
		final[s++] = str2[i] ;
  802aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab2:	8d 50 01             	lea    0x1(%eax),%edx
  802ab5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802ab8:	89 c2                	mov    %eax,%edx
  802aba:	8b 45 10             	mov    0x10(%ebp),%eax
  802abd:	01 c2                	add    %eax,%edx
  802abf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac5:	01 c8                	add    %ecx,%eax
  802ac7:	8a 00                	mov    (%eax),%al
  802ac9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802acb:	ff 45 f8             	incl   -0x8(%ebp)
  802ace:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ad4:	7c d9                	jl     802aaf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802ad6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  802adc:	01 d0                	add    %edx,%eax
  802ade:	c6 00 00             	movb   $0x0,(%eax)
}
  802ae1:	90                   	nop
  802ae2:	c9                   	leave  
  802ae3:	c3                   	ret    

00802ae4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802ae4:	55                   	push   %ebp
  802ae5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  802aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802af0:	8b 45 14             	mov    0x14(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802afc:	8b 45 10             	mov    0x10(%ebp),%eax
  802aff:	01 d0                	add    %edx,%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b07:	eb 0c                	jmp    802b15 <strsplit+0x31>
			*string++ = 0;
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8d 50 01             	lea    0x1(%eax),%edx
  802b0f:	89 55 08             	mov    %edx,0x8(%ebp)
  802b12:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8a 00                	mov    (%eax),%al
  802b1a:	84 c0                	test   %al,%al
  802b1c:	74 18                	je     802b36 <strsplit+0x52>
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8a 00                	mov    (%eax),%al
  802b23:	0f be c0             	movsbl %al,%eax
  802b26:	50                   	push   %eax
  802b27:	ff 75 0c             	pushl  0xc(%ebp)
  802b2a:	e8 83 fa ff ff       	call   8025b2 <strchr>
  802b2f:	83 c4 08             	add    $0x8,%esp
  802b32:	85 c0                	test   %eax,%eax
  802b34:	75 d3                	jne    802b09 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	8a 00                	mov    (%eax),%al
  802b3b:	84 c0                	test   %al,%al
  802b3d:	74 5a                	je     802b99 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	83 f8 0f             	cmp    $0xf,%eax
  802b47:	75 07                	jne    802b50 <strsplit+0x6c>
		{
			return 0;
  802b49:	b8 00 00 00 00       	mov    $0x0,%eax
  802b4e:	eb 66                	jmp    802bb6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802b50:	8b 45 14             	mov    0x14(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	8d 48 01             	lea    0x1(%eax),%ecx
  802b58:	8b 55 14             	mov    0x14(%ebp),%edx
  802b5b:	89 0a                	mov    %ecx,(%edx)
  802b5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802b64:	8b 45 10             	mov    0x10(%ebp),%eax
  802b67:	01 c2                	add    %eax,%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802b6e:	eb 03                	jmp    802b73 <strsplit+0x8f>
			string++;
  802b70:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8a 00                	mov    (%eax),%al
  802b78:	84 c0                	test   %al,%al
  802b7a:	74 8b                	je     802b07 <strsplit+0x23>
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8a 00                	mov    (%eax),%al
  802b81:	0f be c0             	movsbl %al,%eax
  802b84:	50                   	push   %eax
  802b85:	ff 75 0c             	pushl  0xc(%ebp)
  802b88:	e8 25 fa ff ff       	call   8025b2 <strchr>
  802b8d:	83 c4 08             	add    $0x8,%esp
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 dc                	je     802b70 <strsplit+0x8c>
			string++;
	}
  802b94:	e9 6e ff ff ff       	jmp    802b07 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802b99:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ba6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ba9:	01 d0                	add    %edx,%eax
  802bab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802bb1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802bb6:	c9                   	leave  
  802bb7:	c3                   	ret    

00802bb8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802bb8:	55                   	push   %ebp
  802bb9:	89 e5                	mov    %esp,%ebp
  802bbb:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  802bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802bcb:	eb 4a                	jmp    802c17 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	01 c2                	add    %eax,%edx
  802bd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bdb:	01 c8                	add    %ecx,%eax
  802bdd:	8a 00                	mov    (%eax),%al
  802bdf:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  802be1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be7:	01 d0                	add    %edx,%eax
  802be9:	8a 00                	mov    (%eax),%al
  802beb:	3c 40                	cmp    $0x40,%al
  802bed:	7e 25                	jle    802c14 <str2lower+0x5c>
  802bef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	8a 00                	mov    (%eax),%al
  802bf9:	3c 5a                	cmp    $0x5a,%al
  802bfb:	7f 17                	jg     802c14 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802bfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802c08:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0b:	01 ca                	add    %ecx,%edx
  802c0d:	8a 12                	mov    (%edx),%dl
  802c0f:	83 c2 20             	add    $0x20,%edx
  802c12:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802c14:	ff 45 fc             	incl   -0x4(%ebp)
  802c17:	ff 75 0c             	pushl  0xc(%ebp)
  802c1a:	e8 01 f8 ff ff       	call   802420 <strlen>
  802c1f:	83 c4 04             	add    $0x4,%esp
  802c22:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802c25:	7f a6                	jg     802bcd <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802c27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802c2a:	c9                   	leave  
  802c2b:	c3                   	ret    

00802c2c <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
  802c2f:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802c32:	a1 08 60 80 00       	mov    0x806008,%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 42                	je     802c7d <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802c3b:	83 ec 08             	sub    $0x8,%esp
  802c3e:	68 00 00 00 82       	push   $0x82000000
  802c43:	68 00 00 00 80       	push   $0x80000000
  802c48:	e8 00 08 00 00       	call   80344d <initialize_dynamic_allocator>
  802c4d:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802c50:	e8 e7 05 00 00       	call   80323c <sys_get_uheap_strategy>
  802c55:	a3 44 e2 81 00       	mov    %eax,0x81e244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  802c5a:	a1 20 62 80 00       	mov    0x806220,%eax
  802c5f:	05 00 10 00 00       	add    $0x1000,%eax
  802c64:	a3 f0 e2 81 00       	mov    %eax,0x81e2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802c69:	a1 f0 e2 81 00       	mov    0x81e2f0,%eax
  802c6e:	a3 50 e2 81 00       	mov    %eax,0x81e250

		__firstTimeFlag = 0;
  802c73:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  802c7a:	00 00 00 
	}
}
  802c7d:	90                   	nop
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
  802c83:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802c94:	83 ec 08             	sub    $0x8,%esp
  802c97:	68 06 04 00 00       	push   $0x406
  802c9c:	50                   	push   %eax
  802c9d:	e8 e4 01 00 00       	call   802e86 <__sys_allocate_page>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802ca8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cac:	79 14                	jns    802cc2 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 88 4e 80 00       	push   $0x804e88
  802cb6:	6a 1f                	push   $0x1f
  802cb8:	68 c4 4e 80 00       	push   $0x804ec4
  802cbd:	e8 b7 ed ff ff       	call   801a79 <_panic>
	return 0;
  802cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc7:	c9                   	leave  
  802cc8:	c3                   	ret    

00802cc9 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	50                   	push   %eax
  802ce1:	e8 e7 01 00 00       	call   802ecd <__sys_unmap_frame>
  802ce6:	83 c4 10             	add    $0x10,%esp
  802ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf0:	79 14                	jns    802d06 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 d0 4e 80 00       	push   $0x804ed0
  802cfa:	6a 2a                	push   $0x2a
  802cfc:	68 c4 4e 80 00       	push   $0x804ec4
  802d01:	e8 73 ed ff ff       	call   801a79 <_panic>
}
  802d06:	90                   	nop
  802d07:	c9                   	leave  
  802d08:	c3                   	ret    

00802d09 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802d09:	55                   	push   %ebp
  802d0a:	89 e5                	mov    %esp,%ebp
  802d0c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d0f:	e8 18 ff ff ff       	call   802c2c <uheap_init>
	if (size == 0) return NULL ;
  802d14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d18:	75 07                	jne    802d21 <malloc+0x18>
  802d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1f:	eb 14                	jmp    802d35 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  802d21:	83 ec 04             	sub    $0x4,%esp
  802d24:	68 10 4f 80 00       	push   $0x804f10
  802d29:	6a 3e                	push   $0x3e
  802d2b:	68 c4 4e 80 00       	push   $0x804ec4
  802d30:	e8 44 ed ff ff       	call   801a79 <_panic>
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
  802d3a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 38 4f 80 00       	push   $0x804f38
  802d45:	6a 49                	push   $0x49
  802d47:	68 c4 4e 80 00       	push   $0x804ec4
  802d4c:	e8 28 ed ff ff       	call   801a79 <_panic>

00802d51 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
  802d54:	83 ec 18             	sub    $0x18,%esp
  802d57:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d5d:	e8 ca fe ff ff       	call   802c2c <uheap_init>
	if (size == 0) return NULL ;
  802d62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d66:	75 07                	jne    802d6f <smalloc+0x1e>
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	eb 14                	jmp    802d83 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 5c 4f 80 00       	push   $0x804f5c
  802d77:	6a 5a                	push   $0x5a
  802d79:	68 c4 4e 80 00       	push   $0x804ec4
  802d7e:	e8 f6 ec ff ff       	call   801a79 <_panic>
}
  802d83:	c9                   	leave  
  802d84:	c3                   	ret    

00802d85 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d85:	55                   	push   %ebp
  802d86:	89 e5                	mov    %esp,%ebp
  802d88:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802d8b:	e8 9c fe ff ff       	call   802c2c <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  802d90:	83 ec 04             	sub    $0x4,%esp
  802d93:	68 84 4f 80 00       	push   $0x804f84
  802d98:	6a 6a                	push   $0x6a
  802d9a:	68 c4 4e 80 00       	push   $0x804ec4
  802d9f:	e8 d5 ec ff ff       	call   801a79 <_panic>

00802da4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802da4:	55                   	push   %ebp
  802da5:	89 e5                	mov    %esp,%ebp
  802da7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802daa:	e8 7d fe ff ff       	call   802c2c <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  802daf:	83 ec 04             	sub    $0x4,%esp
  802db2:	68 a8 4f 80 00       	push   $0x804fa8
  802db7:	68 88 00 00 00       	push   $0x88
  802dbc:	68 c4 4e 80 00       	push   $0x804ec4
  802dc1:	e8 b3 ec ff ff       	call   801a79 <_panic>

00802dc6 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 d0 4f 80 00       	push   $0x804fd0
  802dd4:	68 9b 00 00 00       	push   $0x9b
  802dd9:	68 c4 4e 80 00       	push   $0x804ec4
  802dde:	e8 96 ec ff ff       	call   801a79 <_panic>

00802de3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802de3:	55                   	push   %ebp
  802de4:	89 e5                	mov    %esp,%ebp
  802de6:	57                   	push   %edi
  802de7:	56                   	push   %esi
  802de8:	53                   	push   %ebx
  802de9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802df5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802df8:	8b 7d 18             	mov    0x18(%ebp),%edi
  802dfb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802dfe:	cd 30                	int    $0x30
  802e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802e06:	83 c4 10             	add    $0x10,%esp
  802e09:	5b                   	pop    %ebx
  802e0a:	5e                   	pop    %esi
  802e0b:	5f                   	pop    %edi
  802e0c:	5d                   	pop    %ebp
  802e0d:	c3                   	ret    

00802e0e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  802e0e:	55                   	push   %ebp
  802e0f:	89 e5                	mov    %esp,%ebp
  802e11:	83 ec 04             	sub    $0x4,%esp
  802e14:	8b 45 10             	mov    0x10(%ebp),%eax
  802e17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  802e1a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e1d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	6a 00                	push   $0x0
  802e26:	51                   	push   %ecx
  802e27:	52                   	push   %edx
  802e28:	ff 75 0c             	pushl  0xc(%ebp)
  802e2b:	50                   	push   %eax
  802e2c:	6a 00                	push   $0x0
  802e2e:	e8 b0 ff ff ff       	call   802de3 <syscall>
  802e33:	83 c4 18             	add    $0x18,%esp
}
  802e36:	90                   	nop
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <sys_cgetc>:

int
sys_cgetc(void)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 02                	push   $0x2
  802e48:	e8 96 ff ff ff       	call   802de3 <syscall>
  802e4d:	83 c4 18             	add    $0x18,%esp
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <sys_lock_cons>:

void sys_lock_cons(void)
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 03                	push   $0x3
  802e61:	e8 7d ff ff ff       	call   802de3 <syscall>
  802e66:	83 c4 18             	add    $0x18,%esp
}
  802e69:	90                   	nop
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

00802e6c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802e6f:	6a 00                	push   $0x0
  802e71:	6a 00                	push   $0x0
  802e73:	6a 00                	push   $0x0
  802e75:	6a 00                	push   $0x0
  802e77:	6a 00                	push   $0x0
  802e79:	6a 04                	push   $0x4
  802e7b:	e8 63 ff ff ff       	call   802de3 <syscall>
  802e80:	83 c4 18             	add    $0x18,%esp
}
  802e83:	90                   	nop
  802e84:	c9                   	leave  
  802e85:	c3                   	ret    

00802e86 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	52                   	push   %edx
  802e96:	50                   	push   %eax
  802e97:	6a 08                	push   $0x8
  802e99:	e8 45 ff ff ff       	call   802de3 <syscall>
  802e9e:	83 c4 18             	add    $0x18,%esp
}
  802ea1:	c9                   	leave  
  802ea2:	c3                   	ret    

00802ea3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ea3:	55                   	push   %ebp
  802ea4:	89 e5                	mov    %esp,%ebp
  802ea6:	56                   	push   %esi
  802ea7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802ea8:	8b 75 18             	mov    0x18(%ebp),%esi
  802eab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	56                   	push   %esi
  802eb8:	53                   	push   %ebx
  802eb9:	51                   	push   %ecx
  802eba:	52                   	push   %edx
  802ebb:	50                   	push   %eax
  802ebc:	6a 09                	push   $0x9
  802ebe:	e8 20 ff ff ff       	call   802de3 <syscall>
  802ec3:	83 c4 18             	add    $0x18,%esp
}
  802ec6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ec9:	5b                   	pop    %ebx
  802eca:	5e                   	pop    %esi
  802ecb:	5d                   	pop    %ebp
  802ecc:	c3                   	ret    

00802ecd <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	ff 75 08             	pushl  0x8(%ebp)
  802edb:	6a 0a                	push   $0xa
  802edd:	e8 01 ff ff ff       	call   802de3 <syscall>
  802ee2:	83 c4 18             	add    $0x18,%esp
}
  802ee5:	c9                   	leave  
  802ee6:	c3                   	ret    

00802ee7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802ee7:	55                   	push   %ebp
  802ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802eea:	6a 00                	push   $0x0
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	ff 75 0c             	pushl  0xc(%ebp)
  802ef3:	ff 75 08             	pushl  0x8(%ebp)
  802ef6:	6a 0b                	push   $0xb
  802ef8:	e8 e6 fe ff ff       	call   802de3 <syscall>
  802efd:	83 c4 18             	add    $0x18,%esp
}
  802f00:	c9                   	leave  
  802f01:	c3                   	ret    

00802f02 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 00                	push   $0x0
  802f0f:	6a 0c                	push   $0xc
  802f11:	e8 cd fe ff ff       	call   802de3 <syscall>
  802f16:	83 c4 18             	add    $0x18,%esp
}
  802f19:	c9                   	leave  
  802f1a:	c3                   	ret    

00802f1b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f1e:	6a 00                	push   $0x0
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	6a 0d                	push   $0xd
  802f2a:	e8 b4 fe ff ff       	call   802de3 <syscall>
  802f2f:	83 c4 18             	add    $0x18,%esp
}
  802f32:	c9                   	leave  
  802f33:	c3                   	ret    

00802f34 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802f37:	6a 00                	push   $0x0
  802f39:	6a 00                	push   $0x0
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 0e                	push   $0xe
  802f43:	e8 9b fe ff ff       	call   802de3 <syscall>
  802f48:	83 c4 18             	add    $0x18,%esp
}
  802f4b:	c9                   	leave  
  802f4c:	c3                   	ret    

00802f4d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802f4d:	55                   	push   %ebp
  802f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 00                	push   $0x0
  802f56:	6a 00                	push   $0x0
  802f58:	6a 00                	push   $0x0
  802f5a:	6a 0f                	push   $0xf
  802f5c:	e8 82 fe ff ff       	call   802de3 <syscall>
  802f61:	83 c4 18             	add    $0x18,%esp
}
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 00                	push   $0x0
  802f71:	ff 75 08             	pushl  0x8(%ebp)
  802f74:	6a 10                	push   $0x10
  802f76:	e8 68 fe ff ff       	call   802de3 <syscall>
  802f7b:	83 c4 18             	add    $0x18,%esp
}
  802f7e:	c9                   	leave  
  802f7f:	c3                   	ret    

00802f80 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802f80:	55                   	push   %ebp
  802f81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 00                	push   $0x0
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 11                	push   $0x11
  802f8f:	e8 4f fe ff ff       	call   802de3 <syscall>
  802f94:	83 c4 18             	add    $0x18,%esp
}
  802f97:	90                   	nop
  802f98:	c9                   	leave  
  802f99:	c3                   	ret    

00802f9a <sys_cputc>:

void
sys_cputc(const char c)
{
  802f9a:	55                   	push   %ebp
  802f9b:	89 e5                	mov    %esp,%ebp
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802fa6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802faa:	6a 00                	push   $0x0
  802fac:	6a 00                	push   $0x0
  802fae:	6a 00                	push   $0x0
  802fb0:	6a 00                	push   $0x0
  802fb2:	50                   	push   %eax
  802fb3:	6a 01                	push   $0x1
  802fb5:	e8 29 fe ff ff       	call   802de3 <syscall>
  802fba:	83 c4 18             	add    $0x18,%esp
}
  802fbd:	90                   	nop
  802fbe:	c9                   	leave  
  802fbf:	c3                   	ret    

00802fc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802fc0:	55                   	push   %ebp
  802fc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802fc3:	6a 00                	push   $0x0
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	6a 00                	push   $0x0
  802fcd:	6a 14                	push   $0x14
  802fcf:	e8 0f fe ff ff       	call   802de3 <syscall>
  802fd4:	83 c4 18             	add    $0x18,%esp
}
  802fd7:	90                   	nop
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    

00802fda <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802fda:	55                   	push   %ebp
  802fdb:	89 e5                	mov    %esp,%ebp
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  802fe3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802fe6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802fe9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	6a 00                	push   $0x0
  802ff2:	51                   	push   %ecx
  802ff3:	52                   	push   %edx
  802ff4:	ff 75 0c             	pushl  0xc(%ebp)
  802ff7:	50                   	push   %eax
  802ff8:	6a 15                	push   $0x15
  802ffa:	e8 e4 fd ff ff       	call   802de3 <syscall>
  802fff:	83 c4 18             	add    $0x18,%esp
}
  803002:	c9                   	leave  
  803003:	c3                   	ret    

00803004 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803004:	55                   	push   %ebp
  803005:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803007:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	6a 00                	push   $0x0
  80300f:	6a 00                	push   $0x0
  803011:	6a 00                	push   $0x0
  803013:	52                   	push   %edx
  803014:	50                   	push   %eax
  803015:	6a 16                	push   $0x16
  803017:	e8 c7 fd ff ff       	call   802de3 <syscall>
  80301c:	83 c4 18             	add    $0x18,%esp
}
  80301f:	c9                   	leave  
  803020:	c3                   	ret    

00803021 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  803024:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	6a 00                	push   $0x0
  80302f:	6a 00                	push   $0x0
  803031:	51                   	push   %ecx
  803032:	52                   	push   %edx
  803033:	50                   	push   %eax
  803034:	6a 17                	push   $0x17
  803036:	e8 a8 fd ff ff       	call   802de3 <syscall>
  80303b:	83 c4 18             	add    $0x18,%esp
}
  80303e:	c9                   	leave  
  80303f:	c3                   	ret    

00803040 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  803040:	55                   	push   %ebp
  803041:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  803043:	8b 55 0c             	mov    0xc(%ebp),%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	6a 00                	push   $0x0
  80304b:	6a 00                	push   $0x0
  80304d:	6a 00                	push   $0x0
  80304f:	52                   	push   %edx
  803050:	50                   	push   %eax
  803051:	6a 18                	push   $0x18
  803053:	e8 8b fd ff ff       	call   802de3 <syscall>
  803058:	83 c4 18             	add    $0x18,%esp
}
  80305b:	c9                   	leave  
  80305c:	c3                   	ret    

0080305d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80305d:	55                   	push   %ebp
  80305e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	6a 00                	push   $0x0
  803065:	ff 75 14             	pushl  0x14(%ebp)
  803068:	ff 75 10             	pushl  0x10(%ebp)
  80306b:	ff 75 0c             	pushl  0xc(%ebp)
  80306e:	50                   	push   %eax
  80306f:	6a 19                	push   $0x19
  803071:	e8 6d fd ff ff       	call   802de3 <syscall>
  803076:	83 c4 18             	add    $0x18,%esp
}
  803079:	c9                   	leave  
  80307a:	c3                   	ret    

0080307b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80307b:	55                   	push   %ebp
  80307c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	6a 00                	push   $0x0
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	6a 00                	push   $0x0
  803089:	50                   	push   %eax
  80308a:	6a 1a                	push   $0x1a
  80308c:	e8 52 fd ff ff       	call   802de3 <syscall>
  803091:	83 c4 18             	add    $0x18,%esp
}
  803094:	90                   	nop
  803095:	c9                   	leave  
  803096:	c3                   	ret    

00803097 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803097:	55                   	push   %ebp
  803098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	6a 00                	push   $0x0
  80309f:	6a 00                	push   $0x0
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	50                   	push   %eax
  8030a6:	6a 1b                	push   $0x1b
  8030a8:	e8 36 fd ff ff       	call   802de3 <syscall>
  8030ad:	83 c4 18             	add    $0x18,%esp
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8030b5:	6a 00                	push   $0x0
  8030b7:	6a 00                	push   $0x0
  8030b9:	6a 00                	push   $0x0
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 05                	push   $0x5
  8030c1:	e8 1d fd ff ff       	call   802de3 <syscall>
  8030c6:	83 c4 18             	add    $0x18,%esp
}
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 00                	push   $0x0
  8030d2:	6a 00                	push   $0x0
  8030d4:	6a 00                	push   $0x0
  8030d6:	6a 00                	push   $0x0
  8030d8:	6a 06                	push   $0x6
  8030da:	e8 04 fd ff ff       	call   802de3 <syscall>
  8030df:	83 c4 18             	add    $0x18,%esp
}
  8030e2:	c9                   	leave  
  8030e3:	c3                   	ret    

008030e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8030e4:	55                   	push   %ebp
  8030e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 00                	push   $0x0
  8030f1:	6a 07                	push   $0x7
  8030f3:	e8 eb fc ff ff       	call   802de3 <syscall>
  8030f8:	83 c4 18             	add    $0x18,%esp
}
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    

008030fd <sys_exit_env>:


void sys_exit_env(void)
{
  8030fd:	55                   	push   %ebp
  8030fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	6a 00                	push   $0x0
  80310a:	6a 1c                	push   $0x1c
  80310c:	e8 d2 fc ff ff       	call   802de3 <syscall>
  803111:	83 c4 18             	add    $0x18,%esp
}
  803114:	90                   	nop
  803115:	c9                   	leave  
  803116:	c3                   	ret    

00803117 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803117:	55                   	push   %ebp
  803118:	89 e5                	mov    %esp,%ebp
  80311a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80311d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803120:	8d 50 04             	lea    0x4(%eax),%edx
  803123:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803126:	6a 00                	push   $0x0
  803128:	6a 00                	push   $0x0
  80312a:	6a 00                	push   $0x0
  80312c:	52                   	push   %edx
  80312d:	50                   	push   %eax
  80312e:	6a 1d                	push   $0x1d
  803130:	e8 ae fc ff ff       	call   802de3 <syscall>
  803135:	83 c4 18             	add    $0x18,%esp
	return result;
  803138:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80313b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80313e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803141:	89 01                	mov    %eax,(%ecx)
  803143:	89 51 04             	mov    %edx,0x4(%ecx)
}
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	c9                   	leave  
  80314a:	c2 04 00             	ret    $0x4

0080314d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  803150:	6a 00                	push   $0x0
  803152:	6a 00                	push   $0x0
  803154:	ff 75 10             	pushl  0x10(%ebp)
  803157:	ff 75 0c             	pushl  0xc(%ebp)
  80315a:	ff 75 08             	pushl  0x8(%ebp)
  80315d:	6a 13                	push   $0x13
  80315f:	e8 7f fc ff ff       	call   802de3 <syscall>
  803164:	83 c4 18             	add    $0x18,%esp
	return ;
  803167:	90                   	nop
}
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <sys_rcr2>:
uint32 sys_rcr2()
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80316d:	6a 00                	push   $0x0
  80316f:	6a 00                	push   $0x0
  803171:	6a 00                	push   $0x0
  803173:	6a 00                	push   $0x0
  803175:	6a 00                	push   $0x0
  803177:	6a 1e                	push   $0x1e
  803179:	e8 65 fc ff ff       	call   802de3 <syscall>
  80317e:	83 c4 18             	add    $0x18,%esp
}
  803181:	c9                   	leave  
  803182:	c3                   	ret    

00803183 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803183:	55                   	push   %ebp
  803184:	89 e5                	mov    %esp,%ebp
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80318f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803193:	6a 00                	push   $0x0
  803195:	6a 00                	push   $0x0
  803197:	6a 00                	push   $0x0
  803199:	6a 00                	push   $0x0
  80319b:	50                   	push   %eax
  80319c:	6a 1f                	push   $0x1f
  80319e:	e8 40 fc ff ff       	call   802de3 <syscall>
  8031a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8031a6:	90                   	nop
}
  8031a7:	c9                   	leave  
  8031a8:	c3                   	ret    

008031a9 <rsttst>:
void rsttst()
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8031ac:	6a 00                	push   $0x0
  8031ae:	6a 00                	push   $0x0
  8031b0:	6a 00                	push   $0x0
  8031b2:	6a 00                	push   $0x0
  8031b4:	6a 00                	push   $0x0
  8031b6:	6a 21                	push   $0x21
  8031b8:	e8 26 fc ff ff       	call   802de3 <syscall>
  8031bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8031c0:	90                   	nop
}
  8031c1:	c9                   	leave  
  8031c2:	c3                   	ret    

008031c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8031c3:	55                   	push   %ebp
  8031c4:	89 e5                	mov    %esp,%ebp
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8031cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8031cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8031d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8031d6:	52                   	push   %edx
  8031d7:	50                   	push   %eax
  8031d8:	ff 75 10             	pushl  0x10(%ebp)
  8031db:	ff 75 0c             	pushl  0xc(%ebp)
  8031de:	ff 75 08             	pushl  0x8(%ebp)
  8031e1:	6a 20                	push   $0x20
  8031e3:	e8 fb fb ff ff       	call   802de3 <syscall>
  8031e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8031eb:	90                   	nop
}
  8031ec:	c9                   	leave  
  8031ed:	c3                   	ret    

008031ee <chktst>:
void chktst(uint32 n)
{
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8031f1:	6a 00                	push   $0x0
  8031f3:	6a 00                	push   $0x0
  8031f5:	6a 00                	push   $0x0
  8031f7:	6a 00                	push   $0x0
  8031f9:	ff 75 08             	pushl  0x8(%ebp)
  8031fc:	6a 22                	push   $0x22
  8031fe:	e8 e0 fb ff ff       	call   802de3 <syscall>
  803203:	83 c4 18             	add    $0x18,%esp
	return ;
  803206:	90                   	nop
}
  803207:	c9                   	leave  
  803208:	c3                   	ret    

00803209 <inctst>:

void inctst()
{
  803209:	55                   	push   %ebp
  80320a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80320c:	6a 00                	push   $0x0
  80320e:	6a 00                	push   $0x0
  803210:	6a 00                	push   $0x0
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 23                	push   $0x23
  803218:	e8 c6 fb ff ff       	call   802de3 <syscall>
  80321d:	83 c4 18             	add    $0x18,%esp
	return ;
  803220:	90                   	nop
}
  803221:	c9                   	leave  
  803222:	c3                   	ret    

00803223 <gettst>:
uint32 gettst()
{
  803223:	55                   	push   %ebp
  803224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 00                	push   $0x0
  80322c:	6a 00                	push   $0x0
  80322e:	6a 00                	push   $0x0
  803230:	6a 24                	push   $0x24
  803232:	e8 ac fb ff ff       	call   802de3 <syscall>
  803237:	83 c4 18             	add    $0x18,%esp
}
  80323a:	c9                   	leave  
  80323b:	c3                   	ret    

0080323c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80323c:	55                   	push   %ebp
  80323d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80323f:	6a 00                	push   $0x0
  803241:	6a 00                	push   $0x0
  803243:	6a 00                	push   $0x0
  803245:	6a 00                	push   $0x0
  803247:	6a 00                	push   $0x0
  803249:	6a 25                	push   $0x25
  80324b:	e8 93 fb ff ff       	call   802de3 <syscall>
  803250:	83 c4 18             	add    $0x18,%esp
  803253:	a3 44 e2 81 00       	mov    %eax,0x81e244
	return uheapPlaceStrategy ;
  803258:	a1 44 e2 81 00       	mov    0x81e244,%eax
}
  80325d:	c9                   	leave  
  80325e:	c3                   	ret    

0080325f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80325f:	55                   	push   %ebp
  803260:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	a3 44 e2 81 00       	mov    %eax,0x81e244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80326a:	6a 00                	push   $0x0
  80326c:	6a 00                	push   $0x0
  80326e:	6a 00                	push   $0x0
  803270:	6a 00                	push   $0x0
  803272:	ff 75 08             	pushl  0x8(%ebp)
  803275:	6a 26                	push   $0x26
  803277:	e8 67 fb ff ff       	call   802de3 <syscall>
  80327c:	83 c4 18             	add    $0x18,%esp
	return ;
  80327f:	90                   	nop
}
  803280:	c9                   	leave  
  803281:	c3                   	ret    

00803282 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803282:	55                   	push   %ebp
  803283:	89 e5                	mov    %esp,%ebp
  803285:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803286:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803289:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80328c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	6a 00                	push   $0x0
  803294:	53                   	push   %ebx
  803295:	51                   	push   %ecx
  803296:	52                   	push   %edx
  803297:	50                   	push   %eax
  803298:	6a 27                	push   $0x27
  80329a:	e8 44 fb ff ff       	call   802de3 <syscall>
  80329f:	83 c4 18             	add    $0x18,%esp
}
  8032a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8032a5:	c9                   	leave  
  8032a6:	c3                   	ret    

008032a7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8032a7:	55                   	push   %ebp
  8032a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8032aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	6a 00                	push   $0x0
  8032b2:	6a 00                	push   $0x0
  8032b4:	6a 00                	push   $0x0
  8032b6:	52                   	push   %edx
  8032b7:	50                   	push   %eax
  8032b8:	6a 28                	push   $0x28
  8032ba:	e8 24 fb ff ff       	call   802de3 <syscall>
  8032bf:	83 c4 18             	add    $0x18,%esp
}
  8032c2:	c9                   	leave  
  8032c3:	c3                   	ret    

008032c4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8032c4:	55                   	push   %ebp
  8032c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8032c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8032ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	6a 00                	push   $0x0
  8032d2:	51                   	push   %ecx
  8032d3:	ff 75 10             	pushl  0x10(%ebp)
  8032d6:	52                   	push   %edx
  8032d7:	50                   	push   %eax
  8032d8:	6a 29                	push   $0x29
  8032da:	e8 04 fb ff ff       	call   802de3 <syscall>
  8032df:	83 c4 18             	add    $0x18,%esp
}
  8032e2:	c9                   	leave  
  8032e3:	c3                   	ret    

008032e4 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8032e4:	55                   	push   %ebp
  8032e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8032e7:	6a 00                	push   $0x0
  8032e9:	6a 00                	push   $0x0
  8032eb:	ff 75 10             	pushl  0x10(%ebp)
  8032ee:	ff 75 0c             	pushl  0xc(%ebp)
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	6a 12                	push   $0x12
  8032f6:	e8 e8 fa ff ff       	call   802de3 <syscall>
  8032fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8032fe:	90                   	nop
}
  8032ff:	c9                   	leave  
  803300:	c3                   	ret    

00803301 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803301:	55                   	push   %ebp
  803302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803304:	8b 55 0c             	mov    0xc(%ebp),%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	6a 00                	push   $0x0
  80330c:	6a 00                	push   $0x0
  80330e:	6a 00                	push   $0x0
  803310:	52                   	push   %edx
  803311:	50                   	push   %eax
  803312:	6a 2a                	push   $0x2a
  803314:	e8 ca fa ff ff       	call   802de3 <syscall>
  803319:	83 c4 18             	add    $0x18,%esp
	return;
  80331c:	90                   	nop
}
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    

0080331f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80331f:	55                   	push   %ebp
  803320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  803322:	6a 00                	push   $0x0
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	6a 00                	push   $0x0
  80332c:	6a 2b                	push   $0x2b
  80332e:	e8 b0 fa ff ff       	call   802de3 <syscall>
  803333:	83 c4 18             	add    $0x18,%esp
}
  803336:	c9                   	leave  
  803337:	c3                   	ret    

00803338 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  803338:	55                   	push   %ebp
  803339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80333b:	6a 00                	push   $0x0
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	ff 75 0c             	pushl  0xc(%ebp)
  803344:	ff 75 08             	pushl  0x8(%ebp)
  803347:	6a 2d                	push   $0x2d
  803349:	e8 95 fa ff ff       	call   802de3 <syscall>
  80334e:	83 c4 18             	add    $0x18,%esp
	return;
  803351:	90                   	nop
}
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  803354:	55                   	push   %ebp
  803355:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  803357:	6a 00                	push   $0x0
  803359:	6a 00                	push   $0x0
  80335b:	6a 00                	push   $0x0
  80335d:	ff 75 0c             	pushl  0xc(%ebp)
  803360:	ff 75 08             	pushl  0x8(%ebp)
  803363:	6a 2c                	push   $0x2c
  803365:	e8 79 fa ff ff       	call   802de3 <syscall>
  80336a:	83 c4 18             	add    $0x18,%esp
	return ;
  80336d:	90                   	nop
}
  80336e:	c9                   	leave  
  80336f:	c3                   	ret    

00803370 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  803370:	55                   	push   %ebp
  803371:	89 e5                	mov    %esp,%ebp
  803373:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  803376:	83 ec 04             	sub    $0x4,%esp
  803379:	68 f4 4f 80 00       	push   $0x804ff4
  80337e:	68 25 01 00 00       	push   $0x125
  803383:	68 27 50 80 00       	push   $0x805027
  803388:	e8 ec e6 ff ff       	call   801a79 <_panic>

0080338d <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80338d:	55                   	push   %ebp
  80338e:	89 e5                	mov    %esp,%ebp
  803390:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  803393:	81 7d 08 40 62 80 00 	cmpl   $0x806240,0x8(%ebp)
  80339a:	72 09                	jb     8033a5 <to_page_va+0x18>
  80339c:	81 7d 08 40 e2 81 00 	cmpl   $0x81e240,0x8(%ebp)
  8033a3:	72 14                	jb     8033b9 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	68 38 50 80 00       	push   $0x805038
  8033ad:	6a 15                	push   $0x15
  8033af:	68 63 50 80 00       	push   $0x805063
  8033b4:	e8 c0 e6 ff ff       	call   801a79 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	ba 40 62 80 00       	mov    $0x806240,%edx
  8033c1:	29 d0                	sub    %edx,%eax
  8033c3:	c1 f8 02             	sar    $0x2,%eax
  8033c6:	89 c2                	mov    %eax,%edx
  8033c8:	89 d0                	mov    %edx,%eax
  8033ca:	c1 e0 02             	shl    $0x2,%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	c1 e0 02             	shl    $0x2,%eax
  8033d2:	01 d0                	add    %edx,%eax
  8033d4:	c1 e0 02             	shl    $0x2,%eax
  8033d7:	01 d0                	add    %edx,%eax
  8033d9:	89 c1                	mov    %eax,%ecx
  8033db:	c1 e1 08             	shl    $0x8,%ecx
  8033de:	01 c8                	add    %ecx,%eax
  8033e0:	89 c1                	mov    %eax,%ecx
  8033e2:	c1 e1 10             	shl    $0x10,%ecx
  8033e5:	01 c8                	add    %ecx,%eax
  8033e7:	01 c0                	add    %eax,%eax
  8033e9:	01 d0                	add    %edx,%eax
  8033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	c1 e0 0c             	shl    $0xc,%eax
  8033f4:	89 c2                	mov    %eax,%edx
  8033f6:	a1 48 e2 81 00       	mov    0x81e248,%eax
  8033fb:	01 d0                	add    %edx,%eax
}
  8033fd:	c9                   	leave  
  8033fe:	c3                   	ret    

008033ff <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  8033ff:	55                   	push   %ebp
  803400:	89 e5                	mov    %esp,%ebp
  803402:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  803405:	a1 48 e2 81 00       	mov    0x81e248,%eax
  80340a:	8b 55 08             	mov    0x8(%ebp),%edx
  80340d:	29 c2                	sub    %eax,%edx
  80340f:	89 d0                	mov    %edx,%eax
  803411:	c1 e8 0c             	shr    $0xc,%eax
  803414:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  803417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341b:	78 09                	js     803426 <to_page_info+0x27>
  80341d:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  803424:	7e 14                	jle    80343a <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 7c 50 80 00       	push   $0x80507c
  80342e:	6a 22                	push   $0x22
  803430:	68 63 50 80 00       	push   $0x805063
  803435:	e8 3f e6 ff ff       	call   801a79 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  80343a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343d:	89 d0                	mov    %edx,%eax
  80343f:	01 c0                	add    %eax,%eax
  803441:	01 d0                	add    %edx,%eax
  803443:	c1 e0 02             	shl    $0x2,%eax
  803446:	05 40 62 80 00       	add    $0x806240,%eax
}
  80344b:	c9                   	leave  
  80344c:	c3                   	ret    

0080344d <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80344d:	55                   	push   %ebp
  80344e:	89 e5                	mov    %esp,%ebp
  803450:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	05 00 00 00 02       	add    $0x2000000,%eax
  80345b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80345e:	73 16                	jae    803476 <initialize_dynamic_allocator+0x29>
  803460:	68 a0 50 80 00       	push   $0x8050a0
  803465:	68 c6 50 80 00       	push   $0x8050c6
  80346a:	6a 34                	push   $0x34
  80346c:	68 63 50 80 00       	push   $0x805063
  803471:	e8 03 e6 ff ff       	call   801a79 <_panic>
		is_initialized = 1;
  803476:	c7 05 04 62 80 00 01 	movl   $0x1,0x806204
  80347d:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	a3 48 e2 81 00       	mov    %eax,0x81e248
	dynAllocEnd = daEnd;
  803488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348b:	a3 20 62 80 00       	mov    %eax,0x806220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  803490:	c7 05 28 62 80 00 00 	movl   $0x0,0x806228
  803497:	00 00 00 
  80349a:	c7 05 2c 62 80 00 00 	movl   $0x0,0x80622c
  8034a1:	00 00 00 
  8034a4:	c7 05 34 62 80 00 00 	movl   $0x0,0x806234
  8034ab:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  8034ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8034b4:	c1 e8 0c             	shr    $0xc,%eax
  8034b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8034ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8034c1:	e9 c8 00 00 00       	jmp    80358e <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  8034c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c9:	89 d0                	mov    %edx,%eax
  8034cb:	01 c0                	add    %eax,%eax
  8034cd:	01 d0                	add    %edx,%eax
  8034cf:	c1 e0 02             	shl    $0x2,%eax
  8034d2:	05 48 62 80 00       	add    $0x806248,%eax
  8034d7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  8034dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034df:	89 d0                	mov    %edx,%eax
  8034e1:	01 c0                	add    %eax,%eax
  8034e3:	01 d0                	add    %edx,%eax
  8034e5:	c1 e0 02             	shl    $0x2,%eax
  8034e8:	05 4a 62 80 00       	add    $0x80624a,%eax
  8034ed:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  8034f2:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  8034f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8034fb:	89 c8                	mov    %ecx,%eax
  8034fd:	01 c0                	add    %eax,%eax
  8034ff:	01 c8                	add    %ecx,%eax
  803501:	c1 e0 02             	shl    $0x2,%eax
  803504:	05 44 62 80 00       	add    $0x806244,%eax
  803509:	89 10                	mov    %edx,(%eax)
  80350b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350e:	89 d0                	mov    %edx,%eax
  803510:	01 c0                	add    %eax,%eax
  803512:	01 d0                	add    %edx,%eax
  803514:	c1 e0 02             	shl    $0x2,%eax
  803517:	05 44 62 80 00       	add    $0x806244,%eax
  80351c:	8b 00                	mov    (%eax),%eax
  80351e:	85 c0                	test   %eax,%eax
  803520:	74 1b                	je     80353d <initialize_dynamic_allocator+0xf0>
  803522:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803528:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80352b:	89 c8                	mov    %ecx,%eax
  80352d:	01 c0                	add    %eax,%eax
  80352f:	01 c8                	add    %ecx,%eax
  803531:	c1 e0 02             	shl    $0x2,%eax
  803534:	05 40 62 80 00       	add    $0x806240,%eax
  803539:	89 02                	mov    %eax,(%edx)
  80353b:	eb 16                	jmp    803553 <initialize_dynamic_allocator+0x106>
  80353d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803540:	89 d0                	mov    %edx,%eax
  803542:	01 c0                	add    %eax,%eax
  803544:	01 d0                	add    %edx,%eax
  803546:	c1 e0 02             	shl    $0x2,%eax
  803549:	05 40 62 80 00       	add    $0x806240,%eax
  80354e:	a3 28 62 80 00       	mov    %eax,0x806228
  803553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803556:	89 d0                	mov    %edx,%eax
  803558:	01 c0                	add    %eax,%eax
  80355a:	01 d0                	add    %edx,%eax
  80355c:	c1 e0 02             	shl    $0x2,%eax
  80355f:	05 40 62 80 00       	add    $0x806240,%eax
  803564:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80356c:	89 d0                	mov    %edx,%eax
  80356e:	01 c0                	add    %eax,%eax
  803570:	01 d0                	add    %edx,%eax
  803572:	c1 e0 02             	shl    $0x2,%eax
  803575:	05 40 62 80 00       	add    $0x806240,%eax
  80357a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803580:	a1 34 62 80 00       	mov    0x806234,%eax
  803585:	40                   	inc    %eax
  803586:	a3 34 62 80 00       	mov    %eax,0x806234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  80358b:	ff 45 f4             	incl   -0xc(%ebp)
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803594:	0f 8c 2c ff ff ff    	jl     8034c6 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80359a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8035a1:	eb 36                	jmp    8035d9 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035a6:	c1 e0 04             	shl    $0x4,%eax
  8035a9:	05 60 e2 81 00       	add    $0x81e260,%eax
  8035ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b7:	c1 e0 04             	shl    $0x4,%eax
  8035ba:	05 64 e2 81 00       	add    $0x81e264,%eax
  8035bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c8:	c1 e0 04             	shl    $0x4,%eax
  8035cb:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8035d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8035d6:	ff 45 f0             	incl   -0x10(%ebp)
  8035d9:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8035dd:	7e c4                	jle    8035a3 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8035df:	90                   	nop
  8035e0:	c9                   	leave  
  8035e1:	c3                   	ret    

008035e2 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8035e2:	55                   	push   %ebp
  8035e3:	89 e5                	mov    %esp,%ebp
  8035e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	83 ec 0c             	sub    $0xc,%esp
  8035ee:	50                   	push   %eax
  8035ef:	e8 0b fe ff ff       	call   8033ff <to_page_info>
  8035f4:	83 c4 10             	add    $0x10,%esp
  8035f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 40 08             	mov    0x8(%eax),%eax
  803600:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803603:	c9                   	leave  
  803604:	c3                   	ret    

00803605 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  803605:	55                   	push   %ebp
  803606:	89 e5                	mov    %esp,%ebp
  803608:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80360b:	83 ec 0c             	sub    $0xc,%esp
  80360e:	ff 75 0c             	pushl  0xc(%ebp)
  803611:	e8 77 fd ff ff       	call   80338d <to_page_va>
  803616:	83 c4 10             	add    $0x10,%esp
  803619:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80361c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803621:	ba 00 00 00 00       	mov    $0x0,%edx
  803626:	f7 75 08             	divl   0x8(%ebp)
  803629:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80362c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362f:	83 ec 0c             	sub    $0xc,%esp
  803632:	50                   	push   %eax
  803633:	e8 48 f6 ff ff       	call   802c80 <get_page>
  803638:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80363b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803641:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80364b:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80364f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803656:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80365d:	eb 19                	jmp    803678 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80365f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803662:	ba 01 00 00 00       	mov    $0x1,%edx
  803667:	88 c1                	mov    %al,%cl
  803669:	d3 e2                	shl    %cl,%edx
  80366b:	89 d0                	mov    %edx,%eax
  80366d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803670:	74 0e                	je     803680 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  803672:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803675:	ff 45 f0             	incl   -0x10(%ebp)
  803678:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80367c:	7e e1                	jle    80365f <split_page_to_blocks+0x5a>
  80367e:	eb 01                	jmp    803681 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  803680:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803681:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803688:	e9 a7 00 00 00       	jmp    803734 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80368d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803690:	0f af 45 08          	imul   0x8(%ebp),%eax
  803694:	89 c2                	mov    %eax,%edx
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	01 d0                	add    %edx,%eax
  80369b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80369e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8036a2:	75 14                	jne    8036b8 <split_page_to_blocks+0xb3>
  8036a4:	83 ec 04             	sub    $0x4,%esp
  8036a7:	68 dc 50 80 00       	push   $0x8050dc
  8036ac:	6a 7c                	push   $0x7c
  8036ae:	68 63 50 80 00       	push   $0x805063
  8036b3:	e8 c1 e3 ff ff       	call   801a79 <_panic>
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	c1 e0 04             	shl    $0x4,%eax
  8036be:	05 64 e2 81 00       	add    $0x81e264,%eax
  8036c3:	8b 10                	mov    (%eax),%edx
  8036c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c8:	89 50 04             	mov    %edx,0x4(%eax)
  8036cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036ce:	8b 40 04             	mov    0x4(%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 14                	je     8036e9 <split_page_to_blocks+0xe4>
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	c1 e0 04             	shl    $0x4,%eax
  8036db:	05 64 e2 81 00       	add    $0x81e264,%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8036e5:	89 10                	mov    %edx,(%eax)
  8036e7:	eb 11                	jmp    8036fa <split_page_to_blocks+0xf5>
  8036e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ec:	c1 e0 04             	shl    $0x4,%eax
  8036ef:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  8036f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036f8:	89 02                	mov    %eax,(%edx)
  8036fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fd:	c1 e0 04             	shl    $0x4,%eax
  803700:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803709:	89 02                	mov    %eax,(%edx)
  80370b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80370e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	c1 e0 04             	shl    $0x4,%eax
  80371a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80371f:	8b 00                	mov    (%eax),%eax
  803721:	8d 50 01             	lea    0x1(%eax),%edx
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	c1 e0 04             	shl    $0x4,%eax
  80372a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  80372f:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  803731:	ff 45 ec             	incl   -0x14(%ebp)
  803734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803737:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80373a:	0f 82 4d ff ff ff    	jb     80368d <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  803740:	90                   	nop
  803741:	c9                   	leave  
  803742:	c3                   	ret    

00803743 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
  803746:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803749:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803750:	76 19                	jbe    80376b <alloc_block+0x28>
  803752:	68 00 51 80 00       	push   $0x805100
  803757:	68 c6 50 80 00       	push   $0x8050c6
  80375c:	68 8a 00 00 00       	push   $0x8a
  803761:	68 63 50 80 00       	push   $0x805063
  803766:	e8 0e e3 ff ff       	call   801a79 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80376b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  803772:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803779:	eb 19                	jmp    803794 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377e:	ba 01 00 00 00       	mov    $0x1,%edx
  803783:	88 c1                	mov    %al,%cl
  803785:	d3 e2                	shl    %cl,%edx
  803787:	89 d0                	mov    %edx,%eax
  803789:	3b 45 08             	cmp    0x8(%ebp),%eax
  80378c:	73 0e                	jae    80379c <alloc_block+0x59>
		idx++;
  80378e:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  803791:	ff 45 f0             	incl   -0x10(%ebp)
  803794:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803798:	7e e1                	jle    80377b <alloc_block+0x38>
  80379a:	eb 01                	jmp    80379d <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80379c:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	c1 e0 04             	shl    $0x4,%eax
  8037a3:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	0f 84 df 00 00 00    	je     803891 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8037b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b5:	c1 e0 04             	shl    $0x4,%eax
  8037b8:	05 60 e2 81 00       	add    $0x81e260,%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8037c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037c6:	75 17                	jne    8037df <alloc_block+0x9c>
  8037c8:	83 ec 04             	sub    $0x4,%esp
  8037cb:	68 21 51 80 00       	push   $0x805121
  8037d0:	68 9e 00 00 00       	push   $0x9e
  8037d5:	68 63 50 80 00       	push   $0x805063
  8037da:	e8 9a e2 ff ff       	call   801a79 <_panic>
  8037df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e2:	8b 00                	mov    (%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 10                	je     8037f8 <alloc_block+0xb5>
  8037e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037eb:	8b 00                	mov    (%eax),%eax
  8037ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037f0:	8b 52 04             	mov    0x4(%edx),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	eb 14                	jmp    80380c <alloc_block+0xc9>
  8037f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fb:	8b 40 04             	mov    0x4(%eax),%eax
  8037fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803801:	c1 e2 04             	shl    $0x4,%edx
  803804:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  80380a:	89 02                	mov    %eax,(%edx)
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	8b 40 04             	mov    0x4(%eax),%eax
  803812:	85 c0                	test   %eax,%eax
  803814:	74 0f                	je     803825 <alloc_block+0xe2>
  803816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803819:	8b 40 04             	mov    0x4(%eax),%eax
  80381c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80381f:	8b 12                	mov    (%edx),%edx
  803821:	89 10                	mov    %edx,(%eax)
  803823:	eb 13                	jmp    803838 <alloc_block+0xf5>
  803825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803828:	8b 00                	mov    (%eax),%eax
  80382a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80382d:	c1 e2 04             	shl    $0x4,%edx
  803830:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803836:	89 02                	mov    %eax,(%edx)
  803838:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80383b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803844:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384e:	c1 e0 04             	shl    $0x4,%eax
  803851:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	8d 50 ff             	lea    -0x1(%eax),%edx
  80385b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385e:	c1 e0 04             	shl    $0x4,%eax
  803861:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803866:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386b:	83 ec 0c             	sub    $0xc,%esp
  80386e:	50                   	push   %eax
  80386f:	e8 8b fb ff ff       	call   8033ff <to_page_info>
  803874:	83 c4 10             	add    $0x10,%esp
  803877:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80387a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80387d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803881:	48                   	dec    %eax
  803882:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803885:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  803889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388c:	e9 bc 02 00 00       	jmp    803b4d <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  803891:	a1 34 62 80 00       	mov    0x806234,%eax
  803896:	85 c0                	test   %eax,%eax
  803898:	0f 84 7d 02 00 00    	je     803b1b <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80389e:	a1 28 62 80 00       	mov    0x806228,%eax
  8038a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8038a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038aa:	75 17                	jne    8038c3 <alloc_block+0x180>
  8038ac:	83 ec 04             	sub    $0x4,%esp
  8038af:	68 21 51 80 00       	push   $0x805121
  8038b4:	68 a9 00 00 00       	push   $0xa9
  8038b9:	68 63 50 80 00       	push   $0x805063
  8038be:	e8 b6 e1 ff ff       	call   801a79 <_panic>
  8038c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c6:	8b 00                	mov    (%eax),%eax
  8038c8:	85 c0                	test   %eax,%eax
  8038ca:	74 10                	je     8038dc <alloc_block+0x199>
  8038cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d4:	8b 52 04             	mov    0x4(%edx),%edx
  8038d7:	89 50 04             	mov    %edx,0x4(%eax)
  8038da:	eb 0b                	jmp    8038e7 <alloc_block+0x1a4>
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	8b 40 04             	mov    0x4(%eax),%eax
  8038e2:	a3 2c 62 80 00       	mov    %eax,0x80622c
  8038e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ea:	8b 40 04             	mov    0x4(%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	74 0f                	je     803900 <alloc_block+0x1bd>
  8038f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f4:	8b 40 04             	mov    0x4(%eax),%eax
  8038f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038fa:	8b 12                	mov    (%edx),%edx
  8038fc:	89 10                	mov    %edx,(%eax)
  8038fe:	eb 0a                	jmp    80390a <alloc_block+0x1c7>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	a3 28 62 80 00       	mov    %eax,0x806228
  80390a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80390d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391d:	a1 34 62 80 00       	mov    0x806234,%eax
  803922:	48                   	dec    %eax
  803923:	a3 34 62 80 00       	mov    %eax,0x806234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  803928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392b:	83 c0 03             	add    $0x3,%eax
  80392e:	ba 01 00 00 00       	mov    $0x1,%edx
  803933:	88 c1                	mov    %al,%cl
  803935:	d3 e2                	shl    %cl,%edx
  803937:	89 d0                	mov    %edx,%eax
  803939:	83 ec 08             	sub    $0x8,%esp
  80393c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80393f:	50                   	push   %eax
  803940:	e8 c0 fc ff ff       	call   803605 <split_page_to_blocks>
  803945:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394b:	c1 e0 04             	shl    $0x4,%eax
  80394e:	05 60 e2 81 00       	add    $0x81e260,%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  803958:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80395c:	75 17                	jne    803975 <alloc_block+0x232>
  80395e:	83 ec 04             	sub    $0x4,%esp
  803961:	68 21 51 80 00       	push   $0x805121
  803966:	68 b0 00 00 00       	push   $0xb0
  80396b:	68 63 50 80 00       	push   $0x805063
  803970:	e8 04 e1 ff ff       	call   801a79 <_panic>
  803975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	74 10                	je     80398e <alloc_block+0x24b>
  80397e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803981:	8b 00                	mov    (%eax),%eax
  803983:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803986:	8b 52 04             	mov    0x4(%edx),%edx
  803989:	89 50 04             	mov    %edx,0x4(%eax)
  80398c:	eb 14                	jmp    8039a2 <alloc_block+0x25f>
  80398e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803991:	8b 40 04             	mov    0x4(%eax),%eax
  803994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803997:	c1 e2 04             	shl    $0x4,%edx
  80399a:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  8039a0:	89 02                	mov    %eax,(%edx)
  8039a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a5:	8b 40 04             	mov    0x4(%eax),%eax
  8039a8:	85 c0                	test   %eax,%eax
  8039aa:	74 0f                	je     8039bb <alloc_block+0x278>
  8039ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039af:	8b 40 04             	mov    0x4(%eax),%eax
  8039b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b5:	8b 12                	mov    (%edx),%edx
  8039b7:	89 10                	mov    %edx,(%eax)
  8039b9:	eb 13                	jmp    8039ce <alloc_block+0x28b>
  8039bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039be:	8b 00                	mov    (%eax),%eax
  8039c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c3:	c1 e2 04             	shl    $0x4,%edx
  8039c6:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  8039cc:	89 02                	mov    %eax,(%edx)
  8039ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	c1 e0 04             	shl    $0x4,%eax
  8039e7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8039ec:	8b 00                	mov    (%eax),%eax
  8039ee:	8d 50 ff             	lea    -0x1(%eax),%edx
  8039f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f4:	c1 e0 04             	shl    $0x4,%eax
  8039f7:	05 6c e2 81 00       	add    $0x81e26c,%eax
  8039fc:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8039fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a01:	83 ec 0c             	sub    $0xc,%esp
  803a04:	50                   	push   %eax
  803a05:	e8 f5 f9 ff ff       	call   8033ff <to_page_info>
  803a0a:	83 c4 10             	add    $0x10,%esp
  803a0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  803a10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a13:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803a17:	48                   	dec    %eax
  803a18:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803a1b:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  803a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a22:	e9 26 01 00 00       	jmp    803b4d <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  803a27:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  803a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2d:	c1 e0 04             	shl    $0x4,%eax
  803a30:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803a35:	8b 00                	mov    (%eax),%eax
  803a37:	85 c0                	test   %eax,%eax
  803a39:	0f 84 dc 00 00 00    	je     803b1b <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  803a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a42:	c1 e0 04             	shl    $0x4,%eax
  803a45:	05 60 e2 81 00       	add    $0x81e260,%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  803a4f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803a53:	75 17                	jne    803a6c <alloc_block+0x329>
  803a55:	83 ec 04             	sub    $0x4,%esp
  803a58:	68 21 51 80 00       	push   $0x805121
  803a5d:	68 be 00 00 00       	push   $0xbe
  803a62:	68 63 50 80 00       	push   $0x805063
  803a67:	e8 0d e0 ff ff       	call   801a79 <_panic>
  803a6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a6f:	8b 00                	mov    (%eax),%eax
  803a71:	85 c0                	test   %eax,%eax
  803a73:	74 10                	je     803a85 <alloc_block+0x342>
  803a75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a78:	8b 00                	mov    (%eax),%eax
  803a7a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a7d:	8b 52 04             	mov    0x4(%edx),%edx
  803a80:	89 50 04             	mov    %edx,0x4(%eax)
  803a83:	eb 14                	jmp    803a99 <alloc_block+0x356>
  803a85:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a88:	8b 40 04             	mov    0x4(%eax),%eax
  803a8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a8e:	c1 e2 04             	shl    $0x4,%edx
  803a91:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803a97:	89 02                	mov    %eax,(%edx)
  803a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a9c:	8b 40 04             	mov    0x4(%eax),%eax
  803a9f:	85 c0                	test   %eax,%eax
  803aa1:	74 0f                	je     803ab2 <alloc_block+0x36f>
  803aa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803aa6:	8b 40 04             	mov    0x4(%eax),%eax
  803aa9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803aac:	8b 12                	mov    (%edx),%edx
  803aae:	89 10                	mov    %edx,(%eax)
  803ab0:	eb 13                	jmp    803ac5 <alloc_block+0x382>
  803ab2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ab5:	8b 00                	mov    (%eax),%eax
  803ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803aba:	c1 e2 04             	shl    $0x4,%edx
  803abd:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803ac3:	89 02                	mov    %eax,(%edx)
  803ac5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ac8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ace:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adb:	c1 e0 04             	shl    $0x4,%eax
  803ade:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803ae3:	8b 00                	mov    (%eax),%eax
  803ae5:	8d 50 ff             	lea    -0x1(%eax),%edx
  803ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aeb:	c1 e0 04             	shl    $0x4,%eax
  803aee:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803af3:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803af5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803af8:	83 ec 0c             	sub    $0xc,%esp
  803afb:	50                   	push   %eax
  803afc:	e8 fe f8 ff ff       	call   8033ff <to_page_info>
  803b01:	83 c4 10             	add    $0x10,%esp
  803b04:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  803b07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803b0a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803b0e:	48                   	dec    %eax
  803b0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803b12:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  803b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803b19:	eb 32                	jmp    803b4d <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  803b1b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  803b1f:	77 15                	ja     803b36 <alloc_block+0x3f3>
  803b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b24:	c1 e0 04             	shl    $0x4,%eax
  803b27:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	85 c0                	test   %eax,%eax
  803b30:	0f 84 f1 fe ff ff    	je     803a27 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  803b36:	83 ec 04             	sub    $0x4,%esp
  803b39:	68 3f 51 80 00       	push   $0x80513f
  803b3e:	68 c8 00 00 00       	push   $0xc8
  803b43:	68 63 50 80 00       	push   $0x805063
  803b48:	e8 2c df ff ff       	call   801a79 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  803b4d:	c9                   	leave  
  803b4e:	c3                   	ret    

00803b4f <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  803b4f:	55                   	push   %ebp
  803b50:	89 e5                	mov    %esp,%ebp
  803b52:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  803b55:	8b 55 08             	mov    0x8(%ebp),%edx
  803b58:	a1 48 e2 81 00       	mov    0x81e248,%eax
  803b5d:	39 c2                	cmp    %eax,%edx
  803b5f:	72 0c                	jb     803b6d <free_block+0x1e>
  803b61:	8b 55 08             	mov    0x8(%ebp),%edx
  803b64:	a1 20 62 80 00       	mov    0x806220,%eax
  803b69:	39 c2                	cmp    %eax,%edx
  803b6b:	72 19                	jb     803b86 <free_block+0x37>
  803b6d:	68 50 51 80 00       	push   $0x805150
  803b72:	68 c6 50 80 00       	push   $0x8050c6
  803b77:	68 d7 00 00 00       	push   $0xd7
  803b7c:	68 63 50 80 00       	push   $0x805063
  803b81:	e8 f3 de ff ff       	call   801a79 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  803b86:	8b 45 08             	mov    0x8(%ebp),%eax
  803b89:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8f:	83 ec 0c             	sub    $0xc,%esp
  803b92:	50                   	push   %eax
  803b93:	e8 67 f8 ff ff       	call   8033ff <to_page_info>
  803b98:	83 c4 10             	add    $0x10,%esp
  803b9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba1:	8b 40 08             	mov    0x8(%eax),%eax
  803ba4:	0f b7 c0             	movzwl %ax,%eax
  803ba7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803baa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803bb1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803bb8:	eb 19                	jmp    803bd3 <free_block+0x84>
	    if ((1 << i) == blk_size)
  803bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bbd:	ba 01 00 00 00       	mov    $0x1,%edx
  803bc2:	88 c1                	mov    %al,%cl
  803bc4:	d3 e2                	shl    %cl,%edx
  803bc6:	89 d0                	mov    %edx,%eax
  803bc8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803bcb:	74 0e                	je     803bdb <free_block+0x8c>
	        break;
	    idx++;
  803bcd:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  803bd0:	ff 45 f0             	incl   -0x10(%ebp)
  803bd3:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803bd7:	7e e1                	jle    803bba <free_block+0x6b>
  803bd9:	eb 01                	jmp    803bdc <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803bdb:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bdf:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803be3:	40                   	inc    %eax
  803be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803be7:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803beb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bef:	75 17                	jne    803c08 <free_block+0xb9>
  803bf1:	83 ec 04             	sub    $0x4,%esp
  803bf4:	68 dc 50 80 00       	push   $0x8050dc
  803bf9:	68 ee 00 00 00       	push   $0xee
  803bfe:	68 63 50 80 00       	push   $0x805063
  803c03:	e8 71 de ff ff       	call   801a79 <_panic>
  803c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0b:	c1 e0 04             	shl    $0x4,%eax
  803c0e:	05 64 e2 81 00       	add    $0x81e264,%eax
  803c13:	8b 10                	mov    (%eax),%edx
  803c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c18:	89 50 04             	mov    %edx,0x4(%eax)
  803c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1e:	8b 40 04             	mov    0x4(%eax),%eax
  803c21:	85 c0                	test   %eax,%eax
  803c23:	74 14                	je     803c39 <free_block+0xea>
  803c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c28:	c1 e0 04             	shl    $0x4,%eax
  803c2b:	05 64 e2 81 00       	add    $0x81e264,%eax
  803c30:	8b 00                	mov    (%eax),%eax
  803c32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c35:	89 10                	mov    %edx,(%eax)
  803c37:	eb 11                	jmp    803c4a <free_block+0xfb>
  803c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3c:	c1 e0 04             	shl    $0x4,%eax
  803c3f:	8d 90 60 e2 81 00    	lea    0x81e260(%eax),%edx
  803c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c48:	89 02                	mov    %eax,(%edx)
  803c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4d:	c1 e0 04             	shl    $0x4,%eax
  803c50:	8d 90 64 e2 81 00    	lea    0x81e264(%eax),%edx
  803c56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c59:	89 02                	mov    %eax,(%edx)
  803c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c67:	c1 e0 04             	shl    $0x4,%eax
  803c6a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803c6f:	8b 00                	mov    (%eax),%eax
  803c71:	8d 50 01             	lea    0x1(%eax),%edx
  803c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c77:	c1 e0 04             	shl    $0x4,%eax
  803c7a:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803c7f:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  803c81:	b8 00 10 00 00       	mov    $0x1000,%eax
  803c86:	ba 00 00 00 00       	mov    $0x0,%edx
  803c8b:	f7 75 e0             	divl   -0x20(%ebp)
  803c8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  803c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c94:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803c98:	0f b7 c0             	movzwl %ax,%eax
  803c9b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803c9e:	0f 85 70 01 00 00    	jne    803e14 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  803ca4:	83 ec 0c             	sub    $0xc,%esp
  803ca7:	ff 75 e4             	pushl  -0x1c(%ebp)
  803caa:	e8 de f6 ff ff       	call   80338d <to_page_va>
  803caf:	83 c4 10             	add    $0x10,%esp
  803cb2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803cb5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803cbc:	e9 b7 00 00 00       	jmp    803d78 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  803cc1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc7:	01 d0                	add    %edx,%eax
  803cc9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803ccc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803cd0:	75 17                	jne    803ce9 <free_block+0x19a>
  803cd2:	83 ec 04             	sub    $0x4,%esp
  803cd5:	68 21 51 80 00       	push   $0x805121
  803cda:	68 f8 00 00 00       	push   $0xf8
  803cdf:	68 63 50 80 00       	push   $0x805063
  803ce4:	e8 90 dd ff ff       	call   801a79 <_panic>
  803ce9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cec:	8b 00                	mov    (%eax),%eax
  803cee:	85 c0                	test   %eax,%eax
  803cf0:	74 10                	je     803d02 <free_block+0x1b3>
  803cf2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803cf5:	8b 00                	mov    (%eax),%eax
  803cf7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803cfa:	8b 52 04             	mov    0x4(%edx),%edx
  803cfd:	89 50 04             	mov    %edx,0x4(%eax)
  803d00:	eb 14                	jmp    803d16 <free_block+0x1c7>
  803d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d05:	8b 40 04             	mov    0x4(%eax),%eax
  803d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d0b:	c1 e2 04             	shl    $0x4,%edx
  803d0e:	81 c2 64 e2 81 00    	add    $0x81e264,%edx
  803d14:	89 02                	mov    %eax,(%edx)
  803d16:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d19:	8b 40 04             	mov    0x4(%eax),%eax
  803d1c:	85 c0                	test   %eax,%eax
  803d1e:	74 0f                	je     803d2f <free_block+0x1e0>
  803d20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d23:	8b 40 04             	mov    0x4(%eax),%eax
  803d26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803d29:	8b 12                	mov    (%edx),%edx
  803d2b:	89 10                	mov    %edx,(%eax)
  803d2d:	eb 13                	jmp    803d42 <free_block+0x1f3>
  803d2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d37:	c1 e2 04             	shl    $0x4,%edx
  803d3a:	81 c2 60 e2 81 00    	add    $0x81e260,%edx
  803d40:	89 02                	mov    %eax,(%edx)
  803d42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d58:	c1 e0 04             	shl    $0x4,%eax
  803d5b:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d60:	8b 00                	mov    (%eax),%eax
  803d62:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d68:	c1 e0 04             	shl    $0x4,%eax
  803d6b:	05 6c e2 81 00       	add    $0x81e26c,%eax
  803d70:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d75:	01 45 ec             	add    %eax,-0x14(%ebp)
  803d78:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  803d7f:	0f 86 3c ff ff ff    	jbe    803cc1 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d88:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d91:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803d97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d9b:	75 17                	jne    803db4 <free_block+0x265>
  803d9d:	83 ec 04             	sub    $0x4,%esp
  803da0:	68 dc 50 80 00       	push   $0x8050dc
  803da5:	68 fe 00 00 00       	push   $0xfe
  803daa:	68 63 50 80 00       	push   $0x805063
  803daf:	e8 c5 dc ff ff       	call   801a79 <_panic>
  803db4:	8b 15 2c 62 80 00    	mov    0x80622c,%edx
  803dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbd:	89 50 04             	mov    %edx,0x4(%eax)
  803dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc3:	8b 40 04             	mov    0x4(%eax),%eax
  803dc6:	85 c0                	test   %eax,%eax
  803dc8:	74 0c                	je     803dd6 <free_block+0x287>
  803dca:	a1 2c 62 80 00       	mov    0x80622c,%eax
  803dcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dd2:	89 10                	mov    %edx,(%eax)
  803dd4:	eb 08                	jmp    803dde <free_block+0x28f>
  803dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd9:	a3 28 62 80 00       	mov    %eax,0x806228
  803dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de1:	a3 2c 62 80 00       	mov    %eax,0x80622c
  803de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803def:	a1 34 62 80 00       	mov    0x806234,%eax
  803df4:	40                   	inc    %eax
  803df5:	a3 34 62 80 00       	mov    %eax,0x806234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803dfa:	83 ec 0c             	sub    $0xc,%esp
  803dfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  803e00:	e8 88 f5 ff ff       	call   80338d <to_page_va>
  803e05:	83 c4 10             	add    $0x10,%esp
  803e08:	83 ec 0c             	sub    $0xc,%esp
  803e0b:	50                   	push   %eax
  803e0c:	e8 b8 ee ff ff       	call   802cc9 <return_page>
  803e11:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  803e14:	90                   	nop
  803e15:	c9                   	leave  
  803e16:	c3                   	ret    

00803e17 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  803e17:	55                   	push   %ebp
  803e18:	89 e5                	mov    %esp,%ebp
  803e1a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  803e1d:	83 ec 04             	sub    $0x4,%esp
  803e20:	68 88 51 80 00       	push   $0x805188
  803e25:	68 11 01 00 00       	push   $0x111
  803e2a:	68 63 50 80 00       	push   $0x805063
  803e2f:	e8 45 dc ff ff       	call   801a79 <_panic>

00803e34 <__udivdi3>:
  803e34:	55                   	push   %ebp
  803e35:	57                   	push   %edi
  803e36:	56                   	push   %esi
  803e37:	53                   	push   %ebx
  803e38:	83 ec 1c             	sub    $0x1c,%esp
  803e3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e4b:	89 ca                	mov    %ecx,%edx
  803e4d:	89 f8                	mov    %edi,%eax
  803e4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e53:	85 f6                	test   %esi,%esi
  803e55:	75 2d                	jne    803e84 <__udivdi3+0x50>
  803e57:	39 cf                	cmp    %ecx,%edi
  803e59:	77 65                	ja     803ec0 <__udivdi3+0x8c>
  803e5b:	89 fd                	mov    %edi,%ebp
  803e5d:	85 ff                	test   %edi,%edi
  803e5f:	75 0b                	jne    803e6c <__udivdi3+0x38>
  803e61:	b8 01 00 00 00       	mov    $0x1,%eax
  803e66:	31 d2                	xor    %edx,%edx
  803e68:	f7 f7                	div    %edi
  803e6a:	89 c5                	mov    %eax,%ebp
  803e6c:	31 d2                	xor    %edx,%edx
  803e6e:	89 c8                	mov    %ecx,%eax
  803e70:	f7 f5                	div    %ebp
  803e72:	89 c1                	mov    %eax,%ecx
  803e74:	89 d8                	mov    %ebx,%eax
  803e76:	f7 f5                	div    %ebp
  803e78:	89 cf                	mov    %ecx,%edi
  803e7a:	89 fa                	mov    %edi,%edx
  803e7c:	83 c4 1c             	add    $0x1c,%esp
  803e7f:	5b                   	pop    %ebx
  803e80:	5e                   	pop    %esi
  803e81:	5f                   	pop    %edi
  803e82:	5d                   	pop    %ebp
  803e83:	c3                   	ret    
  803e84:	39 ce                	cmp    %ecx,%esi
  803e86:	77 28                	ja     803eb0 <__udivdi3+0x7c>
  803e88:	0f bd fe             	bsr    %esi,%edi
  803e8b:	83 f7 1f             	xor    $0x1f,%edi
  803e8e:	75 40                	jne    803ed0 <__udivdi3+0x9c>
  803e90:	39 ce                	cmp    %ecx,%esi
  803e92:	72 0a                	jb     803e9e <__udivdi3+0x6a>
  803e94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e98:	0f 87 9e 00 00 00    	ja     803f3c <__udivdi3+0x108>
  803e9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ea3:	89 fa                	mov    %edi,%edx
  803ea5:	83 c4 1c             	add    $0x1c,%esp
  803ea8:	5b                   	pop    %ebx
  803ea9:	5e                   	pop    %esi
  803eaa:	5f                   	pop    %edi
  803eab:	5d                   	pop    %ebp
  803eac:	c3                   	ret    
  803ead:	8d 76 00             	lea    0x0(%esi),%esi
  803eb0:	31 ff                	xor    %edi,%edi
  803eb2:	31 c0                	xor    %eax,%eax
  803eb4:	89 fa                	mov    %edi,%edx
  803eb6:	83 c4 1c             	add    $0x1c,%esp
  803eb9:	5b                   	pop    %ebx
  803eba:	5e                   	pop    %esi
  803ebb:	5f                   	pop    %edi
  803ebc:	5d                   	pop    %ebp
  803ebd:	c3                   	ret    
  803ebe:	66 90                	xchg   %ax,%ax
  803ec0:	89 d8                	mov    %ebx,%eax
  803ec2:	f7 f7                	div    %edi
  803ec4:	31 ff                	xor    %edi,%edi
  803ec6:	89 fa                	mov    %edi,%edx
  803ec8:	83 c4 1c             	add    $0x1c,%esp
  803ecb:	5b                   	pop    %ebx
  803ecc:	5e                   	pop    %esi
  803ecd:	5f                   	pop    %edi
  803ece:	5d                   	pop    %ebp
  803ecf:	c3                   	ret    
  803ed0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ed5:	89 eb                	mov    %ebp,%ebx
  803ed7:	29 fb                	sub    %edi,%ebx
  803ed9:	89 f9                	mov    %edi,%ecx
  803edb:	d3 e6                	shl    %cl,%esi
  803edd:	89 c5                	mov    %eax,%ebp
  803edf:	88 d9                	mov    %bl,%cl
  803ee1:	d3 ed                	shr    %cl,%ebp
  803ee3:	89 e9                	mov    %ebp,%ecx
  803ee5:	09 f1                	or     %esi,%ecx
  803ee7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803eeb:	89 f9                	mov    %edi,%ecx
  803eed:	d3 e0                	shl    %cl,%eax
  803eef:	89 c5                	mov    %eax,%ebp
  803ef1:	89 d6                	mov    %edx,%esi
  803ef3:	88 d9                	mov    %bl,%cl
  803ef5:	d3 ee                	shr    %cl,%esi
  803ef7:	89 f9                	mov    %edi,%ecx
  803ef9:	d3 e2                	shl    %cl,%edx
  803efb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803eff:	88 d9                	mov    %bl,%cl
  803f01:	d3 e8                	shr    %cl,%eax
  803f03:	09 c2                	or     %eax,%edx
  803f05:	89 d0                	mov    %edx,%eax
  803f07:	89 f2                	mov    %esi,%edx
  803f09:	f7 74 24 0c          	divl   0xc(%esp)
  803f0d:	89 d6                	mov    %edx,%esi
  803f0f:	89 c3                	mov    %eax,%ebx
  803f11:	f7 e5                	mul    %ebp
  803f13:	39 d6                	cmp    %edx,%esi
  803f15:	72 19                	jb     803f30 <__udivdi3+0xfc>
  803f17:	74 0b                	je     803f24 <__udivdi3+0xf0>
  803f19:	89 d8                	mov    %ebx,%eax
  803f1b:	31 ff                	xor    %edi,%edi
  803f1d:	e9 58 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f22:	66 90                	xchg   %ax,%ax
  803f24:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f28:	89 f9                	mov    %edi,%ecx
  803f2a:	d3 e2                	shl    %cl,%edx
  803f2c:	39 c2                	cmp    %eax,%edx
  803f2e:	73 e9                	jae    803f19 <__udivdi3+0xe5>
  803f30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f33:	31 ff                	xor    %edi,%edi
  803f35:	e9 40 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f3a:	66 90                	xchg   %ax,%ax
  803f3c:	31 c0                	xor    %eax,%eax
  803f3e:	e9 37 ff ff ff       	jmp    803e7a <__udivdi3+0x46>
  803f43:	90                   	nop

00803f44 <__umoddi3>:
  803f44:	55                   	push   %ebp
  803f45:	57                   	push   %edi
  803f46:	56                   	push   %esi
  803f47:	53                   	push   %ebx
  803f48:	83 ec 1c             	sub    $0x1c,%esp
  803f4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f63:	89 f3                	mov    %esi,%ebx
  803f65:	89 fa                	mov    %edi,%edx
  803f67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f6b:	89 34 24             	mov    %esi,(%esp)
  803f6e:	85 c0                	test   %eax,%eax
  803f70:	75 1a                	jne    803f8c <__umoddi3+0x48>
  803f72:	39 f7                	cmp    %esi,%edi
  803f74:	0f 86 a2 00 00 00    	jbe    80401c <__umoddi3+0xd8>
  803f7a:	89 c8                	mov    %ecx,%eax
  803f7c:	89 f2                	mov    %esi,%edx
  803f7e:	f7 f7                	div    %edi
  803f80:	89 d0                	mov    %edx,%eax
  803f82:	31 d2                	xor    %edx,%edx
  803f84:	83 c4 1c             	add    $0x1c,%esp
  803f87:	5b                   	pop    %ebx
  803f88:	5e                   	pop    %esi
  803f89:	5f                   	pop    %edi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    
  803f8c:	39 f0                	cmp    %esi,%eax
  803f8e:	0f 87 ac 00 00 00    	ja     804040 <__umoddi3+0xfc>
  803f94:	0f bd e8             	bsr    %eax,%ebp
  803f97:	83 f5 1f             	xor    $0x1f,%ebp
  803f9a:	0f 84 ac 00 00 00    	je     80404c <__umoddi3+0x108>
  803fa0:	bf 20 00 00 00       	mov    $0x20,%edi
  803fa5:	29 ef                	sub    %ebp,%edi
  803fa7:	89 fe                	mov    %edi,%esi
  803fa9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fad:	89 e9                	mov    %ebp,%ecx
  803faf:	d3 e0                	shl    %cl,%eax
  803fb1:	89 d7                	mov    %edx,%edi
  803fb3:	89 f1                	mov    %esi,%ecx
  803fb5:	d3 ef                	shr    %cl,%edi
  803fb7:	09 c7                	or     %eax,%edi
  803fb9:	89 e9                	mov    %ebp,%ecx
  803fbb:	d3 e2                	shl    %cl,%edx
  803fbd:	89 14 24             	mov    %edx,(%esp)
  803fc0:	89 d8                	mov    %ebx,%eax
  803fc2:	d3 e0                	shl    %cl,%eax
  803fc4:	89 c2                	mov    %eax,%edx
  803fc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fca:	d3 e0                	shl    %cl,%eax
  803fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fd4:	89 f1                	mov    %esi,%ecx
  803fd6:	d3 e8                	shr    %cl,%eax
  803fd8:	09 d0                	or     %edx,%eax
  803fda:	d3 eb                	shr    %cl,%ebx
  803fdc:	89 da                	mov    %ebx,%edx
  803fde:	f7 f7                	div    %edi
  803fe0:	89 d3                	mov    %edx,%ebx
  803fe2:	f7 24 24             	mull   (%esp)
  803fe5:	89 c6                	mov    %eax,%esi
  803fe7:	89 d1                	mov    %edx,%ecx
  803fe9:	39 d3                	cmp    %edx,%ebx
  803feb:	0f 82 87 00 00 00    	jb     804078 <__umoddi3+0x134>
  803ff1:	0f 84 91 00 00 00    	je     804088 <__umoddi3+0x144>
  803ff7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ffb:	29 f2                	sub    %esi,%edx
  803ffd:	19 cb                	sbb    %ecx,%ebx
  803fff:	89 d8                	mov    %ebx,%eax
  804001:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804005:	d3 e0                	shl    %cl,%eax
  804007:	89 e9                	mov    %ebp,%ecx
  804009:	d3 ea                	shr    %cl,%edx
  80400b:	09 d0                	or     %edx,%eax
  80400d:	89 e9                	mov    %ebp,%ecx
  80400f:	d3 eb                	shr    %cl,%ebx
  804011:	89 da                	mov    %ebx,%edx
  804013:	83 c4 1c             	add    $0x1c,%esp
  804016:	5b                   	pop    %ebx
  804017:	5e                   	pop    %esi
  804018:	5f                   	pop    %edi
  804019:	5d                   	pop    %ebp
  80401a:	c3                   	ret    
  80401b:	90                   	nop
  80401c:	89 fd                	mov    %edi,%ebp
  80401e:	85 ff                	test   %edi,%edi
  804020:	75 0b                	jne    80402d <__umoddi3+0xe9>
  804022:	b8 01 00 00 00       	mov    $0x1,%eax
  804027:	31 d2                	xor    %edx,%edx
  804029:	f7 f7                	div    %edi
  80402b:	89 c5                	mov    %eax,%ebp
  80402d:	89 f0                	mov    %esi,%eax
  80402f:	31 d2                	xor    %edx,%edx
  804031:	f7 f5                	div    %ebp
  804033:	89 c8                	mov    %ecx,%eax
  804035:	f7 f5                	div    %ebp
  804037:	89 d0                	mov    %edx,%eax
  804039:	e9 44 ff ff ff       	jmp    803f82 <__umoddi3+0x3e>
  80403e:	66 90                	xchg   %ax,%ax
  804040:	89 c8                	mov    %ecx,%eax
  804042:	89 f2                	mov    %esi,%edx
  804044:	83 c4 1c             	add    $0x1c,%esp
  804047:	5b                   	pop    %ebx
  804048:	5e                   	pop    %esi
  804049:	5f                   	pop    %edi
  80404a:	5d                   	pop    %ebp
  80404b:	c3                   	ret    
  80404c:	3b 04 24             	cmp    (%esp),%eax
  80404f:	72 06                	jb     804057 <__umoddi3+0x113>
  804051:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804055:	77 0f                	ja     804066 <__umoddi3+0x122>
  804057:	89 f2                	mov    %esi,%edx
  804059:	29 f9                	sub    %edi,%ecx
  80405b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80405f:	89 14 24             	mov    %edx,(%esp)
  804062:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804066:	8b 44 24 04          	mov    0x4(%esp),%eax
  80406a:	8b 14 24             	mov    (%esp),%edx
  80406d:	83 c4 1c             	add    $0x1c,%esp
  804070:	5b                   	pop    %ebx
  804071:	5e                   	pop    %esi
  804072:	5f                   	pop    %edi
  804073:	5d                   	pop    %ebp
  804074:	c3                   	ret    
  804075:	8d 76 00             	lea    0x0(%esi),%esi
  804078:	2b 04 24             	sub    (%esp),%eax
  80407b:	19 fa                	sbb    %edi,%edx
  80407d:	89 d1                	mov    %edx,%ecx
  80407f:	89 c6                	mov    %eax,%esi
  804081:	e9 71 ff ff ff       	jmp    803ff7 <__umoddi3+0xb3>
  804086:	66 90                	xchg   %ax,%ax
  804088:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80408c:	72 ea                	jb     804078 <__umoddi3+0x134>
  80408e:	89 d9                	mov    %ebx,%ecx
  804090:	e9 62 ff ff ff       	jmp    803ff7 <__umoddi3+0xb3>
