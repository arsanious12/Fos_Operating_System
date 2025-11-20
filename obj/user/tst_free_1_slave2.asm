
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 ad 02 00 00       	call   8002e3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
#if USE_KHEAP

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 40 80 00       	mov    0x804020,%eax
  800048:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  80004e:	a1 20 40 80 00       	mov    0x804020,%eax
  800053:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 c0 2a 80 00       	push   $0x802ac0
  800065:	6a 12                	push   $0x12
  800067:	68 dc 2a 80 00       	push   $0x802adc
  80006c:	e8 22 04 00 00       	call   800493 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 5b 18 00 00       	call   80191c <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 9e 18 00 00       	call   801967 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 46 16 00 00       	call   801723 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 f8 2a 80 00       	push   $0x802af8
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 dc 2a 80 00       	push   $0x802adc
  800100:	e8 8e 03 00 00       	call   800493 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 5d 18 00 00       	call   801967 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 28 2b 80 00       	push   $0x802b28
  800117:	6a 32                	push   $0x32
  800119:	68 dc 2a 80 00       	push   $0x802adc
  80011e:	e8 70 03 00 00       	call   800493 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 f4 17 00 00       	call   80191c <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 b8 17 00 00       	call   80191c <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 58 2b 80 00       	push   $0x802b58
  800181:	6a 3c                	push   $0x3c
  800183:	68 dc 2a 80 00       	push   $0x802adc
  800188:	e8 06 03 00 00       	call   800493 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 12 1b 00 00       	call   801cde <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 d4 2b 80 00       	push   $0x802bd4
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 dc 2a 80 00       	push   $0x802adc
  8001e7:	e8 a7 02 00 00       	call   800493 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 2b 17 00 00       	call   80191c <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 6e 17 00 00       	call   801967 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 46 15 00 00       	call   801751 <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 54 17 00 00       	call   801967 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 f4 2b 80 00       	push   $0x802bf4
  800220:	6a 4d                	push   $0x4d
  800222:	68 dc 2a 80 00       	push   $0x802adc
  800227:	e8 67 02 00 00       	call   800493 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 eb 16 00 00       	call   80191c <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 30 2c 80 00       	push   $0x802c30
  800247:	6a 4e                	push   $0x4e
  800249:	68 dc 2a 80 00       	push   $0x802adc
  80024e:	e8 40 02 00 00       	call   800493 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 4c 1a 00 00       	call   801cde <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 7c 2c 80 00       	push   $0x802c7c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 dc 2a 80 00       	push   $0x802adc
  8002ad:	e8 e1 01 00 00       	call   800493 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 6c 19 00 00       	call   801c23 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 80 19 00 00       	call   801c3d <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 54 19 00 00       	call   801c23 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 a0 2c 80 00       	push   $0x802ca0
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 dc 2a 80 00       	push   $0x802adc
  8002de:	e8 b0 01 00 00       	call   800493 <_panic>

008002e3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	57                   	push   %edi
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ec:	e8 f4 17 00 00       	call   801ae5 <sys_getenvindex>
  8002f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002f7:	89 d0                	mov    %edx,%eax
  8002f9:	c1 e0 02             	shl    $0x2,%eax
  8002fc:	01 d0                	add    %edx,%eax
  8002fe:	c1 e0 03             	shl    $0x3,%eax
  800301:	01 d0                	add    %edx,%eax
  800303:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80030a:	01 d0                	add    %edx,%eax
  80030c:	c1 e0 02             	shl    $0x2,%eax
  80030f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800314:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800319:	a1 20 40 80 00       	mov    0x804020,%eax
  80031e:	8a 40 20             	mov    0x20(%eax),%al
  800321:	84 c0                	test   %al,%al
  800323:	74 0d                	je     800332 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	83 c0 20             	add    $0x20,%eax
  80032d:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800336:	7e 0a                	jle    800342 <libmain+0x5f>
		binaryname = argv[0];
  800338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033b:	8b 00                	mov    (%eax),%eax
  80033d:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	ff 75 0c             	pushl  0xc(%ebp)
  800348:	ff 75 08             	pushl  0x8(%ebp)
  80034b:	e8 e8 fc ff ff       	call   800038 <_main>
  800350:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800353:	a1 00 40 80 00       	mov    0x804000,%eax
  800358:	85 c0                	test   %eax,%eax
  80035a:	0f 84 01 01 00 00    	je     800461 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800360:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800366:	bb e4 2d 80 00       	mov    $0x802de4,%ebx
  80036b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800370:	89 c7                	mov    %eax,%edi
  800372:	89 de                	mov    %ebx,%esi
  800374:	89 d1                	mov    %edx,%ecx
  800376:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800378:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80037b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800380:	b0 00                	mov    $0x0,%al
  800382:	89 d7                	mov    %edx,%edi
  800384:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800386:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80038d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	50                   	push   %eax
  800394:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80039a:	50                   	push   %eax
  80039b:	e8 7b 19 00 00       	call   801d1b <sys_utilities>
  8003a0:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a3:	e8 c4 14 00 00       	call   80186c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 04 2d 80 00       	push   $0x802d04
  8003b0:	e8 ac 03 00 00       	call   800761 <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 18                	je     8003d7 <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003bf:	e8 75 19 00 00       	call   801d39 <sys_get_optimal_num_faults>
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	50                   	push   %eax
  8003c8:	68 2c 2d 80 00       	push   $0x802d2c
  8003cd:	e8 8f 03 00 00       	call   800761 <cprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	eb 59                	jmp    800430 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003dc:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	52                   	push   %edx
  8003f1:	50                   	push   %eax
  8003f2:	68 50 2d 80 00       	push   $0x802d50
  8003f7:	e8 65 03 00 00       	call   800761 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800404:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80040a:	a1 20 40 80 00       	mov    0x804020,%eax
  80040f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800420:	51                   	push   %ecx
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	68 78 2d 80 00       	push   $0x802d78
  800428:	e8 34 03 00 00       	call   800761 <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	50                   	push   %eax
  80043f:	68 d0 2d 80 00       	push   $0x802dd0
  800444:	e8 18 03 00 00       	call   800761 <cprintf>
  800449:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	68 04 2d 80 00       	push   $0x802d04
  800454:	e8 08 03 00 00       	call   800761 <cprintf>
  800459:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80045c:	e8 25 14 00 00       	call   801886 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800461:	e8 1f 00 00 00       	call   800485 <exit>
}
  800466:	90                   	nop
  800467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046a:	5b                   	pop    %ebx
  80046b:	5e                   	pop    %esi
  80046c:	5f                   	pop    %edi
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	6a 00                	push   $0x0
  80047a:	e8 32 16 00 00       	call   801ab1 <sys_destroy_env>
  80047f:	83 c4 10             	add    $0x10,%esp
}
  800482:	90                   	nop
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <exit>:

void
exit(void)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048b:	e8 87 16 00 00       	call   801b17 <sys_exit_env>
}
  800490:	90                   	nop
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800499:	8d 45 10             	lea    0x10(%ebp),%eax
  80049c:	83 c0 04             	add    $0x4,%eax
  80049f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a2:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 16                	je     8004c1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ab:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	50                   	push   %eax
  8004b4:	68 48 2e 80 00       	push   $0x802e48
  8004b9:	e8 a3 02 00 00       	call   800761 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8004c6:	83 ec 0c             	sub    $0xc,%esp
  8004c9:	ff 75 0c             	pushl  0xc(%ebp)
  8004cc:	ff 75 08             	pushl  0x8(%ebp)
  8004cf:	50                   	push   %eax
  8004d0:	68 50 2e 80 00       	push   $0x802e50
  8004d5:	6a 74                	push   $0x74
  8004d7:	e8 b2 02 00 00       	call   80078e <cprintf_colored>
  8004dc:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004df:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	50                   	push   %eax
  8004e9:	e8 04 02 00 00       	call   8006f2 <vcprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	6a 00                	push   $0x0
  8004f6:	68 78 2e 80 00       	push   $0x802e78
  8004fb:	e8 f2 01 00 00       	call   8006f2 <vcprintf>
  800500:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800503:	e8 7d ff ff ff       	call   800485 <exit>

	// should not return here
	while (1) ;
  800508:	eb fe                	jmp    800508 <_panic+0x75>

0080050a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050a:	55                   	push   %ebp
  80050b:	89 e5                	mov    %esp,%ebp
  80050d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800510:	a1 20 40 80 00       	mov    0x804020,%eax
  800515:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	39 c2                	cmp    %eax,%edx
  800520:	74 14                	je     800536 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	68 7c 2e 80 00       	push   $0x802e7c
  80052a:	6a 26                	push   $0x26
  80052c:	68 c8 2e 80 00       	push   $0x802ec8
  800531:	e8 5d ff ff ff       	call   800493 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800544:	e9 c5 00 00 00       	jmp    80060e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800553:	8b 45 08             	mov    0x8(%ebp),%eax
  800556:	01 d0                	add    %edx,%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	85 c0                	test   %eax,%eax
  80055c:	75 08                	jne    800566 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80055e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800561:	e9 a5 00 00 00       	jmp    80060b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800566:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800574:	eb 69                	jmp    8005df <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800576:	a1 20 40 80 00       	mov    0x804020,%eax
  80057b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800581:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800584:	89 d0                	mov    %edx,%eax
  800586:	01 c0                	add    %eax,%eax
  800588:	01 d0                	add    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	8a 40 04             	mov    0x4(%eax),%al
  800592:	84 c0                	test   %al,%al
  800594:	75 46                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800596:	a1 20 40 80 00       	mov    0x804020,%eax
  80059b:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	01 c8                	add    %ecx,%eax
  8005cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cf:	39 c2                	cmp    %eax,%edx
  8005d1:	75 09                	jne    8005dc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005da:	eb 15                	jmp    8005f1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005dc:	ff 45 e8             	incl   -0x18(%ebp)
  8005df:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ed:	39 c2                	cmp    %eax,%edx
  8005ef:	77 85                	ja     800576 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f5:	75 14                	jne    80060b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005f7:	83 ec 04             	sub    $0x4,%esp
  8005fa:	68 d4 2e 80 00       	push   $0x802ed4
  8005ff:	6a 3a                	push   $0x3a
  800601:	68 c8 2e 80 00       	push   $0x802ec8
  800606:	e8 88 fe ff ff       	call   800493 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060b:	ff 45 f0             	incl   -0x10(%ebp)
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800614:	0f 8c 2f ff ff ff    	jl     800549 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800621:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800628:	eb 26                	jmp    800650 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062a:	a1 20 40 80 00       	mov    0x804020,%eax
  80062f:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  800635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800638:	89 d0                	mov    %edx,%eax
  80063a:	01 c0                	add    %eax,%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	c1 e0 03             	shl    $0x3,%eax
  800641:	01 c8                	add    %ecx,%eax
  800643:	8a 40 04             	mov    0x4(%eax),%al
  800646:	3c 01                	cmp    $0x1,%al
  800648:	75 03                	jne    80064d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80064a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064d:	ff 45 e0             	incl   -0x20(%ebp)
  800650:	a1 20 40 80 00       	mov    0x804020,%eax
  800655:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80065b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065e:	39 c2                	cmp    %eax,%edx
  800660:	77 c8                	ja     80062a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800665:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800668:	74 14                	je     80067e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	68 28 2f 80 00       	push   $0x802f28
  800672:	6a 44                	push   $0x44
  800674:	68 c8 2e 80 00       	push   $0x802ec8
  800679:	e8 15 fe ff ff       	call   800493 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80067e:	90                   	nop
  80067f:	c9                   	leave  
  800680:	c3                   	ret    

