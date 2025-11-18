
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 58 02 00 00       	call   80028e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)

	uint32 *x,*y,*z, *expectedVA;
	int freeFrames, diff, expected;
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 73 1a 00 00       	call   801abe <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	//sys_lock_cons();
	sys_lock_cons();
  80004e:	e8 d9 17 00 00       	call   80182c <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  800053:	e8 84 18 00 00       	call   8018dc <sys_calculate_free_frames>
  800058:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = sget(parentenvID,"z");
  80005b:	83 ec 08             	sub    $0x8,%esp
  80005e:	68 80 2a 80 00       	push   $0x802a80
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	e8 f4 16 00 00       	call   80175f <sget>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 0 * PAGE_SIZE);
  800071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800074:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (z != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, z);
  800077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80007a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80007d:	74 1a                	je     800099 <_main+0x61>
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	ff 75 e8             	pushl  -0x18(%ebp)
  800085:	ff 75 e4             	pushl  -0x1c(%ebp)
  800088:	68 84 2a 80 00       	push   $0x802a84
  80008d:	6a 20                	push   $0x20
  80008f:	68 ff 2a 80 00       	push   $0x802aff
  800094:	e8 ba 03 00 00       	call   800453 <_panic>
		expected = 1 ; /*1table*/
  800099:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8000a0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000a3:	e8 34 18 00 00       	call   8018dc <sys_calculate_free_frames>
  8000a8:	29 c3                	sub    %eax,%ebx
  8000aa:	89 d8                	mov    %ebx,%eax
  8000ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8000af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000b2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000b5:	74 24                	je     8000db <_main+0xa3>
  8000b7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ba:	e8 1d 18 00 00       	call   8018dc <sys_calculate_free_frames>
  8000bf:	29 c3                	sub    %eax,%ebx
  8000c1:	89 d8                	mov    %ebx,%eax
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000c9:	50                   	push   %eax
  8000ca:	68 20 2b 80 00       	push   $0x802b20
  8000cf:	6a 23                	push   $0x23
  8000d1:	68 ff 2a 80 00       	push   $0x802aff
  8000d6:	e8 78 03 00 00       	call   800453 <_panic>
	}
	sys_unlock_cons();
  8000db:	e8 66 17 00 00       	call   801846 <sys_unlock_cons>
	//sys_unlock_cons();

	sys_lock_cons();
  8000e0:	e8 47 17 00 00       	call   80182c <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  8000e5:	e8 f2 17 00 00       	call   8018dc <sys_calculate_free_frames>
  8000ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = sget(parentenvID,"y");
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 b8 2b 80 00       	push   $0x802bb8
  8000f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8000f8:	e8 62 16 00 00       	call   80175f <sget>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 d8             	mov    %eax,-0x28(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 1 * PAGE_SIZE);
  800103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800106:	05 00 10 00 00       	add    $0x1000,%eax
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (y != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, y);
  80010e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800111:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800114:	74 1a                	je     800130 <_main+0xf8>
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	ff 75 d8             	pushl  -0x28(%ebp)
  80011c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80011f:	68 84 2a 80 00       	push   $0x802a84
  800124:	6a 2d                	push   $0x2d
  800126:	68 ff 2a 80 00       	push   $0x802aff
  80012b:	e8 23 03 00 00       	call   800453 <_panic>
		expected = 0 ;
  800130:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  800137:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80013a:	e8 9d 17 00 00       	call   8018dc <sys_calculate_free_frames>
  80013f:	29 c3                	sub    %eax,%ebx
  800141:	89 d8                	mov    %ebx,%eax
  800143:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800149:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80014c:	74 24                	je     800172 <_main+0x13a>
  80014e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800151:	e8 86 17 00 00       	call   8018dc <sys_calculate_free_frames>
  800156:	29 c3                	sub    %eax,%ebx
  800158:	89 d8                	mov    %ebx,%eax
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 e0             	pushl  -0x20(%ebp)
  800160:	50                   	push   %eax
  800161:	68 20 2b 80 00       	push   $0x802b20
  800166:	6a 30                	push   $0x30
  800168:	68 ff 2a 80 00       	push   $0x802aff
  80016d:	e8 e1 02 00 00       	call   800453 <_panic>
	}
	sys_unlock_cons();
  800172:	e8 cf 16 00 00       	call   801846 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 bc 2b 80 00       	push   $0x802bbc
  800189:	6a 35                	push   $0x35
  80018b:	68 ff 2a 80 00       	push   $0x802aff
  800190:	e8 be 02 00 00       	call   800453 <_panic>

	sys_lock_cons();
  800195:	e8 92 16 00 00       	call   80182c <sys_lock_cons>
	{
		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 3d 17 00 00       	call   8018dc <sys_calculate_free_frames>
  80019f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 f3 2b 80 00       	push   $0x802bf3
  8001aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ad:	e8 ad 15 00 00       	call   80175f <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expectedVA = (uint32*)(pagealloc_start + 2 * PAGE_SIZE);
  8001b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001bb:	05 00 20 00 00       	add    $0x2000,%eax
  8001c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != expectedVA) panic("Get(): Returned address is not correct. Expected = %x, Actual = %x\nMake sure that you align the allocation on 4KB boundary", expectedVA, x);
  8001c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001c9:	74 1a                	je     8001e5 <_main+0x1ad>
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d4:	68 84 2a 80 00       	push   $0x802a84
  8001d9:	6a 3c                	push   $0x3c
  8001db:	68 ff 2a 80 00       	push   $0x802aff
  8001e0:	e8 6e 02 00 00       	call   800453 <_panic>
		expected = 0 ;
  8001e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001ec:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ef:	e8 e8 16 00 00       	call   8018dc <sys_calculate_free_frames>
  8001f4:	29 c3                	sub    %eax,%ebx
  8001f6:	89 d8                	mov    %ebx,%eax
  8001f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (diff != expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  8001fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800201:	74 24                	je     800227 <_main+0x1ef>
  800203:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800206:	e8 d1 16 00 00       	call   8018dc <sys_calculate_free_frames>
  80020b:	29 c3                	sub    %eax,%ebx
  80020d:	89 d8                	mov    %ebx,%eax
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e0             	pushl  -0x20(%ebp)
  800215:	50                   	push   %eax
  800216:	68 20 2b 80 00       	push   $0x802b20
  80021b:	6a 3f                	push   $0x3f
  80021d:	68 ff 2a 80 00       	push   $0x802aff
  800222:	e8 2c 02 00 00       	call   800453 <_panic>
	}
	sys_unlock_cons();
  800227:	e8 1a 16 00 00       	call   801846 <sys_unlock_cons>
	//sys_unlock_cons();

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  80022c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	83 f8 0a             	cmp    $0xa,%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 bc 2b 80 00       	push   $0x802bbc
  80023e:	6a 44                	push   $0x44
  800240:	68 ff 2a 80 00       	push   $0x802aff
  800245:	e8 09 02 00 00       	call   800453 <_panic>

	sys_lock_cons();
  80024a:	e8 dd 15 00 00       	call   80182c <sys_lock_cons>
	{
		*z = *x + *y ;
  80024f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800252:	8b 10                	mov    (%eax),%edx
  800254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800257:	8b 00                	mov    (%eax),%eax
  800259:	01 c2                	add    %eax,%edx
  80025b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025e:	89 10                	mov    %edx,(%eax)
	}
	sys_unlock_cons();
  800260:	e8 e1 15 00 00       	call   801846 <sys_unlock_cons>

	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800268:	8b 00                	mov    (%eax),%eax
  80026a:	83 f8 1e             	cmp    $0x1e,%eax
  80026d:	74 14                	je     800283 <_main+0x24b>
  80026f:	83 ec 04             	sub    $0x4,%esp
  800272:	68 bc 2b 80 00       	push   $0x802bbc
  800277:	6a 4c                	push   $0x4c
  800279:	68 ff 2a 80 00       	push   $0x802aff
  80027e:	e8 d0 01 00 00       	call   800453 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800283:	e8 5b 19 00 00       	call   801be3 <inctst>

	return;
  800288:	90                   	nop
}
  800289:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	57                   	push   %edi
  800292:	56                   	push   %esi
  800293:	53                   	push   %ebx
  800294:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800297:	e8 09 18 00 00       	call   801aa5 <sys_getenvindex>
  80029c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 d0                	mov    %edx,%eax
  8002a4:	c1 e0 06             	shl    $0x6,%eax
  8002a7:	29 d0                	sub    %edx,%eax
  8002a9:	c1 e0 02             	shl    $0x2,%eax
  8002ac:	01 d0                	add    %edx,%eax
  8002ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b5:	01 c8                	add    %ecx,%eax
  8002b7:	c1 e0 03             	shl    $0x3,%eax
  8002ba:	01 d0                	add    %edx,%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	29 c2                	sub    %eax,%edx
  8002c5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002cc:	89 c2                	mov    %eax,%edx
  8002ce:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002d4:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002de:	8a 40 20             	mov    0x20(%eax),%al
  8002e1:	84 c0                	test   %al,%al
  8002e3:	74 0d                	je     8002f2 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	83 c0 20             	add    $0x20,%eax
  8002ed:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002f6:	7e 0a                	jle    800302 <libmain+0x74>
		binaryname = argv[0];
  8002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	ff 75 0c             	pushl  0xc(%ebp)
  800308:	ff 75 08             	pushl  0x8(%ebp)
  80030b:	e8 28 fd ff ff       	call   800038 <_main>
  800310:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800313:	a1 00 40 80 00       	mov    0x804000,%eax
  800318:	85 c0                	test   %eax,%eax
  80031a:	0f 84 01 01 00 00    	je     800421 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800320:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800326:	bb f0 2c 80 00       	mov    $0x802cf0,%ebx
  80032b:	ba 0e 00 00 00       	mov    $0xe,%edx
  800330:	89 c7                	mov    %eax,%edi
  800332:	89 de                	mov    %ebx,%esi
  800334:	89 d1                	mov    %edx,%ecx
  800336:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800338:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80033b:	b9 56 00 00 00       	mov    $0x56,%ecx
  800340:	b0 00                	mov    $0x0,%al
  800342:	89 d7                	mov    %edx,%edi
  800344:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800346:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80034d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800350:	83 ec 08             	sub    $0x8,%esp
  800353:	50                   	push   %eax
  800354:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80035a:	50                   	push   %eax
  80035b:	e8 7b 19 00 00       	call   801cdb <sys_utilities>
  800360:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800363:	e8 c4 14 00 00       	call   80182c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	68 10 2c 80 00       	push   $0x802c10
  800370:	e8 ac 03 00 00       	call   800721 <cprintf>
  800375:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800378:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037b:	85 c0                	test   %eax,%eax
  80037d:	74 18                	je     800397 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80037f:	e8 75 19 00 00       	call   801cf9 <sys_get_optimal_num_faults>
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	50                   	push   %eax
  800388:	68 38 2c 80 00       	push   $0x802c38
  80038d:	e8 8f 03 00 00       	call   800721 <cprintf>
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	eb 59                	jmp    8003f0 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a7:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	52                   	push   %edx
  8003b1:	50                   	push   %eax
  8003b2:	68 5c 2c 80 00       	push   $0x802c5c
  8003b7:	e8 65 03 00 00       	call   800721 <cprintf>
  8003bc:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c4:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cf:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003da:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003e0:	51                   	push   %ecx
  8003e1:	52                   	push   %edx
  8003e2:	50                   	push   %eax
  8003e3:	68 84 2c 80 00       	push   $0x802c84
  8003e8:	e8 34 03 00 00       	call   800721 <cprintf>
  8003ed:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	50                   	push   %eax
  8003ff:	68 dc 2c 80 00       	push   $0x802cdc
  800404:	e8 18 03 00 00       	call   800721 <cprintf>
  800409:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	68 10 2c 80 00       	push   $0x802c10
  800414:	e8 08 03 00 00       	call   800721 <cprintf>
  800419:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80041c:	e8 25 14 00 00       	call   801846 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800421:	e8 1f 00 00 00       	call   800445 <exit>
}
  800426:	90                   	nop
  800427:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800435:	83 ec 0c             	sub    $0xc,%esp
  800438:	6a 00                	push   $0x0
  80043a:	e8 32 16 00 00       	call   801a71 <sys_destroy_env>
  80043f:	83 c4 10             	add    $0x10,%esp
}
  800442:	90                   	nop
  800443:	c9                   	leave  
  800444:	c3                   	ret    

00800445 <exit>:

void
exit(void)
{
  800445:	55                   	push   %ebp
  800446:	89 e5                	mov    %esp,%ebp
  800448:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80044b:	e8 87 16 00 00       	call   801ad7 <sys_exit_env>
}
  800450:	90                   	nop
  800451:	c9                   	leave  
  800452:	c3                   	ret    

00800453 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800459:	8d 45 10             	lea    0x10(%ebp),%eax
  80045c:	83 c0 04             	add    $0x4,%eax
  80045f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800462:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800467:	85 c0                	test   %eax,%eax
  800469:	74 16                	je     800481 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80046b:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	50                   	push   %eax
  800474:	68 54 2d 80 00       	push   $0x802d54
  800479:	e8 a3 02 00 00       	call   800721 <cprintf>
  80047e:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800481:	a1 04 40 80 00       	mov    0x804004,%eax
  800486:	83 ec 0c             	sub    $0xc,%esp
  800489:	ff 75 0c             	pushl  0xc(%ebp)
  80048c:	ff 75 08             	pushl  0x8(%ebp)
  80048f:	50                   	push   %eax
  800490:	68 5c 2d 80 00       	push   $0x802d5c
  800495:	6a 74                	push   $0x74
  800497:	e8 b2 02 00 00       	call   80074e <cprintf_colored>
  80049c:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80049f:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a8:	50                   	push   %eax
  8004a9:	e8 04 02 00 00       	call   8006b2 <vcprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	6a 00                	push   $0x0
  8004b6:	68 84 2d 80 00       	push   $0x802d84
  8004bb:	e8 f2 01 00 00       	call   8006b2 <vcprintf>
  8004c0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004c3:	e8 7d ff ff ff       	call   800445 <exit>

	// should not return here
	while (1) ;
  8004c8:	eb fe                	jmp    8004c8 <_panic+0x75>

