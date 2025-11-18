
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 d5 03 00 00       	call   80040b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 00    	sub    $0xac,%esp
//#else
//	panic("make sure to enable the kernel heap: USE_KHEAP=1");
//#endif
//	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800044:	c7 45 e4 00 10 00 82 	movl   $0x82001000,-0x1c(%ebp)
	uint32 *x, *y, *z ;
	int diff, expected;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80004b:	e8 09 1a 00 00       	call   801a59 <sys_calculate_free_frames>
  800050:	89 45 e0             	mov    %eax,-0x20(%ebp)
	x = smalloc("x", 4, 0);
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	6a 00                	push   $0x0
  800058:	6a 04                	push   $0x4
  80005a:	68 c0 2c 80 00       	push   $0x802cc0
  80005f:	e8 44 18 00 00       	call   8018a8 <smalloc>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)pagealloc_start) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80006a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80006d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  800070:	74 14                	je     800086 <_main+0x4e>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 c4 2c 80 00       	push   $0x802cc4
  80007a:	6a 1a                	push   $0x1a
  80007c:	68 27 2d 80 00       	push   $0x802d27
  800081:	e8 4a 05 00 00       	call   8005d0 <_panic>
	expected = 1+1 ; /*1page +1table*/
  800086:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80008d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800090:	e8 c4 19 00 00       	call   801a59 <sys_calculate_free_frames>
  800095:	29 c3                	sub    %eax,%ebx
  800097:	89 d8                	mov    %ebx,%eax
  800099:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80009c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80009f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000a2:	7c 0b                	jl     8000af <_main+0x77>
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	83 c0 02             	add    $0x2,%eax
  8000aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8000ad:	7d 24                	jge    8000d3 <_main+0x9b>
  8000af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000b2:	e8 a2 19 00 00       	call   801a59 <sys_calculate_free_frames>
  8000b7:	29 c3                	sub    %eax,%ebx
  8000b9:	89 d8                	mov    %ebx,%eax
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	ff 75 d8             	pushl  -0x28(%ebp)
  8000c1:	50                   	push   %eax
  8000c2:	68 48 2d 80 00       	push   $0x802d48
  8000c7:	6a 1d                	push   $0x1d
  8000c9:	68 27 2d 80 00       	push   $0x802d27
  8000ce:	e8 fd 04 00 00       	call   8005d0 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  8000d3:	e8 81 19 00 00       	call   801a59 <sys_calculate_free_frames>
  8000d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	y = smalloc("y", 4, 0);
  8000db:	83 ec 04             	sub    $0x4,%esp
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 04                	push   $0x4
  8000e2:	68 e0 2d 80 00       	push   $0x802de0
  8000e7:	e8 bc 17 00 00       	call   8018a8 <smalloc>
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (y != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  8000f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f5:	05 00 10 00 00       	add    $0x1000,%eax
  8000fa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8000fd:	74 14                	je     800113 <_main+0xdb>
  8000ff:	83 ec 04             	sub    $0x4,%esp
  800102:	68 c4 2c 80 00       	push   $0x802cc4
  800107:	6a 22                	push   $0x22
  800109:	68 27 2d 80 00       	push   $0x802d27
  80010e:	e8 bd 04 00 00       	call   8005d0 <_panic>
	expected = 1 ; /*1page*/
  800113:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  80011a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80011d:	e8 37 19 00 00       	call   801a59 <sys_calculate_free_frames>
  800122:	29 c3                	sub    %eax,%ebx
  800124:	89 d8                	mov    %ebx,%eax
  800126:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  800129:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80012f:	7c 0b                	jl     80013c <_main+0x104>
  800131:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800134:	83 c0 02             	add    $0x2,%eax
  800137:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80013a:	7d 24                	jge    800160 <_main+0x128>
  80013c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80013f:	e8 15 19 00 00       	call   801a59 <sys_calculate_free_frames>
  800144:	29 c3                	sub    %eax,%ebx
  800146:	89 d8                	mov    %ebx,%eax
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	ff 75 d8             	pushl  -0x28(%ebp)
  80014e:	50                   	push   %eax
  80014f:	68 48 2d 80 00       	push   $0x802d48
  800154:	6a 25                	push   $0x25
  800156:	68 27 2d 80 00       	push   $0x802d27
  80015b:	e8 70 04 00 00       	call   8005d0 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800160:	e8 f4 18 00 00       	call   801a59 <sys_calculate_free_frames>
  800165:	89 45 e0             	mov    %eax,-0x20(%ebp)
	z = smalloc("z", 4, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	6a 04                	push   $0x4
  80016f:	68 e2 2d 80 00       	push   $0x802de2
  800174:	e8 2f 17 00 00       	call   8018a8 <smalloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	if (z != (uint32*)(pagealloc_start + 2 * PAGE_SIZE)) {panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");}
  80017f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800182:	05 00 20 00 00       	add    $0x2000,%eax
  800187:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  80018a:	74 14                	je     8001a0 <_main+0x168>
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	68 c4 2c 80 00       	push   $0x802cc4
  800194:	6a 2a                	push   $0x2a
  800196:	68 27 2d 80 00       	push   $0x802d27
  80019b:	e8 30 04 00 00       	call   8005d0 <_panic>
	expected = 1 ; /*1page*/
  8001a0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
	diff = (freeFrames - sys_calculate_free_frames());
  8001a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001aa:	e8 aa 18 00 00       	call   801a59 <sys_calculate_free_frames>
  8001af:	29 c3                	sub    %eax,%ebx
  8001b1:	89 d8                	mov    %ebx,%eax
  8001b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001bc:	7c 0b                	jl     8001c9 <_main+0x191>
  8001be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001c1:	83 c0 02             	add    $0x2,%eax
  8001c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8001c7:	7d 24                	jge    8001ed <_main+0x1b5>
  8001c9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8001cc:	e8 88 18 00 00       	call   801a59 <sys_calculate_free_frames>
  8001d1:	29 c3                	sub    %eax,%ebx
  8001d3:	89 d8                	mov    %ebx,%eax
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001db:	50                   	push   %eax
  8001dc:	68 48 2d 80 00       	push   $0x802d48
  8001e1:	6a 2d                	push   $0x2d
  8001e3:	68 27 2d 80 00       	push   $0x802d27
  8001e8:	e8 e3 03 00 00       	call   8005d0 <_panic>

	*x = 10 ;
  8001ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001f0:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001f9:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	a1 20 40 80 00       	mov    0x804020,%eax
  800211:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800217:	6a 32                	push   $0x32
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 e4 2d 80 00       	push   $0x802de4
  800220:	e8 8f 19 00 00       	call   801bb4 <sys_create_env>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 45 c8             	mov    %eax,-0x38(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	a1 20 40 80 00       	mov    0x804020,%eax
  80023d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800243:	6a 32                	push   $0x32
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	68 e4 2d 80 00       	push   $0x802de4
  80024c:	e8 63 19 00 00       	call   801bb4 <sys_create_env>
  800251:	83 c4 10             	add    $0x10,%esp
  800254:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800257:	a1 20 40 80 00       	mov    0x804020,%eax
  80025c:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800262:	89 c2                	mov    %eax,%edx
  800264:	a1 20 40 80 00       	mov    0x804020,%eax
  800269:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80026f:	6a 32                	push   $0x32
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	68 e4 2d 80 00       	push   $0x802de4
  800278:	e8 37 19 00 00       	call   801bb4 <sys_create_env>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800283:	e8 78 1a 00 00       	call   801d00 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	6a 01                	push   $0x1
  80028d:	6a 04                	push   $0x4
  80028f:	68 f2 2d 80 00       	push   $0x802df2
  800294:	e8 0f 16 00 00       	call   8018a8 <smalloc>
  800299:	83 c4 10             	add    $0x10,%esp
  80029c:	89 45 bc             	mov    %eax,-0x44(%ebp)

	sys_run_env(id1);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	ff 75 c8             	pushl  -0x38(%ebp)
  8002a5:	e8 28 19 00 00       	call   801bd2 <sys_run_env>
  8002aa:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	ff 75 c4             	pushl  -0x3c(%ebp)
  8002b3:	e8 1a 19 00 00       	call   801bd2 <sys_run_env>
  8002b8:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	ff 75 c0             	pushl  -0x40(%ebp)
  8002c1:	e8 0c 19 00 00       	call   801bd2 <sys_run_env>
  8002c6:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002c9:	83 ec 0c             	sub    $0xc,%esp
  8002cc:	68 98 3a 00 00       	push   $0x3a98
  8002d1:	e8 b5 26 00 00       	call   80298b <env_sleep>
  8002d6:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	while (gettst()!=3) ; //panic("test failed");
  8002d9:	90                   	nop
  8002da:	e8 9b 1a 00 00       	call   801d7a <gettst>
  8002df:	83 f8 03             	cmp    $0x3,%eax
  8002e2:	75 f6                	jne    8002da <_main+0x2a2>


	if (*z != 30)
  8002e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002e7:	8b 00                	mov    (%eax),%eax
  8002e9:	83 f8 1e             	cmp    $0x1e,%eax
  8002ec:	74 14                	je     800302 <_main+0x2ca>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 04 2e 80 00       	push   $0x802e04
  8002f6:	6a 47                	push   $0x47
  8002f8:	68 27 2d 80 00       	push   $0x802d27
  8002fd:	e8 ce 02 00 00       	call   8005d0 <_panic>
	else
		cprintf("test sharing 2 [Create & Get] is finished. Now, it'll destroy its children...\n\n");
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	68 54 2e 80 00       	push   $0x802e54
  80030a:	e8 8f 05 00 00       	call   80089e <cprintf>
  80030f:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800312:	e8 24 19 00 00       	call   801c3b <sys_getparentenvid>
  800317:	85 c0                	test   %eax,%eax
  800319:	0f 8e e3 00 00 00    	jle    800402 <_main+0x3ca>
		//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
		//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
		//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
		//	2. changing the # free frames

		char changeIntCmd[100] = "__changeInterruptStatus__";
  80031f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800325:	bb 5a 2f 80 00       	mov    $0x802f5a,%ebx
  80032a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800337:	8d 95 6e ff ff ff    	lea    -0x92(%ebp),%edx
  80033d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800342:	b0 00                	mov    $0x0,%al
  800344:	89 d7                	mov    %edx,%edi
  800346:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(changeIntCmd, 0);
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	6a 00                	push   $0x0
  80034d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800353:	50                   	push   %eax
  800354:	e8 ff 1a 00 00       	call   801e58 <sys_utilities>
  800359:	83 c4 10             	add    $0x10,%esp
		{
			sys_destroy_env(id1);
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	ff 75 c8             	pushl  -0x38(%ebp)
  800362:	e8 87 18 00 00       	call   801bee <sys_destroy_env>
  800367:	83 c4 10             	add    $0x10,%esp
			cprintf("[1] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	68 a4 2e 80 00       	push   $0x802ea4
  800372:	e8 27 05 00 00       	call   80089e <cprintf>
  800377:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id2);
  80037a:	83 ec 0c             	sub    $0xc,%esp
  80037d:	ff 75 c4             	pushl  -0x3c(%ebp)
  800380:	e8 69 18 00 00       	call   801bee <sys_destroy_env>
  800385:	83 c4 10             	add    $0x10,%esp
			cprintf("[2] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 dc 2e 80 00       	push   $0x802edc
  800390:	e8 09 05 00 00       	call   80089e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(id3);
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	ff 75 c0             	pushl  -0x40(%ebp)
  80039e:	e8 4b 18 00 00       	call   801bee <sys_destroy_env>
  8003a3:	83 c4 10             	add    $0x10,%esp
			cprintf("[3] *****************************>>>>>>>>>>>>>>>>>>>>>\n");
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 14 2f 80 00       	push   $0x802f14
  8003ae:	e8 eb 04 00 00       	call   80089e <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
		}
		sys_utilities(changeIntCmd, 1);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	e8 91 1a 00 00       	call   801e58 <sys_utilities>
  8003c7:	83 c4 10             	add    $0x10,%esp

		int *finishedCount = NULL;
  8003ca:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  8003d1:	e8 65 18 00 00       	call   801c3b <sys_getparentenvid>
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	68 4c 2f 80 00       	push   $0x802f4c
  8003de:	50                   	push   %eax
  8003df:	e8 f8 14 00 00       	call   8018dc <sget>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		sys_lock_cons();
  8003ea:	e8 ba 15 00 00       	call   8019a9 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  8003ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	8d 50 01             	lea    0x1(%eax),%edx
  8003f7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8003fa:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  8003fc:	e8 c2 15 00 00       	call   8019c3 <sys_unlock_cons>
	}
	return;
  800401:	90                   	nop
  800402:	90                   	nop
}
  800403:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
  800411:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800414:	e8 09 18 00 00       	call   801c22 <sys_getenvindex>
  800419:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80041c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 06             	shl    $0x6,%eax
  800424:	29 d0                	sub    %edx,%eax
  800426:	c1 e0 02             	shl    $0x2,%eax
  800429:	01 d0                	add    %edx,%eax
  80042b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800432:	01 c8                	add    %ecx,%eax
  800434:	c1 e0 03             	shl    $0x3,%eax
  800437:	01 d0                	add    %edx,%eax
  800439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800440:	29 c2                	sub    %eax,%edx
  800442:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800449:	89 c2                	mov    %eax,%edx
  80044b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800451:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800456:	a1 20 40 80 00       	mov    0x804020,%eax
  80045b:	8a 40 20             	mov    0x20(%eax),%al
  80045e:	84 c0                	test   %al,%al
  800460:	74 0d                	je     80046f <libmain+0x64>
		binaryname = myEnv->prog_name;
  800462:	a1 20 40 80 00       	mov    0x804020,%eax
  800467:	83 c0 20             	add    $0x20,%eax
  80046a:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80046f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800473:	7e 0a                	jle    80047f <libmain+0x74>
		binaryname = argv[0];
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	ff 75 0c             	pushl  0xc(%ebp)
  800485:	ff 75 08             	pushl  0x8(%ebp)
  800488:	e8 ab fb ff ff       	call   800038 <_main>
  80048d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800490:	a1 00 40 80 00       	mov    0x804000,%eax
  800495:	85 c0                	test   %eax,%eax
  800497:	0f 84 01 01 00 00    	je     80059e <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80049d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004a3:	bb b8 30 80 00       	mov    $0x8030b8,%ebx
  8004a8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8004ad:	89 c7                	mov    %eax,%edi
  8004af:	89 de                	mov    %ebx,%esi
  8004b1:	89 d1                	mov    %edx,%ecx
  8004b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8004b5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8004b8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8004bd:	b0 00                	mov    $0x0,%al
  8004bf:	89 d7                	mov    %edx,%edi
  8004c1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8004c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8004ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8004cd:	83 ec 08             	sub    $0x8,%esp
  8004d0:	50                   	push   %eax
  8004d1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8004d7:	50                   	push   %eax
  8004d8:	e8 7b 19 00 00       	call   801e58 <sys_utilities>
  8004dd:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8004e0:	e8 c4 14 00 00       	call   8019a9 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8004e5:	83 ec 0c             	sub    $0xc,%esp
  8004e8:	68 d8 2f 80 00       	push   $0x802fd8
  8004ed:	e8 ac 03 00 00       	call   80089e <cprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8004f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f8:	85 c0                	test   %eax,%eax
  8004fa:	74 18                	je     800514 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8004fc:	e8 75 19 00 00       	call   801e76 <sys_get_optimal_num_faults>
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	50                   	push   %eax
  800505:	68 00 30 80 00       	push   $0x803000
  80050a:	e8 8f 03 00 00       	call   80089e <cprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	eb 59                	jmp    80056d <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800514:	a1 20 40 80 00       	mov    0x804020,%eax
  800519:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80052a:	83 ec 04             	sub    $0x4,%esp
  80052d:	52                   	push   %edx
  80052e:	50                   	push   %eax
  80052f:	68 24 30 80 00       	push   $0x803024
  800534:	e8 65 03 00 00       	call   80089e <cprintf>
  800539:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80053c:	a1 20 40 80 00       	mov    0x804020,%eax
  800541:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800547:	a1 20 40 80 00       	mov    0x804020,%eax
  80054c:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80055d:	51                   	push   %ecx
  80055e:	52                   	push   %edx
  80055f:	50                   	push   %eax
  800560:	68 4c 30 80 00       	push   $0x80304c
  800565:	e8 34 03 00 00       	call   80089e <cprintf>
  80056a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80056d:	a1 20 40 80 00       	mov    0x804020,%eax
  800572:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800578:	83 ec 08             	sub    $0x8,%esp
  80057b:	50                   	push   %eax
  80057c:	68 a4 30 80 00       	push   $0x8030a4
  800581:	e8 18 03 00 00       	call   80089e <cprintf>
  800586:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	68 d8 2f 80 00       	push   $0x802fd8
  800591:	e8 08 03 00 00       	call   80089e <cprintf>
  800596:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800599:	e8 25 14 00 00       	call   8019c3 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80059e:	e8 1f 00 00 00       	call   8005c2 <exit>
}
  8005a3:	90                   	nop
  8005a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005a7:	5b                   	pop    %ebx
  8005a8:	5e                   	pop    %esi
  8005a9:	5f                   	pop    %edi
  8005aa:	5d                   	pop    %ebp
  8005ab:	c3                   	ret    

008005ac <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8005ac:	55                   	push   %ebp
  8005ad:	89 e5                	mov    %esp,%ebp
  8005af:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8005b2:	83 ec 0c             	sub    $0xc,%esp
  8005b5:	6a 00                	push   $0x0
  8005b7:	e8 32 16 00 00       	call   801bee <sys_destroy_env>
  8005bc:	83 c4 10             	add    $0x10,%esp
}
  8005bf:	90                   	nop
  8005c0:	c9                   	leave  
  8005c1:	c3                   	ret    

008005c2 <exit>:

void
exit(void)
{
  8005c2:	55                   	push   %ebp
  8005c3:	89 e5                	mov    %esp,%ebp
  8005c5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005c8:	e8 87 16 00 00       	call   801c54 <sys_exit_env>
}
  8005cd:	90                   	nop
  8005ce:	c9                   	leave  
  8005cf:	c3                   	ret    

008005d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8005d9:	83 c0 04             	add    $0x4,%eax
  8005dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005df:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8005e4:	85 c0                	test   %eax,%eax
  8005e6:	74 16                	je     8005fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005e8:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	50                   	push   %eax
  8005f1:	68 1c 31 80 00       	push   $0x80311c
  8005f6:	e8 a3 02 00 00       	call   80089e <cprintf>
  8005fb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8005fe:	a1 04 40 80 00       	mov    0x804004,%eax
  800603:	83 ec 0c             	sub    $0xc,%esp
  800606:	ff 75 0c             	pushl  0xc(%ebp)
  800609:	ff 75 08             	pushl  0x8(%ebp)
  80060c:	50                   	push   %eax
  80060d:	68 24 31 80 00       	push   $0x803124
  800612:	6a 74                	push   $0x74
  800614:	e8 b2 02 00 00       	call   8008cb <cprintf_colored>
  800619:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80061c:	8b 45 10             	mov    0x10(%ebp),%eax
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 f4             	pushl  -0xc(%ebp)
  800625:	50                   	push   %eax
  800626:	e8 04 02 00 00       	call   80082f <vcprintf>
  80062b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	6a 00                	push   $0x0
  800633:	68 4c 31 80 00       	push   $0x80314c
  800638:	e8 f2 01 00 00       	call   80082f <vcprintf>
  80063d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800640:	e8 7d ff ff ff       	call   8005c2 <exit>

	// should not return here
	while (1) ;
  800645:	eb fe                	jmp    800645 <_panic+0x75>

00800647 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
  80064a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80064d:	a1 20 40 80 00       	mov    0x804020,%eax
  800652:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	74 14                	je     800673 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80065f:	83 ec 04             	sub    $0x4,%esp
  800662:	68 50 31 80 00       	push   $0x803150
  800667:	6a 26                	push   $0x26
  800669:	68 9c 31 80 00       	push   $0x80319c
  80066e:	e8 5d ff ff ff       	call   8005d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800673:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80067a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800681:	e9 c5 00 00 00       	jmp    80074b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800689:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	01 d0                	add    %edx,%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	85 c0                	test   %eax,%eax
  800699:	75 08                	jne    8006a3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80069b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80069e:	e9 a5 00 00 00       	jmp    800748 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8006a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8006b1:	eb 69                	jmp    80071c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8006b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8006be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	01 c0                	add    %eax,%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	c1 e0 03             	shl    $0x3,%eax
  8006ca:	01 c8                	add    %ecx,%eax
  8006cc:	8a 40 04             	mov    0x4(%eax),%al
  8006cf:	84 c0                	test   %al,%al
  8006d1:	75 46                	jne    800719 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8006d8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8006de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006e1:	89 d0                	mov    %edx,%eax
  8006e3:	01 c0                	add    %eax,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	c1 e0 03             	shl    $0x3,%eax
  8006ea:	01 c8                	add    %ecx,%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006f9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	01 c8                	add    %ecx,%eax
  80070a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80070c:	39 c2                	cmp    %eax,%edx
  80070e:	75 09                	jne    800719 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800710:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800717:	eb 15                	jmp    80072e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800719:	ff 45 e8             	incl   -0x18(%ebp)
  80071c:	a1 20 40 80 00       	mov    0x804020,%eax
  800721:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80072a:	39 c2                	cmp    %eax,%edx
  80072c:	77 85                	ja     8006b3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80072e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800732:	75 14                	jne    800748 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800734:	83 ec 04             	sub    $0x4,%esp
  800737:	68 a8 31 80 00       	push   $0x8031a8
  80073c:	6a 3a                	push   $0x3a
  80073e:	68 9c 31 80 00       	push   $0x80319c
  800743:	e8 88 fe ff ff       	call   8005d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800748:	ff 45 f0             	incl   -0x10(%ebp)
  80074b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80074e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800751:	0f 8c 2f ff ff ff    	jl     800686 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800757:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800765:	eb 26                	jmp    80078d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800767:	a1 20 40 80 00       	mov    0x804020,%eax
  80076c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800772:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800775:	89 d0                	mov    %edx,%eax
  800777:	01 c0                	add    %eax,%eax
  800779:	01 d0                	add    %edx,%eax
  80077b:	c1 e0 03             	shl    $0x3,%eax
  80077e:	01 c8                	add    %ecx,%eax
  800780:	8a 40 04             	mov    0x4(%eax),%al
  800783:	3c 01                	cmp    $0x1,%al
  800785:	75 03                	jne    80078a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800787:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80078a:	ff 45 e0             	incl   -0x20(%ebp)
  80078d:	a1 20 40 80 00       	mov    0x804020,%eax
  800792:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800798:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80079b:	39 c2                	cmp    %eax,%edx
  80079d:	77 c8                	ja     800767 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8007a5:	74 14                	je     8007bb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8007a7:	83 ec 04             	sub    $0x4,%esp
  8007aa:	68 fc 31 80 00       	push   $0x8031fc
  8007af:	6a 44                	push   $0x44
  8007b1:	68 9c 31 80 00       	push   $0x80319c
  8007b6:	e8 15 fe ff ff       	call   8005d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8007bb:	90                   	nop
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	53                   	push   %ebx
  8007c2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8007cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d0:	89 0a                	mov    %ecx,(%edx)
  8007d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d5:	88 d1                	mov    %dl,%cl
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007da:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007e8:	75 30                	jne    80081a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8007ea:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8007f0:	a0 44 40 80 00       	mov    0x804044,%al
  8007f5:	0f b6 c0             	movzbl %al,%eax
  8007f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fb:	8b 09                	mov    (%ecx),%ecx
  8007fd:	89 cb                	mov    %ecx,%ebx
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	83 c1 08             	add    $0x8,%ecx
  800805:	52                   	push   %edx
  800806:	50                   	push   %eax
  800807:	53                   	push   %ebx
  800808:	51                   	push   %ecx
  800809:	e8 57 11 00 00       	call   801965 <sys_cputs>
  80080e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80081a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081d:	8b 40 04             	mov    0x4(%eax),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	8b 45 0c             	mov    0xc(%ebp),%eax
  800826:	89 50 04             	mov    %edx,0x4(%eax)
}
  800829:	90                   	nop
  80082a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    

