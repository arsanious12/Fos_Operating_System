
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 9c 02 00 00       	call   8002d2 <libmain>
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
	// Testing scenario 4: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 c0 2a 80 00       	push   $0x802ac0
  800050:	e8 1a 17 00 00       	call   80176f <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb c1 2c 80 00       	mov    $0x802cc1,%ebx
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
  8000a1:	e8 79 1c 00 00       	call   801d1f <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 72 18 00 00       	call   801920 <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 b5 18 00 00       	call   80196b <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 d0 2a 80 00       	push   $0x802ad0
  8000c4:	e8 9c 06 00 00       	call   800765 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d1:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000d7:	89 c2                	mov    %eax,%edx
  8000d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000de:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e4:	6a 32                	push   $0x32
  8000e6:	52                   	push   %edx
  8000e7:	50                   	push   %eax
  8000e8:	68 03 2b 80 00       	push   $0x802b03
  8000ed:	e8 89 19 00 00       	call   801a7b <sys_create_env>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000fd:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800103:	89 c2                	mov    %eax,%edx
  800105:	a1 20 40 80 00       	mov    0x804020,%eax
  80010a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800110:	6a 32                	push   $0x32
  800112:	52                   	push   %edx
  800113:	50                   	push   %eax
  800114:	68 0c 2b 80 00       	push   $0x802b0c
  800119:	e8 5d 19 00 00       	call   801a7b <sys_create_env>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	ff 75 d8             	pushl  -0x28(%ebp)
  80012a:	e8 6a 19 00 00       	call   801a99 <sys_run_env>
  80012f:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  800132:	90                   	nop
  800133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800136:	8b 00                	mov    (%eax),%eax
  800138:	83 f8 01             	cmp    $0x1,%eax
  80013b:	75 f6                	jne    800133 <_main+0xfb>

	sys_run_env(envIdProcessB);
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 d4             	pushl  -0x2c(%ebp)
  800143:	e8 51 19 00 00       	call   801a99 <sys_run_env>
  800148:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80014b:	90                   	nop
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	8b 00                	mov    (%eax),%eax
  800151:	83 f8 02             	cmp    $0x2,%eax
  800154:	75 f6                	jne    80014c <_main+0x114>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800156:	e8 c5 17 00 00       	call   801920 <sys_calculate_free_frames>
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	50                   	push   %eax
  80015f:	68 18 2b 80 00       	push   $0x802b18
  800164:	e8 fc 05 00 00       	call   800765 <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80016c:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 9d 1b 00 00       	call   801d1f <sys_utilities>
  800182:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800185:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80018b:	bb 25 2d 80 00       	mov    $0x802d25,%ebx
  800190:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800195:	89 c7                	mov    %eax,%edi
  800197:	89 de                	mov    %ebx,%esi
  800199:	89 d1                	mov    %edx,%ecx
  80019b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80019d:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001a3:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001a8:	b0 00                	mov    $0x0,%al
  8001aa:	89 d7                	mov    %edx,%edi
  8001ac:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	6a 00                	push   $0x0
  8001b3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001b9:	50                   	push   %eax
  8001ba:	e8 60 1b 00 00       	call   801d1f <sys_utilities>
  8001bf:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c8:	e8 e8 18 00 00       	call   801ab5 <sys_destroy_env>
  8001cd:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001d6:	e8 da 18 00 00       	call   801ab5 <sys_destroy_env>
  8001db:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	6a 01                	push   $0x1
  8001e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001e9:	50                   	push   %eax
  8001ea:	e8 30 1b 00 00       	call   801d1f <sys_utilities>
  8001ef:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001f2:	e8 29 17 00 00       	call   801920 <sys_calculate_free_frames>
  8001f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001fa:	e8 6c 17 00 00       	call   80196b <sys_pf_calculate_allocated_pages>
  8001ff:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  800202:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800209:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 d0                	add    %edx,%eax
  800214:	48                   	dec    %eax
  800215:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800218:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80021b:	ba 00 00 00 00       	mov    $0x0,%edx
  800220:	f7 75 c8             	divl   -0x38(%ebp)
  800223:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800226:	29 d0                	sub    %edx,%eax
  800228:	89 c1                	mov    %eax,%ecx
  80022a:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800231:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800237:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	48                   	dec    %eax
  80023d:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800240:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 75 c0             	divl   -0x40(%ebp)
  80024b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80024e:	29 d0                	sub    %edx,%eax
  800250:	29 c1                	sub    %eax,%ecx
  800252:	89 c8                	mov    %ecx,%eax
  800254:	c1 e8 0c             	shr    $0xc,%eax
  800257:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	68 4a 2b 80 00       	push   $0x802b4a
  800265:	e8 fb 04 00 00       	call   800765 <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80026d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800270:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800273:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800276:	74 2e                	je     8002a6 <_main+0x26e>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800278:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80027b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	50                   	push   %eax
  800282:	ff 75 d0             	pushl  -0x30(%ebp)
  800285:	68 5c 2b 80 00       	push   $0x802b5c
  80028a:	e8 d6 04 00 00       	call   800765 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 cc 2b 80 00       	push   $0x802bcc
  80029a:	6a 38                	push   $0x38
  80029c:	68 02 2c 80 00       	push   $0x802c02
  8002a1:	e8 f1 01 00 00       	call   800497 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ac:	68 18 2c 80 00       	push   $0x802c18
  8002b1:	e8 af 04 00 00       	call   800765 <cprintf>
  8002b6:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  8002b9:	83 ec 0c             	sub    $0xc,%esp
  8002bc:	68 78 2c 80 00       	push   $0x802c78
  8002c1:	e8 9f 04 00 00       	call   800765 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	return;
  8002c9:	90                   	nop
}
  8002ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cd:	5b                   	pop    %ebx
  8002ce:	5e                   	pop    %esi
  8002cf:	5f                   	pop    %edi
  8002d0:	5d                   	pop    %ebp
  8002d1:	c3                   	ret    

008002d2 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002db:	e8 09 18 00 00       	call   801ae9 <sys_getenvindex>
  8002e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e6:	89 d0                	mov    %edx,%eax
  8002e8:	c1 e0 06             	shl    $0x6,%eax
  8002eb:	29 d0                	sub    %edx,%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	01 d0                	add    %edx,%eax
  8002f2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	c1 e0 03             	shl    $0x3,%eax
  8002fe:	01 d0                	add    %edx,%eax
  800300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800307:	29 c2                	sub    %eax,%edx
  800309:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800310:	89 c2                	mov    %eax,%edx
  800312:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800318:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80031d:	a1 20 40 80 00       	mov    0x804020,%eax
  800322:	8a 40 20             	mov    0x20(%eax),%al
  800325:	84 c0                	test   %al,%al
  800327:	74 0d                	je     800336 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	83 c0 20             	add    $0x20,%eax
  800331:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800336:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80033a:	7e 0a                	jle    800346 <libmain+0x74>
		binaryname = argv[0];
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800346:	83 ec 08             	sub    $0x8,%esp
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 e4 fc ff ff       	call   800038 <_main>
  800354:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800357:	a1 00 40 80 00       	mov    0x804000,%eax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	0f 84 01 01 00 00    	je     800465 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800364:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80036a:	bb 84 2e 80 00       	mov    $0x802e84,%ebx
  80036f:	ba 0e 00 00 00       	mov    $0xe,%edx
  800374:	89 c7                	mov    %eax,%edi
  800376:	89 de                	mov    %ebx,%esi
  800378:	89 d1                	mov    %edx,%ecx
  80037a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80037c:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80037f:	b9 56 00 00 00       	mov    $0x56,%ecx
  800384:	b0 00                	mov    $0x0,%al
  800386:	89 d7                	mov    %edx,%edi
  800388:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80038a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800391:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	50                   	push   %eax
  800398:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80039e:	50                   	push   %eax
  80039f:	e8 7b 19 00 00       	call   801d1f <sys_utilities>
  8003a4:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003a7:	e8 c4 14 00 00       	call   801870 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	68 a4 2d 80 00       	push   $0x802da4
  8003b4:	e8 ac 03 00 00       	call   800765 <cprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	74 18                	je     8003db <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003c3:	e8 75 19 00 00       	call   801d3d <sys_get_optimal_num_faults>
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	50                   	push   %eax
  8003cc:	68 cc 2d 80 00       	push   $0x802dcc
  8003d1:	e8 8f 03 00 00       	call   800765 <cprintf>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	eb 59                	jmp    800434 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003eb:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	52                   	push   %edx
  8003f5:	50                   	push   %eax
  8003f6:	68 f0 2d 80 00       	push   $0x802df0
  8003fb:	e8 65 03 00 00       	call   800765 <cprintf>
  800400:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800424:	51                   	push   %ecx
  800425:	52                   	push   %edx
  800426:	50                   	push   %eax
  800427:	68 18 2e 80 00       	push   $0x802e18
  80042c:	e8 34 03 00 00       	call   800765 <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	50                   	push   %eax
  800443:	68 70 2e 80 00       	push   $0x802e70
  800448:	e8 18 03 00 00       	call   800765 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	68 a4 2d 80 00       	push   $0x802da4
  800458:	e8 08 03 00 00       	call   800765 <cprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800460:	e8 25 14 00 00       	call   80188a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800465:	e8 1f 00 00 00       	call   800489 <exit>
}
  80046a:	90                   	nop
  80046b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80046e:	5b                   	pop    %ebx
  80046f:	5e                   	pop    %esi
  800470:	5f                   	pop    %edi
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800479:	83 ec 0c             	sub    $0xc,%esp
  80047c:	6a 00                	push   $0x0
  80047e:	e8 32 16 00 00       	call   801ab5 <sys_destroy_env>
  800483:	83 c4 10             	add    $0x10,%esp
}
  800486:	90                   	nop
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <exit>:

void
exit(void)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048f:	e8 87 16 00 00       	call   801b1b <sys_exit_env>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049d:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a0:	83 c0 04             	add    $0x4,%eax
  8004a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a6:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 16                	je     8004c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004af:	a1 18 c1 81 00       	mov    0x81c118,%eax
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	50                   	push   %eax
  8004b8:	68 e8 2e 80 00       	push   $0x802ee8
  8004bd:	e8 a3 02 00 00       	call   800765 <cprintf>
  8004c2:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	ff 75 0c             	pushl  0xc(%ebp)
  8004d0:	ff 75 08             	pushl  0x8(%ebp)
  8004d3:	50                   	push   %eax
  8004d4:	68 f0 2e 80 00       	push   $0x802ef0
  8004d9:	6a 74                	push   $0x74
  8004db:	e8 b2 02 00 00       	call   800792 <cprintf_colored>
  8004e0:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	e8 04 02 00 00       	call   8006f6 <vcprintf>
  8004f2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	6a 00                	push   $0x0
  8004fa:	68 18 2f 80 00       	push   $0x802f18
  8004ff:	e8 f2 01 00 00       	call   8006f6 <vcprintf>
  800504:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800507:	e8 7d ff ff ff       	call   800489 <exit>

	// should not return here
	while (1) ;
  80050c:	eb fe                	jmp    80050c <_panic+0x75>

