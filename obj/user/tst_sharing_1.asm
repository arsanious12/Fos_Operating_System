
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
  800031:	e8 19 11 00 00       	call   80114f <libmain>
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
  800067:	e8 31 27 00 00       	call   80279d <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 74 27 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 dd 24 00 00       	call   8025a4 <malloc>
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
  8000df:	e8 b9 26 00 00       	call   80279d <sys_calculate_free_frames>
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
  800125:	68 40 39 80 00       	push   $0x803940
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 de 14 00 00       	call   80160f <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 af 26 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 bc 39 80 00       	push   $0x8039bc
  800150:	6a 0c                	push   $0xc
  800152:	e8 b8 14 00 00       	call   80160f <cprintf_colored>
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
  800174:	e8 24 26 00 00       	call   80279d <sys_calculate_free_frames>
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
  8001b9:	e8 df 25 00 00       	call   80279d <sys_calculate_free_frames>
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
  8001f8:	68 34 3a 80 00       	push   $0x803a34
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 0b 14 00 00       	call   80160f <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 dc 25 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 c0 3a 80 00       	push   $0x803ac0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 de 13 00 00       	call   80160f <cprintf_colored>
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
  800270:	e8 ea 28 00 00       	call   802b5f <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 38 3b 80 00       	push   $0x803b38
  80028f:	6a 0c                	push   $0xc
  800291:	e8 79 13 00 00       	call   80160f <cprintf_colored>
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
  8002ae:	e8 ea 24 00 00       	call   80279d <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 2d 25 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 50 80 00 	mov    0x805020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 01 23 00 00       	call   8025d2 <free>
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
  8002fc:	e8 e7 24 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 70 3b 80 00       	push   $0x803b70
  800318:	6a 0c                	push   $0xc
  80031a:	e8 f0 12 00 00       	call   80160f <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 76 24 00 00       	call   80279d <sys_calculate_free_frames>
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
  800342:	68 bc 3b 80 00       	push   $0x803bbc
  800347:	6a 0c                	push   $0xc
  800349:	e8 c1 12 00 00       	call   80160f <cprintf_colored>
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
  8003a0:	e8 ba 27 00 00       	call   802b5f <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 18 3c 80 00       	push   $0x803c18
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 49 12 00 00       	call   80160f <cprintf_colored>
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
  800416:	68 50 3c 80 00       	push   $0x803c50
  80041b:	6a 03                	push   $0x3
  80041d:	e8 ed 11 00 00       	call   80160f <cprintf_colored>
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
  8004df:	68 80 3c 80 00       	push   $0x803c80
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 24 11 00 00       	call   80160f <cprintf_colored>
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
  8005b9:	68 80 3c 80 00       	push   $0x803c80
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 4a 10 00 00       	call   80160f <cprintf_colored>
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
  800693:	68 80 3c 80 00       	push   $0x803c80
  800698:	6a 0c                	push   $0xc
  80069a:	e8 70 0f 00 00       	call   80160f <cprintf_colored>
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
  80076d:	68 80 3c 80 00       	push   $0x803c80
  800772:	6a 0c                	push   $0xc
  800774:	e8 96 0e 00 00       	call   80160f <cprintf_colored>
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
  800847:	68 80 3c 80 00       	push   $0x803c80
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 bc 0d 00 00       	call   80160f <cprintf_colored>
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
  800921:	68 80 3c 80 00       	push   $0x803c80
  800926:	6a 0c                	push   $0xc
  800928:	e8 e2 0c 00 00       	call   80160f <cprintf_colored>
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
  800a16:	68 80 3c 80 00       	push   $0x803c80
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 ed 0b 00 00       	call   80160f <cprintf_colored>
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
  800b14:	68 80 3c 80 00       	push   $0x803c80
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 ef 0a 00 00       	call   80160f <cprintf_colored>
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
  800c12:	68 80 3c 80 00       	push   $0x803c80
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 f1 09 00 00       	call   80160f <cprintf_colored>
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
  800d10:	68 80 3c 80 00       	push   $0x803c80
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 f3 08 00 00       	call   80160f <cprintf_colored>
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
  800dfd:	68 80 3c 80 00       	push   $0x803c80
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 06 08 00 00       	call   80160f <cprintf_colored>
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
  800eea:	68 80 3c 80 00       	push   $0x803c80
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 19 07 00 00       	call   80160f <cprintf_colored>
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
  800fd7:	68 80 3c 80 00       	push   $0x803c80
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 2c 06 00 00       	call   80160f <cprintf_colored>
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
  800ffa:	68 d2 3c 80 00       	push   $0x803cd2
  800fff:	6a 03                	push   $0x3
  801001:	e8 09 06 00 00       	call   80160f <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c d2 81 00 0d 	movl   $0xd,0x81d24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 7e 17 00 00       	call   80279d <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 be 17 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
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
  801055:	e8 4a 15 00 00       	call   8025a4 <malloc>
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
  801084:	68 f0 3c 80 00       	push   $0x803cf0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 7f 05 00 00       	call   80160f <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 50 17 00 00       	call   8027e8 <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 2c 3d 80 00       	push   $0x803d2c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 53 05 00 00       	call   80160f <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 d9 16 00 00       	call   80279d <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c d2 81 00       	mov    0x81d24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 9c 3d 80 00       	push   $0x803d9c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 27 05 00 00       	call   80160f <cprintf_colored>
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
  801102:	83 ec 08             	sub    $0x8,%esp
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801105:	83 ec 08             	sub    $0x8,%esp
  801108:	68 e4 3d 80 00       	push   $0x803de4
  80110d:	6a 0e                	push   $0xe
  80110f:	e8 fb 04 00 00       	call   80160f <cprintf_colored>
  801114:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	68 18 3e 80 00       	push   $0x803e18
  80111f:	6a 0e                	push   $0xe
  801121:	e8 e9 04 00 00       	call   80160f <cprintf_colored>
  801126:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  801129:	83 ec 08             	sub    $0x8,%esp
  80112c:	68 74 3e 80 00       	push   $0x803e74
  801131:	6a 0e                	push   $0xe
  801133:	e8 d7 04 00 00       	call   80160f <cprintf_colored>
  801138:	83 c4 10             	add    $0x10,%esp
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
			panic("Please increase the WS size");
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	68 ac 3e 80 00       	push   $0x803eac
  801143:	6a 1b                	push   $0x1b
  801145:	68 dd 3e 80 00       	push   $0x803edd
  80114a:	e8 c5 01 00 00       	call   801314 <_panic>

0080114f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	57                   	push   %edi
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
  801155:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  801158:	e8 09 18 00 00       	call   802966 <sys_getenvindex>
  80115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  801160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801163:	89 d0                	mov    %edx,%eax
  801165:	c1 e0 06             	shl    $0x6,%eax
  801168:	29 d0                	sub    %edx,%eax
  80116a:	c1 e0 02             	shl    $0x2,%eax
  80116d:	01 d0                	add    %edx,%eax
  80116f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801176:	01 c8                	add    %ecx,%eax
  801178:	c1 e0 03             	shl    $0x3,%eax
  80117b:	01 d0                	add    %edx,%eax
  80117d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801184:	29 c2                	sub    %eax,%edx
  801186:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80118d:	89 c2                	mov    %eax,%edx
  80118f:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801195:	a3 00 52 80 00       	mov    %eax,0x805200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80119a:	a1 00 52 80 00       	mov    0x805200,%eax
  80119f:	8a 40 20             	mov    0x20(%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	74 0d                	je     8011b3 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8011a6:	a1 00 52 80 00       	mov    0x805200,%eax
  8011ab:	83 c0 20             	add    $0x20,%eax
  8011ae:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b7:	7e 0a                	jle    8011c3 <libmain+0x74>
		binaryname = argv[0];
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	8b 00                	mov    (%eax),%eax
  8011be:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	ff 75 08             	pushl  0x8(%ebp)
  8011cc:	e8 2e ff ff ff       	call   8010ff <_main>
  8011d1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8011d4:	a1 00 50 80 00       	mov    0x805000,%eax
  8011d9:	85 c0                	test   %eax,%eax
  8011db:	0f 84 01 01 00 00    	je     8012e2 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8011e1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8011e7:	bb ec 3f 80 00       	mov    $0x803fec,%ebx
  8011ec:	ba 0e 00 00 00       	mov    $0xe,%edx
  8011f1:	89 c7                	mov    %eax,%edi
  8011f3:	89 de                	mov    %ebx,%esi
  8011f5:	89 d1                	mov    %edx,%ecx
  8011f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8011f9:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8011fc:	b9 56 00 00 00       	mov    $0x56,%ecx
  801201:	b0 00                	mov    $0x0,%al
  801203:	89 d7                	mov    %edx,%edi
  801205:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801207:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80120e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	50                   	push   %eax
  801215:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80121b:	50                   	push   %eax
  80121c:	e8 7b 19 00 00       	call   802b9c <sys_utilities>
  801221:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801224:	e8 c4 14 00 00       	call   8026ed <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801229:	83 ec 0c             	sub    $0xc,%esp
  80122c:	68 0c 3f 80 00       	push   $0x803f0c
  801231:	e8 ac 03 00 00       	call   8015e2 <cprintf>
  801236:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  801239:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123c:	85 c0                	test   %eax,%eax
  80123e:	74 18                	je     801258 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801240:	e8 75 19 00 00       	call   802bba <sys_get_optimal_num_faults>
  801245:	83 ec 08             	sub    $0x8,%esp
  801248:	50                   	push   %eax
  801249:	68 34 3f 80 00       	push   $0x803f34
  80124e:	e8 8f 03 00 00       	call   8015e2 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp
  801256:	eb 59                	jmp    8012b1 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801258:	a1 00 52 80 00       	mov    0x805200,%eax
  80125d:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  801263:	a1 00 52 80 00       	mov    0x805200,%eax
  801268:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80126e:	83 ec 04             	sub    $0x4,%esp
  801271:	52                   	push   %edx
  801272:	50                   	push   %eax
  801273:	68 58 3f 80 00       	push   $0x803f58
  801278:	e8 65 03 00 00       	call   8015e2 <cprintf>
  80127d:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801280:	a1 00 52 80 00       	mov    0x805200,%eax
  801285:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80128b:	a1 00 52 80 00       	mov    0x805200,%eax
  801290:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  801296:	a1 00 52 80 00       	mov    0x805200,%eax
  80129b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8012a1:	51                   	push   %ecx
  8012a2:	52                   	push   %edx
  8012a3:	50                   	push   %eax
  8012a4:	68 80 3f 80 00       	push   $0x803f80
  8012a9:	e8 34 03 00 00       	call   8015e2 <cprintf>
  8012ae:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8012b1:	a1 00 52 80 00       	mov    0x805200,%eax
  8012b6:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	50                   	push   %eax
  8012c0:	68 d8 3f 80 00       	push   $0x803fd8
  8012c5:	e8 18 03 00 00       	call   8015e2 <cprintf>
  8012ca:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8012cd:	83 ec 0c             	sub    $0xc,%esp
  8012d0:	68 0c 3f 80 00       	push   $0x803f0c
  8012d5:	e8 08 03 00 00       	call   8015e2 <cprintf>
  8012da:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8012dd:	e8 25 14 00 00       	call   802707 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8012e2:	e8 1f 00 00 00       	call   801306 <exit>
}
  8012e7:	90                   	nop
  8012e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	6a 00                	push   $0x0
  8012fb:	e8 32 16 00 00       	call   802932 <sys_destroy_env>
  801300:	83 c4 10             	add    $0x10,%esp
}
  801303:	90                   	nop
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <exit>:

void
exit(void)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80130c:	e8 87 16 00 00       	call   802998 <sys_exit_env>
}
  801311:	90                   	nop
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80131a:	8d 45 10             	lea    0x10(%ebp),%eax
  80131d:	83 c0 04             	add    $0x4,%eax
  801320:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801323:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801328:	85 c0                	test   %eax,%eax
  80132a:	74 16                	je     801342 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80132c:	a1 f8 d2 81 00       	mov    0x81d2f8,%eax
  801331:	83 ec 08             	sub    $0x8,%esp
  801334:	50                   	push   %eax
  801335:	68 50 40 80 00       	push   $0x804050
  80133a:	e8 a3 02 00 00       	call   8015e2 <cprintf>
  80133f:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801342:	a1 04 50 80 00       	mov    0x805004,%eax
  801347:	83 ec 0c             	sub    $0xc,%esp
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	ff 75 08             	pushl  0x8(%ebp)
  801350:	50                   	push   %eax
  801351:	68 58 40 80 00       	push   $0x804058
  801356:	6a 74                	push   $0x74
  801358:	e8 b2 02 00 00       	call   80160f <cprintf_colored>
  80135d:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  801360:	8b 45 10             	mov    0x10(%ebp),%eax
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	ff 75 f4             	pushl  -0xc(%ebp)
  801369:	50                   	push   %eax
  80136a:	e8 04 02 00 00       	call   801573 <vcprintf>
  80136f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	6a 00                	push   $0x0
  801377:	68 80 40 80 00       	push   $0x804080
  80137c:	e8 f2 01 00 00       	call   801573 <vcprintf>
  801381:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801384:	e8 7d ff ff ff       	call   801306 <exit>

	// should not return here
	while (1) ;
  801389:	eb fe                	jmp    801389 <_panic+0x75>