008004ca <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004ca:	55                   	push   %ebp
  8004cb:	89 e5                	mov    %esp,%ebp
  8004cd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d5:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004de:	39 c2                	cmp    %eax,%edx
  8004e0:	74 14                	je     8004f6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004e2:	83 ec 04             	sub    $0x4,%esp
  8004e5:	68 88 2d 80 00       	push   $0x802d88
  8004ea:	6a 26                	push   $0x26
  8004ec:	68 d4 2d 80 00       	push   $0x802dd4
  8004f1:	e8 5d ff ff ff       	call   800453 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800504:	e9 c5 00 00 00       	jmp    8005ce <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	85 c0                	test   %eax,%eax
  80051c:	75 08                	jne    800526 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80051e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800521:	e9 a5 00 00 00       	jmp    8005cb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800526:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800534:	eb 69                	jmp    80059f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800536:	a1 20 40 80 00       	mov    0x804020,%eax
  80053b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800541:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800544:	89 d0                	mov    %edx,%eax
  800546:	01 c0                	add    %eax,%eax
  800548:	01 d0                	add    %edx,%eax
  80054a:	c1 e0 03             	shl    $0x3,%eax
  80054d:	01 c8                	add    %ecx,%eax
  80054f:	8a 40 04             	mov    0x4(%eax),%al
  800552:	84 c0                	test   %al,%al
  800554:	75 46                	jne    80059c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800556:	a1 20 40 80 00       	mov    0x804020,%eax
  80055b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800561:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800574:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80057e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80058f:	39 c2                	cmp    %eax,%edx
  800591:	75 09                	jne    80059c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800593:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80059a:	eb 15                	jmp    8005b1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059c:	ff 45 e8             	incl   -0x18(%ebp)
  80059f:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ad:	39 c2                	cmp    %eax,%edx
  8005af:	77 85                	ja     800536 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005b5:	75 14                	jne    8005cb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 e0 2d 80 00       	push   $0x802de0
  8005bf:	6a 3a                	push   $0x3a
  8005c1:	68 d4 2d 80 00       	push   $0x802dd4
  8005c6:	e8 88 fe ff ff       	call   800453 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005cb:	ff 45 f0             	incl   -0x10(%ebp)
  8005ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005d4:	0f 8c 2f ff ff ff    	jl     800509 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e8:	eb 26                	jmp    800610 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ef:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005f8:	89 d0                	mov    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	c1 e0 03             	shl    $0x3,%eax
  800601:	01 c8                	add    %ecx,%eax
  800603:	8a 40 04             	mov    0x4(%eax),%al
  800606:	3c 01                	cmp    $0x1,%al
  800608:	75 03                	jne    80060d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80060a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80060d:	ff 45 e0             	incl   -0x20(%ebp)
  800610:	a1 20 40 80 00       	mov    0x804020,%eax
  800615:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80061b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061e:	39 c2                	cmp    %eax,%edx
  800620:	77 c8                	ja     8005ea <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800625:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800628:	74 14                	je     80063e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	68 34 2e 80 00       	push   $0x802e34
  800632:	6a 44                	push   $0x44
  800634:	68 d4 2d 80 00       	push   $0x802dd4
  800639:	e8 15 fe ff ff       	call   800453 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80063e:	90                   	nop
  80063f:	c9                   	leave  
  800640:	c3                   	ret    

00800641 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800641:	55                   	push   %ebp
  800642:	89 e5                	mov    %esp,%ebp
  800644:	53                   	push   %ebx
  800645:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 48 01             	lea    0x1(%eax),%ecx
  800650:	8b 55 0c             	mov    0xc(%ebp),%edx
  800653:	89 0a                	mov    %ecx,(%edx)
  800655:	8b 55 08             	mov    0x8(%ebp),%edx
  800658:	88 d1                	mov    %dl,%cl
  80065a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800661:	8b 45 0c             	mov    0xc(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066b:	75 30                	jne    80069d <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80066d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800673:	a0 44 40 80 00       	mov    0x804044,%al
  800678:	0f b6 c0             	movzbl %al,%eax
  80067b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067e:	8b 09                	mov    (%ecx),%ecx
  800680:	89 cb                	mov    %ecx,%ebx
  800682:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800685:	83 c1 08             	add    $0x8,%ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	53                   	push   %ebx
  80068b:	51                   	push   %ecx
  80068c:	e8 57 11 00 00       	call   8017e8 <sys_cputs>
  800691:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800694:	8b 45 0c             	mov    0xc(%ebp),%eax
  800697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a0:	8b 40 04             	mov    0x4(%eax),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ac:	90                   	nop
  8006ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    

008006b2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006bb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c2:	00 00 00 
	b.cnt = 0;
  8006c5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006cc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006db:	50                   	push   %eax
  8006dc:	68 41 06 80 00       	push   $0x800641
  8006e1:	e8 5a 02 00 00       	call   800940 <vprintfmt>
  8006e6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006e9:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006ef:	a0 44 40 80 00       	mov    0x804044,%al
  8006f4:	0f b6 c0             	movzbl %al,%eax
  8006f7:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006fd:	52                   	push   %edx
  8006fe:	50                   	push   %eax
  8006ff:	51                   	push   %ecx
  800700:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800706:	83 c0 08             	add    $0x8,%eax
  800709:	50                   	push   %eax
  80070a:	e8 d9 10 00 00       	call   8017e8 <sys_cputs>
  80070f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800712:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800719:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80071f:	c9                   	leave  
  800720:	c3                   	ret    

00800721 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
  800724:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800727:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  80072e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800731:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	ff 75 f4             	pushl  -0xc(%ebp)
  80073d:	50                   	push   %eax
  80073e:	e8 6f ff ff ff       	call   8006b2 <vcprintf>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800749:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800754:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	c1 e0 08             	shl    $0x8,%eax
  800761:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800766:	8d 45 0c             	lea    0xc(%ebp),%eax
  800769:	83 c0 04             	add    $0x4,%eax
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 f4             	pushl  -0xc(%ebp)
  800778:	50                   	push   %eax
  800779:	e8 34 ff ff ff       	call   8006b2 <vcprintf>
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800784:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  80078b:	07 00 00 

	return cnt;
  80078e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800799:	e8 8e 10 00 00       	call   80182c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80079e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	e8 ff fe ff ff       	call   8006b2 <vcprintf>
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007b9:	e8 88 10 00 00       	call   801846 <sys_unlock_cons>
	return cnt;
  8007be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    

008007c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	53                   	push   %ebx
  8007c7:	83 ec 14             	sub    $0x14,%esp
  8007ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8007cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e1:	77 55                	ja     800838 <printnum+0x75>
  8007e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e6:	72 05                	jb     8007ed <printnum+0x2a>
  8007e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007eb:	77 4b                	ja     800838 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fb:	52                   	push   %edx
  8007fc:	50                   	push   %eax
  8007fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800800:	ff 75 f0             	pushl  -0x10(%ebp)
  800803:	e8 08 20 00 00       	call   802810 <__udivdi3>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	83 ec 04             	sub    $0x4,%esp
  80080e:	ff 75 20             	pushl  0x20(%ebp)
  800811:	53                   	push   %ebx
  800812:	ff 75 18             	pushl  0x18(%ebp)
  800815:	52                   	push   %edx
  800816:	50                   	push   %eax
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	ff 75 08             	pushl  0x8(%ebp)
  80081d:	e8 a1 ff ff ff       	call   8007c3 <printnum>
  800822:	83 c4 20             	add    $0x20,%esp
  800825:	eb 1a                	jmp    800841 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800827:	83 ec 08             	sub    $0x8,%esp
  80082a:	ff 75 0c             	pushl  0xc(%ebp)
  80082d:	ff 75 20             	pushl  0x20(%ebp)
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800838:	ff 4d 1c             	decl   0x1c(%ebp)
  80083b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80083f:	7f e6                	jg     800827 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800841:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800844:	bb 00 00 00 00       	mov    $0x0,%ebx
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80084f:	53                   	push   %ebx
  800850:	51                   	push   %ecx
  800851:	52                   	push   %edx
  800852:	50                   	push   %eax
  800853:	e8 c8 20 00 00       	call   802920 <__umoddi3>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	05 94 30 80 00       	add    $0x803094,%eax
  800860:	8a 00                	mov    (%eax),%al
  800862:	0f be c0             	movsbl %al,%eax
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	50                   	push   %eax
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
}
  800874:	90                   	nop
  800875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80087d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800881:	7e 1c                	jle    80089f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	8b 00                	mov    (%eax),%eax
  800888:	8d 50 08             	lea    0x8(%eax),%edx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	89 10                	mov    %edx,(%eax)
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	8b 00                	mov    (%eax),%eax
  800895:	83 e8 08             	sub    $0x8,%eax
  800898:	8b 50 04             	mov    0x4(%eax),%edx
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	eb 40                	jmp    8008df <getuint+0x65>
	else if (lflag)
  80089f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a3:	74 1e                	je     8008c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	8d 50 04             	lea    0x4(%eax),%edx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	89 10                	mov    %edx,(%eax)
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	83 e8 04             	sub    $0x4,%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c1:	eb 1c                	jmp    8008df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 04             	lea    0x4(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 04             	sub    $0x4,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e8:	7e 1c                	jle    800906 <getint+0x25>
		return va_arg(*ap, long long);
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 00                	mov    (%eax),%eax
  8008ef:	8d 50 08             	lea    0x8(%eax),%edx
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	89 10                	mov    %edx,(%eax)
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	83 e8 08             	sub    $0x8,%eax
  8008ff:	8b 50 04             	mov    0x4(%eax),%edx
  800902:	8b 00                	mov    (%eax),%eax
  800904:	eb 38                	jmp    80093e <getint+0x5d>
	else if (lflag)
  800906:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090a:	74 1a                	je     800926 <getint+0x45>
		return va_arg(*ap, long);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	99                   	cltd   
  800924:	eb 18                	jmp    80093e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800926:	8b 45 08             	mov    0x8(%ebp),%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	8d 50 04             	lea    0x4(%eax),%edx
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	89 10                	mov    %edx,(%eax)
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	99                   	cltd   
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	56                   	push   %esi
  800944:	53                   	push   %ebx
  800945:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	eb 17                	jmp    800961 <vprintfmt+0x21>
			if (ch == '\0')
  80094a:	85 db                	test   %ebx,%ebx
  80094c:	0f 84 c1 03 00 00    	je     800d13 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800961:	8b 45 10             	mov    0x10(%ebp),%eax
  800964:	8d 50 01             	lea    0x1(%eax),%edx
  800967:	89 55 10             	mov    %edx,0x10(%ebp)
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	0f b6 d8             	movzbl %al,%ebx
  80096f:	83 fb 25             	cmp    $0x25,%ebx
  800972:	75 d6                	jne    80094a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800974:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800978:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80097f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800986:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80098d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800994:	8b 45 10             	mov    0x10(%ebp),%eax
  800997:	8d 50 01             	lea    0x1(%eax),%edx
  80099a:	89 55 10             	mov    %edx,0x10(%ebp)
  80099d:	8a 00                	mov    (%eax),%al
  80099f:	0f b6 d8             	movzbl %al,%ebx
  8009a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009a5:	83 f8 5b             	cmp    $0x5b,%eax
  8009a8:	0f 87 3d 03 00 00    	ja     800ceb <vprintfmt+0x3ab>
  8009ae:	8b 04 85 b8 30 80 00 	mov    0x8030b8(,%eax,4),%eax
  8009b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009bb:	eb d7                	jmp    800994 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009c1:	eb d1                	jmp    800994 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	c1 e0 02             	shl    $0x2,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d8                	add    %ebx,%eax
  8009d8:	83 e8 30             	sub    $0x30,%eax
  8009db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009de:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8009e9:	7e 3e                	jle    800a29 <vprintfmt+0xe9>
  8009eb:	83 fb 39             	cmp    $0x39,%ebx
  8009ee:	7f 39                	jg     800a29 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f3:	eb d5                	jmp    8009ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f8:	83 c0 04             	add    $0x4,%eax
  8009fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 e8 04             	sub    $0x4,%eax
  800a04:	8b 00                	mov    (%eax),%eax
  800a06:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a09:	eb 1f                	jmp    800a2a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0f:	79 83                	jns    800994 <vprintfmt+0x54>
				width = 0;
  800a11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a18:	e9 77 ff ff ff       	jmp    800994 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a1d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a24:	e9 6b ff ff ff       	jmp    800994 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a29:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2e:	0f 89 60 ff ff ff    	jns    800994 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a3a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a41:	e9 4e ff ff ff       	jmp    800994 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a46:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a49:	e9 46 ff ff ff       	jmp    800994 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	83 c0 04             	add    $0x4,%eax
  800a54:	89 45 14             	mov    %eax,0x14(%ebp)
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 e8 04             	sub    $0x4,%eax
  800a5d:	8b 00                	mov    (%eax),%eax
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	50                   	push   %eax
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	ff d0                	call   *%eax
  800a6b:	83 c4 10             	add    $0x10,%esp
			break;
  800a6e:	e9 9b 02 00 00       	jmp    800d0e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a73:	8b 45 14             	mov    0x14(%ebp),%eax
  800a76:	83 c0 04             	add    $0x4,%eax
  800a79:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 e8 04             	sub    $0x4,%eax
  800a82:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a84:	85 db                	test   %ebx,%ebx
  800a86:	79 02                	jns    800a8a <vprintfmt+0x14a>
				err = -err;
  800a88:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a8a:	83 fb 64             	cmp    $0x64,%ebx
  800a8d:	7f 0b                	jg     800a9a <vprintfmt+0x15a>
  800a8f:	8b 34 9d 00 2f 80 00 	mov    0x802f00(,%ebx,4),%esi
  800a96:	85 f6                	test   %esi,%esi
  800a98:	75 19                	jne    800ab3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a9a:	53                   	push   %ebx
  800a9b:	68 a5 30 80 00       	push   $0x8030a5
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 70 02 00 00       	call   800d1b <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aae:	e9 5b 02 00 00       	jmp    800d0e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab3:	56                   	push   %esi
  800ab4:	68 ae 30 80 00       	push   $0x8030ae
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 57 02 00 00       	call   800d1b <printfmt>
  800ac4:	83 c4 10             	add    $0x10,%esp
			break;
  800ac7:	e9 42 02 00 00       	jmp    800d0e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 c0 04             	add    $0x4,%eax
  800ad2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 e8 04             	sub    $0x4,%eax
  800adb:	8b 30                	mov    (%eax),%esi
  800add:	85 f6                	test   %esi,%esi
  800adf:	75 05                	jne    800ae6 <vprintfmt+0x1a6>
				p = "(null)";
  800ae1:	be b1 30 80 00       	mov    $0x8030b1,%esi
			if (width > 0 && padc != '-')
  800ae6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aea:	7e 6d                	jle    800b59 <vprintfmt+0x219>
  800aec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af0:	74 67                	je     800b59 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	50                   	push   %eax
  800af9:	56                   	push   %esi
  800afa:	e8 1e 03 00 00       	call   800e1d <strnlen>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b05:	eb 16                	jmp    800b1d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b07:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b0b:	83 ec 08             	sub    $0x8,%esp
  800b0e:	ff 75 0c             	pushl  0xc(%ebp)
  800b11:	50                   	push   %eax
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	ff d0                	call   *%eax
  800b17:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b21:	7f e4                	jg     800b07 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b23:	eb 34                	jmp    800b59 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b25:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b29:	74 1c                	je     800b47 <vprintfmt+0x207>
  800b2b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b2e:	7e 05                	jle    800b35 <vprintfmt+0x1f5>
  800b30:	83 fb 7e             	cmp    $0x7e,%ebx
  800b33:	7e 12                	jle    800b47 <vprintfmt+0x207>
					putch('?', putdat);
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	6a 3f                	push   $0x3f
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	ff d0                	call   *%eax
  800b42:	83 c4 10             	add    $0x10,%esp
  800b45:	eb 0f                	jmp    800b56 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b47:	83 ec 08             	sub    $0x8,%esp
  800b4a:	ff 75 0c             	pushl  0xc(%ebp)
  800b4d:	53                   	push   %ebx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	ff d0                	call   *%eax
  800b53:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b56:	ff 4d e4             	decl   -0x1c(%ebp)
  800b59:	89 f0                	mov    %esi,%eax
  800b5b:	8d 70 01             	lea    0x1(%eax),%esi
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f be d8             	movsbl %al,%ebx
  800b63:	85 db                	test   %ebx,%ebx
  800b65:	74 24                	je     800b8b <vprintfmt+0x24b>
  800b67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6b:	78 b8                	js     800b25 <vprintfmt+0x1e5>
  800b6d:	ff 4d e0             	decl   -0x20(%ebp)
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	79 af                	jns    800b25 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b76:	eb 13                	jmp    800b8b <vprintfmt+0x24b>
				putch(' ', putdat);
  800b78:	83 ec 08             	sub    $0x8,%esp
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	6a 20                	push   $0x20
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	ff d0                	call   *%eax
  800b85:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b88:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8f:	7f e7                	jg     800b78 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b91:	e9 78 01 00 00       	jmp    800d0e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b96:	83 ec 08             	sub    $0x8,%esp
  800b99:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b9f:	50                   	push   %eax
  800ba0:	e8 3c fd ff ff       	call   8008e1 <getint>
  800ba5:	83 c4 10             	add    $0x10,%esp
  800ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb4:	85 d2                	test   %edx,%edx
  800bb6:	79 23                	jns    800bdb <vprintfmt+0x29b>
				putch('-', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 2d                	push   $0x2d
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bce:	f7 d8                	neg    %eax
  800bd0:	83 d2 00             	adc    $0x0,%edx
  800bd3:	f7 da                	neg    %edx
  800bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bdb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be2:	e9 bc 00 00 00       	jmp    800ca3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 e8             	pushl  -0x18(%ebp)
  800bed:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf0:	50                   	push   %eax
  800bf1:	e8 84 fc ff ff       	call   80087a <getuint>
  800bf6:	83 c4 10             	add    $0x10,%esp
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 98 00 00 00       	jmp    800ca3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	6a 58                	push   $0x58
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	ff d0                	call   *%eax
  800c18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 58                	push   $0x58
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 0c             	pushl  0xc(%ebp)
  800c31:	6a 58                	push   $0x58
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	ff d0                	call   *%eax
  800c38:	83 c4 10             	add    $0x10,%esp
			break;
  800c3b:	e9 ce 00 00 00       	jmp    800d0e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 0c             	pushl  0xc(%ebp)
  800c46:	6a 30                	push   $0x30
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	ff d0                	call   *%eax
  800c4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 78                	push   $0x78
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c60:	8b 45 14             	mov    0x14(%ebp),%eax
  800c63:	83 c0 04             	add    $0x4,%eax
  800c66:	89 45 14             	mov    %eax,0x14(%ebp)
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 e8 04             	sub    $0x4,%eax
  800c6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c82:	eb 1f                	jmp    800ca3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8d:	50                   	push   %eax
  800c8e:	e8 e7 fb ff ff       	call   80087a <getuint>
  800c93:	83 c4 10             	add    $0x10,%esp
  800c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800caa:	83 ec 04             	sub    $0x4,%esp
  800cad:	52                   	push   %edx
  800cae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cb1:	50                   	push   %eax
  800cb2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	ff 75 08             	pushl  0x8(%ebp)
  800cbe:	e8 00 fb ff ff       	call   8007c3 <printnum>
  800cc3:	83 c4 20             	add    $0x20,%esp
			break;
  800cc6:	eb 46                	jmp    800d0e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 0c             	pushl  0xc(%ebp)
  800cce:	53                   	push   %ebx
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	ff d0                	call   *%eax
  800cd4:	83 c4 10             	add    $0x10,%esp
			break;
  800cd7:	eb 35                	jmp    800d0e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cd9:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800ce0:	eb 2c                	jmp    800d0e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ce2:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ce9:	eb 23                	jmp    800d0e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	6a 25                	push   $0x25
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cfb:	ff 4d 10             	decl   0x10(%ebp)
  800cfe:	eb 03                	jmp    800d03 <vprintfmt+0x3c3>
  800d00:	ff 4d 10             	decl   0x10(%ebp)
  800d03:	8b 45 10             	mov    0x10(%ebp),%eax
  800d06:	48                   	dec    %eax
  800d07:	8a 00                	mov    (%eax),%al
  800d09:	3c 25                	cmp    $0x25,%al
  800d0b:	75 f3                	jne    800d00 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d0d:	90                   	nop
		}
	}
  800d0e:	e9 35 fc ff ff       	jmp    800948 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d13:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d21:	8d 45 10             	lea    0x10(%ebp),%eax
  800d24:	83 c0 04             	add    $0x4,%eax
  800d27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d30:	50                   	push   %eax
  800d31:	ff 75 0c             	pushl  0xc(%ebp)
  800d34:	ff 75 08             	pushl  0x8(%ebp)
  800d37:	e8 04 fc ff ff       	call   800940 <vprintfmt>
  800d3c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d3f:	90                   	nop
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	8b 40 08             	mov    0x8(%eax),%eax
  800d4b:	8d 50 01             	lea    0x1(%eax),%edx
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8b 10                	mov    (%eax),%edx
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8b 40 04             	mov    0x4(%eax),%eax
  800d5f:	39 c2                	cmp    %eax,%edx
  800d61:	73 12                	jae    800d75 <sprintputch+0x33>
		*b->buf++ = ch;
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8b 00                	mov    (%eax),%eax
  800d68:	8d 48 01             	lea    0x1(%eax),%ecx
  800d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6e:	89 0a                	mov    %ecx,(%edx)
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	88 10                	mov    %dl,(%eax)
}
  800d75:	90                   	nop
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	01 d0                	add    %edx,%eax
  800d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9d:	74 06                	je     800da5 <vsnprintf+0x2d>
  800d9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da3:	7f 07                	jg     800dac <vsnprintf+0x34>
		return -E_INVAL;
  800da5:	b8 03 00 00 00       	mov    $0x3,%eax
  800daa:	eb 20                	jmp    800dcc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dac:	ff 75 14             	pushl  0x14(%ebp)
  800daf:	ff 75 10             	pushl  0x10(%ebp)
  800db2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db5:	50                   	push   %eax
  800db6:	68 42 0d 80 00       	push   $0x800d42
  800dbb:	e8 80 fb ff ff       	call   800940 <vprintfmt>
  800dc0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dcc:	c9                   	leave  
  800dcd:	c3                   	ret    