00800681 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800681:	55                   	push   %ebp
  800682:	89 e5                	mov    %esp,%ebp
  800684:	53                   	push   %ebx
  800685:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 48 01             	lea    0x1(%eax),%ecx
  800690:	8b 55 0c             	mov    0xc(%ebp),%edx
  800693:	89 0a                	mov    %ecx,(%edx)
  800695:	8b 55 08             	mov    0x8(%ebp),%edx
  800698:	88 d1                	mov    %dl,%cl
  80069a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ab:	75 30                	jne    8006dd <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006ad:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006b3:	a0 44 40 80 00       	mov    0x804044,%al
  8006b8:	0f b6 c0             	movzbl %al,%eax
  8006bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006be:	8b 09                	mov    (%ecx),%ecx
  8006c0:	89 cb                	mov    %ecx,%ebx
  8006c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c5:	83 c1 08             	add    $0x8,%ecx
  8006c8:	52                   	push   %edx
  8006c9:	50                   	push   %eax
  8006ca:	53                   	push   %ebx
  8006cb:	51                   	push   %ecx
  8006cc:	e8 57 11 00 00       	call   801828 <sys_cputs>
  8006d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	8b 40 04             	mov    0x4(%eax),%eax
  8006e3:	8d 50 01             	lea    0x1(%eax),%edx
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ec:	90                   	nop
  8006ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f0:	c9                   	leave  
  8006f1:	c3                   	ret    

008006f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800702:	00 00 00 
	b.cnt = 0;
  800705:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070f:	ff 75 0c             	pushl  0xc(%ebp)
  800712:	ff 75 08             	pushl  0x8(%ebp)
  800715:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071b:	50                   	push   %eax
  80071c:	68 81 06 80 00       	push   $0x800681
  800721:	e8 5a 02 00 00       	call   800980 <vprintfmt>
  800726:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800729:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80072f:	a0 44 40 80 00       	mov    0x804044,%al
  800734:	0f b6 c0             	movzbl %al,%eax
  800737:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	51                   	push   %ecx
  800740:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800746:	83 c0 08             	add    $0x8,%eax
  800749:	50                   	push   %eax
  80074a:	e8 d9 10 00 00       	call   801828 <sys_cputs>
  80074f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800752:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800759:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80075f:	c9                   	leave  
  800760:	c3                   	ret    

00800761 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800767:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  80076e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 f4             	pushl  -0xc(%ebp)
  80077d:	50                   	push   %eax
  80077e:	e8 6f ff ff ff       	call   8006f2 <vcprintf>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    

0080078e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800794:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	c1 e0 08             	shl    $0x8,%eax
  8007a1:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  8007a6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a9:	83 c0 04             	add    $0x4,%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	e8 34 ff ff ff       	call   8006f2 <vcprintf>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c4:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007cb:	07 00 00 

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007d9:	e8 8e 10 00 00       	call   80186c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 ff fe ff ff       	call   8006f2 <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007f9:	e8 88 10 00 00       	call   801886 <sys_unlock_cons>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 08 20 00 00       	call   802850 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 c8 20 00 00       	call   802960 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 94 31 80 00       	add    $0x803194,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 c1 03 00 00    	je     800d53 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 5b             	cmp    $0x5b,%eax
  8009e8:	0f 87 3d 03 00 00    	ja     800d2b <vprintfmt+0x3ab>
  8009ee:	8b 04 85 b8 31 80 00 	mov    0x8031b8(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 9b 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 00 30 80 00 	mov    0x803000(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 a5 31 80 00       	push   $0x8031a5
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 70 02 00 00       	call   800d5b <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 5b 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 ae 31 80 00       	push   $0x8031ae
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 57 02 00 00       	call   800d5b <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 42 02 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be b1 31 80 00       	mov    $0x8031b1,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 1e 03 00 00       	call   800e5d <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 78 01 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 ce 00 00 00       	jmp    800d4e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 46                	jmp    800d4e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 35                	jmp    800d4e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d19:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d20:	eb 2c                	jmp    800d4e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d22:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d29:	eb 23                	jmp    800d4e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2b:	83 ec 08             	sub    $0x8,%esp
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	6a 25                	push   $0x25
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	ff d0                	call   *%eax
  800d38:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3b:	ff 4d 10             	decl   0x10(%ebp)
  800d3e:	eb 03                	jmp    800d43 <vprintfmt+0x3c3>
  800d40:	ff 4d 10             	decl   0x10(%ebp)
  800d43:	8b 45 10             	mov    0x10(%ebp),%eax
  800d46:	48                   	dec    %eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 25                	cmp    $0x25,%al
  800d4b:	75 f3                	jne    800d40 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d4d:	90                   	nop
		}
	}
  800d4e:	e9 35 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d53:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d61:	8d 45 10             	lea    0x10(%ebp),%eax
  800d64:	83 c0 04             	add    $0x4,%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d70:	50                   	push   %eax
  800d71:	ff 75 0c             	pushl  0xc(%ebp)
  800d74:	ff 75 08             	pushl  0x8(%ebp)
  800d77:	e8 04 fc ff ff       	call   800980 <vprintfmt>
  800d7c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d7f:	90                   	nop
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8b 40 08             	mov    0x8(%eax),%eax
  800d8b:	8d 50 01             	lea    0x1(%eax),%edx
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8b 10                	mov    (%eax),%edx
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 40 04             	mov    0x4(%eax),%eax
  800d9f:	39 c2                	cmp    %eax,%edx
  800da1:	73 12                	jae    800db5 <sprintputch+0x33>
		*b->buf++ = ch;
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8b 00                	mov    (%eax),%eax
  800da8:	8d 48 01             	lea    0x1(%eax),%ecx
  800dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dae:	89 0a                	mov    %ecx,(%edx)
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	88 10                	mov    %dl,(%eax)
}
  800db5:	90                   	nop
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	01 d0                	add    %edx,%eax
  800dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ddd:	74 06                	je     800de5 <vsnprintf+0x2d>
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	7f 07                	jg     800dec <vsnprintf+0x34>
		return -E_INVAL;
  800de5:	b8 03 00 00 00       	mov    $0x3,%eax
  800dea:	eb 20                	jmp    800e0c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dec:	ff 75 14             	pushl  0x14(%ebp)
  800def:	ff 75 10             	pushl  0x10(%ebp)
  800df2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df5:	50                   	push   %eax
  800df6:	68 82 0d 80 00       	push   $0x800d82
  800dfb:	e8 80 fb ff ff       	call   800980 <vprintfmt>
  800e00:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e06:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e14:	8d 45 10             	lea    0x10(%ebp),%eax
  800e17:	83 c0 04             	add    $0x4,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	ff 75 f4             	pushl  -0xc(%ebp)
  800e23:	50                   	push   %eax
  800e24:	ff 75 0c             	pushl  0xc(%ebp)
  800e27:	ff 75 08             	pushl  0x8(%ebp)
  800e2a:	e8 89 ff ff ff       	call   800db8 <vsnprintf>
  800e2f:	83 c4 10             	add    $0x10,%esp
  800e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e40:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e47:	eb 06                	jmp    800e4f <strlen+0x15>
		n++;
  800e49:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	84 c0                	test   %al,%al
  800e56:	75 f1                	jne    800e49 <strlen+0xf>
		n++;
	return n;
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6a:	eb 09                	jmp    800e75 <strnlen+0x18>
		n++;
  800e6c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6f:	ff 45 08             	incl   0x8(%ebp)
  800e72:	ff 4d 0c             	decl   0xc(%ebp)
  800e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e79:	74 09                	je     800e84 <strnlen+0x27>
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e8                	jne    800e6c <strnlen+0xf>
		n++;
	return n;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e95:	90                   	nop
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	84 c0                	test   %al,%al
  800eb0:	75 e4                	jne    800e96 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb5:	c9                   	leave  
  800eb6:	c3                   	ret    

00800eb7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eca:	eb 1f                	jmp    800eeb <strncpy+0x34>
		*dst++ = *src;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	8a 12                	mov    (%edx),%dl
  800eda:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	74 03                	je     800ee8 <strncpy+0x31>
			src++;
  800ee5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ee8:	ff 45 fc             	incl   -0x4(%ebp)
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef1:	72 d9                	jb     800ecc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f08:	74 30                	je     800f3a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0a:	eb 16                	jmp    800f22 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 08             	mov    %edx,0x8(%ebp)
  800f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f22:	ff 4d 10             	decl   0x10(%ebp)
  800f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f29:	74 09                	je     800f34 <strlcpy+0x3c>
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	75 d8                	jne    800f0c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f40:	29 c2                	sub    %eax,%edx
  800f42:	89 d0                	mov    %edx,%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f49:	eb 06                	jmp    800f51 <strcmp+0xb>
		p++, q++;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	84 c0                	test   %al,%al
  800f58:	74 0e                	je     800f68 <strcmp+0x22>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 10                	mov    (%eax),%dl
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	38 c2                	cmp    %al,%dl
  800f66:	74 e3                	je     800f4b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	0f b6 d0             	movzbl %al,%edx
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	0f b6 c0             	movzbl %al,%eax
  800f78:	29 c2                	sub    %eax,%edx
  800f7a:	89 d0                	mov    %edx,%eax
}
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f81:	eb 09                	jmp    800f8c <strncmp+0xe>
		n--, p++, q++;
  800f83:	ff 4d 10             	decl   0x10(%ebp)
  800f86:	ff 45 08             	incl   0x8(%ebp)
  800f89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f90:	74 17                	je     800fa9 <strncmp+0x2b>
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	84 c0                	test   %al,%al
  800f99:	74 0e                	je     800fa9 <strncmp+0x2b>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 10                	mov    (%eax),%dl
  800fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	38 c2                	cmp    %al,%dl
  800fa7:	74 da                	je     800f83 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fad:	75 07                	jne    800fb6 <strncmp+0x38>
		return 0;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb4:	eb 14                	jmp    800fca <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 d0             	movzbl %al,%edx
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 c0             	movzbl %al,%eax
  800fc6:	29 c2                	sub    %eax,%edx
  800fc8:	89 d0                	mov    %edx,%eax
}
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fd8:	eb 12                	jmp    800fec <strchr+0x20>
		if (*s == c)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe2:	75 05                	jne    800fe9 <strchr+0x1d>
			return (char *) s;
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	eb 11                	jmp    800ffa <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fe9:	ff 45 08             	incl   0x8(%ebp)
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	84 c0                	test   %al,%al
  800ff3:	75 e5                	jne    800fda <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    