0080138b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801391:	a1 00 52 80 00       	mov    0x805200,%eax
  801396:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	39 c2                	cmp    %eax,%edx
  8013a1:	74 14                	je     8013b7 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 84 40 80 00       	push   $0x804084
  8013ab:	6a 26                	push   $0x26
  8013ad:	68 d0 40 80 00       	push   $0x8040d0
  8013b2:	e8 5d ff ff ff       	call   801314 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8013be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c5:	e9 c5 00 00 00       	jmp    80148f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8013ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	01 d0                	add    %edx,%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	75 08                	jne    8013e7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8013df:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8013e2:	e9 a5 00 00 00       	jmp    80148c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8013e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013ee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8013f5:	eb 69                	jmp    801460 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8013f7:	a1 00 52 80 00       	mov    0x805200,%eax
  8013fc:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801405:	89 d0                	mov    %edx,%eax
  801407:	01 c0                	add    %eax,%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c1 e0 03             	shl    $0x3,%eax
  80140e:	01 c8                	add    %ecx,%eax
  801410:	8a 40 04             	mov    0x4(%eax),%al
  801413:	84 c0                	test   %al,%al
  801415:	75 46                	jne    80145d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801417:	a1 00 52 80 00       	mov    0x805200,%eax
  80141c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801422:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801425:	89 d0                	mov    %edx,%eax
  801427:	01 c0                	add    %eax,%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	c1 e0 03             	shl    $0x3,%eax
  80142e:	01 c8                	add    %ecx,%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801435:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801442:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	01 c8                	add    %ecx,%eax
  80144e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801450:	39 c2                	cmp    %eax,%edx
  801452:	75 09                	jne    80145d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801454:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80145b:	eb 15                	jmp    801472 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80145d:	ff 45 e8             	incl   -0x18(%ebp)
  801460:	a1 00 52 80 00       	mov    0x805200,%eax
  801465:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80146b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146e:	39 c2                	cmp    %eax,%edx
  801470:	77 85                	ja     8013f7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801476:	75 14                	jne    80148c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	68 dc 40 80 00       	push   $0x8040dc
  801480:	6a 3a                	push   $0x3a
  801482:	68 d0 40 80 00       	push   $0x8040d0
  801487:	e8 88 fe ff ff       	call   801314 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80148c:	ff 45 f0             	incl   -0x10(%ebp)
  80148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801492:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801495:	0f 8c 2f ff ff ff    	jl     8013ca <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80149b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8014a9:	eb 26                	jmp    8014d1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8014ab:	a1 00 52 80 00       	mov    0x805200,%eax
  8014b0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8014b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b9:	89 d0                	mov    %edx,%eax
  8014bb:	01 c0                	add    %eax,%eax
  8014bd:	01 d0                	add    %edx,%eax
  8014bf:	c1 e0 03             	shl    $0x3,%eax
  8014c2:	01 c8                	add    %ecx,%eax
  8014c4:	8a 40 04             	mov    0x4(%eax),%al
  8014c7:	3c 01                	cmp    $0x1,%al
  8014c9:	75 03                	jne    8014ce <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8014cb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014ce:	ff 45 e0             	incl   -0x20(%ebp)
  8014d1:	a1 00 52 80 00       	mov    0x805200,%eax
  8014d6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8014dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	77 c8                	ja     8014ab <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8014e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014e9:	74 14                	je     8014ff <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8014eb:	83 ec 04             	sub    $0x4,%esp
  8014ee:	68 30 41 80 00       	push   $0x804130
  8014f3:	6a 44                	push   $0x44
  8014f5:	68 d0 40 80 00       	push   $0x8040d0
  8014fa:	e8 15 fe ff ff       	call   801314 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8014ff:	90                   	nop
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	53                   	push   %ebx
  801506:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150c:	8b 00                	mov    (%eax),%eax
  80150e:	8d 48 01             	lea    0x1(%eax),%ecx
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	89 0a                	mov    %ecx,(%edx)
  801516:	8b 55 08             	mov    0x8(%ebp),%edx
  801519:	88 d1                	mov    %dl,%cl
  80151b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151e:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801522:	8b 45 0c             	mov    0xc(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	3d ff 00 00 00       	cmp    $0xff,%eax
  80152c:	75 30                	jne    80155e <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80152e:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  801534:	a0 24 52 80 00       	mov    0x805224,%al
  801539:	0f b6 c0             	movzbl %al,%eax
  80153c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80153f:	8b 09                	mov    (%ecx),%ecx
  801541:	89 cb                	mov    %ecx,%ebx
  801543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801546:	83 c1 08             	add    $0x8,%ecx
  801549:	52                   	push   %edx
  80154a:	50                   	push   %eax
  80154b:	53                   	push   %ebx
  80154c:	51                   	push   %ecx
  80154d:	e8 57 11 00 00       	call   8026a9 <sys_cputs>
  801552:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	8b 40 04             	mov    0x4(%eax),%eax
  801564:	8d 50 01             	lea    0x1(%eax),%edx
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80156d:	90                   	nop
  80156e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80157c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801583:	00 00 00 
	b.cnt = 0;
  801586:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80158d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801590:	ff 75 0c             	pushl  0xc(%ebp)
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80159c:	50                   	push   %eax
  80159d:	68 02 15 80 00       	push   $0x801502
  8015a2:	e8 5a 02 00 00       	call   801801 <vprintfmt>
  8015a7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8015aa:	8b 15 fc d2 81 00    	mov    0x81d2fc,%edx
  8015b0:	a0 24 52 80 00       	mov    0x805224,%al
  8015b5:	0f b6 c0             	movzbl %al,%eax
  8015b8:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8015be:	52                   	push   %edx
  8015bf:	50                   	push   %eax
  8015c0:	51                   	push   %ecx
  8015c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8015c7:	83 c0 08             	add    $0x8,%eax
  8015ca:	50                   	push   %eax
  8015cb:	e8 d9 10 00 00       	call   8026a9 <sys_cputs>
  8015d0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8015d3:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
	return b.cnt;
  8015da:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8015e8:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	va_start(ap, fmt);
  8015ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8015f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	50                   	push   %eax
  8015ff:	e8 6f ff ff ff       	call   801573 <vcprintf>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801615:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
	curTextClr = (textClr << 8) ; //set text color by the given value
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	c1 e0 08             	shl    $0x8,%eax
  801622:	a3 fc d2 81 00       	mov    %eax,0x81d2fc
	va_start(ap, fmt);
  801627:	8d 45 0c             	lea    0xc(%ebp),%eax
  80162a:	83 c0 04             	add    $0x4,%eax
  80162d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801630:	8b 45 0c             	mov    0xc(%ebp),%eax
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	ff 75 f4             	pushl  -0xc(%ebp)
  801639:	50                   	push   %eax
  80163a:	e8 34 ff ff ff       	call   801573 <vcprintf>
  80163f:	83 c4 10             	add    $0x10,%esp
  801642:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801645:	c7 05 fc d2 81 00 00 	movl   $0x700,0x81d2fc
  80164c:	07 00 00 

	return cnt;
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80165a:	e8 8e 10 00 00       	call   8026ed <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80165f:	8d 45 0c             	lea    0xc(%ebp),%eax
  801662:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	83 ec 08             	sub    $0x8,%esp
  80166b:	ff 75 f4             	pushl  -0xc(%ebp)
  80166e:	50                   	push   %eax
  80166f:	e8 ff fe ff ff       	call   801573 <vcprintf>
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80167a:	e8 88 10 00 00       	call   802707 <sys_unlock_cons>
	return cnt;
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	53                   	push   %ebx
  801688:	83 ec 14             	sub    $0x14,%esp
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801691:	8b 45 14             	mov    0x14(%ebp),%eax
  801694:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801697:	8b 45 18             	mov    0x18(%ebp),%eax
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016a2:	77 55                	ja     8016f9 <printnum+0x75>
  8016a4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8016a7:	72 05                	jb     8016ae <printnum+0x2a>
  8016a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ac:	77 4b                	ja     8016f9 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8016ae:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8016b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8016b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c4:	e8 07 20 00 00       	call   8036d0 <__udivdi3>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	ff 75 20             	pushl  0x20(%ebp)
  8016d2:	53                   	push   %ebx
  8016d3:	ff 75 18             	pushl  0x18(%ebp)
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	e8 a1 ff ff ff       	call   801684 <printnum>
  8016e3:	83 c4 20             	add    $0x20,%esp
  8016e6:	eb 1a                	jmp    801702 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016e8:	83 ec 08             	sub    $0x8,%esp
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	ff 75 20             	pushl  0x20(%ebp)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016f9:	ff 4d 1c             	decl   0x1c(%ebp)
  8016fc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801700:	7f e6                	jg     8016e8 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801702:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801705:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801710:	53                   	push   %ebx
  801711:	51                   	push   %ecx
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	e8 c7 20 00 00       	call   8037e0 <__umoddi3>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	05 94 43 80 00       	add    $0x804394,%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	0f be c0             	movsbl %al,%eax
  801726:	83 ec 08             	sub    $0x8,%esp
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	50                   	push   %eax
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	ff d0                	call   *%eax
  801732:	83 c4 10             	add    $0x10,%esp
}
  801735:	90                   	nop
  801736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80173e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801742:	7e 1c                	jle    801760 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	8b 00                	mov    (%eax),%eax
  801749:	8d 50 08             	lea    0x8(%eax),%edx
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	89 10                	mov    %edx,(%eax)
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8b 00                	mov    (%eax),%eax
  801756:	83 e8 08             	sub    $0x8,%eax
  801759:	8b 50 04             	mov    0x4(%eax),%edx
  80175c:	8b 00                	mov    (%eax),%eax
  80175e:	eb 40                	jmp    8017a0 <getuint+0x65>
	else if (lflag)
  801760:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801764:	74 1e                	je     801784 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	8d 50 04             	lea    0x4(%eax),%edx
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 10                	mov    %edx,(%eax)
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8b 00                	mov    (%eax),%eax
  801778:	83 e8 04             	sub    $0x4,%eax
  80177b:	8b 00                	mov    (%eax),%eax
  80177d:	ba 00 00 00 00       	mov    $0x0,%edx
  801782:	eb 1c                	jmp    8017a0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 00                	mov    (%eax),%eax
  801789:	8d 50 04             	lea    0x4(%eax),%edx
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	89 10                	mov    %edx,(%eax)
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8b 00                	mov    (%eax),%eax
  801796:	83 e8 04             	sub    $0x4,%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017a5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017a9:	7e 1c                	jle    8017c7 <getint+0x25>
		return va_arg(*ap, long long);
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	8b 00                	mov    (%eax),%eax
  8017b0:	8d 50 08             	lea    0x8(%eax),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	89 10                	mov    %edx,(%eax)
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	83 e8 08             	sub    $0x8,%eax
  8017c0:	8b 50 04             	mov    0x4(%eax),%edx
  8017c3:	8b 00                	mov    (%eax),%eax
  8017c5:	eb 38                	jmp    8017ff <getint+0x5d>
	else if (lflag)
  8017c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017cb:	74 1a                	je     8017e7 <getint+0x45>
		return va_arg(*ap, long);
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	8b 00                	mov    (%eax),%eax
  8017d2:	8d 50 04             	lea    0x4(%eax),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	89 10                	mov    %edx,(%eax)
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8b 00                	mov    (%eax),%eax
  8017df:	83 e8 04             	sub    $0x4,%eax
  8017e2:	8b 00                	mov    (%eax),%eax
  8017e4:	99                   	cltd   
  8017e5:	eb 18                	jmp    8017ff <getint+0x5d>
	else
		return va_arg(*ap, int);
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	8d 50 04             	lea    0x4(%eax),%edx
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	89 10                	mov    %edx,(%eax)
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8b 00                	mov    (%eax),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	99                   	cltd   
}
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    