00800dce <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd4:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd7:	83 c0 04             	add    $0x4,%eax
  800dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  800de0:	ff 75 f4             	pushl  -0xc(%ebp)
  800de3:	50                   	push   %eax
  800de4:	ff 75 0c             	pushl  0xc(%ebp)
  800de7:	ff 75 08             	pushl  0x8(%ebp)
  800dea:	e8 89 ff ff ff       	call   800d78 <vsnprintf>
  800def:	83 c4 10             	add    $0x10,%esp
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e07:	eb 06                	jmp    800e0f <strlen+0x15>
		n++;
  800e09:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e0c:	ff 45 08             	incl   0x8(%ebp)
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	84 c0                	test   %al,%al
  800e16:	75 f1                	jne    800e09 <strlen+0xf>
		n++;
	return n;
  800e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2a:	eb 09                	jmp    800e35 <strnlen+0x18>
		n++;
  800e2c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2f:	ff 45 08             	incl   0x8(%ebp)
  800e32:	ff 4d 0c             	decl   0xc(%ebp)
  800e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e39:	74 09                	je     800e44 <strnlen+0x27>
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 e8                	jne    800e2c <strnlen+0xf>
		n++;
	return n;
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e55:	90                   	nop
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e68:	8a 12                	mov    (%edx),%dl
  800e6a:	88 10                	mov    %dl,(%eax)
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e4                	jne    800e56 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8a:	eb 1f                	jmp    800eab <strncpy+0x34>
		*dst++ = *src;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8d 50 01             	lea    0x1(%eax),%edx
  800e92:	89 55 08             	mov    %edx,0x8(%ebp)
  800e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e98:	8a 12                	mov    (%edx),%dl
  800e9a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	84 c0                	test   %al,%al
  800ea3:	74 03                	je     800ea8 <strncpy+0x31>
			src++;
  800ea5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ea8:	ff 45 fc             	incl   -0x4(%ebp)
  800eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eae:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eb1:	72 d9                	jb     800e8c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec8:	74 30                	je     800efa <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eca:	eb 16                	jmp    800ee2 <strlcpy+0x2a>
			*dst++ = *src++;
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8d 50 01             	lea    0x1(%eax),%edx
  800ed2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ede:	8a 12                	mov    (%edx),%dl
  800ee0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ee2:	ff 4d 10             	decl   0x10(%ebp)
  800ee5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee9:	74 09                	je     800ef4 <strlcpy+0x3c>
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	84 c0                	test   %al,%al
  800ef2:	75 d8                	jne    800ecc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800efa:	8b 55 08             	mov    0x8(%ebp),%edx
  800efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f00:	29 c2                	sub    %eax,%edx
  800f02:	89 d0                	mov    %edx,%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f09:	eb 06                	jmp    800f11 <strcmp+0xb>
		p++, q++;
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	84 c0                	test   %al,%al
  800f18:	74 0e                	je     800f28 <strcmp+0x22>
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	8a 10                	mov    (%eax),%dl
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	38 c2                	cmp    %al,%dl
  800f26:	74 e3                	je     800f0b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f b6 d0             	movzbl %al,%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f b6 c0             	movzbl %al,%eax
  800f38:	29 c2                	sub    %eax,%edx
  800f3a:	89 d0                	mov    %edx,%eax
}
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f41:	eb 09                	jmp    800f4c <strncmp+0xe>
		n--, p++, q++;
  800f43:	ff 4d 10             	decl   0x10(%ebp)
  800f46:	ff 45 08             	incl   0x8(%ebp)
  800f49:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	74 17                	je     800f69 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	84 c0                	test   %al,%al
  800f59:	74 0e                	je     800f69 <strncmp+0x2b>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	38 c2                	cmp    %al,%dl
  800f67:	74 da                	je     800f43 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 07                	jne    800f76 <strncmp+0x38>
		return 0;
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f74:	eb 14                	jmp    800f8a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	0f b6 d0             	movzbl %al,%edx
  800f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	0f b6 c0             	movzbl %al,%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f98:	eb 12                	jmp    800fac <strchr+0x20>
		if (*s == c)
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa2:	75 05                	jne    800fa9 <strchr+0x1d>
			return (char *) s;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	eb 11                	jmp    800fba <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 e5                	jne    800f9a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 04             	sub    $0x4,%esp
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc8:	eb 0d                	jmp    800fd7 <strfind+0x1b>
		if (*s == c)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd2:	74 0e                	je     800fe2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd4:	ff 45 08             	incl   0x8(%ebp)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	84 c0                	test   %al,%al
  800fde:	75 ea                	jne    800fca <strfind+0xe>
  800fe0:	eb 01                	jmp    800fe3 <strfind+0x27>
		if (*s == c)
			break;
  800fe2:	90                   	nop
	return (char *) s;
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    

