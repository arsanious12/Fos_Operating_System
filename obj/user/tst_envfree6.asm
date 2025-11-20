
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 a1 02 00 00       	call   8002d7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 80 2b 80 00       	push   $0x802b80
  800050:	e8 1f 17 00 00       	call   801774 <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 81 2d 80 00       	mov    $0x802d81,%ebx
  80006f:	ba 05 00 00 00       	mov    $0x5,%edx
  800074:	89 c7                	mov    %eax,%edi
  800076:	89 de                	mov    %ebx,%esi
  800078:	89 d1                	mov    %edx,%ecx
  80007a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80007c:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800082:	b9 14 00 00 00       	mov    $0x14,%ecx
  800087:	b8 00 00 00 00       	mov    $0x0,%eax
  80008c:	89 d7                	mov    %edx,%edi
  80008e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800090:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	50                   	push   %eax
  80009a:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000a0:	50                   	push   %eax
  8000a1:	e8 7e 1c 00 00       	call   801d24 <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 77 18 00 00       	call   801925 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 ba 18 00 00       	call   801970 <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 90 2b 80 00       	push   $0x802b90
  8000c4:	e8 a1 06 00 00       	call   80076a <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size, (myEnv->SecondListSize),50);
  8000cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d1:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 c3 2b 80 00       	push   $0x802bc3
  8000ed:	e8 8e 19 00 00       	call   801a80 <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000fd:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 40 80 00       	mov    0x804020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 cc 2b 80 00       	push   $0x802bcc
  800119:	e8 62 19 00 00       	call   801a80 <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 6f 19 00 00       	call   801a9e <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	68 10 27 00 00       	push   $0x2710
  80013a:	e8 18 27 00 00       	call   802857 <env_sleep>
  80013f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	ff 75 d4             	pushl  -0x2c(%ebp)
  800148:	e8 51 19 00 00       	call   801a9e <sys_run_env>
  80014d:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  800150:	90                   	nop
  800151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	83 f8 02             	cmp    $0x2,%eax
  800159:	75 f6                	jne    800151 <_main+0x119>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80015b:	e8 c5 17 00 00       	call   801925 <sys_calculate_free_frames>
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	50                   	push   %eax
  800164:	68 d8 2b 80 00       	push   $0x802bd8
  800169:	e8 fc 05 00 00       	call   80076a <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800171:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	50                   	push   %eax
  80017b:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 9d 1b 00 00       	call   801d24 <sys_utilities>
  800187:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80018a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800190:	bb e5 2d 80 00       	mov    $0x802de5,%ebx
  800195:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80019a:	89 c7                	mov    %eax,%edi
  80019c:	89 de                	mov    %ebx,%esi
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001a2:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a8:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001ad:	b0 00                	mov    $0x0,%al
  8001af:	89 d7                	mov    %edx,%edi
  8001b1:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	6a 00                	push   $0x0
  8001b8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 60 1b 00 00       	call   801d24 <sys_utilities>
  8001c4:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 e8 18 00 00       	call   801aba <sys_destroy_env>
  8001d2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001db:	e8 da 18 00 00       	call   801aba <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	6a 01                	push   $0x1
  8001e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001ee:	50                   	push   %eax
  8001ef:	e8 30 1b 00 00       	call   801d24 <sys_utilities>
  8001f4:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f7:	e8 29 17 00 00       	call   801925 <sys_calculate_free_frames>
  8001fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 6c 17 00 00       	call   801970 <sys_pf_calculate_allocated_pages>
  800204:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800207:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  80020e:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800217:	01 d0                	add    %edx,%eax
  800219:	48                   	dec    %eax
  80021a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80021d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800220:	ba 00 00 00 00       	mov    $0x0,%edx
  800225:	f7 75 c8             	divl   -0x38(%ebp)
  800228:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80022b:	29 d0                	sub    %edx,%eax
  80022d:	89 c1                	mov    %eax,%ecx
  80022f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800236:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  80023c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	48                   	dec    %eax
  800242:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800245:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	f7 75 c0             	divl   -0x40(%ebp)
  800250:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800253:	29 d0                	sub    %edx,%eax
  800255:	29 c1                	sub    %eax,%ecx
  800257:	89 c8                	mov    %ecx,%eax
  800259:	c1 e8 0c             	shr    $0xc,%eax
  80025c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 75 b8             	pushl  -0x48(%ebp)
  800265:	68 0a 2c 80 00       	push   $0x802c0a
  80026a:	e8 fb 04 00 00       	call   80076a <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800278:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80027b:	74 2e                	je     8002ab <_main+0x273>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  80027d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800280:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800283:	ff 75 b8             	pushl  -0x48(%ebp)
  800286:	50                   	push   %eax
  800287:	ff 75 d0             	pushl  -0x30(%ebp)
  80028a:	68 1c 2c 80 00       	push   $0x802c1c
  80028f:	e8 d6 04 00 00       	call   80076a <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 8c 2c 80 00       	push   $0x802c8c
  80029f:	6a 36                	push   $0x36
  8002a1:	68 c2 2c 80 00       	push   $0x802cc2
  8002a6:	e8 f1 01 00 00       	call   80049c <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 d0             	pushl  -0x30(%ebp)
  8002b1:	68 d8 2c 80 00       	push   $0x802cd8
  8002b6:	e8 af 04 00 00       	call   80076a <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 38 2d 80 00       	push   $0x802d38
  8002c6:	e8 9f 04 00 00       	call   80076a <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ce:	90                   	nop
}
  8002cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d2:	5b                   	pop    %ebx
  8002d3:	5e                   	pop    %esi
  8002d4:	5f                   	pop    %edi
  8002d5:	5d                   	pop    %ebp
  8002d6:	c3                   	ret    

008002d7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e0:	e8 09 18 00 00       	call   801aee <sys_getenvindex>
  8002e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 06             	shl    $0x6,%eax
  8002f0:	29 d0                	sub    %edx,%eax
  8002f2:	c1 e0 02             	shl    $0x2,%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002fe:	01 c8                	add    %ecx,%eax
  800300:	c1 e0 03             	shl    $0x3,%eax
  800303:	01 d0                	add    %edx,%eax
  800305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030c:	29 c2                	sub    %eax,%edx
  80030e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800315:	89 c2                	mov    %eax,%edx
  800317:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80031d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800322:	a1 20 40 80 00       	mov    0x804020,%eax
  800327:	8a 40 20             	mov    0x20(%eax),%al
  80032a:	84 c0                	test   %al,%al
  80032c:	74 0d                	je     80033b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	83 c0 20             	add    $0x20,%eax
  800336:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033f:	7e 0a                	jle    80034b <libmain+0x74>
		binaryname = argv[0];
  800341:	8b 45 0c             	mov    0xc(%ebp),%eax
  800344:	8b 00                	mov    (%eax),%eax
  800346:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	ff 75 0c             	pushl  0xc(%ebp)
  800351:	ff 75 08             	pushl  0x8(%ebp)
  800354:	e8 df fc ff ff       	call   800038 <_main>
  800359:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80035c:	a1 00 40 80 00       	mov    0x804000,%eax
  800361:	85 c0                	test   %eax,%eax
  800363:	0f 84 01 01 00 00    	je     80046a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800369:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80036f:	bb 44 2f 80 00       	mov    $0x802f44,%ebx
  800374:	ba 0e 00 00 00       	mov    $0xe,%edx
  800379:	89 c7                	mov    %eax,%edi
  80037b:	89 de                	mov    %ebx,%esi
  80037d:	89 d1                	mov    %edx,%ecx
  80037f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800381:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800384:	b9 56 00 00 00       	mov    $0x56,%ecx
  800389:	b0 00                	mov    $0x0,%al
  80038b:	89 d7                	mov    %edx,%edi
  80038d:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80038f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800396:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	50                   	push   %eax
  80039d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003a3:	50                   	push   %eax
  8003a4:	e8 7b 19 00 00       	call   801d24 <sys_utilities>
  8003a9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003ac:	e8 c4 14 00 00       	call   801875 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	68 64 2e 80 00       	push   $0x802e64
  8003b9:	e8 ac 03 00 00       	call   80076a <cprintf>
  8003be:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c4:	85 c0                	test   %eax,%eax
  8003c6:	74 18                	je     8003e0 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c8:	e8 75 19 00 00       	call   801d42 <sys_get_optimal_num_faults>
  8003cd:	83 ec 08             	sub    $0x8,%esp
  8003d0:	50                   	push   %eax
  8003d1:	68 8c 2e 80 00       	push   $0x802e8c
  8003d6:	e8 8f 03 00 00       	call   80076a <cprintf>
  8003db:	83 c4 10             	add    $0x10,%esp
  8003de:	eb 59                	jmp    800439 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e5:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f0:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003f6:	83 ec 04             	sub    $0x4,%esp
  8003f9:	52                   	push   %edx
  8003fa:	50                   	push   %eax
  8003fb:	68 b0 2e 80 00       	push   $0x802eb0
  800400:	e8 65 03 00 00       	call   80076a <cprintf>
  800405:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800413:	a1 20 40 80 00       	mov    0x804020,%eax
  800418:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80041e:	a1 20 40 80 00       	mov    0x804020,%eax
  800423:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800429:	51                   	push   %ecx
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	68 d8 2e 80 00       	push   $0x802ed8
  800431:	e8 34 03 00 00       	call   80076a <cprintf>
  800436:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800439:	a1 20 40 80 00       	mov    0x804020,%eax
  80043e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	50                   	push   %eax
  800448:	68 30 2f 80 00       	push   $0x802f30
  80044d:	e8 18 03 00 00       	call   80076a <cprintf>
  800452:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800455:	83 ec 0c             	sub    $0xc,%esp
  800458:	68 64 2e 80 00       	push   $0x802e64
  80045d:	e8 08 03 00 00       	call   80076a <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800465:	e8 25 14 00 00       	call   80188f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80046a:	e8 1f 00 00 00       	call   80048e <exit>
}
  80046f:	90                   	nop
  800470:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800473:	5b                   	pop    %ebx
  800474:	5e                   	pop    %esi
  800475:	5f                   	pop    %edi
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    

00800478 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047e:	83 ec 0c             	sub    $0xc,%esp
  800481:	6a 00                	push   $0x0
  800483:	e8 32 16 00 00       	call   801aba <sys_destroy_env>
  800488:	83 c4 10             	add    $0x10,%esp
}
  80048b:	90                   	nop
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <exit>:

void
exit(void)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800494:	e8 87 16 00 00       	call   801b20 <sys_exit_env>
}
  800499:	90                   	nop
  80049a:	c9                   	leave  
  80049b:	c3                   	ret    

0080049c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80049c:	55                   	push   %ebp
  80049d:	89 e5                	mov    %esp,%ebp
  80049f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004a2:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a5:	83 c0 04             	add    $0x4,%eax
  8004a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ab:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004b0:	85 c0                	test   %eax,%eax
  8004b2:	74 16                	je     8004ca <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b4:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	50                   	push   %eax
  8004bd:	68 a8 2f 80 00       	push   $0x802fa8
  8004c2:	e8 a3 02 00 00       	call   80076a <cprintf>
  8004c7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ca:	a1 04 40 80 00       	mov    0x804004,%eax
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	68 b0 2f 80 00       	push   $0x802fb0
  8004de:	6a 74                	push   $0x74
  8004e0:	e8 b2 02 00 00       	call   800797 <cprintf_colored>
  8004e5:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f1:	50                   	push   %eax
  8004f2:	e8 04 02 00 00       	call   8006fb <vcprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	6a 00                	push   $0x0
  8004ff:	68 d8 2f 80 00       	push   $0x802fd8
  800504:	e8 f2 01 00 00       	call   8006fb <vcprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80050c:	e8 7d ff ff ff       	call   80048e <exit>

	// should not return here
	while (1) ;
  800511:	eb fe                	jmp    800511 <_panic+0x75>

