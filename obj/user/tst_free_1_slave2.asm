
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
  800031:	e8 7f 02 00 00       	call   8002b5 <libmain>
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
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800043:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  80004a:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800051:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800058:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80005c:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  800060:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800066:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80006c:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  800073:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  80007a:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  800080:	b9 14 00 00 00       	mov    $0x14,%ecx
  800085:	b8 00 00 00 00       	mov    $0x0,%eax
  80008a:	89 d7                	mov    %edx,%edi
  80008c:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80008e:	e8 70 18 00 00       	call   801903 <sys_calculate_free_frames>
  800093:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800096:	e8 b3 18 00 00       	call   80194e <sys_pf_calculate_allocated_pages>
  80009b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  80009e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000a1:	01 c0                	add    %eax,%eax
  8000a3:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000a6:	83 ec 0c             	sub    $0xc,%esp
  8000a9:	50                   	push   %eax
  8000aa:	e8 5b 16 00 00       	call   80170a <malloc>
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000b8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 a0 2a 80 00       	push   $0x802aa0
  8000cb:	6a 31                	push   $0x31
  8000cd:	68 d0 2a 80 00       	push   $0x802ad0
  8000d2:	e8 a3 03 00 00       	call   80047a <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 72 18 00 00       	call   80194e <sys_pf_calculate_allocated_pages>
  8000dc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000df:	74 14                	je     8000f5 <_main+0xbd>
  8000e1:	83 ec 04             	sub    $0x4,%esp
  8000e4:	68 ec 2a 80 00       	push   $0x802aec
  8000e9:	6a 32                	push   $0x32
  8000eb:	68 d0 2a 80 00       	push   $0x802ad0
  8000f0:	e8 85 03 00 00       	call   80047a <_panic>

			freeFrames = sys_calculate_free_frames() ;
  8000f5:	e8 09 18 00 00       	call   801903 <sys_calculate_free_frames>
  8000fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8000fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800100:	01 c0                	add    %eax,%eax
  800102:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800105:	48                   	dec    %eax
  800106:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800109:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80010f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800112:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800115:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800118:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  80011a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80011d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800120:	01 c2                	add    %eax,%edx
  800122:	8a 45 ea             	mov    -0x16(%ebp),%al
  800125:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800127:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80012e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800131:	e8 cd 17 00 00       	call   801903 <sys_calculate_free_frames>
  800136:	29 c3                	sub    %eax,%ebx
  800138:	89 d8                	mov    %ebx,%eax
  80013a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80013d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800140:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800143:	7d 1a                	jge    80015f <_main+0x127>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 c4             	pushl  -0x3c(%ebp)
  80014b:	ff 75 c8             	pushl  -0x38(%ebp)
  80014e:	68 1c 2b 80 00       	push   $0x802b1c
  800153:	6a 3c                	push   $0x3c
  800155:	68 d0 2a 80 00       	push   $0x802ad0
  80015a:	e8 1b 03 00 00       	call   80047a <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80015f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800165:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800168:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016d:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800173:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800176:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800179:	01 d0                	add    %edx,%eax
  80017b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80017e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800186:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80018c:	6a 02                	push   $0x2
  80018e:	6a 00                	push   $0x0
  800190:	6a 02                	push   $0x2
  800192:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 27 1b 00 00       	call   801cc5 <sys_check_WS_list>
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001a4:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001a8:	74 14                	je     8001be <_main+0x186>
  8001aa:	83 ec 04             	sub    $0x4,%esp
  8001ad:	68 98 2b 80 00       	push   $0x802b98
  8001b2:	6a 40                	push   $0x40
  8001b4:	68 d0 2a 80 00       	push   $0x802ad0
  8001b9:	e8 bc 02 00 00       	call   80047a <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001be:	e8 40 17 00 00       	call   801903 <sys_calculate_free_frames>
  8001c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001c6:	e8 83 17 00 00       	call   80194e <sys_pf_calculate_allocated_pages>
  8001cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001ce:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	50                   	push   %eax
  8001d8:	e8 5b 15 00 00       	call   801738 <free>
  8001dd:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8001e0:	e8 69 17 00 00       	call   80194e <sys_pf_calculate_allocated_pages>
  8001e5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001e8:	74 14                	je     8001fe <_main+0x1c6>
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	68 b8 2b 80 00       	push   $0x802bb8
  8001f2:	6a 4d                	push   $0x4d
  8001f4:	68 d0 2a 80 00       	push   $0x802ad0
  8001f9:	e8 7c 02 00 00       	call   80047a <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8001fe:	e8 00 17 00 00       	call   801903 <sys_calculate_free_frames>
  800203:	89 c2                	mov    %eax,%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	29 c2                	sub    %eax,%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	83 f8 02             	cmp    $0x2,%eax
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 f4 2b 80 00       	push   $0x802bf4
  800219:	6a 4e                	push   $0x4e
  80021b:	68 d0 2a 80 00       	push   $0x802ad0
  800220:	e8 55 02 00 00       	call   80047a <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800225:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800228:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80022b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800244:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800247:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024c:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800252:	6a 03                	push   $0x3
  800254:	6a 00                	push   $0x0
  800256:	6a 02                	push   $0x2
  800258:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80025e:	50                   	push   %eax
  80025f:	e8 61 1a 00 00       	call   801cc5 <sys_check_WS_list>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  80026a:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80026e:	74 14                	je     800284 <_main+0x24c>
  800270:	83 ec 04             	sub    $0x4,%esp
  800273:	68 40 2c 80 00       	push   $0x802c40
  800278:	6a 51                	push   $0x51
  80027a:	68 d0 2a 80 00       	push   $0x802ad0
  80027f:	e8 f6 01 00 00       	call   80047a <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  800284:	e8 81 19 00 00       	call   801c0a <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  800289:	90                   	nop
  80028a:	e8 95 19 00 00       	call   801c24 <gettst>
  80028f:	83 f8 03             	cmp    $0x3,%eax
  800292:	75 f6                	jne    80028a <_main+0x252>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  800294:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800297:	8a 55 eb             	mov    -0x15(%ebp),%dl
  80029a:	88 10                	mov    %dl,(%eax)
		inctst();
  80029c:	e8 69 19 00 00       	call   801c0a <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	68 64 2c 80 00       	push   $0x802c64
  8002a9:	6a 5e                	push   $0x5e
  8002ab:	68 d0 2a 80 00       	push   $0x802ad0
  8002b0:	e8 c5 01 00 00       	call   80047a <_panic>

008002b5 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	57                   	push   %edi
  8002b9:	56                   	push   %esi
  8002ba:	53                   	push   %ebx
  8002bb:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002be:	e8 09 18 00 00       	call   801acc <sys_getenvindex>
  8002c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 06             	shl    $0x6,%eax
  8002ce:	29 d0                	sub    %edx,%eax
  8002d0:	c1 e0 02             	shl    $0x2,%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002dc:	01 c8                	add    %ecx,%eax
  8002de:	c1 e0 03             	shl    $0x3,%eax
  8002e1:	01 d0                	add    %edx,%eax
  8002e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002f3:	89 c2                	mov    %eax,%edx
  8002f5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002fb:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800300:	a1 20 40 80 00       	mov    0x804020,%eax
  800305:	8a 40 20             	mov    0x20(%eax),%al
  800308:	84 c0                	test   %al,%al
  80030a:	74 0d                	je     800319 <libmain+0x64>
		binaryname = myEnv->prog_name;
  80030c:	a1 20 40 80 00       	mov    0x804020,%eax
  800311:	83 c0 20             	add    $0x20,%eax
  800314:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800319:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80031d:	7e 0a                	jle    800329 <libmain+0x74>
		binaryname = argv[0];
  80031f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800322:	8b 00                	mov    (%eax),%eax
  800324:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800329:	83 ec 08             	sub    $0x8,%esp
  80032c:	ff 75 0c             	pushl  0xc(%ebp)
  80032f:	ff 75 08             	pushl  0x8(%ebp)
  800332:	e8 01 fd ff ff       	call   800038 <_main>
  800337:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80033a:	a1 00 40 80 00       	mov    0x804000,%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	0f 84 01 01 00 00    	je     800448 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800347:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80034d:	bb a8 2d 80 00       	mov    $0x802da8,%ebx
  800352:	ba 0e 00 00 00       	mov    $0xe,%edx
  800357:	89 c7                	mov    %eax,%edi
  800359:	89 de                	mov    %ebx,%esi
  80035b:	89 d1                	mov    %edx,%ecx
  80035d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80035f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800362:	b9 56 00 00 00       	mov    $0x56,%ecx
  800367:	b0 00                	mov    $0x0,%al
  800369:	89 d7                	mov    %edx,%edi
  80036b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80036d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800374:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800377:	83 ec 08             	sub    $0x8,%esp
  80037a:	50                   	push   %eax
  80037b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800381:	50                   	push   %eax
  800382:	e8 7b 19 00 00       	call   801d02 <sys_utilities>
  800387:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80038a:	e8 c4 14 00 00       	call   801853 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80038f:	83 ec 0c             	sub    $0xc,%esp
  800392:	68 c8 2c 80 00       	push   $0x802cc8
  800397:	e8 ac 03 00 00       	call   800748 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80039f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a2:	85 c0                	test   %eax,%eax
  8003a4:	74 18                	je     8003be <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003a6:	e8 75 19 00 00       	call   801d20 <sys_get_optimal_num_faults>
  8003ab:	83 ec 08             	sub    $0x8,%esp
  8003ae:	50                   	push   %eax
  8003af:	68 f0 2c 80 00       	push   $0x802cf0
  8003b4:	e8 8f 03 00 00       	call   800748 <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	eb 59                	jmp    800417 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003be:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c3:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	52                   	push   %edx
  8003d8:	50                   	push   %eax
  8003d9:	68 14 2d 80 00       	push   $0x802d14
  8003de:	e8 65 03 00 00       	call   800748 <cprintf>
  8003e3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003eb:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800407:	51                   	push   %ecx
  800408:	52                   	push   %edx
  800409:	50                   	push   %eax
  80040a:	68 3c 2d 80 00       	push   $0x802d3c
  80040f:	e8 34 03 00 00       	call   800748 <cprintf>
  800414:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800417:	a1 20 40 80 00       	mov    0x804020,%eax
  80041c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800422:	83 ec 08             	sub    $0x8,%esp
  800425:	50                   	push   %eax
  800426:	68 94 2d 80 00       	push   $0x802d94
  80042b:	e8 18 03 00 00       	call   800748 <cprintf>
  800430:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	68 c8 2c 80 00       	push   $0x802cc8
  80043b:	e8 08 03 00 00       	call   800748 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800443:	e8 25 14 00 00       	call   80186d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800448:	e8 1f 00 00 00       	call   80046c <exit>
}
  80044d:	90                   	nop
  80044e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800451:	5b                   	pop    %ebx
  800452:	5e                   	pop    %esi
  800453:	5f                   	pop    %edi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
  800459:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80045c:	83 ec 0c             	sub    $0xc,%esp
  80045f:	6a 00                	push   $0x0
  800461:	e8 32 16 00 00       	call   801a98 <sys_destroy_env>
  800466:	83 c4 10             	add    $0x10,%esp
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <exit>:

void
exit(void)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800472:	e8 87 16 00 00       	call   801afe <sys_exit_env>
}
  800477:	90                   	nop
  800478:	c9                   	leave  
  800479:	c3                   	ret    

0080047a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80047a:	55                   	push   %ebp
  80047b:	89 e5                	mov    %esp,%ebp
  80047d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800480:	8d 45 10             	lea    0x10(%ebp),%eax
  800483:	83 c0 04             	add    $0x4,%eax
  800486:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800489:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80048e:	85 c0                	test   %eax,%eax
  800490:	74 16                	je     8004a8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800492:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	50                   	push   %eax
  80049b:	68 0c 2e 80 00       	push   $0x802e0c
  8004a0:	e8 a3 02 00 00       	call   800748 <cprintf>
  8004a5:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004a8:	a1 04 40 80 00       	mov    0x804004,%eax
  8004ad:	83 ec 0c             	sub    $0xc,%esp
  8004b0:	ff 75 0c             	pushl  0xc(%ebp)
  8004b3:	ff 75 08             	pushl  0x8(%ebp)
  8004b6:	50                   	push   %eax
  8004b7:	68 14 2e 80 00       	push   $0x802e14
  8004bc:	6a 74                	push   $0x74
  8004be:	e8 b2 02 00 00       	call   800775 <cprintf_colored>
  8004c3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8004cf:	50                   	push   %eax
  8004d0:	e8 04 02 00 00       	call   8006d9 <vcprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	6a 00                	push   $0x0
  8004dd:	68 3c 2e 80 00       	push   $0x802e3c
  8004e2:	e8 f2 01 00 00       	call   8006d9 <vcprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004ea:	e8 7d ff ff ff       	call   80046c <exit>

	// should not return here
	while (1) ;
  8004ef:	eb fe                	jmp    8004ef <_panic+0x75>