00801801 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	56                   	push   %esi
  801805:	53                   	push   %ebx
  801806:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801809:	eb 17                	jmp    801822 <vprintfmt+0x21>
			if (ch == '\0')
  80180b:	85 db                	test   %ebx,%ebx
  80180d:	0f 84 c1 03 00 00    	je     801bd4 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801813:	83 ec 08             	sub    $0x8,%esp
  801816:	ff 75 0c             	pushl  0xc(%ebp)
  801819:	53                   	push   %ebx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	ff d0                	call   *%eax
  80181f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801822:	8b 45 10             	mov    0x10(%ebp),%eax
  801825:	8d 50 01             	lea    0x1(%eax),%edx
  801828:	89 55 10             	mov    %edx,0x10(%ebp)
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f b6 d8             	movzbl %al,%ebx
  801830:	83 fb 25             	cmp    $0x25,%ebx
  801833:	75 d6                	jne    80180b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801835:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801839:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801840:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801847:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80184e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801855:	8b 45 10             	mov    0x10(%ebp),%eax
  801858:	8d 50 01             	lea    0x1(%eax),%edx
  80185b:	89 55 10             	mov    %edx,0x10(%ebp)
  80185e:	8a 00                	mov    (%eax),%al
  801860:	0f b6 d8             	movzbl %al,%ebx
  801863:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801866:	83 f8 5b             	cmp    $0x5b,%eax
  801869:	0f 87 3d 03 00 00    	ja     801bac <vprintfmt+0x3ab>
  80186f:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
  801876:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801878:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80187c:	eb d7                	jmp    801855 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80187e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801882:	eb d1                	jmp    801855 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801884:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80188b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80188e:	89 d0                	mov    %edx,%eax
  801890:	c1 e0 02             	shl    $0x2,%eax
  801893:	01 d0                	add    %edx,%eax
  801895:	01 c0                	add    %eax,%eax
  801897:	01 d8                	add    %ebx,%eax
  801899:	83 e8 30             	sub    $0x30,%eax
  80189c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80189f:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a2:	8a 00                	mov    (%eax),%al
  8018a4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8018a7:	83 fb 2f             	cmp    $0x2f,%ebx
  8018aa:	7e 3e                	jle    8018ea <vprintfmt+0xe9>
  8018ac:	83 fb 39             	cmp    $0x39,%ebx
  8018af:	7f 39                	jg     8018ea <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8018b1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8018b4:	eb d5                	jmp    80188b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8018b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b9:	83 c0 04             	add    $0x4,%eax
  8018bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8018bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c2:	83 e8 04             	sub    $0x4,%eax
  8018c5:	8b 00                	mov    (%eax),%eax
  8018c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8018ca:	eb 1f                	jmp    8018eb <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8018cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018d0:	79 83                	jns    801855 <vprintfmt+0x54>
				width = 0;
  8018d2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8018d9:	e9 77 ff ff ff       	jmp    801855 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8018de:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8018e5:	e9 6b ff ff ff       	jmp    801855 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8018ea:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8018eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018ef:	0f 89 60 ff ff ff    	jns    801855 <vprintfmt+0x54>
				width = precision, precision = -1;
  8018f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018fb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801902:	e9 4e ff ff ff       	jmp    801855 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801907:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80190a:	e9 46 ff ff ff       	jmp    801855 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80190f:	8b 45 14             	mov    0x14(%ebp),%eax
  801912:	83 c0 04             	add    $0x4,%eax
  801915:	89 45 14             	mov    %eax,0x14(%ebp)
  801918:	8b 45 14             	mov    0x14(%ebp),%eax
  80191b:	83 e8 04             	sub    $0x4,%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	83 ec 08             	sub    $0x8,%esp
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	50                   	push   %eax
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	ff d0                	call   *%eax
  80192c:	83 c4 10             	add    $0x10,%esp
			break;
  80192f:	e9 9b 02 00 00       	jmp    801bcf <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801934:	8b 45 14             	mov    0x14(%ebp),%eax
  801937:	83 c0 04             	add    $0x4,%eax
  80193a:	89 45 14             	mov    %eax,0x14(%ebp)
  80193d:	8b 45 14             	mov    0x14(%ebp),%eax
  801940:	83 e8 04             	sub    $0x4,%eax
  801943:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801945:	85 db                	test   %ebx,%ebx
  801947:	79 02                	jns    80194b <vprintfmt+0x14a>
				err = -err;
  801949:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80194b:	83 fb 64             	cmp    $0x64,%ebx
  80194e:	7f 0b                	jg     80195b <vprintfmt+0x15a>
  801950:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  801957:	85 f6                	test   %esi,%esi
  801959:	75 19                	jne    801974 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80195b:	53                   	push   %ebx
  80195c:	68 a5 43 80 00       	push   $0x8043a5
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	e8 70 02 00 00       	call   801bdc <printfmt>
  80196c:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80196f:	e9 5b 02 00 00       	jmp    801bcf <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801974:	56                   	push   %esi
  801975:	68 ae 43 80 00       	push   $0x8043ae
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 57 02 00 00       	call   801bdc <printfmt>
  801985:	83 c4 10             	add    $0x10,%esp
			break;
  801988:	e9 42 02 00 00       	jmp    801bcf <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	83 c0 04             	add    $0x4,%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
  801996:	8b 45 14             	mov    0x14(%ebp),%eax
  801999:	83 e8 04             	sub    $0x4,%eax
  80199c:	8b 30                	mov    (%eax),%esi
  80199e:	85 f6                	test   %esi,%esi
  8019a0:	75 05                	jne    8019a7 <vprintfmt+0x1a6>
				p = "(null)";
  8019a2:	be b1 43 80 00       	mov    $0x8043b1,%esi
			if (width > 0 && padc != '-')
  8019a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019ab:	7e 6d                	jle    801a1a <vprintfmt+0x219>
  8019ad:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8019b1:	74 67                	je     801a1a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8019b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	50                   	push   %eax
  8019ba:	56                   	push   %esi
  8019bb:	e8 1e 03 00 00       	call   801cde <strnlen>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8019c6:	eb 16                	jmp    8019de <vprintfmt+0x1dd>
					putch(padc, putdat);
  8019c8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	ff d0                	call   *%eax
  8019d8:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8019db:	ff 4d e4             	decl   -0x1c(%ebp)
  8019de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019e2:	7f e4                	jg     8019c8 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8019e4:	eb 34                	jmp    801a1a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8019e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019ea:	74 1c                	je     801a08 <vprintfmt+0x207>
  8019ec:	83 fb 1f             	cmp    $0x1f,%ebx
  8019ef:	7e 05                	jle    8019f6 <vprintfmt+0x1f5>
  8019f1:	83 fb 7e             	cmp    $0x7e,%ebx
  8019f4:	7e 12                	jle    801a08 <vprintfmt+0x207>
					putch('?', putdat);
  8019f6:	83 ec 08             	sub    $0x8,%esp
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	6a 3f                	push   $0x3f
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	ff d0                	call   *%eax
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	eb 0f                	jmp    801a17 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	53                   	push   %ebx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	ff d0                	call   *%eax
  801a14:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a17:	ff 4d e4             	decl   -0x1c(%ebp)
  801a1a:	89 f0                	mov    %esi,%eax
  801a1c:	8d 70 01             	lea    0x1(%eax),%esi
  801a1f:	8a 00                	mov    (%eax),%al
  801a21:	0f be d8             	movsbl %al,%ebx
  801a24:	85 db                	test   %ebx,%ebx
  801a26:	74 24                	je     801a4c <vprintfmt+0x24b>
  801a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a2c:	78 b8                	js     8019e6 <vprintfmt+0x1e5>
  801a2e:	ff 4d e0             	decl   -0x20(%ebp)
  801a31:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a35:	79 af                	jns    8019e6 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a37:	eb 13                	jmp    801a4c <vprintfmt+0x24b>
				putch(' ', putdat);
  801a39:	83 ec 08             	sub    $0x8,%esp
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	6a 20                	push   $0x20
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	ff d0                	call   *%eax
  801a46:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801a49:	ff 4d e4             	decl   -0x1c(%ebp)
  801a4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a50:	7f e7                	jg     801a39 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801a52:	e9 78 01 00 00       	jmp    801bcf <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801a57:	83 ec 08             	sub    $0x8,%esp
  801a5a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a5d:	8d 45 14             	lea    0x14(%ebp),%eax
  801a60:	50                   	push   %eax
  801a61:	e8 3c fd ff ff       	call   8017a2 <getint>
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a75:	85 d2                	test   %edx,%edx
  801a77:	79 23                	jns    801a9c <vprintfmt+0x29b>
				putch('-', putdat);
  801a79:	83 ec 08             	sub    $0x8,%esp
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	6a 2d                	push   $0x2d
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	ff d0                	call   *%eax
  801a86:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a8f:	f7 d8                	neg    %eax
  801a91:	83 d2 00             	adc    $0x0,%edx
  801a94:	f7 da                	neg    %edx
  801a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801a9c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801aa3:	e9 bc 00 00 00       	jmp    801b64 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801aa8:	83 ec 08             	sub    $0x8,%esp
  801aab:	ff 75 e8             	pushl  -0x18(%ebp)
  801aae:	8d 45 14             	lea    0x14(%ebp),%eax
  801ab1:	50                   	push   %eax
  801ab2:	e8 84 fc ff ff       	call   80173b <getuint>
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801ac0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ac7:	e9 98 00 00 00       	jmp    801b64 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	6a 58                	push   $0x58
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	ff d0                	call   *%eax
  801ad9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	6a 58                	push   $0x58
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	ff d0                	call   *%eax
  801ae9:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801aec:	83 ec 08             	sub    $0x8,%esp
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	6a 58                	push   $0x58
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	ff d0                	call   *%eax
  801af9:	83 c4 10             	add    $0x10,%esp
			break;
  801afc:	e9 ce 00 00 00       	jmp    801bcf <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	ff 75 0c             	pushl  0xc(%ebp)
  801b07:	6a 30                	push   $0x30
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	ff d0                	call   *%eax
  801b0e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	6a 78                	push   $0x78
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	ff d0                	call   *%eax
  801b1e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	83 c0 04             	add    $0x4,%eax
  801b27:	89 45 14             	mov    %eax,0x14(%ebp)
  801b2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2d:	83 e8 04             	sub    $0x4,%eax
  801b30:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801b3c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801b43:	eb 1f                	jmp    801b64 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801b45:	83 ec 08             	sub    $0x8,%esp
  801b48:	ff 75 e8             	pushl  -0x18(%ebp)
  801b4b:	8d 45 14             	lea    0x14(%ebp),%eax
  801b4e:	50                   	push   %eax
  801b4f:	e8 e7 fb ff ff       	call   80173b <getuint>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801b5d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801b64:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	52                   	push   %edx
  801b6f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b72:	50                   	push   %eax
  801b73:	ff 75 f4             	pushl  -0xc(%ebp)
  801b76:	ff 75 f0             	pushl  -0x10(%ebp)
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	e8 00 fb ff ff       	call   801684 <printnum>
  801b84:	83 c4 20             	add    $0x20,%esp
			break;
  801b87:	eb 46                	jmp    801bcf <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801b89:	83 ec 08             	sub    $0x8,%esp
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	53                   	push   %ebx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	ff d0                	call   *%eax
  801b95:	83 c4 10             	add    $0x10,%esp
			break;
  801b98:	eb 35                	jmp    801bcf <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801b9a:	c6 05 24 52 80 00 00 	movb   $0x0,0x805224
			break;
  801ba1:	eb 2c                	jmp    801bcf <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801ba3:	c6 05 24 52 80 00 01 	movb   $0x1,0x805224
			break;
  801baa:	eb 23                	jmp    801bcf <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	6a 25                	push   $0x25
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	ff d0                	call   *%eax
  801bb9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801bbc:	ff 4d 10             	decl   0x10(%ebp)
  801bbf:	eb 03                	jmp    801bc4 <vprintfmt+0x3c3>
  801bc1:	ff 4d 10             	decl   0x10(%ebp)
  801bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc7:	48                   	dec    %eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	3c 25                	cmp    $0x25,%al
  801bcc:	75 f3                	jne    801bc1 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801bce:	90                   	nop
		}
	}
  801bcf:	e9 35 fc ff ff       	jmp    801809 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801bd4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801be2:	8d 45 10             	lea    0x10(%ebp),%eax
  801be5:	83 c0 04             	add    $0x4,%eax
  801be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801beb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bee:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf1:	50                   	push   %eax
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	e8 04 fc ff ff       	call   801801 <vprintfmt>
  801bfd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801c00:	90                   	nop
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	8b 40 08             	mov    0x8(%eax),%eax
  801c0c:	8d 50 01             	lea    0x1(%eax),%edx
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	8b 10                	mov    (%eax),%edx
  801c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1d:	8b 40 04             	mov    0x4(%eax),%eax
  801c20:	39 c2                	cmp    %eax,%edx
  801c22:	73 12                	jae    801c36 <sprintputch+0x33>
		*b->buf++ = ch;
  801c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c27:	8b 00                	mov    (%eax),%eax
  801c29:	8d 48 01             	lea    0x1(%eax),%ecx
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	89 0a                	mov    %ecx,(%edx)
  801c31:	8b 55 08             	mov    0x8(%ebp),%edx
  801c34:	88 10                	mov    %dl,(%eax)
}
  801c36:	90                   	nop
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	01 d0                	add    %edx,%eax
  801c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801c5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c5e:	74 06                	je     801c66 <vsnprintf+0x2d>
  801c60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c64:	7f 07                	jg     801c6d <vsnprintf+0x34>
		return -E_INVAL;
  801c66:	b8 03 00 00 00       	mov    $0x3,%eax
  801c6b:	eb 20                	jmp    801c8d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801c6d:	ff 75 14             	pushl  0x14(%ebp)
  801c70:	ff 75 10             	pushl  0x10(%ebp)
  801c73:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801c76:	50                   	push   %eax
  801c77:	68 03 1c 80 00       	push   $0x801c03
  801c7c:	e8 80 fb ff ff       	call   801801 <vprintfmt>
  801c81:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c87:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801c95:	8d 45 10             	lea    0x10(%ebp),%eax
  801c98:	83 c0 04             	add    $0x4,%eax
  801c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca4:	50                   	push   %eax
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	e8 89 ff ff ff       	call   801c39 <vsnprintf>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801cc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cc8:	eb 06                	jmp    801cd0 <strlen+0x15>
		n++;
  801cca:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ccd:	ff 45 08             	incl   0x8(%ebp)
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	8a 00                	mov    (%eax),%al
  801cd5:	84 c0                	test   %al,%al
  801cd7:	75 f1                	jne    801cca <strlen+0xf>
		n++;
	return n;
  801cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ce4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ceb:	eb 09                	jmp    801cf6 <strnlen+0x18>
		n++;
  801ced:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801cf0:	ff 45 08             	incl   0x8(%ebp)
  801cf3:	ff 4d 0c             	decl   0xc(%ebp)
  801cf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cfa:	74 09                	je     801d05 <strnlen+0x27>
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	8a 00                	mov    (%eax),%al
  801d01:	84 c0                	test   %al,%al
  801d03:	75 e8                	jne    801ced <strnlen+0xf>
		n++;
	return n;
  801d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d16:	90                   	nop
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8d 50 01             	lea    0x1(%eax),%edx
  801d1d:	89 55 08             	mov    %edx,0x8(%ebp)
  801d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d23:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d26:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d29:	8a 12                	mov    (%edx),%dl
  801d2b:	88 10                	mov    %dl,(%eax)
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	84 c0                	test   %al,%al
  801d31:	75 e4                	jne    801d17 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801d44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d4b:	eb 1f                	jmp    801d6c <strncpy+0x34>
		*dst++ = *src;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8d 50 01             	lea    0x1(%eax),%edx
  801d53:	89 55 08             	mov    %edx,0x8(%ebp)
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8a 12                	mov    (%edx),%dl
  801d5b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d60:	8a 00                	mov    (%eax),%al
  801d62:	84 c0                	test   %al,%al
  801d64:	74 03                	je     801d69 <strncpy+0x31>
			src++;
  801d66:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801d69:	ff 45 fc             	incl   -0x4(%ebp)
  801d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d72:	72 d9                	jb     801d4d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801d74:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801d85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d89:	74 30                	je     801dbb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801d8b:	eb 16                	jmp    801da3 <strlcpy+0x2a>
			*dst++ = *src++;
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	8d 50 01             	lea    0x1(%eax),%edx
  801d93:	89 55 08             	mov    %edx,0x8(%ebp)
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d9c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d9f:	8a 12                	mov    (%edx),%dl
  801da1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801da3:	ff 4d 10             	decl   0x10(%ebp)
  801da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801daa:	74 09                	je     801db5 <strlcpy+0x3c>
  801dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daf:	8a 00                	mov    (%eax),%al
  801db1:	84 c0                	test   %al,%al
  801db3:	75 d8                	jne    801d8d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc1:	29 c2                	sub    %eax,%edx
  801dc3:	89 d0                	mov    %edx,%eax
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801dca:	eb 06                	jmp    801dd2 <strcmp+0xb>
		p++, q++;
  801dcc:	ff 45 08             	incl   0x8(%ebp)
  801dcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	8a 00                	mov    (%eax),%al
  801dd7:	84 c0                	test   %al,%al
  801dd9:	74 0e                	je     801de9 <strcmp+0x22>
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	8a 10                	mov    (%eax),%dl
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	8a 00                	mov    (%eax),%al
  801de5:	38 c2                	cmp    %al,%dl
  801de7:	74 e3                	je     801dcc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8a 00                	mov    (%eax),%al
  801dee:	0f b6 d0             	movzbl %al,%edx
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	8a 00                	mov    (%eax),%al
  801df6:	0f b6 c0             	movzbl %al,%eax
  801df9:	29 c2                	sub    %eax,%edx
  801dfb:	89 d0                	mov    %edx,%eax
}
  801dfd:	5d                   	pop    %ebp
  801dfe:	c3                   	ret    

00801dff <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e02:	eb 09                	jmp    801e0d <strncmp+0xe>
		n--, p++, q++;
  801e04:	ff 4d 10             	decl   0x10(%ebp)
  801e07:	ff 45 08             	incl   0x8(%ebp)
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e11:	74 17                	je     801e2a <strncmp+0x2b>
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	8a 00                	mov    (%eax),%al
  801e18:	84 c0                	test   %al,%al
  801e1a:	74 0e                	je     801e2a <strncmp+0x2b>
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	8a 10                	mov    (%eax),%dl
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	8a 00                	mov    (%eax),%al
  801e26:	38 c2                	cmp    %al,%dl
  801e28:	74 da                	je     801e04 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2e:	75 07                	jne    801e37 <strncmp+0x38>
		return 0;
  801e30:	b8 00 00 00 00       	mov    $0x0,%eax
  801e35:	eb 14                	jmp    801e4b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8a 00                	mov    (%eax),%al
  801e3c:	0f b6 d0             	movzbl %al,%edx
  801e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e42:	8a 00                	mov    (%eax),%al
  801e44:	0f b6 c0             	movzbl %al,%eax
  801e47:	29 c2                	sub    %eax,%edx
  801e49:	89 d0                	mov    %edx,%eax
}
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    