00800513 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
  800516:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800519:	a1 20 40 80 00       	mov    0x804020,%eax
  80051e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800524:	8b 45 0c             	mov    0xc(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	74 14                	je     80053f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052b:	83 ec 04             	sub    $0x4,%esp
  80052e:	68 dc 2f 80 00       	push   $0x802fdc
  800533:	6a 26                	push   $0x26
  800535:	68 28 30 80 00       	push   $0x803028
  80053a:	e8 5d ff ff ff       	call   80049c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80053f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800546:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80054d:	e9 c5 00 00 00       	jmp    800617 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800555:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 d0                	add    %edx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	85 c0                	test   %eax,%eax
  800565:	75 08                	jne    80056f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800567:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056a:	e9 a5 00 00 00       	jmp    800614 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80056f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800576:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80057d:	eb 69                	jmp    8005e8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80057f:	a1 20 40 80 00       	mov    0x804020,%eax
  800584:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80058a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80058d:	89 d0                	mov    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	c1 e0 03             	shl    $0x3,%eax
  800596:	01 c8                	add    %ecx,%eax
  800598:	8a 40 04             	mov    0x4(%eax),%al
  80059b:	84 c0                	test   %al,%al
  80059d:	75 46                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059f:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ad:	89 d0                	mov    %edx,%eax
  8005af:	01 c0                	add    %eax,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	c1 e0 03             	shl    $0x3,%eax
  8005b6:	01 c8                	add    %ecx,%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d8:	39 c2                	cmp    %eax,%edx
  8005da:	75 09                	jne    8005e5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e3:	eb 15                	jmp    8005fa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e5:	ff 45 e8             	incl   -0x18(%ebp)
  8005e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 85                	ja     80057f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 34 30 80 00       	push   $0x803034
  800608:	6a 3a                	push   $0x3a
  80060a:	68 28 30 80 00       	push   $0x803028
  80060f:	e8 88 fe ff ff       	call   80049c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 2f ff ff ff    	jl     800552 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800667:	39 c2                	cmp    %eax,%edx
  800669:	77 c8                	ja     800633 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800671:	74 14                	je     800687 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800673:	83 ec 04             	sub    $0x4,%esp
  800676:	68 88 30 80 00       	push   $0x803088
  80067b:	6a 44                	push   $0x44
  80067d:	68 28 30 80 00       	push   $0x803028
  800682:	e8 15 fe ff ff       	call   80049c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800687:	90                   	nop
  800688:	c9                   	leave  
  800689:	c3                   	ret    

0080068a <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	53                   	push   %ebx
  80068e:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800691:	8b 45 0c             	mov    0xc(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	8d 48 01             	lea    0x1(%eax),%ecx
  800699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069c:	89 0a                	mov    %ecx,(%edx)
  80069e:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a1:	88 d1                	mov    %dl,%cl
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b4:	75 30                	jne    8006e6 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b6:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006bc:	a0 44 40 80 00       	mov    0x804044,%al
  8006c1:	0f b6 c0             	movzbl %al,%eax
  8006c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c7:	8b 09                	mov    (%ecx),%ecx
  8006c9:	89 cb                	mov    %ecx,%ebx
  8006cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ce:	83 c1 08             	add    $0x8,%ecx
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	53                   	push   %ebx
  8006d4:	51                   	push   %ecx
  8006d5:	e8 57 11 00 00       	call   801831 <sys_cputs>
  8006da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e9:	8b 40 04             	mov    0x4(%eax),%eax
  8006ec:	8d 50 01             	lea    0x1(%eax),%edx
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f5:	90                   	nop
  8006f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800704:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070b:	00 00 00 
	b.cnt = 0;
  80070e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800715:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	68 8a 06 80 00       	push   $0x80068a
  80072a:	e8 5a 02 00 00       	call   800989 <vprintfmt>
  80072f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800732:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800738:	a0 44 40 80 00       	mov    0x804044,%al
  80073d:	0f b6 c0             	movzbl %al,%eax
  800740:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800746:	52                   	push   %edx
  800747:	50                   	push   %eax
  800748:	51                   	push   %ecx
  800749:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074f:	83 c0 08             	add    $0x8,%eax
  800752:	50                   	push   %eax
  800753:	e8 d9 10 00 00       	call   801831 <sys_cputs>
  800758:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80075b:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800762:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800770:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800777:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 f4             	pushl  -0xc(%ebp)
  800786:	50                   	push   %eax
  800787:	e8 6f ff ff ff       	call   8006fb <vcprintf>
  80078c:	83 c4 10             	add    $0x10,%esp
  80078f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800792:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80079d:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	c1 e0 08             	shl    $0x8,%eax
  8007aa:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  8007af:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b2:	83 c0 04             	add    $0x4,%eax
  8007b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c1:	50                   	push   %eax
  8007c2:	e8 34 ff ff ff       	call   8006fb <vcprintf>
  8007c7:	83 c4 10             	add    $0x10,%esp
  8007ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007cd:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007d4:	07 00 00 

	return cnt;
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007da:	c9                   	leave  
  8007db:	c3                   	ret    

008007dc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007e2:	e8 8e 10 00 00       	call   801875 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f6:	50                   	push   %eax
  8007f7:	e8 ff fe ff ff       	call   8006fb <vcprintf>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800802:	e8 88 10 00 00       	call   80188f <sys_unlock_cons>
	return cnt;
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80080a:	c9                   	leave  
  80080b:	c3                   	ret    

0080080c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	53                   	push   %ebx
  800810:	83 ec 14             	sub    $0x14,%esp
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081f:	8b 45 18             	mov    0x18(%ebp),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082a:	77 55                	ja     800881 <printnum+0x75>
  80082c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082f:	72 05                	jb     800836 <printnum+0x2a>
  800831:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800834:	77 4b                	ja     800881 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800836:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800839:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80083c:	8b 45 18             	mov    0x18(%ebp),%eax
  80083f:	ba 00 00 00 00       	mov    $0x0,%edx
  800844:	52                   	push   %edx
  800845:	50                   	push   %eax
  800846:	ff 75 f4             	pushl  -0xc(%ebp)
  800849:	ff 75 f0             	pushl  -0x10(%ebp)
  80084c:	e8 c7 20 00 00       	call   802918 <__udivdi3>
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	83 ec 04             	sub    $0x4,%esp
  800857:	ff 75 20             	pushl  0x20(%ebp)
  80085a:	53                   	push   %ebx
  80085b:	ff 75 18             	pushl  0x18(%ebp)
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 08             	pushl  0x8(%ebp)
  800866:	e8 a1 ff ff ff       	call   80080c <printnum>
  80086b:	83 c4 20             	add    $0x20,%esp
  80086e:	eb 1a                	jmp    80088a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	ff 75 20             	pushl  0x20(%ebp)
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800881:	ff 4d 1c             	decl   0x1c(%ebp)
  800884:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800888:	7f e6                	jg     800870 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80088a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80088d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800898:	53                   	push   %ebx
  800899:	51                   	push   %ecx
  80089a:	52                   	push   %edx
  80089b:	50                   	push   %eax
  80089c:	e8 87 21 00 00       	call   802a28 <__umoddi3>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	05 f4 32 80 00       	add    $0x8032f4,%eax
  8008a9:	8a 00                	mov    (%eax),%al
  8008ab:	0f be c0             	movsbl %al,%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	50                   	push   %eax
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	90                   	nop
  8008be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ca:	7e 1c                	jle    8008e8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 08             	lea    0x8(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 08             	sub    $0x8,%eax
  8008e1:	8b 50 04             	mov    0x4(%eax),%edx
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	eb 40                	jmp    800928 <getuint+0x65>
	else if (lflag)
  8008e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ec:	74 1e                	je     80090c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	8d 50 04             	lea    0x4(%eax),%edx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	89 10                	mov    %edx,(%eax)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	83 e8 04             	sub    $0x4,%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	ba 00 00 00 00       	mov    $0x0,%edx
  80090a:	eb 1c                	jmp    800928 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	89 10                	mov    %edx,(%eax)
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80092d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800931:	7e 1c                	jle    80094f <getint+0x25>
		return va_arg(*ap, long long);
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 50 08             	lea    0x8(%eax),%edx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 10                	mov    %edx,(%eax)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	83 e8 08             	sub    $0x8,%eax
  800948:	8b 50 04             	mov    0x4(%eax),%edx
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	eb 38                	jmp    800987 <getint+0x5d>
	else if (lflag)
  80094f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800953:	74 1a                	je     80096f <getint+0x45>
		return va_arg(*ap, long);
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 50 04             	lea    0x4(%eax),%edx
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	89 10                	mov    %edx,(%eax)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	83 e8 04             	sub    $0x4,%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	99                   	cltd   
  80096d:	eb 18                	jmp    800987 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	89 10                	mov    %edx,(%eax)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	83 e8 04             	sub    $0x4,%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	99                   	cltd   
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	56                   	push   %esi
  80098d:	53                   	push   %ebx
  80098e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800991:	eb 17                	jmp    8009aa <vprintfmt+0x21>
			if (ch == '\0')
  800993:	85 db                	test   %ebx,%ebx
  800995:	0f 84 c1 03 00 00    	je     800d5c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 0c             	pushl  0xc(%ebp)
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	ff d0                	call   *%eax
  8009a7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b3:	8a 00                	mov    (%eax),%al
  8009b5:	0f b6 d8             	movzbl %al,%ebx
  8009b8:	83 fb 25             	cmp    $0x25,%ebx
  8009bb:	75 d6                	jne    800993 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009bd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e0:	8d 50 01             	lea    0x1(%eax),%edx
  8009e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e6:	8a 00                	mov    (%eax),%al
  8009e8:	0f b6 d8             	movzbl %al,%ebx
  8009eb:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ee:	83 f8 5b             	cmp    $0x5b,%eax
  8009f1:	0f 87 3d 03 00 00    	ja     800d34 <vprintfmt+0x3ab>
  8009f7:	8b 04 85 18 33 80 00 	mov    0x803318(,%eax,4),%eax
  8009fe:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a00:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a04:	eb d7                	jmp    8009dd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a06:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a0a:	eb d1                	jmp    8009dd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a16:	89 d0                	mov    %edx,%eax
  800a18:	c1 e0 02             	shl    $0x2,%eax
  800a1b:	01 d0                	add    %edx,%eax
  800a1d:	01 c0                	add    %eax,%eax
  800a1f:	01 d8                	add    %ebx,%eax
  800a21:	83 e8 30             	sub    $0x30,%eax
  800a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a32:	7e 3e                	jle    800a72 <vprintfmt+0xe9>
  800a34:	83 fb 39             	cmp    $0x39,%ebx
  800a37:	7f 39                	jg     800a72 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a39:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a3c:	eb d5                	jmp    800a13 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax
  800a4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a58:	79 83                	jns    8009dd <vprintfmt+0x54>
				width = 0;
  800a5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a61:	e9 77 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a66:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a6d:	e9 6b ff ff ff       	jmp    8009dd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a72:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a77:	0f 89 60 ff ff ff    	jns    8009dd <vprintfmt+0x54>
				width = precision, precision = -1;
  800a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a83:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a8a:	e9 4e ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a92:	e9 46 ff ff ff       	jmp    8009dd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	ff 75 0c             	pushl  0xc(%ebp)
  800aae:	50                   	push   %eax
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	ff d0                	call   *%eax
  800ab4:	83 c4 10             	add    $0x10,%esp
			break;
  800ab7:	e9 9b 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 c0 04             	add    $0x4,%eax
  800ac2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	83 e8 04             	sub    $0x4,%eax
  800acb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800acd:	85 db                	test   %ebx,%ebx
  800acf:	79 02                	jns    800ad3 <vprintfmt+0x14a>
				err = -err;
  800ad1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ad3:	83 fb 64             	cmp    $0x64,%ebx
  800ad6:	7f 0b                	jg     800ae3 <vprintfmt+0x15a>
  800ad8:	8b 34 9d 60 31 80 00 	mov    0x803160(,%ebx,4),%esi
  800adf:	85 f6                	test   %esi,%esi
  800ae1:	75 19                	jne    800afc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ae3:	53                   	push   %ebx
  800ae4:	68 05 33 80 00       	push   $0x803305
  800ae9:	ff 75 0c             	pushl  0xc(%ebp)
  800aec:	ff 75 08             	pushl  0x8(%ebp)
  800aef:	e8 70 02 00 00       	call   800d64 <printfmt>
  800af4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af7:	e9 5b 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800afc:	56                   	push   %esi
  800afd:	68 0e 33 80 00       	push   $0x80330e
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	ff 75 08             	pushl  0x8(%ebp)
  800b08:	e8 57 02 00 00       	call   800d64 <printfmt>
  800b0d:	83 c4 10             	add    $0x10,%esp
			break;
  800b10:	e9 42 02 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	83 e8 04             	sub    $0x4,%eax
  800b24:	8b 30                	mov    (%eax),%esi
  800b26:	85 f6                	test   %esi,%esi
  800b28:	75 05                	jne    800b2f <vprintfmt+0x1a6>
				p = "(null)";
  800b2a:	be 11 33 80 00       	mov    $0x803311,%esi
			if (width > 0 && padc != '-')
  800b2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b33:	7e 6d                	jle    800ba2 <vprintfmt+0x219>
  800b35:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b39:	74 67                	je     800ba2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	50                   	push   %eax
  800b42:	56                   	push   %esi
  800b43:	e8 1e 03 00 00       	call   800e66 <strnlen>
  800b48:	83 c4 10             	add    $0x10,%esp
  800b4b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b4e:	eb 16                	jmp    800b66 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b50:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	50                   	push   %eax
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	ff d0                	call   *%eax
  800b60:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b63:	ff 4d e4             	decl   -0x1c(%ebp)
  800b66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6a:	7f e4                	jg     800b50 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b6c:	eb 34                	jmp    800ba2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b6e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b72:	74 1c                	je     800b90 <vprintfmt+0x207>
  800b74:	83 fb 1f             	cmp    $0x1f,%ebx
  800b77:	7e 05                	jle    800b7e <vprintfmt+0x1f5>
  800b79:	83 fb 7e             	cmp    $0x7e,%ebx
  800b7c:	7e 12                	jle    800b90 <vprintfmt+0x207>
					putch('?', putdat);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 0c             	pushl  0xc(%ebp)
  800b84:	6a 3f                	push   $0x3f
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	ff d0                	call   *%eax
  800b8b:	83 c4 10             	add    $0x10,%esp
  800b8e:	eb 0f                	jmp    800b9f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b90:	83 ec 08             	sub    $0x8,%esp
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	53                   	push   %ebx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9f:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba2:	89 f0                	mov    %esi,%eax
  800ba4:	8d 70 01             	lea    0x1(%eax),%esi
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	0f be d8             	movsbl %al,%ebx
  800bac:	85 db                	test   %ebx,%ebx
  800bae:	74 24                	je     800bd4 <vprintfmt+0x24b>
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	78 b8                	js     800b6e <vprintfmt+0x1e5>
  800bb6:	ff 4d e0             	decl   -0x20(%ebp)
  800bb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bbd:	79 af                	jns    800b6e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbf:	eb 13                	jmp    800bd4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 20                	push   $0x20
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bd1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bd4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd8:	7f e7                	jg     800bc1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bda:	e9 78 01 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 e8             	pushl  -0x18(%ebp)
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	e8 3c fd ff ff       	call   80092a <getint>
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	85 d2                	test   %edx,%edx
  800bff:	79 23                	jns    800c24 <vprintfmt+0x29b>
				putch('-', putdat);
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 0c             	pushl  0xc(%ebp)
  800c07:	6a 2d                	push   $0x2d
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	ff d0                	call   *%eax
  800c0e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c17:	f7 d8                	neg    %eax
  800c19:	83 d2 00             	adc    $0x0,%edx
  800c1c:	f7 da                	neg    %edx
  800c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c24:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2b:	e9 bc 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c30:	83 ec 08             	sub    $0x8,%esp
  800c33:	ff 75 e8             	pushl  -0x18(%ebp)
  800c36:	8d 45 14             	lea    0x14(%ebp),%eax
  800c39:	50                   	push   %eax
  800c3a:	e8 84 fc ff ff       	call   8008c3 <getuint>
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c45:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c48:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4f:	e9 98 00 00 00       	jmp    800cec <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c54:	83 ec 08             	sub    $0x8,%esp
  800c57:	ff 75 0c             	pushl  0xc(%ebp)
  800c5a:	6a 58                	push   $0x58
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	ff d0                	call   *%eax
  800c61:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 58                	push   $0x58
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 58                	push   $0x58
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			break;
  800c84:	e9 ce 00 00 00       	jmp    800d57 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c89:	83 ec 08             	sub    $0x8,%esp
  800c8c:	ff 75 0c             	pushl  0xc(%ebp)
  800c8f:	6a 30                	push   $0x30
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c99:	83 ec 08             	sub    $0x8,%esp
  800c9c:	ff 75 0c             	pushl  0xc(%ebp)
  800c9f:	6a 78                	push   $0x78
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	ff d0                	call   *%eax
  800ca6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 c0 04             	add    $0x4,%eax
  800caf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb5:	83 e8 04             	sub    $0x4,%eax
  800cb8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cc4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ccb:	eb 1f                	jmp    800cec <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ccd:	83 ec 08             	sub    $0x8,%esp
  800cd0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cd3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd6:	50                   	push   %eax
  800cd7:	e8 e7 fb ff ff       	call   8008c3 <getuint>
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cec:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	52                   	push   %edx
  800cf7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfe:	ff 75 f0             	pushl  -0x10(%ebp)
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 00 fb ff ff       	call   80080c <printnum>
  800d0c:	83 c4 20             	add    $0x20,%esp
			break;
  800d0f:	eb 46                	jmp    800d57 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	53                   	push   %ebx
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	ff d0                	call   *%eax
  800d1d:	83 c4 10             	add    $0x10,%esp
			break;
  800d20:	eb 35                	jmp    800d57 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d22:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d29:	eb 2c                	jmp    800d57 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d2b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d32:	eb 23                	jmp    800d57 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	6a 25                	push   $0x25
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	ff d0                	call   *%eax
  800d41:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	eb 03                	jmp    800d4c <vprintfmt+0x3c3>
  800d49:	ff 4d 10             	decl   0x10(%ebp)
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	48                   	dec    %eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3c 25                	cmp    $0x25,%al
  800d54:	75 f3                	jne    800d49 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d56:	90                   	nop
		}
	}
  800d57:	e9 35 fc ff ff       	jmp    800991 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d5c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d6a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d6d:	83 c0 04             	add    $0x4,%eax
  800d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	ff 75 f4             	pushl  -0xc(%ebp)
  800d79:	50                   	push   %eax
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	ff 75 08             	pushl  0x8(%ebp)
  800d80:	e8 04 fc ff ff       	call   800989 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d88:	90                   	nop
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	8b 40 08             	mov    0x8(%eax),%eax
  800d94:	8d 50 01             	lea    0x1(%eax),%edx
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8b 10                	mov    (%eax),%edx
  800da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da5:	8b 40 04             	mov    0x4(%eax),%eax
  800da8:	39 c2                	cmp    %eax,%edx
  800daa:	73 12                	jae    800dbe <sprintputch+0x33>
		*b->buf++ = ch;
  800dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daf:	8b 00                	mov    (%eax),%eax
  800db1:	8d 48 01             	lea    0x1(%eax),%ecx
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	89 0a                	mov    %ecx,(%edx)
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	88 10                	mov    %dl,(%eax)
}
  800dbe:	90                   	nop
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	01 d0                	add    %edx,%eax
  800dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ddb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de6:	74 06                	je     800dee <vsnprintf+0x2d>
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	7f 07                	jg     800df5 <vsnprintf+0x34>
		return -E_INVAL;
  800dee:	b8 03 00 00 00       	mov    $0x3,%eax
  800df3:	eb 20                	jmp    800e15 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df5:	ff 75 14             	pushl  0x14(%ebp)
  800df8:	ff 75 10             	pushl  0x10(%ebp)
  800dfb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dfe:	50                   	push   %eax
  800dff:	68 8b 0d 80 00       	push   $0x800d8b
  800e04:	e8 80 fb ff ff       	call   800989 <vprintfmt>
  800e09:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e1d:	8d 45 10             	lea    0x10(%ebp),%eax
  800e20:	83 c0 04             	add    $0x4,%eax
  800e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e26:	8b 45 10             	mov    0x10(%ebp),%eax
  800e29:	ff 75 f4             	pushl  -0xc(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 89 ff ff ff       	call   800dc1 <vsnprintf>
  800e38:	83 c4 10             	add    $0x10,%esp
  800e3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e41:	c9                   	leave  
  800e42:	c3                   	ret    

00800e43 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e50:	eb 06                	jmp    800e58 <strlen+0x15>
		n++;
  800e52:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e55:	ff 45 08             	incl   0x8(%ebp)
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 f1                	jne    800e52 <strlen+0xf>
		n++;
	return n;
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e73:	eb 09                	jmp    800e7e <strnlen+0x18>
		n++;
  800e75:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e78:	ff 45 08             	incl   0x8(%ebp)
  800e7b:	ff 4d 0c             	decl   0xc(%ebp)
  800e7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e82:	74 09                	je     800e8d <strnlen+0x27>
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 e8                	jne    800e75 <strnlen+0xf>
		n++;
	return n;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e9e:	90                   	nop
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8d 50 01             	lea    0x1(%eax),%edx
  800ea5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb1:	8a 12                	mov    (%edx),%dl
  800eb3:	88 10                	mov    %dl,(%eax)
  800eb5:	8a 00                	mov    (%eax),%al
  800eb7:	84 c0                	test   %al,%al
  800eb9:	75 e4                	jne    800e9f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ecc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ed3:	eb 1f                	jmp    800ef4 <strncpy+0x34>
		*dst++ = *src;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 08             	mov    %edx,0x8(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	8a 12                	mov    (%edx),%dl
  800ee3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	74 03                	je     800ef1 <strncpy+0x31>
			src++;
  800eee:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ef1:	ff 45 fc             	incl   -0x4(%ebp)
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800efa:	72 d9                	jb     800ed5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800efc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f11:	74 30                	je     800f43 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f13:	eb 16                	jmp    800f2b <strlcpy+0x2a>
			*dst++ = *src++;
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8d 50 01             	lea    0x1(%eax),%edx
  800f1b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f24:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f27:	8a 12                	mov    (%edx),%dl
  800f29:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f2b:	ff 4d 10             	decl   0x10(%ebp)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	74 09                	je     800f3d <strlcpy+0x3c>
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	84 c0                	test   %al,%al
  800f3b:	75 d8                	jne    800f15 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	29 c2                	sub    %eax,%edx
  800f4b:	89 d0                	mov    %edx,%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f52:	eb 06                	jmp    800f5a <strcmp+0xb>
		p++, q++;
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 0e                	je     800f71 <strcmp+0x22>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 10                	mov    (%eax),%dl
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	38 c2                	cmp    %al,%dl
  800f6f:	74 e3                	je     800f54 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	0f b6 d0             	movzbl %al,%edx
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	0f b6 c0             	movzbl %al,%eax
  800f81:	29 c2                	sub    %eax,%edx
  800f83:	89 d0                	mov    %edx,%eax
}
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f8a:	eb 09                	jmp    800f95 <strncmp+0xe>
		n--, p++, q++;
  800f8c:	ff 4d 10             	decl   0x10(%ebp)
  800f8f:	ff 45 08             	incl   0x8(%ebp)
  800f92:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	74 17                	je     800fb2 <strncmp+0x2b>
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	74 0e                	je     800fb2 <strncmp+0x2b>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 10                	mov    (%eax),%dl
  800fa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	38 c2                	cmp    %al,%dl
  800fb0:	74 da                	je     800f8c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb6:	75 07                	jne    800fbf <strncmp+0x38>
		return 0;
  800fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbd:	eb 14                	jmp    800fd3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f b6 d0             	movzbl %al,%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f b6 c0             	movzbl %al,%eax
  800fcf:	29 c2                	sub    %eax,%edx
  800fd1:	89 d0                	mov    %edx,%eax
}
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 04             	sub    $0x4,%esp
  800fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fde:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe1:	eb 12                	jmp    800ff5 <strchr+0x20>
		if (*s == c)
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800feb:	75 05                	jne    800ff2 <strchr+0x1d>
			return (char *) s;
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	eb 11                	jmp    801003 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	84 c0                	test   %al,%al
  800ffc:	75 e5                	jne    800fe3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ffe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801011:	eb 0d                	jmp    801020 <strfind+0x1b>
		if (*s == c)
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80101b:	74 0e                	je     80102b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80101d:	ff 45 08             	incl   0x8(%ebp)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	84 c0                	test   %al,%al
  801027:	75 ea                	jne    801013 <strfind+0xe>
  801029:	eb 01                	jmp    80102c <strfind+0x27>
		if (*s == c)
			break;
  80102b:	90                   	nop
	return (char *) s;
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80103d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801041:	76 63                	jbe    8010a6 <memset+0x75>
		uint64 data_block = c;
  801043:	8b 45 0c             	mov    0xc(%ebp),%eax
  801046:	99                   	cltd   
  801047:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801057:	c1 e0 08             	shl    $0x8,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801063:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801066:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80106a:	c1 e0 10             	shl    $0x10,%eax
  80106d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801070:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801079:	89 c2                	mov    %eax,%edx
  80107b:	b8 00 00 00 00       	mov    $0x0,%eax
  801080:	09 45 f0             	or     %eax,-0x10(%ebp)
  801083:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801086:	eb 18                	jmp    8010a0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801088:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80108b:	8d 41 08             	lea    0x8(%ecx),%eax
  80108e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801094:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801097:	89 01                	mov    %eax,(%ecx)
  801099:	89 51 04             	mov    %edx,0x4(%ecx)
  80109c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010a0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a4:	77 e2                	ja     801088 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010aa:	74 23                	je     8010cf <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b2:	eb 0e                	jmp    8010c2 <memset+0x91>
			*p8++ = (uint8)c;
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	8d 50 01             	lea    0x1(%eax),%edx
  8010ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	75 e5                	jne    8010b4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010ea:	76 24                	jbe    801110 <memcpy+0x3c>
		while(n >= 8){
  8010ec:	eb 1c                	jmp    80110a <memcpy+0x36>
			*d64 = *s64;
  8010ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f1:	8b 50 04             	mov    0x4(%eax),%edx
  8010f4:	8b 00                	mov    (%eax),%eax
  8010f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f9:	89 01                	mov    %eax,(%ecx)
  8010fb:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010fe:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801102:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801106:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80110a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110e:	77 de                	ja     8010ee <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801110:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801114:	74 31                	je     801147 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80111c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801122:	eb 16                	jmp    80113a <memcpy+0x66>
			*d8++ = *s8++;
  801124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801127:	8d 50 01             	lea    0x1(%eax),%edx
  80112a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80112d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801130:	8d 4a 01             	lea    0x1(%edx),%ecx
  801133:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801136:	8a 12                	mov    (%edx),%dl
  801138:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801140:	89 55 10             	mov    %edx,0x10(%ebp)
  801143:	85 c0                	test   %eax,%eax
  801145:	75 dd                	jne    801124 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80115e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	73 50                	jae    8011b6 <memmove+0x6a>
  801166:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	01 d0                	add    %edx,%eax
  80116e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801171:	76 43                	jbe    8011b6 <memmove+0x6a>
		s += n;
  801173:	8b 45 10             	mov    0x10(%ebp),%eax
  801176:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80117f:	eb 10                	jmp    801191 <memmove+0x45>
			*--d = *--s;
  801181:	ff 4d f8             	decl   -0x8(%ebp)
  801184:	ff 4d fc             	decl   -0x4(%ebp)
  801187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118a:	8a 10                	mov    (%eax),%dl
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	8d 50 ff             	lea    -0x1(%eax),%edx
  801197:	89 55 10             	mov    %edx,0x10(%ebp)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	75 e3                	jne    801181 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80119e:	eb 23                	jmp    8011c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a3:	8d 50 01             	lea    0x1(%eax),%edx
  8011a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011b2:	8a 12                	mov    (%edx),%dl
  8011b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	75 dd                	jne    8011a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011da:	eb 2a                	jmp    801206 <memcmp+0x3e>
		if (*s1 != *s2)
  8011dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011df:	8a 10                	mov    (%eax),%dl
  8011e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	38 c2                	cmp    %al,%dl
  8011e8:	74 16                	je     801200 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	0f b6 d0             	movzbl %al,%edx
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	0f b6 c0             	movzbl %al,%eax
  8011fa:	29 c2                	sub    %eax,%edx
  8011fc:	89 d0                	mov    %edx,%eax
  8011fe:	eb 18                	jmp    801218 <memcmp+0x50>
		s1++, s2++;
  801200:	ff 45 fc             	incl   -0x4(%ebp)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	8d 50 ff             	lea    -0x1(%eax),%edx
  80120c:	89 55 10             	mov    %edx,0x10(%ebp)
  80120f:	85 c0                	test   %eax,%eax
  801211:	75 c9                	jne    8011dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801220:	8b 55 08             	mov    0x8(%ebp),%edx
  801223:	8b 45 10             	mov    0x10(%ebp),%eax
  801226:	01 d0                	add    %edx,%eax
  801228:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80122b:	eb 15                	jmp    801242 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	0f b6 d0             	movzbl %al,%edx
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	0f b6 c0             	movzbl %al,%eax
  80123b:	39 c2                	cmp    %eax,%edx
  80123d:	74 0d                	je     80124c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80123f:	ff 45 08             	incl   0x8(%ebp)
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801248:	72 e3                	jb     80122d <memfind+0x13>
  80124a:	eb 01                	jmp    80124d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80124c:	90                   	nop
	return (void *) s;
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80125f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801266:	eb 03                	jmp    80126b <strtol+0x19>
		s++;
  801268:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 20                	cmp    $0x20,%al
  801272:	74 f4                	je     801268 <strtol+0x16>
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 09                	cmp    $0x9,%al
  80127b:	74 eb                	je     801268 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	3c 2b                	cmp    $0x2b,%al
  801284:	75 05                	jne    80128b <strtol+0x39>
		s++;
  801286:	ff 45 08             	incl   0x8(%ebp)
  801289:	eb 13                	jmp    80129e <strtol+0x4c>
	else if (*s == '-')
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 2d                	cmp    $0x2d,%al
  801292:	75 0a                	jne    80129e <strtol+0x4c>
		s++, neg = 1;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80129e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a2:	74 06                	je     8012aa <strtol+0x58>
  8012a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012a8:	75 20                	jne    8012ca <strtol+0x78>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	3c 30                	cmp    $0x30,%al
  8012b1:	75 17                	jne    8012ca <strtol+0x78>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	40                   	inc    %eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	3c 78                	cmp    $0x78,%al
  8012bb:	75 0d                	jne    8012ca <strtol+0x78>
		s += 2, base = 16;
  8012bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012c8:	eb 28                	jmp    8012f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ce:	75 15                	jne    8012e5 <strtol+0x93>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 30                	cmp    $0x30,%al
  8012d7:	75 0c                	jne    8012e5 <strtol+0x93>
		s++, base = 8;
  8012d9:	ff 45 08             	incl   0x8(%ebp)
  8012dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012e3:	eb 0d                	jmp    8012f2 <strtol+0xa0>
	else if (base == 0)
  8012e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e9:	75 07                	jne    8012f2 <strtol+0xa0>
		base = 10;
  8012eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	8a 00                	mov    (%eax),%al
  8012f7:	3c 2f                	cmp    $0x2f,%al
  8012f9:	7e 19                	jle    801314 <strtol+0xc2>
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8a 00                	mov    (%eax),%al
  801300:	3c 39                	cmp    $0x39,%al
  801302:	7f 10                	jg     801314 <strtol+0xc2>
			dig = *s - '0';
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	0f be c0             	movsbl %al,%eax
  80130c:	83 e8 30             	sub    $0x30,%eax
  80130f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801312:	eb 42                	jmp    801356 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8a 00                	mov    (%eax),%al
  801319:	3c 60                	cmp    $0x60,%al
  80131b:	7e 19                	jle    801336 <strtol+0xe4>
  80131d:	8b 45 08             	mov    0x8(%ebp),%eax
  801320:	8a 00                	mov    (%eax),%al
  801322:	3c 7a                	cmp    $0x7a,%al
  801324:	7f 10                	jg     801336 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	0f be c0             	movsbl %al,%eax
  80132e:	83 e8 57             	sub    $0x57,%eax
  801331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801334:	eb 20                	jmp    801356 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	3c 40                	cmp    $0x40,%al
  80133d:	7e 39                	jle    801378 <strtol+0x126>
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	3c 5a                	cmp    $0x5a,%al
  801346:	7f 30                	jg     801378 <strtol+0x126>
			dig = *s - 'A' + 10;
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	0f be c0             	movsbl %al,%eax
  801350:	83 e8 37             	sub    $0x37,%eax
  801353:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801359:	3b 45 10             	cmp    0x10(%ebp),%eax
  80135c:	7d 19                	jge    801377 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80135e:	ff 45 08             	incl   0x8(%ebp)
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	0f af 45 10          	imul   0x10(%ebp),%eax
  801368:	89 c2                	mov    %eax,%edx
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801372:	e9 7b ff ff ff       	jmp    8012f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801377:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137c:	74 08                	je     801386 <strtol+0x134>
		*endptr = (char *) s;
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	8b 55 08             	mov    0x8(%ebp),%edx
  801384:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138a:	74 07                	je     801393 <strtol+0x141>
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	f7 d8                	neg    %eax
  801391:	eb 03                	jmp    801396 <strtol+0x144>
  801393:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <ltostr>:

void
ltostr(long value, char *str)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80139e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013b0:	79 13                	jns    8013c5 <ltostr+0x2d>
	{
		neg = 1;
  8013b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013cd:	99                   	cltd   
  8013ce:	f7 f9                	idiv   %ecx
  8013d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d6:	8d 50 01             	lea    0x1(%eax),%edx
  8013d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e1:	01 d0                	add    %edx,%eax
  8013e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e6:	83 c2 30             	add    $0x30,%edx
  8013e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013f3:	f7 e9                	imul   %ecx
  8013f5:	c1 fa 02             	sar    $0x2,%edx
  8013f8:	89 c8                	mov    %ecx,%eax
  8013fa:	c1 f8 1f             	sar    $0x1f,%eax
  8013fd:	29 c2                	sub    %eax,%edx
  8013ff:	89 d0                	mov    %edx,%eax
  801401:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801408:	75 bb                	jne    8013c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80140a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801411:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801414:	48                   	dec    %eax
  801415:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801418:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80141c:	74 3d                	je     80145b <ltostr+0xc3>
		start = 1 ;
  80141e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801425:	eb 34                	jmp    80145b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	01 d0                	add    %edx,%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143a:	01 c2                	add    %eax,%edx
  80143c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	01 c8                	add    %ecx,%eax
  801444:	8a 00                	mov    (%eax),%al
  801446:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801448:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80144b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144e:	01 c2                	add    %eax,%edx
  801450:	8a 45 eb             	mov    -0x15(%ebp),%al
  801453:	88 02                	mov    %al,(%edx)
		start++ ;
  801455:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801458:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80145b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801461:	7c c4                	jl     801427 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801463:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801477:	ff 75 08             	pushl  0x8(%ebp)
  80147a:	e8 c4 f9 ff ff       	call   800e43 <strlen>
  80147f:	83 c4 04             	add    $0x4,%esp
  801482:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801485:	ff 75 0c             	pushl  0xc(%ebp)
  801488:	e8 b6 f9 ff ff       	call   800e43 <strlen>
  80148d:	83 c4 04             	add    $0x4,%esp
  801490:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801493:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80149a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a1:	eb 17                	jmp    8014ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8014a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a9:	01 c2                	add    %eax,%edx
  8014ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	01 c8                	add    %ecx,%eax
  8014b3:	8a 00                	mov    (%eax),%al
  8014b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b7:	ff 45 fc             	incl   -0x4(%ebp)
  8014ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014c0:	7c e1                	jl     8014a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014d0:	eb 1f                	jmp    8014f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d5:	8d 50 01             	lea    0x1(%eax),%edx
  8014d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014db:	89 c2                	mov    %eax,%edx
  8014dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e0:	01 c2                	add    %eax,%edx
  8014e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	01 c8                	add    %ecx,%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014ee:	ff 45 f8             	incl   -0x8(%ebp)
  8014f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f7:	7c d9                	jl     8014d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	c6 00 00             	movb   $0x0,(%eax)
}
  801504:	90                   	nop
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80150a:	8b 45 14             	mov    0x14(%ebp),%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801513:	8b 45 14             	mov    0x14(%ebp),%eax
  801516:	8b 00                	mov    (%eax),%eax
  801518:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151f:	8b 45 10             	mov    0x10(%ebp),%eax
  801522:	01 d0                	add    %edx,%eax
  801524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80152a:	eb 0c                	jmp    801538 <strsplit+0x31>
			*string++ = 0;
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	8d 50 01             	lea    0x1(%eax),%edx
  801532:	89 55 08             	mov    %edx,0x8(%ebp)
  801535:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	84 c0                	test   %al,%al
  80153f:	74 18                	je     801559 <strsplit+0x52>
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f be c0             	movsbl %al,%eax
  801549:	50                   	push   %eax
  80154a:	ff 75 0c             	pushl  0xc(%ebp)
  80154d:	e8 83 fa ff ff       	call   800fd5 <strchr>
  801552:	83 c4 08             	add    $0x8,%esp
  801555:	85 c0                	test   %eax,%eax
  801557:	75 d3                	jne    80152c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8a 00                	mov    (%eax),%al
  80155e:	84 c0                	test   %al,%al
  801560:	74 5a                	je     8015bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801562:	8b 45 14             	mov    0x14(%ebp),%eax
  801565:	8b 00                	mov    (%eax),%eax
  801567:	83 f8 0f             	cmp    $0xf,%eax
  80156a:	75 07                	jne    801573 <strsplit+0x6c>
		{
			return 0;
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 66                	jmp    8015d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801573:	8b 45 14             	mov    0x14(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	8d 48 01             	lea    0x1(%eax),%ecx
  80157b:	8b 55 14             	mov    0x14(%ebp),%edx
  80157e:	89 0a                	mov    %ecx,(%edx)
  801580:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801587:	8b 45 10             	mov    0x10(%ebp),%eax
  80158a:	01 c2                	add    %eax,%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801591:	eb 03                	jmp    801596 <strsplit+0x8f>
			string++;
  801593:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8a 00                	mov    (%eax),%al
  80159b:	84 c0                	test   %al,%al
  80159d:	74 8b                	je     80152a <strsplit+0x23>
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8a 00                	mov    (%eax),%al
  8015a4:	0f be c0             	movsbl %al,%eax
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	e8 25 fa ff ff       	call   800fd5 <strchr>
  8015b0:	83 c4 08             	add    $0x8,%esp
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	74 dc                	je     801593 <strsplit+0x8c>
			string++;
	}
  8015b7:	e9 6e ff ff ff       	jmp    80152a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c0:	8b 00                	mov    (%eax),%eax
  8015c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cc:	01 d0                	add    %edx,%eax
  8015ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ee:	eb 4a                	jmp    80163a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801604:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 d0                	add    %edx,%eax
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	3c 40                	cmp    $0x40,%al
  801610:	7e 25                	jle    801637 <str2lower+0x5c>
  801612:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801615:	8b 45 0c             	mov    0xc(%ebp),%eax
  801618:	01 d0                	add    %edx,%eax
  80161a:	8a 00                	mov    (%eax),%al
  80161c:	3c 5a                	cmp    $0x5a,%al
  80161e:	7f 17                	jg     801637 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801620:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162b:	8b 55 08             	mov    0x8(%ebp),%edx
  80162e:	01 ca                	add    %ecx,%edx
  801630:	8a 12                	mov    (%edx),%dl
  801632:	83 c2 20             	add    $0x20,%edx
  801635:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801637:	ff 45 fc             	incl   -0x4(%ebp)
  80163a:	ff 75 0c             	pushl  0xc(%ebp)
  80163d:	e8 01 f8 ff ff       	call   800e43 <strlen>
  801642:	83 c4 04             	add    $0x4,%esp
  801645:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801648:	7f a6                	jg     8015f0 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80164a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801655:	a1 08 40 80 00       	mov    0x804008,%eax
  80165a:	85 c0                	test   %eax,%eax
  80165c:	74 42                	je     8016a0 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80165e:	83 ec 08             	sub    $0x8,%esp
  801661:	68 00 00 00 82       	push   $0x82000000
  801666:	68 00 00 00 80       	push   $0x80000000
  80166b:	e8 00 08 00 00       	call   801e70 <initialize_dynamic_allocator>
  801670:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801673:	e8 e7 05 00 00       	call   801c5f <sys_get_uheap_strategy>
  801678:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80167d:	a1 40 40 80 00       	mov    0x804040,%eax
  801682:	05 00 10 00 00       	add    $0x1000,%eax
  801687:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80168c:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801691:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801696:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80169d:	00 00 00 
	}
}
  8016a0:	90                   	nop
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	68 06 04 00 00       	push   $0x406
  8016bf:	50                   	push   %eax
  8016c0:	e8 e4 01 00 00       	call   8018a9 <__sys_allocate_page>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016cf:	79 14                	jns    8016e5 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 88 34 80 00       	push   $0x803488
  8016d9:	6a 1f                	push   $0x1f
  8016db:	68 c4 34 80 00       	push   $0x8034c4
  8016e0:	e8 b7 ed ff ff       	call   80049c <_panic>
	return 0;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801700:	83 ec 0c             	sub    $0xc,%esp
  801703:	50                   	push   %eax
  801704:	e8 e7 01 00 00       	call   8018f0 <__sys_unmap_frame>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80170f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801713:	79 14                	jns    801729 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	68 d0 34 80 00       	push   $0x8034d0
  80171d:	6a 2a                	push   $0x2a
  80171f:	68 c4 34 80 00       	push   $0x8034c4
  801724:	e8 73 ed ff ff       	call   80049c <_panic>
}
  801729:	90                   	nop
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801732:	e8 18 ff ff ff       	call   80164f <uheap_init>
	if (size == 0) return NULL ;
  801737:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80173b:	75 07                	jne    801744 <malloc+0x18>
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	eb 14                	jmp    801758 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	68 10 35 80 00       	push   $0x803510
  80174c:	6a 3e                	push   $0x3e
  80174e:	68 c4 34 80 00       	push   $0x8034c4
  801753:	e8 44 ed ff ff       	call   80049c <_panic>
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 38 35 80 00       	push   $0x803538
  801768:	6a 49                	push   $0x49
  80176a:	68 c4 34 80 00       	push   $0x8034c4
  80176f:	e8 28 ed ff ff       	call   80049c <_panic>