0080050e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800514:	a1 20 40 80 00       	mov    0x804020,%eax
  800519:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	74 14                	je     80053a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800526:	83 ec 04             	sub    $0x4,%esp
  800529:	68 1c 2f 80 00       	push   $0x802f1c
  80052e:	6a 26                	push   $0x26
  800530:	68 68 2f 80 00       	push   $0x802f68
  800535:	e8 5d ff ff ff       	call   800497 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80053a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800548:	e9 c5 00 00 00       	jmp    800612 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800550:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	01 d0                	add    %edx,%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	75 08                	jne    80056a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800562:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800565:	e9 a5 00 00 00       	jmp    80060f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800571:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800578:	eb 69                	jmp    8005e3 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80057a:	a1 20 40 80 00       	mov    0x804020,%eax
  80057f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800585:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	01 c0                	add    %eax,%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	c1 e0 03             	shl    $0x3,%eax
  800591:	01 c8                	add    %ecx,%eax
  800593:	8a 40 04             	mov    0x4(%eax),%al
  800596:	84 c0                	test   %al,%al
  800598:	75 46                	jne    8005e0 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80059a:	a1 20 40 80 00       	mov    0x804020,%eax
  80059f:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a8:	89 d0                	mov    %edx,%eax
  8005aa:	01 c0                	add    %eax,%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	c1 e0 03             	shl    $0x3,%eax
  8005b1:	01 c8                	add    %ecx,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cf:	01 c8                	add    %ecx,%eax
  8005d1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d3:	39 c2                	cmp    %eax,%edx
  8005d5:	75 09                	jne    8005e0 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005d7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005de:	eb 15                	jmp    8005f5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e0:	ff 45 e8             	incl   -0x18(%ebp)
  8005e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f1:	39 c2                	cmp    %eax,%edx
  8005f3:	77 85                	ja     80057a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f9:	75 14                	jne    80060f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 74 2f 80 00       	push   $0x802f74
  800603:	6a 3a                	push   $0x3a
  800605:	68 68 2f 80 00       	push   $0x802f68
  80060a:	e8 88 fe ff ff       	call   800497 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80060f:	ff 45 f0             	incl   -0x10(%ebp)
  800612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800615:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800618:	0f 8c 2f ff ff ff    	jl     80054d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80061e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80062c:	eb 26                	jmp    800654 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80062e:	a1 20 40 80 00       	mov    0x804020,%eax
  800633:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800639:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063c:	89 d0                	mov    %edx,%eax
  80063e:	01 c0                	add    %eax,%eax
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 03             	shl    $0x3,%eax
  800645:	01 c8                	add    %ecx,%eax
  800647:	8a 40 04             	mov    0x4(%eax),%al
  80064a:	3c 01                	cmp    $0x1,%al
  80064c:	75 03                	jne    800651 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80064e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800651:	ff 45 e0             	incl   -0x20(%ebp)
  800654:	a1 20 40 80 00       	mov    0x804020,%eax
  800659:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80065f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800662:	39 c2                	cmp    %eax,%edx
  800664:	77 c8                	ja     80062e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800669:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066c:	74 14                	je     800682 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	68 c8 2f 80 00       	push   $0x802fc8
  800676:	6a 44                	push   $0x44
  800678:	68 68 2f 80 00       	push   $0x802f68
  80067d:	e8 15 fe ff ff       	call   800497 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800682:	90                   	nop
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
  800688:	53                   	push   %ebx
  800689:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80068c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	8d 48 01             	lea    0x1(%eax),%ecx
  800694:	8b 55 0c             	mov    0xc(%ebp),%edx
  800697:	89 0a                	mov    %ecx,(%edx)
  800699:	8b 55 08             	mov    0x8(%ebp),%edx
  80069c:	88 d1                	mov    %dl,%cl
  80069e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006af:	75 30                	jne    8006e1 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006b1:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006b7:	a0 44 40 80 00       	mov    0x804044,%al
  8006bc:	0f b6 c0             	movzbl %al,%eax
  8006bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c2:	8b 09                	mov    (%ecx),%ecx
  8006c4:	89 cb                	mov    %ecx,%ebx
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	83 c1 08             	add    $0x8,%ecx
  8006cc:	52                   	push   %edx
  8006cd:	50                   	push   %eax
  8006ce:	53                   	push   %ebx
  8006cf:	51                   	push   %ecx
  8006d0:	e8 57 11 00 00       	call   80182c <sys_cputs>
  8006d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	8b 40 04             	mov    0x4(%eax),%eax
  8006e7:	8d 50 01             	lea    0x1(%eax),%edx
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f0:	90                   	nop
  8006f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800706:	00 00 00 
	b.cnt = 0;
  800709:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800710:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	ff 75 08             	pushl  0x8(%ebp)
  800719:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80071f:	50                   	push   %eax
  800720:	68 85 06 80 00       	push   $0x800685
  800725:	e8 5a 02 00 00       	call   800984 <vprintfmt>
  80072a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80072d:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800733:	a0 44 40 80 00       	mov    0x804044,%al
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800741:	52                   	push   %edx
  800742:	50                   	push   %eax
  800743:	51                   	push   %ecx
  800744:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074a:	83 c0 08             	add    $0x8,%eax
  80074d:	50                   	push   %eax
  80074e:	e8 d9 10 00 00       	call   80182c <sys_cputs>
  800753:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800756:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80075d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076b:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800772:	8d 45 0c             	lea    0xc(%ebp),%eax
  800775:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 f4             	pushl  -0xc(%ebp)
  800781:	50                   	push   %eax
  800782:	e8 6f ff ff ff       	call   8006f6 <vcprintf>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800798:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	c1 e0 08             	shl    $0x8,%eax
  8007a5:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  8007aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ad:	83 c0 04             	add    $0x4,%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 34 ff ff ff       	call   8006f6 <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007c8:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007cf:	07 00 00 

	return cnt;
  8007d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d5:	c9                   	leave  
  8007d6:	c3                   	ret    

008007d7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007dd:	e8 8e 10 00 00       	call   801870 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007e2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f1:	50                   	push   %eax
  8007f2:	e8 ff fe ff ff       	call   8006f6 <vcprintf>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007fd:	e8 88 10 00 00       	call   80188a <sys_unlock_cons>
	return cnt;
  800802:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800805:	c9                   	leave  
  800806:	c3                   	ret    

00800807 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	83 ec 14             	sub    $0x14,%esp
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80081a:	8b 45 18             	mov    0x18(%ebp),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800825:	77 55                	ja     80087c <printnum+0x75>
  800827:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80082a:	72 05                	jb     800831 <printnum+0x2a>
  80082c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082f:	77 4b                	ja     80087c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800831:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800834:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800837:	8b 45 18             	mov    0x18(%ebp),%eax
  80083a:	ba 00 00 00 00       	mov    $0x0,%edx
  80083f:	52                   	push   %edx
  800840:	50                   	push   %eax
  800841:	ff 75 f4             	pushl  -0xc(%ebp)
  800844:	ff 75 f0             	pushl  -0x10(%ebp)
  800847:	e8 08 20 00 00       	call   802854 <__udivdi3>
  80084c:	83 c4 10             	add    $0x10,%esp
  80084f:	83 ec 04             	sub    $0x4,%esp
  800852:	ff 75 20             	pushl  0x20(%ebp)
  800855:	53                   	push   %ebx
  800856:	ff 75 18             	pushl  0x18(%ebp)
  800859:	52                   	push   %edx
  80085a:	50                   	push   %eax
  80085b:	ff 75 0c             	pushl  0xc(%ebp)
  80085e:	ff 75 08             	pushl  0x8(%ebp)
  800861:	e8 a1 ff ff ff       	call   800807 <printnum>
  800866:	83 c4 20             	add    $0x20,%esp
  800869:	eb 1a                	jmp    800885 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80086b:	83 ec 08             	sub    $0x8,%esp
  80086e:	ff 75 0c             	pushl  0xc(%ebp)
  800871:	ff 75 20             	pushl  0x20(%ebp)
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087c:	ff 4d 1c             	decl   0x1c(%ebp)
  80087f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800883:	7f e6                	jg     80086b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800885:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800888:	bb 00 00 00 00       	mov    $0x0,%ebx
  80088d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800893:	53                   	push   %ebx
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	e8 c8 20 00 00       	call   802964 <__umoddi3>
  80089c:	83 c4 10             	add    $0x10,%esp
  80089f:	05 34 32 80 00       	add    $0x803234,%eax
  8008a4:	8a 00                	mov    (%eax),%al
  8008a6:	0f be c0             	movsbl %al,%eax
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	50                   	push   %eax
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
}
  8008b8:	90                   	nop
  8008b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    

008008be <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c5:	7e 1c                	jle    8008e3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 50 08             	lea    0x8(%eax),%edx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	89 10                	mov    %edx,(%eax)
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	83 e8 08             	sub    $0x8,%eax
  8008dc:	8b 50 04             	mov    0x4(%eax),%edx
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	eb 40                	jmp    800923 <getuint+0x65>
	else if (lflag)
  8008e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e7:	74 1e                	je     800907 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 50 04             	lea    0x4(%eax),%edx
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 10                	mov    %edx,(%eax)
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 00                	mov    (%eax),%eax
  8008fb:	83 e8 04             	sub    $0x4,%eax
  8008fe:	8b 00                	mov    (%eax),%eax
  800900:	ba 00 00 00 00       	mov    $0x0,%edx
  800905:	eb 1c                	jmp    800923 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 00                	mov    (%eax),%eax
  80090c:	8d 50 04             	lea    0x4(%eax),%edx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	89 10                	mov    %edx,(%eax)
  800914:	8b 45 08             	mov    0x8(%ebp),%eax
  800917:	8b 00                	mov    (%eax),%eax
  800919:	83 e8 04             	sub    $0x4,%eax
  80091c:	8b 00                	mov    (%eax),%eax
  80091e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800923:	5d                   	pop    %ebp
  800924:	c3                   	ret    