00800ffc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 04             	sub    $0x4,%esp
  801002:	8b 45 0c             	mov    0xc(%ebp),%eax
  801005:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801008:	eb 0d                	jmp    801017 <strfind+0x1b>
		if (*s == c)
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801012:	74 0e                	je     801022 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801014:	ff 45 08             	incl   0x8(%ebp)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	84 c0                	test   %al,%al
  80101e:	75 ea                	jne    80100a <strfind+0xe>
  801020:	eb 01                	jmp    801023 <strfind+0x27>
		if (*s == c)
			break;
  801022:	90                   	nop
	return (char *) s;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801034:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801038:	76 63                	jbe    80109d <memset+0x75>
		uint64 data_block = c;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	99                   	cltd   
  80103e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801041:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80104e:	c1 e0 08             	shl    $0x8,%eax
  801051:	09 45 f0             	or     %eax,-0x10(%ebp)
  801054:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80105d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801061:	c1 e0 10             	shl    $0x10,%eax
  801064:	09 45 f0             	or     %eax,-0x10(%ebp)
  801067:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80106a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801070:	89 c2                	mov    %eax,%edx
  801072:	b8 00 00 00 00       	mov    $0x0,%eax
  801077:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80107d:	eb 18                	jmp    801097 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80107f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801082:	8d 41 08             	lea    0x8(%ecx),%eax
  801085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80108e:	89 01                	mov    %eax,(%ecx)
  801090:	89 51 04             	mov    %edx,0x4(%ecx)
  801093:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801097:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109b:	77 e2                	ja     80107f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80109d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a1:	74 23                	je     8010c6 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010a9:	eb 0e                	jmp    8010b9 <memset+0x91>
			*p8++ = (uint8)c;
  8010ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ae:	8d 50 01             	lea    0x1(%eax),%edx
  8010b1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bf:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c2:	85 c0                	test   %eax,%eax
  8010c4:	75 e5                	jne    8010ab <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c9:	c9                   	leave  
  8010ca:	c3                   	ret    