00801e4d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e56:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e59:	eb 12                	jmp    801e6d <strchr+0x20>
		if (*s == c)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8a 00                	mov    (%eax),%al
  801e60:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e63:	75 05                	jne    801e6a <strchr+0x1d>
			return (char *) s;
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	eb 11                	jmp    801e7b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801e6a:	ff 45 08             	incl   0x8(%ebp)
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8a 00                	mov    (%eax),%al
  801e72:	84 c0                	test   %al,%al
  801e74:	75 e5                	jne    801e5b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e86:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801e89:	eb 0d                	jmp    801e98 <strfind+0x1b>
		if (*s == c)
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8a 00                	mov    (%eax),%al
  801e90:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801e93:	74 0e                	je     801ea3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801e95:	ff 45 08             	incl   0x8(%ebp)
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	8a 00                	mov    (%eax),%al
  801e9d:	84 c0                	test   %al,%al
  801e9f:	75 ea                	jne    801e8b <strfind+0xe>
  801ea1:	eb 01                	jmp    801ea4 <strfind+0x27>
		if (*s == c)
			break;
  801ea3:	90                   	nop
	return (char *) s;
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801eb5:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801eb9:	76 63                	jbe    801f1e <memset+0x75>
		uint64 data_block = c;
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	99                   	cltd   
  801ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec2:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecb:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801ecf:	c1 e0 08             	shl    $0x8,%eax
  801ed2:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ed5:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801ee2:	c1 e0 10             	shl    $0x10,%eax
  801ee5:	09 45 f0             	or     %eax,-0x10(%ebp)
  801ee8:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef1:	89 c2                	mov    %eax,%edx
  801ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef8:	09 45 f0             	or     %eax,-0x10(%ebp)
  801efb:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801efe:	eb 18                	jmp    801f18 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f00:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f03:	8d 41 08             	lea    0x8(%ecx),%eax
  801f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0f:	89 01                	mov    %eax,(%ecx)
  801f11:	89 51 04             	mov    %edx,0x4(%ecx)
  801f14:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801f18:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f1c:	77 e2                	ja     801f00 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801f1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f22:	74 23                	je     801f47 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f2a:	eb 0e                	jmp    801f3a <memset+0x91>
			*p8++ = (uint8)c;
  801f2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f2f:	8d 50 01             	lea    0x1(%eax),%edx
  801f32:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f38:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801f40:	89 55 10             	mov    %edx,0x10(%ebp)
  801f43:	85 c0                	test   %eax,%eax
  801f45:	75 e5                	jne    801f2c <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801f5e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f62:	76 24                	jbe    801f88 <memcpy+0x3c>
		while(n >= 8){
  801f64:	eb 1c                	jmp    801f82 <memcpy+0x36>
			*d64 = *s64;
  801f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f69:	8b 50 04             	mov    0x4(%eax),%edx
  801f6c:	8b 00                	mov    (%eax),%eax
  801f6e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f71:	89 01                	mov    %eax,(%ecx)
  801f73:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801f76:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801f7a:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801f7e:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801f82:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f86:	77 de                	ja     801f66 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801f88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f8c:	74 31                	je     801fbf <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801f94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801f9a:	eb 16                	jmp    801fb2 <memcpy+0x66>
			*d8++ = *s8++;
  801f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9f:	8d 50 01             	lea    0x1(%eax),%edx
  801fa2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fab:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801fae:	8a 12                	mov    (%edx),%dl
  801fb0:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	75 dd                	jne    801f9c <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fdc:	73 50                	jae    80202e <memmove+0x6a>
  801fde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe4:	01 d0                	add    %edx,%eax
  801fe6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fe9:	76 43                	jbe    80202e <memmove+0x6a>
		s += n;
  801feb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fee:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801ff7:	eb 10                	jmp    802009 <memmove+0x45>
			*--d = *--s;
  801ff9:	ff 4d f8             	decl   -0x8(%ebp)
  801ffc:	ff 4d fc             	decl   -0x4(%ebp)
  801fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802002:	8a 10                	mov    (%eax),%dl
  802004:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802007:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802009:	8b 45 10             	mov    0x10(%ebp),%eax
  80200c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80200f:	89 55 10             	mov    %edx,0x10(%ebp)
  802012:	85 c0                	test   %eax,%eax
  802014:	75 e3                	jne    801ff9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802016:	eb 23                	jmp    80203b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80201b:	8d 50 01             	lea    0x1(%eax),%edx
  80201e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802021:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802024:	8d 4a 01             	lea    0x1(%edx),%ecx
  802027:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80202a:	8a 12                	mov    (%edx),%dl
  80202c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80202e:	8b 45 10             	mov    0x10(%ebp),%eax
  802031:	8d 50 ff             	lea    -0x1(%eax),%edx
  802034:	89 55 10             	mov    %edx,0x10(%ebp)
  802037:	85 c0                	test   %eax,%eax
  802039:	75 dd                	jne    802018 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80204c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802052:	eb 2a                	jmp    80207e <memcmp+0x3e>
		if (*s1 != *s2)
  802054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802057:	8a 10                	mov    (%eax),%dl
  802059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80205c:	8a 00                	mov    (%eax),%al
  80205e:	38 c2                	cmp    %al,%dl
  802060:	74 16                	je     802078 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802062:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802065:	8a 00                	mov    (%eax),%al
  802067:	0f b6 d0             	movzbl %al,%edx
  80206a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80206d:	8a 00                	mov    (%eax),%al
  80206f:	0f b6 c0             	movzbl %al,%eax
  802072:	29 c2                	sub    %eax,%edx
  802074:	89 d0                	mov    %edx,%eax
  802076:	eb 18                	jmp    802090 <memcmp+0x50>
		s1++, s2++;
  802078:	ff 45 fc             	incl   -0x4(%ebp)
  80207b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80207e:	8b 45 10             	mov    0x10(%ebp),%eax
  802081:	8d 50 ff             	lea    -0x1(%eax),%edx
  802084:	89 55 10             	mov    %edx,0x10(%ebp)
  802087:	85 c0                	test   %eax,%eax
  802089:	75 c9                	jne    802054 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802098:	8b 55 08             	mov    0x8(%ebp),%edx
  80209b:	8b 45 10             	mov    0x10(%ebp),%eax
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8020a3:	eb 15                	jmp    8020ba <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	8a 00                	mov    (%eax),%al
  8020aa:	0f b6 d0             	movzbl %al,%edx
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	0f b6 c0             	movzbl %al,%eax
  8020b3:	39 c2                	cmp    %eax,%edx
  8020b5:	74 0d                	je     8020c4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020b7:	ff 45 08             	incl   0x8(%ebp)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020c0:	72 e3                	jb     8020a5 <memfind+0x13>
  8020c2:	eb 01                	jmp    8020c5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020c4:	90                   	nop
	return (void *) s;
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020de:	eb 03                	jmp    8020e3 <strtol+0x19>
		s++;
  8020e0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	8a 00                	mov    (%eax),%al
  8020e8:	3c 20                	cmp    $0x20,%al
  8020ea:	74 f4                	je     8020e0 <strtol+0x16>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	8a 00                	mov    (%eax),%al
  8020f1:	3c 09                	cmp    $0x9,%al
  8020f3:	74 eb                	je     8020e0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	8a 00                	mov    (%eax),%al
  8020fa:	3c 2b                	cmp    $0x2b,%al
  8020fc:	75 05                	jne    802103 <strtol+0x39>
		s++;
  8020fe:	ff 45 08             	incl   0x8(%ebp)
  802101:	eb 13                	jmp    802116 <strtol+0x4c>
	else if (*s == '-')
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8a 00                	mov    (%eax),%al
  802108:	3c 2d                	cmp    $0x2d,%al
  80210a:	75 0a                	jne    802116 <strtol+0x4c>
		s++, neg = 1;
  80210c:	ff 45 08             	incl   0x8(%ebp)
  80210f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80211a:	74 06                	je     802122 <strtol+0x58>
  80211c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802120:	75 20                	jne    802142 <strtol+0x78>
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	8a 00                	mov    (%eax),%al
  802127:	3c 30                	cmp    $0x30,%al
  802129:	75 17                	jne    802142 <strtol+0x78>
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	40                   	inc    %eax
  80212f:	8a 00                	mov    (%eax),%al
  802131:	3c 78                	cmp    $0x78,%al
  802133:	75 0d                	jne    802142 <strtol+0x78>
		s += 2, base = 16;
  802135:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802139:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802140:	eb 28                	jmp    80216a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802142:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802146:	75 15                	jne    80215d <strtol+0x93>
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8a 00                	mov    (%eax),%al
  80214d:	3c 30                	cmp    $0x30,%al
  80214f:	75 0c                	jne    80215d <strtol+0x93>
		s++, base = 8;
  802151:	ff 45 08             	incl   0x8(%ebp)
  802154:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80215b:	eb 0d                	jmp    80216a <strtol+0xa0>
	else if (base == 0)
  80215d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802161:	75 07                	jne    80216a <strtol+0xa0>
		base = 10;
  802163:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	8a 00                	mov    (%eax),%al
  80216f:	3c 2f                	cmp    $0x2f,%al
  802171:	7e 19                	jle    80218c <strtol+0xc2>
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	8a 00                	mov    (%eax),%al
  802178:	3c 39                	cmp    $0x39,%al
  80217a:	7f 10                	jg     80218c <strtol+0xc2>
			dig = *s - '0';
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8a 00                	mov    (%eax),%al
  802181:	0f be c0             	movsbl %al,%eax
  802184:	83 e8 30             	sub    $0x30,%eax
  802187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218a:	eb 42                	jmp    8021ce <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8a 00                	mov    (%eax),%al
  802191:	3c 60                	cmp    $0x60,%al
  802193:	7e 19                	jle    8021ae <strtol+0xe4>
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8a 00                	mov    (%eax),%al
  80219a:	3c 7a                	cmp    $0x7a,%al
  80219c:	7f 10                	jg     8021ae <strtol+0xe4>
			dig = *s - 'a' + 10;
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8a 00                	mov    (%eax),%al
  8021a3:	0f be c0             	movsbl %al,%eax
  8021a6:	83 e8 57             	sub    $0x57,%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	eb 20                	jmp    8021ce <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8a 00                	mov    (%eax),%al
  8021b3:	3c 40                	cmp    $0x40,%al
  8021b5:	7e 39                	jle    8021f0 <strtol+0x126>
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	8a 00                	mov    (%eax),%al
  8021bc:	3c 5a                	cmp    $0x5a,%al
  8021be:	7f 30                	jg     8021f0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	8a 00                	mov    (%eax),%al
  8021c5:	0f be c0             	movsbl %al,%eax
  8021c8:	83 e8 37             	sub    $0x37,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021d4:	7d 19                	jge    8021ef <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021d6:	ff 45 08             	incl   0x8(%ebp)
  8021d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021dc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	01 d0                	add    %edx,%eax
  8021e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021ea:	e9 7b ff ff ff       	jmp    80216a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021ef:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021f4:	74 08                	je     8021fe <strtol+0x134>
		*endptr = (char *) s;
  8021f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802202:	74 07                	je     80220b <strtol+0x141>
  802204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802207:	f7 d8                	neg    %eax
  802209:	eb 03                	jmp    80220e <strtol+0x144>
  80220b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <ltostr>:

void
ltostr(long value, char *str)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802216:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80221d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802224:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802228:	79 13                	jns    80223d <ltostr+0x2d>
	{
		neg = 1;
  80222a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802231:	8b 45 0c             	mov    0xc(%ebp),%eax
  802234:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802237:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80223a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802245:	99                   	cltd   
  802246:	f7 f9                	idiv   %ecx
  802248:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80224b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80224e:	8d 50 01             	lea    0x1(%eax),%edx
  802251:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802254:	89 c2                	mov    %eax,%edx
  802256:	8b 45 0c             	mov    0xc(%ebp),%eax
  802259:	01 d0                	add    %edx,%eax
  80225b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80225e:	83 c2 30             	add    $0x30,%edx
  802261:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802266:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80226b:	f7 e9                	imul   %ecx
  80226d:	c1 fa 02             	sar    $0x2,%edx
  802270:	89 c8                	mov    %ecx,%eax
  802272:	c1 f8 1f             	sar    $0x1f,%eax
  802275:	29 c2                	sub    %eax,%edx
  802277:	89 d0                	mov    %edx,%eax
  802279:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80227c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802280:	75 bb                	jne    80223d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802282:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228c:	48                   	dec    %eax
  80228d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802290:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802294:	74 3d                	je     8022d3 <ltostr+0xc3>
		start = 1 ;
  802296:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80229d:	eb 34                	jmp    8022d3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80229f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	8a 00                	mov    (%eax),%al
  8022a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b2:	01 c2                	add    %eax,%edx
  8022b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ba:	01 c8                	add    %ecx,%eax
  8022bc:	8a 00                	mov    (%eax),%al
  8022be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8022cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022d9:	7c c4                	jl     80229f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	01 d0                	add    %edx,%eax
  8022e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8022ef:	ff 75 08             	pushl  0x8(%ebp)
  8022f2:	e8 c4 f9 ff ff       	call   801cbb <strlen>
  8022f7:	83 c4 04             	add    $0x4,%esp
  8022fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8022fd:	ff 75 0c             	pushl  0xc(%ebp)
  802300:	e8 b6 f9 ff ff       	call   801cbb <strlen>
  802305:	83 c4 04             	add    $0x4,%esp
  802308:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80230b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802312:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802319:	eb 17                	jmp    802332 <strcconcat+0x49>
		final[s] = str1[s] ;
  80231b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80231e:	8b 45 10             	mov    0x10(%ebp),%eax
  802321:	01 c2                	add    %eax,%edx
  802323:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	01 c8                	add    %ecx,%eax
  80232b:	8a 00                	mov    (%eax),%al
  80232d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80232f:	ff 45 fc             	incl   -0x4(%ebp)
  802332:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802335:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802338:	7c e1                	jl     80231b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80233a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802341:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802348:	eb 1f                	jmp    802369 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80234a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234d:	8d 50 01             	lea    0x1(%eax),%edx
  802350:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802353:	89 c2                	mov    %eax,%edx
  802355:	8b 45 10             	mov    0x10(%ebp),%eax
  802358:	01 c2                	add    %eax,%edx
  80235a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80235d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802360:	01 c8                	add    %ecx,%eax
  802362:	8a 00                	mov    (%eax),%al
  802364:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802366:	ff 45 f8             	incl   -0x8(%ebp)
  802369:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80236c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80236f:	7c d9                	jl     80234a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802371:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802374:	8b 45 10             	mov    0x10(%ebp),%eax
  802377:	01 d0                	add    %edx,%eax
  802379:	c6 00 00             	movb   $0x0,(%eax)
}
  80237c:	90                   	nop
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802382:	8b 45 14             	mov    0x14(%ebp),%eax
  802385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80238b:	8b 45 14             	mov    0x14(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802397:	8b 45 10             	mov    0x10(%ebp),%eax
  80239a:	01 d0                	add    %edx,%eax
  80239c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023a2:	eb 0c                	jmp    8023b0 <strsplit+0x31>
			*string++ = 0;
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8d 50 01             	lea    0x1(%eax),%edx
  8023aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8023ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8a 00                	mov    (%eax),%al
  8023b5:	84 c0                	test   %al,%al
  8023b7:	74 18                	je     8023d1 <strsplit+0x52>
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8a 00                	mov    (%eax),%al
  8023be:	0f be c0             	movsbl %al,%eax
  8023c1:	50                   	push   %eax
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	e8 83 fa ff ff       	call   801e4d <strchr>
  8023ca:	83 c4 08             	add    $0x8,%esp
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	75 d3                	jne    8023a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	8a 00                	mov    (%eax),%al
  8023d6:	84 c0                	test   %al,%al
  8023d8:	74 5a                	je     802434 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023da:	8b 45 14             	mov    0x14(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	83 f8 0f             	cmp    $0xf,%eax
  8023e2:	75 07                	jne    8023eb <strsplit+0x6c>
		{
			return 0;
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	eb 66                	jmp    802451 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8023f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8023f6:	89 0a                	mov    %ecx,(%edx)
  8023f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802402:	01 c2                	add    %eax,%edx
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802409:	eb 03                	jmp    80240e <strsplit+0x8f>
			string++;
  80240b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8a 00                	mov    (%eax),%al
  802413:	84 c0                	test   %al,%al
  802415:	74 8b                	je     8023a2 <strsplit+0x23>
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	8a 00                	mov    (%eax),%al
  80241c:	0f be c0             	movsbl %al,%eax
  80241f:	50                   	push   %eax
  802420:	ff 75 0c             	pushl  0xc(%ebp)
  802423:	e8 25 fa ff ff       	call   801e4d <strchr>
  802428:	83 c4 08             	add    $0x8,%esp
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 dc                	je     80240b <strsplit+0x8c>
			string++;
	}
  80242f:	e9 6e ff ff ff       	jmp    8023a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802434:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802435:	8b 45 14             	mov    0x14(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802441:	8b 45 10             	mov    0x10(%ebp),%eax
  802444:	01 d0                	add    %edx,%eax
  802446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80245f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802466:	eb 4a                	jmp    8024b2 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  802468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	01 c2                	add    %eax,%edx
  802470:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802473:	8b 45 0c             	mov    0xc(%ebp),%eax
  802476:	01 c8                	add    %ecx,%eax
  802478:	8a 00                	mov    (%eax),%al
  80247a:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80247c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80247f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802482:	01 d0                	add    %edx,%eax
  802484:	8a 00                	mov    (%eax),%al
  802486:	3c 40                	cmp    $0x40,%al
  802488:	7e 25                	jle    8024af <str2lower+0x5c>
  80248a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80248d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802490:	01 d0                	add    %edx,%eax
  802492:	8a 00                	mov    (%eax),%al
  802494:	3c 5a                	cmp    $0x5a,%al
  802496:	7f 17                	jg     8024af <str2lower+0x5c>
		{
			dst[i] += 32 ;
  802498:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	01 d0                	add    %edx,%eax
  8024a0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a6:	01 ca                	add    %ecx,%edx
  8024a8:	8a 12                	mov    (%edx),%dl
  8024aa:	83 c2 20             	add    $0x20,%edx
  8024ad:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8024af:	ff 45 fc             	incl   -0x4(%ebp)
  8024b2:	ff 75 0c             	pushl  0xc(%ebp)
  8024b5:	e8 01 f8 ff ff       	call   801cbb <strlen>
  8024ba:	83 c4 04             	add    $0x4,%esp
  8024bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8024c0:	7f a6                	jg     802468 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8024c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8024cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 42                	je     802518 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8024d6:	83 ec 08             	sub    $0x8,%esp
  8024d9:	68 00 00 00 82       	push   $0x82000000
  8024de:	68 00 00 00 80       	push   $0x80000000
  8024e3:	e8 00 08 00 00       	call   802ce8 <initialize_dynamic_allocator>
  8024e8:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8024eb:	e8 e7 05 00 00       	call   802ad7 <sys_get_uheap_strategy>
  8024f0:	a3 44 d2 81 00       	mov    %eax,0x81d244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8024f5:	a1 20 52 80 00       	mov    0x805220,%eax
  8024fa:	05 00 10 00 00       	add    $0x1000,%eax
  8024ff:	a3 f0 d2 81 00       	mov    %eax,0x81d2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  802504:	a1 f0 d2 81 00       	mov    0x81d2f0,%eax
  802509:	a3 50 d2 81 00       	mov    %eax,0x81d250

		__firstTimeFlag = 0;
  80250e:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  802515:	00 00 00 
	}
}
  802518:	90                   	nop
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80252f:	83 ec 08             	sub    $0x8,%esp
  802532:	68 06 04 00 00       	push   $0x406
  802537:	50                   	push   %eax
  802538:	e8 e4 01 00 00       	call   802721 <__sys_allocate_page>
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802543:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802547:	79 14                	jns    80255d <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 28 45 80 00       	push   $0x804528
  802551:	6a 1f                	push   $0x1f
  802553:	68 64 45 80 00       	push   $0x804564
  802558:	e8 b7 ed ff ff       	call   801314 <_panic>
	return 0;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	50                   	push   %eax
  80257c:	e8 e7 01 00 00       	call   802768 <__sys_unmap_frame>
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802587:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80258b:	79 14                	jns    8025a1 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80258d:	83 ec 04             	sub    $0x4,%esp
  802590:	68 70 45 80 00       	push   $0x804570
  802595:	6a 2a                	push   $0x2a
  802597:	68 64 45 80 00       	push   $0x804564
  80259c:	e8 73 ed ff ff       	call   801314 <_panic>
}
  8025a1:	90                   	nop
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    

008025a4 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025aa:	e8 18 ff ff ff       	call   8024c7 <uheap_init>
	if (size == 0) return NULL ;
  8025af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b3:	75 07                	jne    8025bc <malloc+0x18>
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	eb 14                	jmp    8025d0 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8025bc:	83 ec 04             	sub    $0x4,%esp
  8025bf:	68 b0 45 80 00       	push   $0x8045b0
  8025c4:	6a 3e                	push   $0x3e
  8025c6:	68 64 45 80 00       	push   $0x804564
  8025cb:	e8 44 ed ff ff       	call   801314 <_panic>
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8025d8:	83 ec 04             	sub    $0x4,%esp
  8025db:	68 d8 45 80 00       	push   $0x8045d8
  8025e0:	6a 49                	push   $0x49
  8025e2:	68 64 45 80 00       	push   $0x804564
  8025e7:	e8 28 ed ff ff       	call   801314 <_panic>

008025ec <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 18             	sub    $0x18,%esp
  8025f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8025f8:	e8 ca fe ff ff       	call   8024c7 <uheap_init>
	if (size == 0) return NULL ;
  8025fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802601:	75 07                	jne    80260a <smalloc+0x1e>
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	eb 14                	jmp    80261e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	68 fc 45 80 00       	push   $0x8045fc
  802612:	6a 5a                	push   $0x5a
  802614:	68 64 45 80 00       	push   $0x804564
  802619:	e8 f6 ec ff ff       	call   801314 <_panic>
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802626:	e8 9c fe ff ff       	call   8024c7 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 24 46 80 00       	push   $0x804624
  802633:	6a 6a                	push   $0x6a
  802635:	68 64 45 80 00       	push   $0x804564
  80263a:	e8 d5 ec ff ff       	call   801314 <_panic>

0080263f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802645:	e8 7d fe ff ff       	call   8024c7 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 48 46 80 00       	push   $0x804648
  802652:	68 88 00 00 00       	push   $0x88
  802657:	68 64 45 80 00       	push   $0x804564
  80265c:	e8 b3 ec ff ff       	call   801314 <_panic>

00802661 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  802667:	83 ec 04             	sub    $0x4,%esp
  80266a:	68 70 46 80 00       	push   $0x804670
  80266f:	68 9b 00 00 00       	push   $0x9b
  802674:	68 64 45 80 00       	push   $0x804564
  802679:	e8 96 ec ff ff       	call   801314 <_panic>

0080267e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	53                   	push   %ebx
  802684:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802690:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802693:	8b 7d 18             	mov    0x18(%ebp),%edi
  802696:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802699:	cd 30                	int    $0x30
  80269b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80269e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8026a1:	83 c4 10             	add    $0x10,%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5f                   	pop    %edi
  8026a7:	5d                   	pop    %ebp
  8026a8:	c3                   	ret    

008026a9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	8b 45 10             	mov    0x10(%ebp),%eax
  8026b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8026b5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	6a 00                	push   $0x0
  8026c1:	51                   	push   %ecx
  8026c2:	52                   	push   %edx
  8026c3:	ff 75 0c             	pushl  0xc(%ebp)
  8026c6:	50                   	push   %eax
  8026c7:	6a 00                	push   $0x0
  8026c9:	e8 b0 ff ff ff       	call   80267e <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	90                   	nop
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 02                	push   $0x2
  8026e3:	e8 96 ff ff ff       	call   80267e <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sys_lock_cons>:

void sys_lock_cons(void)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 03                	push   $0x3
  8026fc:	e8 7d ff ff ff       	call   80267e <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	90                   	nop
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 04                	push   $0x4
  802716:	e8 63 ff ff ff       	call   80267e <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	90                   	nop
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802724:	8b 55 0c             	mov    0xc(%ebp),%edx
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	52                   	push   %edx
  802731:	50                   	push   %eax
  802732:	6a 08                	push   $0x8
  802734:	e8 45 ff ff ff       	call   80267e <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	56                   	push   %esi
  802742:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802743:	8b 75 18             	mov    0x18(%ebp),%esi
  802746:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	56                   	push   %esi
  802753:	53                   	push   %ebx
  802754:	51                   	push   %ecx
  802755:	52                   	push   %edx
  802756:	50                   	push   %eax
  802757:	6a 09                	push   $0x9
  802759:	e8 20 ff ff ff       	call   80267e <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802764:	5b                   	pop    %ebx
  802765:	5e                   	pop    %esi
  802766:	5d                   	pop    %ebp
  802767:	c3                   	ret    

00802768 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	ff 75 08             	pushl  0x8(%ebp)
  802776:	6a 0a                	push   $0xa
  802778:	e8 01 ff ff ff       	call   80267e <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	ff 75 0c             	pushl  0xc(%ebp)
  80278e:	ff 75 08             	pushl  0x8(%ebp)
  802791:	6a 0b                	push   $0xb
  802793:	e8 e6 fe ff ff       	call   80267e <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 00                	push   $0x0
  8027a6:	6a 00                	push   $0x0
  8027a8:	6a 00                	push   $0x0
  8027aa:	6a 0c                	push   $0xc
  8027ac:	e8 cd fe ff ff       	call   80267e <syscall>
  8027b1:	83 c4 18             	add    $0x18,%esp
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 0d                	push   $0xd
  8027c5:	e8 b4 fe ff ff       	call   80267e <syscall>
  8027ca:	83 c4 18             	add    $0x18,%esp
}
  8027cd:	c9                   	leave  
  8027ce:	c3                   	ret    

008027cf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8027cf:	55                   	push   %ebp
  8027d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 00                	push   $0x0
  8027da:	6a 00                	push   $0x0
  8027dc:	6a 0e                	push   $0xe
  8027de:	e8 9b fe ff ff       	call   80267e <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027eb:	6a 00                	push   $0x0
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 0f                	push   $0xf
  8027f7:	e8 82 fe ff ff       	call   80267e <syscall>
  8027fc:	83 c4 18             	add    $0x18,%esp
}
  8027ff:	c9                   	leave  
  802800:	c3                   	ret    