00801774 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 18             	sub    $0x18,%esp
  80177a:	8b 45 10             	mov    0x10(%ebp),%eax
  80177d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801780:	e8 ca fe ff ff       	call   80164f <uheap_init>
	if (size == 0) return NULL ;
  801785:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801789:	75 07                	jne    801792 <smalloc+0x1e>
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 14                	jmp    8017a6 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	68 5c 35 80 00       	push   $0x80355c
  80179a:	6a 5a                	push   $0x5a
  80179c:	68 c4 34 80 00       	push   $0x8034c4
  8017a1:	e8 f6 ec ff ff       	call   80049c <_panic>
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017ae:	e8 9c fe ff ff       	call   80164f <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 84 35 80 00       	push   $0x803584
  8017bb:	6a 6a                	push   $0x6a
  8017bd:	68 c4 34 80 00       	push   $0x8034c4
  8017c2:	e8 d5 ec ff ff       	call   80049c <_panic>

008017c7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017cd:	e8 7d fe ff ff       	call   80164f <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 a8 35 80 00       	push   $0x8035a8
  8017da:	68 88 00 00 00       	push   $0x88
  8017df:	68 c4 34 80 00       	push   $0x8034c4
  8017e4:	e8 b3 ec ff ff       	call   80049c <_panic>