008010cb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010dd:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e1:	76 24                	jbe    801107 <memcpy+0x3c>
		while(n >= 8){
  8010e3:	eb 1c                	jmp    801101 <memcpy+0x36>
			*d64 = *s64;
  8010e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e8:	8b 50 04             	mov    0x4(%eax),%edx
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f0:	89 01                	mov    %eax,(%ecx)
  8010f2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010f9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010fd:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801101:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801105:	77 de                	ja     8010e5 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801107:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110b:	74 31                	je     80113e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801110:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801119:	eb 16                	jmp    801131 <memcpy+0x66>
			*d8++ = *s8++;
  80111b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111e:	8d 50 01             	lea    0x1(%eax),%edx
  801121:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801127:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801131:	8b 45 10             	mov    0x10(%ebp),%eax
  801134:	8d 50 ff             	lea    -0x1(%eax),%edx
  801137:	89 55 10             	mov    %edx,0x10(%ebp)
  80113a:	85 c0                	test   %eax,%eax
  80113c:	75 dd                	jne    80111b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801149:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801158:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115b:	73 50                	jae    8011ad <memmove+0x6a>
  80115d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801160:	8b 45 10             	mov    0x10(%ebp),%eax
  801163:	01 d0                	add    %edx,%eax
  801165:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801168:	76 43                	jbe    8011ad <memmove+0x6a>
		s += n;
  80116a:	8b 45 10             	mov    0x10(%ebp),%eax
  80116d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801176:	eb 10                	jmp    801188 <memmove+0x45>
			*--d = *--s;
  801178:	ff 4d f8             	decl   -0x8(%ebp)
  80117b:	ff 4d fc             	decl   -0x4(%ebp)
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	8a 10                	mov    (%eax),%dl
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118e:	89 55 10             	mov    %edx,0x10(%ebp)
  801191:	85 c0                	test   %eax,%eax
  801193:	75 e3                	jne    801178 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801195:	eb 23                	jmp    8011ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	8d 50 01             	lea    0x1(%eax),%edx
  80119d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a9:	8a 12                	mov    (%edx),%dl
  8011ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 dd                	jne    801197 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011d1:	eb 2a                	jmp    8011fd <memcmp+0x3e>
		if (*s1 != *s2)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	8a 10                	mov    (%eax),%dl
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	38 c2                	cmp    %al,%dl
  8011df:	74 16                	je     8011f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f b6 d0             	movzbl %al,%edx
  8011e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	0f b6 c0             	movzbl %al,%eax
  8011f1:	29 c2                	sub    %eax,%edx
  8011f3:	89 d0                	mov    %edx,%eax
  8011f5:	eb 18                	jmp    80120f <memcmp+0x50>
		s1++, s2++;
  8011f7:	ff 45 fc             	incl   -0x4(%ebp)
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	8d 50 ff             	lea    -0x1(%eax),%edx
  801203:	89 55 10             	mov    %edx,0x10(%ebp)
  801206:	85 c0                	test   %eax,%eax
  801208:	75 c9                	jne    8011d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120f:	c9                   	leave  
  801210:	c3                   	ret    

00801211 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	01 d0                	add    %edx,%eax
  80121f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801222:	eb 15                	jmp    801239 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	0f b6 d0             	movzbl %al,%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	0f b6 c0             	movzbl %al,%eax
  801232:	39 c2                	cmp    %eax,%edx
  801234:	74 0d                	je     801243 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801236:	ff 45 08             	incl   0x8(%ebp)
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123f:	72 e3                	jb     801224 <memfind+0x13>
  801241:	eb 01                	jmp    801244 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801243:	90                   	nop
	return (void *) s;
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801256:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125d:	eb 03                	jmp    801262 <strtol+0x19>
		s++;
  80125f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 20                	cmp    $0x20,%al
  801269:	74 f4                	je     80125f <strtol+0x16>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 09                	cmp    $0x9,%al
  801272:	74 eb                	je     80125f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 2b                	cmp    $0x2b,%al
  80127b:	75 05                	jne    801282 <strtol+0x39>
		s++;
  80127d:	ff 45 08             	incl   0x8(%ebp)
  801280:	eb 13                	jmp    801295 <strtol+0x4c>
	else if (*s == '-')
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	8a 00                	mov    (%eax),%al
  801287:	3c 2d                	cmp    $0x2d,%al
  801289:	75 0a                	jne    801295 <strtol+0x4c>
		s++, neg = 1;
  80128b:	ff 45 08             	incl   0x8(%ebp)
  80128e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801295:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801299:	74 06                	je     8012a1 <strtol+0x58>
  80129b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129f:	75 20                	jne    8012c1 <strtol+0x78>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 30                	cmp    $0x30,%al
  8012a8:	75 17                	jne    8012c1 <strtol+0x78>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	40                   	inc    %eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 78                	cmp    $0x78,%al
  8012b2:	75 0d                	jne    8012c1 <strtol+0x78>
		s += 2, base = 16;
  8012b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bf:	eb 28                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c5:	75 15                	jne    8012dc <strtol+0x93>
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	3c 30                	cmp    $0x30,%al
  8012ce:	75 0c                	jne    8012dc <strtol+0x93>
		s++, base = 8;
  8012d0:	ff 45 08             	incl   0x8(%ebp)
  8012d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012da:	eb 0d                	jmp    8012e9 <strtol+0xa0>
	else if (base == 0)
  8012dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e0:	75 07                	jne    8012e9 <strtol+0xa0>
		base = 10;
  8012e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	3c 2f                	cmp    $0x2f,%al
  8012f0:	7e 19                	jle    80130b <strtol+0xc2>
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 39                	cmp    $0x39,%al
  8012f9:	7f 10                	jg     80130b <strtol+0xc2>
			dig = *s - '0';
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	0f be c0             	movsbl %al,%eax
  801303:	83 e8 30             	sub    $0x30,%eax
  801306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801309:	eb 42                	jmp    80134d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	3c 60                	cmp    $0x60,%al
  801312:	7e 19                	jle    80132d <strtol+0xe4>
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 7a                	cmp    $0x7a,%al
  80131b:	7f 10                	jg     80132d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	0f be c0             	movsbl %al,%eax
  801325:	83 e8 57             	sub    $0x57,%eax
  801328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132b:	eb 20                	jmp    80134d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	3c 40                	cmp    $0x40,%al
  801334:	7e 39                	jle    80136f <strtol+0x126>
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 5a                	cmp    $0x5a,%al
  80133d:	7f 30                	jg     80136f <strtol+0x126>
			dig = *s - 'A' + 10;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	0f be c0             	movsbl %al,%eax
  801347:	83 e8 37             	sub    $0x37,%eax
  80134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801350:	3b 45 10             	cmp    0x10(%ebp),%eax
  801353:	7d 19                	jge    80136e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801355:	ff 45 08             	incl   0x8(%ebp)
  801358:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135f:	89 c2                	mov    %eax,%edx
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801369:	e9 7b ff ff ff       	jmp    8012e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801373:	74 08                	je     80137d <strtol+0x134>
		*endptr = (char *) s;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 55 08             	mov    0x8(%ebp),%edx
  80137b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80137d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801381:	74 07                	je     80138a <strtol+0x141>
  801383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801386:	f7 d8                	neg    %eax
  801388:	eb 03                	jmp    80138d <strtol+0x144>
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <ltostr>:

void
ltostr(long value, char *str)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801395:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80139c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a7:	79 13                	jns    8013bc <ltostr+0x2d>
	{
		neg = 1;
  8013a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c4:	99                   	cltd   
  8013c5:	f7 f9                	idiv   %ecx
  8013c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cd:	8d 50 01             	lea    0x1(%eax),%edx
  8013d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d8:	01 d0                	add    %edx,%eax
  8013da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013dd:	83 c2 30             	add    $0x30,%edx
  8013e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ea:	f7 e9                	imul   %ecx
  8013ec:	c1 fa 02             	sar    $0x2,%edx
  8013ef:	89 c8                	mov    %ecx,%eax
  8013f1:	c1 f8 1f             	sar    $0x1f,%eax
  8013f4:	29 c2                	sub    %eax,%edx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ff:	75 bb                	jne    8013bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801408:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140b:	48                   	dec    %eax
  80140c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80140f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801413:	74 3d                	je     801452 <ltostr+0xc3>
		start = 1 ;
  801415:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80141c:	eb 34                	jmp    801452 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 45 0c             	mov    0xc(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	8a 00                	mov    (%eax),%al
  801428:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	01 c2                	add    %eax,%edx
  801433:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801436:	8b 45 0c             	mov    0xc(%ebp),%eax
  801439:	01 c8                	add    %ecx,%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80143f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
  801445:	01 c2                	add    %eax,%edx
  801447:	8a 45 eb             	mov    -0x15(%ebp),%al
  80144a:	88 02                	mov    %al,(%edx)
		start++ ;
  80144c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80144f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801458:	7c c4                	jl     80141e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80145a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801465:	90                   	nop
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80146e:	ff 75 08             	pushl  0x8(%ebp)
  801471:	e8 c4 f9 ff ff       	call   800e3a <strlen>
  801476:	83 c4 04             	add    $0x4,%esp
  801479:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	e8 b6 f9 ff ff       	call   800e3a <strlen>
  801484:	83 c4 04             	add    $0x4,%esp
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80148a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801491:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801498:	eb 17                	jmp    8014b1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80149a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	01 c8                	add    %ecx,%eax
  8014aa:	8a 00                	mov    (%eax),%al
  8014ac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014ae:	ff 45 fc             	incl   -0x4(%ebp)
  8014b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014b7:	7c e1                	jl     80149a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014c7:	eb 1f                	jmp    8014e8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cc:	8d 50 01             	lea    0x1(%eax),%edx
  8014cf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	01 c2                	add    %eax,%edx
  8014d9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	01 c8                	add    %ecx,%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e5:	ff 45 f8             	incl   -0x8(%ebp)
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ee:	7c d9                	jl     8014c9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f6:	01 d0                	add    %edx,%eax
  8014f8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014fb:	90                   	nop
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801501:	8b 45 14             	mov    0x14(%ebp),%eax
  801504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801516:	8b 45 10             	mov    0x10(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801521:	eb 0c                	jmp    80152f <strsplit+0x31>
			*string++ = 0;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	8d 50 01             	lea    0x1(%eax),%edx
  801529:	89 55 08             	mov    %edx,0x8(%ebp)
  80152c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 00                	mov    (%eax),%al
  801534:	84 c0                	test   %al,%al
  801536:	74 18                	je     801550 <strsplit+0x52>
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	0f be c0             	movsbl %al,%eax
  801540:	50                   	push   %eax
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	e8 83 fa ff ff       	call   800fcc <strchr>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 d3                	jne    801523 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	84 c0                	test   %al,%al
  801557:	74 5a                	je     8015b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801559:	8b 45 14             	mov    0x14(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	83 f8 0f             	cmp    $0xf,%eax
  801561:	75 07                	jne    80156a <strsplit+0x6c>
		{
			return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
  801568:	eb 66                	jmp    8015d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 48 01             	lea    0x1(%eax),%ecx
  801572:	8b 55 14             	mov    0x14(%ebp),%edx
  801575:	89 0a                	mov    %ecx,(%edx)
  801577:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80157e:	8b 45 10             	mov    0x10(%ebp),%eax
  801581:	01 c2                	add    %eax,%edx
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801588:	eb 03                	jmp    80158d <strsplit+0x8f>
			string++;
  80158a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	8a 00                	mov    (%eax),%al
  801592:	84 c0                	test   %al,%al
  801594:	74 8b                	je     801521 <strsplit+0x23>
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	0f be c0             	movsbl %al,%eax
  80159e:	50                   	push   %eax
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	e8 25 fa ff ff       	call   800fcc <strchr>
  8015a7:	83 c4 08             	add    $0x8,%esp
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 dc                	je     80158a <strsplit+0x8c>
			string++;
	}
  8015ae:	e9 6e ff ff ff       	jmp    801521 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 4a                	jmp    801631 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	3c 40                	cmp    $0x40,%al
  801607:	7e 25                	jle    80162e <str2lower+0x5c>
  801609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	01 d0                	add    %edx,%eax
  801611:	8a 00                	mov    (%eax),%al
  801613:	3c 5a                	cmp    $0x5a,%al
  801615:	7f 17                	jg     80162e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801617:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801622:	8b 55 08             	mov    0x8(%ebp),%edx
  801625:	01 ca                	add    %ecx,%edx
  801627:	8a 12                	mov    (%edx),%dl
  801629:	83 c2 20             	add    $0x20,%edx
  80162c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80162e:	ff 45 fc             	incl   -0x4(%ebp)
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	e8 01 f8 ff ff       	call   800e3a <strlen>
  801639:	83 c4 04             	add    $0x4,%esp
  80163c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80163f:	7f a6                	jg     8015e7 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801641:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80164c:	a1 08 40 80 00       	mov    0x804008,%eax
  801651:	85 c0                	test   %eax,%eax
  801653:	74 42                	je     801697 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	68 00 00 00 82       	push   $0x82000000
  80165d:	68 00 00 00 80       	push   $0x80000000
  801662:	e8 00 08 00 00       	call   801e67 <initialize_dynamic_allocator>
  801667:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80166a:	e8 e7 05 00 00       	call   801c56 <sys_get_uheap_strategy>
  80166f:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801674:	a1 40 40 80 00       	mov    0x804040,%eax
  801679:	05 00 10 00 00       	add    $0x1000,%eax
  80167e:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801683:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801688:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80168d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801694:	00 00 00 
	}
}
  801697:	90                   	nop
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	68 06 04 00 00       	push   $0x406
  8016b6:	50                   	push   %eax
  8016b7:	e8 e4 01 00 00       	call   8018a0 <__sys_allocate_page>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016c6:	79 14                	jns    8016dc <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 28 33 80 00       	push   $0x803328
  8016d0:	6a 1f                	push   $0x1f
  8016d2:	68 64 33 80 00       	push   $0x803364
  8016d7:	e8 b7 ed ff ff       	call   800493 <_panic>
	return 0;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	50                   	push   %eax
  8016fb:	e8 e7 01 00 00       	call   8018e7 <__sys_unmap_frame>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170a:	79 14                	jns    801720 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	68 70 33 80 00       	push   $0x803370
  801714:	6a 2a                	push   $0x2a
  801716:	68 64 33 80 00       	push   $0x803364
  80171b:	e8 73 ed ff ff       	call   800493 <_panic>
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801729:	e8 18 ff ff ff       	call   801646 <uheap_init>
	if (size == 0) return NULL ;
  80172e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801732:	75 07                	jne    80173b <malloc+0x18>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	eb 14                	jmp    80174f <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	68 b0 33 80 00       	push   $0x8033b0
  801743:	6a 3e                	push   $0x3e
  801745:	68 64 33 80 00       	push   $0x803364
  80174a:	e8 44 ed ff ff       	call   800493 <_panic>
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801757:	83 ec 04             	sub    $0x4,%esp
  80175a:	68 d8 33 80 00       	push   $0x8033d8
  80175f:	6a 49                	push   $0x49
  801761:	68 64 33 80 00       	push   $0x803364
  801766:	e8 28 ed ff ff       	call   800493 <_panic>

0080176b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 18             	sub    $0x18,%esp
  801771:	8b 45 10             	mov    0x10(%ebp),%eax
  801774:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801777:	e8 ca fe ff ff       	call   801646 <uheap_init>
	if (size == 0) return NULL ;
  80177c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801780:	75 07                	jne    801789 <smalloc+0x1e>
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
  801787:	eb 14                	jmp    80179d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 fc 33 80 00       	push   $0x8033fc
  801791:	6a 5a                	push   $0x5a
  801793:	68 64 33 80 00       	push   $0x803364
  801798:	e8 f6 ec ff ff       	call   800493 <_panic>
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017a5:	e8 9c fe ff ff       	call   801646 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 24 34 80 00       	push   $0x803424
  8017b2:	6a 6a                	push   $0x6a
  8017b4:	68 64 33 80 00       	push   $0x803364
  8017b9:	e8 d5 ec ff ff       	call   800493 <_panic>

008017be <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017c4:	e8 7d fe ff ff       	call   801646 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 48 34 80 00       	push   $0x803448
  8017d1:	68 88 00 00 00       	push   $0x88
  8017d6:	68 64 33 80 00       	push   $0x803364
  8017db:	e8 b3 ec ff ff       	call   800493 <_panic>

008017e0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 70 34 80 00       	push   $0x803470
  8017ee:	68 9b 00 00 00       	push   $0x9b
  8017f3:	68 64 33 80 00       	push   $0x803364
  8017f8:	e8 96 ec ff ff       	call   800493 <_panic>

008017fd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	57                   	push   %edi
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801812:	8b 7d 18             	mov    0x18(%ebp),%edi
  801815:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801818:	cd 30                	int    $0x30
  80181a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	8b 45 10             	mov    0x10(%ebp),%eax
  801831:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801834:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801837:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	51                   	push   %ecx
  801841:	52                   	push   %edx
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	50                   	push   %eax
  801846:	6a 00                	push   $0x0
  801848:	e8 b0 ff ff ff       	call   8017fd <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_cgetc>:

int
sys_cgetc(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 02                	push   $0x2
  801862:	e8 96 ff ff ff       	call   8017fd <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 03                	push   $0x3
  80187b:	e8 7d ff ff ff       	call   8017fd <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	90                   	nop
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 04                	push   $0x4
  801895:	e8 63 ff ff ff       	call   8017fd <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	90                   	nop
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	6a 08                	push   $0x8
  8018b3:	e8 45 ff ff ff       	call   8017fd <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	56                   	push   %esi
  8018d2:	53                   	push   %ebx
  8018d3:	51                   	push   %ecx
  8018d4:	52                   	push   %edx
  8018d5:	50                   	push   %eax
  8018d6:	6a 09                	push   $0x9
  8018d8:	e8 20 ff ff ff       	call   8017fd <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5e                   	pop    %esi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    

008018e7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 0a                	push   $0xa
  8018f7:	e8 01 ff ff ff       	call   8017fd <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 0b                	push   $0xb
  801912:	e8 e6 fe ff ff       	call   8017fd <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0c                	push   $0xc
  80192b:	e8 cd fe ff ff       	call   8017fd <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0d                	push   $0xd
  801944:	e8 b4 fe ff ff       	call   8017fd <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 0e                	push   $0xe
  80195d:	e8 9b fe ff ff       	call   8017fd <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 0f                	push   $0xf
  801976:	e8 82 fe ff ff       	call   8017fd <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 10                	push   $0x10
  801990:	e8 68 fe ff ff       	call   8017fd <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 11                	push   $0x11
  8019a9:	e8 4f fe ff ff       	call   8017fd <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	50                   	push   %eax
  8019cd:	6a 01                	push   $0x1
  8019cf:	e8 29 fe ff ff       	call   8017fd <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 14                	push   $0x14
  8019e9:	e8 0f fe ff ff       	call   8017fd <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	6a 15                	push   $0x15
  801a14:	e8 e4 fd ff ff       	call   8017fd <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 16                	push   $0x16
  801a31:	e8 c7 fd ff ff       	call   8017fd <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 17                	push   $0x17
  801a50:	e8 a8 fd ff ff       	call   8017fd <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 18                	push   $0x18
  801a6d:	e8 8b fd ff ff       	call   8017fd <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	ff 75 14             	pushl  0x14(%ebp)
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	6a 19                	push   $0x19
  801a8b:	e8 6d fd ff ff       	call   8017fd <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	50                   	push   %eax
  801aa4:	6a 1a                	push   $0x1a
  801aa6:	e8 52 fd ff ff       	call   8017fd <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	50                   	push   %eax
  801ac0:	6a 1b                	push   $0x1b
  801ac2:	e8 36 fd ff ff       	call   8017fd <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 05                	push   $0x5
  801adb:	e8 1d fd ff ff       	call   8017fd <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 06                	push   $0x6
  801af4:	e8 04 fd ff ff       	call   8017fd <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 07                	push   $0x7
  801b0d:	e8 eb fc ff ff       	call   8017fd <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_exit_env>:


void sys_exit_env(void)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 1c                	push   $0x1c
  801b26:	e8 d2 fc ff ff       	call   8017fd <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3a:	8d 50 04             	lea    0x4(%eax),%edx
  801b3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 1d                	push   $0x1d
  801b4a:	e8 ae fc ff ff       	call   8017fd <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5b:	89 01                	mov    %eax,(%ecx)
  801b5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	c9                   	leave  
  801b64:	c2 04 00             	ret    $0x4

00801b67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	6a 13                	push   $0x13
  801b79:	e8 7f fc ff ff       	call   8017fd <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 1e                	push   $0x1e
  801b93:	e8 65 fc ff ff       	call   8017fd <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	50                   	push   %eax
  801bb6:	6a 1f                	push   $0x1f
  801bb8:	e8 40 fc ff ff       	call   8017fd <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <rsttst>:
void rsttst()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 21                	push   $0x21
  801bd2:	e8 26 fc ff ff       	call   8017fd <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 45 14             	mov    0x14(%ebp),%eax
  801be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be9:	8b 55 18             	mov    0x18(%ebp),%edx
  801bec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf0:	52                   	push   %edx
  801bf1:	50                   	push   %eax
  801bf2:	ff 75 10             	pushl  0x10(%ebp)
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 20                	push   $0x20
  801bfd:	e8 fb fb ff ff       	call   8017fd <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return ;
  801c05:	90                   	nop
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <chktst>:
void chktst(uint32 n)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 08             	pushl  0x8(%ebp)
  801c16:	6a 22                	push   $0x22
  801c18:	e8 e0 fb ff ff       	call   8017fd <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <inctst>:

void inctst()
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 23                	push   $0x23
  801c32:	e8 c6 fb ff ff       	call   8017fd <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <gettst>:
uint32 gettst()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 24                	push   $0x24
  801c4c:	e8 ac fb ff ff       	call   8017fd <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 25                	push   $0x25
  801c65:	e8 93 fb ff ff       	call   8017fd <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
  801c6d:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c72:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	6a 26                	push   $0x26
  801c91:	e8 67 fb ff ff       	call   8017fd <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	53                   	push   %ebx
  801caf:	51                   	push   %ecx
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 27                	push   $0x27
  801cb4:	e8 44 fb ff ff       	call   8017fd <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 28                	push   $0x28
  801cd4:	e8 24 fb ff ff       	call   8017fd <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ce1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	6a 00                	push   $0x0
  801cec:	51                   	push   %ecx
  801ced:	ff 75 10             	pushl  0x10(%ebp)
  801cf0:	52                   	push   %edx
  801cf1:	50                   	push   %eax
  801cf2:	6a 29                	push   $0x29
  801cf4:	e8 04 fb ff ff       	call   8017fd <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 10             	pushl  0x10(%ebp)
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	ff 75 08             	pushl  0x8(%ebp)
  801d0e:	6a 12                	push   $0x12
  801d10:	e8 e8 fa ff ff       	call   8017fd <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	52                   	push   %edx
  801d2b:	50                   	push   %eax
  801d2c:	6a 2a                	push   $0x2a
  801d2e:	e8 ca fa ff ff       	call   8017fd <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
	return;
  801d36:	90                   	nop
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 2b                	push   $0x2b
  801d48:	e8 b0 fa ff ff       	call   8017fd <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	ff 75 08             	pushl  0x8(%ebp)
  801d61:	6a 2d                	push   $0x2d
  801d63:	e8 95 fa ff ff       	call   8017fd <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
	return;
  801d6b:	90                   	nop
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	6a 2c                	push   $0x2c
  801d7f:	e8 79 fa ff ff       	call   8017fd <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d90:	83 ec 04             	sub    $0x4,%esp
  801d93:	68 94 34 80 00       	push   $0x803494
  801d98:	68 25 01 00 00       	push   $0x125
  801d9d:	68 c7 34 80 00       	push   $0x8034c7
  801da2:	e8 ec e6 ff ff       	call   800493 <_panic>

00801da7 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801dad:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801db4:	72 09                	jb     801dbf <to_page_va+0x18>
  801db6:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801dbd:	72 14                	jb     801dd3 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	68 d8 34 80 00       	push   $0x8034d8
  801dc7:	6a 15                	push   $0x15
  801dc9:	68 03 35 80 00       	push   $0x803503
  801dce:	e8 c0 e6 ff ff       	call   800493 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	ba 60 40 80 00       	mov    $0x804060,%edx
  801ddb:	29 d0                	sub    %edx,%eax
  801ddd:	c1 f8 02             	sar    $0x2,%eax
  801de0:	89 c2                	mov    %eax,%edx
  801de2:	89 d0                	mov    %edx,%eax
  801de4:	c1 e0 02             	shl    $0x2,%eax
  801de7:	01 d0                	add    %edx,%eax
  801de9:	c1 e0 02             	shl    $0x2,%eax
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 02             	shl    $0x2,%eax
  801df1:	01 d0                	add    %edx,%eax
  801df3:	89 c1                	mov    %eax,%ecx
  801df5:	c1 e1 08             	shl    $0x8,%ecx
  801df8:	01 c8                	add    %ecx,%eax
  801dfa:	89 c1                	mov    %eax,%ecx
  801dfc:	c1 e1 10             	shl    $0x10,%ecx
  801dff:	01 c8                	add    %ecx,%eax
  801e01:	01 c0                	add    %eax,%eax
  801e03:	01 d0                	add    %edx,%eax
  801e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	c1 e0 0c             	shl    $0xc,%eax
  801e0e:	89 c2                	mov    %eax,%edx
  801e10:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e15:	01 d0                	add    %edx,%eax
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e1f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e24:	8b 55 08             	mov    0x8(%ebp),%edx
  801e27:	29 c2                	sub    %eax,%edx
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	c1 e8 0c             	shr    $0xc,%eax
  801e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e35:	78 09                	js     801e40 <to_page_info+0x27>
  801e37:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e3e:	7e 14                	jle    801e54 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	68 1c 35 80 00       	push   $0x80351c
  801e48:	6a 22                	push   $0x22
  801e4a:	68 03 35 80 00       	push   $0x803503
  801e4f:	e8 3f e6 ff ff       	call   800493 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e57:	89 d0                	mov    %edx,%eax
  801e59:	01 c0                	add    %eax,%eax
  801e5b:	01 d0                	add    %edx,%eax
  801e5d:	c1 e0 02             	shl    $0x2,%eax
  801e60:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	05 00 00 00 02       	add    $0x2000000,%eax
  801e75:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e78:	73 16                	jae    801e90 <initialize_dynamic_allocator+0x29>
  801e7a:	68 40 35 80 00       	push   $0x803540
  801e7f:	68 66 35 80 00       	push   $0x803566
  801e84:	6a 34                	push   $0x34
  801e86:	68 03 35 80 00       	push   $0x803503
  801e8b:	e8 03 e6 ff ff       	call   800493 <_panic>
		is_initialized = 1;
  801e90:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e97:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea5:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801eaa:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801eb1:	00 00 00 
  801eb4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801ebb:	00 00 00 
  801ebe:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ec5:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecb:	2b 45 08             	sub    0x8(%ebp),%eax
  801ece:	c1 e8 0c             	shr    $0xc,%eax
  801ed1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ed4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801edb:	e9 c8 00 00 00       	jmp    801fa8 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee3:	89 d0                	mov    %edx,%eax
  801ee5:	01 c0                	add    %eax,%eax
  801ee7:	01 d0                	add    %edx,%eax
  801ee9:	c1 e0 02             	shl    $0x2,%eax
  801eec:	05 68 40 80 00       	add    $0x804068,%eax
  801ef1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	89 d0                	mov    %edx,%eax
  801efb:	01 c0                	add    %eax,%eax
  801efd:	01 d0                	add    %edx,%eax
  801eff:	c1 e0 02             	shl    $0x2,%eax
  801f02:	05 6a 40 80 00       	add    $0x80406a,%eax
  801f07:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801f0c:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f12:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f15:	89 c8                	mov    %ecx,%eax
  801f17:	01 c0                	add    %eax,%eax
  801f19:	01 c8                	add    %ecx,%eax
  801f1b:	c1 e0 02             	shl    $0x2,%eax
  801f1e:	05 64 40 80 00       	add    $0x804064,%eax
  801f23:	89 10                	mov    %edx,(%eax)
  801f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f28:	89 d0                	mov    %edx,%eax
  801f2a:	01 c0                	add    %eax,%eax
  801f2c:	01 d0                	add    %edx,%eax
  801f2e:	c1 e0 02             	shl    $0x2,%eax
  801f31:	05 64 40 80 00       	add    $0x804064,%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	74 1b                	je     801f57 <initialize_dynamic_allocator+0xf0>
  801f3c:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f42:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f45:	89 c8                	mov    %ecx,%eax
  801f47:	01 c0                	add    %eax,%eax
  801f49:	01 c8                	add    %ecx,%eax
  801f4b:	c1 e0 02             	shl    $0x2,%eax
  801f4e:	05 60 40 80 00       	add    $0x804060,%eax
  801f53:	89 02                	mov    %eax,(%edx)
  801f55:	eb 16                	jmp    801f6d <initialize_dynamic_allocator+0x106>
  801f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5a:	89 d0                	mov    %edx,%eax
  801f5c:	01 c0                	add    %eax,%eax
  801f5e:	01 d0                	add    %edx,%eax
  801f60:	c1 e0 02             	shl    $0x2,%eax
  801f63:	05 60 40 80 00       	add    $0x804060,%eax
  801f68:	a3 48 40 80 00       	mov    %eax,0x804048
  801f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f70:	89 d0                	mov    %edx,%eax
  801f72:	01 c0                	add    %eax,%eax
  801f74:	01 d0                	add    %edx,%eax
  801f76:	c1 e0 02             	shl    $0x2,%eax
  801f79:	05 60 40 80 00       	add    $0x804060,%eax
  801f7e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f86:	89 d0                	mov    %edx,%eax
  801f88:	01 c0                	add    %eax,%eax
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	c1 e0 02             	shl    $0x2,%eax
  801f8f:	05 60 40 80 00       	add    $0x804060,%eax
  801f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f9a:	a1 54 40 80 00       	mov    0x804054,%eax
  801f9f:	40                   	inc    %eax
  801fa0:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801fa5:	ff 45 f4             	incl   -0xc(%ebp)
  801fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fae:	0f 8c 2c ff ff ff    	jl     801ee0 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fbb:	eb 36                	jmp    801ff3 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc0:	c1 e0 04             	shl    $0x4,%eax
  801fc3:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	c1 e0 04             	shl    $0x4,%eax
  801fd4:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe2:	c1 e0 04             	shl    $0x4,%eax
  801fe5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ff0:	ff 45 f0             	incl   -0x10(%ebp)
  801ff3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801ff7:	7e c4                	jle    801fbd <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801ff9:	90                   	nop
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	50                   	push   %eax
  802009:	e8 0b fe ff ff       	call   801e19 <to_page_info>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 40 08             	mov    0x8(%eax),%eax
  80201a:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	e8 77 fd ff ff       	call   801da7 <to_page_va>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802036:	b8 00 10 00 00       	mov    $0x1000,%eax
  80203b:	ba 00 00 00 00       	mov    $0x0,%edx
  802040:	f7 75 08             	divl   0x8(%ebp)
  802043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	50                   	push   %eax
  80204d:	e8 48 f6 ff ff       	call   80169a <get_page>
  802052:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802058:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80205f:	8b 45 08             	mov    0x8(%ebp),%eax
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
  802065:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802070:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802077:	eb 19                	jmp    802092 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	ba 01 00 00 00       	mov    $0x1,%edx
  802081:	88 c1                	mov    %al,%cl
  802083:	d3 e2                	shl    %cl,%edx
  802085:	89 d0                	mov    %edx,%eax
  802087:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208a:	74 0e                	je     80209a <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80208c:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80208f:	ff 45 f0             	incl   -0x10(%ebp)
  802092:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802096:	7e e1                	jle    802079 <split_page_to_blocks+0x5a>
  802098:	eb 01                	jmp    80209b <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80209a:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80209b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8020a2:	e9 a7 00 00 00       	jmp    80214e <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8020a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020aa:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b3:	01 d0                	add    %edx,%eax
  8020b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020bc:	75 14                	jne    8020d2 <split_page_to_blocks+0xb3>
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 7c 35 80 00       	push   $0x80357c
  8020c6:	6a 7c                	push   $0x7c
  8020c8:	68 03 35 80 00       	push   $0x803503
  8020cd:	e8 c1 e3 ff ff       	call   800493 <_panic>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	c1 e0 04             	shl    $0x4,%eax
  8020d8:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020dd:	8b 10                	mov    (%eax),%edx
  8020df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e2:	89 50 04             	mov    %edx,0x4(%eax)
  8020e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e8:	8b 40 04             	mov    0x4(%eax),%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	74 14                	je     802103 <split_page_to_blocks+0xe4>
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	c1 e0 04             	shl    $0x4,%eax
  8020f5:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020fa:	8b 00                	mov    (%eax),%eax
  8020fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020ff:	89 10                	mov    %edx,(%eax)
  802101:	eb 11                	jmp    802114 <split_page_to_blocks+0xf5>
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	c1 e0 04             	shl    $0x4,%eax
  802109:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80210f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802112:	89 02                	mov    %eax,(%edx)
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	c1 e0 04             	shl    $0x4,%eax
  80211a:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802123:	89 02                	mov    %eax,(%edx)
  802125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802128:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	c1 e0 04             	shl    $0x4,%eax
  802134:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	8d 50 01             	lea    0x1(%eax),%edx
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	c1 e0 04             	shl    $0x4,%eax
  802144:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802149:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80214b:	ff 45 ec             	incl   -0x14(%ebp)
  80214e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802151:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802154:	0f 82 4d ff ff ff    	jb     8020a7 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80215a:	90                   	nop
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802163:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80216a:	76 19                	jbe    802185 <alloc_block+0x28>
  80216c:	68 a0 35 80 00       	push   $0x8035a0
  802171:	68 66 35 80 00       	push   $0x803566
  802176:	68 8a 00 00 00       	push   $0x8a
  80217b:	68 03 35 80 00       	push   $0x803503
  802180:	e8 0e e3 ff ff       	call   800493 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802185:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80218c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802193:	eb 19                	jmp    8021ae <alloc_block+0x51>
		if((1 << i) >= size) break;
  802195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802198:	ba 01 00 00 00       	mov    $0x1,%edx
  80219d:	88 c1                	mov    %al,%cl
  80219f:	d3 e2                	shl    %cl,%edx
  8021a1:	89 d0                	mov    %edx,%eax
  8021a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021a6:	73 0e                	jae    8021b6 <alloc_block+0x59>
		idx++;
  8021a8:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021ab:	ff 45 f0             	incl   -0x10(%ebp)
  8021ae:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021b2:	7e e1                	jle    802195 <alloc_block+0x38>
  8021b4:	eb 01                	jmp    8021b7 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021b6:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	c1 e0 04             	shl    $0x4,%eax
  8021bd:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	0f 84 df 00 00 00    	je     8022ab <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	c1 e0 04             	shl    $0x4,%eax
  8021d2:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e0:	75 17                	jne    8021f9 <alloc_block+0x9c>
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	68 c1 35 80 00       	push   $0x8035c1
  8021ea:	68 9e 00 00 00       	push   $0x9e
  8021ef:	68 03 35 80 00       	push   $0x803503
  8021f4:	e8 9a e2 ff ff       	call   800493 <_panic>
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 10                	je     802212 <alloc_block+0xb5>
  802202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80220a:	8b 52 04             	mov    0x4(%edx),%edx
  80220d:	89 50 04             	mov    %edx,0x4(%eax)
  802210:	eb 14                	jmp    802226 <alloc_block+0xc9>
  802212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802215:	8b 40 04             	mov    0x4(%eax),%eax
  802218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221b:	c1 e2 04             	shl    $0x4,%edx
  80221e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802224:	89 02                	mov    %eax,(%edx)
  802226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802229:	8b 40 04             	mov    0x4(%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0f                	je     80223f <alloc_block+0xe2>
  802230:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802239:	8b 12                	mov    (%edx),%edx
  80223b:	89 10                	mov    %edx,(%eax)
  80223d:	eb 13                	jmp    802252 <alloc_block+0xf5>
  80223f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802247:	c1 e2 04             	shl    $0x4,%edx
  80224a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802250:	89 02                	mov    %eax,(%edx)
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	c1 e0 04             	shl    $0x4,%eax
  80226b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	8d 50 ff             	lea    -0x1(%eax),%edx
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	c1 e0 04             	shl    $0x4,%eax
  80227b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802280:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	50                   	push   %eax
  802289:	e8 8b fb ff ff       	call   801e19 <to_page_info>
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802297:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80229b:	48                   	dec    %eax
  80229c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80229f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8022a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a6:	e9 bc 02 00 00       	jmp    802567 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8022ab:	a1 54 40 80 00       	mov    0x804054,%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	0f 84 7d 02 00 00    	je     802535 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022b8:	a1 48 40 80 00       	mov    0x804048,%eax
  8022bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022c4:	75 17                	jne    8022dd <alloc_block+0x180>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 c1 35 80 00       	push   $0x8035c1
  8022ce:	68 a9 00 00 00       	push   $0xa9
  8022d3:	68 03 35 80 00       	push   $0x803503
  8022d8:	e8 b6 e1 ff ff       	call   800493 <_panic>
  8022dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	74 10                	je     8022f6 <alloc_block+0x199>
  8022e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022ee:	8b 52 04             	mov    0x4(%edx),%edx
  8022f1:	89 50 04             	mov    %edx,0x4(%eax)
  8022f4:	eb 0b                	jmp    802301 <alloc_block+0x1a4>
  8022f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f9:	8b 40 04             	mov    0x4(%eax),%eax
  8022fc:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	74 0f                	je     80231a <alloc_block+0x1bd>
  80230b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802314:	8b 12                	mov    (%edx),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	eb 0a                	jmp    802324 <alloc_block+0x1c7>
  80231a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	a3 48 40 80 00       	mov    %eax,0x804048
  802324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802330:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802337:	a1 54 40 80 00       	mov    0x804054,%eax
  80233c:	48                   	dec    %eax
  80233d:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	83 c0 03             	add    $0x3,%eax
  802348:	ba 01 00 00 00       	mov    $0x1,%edx
  80234d:	88 c1                	mov    %al,%cl
  80234f:	d3 e2                	shl    %cl,%edx
  802351:	89 d0                	mov    %edx,%eax
  802353:	83 ec 08             	sub    $0x8,%esp
  802356:	ff 75 e4             	pushl  -0x1c(%ebp)
  802359:	50                   	push   %eax
  80235a:	e8 c0 fc ff ff       	call   80201f <split_page_to_blocks>
  80235f:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c1 e0 04             	shl    $0x4,%eax
  802368:	05 80 c0 81 00       	add    $0x81c080,%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802372:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802376:	75 17                	jne    80238f <alloc_block+0x232>
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 c1 35 80 00       	push   $0x8035c1
  802380:	68 b0 00 00 00       	push   $0xb0
  802385:	68 03 35 80 00       	push   $0x803503
  80238a:	e8 04 e1 ff ff       	call   800493 <_panic>
  80238f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	85 c0                	test   %eax,%eax
  802396:	74 10                	je     8023a8 <alloc_block+0x24b>
  802398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a0:	8b 52 04             	mov    0x4(%edx),%edx
  8023a3:	89 50 04             	mov    %edx,0x4(%eax)
  8023a6:	eb 14                	jmp    8023bc <alloc_block+0x25f>
  8023a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b1:	c1 e2 04             	shl    $0x4,%edx
  8023b4:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023ba:	89 02                	mov    %eax,(%edx)
  8023bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 0f                	je     8023d5 <alloc_block+0x278>
  8023c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023cf:	8b 12                	mov    (%edx),%edx
  8023d1:	89 10                	mov    %edx,(%eax)
  8023d3:	eb 13                	jmp    8023e8 <alloc_block+0x28b>
  8023d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dd:	c1 e2 04             	shl    $0x4,%edx
  8023e0:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023e6:	89 02                	mov    %eax,(%edx)
  8023e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	c1 e0 04             	shl    $0x4,%eax
  802401:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802406:	8b 00                	mov    (%eax),%eax
  802408:	8d 50 ff             	lea    -0x1(%eax),%edx
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	c1 e0 04             	shl    $0x4,%eax
  802411:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802416:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	50                   	push   %eax
  80241f:	e8 f5 f9 ff ff       	call   801e19 <to_page_info>
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80242a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80242d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802431:	48                   	dec    %eax
  802432:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802435:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243c:	e9 26 01 00 00       	jmp    802567 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802441:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	c1 e0 04             	shl    $0x4,%eax
  80244a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 84 dc 00 00 00    	je     802535 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	c1 e0 04             	shl    $0x4,%eax
  80245f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802469:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80246d:	75 17                	jne    802486 <alloc_block+0x329>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 c1 35 80 00       	push   $0x8035c1
  802477:	68 be 00 00 00       	push   $0xbe
  80247c:	68 03 35 80 00       	push   $0x803503
  802481:	e8 0d e0 ff ff       	call   800493 <_panic>
  802486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	74 10                	je     80249f <alloc_block+0x342>
  80248f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802497:	8b 52 04             	mov    0x4(%edx),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%eax)
  80249d:	eb 14                	jmp    8024b3 <alloc_block+0x356>
  80249f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a2:	8b 40 04             	mov    0x4(%eax),%eax
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	c1 e2 04             	shl    $0x4,%edx
  8024ab:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024b1:	89 02                	mov    %eax,(%edx)
  8024b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0f                	je     8024cc <alloc_block+0x36f>
  8024bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024c6:	8b 12                	mov    (%edx),%edx
  8024c8:	89 10                	mov    %edx,(%eax)
  8024ca:	eb 13                	jmp    8024df <alloc_block+0x382>
  8024cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d4:	c1 e2 04             	shl    $0x4,%edx
  8024d7:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024dd:	89 02                	mov    %eax,(%edx)
  8024df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	c1 e0 04             	shl    $0x4,%eax
  8024f8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	c1 e0 04             	shl    $0x4,%eax
  802508:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80250d:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80250f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802512:	83 ec 0c             	sub    $0xc,%esp
  802515:	50                   	push   %eax
  802516:	e8 fe f8 ff ff       	call   801e19 <to_page_info>
  80251b:	83 c4 10             	add    $0x10,%esp
  80251e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802524:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802528:	48                   	dec    %eax
  802529:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80252c:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802530:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802533:	eb 32                	jmp    802567 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802535:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802539:	77 15                	ja     802550 <alloc_block+0x3f3>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c1 e0 04             	shl    $0x4,%eax
  802541:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 84 f1 fe ff ff    	je     802441 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 df 35 80 00       	push   $0x8035df
  802558:	68 c8 00 00 00       	push   $0xc8
  80255d:	68 03 35 80 00       	push   $0x803503
  802562:	e8 2c df ff ff       	call   800493 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802567:	c9                   	leave  
  802568:	c3                   	ret    

00802569 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802569:	55                   	push   %ebp
  80256a:	89 e5                	mov    %esp,%ebp
  80256c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80256f:	8b 55 08             	mov    0x8(%ebp),%edx
  802572:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802577:	39 c2                	cmp    %eax,%edx
  802579:	72 0c                	jb     802587 <free_block+0x1e>
  80257b:	8b 55 08             	mov    0x8(%ebp),%edx
  80257e:	a1 40 40 80 00       	mov    0x804040,%eax
  802583:	39 c2                	cmp    %eax,%edx
  802585:	72 19                	jb     8025a0 <free_block+0x37>
  802587:	68 f0 35 80 00       	push   $0x8035f0
  80258c:	68 66 35 80 00       	push   $0x803566
  802591:	68 d7 00 00 00       	push   $0xd7
  802596:	68 03 35 80 00       	push   $0x803503
  80259b:	e8 f3 de ff ff       	call   800493 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8025a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a9:	83 ec 0c             	sub    $0xc,%esp
  8025ac:	50                   	push   %eax
  8025ad:	e8 67 f8 ff ff       	call   801e19 <to_page_info>
  8025b2:	83 c4 10             	add    $0x10,%esp
  8025b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	8b 40 08             	mov    0x8(%eax),%eax
  8025be:	0f b7 c0             	movzwl %ax,%eax
  8025c1:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025cb:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025d2:	eb 19                	jmp    8025ed <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	ba 01 00 00 00       	mov    $0x1,%edx
  8025dc:	88 c1                	mov    %al,%cl
  8025de:	d3 e2                	shl    %cl,%edx
  8025e0:	89 d0                	mov    %edx,%eax
  8025e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025e5:	74 0e                	je     8025f5 <free_block+0x8c>
	        break;
	    idx++;
  8025e7:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025ea:	ff 45 f0             	incl   -0x10(%ebp)
  8025ed:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025f1:	7e e1                	jle    8025d4 <free_block+0x6b>
  8025f3:	eb 01                	jmp    8025f6 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025f5:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025fd:	40                   	inc    %eax
  8025fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802601:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802605:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802609:	75 17                	jne    802622 <free_block+0xb9>
  80260b:	83 ec 04             	sub    $0x4,%esp
  80260e:	68 7c 35 80 00       	push   $0x80357c
  802613:	68 ee 00 00 00       	push   $0xee
  802618:	68 03 35 80 00       	push   $0x803503
  80261d:	e8 71 de ff ff       	call   800493 <_panic>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	c1 e0 04             	shl    $0x4,%eax
  802628:	05 84 c0 81 00       	add    $0x81c084,%eax
  80262d:	8b 10                	mov    (%eax),%edx
  80262f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802632:	89 50 04             	mov    %edx,0x4(%eax)
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 14                	je     802653 <free_block+0xea>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c1 e0 04             	shl    $0x4,%eax
  802645:	05 84 c0 81 00       	add    $0x81c084,%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80264f:	89 10                	mov    %edx,(%eax)
  802651:	eb 11                	jmp    802664 <free_block+0xfb>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	c1 e0 04             	shl    $0x4,%eax
  802659:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80265f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802662:	89 02                	mov    %eax,(%edx)
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	c1 e0 04             	shl    $0x4,%eax
  80266a:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802670:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802673:	89 02                	mov    %eax,(%edx)
  802675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	c1 e0 04             	shl    $0x4,%eax
  802684:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	8d 50 01             	lea    0x1(%eax),%edx
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c1 e0 04             	shl    $0x4,%eax
  802694:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802699:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80269b:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a5:	f7 75 e0             	divl   -0x20(%ebp)
  8026a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8026ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ae:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026b2:	0f b7 c0             	movzwl %ax,%eax
  8026b5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026b8:	0f 85 70 01 00 00    	jne    80282e <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c4:	e8 de f6 ff ff       	call   801da7 <to_page_va>
  8026c9:	83 c4 10             	add    $0x10,%esp
  8026cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026d6:	e9 b7 00 00 00       	jmp    802792 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e1:	01 d0                	add    %edx,%eax
  8026e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026ea:	75 17                	jne    802703 <free_block+0x19a>
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 c1 35 80 00       	push   $0x8035c1
  8026f4:	68 f8 00 00 00       	push   $0xf8
  8026f9:	68 03 35 80 00       	push   $0x803503
  8026fe:	e8 90 dd ff ff       	call   800493 <_panic>
  802703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <free_block+0x1b3>
  80270c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 14                	jmp    802730 <free_block+0x1c7>
  80271c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	c1 e2 04             	shl    $0x4,%edx
  802728:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80272e:	89 02                	mov    %eax,(%edx)
  802730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 0f                	je     802749 <free_block+0x1e0>
  80273a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802743:	8b 12                	mov    (%edx),%edx
  802745:	89 10                	mov    %edx,(%eax)
  802747:	eb 13                	jmp    80275c <free_block+0x1f3>
  802749:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	c1 e2 04             	shl    $0x4,%edx
  802754:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80275a:	89 02                	mov    %eax,(%edx)
  80275c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80275f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802768:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	c1 e0 04             	shl    $0x4,%eax
  802775:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	c1 e0 04             	shl    $0x4,%eax
  802785:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80278a:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80278c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278f:	01 45 ec             	add    %eax,-0x14(%ebp)
  802792:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802799:	0f 86 3c ff ff ff    	jbe    8026db <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80279f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027b5:	75 17                	jne    8027ce <free_block+0x265>
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	68 7c 35 80 00       	push   $0x80357c
  8027bf:	68 fe 00 00 00       	push   $0xfe
  8027c4:	68 03 35 80 00       	push   $0x803503
  8027c9:	e8 c5 dc ff ff       	call   800493 <_panic>
  8027ce:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 0c                	je     8027f0 <free_block+0x287>
  8027e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ec:	89 10                	mov    %edx,(%eax)
  8027ee:	eb 08                	jmp    8027f8 <free_block+0x28f>
  8027f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f3:	a3 48 40 80 00       	mov    %eax,0x804048
  8027f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802809:	a1 54 40 80 00       	mov    0x804054,%eax
  80280e:	40                   	inc    %eax
  80280f:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	ff 75 e4             	pushl  -0x1c(%ebp)
  80281a:	e8 88 f5 ff ff       	call   801da7 <to_page_va>
  80281f:	83 c4 10             	add    $0x10,%esp
  802822:	83 ec 0c             	sub    $0xc,%esp
  802825:	50                   	push   %eax
  802826:	e8 b8 ee ff ff       	call   8016e3 <return_page>
  80282b:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80282e:	90                   	nop
  80282f:	c9                   	leave  
  802830:	c3                   	ret    

00802831 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	68 28 36 80 00       	push   $0x803628
  80283f:	68 11 01 00 00       	push   $0x111
  802844:	68 03 35 80 00       	push   $0x803503
  802849:	e8 45 dc ff ff       	call   800493 <_panic>
  80284e:	66 90                	xchg   %ax,%ax

00802850 <__udivdi3>:
  802850:	55                   	push   %ebp
  802851:	57                   	push   %edi
  802852:	56                   	push   %esi
  802853:	53                   	push   %ebx
  802854:	83 ec 1c             	sub    $0x1c,%esp
  802857:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80285b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80285f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802863:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802867:	89 ca                	mov    %ecx,%edx
  802869:	89 f8                	mov    %edi,%eax
  80286b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80286f:	85 f6                	test   %esi,%esi
  802871:	75 2d                	jne    8028a0 <__udivdi3+0x50>
  802873:	39 cf                	cmp    %ecx,%edi
  802875:	77 65                	ja     8028dc <__udivdi3+0x8c>
  802877:	89 fd                	mov    %edi,%ebp
  802879:	85 ff                	test   %edi,%edi
  80287b:	75 0b                	jne    802888 <__udivdi3+0x38>
  80287d:	b8 01 00 00 00       	mov    $0x1,%eax
  802882:	31 d2                	xor    %edx,%edx
  802884:	f7 f7                	div    %edi
  802886:	89 c5                	mov    %eax,%ebp
  802888:	31 d2                	xor    %edx,%edx
  80288a:	89 c8                	mov    %ecx,%eax
  80288c:	f7 f5                	div    %ebp
  80288e:	89 c1                	mov    %eax,%ecx
  802890:	89 d8                	mov    %ebx,%eax
  802892:	f7 f5                	div    %ebp
  802894:	89 cf                	mov    %ecx,%edi
  802896:	89 fa                	mov    %edi,%edx
  802898:	83 c4 1c             	add    $0x1c,%esp
  80289b:	5b                   	pop    %ebx
  80289c:	5e                   	pop    %esi
  80289d:	5f                   	pop    %edi
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    
  8028a0:	39 ce                	cmp    %ecx,%esi
  8028a2:	77 28                	ja     8028cc <__udivdi3+0x7c>
  8028a4:	0f bd fe             	bsr    %esi,%edi
  8028a7:	83 f7 1f             	xor    $0x1f,%edi
  8028aa:	75 40                	jne    8028ec <__udivdi3+0x9c>
  8028ac:	39 ce                	cmp    %ecx,%esi
  8028ae:	72 0a                	jb     8028ba <__udivdi3+0x6a>
  8028b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8028b4:	0f 87 9e 00 00 00    	ja     802958 <__udivdi3+0x108>
  8028ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bf:	89 fa                	mov    %edi,%edx
  8028c1:	83 c4 1c             	add    $0x1c,%esp
  8028c4:	5b                   	pop    %ebx
  8028c5:	5e                   	pop    %esi
  8028c6:	5f                   	pop    %edi
  8028c7:	5d                   	pop    %ebp
  8028c8:	c3                   	ret    
  8028c9:	8d 76 00             	lea    0x0(%esi),%esi
  8028cc:	31 ff                	xor    %edi,%edi
  8028ce:	31 c0                	xor    %eax,%eax
  8028d0:	89 fa                	mov    %edi,%edx
  8028d2:	83 c4 1c             	add    $0x1c,%esp
  8028d5:	5b                   	pop    %ebx
  8028d6:	5e                   	pop    %esi
  8028d7:	5f                   	pop    %edi
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	89 d8                	mov    %ebx,%eax
  8028de:	f7 f7                	div    %edi
  8028e0:	31 ff                	xor    %edi,%edi
  8028e2:	89 fa                	mov    %edi,%edx
  8028e4:	83 c4 1c             	add    $0x1c,%esp
  8028e7:	5b                   	pop    %ebx
  8028e8:	5e                   	pop    %esi
  8028e9:	5f                   	pop    %edi
  8028ea:	5d                   	pop    %ebp
  8028eb:	c3                   	ret    
  8028ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028f1:	89 eb                	mov    %ebp,%ebx
  8028f3:	29 fb                	sub    %edi,%ebx
  8028f5:	89 f9                	mov    %edi,%ecx
  8028f7:	d3 e6                	shl    %cl,%esi
  8028f9:	89 c5                	mov    %eax,%ebp
  8028fb:	88 d9                	mov    %bl,%cl
  8028fd:	d3 ed                	shr    %cl,%ebp
  8028ff:	89 e9                	mov    %ebp,%ecx
  802901:	09 f1                	or     %esi,%ecx
  802903:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802907:	89 f9                	mov    %edi,%ecx
  802909:	d3 e0                	shl    %cl,%eax
  80290b:	89 c5                	mov    %eax,%ebp
  80290d:	89 d6                	mov    %edx,%esi
  80290f:	88 d9                	mov    %bl,%cl
  802911:	d3 ee                	shr    %cl,%esi
  802913:	89 f9                	mov    %edi,%ecx
  802915:	d3 e2                	shl    %cl,%edx
  802917:	8b 44 24 08          	mov    0x8(%esp),%eax
  80291b:	88 d9                	mov    %bl,%cl
  80291d:	d3 e8                	shr    %cl,%eax
  80291f:	09 c2                	or     %eax,%edx
  802921:	89 d0                	mov    %edx,%eax
  802923:	89 f2                	mov    %esi,%edx
  802925:	f7 74 24 0c          	divl   0xc(%esp)
  802929:	89 d6                	mov    %edx,%esi
  80292b:	89 c3                	mov    %eax,%ebx
  80292d:	f7 e5                	mul    %ebp
  80292f:	39 d6                	cmp    %edx,%esi
  802931:	72 19                	jb     80294c <__udivdi3+0xfc>
  802933:	74 0b                	je     802940 <__udivdi3+0xf0>
  802935:	89 d8                	mov    %ebx,%eax
  802937:	31 ff                	xor    %edi,%edi
  802939:	e9 58 ff ff ff       	jmp    802896 <__udivdi3+0x46>
  80293e:	66 90                	xchg   %ax,%ax
  802940:	8b 54 24 08          	mov    0x8(%esp),%edx
  802944:	89 f9                	mov    %edi,%ecx
  802946:	d3 e2                	shl    %cl,%edx
  802948:	39 c2                	cmp    %eax,%edx
  80294a:	73 e9                	jae    802935 <__udivdi3+0xe5>
  80294c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80294f:	31 ff                	xor    %edi,%edi
  802951:	e9 40 ff ff ff       	jmp    802896 <__udivdi3+0x46>
  802956:	66 90                	xchg   %ax,%ax
  802958:	31 c0                	xor    %eax,%eax
  80295a:	e9 37 ff ff ff       	jmp    802896 <__udivdi3+0x46>
  80295f:	90                   	nop

00802960 <__umoddi3>:
  802960:	55                   	push   %ebp
  802961:	57                   	push   %edi
  802962:	56                   	push   %esi
  802963:	53                   	push   %ebx
  802964:	83 ec 1c             	sub    $0x1c,%esp
  802967:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80296b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80296f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802973:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802977:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80297b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80297f:	89 f3                	mov    %esi,%ebx
  802981:	89 fa                	mov    %edi,%edx
  802983:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802987:	89 34 24             	mov    %esi,(%esp)
  80298a:	85 c0                	test   %eax,%eax
  80298c:	75 1a                	jne    8029a8 <__umoddi3+0x48>
  80298e:	39 f7                	cmp    %esi,%edi
  802990:	0f 86 a2 00 00 00    	jbe    802a38 <__umoddi3+0xd8>
  802996:	89 c8                	mov    %ecx,%eax
  802998:	89 f2                	mov    %esi,%edx
  80299a:	f7 f7                	div    %edi
  80299c:	89 d0                	mov    %edx,%eax
  80299e:	31 d2                	xor    %edx,%edx
  8029a0:	83 c4 1c             	add    $0x1c,%esp
  8029a3:	5b                   	pop    %ebx
  8029a4:	5e                   	pop    %esi
  8029a5:	5f                   	pop    %edi
  8029a6:	5d                   	pop    %ebp
  8029a7:	c3                   	ret    
  8029a8:	39 f0                	cmp    %esi,%eax
  8029aa:	0f 87 ac 00 00 00    	ja     802a5c <__umoddi3+0xfc>
  8029b0:	0f bd e8             	bsr    %eax,%ebp
  8029b3:	83 f5 1f             	xor    $0x1f,%ebp
  8029b6:	0f 84 ac 00 00 00    	je     802a68 <__umoddi3+0x108>
  8029bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8029c1:	29 ef                	sub    %ebp,%edi
  8029c3:	89 fe                	mov    %edi,%esi
  8029c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029c9:	89 e9                	mov    %ebp,%ecx
  8029cb:	d3 e0                	shl    %cl,%eax
  8029cd:	89 d7                	mov    %edx,%edi
  8029cf:	89 f1                	mov    %esi,%ecx
  8029d1:	d3 ef                	shr    %cl,%edi
  8029d3:	09 c7                	or     %eax,%edi
  8029d5:	89 e9                	mov    %ebp,%ecx
  8029d7:	d3 e2                	shl    %cl,%edx
  8029d9:	89 14 24             	mov    %edx,(%esp)
  8029dc:	89 d8                	mov    %ebx,%eax
  8029de:	d3 e0                	shl    %cl,%eax
  8029e0:	89 c2                	mov    %eax,%edx
  8029e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029e6:	d3 e0                	shl    %cl,%eax
  8029e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029f0:	89 f1                	mov    %esi,%ecx
  8029f2:	d3 e8                	shr    %cl,%eax
  8029f4:	09 d0                	or     %edx,%eax
  8029f6:	d3 eb                	shr    %cl,%ebx
  8029f8:	89 da                	mov    %ebx,%edx
  8029fa:	f7 f7                	div    %edi
  8029fc:	89 d3                	mov    %edx,%ebx
  8029fe:	f7 24 24             	mull   (%esp)
  802a01:	89 c6                	mov    %eax,%esi
  802a03:	89 d1                	mov    %edx,%ecx
  802a05:	39 d3                	cmp    %edx,%ebx
  802a07:	0f 82 87 00 00 00    	jb     802a94 <__umoddi3+0x134>
  802a0d:	0f 84 91 00 00 00    	je     802aa4 <__umoddi3+0x144>
  802a13:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a17:	29 f2                	sub    %esi,%edx
  802a19:	19 cb                	sbb    %ecx,%ebx
  802a1b:	89 d8                	mov    %ebx,%eax
  802a1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a21:	d3 e0                	shl    %cl,%eax
  802a23:	89 e9                	mov    %ebp,%ecx
  802a25:	d3 ea                	shr    %cl,%edx
  802a27:	09 d0                	or     %edx,%eax
  802a29:	89 e9                	mov    %ebp,%ecx
  802a2b:	d3 eb                	shr    %cl,%ebx
  802a2d:	89 da                	mov    %ebx,%edx
  802a2f:	83 c4 1c             	add    $0x1c,%esp
  802a32:	5b                   	pop    %ebx
  802a33:	5e                   	pop    %esi
  802a34:	5f                   	pop    %edi
  802a35:	5d                   	pop    %ebp
  802a36:	c3                   	ret    
  802a37:	90                   	nop
  802a38:	89 fd                	mov    %edi,%ebp
  802a3a:	85 ff                	test   %edi,%edi
  802a3c:	75 0b                	jne    802a49 <__umoddi3+0xe9>
  802a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a43:	31 d2                	xor    %edx,%edx
  802a45:	f7 f7                	div    %edi
  802a47:	89 c5                	mov    %eax,%ebp
  802a49:	89 f0                	mov    %esi,%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	f7 f5                	div    %ebp
  802a4f:	89 c8                	mov    %ecx,%eax
  802a51:	f7 f5                	div    %ebp
  802a53:	89 d0                	mov    %edx,%eax
  802a55:	e9 44 ff ff ff       	jmp    80299e <__umoddi3+0x3e>
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	89 c8                	mov    %ecx,%eax
  802a5e:	89 f2                	mov    %esi,%edx
  802a60:	83 c4 1c             	add    $0x1c,%esp
  802a63:	5b                   	pop    %ebx
  802a64:	5e                   	pop    %esi
  802a65:	5f                   	pop    %edi
  802a66:	5d                   	pop    %ebp
  802a67:	c3                   	ret    
  802a68:	3b 04 24             	cmp    (%esp),%eax
  802a6b:	72 06                	jb     802a73 <__umoddi3+0x113>
  802a6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a71:	77 0f                	ja     802a82 <__umoddi3+0x122>
  802a73:	89 f2                	mov    %esi,%edx
  802a75:	29 f9                	sub    %edi,%ecx
  802a77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a7b:	89 14 24             	mov    %edx,(%esp)
  802a7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a82:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a86:	8b 14 24             	mov    (%esp),%edx
  802a89:	83 c4 1c             	add    $0x1c,%esp
  802a8c:	5b                   	pop    %ebx
  802a8d:	5e                   	pop    %esi
  802a8e:	5f                   	pop    %edi
  802a8f:	5d                   	pop    %ebp
  802a90:	c3                   	ret    
  802a91:	8d 76 00             	lea    0x0(%esi),%esi
  802a94:	2b 04 24             	sub    (%esp),%eax
  802a97:	19 fa                	sbb    %edi,%edx
  802a99:	89 d1                	mov    %edx,%ecx
  802a9b:	89 c6                	mov    %eax,%esi
  802a9d:	e9 71 ff ff ff       	jmp    802a13 <__umoddi3+0xb3>
  802aa2:	66 90                	xchg   %ax,%ax
  802aa4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802aa8:	72 ea                	jb     802a94 <__umoddi3+0x134>
  802aaa:	89 d9                	mov    %ebx,%ecx
  802aac:	e9 62 ff ff ff       	jmp    802a13 <__umoddi3+0xb3>