0080082f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800838:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80083f:	00 00 00 
	b.cnt = 0;
  800842:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800849:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80084c:	ff 75 0c             	pushl  0xc(%ebp)
  80084f:	ff 75 08             	pushl  0x8(%ebp)
  800852:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800858:	50                   	push   %eax
  800859:	68 be 07 80 00       	push   $0x8007be
  80085e:	e8 5a 02 00 00       	call   800abd <vprintfmt>
  800863:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800866:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80086c:	a0 44 40 80 00       	mov    0x804044,%al
  800871:	0f b6 c0             	movzbl %al,%eax
  800874:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80087a:	52                   	push   %edx
  80087b:	50                   	push   %eax
  80087c:	51                   	push   %ecx
  80087d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800883:	83 c0 08             	add    $0x8,%eax
  800886:	50                   	push   %eax
  800887:	e8 d9 10 00 00       	call   801965 <sys_cputs>
  80088c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80088f:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800896:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008a4:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8008ab:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	e8 6f ff ff ff       	call   80082f <vcprintf>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8008c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8008d1:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	c1 e0 08             	shl    $0x8,%eax
  8008de:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  8008e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008e6:	83 c0 04             	add    $0x4,%eax
  8008e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f5:	50                   	push   %eax
  8008f6:	e8 34 ff ff ff       	call   80082f <vcprintf>
  8008fb:	83 c4 10             	add    $0x10,%esp
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800901:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800908:	07 00 00 

	return cnt;
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800916:	e8 8e 10 00 00       	call   8019a9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80091b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80091e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800921:	8b 45 08             	mov    0x8(%ebp),%eax
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 f4             	pushl  -0xc(%ebp)
  80092a:	50                   	push   %eax
  80092b:	e8 ff fe ff ff       	call   80082f <vcprintf>
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800936:	e8 88 10 00 00       	call   8019c3 <sys_unlock_cons>
	return cnt;
  80093b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	53                   	push   %ebx
  800944:	83 ec 14             	sub    $0x14,%esp
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800953:	8b 45 18             	mov    0x18(%ebp),%eax
  800956:	ba 00 00 00 00       	mov    $0x0,%edx
  80095b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80095e:	77 55                	ja     8009b5 <printnum+0x75>
  800960:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800963:	72 05                	jb     80096a <printnum+0x2a>
  800965:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800968:	77 4b                	ja     8009b5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80096a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80096d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800970:	8b 45 18             	mov    0x18(%ebp),%eax
  800973:	ba 00 00 00 00       	mov    $0x0,%edx
  800978:	52                   	push   %edx
  800979:	50                   	push   %eax
  80097a:	ff 75 f4             	pushl  -0xc(%ebp)
  80097d:	ff 75 f0             	pushl  -0x10(%ebp)
  800980:	e8 c7 20 00 00       	call   802a4c <__udivdi3>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	ff 75 20             	pushl  0x20(%ebp)
  80098e:	53                   	push   %ebx
  80098f:	ff 75 18             	pushl  0x18(%ebp)
  800992:	52                   	push   %edx
  800993:	50                   	push   %eax
  800994:	ff 75 0c             	pushl  0xc(%ebp)
  800997:	ff 75 08             	pushl  0x8(%ebp)
  80099a:	e8 a1 ff ff ff       	call   800940 <printnum>
  80099f:	83 c4 20             	add    $0x20,%esp
  8009a2:	eb 1a                	jmp    8009be <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009a4:	83 ec 08             	sub    $0x8,%esp
  8009a7:	ff 75 0c             	pushl  0xc(%ebp)
  8009aa:	ff 75 20             	pushl  0x20(%ebp)
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009b5:	ff 4d 1c             	decl   0x1c(%ebp)
  8009b8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8009bc:	7f e6                	jg     8009a4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009be:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8009c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009cc:	53                   	push   %ebx
  8009cd:	51                   	push   %ecx
  8009ce:	52                   	push   %edx
  8009cf:	50                   	push   %eax
  8009d0:	e8 87 21 00 00       	call   802b5c <__umoddi3>
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	05 74 34 80 00       	add    $0x803474,%eax
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f be c0             	movsbl %al,%eax
  8009e2:	83 ec 08             	sub    $0x8,%esp
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	50                   	push   %eax
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	ff d0                	call   *%eax
  8009ee:	83 c4 10             	add    $0x10,%esp
}
  8009f1:	90                   	nop
  8009f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009fe:	7e 1c                	jle    800a1c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	8d 50 08             	lea    0x8(%eax),%edx
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	89 10                	mov    %edx,(%eax)
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 00                	mov    (%eax),%eax
  800a12:	83 e8 08             	sub    $0x8,%eax
  800a15:	8b 50 04             	mov    0x4(%eax),%edx
  800a18:	8b 00                	mov    (%eax),%eax
  800a1a:	eb 40                	jmp    800a5c <getuint+0x65>
	else if (lflag)
  800a1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a20:	74 1e                	je     800a40 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 00                	mov    (%eax),%eax
  800a27:	8d 50 04             	lea    0x4(%eax),%edx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	89 10                	mov    %edx,(%eax)
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8b 00                	mov    (%eax),%eax
  800a34:	83 e8 04             	sub    $0x4,%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3e:	eb 1c                	jmp    800a5c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	8d 50 04             	lea    0x4(%eax),%edx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	89 10                	mov    %edx,(%eax)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	83 e8 04             	sub    $0x4,%eax
  800a55:	8b 00                	mov    (%eax),%eax
  800a57:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a61:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a65:	7e 1c                	jle    800a83 <getint+0x25>
		return va_arg(*ap, long long);
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8b 00                	mov    (%eax),%eax
  800a6c:	8d 50 08             	lea    0x8(%eax),%edx
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	89 10                	mov    %edx,(%eax)
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	8b 00                	mov    (%eax),%eax
  800a79:	83 e8 08             	sub    $0x8,%eax
  800a7c:	8b 50 04             	mov    0x4(%eax),%edx
  800a7f:	8b 00                	mov    (%eax),%eax
  800a81:	eb 38                	jmp    800abb <getint+0x5d>
	else if (lflag)
  800a83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a87:	74 1a                	je     800aa3 <getint+0x45>
		return va_arg(*ap, long);
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 00                	mov    (%eax),%eax
  800a8e:	8d 50 04             	lea    0x4(%eax),%edx
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	89 10                	mov    %edx,(%eax)
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 00                	mov    (%eax),%eax
  800a9b:	83 e8 04             	sub    $0x4,%eax
  800a9e:	8b 00                	mov    (%eax),%eax
  800aa0:	99                   	cltd   
  800aa1:	eb 18                	jmp    800abb <getint+0x5d>
	else
		return va_arg(*ap, int);
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	8d 50 04             	lea    0x4(%eax),%edx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	89 10                	mov    %edx,(%eax)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8b 00                	mov    (%eax),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	99                   	cltd   
}
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac5:	eb 17                	jmp    800ade <vprintfmt+0x21>
			if (ch == '\0')
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	0f 84 c1 03 00 00    	je     800e90 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800acf:	83 ec 08             	sub    $0x8,%esp
  800ad2:	ff 75 0c             	pushl  0xc(%ebp)
  800ad5:	53                   	push   %ebx
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ade:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae1:	8d 50 01             	lea    0x1(%eax),%edx
  800ae4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	0f b6 d8             	movzbl %al,%ebx
  800aec:	83 fb 25             	cmp    $0x25,%ebx
  800aef:	75 d6                	jne    800ac7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800af1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800af5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800afc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b03:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b0a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b11:	8b 45 10             	mov    0x10(%ebp),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	89 55 10             	mov    %edx,0x10(%ebp)
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	0f b6 d8             	movzbl %al,%ebx
  800b1f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b22:	83 f8 5b             	cmp    $0x5b,%eax
  800b25:	0f 87 3d 03 00 00    	ja     800e68 <vprintfmt+0x3ab>
  800b2b:	8b 04 85 98 34 80 00 	mov    0x803498(,%eax,4),%eax
  800b32:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800b34:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800b38:	eb d7                	jmp    800b11 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b3a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800b3e:	eb d1                	jmp    800b11 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b4a:	89 d0                	mov    %edx,%eax
  800b4c:	c1 e0 02             	shl    $0x2,%eax
  800b4f:	01 d0                	add    %edx,%eax
  800b51:	01 c0                	add    %eax,%eax
  800b53:	01 d8                	add    %ebx,%eax
  800b55:	83 e8 30             	sub    $0x30,%eax
  800b58:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b63:	83 fb 2f             	cmp    $0x2f,%ebx
  800b66:	7e 3e                	jle    800ba6 <vprintfmt+0xe9>
  800b68:	83 fb 39             	cmp    $0x39,%ebx
  800b6b:	7f 39                	jg     800ba6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b6d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b70:	eb d5                	jmp    800b47 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 14             	mov    %eax,0x14(%ebp)
  800b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7e:	83 e8 04             	sub    $0x4,%eax
  800b81:	8b 00                	mov    (%eax),%eax
  800b83:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b86:	eb 1f                	jmp    800ba7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8c:	79 83                	jns    800b11 <vprintfmt+0x54>
				width = 0;
  800b8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b95:	e9 77 ff ff ff       	jmp    800b11 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b9a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ba1:	e9 6b ff ff ff       	jmp    800b11 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ba6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ba7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bab:	0f 89 60 ff ff ff    	jns    800b11 <vprintfmt+0x54>
				width = precision, precision = -1;
  800bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bb7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800bbe:	e9 4e ff ff ff       	jmp    800b11 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800bc3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800bc6:	e9 46 ff ff ff       	jmp    800b11 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd7:	83 e8 04             	sub    $0x4,%eax
  800bda:	8b 00                	mov    (%eax),%eax
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	50                   	push   %eax
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	ff d0                	call   *%eax
  800be8:	83 c4 10             	add    $0x10,%esp
			break;
  800beb:	e9 9b 02 00 00       	jmp    800e8b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	83 c0 04             	add    $0x4,%eax
  800bf6:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfc:	83 e8 04             	sub    $0x4,%eax
  800bff:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c01:	85 db                	test   %ebx,%ebx
  800c03:	79 02                	jns    800c07 <vprintfmt+0x14a>
				err = -err;
  800c05:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c07:	83 fb 64             	cmp    $0x64,%ebx
  800c0a:	7f 0b                	jg     800c17 <vprintfmt+0x15a>
  800c0c:	8b 34 9d e0 32 80 00 	mov    0x8032e0(,%ebx,4),%esi
  800c13:	85 f6                	test   %esi,%esi
  800c15:	75 19                	jne    800c30 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c17:	53                   	push   %ebx
  800c18:	68 85 34 80 00       	push   $0x803485
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	ff 75 08             	pushl  0x8(%ebp)
  800c23:	e8 70 02 00 00       	call   800e98 <printfmt>
  800c28:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800c2b:	e9 5b 02 00 00       	jmp    800e8b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800c30:	56                   	push   %esi
  800c31:	68 8e 34 80 00       	push   $0x80348e
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	ff 75 08             	pushl  0x8(%ebp)
  800c3c:	e8 57 02 00 00       	call   800e98 <printfmt>
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 42 02 00 00       	jmp    800e8b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c49:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4c:	83 c0 04             	add    $0x4,%eax
  800c4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 e8 04             	sub    $0x4,%eax
  800c58:	8b 30                	mov    (%eax),%esi
  800c5a:	85 f6                	test   %esi,%esi
  800c5c:	75 05                	jne    800c63 <vprintfmt+0x1a6>
				p = "(null)";
  800c5e:	be 91 34 80 00       	mov    $0x803491,%esi
			if (width > 0 && padc != '-')
  800c63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c67:	7e 6d                	jle    800cd6 <vprintfmt+0x219>
  800c69:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c6d:	74 67                	je     800cd6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	50                   	push   %eax
  800c76:	56                   	push   %esi
  800c77:	e8 1e 03 00 00       	call   800f9a <strnlen>
  800c7c:	83 c4 10             	add    $0x10,%esp
  800c7f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c82:	eb 16                	jmp    800c9a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c84:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c88:	83 ec 08             	sub    $0x8,%esp
  800c8b:	ff 75 0c             	pushl  0xc(%ebp)
  800c8e:	50                   	push   %eax
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c97:	ff 4d e4             	decl   -0x1c(%ebp)
  800c9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9e:	7f e4                	jg     800c84 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ca0:	eb 34                	jmp    800cd6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ca2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ca6:	74 1c                	je     800cc4 <vprintfmt+0x207>
  800ca8:	83 fb 1f             	cmp    $0x1f,%ebx
  800cab:	7e 05                	jle    800cb2 <vprintfmt+0x1f5>
  800cad:	83 fb 7e             	cmp    $0x7e,%ebx
  800cb0:	7e 12                	jle    800cc4 <vprintfmt+0x207>
					putch('?', putdat);
  800cb2:	83 ec 08             	sub    $0x8,%esp
  800cb5:	ff 75 0c             	pushl  0xc(%ebp)
  800cb8:	6a 3f                	push   $0x3f
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	ff d0                	call   *%eax
  800cbf:	83 c4 10             	add    $0x10,%esp
  800cc2:	eb 0f                	jmp    800cd3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	53                   	push   %ebx
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd3:	ff 4d e4             	decl   -0x1c(%ebp)
  800cd6:	89 f0                	mov    %esi,%eax
  800cd8:	8d 70 01             	lea    0x1(%eax),%esi
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f be d8             	movsbl %al,%ebx
  800ce0:	85 db                	test   %ebx,%ebx
  800ce2:	74 24                	je     800d08 <vprintfmt+0x24b>
  800ce4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ce8:	78 b8                	js     800ca2 <vprintfmt+0x1e5>
  800cea:	ff 4d e0             	decl   -0x20(%ebp)
  800ced:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800cf1:	79 af                	jns    800ca2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf3:	eb 13                	jmp    800d08 <vprintfmt+0x24b>
				putch(' ', putdat);
  800cf5:	83 ec 08             	sub    $0x8,%esp
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	6a 20                	push   $0x20
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	ff d0                	call   *%eax
  800d02:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d05:	ff 4d e4             	decl   -0x1c(%ebp)
  800d08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0c:	7f e7                	jg     800cf5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d0e:	e9 78 01 00 00       	jmp    800e8b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d13:	83 ec 08             	sub    $0x8,%esp
  800d16:	ff 75 e8             	pushl  -0x18(%ebp)
  800d19:	8d 45 14             	lea    0x14(%ebp),%eax
  800d1c:	50                   	push   %eax
  800d1d:	e8 3c fd ff ff       	call   800a5e <getint>
  800d22:	83 c4 10             	add    $0x10,%esp
  800d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d31:	85 d2                	test   %edx,%edx
  800d33:	79 23                	jns    800d58 <vprintfmt+0x29b>
				putch('-', putdat);
  800d35:	83 ec 08             	sub    $0x8,%esp
  800d38:	ff 75 0c             	pushl  0xc(%ebp)
  800d3b:	6a 2d                	push   $0x2d
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	ff d0                	call   *%eax
  800d42:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d4b:	f7 d8                	neg    %eax
  800d4d:	83 d2 00             	adc    $0x0,%edx
  800d50:	f7 da                	neg    %edx
  800d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800d58:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d5f:	e9 bc 00 00 00       	jmp    800e20 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 e8             	pushl  -0x18(%ebp)
  800d6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800d6d:	50                   	push   %eax
  800d6e:	e8 84 fc ff ff       	call   8009f7 <getuint>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d7c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d83:	e9 98 00 00 00       	jmp    800e20 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	6a 58                	push   $0x58
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	ff d0                	call   *%eax
  800d95:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	6a 58                	push   $0x58
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	ff d0                	call   *%eax
  800da5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	ff 75 0c             	pushl  0xc(%ebp)
  800dae:	6a 58                	push   $0x58
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	ff d0                	call   *%eax
  800db5:	83 c4 10             	add    $0x10,%esp
			break;
  800db8:	e9 ce 00 00 00       	jmp    800e8b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800dbd:	83 ec 08             	sub    $0x8,%esp
  800dc0:	ff 75 0c             	pushl  0xc(%ebp)
  800dc3:	6a 30                	push   $0x30
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	ff d0                	call   *%eax
  800dca:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800dcd:	83 ec 08             	sub    $0x8,%esp
  800dd0:	ff 75 0c             	pushl  0xc(%ebp)
  800dd3:	6a 78                	push   $0x78
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	ff d0                	call   *%eax
  800dda:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ddd:	8b 45 14             	mov    0x14(%ebp),%eax
  800de0:	83 c0 04             	add    $0x4,%eax
  800de3:	89 45 14             	mov    %eax,0x14(%ebp)
  800de6:	8b 45 14             	mov    0x14(%ebp),%eax
  800de9:	83 e8 04             	sub    $0x4,%eax
  800dec:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800df8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800dff:	eb 1f                	jmp    800e20 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e01:	83 ec 08             	sub    $0x8,%esp
  800e04:	ff 75 e8             	pushl  -0x18(%ebp)
  800e07:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0a:	50                   	push   %eax
  800e0b:	e8 e7 fb ff ff       	call   8009f7 <getuint>
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e16:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e19:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e20:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e27:	83 ec 04             	sub    $0x4,%esp
  800e2a:	52                   	push   %edx
  800e2b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800e2e:	50                   	push   %eax
  800e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e32:	ff 75 f0             	pushl  -0x10(%ebp)
  800e35:	ff 75 0c             	pushl  0xc(%ebp)
  800e38:	ff 75 08             	pushl  0x8(%ebp)
  800e3b:	e8 00 fb ff ff       	call   800940 <printnum>
  800e40:	83 c4 20             	add    $0x20,%esp
			break;
  800e43:	eb 46                	jmp    800e8b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	ff 75 0c             	pushl  0xc(%ebp)
  800e4b:	53                   	push   %ebx
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
			break;
  800e54:	eb 35                	jmp    800e8b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800e56:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800e5d:	eb 2c                	jmp    800e8b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800e5f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800e66:	eb 23                	jmp    800e8b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 25                	push   $0x25
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e78:	ff 4d 10             	decl   0x10(%ebp)
  800e7b:	eb 03                	jmp    800e80 <vprintfmt+0x3c3>
  800e7d:	ff 4d 10             	decl   0x10(%ebp)
  800e80:	8b 45 10             	mov    0x10(%ebp),%eax
  800e83:	48                   	dec    %eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	3c 25                	cmp    $0x25,%al
  800e88:	75 f3                	jne    800e7d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e8a:	90                   	nop
		}
	}
  800e8b:	e9 35 fc ff ff       	jmp    800ac5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e90:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e91:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5d                   	pop    %ebp
  800e97:	c3                   	ret    