00800925 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800928:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80092c:	7e 1c                	jle    80094a <getint+0x25>
		return va_arg(*ap, long long);
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	8b 00                	mov    (%eax),%eax
  800933:	8d 50 08             	lea    0x8(%eax),%edx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	89 10                	mov    %edx,(%eax)
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	83 e8 08             	sub    $0x8,%eax
  800943:	8b 50 04             	mov    0x4(%eax),%edx
  800946:	8b 00                	mov    (%eax),%eax
  800948:	eb 38                	jmp    800982 <getint+0x5d>
	else if (lflag)
  80094a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094e:	74 1a                	je     80096a <getint+0x45>
		return va_arg(*ap, long);
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	8b 00                	mov    (%eax),%eax
  800955:	8d 50 04             	lea    0x4(%eax),%edx
  800958:	8b 45 08             	mov    0x8(%ebp),%eax
  80095b:	89 10                	mov    %edx,(%eax)
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 00                	mov    (%eax),%eax
  800962:	83 e8 04             	sub    $0x4,%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	99                   	cltd   
  800968:	eb 18                	jmp    800982 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	8b 00                	mov    (%eax),%eax
  80096f:	8d 50 04             	lea    0x4(%eax),%edx
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	89 10                	mov    %edx,(%eax)
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 e8 04             	sub    $0x4,%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	99                   	cltd   
}
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80098c:	eb 17                	jmp    8009a5 <vprintfmt+0x21>
			if (ch == '\0')
  80098e:	85 db                	test   %ebx,%ebx
  800990:	0f 84 c1 03 00 00    	je     800d57 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	53                   	push   %ebx
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a8:	8d 50 01             	lea    0x1(%eax),%edx
  8009ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ae:	8a 00                	mov    (%eax),%al
  8009b0:	0f b6 d8             	movzbl %al,%ebx
  8009b3:	83 fb 25             	cmp    $0x25,%ebx
  8009b6:	75 d6                	jne    80098e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009bc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009c3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009db:	8d 50 01             	lea    0x1(%eax),%edx
  8009de:	89 55 10             	mov    %edx,0x10(%ebp)
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f b6 d8             	movzbl %al,%ebx
  8009e6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e9:	83 f8 5b             	cmp    $0x5b,%eax
  8009ec:	0f 87 3d 03 00 00    	ja     800d2f <vprintfmt+0x3ab>
  8009f2:	8b 04 85 58 32 80 00 	mov    0x803258(,%eax,4),%eax
  8009f9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009fb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ff:	eb d7                	jmp    8009d8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a01:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a05:	eb d1                	jmp    8009d8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a11:	89 d0                	mov    %edx,%eax
  800a13:	c1 e0 02             	shl    $0x2,%eax
  800a16:	01 d0                	add    %edx,%eax
  800a18:	01 c0                	add    %eax,%eax
  800a1a:	01 d8                	add    %ebx,%eax
  800a1c:	83 e8 30             	sub    $0x30,%eax
  800a1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	8a 00                	mov    (%eax),%al
  800a27:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a2a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a2d:	7e 3e                	jle    800a6d <vprintfmt+0xe9>
  800a2f:	83 fb 39             	cmp    $0x39,%ebx
  800a32:	7f 39                	jg     800a6d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a34:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a37:	eb d5                	jmp    800a0e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 c0 04             	add    $0x4,%eax
  800a3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a42:	8b 45 14             	mov    0x14(%ebp),%eax
  800a45:	83 e8 04             	sub    $0x4,%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a4d:	eb 1f                	jmp    800a6e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a53:	79 83                	jns    8009d8 <vprintfmt+0x54>
				width = 0;
  800a55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a5c:	e9 77 ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a61:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a68:	e9 6b ff ff ff       	jmp    8009d8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a6d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a72:	0f 89 60 ff ff ff    	jns    8009d8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a85:	e9 4e ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a8a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a8d:	e9 46 ff ff ff       	jmp    8009d8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a92:	8b 45 14             	mov    0x14(%ebp),%eax
  800a95:	83 c0 04             	add    $0x4,%eax
  800a98:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9e:	83 e8 04             	sub    $0x4,%eax
  800aa1:	8b 00                	mov    (%eax),%eax
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	50                   	push   %eax
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	ff d0                	call   *%eax
  800aaf:	83 c4 10             	add    $0x10,%esp
			break;
  800ab2:	e9 9b 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac8:	85 db                	test   %ebx,%ebx
  800aca:	79 02                	jns    800ace <vprintfmt+0x14a>
				err = -err;
  800acc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ace:	83 fb 64             	cmp    $0x64,%ebx
  800ad1:	7f 0b                	jg     800ade <vprintfmt+0x15a>
  800ad3:	8b 34 9d a0 30 80 00 	mov    0x8030a0(,%ebx,4),%esi
  800ada:	85 f6                	test   %esi,%esi
  800adc:	75 19                	jne    800af7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ade:	53                   	push   %ebx
  800adf:	68 45 32 80 00       	push   $0x803245
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 70 02 00 00       	call   800d5f <printfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800af2:	e9 5b 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af7:	56                   	push   %esi
  800af8:	68 4e 32 80 00       	push   $0x80324e
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 57 02 00 00       	call   800d5f <printfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
			break;
  800b0b:	e9 42 02 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 30                	mov    (%eax),%esi
  800b21:	85 f6                	test   %esi,%esi
  800b23:	75 05                	jne    800b2a <vprintfmt+0x1a6>
				p = "(null)";
  800b25:	be 51 32 80 00       	mov    $0x803251,%esi
			if (width > 0 && padc != '-')
  800b2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2e:	7e 6d                	jle    800b9d <vprintfmt+0x219>
  800b30:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b34:	74 67                	je     800b9d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b39:	83 ec 08             	sub    $0x8,%esp
  800b3c:	50                   	push   %eax
  800b3d:	56                   	push   %esi
  800b3e:	e8 1e 03 00 00       	call   800e61 <strnlen>
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b49:	eb 16                	jmp    800b61 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b4b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	ff d0                	call   *%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b65:	7f e4                	jg     800b4b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b67:	eb 34                	jmp    800b9d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b6d:	74 1c                	je     800b8b <vprintfmt+0x207>
  800b6f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b72:	7e 05                	jle    800b79 <vprintfmt+0x1f5>
  800b74:	83 fb 7e             	cmp    $0x7e,%ebx
  800b77:	7e 12                	jle    800b8b <vprintfmt+0x207>
					putch('?', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 3f                	push   $0x3f
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	eb 0f                	jmp    800b9a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 0c             	pushl  0xc(%ebp)
  800b91:	53                   	push   %ebx
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b9a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9d:	89 f0                	mov    %esi,%eax
  800b9f:	8d 70 01             	lea    0x1(%eax),%esi
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	0f be d8             	movsbl %al,%ebx
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	74 24                	je     800bcf <vprintfmt+0x24b>
  800bab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baf:	78 b8                	js     800b69 <vprintfmt+0x1e5>
  800bb1:	ff 4d e0             	decl   -0x20(%ebp)
  800bb4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb8:	79 af                	jns    800b69 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bba:	eb 13                	jmp    800bcf <vprintfmt+0x24b>
				putch(' ', putdat);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 0c             	pushl  0xc(%ebp)
  800bc2:	6a 20                	push   $0x20
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	ff d0                	call   *%eax
  800bc9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bcc:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bd3:	7f e7                	jg     800bbc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd5:	e9 78 01 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bda:	83 ec 08             	sub    $0x8,%esp
  800bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  800be0:	8d 45 14             	lea    0x14(%ebp),%eax
  800be3:	50                   	push   %eax
  800be4:	e8 3c fd ff ff       	call   800925 <getint>
  800be9:	83 c4 10             	add    $0x10,%esp
  800bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf8:	85 d2                	test   %edx,%edx
  800bfa:	79 23                	jns    800c1f <vprintfmt+0x29b>
				putch('-', putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	6a 2d                	push   $0x2d
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	ff d0                	call   *%eax
  800c09:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c12:	f7 d8                	neg    %eax
  800c14:	83 d2 00             	adc    $0x0,%edx
  800c17:	f7 da                	neg    %edx
  800c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c26:	e9 bc 00 00 00       	jmp    800ce7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c2b:	83 ec 08             	sub    $0x8,%esp
  800c2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c31:	8d 45 14             	lea    0x14(%ebp),%eax
  800c34:	50                   	push   %eax
  800c35:	e8 84 fc ff ff       	call   8008be <getuint>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c43:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4a:	e9 98 00 00 00       	jmp    800ce7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 58                	push   $0x58
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6f:	83 ec 08             	sub    $0x8,%esp
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	6a 58                	push   $0x58
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	ff d0                	call   *%eax
  800c7c:	83 c4 10             	add    $0x10,%esp
			break;
  800c7f:	e9 ce 00 00 00       	jmp    800d52 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 30                	push   $0x30
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 78                	push   $0x78
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca7:	83 c0 04             	add    $0x4,%eax
  800caa:	89 45 14             	mov    %eax,0x14(%ebp)
  800cad:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb0:	83 e8 04             	sub    $0x4,%eax
  800cb3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc6:	eb 1f                	jmp    800ce7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	ff 75 e8             	pushl  -0x18(%ebp)
  800cce:	8d 45 14             	lea    0x14(%ebp),%eax
  800cd1:	50                   	push   %eax
  800cd2:	e8 e7 fb ff ff       	call   8008be <getuint>
  800cd7:	83 c4 10             	add    $0x10,%esp
  800cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ce0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cee:	83 ec 04             	sub    $0x4,%esp
  800cf1:	52                   	push   %edx
  800cf2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cfc:	ff 75 0c             	pushl  0xc(%ebp)
  800cff:	ff 75 08             	pushl  0x8(%ebp)
  800d02:	e8 00 fb ff ff       	call   800807 <printnum>
  800d07:	83 c4 20             	add    $0x20,%esp
			break;
  800d0a:	eb 46                	jmp    800d52 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	53                   	push   %ebx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
			break;
  800d1b:	eb 35                	jmp    800d52 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d1d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d24:	eb 2c                	jmp    800d52 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d26:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d2d:	eb 23                	jmp    800d52 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d2f:	83 ec 08             	sub    $0x8,%esp
  800d32:	ff 75 0c             	pushl  0xc(%ebp)
  800d35:	6a 25                	push   $0x25
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	ff d0                	call   *%eax
  800d3c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d3f:	ff 4d 10             	decl   0x10(%ebp)
  800d42:	eb 03                	jmp    800d47 <vprintfmt+0x3c3>
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	48                   	dec    %eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3c 25                	cmp    $0x25,%al
  800d4f:	75 f3                	jne    800d44 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d51:	90                   	nop
		}
	}
  800d52:	e9 35 fc ff ff       	jmp    80098c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d57:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d65:	8d 45 10             	lea    0x10(%ebp),%eax
  800d68:	83 c0 04             	add    $0x4,%eax
  800d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d71:	ff 75 f4             	pushl  -0xc(%ebp)
  800d74:	50                   	push   %eax
  800d75:	ff 75 0c             	pushl  0xc(%ebp)
  800d78:	ff 75 08             	pushl  0x8(%ebp)
  800d7b:	e8 04 fc ff ff       	call   800984 <vprintfmt>
  800d80:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d83:	90                   	nop
  800d84:	c9                   	leave  
  800d85:	c3                   	ret    

00800d86 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8b 40 08             	mov    0x8(%eax),%eax
  800d8f:	8d 50 01             	lea    0x1(%eax),%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	8b 10                	mov    (%eax),%edx
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	8b 40 04             	mov    0x4(%eax),%eax
  800da3:	39 c2                	cmp    %eax,%edx
  800da5:	73 12                	jae    800db9 <sprintputch+0x33>
		*b->buf++ = ch;
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	8d 48 01             	lea    0x1(%eax),%ecx
  800daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db2:	89 0a                	mov    %ecx,(%edx)
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	88 10                	mov    %dl,(%eax)
}
  800db9:	90                   	nop
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800de1:	74 06                	je     800de9 <vsnprintf+0x2d>
  800de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de7:	7f 07                	jg     800df0 <vsnprintf+0x34>
		return -E_INVAL;
  800de9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dee:	eb 20                	jmp    800e10 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800df0:	ff 75 14             	pushl  0x14(%ebp)
  800df3:	ff 75 10             	pushl  0x10(%ebp)
  800df6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800df9:	50                   	push   %eax
  800dfa:	68 86 0d 80 00       	push   $0x800d86
  800dff:	e8 80 fb ff ff       	call   800984 <vprintfmt>
  800e04:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e0a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e18:	8d 45 10             	lea    0x10(%ebp),%eax
  800e1b:	83 c0 04             	add    $0x4,%eax
  800e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	ff 75 f4             	pushl  -0xc(%ebp)
  800e27:	50                   	push   %eax
  800e28:	ff 75 0c             	pushl  0xc(%ebp)
  800e2b:	ff 75 08             	pushl  0x8(%ebp)
  800e2e:	e8 89 ff ff ff       	call   800dbc <vsnprintf>
  800e33:	83 c4 10             	add    $0x10,%esp
  800e36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4b:	eb 06                	jmp    800e53 <strlen+0x15>
		n++;
  800e4d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e50:	ff 45 08             	incl   0x8(%ebp)
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	84 c0                	test   %al,%al
  800e5a:	75 f1                	jne    800e4d <strlen+0xf>
		n++;
	return n;
  800e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6e:	eb 09                	jmp    800e79 <strnlen+0x18>
		n++;
  800e70:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e73:	ff 45 08             	incl   0x8(%ebp)
  800e76:	ff 4d 0c             	decl   0xc(%ebp)
  800e79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7d:	74 09                	je     800e88 <strnlen+0x27>
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	75 e8                	jne    800e70 <strnlen+0xf>
		n++;
	return n;
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e99:	90                   	nop
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	84 c0                	test   %al,%al
  800eb4:	75 e4                	jne    800e9a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ece:	eb 1f                	jmp    800eef <strncpy+0x34>
		*dst++ = *src;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8d 50 01             	lea    0x1(%eax),%edx
  800ed6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800edc:	8a 12                	mov    (%edx),%dl
  800ede:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	84 c0                	test   %al,%al
  800ee7:	74 03                	je     800eec <strncpy+0x31>
			src++;
  800ee9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eec:	ff 45 fc             	incl   -0x4(%ebp)
  800eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef5:	72 d9                	jb     800ed0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800efa:	c9                   	leave  
  800efb:	c3                   	ret    

00800efc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0c:	74 30                	je     800f3e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0e:	eb 16                	jmp    800f26 <strlcpy+0x2a>
			*dst++ = *src++;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8d 50 01             	lea    0x1(%eax),%edx
  800f16:	89 55 08             	mov    %edx,0x8(%ebp)
  800f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f22:	8a 12                	mov    (%edx),%dl
  800f24:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2d:	74 09                	je     800f38 <strlcpy+0x3c>
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	84 c0                	test   %al,%al
  800f36:	75 d8                	jne    800f10 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f44:	29 c2                	sub    %eax,%edx
  800f46:	89 d0                	mov    %edx,%eax
}
  800f48:	c9                   	leave  
  800f49:	c3                   	ret    

00800f4a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f4d:	eb 06                	jmp    800f55 <strcmp+0xb>
		p++, q++;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	8a 00                	mov    (%eax),%al
  800f5a:	84 c0                	test   %al,%al
  800f5c:	74 0e                	je     800f6c <strcmp+0x22>
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 10                	mov    (%eax),%dl
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	38 c2                	cmp    %al,%dl
  800f6a:	74 e3                	je     800f4f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	0f b6 d0             	movzbl %al,%edx
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	0f b6 c0             	movzbl %al,%eax
  800f7c:	29 c2                	sub    %eax,%edx
  800f7e:	89 d0                	mov    %edx,%eax
}
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    