008017e9 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017ef:	83 ec 04             	sub    $0x4,%esp
  8017f2:	68 d0 35 80 00       	push   $0x8035d0
  8017f7:	68 9b 00 00 00       	push   $0x9b
  8017fc:	68 c4 34 80 00       	push   $0x8034c4
  801801:	e8 96 ec ff ff       	call   80049c <_panic>

00801806 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	57                   	push   %edi
  80180a:	56                   	push   %esi
  80180b:	53                   	push   %ebx
  80180c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	8b 55 0c             	mov    0xc(%ebp),%edx
  801815:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801818:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80181e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801821:	cd 30                	int    $0x30
  801823:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	5b                   	pop    %ebx
  80182d:	5e                   	pop    %esi
  80182e:	5f                   	pop    %edi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	8b 45 10             	mov    0x10(%ebp),%eax
  80183a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80183d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801840:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	51                   	push   %ecx
  80184a:	52                   	push   %edx
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	6a 00                	push   $0x0
  801851:	e8 b0 ff ff ff       	call   801806 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	90                   	nop
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_cgetc>:

int
sys_cgetc(void)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 02                	push   $0x2
  80186b:	e8 96 ff ff ff       	call   801806 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 03                	push   $0x3
  801884:	e8 7d ff ff ff       	call   801806 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	90                   	nop
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 04                	push   $0x4
  80189e:	e8 63 ff ff ff       	call   801806 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	90                   	nop
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	52                   	push   %edx
  8018b9:	50                   	push   %eax
  8018ba:	6a 08                	push   $0x8
  8018bc:	e8 45 ff ff ff       	call   801806 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	51                   	push   %ecx
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 09                	push   $0x9
  8018e1:	e8 20 ff ff ff       	call   801806 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5e                   	pop    %esi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 0a                	push   $0xa
  801900:	e8 01 ff ff ff       	call   801806 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	6a 0b                	push   $0xb
  80191b:	e8 e6 fe ff ff       	call   801806 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 0c                	push   $0xc
  801934:	e8 cd fe ff ff       	call   801806 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 0d                	push   $0xd
  80194d:	e8 b4 fe ff ff       	call   801806 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 0e                	push   $0xe
  801966:	e8 9b fe ff ff       	call   801806 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 0f                	push   $0xf
  80197f:	e8 82 fe ff ff       	call   801806 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 10                	push   $0x10
  801999:	e8 68 fe ff ff       	call   801806 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 11                	push   $0x11
  8019b2:	e8 4f fe ff ff       	call   801806 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_cputc>:

void
sys_cputc(const char c)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 04             	sub    $0x4,%esp
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	50                   	push   %eax
  8019d6:	6a 01                	push   $0x1
  8019d8:	e8 29 fe ff ff       	call   801806 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 14                	push   $0x14
  8019f2:	e8 0f fe ff ff       	call   801806 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	8b 45 10             	mov    0x10(%ebp),%eax
  801a06:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	51                   	push   %ecx
  801a16:	52                   	push   %edx
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	50                   	push   %eax
  801a1b:	6a 15                	push   $0x15
  801a1d:	e8 e4 fd ff ff       	call   801806 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 16                	push   $0x16
  801a3a:	e8 c7 fd ff ff       	call   801806 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	51                   	push   %ecx
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 17                	push   $0x17
  801a59:	e8 a8 fd ff ff       	call   801806 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 18                	push   $0x18
  801a76:	e8 8b fd ff ff       	call   801806 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 14             	pushl  0x14(%ebp)
  801a8b:	ff 75 10             	pushl  0x10(%ebp)
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	6a 19                	push   $0x19
  801a94:	e8 6d fd ff ff       	call   801806 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	50                   	push   %eax
  801aad:	6a 1a                	push   $0x1a
  801aaf:	e8 52 fd ff ff       	call   801806 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	50                   	push   %eax
  801ac9:	6a 1b                	push   $0x1b
  801acb:	e8 36 fd ff ff       	call   801806 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 05                	push   $0x5
  801ae4:	e8 1d fd ff ff       	call   801806 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 06                	push   $0x6
  801afd:	e8 04 fd ff ff       	call   801806 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 07                	push   $0x7
  801b16:	e8 eb fc ff ff       	call   801806 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_exit_env>:


void sys_exit_env(void)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 1c                	push   $0x1c
  801b2f:	e8 d2 fc ff ff       	call   801806 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	90                   	nop
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b43:	8d 50 04             	lea    0x4(%eax),%edx
  801b46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1d                	push   $0x1d
  801b53:	e8 ae fc ff ff       	call   801806 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b64:	89 01                	mov    %eax,(%ecx)
  801b66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	c9                   	leave  
  801b6d:	c2 04 00             	ret    $0x4