00802801 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	ff 75 08             	pushl  0x8(%ebp)
  80280f:	6a 10                	push   $0x10
  802811:	e8 68 fe ff ff       	call   80267e <syscall>
  802816:	83 c4 18             	add    $0x18,%esp
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 11                	push   $0x11
  80282a:	e8 4f fe ff ff       	call   80267e <syscall>
  80282f:	83 c4 18             	add    $0x18,%esp
}
  802832:	90                   	nop
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <sys_cputc>:

void
sys_cputc(const char c)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802841:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	50                   	push   %eax
  80284e:	6a 01                	push   $0x1
  802850:	e8 29 fe ff ff       	call   80267e <syscall>
  802855:	83 c4 18             	add    $0x18,%esp
}
  802858:	90                   	nop
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80285e:	6a 00                	push   $0x0
  802860:	6a 00                	push   $0x0
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 14                	push   $0x14
  80286a:	e8 0f fe ff ff       	call   80267e <syscall>
  80286f:	83 c4 18             	add    $0x18,%esp
}
  802872:	90                   	nop
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	8b 45 10             	mov    0x10(%ebp),%eax
  80287e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802881:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802884:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	6a 00                	push   $0x0
  80288d:	51                   	push   %ecx
  80288e:	52                   	push   %edx
  80288f:	ff 75 0c             	pushl  0xc(%ebp)
  802892:	50                   	push   %eax
  802893:	6a 15                	push   $0x15
  802895:	e8 e4 fd ff ff       	call   80267e <syscall>
  80289a:	83 c4 18             	add    $0x18,%esp
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8028a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	6a 00                	push   $0x0
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	52                   	push   %edx
  8028af:	50                   	push   %eax
  8028b0:	6a 16                	push   $0x16
  8028b2:	e8 c7 fd ff ff       	call   80267e <syscall>
  8028b7:	83 c4 18             	add    $0x18,%esp
}
  8028ba:	c9                   	leave  
  8028bb:	c3                   	ret    

008028bc <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8028bc:	55                   	push   %ebp
  8028bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8028bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	51                   	push   %ecx
  8028cd:	52                   	push   %edx
  8028ce:	50                   	push   %eax
  8028cf:	6a 17                	push   $0x17
  8028d1:	e8 a8 fd ff ff       	call   80267e <syscall>
  8028d6:	83 c4 18             	add    $0x18,%esp
}
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    

008028db <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	52                   	push   %edx
  8028eb:	50                   	push   %eax
  8028ec:	6a 18                	push   $0x18
  8028ee:	e8 8b fd ff ff       	call   80267e <syscall>
  8028f3:	83 c4 18             	add    $0x18,%esp
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	6a 00                	push   $0x0
  802900:	ff 75 14             	pushl  0x14(%ebp)
  802903:	ff 75 10             	pushl  0x10(%ebp)
  802906:	ff 75 0c             	pushl  0xc(%ebp)
  802909:	50                   	push   %eax
  80290a:	6a 19                	push   $0x19
  80290c:	e8 6d fd ff ff       	call   80267e <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <sys_run_env>:

void sys_run_env(int32 envId)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 00                	push   $0x0
  802924:	50                   	push   %eax
  802925:	6a 1a                	push   $0x1a
  802927:	e8 52 fd ff ff       	call   80267e <syscall>
  80292c:	83 c4 18             	add    $0x18,%esp
}
  80292f:	90                   	nop
  802930:	c9                   	leave  
  802931:	c3                   	ret    

00802932 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	50                   	push   %eax
  802941:	6a 1b                	push   $0x1b
  802943:	e8 36 fd ff ff       	call   80267e <syscall>
  802948:	83 c4 18             	add    $0x18,%esp
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802950:	6a 00                	push   $0x0
  802952:	6a 00                	push   $0x0
  802954:	6a 00                	push   $0x0
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 05                	push   $0x5
  80295c:	e8 1d fd ff ff       	call   80267e <syscall>
  802961:	83 c4 18             	add    $0x18,%esp
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802969:	6a 00                	push   $0x0
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 06                	push   $0x6
  802975:	e8 04 fd ff ff       	call   80267e <syscall>
  80297a:	83 c4 18             	add    $0x18,%esp
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	6a 00                	push   $0x0
  802988:	6a 00                	push   $0x0
  80298a:	6a 00                	push   $0x0
  80298c:	6a 07                	push   $0x7
  80298e:	e8 eb fc ff ff       	call   80267e <syscall>
  802993:	83 c4 18             	add    $0x18,%esp
}
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <sys_exit_env>:


void sys_exit_env(void)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80299b:	6a 00                	push   $0x0
  80299d:	6a 00                	push   $0x0
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 1c                	push   $0x1c
  8029a7:	e8 d2 fc ff ff       	call   80267e <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	90                   	nop
  8029b0:	c9                   	leave  
  8029b1:	c3                   	ret    

008029b2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8029b2:	55                   	push   %ebp
  8029b3:	89 e5                	mov    %esp,%ebp
  8029b5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029b8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029bb:	8d 50 04             	lea    0x4(%eax),%edx
  8029be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 00                	push   $0x0
  8029c5:	6a 00                	push   $0x0
  8029c7:	52                   	push   %edx
  8029c8:	50                   	push   %eax
  8029c9:	6a 1d                	push   $0x1d
  8029cb:	e8 ae fc ff ff       	call   80267e <syscall>
  8029d0:	83 c4 18             	add    $0x18,%esp
	return result;
  8029d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029dc:	89 01                	mov    %eax,(%ecx)
  8029de:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	c9                   	leave  
  8029e5:	c2 04 00             	ret    $0x4

008029e8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	ff 75 10             	pushl  0x10(%ebp)
  8029f2:	ff 75 0c             	pushl  0xc(%ebp)
  8029f5:	ff 75 08             	pushl  0x8(%ebp)
  8029f8:	6a 13                	push   $0x13
  8029fa:	e8 7f fc ff ff       	call   80267e <syscall>
  8029ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802a02:	90                   	nop
}
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 1e                	push   $0x1e
  802a14:	e8 65 fc ff ff       	call   80267e <syscall>
  802a19:	83 c4 18             	add    $0x18,%esp
}
  802a1c:	c9                   	leave  
  802a1d:	c3                   	ret    

00802a1e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a2a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	6a 00                	push   $0x0
  802a36:	50                   	push   %eax
  802a37:	6a 1f                	push   $0x1f
  802a39:	e8 40 fc ff ff       	call   80267e <syscall>
  802a3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a41:	90                   	nop
}
  802a42:	c9                   	leave  
  802a43:	c3                   	ret    

00802a44 <rsttst>:
void rsttst()
{
  802a44:	55                   	push   %ebp
  802a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	6a 00                	push   $0x0
  802a51:	6a 21                	push   $0x21
  802a53:	e8 26 fc ff ff       	call   80267e <syscall>
  802a58:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5b:	90                   	nop
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	8b 45 14             	mov    0x14(%ebp),%eax
  802a67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a6a:	8b 55 18             	mov    0x18(%ebp),%edx
  802a6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a71:	52                   	push   %edx
  802a72:	50                   	push   %eax
  802a73:	ff 75 10             	pushl  0x10(%ebp)
  802a76:	ff 75 0c             	pushl  0xc(%ebp)
  802a79:	ff 75 08             	pushl  0x8(%ebp)
  802a7c:	6a 20                	push   $0x20
  802a7e:	e8 fb fb ff ff       	call   80267e <syscall>
  802a83:	83 c4 18             	add    $0x18,%esp
	return ;
  802a86:	90                   	nop
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <chktst>:
void chktst(uint32 n)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	ff 75 08             	pushl  0x8(%ebp)
  802a97:	6a 22                	push   $0x22
  802a99:	e8 e0 fb ff ff       	call   80267e <syscall>
  802a9e:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa1:	90                   	nop
}
  802aa2:	c9                   	leave  
  802aa3:	c3                   	ret    

00802aa4 <inctst>:

void inctst()
{
  802aa4:	55                   	push   %ebp
  802aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 00                	push   $0x0
  802ab1:	6a 23                	push   $0x23
  802ab3:	e8 c6 fb ff ff       	call   80267e <syscall>
  802ab8:	83 c4 18             	add    $0x18,%esp
	return ;
  802abb:	90                   	nop
}
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <gettst>:
uint32 gettst()
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ac1:	6a 00                	push   $0x0
  802ac3:	6a 00                	push   $0x0
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 24                	push   $0x24
  802acd:	e8 ac fb ff ff       	call   80267e <syscall>
  802ad2:	83 c4 18             	add    $0x18,%esp
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ada:	6a 00                	push   $0x0
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 25                	push   $0x25
  802ae6:	e8 93 fb ff ff       	call   80267e <syscall>
  802aeb:	83 c4 18             	add    $0x18,%esp
  802aee:	a3 44 d2 81 00       	mov    %eax,0x81d244
	return uheapPlaceStrategy ;
  802af3:	a1 44 d2 81 00       	mov    0x81d244,%eax
}
  802af8:	c9                   	leave  
  802af9:	c3                   	ret    

00802afa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	a3 44 d2 81 00       	mov    %eax,0x81d244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	6a 00                	push   $0x0
  802b0d:	ff 75 08             	pushl  0x8(%ebp)
  802b10:	6a 26                	push   $0x26
  802b12:	e8 67 fb ff ff       	call   80267e <syscall>
  802b17:	83 c4 18             	add    $0x18,%esp
	return ;
  802b1a:	90                   	nop
}
  802b1b:	c9                   	leave  
  802b1c:	c3                   	ret    