00800e98 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e98:	55                   	push   %ebp
  800e99:	89 e5                	mov    %esp,%ebp
  800e9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e9e:	8d 45 10             	lea    0x10(%ebp),%eax
  800ea1:	83 c0 04             	add    $0x4,%eax
  800ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ead:	50                   	push   %eax
  800eae:	ff 75 0c             	pushl  0xc(%ebp)
  800eb1:	ff 75 08             	pushl  0x8(%ebp)
  800eb4:	e8 04 fc ff ff       	call   800abd <vprintfmt>
  800eb9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ebc:	90                   	nop
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    

00800ebf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	8b 40 08             	mov    0x8(%eax),%eax
  800ec8:	8d 50 01             	lea    0x1(%eax),%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	8b 10                	mov    (%eax),%edx
  800ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed9:	8b 40 04             	mov    0x4(%eax),%eax
  800edc:	39 c2                	cmp    %eax,%edx
  800ede:	73 12                	jae    800ef2 <sprintputch+0x33>
		*b->buf++ = ch;
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	8b 00                	mov    (%eax),%eax
  800ee5:	8d 48 01             	lea    0x1(%eax),%ecx
  800ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eeb:	89 0a                	mov    %ecx,(%edx)
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	88 10                	mov    %dl,(%eax)
}
  800ef2:	90                   	nop
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	01 d0                	add    %edx,%eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f1a:	74 06                	je     800f22 <vsnprintf+0x2d>
  800f1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f20:	7f 07                	jg     800f29 <vsnprintf+0x34>
		return -E_INVAL;
  800f22:	b8 03 00 00 00       	mov    $0x3,%eax
  800f27:	eb 20                	jmp    800f49 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f29:	ff 75 14             	pushl  0x14(%ebp)
  800f2c:	ff 75 10             	pushl  0x10(%ebp)
  800f2f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f32:	50                   	push   %eax
  800f33:	68 bf 0e 80 00       	push   $0x800ebf
  800f38:	e8 80 fb ff ff       	call   800abd <vprintfmt>
  800f3d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f43:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800f51:	8d 45 10             	lea    0x10(%ebp),%eax
  800f54:	83 c0 04             	add    $0x4,%eax
  800f57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	ff 75 0c             	pushl  0xc(%ebp)
  800f64:	ff 75 08             	pushl  0x8(%ebp)
  800f67:	e8 89 ff ff ff       	call   800ef5 <vsnprintf>
  800f6c:	83 c4 10             	add    $0x10,%esp
  800f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f75:	c9                   	leave  
  800f76:	c3                   	ret    