00800fe8 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800ff4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff8:	76 63                	jbe    80105d <memset+0x75>
		uint64 data_block = c;
  800ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffd:	99                   	cltd   
  800ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801001:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100a:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80100e:	c1 e0 08             	shl    $0x8,%eax
  801011:	09 45 f0             	or     %eax,-0x10(%ebp)
  801014:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801021:	c1 e0 10             	shl    $0x10,%eax
  801024:	09 45 f0             	or     %eax,-0x10(%ebp)
  801027:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80102a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801030:	89 c2                	mov    %eax,%edx
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	09 45 f0             	or     %eax,-0x10(%ebp)
  80103a:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  80103d:	eb 18                	jmp    801057 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80103f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801042:	8d 41 08             	lea    0x8(%ecx),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	89 01                	mov    %eax,(%ecx)
  801050:	89 51 04             	mov    %edx,0x4(%ecx)
  801053:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801057:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80105b:	77 e2                	ja     80103f <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  80105d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801061:	74 23                	je     801086 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801069:	eb 0e                	jmp    801079 <memset+0x91>
			*p8++ = (uint8)c;
  80106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106e:	8d 50 01             	lea    0x1(%eax),%edx
  801071:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801074:	8b 55 0c             	mov    0xc(%ebp),%edx
  801077:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801079:	8b 45 10             	mov    0x10(%ebp),%eax
  80107c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107f:	89 55 10             	mov    %edx,0x10(%ebp)
  801082:	85 c0                	test   %eax,%eax
  801084:	75 e5                	jne    80106b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801091:	8b 45 0c             	mov    0xc(%ebp),%eax
  801094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80109d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a1:	76 24                	jbe    8010c7 <memcpy+0x3c>
		while(n >= 8){
  8010a3:	eb 1c                	jmp    8010c1 <memcpy+0x36>
			*d64 = *s64;
  8010a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a8:	8b 50 04             	mov    0x4(%eax),%edx
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010b0:	89 01                	mov    %eax,(%ecx)
  8010b2:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010b5:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010b9:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010bd:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010c1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c5:	77 de                	ja     8010a5 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cb:	74 31                	je     8010fe <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010d9:	eb 16                	jmp    8010f1 <memcpy+0x66>
			*d8++ = *s8++;
  8010db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ea:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010ed:	8a 12                	mov    (%edx),%dl
  8010ef:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 dd                	jne    8010db <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80111b:	73 50                	jae    80116d <memmove+0x6a>
  80111d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801128:	76 43                	jbe    80116d <memmove+0x6a>
		s += n;
  80112a:	8b 45 10             	mov    0x10(%ebp),%eax
  80112d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801130:	8b 45 10             	mov    0x10(%ebp),%eax
  801133:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801136:	eb 10                	jmp    801148 <memmove+0x45>
			*--d = *--s;
  801138:	ff 4d f8             	decl   -0x8(%ebp)
  80113b:	ff 4d fc             	decl   -0x4(%ebp)
  80113e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801141:	8a 10                	mov    (%eax),%dl
  801143:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801146:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801148:	8b 45 10             	mov    0x10(%ebp),%eax
  80114b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114e:	89 55 10             	mov    %edx,0x10(%ebp)
  801151:	85 c0                	test   %eax,%eax
  801153:	75 e3                	jne    801138 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801155:	eb 23                	jmp    80117a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80115a:	8d 50 01             	lea    0x1(%eax),%edx
  80115d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801160:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801163:	8d 4a 01             	lea    0x1(%edx),%ecx
  801166:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801169:	8a 12                	mov    (%edx),%dl
  80116b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	8d 50 ff             	lea    -0x1(%eax),%edx
  801173:	89 55 10             	mov    %edx,0x10(%ebp)
  801176:	85 c0                	test   %eax,%eax
  801178:	75 dd                	jne    801157 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801191:	eb 2a                	jmp    8011bd <memcmp+0x3e>
		if (*s1 != *s2)
  801193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801196:	8a 10                	mov    (%eax),%dl
  801198:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	38 c2                	cmp    %al,%dl
  80119f:	74 16                	je     8011b7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	0f b6 d0             	movzbl %al,%edx
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	0f b6 c0             	movzbl %al,%eax
  8011b1:	29 c2                	sub    %eax,%edx
  8011b3:	89 d0                	mov    %edx,%eax
  8011b5:	eb 18                	jmp    8011cf <memcmp+0x50>
		s1++, s2++;
  8011b7:	ff 45 fc             	incl   -0x4(%ebp)
  8011ba:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	75 c9                	jne    801193 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 d0                	add    %edx,%eax
  8011df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011e2:	eb 15                	jmp    8011f9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	0f b6 d0             	movzbl %al,%edx
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	0f b6 c0             	movzbl %al,%eax
  8011f2:	39 c2                	cmp    %eax,%edx
  8011f4:	74 0d                	je     801203 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011f6:	ff 45 08             	incl   0x8(%ebp)
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011ff:	72 e3                	jb     8011e4 <memfind+0x13>
  801201:	eb 01                	jmp    801204 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801203:	90                   	nop
	return (void *) s;
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80120f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801216:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80121d:	eb 03                	jmp    801222 <strtol+0x19>
		s++;
  80121f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 20                	cmp    $0x20,%al
  801229:	74 f4                	je     80121f <strtol+0x16>
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	3c 09                	cmp    $0x9,%al
  801232:	74 eb                	je     80121f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	3c 2b                	cmp    $0x2b,%al
  80123b:	75 05                	jne    801242 <strtol+0x39>
		s++;
  80123d:	ff 45 08             	incl   0x8(%ebp)
  801240:	eb 13                	jmp    801255 <strtol+0x4c>
	else if (*s == '-')
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 2d                	cmp    $0x2d,%al
  801249:	75 0a                	jne    801255 <strtol+0x4c>
		s++, neg = 1;
  80124b:	ff 45 08             	incl   0x8(%ebp)
  80124e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801259:	74 06                	je     801261 <strtol+0x58>
  80125b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80125f:	75 20                	jne    801281 <strtol+0x78>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	3c 30                	cmp    $0x30,%al
  801268:	75 17                	jne    801281 <strtol+0x78>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	40                   	inc    %eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 78                	cmp    $0x78,%al
  801272:	75 0d                	jne    801281 <strtol+0x78>
		s += 2, base = 16;
  801274:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801278:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80127f:	eb 28                	jmp    8012a9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801285:	75 15                	jne    80129c <strtol+0x93>
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	8a 00                	mov    (%eax),%al
  80128c:	3c 30                	cmp    $0x30,%al
  80128e:	75 0c                	jne    80129c <strtol+0x93>
		s++, base = 8;
  801290:	ff 45 08             	incl   0x8(%ebp)
  801293:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80129a:	eb 0d                	jmp    8012a9 <strtol+0xa0>
	else if (base == 0)
  80129c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a0:	75 07                	jne    8012a9 <strtol+0xa0>
		base = 10;
  8012a2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	3c 2f                	cmp    $0x2f,%al
  8012b0:	7e 19                	jle    8012cb <strtol+0xc2>
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	3c 39                	cmp    $0x39,%al
  8012b9:	7f 10                	jg     8012cb <strtol+0xc2>
			dig = *s - '0';
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8a 00                	mov    (%eax),%al
  8012c0:	0f be c0             	movsbl %al,%eax
  8012c3:	83 e8 30             	sub    $0x30,%eax
  8012c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c9:	eb 42                	jmp    80130d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 60                	cmp    $0x60,%al
  8012d2:	7e 19                	jle    8012ed <strtol+0xe4>
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	3c 7a                	cmp    $0x7a,%al
  8012db:	7f 10                	jg     8012ed <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	8a 00                	mov    (%eax),%al
  8012e2:	0f be c0             	movsbl %al,%eax
  8012e5:	83 e8 57             	sub    $0x57,%eax
  8012e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012eb:	eb 20                	jmp    80130d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	3c 40                	cmp    $0x40,%al
  8012f4:	7e 39                	jle    80132f <strtol+0x126>
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	3c 5a                	cmp    $0x5a,%al
  8012fd:	7f 30                	jg     80132f <strtol+0x126>
			dig = *s - 'A' + 10;
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	0f be c0             	movsbl %al,%eax
  801307:	83 e8 37             	sub    $0x37,%eax
  80130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	3b 45 10             	cmp    0x10(%ebp),%eax
  801313:	7d 19                	jge    80132e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801315:	ff 45 08             	incl   0x8(%ebp)
  801318:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80131f:	89 c2                	mov    %eax,%edx
  801321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801324:	01 d0                	add    %edx,%eax
  801326:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801329:	e9 7b ff ff ff       	jmp    8012a9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80132e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80132f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801333:	74 08                	je     80133d <strtol+0x134>
		*endptr = (char *) s;
  801335:	8b 45 0c             	mov    0xc(%ebp),%eax
  801338:	8b 55 08             	mov    0x8(%ebp),%edx
  80133b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80133d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801341:	74 07                	je     80134a <strtol+0x141>
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	f7 d8                	neg    %eax
  801348:	eb 03                	jmp    80134d <strtol+0x144>
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <ltostr>:

void
ltostr(long value, char *str)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801355:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80135c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801367:	79 13                	jns    80137c <ltostr+0x2d>
	{
		neg = 1;
  801369:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801376:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801379:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801384:	99                   	cltd   
  801385:	f7 f9                	idiv   %ecx
  801387:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80138a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138d:	8d 50 01             	lea    0x1(%eax),%edx
  801390:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801393:	89 c2                	mov    %eax,%edx
  801395:	8b 45 0c             	mov    0xc(%ebp),%eax
  801398:	01 d0                	add    %edx,%eax
  80139a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80139d:	83 c2 30             	add    $0x30,%edx
  8013a0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013a5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013aa:	f7 e9                	imul   %ecx
  8013ac:	c1 fa 02             	sar    $0x2,%edx
  8013af:	89 c8                	mov    %ecx,%eax
  8013b1:	c1 f8 1f             	sar    $0x1f,%eax
  8013b4:	29 c2                	sub    %eax,%edx
  8013b6:	89 d0                	mov    %edx,%eax
  8013b8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013bf:	75 bb                	jne    80137c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013cb:	48                   	dec    %eax
  8013cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013d3:	74 3d                	je     801412 <ltostr+0xc3>
		start = 1 ;
  8013d5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013dc:	eb 34                	jmp    801412 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f1:	01 c2                	add    %eax,%edx
  8013f3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	01 c8                	add    %ecx,%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
  801405:	01 c2                	add    %eax,%edx
  801407:	8a 45 eb             	mov    -0x15(%ebp),%al
  80140a:	88 02                	mov    %al,(%edx)
		start++ ;
  80140c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80140f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801415:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801418:	7c c4                	jl     8013de <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80141a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 d0                	add    %edx,%eax
  801422:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801425:	90                   	nop
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80142e:	ff 75 08             	pushl  0x8(%ebp)
  801431:	e8 c4 f9 ff ff       	call   800dfa <strlen>
  801436:	83 c4 04             	add    $0x4,%esp
  801439:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80143c:	ff 75 0c             	pushl  0xc(%ebp)
  80143f:	e8 b6 f9 ff ff       	call   800dfa <strlen>
  801444:	83 c4 04             	add    $0x4,%esp
  801447:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80144a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801451:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801458:	eb 17                	jmp    801471 <strcconcat+0x49>
		final[s] = str1[s] ;
  80145a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80145d:	8b 45 10             	mov    0x10(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	01 c8                	add    %ecx,%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80146e:	ff 45 fc             	incl   -0x4(%ebp)
  801471:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801474:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801477:	7c e1                	jl     80145a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801479:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801480:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801487:	eb 1f                	jmp    8014a8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148c:	8d 50 01             	lea    0x1(%eax),%edx
  80148f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801492:	89 c2                	mov    %eax,%edx
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	01 c2                	add    %eax,%edx
  801499:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	01 c8                	add    %ecx,%eax
  8014a1:	8a 00                	mov    (%eax),%al
  8014a3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014a5:	ff 45 f8             	incl   -0x8(%ebp)
  8014a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014ae:	7c d9                	jl     801489 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b6:	01 d0                	add    %edx,%eax
  8014b8:	c6 00 00             	movb   $0x0,(%eax)
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cd:	8b 00                	mov    (%eax),%eax
  8014cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e1:	eb 0c                	jmp    8014ef <strsplit+0x31>
			*string++ = 0;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8d 50 01             	lea    0x1(%eax),%edx
  8014e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ec:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f2:	8a 00                	mov    (%eax),%al
  8014f4:	84 c0                	test   %al,%al
  8014f6:	74 18                	je     801510 <strsplit+0x52>
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	8a 00                	mov    (%eax),%al
  8014fd:	0f be c0             	movsbl %al,%eax
  801500:	50                   	push   %eax
  801501:	ff 75 0c             	pushl  0xc(%ebp)
  801504:	e8 83 fa ff ff       	call   800f8c <strchr>
  801509:	83 c4 08             	add    $0x8,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	75 d3                	jne    8014e3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	84 c0                	test   %al,%al
  801517:	74 5a                	je     801573 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801519:	8b 45 14             	mov    0x14(%ebp),%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	83 f8 0f             	cmp    $0xf,%eax
  801521:	75 07                	jne    80152a <strsplit+0x6c>
		{
			return 0;
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	eb 66                	jmp    801590 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80152a:	8b 45 14             	mov    0x14(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	8d 48 01             	lea    0x1(%eax),%ecx
  801532:	8b 55 14             	mov    0x14(%ebp),%edx
  801535:	89 0a                	mov    %ecx,(%edx)
  801537:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80153e:	8b 45 10             	mov    0x10(%ebp),%eax
  801541:	01 c2                	add    %eax,%edx
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801548:	eb 03                	jmp    80154d <strsplit+0x8f>
			string++;
  80154a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	74 8b                	je     8014e1 <strsplit+0x23>
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	8a 00                	mov    (%eax),%al
  80155b:	0f be c0             	movsbl %al,%eax
  80155e:	50                   	push   %eax
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	e8 25 fa ff ff       	call   800f8c <strchr>
  801567:	83 c4 08             	add    $0x8,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	74 dc                	je     80154a <strsplit+0x8c>
			string++;
	}
  80156e:	e9 6e ff ff ff       	jmp    8014e1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801573:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80158b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a5:	eb 4a                	jmp    8015f1 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	01 c2                	add    %eax,%edx
  8015af:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	01 c8                	add    %ecx,%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c1:	01 d0                	add    %edx,%eax
  8015c3:	8a 00                	mov    (%eax),%al
  8015c5:	3c 40                	cmp    $0x40,%al
  8015c7:	7e 25                	jle    8015ee <str2lower+0x5c>
  8015c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	8a 00                	mov    (%eax),%al
  8015d3:	3c 5a                	cmp    $0x5a,%al
  8015d5:	7f 17                	jg     8015ee <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	01 d0                	add    %edx,%eax
  8015df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e5:	01 ca                	add    %ecx,%edx
  8015e7:	8a 12                	mov    (%edx),%dl
  8015e9:	83 c2 20             	add    $0x20,%edx
  8015ec:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015ee:	ff 45 fc             	incl   -0x4(%ebp)
  8015f1:	ff 75 0c             	pushl  0xc(%ebp)
  8015f4:	e8 01 f8 ff ff       	call   800dfa <strlen>
  8015f9:	83 c4 04             	add    $0x4,%esp
  8015fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015ff:	7f a6                	jg     8015a7 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801601:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80160c:	a1 08 40 80 00       	mov    0x804008,%eax
  801611:	85 c0                	test   %eax,%eax
  801613:	74 42                	je     801657 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	68 00 00 00 82       	push   $0x82000000
  80161d:	68 00 00 00 80       	push   $0x80000000
  801622:	e8 00 08 00 00       	call   801e27 <initialize_dynamic_allocator>
  801627:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80162a:	e8 e7 05 00 00       	call   801c16 <sys_get_uheap_strategy>
  80162f:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801634:	a1 40 40 80 00       	mov    0x804040,%eax
  801639:	05 00 10 00 00       	add    $0x1000,%eax
  80163e:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801643:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801648:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  80164d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801654:	00 00 00 
	}
}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	68 06 04 00 00       	push   $0x406
  801676:	50                   	push   %eax
  801677:	e8 e4 01 00 00       	call   801860 <__sys_allocate_page>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801682:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801686:	79 14                	jns    80169c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 28 32 80 00       	push   $0x803228
  801690:	6a 1f                	push   $0x1f
  801692:	68 64 32 80 00       	push   $0x803264
  801697:	e8 b7 ed ff ff       	call   800453 <_panic>
	return 0;
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b7:	83 ec 0c             	sub    $0xc,%esp
  8016ba:	50                   	push   %eax
  8016bb:	e8 e7 01 00 00       	call   8018a7 <__sys_unmap_frame>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ca:	79 14                	jns    8016e0 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 70 32 80 00       	push   $0x803270
  8016d4:	6a 2a                	push   $0x2a
  8016d6:	68 64 32 80 00       	push   $0x803264
  8016db:	e8 73 ed ff ff       	call   800453 <_panic>
}
  8016e0:	90                   	nop
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016e9:	e8 18 ff ff ff       	call   801606 <uheap_init>
	if (size == 0) return NULL ;
  8016ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f2:	75 07                	jne    8016fb <malloc+0x18>
  8016f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f9:	eb 14                	jmp    80170f <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 b0 32 80 00       	push   $0x8032b0
  801703:	6a 3e                	push   $0x3e
  801705:	68 64 32 80 00       	push   $0x803264
  80170a:	e8 44 ed ff ff       	call   800453 <_panic>
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 d8 32 80 00       	push   $0x8032d8
  80171f:	6a 49                	push   $0x49
  801721:	68 64 32 80 00       	push   $0x803264
  801726:	e8 28 ed ff ff       	call   800453 <_panic>

0080172b <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	83 ec 18             	sub    $0x18,%esp
  801731:	8b 45 10             	mov    0x10(%ebp),%eax
  801734:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801737:	e8 ca fe ff ff       	call   801606 <uheap_init>
	if (size == 0) return NULL ;
  80173c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801740:	75 07                	jne    801749 <smalloc+0x1e>
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	eb 14                	jmp    80175d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 fc 32 80 00       	push   $0x8032fc
  801751:	6a 5a                	push   $0x5a
  801753:	68 64 32 80 00       	push   $0x803264
  801758:	e8 f6 ec ff ff       	call   800453 <_panic>
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801765:	e8 9c fe ff ff       	call   801606 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	68 24 33 80 00       	push   $0x803324
  801772:	6a 6a                	push   $0x6a
  801774:	68 64 32 80 00       	push   $0x803264
  801779:	e8 d5 ec ff ff       	call   800453 <_panic>

0080177e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801784:	e8 7d fe ff ff       	call   801606 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 48 33 80 00       	push   $0x803348
  801791:	68 88 00 00 00       	push   $0x88
  801796:	68 64 32 80 00       	push   $0x803264
  80179b:	e8 b3 ec ff ff       	call   800453 <_panic>

008017a0 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 70 33 80 00       	push   $0x803370
  8017ae:	68 9b 00 00 00       	push   $0x9b
  8017b3:	68 64 32 80 00       	push   $0x803264
  8017b8:	e8 96 ec ff ff       	call   800453 <_panic>

008017bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	57                   	push   %edi
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017d5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017d8:	cd 30                	int    $0x30
  8017da:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	5b                   	pop    %ebx
  8017e4:	5e                   	pop    %esi
  8017e5:	5f                   	pop    %edi
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8017f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	51                   	push   %ecx
  801801:	52                   	push   %edx
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	50                   	push   %eax
  801806:	6a 00                	push   $0x0
  801808:	e8 b0 ff ff ff       	call   8017bd <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_cgetc>:

int
sys_cgetc(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 02                	push   $0x2
  801822:	e8 96 ff ff ff       	call   8017bd <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 03                	push   $0x3
  80183b:	e8 7d ff ff ff       	call   8017bd <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	90                   	nop
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 04                	push   $0x4
  801855:	e8 63 ff ff ff       	call   8017bd <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 08                	push   $0x8
  801873:	e8 45 ff ff ff       	call   8017bd <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801882:	8b 75 18             	mov    0x18(%ebp),%esi
  801885:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	56                   	push   %esi
  801892:	53                   	push   %ebx
  801893:	51                   	push   %ecx
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 09                	push   $0x9
  801898:	e8 20 ff ff ff       	call   8017bd <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 0a                	push   $0xa
  8018b7:	e8 01 ff ff ff       	call   8017bd <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 0b                	push   $0xb
  8018d2:	e8 e6 fe ff ff       	call   8017bd <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 0c                	push   $0xc
  8018eb:	e8 cd fe ff ff       	call   8017bd <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0d                	push   $0xd
  801904:	e8 b4 fe ff ff       	call   8017bd <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 0e                	push   $0xe
  80191d:	e8 9b fe ff ff       	call   8017bd <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 0f                	push   $0xf
  801936:	e8 82 fe ff ff       	call   8017bd <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 10                	push   $0x10
  801950:	e8 68 fe ff ff       	call   8017bd <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 11                	push   $0x11
  801969:	e8 4f fe ff ff       	call   8017bd <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_cputc>:

void
sys_cputc(const char c)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801980:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	50                   	push   %eax
  80198d:	6a 01                	push   $0x1
  80198f:	e8 29 fe ff ff       	call   8017bd <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 14                	push   $0x14
  8019a9:	e8 0f fe ff ff       	call   8017bd <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	51                   	push   %ecx
  8019cd:	52                   	push   %edx
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	6a 15                	push   $0x15
  8019d4:	e8 e4 fd ff ff       	call   8017bd <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	6a 16                	push   $0x16
  8019f1:	e8 c7 fd ff ff       	call   8017bd <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	51                   	push   %ecx
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	6a 17                	push   $0x17
  801a10:	e8 a8 fd ff ff       	call   8017bd <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	6a 18                	push   $0x18
  801a2d:	e8 8b fd ff ff       	call   8017bd <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 14             	pushl  0x14(%ebp)
  801a42:	ff 75 10             	pushl  0x10(%ebp)
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	6a 19                	push   $0x19
  801a4b:	e8 6d fd ff ff       	call   8017bd <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	50                   	push   %eax
  801a64:	6a 1a                	push   $0x1a
  801a66:	e8 52 fd ff ff       	call   8017bd <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	50                   	push   %eax
  801a80:	6a 1b                	push   $0x1b
  801a82:	e8 36 fd ff ff       	call   8017bd <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 05                	push   $0x5
  801a9b:	e8 1d fd ff ff       	call   8017bd <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 06                	push   $0x6
  801ab4:	e8 04 fd ff ff       	call   8017bd <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 07                	push   $0x7
  801acd:	e8 eb fc ff ff       	call   8017bd <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 1c                	push   $0x1c
  801ae6:	e8 d2 fc ff ff       	call   8017bd <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afa:	8d 50 04             	lea    0x4(%eax),%edx
  801afd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 1d                	push   $0x1d
  801b0a:	e8 ae fc ff ff       	call   8017bd <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1b:	89 01                	mov    %eax,(%ecx)
  801b1d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	c9                   	leave  
  801b24:	c2 04 00             	ret    $0x4

00801b27 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 10             	pushl  0x10(%ebp)
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	ff 75 08             	pushl  0x8(%ebp)
  801b37:	6a 13                	push   $0x13
  801b39:	e8 7f fc ff ff       	call   8017bd <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b41:	90                   	nop
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 1e                	push   $0x1e
  801b53:	e8 65 fc ff ff       	call   8017bd <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b69:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	50                   	push   %eax
  801b76:	6a 1f                	push   $0x1f
  801b78:	e8 40 fc ff ff       	call   8017bd <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <rsttst>:
void rsttst()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 21                	push   $0x21
  801b92:	e8 26 fc ff ff       	call   8017bd <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ba9:	8b 55 18             	mov    0x18(%ebp),%edx
  801bac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	ff 75 10             	pushl  0x10(%ebp)
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	6a 20                	push   $0x20
  801bbd:	e8 fb fb ff ff       	call   8017bd <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <chktst>:
void chktst(uint32 n)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	6a 22                	push   $0x22
  801bd8:	e8 e0 fb ff ff       	call   8017bd <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <inctst>:

void inctst()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 23                	push   $0x23
  801bf2:	e8 c6 fb ff ff       	call   8017bd <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <gettst>:
uint32 gettst()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 24                	push   $0x24
  801c0c:	e8 ac fb ff ff       	call   8017bd <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 25                	push   $0x25
  801c25:	e8 93 fb ff ff       	call   8017bd <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c32:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	ff 75 08             	pushl  0x8(%ebp)
  801c4f:	6a 26                	push   $0x26
  801c51:	e8 67 fb ff ff       	call   8017bd <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	53                   	push   %ebx
  801c6f:	51                   	push   %ecx
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	6a 27                	push   $0x27
  801c74:	e8 44 fb ff ff       	call   8017bd <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 28                	push   $0x28
  801c94:	e8 24 fb ff ff       	call   8017bd <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ca1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	51                   	push   %ecx
  801cad:	ff 75 10             	pushl  0x10(%ebp)
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 29                	push   $0x29
  801cb4:	e8 04 fb ff ff       	call   8017bd <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	ff 75 10             	pushl  0x10(%ebp)
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	6a 12                	push   $0x12
  801cd0:	e8 e8 fa ff ff       	call   8017bd <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 2a                	push   $0x2a
  801cee:	e8 ca fa ff ff       	call   8017bd <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 2b                	push   $0x2b
  801d08:	e8 b0 fa ff ff       	call   8017bd <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 2d                	push   $0x2d
  801d23:	e8 95 fa ff ff       	call   8017bd <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	ff 75 08             	pushl  0x8(%ebp)
  801d3d:	6a 2c                	push   $0x2c
  801d3f:	e8 79 fa ff ff       	call   8017bd <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
	return ;
  801d47:	90                   	nop
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	68 94 33 80 00       	push   $0x803394
  801d58:	68 25 01 00 00       	push   $0x125
  801d5d:	68 c7 33 80 00       	push   $0x8033c7
  801d62:	e8 ec e6 ff ff       	call   800453 <_panic>

00801d67 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801d6d:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801d74:	72 09                	jb     801d7f <to_page_va+0x18>
  801d76:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801d7d:	72 14                	jb     801d93 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801d7f:	83 ec 04             	sub    $0x4,%esp
  801d82:	68 d8 33 80 00       	push   $0x8033d8
  801d87:	6a 15                	push   $0x15
  801d89:	68 03 34 80 00       	push   $0x803403
  801d8e:	e8 c0 e6 ff ff       	call   800453 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	ba 60 40 80 00       	mov    $0x804060,%edx
  801d9b:	29 d0                	sub    %edx,%eax
  801d9d:	c1 f8 02             	sar    $0x2,%eax
  801da0:	89 c2                	mov    %eax,%edx
  801da2:	89 d0                	mov    %edx,%eax
  801da4:	c1 e0 02             	shl    $0x2,%eax
  801da7:	01 d0                	add    %edx,%eax
  801da9:	c1 e0 02             	shl    $0x2,%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	c1 e0 02             	shl    $0x2,%eax
  801db1:	01 d0                	add    %edx,%eax
  801db3:	89 c1                	mov    %eax,%ecx
  801db5:	c1 e1 08             	shl    $0x8,%ecx
  801db8:	01 c8                	add    %ecx,%eax
  801dba:	89 c1                	mov    %eax,%ecx
  801dbc:	c1 e1 10             	shl    $0x10,%ecx
  801dbf:	01 c8                	add    %ecx,%eax
  801dc1:	01 c0                	add    %eax,%eax
  801dc3:	01 d0                	add    %edx,%eax
  801dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	c1 e0 0c             	shl    $0xc,%eax
  801dce:	89 c2                	mov    %eax,%edx
  801dd0:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801dd5:	01 d0                	add    %edx,%eax
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801ddf:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801de4:	8b 55 08             	mov    0x8(%ebp),%edx
  801de7:	29 c2                	sub    %eax,%edx
  801de9:	89 d0                	mov    %edx,%eax
  801deb:	c1 e8 0c             	shr    $0xc,%eax
  801dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df5:	78 09                	js     801e00 <to_page_info+0x27>
  801df7:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801dfe:	7e 14                	jle    801e14 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	68 1c 34 80 00       	push   $0x80341c
  801e08:	6a 22                	push   $0x22
  801e0a:	68 03 34 80 00       	push   $0x803403
  801e0f:	e8 3f e6 ff ff       	call   800453 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e17:	89 d0                	mov    %edx,%eax
  801e19:	01 c0                	add    %eax,%eax
  801e1b:	01 d0                	add    %edx,%eax
  801e1d:	c1 e0 02             	shl    $0x2,%eax
  801e20:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	05 00 00 00 02       	add    $0x2000000,%eax
  801e35:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e38:	73 16                	jae    801e50 <initialize_dynamic_allocator+0x29>
  801e3a:	68 40 34 80 00       	push   $0x803440
  801e3f:	68 66 34 80 00       	push   $0x803466
  801e44:	6a 34                	push   $0x34
  801e46:	68 03 34 80 00       	push   $0x803403
  801e4b:	e8 03 e6 ff ff       	call   800453 <_panic>
		is_initialized = 1;
  801e50:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e57:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e65:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e6a:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801e71:	00 00 00 
  801e74:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801e7b:	00 00 00 
  801e7e:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801e85:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	2b 45 08             	sub    0x8(%ebp),%eax
  801e8e:	c1 e8 0c             	shr    $0xc,%eax
  801e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e9b:	e9 c8 00 00 00       	jmp    801f68 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ea0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea3:	89 d0                	mov    %edx,%eax
  801ea5:	01 c0                	add    %eax,%eax
  801ea7:	01 d0                	add    %edx,%eax
  801ea9:	c1 e0 02             	shl    $0x2,%eax
  801eac:	05 68 40 80 00       	add    $0x804068,%eax
  801eb1:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb9:	89 d0                	mov    %edx,%eax
  801ebb:	01 c0                	add    %eax,%eax
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	c1 e0 02             	shl    $0x2,%eax
  801ec2:	05 6a 40 80 00       	add    $0x80406a,%eax
  801ec7:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801ecc:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ed2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ed5:	89 c8                	mov    %ecx,%eax
  801ed7:	01 c0                	add    %eax,%eax
  801ed9:	01 c8                	add    %ecx,%eax
  801edb:	c1 e0 02             	shl    $0x2,%eax
  801ede:	05 64 40 80 00       	add    $0x804064,%eax
  801ee3:	89 10                	mov    %edx,(%eax)
  801ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee8:	89 d0                	mov    %edx,%eax
  801eea:	01 c0                	add    %eax,%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	c1 e0 02             	shl    $0x2,%eax
  801ef1:	05 64 40 80 00       	add    $0x804064,%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	74 1b                	je     801f17 <initialize_dynamic_allocator+0xf0>
  801efc:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f02:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f05:	89 c8                	mov    %ecx,%eax
  801f07:	01 c0                	add    %eax,%eax
  801f09:	01 c8                	add    %ecx,%eax
  801f0b:	c1 e0 02             	shl    $0x2,%eax
  801f0e:	05 60 40 80 00       	add    $0x804060,%eax
  801f13:	89 02                	mov    %eax,(%edx)
  801f15:	eb 16                	jmp    801f2d <initialize_dynamic_allocator+0x106>
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	89 d0                	mov    %edx,%eax
  801f1c:	01 c0                	add    %eax,%eax
  801f1e:	01 d0                	add    %edx,%eax
  801f20:	c1 e0 02             	shl    $0x2,%eax
  801f23:	05 60 40 80 00       	add    $0x804060,%eax
  801f28:	a3 48 40 80 00       	mov    %eax,0x804048
  801f2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f30:	89 d0                	mov    %edx,%eax
  801f32:	01 c0                	add    %eax,%eax
  801f34:	01 d0                	add    %edx,%eax
  801f36:	c1 e0 02             	shl    $0x2,%eax
  801f39:	05 60 40 80 00       	add    $0x804060,%eax
  801f3e:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f46:	89 d0                	mov    %edx,%eax
  801f48:	01 c0                	add    %eax,%eax
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	c1 e0 02             	shl    $0x2,%eax
  801f4f:	05 60 40 80 00       	add    $0x804060,%eax
  801f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f5a:	a1 54 40 80 00       	mov    0x804054,%eax
  801f5f:	40                   	inc    %eax
  801f60:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f65:	ff 45 f4             	incl   -0xc(%ebp)
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f6e:	0f 8c 2c ff ff ff    	jl     801ea0 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f7b:	eb 36                	jmp    801fb3 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	c1 e0 04             	shl    $0x4,%eax
  801f83:	05 80 c0 81 00       	add    $0x81c080,%eax
  801f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f91:	c1 e0 04             	shl    $0x4,%eax
  801f94:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	c1 e0 04             	shl    $0x4,%eax
  801fa5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801faa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fb0:	ff 45 f0             	incl   -0x10(%ebp)
  801fb3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801fb7:	7e c4                	jle    801f7d <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801fb9:	90                   	nop
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	50                   	push   %eax
  801fc9:	e8 0b fe ff ff       	call   801dd9 <to_page_info>
  801fce:	83 c4 10             	add    $0x10,%esp
  801fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 40 08             	mov    0x8(%eax),%eax
  801fda:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	e8 77 fd ff ff       	call   801d67 <to_page_va>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801ff6:	b8 00 10 00 00       	mov    $0x1000,%eax
  801ffb:	ba 00 00 00 00       	mov    $0x0,%edx
  802000:	f7 75 08             	divl   0x8(%ebp)
  802003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	50                   	push   %eax
  80200d:	e8 48 f6 ff ff       	call   80165a <get_page>
  802012:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	8b 55 0c             	mov    0xc(%ebp),%edx
  802025:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802029:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802030:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802037:	eb 19                	jmp    802052 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203c:	ba 01 00 00 00       	mov    $0x1,%edx
  802041:	88 c1                	mov    %al,%cl
  802043:	d3 e2                	shl    %cl,%edx
  802045:	89 d0                	mov    %edx,%eax
  802047:	3b 45 08             	cmp    0x8(%ebp),%eax
  80204a:	74 0e                	je     80205a <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80204c:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80204f:	ff 45 f0             	incl   -0x10(%ebp)
  802052:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802056:	7e e1                	jle    802039 <split_page_to_blocks+0x5a>
  802058:	eb 01                	jmp    80205b <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80205a:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80205b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802062:	e9 a7 00 00 00       	jmp    80210e <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206a:	0f af 45 08          	imul   0x8(%ebp),%eax
  80206e:	89 c2                	mov    %eax,%edx
  802070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802073:	01 d0                	add    %edx,%eax
  802075:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802078:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80207c:	75 14                	jne    802092 <split_page_to_blocks+0xb3>
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	68 7c 34 80 00       	push   $0x80347c
  802086:	6a 7c                	push   $0x7c
  802088:	68 03 34 80 00       	push   $0x803403
  80208d:	e8 c1 e3 ff ff       	call   800453 <_panic>
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	c1 e0 04             	shl    $0x4,%eax
  802098:	05 84 c0 81 00       	add    $0x81c084,%eax
  80209d:	8b 10                	mov    (%eax),%edx
  80209f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a2:	89 50 04             	mov    %edx,0x4(%eax)
  8020a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a8:	8b 40 04             	mov    0x4(%eax),%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 14                	je     8020c3 <split_page_to_blocks+0xe4>
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	c1 e0 04             	shl    $0x4,%eax
  8020b5:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020bf:	89 10                	mov    %edx,(%eax)
  8020c1:	eb 11                	jmp    8020d4 <split_page_to_blocks+0xf5>
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	c1 e0 04             	shl    $0x4,%eax
  8020c9:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8020cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d2:	89 02                	mov    %eax,(%edx)
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	c1 e0 04             	shl    $0x4,%eax
  8020da:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8020e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e3:	89 02                	mov    %eax,(%edx)
  8020e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	c1 e0 04             	shl    $0x4,%eax
  8020f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	8d 50 01             	lea    0x1(%eax),%edx
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	c1 e0 04             	shl    $0x4,%eax
  802104:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802109:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80210b:	ff 45 ec             	incl   -0x14(%ebp)
  80210e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802111:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802114:	0f 82 4d ff ff ff    	jb     802067 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80211a:	90                   	nop
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802123:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80212a:	76 19                	jbe    802145 <alloc_block+0x28>
  80212c:	68 a0 34 80 00       	push   $0x8034a0
  802131:	68 66 34 80 00       	push   $0x803466
  802136:	68 8a 00 00 00       	push   $0x8a
  80213b:	68 03 34 80 00       	push   $0x803403
  802140:	e8 0e e3 ff ff       	call   800453 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802145:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80214c:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802153:	eb 19                	jmp    80216e <alloc_block+0x51>
		if((1 << i) >= size) break;
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	ba 01 00 00 00       	mov    $0x1,%edx
  80215d:	88 c1                	mov    %al,%cl
  80215f:	d3 e2                	shl    %cl,%edx
  802161:	89 d0                	mov    %edx,%eax
  802163:	3b 45 08             	cmp    0x8(%ebp),%eax
  802166:	73 0e                	jae    802176 <alloc_block+0x59>
		idx++;
  802168:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80216b:	ff 45 f0             	incl   -0x10(%ebp)
  80216e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802172:	7e e1                	jle    802155 <alloc_block+0x38>
  802174:	eb 01                	jmp    802177 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802176:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	c1 e0 04             	shl    $0x4,%eax
  80217d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	0f 84 df 00 00 00    	je     80226b <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	c1 e0 04             	shl    $0x4,%eax
  802192:	05 80 c0 81 00       	add    $0x81c080,%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80219c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a0:	75 17                	jne    8021b9 <alloc_block+0x9c>
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 c1 34 80 00       	push   $0x8034c1
  8021aa:	68 9e 00 00 00       	push   $0x9e
  8021af:	68 03 34 80 00       	push   $0x803403
  8021b4:	e8 9a e2 ff ff       	call   800453 <_panic>
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	74 10                	je     8021d2 <alloc_block+0xb5>
  8021c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ca:	8b 52 04             	mov    0x4(%edx),%edx
  8021cd:	89 50 04             	mov    %edx,0x4(%eax)
  8021d0:	eb 14                	jmp    8021e6 <alloc_block+0xc9>
  8021d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d5:	8b 40 04             	mov    0x4(%eax),%eax
  8021d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021db:	c1 e2 04             	shl    $0x4,%edx
  8021de:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8021e4:	89 02                	mov    %eax,(%edx)
  8021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 0f                	je     8021ff <alloc_block+0xe2>
  8021f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f3:	8b 40 04             	mov    0x4(%eax),%eax
  8021f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f9:	8b 12                	mov    (%edx),%edx
  8021fb:	89 10                	mov    %edx,(%eax)
  8021fd:	eb 13                	jmp    802212 <alloc_block+0xf5>
  8021ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802207:	c1 e2 04             	shl    $0x4,%edx
  80220a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802210:	89 02                	mov    %eax,(%edx)
  802212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802215:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	c1 e0 04             	shl    $0x4,%eax
  80222b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	8d 50 ff             	lea    -0x1(%eax),%edx
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	c1 e0 04             	shl    $0x4,%eax
  80223b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802240:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	83 ec 0c             	sub    $0xc,%esp
  802248:	50                   	push   %eax
  802249:	e8 8b fb ff ff       	call   801dd9 <to_page_info>
  80224e:	83 c4 10             	add    $0x10,%esp
  802251:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802257:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80225b:	48                   	dec    %eax
  80225c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80225f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802266:	e9 bc 02 00 00       	jmp    802527 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80226b:	a1 54 40 80 00       	mov    0x804054,%eax
  802270:	85 c0                	test   %eax,%eax
  802272:	0f 84 7d 02 00 00    	je     8024f5 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802278:	a1 48 40 80 00       	mov    0x804048,%eax
  80227d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802280:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802284:	75 17                	jne    80229d <alloc_block+0x180>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 c1 34 80 00       	push   $0x8034c1
  80228e:	68 a9 00 00 00       	push   $0xa9
  802293:	68 03 34 80 00       	push   $0x803403
  802298:	e8 b6 e1 ff ff       	call   800453 <_panic>
  80229d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 10                	je     8022b6 <alloc_block+0x199>
  8022a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a9:	8b 00                	mov    (%eax),%eax
  8022ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022ae:	8b 52 04             	mov    0x4(%edx),%edx
  8022b1:	89 50 04             	mov    %edx,0x4(%eax)
  8022b4:	eb 0b                	jmp    8022c1 <alloc_block+0x1a4>
  8022b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b9:	8b 40 04             	mov    0x4(%eax),%eax
  8022bc:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c4:	8b 40 04             	mov    0x4(%eax),%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	74 0f                	je     8022da <alloc_block+0x1bd>
  8022cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ce:	8b 40 04             	mov    0x4(%eax),%eax
  8022d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022d4:	8b 12                	mov    (%edx),%edx
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	eb 0a                	jmp    8022e4 <alloc_block+0x1c7>
  8022da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022dd:	8b 00                	mov    (%eax),%eax
  8022df:	a3 48 40 80 00       	mov    %eax,0x804048
  8022e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f7:	a1 54 40 80 00       	mov    0x804054,%eax
  8022fc:	48                   	dec    %eax
  8022fd:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	83 c0 03             	add    $0x3,%eax
  802308:	ba 01 00 00 00       	mov    $0x1,%edx
  80230d:	88 c1                	mov    %al,%cl
  80230f:	d3 e2                	shl    %cl,%edx
  802311:	89 d0                	mov    %edx,%eax
  802313:	83 ec 08             	sub    $0x8,%esp
  802316:	ff 75 e4             	pushl  -0x1c(%ebp)
  802319:	50                   	push   %eax
  80231a:	e8 c0 fc ff ff       	call   801fdf <split_page_to_blocks>
  80231f:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	c1 e0 04             	shl    $0x4,%eax
  802328:	05 80 c0 81 00       	add    $0x81c080,%eax
  80232d:	8b 00                	mov    (%eax),%eax
  80232f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802332:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802336:	75 17                	jne    80234f <alloc_block+0x232>
  802338:	83 ec 04             	sub    $0x4,%esp
  80233b:	68 c1 34 80 00       	push   $0x8034c1
  802340:	68 b0 00 00 00       	push   $0xb0
  802345:	68 03 34 80 00       	push   $0x803403
  80234a:	e8 04 e1 ff ff       	call   800453 <_panic>
  80234f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 10                	je     802368 <alloc_block+0x24b>
  802358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802360:	8b 52 04             	mov    0x4(%edx),%edx
  802363:	89 50 04             	mov    %edx,0x4(%eax)
  802366:	eb 14                	jmp    80237c <alloc_block+0x25f>
  802368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802371:	c1 e2 04             	shl    $0x4,%edx
  802374:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80237a:	89 02                	mov    %eax,(%edx)
  80237c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237f:	8b 40 04             	mov    0x4(%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0f                	je     802395 <alloc_block+0x278>
  802386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80238f:	8b 12                	mov    (%edx),%edx
  802391:	89 10                	mov    %edx,(%eax)
  802393:	eb 13                	jmp    8023a8 <alloc_block+0x28b>
  802395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	c1 e2 04             	shl    $0x4,%edx
  8023a0:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023a6:	89 02                	mov    %eax,(%edx)
  8023a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	c1 e0 04             	shl    $0x4,%eax
  8023c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	c1 e0 04             	shl    $0x4,%eax
  8023d1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023d6:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023db:	83 ec 0c             	sub    $0xc,%esp
  8023de:	50                   	push   %eax
  8023df:	e8 f5 f9 ff ff       	call   801dd9 <to_page_info>
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8023ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023ed:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023f1:	48                   	dec    %eax
  8023f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023f5:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8023f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fc:	e9 26 01 00 00       	jmp    802527 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802401:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	c1 e0 04             	shl    $0x4,%eax
  80240a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	0f 84 dc 00 00 00    	je     8024f5 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	c1 e0 04             	shl    $0x4,%eax
  80241f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802429:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80242d:	75 17                	jne    802446 <alloc_block+0x329>
  80242f:	83 ec 04             	sub    $0x4,%esp
  802432:	68 c1 34 80 00       	push   $0x8034c1
  802437:	68 be 00 00 00       	push   $0xbe
  80243c:	68 03 34 80 00       	push   $0x803403
  802441:	e8 0d e0 ff ff       	call   800453 <_panic>
  802446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 10                	je     80245f <alloc_block+0x342>
  80244f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802457:	8b 52 04             	mov    0x4(%edx),%edx
  80245a:	89 50 04             	mov    %edx,0x4(%eax)
  80245d:	eb 14                	jmp    802473 <alloc_block+0x356>
  80245f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802468:	c1 e2 04             	shl    $0x4,%edx
  80246b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802471:	89 02                	mov    %eax,(%edx)
  802473:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802476:	8b 40 04             	mov    0x4(%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 0f                	je     80248c <alloc_block+0x36f>
  80247d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802486:	8b 12                	mov    (%edx),%edx
  802488:	89 10                	mov    %edx,(%eax)
  80248a:	eb 13                	jmp    80249f <alloc_block+0x382>
  80248c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802494:	c1 e2 04             	shl    $0x4,%edx
  802497:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80249d:	89 02                	mov    %eax,(%edx)
  80249f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	c1 e0 04             	shl    $0x4,%eax
  8024b8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	c1 e0 04             	shl    $0x4,%eax
  8024c8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024cd:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8024cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	50                   	push   %eax
  8024d6:	e8 fe f8 ff ff       	call   801dd9 <to_page_info>
  8024db:	83 c4 10             	add    $0x10,%esp
  8024de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8024e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024e4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024e8:	48                   	dec    %eax
  8024e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024ec:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8024f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f3:	eb 32                	jmp    802527 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8024f5:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8024f9:	77 15                	ja     802510 <alloc_block+0x3f3>
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	c1 e0 04             	shl    $0x4,%eax
  802501:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	0f 84 f1 fe ff ff    	je     802401 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 df 34 80 00       	push   $0x8034df
  802518:	68 c8 00 00 00       	push   $0xc8
  80251d:	68 03 34 80 00       	push   $0x803403
  802522:	e8 2c df ff ff       	call   800453 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
  80252c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80252f:	8b 55 08             	mov    0x8(%ebp),%edx
  802532:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802537:	39 c2                	cmp    %eax,%edx
  802539:	72 0c                	jb     802547 <free_block+0x1e>
  80253b:	8b 55 08             	mov    0x8(%ebp),%edx
  80253e:	a1 40 40 80 00       	mov    0x804040,%eax
  802543:	39 c2                	cmp    %eax,%edx
  802545:	72 19                	jb     802560 <free_block+0x37>
  802547:	68 f0 34 80 00       	push   $0x8034f0
  80254c:	68 66 34 80 00       	push   $0x803466
  802551:	68 d7 00 00 00       	push   $0xd7
  802556:	68 03 34 80 00       	push   $0x803403
  80255b:	e8 f3 de ff ff       	call   800453 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	50                   	push   %eax
  80256d:	e8 67 f8 ff ff       	call   801dd9 <to_page_info>
  802572:	83 c4 10             	add    $0x10,%esp
  802575:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257b:	8b 40 08             	mov    0x8(%eax),%eax
  80257e:	0f b7 c0             	movzwl %ax,%eax
  802581:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80258b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802592:	eb 19                	jmp    8025ad <free_block+0x84>
	    if ((1 << i) == blk_size)
  802594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802597:	ba 01 00 00 00       	mov    $0x1,%edx
  80259c:	88 c1                	mov    %al,%cl
  80259e:	d3 e2                	shl    %cl,%edx
  8025a0:	89 d0                	mov    %edx,%eax
  8025a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025a5:	74 0e                	je     8025b5 <free_block+0x8c>
	        break;
	    idx++;
  8025a7:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025aa:	ff 45 f0             	incl   -0x10(%ebp)
  8025ad:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025b1:	7e e1                	jle    802594 <free_block+0x6b>
  8025b3:	eb 01                	jmp    8025b6 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025b5:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025bd:	40                   	inc    %eax
  8025be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c1:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8025c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025c9:	75 17                	jne    8025e2 <free_block+0xb9>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 7c 34 80 00       	push   $0x80347c
  8025d3:	68 ee 00 00 00       	push   $0xee
  8025d8:	68 03 34 80 00       	push   $0x803403
  8025dd:	e8 71 de ff ff       	call   800453 <_panic>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	c1 e0 04             	shl    $0x4,%eax
  8025e8:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025ed:	8b 10                	mov    (%eax),%edx
  8025ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f2:	89 50 04             	mov    %edx,0x4(%eax)
  8025f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 14                	je     802613 <free_block+0xea>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c1 e0 04             	shl    $0x4,%eax
  802605:	05 84 c0 81 00       	add    $0x81c084,%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80260f:	89 10                	mov    %edx,(%eax)
  802611:	eb 11                	jmp    802624 <free_block+0xfb>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	c1 e0 04             	shl    $0x4,%eax
  802619:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80261f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802622:	89 02                	mov    %eax,(%edx)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	c1 e0 04             	shl    $0x4,%eax
  80262a:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802633:	89 02                	mov    %eax,(%edx)
  802635:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802638:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	c1 e0 04             	shl    $0x4,%eax
  802644:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	8d 50 01             	lea    0x1(%eax),%edx
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c1 e0 04             	shl    $0x4,%eax
  802654:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802659:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80265b:	b8 00 10 00 00       	mov    $0x1000,%eax
  802660:	ba 00 00 00 00       	mov    $0x0,%edx
  802665:	f7 75 e0             	divl   -0x20(%ebp)
  802668:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80266b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802672:	0f b7 c0             	movzwl %ax,%eax
  802675:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802678:	0f 85 70 01 00 00    	jne    8027ee <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	ff 75 e4             	pushl  -0x1c(%ebp)
  802684:	e8 de f6 ff ff       	call   801d67 <to_page_va>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80268f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802696:	e9 b7 00 00 00       	jmp    802752 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  80269b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026aa:	75 17                	jne    8026c3 <free_block+0x19a>
  8026ac:	83 ec 04             	sub    $0x4,%esp
  8026af:	68 c1 34 80 00       	push   $0x8034c1
  8026b4:	68 f8 00 00 00       	push   $0xf8
  8026b9:	68 03 34 80 00       	push   $0x803403
  8026be:	e8 90 dd ff ff       	call   800453 <_panic>
  8026c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	74 10                	je     8026dc <free_block+0x1b3>
  8026cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026d4:	8b 52 04             	mov    0x4(%edx),%edx
  8026d7:	89 50 04             	mov    %edx,0x4(%eax)
  8026da:	eb 14                	jmp    8026f0 <free_block+0x1c7>
  8026dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	c1 e2 04             	shl    $0x4,%edx
  8026e8:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026ee:	89 02                	mov    %eax,(%edx)
  8026f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f3:	8b 40 04             	mov    0x4(%eax),%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	74 0f                	je     802709 <free_block+0x1e0>
  8026fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026fd:	8b 40 04             	mov    0x4(%eax),%eax
  802700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802703:	8b 12                	mov    (%edx),%edx
  802705:	89 10                	mov    %edx,(%eax)
  802707:	eb 13                	jmp    80271c <free_block+0x1f3>
  802709:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802711:	c1 e2 04             	shl    $0x4,%edx
  802714:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80271a:	89 02                	mov    %eax,(%edx)
  80271c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80271f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802725:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802728:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	c1 e0 04             	shl    $0x4,%eax
  802735:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	c1 e0 04             	shl    $0x4,%eax
  802745:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80274a:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	01 45 ec             	add    %eax,-0x14(%ebp)
  802752:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802759:	0f 86 3c ff ff ff    	jbe    80269b <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80275f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802762:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802771:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802775:	75 17                	jne    80278e <free_block+0x265>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 7c 34 80 00       	push   $0x80347c
  80277f:	68 fe 00 00 00       	push   $0xfe
  802784:	68 03 34 80 00       	push   $0x803403
  802789:	e8 c5 dc ff ff       	call   800453 <_panic>
  80278e:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	89 50 04             	mov    %edx,0x4(%eax)
  80279a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 0c                	je     8027b0 <free_block+0x287>
  8027a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ac:	89 10                	mov    %edx,(%eax)
  8027ae:	eb 08                	jmp    8027b8 <free_block+0x28f>
  8027b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b3:	a3 48 40 80 00       	mov    %eax,0x804048
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c9:	a1 54 40 80 00       	mov    0x804054,%eax
  8027ce:	40                   	inc    %eax
  8027cf:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8027d4:	83 ec 0c             	sub    $0xc,%esp
  8027d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027da:	e8 88 f5 ff ff       	call   801d67 <to_page_va>
  8027df:	83 c4 10             	add    $0x10,%esp
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	50                   	push   %eax
  8027e6:	e8 b8 ee ff ff       	call   8016a3 <return_page>
  8027eb:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8027ee:	90                   	nop
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 28 35 80 00       	push   $0x803528
  8027ff:	68 11 01 00 00       	push   $0x111
  802804:	68 03 34 80 00       	push   $0x803403
  802809:	e8 45 dc ff ff       	call   800453 <_panic>
  80280e:	66 90                	xchg   %ax,%ax

00802810 <__udivdi3>:
  802810:	55                   	push   %ebp
  802811:	57                   	push   %edi
  802812:	56                   	push   %esi
  802813:	53                   	push   %ebx
  802814:	83 ec 1c             	sub    $0x1c,%esp
  802817:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80281b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80281f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802823:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802827:	89 ca                	mov    %ecx,%edx
  802829:	89 f8                	mov    %edi,%eax
  80282b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80282f:	85 f6                	test   %esi,%esi
  802831:	75 2d                	jne    802860 <__udivdi3+0x50>
  802833:	39 cf                	cmp    %ecx,%edi
  802835:	77 65                	ja     80289c <__udivdi3+0x8c>
  802837:	89 fd                	mov    %edi,%ebp
  802839:	85 ff                	test   %edi,%edi
  80283b:	75 0b                	jne    802848 <__udivdi3+0x38>
  80283d:	b8 01 00 00 00       	mov    $0x1,%eax
  802842:	31 d2                	xor    %edx,%edx
  802844:	f7 f7                	div    %edi
  802846:	89 c5                	mov    %eax,%ebp
  802848:	31 d2                	xor    %edx,%edx
  80284a:	89 c8                	mov    %ecx,%eax
  80284c:	f7 f5                	div    %ebp
  80284e:	89 c1                	mov    %eax,%ecx
  802850:	89 d8                	mov    %ebx,%eax
  802852:	f7 f5                	div    %ebp
  802854:	89 cf                	mov    %ecx,%edi
  802856:	89 fa                	mov    %edi,%edx
  802858:	83 c4 1c             	add    $0x1c,%esp
  80285b:	5b                   	pop    %ebx
  80285c:	5e                   	pop    %esi
  80285d:	5f                   	pop    %edi
  80285e:	5d                   	pop    %ebp
  80285f:	c3                   	ret    
  802860:	39 ce                	cmp    %ecx,%esi
  802862:	77 28                	ja     80288c <__udivdi3+0x7c>
  802864:	0f bd fe             	bsr    %esi,%edi
  802867:	83 f7 1f             	xor    $0x1f,%edi
  80286a:	75 40                	jne    8028ac <__udivdi3+0x9c>
  80286c:	39 ce                	cmp    %ecx,%esi
  80286e:	72 0a                	jb     80287a <__udivdi3+0x6a>
  802870:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802874:	0f 87 9e 00 00 00    	ja     802918 <__udivdi3+0x108>
  80287a:	b8 01 00 00 00       	mov    $0x1,%eax
  80287f:	89 fa                	mov    %edi,%edx
  802881:	83 c4 1c             	add    $0x1c,%esp
  802884:	5b                   	pop    %ebx
  802885:	5e                   	pop    %esi
  802886:	5f                   	pop    %edi
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    
  802889:	8d 76 00             	lea    0x0(%esi),%esi
  80288c:	31 ff                	xor    %edi,%edi
  80288e:	31 c0                	xor    %eax,%eax
  802890:	89 fa                	mov    %edi,%edx
  802892:	83 c4 1c             	add    $0x1c,%esp
  802895:	5b                   	pop    %ebx
  802896:	5e                   	pop    %esi
  802897:	5f                   	pop    %edi
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	89 d8                	mov    %ebx,%eax
  80289e:	f7 f7                	div    %edi
  8028a0:	31 ff                	xor    %edi,%edi
  8028a2:	89 fa                	mov    %edi,%edx
  8028a4:	83 c4 1c             	add    $0x1c,%esp
  8028a7:	5b                   	pop    %ebx
  8028a8:	5e                   	pop    %esi
  8028a9:	5f                   	pop    %edi
  8028aa:	5d                   	pop    %ebp
  8028ab:	c3                   	ret    
  8028ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028b1:	89 eb                	mov    %ebp,%ebx
  8028b3:	29 fb                	sub    %edi,%ebx
  8028b5:	89 f9                	mov    %edi,%ecx
  8028b7:	d3 e6                	shl    %cl,%esi
  8028b9:	89 c5                	mov    %eax,%ebp
  8028bb:	88 d9                	mov    %bl,%cl
  8028bd:	d3 ed                	shr    %cl,%ebp
  8028bf:	89 e9                	mov    %ebp,%ecx
  8028c1:	09 f1                	or     %esi,%ecx
  8028c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8028c7:	89 f9                	mov    %edi,%ecx
  8028c9:	d3 e0                	shl    %cl,%eax
  8028cb:	89 c5                	mov    %eax,%ebp
  8028cd:	89 d6                	mov    %edx,%esi
  8028cf:	88 d9                	mov    %bl,%cl
  8028d1:	d3 ee                	shr    %cl,%esi
  8028d3:	89 f9                	mov    %edi,%ecx
  8028d5:	d3 e2                	shl    %cl,%edx
  8028d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028db:	88 d9                	mov    %bl,%cl
  8028dd:	d3 e8                	shr    %cl,%eax
  8028df:	09 c2                	or     %eax,%edx
  8028e1:	89 d0                	mov    %edx,%eax
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	f7 74 24 0c          	divl   0xc(%esp)
  8028e9:	89 d6                	mov    %edx,%esi
  8028eb:	89 c3                	mov    %eax,%ebx
  8028ed:	f7 e5                	mul    %ebp
  8028ef:	39 d6                	cmp    %edx,%esi
  8028f1:	72 19                	jb     80290c <__udivdi3+0xfc>
  8028f3:	74 0b                	je     802900 <__udivdi3+0xf0>
  8028f5:	89 d8                	mov    %ebx,%eax
  8028f7:	31 ff                	xor    %edi,%edi
  8028f9:	e9 58 ff ff ff       	jmp    802856 <__udivdi3+0x46>
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	8b 54 24 08          	mov    0x8(%esp),%edx
  802904:	89 f9                	mov    %edi,%ecx
  802906:	d3 e2                	shl    %cl,%edx
  802908:	39 c2                	cmp    %eax,%edx
  80290a:	73 e9                	jae    8028f5 <__udivdi3+0xe5>
  80290c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80290f:	31 ff                	xor    %edi,%edi
  802911:	e9 40 ff ff ff       	jmp    802856 <__udivdi3+0x46>
  802916:	66 90                	xchg   %ax,%ax
  802918:	31 c0                	xor    %eax,%eax
  80291a:	e9 37 ff ff ff       	jmp    802856 <__udivdi3+0x46>
  80291f:	90                   	nop

00802920 <__umoddi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	53                   	push   %ebx
  802924:	83 ec 1c             	sub    $0x1c,%esp
  802927:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80292b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80292f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802933:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802937:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80293b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80293f:	89 f3                	mov    %esi,%ebx
  802941:	89 fa                	mov    %edi,%edx
  802943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802947:	89 34 24             	mov    %esi,(%esp)
  80294a:	85 c0                	test   %eax,%eax
  80294c:	75 1a                	jne    802968 <__umoddi3+0x48>
  80294e:	39 f7                	cmp    %esi,%edi
  802950:	0f 86 a2 00 00 00    	jbe    8029f8 <__umoddi3+0xd8>
  802956:	89 c8                	mov    %ecx,%eax
  802958:	89 f2                	mov    %esi,%edx
  80295a:	f7 f7                	div    %edi
  80295c:	89 d0                	mov    %edx,%eax
  80295e:	31 d2                	xor    %edx,%edx
  802960:	83 c4 1c             	add    $0x1c,%esp
  802963:	5b                   	pop    %ebx
  802964:	5e                   	pop    %esi
  802965:	5f                   	pop    %edi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    
  802968:	39 f0                	cmp    %esi,%eax
  80296a:	0f 87 ac 00 00 00    	ja     802a1c <__umoddi3+0xfc>
  802970:	0f bd e8             	bsr    %eax,%ebp
  802973:	83 f5 1f             	xor    $0x1f,%ebp
  802976:	0f 84 ac 00 00 00    	je     802a28 <__umoddi3+0x108>
  80297c:	bf 20 00 00 00       	mov    $0x20,%edi
  802981:	29 ef                	sub    %ebp,%edi
  802983:	89 fe                	mov    %edi,%esi
  802985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802989:	89 e9                	mov    %ebp,%ecx
  80298b:	d3 e0                	shl    %cl,%eax
  80298d:	89 d7                	mov    %edx,%edi
  80298f:	89 f1                	mov    %esi,%ecx
  802991:	d3 ef                	shr    %cl,%edi
  802993:	09 c7                	or     %eax,%edi
  802995:	89 e9                	mov    %ebp,%ecx
  802997:	d3 e2                	shl    %cl,%edx
  802999:	89 14 24             	mov    %edx,(%esp)
  80299c:	89 d8                	mov    %ebx,%eax
  80299e:	d3 e0                	shl    %cl,%eax
  8029a0:	89 c2                	mov    %eax,%edx
  8029a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029a6:	d3 e0                	shl    %cl,%eax
  8029a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029b0:	89 f1                	mov    %esi,%ecx
  8029b2:	d3 e8                	shr    %cl,%eax
  8029b4:	09 d0                	or     %edx,%eax
  8029b6:	d3 eb                	shr    %cl,%ebx
  8029b8:	89 da                	mov    %ebx,%edx
  8029ba:	f7 f7                	div    %edi
  8029bc:	89 d3                	mov    %edx,%ebx
  8029be:	f7 24 24             	mull   (%esp)
  8029c1:	89 c6                	mov    %eax,%esi
  8029c3:	89 d1                	mov    %edx,%ecx
  8029c5:	39 d3                	cmp    %edx,%ebx
  8029c7:	0f 82 87 00 00 00    	jb     802a54 <__umoddi3+0x134>
  8029cd:	0f 84 91 00 00 00    	je     802a64 <__umoddi3+0x144>
  8029d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029d7:	29 f2                	sub    %esi,%edx
  8029d9:	19 cb                	sbb    %ecx,%ebx
  8029db:	89 d8                	mov    %ebx,%eax
  8029dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8029e1:	d3 e0                	shl    %cl,%eax
  8029e3:	89 e9                	mov    %ebp,%ecx
  8029e5:	d3 ea                	shr    %cl,%edx
  8029e7:	09 d0                	or     %edx,%eax
  8029e9:	89 e9                	mov    %ebp,%ecx
  8029eb:	d3 eb                	shr    %cl,%ebx
  8029ed:	89 da                	mov    %ebx,%edx
  8029ef:	83 c4 1c             	add    $0x1c,%esp
  8029f2:	5b                   	pop    %ebx
  8029f3:	5e                   	pop    %esi
  8029f4:	5f                   	pop    %edi
  8029f5:	5d                   	pop    %ebp
  8029f6:	c3                   	ret    
  8029f7:	90                   	nop
  8029f8:	89 fd                	mov    %edi,%ebp
  8029fa:	85 ff                	test   %edi,%edi
  8029fc:	75 0b                	jne    802a09 <__umoddi3+0xe9>
  8029fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802a03:	31 d2                	xor    %edx,%edx
  802a05:	f7 f7                	div    %edi
  802a07:	89 c5                	mov    %eax,%ebp
  802a09:	89 f0                	mov    %esi,%eax
  802a0b:	31 d2                	xor    %edx,%edx
  802a0d:	f7 f5                	div    %ebp
  802a0f:	89 c8                	mov    %ecx,%eax
  802a11:	f7 f5                	div    %ebp
  802a13:	89 d0                	mov    %edx,%eax
  802a15:	e9 44 ff ff ff       	jmp    80295e <__umoddi3+0x3e>
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	89 c8                	mov    %ecx,%eax
  802a1e:	89 f2                	mov    %esi,%edx
  802a20:	83 c4 1c             	add    $0x1c,%esp
  802a23:	5b                   	pop    %ebx
  802a24:	5e                   	pop    %esi
  802a25:	5f                   	pop    %edi
  802a26:	5d                   	pop    %ebp
  802a27:	c3                   	ret    
  802a28:	3b 04 24             	cmp    (%esp),%eax
  802a2b:	72 06                	jb     802a33 <__umoddi3+0x113>
  802a2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a31:	77 0f                	ja     802a42 <__umoddi3+0x122>
  802a33:	89 f2                	mov    %esi,%edx
  802a35:	29 f9                	sub    %edi,%ecx
  802a37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a3b:	89 14 24             	mov    %edx,(%esp)
  802a3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a42:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a46:	8b 14 24             	mov    (%esp),%edx
  802a49:	83 c4 1c             	add    $0x1c,%esp
  802a4c:	5b                   	pop    %ebx
  802a4d:	5e                   	pop    %esi
  802a4e:	5f                   	pop    %edi
  802a4f:	5d                   	pop    %ebp
  802a50:	c3                   	ret    
  802a51:	8d 76 00             	lea    0x0(%esi),%esi
  802a54:	2b 04 24             	sub    (%esp),%eax
  802a57:	19 fa                	sbb    %edi,%edx
  802a59:	89 d1                	mov    %edx,%ecx
  802a5b:	89 c6                	mov    %eax,%esi
  802a5d:	e9 71 ff ff ff       	jmp    8029d3 <__umoddi3+0xb3>
  802a62:	66 90                	xchg   %ax,%ax
  802a64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a68:	72 ea                	jb     802a54 <__umoddi3+0x134>
  802a6a:	89 d9                	mov    %ebx,%ecx
  802a6c:	e9 62 ff ff ff       	jmp    8029d3 <__umoddi3+0xb3>