00802b1d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
  802b20:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802b21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	6a 00                	push   $0x0
  802b2f:	53                   	push   %ebx
  802b30:	51                   	push   %ecx
  802b31:	52                   	push   %edx
  802b32:	50                   	push   %eax
  802b33:	6a 27                	push   $0x27
  802b35:	e8 44 fb ff ff       	call   80267e <syscall>
  802b3a:	83 c4 18             	add    $0x18,%esp
}
  802b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	6a 00                	push   $0x0
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	52                   	push   %edx
  802b52:	50                   	push   %eax
  802b53:	6a 28                	push   $0x28
  802b55:	e8 24 fb ff ff       	call   80267e <syscall>
  802b5a:	83 c4 18             	add    $0x18,%esp
}
  802b5d:	c9                   	leave  
  802b5e:	c3                   	ret    

00802b5f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  802b5f:	55                   	push   %ebp
  802b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802b62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	6a 00                	push   $0x0
  802b6d:	51                   	push   %ecx
  802b6e:	ff 75 10             	pushl  0x10(%ebp)
  802b71:	52                   	push   %edx
  802b72:	50                   	push   %eax
  802b73:	6a 29                	push   $0x29
  802b75:	e8 04 fb ff ff       	call   80267e <syscall>
  802b7a:	83 c4 18             	add    $0x18,%esp
}
  802b7d:	c9                   	leave  
  802b7e:	c3                   	ret    

00802b7f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b7f:	55                   	push   %ebp
  802b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b82:	6a 00                	push   $0x0
  802b84:	6a 00                	push   $0x0
  802b86:	ff 75 10             	pushl  0x10(%ebp)
  802b89:	ff 75 0c             	pushl  0xc(%ebp)
  802b8c:	ff 75 08             	pushl  0x8(%ebp)
  802b8f:	6a 12                	push   $0x12
  802b91:	e8 e8 fa ff ff       	call   80267e <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
	return ;
  802b99:	90                   	nop
}
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  802b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 00                	push   $0x0
  802bab:	52                   	push   %edx
  802bac:	50                   	push   %eax
  802bad:	6a 2a                	push   $0x2a
  802baf:	e8 ca fa ff ff       	call   80267e <syscall>
  802bb4:	83 c4 18             	add    $0x18,%esp
	return;
  802bb7:	90                   	nop
}
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 2b                	push   $0x2b
  802bc9:	e8 b0 fa ff ff       	call   80267e <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	ff 75 0c             	pushl  0xc(%ebp)
  802bdf:	ff 75 08             	pushl  0x8(%ebp)
  802be2:	6a 2d                	push   $0x2d
  802be4:	e8 95 fa ff ff       	call   80267e <syscall>
  802be9:	83 c4 18             	add    $0x18,%esp
	return;
  802bec:	90                   	nop
}
  802bed:	c9                   	leave  
  802bee:	c3                   	ret    

00802bef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802bef:	55                   	push   %ebp
  802bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	ff 75 0c             	pushl  0xc(%ebp)
  802bfb:	ff 75 08             	pushl  0x8(%ebp)
  802bfe:	6a 2c                	push   $0x2c
  802c00:	e8 79 fa ff ff       	call   80267e <syscall>
  802c05:	83 c4 18             	add    $0x18,%esp
	return ;
  802c08:	90                   	nop
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
  802c0e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802c11:	83 ec 04             	sub    $0x4,%esp
  802c14:	68 94 46 80 00       	push   $0x804694
  802c19:	68 25 01 00 00       	push   $0x125
  802c1e:	68 c7 46 80 00       	push   $0x8046c7
  802c23:	e8 ec e6 ff ff       	call   801314 <_panic>

00802c28 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
  802c2b:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  802c2e:	81 7d 08 40 52 80 00 	cmpl   $0x805240,0x8(%ebp)
  802c35:	72 09                	jb     802c40 <to_page_va+0x18>
  802c37:	81 7d 08 40 d2 81 00 	cmpl   $0x81d240,0x8(%ebp)
  802c3e:	72 14                	jb     802c54 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	68 d8 46 80 00       	push   $0x8046d8
  802c48:	6a 15                	push   $0x15
  802c4a:	68 03 47 80 00       	push   $0x804703
  802c4f:	e8 c0 e6 ff ff       	call   801314 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	ba 40 52 80 00       	mov    $0x805240,%edx
  802c5c:	29 d0                	sub    %edx,%eax
  802c5e:	c1 f8 02             	sar    $0x2,%eax
  802c61:	89 c2                	mov    %eax,%edx
  802c63:	89 d0                	mov    %edx,%eax
  802c65:	c1 e0 02             	shl    $0x2,%eax
  802c68:	01 d0                	add    %edx,%eax
  802c6a:	c1 e0 02             	shl    $0x2,%eax
  802c6d:	01 d0                	add    %edx,%eax
  802c6f:	c1 e0 02             	shl    $0x2,%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	89 c1                	mov    %eax,%ecx
  802c76:	c1 e1 08             	shl    $0x8,%ecx
  802c79:	01 c8                	add    %ecx,%eax
  802c7b:	89 c1                	mov    %eax,%ecx
  802c7d:	c1 e1 10             	shl    $0x10,%ecx
  802c80:	01 c8                	add    %ecx,%eax
  802c82:	01 c0                	add    %eax,%eax
  802c84:	01 d0                	add    %edx,%eax
  802c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	c1 e0 0c             	shl    $0xc,%eax
  802c8f:	89 c2                	mov    %eax,%edx
  802c91:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802c96:	01 d0                	add    %edx,%eax
}
  802c98:	c9                   	leave  
  802c99:	c3                   	ret    

00802c9a <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802c9a:	55                   	push   %ebp
  802c9b:	89 e5                	mov    %esp,%ebp
  802c9d:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  802ca0:	a1 48 d2 81 00       	mov    0x81d248,%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	29 c2                	sub    %eax,%edx
  802caa:	89 d0                	mov    %edx,%eax
  802cac:	c1 e8 0c             	shr    $0xc,%eax
  802caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb6:	78 09                	js     802cc1 <to_page_info+0x27>
  802cb8:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  802cbf:	7e 14                	jle    802cd5 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 1c 47 80 00       	push   $0x80471c
  802cc9:	6a 22                	push   $0x22
  802ccb:	68 03 47 80 00       	push   $0x804703
  802cd0:	e8 3f e6 ff ff       	call   801314 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  802cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd8:	89 d0                	mov    %edx,%eax
  802cda:	01 c0                	add    %eax,%eax
  802cdc:	01 d0                	add    %edx,%eax
  802cde:	c1 e0 02             	shl    $0x2,%eax
  802ce1:	05 40 52 80 00       	add    $0x805240,%eax
}
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	05 00 00 00 02       	add    $0x2000000,%eax
  802cf6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cf9:	73 16                	jae    802d11 <initialize_dynamic_allocator+0x29>
  802cfb:	68 40 47 80 00       	push   $0x804740
  802d00:	68 66 47 80 00       	push   $0x804766
  802d05:	6a 34                	push   $0x34
  802d07:	68 03 47 80 00       	push   $0x804703
  802d0c:	e8 03 e6 ff ff       	call   801314 <_panic>
		is_initialized = 1;
  802d11:	c7 05 04 52 80 00 01 	movl   $0x1,0x805204
  802d18:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 48 d2 81 00       	mov    %eax,0x81d248
	dynAllocEnd = daEnd;
  802d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d26:	a3 20 52 80 00       	mov    %eax,0x805220
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  802d2b:	c7 05 28 52 80 00 00 	movl   $0x0,0x805228
  802d32:	00 00 00 
  802d35:	c7 05 2c 52 80 00 00 	movl   $0x0,0x80522c
  802d3c:	00 00 00 
  802d3f:	c7 05 34 52 80 00 00 	movl   $0x0,0x805234
  802d46:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4f:	c1 e8 0c             	shr    $0xc,%eax
  802d52:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802d55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d5c:	e9 c8 00 00 00       	jmp    802e29 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d64:	89 d0                	mov    %edx,%eax
  802d66:	01 c0                	add    %eax,%eax
  802d68:	01 d0                	add    %edx,%eax
  802d6a:	c1 e0 02             	shl    $0x2,%eax
  802d6d:	05 48 52 80 00       	add    $0x805248,%eax
  802d72:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7a:	89 d0                	mov    %edx,%eax
  802d7c:	01 c0                	add    %eax,%eax
  802d7e:	01 d0                	add    %edx,%eax
  802d80:	c1 e0 02             	shl    $0x2,%eax
  802d83:	05 4a 52 80 00       	add    $0x80524a,%eax
  802d88:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802d8d:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802d93:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d96:	89 c8                	mov    %ecx,%eax
  802d98:	01 c0                	add    %eax,%eax
  802d9a:	01 c8                	add    %ecx,%eax
  802d9c:	c1 e0 02             	shl    $0x2,%eax
  802d9f:	05 44 52 80 00       	add    $0x805244,%eax
  802da4:	89 10                	mov    %edx,(%eax)
  802da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da9:	89 d0                	mov    %edx,%eax
  802dab:	01 c0                	add    %eax,%eax
  802dad:	01 d0                	add    %edx,%eax
  802daf:	c1 e0 02             	shl    $0x2,%eax
  802db2:	05 44 52 80 00       	add    $0x805244,%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 1b                	je     802dd8 <initialize_dynamic_allocator+0xf0>
  802dbd:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  802dc3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802dc6:	89 c8                	mov    %ecx,%eax
  802dc8:	01 c0                	add    %eax,%eax
  802dca:	01 c8                	add    %ecx,%eax
  802dcc:	c1 e0 02             	shl    $0x2,%eax
  802dcf:	05 40 52 80 00       	add    $0x805240,%eax
  802dd4:	89 02                	mov    %eax,(%edx)
  802dd6:	eb 16                	jmp    802dee <initialize_dynamic_allocator+0x106>
  802dd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddb:	89 d0                	mov    %edx,%eax
  802ddd:	01 c0                	add    %eax,%eax
  802ddf:	01 d0                	add    %edx,%eax
  802de1:	c1 e0 02             	shl    $0x2,%eax
  802de4:	05 40 52 80 00       	add    $0x805240,%eax
  802de9:	a3 28 52 80 00       	mov    %eax,0x805228
  802dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df1:	89 d0                	mov    %edx,%eax
  802df3:	01 c0                	add    %eax,%eax
  802df5:	01 d0                	add    %edx,%eax
  802df7:	c1 e0 02             	shl    $0x2,%eax
  802dfa:	05 40 52 80 00       	add    $0x805240,%eax
  802dff:	a3 2c 52 80 00       	mov    %eax,0x80522c
  802e04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e07:	89 d0                	mov    %edx,%eax
  802e09:	01 c0                	add    %eax,%eax
  802e0b:	01 d0                	add    %edx,%eax
  802e0d:	c1 e0 02             	shl    $0x2,%eax
  802e10:	05 40 52 80 00       	add    $0x805240,%eax
  802e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1b:	a1 34 52 80 00       	mov    0x805234,%eax
  802e20:	40                   	inc    %eax
  802e21:	a3 34 52 80 00       	mov    %eax,0x805234
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802e26:	ff 45 f4             	incl   -0xc(%ebp)
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e2f:	0f 8c 2c ff ff ff    	jl     802d61 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e3c:	eb 36                	jmp    802e74 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	c1 e0 04             	shl    $0x4,%eax
  802e44:	05 60 d2 81 00       	add    $0x81d260,%eax
  802e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	c1 e0 04             	shl    $0x4,%eax
  802e55:	05 64 d2 81 00       	add    $0x81d264,%eax
  802e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	c1 e0 04             	shl    $0x4,%eax
  802e66:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802e71:	ff 45 f0             	incl   -0x10(%ebp)
  802e74:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802e78:	7e c4                	jle    802e3e <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802e7a:	90                   	nop
  802e7b:	c9                   	leave  
  802e7c:	c3                   	ret    

00802e7d <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802e7d:	55                   	push   %ebp
  802e7e:	89 e5                	mov    %esp,%ebp
  802e80:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	83 ec 0c             	sub    $0xc,%esp
  802e89:	50                   	push   %eax
  802e8a:	e8 0b fe ff ff       	call   802c9a <to_page_info>
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802e9e:	c9                   	leave  
  802e9f:	c3                   	ret    

00802ea0 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802ea0:	55                   	push   %ebp
  802ea1:	89 e5                	mov    %esp,%ebp
  802ea3:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802ea6:	83 ec 0c             	sub    $0xc,%esp
  802ea9:	ff 75 0c             	pushl  0xc(%ebp)
  802eac:	e8 77 fd ff ff       	call   802c28 <to_page_va>
  802eb1:	83 c4 10             	add    $0x10,%esp
  802eb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802eb7:	b8 00 10 00 00       	mov    $0x1000,%eax
  802ebc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ec1:	f7 75 08             	divl   0x8(%ebp)
  802ec4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	83 ec 0c             	sub    $0xc,%esp
  802ecd:	50                   	push   %eax
  802ece:	e8 48 f6 ff ff       	call   80251b <get_page>
  802ed3:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802edc:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee6:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802eea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802ef1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802ef8:	eb 19                	jmp    802f13 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	ba 01 00 00 00       	mov    $0x1,%edx
  802f02:	88 c1                	mov    %al,%cl
  802f04:	d3 e2                	shl    %cl,%edx
  802f06:	89 d0                	mov    %edx,%eax
  802f08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0b:	74 0e                	je     802f1b <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802f0d:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802f10:	ff 45 f0             	incl   -0x10(%ebp)
  802f13:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802f17:	7e e1                	jle    802efa <split_page_to_blocks+0x5a>
  802f19:	eb 01                	jmp    802f1c <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802f1b:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802f1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802f23:	e9 a7 00 00 00       	jmp    802fcf <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	0f af 45 08          	imul   0x8(%ebp),%eax
  802f2f:	89 c2                	mov    %eax,%edx
  802f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f34:	01 d0                	add    %edx,%eax
  802f36:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802f39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f3d:	75 14                	jne    802f53 <split_page_to_blocks+0xb3>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 7c 47 80 00       	push   $0x80477c
  802f47:	6a 7c                	push   $0x7c
  802f49:	68 03 47 80 00       	push   $0x804703
  802f4e:	e8 c1 e3 ff ff       	call   801314 <_panic>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	c1 e0 04             	shl    $0x4,%eax
  802f59:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f5e:	8b 10                	mov    (%eax),%edx
  802f60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 14                	je     802f84 <split_page_to_blocks+0xe4>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	c1 e0 04             	shl    $0x4,%eax
  802f76:	05 64 d2 81 00       	add    $0x81d264,%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	eb 11                	jmp    802f95 <split_page_to_blocks+0xf5>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	c1 e0 04             	shl    $0x4,%eax
  802f8a:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  802f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f93:	89 02                	mov    %eax,(%edx)
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	c1 e0 04             	shl    $0x4,%eax
  802f9b:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  802fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa4:	89 02                	mov    %eax,(%edx)
  802fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	c1 e0 04             	shl    $0x4,%eax
  802fb5:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	8d 50 01             	lea    0x1(%eax),%edx
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	c1 e0 04             	shl    $0x4,%eax
  802fc5:	05 6c d2 81 00       	add    $0x81d26c,%eax
  802fca:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802fcc:	ff 45 ec             	incl   -0x14(%ebp)
  802fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802fd5:	0f 82 4d ff ff ff    	jb     802f28 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802fdb:	90                   	nop
  802fdc:	c9                   	leave  
  802fdd:	c3                   	ret    