00800f77 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f84:	eb 06                	jmp    800f8c <strlen+0x15>
		n++;
  800f86:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f89:	ff 45 08             	incl   0x8(%ebp)
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	84 c0                	test   %al,%al
  800f93:	75 f1                	jne    800f86 <strlen+0xf>
		n++;
	return n;
  800f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa7:	eb 09                	jmp    800fb2 <strnlen+0x18>
		n++;
  800fa9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	ff 4d 0c             	decl   0xc(%ebp)
  800fb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb6:	74 09                	je     800fc1 <strnlen+0x27>
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	84 c0                	test   %al,%al
  800fbf:	75 e8                	jne    800fa9 <strnlen+0xf>
		n++;
	return n;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800fc4:	c9                   	leave  
  800fc5:	c3                   	ret    

00800fc6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800fc6:	55                   	push   %ebp
  800fc7:	89 e5                	mov    %esp,%ebp
  800fc9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800fd2:	90                   	nop
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8d 50 01             	lea    0x1(%eax),%edx
  800fd9:	89 55 08             	mov    %edx,0x8(%ebp)
  800fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fe5:	8a 12                	mov    (%edx),%dl
  800fe7:	88 10                	mov    %dl,(%eax)
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	84 c0                	test   %al,%al
  800fed:	75 e4                	jne    800fd3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801000:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801007:	eb 1f                	jmp    801028 <strncpy+0x34>
		*dst++ = *src;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8d 50 01             	lea    0x1(%eax),%edx
  80100f:	89 55 08             	mov    %edx,0x8(%ebp)
  801012:	8b 55 0c             	mov    0xc(%ebp),%edx
  801015:	8a 12                	mov    (%edx),%dl
  801017:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	74 03                	je     801025 <strncpy+0x31>
			src++;
  801022:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801025:	ff 45 fc             	incl   -0x4(%ebp)
  801028:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102e:	72 d9                	jb     801009 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801030:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801033:	c9                   	leave  
  801034:	c3                   	ret    

00801035 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801041:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801045:	74 30                	je     801077 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801047:	eb 16                	jmp    80105f <strlcpy+0x2a>
			*dst++ = *src++;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8d 50 01             	lea    0x1(%eax),%edx
  80104f:	89 55 08             	mov    %edx,0x8(%ebp)
  801052:	8b 55 0c             	mov    0xc(%ebp),%edx
  801055:	8d 4a 01             	lea    0x1(%edx),%ecx
  801058:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80105b:	8a 12                	mov    (%edx),%dl
  80105d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80105f:	ff 4d 10             	decl   0x10(%ebp)
  801062:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801066:	74 09                	je     801071 <strlcpy+0x3c>
  801068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	84 c0                	test   %al,%al
  80106f:	75 d8                	jne    801049 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107d:	29 c2                	sub    %eax,%edx
  80107f:	89 d0                	mov    %edx,%eax
}
  801081:	c9                   	leave  
  801082:	c3                   	ret    