00801b70 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 10             	pushl  0x10(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 13                	push   $0x13
  801b82:	e8 7f fc ff ff       	call   801806 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 1e                	push   $0x1e
  801b9c:	e8 65 fc ff ff       	call   801806 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 04             	sub    $0x4,%esp
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	50                   	push   %eax
  801bbf:	6a 1f                	push   $0x1f
  801bc1:	e8 40 fc ff ff       	call   801806 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc9:	90                   	nop
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <rsttst>:
void rsttst()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 21                	push   $0x21
  801bdb:	e8 26 fc ff ff       	call   801806 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 04             	sub    $0x4,%esp
  801bec:	8b 45 14             	mov    0x14(%ebp),%eax
  801bef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf2:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	ff 75 10             	pushl  0x10(%ebp)
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	6a 20                	push   $0x20
  801c06:	e8 fb fb ff ff       	call   801806 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <chktst>:
void chktst(uint32 n)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	ff 75 08             	pushl  0x8(%ebp)
  801c1f:	6a 22                	push   $0x22
  801c21:	e8 e0 fb ff ff       	call   801806 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return ;
  801c29:	90                   	nop
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <inctst>:

void inctst()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 23                	push   $0x23
  801c3b:	e8 c6 fb ff ff       	call   801806 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <gettst>:
uint32 gettst()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 24                	push   $0x24
  801c55:	e8 ac fb ff ff       	call   801806 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 25                	push   $0x25
  801c6e:	e8 93 fb ff ff       	call   801806 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
  801c76:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c7b:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	ff 75 08             	pushl  0x8(%ebp)
  801c98:	6a 26                	push   $0x26
  801c9a:	e8 67 fb ff ff       	call   801806 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca2:	90                   	nop
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	53                   	push   %ebx
  801cb8:	51                   	push   %ecx
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 27                	push   $0x27
  801cbd:	e8 44 fb ff ff       	call   801806 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 28                	push   $0x28
  801cdd:	e8 24 fb ff ff       	call   801806 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cea:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	51                   	push   %ecx
  801cf6:	ff 75 10             	pushl  0x10(%ebp)
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 29                	push   $0x29
  801cfd:	e8 04 fb ff ff       	call   801806 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 12                	push   $0x12
  801d19:	e8 e8 fa ff ff       	call   801806 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 2a                	push   $0x2a
  801d37:	e8 ca fa ff ff       	call   801806 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
	return;
  801d3f:	90                   	nop
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 2b                	push   $0x2b
  801d51:	e8 b0 fa ff ff       	call   801806 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	ff 75 0c             	pushl  0xc(%ebp)
  801d67:	ff 75 08             	pushl  0x8(%ebp)
  801d6a:	6a 2d                	push   $0x2d
  801d6c:	e8 95 fa ff ff       	call   801806 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	ff 75 08             	pushl  0x8(%ebp)
  801d86:	6a 2c                	push   $0x2c
  801d88:	e8 79 fa ff ff       	call   801806 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	68 f4 35 80 00       	push   $0x8035f4
  801da1:	68 25 01 00 00       	push   $0x125
  801da6:	68 27 36 80 00       	push   $0x803627
  801dab:	e8 ec e6 ff ff       	call   80049c <_panic>

00801db0 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801db6:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801dbd:	72 09                	jb     801dc8 <to_page_va+0x18>
  801dbf:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801dc6:	72 14                	jb     801ddc <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	68 38 36 80 00       	push   $0x803638
  801dd0:	6a 15                	push   $0x15
  801dd2:	68 63 36 80 00       	push   $0x803663
  801dd7:	e8 c0 e6 ff ff       	call   80049c <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	ba 60 40 80 00       	mov    $0x804060,%edx
  801de4:	29 d0                	sub    %edx,%eax
  801de6:	c1 f8 02             	sar    $0x2,%eax
  801de9:	89 c2                	mov    %eax,%edx
  801deb:	89 d0                	mov    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	c1 e0 02             	shl    $0x2,%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	c1 e0 02             	shl    $0x2,%eax
  801dfa:	01 d0                	add    %edx,%eax
  801dfc:	89 c1                	mov    %eax,%ecx
  801dfe:	c1 e1 08             	shl    $0x8,%ecx
  801e01:	01 c8                	add    %ecx,%eax
  801e03:	89 c1                	mov    %eax,%ecx
  801e05:	c1 e1 10             	shl    $0x10,%ecx
  801e08:	01 c8                	add    %ecx,%eax
  801e0a:	01 c0                	add    %eax,%eax
  801e0c:	01 d0                	add    %edx,%eax
  801e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	c1 e0 0c             	shl    $0xc,%eax
  801e17:	89 c2                	mov    %eax,%edx
  801e19:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e1e:	01 d0                	add    %edx,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e28:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e30:	29 c2                	sub    %eax,%edx
  801e32:	89 d0                	mov    %edx,%eax
  801e34:	c1 e8 0c             	shr    $0xc,%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3e:	78 09                	js     801e49 <to_page_info+0x27>
  801e40:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e47:	7e 14                	jle    801e5d <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e49:	83 ec 04             	sub    $0x4,%esp
  801e4c:	68 7c 36 80 00       	push   $0x80367c
  801e51:	6a 22                	push   $0x22
  801e53:	68 63 36 80 00       	push   $0x803663
  801e58:	e8 3f e6 ff ff       	call   80049c <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e60:	89 d0                	mov    %edx,%eax
  801e62:	01 c0                	add    %eax,%eax
  801e64:	01 d0                	add    %edx,%eax
  801e66:	c1 e0 02             	shl    $0x2,%eax
  801e69:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	05 00 00 00 02       	add    $0x2000000,%eax
  801e7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e81:	73 16                	jae    801e99 <initialize_dynamic_allocator+0x29>
  801e83:	68 a0 36 80 00       	push   $0x8036a0
  801e88:	68 c6 36 80 00       	push   $0x8036c6
  801e8d:	6a 34                	push   $0x34
  801e8f:	68 63 36 80 00       	push   $0x803663
  801e94:	e8 03 e6 ff ff       	call   80049c <_panic>
		is_initialized = 1;
  801e99:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801ea0:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eae:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801eb3:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801eba:	00 00 00 
  801ebd:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801ec4:	00 00 00 
  801ec7:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ece:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed4:	2b 45 08             	sub    0x8(%ebp),%eax
  801ed7:	c1 e8 0c             	shr    $0xc,%eax
  801eda:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801edd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ee4:	e9 c8 00 00 00       	jmp    801fb1 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	01 c0                	add    %eax,%eax
  801ef0:	01 d0                	add    %edx,%eax
  801ef2:	c1 e0 02             	shl    $0x2,%eax
  801ef5:	05 68 40 80 00       	add    $0x804068,%eax
  801efa:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f02:	89 d0                	mov    %edx,%eax
  801f04:	01 c0                	add    %eax,%eax
  801f06:	01 d0                	add    %edx,%eax
  801f08:	c1 e0 02             	shl    $0x2,%eax
  801f0b:	05 6a 40 80 00       	add    $0x80406a,%eax
  801f10:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801f15:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f1b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f1e:	89 c8                	mov    %ecx,%eax
  801f20:	01 c0                	add    %eax,%eax
  801f22:	01 c8                	add    %ecx,%eax
  801f24:	c1 e0 02             	shl    $0x2,%eax
  801f27:	05 64 40 80 00       	add    $0x804064,%eax
  801f2c:	89 10                	mov    %edx,(%eax)
  801f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f31:	89 d0                	mov    %edx,%eax
  801f33:	01 c0                	add    %eax,%eax
  801f35:	01 d0                	add    %edx,%eax
  801f37:	c1 e0 02             	shl    $0x2,%eax
  801f3a:	05 64 40 80 00       	add    $0x804064,%eax
  801f3f:	8b 00                	mov    (%eax),%eax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	74 1b                	je     801f60 <initialize_dynamic_allocator+0xf0>
  801f45:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f4b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f4e:	89 c8                	mov    %ecx,%eax
  801f50:	01 c0                	add    %eax,%eax
  801f52:	01 c8                	add    %ecx,%eax
  801f54:	c1 e0 02             	shl    $0x2,%eax
  801f57:	05 60 40 80 00       	add    $0x804060,%eax
  801f5c:	89 02                	mov    %eax,(%edx)
  801f5e:	eb 16                	jmp    801f76 <initialize_dynamic_allocator+0x106>
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	89 d0                	mov    %edx,%eax
  801f65:	01 c0                	add    %eax,%eax
  801f67:	01 d0                	add    %edx,%eax
  801f69:	c1 e0 02             	shl    $0x2,%eax
  801f6c:	05 60 40 80 00       	add    $0x804060,%eax
  801f71:	a3 48 40 80 00       	mov    %eax,0x804048
  801f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f79:	89 d0                	mov    %edx,%eax
  801f7b:	01 c0                	add    %eax,%eax
  801f7d:	01 d0                	add    %edx,%eax
  801f7f:	c1 e0 02             	shl    $0x2,%eax
  801f82:	05 60 40 80 00       	add    $0x804060,%eax
  801f87:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8f:	89 d0                	mov    %edx,%eax
  801f91:	01 c0                	add    %eax,%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	c1 e0 02             	shl    $0x2,%eax
  801f98:	05 60 40 80 00       	add    $0x804060,%eax
  801f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa3:	a1 54 40 80 00       	mov    0x804054,%eax
  801fa8:	40                   	inc    %eax
  801fa9:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801fae:	ff 45 f4             	incl   -0xc(%ebp)
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fb7:	0f 8c 2c ff ff ff    	jl     801ee9 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fbd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fc4:	eb 36                	jmp    801ffc <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	c1 e0 04             	shl    $0x4,%eax
  801fcc:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fda:	c1 e0 04             	shl    $0x4,%eax
  801fdd:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fe2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	c1 e0 04             	shl    $0x4,%eax
  801fee:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ff9:	ff 45 f0             	incl   -0x10(%ebp)
  801ffc:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802000:	7e c4                	jle    801fc6 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802002:	90                   	nop
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	50                   	push   %eax
  802012:	e8 0b fe ff ff       	call   801e22 <to_page_info>
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 40 08             	mov    0x8(%eax),%eax
  802023:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	ff 75 0c             	pushl  0xc(%ebp)
  802034:	e8 77 fd ff ff       	call   801db0 <to_page_va>
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80203f:	b8 00 10 00 00       	mov    $0x1000,%eax
  802044:	ba 00 00 00 00       	mov    $0x0,%edx
  802049:	f7 75 08             	divl   0x8(%ebp)
  80204c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80204f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	50                   	push   %eax
  802056:	e8 48 f6 ff ff       	call   8016a3 <get_page>
  80205b:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  80205e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802061:	8b 55 0c             	mov    0xc(%ebp),%edx
  802064:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802072:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802079:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802080:	eb 19                	jmp    80209b <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	ba 01 00 00 00       	mov    $0x1,%edx
  80208a:	88 c1                	mov    %al,%cl
  80208c:	d3 e2                	shl    %cl,%edx
  80208e:	89 d0                	mov    %edx,%eax
  802090:	3b 45 08             	cmp    0x8(%ebp),%eax
  802093:	74 0e                	je     8020a3 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802095:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802098:	ff 45 f0             	incl   -0x10(%ebp)
  80209b:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80209f:	7e e1                	jle    802082 <split_page_to_blocks+0x5a>
  8020a1:	eb 01                	jmp    8020a4 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8020a3:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8020a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8020ab:	e9 a7 00 00 00       	jmp    802157 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b3:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020b7:	89 c2                	mov    %eax,%edx
  8020b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020bc:	01 d0                	add    %edx,%eax
  8020be:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020c5:	75 14                	jne    8020db <split_page_to_blocks+0xb3>
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	68 dc 36 80 00       	push   $0x8036dc
  8020cf:	6a 7c                	push   $0x7c
  8020d1:	68 63 36 80 00       	push   $0x803663
  8020d6:	e8 c1 e3 ff ff       	call   80049c <_panic>
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	c1 e0 04             	shl    $0x4,%eax
  8020e1:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020e6:	8b 10                	mov    (%eax),%edx
  8020e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020eb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f1:	8b 40 04             	mov    0x4(%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 14                	je     80210c <split_page_to_blocks+0xe4>
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	c1 e0 04             	shl    $0x4,%eax
  8020fe:	05 84 c0 81 00       	add    $0x81c084,%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802108:	89 10                	mov    %edx,(%eax)
  80210a:	eb 11                	jmp    80211d <split_page_to_blocks+0xf5>
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	c1 e0 04             	shl    $0x4,%eax
  802112:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80211b:	89 02                	mov    %eax,(%edx)
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	c1 e0 04             	shl    $0x4,%eax
  802123:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212c:	89 02                	mov    %eax,(%edx)
  80212e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802131:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	c1 e0 04             	shl    $0x4,%eax
  80213d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	8d 50 01             	lea    0x1(%eax),%edx
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	c1 e0 04             	shl    $0x4,%eax
  80214d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802152:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802154:	ff 45 ec             	incl   -0x14(%ebp)
  802157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80215d:	0f 82 4d ff ff ff    	jb     8020b0 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802163:	90                   	nop
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80216c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802173:	76 19                	jbe    80218e <alloc_block+0x28>
  802175:	68 00 37 80 00       	push   $0x803700
  80217a:	68 c6 36 80 00       	push   $0x8036c6
  80217f:	68 8a 00 00 00       	push   $0x8a
  802184:	68 63 36 80 00       	push   $0x803663
  802189:	e8 0e e3 ff ff       	call   80049c <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  80218e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802195:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80219c:	eb 19                	jmp    8021b7 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	ba 01 00 00 00       	mov    $0x1,%edx
  8021a6:	88 c1                	mov    %al,%cl
  8021a8:	d3 e2                	shl    %cl,%edx
  8021aa:	89 d0                	mov    %edx,%eax
  8021ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021af:	73 0e                	jae    8021bf <alloc_block+0x59>
		idx++;
  8021b1:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021b4:	ff 45 f0             	incl   -0x10(%ebp)
  8021b7:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021bb:	7e e1                	jle    80219e <alloc_block+0x38>
  8021bd:	eb 01                	jmp    8021c0 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021bf:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	c1 e0 04             	shl    $0x4,%eax
  8021c6:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021cb:	8b 00                	mov    (%eax),%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	0f 84 df 00 00 00    	je     8022b4 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	c1 e0 04             	shl    $0x4,%eax
  8021db:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e9:	75 17                	jne    802202 <alloc_block+0x9c>
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 21 37 80 00       	push   $0x803721
  8021f3:	68 9e 00 00 00       	push   $0x9e
  8021f8:	68 63 36 80 00       	push   $0x803663
  8021fd:	e8 9a e2 ff ff       	call   80049c <_panic>
  802202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	74 10                	je     80221b <alloc_block+0xb5>
  80220b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802213:	8b 52 04             	mov    0x4(%edx),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	eb 14                	jmp    80222f <alloc_block+0xc9>
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802224:	c1 e2 04             	shl    $0x4,%edx
  802227:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80222d:	89 02                	mov    %eax,(%edx)
  80222f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802232:	8b 40 04             	mov    0x4(%eax),%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	74 0f                	je     802248 <alloc_block+0xe2>
  802239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223c:	8b 40 04             	mov    0x4(%eax),%eax
  80223f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802242:	8b 12                	mov    (%edx),%edx
  802244:	89 10                	mov    %edx,(%eax)
  802246:	eb 13                	jmp    80225b <alloc_block+0xf5>
  802248:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224b:	8b 00                	mov    (%eax),%eax
  80224d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802250:	c1 e2 04             	shl    $0x4,%edx
  802253:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802259:	89 02                	mov    %eax,(%edx)
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	c1 e0 04             	shl    $0x4,%eax
  802274:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	c1 e0 04             	shl    $0x4,%eax
  802284:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802289:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80228b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228e:	83 ec 0c             	sub    $0xc,%esp
  802291:	50                   	push   %eax
  802292:	e8 8b fb ff ff       	call   801e22 <to_page_info>
  802297:	83 c4 10             	add    $0x10,%esp
  80229a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80229d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a0:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8022a4:	48                   	dec    %eax
  8022a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a8:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022af:	e9 bc 02 00 00       	jmp    802570 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8022b4:	a1 54 40 80 00       	mov    0x804054,%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	0f 84 7d 02 00 00    	je     80253e <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022c1:	a1 48 40 80 00       	mov    0x804048,%eax
  8022c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022cd:	75 17                	jne    8022e6 <alloc_block+0x180>
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 21 37 80 00       	push   $0x803721
  8022d7:	68 a9 00 00 00       	push   $0xa9
  8022dc:	68 63 36 80 00       	push   $0x803663
  8022e1:	e8 b6 e1 ff ff       	call   80049c <_panic>
  8022e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	74 10                	je     8022ff <alloc_block+0x199>
  8022ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f7:	8b 52 04             	mov    0x4(%edx),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
  8022fd:	eb 0b                	jmp    80230a <alloc_block+0x1a4>
  8022ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802302:	8b 40 04             	mov    0x4(%eax),%eax
  802305:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80230a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230d:	8b 40 04             	mov    0x4(%eax),%eax
  802310:	85 c0                	test   %eax,%eax
  802312:	74 0f                	je     802323 <alloc_block+0x1bd>
  802314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80231d:	8b 12                	mov    (%edx),%edx
  80231f:	89 10                	mov    %edx,(%eax)
  802321:	eb 0a                	jmp    80232d <alloc_block+0x1c7>
  802323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	a3 48 40 80 00       	mov    %eax,0x804048
  80232d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802330:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802339:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802340:	a1 54 40 80 00       	mov    0x804054,%eax
  802345:	48                   	dec    %eax
  802346:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	83 c0 03             	add    $0x3,%eax
  802351:	ba 01 00 00 00       	mov    $0x1,%edx
  802356:	88 c1                	mov    %al,%cl
  802358:	d3 e2                	shl    %cl,%edx
  80235a:	89 d0                	mov    %edx,%eax
  80235c:	83 ec 08             	sub    $0x8,%esp
  80235f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802362:	50                   	push   %eax
  802363:	e8 c0 fc ff ff       	call   802028 <split_page_to_blocks>
  802368:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c1 e0 04             	shl    $0x4,%eax
  802371:	05 80 c0 81 00       	add    $0x81c080,%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80237b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80237f:	75 17                	jne    802398 <alloc_block+0x232>
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	68 21 37 80 00       	push   $0x803721
  802389:	68 b0 00 00 00       	push   $0xb0
  80238e:	68 63 36 80 00       	push   $0x803663
  802393:	e8 04 e1 ff ff       	call   80049c <_panic>
  802398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 10                	je     8023b1 <alloc_block+0x24b>
  8023a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a9:	8b 52 04             	mov    0x4(%edx),%edx
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	eb 14                	jmp    8023c5 <alloc_block+0x25f>
  8023b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ba:	c1 e2 04             	shl    $0x4,%edx
  8023bd:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023c3:	89 02                	mov    %eax,(%edx)
  8023c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c8:	8b 40 04             	mov    0x4(%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 0f                	je     8023de <alloc_block+0x278>
  8023cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d2:	8b 40 04             	mov    0x4(%eax),%eax
  8023d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023d8:	8b 12                	mov    (%edx),%edx
  8023da:	89 10                	mov    %edx,(%eax)
  8023dc:	eb 13                	jmp    8023f1 <alloc_block+0x28b>
  8023de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e6:	c1 e2 04             	shl    $0x4,%edx
  8023e9:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023ef:	89 02                	mov    %eax,(%edx)
  8023f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	c1 e0 04             	shl    $0x4,%eax
  80240a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	8d 50 ff             	lea    -0x1(%eax),%edx
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	c1 e0 04             	shl    $0x4,%eax
  80241a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80241f:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802424:	83 ec 0c             	sub    $0xc,%esp
  802427:	50                   	push   %eax
  802428:	e8 f5 f9 ff ff       	call   801e22 <to_page_info>
  80242d:	83 c4 10             	add    $0x10,%esp
  802430:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802433:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802436:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80243a:	48                   	dec    %eax
  80243b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80243e:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	e9 26 01 00 00       	jmp    802570 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80244a:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	c1 e0 04             	shl    $0x4,%eax
  802453:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	0f 84 dc 00 00 00    	je     80253e <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	c1 e0 04             	shl    $0x4,%eax
  802468:	05 80 c0 81 00       	add    $0x81c080,%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802472:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802476:	75 17                	jne    80248f <alloc_block+0x329>
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	68 21 37 80 00       	push   $0x803721
  802480:	68 be 00 00 00       	push   $0xbe
  802485:	68 63 36 80 00       	push   $0x803663
  80248a:	e8 0d e0 ff ff       	call   80049c <_panic>
  80248f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 10                	je     8024a8 <alloc_block+0x342>
  802498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024a0:	8b 52 04             	mov    0x4(%edx),%edx
  8024a3:	89 50 04             	mov    %edx,0x4(%eax)
  8024a6:	eb 14                	jmp    8024bc <alloc_block+0x356>
  8024a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b1:	c1 e2 04             	shl    $0x4,%edx
  8024b4:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024ba:	89 02                	mov    %eax,(%edx)
  8024bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block+0x36f>
  8024c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 13                	jmp    8024e8 <alloc_block+0x382>
  8024d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	c1 e2 04             	shl    $0x4,%edx
  8024e0:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024e6:	89 02                	mov    %eax,(%edx)
  8024e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	c1 e0 04             	shl    $0x4,%eax
  802501:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	8d 50 ff             	lea    -0x1(%eax),%edx
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	c1 e0 04             	shl    $0x4,%eax
  802511:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802516:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802518:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	50                   	push   %eax
  80251f:	e8 fe f8 ff ff       	call   801e22 <to_page_info>
  802524:	83 c4 10             	add    $0x10,%esp
  802527:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80252a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80252d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802531:	48                   	dec    %eax
  802532:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802535:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80253c:	eb 32                	jmp    802570 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  80253e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802542:	77 15                	ja     802559 <alloc_block+0x3f3>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	c1 e0 04             	shl    $0x4,%eax
  80254a:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	0f 84 f1 fe ff ff    	je     80244a <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 3f 37 80 00       	push   $0x80373f
  802561:	68 c8 00 00 00       	push   $0xc8
  802566:	68 63 36 80 00       	push   $0x803663
  80256b:	e8 2c df ff ff       	call   80049c <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802578:	8b 55 08             	mov    0x8(%ebp),%edx
  80257b:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802580:	39 c2                	cmp    %eax,%edx
  802582:	72 0c                	jb     802590 <free_block+0x1e>
  802584:	8b 55 08             	mov    0x8(%ebp),%edx
  802587:	a1 40 40 80 00       	mov    0x804040,%eax
  80258c:	39 c2                	cmp    %eax,%edx
  80258e:	72 19                	jb     8025a9 <free_block+0x37>
  802590:	68 50 37 80 00       	push   $0x803750
  802595:	68 c6 36 80 00       	push   $0x8036c6
  80259a:	68 d7 00 00 00       	push   $0xd7
  80259f:	68 63 36 80 00       	push   $0x803663
  8025a4:	e8 f3 de ff ff       	call   80049c <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	83 ec 0c             	sub    $0xc,%esp
  8025b5:	50                   	push   %eax
  8025b6:	e8 67 f8 ff ff       	call   801e22 <to_page_info>
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c4:	8b 40 08             	mov    0x8(%eax),%eax
  8025c7:	0f b7 c0             	movzwl %ax,%eax
  8025ca:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025d4:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025db:	eb 19                	jmp    8025f6 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	ba 01 00 00 00       	mov    $0x1,%edx
  8025e5:	88 c1                	mov    %al,%cl
  8025e7:	d3 e2                	shl    %cl,%edx
  8025e9:	89 d0                	mov    %edx,%eax
  8025eb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025ee:	74 0e                	je     8025fe <free_block+0x8c>
	        break;
	    idx++;
  8025f0:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025f3:	ff 45 f0             	incl   -0x10(%ebp)
  8025f6:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025fa:	7e e1                	jle    8025dd <free_block+0x6b>
  8025fc:	eb 01                	jmp    8025ff <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025fe:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802602:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802606:	40                   	inc    %eax
  802607:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80260e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802612:	75 17                	jne    80262b <free_block+0xb9>
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 dc 36 80 00       	push   $0x8036dc
  80261c:	68 ee 00 00 00       	push   $0xee
  802621:	68 63 36 80 00       	push   $0x803663
  802626:	e8 71 de ff ff       	call   80049c <_panic>
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	c1 e0 04             	shl    $0x4,%eax
  802631:	05 84 c0 81 00       	add    $0x81c084,%eax
  802636:	8b 10                	mov    (%eax),%edx
  802638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263b:	89 50 04             	mov    %edx,0x4(%eax)
  80263e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	74 14                	je     80265c <free_block+0xea>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	c1 e0 04             	shl    $0x4,%eax
  80264e:	05 84 c0 81 00       	add    $0x81c084,%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	eb 11                	jmp    80266d <free_block+0xfb>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	c1 e0 04             	shl    $0x4,%eax
  802662:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266b:	89 02                	mov    %eax,(%edx)
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	c1 e0 04             	shl    $0x4,%eax
  802673:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267c:	89 02                	mov    %eax,(%edx)
  80267e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	c1 e0 04             	shl    $0x4,%eax
  80268d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	8d 50 01             	lea    0x1(%eax),%edx
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	c1 e0 04             	shl    $0x4,%eax
  80269d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026a2:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  8026a4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ae:	f7 75 e0             	divl   -0x20(%ebp)
  8026b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026bb:	0f b7 c0             	movzwl %ax,%eax
  8026be:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026c1:	0f 85 70 01 00 00    	jne    802837 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026c7:	83 ec 0c             	sub    $0xc,%esp
  8026ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026cd:	e8 de f6 ff ff       	call   801db0 <to_page_va>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026df:	e9 b7 00 00 00       	jmp    80279b <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026ef:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026f3:	75 17                	jne    80270c <free_block+0x19a>
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	68 21 37 80 00       	push   $0x803721
  8026fd:	68 f8 00 00 00       	push   $0xf8
  802702:	68 63 36 80 00       	push   $0x803663
  802707:	e8 90 dd ff ff       	call   80049c <_panic>
  80270c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 10                	je     802725 <free_block+0x1b3>
  802715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80271d:	8b 52 04             	mov    0x4(%edx),%edx
  802720:	89 50 04             	mov    %edx,0x4(%eax)
  802723:	eb 14                	jmp    802739 <free_block+0x1c7>
  802725:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272e:	c1 e2 04             	shl    $0x4,%edx
  802731:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802737:	89 02                	mov    %eax,(%edx)
  802739:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	85 c0                	test   %eax,%eax
  802741:	74 0f                	je     802752 <free_block+0x1e0>
  802743:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80274c:	8b 12                	mov    (%edx),%edx
  80274e:	89 10                	mov    %edx,(%eax)
  802750:	eb 13                	jmp    802765 <free_block+0x1f3>
  802752:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275a:	c1 e2 04             	shl    $0x4,%edx
  80275d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802763:	89 02                	mov    %eax,(%edx)
  802765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802768:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	c1 e0 04             	shl    $0x4,%eax
  80277e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	8d 50 ff             	lea    -0x1(%eax),%edx
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	c1 e0 04             	shl    $0x4,%eax
  80278e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802793:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802795:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802798:	01 45 ec             	add    %eax,-0x14(%ebp)
  80279b:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  8027a2:	0f 86 3c ff ff ff    	jbe    8026e4 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8027b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b4:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027be:	75 17                	jne    8027d7 <free_block+0x265>
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	68 dc 36 80 00       	push   $0x8036dc
  8027c8:	68 fe 00 00 00       	push   $0xfe
  8027cd:	68 63 36 80 00       	push   $0x803663
  8027d2:	e8 c5 dc ff ff       	call   80049c <_panic>
  8027d7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	89 50 04             	mov    %edx,0x4(%eax)
  8027e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0c                	je     8027f9 <free_block+0x287>
  8027ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f5:	89 10                	mov    %edx,(%eax)
  8027f7:	eb 08                	jmp    802801 <free_block+0x28f>
  8027f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fc:	a3 48 40 80 00       	mov    %eax,0x804048
  802801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802804:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802812:	a1 54 40 80 00       	mov    0x804054,%eax
  802817:	40                   	inc    %eax
  802818:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80281d:	83 ec 0c             	sub    $0xc,%esp
  802820:	ff 75 e4             	pushl  -0x1c(%ebp)
  802823:	e8 88 f5 ff ff       	call   801db0 <to_page_va>
  802828:	83 c4 10             	add    $0x10,%esp
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	50                   	push   %eax
  80282f:	e8 b8 ee ff ff       	call   8016ec <return_page>
  802834:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802837:	90                   	nop
  802838:	c9                   	leave  
  802839:	c3                   	ret    

0080283a <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 88 37 80 00       	push   $0x803788
  802848:	68 11 01 00 00       	push   $0x111
  80284d:	68 63 36 80 00       	push   $0x803663
  802852:	e8 45 dc ff ff       	call   80049c <_panic>

00802857 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80285d:	8b 55 08             	mov    0x8(%ebp),%edx
  802860:	89 d0                	mov    %edx,%eax
  802862:	c1 e0 02             	shl    $0x2,%eax
  802865:	01 d0                	add    %edx,%eax
  802867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80286e:	01 d0                	add    %edx,%eax
  802870:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802877:	01 d0                	add    %edx,%eax
  802879:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802880:	01 d0                	add    %edx,%eax
  802882:	c1 e0 04             	shl    $0x4,%eax
  802885:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802888:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80288f:	0f 31                	rdtsc  
  802891:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802894:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802897:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028a0:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8028a3:	eb 46                	jmp    8028eb <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8028a5:	0f 31                	rdtsc  
  8028a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8028aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8028ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8028b0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8028b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8028b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8028b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	29 c2                	sub    %eax,%edx
  8028c1:	89 d0                	mov    %edx,%eax
  8028c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8028c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	89 d1                	mov    %edx,%ecx
  8028ce:	29 c1                	sub    %eax,%ecx
  8028d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d6:	39 c2                	cmp    %eax,%edx
  8028d8:	0f 97 c0             	seta   %al
  8028db:	0f b6 c0             	movzbl %al,%eax
  8028de:	29 c1                	sub    %eax,%ecx
  8028e0:	89 c8                	mov    %ecx,%eax
  8028e2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8028e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8028eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028f1:	72 b2                	jb     8028a5 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8028f3:	90                   	nop
  8028f4:	c9                   	leave  
  8028f5:	c3                   	ret    

008028f6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8028f6:	55                   	push   %ebp
  8028f7:	89 e5                	mov    %esp,%ebp
  8028f9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8028fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802903:	eb 03                	jmp    802908 <busy_wait+0x12>
  802905:	ff 45 fc             	incl   -0x4(%ebp)
  802908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290e:	72 f5                	jb     802905 <busy_wait+0xf>
	return i;
  802910:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    
  802915:	66 90                	xchg   %ax,%ax
  802917:	90                   	nop

00802918 <__udivdi3>:
  802918:	55                   	push   %ebp
  802919:	57                   	push   %edi
  80291a:	56                   	push   %esi
  80291b:	53                   	push   %ebx
  80291c:	83 ec 1c             	sub    $0x1c,%esp
  80291f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802923:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80292b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80292f:	89 ca                	mov    %ecx,%edx
  802931:	89 f8                	mov    %edi,%eax
  802933:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802937:	85 f6                	test   %esi,%esi
  802939:	75 2d                	jne    802968 <__udivdi3+0x50>
  80293b:	39 cf                	cmp    %ecx,%edi
  80293d:	77 65                	ja     8029a4 <__udivdi3+0x8c>
  80293f:	89 fd                	mov    %edi,%ebp
  802941:	85 ff                	test   %edi,%edi
  802943:	75 0b                	jne    802950 <__udivdi3+0x38>
  802945:	b8 01 00 00 00       	mov    $0x1,%eax
  80294a:	31 d2                	xor    %edx,%edx
  80294c:	f7 f7                	div    %edi
  80294e:	89 c5                	mov    %eax,%ebp
  802950:	31 d2                	xor    %edx,%edx
  802952:	89 c8                	mov    %ecx,%eax
  802954:	f7 f5                	div    %ebp
  802956:	89 c1                	mov    %eax,%ecx
  802958:	89 d8                	mov    %ebx,%eax
  80295a:	f7 f5                	div    %ebp
  80295c:	89 cf                	mov    %ecx,%edi
  80295e:	89 fa                	mov    %edi,%edx
  802960:	83 c4 1c             	add    $0x1c,%esp
  802963:	5b                   	pop    %ebx
  802964:	5e                   	pop    %esi
  802965:	5f                   	pop    %edi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    
  802968:	39 ce                	cmp    %ecx,%esi
  80296a:	77 28                	ja     802994 <__udivdi3+0x7c>
  80296c:	0f bd fe             	bsr    %esi,%edi
  80296f:	83 f7 1f             	xor    $0x1f,%edi
  802972:	75 40                	jne    8029b4 <__udivdi3+0x9c>
  802974:	39 ce                	cmp    %ecx,%esi
  802976:	72 0a                	jb     802982 <__udivdi3+0x6a>
  802978:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80297c:	0f 87 9e 00 00 00    	ja     802a20 <__udivdi3+0x108>
  802982:	b8 01 00 00 00       	mov    $0x1,%eax
  802987:	89 fa                	mov    %edi,%edx
  802989:	83 c4 1c             	add    $0x1c,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5f                   	pop    %edi
  80298f:	5d                   	pop    %ebp
  802990:	c3                   	ret    
  802991:	8d 76 00             	lea    0x0(%esi),%esi
  802994:	31 ff                	xor    %edi,%edi
  802996:	31 c0                	xor    %eax,%eax
  802998:	89 fa                	mov    %edi,%edx
  80299a:	83 c4 1c             	add    $0x1c,%esp
  80299d:	5b                   	pop    %ebx
  80299e:	5e                   	pop    %esi
  80299f:	5f                   	pop    %edi
  8029a0:	5d                   	pop    %ebp
  8029a1:	c3                   	ret    
  8029a2:	66 90                	xchg   %ax,%ax
  8029a4:	89 d8                	mov    %ebx,%eax
  8029a6:	f7 f7                	div    %edi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	89 fa                	mov    %edi,%edx
  8029ac:	83 c4 1c             	add    $0x1c,%esp
  8029af:	5b                   	pop    %ebx
  8029b0:	5e                   	pop    %esi
  8029b1:	5f                   	pop    %edi
  8029b2:	5d                   	pop    %ebp
  8029b3:	c3                   	ret    
  8029b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029b9:	89 eb                	mov    %ebp,%ebx
  8029bb:	29 fb                	sub    %edi,%ebx
  8029bd:	89 f9                	mov    %edi,%ecx
  8029bf:	d3 e6                	shl    %cl,%esi
  8029c1:	89 c5                	mov    %eax,%ebp
  8029c3:	88 d9                	mov    %bl,%cl
  8029c5:	d3 ed                	shr    %cl,%ebp
  8029c7:	89 e9                	mov    %ebp,%ecx
  8029c9:	09 f1                	or     %esi,%ecx
  8029cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029cf:	89 f9                	mov    %edi,%ecx
  8029d1:	d3 e0                	shl    %cl,%eax
  8029d3:	89 c5                	mov    %eax,%ebp
  8029d5:	89 d6                	mov    %edx,%esi
  8029d7:	88 d9                	mov    %bl,%cl
  8029d9:	d3 ee                	shr    %cl,%esi
  8029db:	89 f9                	mov    %edi,%ecx
  8029dd:	d3 e2                	shl    %cl,%edx
  8029df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029e3:	88 d9                	mov    %bl,%cl
  8029e5:	d3 e8                	shr    %cl,%eax
  8029e7:	09 c2                	or     %eax,%edx
  8029e9:	89 d0                	mov    %edx,%eax
  8029eb:	89 f2                	mov    %esi,%edx
  8029ed:	f7 74 24 0c          	divl   0xc(%esp)
  8029f1:	89 d6                	mov    %edx,%esi
  8029f3:	89 c3                	mov    %eax,%ebx
  8029f5:	f7 e5                	mul    %ebp
  8029f7:	39 d6                	cmp    %edx,%esi
  8029f9:	72 19                	jb     802a14 <__udivdi3+0xfc>
  8029fb:	74 0b                	je     802a08 <__udivdi3+0xf0>
  8029fd:	89 d8                	mov    %ebx,%eax
  8029ff:	31 ff                	xor    %edi,%edi
  802a01:	e9 58 ff ff ff       	jmp    80295e <__udivdi3+0x46>
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a0c:	89 f9                	mov    %edi,%ecx
  802a0e:	d3 e2                	shl    %cl,%edx
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	73 e9                	jae    8029fd <__udivdi3+0xe5>
  802a14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a17:	31 ff                	xor    %edi,%edi
  802a19:	e9 40 ff ff ff       	jmp    80295e <__udivdi3+0x46>
  802a1e:	66 90                	xchg   %ax,%ax
  802a20:	31 c0                	xor    %eax,%eax
  802a22:	e9 37 ff ff ff       	jmp    80295e <__udivdi3+0x46>
  802a27:	90                   	nop

00802a28 <__umoddi3>:
  802a28:	55                   	push   %ebp
  802a29:	57                   	push   %edi
  802a2a:	56                   	push   %esi
  802a2b:	53                   	push   %ebx
  802a2c:	83 ec 1c             	sub    $0x1c,%esp
  802a2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a33:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a47:	89 f3                	mov    %esi,%ebx
  802a49:	89 fa                	mov    %edi,%edx
  802a4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a4f:	89 34 24             	mov    %esi,(%esp)
  802a52:	85 c0                	test   %eax,%eax
  802a54:	75 1a                	jne    802a70 <__umoddi3+0x48>
  802a56:	39 f7                	cmp    %esi,%edi
  802a58:	0f 86 a2 00 00 00    	jbe    802b00 <__umoddi3+0xd8>
  802a5e:	89 c8                	mov    %ecx,%eax
  802a60:	89 f2                	mov    %esi,%edx
  802a62:	f7 f7                	div    %edi
  802a64:	89 d0                	mov    %edx,%eax
  802a66:	31 d2                	xor    %edx,%edx
  802a68:	83 c4 1c             	add    $0x1c,%esp
  802a6b:	5b                   	pop    %ebx
  802a6c:	5e                   	pop    %esi
  802a6d:	5f                   	pop    %edi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    
  802a70:	39 f0                	cmp    %esi,%eax
  802a72:	0f 87 ac 00 00 00    	ja     802b24 <__umoddi3+0xfc>
  802a78:	0f bd e8             	bsr    %eax,%ebp
  802a7b:	83 f5 1f             	xor    $0x1f,%ebp
  802a7e:	0f 84 ac 00 00 00    	je     802b30 <__umoddi3+0x108>
  802a84:	bf 20 00 00 00       	mov    $0x20,%edi
  802a89:	29 ef                	sub    %ebp,%edi
  802a8b:	89 fe                	mov    %edi,%esi
  802a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a91:	89 e9                	mov    %ebp,%ecx
  802a93:	d3 e0                	shl    %cl,%eax
  802a95:	89 d7                	mov    %edx,%edi
  802a97:	89 f1                	mov    %esi,%ecx
  802a99:	d3 ef                	shr    %cl,%edi
  802a9b:	09 c7                	or     %eax,%edi
  802a9d:	89 e9                	mov    %ebp,%ecx
  802a9f:	d3 e2                	shl    %cl,%edx
  802aa1:	89 14 24             	mov    %edx,(%esp)
  802aa4:	89 d8                	mov    %ebx,%eax
  802aa6:	d3 e0                	shl    %cl,%eax
  802aa8:	89 c2                	mov    %eax,%edx
  802aaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  802aae:	d3 e0                	shl    %cl,%eax
  802ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ab8:	89 f1                	mov    %esi,%ecx
  802aba:	d3 e8                	shr    %cl,%eax
  802abc:	09 d0                	or     %edx,%eax
  802abe:	d3 eb                	shr    %cl,%ebx
  802ac0:	89 da                	mov    %ebx,%edx
  802ac2:	f7 f7                	div    %edi
  802ac4:	89 d3                	mov    %edx,%ebx
  802ac6:	f7 24 24             	mull   (%esp)
  802ac9:	89 c6                	mov    %eax,%esi
  802acb:	89 d1                	mov    %edx,%ecx
  802acd:	39 d3                	cmp    %edx,%ebx
  802acf:	0f 82 87 00 00 00    	jb     802b5c <__umoddi3+0x134>
  802ad5:	0f 84 91 00 00 00    	je     802b6c <__umoddi3+0x144>
  802adb:	8b 54 24 04          	mov    0x4(%esp),%edx
  802adf:	29 f2                	sub    %esi,%edx
  802ae1:	19 cb                	sbb    %ecx,%ebx
  802ae3:	89 d8                	mov    %ebx,%eax
  802ae5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ae9:	d3 e0                	shl    %cl,%eax
  802aeb:	89 e9                	mov    %ebp,%ecx
  802aed:	d3 ea                	shr    %cl,%edx
  802aef:	09 d0                	or     %edx,%eax
  802af1:	89 e9                	mov    %ebp,%ecx
  802af3:	d3 eb                	shr    %cl,%ebx
  802af5:	89 da                	mov    %ebx,%edx
  802af7:	83 c4 1c             	add    $0x1c,%esp
  802afa:	5b                   	pop    %ebx
  802afb:	5e                   	pop    %esi
  802afc:	5f                   	pop    %edi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    
  802aff:	90                   	nop
  802b00:	89 fd                	mov    %edi,%ebp
  802b02:	85 ff                	test   %edi,%edi
  802b04:	75 0b                	jne    802b11 <__umoddi3+0xe9>
  802b06:	b8 01 00 00 00       	mov    $0x1,%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	f7 f7                	div    %edi
  802b0f:	89 c5                	mov    %eax,%ebp
  802b11:	89 f0                	mov    %esi,%eax
  802b13:	31 d2                	xor    %edx,%edx
  802b15:	f7 f5                	div    %ebp
  802b17:	89 c8                	mov    %ecx,%eax
  802b19:	f7 f5                	div    %ebp
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	e9 44 ff ff ff       	jmp    802a66 <__umoddi3+0x3e>
  802b22:	66 90                	xchg   %ax,%ax
  802b24:	89 c8                	mov    %ecx,%eax
  802b26:	89 f2                	mov    %esi,%edx
  802b28:	83 c4 1c             	add    $0x1c,%esp
  802b2b:	5b                   	pop    %ebx
  802b2c:	5e                   	pop    %esi
  802b2d:	5f                   	pop    %edi
  802b2e:	5d                   	pop    %ebp
  802b2f:	c3                   	ret    
  802b30:	3b 04 24             	cmp    (%esp),%eax
  802b33:	72 06                	jb     802b3b <__umoddi3+0x113>
  802b35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b39:	77 0f                	ja     802b4a <__umoddi3+0x122>
  802b3b:	89 f2                	mov    %esi,%edx
  802b3d:	29 f9                	sub    %edi,%ecx
  802b3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b43:	89 14 24             	mov    %edx,(%esp)
  802b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b4e:	8b 14 24             	mov    (%esp),%edx
  802b51:	83 c4 1c             	add    $0x1c,%esp
  802b54:	5b                   	pop    %ebx
  802b55:	5e                   	pop    %esi
  802b56:	5f                   	pop    %edi
  802b57:	5d                   	pop    %ebp
  802b58:	c3                   	ret    
  802b59:	8d 76 00             	lea    0x0(%esi),%esi
  802b5c:	2b 04 24             	sub    (%esp),%eax
  802b5f:	19 fa                	sbb    %edi,%edx
  802b61:	89 d1                	mov    %edx,%ecx
  802b63:	89 c6                	mov    %eax,%esi
  802b65:	e9 71 ff ff ff       	jmp    802adb <__umoddi3+0xb3>
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b70:	72 ea                	jb     802b5c <__umoddi3+0x134>
  802b72:	89 d9                	mov    %ebx,%ecx
  802b74:	e9 62 ff ff ff       	jmp    802adb <__umoddi3+0xb3>