00802fde <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802fde:	55                   	push   %ebp
  802fdf:	89 e5                	mov    %esp,%ebp
  802fe1:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802fe4:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802feb:	76 19                	jbe    803006 <alloc_block+0x28>
  802fed:	68 a0 47 80 00       	push   $0x8047a0
  802ff2:	68 66 47 80 00       	push   $0x804766
  802ff7:	68 8a 00 00 00       	push   $0x8a
  802ffc:	68 03 47 80 00       	push   $0x804703
  803001:	e8 0e e3 ff ff       	call   801314 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  803006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80300d:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803014:	eb 19                	jmp    80302f <alloc_block+0x51>
		if((1 << i) >= size) break;
  803016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803019:	ba 01 00 00 00       	mov    $0x1,%edx
  80301e:	88 c1                	mov    %al,%cl
  803020:	d3 e2                	shl    %cl,%edx
  803022:	89 d0                	mov    %edx,%eax
  803024:	3b 45 08             	cmp    0x8(%ebp),%eax
  803027:	73 0e                	jae    803037 <alloc_block+0x59>
		idx++;
  803029:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80302c:	ff 45 f0             	incl   -0x10(%ebp)
  80302f:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803033:	7e e1                	jle    803016 <alloc_block+0x38>
  803035:	eb 01                	jmp    803038 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  803037:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	c1 e0 04             	shl    $0x4,%eax
  80303e:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	0f 84 df 00 00 00    	je     80312c <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	c1 e0 04             	shl    $0x4,%eax
  803053:	05 60 d2 81 00       	add    $0x81d260,%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80305d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803061:	75 17                	jne    80307a <alloc_block+0x9c>
  803063:	83 ec 04             	sub    $0x4,%esp
  803066:	68 c1 47 80 00       	push   $0x8047c1
  80306b:	68 9e 00 00 00       	push   $0x9e
  803070:	68 03 47 80 00       	push   $0x804703
  803075:	e8 9a e2 ff ff       	call   801314 <_panic>
  80307a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	74 10                	je     803093 <alloc_block+0xb5>
  803083:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80308b:	8b 52 04             	mov    0x4(%edx),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 14                	jmp    8030a7 <alloc_block+0xc9>
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309c:	c1 e2 04             	shl    $0x4,%edx
  80309f:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8030a5:	89 02                	mov    %eax,(%edx)
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0f                	je     8030c0 <alloc_block+0xe2>
  8030b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ba:	8b 12                	mov    (%edx),%edx
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	eb 13                	jmp    8030d3 <alloc_block+0xf5>
  8030c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c8:	c1 e2 04             	shl    $0x4,%edx
  8030cb:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8030d1:	89 02                	mov    %eax,(%edx)
  8030d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	c1 e0 04             	shl    $0x4,%eax
  8030ec:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8030f1:	8b 00                	mov    (%eax),%eax
  8030f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	c1 e0 04             	shl    $0x4,%eax
  8030fc:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803101:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	50                   	push   %eax
  80310a:	e8 8b fb ff ff       	call   802c9a <to_page_info>
  80310f:	83 c4 10             	add    $0x10,%esp
  803112:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80311c:	48                   	dec    %eax
  80311d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803120:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  803124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803127:	e9 bc 02 00 00       	jmp    8033e8 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80312c:	a1 34 52 80 00       	mov    0x805234,%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	0f 84 7d 02 00 00    	je     8033b6 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  803139:	a1 28 52 80 00       	mov    0x805228,%eax
  80313e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  803141:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803145:	75 17                	jne    80315e <alloc_block+0x180>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 c1 47 80 00       	push   $0x8047c1
  80314f:	68 a9 00 00 00       	push   $0xa9
  803154:	68 03 47 80 00       	push   $0x804703
  803159:	e8 b6 e1 ff ff       	call   801314 <_panic>
  80315e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 10                	je     803177 <alloc_block+0x199>
  803167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80316f:	8b 52 04             	mov    0x4(%edx),%edx
  803172:	89 50 04             	mov    %edx,0x4(%eax)
  803175:	eb 0b                	jmp    803182 <alloc_block+0x1a4>
  803177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	85 c0                	test   %eax,%eax
  80318a:	74 0f                	je     80319b <alloc_block+0x1bd>
  80318c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318f:	8b 40 04             	mov    0x4(%eax),%eax
  803192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803195:	8b 12                	mov    (%edx),%edx
  803197:	89 10                	mov    %edx,(%eax)
  803199:	eb 0a                	jmp    8031a5 <alloc_block+0x1c7>
  80319b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	a3 28 52 80 00       	mov    %eax,0x805228
  8031a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b8:	a1 34 52 80 00       	mov    0x805234,%eax
  8031bd:	48                   	dec    %eax
  8031be:	a3 34 52 80 00       	mov    %eax,0x805234
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	83 c0 03             	add    $0x3,%eax
  8031c9:	ba 01 00 00 00       	mov    $0x1,%edx
  8031ce:	88 c1                	mov    %al,%cl
  8031d0:	d3 e2                	shl    %cl,%edx
  8031d2:	89 d0                	mov    %edx,%eax
  8031d4:	83 ec 08             	sub    $0x8,%esp
  8031d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031da:	50                   	push   %eax
  8031db:	e8 c0 fc ff ff       	call   802ea0 <split_page_to_blocks>
  8031e0:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	c1 e0 04             	shl    $0x4,%eax
  8031e9:	05 60 d2 81 00       	add    $0x81d260,%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8031f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031f7:	75 17                	jne    803210 <alloc_block+0x232>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 c1 47 80 00       	push   $0x8047c1
  803201:	68 b0 00 00 00       	push   $0xb0
  803206:	68 03 47 80 00       	push   $0x804703
  80320b:	e8 04 e1 ff ff       	call   801314 <_panic>
  803210:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 10                	je     803229 <alloc_block+0x24b>
  803219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803221:	8b 52 04             	mov    0x4(%edx),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	eb 14                	jmp    80323d <alloc_block+0x25f>
  803229:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	c1 e2 04             	shl    $0x4,%edx
  803235:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  80323b:	89 02                	mov    %eax,(%edx)
  80323d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0f                	je     803256 <alloc_block+0x278>
  803247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803250:	8b 12                	mov    (%edx),%edx
  803252:	89 10                	mov    %edx,(%eax)
  803254:	eb 13                	jmp    803269 <alloc_block+0x28b>
  803256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325e:	c1 e2 04             	shl    $0x4,%edx
  803261:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  803267:	89 02                	mov    %eax,(%edx)
  803269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	c1 e0 04             	shl    $0x4,%eax
  803282:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803287:	8b 00                	mov    (%eax),%eax
  803289:	8d 50 ff             	lea    -0x1(%eax),%edx
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	c1 e0 04             	shl    $0x4,%eax
  803292:	05 6c d2 81 00       	add    $0x81d26c,%eax
  803297:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80329c:	83 ec 0c             	sub    $0xc,%esp
  80329f:	50                   	push   %eax
  8032a0:	e8 f5 f9 ff ff       	call   802c9a <to_page_info>
  8032a5:	83 c4 10             	add    $0x10,%esp
  8032a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8032ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032ae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8032b2:	48                   	dec    %eax
  8032b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8032b6:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8032ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032bd:	e9 26 01 00 00       	jmp    8033e8 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8032c2:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8032c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c8:	c1 e0 04             	shl    $0x4,%eax
  8032cb:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	0f 84 dc 00 00 00    	je     8033b6 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	c1 e0 04             	shl    $0x4,%eax
  8032e0:	05 60 d2 81 00       	add    $0x81d260,%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8032ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8032ee:	75 17                	jne    803307 <alloc_block+0x329>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 c1 47 80 00       	push   $0x8047c1
  8032f8:	68 be 00 00 00       	push   $0xbe
  8032fd:	68 03 47 80 00       	push   $0x804703
  803302:	e8 0d e0 ff ff       	call   801314 <_panic>
  803307:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	85 c0                	test   %eax,%eax
  80330e:	74 10                	je     803320 <alloc_block+0x342>
  803310:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803318:	8b 52 04             	mov    0x4(%edx),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	eb 14                	jmp    803334 <alloc_block+0x356>
  803320:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803329:	c1 e2 04             	shl    $0x4,%edx
  80332c:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  803332:	89 02                	mov    %eax,(%edx)
  803334:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 0f                	je     80334d <alloc_block+0x36f>
  80333e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803347:	8b 12                	mov    (%edx),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	eb 13                	jmp    803360 <alloc_block+0x382>
  80334d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803355:	c1 e2 04             	shl    $0x4,%edx
  803358:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  80335e:	89 02                	mov    %eax,(%edx)
  803360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803369:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80336c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	c1 e0 04             	shl    $0x4,%eax
  803379:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80337e:	8b 00                	mov    (%eax),%eax
  803380:	8d 50 ff             	lea    -0x1(%eax),%edx
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	c1 e0 04             	shl    $0x4,%eax
  803389:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80338e:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  803390:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803393:	83 ec 0c             	sub    $0xc,%esp
  803396:	50                   	push   %eax
  803397:	e8 fe f8 ff ff       	call   802c9a <to_page_info>
  80339c:	83 c4 10             	add    $0x10,%esp
  80339f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8033a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a5:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8033a9:	48                   	dec    %eax
  8033aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ad:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8033b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033b4:	eb 32                	jmp    8033e8 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8033b6:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8033ba:	77 15                	ja     8033d1 <alloc_block+0x3f3>
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	c1 e0 04             	shl    $0x4,%eax
  8033c2:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8033c7:	8b 00                	mov    (%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	0f 84 f1 fe ff ff    	je     8032c2 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	68 df 47 80 00       	push   $0x8047df
  8033d9:	68 c8 00 00 00       	push   $0xc8
  8033de:	68 03 47 80 00       	push   $0x804703
  8033e3:	e8 2c df ff ff       	call   801314 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8033e8:	c9                   	leave  
  8033e9:	c3                   	ret    

008033ea <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8033ea:	55                   	push   %ebp
  8033eb:	89 e5                	mov    %esp,%ebp
  8033ed:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8033f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f3:	a1 48 d2 81 00       	mov    0x81d248,%eax
  8033f8:	39 c2                	cmp    %eax,%edx
  8033fa:	72 0c                	jb     803408 <free_block+0x1e>
  8033fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ff:	a1 20 52 80 00       	mov    0x805220,%eax
  803404:	39 c2                	cmp    %eax,%edx
  803406:	72 19                	jb     803421 <free_block+0x37>
  803408:	68 f0 47 80 00       	push   $0x8047f0
  80340d:	68 66 47 80 00       	push   $0x804766
  803412:	68 d7 00 00 00       	push   $0xd7
  803417:	68 03 47 80 00       	push   $0x804703
  80341c:	e8 f3 de ff ff       	call   801314 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	83 ec 0c             	sub    $0xc,%esp
  80342d:	50                   	push   %eax
  80342e:	e8 67 f8 ff ff       	call   802c9a <to_page_info>
  803433:	83 c4 10             	add    $0x10,%esp
  803436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  803439:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343c:	8b 40 08             	mov    0x8(%eax),%eax
  80343f:	0f b7 c0             	movzwl %ax,%eax
  803442:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  803445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80344c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  803453:	eb 19                	jmp    80346e <free_block+0x84>
	    if ((1 << i) == blk_size)
  803455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803458:	ba 01 00 00 00       	mov    $0x1,%edx
  80345d:	88 c1                	mov    %al,%cl
  80345f:	d3 e2                	shl    %cl,%edx
  803461:	89 d0                	mov    %edx,%eax
  803463:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803466:	74 0e                	je     803476 <free_block+0x8c>
	        break;
	    idx++;
  803468:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80346b:	ff 45 f0             	incl   -0x10(%ebp)
  80346e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  803472:	7e e1                	jle    803455 <free_block+0x6b>
  803474:	eb 01                	jmp    803477 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  803476:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  803477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80347e:	40                   	inc    %eax
  80347f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803482:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  803486:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80348a:	75 17                	jne    8034a3 <free_block+0xb9>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 7c 47 80 00       	push   $0x80477c
  803494:	68 ee 00 00 00       	push   $0xee
  803499:	68 03 47 80 00       	push   $0x804703
  80349e:	e8 71 de ff ff       	call   801314 <_panic>
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	c1 e0 04             	shl    $0x4,%eax
  8034a9:	05 64 d2 81 00       	add    $0x81d264,%eax
  8034ae:	8b 10                	mov    (%eax),%edx
  8034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b3:	89 50 04             	mov    %edx,0x4(%eax)
  8034b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b9:	8b 40 04             	mov    0x4(%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	74 14                	je     8034d4 <free_block+0xea>
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	c1 e0 04             	shl    $0x4,%eax
  8034c6:	05 64 d2 81 00       	add    $0x81d264,%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d0:	89 10                	mov    %edx,(%eax)
  8034d2:	eb 11                	jmp    8034e5 <free_block+0xfb>
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	c1 e0 04             	shl    $0x4,%eax
  8034da:	8d 90 60 d2 81 00    	lea    0x81d260(%eax),%edx
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	89 02                	mov    %eax,(%edx)
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	c1 e0 04             	shl    $0x4,%eax
  8034eb:	8d 90 64 d2 81 00    	lea    0x81d264(%eax),%edx
  8034f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f4:	89 02                	mov    %eax,(%edx)
  8034f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803502:	c1 e0 04             	shl    $0x4,%eax
  803505:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	8d 50 01             	lea    0x1(%eax),%edx
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	c1 e0 04             	shl    $0x4,%eax
  803515:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80351a:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80351c:	b8 00 10 00 00       	mov    $0x1000,%eax
  803521:	ba 00 00 00 00       	mov    $0x0,%edx
  803526:	f7 75 e0             	divl   -0x20(%ebp)
  803529:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80352c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352f:	66 8b 40 0a          	mov    0xa(%eax),%ax
  803533:	0f b7 c0             	movzwl %ax,%eax
  803536:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803539:	0f 85 70 01 00 00    	jne    8036af <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80353f:	83 ec 0c             	sub    $0xc,%esp
  803542:	ff 75 e4             	pushl  -0x1c(%ebp)
  803545:	e8 de f6 ff ff       	call   802c28 <to_page_va>
  80354a:	83 c4 10             	add    $0x10,%esp
  80354d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  803550:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803557:	e9 b7 00 00 00       	jmp    803613 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80355c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80355f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803562:	01 d0                	add    %edx,%eax
  803564:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  803567:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80356b:	75 17                	jne    803584 <free_block+0x19a>
  80356d:	83 ec 04             	sub    $0x4,%esp
  803570:	68 c1 47 80 00       	push   $0x8047c1
  803575:	68 f8 00 00 00       	push   $0xf8
  80357a:	68 03 47 80 00       	push   $0x804703
  80357f:	e8 90 dd ff ff       	call   801314 <_panic>
  803584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	85 c0                	test   %eax,%eax
  80358b:	74 10                	je     80359d <free_block+0x1b3>
  80358d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803590:	8b 00                	mov    (%eax),%eax
  803592:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803595:	8b 52 04             	mov    0x4(%edx),%edx
  803598:	89 50 04             	mov    %edx,0x4(%eax)
  80359b:	eb 14                	jmp    8035b1 <free_block+0x1c7>
  80359d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a0:	8b 40 04             	mov    0x4(%eax),%eax
  8035a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a6:	c1 e2 04             	shl    $0x4,%edx
  8035a9:	81 c2 64 d2 81 00    	add    $0x81d264,%edx
  8035af:	89 02                	mov    %eax,(%edx)
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	8b 40 04             	mov    0x4(%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	74 0f                	je     8035ca <free_block+0x1e0>
  8035bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035be:	8b 40 04             	mov    0x4(%eax),%eax
  8035c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c4:	8b 12                	mov    (%edx),%edx
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	eb 13                	jmp    8035dd <free_block+0x1f3>
  8035ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d2:	c1 e2 04             	shl    $0x4,%edx
  8035d5:	81 c2 60 d2 81 00    	add    $0x81d260,%edx
  8035db:	89 02                	mov    %eax,(%edx)
  8035dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f3:	c1 e0 04             	shl    $0x4,%eax
  8035f6:	05 6c d2 81 00       	add    $0x81d26c,%eax
  8035fb:	8b 00                	mov    (%eax),%eax
  8035fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	c1 e0 04             	shl    $0x4,%eax
  803606:	05 6c d2 81 00       	add    $0x81d26c,%eax
  80360b:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80360d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803610:	01 45 ec             	add    %eax,-0x14(%ebp)
  803613:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80361a:	0f 86 3c ff ff ff    	jbe    80355c <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  803620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803623:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  803629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362c:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  803632:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803636:	75 17                	jne    80364f <free_block+0x265>
  803638:	83 ec 04             	sub    $0x4,%esp
  80363b:	68 7c 47 80 00       	push   $0x80477c
  803640:	68 fe 00 00 00       	push   $0xfe
  803645:	68 03 47 80 00       	push   $0x804703
  80364a:	e8 c5 dc ff ff       	call   801314 <_panic>
  80364f:	8b 15 2c 52 80 00    	mov    0x80522c,%edx
  803655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803658:	89 50 04             	mov    %edx,0x4(%eax)
  80365b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365e:	8b 40 04             	mov    0x4(%eax),%eax
  803661:	85 c0                	test   %eax,%eax
  803663:	74 0c                	je     803671 <free_block+0x287>
  803665:	a1 2c 52 80 00       	mov    0x80522c,%eax
  80366a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80366d:	89 10                	mov    %edx,(%eax)
  80366f:	eb 08                	jmp    803679 <free_block+0x28f>
  803671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803674:	a3 28 52 80 00       	mov    %eax,0x805228
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	a3 2c 52 80 00       	mov    %eax,0x80522c
  803681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803684:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80368a:	a1 34 52 80 00       	mov    0x805234,%eax
  80368f:	40                   	inc    %eax
  803690:	a3 34 52 80 00       	mov    %eax,0x805234
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  803695:	83 ec 0c             	sub    $0xc,%esp
  803698:	ff 75 e4             	pushl  -0x1c(%ebp)
  80369b:	e8 88 f5 ff ff       	call   802c28 <to_page_va>
  8036a0:	83 c4 10             	add    $0x10,%esp
  8036a3:	83 ec 0c             	sub    $0xc,%esp
  8036a6:	50                   	push   %eax
  8036a7:	e8 b8 ee ff ff       	call   802564 <return_page>
  8036ac:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8036af:	90                   	nop
  8036b0:	c9                   	leave  
  8036b1:	c3                   	ret    

008036b2 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
  8036b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 28 48 80 00       	push   $0x804828
  8036c0:	68 11 01 00 00       	push   $0x111
  8036c5:	68 03 47 80 00       	push   $0x804703
  8036ca:	e8 45 dc ff ff       	call   801314 <_panic>
  8036cf:	90                   	nop

008036d0 <__udivdi3>:
  8036d0:	55                   	push   %ebp
  8036d1:	57                   	push   %edi
  8036d2:	56                   	push   %esi
  8036d3:	53                   	push   %ebx
  8036d4:	83 ec 1c             	sub    $0x1c,%esp
  8036d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036e7:	89 ca                	mov    %ecx,%edx
  8036e9:	89 f8                	mov    %edi,%eax
  8036eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036ef:	85 f6                	test   %esi,%esi
  8036f1:	75 2d                	jne    803720 <__udivdi3+0x50>
  8036f3:	39 cf                	cmp    %ecx,%edi
  8036f5:	77 65                	ja     80375c <__udivdi3+0x8c>
  8036f7:	89 fd                	mov    %edi,%ebp
  8036f9:	85 ff                	test   %edi,%edi
  8036fb:	75 0b                	jne    803708 <__udivdi3+0x38>
  8036fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803702:	31 d2                	xor    %edx,%edx
  803704:	f7 f7                	div    %edi
  803706:	89 c5                	mov    %eax,%ebp
  803708:	31 d2                	xor    %edx,%edx
  80370a:	89 c8                	mov    %ecx,%eax
  80370c:	f7 f5                	div    %ebp
  80370e:	89 c1                	mov    %eax,%ecx
  803710:	89 d8                	mov    %ebx,%eax
  803712:	f7 f5                	div    %ebp
  803714:	89 cf                	mov    %ecx,%edi
  803716:	89 fa                	mov    %edi,%edx
  803718:	83 c4 1c             	add    $0x1c,%esp
  80371b:	5b                   	pop    %ebx
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	39 ce                	cmp    %ecx,%esi
  803722:	77 28                	ja     80374c <__udivdi3+0x7c>
  803724:	0f bd fe             	bsr    %esi,%edi
  803727:	83 f7 1f             	xor    $0x1f,%edi
  80372a:	75 40                	jne    80376c <__udivdi3+0x9c>
  80372c:	39 ce                	cmp    %ecx,%esi
  80372e:	72 0a                	jb     80373a <__udivdi3+0x6a>
  803730:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803734:	0f 87 9e 00 00 00    	ja     8037d8 <__udivdi3+0x108>
  80373a:	b8 01 00 00 00       	mov    $0x1,%eax
  80373f:	89 fa                	mov    %edi,%edx
  803741:	83 c4 1c             	add    $0x1c,%esp
  803744:	5b                   	pop    %ebx
  803745:	5e                   	pop    %esi
  803746:	5f                   	pop    %edi
  803747:	5d                   	pop    %ebp
  803748:	c3                   	ret    
  803749:	8d 76 00             	lea    0x0(%esi),%esi
  80374c:	31 ff                	xor    %edi,%edi
  80374e:	31 c0                	xor    %eax,%eax
  803750:	89 fa                	mov    %edi,%edx
  803752:	83 c4 1c             	add    $0x1c,%esp
  803755:	5b                   	pop    %ebx
  803756:	5e                   	pop    %esi
  803757:	5f                   	pop    %edi
  803758:	5d                   	pop    %ebp
  803759:	c3                   	ret    
  80375a:	66 90                	xchg   %ax,%ax
  80375c:	89 d8                	mov    %ebx,%eax
  80375e:	f7 f7                	div    %edi
  803760:	31 ff                	xor    %edi,%edi
  803762:	89 fa                	mov    %edi,%edx
  803764:	83 c4 1c             	add    $0x1c,%esp
  803767:	5b                   	pop    %ebx
  803768:	5e                   	pop    %esi
  803769:	5f                   	pop    %edi
  80376a:	5d                   	pop    %ebp
  80376b:	c3                   	ret    
  80376c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803771:	89 eb                	mov    %ebp,%ebx
  803773:	29 fb                	sub    %edi,%ebx
  803775:	89 f9                	mov    %edi,%ecx
  803777:	d3 e6                	shl    %cl,%esi
  803779:	89 c5                	mov    %eax,%ebp
  80377b:	88 d9                	mov    %bl,%cl
  80377d:	d3 ed                	shr    %cl,%ebp
  80377f:	89 e9                	mov    %ebp,%ecx
  803781:	09 f1                	or     %esi,%ecx
  803783:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803787:	89 f9                	mov    %edi,%ecx
  803789:	d3 e0                	shl    %cl,%eax
  80378b:	89 c5                	mov    %eax,%ebp
  80378d:	89 d6                	mov    %edx,%esi
  80378f:	88 d9                	mov    %bl,%cl
  803791:	d3 ee                	shr    %cl,%esi
  803793:	89 f9                	mov    %edi,%ecx
  803795:	d3 e2                	shl    %cl,%edx
  803797:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379b:	88 d9                	mov    %bl,%cl
  80379d:	d3 e8                	shr    %cl,%eax
  80379f:	09 c2                	or     %eax,%edx
  8037a1:	89 d0                	mov    %edx,%eax
  8037a3:	89 f2                	mov    %esi,%edx
  8037a5:	f7 74 24 0c          	divl   0xc(%esp)
  8037a9:	89 d6                	mov    %edx,%esi
  8037ab:	89 c3                	mov    %eax,%ebx
  8037ad:	f7 e5                	mul    %ebp
  8037af:	39 d6                	cmp    %edx,%esi
  8037b1:	72 19                	jb     8037cc <__udivdi3+0xfc>
  8037b3:	74 0b                	je     8037c0 <__udivdi3+0xf0>
  8037b5:	89 d8                	mov    %ebx,%eax
  8037b7:	31 ff                	xor    %edi,%edi
  8037b9:	e9 58 ff ff ff       	jmp    803716 <__udivdi3+0x46>
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037c4:	89 f9                	mov    %edi,%ecx
  8037c6:	d3 e2                	shl    %cl,%edx
  8037c8:	39 c2                	cmp    %eax,%edx
  8037ca:	73 e9                	jae    8037b5 <__udivdi3+0xe5>
  8037cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037cf:	31 ff                	xor    %edi,%edi
  8037d1:	e9 40 ff ff ff       	jmp    803716 <__udivdi3+0x46>
  8037d6:	66 90                	xchg   %ax,%ax
  8037d8:	31 c0                	xor    %eax,%eax
  8037da:	e9 37 ff ff ff       	jmp    803716 <__udivdi3+0x46>
  8037df:	90                   	nop

008037e0 <__umoddi3>:
  8037e0:	55                   	push   %ebp
  8037e1:	57                   	push   %edi
  8037e2:	56                   	push   %esi
  8037e3:	53                   	push   %ebx
  8037e4:	83 ec 1c             	sub    $0x1c,%esp
  8037e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037ff:	89 f3                	mov    %esi,%ebx
  803801:	89 fa                	mov    %edi,%edx
  803803:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803807:	89 34 24             	mov    %esi,(%esp)
  80380a:	85 c0                	test   %eax,%eax
  80380c:	75 1a                	jne    803828 <__umoddi3+0x48>
  80380e:	39 f7                	cmp    %esi,%edi
  803810:	0f 86 a2 00 00 00    	jbe    8038b8 <__umoddi3+0xd8>
  803816:	89 c8                	mov    %ecx,%eax
  803818:	89 f2                	mov    %esi,%edx
  80381a:	f7 f7                	div    %edi
  80381c:	89 d0                	mov    %edx,%eax
  80381e:	31 d2                	xor    %edx,%edx
  803820:	83 c4 1c             	add    $0x1c,%esp
  803823:	5b                   	pop    %ebx
  803824:	5e                   	pop    %esi
  803825:	5f                   	pop    %edi
  803826:	5d                   	pop    %ebp
  803827:	c3                   	ret    
  803828:	39 f0                	cmp    %esi,%eax
  80382a:	0f 87 ac 00 00 00    	ja     8038dc <__umoddi3+0xfc>
  803830:	0f bd e8             	bsr    %eax,%ebp
  803833:	83 f5 1f             	xor    $0x1f,%ebp
  803836:	0f 84 ac 00 00 00    	je     8038e8 <__umoddi3+0x108>
  80383c:	bf 20 00 00 00       	mov    $0x20,%edi
  803841:	29 ef                	sub    %ebp,%edi
  803843:	89 fe                	mov    %edi,%esi
  803845:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803849:	89 e9                	mov    %ebp,%ecx
  80384b:	d3 e0                	shl    %cl,%eax
  80384d:	89 d7                	mov    %edx,%edi
  80384f:	89 f1                	mov    %esi,%ecx
  803851:	d3 ef                	shr    %cl,%edi
  803853:	09 c7                	or     %eax,%edi
  803855:	89 e9                	mov    %ebp,%ecx
  803857:	d3 e2                	shl    %cl,%edx
  803859:	89 14 24             	mov    %edx,(%esp)
  80385c:	89 d8                	mov    %ebx,%eax
  80385e:	d3 e0                	shl    %cl,%eax
  803860:	89 c2                	mov    %eax,%edx
  803862:	8b 44 24 08          	mov    0x8(%esp),%eax
  803866:	d3 e0                	shl    %cl,%eax
  803868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80386c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803870:	89 f1                	mov    %esi,%ecx
  803872:	d3 e8                	shr    %cl,%eax
  803874:	09 d0                	or     %edx,%eax
  803876:	d3 eb                	shr    %cl,%ebx
  803878:	89 da                	mov    %ebx,%edx
  80387a:	f7 f7                	div    %edi
  80387c:	89 d3                	mov    %edx,%ebx
  80387e:	f7 24 24             	mull   (%esp)
  803881:	89 c6                	mov    %eax,%esi
  803883:	89 d1                	mov    %edx,%ecx
  803885:	39 d3                	cmp    %edx,%ebx
  803887:	0f 82 87 00 00 00    	jb     803914 <__umoddi3+0x134>
  80388d:	0f 84 91 00 00 00    	je     803924 <__umoddi3+0x144>
  803893:	8b 54 24 04          	mov    0x4(%esp),%edx
  803897:	29 f2                	sub    %esi,%edx
  803899:	19 cb                	sbb    %ecx,%ebx
  80389b:	89 d8                	mov    %ebx,%eax
  80389d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038a1:	d3 e0                	shl    %cl,%eax
  8038a3:	89 e9                	mov    %ebp,%ecx
  8038a5:	d3 ea                	shr    %cl,%edx
  8038a7:	09 d0                	or     %edx,%eax
  8038a9:	89 e9                	mov    %ebp,%ecx
  8038ab:	d3 eb                	shr    %cl,%ebx
  8038ad:	89 da                	mov    %ebx,%edx
  8038af:	83 c4 1c             	add    $0x1c,%esp
  8038b2:	5b                   	pop    %ebx
  8038b3:	5e                   	pop    %esi
  8038b4:	5f                   	pop    %edi
  8038b5:	5d                   	pop    %ebp
  8038b6:	c3                   	ret    
  8038b7:	90                   	nop
  8038b8:	89 fd                	mov    %edi,%ebp
  8038ba:	85 ff                	test   %edi,%edi
  8038bc:	75 0b                	jne    8038c9 <__umoddi3+0xe9>
  8038be:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c3:	31 d2                	xor    %edx,%edx
  8038c5:	f7 f7                	div    %edi
  8038c7:	89 c5                	mov    %eax,%ebp
  8038c9:	89 f0                	mov    %esi,%eax
  8038cb:	31 d2                	xor    %edx,%edx
  8038cd:	f7 f5                	div    %ebp
  8038cf:	89 c8                	mov    %ecx,%eax
  8038d1:	f7 f5                	div    %ebp
  8038d3:	89 d0                	mov    %edx,%eax
  8038d5:	e9 44 ff ff ff       	jmp    80381e <__umoddi3+0x3e>
  8038da:	66 90                	xchg   %ax,%ax
  8038dc:	89 c8                	mov    %ecx,%eax
  8038de:	89 f2                	mov    %esi,%edx
  8038e0:	83 c4 1c             	add    $0x1c,%esp
  8038e3:	5b                   	pop    %ebx
  8038e4:	5e                   	pop    %esi
  8038e5:	5f                   	pop    %edi
  8038e6:	5d                   	pop    %ebp
  8038e7:	c3                   	ret    
  8038e8:	3b 04 24             	cmp    (%esp),%eax
  8038eb:	72 06                	jb     8038f3 <__umoddi3+0x113>
  8038ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038f1:	77 0f                	ja     803902 <__umoddi3+0x122>
  8038f3:	89 f2                	mov    %esi,%edx
  8038f5:	29 f9                	sub    %edi,%ecx
  8038f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038fb:	89 14 24             	mov    %edx,(%esp)
  8038fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803902:	8b 44 24 04          	mov    0x4(%esp),%eax
  803906:	8b 14 24             	mov    (%esp),%edx
  803909:	83 c4 1c             	add    $0x1c,%esp
  80390c:	5b                   	pop    %ebx
  80390d:	5e                   	pop    %esi
  80390e:	5f                   	pop    %edi
  80390f:	5d                   	pop    %ebp
  803910:	c3                   	ret    
  803911:	8d 76 00             	lea    0x0(%esi),%esi
  803914:	2b 04 24             	sub    (%esp),%eax
  803917:	19 fa                	sbb    %edi,%edx
  803919:	89 d1                	mov    %edx,%ecx
  80391b:	89 c6                	mov    %eax,%esi
  80391d:	e9 71 ff ff ff       	jmp    803893 <__umoddi3+0xb3>
  803922:	66 90                	xchg   %ax,%ax
  803924:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803928:	72 ea                	jb     803914 <__umoddi3+0x134>
  80392a:	89 d9                	mov    %ebx,%ecx
  80392c:	e9 62 ff ff ff       	jmp    803893 <__umoddi3+0xb3>