00801083 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801086:	eb 06                	jmp    80108e <strcmp+0xb>
		p++, q++;
  801088:	ff 45 08             	incl   0x8(%ebp)
  80108b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	8a 00                	mov    (%eax),%al
  801093:	84 c0                	test   %al,%al
  801095:	74 0e                	je     8010a5 <strcmp+0x22>
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 10                	mov    (%eax),%dl
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	38 c2                	cmp    %al,%dl
  8010a3:	74 e3                	je     801088 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	0f b6 d0             	movzbl %al,%edx
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	0f b6 c0             	movzbl %al,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
}
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8010be:	eb 09                	jmp    8010c9 <strncmp+0xe>
		n--, p++, q++;
  8010c0:	ff 4d 10             	decl   0x10(%ebp)
  8010c3:	ff 45 08             	incl   0x8(%ebp)
  8010c6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8010c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cd:	74 17                	je     8010e6 <strncmp+0x2b>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	84 c0                	test   %al,%al
  8010d6:	74 0e                	je     8010e6 <strncmp+0x2b>
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 10                	mov    (%eax),%dl
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	38 c2                	cmp    %al,%dl
  8010e4:	74 da                	je     8010c0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8010e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ea:	75 07                	jne    8010f3 <strncmp+0x38>
		return 0;
  8010ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f1:	eb 14                	jmp    801107 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	0f b6 d0             	movzbl %al,%edx
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	0f b6 c0             	movzbl %al,%eax
  801103:	29 c2                	sub    %eax,%edx
  801105:	89 d0                	mov    %edx,%eax
}
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801115:	eb 12                	jmp    801129 <strchr+0x20>
		if (*s == c)
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80111f:	75 05                	jne    801126 <strchr+0x1d>
			return (char *) s;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	eb 11                	jmp    801137 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801126:	ff 45 08             	incl   0x8(%ebp)
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	84 c0                	test   %al,%al
  801130:	75 e5                	jne    801117 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801132:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801145:	eb 0d                	jmp    801154 <strfind+0x1b>
		if (*s == c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80114f:	74 0e                	je     80115f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	84 c0                	test   %al,%al
  80115b:	75 ea                	jne    801147 <strfind+0xe>
  80115d:	eb 01                	jmp    801160 <strfind+0x27>
		if (*s == c)
			break;
  80115f:	90                   	nop
	return (char *) s;
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801171:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801175:	76 63                	jbe    8011da <memset+0x75>
		uint64 data_block = c;
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	99                   	cltd   
  80117b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80117e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801187:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80118b:	c1 e0 08             	shl    $0x8,%eax
  80118e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801191:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80119e:	c1 e0 10             	shl    $0x10,%eax
  8011a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011a4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8011a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8011b7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8011ba:	eb 18                	jmp    8011d4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8011bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011bf:	8d 41 08             	lea    0x8(%ecx),%eax
  8011c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8011c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cb:	89 01                	mov    %eax,(%ecx)
  8011cd:	89 51 04             	mov    %edx,0x4(%ecx)
  8011d0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8011d4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011d8:	77 e2                	ja     8011bc <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8011da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011de:	74 23                	je     801203 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8011e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011e6:	eb 0e                	jmp    8011f6 <memset+0x91>
			*p8++ = (uint8)c;
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011eb:	8d 50 01             	lea    0x1(%eax),%edx
  8011ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ff:	85 c0                	test   %eax,%eax
  801201:	75 e5                	jne    8011e8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    

00801208 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80120e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80121a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80121e:	76 24                	jbe    801244 <memcpy+0x3c>
		while(n >= 8){
  801220:	eb 1c                	jmp    80123e <memcpy+0x36>
			*d64 = *s64;
  801222:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801225:	8b 50 04             	mov    0x4(%eax),%edx
  801228:	8b 00                	mov    (%eax),%eax
  80122a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80122d:	89 01                	mov    %eax,(%ecx)
  80122f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801232:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801236:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80123a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80123e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801242:	77 de                	ja     801222 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 31                	je     80127b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801250:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801253:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801256:	eb 16                	jmp    80126e <memcpy+0x66>
			*d8++ = *s8++;
  801258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125b:	8d 50 01             	lea    0x1(%eax),%edx
  80125e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801261:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801264:	8d 4a 01             	lea    0x1(%edx),%ecx
  801267:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80126a:	8a 12                	mov    (%edx),%dl
  80126c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	8d 50 ff             	lea    -0x1(%eax),%edx
  801274:	89 55 10             	mov    %edx,0x10(%ebp)
  801277:	85 c0                	test   %eax,%eax
  801279:	75 dd                	jne    801258 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801292:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801295:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801298:	73 50                	jae    8012ea <memmove+0x6a>
  80129a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012a5:	76 43                	jbe    8012ea <memmove+0x6a>
		s += n;
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012b3:	eb 10                	jmp    8012c5 <memmove+0x45>
			*--d = *--s;
  8012b5:	ff 4d f8             	decl   -0x8(%ebp)
  8012b8:	ff 4d fc             	decl   -0x4(%ebp)
  8012bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012be:	8a 10                	mov    (%eax),%dl
  8012c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	75 e3                	jne    8012b5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012d2:	eb 23                	jmp    8012f7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012e6:	8a 12                	mov    (%edx),%dl
  8012e8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	75 dd                	jne    8012d4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80130e:	eb 2a                	jmp    80133a <memcmp+0x3e>
		if (*s1 != *s2)
  801310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801313:	8a 10                	mov    (%eax),%dl
  801315:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801318:	8a 00                	mov    (%eax),%al
  80131a:	38 c2                	cmp    %al,%dl
  80131c:	74 16                	je     801334 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8a 00                	mov    (%eax),%al
  801323:	0f b6 d0             	movzbl %al,%edx
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	0f b6 c0             	movzbl %al,%eax
  80132e:	29 c2                	sub    %eax,%edx
  801330:	89 d0                	mov    %edx,%eax
  801332:	eb 18                	jmp    80134c <memcmp+0x50>
		s1++, s2++;
  801334:	ff 45 fc             	incl   -0x4(%ebp)
  801337:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 c9                	jne    801310 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801347:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
  801351:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801354:	8b 55 08             	mov    0x8(%ebp),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80135f:	eb 15                	jmp    801376 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	8a 00                	mov    (%eax),%al
  801366:	0f b6 d0             	movzbl %al,%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	0f b6 c0             	movzbl %al,%eax
  80136f:	39 c2                	cmp    %eax,%edx
  801371:	74 0d                	je     801380 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80137c:	72 e3                	jb     801361 <memfind+0x13>
  80137e:	eb 01                	jmp    801381 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801380:	90                   	nop
	return (void *) s;
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80138c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801393:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139a:	eb 03                	jmp    80139f <strtol+0x19>
		s++;
  80139c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	3c 20                	cmp    $0x20,%al
  8013a6:	74 f4                	je     80139c <strtol+0x16>
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	3c 09                	cmp    $0x9,%al
  8013af:	74 eb                	je     80139c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	3c 2b                	cmp    $0x2b,%al
  8013b8:	75 05                	jne    8013bf <strtol+0x39>
		s++;
  8013ba:	ff 45 08             	incl   0x8(%ebp)
  8013bd:	eb 13                	jmp    8013d2 <strtol+0x4c>
	else if (*s == '-')
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	3c 2d                	cmp    $0x2d,%al
  8013c6:	75 0a                	jne    8013d2 <strtol+0x4c>
		s++, neg = 1;
  8013c8:	ff 45 08             	incl   0x8(%ebp)
  8013cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d6:	74 06                	je     8013de <strtol+0x58>
  8013d8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013dc:	75 20                	jne    8013fe <strtol+0x78>
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	3c 30                	cmp    $0x30,%al
  8013e5:	75 17                	jne    8013fe <strtol+0x78>
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	40                   	inc    %eax
  8013eb:	8a 00                	mov    (%eax),%al
  8013ed:	3c 78                	cmp    $0x78,%al
  8013ef:	75 0d                	jne    8013fe <strtol+0x78>
		s += 2, base = 16;
  8013f1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013f5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013fc:	eb 28                	jmp    801426 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801402:	75 15                	jne    801419 <strtol+0x93>
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	8a 00                	mov    (%eax),%al
  801409:	3c 30                	cmp    $0x30,%al
  80140b:	75 0c                	jne    801419 <strtol+0x93>
		s++, base = 8;
  80140d:	ff 45 08             	incl   0x8(%ebp)
  801410:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801417:	eb 0d                	jmp    801426 <strtol+0xa0>
	else if (base == 0)
  801419:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80141d:	75 07                	jne    801426 <strtol+0xa0>
		base = 10;
  80141f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	3c 2f                	cmp    $0x2f,%al
  80142d:	7e 19                	jle    801448 <strtol+0xc2>
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	3c 39                	cmp    $0x39,%al
  801436:	7f 10                	jg     801448 <strtol+0xc2>
			dig = *s - '0';
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f be c0             	movsbl %al,%eax
  801440:	83 e8 30             	sub    $0x30,%eax
  801443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801446:	eb 42                	jmp    80148a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	3c 60                	cmp    $0x60,%al
  80144f:	7e 19                	jle    80146a <strtol+0xe4>
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 7a                	cmp    $0x7a,%al
  801458:	7f 10                	jg     80146a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	0f be c0             	movsbl %al,%eax
  801462:	83 e8 57             	sub    $0x57,%eax
  801465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801468:	eb 20                	jmp    80148a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 40                	cmp    $0x40,%al
  801471:	7e 39                	jle    8014ac <strtol+0x126>
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	8a 00                	mov    (%eax),%al
  801478:	3c 5a                	cmp    $0x5a,%al
  80147a:	7f 30                	jg     8014ac <strtol+0x126>
			dig = *s - 'A' + 10;
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8a 00                	mov    (%eax),%al
  801481:	0f be c0             	movsbl %al,%eax
  801484:	83 e8 37             	sub    $0x37,%eax
  801487:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	7d 19                	jge    8014ab <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801492:	ff 45 08             	incl   0x8(%ebp)
  801495:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801498:	0f af 45 10          	imul   0x10(%ebp),%eax
  80149c:	89 c2                	mov    %eax,%edx
  80149e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a1:	01 d0                	add    %edx,%eax
  8014a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014a6:	e9 7b ff ff ff       	jmp    801426 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014ab:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014b0:	74 08                	je     8014ba <strtol+0x134>
		*endptr = (char *) s;
  8014b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014be:	74 07                	je     8014c7 <strtol+0x141>
  8014c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c3:	f7 d8                	neg    %eax
  8014c5:	eb 03                	jmp    8014ca <strtol+0x144>
  8014c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <ltostr>:

void
ltostr(long value, char *str)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e4:	79 13                	jns    8014f9 <ltostr+0x2d>
	{
		neg = 1;
  8014e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014f3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014f6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801501:	99                   	cltd   
  801502:	f7 f9                	idiv   %ecx
  801504:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801507:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80150a:	8d 50 01             	lea    0x1(%eax),%edx
  80150d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801510:	89 c2                	mov    %eax,%edx
  801512:	8b 45 0c             	mov    0xc(%ebp),%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80151a:	83 c2 30             	add    $0x30,%edx
  80151d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80151f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801522:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801527:	f7 e9                	imul   %ecx
  801529:	c1 fa 02             	sar    $0x2,%edx
  80152c:	89 c8                	mov    %ecx,%eax
  80152e:	c1 f8 1f             	sar    $0x1f,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801538:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80153c:	75 bb                	jne    8014f9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801545:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801548:	48                   	dec    %eax
  801549:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801550:	74 3d                	je     80158f <ltostr+0xc3>
		start = 1 ;
  801552:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801559:	eb 34                	jmp    80158f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80155b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156e:	01 c2                	add    %eax,%edx
  801570:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	01 c8                	add    %ecx,%eax
  801578:	8a 00                	mov    (%eax),%al
  80157a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801582:	01 c2                	add    %eax,%edx
  801584:	8a 45 eb             	mov    -0x15(%ebp),%al
  801587:	88 02                	mov    %al,(%edx)
		start++ ;
  801589:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801595:	7c c4                	jl     80155b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801597:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80159a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159d:	01 d0                	add    %edx,%eax
  80159f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a2:	90                   	nop
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 c4 f9 ff ff       	call   800f77 <strlen>
  8015b3:	83 c4 04             	add    $0x4,%esp
  8015b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b9:	ff 75 0c             	pushl  0xc(%ebp)
  8015bc:	e8 b6 f9 ff ff       	call   800f77 <strlen>
  8015c1:	83 c4 04             	add    $0x4,%esp
  8015c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d5:	eb 17                	jmp    8015ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015da:	8b 45 10             	mov    0x10(%ebp),%eax
  8015dd:	01 c2                	add    %eax,%edx
  8015df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	01 c8                	add    %ecx,%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015eb:	ff 45 fc             	incl   -0x4(%ebp)
  8015ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f4:	7c e1                	jl     8015d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801604:	eb 1f                	jmp    801625 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801606:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801609:	8d 50 01             	lea    0x1(%eax),%edx
  80160c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160f:	89 c2                	mov    %eax,%edx
  801611:	8b 45 10             	mov    0x10(%ebp),%eax
  801614:	01 c2                	add    %eax,%edx
  801616:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161c:	01 c8                	add    %ecx,%eax
  80161e:	8a 00                	mov    (%eax),%al
  801620:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801622:	ff 45 f8             	incl   -0x8(%ebp)
  801625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801628:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80162b:	7c d9                	jl     801606 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801630:	8b 45 10             	mov    0x10(%ebp),%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	c6 00 00             	movb   $0x0,(%eax)
}
  801638:	90                   	nop
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163e:	8b 45 14             	mov    0x14(%ebp),%eax
  801641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801647:	8b 45 14             	mov    0x14(%ebp),%eax
  80164a:	8b 00                	mov    (%eax),%eax
  80164c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801653:	8b 45 10             	mov    0x10(%ebp),%eax
  801656:	01 d0                	add    %edx,%eax
  801658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165e:	eb 0c                	jmp    80166c <strsplit+0x31>
			*string++ = 0;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8d 50 01             	lea    0x1(%eax),%edx
  801666:	89 55 08             	mov    %edx,0x8(%ebp)
  801669:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	84 c0                	test   %al,%al
  801673:	74 18                	je     80168d <strsplit+0x52>
  801675:	8b 45 08             	mov    0x8(%ebp),%eax
  801678:	8a 00                	mov    (%eax),%al
  80167a:	0f be c0             	movsbl %al,%eax
  80167d:	50                   	push   %eax
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	e8 83 fa ff ff       	call   801109 <strchr>
  801686:	83 c4 08             	add    $0x8,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	75 d3                	jne    801660 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	84 c0                	test   %al,%al
  801694:	74 5a                	je     8016f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801696:	8b 45 14             	mov    0x14(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	83 f8 0f             	cmp    $0xf,%eax
  80169e:	75 07                	jne    8016a7 <strsplit+0x6c>
		{
			return 0;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	eb 66                	jmp    80170d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016aa:	8b 00                	mov    (%eax),%eax
  8016ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8016af:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b2:	89 0a                	mov    %ecx,(%edx)
  8016b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016be:	01 c2                	add    %eax,%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c5:	eb 03                	jmp    8016ca <strsplit+0x8f>
			string++;
  8016c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	84 c0                	test   %al,%al
  8016d1:	74 8b                	je     80165e <strsplit+0x23>
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8a 00                	mov    (%eax),%al
  8016d8:	0f be c0             	movsbl %al,%eax
  8016db:	50                   	push   %eax
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	e8 25 fa ff ff       	call   801109 <strchr>
  8016e4:	83 c4 08             	add    $0x8,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	74 dc                	je     8016c7 <strsplit+0x8c>
			string++;
	}
  8016eb:	e9 6e ff ff ff       	jmp    80165e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f4:	8b 00                	mov    (%eax),%eax
  8016f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	01 d0                	add    %edx,%eax
  801702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801708:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80171b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801722:	eb 4a                	jmp    80176e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801724:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801727:	8b 45 08             	mov    0x8(%ebp),%eax
  80172a:	01 c2                	add    %eax,%edx
  80172c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80172f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801732:	01 c8                	add    %ecx,%eax
  801734:	8a 00                	mov    (%eax),%al
  801736:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801738:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80173b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173e:	01 d0                	add    %edx,%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	3c 40                	cmp    $0x40,%al
  801744:	7e 25                	jle    80176b <str2lower+0x5c>
  801746:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174c:	01 d0                	add    %edx,%eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	3c 5a                	cmp    $0x5a,%al
  801752:	7f 17                	jg     80176b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801754:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	01 d0                	add    %edx,%eax
  80175c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80175f:	8b 55 08             	mov    0x8(%ebp),%edx
  801762:	01 ca                	add    %ecx,%edx
  801764:	8a 12                	mov    (%edx),%dl
  801766:	83 c2 20             	add    $0x20,%edx
  801769:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80176b:	ff 45 fc             	incl   -0x4(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	e8 01 f8 ff ff       	call   800f77 <strlen>
  801776:	83 c4 04             	add    $0x4,%esp
  801779:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80177c:	7f a6                	jg     801724 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801789:	a1 08 40 80 00       	mov    0x804008,%eax
  80178e:	85 c0                	test   %eax,%eax
  801790:	74 42                	je     8017d4 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801792:	83 ec 08             	sub    $0x8,%esp
  801795:	68 00 00 00 82       	push   $0x82000000
  80179a:	68 00 00 00 80       	push   $0x80000000
  80179f:	e8 00 08 00 00       	call   801fa4 <initialize_dynamic_allocator>
  8017a4:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8017a7:	e8 e7 05 00 00       	call   801d93 <sys_get_uheap_strategy>
  8017ac:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8017b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8017b6:	05 00 10 00 00       	add    $0x1000,%eax
  8017bb:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8017c0:	a1 10 c1 81 00       	mov    0x81c110,%eax
  8017c5:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  8017ca:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8017d1:	00 00 00 
	}
}
  8017d4:	90                   	nop
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017eb:	83 ec 08             	sub    $0x8,%esp
  8017ee:	68 06 04 00 00       	push   $0x406
  8017f3:	50                   	push   %eax
  8017f4:	e8 e4 01 00 00       	call   8019dd <__sys_allocate_page>
  8017f9:	83 c4 10             	add    $0x10,%esp
  8017fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801803:	79 14                	jns    801819 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	68 08 36 80 00       	push   $0x803608
  80180d:	6a 1f                	push   $0x1f
  80180f:	68 44 36 80 00       	push   $0x803644
  801814:	e8 b7 ed ff ff       	call   8005d0 <_panic>
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801834:	83 ec 0c             	sub    $0xc,%esp
  801837:	50                   	push   %eax
  801838:	e8 e7 01 00 00       	call   801a24 <__sys_unmap_frame>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801847:	79 14                	jns    80185d <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 50 36 80 00       	push   $0x803650
  801851:	6a 2a                	push   $0x2a
  801853:	68 44 36 80 00       	push   $0x803644
  801858:	e8 73 ed ff ff       	call   8005d0 <_panic>
}
  80185d:	90                   	nop
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801866:	e8 18 ff ff ff       	call   801783 <uheap_init>
	if (size == 0) return NULL ;
  80186b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80186f:	75 07                	jne    801878 <malloc+0x18>
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
  801876:	eb 14                	jmp    80188c <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	68 90 36 80 00       	push   $0x803690
  801880:	6a 3e                	push   $0x3e
  801882:	68 44 36 80 00       	push   $0x803644
  801887:	e8 44 ed ff ff       	call   8005d0 <_panic>
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801894:	83 ec 04             	sub    $0x4,%esp
  801897:	68 b8 36 80 00       	push   $0x8036b8
  80189c:	6a 49                	push   $0x49
  80189e:	68 44 36 80 00       	push   $0x803644
  8018a3:	e8 28 ed ff ff       	call   8005d0 <_panic>

008018a8 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 18             	sub    $0x18,%esp
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018b4:	e8 ca fe ff ff       	call   801783 <uheap_init>
	if (size == 0) return NULL ;
  8018b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018bd:	75 07                	jne    8018c6 <smalloc+0x1e>
  8018bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c4:	eb 14                	jmp    8018da <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	68 dc 36 80 00       	push   $0x8036dc
  8018ce:	6a 5a                	push   $0x5a
  8018d0:	68 44 36 80 00       	push   $0x803644
  8018d5:	e8 f6 ec ff ff       	call   8005d0 <_panic>
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8018e2:	e8 9c fe ff ff       	call   801783 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	68 04 37 80 00       	push   $0x803704
  8018ef:	6a 6a                	push   $0x6a
  8018f1:	68 44 36 80 00       	push   $0x803644
  8018f6:	e8 d5 ec ff ff       	call   8005d0 <_panic>

008018fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801901:	e8 7d fe ff ff       	call   801783 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 28 37 80 00       	push   $0x803728
  80190e:	68 88 00 00 00       	push   $0x88
  801913:	68 44 36 80 00       	push   $0x803644
  801918:	e8 b3 ec ff ff       	call   8005d0 <_panic>

0080191d <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	68 50 37 80 00       	push   $0x803750
  80192b:	68 9b 00 00 00       	push   $0x9b
  801930:	68 44 36 80 00       	push   $0x803644
  801935:	e8 96 ec ff ff       	call   8005d0 <_panic>

0080193a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	57                   	push   %edi
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801952:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801955:	cd 30                	int    $0x30
  801957:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80195a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	5b                   	pop    %ebx
  801961:	5e                   	pop    %esi
  801962:	5f                   	pop    %edi
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801971:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801974:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	51                   	push   %ecx
  80197e:	52                   	push   %edx
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	6a 00                	push   $0x0
  801985:	e8 b0 ff ff ff       	call   80193a <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_cgetc>:

int
sys_cgetc(void)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 02                	push   $0x2
  80199f:	e8 96 ff ff ff       	call   80193a <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 03                	push   $0x3
  8019b8:	e8 7d ff ff ff       	call   80193a <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 04                	push   $0x4
  8019d2:	e8 63 ff ff ff       	call   80193a <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 08                	push   $0x8
  8019f0:	e8 45 ff ff ff       	call   80193a <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ff:	8b 75 18             	mov    0x18(%ebp),%esi
  801a02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	51                   	push   %ecx
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 09                	push   $0x9
  801a15:	e8 20 ff ff ff       	call   80193a <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 0a                	push   $0xa
  801a34:	e8 01 ff ff ff       	call   80193a <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	ff 75 08             	pushl  0x8(%ebp)
  801a4d:	6a 0b                	push   $0xb
  801a4f:	e8 e6 fe ff ff       	call   80193a <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 0c                	push   $0xc
  801a68:	e8 cd fe ff ff       	call   80193a <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 0d                	push   $0xd
  801a81:	e8 b4 fe ff ff       	call   80193a <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 0e                	push   $0xe
  801a9a:	e8 9b fe ff ff       	call   80193a <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 0f                	push   $0xf
  801ab3:	e8 82 fe ff ff       	call   80193a <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	ff 75 08             	pushl  0x8(%ebp)
  801acb:	6a 10                	push   $0x10
  801acd:	e8 68 fe ff ff       	call   80193a <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 11                	push   $0x11
  801ae6:	e8 4f fe ff ff       	call   80193a <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_cputc>:

void
sys_cputc(const char c)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 04             	sub    $0x4,%esp
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801afd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	50                   	push   %eax
  801b0a:	6a 01                	push   $0x1
  801b0c:	e8 29 fe ff ff       	call   80193a <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 14                	push   $0x14
  801b26:	e8 0f fe ff ff       	call   80193a <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	51                   	push   %ecx
  801b4a:	52                   	push   %edx
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	6a 15                	push   $0x15
  801b51:	e8 e4 fd ff ff       	call   80193a <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 16                	push   $0x16
  801b6e:	e8 c7 fd ff ff       	call   80193a <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	51                   	push   %ecx
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 17                	push   $0x17
  801b8d:	e8 a8 fd ff ff       	call   80193a <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	52                   	push   %edx
  801ba7:	50                   	push   %eax
  801ba8:	6a 18                	push   $0x18
  801baa:	e8 8b fd ff ff       	call   80193a <syscall>
  801baf:	83 c4 18             	add    $0x18,%esp
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 14             	pushl  0x14(%ebp)
  801bbf:	ff 75 10             	pushl  0x10(%ebp)
  801bc2:	ff 75 0c             	pushl  0xc(%ebp)
  801bc5:	50                   	push   %eax
  801bc6:	6a 19                	push   $0x19
  801bc8:	e8 6d fd ff ff       	call   80193a <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	50                   	push   %eax
  801be1:	6a 1a                	push   $0x1a
  801be3:	e8 52 fd ff ff       	call   80193a <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	90                   	nop
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	50                   	push   %eax
  801bfd:	6a 1b                	push   $0x1b
  801bff:	e8 36 fd ff ff       	call   80193a <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 05                	push   $0x5
  801c18:	e8 1d fd ff ff       	call   80193a <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 06                	push   $0x6
  801c31:	e8 04 fd ff ff       	call   80193a <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 07                	push   $0x7
  801c4a:	e8 eb fc ff ff       	call   80193a <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_exit_env>:


void sys_exit_env(void)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 1c                	push   $0x1c
  801c63:	e8 d2 fc ff ff       	call   80193a <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c77:	8d 50 04             	lea    0x4(%eax),%edx
  801c7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 1d                	push   $0x1d
  801c87:	e8 ae fc ff ff       	call   80193a <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c98:	89 01                	mov    %eax,(%ecx)
  801c9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	c9                   	leave  
  801ca1:	c2 04 00             	ret    $0x4

00801ca4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	ff 75 10             	pushl  0x10(%ebp)
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	ff 75 08             	pushl  0x8(%ebp)
  801cb4:	6a 13                	push   $0x13
  801cb6:	e8 7f fc ff ff       	call   80193a <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbe:	90                   	nop
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 1e                	push   $0x1e
  801cd0:	e8 65 fc ff ff       	call   80193a <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	50                   	push   %eax
  801cf3:	6a 1f                	push   $0x1f
  801cf5:	e8 40 fc ff ff       	call   80193a <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <rsttst>:
void rsttst()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 21                	push   $0x21
  801d0f:	e8 26 fc ff ff       	call   80193a <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	8b 45 14             	mov    0x14(%ebp),%eax
  801d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d26:	8b 55 18             	mov    0x18(%ebp),%edx
  801d29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d2d:	52                   	push   %edx
  801d2e:	50                   	push   %eax
  801d2f:	ff 75 10             	pushl  0x10(%ebp)
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	6a 20                	push   $0x20
  801d3a:	e8 fb fb ff ff       	call   80193a <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <chktst>:
void chktst(uint32 n)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	ff 75 08             	pushl  0x8(%ebp)
  801d53:	6a 22                	push   $0x22
  801d55:	e8 e0 fb ff ff       	call   80193a <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5d:	90                   	nop
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <inctst>:

void inctst()
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 23                	push   $0x23
  801d6f:	e8 c6 fb ff ff       	call   80193a <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
	return ;
  801d77:	90                   	nop
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <gettst>:
uint32 gettst()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 24                	push   $0x24
  801d89:	e8 ac fb ff ff       	call   80193a <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 25                	push   $0x25
  801da2:	e8 93 fb ff ff       	call   80193a <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
  801daa:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801daf:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 26                	push   $0x26
  801dce:	e8 67 fb ff ff       	call   80193a <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ddd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	53                   	push   %ebx
  801dec:	51                   	push   %ecx
  801ded:	52                   	push   %edx
  801dee:	50                   	push   %eax
  801def:	6a 27                	push   $0x27
  801df1:	e8 44 fb ff ff       	call   80193a <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 28                	push   $0x28
  801e11:	e8 24 fb ff ff       	call   80193a <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	51                   	push   %ecx
  801e2a:	ff 75 10             	pushl  0x10(%ebp)
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 29                	push   $0x29
  801e31:	e8 04 fb ff ff       	call   80193a <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 10             	pushl  0x10(%ebp)
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	6a 12                	push   $0x12
  801e4d:	e8 e8 fa ff ff       	call   80193a <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
	return ;
  801e55:	90                   	nop
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 2a                	push   $0x2a
  801e6b:	e8 ca fa ff ff       	call   80193a <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return;
  801e73:	90                   	nop
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 2b                	push   $0x2b
  801e85:	e8 b0 fa ff ff       	call   80193a <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	6a 2d                	push   $0x2d
  801ea0:	e8 95 fa ff ff       	call   80193a <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	6a 2c                	push   $0x2c
  801ebc:	e8 79 fa ff ff       	call   80193a <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec4:	90                   	nop
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	68 74 37 80 00       	push   $0x803774
  801ed5:	68 25 01 00 00       	push   $0x125
  801eda:	68 a7 37 80 00       	push   $0x8037a7
  801edf:	e8 ec e6 ff ff       	call   8005d0 <_panic>

00801ee4 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801eea:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801ef1:	72 09                	jb     801efc <to_page_va+0x18>
  801ef3:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801efa:	72 14                	jb     801f10 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	68 b8 37 80 00       	push   $0x8037b8
  801f04:	6a 15                	push   $0x15
  801f06:	68 e3 37 80 00       	push   $0x8037e3
  801f0b:	e8 c0 e6 ff ff       	call   8005d0 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	ba 60 40 80 00       	mov    $0x804060,%edx
  801f18:	29 d0                	sub    %edx,%eax
  801f1a:	c1 f8 02             	sar    $0x2,%eax
  801f1d:	89 c2                	mov    %eax,%edx
  801f1f:	89 d0                	mov    %edx,%eax
  801f21:	c1 e0 02             	shl    $0x2,%eax
  801f24:	01 d0                	add    %edx,%eax
  801f26:	c1 e0 02             	shl    $0x2,%eax
  801f29:	01 d0                	add    %edx,%eax
  801f2b:	c1 e0 02             	shl    $0x2,%eax
  801f2e:	01 d0                	add    %edx,%eax
  801f30:	89 c1                	mov    %eax,%ecx
  801f32:	c1 e1 08             	shl    $0x8,%ecx
  801f35:	01 c8                	add    %ecx,%eax
  801f37:	89 c1                	mov    %eax,%ecx
  801f39:	c1 e1 10             	shl    $0x10,%ecx
  801f3c:	01 c8                	add    %ecx,%eax
  801f3e:	01 c0                	add    %eax,%eax
  801f40:	01 d0                	add    %edx,%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	c1 e0 0c             	shl    $0xc,%eax
  801f4b:	89 c2                	mov    %eax,%edx
  801f4d:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801f52:	01 d0                	add    %edx,%eax
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801f5c:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801f61:	8b 55 08             	mov    0x8(%ebp),%edx
  801f64:	29 c2                	sub    %eax,%edx
  801f66:	89 d0                	mov    %edx,%eax
  801f68:	c1 e8 0c             	shr    $0xc,%eax
  801f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f72:	78 09                	js     801f7d <to_page_info+0x27>
  801f74:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801f7b:	7e 14                	jle    801f91 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	68 fc 37 80 00       	push   $0x8037fc
  801f85:	6a 22                	push   $0x22
  801f87:	68 e3 37 80 00       	push   $0x8037e3
  801f8c:	e8 3f e6 ff ff       	call   8005d0 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f94:	89 d0                	mov    %edx,%eax
  801f96:	01 c0                	add    %eax,%eax
  801f98:	01 d0                	add    %edx,%eax
  801f9a:	c1 e0 02             	shl    $0x2,%eax
  801f9d:	05 60 40 80 00       	add    $0x804060,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	05 00 00 00 02       	add    $0x2000000,%eax
  801fb2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb5:	73 16                	jae    801fcd <initialize_dynamic_allocator+0x29>
  801fb7:	68 20 38 80 00       	push   $0x803820
  801fbc:	68 46 38 80 00       	push   $0x803846
  801fc1:	6a 34                	push   $0x34
  801fc3:	68 e3 37 80 00       	push   $0x8037e3
  801fc8:	e8 03 e6 ff ff       	call   8005d0 <_panic>
		is_initialized = 1;
  801fcd:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801fd4:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe2:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801fe7:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801fee:	00 00 00 
  801ff1:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801ff8:	00 00 00 
  801ffb:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802002:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802005:	8b 45 0c             	mov    0xc(%ebp),%eax
  802008:	2b 45 08             	sub    0x8(%ebp),%eax
  80200b:	c1 e8 0c             	shr    $0xc,%eax
  80200e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802011:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802018:	e9 c8 00 00 00       	jmp    8020e5 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  80201d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802020:	89 d0                	mov    %edx,%eax
  802022:	01 c0                	add    %eax,%eax
  802024:	01 d0                	add    %edx,%eax
  802026:	c1 e0 02             	shl    $0x2,%eax
  802029:	05 68 40 80 00       	add    $0x804068,%eax
  80202e:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802036:	89 d0                	mov    %edx,%eax
  802038:	01 c0                	add    %eax,%eax
  80203a:	01 d0                	add    %edx,%eax
  80203c:	c1 e0 02             	shl    $0x2,%eax
  80203f:	05 6a 40 80 00       	add    $0x80406a,%eax
  802044:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  802049:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80204f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802052:	89 c8                	mov    %ecx,%eax
  802054:	01 c0                	add    %eax,%eax
  802056:	01 c8                	add    %ecx,%eax
  802058:	c1 e0 02             	shl    $0x2,%eax
  80205b:	05 64 40 80 00       	add    $0x804064,%eax
  802060:	89 10                	mov    %edx,(%eax)
  802062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802065:	89 d0                	mov    %edx,%eax
  802067:	01 c0                	add    %eax,%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	c1 e0 02             	shl    $0x2,%eax
  80206e:	05 64 40 80 00       	add    $0x804064,%eax
  802073:	8b 00                	mov    (%eax),%eax
  802075:	85 c0                	test   %eax,%eax
  802077:	74 1b                	je     802094 <initialize_dynamic_allocator+0xf0>
  802079:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80207f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802082:	89 c8                	mov    %ecx,%eax
  802084:	01 c0                	add    %eax,%eax
  802086:	01 c8                	add    %ecx,%eax
  802088:	c1 e0 02             	shl    $0x2,%eax
  80208b:	05 60 40 80 00       	add    $0x804060,%eax
  802090:	89 02                	mov    %eax,(%edx)
  802092:	eb 16                	jmp    8020aa <initialize_dynamic_allocator+0x106>
  802094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802097:	89 d0                	mov    %edx,%eax
  802099:	01 c0                	add    %eax,%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	c1 e0 02             	shl    $0x2,%eax
  8020a0:	05 60 40 80 00       	add    $0x804060,%eax
  8020a5:	a3 48 40 80 00       	mov    %eax,0x804048
  8020aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ad:	89 d0                	mov    %edx,%eax
  8020af:	01 c0                	add    %eax,%eax
  8020b1:	01 d0                	add    %edx,%eax
  8020b3:	c1 e0 02             	shl    $0x2,%eax
  8020b6:	05 60 40 80 00       	add    $0x804060,%eax
  8020bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c3:	89 d0                	mov    %edx,%eax
  8020c5:	01 c0                	add    %eax,%eax
  8020c7:	01 d0                	add    %edx,%eax
  8020c9:	c1 e0 02             	shl    $0x2,%eax
  8020cc:	05 60 40 80 00       	add    $0x804060,%eax
  8020d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020d7:	a1 54 40 80 00       	mov    0x804054,%eax
  8020dc:	40                   	inc    %eax
  8020dd:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  8020e2:	ff 45 f4             	incl   -0xc(%ebp)
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020eb:	0f 8c 2c ff ff ff    	jl     80201d <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8020f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8020f8:	eb 36                	jmp    802130 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  8020fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fd:	c1 e0 04             	shl    $0x4,%eax
  802100:	05 80 c0 81 00       	add    $0x81c080,%eax
  802105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	c1 e0 04             	shl    $0x4,%eax
  802111:	05 84 c0 81 00       	add    $0x81c084,%eax
  802116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211f:	c1 e0 04             	shl    $0x4,%eax
  802122:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802127:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80212d:	ff 45 f0             	incl   -0x10(%ebp)
  802130:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802134:	7e c4                	jle    8020fa <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	50                   	push   %eax
  802146:	e8 0b fe ff ff       	call   801f56 <to_page_info>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	8b 40 08             	mov    0x8(%eax),%eax
  802157:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802162:	83 ec 0c             	sub    $0xc,%esp
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	e8 77 fd ff ff       	call   801ee4 <to_page_va>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802173:	b8 00 10 00 00       	mov    $0x1000,%eax
  802178:	ba 00 00 00 00       	mov    $0x0,%edx
  80217d:	f7 75 08             	divl   0x8(%ebp)
  802180:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	50                   	push   %eax
  80218a:	e8 48 f6 ff ff       	call   8017d7 <get_page>
  80218f:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a2:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8021a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8021ad:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8021b4:	eb 19                	jmp    8021cf <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8021b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b9:	ba 01 00 00 00       	mov    $0x1,%edx
  8021be:	88 c1                	mov    %al,%cl
  8021c0:	d3 e2                	shl    %cl,%edx
  8021c2:	89 d0                	mov    %edx,%eax
  8021c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c7:	74 0e                	je     8021d7 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8021c9:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8021cc:	ff 45 f0             	incl   -0x10(%ebp)
  8021cf:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021d3:	7e e1                	jle    8021b6 <split_page_to_blocks+0x5a>
  8021d5:	eb 01                	jmp    8021d8 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8021d7:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8021d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8021df:	e9 a7 00 00 00       	jmp    80228b <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8021e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e7:	0f af 45 08          	imul   0x8(%ebp),%eax
  8021eb:	89 c2                	mov    %eax,%edx
  8021ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f0:	01 d0                	add    %edx,%eax
  8021f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8021f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021f9:	75 14                	jne    80220f <split_page_to_blocks+0xb3>
  8021fb:	83 ec 04             	sub    $0x4,%esp
  8021fe:	68 5c 38 80 00       	push   $0x80385c
  802203:	6a 7c                	push   $0x7c
  802205:	68 e3 37 80 00       	push   $0x8037e3
  80220a:	e8 c1 e3 ff ff       	call   8005d0 <_panic>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	c1 e0 04             	shl    $0x4,%eax
  802215:	05 84 c0 81 00       	add    $0x81c084,%eax
  80221a:	8b 10                	mov    (%eax),%edx
  80221c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80221f:	89 50 04             	mov    %edx,0x4(%eax)
  802222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802225:	8b 40 04             	mov    0x4(%eax),%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	74 14                	je     802240 <split_page_to_blocks+0xe4>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	c1 e0 04             	shl    $0x4,%eax
  802232:	05 84 c0 81 00       	add    $0x81c084,%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80223c:	89 10                	mov    %edx,(%eax)
  80223e:	eb 11                	jmp    802251 <split_page_to_blocks+0xf5>
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	c1 e0 04             	shl    $0x4,%eax
  802246:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80224c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224f:	89 02                	mov    %eax,(%edx)
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	c1 e0 04             	shl    $0x4,%eax
  802257:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80225d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802260:	89 02                	mov    %eax,(%edx)
  802262:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	c1 e0 04             	shl    $0x4,%eax
  802271:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	8d 50 01             	lea    0x1(%eax),%edx
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	c1 e0 04             	shl    $0x4,%eax
  802281:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802286:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802288:	ff 45 ec             	incl   -0x14(%ebp)
  80228b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80228e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802291:	0f 82 4d ff ff ff    	jb     8021e4 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802297:	90                   	nop
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8022a0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022a7:	76 19                	jbe    8022c2 <alloc_block+0x28>
  8022a9:	68 80 38 80 00       	push   $0x803880
  8022ae:	68 46 38 80 00       	push   $0x803846
  8022b3:	68 8a 00 00 00       	push   $0x8a
  8022b8:	68 e3 37 80 00       	push   $0x8037e3
  8022bd:	e8 0e e3 ff ff       	call   8005d0 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8022c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8022c9:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8022d0:	eb 19                	jmp    8022eb <alloc_block+0x51>
		if((1 << i) >= size) break;
  8022d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8022da:	88 c1                	mov    %al,%cl
  8022dc:	d3 e2                	shl    %cl,%edx
  8022de:	89 d0                	mov    %edx,%eax
  8022e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e3:	73 0e                	jae    8022f3 <alloc_block+0x59>
		idx++;
  8022e5:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8022e8:	ff 45 f0             	incl   -0x10(%ebp)
  8022eb:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8022ef:	7e e1                	jle    8022d2 <alloc_block+0x38>
  8022f1:	eb 01                	jmp    8022f4 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8022f3:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	c1 e0 04             	shl    $0x4,%eax
  8022fa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 84 df 00 00 00    	je     8023e8 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	c1 e0 04             	shl    $0x4,%eax
  80230f:	05 80 c0 81 00       	add    $0x81c080,%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802319:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80231d:	75 17                	jne    802336 <alloc_block+0x9c>
  80231f:	83 ec 04             	sub    $0x4,%esp
  802322:	68 a1 38 80 00       	push   $0x8038a1
  802327:	68 9e 00 00 00       	push   $0x9e
  80232c:	68 e3 37 80 00       	push   $0x8037e3
  802331:	e8 9a e2 ff ff       	call   8005d0 <_panic>
  802336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	74 10                	je     80234f <alloc_block+0xb5>
  80233f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802347:	8b 52 04             	mov    0x4(%edx),%edx
  80234a:	89 50 04             	mov    %edx,0x4(%eax)
  80234d:	eb 14                	jmp    802363 <alloc_block+0xc9>
  80234f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802352:	8b 40 04             	mov    0x4(%eax),%eax
  802355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802358:	c1 e2 04             	shl    $0x4,%edx
  80235b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802361:	89 02                	mov    %eax,(%edx)
  802363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802366:	8b 40 04             	mov    0x4(%eax),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 0f                	je     80237c <alloc_block+0xe2>
  80236d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802370:	8b 40 04             	mov    0x4(%eax),%eax
  802373:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802376:	8b 12                	mov    (%edx),%edx
  802378:	89 10                	mov    %edx,(%eax)
  80237a:	eb 13                	jmp    80238f <alloc_block+0xf5>
  80237c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802384:	c1 e2 04             	shl    $0x4,%edx
  802387:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80238d:	89 02                	mov    %eax,(%edx)
  80238f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	c1 e0 04             	shl    $0x4,%eax
  8023a8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	c1 e0 04             	shl    $0x4,%eax
  8023b8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023bd:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	50                   	push   %eax
  8023c6:	e8 8b fb ff ff       	call   801f56 <to_page_info>
  8023cb:	83 c4 10             	add    $0x10,%esp
  8023ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8023d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023d8:	48                   	dec    %eax
  8023d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023dc:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8023e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e3:	e9 bc 02 00 00       	jmp    8026a4 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8023e8:	a1 54 40 80 00       	mov    0x804054,%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	0f 84 7d 02 00 00    	je     802672 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8023f5:	a1 48 40 80 00       	mov    0x804048,%eax
  8023fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8023fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802401:	75 17                	jne    80241a <alloc_block+0x180>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 a1 38 80 00       	push   $0x8038a1
  80240b:	68 a9 00 00 00       	push   $0xa9
  802410:	68 e3 37 80 00       	push   $0x8037e3
  802415:	e8 b6 e1 ff ff       	call   8005d0 <_panic>
  80241a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block+0x199>
  802423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block+0x1a4>
  802433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80243e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block+0x1bd>
  802448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block+0x1c7>
  802457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 48 40 80 00       	mov    %eax,0x804048
  802461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 54 40 80 00       	mov    0x804054,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	83 c0 03             	add    $0x3,%eax
  802485:	ba 01 00 00 00       	mov    $0x1,%edx
  80248a:	88 c1                	mov    %al,%cl
  80248c:	d3 e2                	shl    %cl,%edx
  80248e:	89 d0                	mov    %edx,%eax
  802490:	83 ec 08             	sub    $0x8,%esp
  802493:	ff 75 e4             	pushl  -0x1c(%ebp)
  802496:	50                   	push   %eax
  802497:	e8 c0 fc ff ff       	call   80215c <split_page_to_blocks>
  80249c:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c1 e0 04             	shl    $0x4,%eax
  8024a5:	05 80 c0 81 00       	add    $0x81c080,%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8024af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024b3:	75 17                	jne    8024cc <alloc_block+0x232>
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 a1 38 80 00       	push   $0x8038a1
  8024bd:	68 b0 00 00 00       	push   $0xb0
  8024c2:	68 e3 37 80 00       	push   $0x8037e3
  8024c7:	e8 04 e1 ff ff       	call   8005d0 <_panic>
  8024cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 10                	je     8024e5 <alloc_block+0x24b>
  8024d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024dd:	8b 52 04             	mov    0x4(%edx),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	eb 14                	jmp    8024f9 <alloc_block+0x25f>
  8024e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	c1 e2 04             	shl    $0x4,%edx
  8024f1:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024f7:	89 02                	mov    %eax,(%edx)
  8024f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0f                	je     802512 <alloc_block+0x278>
  802503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80250c:	8b 12                	mov    (%edx),%edx
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	eb 13                	jmp    802525 <alloc_block+0x28b>
  802512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251a:	c1 e2 04             	shl    $0x4,%edx
  80251d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802523:	89 02                	mov    %eax,(%edx)
  802525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	c1 e0 04             	shl    $0x4,%eax
  80253e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	8d 50 ff             	lea    -0x1(%eax),%edx
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	c1 e0 04             	shl    $0x4,%eax
  80254e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802553:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802558:	83 ec 0c             	sub    $0xc,%esp
  80255b:	50                   	push   %eax
  80255c:	e8 f5 f9 ff ff       	call   801f56 <to_page_info>
  802561:	83 c4 10             	add    $0x10,%esp
  802564:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802567:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80256e:	48                   	dec    %eax
  80256f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802572:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802576:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802579:	e9 26 01 00 00       	jmp    8026a4 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80257e:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	c1 e0 04             	shl    $0x4,%eax
  802587:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	0f 84 dc 00 00 00    	je     802672 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c1 e0 04             	shl    $0x4,%eax
  80259c:	05 80 c0 81 00       	add    $0x81c080,%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8025a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8025aa:	75 17                	jne    8025c3 <alloc_block+0x329>
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	68 a1 38 80 00       	push   $0x8038a1
  8025b4:	68 be 00 00 00       	push   $0xbe
  8025b9:	68 e3 37 80 00       	push   $0x8037e3
  8025be:	e8 0d e0 ff ff       	call   8005d0 <_panic>
  8025c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 10                	je     8025dc <alloc_block+0x342>
  8025cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025d4:	8b 52 04             	mov    0x4(%edx),%edx
  8025d7:	89 50 04             	mov    %edx,0x4(%eax)
  8025da:	eb 14                	jmp    8025f0 <alloc_block+0x356>
  8025dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	c1 e2 04             	shl    $0x4,%edx
  8025e8:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8025ee:	89 02                	mov    %eax,(%edx)
  8025f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025f3:	8b 40 04             	mov    0x4(%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 0f                	je     802609 <alloc_block+0x36f>
  8025fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802603:	8b 12                	mov    (%edx),%edx
  802605:	89 10                	mov    %edx,(%eax)
  802607:	eb 13                	jmp    80261c <alloc_block+0x382>
  802609:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80260c:	8b 00                	mov    (%eax),%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	c1 e2 04             	shl    $0x4,%edx
  802614:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80261a:	89 02                	mov    %eax,(%edx)
  80261c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80261f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802625:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c1 e0 04             	shl    $0x4,%eax
  802635:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	c1 e0 04             	shl    $0x4,%eax
  802645:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80264a:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80264c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80264f:	83 ec 0c             	sub    $0xc,%esp
  802652:	50                   	push   %eax
  802653:	e8 fe f8 ff ff       	call   801f56 <to_page_info>
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80265e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802661:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802665:	48                   	dec    %eax
  802666:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802669:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80266d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802670:	eb 32                	jmp    8026a4 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802672:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802676:	77 15                	ja     80268d <alloc_block+0x3f3>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	c1 e0 04             	shl    $0x4,%eax
  80267e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 84 f1 fe ff ff    	je     80257e <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 bf 38 80 00       	push   $0x8038bf
  802695:	68 c8 00 00 00       	push   $0xc8
  80269a:	68 e3 37 80 00       	push   $0x8037e3
  80269f:	e8 2c df ff ff       	call   8005d0 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8026ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8026af:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8026b4:	39 c2                	cmp    %eax,%edx
  8026b6:	72 0c                	jb     8026c4 <free_block+0x1e>
  8026b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bb:	a1 40 40 80 00       	mov    0x804040,%eax
  8026c0:	39 c2                	cmp    %eax,%edx
  8026c2:	72 19                	jb     8026dd <free_block+0x37>
  8026c4:	68 d0 38 80 00       	push   $0x8038d0
  8026c9:	68 46 38 80 00       	push   $0x803846
  8026ce:	68 d7 00 00 00       	push   $0xd7
  8026d3:	68 e3 37 80 00       	push   $0x8037e3
  8026d8:	e8 f3 de ff ff       	call   8005d0 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8026dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	50                   	push   %eax
  8026ea:	e8 67 f8 ff ff       	call   801f56 <to_page_info>
  8026ef:	83 c4 10             	add    $0x10,%esp
  8026f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8026f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f8:	8b 40 08             	mov    0x8(%eax),%eax
  8026fb:	0f b7 c0             	movzwl %ax,%eax
  8026fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802708:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80270f:	eb 19                	jmp    80272a <free_block+0x84>
	    if ((1 << i) == blk_size)
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	ba 01 00 00 00       	mov    $0x1,%edx
  802719:	88 c1                	mov    %al,%cl
  80271b:	d3 e2                	shl    %cl,%edx
  80271d:	89 d0                	mov    %edx,%eax
  80271f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802722:	74 0e                	je     802732 <free_block+0x8c>
	        break;
	    idx++;
  802724:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802727:	ff 45 f0             	incl   -0x10(%ebp)
  80272a:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80272e:	7e e1                	jle    802711 <free_block+0x6b>
  802730:	eb 01                	jmp    802733 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802732:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80273a:	40                   	inc    %eax
  80273b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802742:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802746:	75 17                	jne    80275f <free_block+0xb9>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 5c 38 80 00       	push   $0x80385c
  802750:	68 ee 00 00 00       	push   $0xee
  802755:	68 e3 37 80 00       	push   $0x8037e3
  80275a:	e8 71 de ff ff       	call   8005d0 <_panic>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	c1 e0 04             	shl    $0x4,%eax
  802765:	05 84 c0 81 00       	add    $0x81c084,%eax
  80276a:	8b 10                	mov    (%eax),%edx
  80276c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276f:	89 50 04             	mov    %edx,0x4(%eax)
  802772:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	74 14                	je     802790 <free_block+0xea>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	c1 e0 04             	shl    $0x4,%eax
  802782:	05 84 c0 81 00       	add    $0x81c084,%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80278c:	89 10                	mov    %edx,(%eax)
  80278e:	eb 11                	jmp    8027a1 <free_block+0xfb>
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	c1 e0 04             	shl    $0x4,%eax
  802796:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80279c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279f:	89 02                	mov    %eax,(%edx)
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	c1 e0 04             	shl    $0x4,%eax
  8027a7:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8027ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b0:	89 02                	mov    %eax,(%edx)
  8027b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	c1 e0 04             	shl    $0x4,%eax
  8027c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	8d 50 01             	lea    0x1(%eax),%edx
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	c1 e0 04             	shl    $0x4,%eax
  8027d1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8027d6:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8027d8:	b8 00 10 00 00       	mov    $0x1000,%eax
  8027dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e2:	f7 75 e0             	divl   -0x20(%ebp)
  8027e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8027e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027eb:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8027ef:	0f b7 c0             	movzwl %ax,%eax
  8027f2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027f5:	0f 85 70 01 00 00    	jne    80296b <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  802801:	e8 de f6 ff ff       	call   801ee4 <to_page_va>
  802806:	83 c4 10             	add    $0x10,%esp
  802809:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80280c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802813:	e9 b7 00 00 00       	jmp    8028cf <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802818:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	01 d0                	add    %edx,%eax
  802820:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802823:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802827:	75 17                	jne    802840 <free_block+0x19a>
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	68 a1 38 80 00       	push   $0x8038a1
  802831:	68 f8 00 00 00       	push   $0xf8
  802836:	68 e3 37 80 00       	push   $0x8037e3
  80283b:	e8 90 dd ff ff       	call   8005d0 <_panic>
  802840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 10                	je     802859 <free_block+0x1b3>
  802849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802851:	8b 52 04             	mov    0x4(%edx),%edx
  802854:	89 50 04             	mov    %edx,0x4(%eax)
  802857:	eb 14                	jmp    80286d <free_block+0x1c7>
  802859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80285c:	8b 40 04             	mov    0x4(%eax),%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	c1 e2 04             	shl    $0x4,%edx
  802865:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80286b:	89 02                	mov    %eax,(%edx)
  80286d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 0f                	je     802886 <free_block+0x1e0>
  802877:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802880:	8b 12                	mov    (%edx),%edx
  802882:	89 10                	mov    %edx,(%eax)
  802884:	eb 13                	jmp    802899 <free_block+0x1f3>
  802886:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288e:	c1 e2 04             	shl    $0x4,%edx
  802891:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802897:	89 02                	mov    %eax,(%edx)
  802899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80289c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8028a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	c1 e0 04             	shl    $0x4,%eax
  8028b2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	c1 e0 04             	shl    $0x4,%eax
  8028c2:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028c7:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8028c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cc:	01 45 ec             	add    %eax,-0x14(%ebp)
  8028cf:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8028d6:	0f 86 3c ff ff ff    	jbe    802818 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8028dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028df:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8028e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e8:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8028ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028f2:	75 17                	jne    80290b <free_block+0x265>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 5c 38 80 00       	push   $0x80385c
  8028fc:	68 fe 00 00 00       	push   $0xfe
  802901:	68 e3 37 80 00       	push   $0x8037e3
  802906:	e8 c5 dc ff ff       	call   8005d0 <_panic>
  80290b:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802911:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 0c                	je     80292d <free_block+0x287>
  802921:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802926:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	eb 08                	jmp    802935 <free_block+0x28f>
  80292d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802930:	a3 48 40 80 00       	mov    %eax,0x804048
  802935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802938:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802946:	a1 54 40 80 00       	mov    0x804054,%eax
  80294b:	40                   	inc    %eax
  80294c:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802951:	83 ec 0c             	sub    $0xc,%esp
  802954:	ff 75 e4             	pushl  -0x1c(%ebp)
  802957:	e8 88 f5 ff ff       	call   801ee4 <to_page_va>
  80295c:	83 c4 10             	add    $0x10,%esp
  80295f:	83 ec 0c             	sub    $0xc,%esp
  802962:	50                   	push   %eax
  802963:	e8 b8 ee ff ff       	call   801820 <return_page>
  802968:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  80296b:	90                   	nop
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	68 08 39 80 00       	push   $0x803908
  80297c:	68 11 01 00 00       	push   $0x111
  802981:	68 e3 37 80 00       	push   $0x8037e3
  802986:	e8 45 dc ff ff       	call   8005d0 <_panic>

0080298b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 d0                	mov    %edx,%eax
  802996:	c1 e0 02             	shl    $0x2,%eax
  802999:	01 d0                	add    %edx,%eax
  80299b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029a2:	01 d0                	add    %edx,%eax
  8029a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029ab:	01 d0                	add    %edx,%eax
  8029ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8029b4:	01 d0                	add    %edx,%eax
  8029b6:	c1 e0 04             	shl    $0x4,%eax
  8029b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  8029bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8029c3:	0f 31                	rdtsc  
  8029c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8029cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029d4:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8029d7:	eb 46                	jmp    802a1f <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8029d9:	0f 31                	rdtsc  
  8029db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8029de:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8029e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8029e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8029ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8029ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	29 c2                	sub    %eax,%edx
  8029f5:	89 d0                	mov    %edx,%eax
  8029f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8029fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	89 d1                	mov    %edx,%ecx
  802a02:	29 c1                	sub    %eax,%ecx
  802a04:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0a:	39 c2                	cmp    %eax,%edx
  802a0c:	0f 97 c0             	seta   %al
  802a0f:	0f b6 c0             	movzbl %al,%eax
  802a12:	29 c1                	sub    %eax,%ecx
  802a14:	89 c8                	mov    %ecx,%eax
  802a16:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  802a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802a25:	72 b2                	jb     8029d9 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802a27:	90                   	nop
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802a37:	eb 03                	jmp    802a3c <busy_wait+0x12>
  802a39:	ff 45 fc             	incl   -0x4(%ebp)
  802a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a42:	72 f5                	jb     802a39 <busy_wait+0xf>
	return i;
  802a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802a47:	c9                   	leave  
  802a48:	c3                   	ret    
  802a49:	66 90                	xchg   %ax,%ax
  802a4b:	90                   	nop

00802a4c <__udivdi3>:
  802a4c:	55                   	push   %ebp
  802a4d:	57                   	push   %edi
  802a4e:	56                   	push   %esi
  802a4f:	53                   	push   %ebx
  802a50:	83 ec 1c             	sub    $0x1c,%esp
  802a53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802a57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802a5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a63:	89 ca                	mov    %ecx,%edx
  802a65:	89 f8                	mov    %edi,%eax
  802a67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802a6b:	85 f6                	test   %esi,%esi
  802a6d:	75 2d                	jne    802a9c <__udivdi3+0x50>
  802a6f:	39 cf                	cmp    %ecx,%edi
  802a71:	77 65                	ja     802ad8 <__udivdi3+0x8c>
  802a73:	89 fd                	mov    %edi,%ebp
  802a75:	85 ff                	test   %edi,%edi
  802a77:	75 0b                	jne    802a84 <__udivdi3+0x38>
  802a79:	b8 01 00 00 00       	mov    $0x1,%eax
  802a7e:	31 d2                	xor    %edx,%edx
  802a80:	f7 f7                	div    %edi
  802a82:	89 c5                	mov    %eax,%ebp
  802a84:	31 d2                	xor    %edx,%edx
  802a86:	89 c8                	mov    %ecx,%eax
  802a88:	f7 f5                	div    %ebp
  802a8a:	89 c1                	mov    %eax,%ecx
  802a8c:	89 d8                	mov    %ebx,%eax
  802a8e:	f7 f5                	div    %ebp
  802a90:	89 cf                	mov    %ecx,%edi
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	83 c4 1c             	add    $0x1c,%esp
  802a97:	5b                   	pop    %ebx
  802a98:	5e                   	pop    %esi
  802a99:	5f                   	pop    %edi
  802a9a:	5d                   	pop    %ebp
  802a9b:	c3                   	ret    
  802a9c:	39 ce                	cmp    %ecx,%esi
  802a9e:	77 28                	ja     802ac8 <__udivdi3+0x7c>
  802aa0:	0f bd fe             	bsr    %esi,%edi
  802aa3:	83 f7 1f             	xor    $0x1f,%edi
  802aa6:	75 40                	jne    802ae8 <__udivdi3+0x9c>
  802aa8:	39 ce                	cmp    %ecx,%esi
  802aaa:	72 0a                	jb     802ab6 <__udivdi3+0x6a>
  802aac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ab0:	0f 87 9e 00 00 00    	ja     802b54 <__udivdi3+0x108>
  802ab6:	b8 01 00 00 00       	mov    $0x1,%eax
  802abb:	89 fa                	mov    %edi,%edx
  802abd:	83 c4 1c             	add    $0x1c,%esp
  802ac0:	5b                   	pop    %ebx
  802ac1:	5e                   	pop    %esi
  802ac2:	5f                   	pop    %edi
  802ac3:	5d                   	pop    %ebp
  802ac4:	c3                   	ret    
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	31 ff                	xor    %edi,%edi
  802aca:	31 c0                	xor    %eax,%eax
  802acc:	89 fa                	mov    %edi,%edx
  802ace:	83 c4 1c             	add    $0x1c,%esp
  802ad1:	5b                   	pop    %ebx
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	89 d8                	mov    %ebx,%eax
  802ada:	f7 f7                	div    %edi
  802adc:	31 ff                	xor    %edi,%edi
  802ade:	89 fa                	mov    %edi,%edx
  802ae0:	83 c4 1c             	add    $0x1c,%esp
  802ae3:	5b                   	pop    %ebx
  802ae4:	5e                   	pop    %esi
  802ae5:	5f                   	pop    %edi
  802ae6:	5d                   	pop    %ebp
  802ae7:	c3                   	ret    
  802ae8:	bd 20 00 00 00       	mov    $0x20,%ebp
  802aed:	89 eb                	mov    %ebp,%ebx
  802aef:	29 fb                	sub    %edi,%ebx
  802af1:	89 f9                	mov    %edi,%ecx
  802af3:	d3 e6                	shl    %cl,%esi
  802af5:	89 c5                	mov    %eax,%ebp
  802af7:	88 d9                	mov    %bl,%cl
  802af9:	d3 ed                	shr    %cl,%ebp
  802afb:	89 e9                	mov    %ebp,%ecx
  802afd:	09 f1                	or     %esi,%ecx
  802aff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802b03:	89 f9                	mov    %edi,%ecx
  802b05:	d3 e0                	shl    %cl,%eax
  802b07:	89 c5                	mov    %eax,%ebp
  802b09:	89 d6                	mov    %edx,%esi
  802b0b:	88 d9                	mov    %bl,%cl
  802b0d:	d3 ee                	shr    %cl,%esi
  802b0f:	89 f9                	mov    %edi,%ecx
  802b11:	d3 e2                	shl    %cl,%edx
  802b13:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b17:	88 d9                	mov    %bl,%cl
  802b19:	d3 e8                	shr    %cl,%eax
  802b1b:	09 c2                	or     %eax,%edx
  802b1d:	89 d0                	mov    %edx,%eax
  802b1f:	89 f2                	mov    %esi,%edx
  802b21:	f7 74 24 0c          	divl   0xc(%esp)
  802b25:	89 d6                	mov    %edx,%esi
  802b27:	89 c3                	mov    %eax,%ebx
  802b29:	f7 e5                	mul    %ebp
  802b2b:	39 d6                	cmp    %edx,%esi
  802b2d:	72 19                	jb     802b48 <__udivdi3+0xfc>
  802b2f:	74 0b                	je     802b3c <__udivdi3+0xf0>
  802b31:	89 d8                	mov    %ebx,%eax
  802b33:	31 ff                	xor    %edi,%edi
  802b35:	e9 58 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b3a:	66 90                	xchg   %ax,%ax
  802b3c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802b40:	89 f9                	mov    %edi,%ecx
  802b42:	d3 e2                	shl    %cl,%edx
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	73 e9                	jae    802b31 <__udivdi3+0xe5>
  802b48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b4b:	31 ff                	xor    %edi,%edi
  802b4d:	e9 40 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b52:	66 90                	xchg   %ax,%ax
  802b54:	31 c0                	xor    %eax,%eax
  802b56:	e9 37 ff ff ff       	jmp    802a92 <__udivdi3+0x46>
  802b5b:	90                   	nop

00802b5c <__umoddi3>:
  802b5c:	55                   	push   %ebp
  802b5d:	57                   	push   %edi
  802b5e:	56                   	push   %esi
  802b5f:	53                   	push   %ebx
  802b60:	83 ec 1c             	sub    $0x1c,%esp
  802b63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802b67:	8b 74 24 34          	mov    0x34(%esp),%esi
  802b6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802b6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802b73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b7b:	89 f3                	mov    %esi,%ebx
  802b7d:	89 fa                	mov    %edi,%edx
  802b7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b83:	89 34 24             	mov    %esi,(%esp)
  802b86:	85 c0                	test   %eax,%eax
  802b88:	75 1a                	jne    802ba4 <__umoddi3+0x48>
  802b8a:	39 f7                	cmp    %esi,%edi
  802b8c:	0f 86 a2 00 00 00    	jbe    802c34 <__umoddi3+0xd8>
  802b92:	89 c8                	mov    %ecx,%eax
  802b94:	89 f2                	mov    %esi,%edx
  802b96:	f7 f7                	div    %edi
  802b98:	89 d0                	mov    %edx,%eax
  802b9a:	31 d2                	xor    %edx,%edx
  802b9c:	83 c4 1c             	add    $0x1c,%esp
  802b9f:	5b                   	pop    %ebx
  802ba0:	5e                   	pop    %esi
  802ba1:	5f                   	pop    %edi
  802ba2:	5d                   	pop    %ebp
  802ba3:	c3                   	ret    
  802ba4:	39 f0                	cmp    %esi,%eax
  802ba6:	0f 87 ac 00 00 00    	ja     802c58 <__umoddi3+0xfc>
  802bac:	0f bd e8             	bsr    %eax,%ebp
  802baf:	83 f5 1f             	xor    $0x1f,%ebp
  802bb2:	0f 84 ac 00 00 00    	je     802c64 <__umoddi3+0x108>
  802bb8:	bf 20 00 00 00       	mov    $0x20,%edi
  802bbd:	29 ef                	sub    %ebp,%edi
  802bbf:	89 fe                	mov    %edi,%esi
  802bc1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bc5:	89 e9                	mov    %ebp,%ecx
  802bc7:	d3 e0                	shl    %cl,%eax
  802bc9:	89 d7                	mov    %edx,%edi
  802bcb:	89 f1                	mov    %esi,%ecx
  802bcd:	d3 ef                	shr    %cl,%edi
  802bcf:	09 c7                	or     %eax,%edi
  802bd1:	89 e9                	mov    %ebp,%ecx
  802bd3:	d3 e2                	shl    %cl,%edx
  802bd5:	89 14 24             	mov    %edx,(%esp)
  802bd8:	89 d8                	mov    %ebx,%eax
  802bda:	d3 e0                	shl    %cl,%eax
  802bdc:	89 c2                	mov    %eax,%edx
  802bde:	8b 44 24 08          	mov    0x8(%esp),%eax
  802be2:	d3 e0                	shl    %cl,%eax
  802be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bec:	89 f1                	mov    %esi,%ecx
  802bee:	d3 e8                	shr    %cl,%eax
  802bf0:	09 d0                	or     %edx,%eax
  802bf2:	d3 eb                	shr    %cl,%ebx
  802bf4:	89 da                	mov    %ebx,%edx
  802bf6:	f7 f7                	div    %edi
  802bf8:	89 d3                	mov    %edx,%ebx
  802bfa:	f7 24 24             	mull   (%esp)
  802bfd:	89 c6                	mov    %eax,%esi
  802bff:	89 d1                	mov    %edx,%ecx
  802c01:	39 d3                	cmp    %edx,%ebx
  802c03:	0f 82 87 00 00 00    	jb     802c90 <__umoddi3+0x134>
  802c09:	0f 84 91 00 00 00    	je     802ca0 <__umoddi3+0x144>
  802c0f:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c13:	29 f2                	sub    %esi,%edx
  802c15:	19 cb                	sbb    %ecx,%ebx
  802c17:	89 d8                	mov    %ebx,%eax
  802c19:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802c1d:	d3 e0                	shl    %cl,%eax
  802c1f:	89 e9                	mov    %ebp,%ecx
  802c21:	d3 ea                	shr    %cl,%edx
  802c23:	09 d0                	or     %edx,%eax
  802c25:	89 e9                	mov    %ebp,%ecx
  802c27:	d3 eb                	shr    %cl,%ebx
  802c29:	89 da                	mov    %ebx,%edx
  802c2b:	83 c4 1c             	add    $0x1c,%esp
  802c2e:	5b                   	pop    %ebx
  802c2f:	5e                   	pop    %esi
  802c30:	5f                   	pop    %edi
  802c31:	5d                   	pop    %ebp
  802c32:	c3                   	ret    
  802c33:	90                   	nop
  802c34:	89 fd                	mov    %edi,%ebp
  802c36:	85 ff                	test   %edi,%edi
  802c38:	75 0b                	jne    802c45 <__umoddi3+0xe9>
  802c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3f:	31 d2                	xor    %edx,%edx
  802c41:	f7 f7                	div    %edi
  802c43:	89 c5                	mov    %eax,%ebp
  802c45:	89 f0                	mov    %esi,%eax
  802c47:	31 d2                	xor    %edx,%edx
  802c49:	f7 f5                	div    %ebp
  802c4b:	89 c8                	mov    %ecx,%eax
  802c4d:	f7 f5                	div    %ebp
  802c4f:	89 d0                	mov    %edx,%eax
  802c51:	e9 44 ff ff ff       	jmp    802b9a <__umoddi3+0x3e>
  802c56:	66 90                	xchg   %ax,%ax
  802c58:	89 c8                	mov    %ecx,%eax
  802c5a:	89 f2                	mov    %esi,%edx
  802c5c:	83 c4 1c             	add    $0x1c,%esp
  802c5f:	5b                   	pop    %ebx
  802c60:	5e                   	pop    %esi
  802c61:	5f                   	pop    %edi
  802c62:	5d                   	pop    %ebp
  802c63:	c3                   	ret    
  802c64:	3b 04 24             	cmp    (%esp),%eax
  802c67:	72 06                	jb     802c6f <__umoddi3+0x113>
  802c69:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802c6d:	77 0f                	ja     802c7e <__umoddi3+0x122>
  802c6f:	89 f2                	mov    %esi,%edx
  802c71:	29 f9                	sub    %edi,%ecx
  802c73:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802c77:	89 14 24             	mov    %edx,(%esp)
  802c7a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c7e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c82:	8b 14 24             	mov    (%esp),%edx
  802c85:	83 c4 1c             	add    $0x1c,%esp
  802c88:	5b                   	pop    %ebx
  802c89:	5e                   	pop    %esi
  802c8a:	5f                   	pop    %edi
  802c8b:	5d                   	pop    %ebp
  802c8c:	c3                   	ret    
  802c8d:	8d 76 00             	lea    0x0(%esi),%esi
  802c90:	2b 04 24             	sub    (%esp),%eax
  802c93:	19 fa                	sbb    %edi,%edx
  802c95:	89 d1                	mov    %edx,%ecx
  802c97:	89 c6                	mov    %eax,%esi
  802c99:	e9 71 ff ff ff       	jmp    802c0f <__umoddi3+0xb3>
  802c9e:	66 90                	xchg   %ax,%ax
  802ca0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802ca4:	72 ea                	jb     802c90 <__umoddi3+0x134>
  802ca6:	89 d9                	mov    %ebx,%ecx
  802ca8:	e9 62 ff ff ff       	jmp    802c0f <__umoddi3+0xb3>