008004f1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800502:	8b 45 0c             	mov    0xc(%ebp),%eax
  800505:	39 c2                	cmp    %eax,%edx
  800507:	74 14                	je     80051d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 40 2e 80 00       	push   $0x802e40
  800511:	6a 26                	push   $0x26
  800513:	68 8c 2e 80 00       	push   $0x802e8c
  800518:	e8 5d ff ff ff       	call   80047a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80051d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800524:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80052b:	e9 c5 00 00 00       	jmp    8005f5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800533:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	85 c0                	test   %eax,%eax
  800543:	75 08                	jne    80054d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800545:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800548:	e9 a5 00 00 00       	jmp    8005f2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80054d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800554:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80055b:	eb 69                	jmp    8005c6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80055d:	a1 20 40 80 00       	mov    0x804020,%eax
  800562:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800568:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056b:	89 d0                	mov    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	c1 e0 03             	shl    $0x3,%eax
  800574:	01 c8                	add    %ecx,%eax
  800576:	8a 40 04             	mov    0x4(%eax),%al
  800579:	84 c0                	test   %al,%al
  80057b:	75 46                	jne    8005c3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80057d:	a1 20 40 80 00       	mov    0x804020,%eax
  800582:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800588:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058b:	89 d0                	mov    %edx,%eax
  80058d:	01 c0                	add    %eax,%eax
  80058f:	01 d0                	add    %edx,%eax
  800591:	c1 e0 03             	shl    $0x3,%eax
  800594:	01 c8                	add    %ecx,%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80059b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	01 c8                	add    %ecx,%eax
  8005b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	39 c2                	cmp    %eax,%edx
  8005b8:	75 09                	jne    8005c3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005c1:	eb 15                	jmp    8005d8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c3:	ff 45 e8             	incl   -0x18(%ebp)
  8005c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005cb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d4:	39 c2                	cmp    %eax,%edx
  8005d6:	77 85                	ja     80055d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005dc:	75 14                	jne    8005f2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005de:	83 ec 04             	sub    $0x4,%esp
  8005e1:	68 98 2e 80 00       	push   $0x802e98
  8005e6:	6a 3a                	push   $0x3a
  8005e8:	68 8c 2e 80 00       	push   $0x802e8c
  8005ed:	e8 88 fe ff ff       	call   80047a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005f2:	ff 45 f0             	incl   -0x10(%ebp)
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005fb:	0f 8c 2f ff ff ff    	jl     800530 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800601:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800608:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80060f:	eb 26                	jmp    800637 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800611:	a1 20 40 80 00       	mov    0x804020,%eax
  800616:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80061c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061f:	89 d0                	mov    %edx,%eax
  800621:	01 c0                	add    %eax,%eax
  800623:	01 d0                	add    %edx,%eax
  800625:	c1 e0 03             	shl    $0x3,%eax
  800628:	01 c8                	add    %ecx,%eax
  80062a:	8a 40 04             	mov    0x4(%eax),%al
  80062d:	3c 01                	cmp    $0x1,%al
  80062f:	75 03                	jne    800634 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800631:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800634:	ff 45 e0             	incl   -0x20(%ebp)
  800637:	a1 20 40 80 00       	mov    0x804020,%eax
  80063c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800645:	39 c2                	cmp    %eax,%edx
  800647:	77 c8                	ja     800611 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80064f:	74 14                	je     800665 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 ec 2e 80 00       	push   $0x802eec
  800659:	6a 44                	push   $0x44
  80065b:	68 8c 2e 80 00       	push   $0x802e8c
  800660:	e8 15 fe ff ff       	call   80047a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800665:	90                   	nop
  800666:	c9                   	leave  
  800667:	c3                   	ret    

00800668 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	53                   	push   %ebx
  80066c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 30                	jne    8006c4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800694:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80069a:	a0 44 40 80 00       	mov    0x804044,%al
  80069f:	0f b6 c0             	movzbl %al,%eax
  8006a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a5:	8b 09                	mov    (%ecx),%ecx
  8006a7:	89 cb                	mov    %ecx,%ebx
  8006a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ac:	83 c1 08             	add    $0x8,%ecx
  8006af:	52                   	push   %edx
  8006b0:	50                   	push   %eax
  8006b1:	53                   	push   %ebx
  8006b2:	51                   	push   %ecx
  8006b3:	e8 57 11 00 00       	call   80180f <sys_cputs>
  8006b8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c7:	8b 40 04             	mov    0x4(%eax),%eax
  8006ca:	8d 50 01             	lea    0x1(%eax),%edx
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006d3:	90                   	nop
  8006d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d7:	c9                   	leave  
  8006d8:	c3                   	ret    

008006d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d9:	55                   	push   %ebp
  8006da:	89 e5                	mov    %esp,%ebp
  8006dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e9:	00 00 00 
	b.cnt = 0;
  8006ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 08             	pushl  0x8(%ebp)
  8006fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800702:	50                   	push   %eax
  800703:	68 68 06 80 00       	push   $0x800668
  800708:	e8 5a 02 00 00       	call   800967 <vprintfmt>
  80070d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800710:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800716:	a0 44 40 80 00       	mov    0x804044,%al
  80071b:	0f b6 c0             	movzbl %al,%eax
  80071e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800724:	52                   	push   %edx
  800725:	50                   	push   %eax
  800726:	51                   	push   %ecx
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	83 c0 08             	add    $0x8,%eax
  800730:	50                   	push   %eax
  800731:	e8 d9 10 00 00       	call   80180f <sys_cputs>
  800736:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800739:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800740:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800755:	8d 45 0c             	lea    0xc(%ebp),%eax
  800758:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 f4             	pushl  -0xc(%ebp)
  800764:	50                   	push   %eax
  800765:	e8 6f ff ff ff       	call   8006d9 <vcprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
  80076d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800770:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	c1 e0 08             	shl    $0x8,%eax
  800788:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  80078d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800790:	83 c0 04             	add    $0x4,%eax
  800793:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800796:	8b 45 0c             	mov    0xc(%ebp),%eax
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 f4             	pushl  -0xc(%ebp)
  80079f:	50                   	push   %eax
  8007a0:	e8 34 ff ff ff       	call   8006d9 <vcprintf>
  8007a5:	83 c4 10             	add    $0x10,%esp
  8007a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ab:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007b2:	07 00 00 

	return cnt;
  8007b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007c0:	e8 8e 10 00 00       	call   801853 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007c5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	e8 ff fe ff ff       	call   8006d9 <vcprintf>
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007e0:	e8 88 10 00 00       	call   80186d <sys_unlock_cons>
	return cnt;
  8007e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    