00800f82 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f85:	eb 09                	jmp    800f90 <strncmp+0xe>
		n--, p++, q++;
  800f87:	ff 4d 10             	decl   0x10(%ebp)
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	74 17                	je     800fad <strncmp+0x2b>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	84 c0                	test   %al,%al
  800f9d:	74 0e                	je     800fad <strncmp+0x2b>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 10                	mov    (%eax),%dl
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	38 c2                	cmp    %al,%dl
  800fab:	74 da                	je     800f87 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb1:	75 07                	jne    800fba <strncmp+0x38>
		return 0;
  800fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb8:	eb 14                	jmp    800fce <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f b6 d0             	movzbl %al,%edx
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	0f b6 c0             	movzbl %al,%eax
  800fca:	29 c2                	sub    %eax,%edx
  800fcc:	89 d0                	mov    %edx,%eax
}
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 04             	sub    $0x4,%esp
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fdc:	eb 12                	jmp    800ff0 <strchr+0x20>
		if (*s == c)
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe6:	75 05                	jne    800fed <strchr+0x1d>
			return (char *) s;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	eb 11                	jmp    800ffe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	84 c0                	test   %al,%al
  800ff7:	75 e5                	jne    800fde <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100c:	eb 0d                	jmp    80101b <strfind+0x1b>
		if (*s == c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801016:	74 0e                	je     801026 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801018:	ff 45 08             	incl   0x8(%ebp)
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	84 c0                	test   %al,%al
  801022:	75 ea                	jne    80100e <strfind+0xe>
  801024:	eb 01                	jmp    801027 <strfind+0x27>
		if (*s == c)
			break;
  801026:	90                   	nop
	return (char *) s;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801038:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80103c:	76 63                	jbe    8010a1 <memset+0x75>
		uint64 data_block = c;
  80103e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801041:	99                   	cltd   
  801042:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801045:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80104b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104e:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801052:	c1 e0 08             	shl    $0x8,%eax
  801055:	09 45 f0             	or     %eax,-0x10(%ebp)
  801058:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80105b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801061:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801065:	c1 e0 10             	shl    $0x10,%eax
  801068:	09 45 f0             	or     %eax,-0x10(%ebp)
  80106b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80106e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801074:	89 c2                	mov    %eax,%edx
  801076:	b8 00 00 00 00       	mov    $0x0,%eax
  80107b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107e:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801081:	eb 18                	jmp    80109b <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801083:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801086:	8d 41 08             	lea    0x8(%ecx),%eax
  801089:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80108c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801092:	89 01                	mov    %eax,(%ecx)
  801094:	89 51 04             	mov    %edx,0x4(%ecx)
  801097:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80109b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80109f:	77 e2                	ja     801083 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a5:	74 23                	je     8010ca <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ad:	eb 0e                	jmp    8010bd <memset+0x91>
			*p8++ = (uint8)c;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bb:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	75 e5                	jne    8010af <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010e1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e5:	76 24                	jbe    80110b <memcpy+0x3c>
		while(n >= 8){
  8010e7:	eb 1c                	jmp    801105 <memcpy+0x36>
			*d64 = *s64;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8b 50 04             	mov    0x4(%eax),%edx
  8010ef:	8b 00                	mov    (%eax),%eax
  8010f1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010f4:	89 01                	mov    %eax,(%ecx)
  8010f6:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010f9:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010fd:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801101:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801105:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801109:	77 de                	ja     8010e9 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80110b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110f:	74 31                	je     801142 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80111d:	eb 16                	jmp    801135 <memcpy+0x66>
			*d8++ = *s8++;
  80111f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801122:	8d 50 01             	lea    0x1(%eax),%edx
  801125:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80112e:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801131:	8a 12                	mov    (%edx),%dl
  801133:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801135:	8b 45 10             	mov    0x10(%ebp),%eax
  801138:	8d 50 ff             	lea    -0x1(%eax),%edx
  80113b:	89 55 10             	mov    %edx,0x10(%ebp)
  80113e:	85 c0                	test   %eax,%eax
  801140:	75 dd                	jne    80111f <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801142:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80115f:	73 50                	jae    8011b1 <memmove+0x6a>
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 d0                	add    %edx,%eax
  801169:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80116c:	76 43                	jbe    8011b1 <memmove+0x6a>
		s += n;
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801174:	8b 45 10             	mov    0x10(%ebp),%eax
  801177:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80117a:	eb 10                	jmp    80118c <memmove+0x45>
			*--d = *--s;
  80117c:	ff 4d f8             	decl   -0x8(%ebp)
  80117f:	ff 4d fc             	decl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	8a 10                	mov    (%eax),%dl
  801187:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	85 c0                	test   %eax,%eax
  801197:	75 e3                	jne    80117c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801199:	eb 23                	jmp    8011be <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80119b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119e:	8d 50 01             	lea    0x1(%eax),%edx
  8011a1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011aa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011ad:	8a 12                	mov    (%edx),%dl
  8011af:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	75 dd                	jne    80119b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011d5:	eb 2a                	jmp    801201 <memcmp+0x3e>
		if (*s1 != *s2)
  8011d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011da:	8a 10                	mov    (%eax),%dl
  8011dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	38 c2                	cmp    %al,%dl
  8011e3:	74 16                	je     8011fb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 d0             	movzbl %al,%edx
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	0f b6 c0             	movzbl %al,%eax
  8011f5:	29 c2                	sub    %eax,%edx
  8011f7:	89 d0                	mov    %edx,%eax
  8011f9:	eb 18                	jmp    801213 <memcmp+0x50>
		s1++, s2++;
  8011fb:	ff 45 fc             	incl   -0x4(%ebp)
  8011fe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	8d 50 ff             	lea    -0x1(%eax),%edx
  801207:	89 55 10             	mov    %edx,0x10(%ebp)
  80120a:	85 c0                	test   %eax,%eax
  80120c:	75 c9                	jne    8011d7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80120e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80121b:	8b 55 08             	mov    0x8(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801226:	eb 15                	jmp    80123d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 d0             	movzbl %al,%edx
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	0f b6 c0             	movzbl %al,%eax
  801236:	39 c2                	cmp    %eax,%edx
  801238:	74 0d                	je     801247 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80123a:	ff 45 08             	incl   0x8(%ebp)
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801243:	72 e3                	jb     801228 <memfind+0x13>
  801245:	eb 01                	jmp    801248 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801247:	90                   	nop
	return (void *) s;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801253:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801261:	eb 03                	jmp    801266 <strtol+0x19>
		s++;
  801263:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	3c 20                	cmp    $0x20,%al
  80126d:	74 f4                	je     801263 <strtol+0x16>
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	8a 00                	mov    (%eax),%al
  801274:	3c 09                	cmp    $0x9,%al
  801276:	74 eb                	je     801263 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	3c 2b                	cmp    $0x2b,%al
  80127f:	75 05                	jne    801286 <strtol+0x39>
		s++;
  801281:	ff 45 08             	incl   0x8(%ebp)
  801284:	eb 13                	jmp    801299 <strtol+0x4c>
	else if (*s == '-')
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	3c 2d                	cmp    $0x2d,%al
  80128d:	75 0a                	jne    801299 <strtol+0x4c>
		s++, neg = 1;
  80128f:	ff 45 08             	incl   0x8(%ebp)
  801292:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801299:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80129d:	74 06                	je     8012a5 <strtol+0x58>
  80129f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012a3:	75 20                	jne    8012c5 <strtol+0x78>
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	3c 30                	cmp    $0x30,%al
  8012ac:	75 17                	jne    8012c5 <strtol+0x78>
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	40                   	inc    %eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	3c 78                	cmp    $0x78,%al
  8012b6:	75 0d                	jne    8012c5 <strtol+0x78>
		s += 2, base = 16;
  8012b8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012bc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012c3:	eb 28                	jmp    8012ed <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c9:	75 15                	jne    8012e0 <strtol+0x93>
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 30                	cmp    $0x30,%al
  8012d2:	75 0c                	jne    8012e0 <strtol+0x93>
		s++, base = 8;
  8012d4:	ff 45 08             	incl   0x8(%ebp)
  8012d7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012de:	eb 0d                	jmp    8012ed <strtol+0xa0>
	else if (base == 0)
  8012e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012e4:	75 07                	jne    8012ed <strtol+0xa0>
		base = 10;
  8012e6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	3c 2f                	cmp    $0x2f,%al
  8012f4:	7e 19                	jle    80130f <strtol+0xc2>
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	8a 00                	mov    (%eax),%al
  8012fb:	3c 39                	cmp    $0x39,%al
  8012fd:	7f 10                	jg     80130f <strtol+0xc2>
			dig = *s - '0';
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	0f be c0             	movsbl %al,%eax
  801307:	83 e8 30             	sub    $0x30,%eax
  80130a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130d:	eb 42                	jmp    801351 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	3c 60                	cmp    $0x60,%al
  801316:	7e 19                	jle    801331 <strtol+0xe4>
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	3c 7a                	cmp    $0x7a,%al
  80131f:	7f 10                	jg     801331 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	0f be c0             	movsbl %al,%eax
  801329:	83 e8 57             	sub    $0x57,%eax
  80132c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80132f:	eb 20                	jmp    801351 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	3c 40                	cmp    $0x40,%al
  801338:	7e 39                	jle    801373 <strtol+0x126>
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	3c 5a                	cmp    $0x5a,%al
  801341:	7f 30                	jg     801373 <strtol+0x126>
			dig = *s - 'A' + 10;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	0f be c0             	movsbl %al,%eax
  80134b:	83 e8 37             	sub    $0x37,%eax
  80134e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801354:	3b 45 10             	cmp    0x10(%ebp),%eax
  801357:	7d 19                	jge    801372 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801359:	ff 45 08             	incl   0x8(%ebp)
  80135c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801363:	89 c2                	mov    %eax,%edx
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	01 d0                	add    %edx,%eax
  80136a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80136d:	e9 7b ff ff ff       	jmp    8012ed <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801372:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801373:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801377:	74 08                	je     801381 <strtol+0x134>
		*endptr = (char *) s;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137c:	8b 55 08             	mov    0x8(%ebp),%edx
  80137f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801381:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801385:	74 07                	je     80138e <strtol+0x141>
  801387:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138a:	f7 d8                	neg    %eax
  80138c:	eb 03                	jmp    801391 <strtol+0x144>
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <ltostr>:

void
ltostr(long value, char *str)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801399:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013a0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013ab:	79 13                	jns    8013c0 <ltostr+0x2d>
	{
		neg = 1;
  8013ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013ba:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013bd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c8:	99                   	cltd   
  8013c9:	f7 f9                	idiv   %ecx
  8013cb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 d0                	add    %edx,%eax
  8013de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013e1:	83 c2 30             	add    $0x30,%edx
  8013e4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ee:	f7 e9                	imul   %ecx
  8013f0:	c1 fa 02             	sar    $0x2,%edx
  8013f3:	89 c8                	mov    %ecx,%eax
  8013f5:	c1 f8 1f             	sar    $0x1f,%eax
  8013f8:	29 c2                	sub    %eax,%edx
  8013fa:	89 d0                	mov    %edx,%eax
  8013fc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801403:	75 bb                	jne    8013c0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80140c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140f:	48                   	dec    %eax
  801410:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801413:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801417:	74 3d                	je     801456 <ltostr+0xc3>
		start = 1 ;
  801419:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801420:	eb 34                	jmp    801456 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 d0                	add    %edx,%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80142f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801446:	8b 45 0c             	mov    0xc(%ebp),%eax
  801449:	01 c2                	add    %eax,%edx
  80144b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80144e:	88 02                	mov    %al,(%edx)
		start++ ;
  801450:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801453:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801459:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80145c:	7c c4                	jl     801422 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80145e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801461:	8b 45 0c             	mov    0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801469:	90                   	nop
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801472:	ff 75 08             	pushl  0x8(%ebp)
  801475:	e8 c4 f9 ff ff       	call   800e3e <strlen>
  80147a:	83 c4 04             	add    $0x4,%esp
  80147d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801480:	ff 75 0c             	pushl  0xc(%ebp)
  801483:	e8 b6 f9 ff ff       	call   800e3e <strlen>
  801488:	83 c4 04             	add    $0x4,%esp
  80148b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80148e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80149c:	eb 17                	jmp    8014b5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80149e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a4:	01 c2                	add    %eax,%edx
  8014a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	01 c8                	add    %ecx,%eax
  8014ae:	8a 00                	mov    (%eax),%al
  8014b0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014b2:	ff 45 fc             	incl   -0x4(%ebp)
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014bb:	7c e1                	jl     80149e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014cb:	eb 1f                	jmp    8014ec <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d0:	8d 50 01             	lea    0x1(%eax),%edx
  8014d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d6:	89 c2                	mov    %eax,%edx
  8014d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014db:	01 c2                	add    %eax,%edx
  8014dd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	01 c8                	add    %ecx,%eax
  8014e5:	8a 00                	mov    (%eax),%al
  8014e7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014e9:	ff 45 f8             	incl   -0x8(%ebp)
  8014ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014f2:	7c d9                	jl     8014cd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fa:	01 d0                	add    %edx,%eax
  8014fc:	c6 00 00             	movb   $0x0,(%eax)
}
  8014ff:	90                   	nop
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801505:	8b 45 14             	mov    0x14(%ebp),%eax
  801508:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80150e:	8b 45 14             	mov    0x14(%ebp),%eax
  801511:	8b 00                	mov    (%eax),%eax
  801513:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801525:	eb 0c                	jmp    801533 <strsplit+0x31>
			*string++ = 0;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8d 50 01             	lea    0x1(%eax),%edx
  80152d:	89 55 08             	mov    %edx,0x8(%ebp)
  801530:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	84 c0                	test   %al,%al
  80153a:	74 18                	je     801554 <strsplit+0x52>
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f be c0             	movsbl %al,%eax
  801544:	50                   	push   %eax
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	e8 83 fa ff ff       	call   800fd0 <strchr>
  80154d:	83 c4 08             	add    $0x8,%esp
  801550:	85 c0                	test   %eax,%eax
  801552:	75 d3                	jne    801527 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 5a                	je     8015b7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80155d:	8b 45 14             	mov    0x14(%ebp),%eax
  801560:	8b 00                	mov    (%eax),%eax
  801562:	83 f8 0f             	cmp    $0xf,%eax
  801565:	75 07                	jne    80156e <strsplit+0x6c>
		{
			return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	eb 66                	jmp    8015d4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80156e:	8b 45 14             	mov    0x14(%ebp),%eax
  801571:	8b 00                	mov    (%eax),%eax
  801573:	8d 48 01             	lea    0x1(%eax),%ecx
  801576:	8b 55 14             	mov    0x14(%ebp),%edx
  801579:	89 0a                	mov    %ecx,(%edx)
  80157b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801582:	8b 45 10             	mov    0x10(%ebp),%eax
  801585:	01 c2                	add    %eax,%edx
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80158c:	eb 03                	jmp    801591 <strsplit+0x8f>
			string++;
  80158e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	84 c0                	test   %al,%al
  801598:	74 8b                	je     801525 <strsplit+0x23>
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	8a 00                	mov    (%eax),%al
  80159f:	0f be c0             	movsbl %al,%eax
  8015a2:	50                   	push   %eax
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	e8 25 fa ff ff       	call   800fd0 <strchr>
  8015ab:	83 c4 08             	add    $0x8,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	74 dc                	je     80158e <strsplit+0x8c>
			string++;
	}
  8015b2:	e9 6e ff ff ff       	jmp    801525 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015b7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	8b 00                	mov    (%eax),%eax
  8015bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e9:	eb 4a                	jmp    801635 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 c2                	add    %eax,%edx
  8015f3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f9:	01 c8                	add    %ecx,%eax
  8015fb:	8a 00                	mov    (%eax),%al
  8015fd:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	01 d0                	add    %edx,%eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 40                	cmp    $0x40,%al
  80160b:	7e 25                	jle    801632 <str2lower+0x5c>
  80160d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	8a 00                	mov    (%eax),%al
  801617:	3c 5a                	cmp    $0x5a,%al
  801619:	7f 17                	jg     801632 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80161b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	01 d0                	add    %edx,%eax
  801623:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801626:	8b 55 08             	mov    0x8(%ebp),%edx
  801629:	01 ca                	add    %ecx,%edx
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	83 c2 20             	add    $0x20,%edx
  801630:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801632:	ff 45 fc             	incl   -0x4(%ebp)
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	e8 01 f8 ff ff       	call   800e3e <strlen>
  80163d:	83 c4 04             	add    $0x4,%esp
  801640:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801643:	7f a6                	jg     8015eb <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801650:	a1 08 40 80 00       	mov    0x804008,%eax
  801655:	85 c0                	test   %eax,%eax
  801657:	74 42                	je     80169b <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801659:	83 ec 08             	sub    $0x8,%esp
  80165c:	68 00 00 00 82       	push   $0x82000000
  801661:	68 00 00 00 80       	push   $0x80000000
  801666:	e8 00 08 00 00       	call   801e6b <initialize_dynamic_allocator>
  80166b:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80166e:	e8 e7 05 00 00       	call   801c5a <sys_get_uheap_strategy>
  801673:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801678:	a1 40 40 80 00       	mov    0x804040,%eax
  80167d:	05 00 10 00 00       	add    $0x1000,%eax
  801682:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801687:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80168c:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801691:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801698:	00 00 00 
	}
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	68 06 04 00 00       	push   $0x406
  8016ba:	50                   	push   %eax
  8016bb:	e8 e4 01 00 00       	call   8018a4 <__sys_allocate_page>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ca:	79 14                	jns    8016e0 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 c8 33 80 00       	push   $0x8033c8
  8016d4:	6a 1f                	push   $0x1f
  8016d6:	68 04 34 80 00       	push   $0x803404
  8016db:	e8 b7 ed ff ff       	call   800497 <_panic>
	return 0;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016fb:	83 ec 0c             	sub    $0xc,%esp
  8016fe:	50                   	push   %eax
  8016ff:	e8 e7 01 00 00       	call   8018eb <__sys_unmap_frame>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80170a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170e:	79 14                	jns    801724 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	68 10 34 80 00       	push   $0x803410
  801718:	6a 2a                	push   $0x2a
  80171a:	68 04 34 80 00       	push   $0x803404
  80171f:	e8 73 ed ff ff       	call   800497 <_panic>
}
  801724:	90                   	nop
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80172d:	e8 18 ff ff ff       	call   80164a <uheap_init>
	if (size == 0) return NULL ;
  801732:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801736:	75 07                	jne    80173f <malloc+0x18>
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
  80173d:	eb 14                	jmp    801753 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 50 34 80 00       	push   $0x803450
  801747:	6a 3e                	push   $0x3e
  801749:	68 04 34 80 00       	push   $0x803404
  80174e:	e8 44 ed ff ff       	call   800497 <_panic>
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 78 34 80 00       	push   $0x803478
  801763:	6a 49                	push   $0x49
  801765:	68 04 34 80 00       	push   $0x803404
  80176a:	e8 28 ed ff ff       	call   800497 <_panic>

0080176f <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 18             	sub    $0x18,%esp
  801775:	8b 45 10             	mov    0x10(%ebp),%eax
  801778:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80177b:	e8 ca fe ff ff       	call   80164a <uheap_init>
	if (size == 0) return NULL ;
  801780:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801784:	75 07                	jne    80178d <smalloc+0x1e>
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	eb 14                	jmp    8017a1 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 9c 34 80 00       	push   $0x80349c
  801795:	6a 5a                	push   $0x5a
  801797:	68 04 34 80 00       	push   $0x803404
  80179c:	e8 f6 ec ff ff       	call   800497 <_panic>
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017a9:	e8 9c fe ff ff       	call   80164a <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  8017ae:	83 ec 04             	sub    $0x4,%esp
  8017b1:	68 c4 34 80 00       	push   $0x8034c4
  8017b6:	6a 6a                	push   $0x6a
  8017b8:	68 04 34 80 00       	push   $0x803404
  8017bd:	e8 d5 ec ff ff       	call   800497 <_panic>

008017c2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017c8:	e8 7d fe ff ff       	call   80164a <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 e8 34 80 00       	push   $0x8034e8
  8017d5:	68 88 00 00 00       	push   $0x88
  8017da:	68 04 34 80 00       	push   $0x803404
  8017df:	e8 b3 ec ff ff       	call   800497 <_panic>

008017e4 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	68 10 35 80 00       	push   $0x803510
  8017f2:	68 9b 00 00 00       	push   $0x9b
  8017f7:	68 04 34 80 00       	push   $0x803404
  8017fc:	e8 96 ec ff ff       	call   800497 <_panic>

00801801 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	57                   	push   %edi
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801813:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801816:	8b 7d 18             	mov    0x18(%ebp),%edi
  801819:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181c:	cd 30                	int    $0x30
  80181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5f                   	pop    %edi
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	8b 45 10             	mov    0x10(%ebp),%eax
  801835:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801838:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80183b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	51                   	push   %ecx
  801845:	52                   	push   %edx
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	6a 00                	push   $0x0
  80184c:	e8 b0 ff ff ff       	call   801801 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_cgetc>:

int
sys_cgetc(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 02                	push   $0x2
  801866:	e8 96 ff ff ff       	call   801801 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 03                	push   $0x3
  80187f:	e8 7d ff ff ff       	call   801801 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 04                	push   $0x4
  801899:	e8 63 ff ff ff       	call   801801 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 08                	push   $0x8
  8018b7:	e8 45 ff ff ff       	call   801801 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	51                   	push   %ecx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	6a 09                	push   $0x9
  8018dc:	e8 20 ff ff ff       	call   801801 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    

008018eb <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 08             	pushl  0x8(%ebp)
  8018f9:	6a 0a                	push   $0xa
  8018fb:	e8 01 ff ff ff       	call   801801 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 0b                	push   $0xb
  801916:	e8 e6 fe ff ff       	call   801801 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 0c                	push   $0xc
  80192f:	e8 cd fe ff ff       	call   801801 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 0d                	push   $0xd
  801948:	e8 b4 fe ff ff       	call   801801 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0e                	push   $0xe
  801961:	e8 9b fe ff ff       	call   801801 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0f                	push   $0xf
  80197a:	e8 82 fe ff ff       	call   801801 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	6a 10                	push   $0x10
  801994:	e8 68 fe ff ff       	call   801801 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 11                	push   $0x11
  8019ad:	e8 4f fe ff ff       	call   801801 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	50                   	push   %eax
  8019d1:	6a 01                	push   $0x1
  8019d3:	e8 29 fe ff ff       	call   801801 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 14                	push   $0x14
  8019ed:	e8 0f fe ff ff       	call   801801 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801a01:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a04:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a07:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	6a 00                	push   $0x0
  801a10:	51                   	push   %ecx
  801a11:	52                   	push   %edx
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	6a 15                	push   $0x15
  801a18:	e8 e4 fd ff ff       	call   801801 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	52                   	push   %edx
  801a32:	50                   	push   %eax
  801a33:	6a 16                	push   $0x16
  801a35:	e8 c7 fd ff ff       	call   801801 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 17                	push   $0x17
  801a54:	e8 a8 fd ff ff       	call   801801 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	6a 18                	push   $0x18
  801a71:	e8 8b fd ff ff       	call   801801 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 14             	pushl  0x14(%ebp)
  801a86:	ff 75 10             	pushl  0x10(%ebp)
  801a89:	ff 75 0c             	pushl  0xc(%ebp)
  801a8c:	50                   	push   %eax
  801a8d:	6a 19                	push   $0x19
  801a8f:	e8 6d fd ff ff       	call   801801 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 1a                	push   $0x1a
  801aaa:	e8 52 fd ff ff       	call   801801 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 1b                	push   $0x1b
  801ac6:	e8 36 fd ff ff       	call   801801 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 05                	push   $0x5
  801adf:	e8 1d fd ff ff       	call   801801 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 06                	push   $0x6
  801af8:	e8 04 fd ff ff       	call   801801 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 07                	push   $0x7
  801b11:	e8 eb fc ff ff       	call   801801 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_exit_env>:


void sys_exit_env(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 1c                	push   $0x1c
  801b2a:	e8 d2 fc ff ff       	call   801801 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	90                   	nop
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3e:	8d 50 04             	lea    0x4(%eax),%edx
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 1d                	push   $0x1d
  801b4e:	e8 ae fc ff ff       	call   801801 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return result;
  801b56:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5f:	89 01                	mov    %eax,(%ecx)
  801b61:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	c9                   	leave  
  801b68:	c2 04 00             	ret    $0x4

00801b6b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 13                	push   $0x13
  801b7d:	e8 7f fc ff ff       	call   801801 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 1e                	push   $0x1e
  801b97:	e8 65 fc ff ff       	call   801801 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bad:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	50                   	push   %eax
  801bba:	6a 1f                	push   $0x1f
  801bbc:	e8 40 fc ff ff       	call   801801 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <rsttst>:
void rsttst()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 21                	push   $0x21
  801bd6:	e8 26 fc ff ff       	call   801801 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bed:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 20                	push   $0x20
  801c01:	e8 fb fb ff ff       	call   801801 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <chktst>:
void chktst(uint32 n)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 08             	pushl  0x8(%ebp)
  801c1a:	6a 22                	push   $0x22
  801c1c:	e8 e0 fb ff ff       	call   801801 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
	return ;
  801c24:	90                   	nop
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <inctst>:

void inctst()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 23                	push   $0x23
  801c36:	e8 c6 fb ff ff       	call   801801 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <gettst>:
uint32 gettst()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 24                	push   $0x24
  801c50:	e8 ac fb ff ff       	call   801801 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 25                	push   $0x25
  801c69:	e8 93 fb ff ff       	call   801801 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
  801c71:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c76:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 26                	push   $0x26
  801c95:	e8 67 fb ff ff       	call   801801 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	6a 00                	push   $0x0
  801cb2:	53                   	push   %ebx
  801cb3:	51                   	push   %ecx
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 27                	push   $0x27
  801cb8:	e8 44 fb ff ff       	call   801801 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 28                	push   $0x28
  801cd8:	e8 24 fb ff ff       	call   801801 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ce5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	51                   	push   %ecx
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 29                	push   $0x29
  801cf8:	e8 04 fb ff ff       	call   801801 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 10             	pushl  0x10(%ebp)
  801d0c:	ff 75 0c             	pushl  0xc(%ebp)
  801d0f:	ff 75 08             	pushl  0x8(%ebp)
  801d12:	6a 12                	push   $0x12
  801d14:	e8 e8 fa ff ff       	call   801801 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1c:	90                   	nop
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 2a                	push   $0x2a
  801d32:	e8 ca fa ff ff       	call   801801 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 2b                	push   $0x2b
  801d4c:	e8 b0 fa ff ff       	call   801801 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 0c             	pushl  0xc(%ebp)
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 2d                	push   $0x2d
  801d67:	e8 95 fa ff ff       	call   801801 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	ff 75 0c             	pushl  0xc(%ebp)
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	6a 2c                	push   $0x2c
  801d83:	e8 79 fa ff ff       	call   801801 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	68 34 35 80 00       	push   $0x803534
  801d9c:	68 25 01 00 00       	push   $0x125
  801da1:	68 67 35 80 00       	push   $0x803567
  801da6:	e8 ec e6 ff ff       	call   800497 <_panic>

00801dab <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801db1:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801db8:	72 09                	jb     801dc3 <to_page_va+0x18>
  801dba:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801dc1:	72 14                	jb     801dd7 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 78 35 80 00       	push   $0x803578
  801dcb:	6a 15                	push   $0x15
  801dcd:	68 a3 35 80 00       	push   $0x8035a3
  801dd2:	e8 c0 e6 ff ff       	call   800497 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	ba 60 40 80 00       	mov    $0x804060,%edx
  801ddf:	29 d0                	sub    %edx,%eax
  801de1:	c1 f8 02             	sar    $0x2,%eax
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	89 d0                	mov    %edx,%eax
  801de8:	c1 e0 02             	shl    $0x2,%eax
  801deb:	01 d0                	add    %edx,%eax
  801ded:	c1 e0 02             	shl    $0x2,%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	c1 e0 02             	shl    $0x2,%eax
  801df5:	01 d0                	add    %edx,%eax
  801df7:	89 c1                	mov    %eax,%ecx
  801df9:	c1 e1 08             	shl    $0x8,%ecx
  801dfc:	01 c8                	add    %ecx,%eax
  801dfe:	89 c1                	mov    %eax,%ecx
  801e00:	c1 e1 10             	shl    $0x10,%ecx
  801e03:	01 c8                	add    %ecx,%eax
  801e05:	01 c0                	add    %eax,%eax
  801e07:	01 d0                	add    %edx,%eax
  801e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0f:	c1 e0 0c             	shl    $0xc,%eax
  801e12:	89 c2                	mov    %eax,%edx
  801e14:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e19:	01 d0                	add    %edx,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e23:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e28:	8b 55 08             	mov    0x8(%ebp),%edx
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	89 d0                	mov    %edx,%eax
  801e2f:	c1 e8 0c             	shr    $0xc,%eax
  801e32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e39:	78 09                	js     801e44 <to_page_info+0x27>
  801e3b:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e42:	7e 14                	jle    801e58 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	68 bc 35 80 00       	push   $0x8035bc
  801e4c:	6a 22                	push   $0x22
  801e4e:	68 a3 35 80 00       	push   $0x8035a3
  801e53:	e8 3f e6 ff ff       	call   800497 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	01 c0                	add    %eax,%eax
  801e5f:	01 d0                	add    %edx,%eax
  801e61:	c1 e0 02             	shl    $0x2,%eax
  801e64:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	05 00 00 00 02       	add    $0x2000000,%eax
  801e79:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e7c:	73 16                	jae    801e94 <initialize_dynamic_allocator+0x29>
  801e7e:	68 e0 35 80 00       	push   $0x8035e0
  801e83:	68 06 36 80 00       	push   $0x803606
  801e88:	6a 34                	push   $0x34
  801e8a:	68 a3 35 80 00       	push   $0x8035a3
  801e8f:	e8 03 e6 ff ff       	call   800497 <_panic>
		is_initialized = 1;
  801e94:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e9b:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801eae:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801eb5:	00 00 00 
  801eb8:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801ebf:	00 00 00 
  801ec2:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ec9:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	2b 45 08             	sub    0x8(%ebp),%eax
  801ed2:	c1 e8 0c             	shr    $0xc,%eax
  801ed5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801ed8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801edf:	e9 c8 00 00 00       	jmp    801fac <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	01 c0                	add    %eax,%eax
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	c1 e0 02             	shl    $0x2,%eax
  801ef0:	05 68 40 80 00       	add    $0x804068,%eax
  801ef5:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efd:	89 d0                	mov    %edx,%eax
  801eff:	01 c0                	add    %eax,%eax
  801f01:	01 d0                	add    %edx,%eax
  801f03:	c1 e0 02             	shl    $0x2,%eax
  801f06:	05 6a 40 80 00       	add    $0x80406a,%eax
  801f0b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801f10:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f16:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f19:	89 c8                	mov    %ecx,%eax
  801f1b:	01 c0                	add    %eax,%eax
  801f1d:	01 c8                	add    %ecx,%eax
  801f1f:	c1 e0 02             	shl    $0x2,%eax
  801f22:	05 64 40 80 00       	add    $0x804064,%eax
  801f27:	89 10                	mov    %edx,(%eax)
  801f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2c:	89 d0                	mov    %edx,%eax
  801f2e:	01 c0                	add    %eax,%eax
  801f30:	01 d0                	add    %edx,%eax
  801f32:	c1 e0 02             	shl    $0x2,%eax
  801f35:	05 64 40 80 00       	add    $0x804064,%eax
  801f3a:	8b 00                	mov    (%eax),%eax
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	74 1b                	je     801f5b <initialize_dynamic_allocator+0xf0>
  801f40:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f46:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f49:	89 c8                	mov    %ecx,%eax
  801f4b:	01 c0                	add    %eax,%eax
  801f4d:	01 c8                	add    %ecx,%eax
  801f4f:	c1 e0 02             	shl    $0x2,%eax
  801f52:	05 60 40 80 00       	add    $0x804060,%eax
  801f57:	89 02                	mov    %eax,(%edx)
  801f59:	eb 16                	jmp    801f71 <initialize_dynamic_allocator+0x106>
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	89 d0                	mov    %edx,%eax
  801f60:	01 c0                	add    %eax,%eax
  801f62:	01 d0                	add    %edx,%eax
  801f64:	c1 e0 02             	shl    $0x2,%eax
  801f67:	05 60 40 80 00       	add    $0x804060,%eax
  801f6c:	a3 48 40 80 00       	mov    %eax,0x804048
  801f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f74:	89 d0                	mov    %edx,%eax
  801f76:	01 c0                	add    %eax,%eax
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	c1 e0 02             	shl    $0x2,%eax
  801f7d:	05 60 40 80 00       	add    $0x804060,%eax
  801f82:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8a:	89 d0                	mov    %edx,%eax
  801f8c:	01 c0                	add    %eax,%eax
  801f8e:	01 d0                	add    %edx,%eax
  801f90:	c1 e0 02             	shl    $0x2,%eax
  801f93:	05 60 40 80 00       	add    $0x804060,%eax
  801f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f9e:	a1 54 40 80 00       	mov    0x804054,%eax
  801fa3:	40                   	inc    %eax
  801fa4:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801fa9:	ff 45 f4             	incl   -0xc(%ebp)
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fb2:	0f 8c 2c ff ff ff    	jl     801ee4 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fb8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801fbf:	eb 36                	jmp    801ff7 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	c1 e0 04             	shl    $0x4,%eax
  801fc7:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd5:	c1 e0 04             	shl    $0x4,%eax
  801fd8:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe6:	c1 e0 04             	shl    $0x4,%eax
  801fe9:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801ff4:	ff 45 f0             	incl   -0x10(%ebp)
  801ff7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801ffb:	7e c4                	jle    801fc1 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801ffd:	90                   	nop
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	50                   	push   %eax
  80200d:	e8 0b fe ff ff       	call   801e1d <to_page_info>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	e8 77 fd ff ff       	call   801dab <to_page_va>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  80203a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80203f:	ba 00 00 00 00       	mov    $0x0,%edx
  802044:	f7 75 08             	divl   0x8(%ebp)
  802047:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  80204a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	50                   	push   %eax
  802051:	e8 48 f6 ff ff       	call   80169e <get_page>
  802056:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	8b 55 0c             	mov    0xc(%ebp),%edx
  802069:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80206d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802074:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80207b:	eb 19                	jmp    802096 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80207d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802080:	ba 01 00 00 00       	mov    $0x1,%edx
  802085:	88 c1                	mov    %al,%cl
  802087:	d3 e2                	shl    %cl,%edx
  802089:	89 d0                	mov    %edx,%eax
  80208b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208e:	74 0e                	je     80209e <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802090:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802093:	ff 45 f0             	incl   -0x10(%ebp)
  802096:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80209a:	7e e1                	jle    80207d <split_page_to_blocks+0x5a>
  80209c:	eb 01                	jmp    80209f <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80209e:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80209f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8020a6:	e9 a7 00 00 00       	jmp    802152 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  8020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ae:	0f af 45 08          	imul   0x8(%ebp),%eax
  8020b2:	89 c2                	mov    %eax,%edx
  8020b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  8020bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020c0:	75 14                	jne    8020d6 <split_page_to_blocks+0xb3>
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	68 1c 36 80 00       	push   $0x80361c
  8020ca:	6a 7c                	push   $0x7c
  8020cc:	68 a3 35 80 00       	push   $0x8035a3
  8020d1:	e8 c1 e3 ff ff       	call   800497 <_panic>
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	c1 e0 04             	shl    $0x4,%eax
  8020dc:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020e1:	8b 10                	mov    (%eax),%edx
  8020e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e6:	89 50 04             	mov    %edx,0x4(%eax)
  8020e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020ec:	8b 40 04             	mov    0x4(%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 14                	je     802107 <split_page_to_blocks+0xe4>
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	c1 e0 04             	shl    $0x4,%eax
  8020f9:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802103:	89 10                	mov    %edx,(%eax)
  802105:	eb 11                	jmp    802118 <split_page_to_blocks+0xf5>
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	c1 e0 04             	shl    $0x4,%eax
  80210d:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802116:	89 02                	mov    %eax,(%edx)
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	c1 e0 04             	shl    $0x4,%eax
  80211e:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802127:	89 02                	mov    %eax,(%edx)
  802129:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80212c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	c1 e0 04             	shl    $0x4,%eax
  802138:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	8d 50 01             	lea    0x1(%eax),%edx
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	c1 e0 04             	shl    $0x4,%eax
  802148:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80214d:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80214f:	ff 45 ec             	incl   -0x14(%ebp)
  802152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802155:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802158:	0f 82 4d ff ff ff    	jb     8020ab <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80215e:	90                   	nop
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802167:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80216e:	76 19                	jbe    802189 <alloc_block+0x28>
  802170:	68 40 36 80 00       	push   $0x803640
  802175:	68 06 36 80 00       	push   $0x803606
  80217a:	68 8a 00 00 00       	push   $0x8a
  80217f:	68 a3 35 80 00       	push   $0x8035a3
  802184:	e8 0e e3 ff ff       	call   800497 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802190:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802197:	eb 19                	jmp    8021b2 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	ba 01 00 00 00       	mov    $0x1,%edx
  8021a1:	88 c1                	mov    %al,%cl
  8021a3:	d3 e2                	shl    %cl,%edx
  8021a5:	89 d0                	mov    %edx,%eax
  8021a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021aa:	73 0e                	jae    8021ba <alloc_block+0x59>
		idx++;
  8021ac:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8021af:	ff 45 f0             	incl   -0x10(%ebp)
  8021b2:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8021b6:	7e e1                	jle    802199 <alloc_block+0x38>
  8021b8:	eb 01                	jmp    8021bb <alloc_block+0x5a>
		if((1 << i) >= size) break;
  8021ba:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	c1 e0 04             	shl    $0x4,%eax
  8021c1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	0f 84 df 00 00 00    	je     8022af <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	c1 e0 04             	shl    $0x4,%eax
  8021d6:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e4:	75 17                	jne    8021fd <alloc_block+0x9c>
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 61 36 80 00       	push   $0x803661
  8021ee:	68 9e 00 00 00       	push   $0x9e
  8021f3:	68 a3 35 80 00       	push   $0x8035a3
  8021f8:	e8 9a e2 ff ff       	call   800497 <_panic>
  8021fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	74 10                	je     802216 <alloc_block+0xb5>
  802206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80220e:	8b 52 04             	mov    0x4(%edx),%edx
  802211:	89 50 04             	mov    %edx,0x4(%eax)
  802214:	eb 14                	jmp    80222a <alloc_block+0xc9>
  802216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802219:	8b 40 04             	mov    0x4(%eax),%eax
  80221c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221f:	c1 e2 04             	shl    $0x4,%edx
  802222:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802228:	89 02                	mov    %eax,(%edx)
  80222a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222d:	8b 40 04             	mov    0x4(%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	74 0f                	je     802243 <alloc_block+0xe2>
  802234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80223d:	8b 12                	mov    (%edx),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	eb 13                	jmp    802256 <alloc_block+0xf5>
  802243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	c1 e2 04             	shl    $0x4,%edx
  80224e:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802254:	89 02                	mov    %eax,(%edx)
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	c1 e0 04             	shl    $0x4,%eax
  80226f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802274:	8b 00                	mov    (%eax),%eax
  802276:	8d 50 ff             	lea    -0x1(%eax),%edx
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	c1 e0 04             	shl    $0x4,%eax
  80227f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802284:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	50                   	push   %eax
  80228d:	e8 8b fb ff ff       	call   801e1d <to_page_info>
  802292:	83 c4 10             	add    $0x10,%esp
  802295:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80229b:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80229f:	48                   	dec    %eax
  8022a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022a3:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  8022a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022aa:	e9 bc 02 00 00       	jmp    80256b <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  8022af:	a1 54 40 80 00       	mov    0x804054,%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	0f 84 7d 02 00 00    	je     802539 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  8022bc:	a1 48 40 80 00       	mov    0x804048,%eax
  8022c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022c8:	75 17                	jne    8022e1 <alloc_block+0x180>
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	68 61 36 80 00       	push   $0x803661
  8022d2:	68 a9 00 00 00       	push   $0xa9
  8022d7:	68 a3 35 80 00       	push   $0x8035a3
  8022dc:	e8 b6 e1 ff ff       	call   800497 <_panic>
  8022e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 10                	je     8022fa <alloc_block+0x199>
  8022ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f2:	8b 52 04             	mov    0x4(%edx),%edx
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	eb 0b                	jmp    802305 <alloc_block+0x1a4>
  8022fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fd:	8b 40 04             	mov    0x4(%eax),%eax
  802300:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802308:	8b 40 04             	mov    0x4(%eax),%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 0f                	je     80231e <alloc_block+0x1bd>
  80230f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802318:	8b 12                	mov    (%edx),%edx
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	eb 0a                	jmp    802328 <alloc_block+0x1c7>
  80231e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	a3 48 40 80 00       	mov    %eax,0x804048
  802328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802334:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80233b:	a1 54 40 80 00       	mov    0x804054,%eax
  802340:	48                   	dec    %eax
  802341:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	83 c0 03             	add    $0x3,%eax
  80234c:	ba 01 00 00 00       	mov    $0x1,%edx
  802351:	88 c1                	mov    %al,%cl
  802353:	d3 e2                	shl    %cl,%edx
  802355:	89 d0                	mov    %edx,%eax
  802357:	83 ec 08             	sub    $0x8,%esp
  80235a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80235d:	50                   	push   %eax
  80235e:	e8 c0 fc ff ff       	call   802023 <split_page_to_blocks>
  802363:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	c1 e0 04             	shl    $0x4,%eax
  80236c:	05 80 c0 81 00       	add    $0x81c080,%eax
  802371:	8b 00                	mov    (%eax),%eax
  802373:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802376:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80237a:	75 17                	jne    802393 <alloc_block+0x232>
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 61 36 80 00       	push   $0x803661
  802384:	68 b0 00 00 00       	push   $0xb0
  802389:	68 a3 35 80 00       	push   $0x8035a3
  80238e:	e8 04 e1 ff ff       	call   800497 <_panic>
  802393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 10                	je     8023ac <alloc_block+0x24b>
  80239c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a4:	8b 52 04             	mov    0x4(%edx),%edx
  8023a7:	89 50 04             	mov    %edx,0x4(%eax)
  8023aa:	eb 14                	jmp    8023c0 <alloc_block+0x25f>
  8023ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023af:	8b 40 04             	mov    0x4(%eax),%eax
  8023b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b5:	c1 e2 04             	shl    $0x4,%edx
  8023b8:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8023be:	89 02                	mov    %eax,(%edx)
  8023c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	74 0f                	je     8023d9 <alloc_block+0x278>
  8023ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023d3:	8b 12                	mov    (%edx),%edx
  8023d5:	89 10                	mov    %edx,(%eax)
  8023d7:	eb 13                	jmp    8023ec <alloc_block+0x28b>
  8023d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e1:	c1 e2 04             	shl    $0x4,%edx
  8023e4:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023ea:	89 02                	mov    %eax,(%edx)
  8023ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	c1 e0 04             	shl    $0x4,%eax
  802405:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	c1 e0 04             	shl    $0x4,%eax
  802415:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80241a:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80241c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241f:	83 ec 0c             	sub    $0xc,%esp
  802422:	50                   	push   %eax
  802423:	e8 f5 f9 ff ff       	call   801e1d <to_page_info>
  802428:	83 c4 10             	add    $0x10,%esp
  80242b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80242e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802431:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802435:	48                   	dec    %eax
  802436:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802439:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80243d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802440:	e9 26 01 00 00       	jmp    80256b <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802445:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	c1 e0 04             	shl    $0x4,%eax
  80244e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	0f 84 dc 00 00 00    	je     802539 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	c1 e0 04             	shl    $0x4,%eax
  802463:	05 80 c0 81 00       	add    $0x81c080,%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80246d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802471:	75 17                	jne    80248a <alloc_block+0x329>
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 61 36 80 00       	push   $0x803661
  80247b:	68 be 00 00 00       	push   $0xbe
  802480:	68 a3 35 80 00       	push   $0x8035a3
  802485:	e8 0d e0 ff ff       	call   800497 <_panic>
  80248a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	85 c0                	test   %eax,%eax
  802491:	74 10                	je     8024a3 <alloc_block+0x342>
  802493:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80249b:	8b 52 04             	mov    0x4(%edx),%edx
  80249e:	89 50 04             	mov    %edx,0x4(%eax)
  8024a1:	eb 14                	jmp    8024b7 <alloc_block+0x356>
  8024a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ac:	c1 e2 04             	shl    $0x4,%edx
  8024af:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8024b5:	89 02                	mov    %eax,(%edx)
  8024b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ba:	8b 40 04             	mov    0x4(%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	74 0f                	je     8024d0 <alloc_block+0x36f>
  8024c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c4:	8b 40 04             	mov    0x4(%eax),%eax
  8024c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024ca:	8b 12                	mov    (%edx),%edx
  8024cc:	89 10                	mov    %edx,(%eax)
  8024ce:	eb 13                	jmp    8024e3 <alloc_block+0x382>
  8024d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	c1 e2 04             	shl    $0x4,%edx
  8024db:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024e1:	89 02                	mov    %eax,(%edx)
  8024e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	c1 e0 04             	shl    $0x4,%eax
  8024fc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	8d 50 ff             	lea    -0x1(%eax),%edx
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	c1 e0 04             	shl    $0x4,%eax
  80250c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802511:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802513:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802516:	83 ec 0c             	sub    $0xc,%esp
  802519:	50                   	push   %eax
  80251a:	e8 fe f8 ff ff       	call   801e1d <to_page_info>
  80251f:	83 c4 10             	add    $0x10,%esp
  802522:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802525:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802528:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80252c:	48                   	dec    %eax
  80252d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802530:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802534:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802537:	eb 32                	jmp    80256b <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802539:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80253d:	77 15                	ja     802554 <alloc_block+0x3f3>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	c1 e0 04             	shl    $0x4,%eax
  802545:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80254a:	8b 00                	mov    (%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	0f 84 f1 fe ff ff    	je     802445 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	68 7f 36 80 00       	push   $0x80367f
  80255c:	68 c8 00 00 00       	push   $0xc8
  802561:	68 a3 35 80 00       	push   $0x8035a3
  802566:	e8 2c df ff ff       	call   800497 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802573:	8b 55 08             	mov    0x8(%ebp),%edx
  802576:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80257b:	39 c2                	cmp    %eax,%edx
  80257d:	72 0c                	jb     80258b <free_block+0x1e>
  80257f:	8b 55 08             	mov    0x8(%ebp),%edx
  802582:	a1 40 40 80 00       	mov    0x804040,%eax
  802587:	39 c2                	cmp    %eax,%edx
  802589:	72 19                	jb     8025a4 <free_block+0x37>
  80258b:	68 90 36 80 00       	push   $0x803690
  802590:	68 06 36 80 00       	push   $0x803606
  802595:	68 d7 00 00 00       	push   $0xd7
  80259a:	68 a3 35 80 00       	push   $0x8035a3
  80259f:	e8 f3 de ff ff       	call   800497 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	50                   	push   %eax
  8025b1:	e8 67 f8 ff ff       	call   801e1d <to_page_info>
  8025b6:	83 c4 10             	add    $0x10,%esp
  8025b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	8b 40 08             	mov    0x8(%eax),%eax
  8025c2:	0f b7 c0             	movzwl %ax,%eax
  8025c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025cf:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025d6:	eb 19                	jmp    8025f1 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025db:	ba 01 00 00 00       	mov    $0x1,%edx
  8025e0:	88 c1                	mov    %al,%cl
  8025e2:	d3 e2                	shl    %cl,%edx
  8025e4:	89 d0                	mov    %edx,%eax
  8025e6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025e9:	74 0e                	je     8025f9 <free_block+0x8c>
	        break;
	    idx++;
  8025eb:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025ee:	ff 45 f0             	incl   -0x10(%ebp)
  8025f1:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025f5:	7e e1                	jle    8025d8 <free_block+0x6b>
  8025f7:	eb 01                	jmp    8025fa <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025f9:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fd:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802601:	40                   	inc    %eax
  802602:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802605:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802609:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80260d:	75 17                	jne    802626 <free_block+0xb9>
  80260f:	83 ec 04             	sub    $0x4,%esp
  802612:	68 1c 36 80 00       	push   $0x80361c
  802617:	68 ee 00 00 00       	push   $0xee
  80261c:	68 a3 35 80 00       	push   $0x8035a3
  802621:	e8 71 de ff ff       	call   800497 <_panic>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	c1 e0 04             	shl    $0x4,%eax
  80262c:	05 84 c0 81 00       	add    $0x81c084,%eax
  802631:	8b 10                	mov    (%eax),%edx
  802633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802636:	89 50 04             	mov    %edx,0x4(%eax)
  802639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 14                	je     802657 <free_block+0xea>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	c1 e0 04             	shl    $0x4,%eax
  802649:	05 84 c0 81 00       	add    $0x81c084,%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802653:	89 10                	mov    %edx,(%eax)
  802655:	eb 11                	jmp    802668 <free_block+0xfb>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	c1 e0 04             	shl    $0x4,%eax
  80265d:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802666:	89 02                	mov    %eax,(%edx)
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	c1 e0 04             	shl    $0x4,%eax
  80266e:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802677:	89 02                	mov    %eax,(%edx)
  802679:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	c1 e0 04             	shl    $0x4,%eax
  802688:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8d 50 01             	lea    0x1(%eax),%edx
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	c1 e0 04             	shl    $0x4,%eax
  802698:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80269d:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80269f:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a9:	f7 75 e0             	divl   -0x20(%ebp)
  8026ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  8026af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b2:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026b6:	0f b7 c0             	movzwl %ax,%eax
  8026b9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8026bc:	0f 85 70 01 00 00    	jne    802832 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026c2:	83 ec 0c             	sub    $0xc,%esp
  8026c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c8:	e8 de f6 ff ff       	call   801dab <to_page_va>
  8026cd:	83 c4 10             	add    $0x10,%esp
  8026d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026da:	e9 b7 00 00 00       	jmp    802796 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026ee:	75 17                	jne    802707 <free_block+0x19a>
  8026f0:	83 ec 04             	sub    $0x4,%esp
  8026f3:	68 61 36 80 00       	push   $0x803661
  8026f8:	68 f8 00 00 00       	push   $0xf8
  8026fd:	68 a3 35 80 00       	push   $0x8035a3
  802702:	e8 90 dd ff ff       	call   800497 <_panic>
  802707:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 10                	je     802720 <free_block+0x1b3>
  802710:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802718:	8b 52 04             	mov    0x4(%edx),%edx
  80271b:	89 50 04             	mov    %edx,0x4(%eax)
  80271e:	eb 14                	jmp    802734 <free_block+0x1c7>
  802720:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802723:	8b 40 04             	mov    0x4(%eax),%eax
  802726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802729:	c1 e2 04             	shl    $0x4,%edx
  80272c:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802732:	89 02                	mov    %eax,(%edx)
  802734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802737:	8b 40 04             	mov    0x4(%eax),%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	74 0f                	je     80274d <free_block+0x1e0>
  80273e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802747:	8b 12                	mov    (%edx),%edx
  802749:	89 10                	mov    %edx,(%eax)
  80274b:	eb 13                	jmp    802760 <free_block+0x1f3>
  80274d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802755:	c1 e2 04             	shl    $0x4,%edx
  802758:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80275e:	89 02                	mov    %eax,(%edx)
  802760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802769:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	c1 e0 04             	shl    $0x4,%eax
  802779:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	8d 50 ff             	lea    -0x1(%eax),%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	c1 e0 04             	shl    $0x4,%eax
  802789:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80278e:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802793:	01 45 ec             	add    %eax,-0x14(%ebp)
  802796:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80279d:	0f 86 3c ff ff ff    	jbe    8026df <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  8027a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a6:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  8027ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027af:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  8027b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027b9:	75 17                	jne    8027d2 <free_block+0x265>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 1c 36 80 00       	push   $0x80361c
  8027c3:	68 fe 00 00 00       	push   $0xfe
  8027c8:	68 a3 35 80 00       	push   $0x8035a3
  8027cd:	e8 c5 dc ff ff       	call   800497 <_panic>
  8027d2:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	89 50 04             	mov    %edx,0x4(%eax)
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0c                	je     8027f4 <free_block+0x287>
  8027e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f0:	89 10                	mov    %edx,(%eax)
  8027f2:	eb 08                	jmp    8027fc <free_block+0x28f>
  8027f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f7:	a3 48 40 80 00       	mov    %eax,0x804048
  8027fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ff:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802807:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280d:	a1 54 40 80 00       	mov    0x804054,%eax
  802812:	40                   	inc    %eax
  802813:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80281e:	e8 88 f5 ff ff       	call   801dab <to_page_va>
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	83 ec 0c             	sub    $0xc,%esp
  802829:	50                   	push   %eax
  80282a:	e8 b8 ee ff ff       	call   8016e7 <return_page>
  80282f:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802832:	90                   	nop
  802833:	c9                   	leave  
  802834:	c3                   	ret    

00802835 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802835:	55                   	push   %ebp
  802836:	89 e5                	mov    %esp,%ebp
  802838:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80283b:	83 ec 04             	sub    $0x4,%esp
  80283e:	68 c8 36 80 00       	push   $0x8036c8
  802843:	68 11 01 00 00       	push   $0x111
  802848:	68 a3 35 80 00       	push   $0x8035a3
  80284d:	e8 45 dc ff ff       	call   800497 <_panic>
  802852:	66 90                	xchg   %ax,%ax

00802854 <__udivdi3>:
  802854:	55                   	push   %ebp
  802855:	57                   	push   %edi
  802856:	56                   	push   %esi
  802857:	53                   	push   %ebx
  802858:	83 ec 1c             	sub    $0x1c,%esp
  80285b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80285f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802863:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80286b:	89 ca                	mov    %ecx,%edx
  80286d:	89 f8                	mov    %edi,%eax
  80286f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802873:	85 f6                	test   %esi,%esi
  802875:	75 2d                	jne    8028a4 <__udivdi3+0x50>
  802877:	39 cf                	cmp    %ecx,%edi
  802879:	77 65                	ja     8028e0 <__udivdi3+0x8c>
  80287b:	89 fd                	mov    %edi,%ebp
  80287d:	85 ff                	test   %edi,%edi
  80287f:	75 0b                	jne    80288c <__udivdi3+0x38>
  802881:	b8 01 00 00 00       	mov    $0x1,%eax
  802886:	31 d2                	xor    %edx,%edx
  802888:	f7 f7                	div    %edi
  80288a:	89 c5                	mov    %eax,%ebp
  80288c:	31 d2                	xor    %edx,%edx
  80288e:	89 c8                	mov    %ecx,%eax
  802890:	f7 f5                	div    %ebp
  802892:	89 c1                	mov    %eax,%ecx
  802894:	89 d8                	mov    %ebx,%eax
  802896:	f7 f5                	div    %ebp
  802898:	89 cf                	mov    %ecx,%edi
  80289a:	89 fa                	mov    %edi,%edx
  80289c:	83 c4 1c             	add    $0x1c,%esp
  80289f:	5b                   	pop    %ebx
  8028a0:	5e                   	pop    %esi
  8028a1:	5f                   	pop    %edi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    
  8028a4:	39 ce                	cmp    %ecx,%esi
  8028a6:	77 28                	ja     8028d0 <__udivdi3+0x7c>
  8028a8:	0f bd fe             	bsr    %esi,%edi
  8028ab:	83 f7 1f             	xor    $0x1f,%edi
  8028ae:	75 40                	jne    8028f0 <__udivdi3+0x9c>
  8028b0:	39 ce                	cmp    %ecx,%esi
  8028b2:	72 0a                	jb     8028be <__udivdi3+0x6a>
  8028b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8028b8:	0f 87 9e 00 00 00    	ja     80295c <__udivdi3+0x108>
  8028be:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c3:	89 fa                	mov    %edi,%edx
  8028c5:	83 c4 1c             	add    $0x1c,%esp
  8028c8:	5b                   	pop    %ebx
  8028c9:	5e                   	pop    %esi
  8028ca:	5f                   	pop    %edi
  8028cb:	5d                   	pop    %ebp
  8028cc:	c3                   	ret    
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	31 ff                	xor    %edi,%edi
  8028d2:	31 c0                	xor    %eax,%eax
  8028d4:	89 fa                	mov    %edi,%edx
  8028d6:	83 c4 1c             	add    $0x1c,%esp
  8028d9:	5b                   	pop    %ebx
  8028da:	5e                   	pop    %esi
  8028db:	5f                   	pop    %edi
  8028dc:	5d                   	pop    %ebp
  8028dd:	c3                   	ret    
  8028de:	66 90                	xchg   %ax,%ax
  8028e0:	89 d8                	mov    %ebx,%eax
  8028e2:	f7 f7                	div    %edi
  8028e4:	31 ff                	xor    %edi,%edi
  8028e6:	89 fa                	mov    %edi,%edx
  8028e8:	83 c4 1c             	add    $0x1c,%esp
  8028eb:	5b                   	pop    %ebx
  8028ec:	5e                   	pop    %esi
  8028ed:	5f                   	pop    %edi
  8028ee:	5d                   	pop    %ebp
  8028ef:	c3                   	ret    
  8028f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8028f5:	89 eb                	mov    %ebp,%ebx
  8028f7:	29 fb                	sub    %edi,%ebx
  8028f9:	89 f9                	mov    %edi,%ecx
  8028fb:	d3 e6                	shl    %cl,%esi
  8028fd:	89 c5                	mov    %eax,%ebp
  8028ff:	88 d9                	mov    %bl,%cl
  802901:	d3 ed                	shr    %cl,%ebp
  802903:	89 e9                	mov    %ebp,%ecx
  802905:	09 f1                	or     %esi,%ecx
  802907:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80290b:	89 f9                	mov    %edi,%ecx
  80290d:	d3 e0                	shl    %cl,%eax
  80290f:	89 c5                	mov    %eax,%ebp
  802911:	89 d6                	mov    %edx,%esi
  802913:	88 d9                	mov    %bl,%cl
  802915:	d3 ee                	shr    %cl,%esi
  802917:	89 f9                	mov    %edi,%ecx
  802919:	d3 e2                	shl    %cl,%edx
  80291b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80291f:	88 d9                	mov    %bl,%cl
  802921:	d3 e8                	shr    %cl,%eax
  802923:	09 c2                	or     %eax,%edx
  802925:	89 d0                	mov    %edx,%eax
  802927:	89 f2                	mov    %esi,%edx
  802929:	f7 74 24 0c          	divl   0xc(%esp)
  80292d:	89 d6                	mov    %edx,%esi
  80292f:	89 c3                	mov    %eax,%ebx
  802931:	f7 e5                	mul    %ebp
  802933:	39 d6                	cmp    %edx,%esi
  802935:	72 19                	jb     802950 <__udivdi3+0xfc>
  802937:	74 0b                	je     802944 <__udivdi3+0xf0>
  802939:	89 d8                	mov    %ebx,%eax
  80293b:	31 ff                	xor    %edi,%edi
  80293d:	e9 58 ff ff ff       	jmp    80289a <__udivdi3+0x46>
  802942:	66 90                	xchg   %ax,%ax
  802944:	8b 54 24 08          	mov    0x8(%esp),%edx
  802948:	89 f9                	mov    %edi,%ecx
  80294a:	d3 e2                	shl    %cl,%edx
  80294c:	39 c2                	cmp    %eax,%edx
  80294e:	73 e9                	jae    802939 <__udivdi3+0xe5>
  802950:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802953:	31 ff                	xor    %edi,%edi
  802955:	e9 40 ff ff ff       	jmp    80289a <__udivdi3+0x46>
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	31 c0                	xor    %eax,%eax
  80295e:	e9 37 ff ff ff       	jmp    80289a <__udivdi3+0x46>
  802963:	90                   	nop

00802964 <__umoddi3>:
  802964:	55                   	push   %ebp
  802965:	57                   	push   %edi
  802966:	56                   	push   %esi
  802967:	53                   	push   %ebx
  802968:	83 ec 1c             	sub    $0x1c,%esp
  80296b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80296f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802973:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802977:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80297b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80297f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802983:	89 f3                	mov    %esi,%ebx
  802985:	89 fa                	mov    %edi,%edx
  802987:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80298b:	89 34 24             	mov    %esi,(%esp)
  80298e:	85 c0                	test   %eax,%eax
  802990:	75 1a                	jne    8029ac <__umoddi3+0x48>
  802992:	39 f7                	cmp    %esi,%edi
  802994:	0f 86 a2 00 00 00    	jbe    802a3c <__umoddi3+0xd8>
  80299a:	89 c8                	mov    %ecx,%eax
  80299c:	89 f2                	mov    %esi,%edx
  80299e:	f7 f7                	div    %edi
  8029a0:	89 d0                	mov    %edx,%eax
  8029a2:	31 d2                	xor    %edx,%edx
  8029a4:	83 c4 1c             	add    $0x1c,%esp
  8029a7:	5b                   	pop    %ebx
  8029a8:	5e                   	pop    %esi
  8029a9:	5f                   	pop    %edi
  8029aa:	5d                   	pop    %ebp
  8029ab:	c3                   	ret    
  8029ac:	39 f0                	cmp    %esi,%eax
  8029ae:	0f 87 ac 00 00 00    	ja     802a60 <__umoddi3+0xfc>
  8029b4:	0f bd e8             	bsr    %eax,%ebp
  8029b7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ba:	0f 84 ac 00 00 00    	je     802a6c <__umoddi3+0x108>
  8029c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8029c5:	29 ef                	sub    %ebp,%edi
  8029c7:	89 fe                	mov    %edi,%esi
  8029c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029cd:	89 e9                	mov    %ebp,%ecx
  8029cf:	d3 e0                	shl    %cl,%eax
  8029d1:	89 d7                	mov    %edx,%edi
  8029d3:	89 f1                	mov    %esi,%ecx
  8029d5:	d3 ef                	shr    %cl,%edi
  8029d7:	09 c7                	or     %eax,%edi
  8029d9:	89 e9                	mov    %ebp,%ecx
  8029db:	d3 e2                	shl    %cl,%edx
  8029dd:	89 14 24             	mov    %edx,(%esp)
  8029e0:	89 d8                	mov    %ebx,%eax
  8029e2:	d3 e0                	shl    %cl,%eax
  8029e4:	89 c2                	mov    %eax,%edx
  8029e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029ea:	d3 e0                	shl    %cl,%eax
  8029ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029f4:	89 f1                	mov    %esi,%ecx
  8029f6:	d3 e8                	shr    %cl,%eax
  8029f8:	09 d0                	or     %edx,%eax
  8029fa:	d3 eb                	shr    %cl,%ebx
  8029fc:	89 da                	mov    %ebx,%edx
  8029fe:	f7 f7                	div    %edi
  802a00:	89 d3                	mov    %edx,%ebx
  802a02:	f7 24 24             	mull   (%esp)
  802a05:	89 c6                	mov    %eax,%esi
  802a07:	89 d1                	mov    %edx,%ecx
  802a09:	39 d3                	cmp    %edx,%ebx
  802a0b:	0f 82 87 00 00 00    	jb     802a98 <__umoddi3+0x134>
  802a11:	0f 84 91 00 00 00    	je     802aa8 <__umoddi3+0x144>
  802a17:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a1b:	29 f2                	sub    %esi,%edx
  802a1d:	19 cb                	sbb    %ecx,%ebx
  802a1f:	89 d8                	mov    %ebx,%eax
  802a21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802a25:	d3 e0                	shl    %cl,%eax
  802a27:	89 e9                	mov    %ebp,%ecx
  802a29:	d3 ea                	shr    %cl,%edx
  802a2b:	09 d0                	or     %edx,%eax
  802a2d:	89 e9                	mov    %ebp,%ecx
  802a2f:	d3 eb                	shr    %cl,%ebx
  802a31:	89 da                	mov    %ebx,%edx
  802a33:	83 c4 1c             	add    $0x1c,%esp
  802a36:	5b                   	pop    %ebx
  802a37:	5e                   	pop    %esi
  802a38:	5f                   	pop    %edi
  802a39:	5d                   	pop    %ebp
  802a3a:	c3                   	ret    
  802a3b:	90                   	nop
  802a3c:	89 fd                	mov    %edi,%ebp
  802a3e:	85 ff                	test   %edi,%edi
  802a40:	75 0b                	jne    802a4d <__umoddi3+0xe9>
  802a42:	b8 01 00 00 00       	mov    $0x1,%eax
  802a47:	31 d2                	xor    %edx,%edx
  802a49:	f7 f7                	div    %edi
  802a4b:	89 c5                	mov    %eax,%ebp
  802a4d:	89 f0                	mov    %esi,%eax
  802a4f:	31 d2                	xor    %edx,%edx
  802a51:	f7 f5                	div    %ebp
  802a53:	89 c8                	mov    %ecx,%eax
  802a55:	f7 f5                	div    %ebp
  802a57:	89 d0                	mov    %edx,%eax
  802a59:	e9 44 ff ff ff       	jmp    8029a2 <__umoddi3+0x3e>
  802a5e:	66 90                	xchg   %ax,%ax
  802a60:	89 c8                	mov    %ecx,%eax
  802a62:	89 f2                	mov    %esi,%edx
  802a64:	83 c4 1c             	add    $0x1c,%esp
  802a67:	5b                   	pop    %ebx
  802a68:	5e                   	pop    %esi
  802a69:	5f                   	pop    %edi
  802a6a:	5d                   	pop    %ebp
  802a6b:	c3                   	ret    
  802a6c:	3b 04 24             	cmp    (%esp),%eax
  802a6f:	72 06                	jb     802a77 <__umoddi3+0x113>
  802a71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802a75:	77 0f                	ja     802a86 <__umoddi3+0x122>
  802a77:	89 f2                	mov    %esi,%edx
  802a79:	29 f9                	sub    %edi,%ecx
  802a7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802a7f:	89 14 24             	mov    %edx,(%esp)
  802a82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a86:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a8a:	8b 14 24             	mov    (%esp),%edx
  802a8d:	83 c4 1c             	add    $0x1c,%esp
  802a90:	5b                   	pop    %ebx
  802a91:	5e                   	pop    %esi
  802a92:	5f                   	pop    %edi
  802a93:	5d                   	pop    %ebp
  802a94:	c3                   	ret    
  802a95:	8d 76 00             	lea    0x0(%esi),%esi
  802a98:	2b 04 24             	sub    (%esp),%eax
  802a9b:	19 fa                	sbb    %edi,%edx
  802a9d:	89 d1                	mov    %edx,%ecx
  802a9f:	89 c6                	mov    %eax,%esi
  802aa1:	e9 71 ff ff ff       	jmp    802a17 <__umoddi3+0xb3>
  802aa6:	66 90                	xchg   %ax,%ax
  802aa8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802aac:	72 ea                	jb     802a98 <__umoddi3+0x134>
  802aae:	89 d9                	mov    %ebx,%ecx
  802ab0:	e9 62 ff ff ff       	jmp    802a17 <__umoddi3+0xb3>