008007ea <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	53                   	push   %ebx
  8007ee:	83 ec 14             	sub    $0x14,%esp
  8007f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fd:	8b 45 18             	mov    0x18(%ebp),%eax
  800800:	ba 00 00 00 00       	mov    $0x0,%edx
  800805:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800808:	77 55                	ja     80085f <printnum+0x75>
  80080a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080d:	72 05                	jb     800814 <printnum+0x2a>
  80080f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800812:	77 4b                	ja     80085f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800814:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800817:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80081a:	8b 45 18             	mov    0x18(%ebp),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	52                   	push   %edx
  800823:	50                   	push   %eax
  800824:	ff 75 f4             	pushl  -0xc(%ebp)
  800827:	ff 75 f0             	pushl  -0x10(%ebp)
  80082a:	e8 09 20 00 00       	call   802838 <__udivdi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	83 ec 04             	sub    $0x4,%esp
  800835:	ff 75 20             	pushl  0x20(%ebp)
  800838:	53                   	push   %ebx
  800839:	ff 75 18             	pushl  0x18(%ebp)
  80083c:	52                   	push   %edx
  80083d:	50                   	push   %eax
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	ff 75 08             	pushl  0x8(%ebp)
  800844:	e8 a1 ff ff ff       	call   8007ea <printnum>
  800849:	83 c4 20             	add    $0x20,%esp
  80084c:	eb 1a                	jmp    800868 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	ff 75 20             	pushl  0x20(%ebp)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	ff d0                	call   *%eax
  80085c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085f:	ff 4d 1c             	decl   0x1c(%ebp)
  800862:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800866:	7f e6                	jg     80084e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800868:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80086b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800876:	53                   	push   %ebx
  800877:	51                   	push   %ecx
  800878:	52                   	push   %edx
  800879:	50                   	push   %eax
  80087a:	e8 c9 20 00 00       	call   802948 <__umoddi3>
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	05 54 31 80 00       	add    $0x803154,%eax
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f be c0             	movsbl %al,%eax
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	50                   	push   %eax
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
}
  80089b:	90                   	nop
  80089c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a8:	7e 1c                	jle    8008c6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 08             	lea    0x8(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 08             	sub    $0x8,%eax
  8008bf:	8b 50 04             	mov    0x4(%eax),%edx
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	eb 40                	jmp    800906 <getuint+0x65>
	else if (lflag)
  8008c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ca:	74 1e                	je     8008ea <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e8:	eb 1c                	jmp    800906 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	8d 50 04             	lea    0x4(%eax),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	89 10                	mov    %edx,(%eax)
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	83 e8 04             	sub    $0x4,%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80090b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090f:	7e 1c                	jle    80092d <getint+0x25>
		return va_arg(*ap, long long);
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	8d 50 08             	lea    0x8(%eax),%edx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	89 10                	mov    %edx,(%eax)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	83 e8 08             	sub    $0x8,%eax
  800926:	8b 50 04             	mov    0x4(%eax),%edx
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	eb 38                	jmp    800965 <getint+0x5d>
	else if (lflag)
  80092d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800931:	74 1a                	je     80094d <getint+0x45>
		return va_arg(*ap, long);
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 50 04             	lea    0x4(%eax),%edx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 10                	mov    %edx,(%eax)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	99                   	cltd   
  80094b:	eb 18                	jmp    800965 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	8b 00                	mov    (%eax),%eax
  800952:	8d 50 04             	lea    0x4(%eax),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 10                	mov    %edx,(%eax)
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8b 00                	mov    (%eax),%eax
  80095f:	83 e8 04             	sub    $0x4,%eax
  800962:	8b 00                	mov    (%eax),%eax
  800964:	99                   	cltd   
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	56                   	push   %esi
  80096b:	53                   	push   %ebx
  80096c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096f:	eb 17                	jmp    800988 <vprintfmt+0x21>
			if (ch == '\0')
  800971:	85 db                	test   %ebx,%ebx
  800973:	0f 84 c1 03 00 00    	je     800d3a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 0c             	pushl  0xc(%ebp)
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	8b 45 10             	mov    0x10(%ebp),%eax
  80098b:	8d 50 01             	lea    0x1(%eax),%edx
  80098e:	89 55 10             	mov    %edx,0x10(%ebp)
  800991:	8a 00                	mov    (%eax),%al
  800993:	0f b6 d8             	movzbl %al,%ebx
  800996:	83 fb 25             	cmp    $0x25,%ebx
  800999:	75 d6                	jne    800971 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80099b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009be:	8d 50 01             	lea    0x1(%eax),%edx
  8009c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c4:	8a 00                	mov    (%eax),%al
  8009c6:	0f b6 d8             	movzbl %al,%ebx
  8009c9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009cc:	83 f8 5b             	cmp    $0x5b,%eax
  8009cf:	0f 87 3d 03 00 00    	ja     800d12 <vprintfmt+0x3ab>
  8009d5:	8b 04 85 78 31 80 00 	mov    0x803178(,%eax,4),%eax
  8009dc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009de:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009e2:	eb d7                	jmp    8009bb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e8:	eb d1                	jmp    8009bb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f4:	89 d0                	mov    %edx,%eax
  8009f6:	c1 e0 02             	shl    $0x2,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	01 c0                	add    %eax,%eax
  8009fd:	01 d8                	add    %ebx,%eax
  8009ff:	83 e8 30             	sub    $0x30,%eax
  800a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a05:	8b 45 10             	mov    0x10(%ebp),%eax
  800a08:	8a 00                	mov    (%eax),%al
  800a0a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0d:	83 fb 2f             	cmp    $0x2f,%ebx
  800a10:	7e 3e                	jle    800a50 <vprintfmt+0xe9>
  800a12:	83 fb 39             	cmp    $0x39,%ebx
  800a15:	7f 39                	jg     800a50 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a17:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a1a:	eb d5                	jmp    8009f1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1f:	83 c0 04             	add    $0x4,%eax
  800a22:	89 45 14             	mov    %eax,0x14(%ebp)
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 e8 04             	sub    $0x4,%eax
  800a2b:	8b 00                	mov    (%eax),%eax
  800a2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a30:	eb 1f                	jmp    800a51 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a36:	79 83                	jns    8009bb <vprintfmt+0x54>
				width = 0;
  800a38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3f:	e9 77 ff ff ff       	jmp    8009bb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a44:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a4b:	e9 6b ff ff ff       	jmp    8009bb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a50:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a55:	0f 89 60 ff ff ff    	jns    8009bb <vprintfmt+0x54>
				width = precision, precision = -1;
  800a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a61:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a68:	e9 4e ff ff ff       	jmp    8009bb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a70:	e9 46 ff ff ff       	jmp    8009bb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a75:	8b 45 14             	mov    0x14(%ebp),%eax
  800a78:	83 c0 04             	add    $0x4,%eax
  800a7b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a81:	83 e8 04             	sub    $0x4,%eax
  800a84:	8b 00                	mov    (%eax),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
			break;
  800a95:	e9 9b 02 00 00       	jmp    800d35 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9d:	83 c0 04             	add    $0x4,%eax
  800aa0:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 e8 04             	sub    $0x4,%eax
  800aa9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aab:	85 db                	test   %ebx,%ebx
  800aad:	79 02                	jns    800ab1 <vprintfmt+0x14a>
				err = -err;
  800aaf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ab1:	83 fb 64             	cmp    $0x64,%ebx
  800ab4:	7f 0b                	jg     800ac1 <vprintfmt+0x15a>
  800ab6:	8b 34 9d c0 2f 80 00 	mov    0x802fc0(,%ebx,4),%esi
  800abd:	85 f6                	test   %esi,%esi
  800abf:	75 19                	jne    800ada <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ac1:	53                   	push   %ebx
  800ac2:	68 65 31 80 00       	push   $0x803165
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	ff 75 08             	pushl  0x8(%ebp)
  800acd:	e8 70 02 00 00       	call   800d42 <printfmt>
  800ad2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad5:	e9 5b 02 00 00       	jmp    800d35 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ada:	56                   	push   %esi
  800adb:	68 6e 31 80 00       	push   $0x80316e
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 57 02 00 00       	call   800d42 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			break;
  800aee:	e9 42 02 00 00       	jmp    800d35 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af3:	8b 45 14             	mov    0x14(%ebp),%eax
  800af6:	83 c0 04             	add    $0x4,%eax
  800af9:	89 45 14             	mov    %eax,0x14(%ebp)
  800afc:	8b 45 14             	mov    0x14(%ebp),%eax
  800aff:	83 e8 04             	sub    $0x4,%eax
  800b02:	8b 30                	mov    (%eax),%esi
  800b04:	85 f6                	test   %esi,%esi
  800b06:	75 05                	jne    800b0d <vprintfmt+0x1a6>
				p = "(null)";
  800b08:	be 71 31 80 00       	mov    $0x803171,%esi
			if (width > 0 && padc != '-')
  800b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b11:	7e 6d                	jle    800b80 <vprintfmt+0x219>
  800b13:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b17:	74 67                	je     800b80 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	50                   	push   %eax
  800b20:	56                   	push   %esi
  800b21:	e8 1e 03 00 00       	call   800e44 <strnlen>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b2c:	eb 16                	jmp    800b44 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	50                   	push   %eax
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	ff d0                	call   *%eax
  800b3e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b41:	ff 4d e4             	decl   -0x1c(%ebp)
  800b44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b48:	7f e4                	jg     800b2e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4a:	eb 34                	jmp    800b80 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b50:	74 1c                	je     800b6e <vprintfmt+0x207>
  800b52:	83 fb 1f             	cmp    $0x1f,%ebx
  800b55:	7e 05                	jle    800b5c <vprintfmt+0x1f5>
  800b57:	83 fb 7e             	cmp    $0x7e,%ebx
  800b5a:	7e 12                	jle    800b6e <vprintfmt+0x207>
					putch('?', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 3f                	push   $0x3f
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
  800b6c:	eb 0f                	jmp    800b7d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	53                   	push   %ebx
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	89 f0                	mov    %esi,%eax
  800b82:	8d 70 01             	lea    0x1(%eax),%esi
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f be d8             	movsbl %al,%ebx
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	74 24                	je     800bb2 <vprintfmt+0x24b>
  800b8e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b92:	78 b8                	js     800b4c <vprintfmt+0x1e5>
  800b94:	ff 4d e0             	decl   -0x20(%ebp)
  800b97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b9b:	79 af                	jns    800b4c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9d:	eb 13                	jmp    800bb2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 20                	push   $0x20
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800baf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb6:	7f e7                	jg     800b9f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb8:	e9 78 01 00 00       	jmp    800d35 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc3:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc6:	50                   	push   %eax
  800bc7:	e8 3c fd ff ff       	call   800908 <getint>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdb:	85 d2                	test   %edx,%edx
  800bdd:	79 23                	jns    800c02 <vprintfmt+0x29b>
				putch('-', putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	6a 2d                	push   $0x2d
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	ff d0                	call   *%eax
  800bec:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf5:	f7 d8                	neg    %eax
  800bf7:	83 d2 00             	adc    $0x0,%edx
  800bfa:	f7 da                	neg    %edx
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c02:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c09:	e9 bc 00 00 00       	jmp    800cca <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 e8             	pushl  -0x18(%ebp)
  800c14:	8d 45 14             	lea    0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	e8 84 fc ff ff       	call   8008a1 <getuint>
  800c1d:	83 c4 10             	add    $0x10,%esp
  800c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c23:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c26:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2d:	e9 98 00 00 00       	jmp    800cca <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 58                	push   $0x58
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 0c             	pushl  0xc(%ebp)
  800c48:	6a 58                	push   $0x58
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	ff d0                	call   *%eax
  800c4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c52:	83 ec 08             	sub    $0x8,%esp
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	6a 58                	push   $0x58
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			break;
  800c62:	e9 ce 00 00 00       	jmp    800d35 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 0c             	pushl  0xc(%ebp)
  800c6d:	6a 30                	push   $0x30
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	ff d0                	call   *%eax
  800c74:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 78                	push   $0x78
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	83 c0 04             	add    $0x4,%eax
  800c8d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 e8 04             	sub    $0x4,%eax
  800c96:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ca2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca9:	eb 1f                	jmp    800cca <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb1:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb4:	50                   	push   %eax
  800cb5:	e8 e7 fb ff ff       	call   8008a1 <getuint>
  800cba:	83 c4 10             	add    $0x10,%esp
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cca:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	83 ec 04             	sub    $0x4,%esp
  800cd4:	52                   	push   %edx
  800cd5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cdc:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdf:	ff 75 0c             	pushl  0xc(%ebp)
  800ce2:	ff 75 08             	pushl  0x8(%ebp)
  800ce5:	e8 00 fb ff ff       	call   8007ea <printnum>
  800cea:	83 c4 20             	add    $0x20,%esp
			break;
  800ced:	eb 46                	jmp    800d35 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cef:	83 ec 08             	sub    $0x8,%esp
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	53                   	push   %ebx
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	ff d0                	call   *%eax
  800cfb:	83 c4 10             	add    $0x10,%esp
			break;
  800cfe:	eb 35                	jmp    800d35 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d00:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d07:	eb 2c                	jmp    800d35 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d09:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d10:	eb 23                	jmp    800d35 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	6a 25                	push   $0x25
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	ff d0                	call   *%eax
  800d1f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d22:	ff 4d 10             	decl   0x10(%ebp)
  800d25:	eb 03                	jmp    800d2a <vprintfmt+0x3c3>
  800d27:	ff 4d 10             	decl   0x10(%ebp)
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	48                   	dec    %eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	3c 25                	cmp    $0x25,%al
  800d32:	75 f3                	jne    800d27 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d34:	90                   	nop
		}
	}
  800d35:	e9 35 fc ff ff       	jmp    80096f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d3a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d48:	8d 45 10             	lea    0x10(%ebp),%eax
  800d4b:	83 c0 04             	add    $0x4,%eax
  800d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d51:	8b 45 10             	mov    0x10(%ebp),%eax
  800d54:	ff 75 f4             	pushl  -0xc(%ebp)
  800d57:	50                   	push   %eax
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	ff 75 08             	pushl  0x8(%ebp)
  800d5e:	e8 04 fc ff ff       	call   800967 <vprintfmt>
  800d63:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d66:	90                   	nop
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8b 40 08             	mov    0x8(%eax),%eax
  800d72:	8d 50 01             	lea    0x1(%eax),%edx
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8b 10                	mov    (%eax),%edx
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	8b 40 04             	mov    0x4(%eax),%eax
  800d86:	39 c2                	cmp    %eax,%edx
  800d88:	73 12                	jae    800d9c <sprintputch+0x33>
		*b->buf++ = ch;
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d95:	89 0a                	mov    %ecx,(%edx)
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	88 10                	mov    %dl,(%eax)
}
  800d9c:	90                   	nop
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    

00800d9f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	01 d0                	add    %edx,%eax
  800db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc4:	74 06                	je     800dcc <vsnprintf+0x2d>
  800dc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dca:	7f 07                	jg     800dd3 <vsnprintf+0x34>
		return -E_INVAL;
  800dcc:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd1:	eb 20                	jmp    800df3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd3:	ff 75 14             	pushl  0x14(%ebp)
  800dd6:	ff 75 10             	pushl  0x10(%ebp)
  800dd9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ddc:	50                   	push   %eax
  800ddd:	68 69 0d 80 00       	push   $0x800d69
  800de2:	e8 80 fb ff ff       	call   800967 <vprintfmt>
  800de7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dfb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfe:	83 c0 04             	add    $0x4,%eax
  800e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e04:	8b 45 10             	mov    0x10(%ebp),%eax
  800e07:	ff 75 f4             	pushl  -0xc(%ebp)
  800e0a:	50                   	push   %eax
  800e0b:	ff 75 0c             	pushl  0xc(%ebp)
  800e0e:	ff 75 08             	pushl  0x8(%ebp)
  800e11:	e8 89 ff ff ff       	call   800d9f <vsnprintf>
  800e16:	83 c4 10             	add    $0x10,%esp
  800e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2e:	eb 06                	jmp    800e36 <strlen+0x15>
		n++;
  800e30:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e33:	ff 45 08             	incl   0x8(%ebp)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	84 c0                	test   %al,%al
  800e3d:	75 f1                	jne    800e30 <strlen+0xf>
		n++;
	return n;
  800e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e42:	c9                   	leave  
  800e43:	c3                   	ret    

00800e44 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e51:	eb 09                	jmp    800e5c <strnlen+0x18>
		n++;
  800e53:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e56:	ff 45 08             	incl   0x8(%ebp)
  800e59:	ff 4d 0c             	decl   0xc(%ebp)
  800e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e60:	74 09                	je     800e6b <strnlen+0x27>
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	84 c0                	test   %al,%al
  800e69:	75 e8                	jne    800e53 <strnlen+0xf>
		n++;
	return n;
  800e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e7c:	90                   	nop
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 08             	mov    %edx,0x8(%ebp)
  800e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	75 e4                	jne    800e7d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb1:	eb 1f                	jmp    800ed2 <strncpy+0x34>
		*dst++ = *src;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	8d 50 01             	lea    0x1(%eax),%edx
  800eb9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebf:	8a 12                	mov    (%edx),%dl
  800ec1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	74 03                	je     800ecf <strncpy+0x31>
			src++;
  800ecc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecf:	ff 45 fc             	incl   -0x4(%ebp)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed8:	72 d9                	jb     800eb3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eeb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eef:	74 30                	je     800f21 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef1:	eb 16                	jmp    800f09 <strlcpy+0x2a>
			*dst++ = *src++;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8d 50 01             	lea    0x1(%eax),%edx
  800ef9:	89 55 08             	mov    %edx,0x8(%ebp)
  800efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f02:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f05:	8a 12                	mov    (%edx),%dl
  800f07:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f09:	ff 4d 10             	decl   0x10(%ebp)
  800f0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f10:	74 09                	je     800f1b <strlcpy+0x3c>
  800f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	84 c0                	test   %al,%al
  800f19:	75 d8                	jne    800ef3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f30:	eb 06                	jmp    800f38 <strcmp+0xb>
		p++, q++;
  800f32:	ff 45 08             	incl   0x8(%ebp)
  800f35:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	84 c0                	test   %al,%al
  800f3f:	74 0e                	je     800f4f <strcmp+0x22>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 10                	mov    (%eax),%dl
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	38 c2                	cmp    %al,%dl
  800f4d:	74 e3                	je     800f32 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	0f b6 d0             	movzbl %al,%edx
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	0f b6 c0             	movzbl %al,%eax
  800f5f:	29 c2                	sub    %eax,%edx
  800f61:	89 d0                	mov    %edx,%eax
}
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f68:	eb 09                	jmp    800f73 <strncmp+0xe>
		n--, p++, q++;
  800f6a:	ff 4d 10             	decl   0x10(%ebp)
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f77:	74 17                	je     800f90 <strncmp+0x2b>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	84 c0                	test   %al,%al
  800f80:	74 0e                	je     800f90 <strncmp+0x2b>
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 10                	mov    (%eax),%dl
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	38 c2                	cmp    %al,%dl
  800f8e:	74 da                	je     800f6a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 07                	jne    800f9d <strncmp+0x38>
		return 0;
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9b:	eb 14                	jmp    800fb1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d0             	movzbl %al,%edx
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	0f b6 c0             	movzbl %al,%eax
  800fad:	29 c2                	sub    %eax,%edx
  800faf:	89 d0                	mov    %edx,%eax
}
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 12                	jmp    800fd3 <strchr+0x20>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	75 05                	jne    800fd0 <strchr+0x1d>
			return (char *) s;
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	eb 11                	jmp    800fe1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd0:	ff 45 08             	incl   0x8(%ebp)
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	84 c0                	test   %al,%al
  800fda:	75 e5                	jne    800fc1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    

00800fe3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	83 ec 04             	sub    $0x4,%esp
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fef:	eb 0d                	jmp    800ffe <strfind+0x1b>
		if (*s == c)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff9:	74 0e                	je     801009 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 ea                	jne    800ff1 <strfind+0xe>
  801007:	eb 01                	jmp    80100a <strfind+0x27>
		if (*s == c)
			break;
  801009:	90                   	nop
	return (char *) s;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80101b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101f:	76 63                	jbe    801084 <memset+0x75>
		uint64 data_block = c;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	99                   	cltd   
  801025:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801028:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80102b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801031:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801035:	c1 e0 08             	shl    $0x8,%eax
  801038:	09 45 f0             	or     %eax,-0x10(%ebp)
  80103b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80103e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801044:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801048:	c1 e0 10             	shl    $0x10,%eax
  80104b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801057:	89 c2                	mov    %eax,%edx
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
  80105e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801061:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801064:	eb 18                	jmp    80107e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801066:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801069:	8d 41 08             	lea    0x8(%ecx),%eax
  80106c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80106f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801075:	89 01                	mov    %eax,(%ecx)
  801077:	89 51 04             	mov    %edx,0x4(%ecx)
  80107a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80107e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801082:	77 e2                	ja     801066 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	74 23                	je     8010ad <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801090:	eb 0e                	jmp    8010a0 <memset+0x91>
			*p8++ = (uint8)c;
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801095:	8d 50 01             	lea    0x1(%eax),%edx
  801098:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	75 e5                	jne    801092 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010c4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c8:	76 24                	jbe    8010ee <memcpy+0x3c>
		while(n >= 8){
  8010ca:	eb 1c                	jmp    8010e8 <memcpy+0x36>
			*d64 = *s64;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	8b 50 04             	mov    0x4(%eax),%edx
  8010d2:	8b 00                	mov    (%eax),%eax
  8010d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d7:	89 01                	mov    %eax,(%ecx)
  8010d9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010dc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010e0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010e4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010e8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ec:	77 de                	ja     8010cc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f2:	74 31                	je     801125 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801100:	eb 16                	jmp    801118 <memcpy+0x66>
			*d8++ = *s8++;
  801102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801105:	8d 50 01             	lea    0x1(%eax),%edx
  801108:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80110b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801111:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801114:	8a 12                	mov    (%edx),%dl
  801116:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	89 55 10             	mov    %edx,0x10(%ebp)
  801121:	85 c0                	test   %eax,%eax
  801123:	75 dd                	jne    801102 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801142:	73 50                	jae    801194 <memmove+0x6a>
  801144:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801147:	8b 45 10             	mov    0x10(%ebp),%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114f:	76 43                	jbe    801194 <memmove+0x6a>
		s += n;
  801151:	8b 45 10             	mov    0x10(%ebp),%eax
  801154:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801157:	8b 45 10             	mov    0x10(%ebp),%eax
  80115a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80115d:	eb 10                	jmp    80116f <memmove+0x45>
			*--d = *--s;
  80115f:	ff 4d f8             	decl   -0x8(%ebp)
  801162:	ff 4d fc             	decl   -0x4(%ebp)
  801165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801168:	8a 10                	mov    (%eax),%dl
  80116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80116f:	8b 45 10             	mov    0x10(%ebp),%eax
  801172:	8d 50 ff             	lea    -0x1(%eax),%edx
  801175:	89 55 10             	mov    %edx,0x10(%ebp)
  801178:	85 c0                	test   %eax,%eax
  80117a:	75 e3                	jne    80115f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80117c:	eb 23                	jmp    8011a1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80117e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801181:	8d 50 01             	lea    0x1(%eax),%edx
  801184:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801187:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80118d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 dd                	jne    80117e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011b8:	eb 2a                	jmp    8011e4 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bd:	8a 10                	mov    (%eax),%dl
  8011bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	38 c2                	cmp    %al,%dl
  8011c6:	74 16                	je     8011de <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	0f b6 d0             	movzbl %al,%edx
  8011d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 c0             	movzbl %al,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	eb 18                	jmp    8011f6 <memcmp+0x50>
		s1++, s2++;
  8011de:	ff 45 fc             	incl   -0x4(%ebp)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	75 c9                	jne    8011ba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801209:	eb 15                	jmp    801220 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	0f b6 c0             	movzbl %al,%eax
  801219:	39 c2                	cmp    %eax,%edx
  80121b:	74 0d                	je     80122a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801226:	72 e3                	jb     80120b <memfind+0x13>
  801228:	eb 01                	jmp    80122b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80122a:	90                   	nop
	return (void *) s;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80123d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801244:	eb 03                	jmp    801249 <strtol+0x19>
		s++;
  801246:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 20                	cmp    $0x20,%al
  801250:	74 f4                	je     801246 <strtol+0x16>
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 09                	cmp    $0x9,%al
  801259:	74 eb                	je     801246 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 2b                	cmp    $0x2b,%al
  801262:	75 05                	jne    801269 <strtol+0x39>
		s++;
  801264:	ff 45 08             	incl   0x8(%ebp)
  801267:	eb 13                	jmp    80127c <strtol+0x4c>
	else if (*s == '-')
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	3c 2d                	cmp    $0x2d,%al
  801270:	75 0a                	jne    80127c <strtol+0x4c>
		s++, neg = 1;
  801272:	ff 45 08             	incl   0x8(%ebp)
  801275:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80127c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801280:	74 06                	je     801288 <strtol+0x58>
  801282:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801286:	75 20                	jne    8012a8 <strtol+0x78>
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	3c 30                	cmp    $0x30,%al
  80128f:	75 17                	jne    8012a8 <strtol+0x78>
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	40                   	inc    %eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 78                	cmp    $0x78,%al
  801299:	75 0d                	jne    8012a8 <strtol+0x78>
		s += 2, base = 16;
  80129b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80129f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012a6:	eb 28                	jmp    8012d0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ac:	75 15                	jne    8012c3 <strtol+0x93>
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 30                	cmp    $0x30,%al
  8012b5:	75 0c                	jne    8012c3 <strtol+0x93>
		s++, base = 8;
  8012b7:	ff 45 08             	incl   0x8(%ebp)
  8012ba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012c1:	eb 0d                	jmp    8012d0 <strtol+0xa0>
	else if (base == 0)
  8012c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c7:	75 07                	jne    8012d0 <strtol+0xa0>
		base = 10;
  8012c9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 2f                	cmp    $0x2f,%al
  8012d7:	7e 19                	jle    8012f2 <strtol+0xc2>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 39                	cmp    $0x39,%al
  8012e0:	7f 10                	jg     8012f2 <strtol+0xc2>
			dig = *s - '0';
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f be c0             	movsbl %al,%eax
  8012ea:	83 e8 30             	sub    $0x30,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012f0:	eb 42                	jmp    801334 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 60                	cmp    $0x60,%al
  8012f9:	7e 19                	jle    801314 <strtol+0xe4>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 7a                	cmp    $0x7a,%al
  801302:	7f 10                	jg     801314 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	0f be c0             	movsbl %al,%eax
  80130c:	83 e8 57             	sub    $0x57,%eax
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801312:	eb 20                	jmp    801334 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 40                	cmp    $0x40,%al
  80131b:	7e 39                	jle    801356 <strtol+0x126>
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	3c 5a                	cmp    $0x5a,%al
  801324:	7f 30                	jg     801356 <strtol+0x126>
			dig = *s - 'A' + 10;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	0f be c0             	movsbl %al,%eax
  80132e:	83 e8 37             	sub    $0x37,%eax
  801331:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801337:	3b 45 10             	cmp    0x10(%ebp),%eax
  80133a:	7d 19                	jge    801355 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80133c:	ff 45 08             	incl   0x8(%ebp)
  80133f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801342:	0f af 45 10          	imul   0x10(%ebp),%eax
  801346:	89 c2                	mov    %eax,%edx
  801348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801350:	e9 7b ff ff ff       	jmp    8012d0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801355:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801356:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80135a:	74 08                	je     801364 <strtol+0x134>
		*endptr = (char *) s;
  80135c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135f:	8b 55 08             	mov    0x8(%ebp),%edx
  801362:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801364:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801368:	74 07                	je     801371 <strtol+0x141>
  80136a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136d:	f7 d8                	neg    %eax
  80136f:	eb 03                	jmp    801374 <strtol+0x144>
  801371:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <ltostr>:

void
ltostr(long value, char *str)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80137c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801383:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	79 13                	jns    8013a3 <ltostr+0x2d>
	{
		neg = 1;
  801390:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80139d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ab:	99                   	cltd   
  8013ac:	f7 f9                	idiv   %ecx
  8013ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b4:	8d 50 01             	lea    0x1(%eax),%edx
  8013b7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ba:	89 c2                	mov    %eax,%edx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c4:	83 c2 30             	add    $0x30,%edx
  8013c7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013d1:	f7 e9                	imul   %ecx
  8013d3:	c1 fa 02             	sar    $0x2,%edx
  8013d6:	89 c8                	mov    %ecx,%eax
  8013d8:	c1 f8 1f             	sar    $0x1f,%eax
  8013db:	29 c2                	sub    %eax,%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e6:	75 bb                	jne    8013a3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f2:	48                   	dec    %eax
  8013f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013fa:	74 3d                	je     801439 <ltostr+0xc3>
		start = 1 ;
  8013fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801403:	eb 34                	jmp    801439 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140b:	01 d0                	add    %edx,%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801415:	8b 45 0c             	mov    0xc(%ebp),%eax
  801418:	01 c2                	add    %eax,%edx
  80141a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 c8                	add    %ecx,%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801426:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142c:	01 c2                	add    %eax,%edx
  80142e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801431:	88 02                	mov    %al,(%edx)
		start++ ;
  801433:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801436:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80143f:	7c c4                	jl     801405 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801441:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	01 d0                	add    %edx,%eax
  801449:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80144c:	90                   	nop
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801455:	ff 75 08             	pushl  0x8(%ebp)
  801458:	e8 c4 f9 ff ff       	call   800e21 <strlen>
  80145d:	83 c4 04             	add    $0x4,%esp
  801460:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	e8 b6 f9 ff ff       	call   800e21 <strlen>
  80146b:	83 c4 04             	add    $0x4,%esp
  80146e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801471:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801478:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147f:	eb 17                	jmp    801498 <strcconcat+0x49>
		final[s] = str1[s] ;
  801481:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801484:	8b 45 10             	mov    0x10(%ebp),%eax
  801487:	01 c2                	add    %eax,%edx
  801489:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	01 c8                	add    %ecx,%eax
  801491:	8a 00                	mov    (%eax),%al
  801493:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801495:	ff 45 fc             	incl   -0x4(%ebp)
  801498:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80149e:	7c e1                	jl     801481 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014ae:	eb 1f                	jmp    8014cf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b3:	8d 50 01             	lea    0x1(%eax),%edx
  8014b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014be:	01 c2                	add    %eax,%edx
  8014c0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	01 c8                	add    %ecx,%eax
  8014c8:	8a 00                	mov    (%eax),%al
  8014ca:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014cc:	ff 45 f8             	incl   -0x8(%ebp)
  8014cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014d5:	7c d9                	jl     8014b0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014da:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dd:	01 d0                	add    %edx,%eax
  8014df:	c6 00 00             	movb   $0x0,(%eax)
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801508:	eb 0c                	jmp    801516 <strsplit+0x31>
			*string++ = 0;
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8d 50 01             	lea    0x1(%eax),%edx
  801510:	89 55 08             	mov    %edx,0x8(%ebp)
  801513:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	8a 00                	mov    (%eax),%al
  80151b:	84 c0                	test   %al,%al
  80151d:	74 18                	je     801537 <strsplit+0x52>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	0f be c0             	movsbl %al,%eax
  801527:	50                   	push   %eax
  801528:	ff 75 0c             	pushl  0xc(%ebp)
  80152b:	e8 83 fa ff ff       	call   800fb3 <strchr>
  801530:	83 c4 08             	add    $0x8,%esp
  801533:	85 c0                	test   %eax,%eax
  801535:	75 d3                	jne    80150a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	8a 00                	mov    (%eax),%al
  80153c:	84 c0                	test   %al,%al
  80153e:	74 5a                	je     80159a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801540:	8b 45 14             	mov    0x14(%ebp),%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	83 f8 0f             	cmp    $0xf,%eax
  801548:	75 07                	jne    801551 <strsplit+0x6c>
		{
			return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	eb 66                	jmp    8015b7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801551:	8b 45 14             	mov    0x14(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	8d 48 01             	lea    0x1(%eax),%ecx
  801559:	8b 55 14             	mov    0x14(%ebp),%edx
  80155c:	89 0a                	mov    %ecx,(%edx)
  80155e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801565:	8b 45 10             	mov    0x10(%ebp),%eax
  801568:	01 c2                	add    %eax,%edx
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156f:	eb 03                	jmp    801574 <strsplit+0x8f>
			string++;
  801571:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 00                	mov    (%eax),%al
  801579:	84 c0                	test   %al,%al
  80157b:	74 8b                	je     801508 <strsplit+0x23>
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f be c0             	movsbl %al,%eax
  801585:	50                   	push   %eax
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	e8 25 fa ff ff       	call   800fb3 <strchr>
  80158e:	83 c4 08             	add    $0x8,%esp
  801591:	85 c0                	test   %eax,%eax
  801593:	74 dc                	je     801571 <strsplit+0x8c>
			string++;
	}
  801595:	e9 6e ff ff ff       	jmp    801508 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80159a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80159b:	8b 45 14             	mov    0x14(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	01 d0                	add    %edx,%eax
  8015ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015cc:	eb 4a                	jmp    801618 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	01 c2                	add    %eax,%edx
  8015d6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	01 c8                	add    %ecx,%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	8a 00                	mov    (%eax),%al
  8015ec:	3c 40                	cmp    $0x40,%al
  8015ee:	7e 25                	jle    801615 <str2lower+0x5c>
  8015f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	3c 5a                	cmp    $0x5a,%al
  8015fc:	7f 17                	jg     801615 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	01 d0                	add    %edx,%eax
  801606:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801609:	8b 55 08             	mov    0x8(%ebp),%edx
  80160c:	01 ca                	add    %ecx,%edx
  80160e:	8a 12                	mov    (%edx),%dl
  801610:	83 c2 20             	add    $0x20,%edx
  801613:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801615:	ff 45 fc             	incl   -0x4(%ebp)
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	e8 01 f8 ff ff       	call   800e21 <strlen>
  801620:	83 c4 04             	add    $0x4,%esp
  801623:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801626:	7f a6                	jg     8015ce <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801628:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801633:	a1 08 40 80 00       	mov    0x804008,%eax
  801638:	85 c0                	test   %eax,%eax
  80163a:	74 42                	je     80167e <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	68 00 00 00 82       	push   $0x82000000
  801644:	68 00 00 00 80       	push   $0x80000000
  801649:	e8 00 08 00 00       	call   801e4e <initialize_dynamic_allocator>
  80164e:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801651:	e8 e7 05 00 00       	call   801c3d <sys_get_uheap_strategy>
  801656:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80165b:	a1 40 40 80 00       	mov    0x804040,%eax
  801660:	05 00 10 00 00       	add    $0x1000,%eax
  801665:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80166a:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80166f:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801674:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80167b:	00 00 00 
	}
}
  80167e:	90                   	nop
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	68 06 04 00 00       	push   $0x406
  80169d:	50                   	push   %eax
  80169e:	e8 e4 01 00 00       	call   801887 <__sys_allocate_page>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ad:	79 14                	jns    8016c3 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	68 e8 32 80 00       	push   $0x8032e8
  8016b7:	6a 1f                	push   $0x1f
  8016b9:	68 24 33 80 00       	push   $0x803324
  8016be:	e8 b7 ed ff ff       	call   80047a <_panic>
	return 0;
  8016c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016de:	83 ec 0c             	sub    $0xc,%esp
  8016e1:	50                   	push   %eax
  8016e2:	e8 e7 01 00 00       	call   8018ce <__sys_unmap_frame>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f1:	79 14                	jns    801707 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	68 30 33 80 00       	push   $0x803330
  8016fb:	6a 2a                	push   $0x2a
  8016fd:	68 24 33 80 00       	push   $0x803324
  801702:	e8 73 ed ff ff       	call   80047a <_panic>
}
  801707:	90                   	nop
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801710:	e8 18 ff ff ff       	call   80162d <uheap_init>
	if (size == 0) return NULL ;
  801715:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801719:	75 07                	jne    801722 <malloc+0x18>
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
  801720:	eb 14                	jmp    801736 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 70 33 80 00       	push   $0x803370
  80172a:	6a 3e                	push   $0x3e
  80172c:	68 24 33 80 00       	push   $0x803324
  801731:	e8 44 ed ff ff       	call   80047a <_panic>
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 98 33 80 00       	push   $0x803398
  801746:	6a 49                	push   $0x49
  801748:	68 24 33 80 00       	push   $0x803324
  80174d:	e8 28 ed ff ff       	call   80047a <_panic>

00801752 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 18             	sub    $0x18,%esp
  801758:	8b 45 10             	mov    0x10(%ebp),%eax
  80175b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80175e:	e8 ca fe ff ff       	call   80162d <uheap_init>
	if (size == 0) return NULL ;
  801763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801767:	75 07                	jne    801770 <smalloc+0x1e>
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
  80176e:	eb 14                	jmp    801784 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	68 bc 33 80 00       	push   $0x8033bc
  801778:	6a 5a                	push   $0x5a
  80177a:	68 24 33 80 00       	push   $0x803324
  80177f:	e8 f6 ec ff ff       	call   80047a <_panic>
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80178c:	e8 9c fe ff ff       	call   80162d <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801791:	83 ec 04             	sub    $0x4,%esp
  801794:	68 e4 33 80 00       	push   $0x8033e4
  801799:	6a 6a                	push   $0x6a
  80179b:	68 24 33 80 00       	push   $0x803324
  8017a0:	e8 d5 ec ff ff       	call   80047a <_panic>

008017a5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ab:	e8 7d fe ff ff       	call   80162d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	68 08 34 80 00       	push   $0x803408
  8017b8:	68 88 00 00 00       	push   $0x88
  8017bd:	68 24 33 80 00       	push   $0x803324
  8017c2:	e8 b3 ec ff ff       	call   80047a <_panic>

008017c7 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 30 34 80 00       	push   $0x803430
  8017d5:	68 9b 00 00 00       	push   $0x9b
  8017da:	68 24 33 80 00       	push   $0x803324
  8017df:	e8 96 ec ff ff       	call   80047a <_panic>

008017e4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	57                   	push   %edi
  8017e8:	56                   	push   %esi
  8017e9:	53                   	push   %ebx
  8017ea:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017fc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ff:	cd 30                	int    $0x30
  801801:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801807:	83 c4 10             	add    $0x10,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80181b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	51                   	push   %ecx
  801828:	52                   	push   %edx
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	50                   	push   %eax
  80182d:	6a 00                	push   $0x0
  80182f:	e8 b0 ff ff ff       	call   8017e4 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_cgetc>:

int
sys_cgetc(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 02                	push   $0x2
  801849:	e8 96 ff ff ff       	call   8017e4 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 03                	push   $0x3
  801862:	e8 7d ff ff ff       	call   8017e4 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	90                   	nop
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 04                	push   $0x4
  80187c:	e8 63 ff ff ff       	call   8017e4 <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	90                   	nop
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 08                	push   $0x8
  80189a:	e8 45 ff ff ff       	call   8017e4 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	51                   	push   %ecx
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 09                	push   $0x9
  8018bf:	e8 20 ff ff ff       	call   8017e4 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 08             	pushl  0x8(%ebp)
  8018dc:	6a 0a                	push   $0xa
  8018de:	e8 01 ff ff ff       	call   8017e4 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	6a 0b                	push   $0xb
  8018f9:	e8 e6 fe ff ff       	call   8017e4 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 0c                	push   $0xc
  801912:	e8 cd fe ff ff       	call   8017e4 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0d                	push   $0xd
  80192b:	e8 b4 fe ff ff       	call   8017e4 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0e                	push   $0xe
  801944:	e8 9b fe ff ff       	call   8017e4 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 0f                	push   $0xf
  80195d:	e8 82 fe ff ff       	call   8017e4 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 10                	push   $0x10
  801977:	e8 68 fe ff ff       	call   8017e4 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 11                	push   $0x11
  801990:	e8 4f fe ff ff       	call   8017e4 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_cputc>:

void
sys_cputc(const char c)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	50                   	push   %eax
  8019b4:	6a 01                	push   $0x1
  8019b6:	e8 29 fe ff ff       	call   8017e4 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 14                	push   $0x14
  8019d0:	e8 0f fe ff ff       	call   8017e4 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	51                   	push   %ecx
  8019f4:	52                   	push   %edx
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	50                   	push   %eax
  8019f9:	6a 15                	push   $0x15
  8019fb:	e8 e4 fd ff ff       	call   8017e4 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	6a 16                	push   $0x16
  801a18:	e8 c7 fd ff ff       	call   8017e4 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	51                   	push   %ecx
  801a33:	52                   	push   %edx
  801a34:	50                   	push   %eax
  801a35:	6a 17                	push   $0x17
  801a37:	e8 a8 fd ff ff       	call   8017e4 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 18                	push   $0x18
  801a54:	e8 8b fd ff ff       	call   8017e4 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	ff 75 14             	pushl  0x14(%ebp)
  801a69:	ff 75 10             	pushl  0x10(%ebp)
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	50                   	push   %eax
  801a70:	6a 19                	push   $0x19
  801a72:	e8 6d fd ff ff       	call   8017e4 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	50                   	push   %eax
  801a8b:	6a 1a                	push   $0x1a
  801a8d:	e8 52 fd ff ff       	call   8017e4 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	50                   	push   %eax
  801aa7:	6a 1b                	push   $0x1b
  801aa9:	e8 36 fd ff ff       	call   8017e4 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 05                	push   $0x5
  801ac2:	e8 1d fd ff ff       	call   8017e4 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 06                	push   $0x6
  801adb:	e8 04 fd ff ff       	call   8017e4 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 07                	push   $0x7
  801af4:	e8 eb fc ff ff       	call   8017e4 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_exit_env>:


void sys_exit_env(void)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 1c                	push   $0x1c
  801b0d:	e8 d2 fc ff ff       	call   8017e4 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b21:	8d 50 04             	lea    0x4(%eax),%edx
  801b24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1d                	push   $0x1d
  801b31:	e8 ae fc ff ff       	call   8017e4 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
	return result;
  801b39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b42:	89 01                	mov    %eax,(%ecx)
  801b44:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	c9                   	leave  
  801b4b:	c2 04 00             	ret    $0x4

00801b4e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 10             	pushl  0x10(%ebp)
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	ff 75 08             	pushl  0x8(%ebp)
  801b5e:	6a 13                	push   $0x13
  801b60:	e8 7f fc ff ff       	call   8017e4 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return ;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_rcr2>:
uint32 sys_rcr2()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 1e                	push   $0x1e
  801b7a:	e8 65 fc ff ff       	call   8017e4 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b90:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	50                   	push   %eax
  801b9d:	6a 1f                	push   $0x1f
  801b9f:	e8 40 fc ff ff       	call   8017e4 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <rsttst>:
void rsttst()
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 21                	push   $0x21
  801bb9:	e8 26 fc ff ff       	call   8017e4 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc1:	90                   	nop
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 04             	sub    $0x4,%esp
  801bca:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bd0:	8b 55 18             	mov    0x18(%ebp),%edx
  801bd3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	ff 75 10             	pushl  0x10(%ebp)
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	ff 75 08             	pushl  0x8(%ebp)
  801be2:	6a 20                	push   $0x20
  801be4:	e8 fb fb ff ff       	call   8017e4 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <chktst>:
void chktst(uint32 n)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 08             	pushl  0x8(%ebp)
  801bfd:	6a 22                	push   $0x22
  801bff:	e8 e0 fb ff ff       	call   8017e4 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
	return ;
  801c07:	90                   	nop
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <inctst>:

void inctst()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 23                	push   $0x23
  801c19:	e8 c6 fb ff ff       	call   8017e4 <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c21:	90                   	nop
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <gettst>:
uint32 gettst()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 24                	push   $0x24
  801c33:	e8 ac fb ff ff       	call   8017e4 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 25                	push   $0x25
  801c4c:	e8 93 fb ff ff       	call   8017e4 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
  801c54:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c59:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 26                	push   $0x26
  801c78:	e8 67 fb ff ff       	call   8017e4 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	53                   	push   %ebx
  801c96:	51                   	push   %ecx
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 27                	push   $0x27
  801c9b:	e8 44 fb ff ff       	call   8017e4 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 28                	push   $0x28
  801cbb:	e8 24 fb ff ff       	call   8017e4 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cc8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	51                   	push   %ecx
  801cd4:	ff 75 10             	pushl  0x10(%ebp)
  801cd7:	52                   	push   %edx
  801cd8:	50                   	push   %eax
  801cd9:	6a 29                	push   $0x29
  801cdb:	e8 04 fb ff ff       	call   8017e4 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	ff 75 08             	pushl  0x8(%ebp)
  801cf5:	6a 12                	push   $0x12
  801cf7:	e8 e8 fa ff ff       	call   8017e4 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 2a                	push   $0x2a
  801d15:	e8 ca fa ff ff       	call   8017e4 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return;
  801d1d:	90                   	nop
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 2b                	push   $0x2b
  801d2f:	e8 b0 fa ff ff       	call   8017e4 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 2d                	push   $0x2d
  801d4a:	e8 95 fa ff ff       	call   8017e4 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	6a 2c                	push   $0x2c
  801d66:	e8 79 fa ff ff       	call   8017e4 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 54 34 80 00       	push   $0x803454
  801d7f:	68 25 01 00 00       	push   $0x125
  801d84:	68 87 34 80 00       	push   $0x803487
  801d89:	e8 ec e6 ff ff       	call   80047a <_panic>

00801d8e <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801d94:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801d9b:	72 09                	jb     801da6 <to_page_va+0x18>
  801d9d:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801da4:	72 14                	jb     801dba <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801da6:	83 ec 04             	sub    $0x4,%esp
  801da9:	68 98 34 80 00       	push   $0x803498
  801dae:	6a 15                	push   $0x15
  801db0:	68 c3 34 80 00       	push   $0x8034c3
  801db5:	e8 c0 e6 ff ff       	call   80047a <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	ba 60 40 80 00       	mov    $0x804060,%edx
  801dc2:	29 d0                	sub    %edx,%eax
  801dc4:	c1 f8 02             	sar    $0x2,%eax
  801dc7:	89 c2                	mov    %eax,%edx
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	c1 e0 02             	shl    $0x2,%eax
  801dce:	01 d0                	add    %edx,%eax
  801dd0:	c1 e0 02             	shl    $0x2,%eax
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	c1 e0 02             	shl    $0x2,%eax
  801dd8:	01 d0                	add    %edx,%eax
  801dda:	89 c1                	mov    %eax,%ecx
  801ddc:	c1 e1 08             	shl    $0x8,%ecx
  801ddf:	01 c8                	add    %ecx,%eax
  801de1:	89 c1                	mov    %eax,%ecx
  801de3:	c1 e1 10             	shl    $0x10,%ecx
  801de6:	01 c8                	add    %ecx,%eax
  801de8:	01 c0                	add    %eax,%eax
  801dea:	01 d0                	add    %edx,%eax
  801dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	c1 e0 0c             	shl    $0xc,%eax
  801df5:	89 c2                	mov    %eax,%edx
  801df7:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801dfc:	01 d0                	add    %edx,%eax
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e06:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0e:	29 c2                	sub    %eax,%edx
  801e10:	89 d0                	mov    %edx,%eax
  801e12:	c1 e8 0c             	shr    $0xc,%eax
  801e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1c:	78 09                	js     801e27 <to_page_info+0x27>
  801e1e:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e25:	7e 14                	jle    801e3b <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	68 dc 34 80 00       	push   $0x8034dc
  801e2f:	6a 22                	push   $0x22
  801e31:	68 c3 34 80 00       	push   $0x8034c3
  801e36:	e8 3f e6 ff ff       	call   80047a <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3e:	89 d0                	mov    %edx,%eax
  801e40:	01 c0                	add    %eax,%eax
  801e42:	01 d0                	add    %edx,%eax
  801e44:	c1 e0 02             	shl    $0x2,%eax
  801e47:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	05 00 00 00 02       	add    $0x2000000,%eax
  801e5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e5f:	73 16                	jae    801e77 <initialize_dynamic_allocator+0x29>
  801e61:	68 00 35 80 00       	push   $0x803500
  801e66:	68 26 35 80 00       	push   $0x803526
  801e6b:	6a 34                	push   $0x34
  801e6d:	68 c3 34 80 00       	push   $0x8034c3
  801e72:	e8 03 e6 ff ff       	call   80047a <_panic>
		is_initialized = 1;
  801e77:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e7e:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8c:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e91:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801e98:	00 00 00 
  801e9b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801ea2:	00 00 00 
  801ea5:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801eac:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb2:	2b 45 08             	sub    0x8(%ebp),%eax
  801eb5:	c1 e8 0c             	shr    $0xc,%eax
  801eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec2:	e9 c8 00 00 00       	jmp    801f8f <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eca:	89 d0                	mov    %edx,%eax
  801ecc:	01 c0                	add    %eax,%eax
  801ece:	01 d0                	add    %edx,%eax
  801ed0:	c1 e0 02             	shl    $0x2,%eax
  801ed3:	05 68 40 80 00       	add    $0x804068,%eax
  801ed8:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	89 d0                	mov    %edx,%eax
  801ee2:	01 c0                	add    %eax,%eax
  801ee4:	01 d0                	add    %edx,%eax
  801ee6:	c1 e0 02             	shl    $0x2,%eax
  801ee9:	05 6a 40 80 00       	add    $0x80406a,%eax
  801eee:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801ef3:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ef9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801efc:	89 c8                	mov    %ecx,%eax
  801efe:	01 c0                	add    %eax,%eax
  801f00:	01 c8                	add    %ecx,%eax
  801f02:	c1 e0 02             	shl    $0x2,%eax
  801f05:	05 64 40 80 00       	add    $0x804064,%eax
  801f0a:	89 10                	mov    %edx,(%eax)
  801f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0f:	89 d0                	mov    %edx,%eax
  801f11:	01 c0                	add    %eax,%eax
  801f13:	01 d0                	add    %edx,%eax
  801f15:	c1 e0 02             	shl    $0x2,%eax
  801f18:	05 64 40 80 00       	add    $0x804064,%eax
  801f1d:	8b 00                	mov    (%eax),%eax
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	74 1b                	je     801f3e <initialize_dynamic_allocator+0xf0>
  801f23:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f29:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f2c:	89 c8                	mov    %ecx,%eax
  801f2e:	01 c0                	add    %eax,%eax
  801f30:	01 c8                	add    %ecx,%eax
  801f32:	c1 e0 02             	shl    $0x2,%eax
  801f35:	05 60 40 80 00       	add    $0x804060,%eax
  801f3a:	89 02                	mov    %eax,(%edx)
  801f3c:	eb 16                	jmp    801f54 <initialize_dynamic_allocator+0x106>
  801f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f41:	89 d0                	mov    %edx,%eax
  801f43:	01 c0                	add    %eax,%eax
  801f45:	01 d0                	add    %edx,%eax
  801f47:	c1 e0 02             	shl    $0x2,%eax
  801f4a:	05 60 40 80 00       	add    $0x804060,%eax
  801f4f:	a3 48 40 80 00       	mov    %eax,0x804048
  801f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f57:	89 d0                	mov    %edx,%eax
  801f59:	01 c0                	add    %eax,%eax
  801f5b:	01 d0                	add    %edx,%eax
  801f5d:	c1 e0 02             	shl    $0x2,%eax
  801f60:	05 60 40 80 00       	add    $0x804060,%eax
  801f65:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6d:	89 d0                	mov    %edx,%eax
  801f6f:	01 c0                	add    %eax,%eax
  801f71:	01 d0                	add    %edx,%eax
  801f73:	c1 e0 02             	shl    $0x2,%eax
  801f76:	05 60 40 80 00       	add    $0x804060,%eax
  801f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f81:	a1 54 40 80 00       	mov    0x804054,%eax
  801f86:	40                   	inc    %eax
  801f87:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f8c:	ff 45 f4             	incl   -0xc(%ebp)
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f95:	0f 8c 2c ff ff ff    	jl     801ec7 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f9b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fa2:	eb 36                	jmp    801fda <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	c1 e0 04             	shl    $0x4,%eax
  801faa:	05 80 c0 81 00       	add    $0x81c080,%eax
  801faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb8:	c1 e0 04             	shl    $0x4,%eax
  801fbb:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	c1 e0 04             	shl    $0x4,%eax
  801fcc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fd7:	ff 45 f0             	incl   -0x10(%ebp)
  801fda:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801fde:	7e c4                	jle    801fa4 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801fe0:	90                   	nop
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	50                   	push   %eax
  801ff0:	e8 0b fe ff ff       	call   801e00 <to_page_info>
  801ff5:	83 c4 10             	add    $0x10,%esp
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 40 08             	mov    0x8(%eax),%eax
  802001:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	ff 75 0c             	pushl  0xc(%ebp)
  802012:	e8 77 fd ff ff       	call   801d8e <to_page_va>
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80201d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802022:	ba 00 00 00 00       	mov    $0x0,%edx
  802027:	f7 75 08             	divl   0x8(%ebp)
  80202a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80202d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	50                   	push   %eax
  802034:	e8 48 f6 ff ff       	call   801681 <get_page>
  802039:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80203c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802057:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80205e:	eb 19                	jmp    802079 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	ba 01 00 00 00       	mov    $0x1,%edx
  802068:	88 c1                	mov    %al,%cl
  80206a:	d3 e2                	shl    %cl,%edx
  80206c:	89 d0                	mov    %edx,%eax
  80206e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802071:	74 0e                	je     802081 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802073:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802076:	ff 45 f0             	incl   -0x10(%ebp)
  802079:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80207d:	7e e1                	jle    802060 <split_page_to_blocks+0x5a>
  80207f:	eb 01                	jmp    802082 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802081:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802082:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802089:	e9 a7 00 00 00       	jmp    802135 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80208e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802091:	0f af 45 08          	imul   0x8(%ebp),%eax
  802095:	89 c2                	mov    %eax,%edx
  802097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80209a:	01 d0                	add    %edx,%eax
  80209c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80209f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020a3:	75 14                	jne    8020b9 <split_page_to_blocks+0xb3>
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 3c 35 80 00       	push   $0x80353c
  8020ad:	6a 7c                	push   $0x7c
  8020af:	68 c3 34 80 00       	push   $0x8034c3
  8020b4:	e8 c1 e3 ff ff       	call   80047a <_panic>
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	c1 e0 04             	shl    $0x4,%eax
  8020bf:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020c4:	8b 10                	mov    (%eax),%edx
  8020c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c9:	89 50 04             	mov    %edx,0x4(%eax)
  8020cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cf:	8b 40 04             	mov    0x4(%eax),%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 14                	je     8020ea <split_page_to_blocks+0xe4>
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	c1 e0 04             	shl    $0x4,%eax
  8020dc:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e6:	89 10                	mov    %edx,(%eax)
  8020e8:	eb 11                	jmp    8020fb <split_page_to_blocks+0xf5>
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	c1 e0 04             	shl    $0x4,%eax
  8020f0:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8020f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f9:	89 02                	mov    %eax,(%edx)
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c1 e0 04             	shl    $0x4,%eax
  802101:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802107:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210a:	89 02                	mov    %eax,(%edx)
  80210c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	c1 e0 04             	shl    $0x4,%eax
  80211b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802120:	8b 00                	mov    (%eax),%eax
  802122:	8d 50 01             	lea    0x1(%eax),%edx
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	c1 e0 04             	shl    $0x4,%eax
  80212b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802130:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802132:	ff 45 ec             	incl   -0x14(%ebp)
  802135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802138:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80213b:	0f 82 4d ff ff ff    	jb     80208e <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802141:	90                   	nop
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80214a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802151:	76 19                	jbe    80216c <alloc_block+0x28>
  802153:	68 60 35 80 00       	push   $0x803560
  802158:	68 26 35 80 00       	push   $0x803526
  80215d:	68 8a 00 00 00       	push   $0x8a
  802162:	68 c3 34 80 00       	push   $0x8034c3
  802167:	e8 0e e3 ff ff       	call   80047a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80216c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802173:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80217a:	eb 19                	jmp    802195 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	ba 01 00 00 00       	mov    $0x1,%edx
  802184:	88 c1                	mov    %al,%cl
  802186:	d3 e2                	shl    %cl,%edx
  802188:	89 d0                	mov    %edx,%eax
  80218a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80218d:	73 0e                	jae    80219d <alloc_block+0x59>
		idx++;
  80218f:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802192:	ff 45 f0             	incl   -0x10(%ebp)
  802195:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802199:	7e e1                	jle    80217c <alloc_block+0x38>
  80219b:	eb 01                	jmp    80219e <alloc_block+0x5a>
		if((1 << i) >= size) break;
  80219d:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	c1 e0 04             	shl    $0x4,%eax
  8021a4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	0f 84 df 00 00 00    	je     802292 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	c1 e0 04             	shl    $0x4,%eax
  8021b9:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021be:	8b 00                	mov    (%eax),%eax
  8021c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c7:	75 17                	jne    8021e0 <alloc_block+0x9c>
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 81 35 80 00       	push   $0x803581
  8021d1:	68 9e 00 00 00       	push   $0x9e
  8021d6:	68 c3 34 80 00       	push   $0x8034c3
  8021db:	e8 9a e2 ff ff       	call   80047a <_panic>
  8021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	74 10                	je     8021f9 <alloc_block+0xb5>
  8021e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f1:	8b 52 04             	mov    0x4(%edx),%edx
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	eb 14                	jmp    80220d <alloc_block+0xc9>
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802202:	c1 e2 04             	shl    $0x4,%edx
  802205:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80220b:	89 02                	mov    %eax,(%edx)
  80220d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802210:	8b 40 04             	mov    0x4(%eax),%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	74 0f                	je     802226 <alloc_block+0xe2>
  802217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221a:	8b 40 04             	mov    0x4(%eax),%eax
  80221d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802220:	8b 12                	mov    (%edx),%edx
  802222:	89 10                	mov    %edx,(%eax)
  802224:	eb 13                	jmp    802239 <alloc_block+0xf5>
  802226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	c1 e2 04             	shl    $0x4,%edx
  802231:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802237:	89 02                	mov    %eax,(%edx)
  802239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	c1 e0 04             	shl    $0x4,%eax
  802252:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	8d 50 ff             	lea    -0x1(%eax),%edx
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	c1 e0 04             	shl    $0x4,%eax
  802262:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802267:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226c:	83 ec 0c             	sub    $0xc,%esp
  80226f:	50                   	push   %eax
  802270:	e8 8b fb ff ff       	call   801e00 <to_page_info>
  802275:	83 c4 10             	add    $0x10,%esp
  802278:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80227b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802282:	48                   	dec    %eax
  802283:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802286:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80228a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228d:	e9 bc 02 00 00       	jmp    80254e <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802292:	a1 54 40 80 00       	mov    0x804054,%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	0f 84 7d 02 00 00    	je     80251c <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80229f:	a1 48 40 80 00       	mov    0x804048,%eax
  8022a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022ab:	75 17                	jne    8022c4 <alloc_block+0x180>
  8022ad:	83 ec 04             	sub    $0x4,%esp
  8022b0:	68 81 35 80 00       	push   $0x803581
  8022b5:	68 a9 00 00 00       	push   $0xa9
  8022ba:	68 c3 34 80 00       	push   $0x8034c3
  8022bf:	e8 b6 e1 ff ff       	call   80047a <_panic>
  8022c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 10                	je     8022dd <alloc_block+0x199>
  8022cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d0:	8b 00                	mov    (%eax),%eax
  8022d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022d5:	8b 52 04             	mov    0x4(%edx),%edx
  8022d8:	89 50 04             	mov    %edx,0x4(%eax)
  8022db:	eb 0b                	jmp    8022e8 <alloc_block+0x1a4>
  8022dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e0:	8b 40 04             	mov    0x4(%eax),%eax
  8022e3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022eb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 0f                	je     802301 <alloc_block+0x1bd>
  8022f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f5:	8b 40 04             	mov    0x4(%eax),%eax
  8022f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022fb:	8b 12                	mov    (%edx),%edx
  8022fd:	89 10                	mov    %edx,(%eax)
  8022ff:	eb 0a                	jmp    80230b <alloc_block+0x1c7>
  802301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	a3 48 40 80 00       	mov    %eax,0x804048
  80230b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231e:	a1 54 40 80 00       	mov    0x804054,%eax
  802323:	48                   	dec    %eax
  802324:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	83 c0 03             	add    $0x3,%eax
  80232f:	ba 01 00 00 00       	mov    $0x1,%edx
  802334:	88 c1                	mov    %al,%cl
  802336:	d3 e2                	shl    %cl,%edx
  802338:	89 d0                	mov    %edx,%eax
  80233a:	83 ec 08             	sub    $0x8,%esp
  80233d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802340:	50                   	push   %eax
  802341:	e8 c0 fc ff ff       	call   802006 <split_page_to_blocks>
  802346:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	c1 e0 04             	shl    $0x4,%eax
  80234f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802359:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80235d:	75 17                	jne    802376 <alloc_block+0x232>
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	68 81 35 80 00       	push   $0x803581
  802367:	68 b0 00 00 00       	push   $0xb0
  80236c:	68 c3 34 80 00       	push   $0x8034c3
  802371:	e8 04 e1 ff ff       	call   80047a <_panic>
  802376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	74 10                	je     80238f <alloc_block+0x24b>
  80237f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802387:	8b 52 04             	mov    0x4(%edx),%edx
  80238a:	89 50 04             	mov    %edx,0x4(%eax)
  80238d:	eb 14                	jmp    8023a3 <alloc_block+0x25f>
  80238f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802392:	8b 40 04             	mov    0x4(%eax),%eax
  802395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802398:	c1 e2 04             	shl    $0x4,%edx
  80239b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023a1:	89 02                	mov    %eax,(%edx)
  8023a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a6:	8b 40 04             	mov    0x4(%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 0f                	je     8023bc <alloc_block+0x278>
  8023ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b0:	8b 40 04             	mov    0x4(%eax),%eax
  8023b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b6:	8b 12                	mov    (%edx),%edx
  8023b8:	89 10                	mov    %edx,(%eax)
  8023ba:	eb 13                	jmp    8023cf <alloc_block+0x28b>
  8023bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	c1 e2 04             	shl    $0x4,%edx
  8023c7:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023cd:	89 02                	mov    %eax,(%edx)
  8023cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	c1 e0 04             	shl    $0x4,%eax
  8023e8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	c1 e0 04             	shl    $0x4,%eax
  8023f8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023fd:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	50                   	push   %eax
  802406:	e8 f5 f9 ff ff       	call   801e00 <to_page_info>
  80240b:	83 c4 10             	add    $0x10,%esp
  80240e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802411:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802414:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802418:	48                   	dec    %eax
  802419:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80241c:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802423:	e9 26 01 00 00       	jmp    80254e <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802428:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	c1 e0 04             	shl    $0x4,%eax
  802431:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	0f 84 dc 00 00 00    	je     80251c <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	c1 e0 04             	shl    $0x4,%eax
  802446:	05 80 c0 81 00       	add    $0x81c080,%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802450:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802454:	75 17                	jne    80246d <alloc_block+0x329>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 81 35 80 00       	push   $0x803581
  80245e:	68 be 00 00 00       	push   $0xbe
  802463:	68 c3 34 80 00       	push   $0x8034c3
  802468:	e8 0d e0 ff ff       	call   80047a <_panic>
  80246d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 10                	je     802486 <alloc_block+0x342>
  802476:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80247e:	8b 52 04             	mov    0x4(%edx),%edx
  802481:	89 50 04             	mov    %edx,0x4(%eax)
  802484:	eb 14                	jmp    80249a <alloc_block+0x356>
  802486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248f:	c1 e2 04             	shl    $0x4,%edx
  802492:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802498:	89 02                	mov    %eax,(%edx)
  80249a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	74 0f                	je     8024b3 <alloc_block+0x36f>
  8024a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a7:	8b 40 04             	mov    0x4(%eax),%eax
  8024aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024ad:	8b 12                	mov    (%edx),%edx
  8024af:	89 10                	mov    %edx,(%eax)
  8024b1:	eb 13                	jmp    8024c6 <alloc_block+0x382>
  8024b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bb:	c1 e2 04             	shl    $0x4,%edx
  8024be:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024c4:	89 02                	mov    %eax,(%edx)
  8024c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	c1 e0 04             	shl    $0x4,%eax
  8024df:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	c1 e0 04             	shl    $0x4,%eax
  8024ef:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024f4:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8024f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f9:	83 ec 0c             	sub    $0xc,%esp
  8024fc:	50                   	push   %eax
  8024fd:	e8 fe f8 ff ff       	call   801e00 <to_page_info>
  802502:	83 c4 10             	add    $0x10,%esp
  802505:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80250b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80250f:	48                   	dec    %eax
  802510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802513:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802517:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251a:	eb 32                	jmp    80254e <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80251c:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802520:	77 15                	ja     802537 <alloc_block+0x3f3>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	c1 e0 04             	shl    $0x4,%eax
  802528:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	0f 84 f1 fe ff ff    	je     802428 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 9f 35 80 00       	push   $0x80359f
  80253f:	68 c8 00 00 00       	push   $0xc8
  802544:	68 c3 34 80 00       	push   $0x8034c3
  802549:	e8 2c df ff ff       	call   80047a <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802556:	8b 55 08             	mov    0x8(%ebp),%edx
  802559:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80255e:	39 c2                	cmp    %eax,%edx
  802560:	72 0c                	jb     80256e <free_block+0x1e>
  802562:	8b 55 08             	mov    0x8(%ebp),%edx
  802565:	a1 40 40 80 00       	mov    0x804040,%eax
  80256a:	39 c2                	cmp    %eax,%edx
  80256c:	72 19                	jb     802587 <free_block+0x37>
  80256e:	68 b0 35 80 00       	push   $0x8035b0
  802573:	68 26 35 80 00       	push   $0x803526
  802578:	68 d7 00 00 00       	push   $0xd7
  80257d:	68 c3 34 80 00       	push   $0x8034c3
  802582:	e8 f3 de ff ff       	call   80047a <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  80258d:	8b 45 08             	mov    0x8(%ebp),%eax
  802590:	83 ec 0c             	sub    $0xc,%esp
  802593:	50                   	push   %eax
  802594:	e8 67 f8 ff ff       	call   801e00 <to_page_info>
  802599:	83 c4 10             	add    $0x10,%esp
  80259c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80259f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a2:	8b 40 08             	mov    0x8(%eax),%eax
  8025a5:	0f b7 c0             	movzwl %ax,%eax
  8025a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025b2:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025b9:	eb 19                	jmp    8025d4 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025be:	ba 01 00 00 00       	mov    $0x1,%edx
  8025c3:	88 c1                	mov    %al,%cl
  8025c5:	d3 e2                	shl    %cl,%edx
  8025c7:	89 d0                	mov    %edx,%eax
  8025c9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025cc:	74 0e                	je     8025dc <free_block+0x8c>
	        break;
	    idx++;
  8025ce:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025d1:	ff 45 f0             	incl   -0x10(%ebp)
  8025d4:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025d8:	7e e1                	jle    8025bb <free_block+0x6b>
  8025da:	eb 01                	jmp    8025dd <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025dc:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025e4:	40                   	inc    %eax
  8025e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e8:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8025ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025f0:	75 17                	jne    802609 <free_block+0xb9>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 3c 35 80 00       	push   $0x80353c
  8025fa:	68 ee 00 00 00       	push   $0xee
  8025ff:	68 c3 34 80 00       	push   $0x8034c3
  802604:	e8 71 de ff ff       	call   80047a <_panic>
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	c1 e0 04             	shl    $0x4,%eax
  80260f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802614:	8b 10                	mov    (%eax),%edx
  802616:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802619:	89 50 04             	mov    %edx,0x4(%eax)
  80261c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	74 14                	je     80263a <free_block+0xea>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c1 e0 04             	shl    $0x4,%eax
  80262c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802636:	89 10                	mov    %edx,(%eax)
  802638:	eb 11                	jmp    80264b <free_block+0xfb>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	c1 e0 04             	shl    $0x4,%eax
  802640:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802649:	89 02                	mov    %eax,(%edx)
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	c1 e0 04             	shl    $0x4,%eax
  802651:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265a:	89 02                	mov    %eax,(%edx)
  80265c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	c1 e0 04             	shl    $0x4,%eax
  80266b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	8d 50 01             	lea    0x1(%eax),%edx
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	c1 e0 04             	shl    $0x4,%eax
  80267b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802680:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802682:	b8 00 10 00 00       	mov    $0x1000,%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 e0             	divl   -0x20(%ebp)
  80268f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802695:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802699:	0f b7 c0             	movzwl %ax,%eax
  80269c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80269f:	0f 85 70 01 00 00    	jne    802815 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026ab:	e8 de f6 ff ff       	call   801d8e <to_page_va>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026bd:	e9 b7 00 00 00       	jmp    802779 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026d1:	75 17                	jne    8026ea <free_block+0x19a>
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	68 81 35 80 00       	push   $0x803581
  8026db:	68 f8 00 00 00       	push   $0xf8
  8026e0:	68 c3 34 80 00       	push   $0x8034c3
  8026e5:	e8 90 dd ff ff       	call   80047a <_panic>
  8026ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	74 10                	je     802703 <free_block+0x1b3>
  8026f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026fb:	8b 52 04             	mov    0x4(%edx),%edx
  8026fe:	89 50 04             	mov    %edx,0x4(%eax)
  802701:	eb 14                	jmp    802717 <free_block+0x1c7>
  802703:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	c1 e2 04             	shl    $0x4,%edx
  80270f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802715:	89 02                	mov    %eax,(%edx)
  802717:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	74 0f                	je     802730 <free_block+0x1e0>
  802721:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80272a:	8b 12                	mov    (%edx),%edx
  80272c:	89 10                	mov    %edx,(%eax)
  80272e:	eb 13                	jmp    802743 <free_block+0x1f3>
  802730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802738:	c1 e2 04             	shl    $0x4,%edx
  80273b:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802741:	89 02                	mov    %eax,(%edx)
  802743:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802746:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	c1 e0 04             	shl    $0x4,%eax
  80275c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	8d 50 ff             	lea    -0x1(%eax),%edx
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	c1 e0 04             	shl    $0x4,%eax
  80276c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802771:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802776:	01 45 ec             	add    %eax,-0x14(%ebp)
  802779:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802780:	0f 86 3c ff ff ff    	jbe    8026c2 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80278f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802792:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80279c:	75 17                	jne    8027b5 <free_block+0x265>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 3c 35 80 00       	push   $0x80353c
  8027a6:	68 fe 00 00 00       	push   $0xfe
  8027ab:	68 c3 34 80 00       	push   $0x8034c3
  8027b0:	e8 c5 dc ff ff       	call   80047a <_panic>
  8027b5:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027be:	89 50 04             	mov    %edx,0x4(%eax)
  8027c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0c                	je     8027d7 <free_block+0x287>
  8027cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d3:	89 10                	mov    %edx,(%eax)
  8027d5:	eb 08                	jmp    8027df <free_block+0x28f>
  8027d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027da:	a3 48 40 80 00       	mov    %eax,0x804048
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f0:	a1 54 40 80 00       	mov    0x804054,%eax
  8027f5:	40                   	inc    %eax
  8027f6:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  802801:	e8 88 f5 ff ff       	call   801d8e <to_page_va>
  802806:	83 c4 10             	add    $0x10,%esp
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	50                   	push   %eax
  80280d:	e8 b8 ee ff ff       	call   8016ca <return_page>
  802812:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802815:	90                   	nop
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	68 e8 35 80 00       	push   $0x8035e8
  802826:	68 11 01 00 00       	push   $0x111
  80282b:	68 c3 34 80 00       	push   $0x8034c3
  802830:	e8 45 dc ff ff       	call   80047a <_panic>
  802835:	66 90                	xchg   %ax,%ax
  802837:	90                   	nop

00802838 <__udivdi3>:
  802838:	55                   	push   %ebp
  802839:	57                   	push   %edi
  80283a:	56                   	push   %esi
  80283b:	53                   	push   %ebx
  80283c:	83 ec 1c             	sub    $0x1c,%esp
  80283f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802843:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80284b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80284f:	89 ca                	mov    %ecx,%edx
  802851:	89 f8                	mov    %edi,%eax
  802853:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802857:	85 f6                	test   %esi,%esi
  802859:	75 2d                	jne    802888 <__udivdi3+0x50>
  80285b:	39 cf                	cmp    %ecx,%edi
  80285d:	77 65                	ja     8028c4 <__udivdi3+0x8c>
  80285f:	89 fd                	mov    %edi,%ebp
  802861:	85 ff                	test   %edi,%edi
  802863:	75 0b                	jne    802870 <__udivdi3+0x38>
  802865:	b8 01 00 00 00       	mov    $0x1,%eax
  80286a:	31 d2                	xor    %edx,%edx
  80286c:	f7 f7                	div    %edi
  80286e:	89 c5                	mov    %eax,%ebp
  802870:	31 d2                	xor    %edx,%edx
  802872:	89 c8                	mov    %ecx,%eax
  802874:	f7 f5                	div    %ebp
  802876:	89 c1                	mov    %eax,%ecx
  802878:	89 d8                	mov    %ebx,%eax
  80287a:	f7 f5                	div    %ebp
  80287c:	89 cf                	mov    %ecx,%edi
  80287e:	89 fa                	mov    %edi,%edx
  802880:	83 c4 1c             	add    $0x1c,%esp
  802883:	5b                   	pop    %ebx
  802884:	5e                   	pop    %esi
  802885:	5f                   	pop    %edi
  802886:	5d                   	pop    %ebp
  802887:	c3                   	ret    
  802888:	39 ce                	cmp    %ecx,%esi
  80288a:	77 28                	ja     8028b4 <__udivdi3+0x7c>
  80288c:	0f bd fe             	bsr    %esi,%edi
  80288f:	83 f7 1f             	xor    $0x1f,%edi
  802892:	75 40                	jne    8028d4 <__udivdi3+0x9c>
  802894:	39 ce                	cmp    %ecx,%esi
  802896:	72 0a                	jb     8028a2 <__udivdi3+0x6a>
  802898:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80289c:	0f 87 9e 00 00 00    	ja     802940 <__udivdi3+0x108>
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a7:	89 fa                	mov    %edi,%edx
  8028a9:	83 c4 1c             	add    $0x1c,%esp
  8028ac:	5b                   	pop    %ebx
  8028ad:	5e                   	pop    %esi
  8028ae:	5f                   	pop    %edi
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    
  8028b1:	8d 76 00             	lea    0x0(%esi),%esi
  8028b4:	31 ff                	xor    %edi,%edi
  8028b6:	31 c0                	xor    %eax,%eax
  8028b8:	89 fa                	mov    %edi,%edx
  8028ba:	83 c4 1c             	add    $0x1c,%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	5f                   	pop    %edi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    
  8028c2:	66 90                	xchg   %ax,%ax
  8028c4:	89 d8                	mov    %ebx,%eax
  8028c6:	f7 f7                	div    %edi
  8028c8:	31 ff                	xor    %edi,%edi
  8028ca:	89 fa                	mov    %edi,%edx
  8028cc:	83 c4 1c             	add    $0x1c,%esp
  8028cf:	5b                   	pop    %ebx
  8028d0:	5e                   	pop    %esi
  8028d1:	5f                   	pop    %edi
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
  8028d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028d9:	89 eb                	mov    %ebp,%ebx
  8028db:	29 fb                	sub    %edi,%ebx
  8028dd:	89 f9                	mov    %edi,%ecx
  8028df:	d3 e6                	shl    %cl,%esi
  8028e1:	89 c5                	mov    %eax,%ebp
  8028e3:	88 d9                	mov    %bl,%cl
  8028e5:	d3 ed                	shr    %cl,%ebp
  8028e7:	89 e9                	mov    %ebp,%ecx
  8028e9:	09 f1                	or     %esi,%ecx
  8028eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028ef:	89 f9                	mov    %edi,%ecx
  8028f1:	d3 e0                	shl    %cl,%eax
  8028f3:	89 c5                	mov    %eax,%ebp
  8028f5:	89 d6                	mov    %edx,%esi
  8028f7:	88 d9                	mov    %bl,%cl
  8028f9:	d3 ee                	shr    %cl,%esi
  8028fb:	89 f9                	mov    %edi,%ecx
  8028fd:	d3 e2                	shl    %cl,%edx
  8028ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  802903:	88 d9                	mov    %bl,%cl
  802905:	d3 e8                	shr    %cl,%eax
  802907:	09 c2                	or     %eax,%edx
  802909:	89 d0                	mov    %edx,%eax
  80290b:	89 f2                	mov    %esi,%edx
  80290d:	f7 74 24 0c          	divl   0xc(%esp)
  802911:	89 d6                	mov    %edx,%esi
  802913:	89 c3                	mov    %eax,%ebx
  802915:	f7 e5                	mul    %ebp
  802917:	39 d6                	cmp    %edx,%esi
  802919:	72 19                	jb     802934 <__udivdi3+0xfc>
  80291b:	74 0b                	je     802928 <__udivdi3+0xf0>
  80291d:	89 d8                	mov    %ebx,%eax
  80291f:	31 ff                	xor    %edi,%edi
  802921:	e9 58 ff ff ff       	jmp    80287e <__udivdi3+0x46>
  802926:	66 90                	xchg   %ax,%ax
  802928:	8b 54 24 08          	mov    0x8(%esp),%edx
  80292c:	89 f9                	mov    %edi,%ecx
  80292e:	d3 e2                	shl    %cl,%edx
  802930:	39 c2                	cmp    %eax,%edx
  802932:	73 e9                	jae    80291d <__udivdi3+0xe5>
  802934:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802937:	31 ff                	xor    %edi,%edi
  802939:	e9 40 ff ff ff       	jmp    80287e <__udivdi3+0x46>
  80293e:	66 90                	xchg   %ax,%ax
  802940:	31 c0                	xor    %eax,%eax
  802942:	e9 37 ff ff ff       	jmp    80287e <__udivdi3+0x46>
  802947:	90                   	nop

00802948 <__umoddi3>:
  802948:	55                   	push   %ebp
  802949:	57                   	push   %edi
  80294a:	56                   	push   %esi
  80294b:	53                   	push   %ebx
  80294c:	83 ec 1c             	sub    $0x1c,%esp
  80294f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802953:	8b 74 24 34          	mov    0x34(%esp),%esi
  802957:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80295b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80295f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802963:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802967:	89 f3                	mov    %esi,%ebx
  802969:	89 fa                	mov    %edi,%edx
  80296b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80296f:	89 34 24             	mov    %esi,(%esp)
  802972:	85 c0                	test   %eax,%eax
  802974:	75 1a                	jne    802990 <__umoddi3+0x48>
  802976:	39 f7                	cmp    %esi,%edi
  802978:	0f 86 a2 00 00 00    	jbe    802a20 <__umoddi3+0xd8>
  80297e:	89 c8                	mov    %ecx,%eax
  802980:	89 f2                	mov    %esi,%edx
  802982:	f7 f7                	div    %edi
  802984:	89 d0                	mov    %edx,%eax
  802986:	31 d2                	xor    %edx,%edx
  802988:	83 c4 1c             	add    $0x1c,%esp
  80298b:	5b                   	pop    %ebx
  80298c:	5e                   	pop    %esi
  80298d:	5f                   	pop    %edi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    
  802990:	39 f0                	cmp    %esi,%eax
  802992:	0f 87 ac 00 00 00    	ja     802a44 <__umoddi3+0xfc>
  802998:	0f bd e8             	bsr    %eax,%ebp
  80299b:	83 f5 1f             	xor    $0x1f,%ebp
  80299e:	0f 84 ac 00 00 00    	je     802a50 <__umoddi3+0x108>
  8029a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8029a9:	29 ef                	sub    %ebp,%edi
  8029ab:	89 fe                	mov    %edi,%esi
  8029ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029b1:	89 e9                	mov    %ebp,%ecx
  8029b3:	d3 e0                	shl    %cl,%eax
  8029b5:	89 d7                	mov    %edx,%edi
  8029b7:	89 f1                	mov    %esi,%ecx
  8029b9:	d3 ef                	shr    %cl,%edi
  8029bb:	09 c7                	or     %eax,%edi
  8029bd:	89 e9                	mov    %ebp,%ecx
  8029bf:	d3 e2                	shl    %cl,%edx
  8029c1:	89 14 24             	mov    %edx,(%esp)
  8029c4:	89 d8                	mov    %ebx,%eax
  8029c6:	d3 e0                	shl    %cl,%eax
  8029c8:	89 c2                	mov    %eax,%edx
  8029ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029ce:	d3 e0                	shl    %cl,%eax
  8029d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029d8:	89 f1                	mov    %esi,%ecx
  8029da:	d3 e8                	shr    %cl,%eax
  8029dc:	09 d0                	or     %edx,%eax
  8029de:	d3 eb                	shr    %cl,%ebx
  8029e0:	89 da                	mov    %ebx,%edx
  8029e2:	f7 f7                	div    %edi
  8029e4:	89 d3                	mov    %edx,%ebx
  8029e6:	f7 24 24             	mull   (%esp)
  8029e9:	89 c6                	mov    %eax,%esi
  8029eb:	89 d1                	mov    %edx,%ecx
  8029ed:	39 d3                	cmp    %edx,%ebx
  8029ef:	0f 82 87 00 00 00    	jb     802a7c <__umoddi3+0x134>
  8029f5:	0f 84 91 00 00 00    	je     802a8c <__umoddi3+0x144>
  8029fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029ff:	29 f2                	sub    %esi,%edx
  802a01:	19 cb                	sbb    %ecx,%ebx
  802a03:	89 d8                	mov    %ebx,%eax
  802a05:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a09:	d3 e0                	shl    %cl,%eax
  802a0b:	89 e9                	mov    %ebp,%ecx
  802a0d:	d3 ea                	shr    %cl,%edx
  802a0f:	09 d0                	or     %edx,%eax
  802a11:	89 e9                	mov    %ebp,%ecx
  802a13:	d3 eb                	shr    %cl,%ebx
  802a15:	89 da                	mov    %ebx,%edx
  802a17:	83 c4 1c             	add    $0x1c,%esp
  802a1a:	5b                   	pop    %ebx
  802a1b:	5e                   	pop    %esi
  802a1c:	5f                   	pop    %edi
  802a1d:	5d                   	pop    %ebp
  802a1e:	c3                   	ret    
  802a1f:	90                   	nop
  802a20:	89 fd                	mov    %edi,%ebp
  802a22:	85 ff                	test   %edi,%edi
  802a24:	75 0b                	jne    802a31 <__umoddi3+0xe9>
  802a26:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	f7 f7                	div    %edi
  802a2f:	89 c5                	mov    %eax,%ebp
  802a31:	89 f0                	mov    %esi,%eax
  802a33:	31 d2                	xor    %edx,%edx
  802a35:	f7 f5                	div    %ebp
  802a37:	89 c8                	mov    %ecx,%eax
  802a39:	f7 f5                	div    %ebp
  802a3b:	89 d0                	mov    %edx,%eax
  802a3d:	e9 44 ff ff ff       	jmp    802986 <__umoddi3+0x3e>
  802a42:	66 90                	xchg   %ax,%ax
  802a44:	89 c8                	mov    %ecx,%eax
  802a46:	89 f2                	mov    %esi,%edx
  802a48:	83 c4 1c             	add    $0x1c,%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	3b 04 24             	cmp    (%esp),%eax
  802a53:	72 06                	jb     802a5b <__umoddi3+0x113>
  802a55:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a59:	77 0f                	ja     802a6a <__umoddi3+0x122>
  802a5b:	89 f2                	mov    %esi,%edx
  802a5d:	29 f9                	sub    %edi,%ecx
  802a5f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a63:	89 14 24             	mov    %edx,(%esp)
  802a66:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a6a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a6e:	8b 14 24             	mov    (%esp),%edx
  802a71:	83 c4 1c             	add    $0x1c,%esp
  802a74:	5b                   	pop    %ebx
  802a75:	5e                   	pop    %esi
  802a76:	5f                   	pop    %edi
  802a77:	5d                   	pop    %ebp
  802a78:	c3                   	ret    
  802a79:	8d 76 00             	lea    0x0(%esi),%esi
  802a7c:	2b 04 24             	sub    (%esp),%eax
  802a7f:	19 fa                	sbb    %edi,%edx
  802a81:	89 d1                	mov    %edx,%ecx
  802a83:	89 c6                	mov    %eax,%esi
  802a85:	e9 71 ff ff ff       	jmp    8029fb <__umoddi3+0xb3>
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a90:	72 ea                	jb     802a7c <__umoddi3+0x134>
  802a92:	89 d9                	mov    %ebx,%ecx
  802a94:	e9 62 ff ff ff       	jmp    8029fb <__umoddi3+0xb3>
