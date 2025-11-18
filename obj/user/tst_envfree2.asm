
obj/user/tst_envfree2:     file format elf32-i386


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
  800031:	e8 73 02 00 00       	call   8002a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef2 10 5
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	// Testing scenario 2: using dynamic allocation and free
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  80004a:	bb 31 20 80 00       	mov    $0x802031,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 b9 1a 00 00       	call   801b3f <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 b2 16 00 00       	call   801740 <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 f5 16 00 00       	call   80178b <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 40 1e 80 00       	push   $0x801e40
  8000a4:	e8 93 06 00 00       	call   80073c <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("sc_ms_leak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 73 1e 80 00       	push   $0x801e73
  8000cd:	e8 c9 17 00 00       	call   80189b <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_ms_noleak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dd:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000e3:	89 c2                	mov    %eax,%edx
  8000e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ea:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f0:	6a 32                	push   $0x32
  8000f2:	52                   	push   %edx
  8000f3:	50                   	push   %eax
  8000f4:	68 84 1e 80 00       	push   $0x801e84
  8000f9:	e8 9d 17 00 00       	call   80189b <sys_create_env>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 d8             	mov    %eax,-0x28(%ebp)

	rsttst();
  800104:	e8 de 18 00 00       	call   8019e7 <rsttst>

	//Run 2 processes
	sys_run_env(envIdProcessA);
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	ff 75 dc             	pushl  -0x24(%ebp)
  80010f:	e8 a5 17 00 00       	call   8018b9 <sys_run_env>
  800114:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	ff 75 d8             	pushl  -0x28(%ebp)
  80011d:	e8 97 17 00 00       	call   8018b9 <sys_run_env>
  800122:	83 c4 10             	add    $0x10,%esp

	//env_sleep(30000);

	//to ensure that the slave environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  800125:	90                   	nop
  800126:	e8 36 19 00 00       	call   801a61 <gettst>
  80012b:	83 f8 02             	cmp    $0x2,%eax
  80012e:	75 f6                	jne    800126 <_main+0xee>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800130:	e8 0b 16 00 00       	call   801740 <sys_calculate_free_frames>
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	50                   	push   %eax
  800139:	68 98 1e 80 00       	push   $0x801e98
  80013e:	e8 f9 05 00 00       	call   80073c <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800146:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80014c:	83 ec 08             	sub    $0x8,%esp
  80014f:	50                   	push   %eax
  800150:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 e3 19 00 00       	call   801b3f <sys_utilities>
  80015c:	83 c4 10             	add    $0x10,%esp
	//Kill the 2 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80015f:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800165:	bb 95 20 80 00       	mov    $0x802095,%ebx
  80016a:	ba 1a 00 00 00       	mov    $0x1a,%edx
  80016f:	89 c7                	mov    %eax,%edi
  800171:	89 de                	mov    %ebx,%esi
  800173:	89 d1                	mov    %edx,%ecx
  800175:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800177:	8d 95 06 ff ff ff    	lea    -0xfa(%ebp),%edx
  80017d:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800182:	b0 00                	mov    $0x0,%al
  800184:	89 d7                	mov    %edx,%edi
  800186:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 a6 19 00 00       	call   801b3f <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a2:	e8 2e 17 00 00       	call   8018d5 <sys_destroy_env>
  8001a7:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b0:	e8 20 17 00 00       	call   8018d5 <sys_destroy_env>
  8001b5:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	6a 01                	push   $0x1
  8001bd:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  8001c3:	50                   	push   %eax
  8001c4:	e8 76 19 00 00       	call   801b3f <sys_utilities>
  8001c9:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001cc:	e8 6f 15 00 00       	call   801740 <sys_calculate_free_frames>
  8001d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d4:	e8 b2 15 00 00       	call   80178b <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001dc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8001e3:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  8001e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	48                   	dec    %eax
  8001ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	f7 75 cc             	divl   -0x34(%ebp)
  8001fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800200:	29 d0                	sub    %edx,%eax
  800202:	89 c1                	mov    %eax,%ecx
  800204:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80020b:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
  800211:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800214:	01 d0                	add    %edx,%eax
  800216:	48                   	dec    %eax
  800217:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80021a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80021d:	ba 00 00 00 00       	mov    $0x0,%edx
  800222:	f7 75 c4             	divl   -0x3c(%ebp)
  800225:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800228:	29 d0                	sub    %edx,%eax
  80022a:	29 c1                	sub    %eax,%ecx
  80022c:	89 c8                	mov    %ecx,%eax
  80022e:	c1 e8 0c             	shr    $0xc,%eax
  800231:	89 45 bc             	mov    %eax,-0x44(%ebp)
	cprintf("expected = %d\n",expected);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	ff 75 bc             	pushl  -0x44(%ebp)
  80023a:	68 ca 1e 80 00       	push   $0x801eca
  80023f:	e8 f8 04 00 00       	call   80073c <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80024d:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800250:	74 2e                	je     800280 <_main+0x248>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800252:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800255:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800258:	ff 75 bc             	pushl  -0x44(%ebp)
  80025b:	50                   	push   %eax
  80025c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025f:	68 dc 1e 80 00       	push   $0x801edc
  800264:	e8 d3 04 00 00       	call   80073c <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 4c 1f 80 00       	push   $0x801f4c
  800274:	6a 3c                	push   $0x3c
  800276:	68 82 1f 80 00       	push   $0x801f82
  80027b:	e8 ee 01 00 00       	call   80046e <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 98 1f 80 00       	push   $0x801f98
  800288:	e8 af 04 00 00       	call   80073c <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 2 for envfree completed successfully.\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 e8 1f 80 00       	push   $0x801fe8
  800298:	e8 9f 04 00 00       	call   80073c <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	return;
  8002a0:	90                   	nop
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002b2:	e8 52 16 00 00       	call   801909 <sys_getenvindex>
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002bd:	89 d0                	mov    %edx,%eax
  8002bf:	c1 e0 06             	shl    $0x6,%eax
  8002c2:	29 d0                	sub    %edx,%eax
  8002c4:	c1 e0 02             	shl    $0x2,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d0:	01 c8                	add    %ecx,%eax
  8002d2:	c1 e0 03             	shl    $0x3,%eax
  8002d5:	01 d0                	add    %edx,%eax
  8002d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002de:	29 c2                	sub    %eax,%edx
  8002e0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002ef:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f9:	8a 40 20             	mov    0x20(%eax),%al
  8002fc:	84 c0                	test   %al,%al
  8002fe:	74 0d                	je     80030d <libmain+0x64>
		binaryname = myEnv->prog_name;
  800300:	a1 20 30 80 00       	mov    0x803020,%eax
  800305:	83 c0 20             	add    $0x20,%eax
  800308:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80030d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800311:	7e 0a                	jle    80031d <libmain+0x74>
		binaryname = argv[0];
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	8b 00                	mov    (%eax),%eax
  800318:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 0d fd ff ff       	call   800038 <_main>
  80032b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80032e:	a1 00 30 80 00       	mov    0x803000,%eax
  800333:	85 c0                	test   %eax,%eax
  800335:	0f 84 01 01 00 00    	je     80043c <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80033b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800341:	bb f4 21 80 00       	mov    $0x8021f4,%ebx
  800346:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034b:	89 c7                	mov    %eax,%edi
  80034d:	89 de                	mov    %ebx,%esi
  80034f:	89 d1                	mov    %edx,%ecx
  800351:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800353:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800356:	b9 56 00 00 00       	mov    $0x56,%ecx
  80035b:	b0 00                	mov    $0x0,%al
  80035d:	89 d7                	mov    %edx,%edi
  80035f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800361:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800368:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	50                   	push   %eax
  80036f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800375:	50                   	push   %eax
  800376:	e8 c4 17 00 00       	call   801b3f <sys_utilities>
  80037b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80037e:	e8 0d 13 00 00       	call   801690 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800383:	83 ec 0c             	sub    $0xc,%esp
  800386:	68 14 21 80 00       	push   $0x802114
  80038b:	e8 ac 03 00 00       	call   80073c <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800393:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800396:	85 c0                	test   %eax,%eax
  800398:	74 18                	je     8003b2 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80039a:	e8 be 17 00 00       	call   801b5d <sys_get_optimal_num_faults>
  80039f:	83 ec 08             	sub    $0x8,%esp
  8003a2:	50                   	push   %eax
  8003a3:	68 3c 21 80 00       	push   $0x80213c
  8003a8:	e8 8f 03 00 00       	call   80073c <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp
  8003b0:	eb 59                	jmp    80040b <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b7:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c2:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	52                   	push   %edx
  8003cc:	50                   	push   %eax
  8003cd:	68 60 21 80 00       	push   $0x802160
  8003d2:	e8 65 03 00 00       	call   80073c <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003da:	a1 20 30 80 00       	mov    0x803020,%eax
  8003df:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003e5:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ea:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003fb:	51                   	push   %ecx
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 88 21 80 00       	push   $0x802188
  800403:	e8 34 03 00 00       	call   80073c <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	50                   	push   %eax
  80041a:	68 e0 21 80 00       	push   $0x8021e0
  80041f:	e8 18 03 00 00       	call   80073c <cprintf>
  800424:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	68 14 21 80 00       	push   $0x802114
  80042f:	e8 08 03 00 00       	call   80073c <cprintf>
  800434:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800437:	e8 6e 12 00 00       	call   8016aa <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80043c:	e8 1f 00 00 00       	call   800460 <exit>
}
  800441:	90                   	nop
  800442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800445:	5b                   	pop    %ebx
  800446:	5e                   	pop    %esi
  800447:	5f                   	pop    %edi
  800448:	5d                   	pop    %ebp
  800449:	c3                   	ret    

0080044a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	6a 00                	push   $0x0
  800455:	e8 7b 14 00 00       	call   8018d5 <sys_destroy_env>
  80045a:	83 c4 10             	add    $0x10,%esp
}
  80045d:	90                   	nop
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <exit>:

void
exit(void)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800466:	e8 d0 14 00 00       	call   80193b <sys_exit_env>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800474:	8d 45 10             	lea    0x10(%ebp),%eax
  800477:	83 c0 04             	add    $0x4,%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80047d:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	74 16                	je     80049c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800486:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	50                   	push   %eax
  80048f:	68 58 22 80 00       	push   $0x802258
  800494:	e8 a3 02 00 00       	call   80073c <cprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80049c:	a1 04 30 80 00       	mov    0x803004,%eax
  8004a1:	83 ec 0c             	sub    $0xc,%esp
  8004a4:	ff 75 0c             	pushl  0xc(%ebp)
  8004a7:	ff 75 08             	pushl  0x8(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	68 60 22 80 00       	push   $0x802260
  8004b0:	6a 74                	push   $0x74
  8004b2:	e8 b2 02 00 00       	call   800769 <cprintf_colored>
  8004b7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8004c3:	50                   	push   %eax
  8004c4:	e8 04 02 00 00       	call   8006cd <vcprintf>
  8004c9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	6a 00                	push   $0x0
  8004d1:	68 88 22 80 00       	push   $0x802288
  8004d6:	e8 f2 01 00 00       	call   8006cd <vcprintf>
  8004db:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004de:	e8 7d ff ff ff       	call   800460 <exit>

	// should not return here
	while (1) ;
  8004e3:	eb fe                	jmp    8004e3 <_panic+0x75>

008004e5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	39 c2                	cmp    %eax,%edx
  8004fb:	74 14                	je     800511 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 8c 22 80 00       	push   $0x80228c
  800505:	6a 26                	push   $0x26
  800507:	68 d8 22 80 00       	push   $0x8022d8
  80050c:	e8 5d ff ff ff       	call   80046e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051f:	e9 c5 00 00 00       	jmp    8005e9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800527:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	01 d0                	add    %edx,%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	85 c0                	test   %eax,%eax
  800537:	75 08                	jne    800541 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800539:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80053c:	e9 a5 00 00 00       	jmp    8005e6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800541:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800548:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80054f:	eb 69                	jmp    8005ba <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800551:	a1 20 30 80 00       	mov    0x803020,%eax
  800556:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80055c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80055f:	89 d0                	mov    %edx,%eax
  800561:	01 c0                	add    %eax,%eax
  800563:	01 d0                	add    %edx,%eax
  800565:	c1 e0 03             	shl    $0x3,%eax
  800568:	01 c8                	add    %ecx,%eax
  80056a:	8a 40 04             	mov    0x4(%eax),%al
  80056d:	84 c0                	test   %al,%al
  80056f:	75 46                	jne    8005b7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80057c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	01 c0                	add    %eax,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	c1 e0 03             	shl    $0x3,%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80058f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800592:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800597:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80059c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	01 c8                	add    %ecx,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005aa:	39 c2                	cmp    %eax,%edx
  8005ac:	75 09                	jne    8005b7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005ae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005b5:	eb 15                	jmp    8005cc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b7:	ff 45 e8             	incl   -0x18(%ebp)
  8005ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8005bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	39 c2                	cmp    %eax,%edx
  8005ca:	77 85                	ja     800551 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d0:	75 14                	jne    8005e6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005d2:	83 ec 04             	sub    $0x4,%esp
  8005d5:	68 e4 22 80 00       	push   $0x8022e4
  8005da:	6a 3a                	push   $0x3a
  8005dc:	68 d8 22 80 00       	push   $0x8022d8
  8005e1:	e8 88 fe ff ff       	call   80046e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005e6:	ff 45 f0             	incl   -0x10(%ebp)
  8005e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005ef:	0f 8c 2f ff ff ff    	jl     800524 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800603:	eb 26                	jmp    80062b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800605:	a1 20 30 80 00       	mov    0x803020,%eax
  80060a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800610:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800613:	89 d0                	mov    %edx,%eax
  800615:	01 c0                	add    %eax,%eax
  800617:	01 d0                	add    %edx,%eax
  800619:	c1 e0 03             	shl    $0x3,%eax
  80061c:	01 c8                	add    %ecx,%eax
  80061e:	8a 40 04             	mov    0x4(%eax),%al
  800621:	3c 01                	cmp    $0x1,%al
  800623:	75 03                	jne    800628 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800625:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800628:	ff 45 e0             	incl   -0x20(%ebp)
  80062b:	a1 20 30 80 00       	mov    0x803020,%eax
  800630:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800639:	39 c2                	cmp    %eax,%edx
  80063b:	77 c8                	ja     800605 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80063d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800640:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800643:	74 14                	je     800659 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800645:	83 ec 04             	sub    $0x4,%esp
  800648:	68 38 23 80 00       	push   $0x802338
  80064d:	6a 44                	push   $0x44
  80064f:	68 d8 22 80 00       	push   $0x8022d8
  800654:	e8 15 fe ff ff       	call   80046e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800659:	90                   	nop
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	53                   	push   %ebx
  800660:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	8d 48 01             	lea    0x1(%eax),%ecx
  80066b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066e:	89 0a                	mov    %ecx,(%edx)
  800670:	8b 55 08             	mov    0x8(%ebp),%edx
  800673:	88 d1                	mov    %dl,%cl
  800675:	8b 55 0c             	mov    0xc(%ebp),%edx
  800678:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80067c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	3d ff 00 00 00       	cmp    $0xff,%eax
  800686:	75 30                	jne    8006b8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800688:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80068e:	a0 44 30 80 00       	mov    0x803044,%al
  800693:	0f b6 c0             	movzbl %al,%eax
  800696:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800699:	8b 09                	mov    (%ecx),%ecx
  80069b:	89 cb                	mov    %ecx,%ebx
  80069d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a0:	83 c1 08             	add    $0x8,%ecx
  8006a3:	52                   	push   %edx
  8006a4:	50                   	push   %eax
  8006a5:	53                   	push   %ebx
  8006a6:	51                   	push   %ecx
  8006a7:	e8 a0 0f 00 00       	call   80164c <sys_cputs>
  8006ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bb:	8b 40 04             	mov    0x4(%eax),%eax
  8006be:	8d 50 01             	lea    0x1(%eax),%edx
  8006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006c7:	90                   	nop
  8006c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006dd:	00 00 00 
	b.cnt = 0;
  8006e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	ff 75 08             	pushl  0x8(%ebp)
  8006f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f6:	50                   	push   %eax
  8006f7:	68 5c 06 80 00       	push   $0x80065c
  8006fc:	e8 5a 02 00 00       	call   80095b <vprintfmt>
  800701:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800704:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80070a:	a0 44 30 80 00       	mov    0x803044,%al
  80070f:	0f b6 c0             	movzbl %al,%eax
  800712:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	51                   	push   %ecx
  80071b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800721:	83 c0 08             	add    $0x8,%eax
  800724:	50                   	push   %eax
  800725:	e8 22 0f 00 00       	call   80164c <sys_cputs>
  80072a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072d:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800734:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    

0080073c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800742:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800749:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 f4             	pushl  -0xc(%ebp)
  800758:	50                   	push   %eax
  800759:	e8 6f ff ff ff       	call   8006cd <vcprintf>
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800764:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076f:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	c1 e0 08             	shl    $0x8,%eax
  80077c:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800781:	8d 45 0c             	lea    0xc(%ebp),%eax
  800784:	83 c0 04             	add    $0x4,%eax
  800787:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 f4             	pushl  -0xc(%ebp)
  800793:	50                   	push   %eax
  800794:	e8 34 ff ff ff       	call   8006cd <vcprintf>
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80079f:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007a6:	07 00 00 

	return cnt;
  8007a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007b4:	e8 d7 0e 00 00       	call   801690 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c8:	50                   	push   %eax
  8007c9:	e8 ff fe ff ff       	call   8006cd <vcprintf>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007d4:	e8 d1 0e 00 00       	call   8016aa <sys_unlock_cons>
	return cnt;
  8007d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    

008007de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 14             	sub    $0x14,%esp
  8007e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007fc:	77 55                	ja     800853 <printnum+0x75>
  8007fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800801:	72 05                	jb     800808 <printnum+0x2a>
  800803:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800806:	77 4b                	ja     800853 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800808:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80080b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80080e:	8b 45 18             	mov    0x18(%ebp),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
  800816:	52                   	push   %edx
  800817:	50                   	push   %eax
  800818:	ff 75 f4             	pushl  -0xc(%ebp)
  80081b:	ff 75 f0             	pushl  -0x10(%ebp)
  80081e:	e8 a9 13 00 00       	call   801bcc <__udivdi3>
  800823:	83 c4 10             	add    $0x10,%esp
  800826:	83 ec 04             	sub    $0x4,%esp
  800829:	ff 75 20             	pushl  0x20(%ebp)
  80082c:	53                   	push   %ebx
  80082d:	ff 75 18             	pushl  0x18(%ebp)
  800830:	52                   	push   %edx
  800831:	50                   	push   %eax
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	ff 75 08             	pushl  0x8(%ebp)
  800838:	e8 a1 ff ff ff       	call   8007de <printnum>
  80083d:	83 c4 20             	add    $0x20,%esp
  800840:	eb 1a                	jmp    80085c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 20             	pushl  0x20(%ebp)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800853:	ff 4d 1c             	decl   0x1c(%ebp)
  800856:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80085a:	7f e6                	jg     800842 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80085c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80085f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800867:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086a:	53                   	push   %ebx
  80086b:	51                   	push   %ecx
  80086c:	52                   	push   %edx
  80086d:	50                   	push   %eax
  80086e:	e8 69 14 00 00       	call   801cdc <__umoddi3>
  800873:	83 c4 10             	add    $0x10,%esp
  800876:	05 b4 25 80 00       	add    $0x8025b4,%eax
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f be c0             	movsbl %al,%eax
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	50                   	push   %eax
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	ff d0                	call   *%eax
  80088c:	83 c4 10             	add    $0x10,%esp
}
  80088f:	90                   	nop
  800890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800893:	c9                   	leave  
  800894:	c3                   	ret    

00800895 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800898:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80089c:	7e 1c                	jle    8008ba <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	8d 50 08             	lea    0x8(%eax),%edx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	89 10                	mov    %edx,(%eax)
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 00                	mov    (%eax),%eax
  8008b0:	83 e8 08             	sub    $0x8,%eax
  8008b3:	8b 50 04             	mov    0x4(%eax),%edx
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	eb 40                	jmp    8008fa <getuint+0x65>
	else if (lflag)
  8008ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008be:	74 1e                	je     8008de <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	8d 50 04             	lea    0x4(%eax),%edx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	89 10                	mov    %edx,(%eax)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	83 e8 04             	sub    $0x4,%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008dc:	eb 1c                	jmp    8008fa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	8d 50 04             	lea    0x4(%eax),%edx
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	89 10                	mov    %edx,(%eax)
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	83 e8 04             	sub    $0x4,%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800903:	7e 1c                	jle    800921 <getint+0x25>
		return va_arg(*ap, long long);
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	8d 50 08             	lea    0x8(%eax),%edx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	89 10                	mov    %edx,(%eax)
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 e8 08             	sub    $0x8,%eax
  80091a:	8b 50 04             	mov    0x4(%eax),%edx
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	eb 38                	jmp    800959 <getint+0x5d>
	else if (lflag)
  800921:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800925:	74 1a                	je     800941 <getint+0x45>
		return va_arg(*ap, long);
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	8d 50 04             	lea    0x4(%eax),%edx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	89 10                	mov    %edx,(%eax)
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	83 e8 04             	sub    $0x4,%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	99                   	cltd   
  80093f:	eb 18                	jmp    800959 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 50 04             	lea    0x4(%eax),%edx
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	89 10                	mov    %edx,(%eax)
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 00                	mov    (%eax),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	99                   	cltd   
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	56                   	push   %esi
  80095f:	53                   	push   %ebx
  800960:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800963:	eb 17                	jmp    80097c <vprintfmt+0x21>
			if (ch == '\0')
  800965:	85 db                	test   %ebx,%ebx
  800967:	0f 84 c1 03 00 00    	je     800d2e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	53                   	push   %ebx
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	8d 50 01             	lea    0x1(%eax),%edx
  800982:	89 55 10             	mov    %edx,0x10(%ebp)
  800985:	8a 00                	mov    (%eax),%al
  800987:	0f b6 d8             	movzbl %al,%ebx
  80098a:	83 fb 25             	cmp    $0x25,%ebx
  80098d:	75 d6                	jne    800965 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80098f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800993:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80099a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009a8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009af:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b2:	8d 50 01             	lea    0x1(%eax),%edx
  8009b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f b6 d8             	movzbl %al,%ebx
  8009bd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c0:	83 f8 5b             	cmp    $0x5b,%eax
  8009c3:	0f 87 3d 03 00 00    	ja     800d06 <vprintfmt+0x3ab>
  8009c9:	8b 04 85 d8 25 80 00 	mov    0x8025d8(,%eax,4),%eax
  8009d0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009d2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009d6:	eb d7                	jmp    8009af <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009d8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009dc:	eb d1                	jmp    8009af <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009e8:	89 d0                	mov    %edx,%eax
  8009ea:	c1 e0 02             	shl    $0x2,%eax
  8009ed:	01 d0                	add    %edx,%eax
  8009ef:	01 c0                	add    %eax,%eax
  8009f1:	01 d8                	add    %ebx,%eax
  8009f3:	83 e8 30             	sub    $0x30,%eax
  8009f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8a 00                	mov    (%eax),%al
  8009fe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a01:	83 fb 2f             	cmp    $0x2f,%ebx
  800a04:	7e 3e                	jle    800a44 <vprintfmt+0xe9>
  800a06:	83 fb 39             	cmp    $0x39,%ebx
  800a09:	7f 39                	jg     800a44 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a0b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a0e:	eb d5                	jmp    8009e5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a10:	8b 45 14             	mov    0x14(%ebp),%eax
  800a13:	83 c0 04             	add    $0x4,%eax
  800a16:	89 45 14             	mov    %eax,0x14(%ebp)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 e8 04             	sub    $0x4,%eax
  800a1f:	8b 00                	mov    (%eax),%eax
  800a21:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a24:	eb 1f                	jmp    800a45 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2a:	79 83                	jns    8009af <vprintfmt+0x54>
				width = 0;
  800a2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a33:	e9 77 ff ff ff       	jmp    8009af <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a38:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a3f:	e9 6b ff ff ff       	jmp    8009af <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a44:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a49:	0f 89 60 ff ff ff    	jns    8009af <vprintfmt+0x54>
				width = precision, precision = -1;
  800a4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a5c:	e9 4e ff ff ff       	jmp    8009af <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a61:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a64:	e9 46 ff ff ff       	jmp    8009af <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 c0 04             	add    $0x4,%eax
  800a6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 e8 04             	sub    $0x4,%eax
  800a78:	8b 00                	mov    (%eax),%eax
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	50                   	push   %eax
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			break;
  800a89:	e9 9b 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a9f:	85 db                	test   %ebx,%ebx
  800aa1:	79 02                	jns    800aa5 <vprintfmt+0x14a>
				err = -err;
  800aa3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aa5:	83 fb 64             	cmp    $0x64,%ebx
  800aa8:	7f 0b                	jg     800ab5 <vprintfmt+0x15a>
  800aaa:	8b 34 9d 20 24 80 00 	mov    0x802420(,%ebx,4),%esi
  800ab1:	85 f6                	test   %esi,%esi
  800ab3:	75 19                	jne    800ace <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ab5:	53                   	push   %ebx
  800ab6:	68 c5 25 80 00       	push   $0x8025c5
  800abb:	ff 75 0c             	pushl  0xc(%ebp)
  800abe:	ff 75 08             	pushl  0x8(%ebp)
  800ac1:	e8 70 02 00 00       	call   800d36 <printfmt>
  800ac6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ac9:	e9 5b 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ace:	56                   	push   %esi
  800acf:	68 ce 25 80 00       	push   $0x8025ce
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 57 02 00 00       	call   800d36 <printfmt>
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	e9 42 02 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	83 c0 04             	add    $0x4,%eax
  800aed:	89 45 14             	mov    %eax,0x14(%ebp)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 e8 04             	sub    $0x4,%eax
  800af6:	8b 30                	mov    (%eax),%esi
  800af8:	85 f6                	test   %esi,%esi
  800afa:	75 05                	jne    800b01 <vprintfmt+0x1a6>
				p = "(null)";
  800afc:	be d1 25 80 00       	mov    $0x8025d1,%esi
			if (width > 0 && padc != '-')
  800b01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b05:	7e 6d                	jle    800b74 <vprintfmt+0x219>
  800b07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b0b:	74 67                	je     800b74 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	50                   	push   %eax
  800b14:	56                   	push   %esi
  800b15:	e8 1e 03 00 00       	call   800e38 <strnlen>
  800b1a:	83 c4 10             	add    $0x10,%esp
  800b1d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b20:	eb 16                	jmp    800b38 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b22:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b26:	83 ec 08             	sub    $0x8,%esp
  800b29:	ff 75 0c             	pushl  0xc(%ebp)
  800b2c:	50                   	push   %eax
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	ff d0                	call   *%eax
  800b32:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b35:	ff 4d e4             	decl   -0x1c(%ebp)
  800b38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b3c:	7f e4                	jg     800b22 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3e:	eb 34                	jmp    800b74 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b44:	74 1c                	je     800b62 <vprintfmt+0x207>
  800b46:	83 fb 1f             	cmp    $0x1f,%ebx
  800b49:	7e 05                	jle    800b50 <vprintfmt+0x1f5>
  800b4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800b4e:	7e 12                	jle    800b62 <vprintfmt+0x207>
					putch('?', putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	6a 3f                	push   $0x3f
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	ff d0                	call   *%eax
  800b5d:	83 c4 10             	add    $0x10,%esp
  800b60:	eb 0f                	jmp    800b71 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	53                   	push   %ebx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	ff d0                	call   *%eax
  800b6e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b71:	ff 4d e4             	decl   -0x1c(%ebp)
  800b74:	89 f0                	mov    %esi,%eax
  800b76:	8d 70 01             	lea    0x1(%eax),%esi
  800b79:	8a 00                	mov    (%eax),%al
  800b7b:	0f be d8             	movsbl %al,%ebx
  800b7e:	85 db                	test   %ebx,%ebx
  800b80:	74 24                	je     800ba6 <vprintfmt+0x24b>
  800b82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b86:	78 b8                	js     800b40 <vprintfmt+0x1e5>
  800b88:	ff 4d e0             	decl   -0x20(%ebp)
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	79 af                	jns    800b40 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	eb 13                	jmp    800ba6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	6a 20                	push   $0x20
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ba3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ba6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800baa:	7f e7                	jg     800b93 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bac:	e9 78 01 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb1:	83 ec 08             	sub    $0x8,%esp
  800bb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800bb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800bba:	50                   	push   %eax
  800bbb:	e8 3c fd ff ff       	call   8008fc <getint>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcf:	85 d2                	test   %edx,%edx
  800bd1:	79 23                	jns    800bf6 <vprintfmt+0x29b>
				putch('-', putdat);
  800bd3:	83 ec 08             	sub    $0x8,%esp
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	6a 2d                	push   $0x2d
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	ff d0                	call   *%eax
  800be0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be9:	f7 d8                	neg    %eax
  800beb:	83 d2 00             	adc    $0x0,%edx
  800bee:	f7 da                	neg    %edx
  800bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bf6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfd:	e9 bc 00 00 00       	jmp    800cbe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 e8             	pushl  -0x18(%ebp)
  800c08:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	e8 84 fc ff ff       	call   800895 <getuint>
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c21:	e9 98 00 00 00       	jmp    800cbe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	6a 58                	push   $0x58
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	ff d0                	call   *%eax
  800c33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c36:	83 ec 08             	sub    $0x8,%esp
  800c39:	ff 75 0c             	pushl  0xc(%ebp)
  800c3c:	6a 58                	push   $0x58
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	ff d0                	call   *%eax
  800c43:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c46:	83 ec 08             	sub    $0x8,%esp
  800c49:	ff 75 0c             	pushl  0xc(%ebp)
  800c4c:	6a 58                	push   $0x58
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			break;
  800c56:	e9 ce 00 00 00       	jmp    800d29 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 30                	push   $0x30
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 78                	push   $0x78
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7e:	83 c0 04             	add    $0x4,%eax
  800c81:	89 45 14             	mov    %eax,0x14(%ebp)
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 e8 04             	sub    $0x4,%eax
  800c8a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c9d:	eb 1f                	jmp    800cbe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ca5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ca8:	50                   	push   %eax
  800ca9:	e8 e7 fb ff ff       	call   800895 <getuint>
  800cae:	83 c4 10             	add    $0x10,%esp
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cb7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc5:	83 ec 04             	sub    $0x4,%esp
  800cc8:	52                   	push   %edx
  800cc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ccc:	50                   	push   %eax
  800ccd:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cd3:	ff 75 0c             	pushl  0xc(%ebp)
  800cd6:	ff 75 08             	pushl  0x8(%ebp)
  800cd9:	e8 00 fb ff ff       	call   8007de <printnum>
  800cde:	83 c4 20             	add    $0x20,%esp
			break;
  800ce1:	eb 46                	jmp    800d29 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	ff 75 0c             	pushl  0xc(%ebp)
  800ce9:	53                   	push   %ebx
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			break;
  800cf2:	eb 35                	jmp    800d29 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cf4:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cfb:	eb 2c                	jmp    800d29 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cfd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d04:	eb 23                	jmp    800d29 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	6a 25                	push   $0x25
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	ff d0                	call   *%eax
  800d13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d16:	ff 4d 10             	decl   0x10(%ebp)
  800d19:	eb 03                	jmp    800d1e <vprintfmt+0x3c3>
  800d1b:	ff 4d 10             	decl   0x10(%ebp)
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	48                   	dec    %eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	3c 25                	cmp    $0x25,%al
  800d26:	75 f3                	jne    800d1b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d28:	90                   	nop
		}
	}
  800d29:	e9 35 fc ff ff       	jmp    800963 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d3f:	83 c0 04             	add    $0x4,%eax
  800d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d45:	8b 45 10             	mov    0x10(%ebp),%eax
  800d48:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4b:	50                   	push   %eax
  800d4c:	ff 75 0c             	pushl  0xc(%ebp)
  800d4f:	ff 75 08             	pushl  0x8(%ebp)
  800d52:	e8 04 fc ff ff       	call   80095b <vprintfmt>
  800d57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d5a:	90                   	nop
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	8b 40 08             	mov    0x8(%eax),%eax
  800d66:	8d 50 01             	lea    0x1(%eax),%edx
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 10                	mov    (%eax),%edx
  800d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d77:	8b 40 04             	mov    0x4(%eax),%eax
  800d7a:	39 c2                	cmp    %eax,%edx
  800d7c:	73 12                	jae    800d90 <sprintputch+0x33>
		*b->buf++ = ch;
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	8b 00                	mov    (%eax),%eax
  800d83:	8d 48 01             	lea    0x1(%eax),%ecx
  800d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d89:	89 0a                	mov    %ecx,(%edx)
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	88 10                	mov    %dl,(%eax)
}
  800d90:	90                   	nop
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	01 d0                	add    %edx,%eax
  800daa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800db8:	74 06                	je     800dc0 <vsnprintf+0x2d>
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	7f 07                	jg     800dc7 <vsnprintf+0x34>
		return -E_INVAL;
  800dc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800dc5:	eb 20                	jmp    800de7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dc7:	ff 75 14             	pushl  0x14(%ebp)
  800dca:	ff 75 10             	pushl  0x10(%ebp)
  800dcd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd0:	50                   	push   %eax
  800dd1:	68 5d 0d 80 00       	push   $0x800d5d
  800dd6:	e8 80 fb ff ff       	call   80095b <vprintfmt>
  800ddb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800def:	8d 45 10             	lea    0x10(%ebp),%eax
  800df2:	83 c0 04             	add    $0x4,%eax
  800df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800df8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfb:	ff 75 f4             	pushl  -0xc(%ebp)
  800dfe:	50                   	push   %eax
  800dff:	ff 75 0c             	pushl  0xc(%ebp)
  800e02:	ff 75 08             	pushl  0x8(%ebp)
  800e05:	e8 89 ff ff ff       	call   800d93 <vsnprintf>
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e22:	eb 06                	jmp    800e2a <strlen+0x15>
		n++;
  800e24:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e27:	ff 45 08             	incl   0x8(%ebp)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 f1                	jne    800e24 <strlen+0xf>
		n++;
	return n;
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e45:	eb 09                	jmp    800e50 <strnlen+0x18>
		n++;
  800e47:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	ff 4d 0c             	decl   0xc(%ebp)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 09                	je     800e5f <strnlen+0x27>
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e8                	jne    800e47 <strnlen+0xf>
		n++;
	return n;
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e62:	c9                   	leave  
  800e63:	c3                   	ret    

00800e64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e70:	90                   	nop
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	8d 50 01             	lea    0x1(%eax),%edx
  800e77:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e83:	8a 12                	mov    (%edx),%dl
  800e85:	88 10                	mov    %dl,(%eax)
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	84 c0                	test   %al,%al
  800e8b:	75 e4                	jne    800e71 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea5:	eb 1f                	jmp    800ec6 <strncpy+0x34>
		*dst++ = *src;
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8d 50 01             	lea    0x1(%eax),%edx
  800ead:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	74 03                	je     800ec3 <strncpy+0x31>
			src++;
  800ec0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ecc:	72 d9                	jb     800ea7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee3:	74 30                	je     800f15 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ee5:	eb 16                	jmp    800efd <strlcpy+0x2a>
			*dst++ = *src++;
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	8d 50 01             	lea    0x1(%eax),%edx
  800eed:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef9:	8a 12                	mov    (%edx),%dl
  800efb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800efd:	ff 4d 10             	decl   0x10(%ebp)
  800f00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f04:	74 09                	je     800f0f <strlcpy+0x3c>
  800f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f09:	8a 00                	mov    (%eax),%al
  800f0b:	84 c0                	test   %al,%al
  800f0d:	75 d8                	jne    800ee7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f24:	eb 06                	jmp    800f2c <strcmp+0xb>
		p++, q++;
  800f26:	ff 45 08             	incl   0x8(%ebp)
  800f29:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	84 c0                	test   %al,%al
  800f33:	74 0e                	je     800f43 <strcmp+0x22>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 e3                	je     800f26 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
}
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f5c:	eb 09                	jmp    800f67 <strncmp+0xe>
		n--, p++, q++;
  800f5e:	ff 4d 10             	decl   0x10(%ebp)
  800f61:	ff 45 08             	incl   0x8(%ebp)
  800f64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6b:	74 17                	je     800f84 <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	84 c0                	test   %al,%al
  800f74:	74 0e                	je     800f84 <strncmp+0x2b>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 10                	mov    (%eax),%dl
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	38 c2                	cmp    %al,%dl
  800f82:	74 da                	je     800f5e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strncmp+0x38>
		return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8f:	eb 14                	jmp    800fa5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	0f b6 d0             	movzbl %al,%edx
  800f99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 c0             	movzbl %al,%eax
  800fa1:	29 c2                	sub    %eax,%edx
  800fa3:	89 d0                	mov    %edx,%eax
}
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	83 ec 04             	sub    $0x4,%esp
  800fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb3:	eb 12                	jmp    800fc7 <strchr+0x20>
		if (*s == c)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fbd:	75 05                	jne    800fc4 <strchr+0x1d>
			return (char *) s;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	eb 11                	jmp    800fd5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fc4:	ff 45 08             	incl   0x8(%ebp)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	84 c0                	test   %al,%al
  800fce:	75 e5                	jne    800fb5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fe3:	eb 0d                	jmp    800ff2 <strfind+0x1b>
		if (*s == c)
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fed:	74 0e                	je     800ffd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fef:	ff 45 08             	incl   0x8(%ebp)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8a 00                	mov    (%eax),%al
  800ff7:	84 c0                	test   %al,%al
  800ff9:	75 ea                	jne    800fe5 <strfind+0xe>
  800ffb:	eb 01                	jmp    800ffe <strfind+0x27>
		if (*s == c)
			break;
  800ffd:	90                   	nop
	return (char *) s;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801001:	c9                   	leave  
  801002:	c3                   	ret    

00801003 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80100f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801013:	76 63                	jbe    801078 <memset+0x75>
		uint64 data_block = c;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	99                   	cltd   
  801019:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80101c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80101f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801025:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801029:	c1 e0 08             	shl    $0x8,%eax
  80102c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80102f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801038:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80103c:	c1 e0 10             	shl    $0x10,%eax
  80103f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801042:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	89 c2                	mov    %eax,%edx
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	09 45 f0             	or     %eax,-0x10(%ebp)
  801055:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801058:	eb 18                	jmp    801072 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80105a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80105d:	8d 41 08             	lea    0x8(%ecx),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801066:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801069:	89 01                	mov    %eax,(%ecx)
  80106b:	89 51 04             	mov    %edx,0x4(%ecx)
  80106e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801072:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801076:	77 e2                	ja     80105a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	74 23                	je     8010a1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80107e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801084:	eb 0e                	jmp    801094 <memset+0x91>
			*p8++ = (uint8)c;
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8d 50 01             	lea    0x1(%eax),%edx
  80108c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801092:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801094:	8b 45 10             	mov    0x10(%ebp),%eax
  801097:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109a:	89 55 10             	mov    %edx,0x10(%ebp)
  80109d:	85 c0                	test   %eax,%eax
  80109f:	75 e5                	jne    801086 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010b8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010bc:	76 24                	jbe    8010e2 <memcpy+0x3c>
		while(n >= 8){
  8010be:	eb 1c                	jmp    8010dc <memcpy+0x36>
			*d64 = *s64;
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	8b 50 04             	mov    0x4(%eax),%edx
  8010c6:	8b 00                	mov    (%eax),%eax
  8010c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010cb:	89 01                	mov    %eax,(%ecx)
  8010cd:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010d0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010d4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010d8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010dc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e0:	77 de                	ja     8010c0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e6:	74 31                	je     801119 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010f4:	eb 16                	jmp    80110c <memcpy+0x66>
			*d8++ = *s8++;
  8010f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010f9:	8d 50 01             	lea    0x1(%eax),%edx
  8010fc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801102:	8d 4a 01             	lea    0x1(%edx),%ecx
  801105:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801108:	8a 12                	mov    (%edx),%dl
  80110a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80110c:	8b 45 10             	mov    0x10(%ebp),%eax
  80110f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801112:	89 55 10             	mov    %edx,0x10(%ebp)
  801115:	85 c0                	test   %eax,%eax
  801117:	75 dd                	jne    8010f6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111c:	c9                   	leave  
  80111d:	c3                   	ret    

0080111e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801133:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801136:	73 50                	jae    801188 <memmove+0x6a>
  801138:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113b:	8b 45 10             	mov    0x10(%ebp),%eax
  80113e:	01 d0                	add    %edx,%eax
  801140:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801143:	76 43                	jbe    801188 <memmove+0x6a>
		s += n;
  801145:	8b 45 10             	mov    0x10(%ebp),%eax
  801148:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801151:	eb 10                	jmp    801163 <memmove+0x45>
			*--d = *--s;
  801153:	ff 4d f8             	decl   -0x8(%ebp)
  801156:	ff 4d fc             	decl   -0x4(%ebp)
  801159:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115c:	8a 10                	mov    (%eax),%dl
  80115e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801161:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801163:	8b 45 10             	mov    0x10(%ebp),%eax
  801166:	8d 50 ff             	lea    -0x1(%eax),%edx
  801169:	89 55 10             	mov    %edx,0x10(%ebp)
  80116c:	85 c0                	test   %eax,%eax
  80116e:	75 e3                	jne    801153 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801170:	eb 23                	jmp    801195 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	8d 50 01             	lea    0x1(%eax),%edx
  801178:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80117b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801181:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801184:	8a 12                	mov    (%edx),%dl
  801186:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118e:	89 55 10             	mov    %edx,0x10(%ebp)
  801191:	85 c0                	test   %eax,%eax
  801193:	75 dd                	jne    801172 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011ac:	eb 2a                	jmp    8011d8 <memcmp+0x3e>
		if (*s1 != *s2)
  8011ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b1:	8a 10                	mov    (%eax),%dl
  8011b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	38 c2                	cmp    %al,%dl
  8011ba:	74 16                	je     8011d2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bf:	8a 00                	mov    (%eax),%al
  8011c1:	0f b6 d0             	movzbl %al,%edx
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	0f b6 c0             	movzbl %al,%eax
  8011cc:	29 c2                	sub    %eax,%edx
  8011ce:	89 d0                	mov    %edx,%eax
  8011d0:	eb 18                	jmp    8011ea <memcmp+0x50>
		s1++, s2++;
  8011d2:	ff 45 fc             	incl   -0x4(%ebp)
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011de:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	75 c9                	jne    8011ae <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f8:	01 d0                	add    %edx,%eax
  8011fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011fd:	eb 15                	jmp    801214 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	0f b6 c0             	movzbl %al,%eax
  80120d:	39 c2                	cmp    %eax,%edx
  80120f:	74 0d                	je     80121e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801211:	ff 45 08             	incl   0x8(%ebp)
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80121a:	72 e3                	jb     8011ff <memfind+0x13>
  80121c:	eb 01                	jmp    80121f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80121e:	90                   	nop
	return (void *) s;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801231:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801238:	eb 03                	jmp    80123d <strtol+0x19>
		s++;
  80123a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	3c 20                	cmp    $0x20,%al
  801244:	74 f4                	je     80123a <strtol+0x16>
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	3c 09                	cmp    $0x9,%al
  80124d:	74 eb                	je     80123a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	3c 2b                	cmp    $0x2b,%al
  801256:	75 05                	jne    80125d <strtol+0x39>
		s++;
  801258:	ff 45 08             	incl   0x8(%ebp)
  80125b:	eb 13                	jmp    801270 <strtol+0x4c>
	else if (*s == '-')
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	3c 2d                	cmp    $0x2d,%al
  801264:	75 0a                	jne    801270 <strtol+0x4c>
		s++, neg = 1;
  801266:	ff 45 08             	incl   0x8(%ebp)
  801269:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801270:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801274:	74 06                	je     80127c <strtol+0x58>
  801276:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80127a:	75 20                	jne    80129c <strtol+0x78>
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	3c 30                	cmp    $0x30,%al
  801283:	75 17                	jne    80129c <strtol+0x78>
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	40                   	inc    %eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	3c 78                	cmp    $0x78,%al
  80128d:	75 0d                	jne    80129c <strtol+0x78>
		s += 2, base = 16;
  80128f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801293:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80129a:	eb 28                	jmp    8012c4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80129c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a0:	75 15                	jne    8012b7 <strtol+0x93>
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 30                	cmp    $0x30,%al
  8012a9:	75 0c                	jne    8012b7 <strtol+0x93>
		s++, base = 8;
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012b5:	eb 0d                	jmp    8012c4 <strtol+0xa0>
	else if (base == 0)
  8012b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012bb:	75 07                	jne    8012c4 <strtol+0xa0>
		base = 10;
  8012bd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 2f                	cmp    $0x2f,%al
  8012cb:	7e 19                	jle    8012e6 <strtol+0xc2>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 39                	cmp    $0x39,%al
  8012d4:	7f 10                	jg     8012e6 <strtol+0xc2>
			dig = *s - '0';
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 30             	sub    $0x30,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012e4:	eb 42                	jmp    801328 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	3c 60                	cmp    $0x60,%al
  8012ed:	7e 19                	jle    801308 <strtol+0xe4>
  8012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f2:	8a 00                	mov    (%eax),%al
  8012f4:	3c 7a                	cmp    $0x7a,%al
  8012f6:	7f 10                	jg     801308 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	8a 00                	mov    (%eax),%al
  8012fd:	0f be c0             	movsbl %al,%eax
  801300:	83 e8 57             	sub    $0x57,%eax
  801303:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801306:	eb 20                	jmp    801328 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	3c 40                	cmp    $0x40,%al
  80130f:	7e 39                	jle    80134a <strtol+0x126>
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	3c 5a                	cmp    $0x5a,%al
  801318:	7f 30                	jg     80134a <strtol+0x126>
			dig = *s - 'A' + 10;
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	0f be c0             	movsbl %al,%eax
  801322:	83 e8 37             	sub    $0x37,%eax
  801325:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132e:	7d 19                	jge    801349 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801330:	ff 45 08             	incl   0x8(%ebp)
  801333:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801336:	0f af 45 10          	imul   0x10(%ebp),%eax
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	01 d0                	add    %edx,%eax
  801341:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801344:	e9 7b ff ff ff       	jmp    8012c4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801349:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80134a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80134e:	74 08                	je     801358 <strtol+0x134>
		*endptr = (char *) s;
  801350:	8b 45 0c             	mov    0xc(%ebp),%eax
  801353:	8b 55 08             	mov    0x8(%ebp),%edx
  801356:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801358:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135c:	74 07                	je     801365 <strtol+0x141>
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	f7 d8                	neg    %eax
  801363:	eb 03                	jmp    801368 <strtol+0x144>
  801365:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <ltostr>:

void
ltostr(long value, char *str)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801377:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80137e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801382:	79 13                	jns    801397 <ltostr+0x2d>
	{
		neg = 1;
  801384:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80138b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801391:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801394:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80139f:	99                   	cltd   
  8013a0:	f7 f9                	idiv   %ecx
  8013a2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a8:	8d 50 01             	lea    0x1(%eax),%edx
  8013ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013ae:	89 c2                	mov    %eax,%edx
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	01 d0                	add    %edx,%eax
  8013b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013b8:	83 c2 30             	add    $0x30,%edx
  8013bb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013c5:	f7 e9                	imul   %ecx
  8013c7:	c1 fa 02             	sar    $0x2,%edx
  8013ca:	89 c8                	mov    %ecx,%eax
  8013cc:	c1 f8 1f             	sar    $0x1f,%eax
  8013cf:	29 c2                	sub    %eax,%edx
  8013d1:	89 d0                	mov    %edx,%eax
  8013d3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013da:	75 bb                	jne    801397 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e6:	48                   	dec    %eax
  8013e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013ee:	74 3d                	je     80142d <ltostr+0xc3>
		start = 1 ;
  8013f0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013f7:	eb 34                	jmp    80142d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ff:	01 d0                	add    %edx,%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801406:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 c2                	add    %eax,%edx
  80140e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 c8                	add    %ecx,%eax
  801416:	8a 00                	mov    (%eax),%al
  801418:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80141a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	01 c2                	add    %eax,%edx
  801422:	8a 45 eb             	mov    -0x15(%ebp),%al
  801425:	88 02                	mov    %al,(%edx)
		start++ ;
  801427:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80142a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80142d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801430:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801433:	7c c4                	jl     8013f9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801435:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 d0                	add    %edx,%eax
  80143d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801440:	90                   	nop
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	e8 c4 f9 ff ff       	call   800e15 <strlen>
  801451:	83 c4 04             	add    $0x4,%esp
  801454:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801457:	ff 75 0c             	pushl  0xc(%ebp)
  80145a:	e8 b6 f9 ff ff       	call   800e15 <strlen>
  80145f:	83 c4 04             	add    $0x4,%esp
  801462:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801465:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80146c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801473:	eb 17                	jmp    80148c <strcconcat+0x49>
		final[s] = str1[s] ;
  801475:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801478:	8b 45 10             	mov    0x10(%ebp),%eax
  80147b:	01 c2                	add    %eax,%edx
  80147d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801480:	8b 45 08             	mov    0x8(%ebp),%eax
  801483:	01 c8                	add    %ecx,%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801489:	ff 45 fc             	incl   -0x4(%ebp)
  80148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801492:	7c e1                	jl     801475 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801494:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80149b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014a2:	eb 1f                	jmp    8014c3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014a7:	8d 50 01             	lea    0x1(%eax),%edx
  8014aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ad:	89 c2                	mov    %eax,%edx
  8014af:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b2:	01 c2                	add    %eax,%edx
  8014b4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ba:	01 c8                	add    %ecx,%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c0:	ff 45 f8             	incl   -0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014c9:	7c d9                	jl     8014a4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d1:	01 d0                	add    %edx,%eax
  8014d3:	c6 00 00             	movb   $0x0,(%eax)
}
  8014d6:	90                   	nop
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	8b 00                	mov    (%eax),%eax
  8014ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014fc:	eb 0c                	jmp    80150a <strsplit+0x31>
			*string++ = 0;
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	8d 50 01             	lea    0x1(%eax),%edx
  801504:	89 55 08             	mov    %edx,0x8(%ebp)
  801507:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	8a 00                	mov    (%eax),%al
  80150f:	84 c0                	test   %al,%al
  801511:	74 18                	je     80152b <strsplit+0x52>
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	0f be c0             	movsbl %al,%eax
  80151b:	50                   	push   %eax
  80151c:	ff 75 0c             	pushl  0xc(%ebp)
  80151f:	e8 83 fa ff ff       	call   800fa7 <strchr>
  801524:	83 c4 08             	add    $0x8,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	75 d3                	jne    8014fe <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	8a 00                	mov    (%eax),%al
  801530:	84 c0                	test   %al,%al
  801532:	74 5a                	je     80158e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801534:	8b 45 14             	mov    0x14(%ebp),%eax
  801537:	8b 00                	mov    (%eax),%eax
  801539:	83 f8 0f             	cmp    $0xf,%eax
  80153c:	75 07                	jne    801545 <strsplit+0x6c>
		{
			return 0;
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
  801543:	eb 66                	jmp    8015ab <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801545:	8b 45 14             	mov    0x14(%ebp),%eax
  801548:	8b 00                	mov    (%eax),%eax
  80154a:	8d 48 01             	lea    0x1(%eax),%ecx
  80154d:	8b 55 14             	mov    0x14(%ebp),%edx
  801550:	89 0a                	mov    %ecx,(%edx)
  801552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801559:	8b 45 10             	mov    0x10(%ebp),%eax
  80155c:	01 c2                	add    %eax,%edx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801563:	eb 03                	jmp    801568 <strsplit+0x8f>
			string++;
  801565:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	84 c0                	test   %al,%al
  80156f:	74 8b                	je     8014fc <strsplit+0x23>
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8a 00                	mov    (%eax),%al
  801576:	0f be c0             	movsbl %al,%eax
  801579:	50                   	push   %eax
  80157a:	ff 75 0c             	pushl  0xc(%ebp)
  80157d:	e8 25 fa ff ff       	call   800fa7 <strchr>
  801582:	83 c4 08             	add    $0x8,%esp
  801585:	85 c0                	test   %eax,%eax
  801587:	74 dc                	je     801565 <strsplit+0x8c>
			string++;
	}
  801589:	e9 6e ff ff ff       	jmp    8014fc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80158e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
  80159e:	01 d0                	add    %edx,%eax
  8015a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c0:	eb 4a                	jmp    80160c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	01 c2                	add    %eax,%edx
  8015ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	01 c8                	add    %ecx,%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 40                	cmp    $0x40,%al
  8015e2:	7e 25                	jle    801609 <str2lower+0x5c>
  8015e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	3c 5a                	cmp    $0x5a,%al
  8015f0:	7f 17                	jg     801609 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	01 d0                	add    %edx,%eax
  8015fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801600:	01 ca                	add    %ecx,%edx
  801602:	8a 12                	mov    (%edx),%dl
  801604:	83 c2 20             	add    $0x20,%edx
  801607:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801609:	ff 45 fc             	incl   -0x4(%ebp)
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	e8 01 f8 ff ff       	call   800e15 <strlen>
  801614:	83 c4 04             	add    $0x4,%esp
  801617:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80161a:	7f a6                	jg     8015c2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80161c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	57                   	push   %edi
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801630:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801633:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801636:	8b 7d 18             	mov    0x18(%ebp),%edi
  801639:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80163c:	cd 30                	int    $0x30
  80163e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	5b                   	pop    %ebx
  801648:	5e                   	pop    %esi
  801649:	5f                   	pop    %edi
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801658:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	6a 00                	push   $0x0
  801664:	51                   	push   %ecx
  801665:	52                   	push   %edx
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	50                   	push   %eax
  80166a:	6a 00                	push   $0x0
  80166c:	e8 b0 ff ff ff       	call   801621 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	90                   	nop
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_cgetc>:

int
sys_cgetc(void)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 02                	push   $0x2
  801686:	e8 96 ff ff ff       	call   801621 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 03                	push   $0x3
  80169f:	e8 7d ff ff ff       	call   801621 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	90                   	nop
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 04                	push   $0x4
  8016b9:	e8 63 ff ff ff       	call   801621 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	6a 08                	push   $0x8
  8016d7:	e8 45 ff ff ff       	call   801621 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	56                   	push   %esi
  8016e5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e6:	8b 75 18             	mov    0x18(%ebp),%esi
  8016e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
  8016f7:	51                   	push   %ecx
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	6a 09                	push   $0x9
  8016fc:	e8 20 ff ff ff       	call   801621 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	6a 0a                	push   $0xa
  80171b:	e8 01 ff ff ff       	call   801621 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 0c             	pushl  0xc(%ebp)
  801731:	ff 75 08             	pushl  0x8(%ebp)
  801734:	6a 0b                	push   $0xb
  801736:	e8 e6 fe ff ff       	call   801621 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 0c                	push   $0xc
  80174f:	e8 cd fe ff ff       	call   801621 <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 0d                	push   $0xd
  801768:	e8 b4 fe ff ff       	call   801621 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 0e                	push   $0xe
  801781:	e8 9b fe ff ff       	call   801621 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 0f                	push   $0xf
  80179a:	e8 82 fe ff ff       	call   801621 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	6a 10                	push   $0x10
  8017b4:	e8 68 fe ff ff       	call   801621 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 11                	push   $0x11
  8017cd:	e8 4f fe ff ff       	call   801621 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	50                   	push   %eax
  8017f1:	6a 01                	push   $0x1
  8017f3:	e8 29 fe ff ff       	call   801621 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	90                   	nop
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 14                	push   $0x14
  80180d:	e8 0f fe ff ff       	call   801621 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	90                   	nop
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	8b 45 10             	mov    0x10(%ebp),%eax
  801821:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801824:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801827:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	51                   	push   %ecx
  801831:	52                   	push   %edx
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	6a 15                	push   $0x15
  801838:	e8 e4 fd ff ff       	call   801621 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	52                   	push   %edx
  801852:	50                   	push   %eax
  801853:	6a 16                	push   $0x16
  801855:	e8 c7 fd ff ff       	call   801621 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801862:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801865:	8b 55 0c             	mov    0xc(%ebp),%edx
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	51                   	push   %ecx
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 17                	push   $0x17
  801874:	e8 a8 fd ff ff       	call   801621 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801881:	8b 55 0c             	mov    0xc(%ebp),%edx
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 18                	push   $0x18
  801891:	e8 8b fd ff ff       	call   801621 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 14             	pushl  0x14(%ebp)
  8018a6:	ff 75 10             	pushl  0x10(%ebp)
  8018a9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ac:	50                   	push   %eax
  8018ad:	6a 19                	push   $0x19
  8018af:	e8 6d fd ff ff       	call   801621 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	50                   	push   %eax
  8018c8:	6a 1a                	push   $0x1a
  8018ca:	e8 52 fd ff ff       	call   801621 <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	90                   	nop
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	50                   	push   %eax
  8018e4:	6a 1b                	push   $0x1b
  8018e6:	e8 36 fd ff ff       	call   801621 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 05                	push   $0x5
  8018ff:	e8 1d fd ff ff       	call   801621 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 06                	push   $0x6
  801918:	e8 04 fd ff ff       	call   801621 <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 07                	push   $0x7
  801931:	e8 eb fc ff ff       	call   801621 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_exit_env>:


void sys_exit_env(void)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 1c                	push   $0x1c
  80194a:	e8 d2 fc ff ff       	call   801621 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	90                   	nop
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80195b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195e:	8d 50 04             	lea    0x4(%eax),%edx
  801961:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 1d                	push   $0x1d
  80196e:	e8 ae fc ff ff       	call   801621 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
	return result;
  801976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801979:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80197f:	89 01                	mov    %eax,(%ecx)
  801981:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	c9                   	leave  
  801988:	c2 04 00             	ret    $0x4

0080198b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 10             	pushl  0x10(%ebp)
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 13                	push   $0x13
  80199d:	e8 7f fc ff ff       	call   801621 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a5:	90                   	nop
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 1e                	push   $0x1e
  8019b7:	e8 65 fc ff ff       	call   801621 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019cd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	50                   	push   %eax
  8019da:	6a 1f                	push   $0x1f
  8019dc:	e8 40 fc ff ff       	call   801621 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e4:	90                   	nop
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <rsttst>:
void rsttst()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 21                	push   $0x21
  8019f6:	e8 26 fc ff ff       	call   801621 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a0d:	8b 55 18             	mov    0x18(%ebp),%edx
  801a10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 20                	push   $0x20
  801a21:	e8 fb fb ff ff       	call   801621 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <chktst>:
void chktst(uint32 n)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 22                	push   $0x22
  801a3c:	e8 e0 fb ff ff       	call   801621 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <inctst>:

void inctst()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 23                	push   $0x23
  801a56:	e8 c6 fb ff ff       	call   801621 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5e:	90                   	nop
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <gettst>:
uint32 gettst()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 24                	push   $0x24
  801a70:	e8 ac fb ff ff       	call   801621 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 25                	push   $0x25
  801a89:	e8 93 fb ff ff       	call   801621 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
  801a91:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a96:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	6a 26                	push   $0x26
  801ab5:	e8 67 fb ff ff       	call   801621 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
	return ;
  801abd:	90                   	nop
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	53                   	push   %ebx
  801ad3:	51                   	push   %ecx
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 27                	push   $0x27
  801ad8:	e8 44 fb ff ff       	call   801621 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 28                	push   $0x28
  801af8:	e8 24 fb ff ff       	call   801621 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b05:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	51                   	push   %ecx
  801b11:	ff 75 10             	pushl  0x10(%ebp)
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 29                	push   $0x29
  801b18:	e8 04 fb ff ff       	call   801621 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	ff 75 10             	pushl  0x10(%ebp)
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	6a 12                	push   $0x12
  801b34:	e8 e8 fa ff ff       	call   801621 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3c:	90                   	nop
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 2a                	push   $0x2a
  801b52:	e8 ca fa ff ff       	call   801621 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 2b                	push   $0x2b
  801b6c:	e8 b0 fa ff ff       	call   801621 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 2d                	push   $0x2d
  801b87:	e8 95 fa ff ff       	call   801621 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 2c                	push   $0x2c
  801ba3:	e8 79 fa ff ff       	call   801621 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	68 48 27 80 00       	push   $0x802748
  801bbc:	68 25 01 00 00       	push   $0x125
  801bc1:	68 7b 27 80 00       	push   $0x80277b
  801bc6:	e8 a3 e8 ff ff       	call   80046e <_panic>
  801bcb:	90                   	nop

00801bcc <__udivdi3>:
  801bcc:	55                   	push   %ebp
  801bcd:	57                   	push   %edi
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 1c             	sub    $0x1c,%esp
  801bd3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bd7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bdf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801be3:	89 ca                	mov    %ecx,%edx
  801be5:	89 f8                	mov    %edi,%eax
  801be7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801beb:	85 f6                	test   %esi,%esi
  801bed:	75 2d                	jne    801c1c <__udivdi3+0x50>
  801bef:	39 cf                	cmp    %ecx,%edi
  801bf1:	77 65                	ja     801c58 <__udivdi3+0x8c>
  801bf3:	89 fd                	mov    %edi,%ebp
  801bf5:	85 ff                	test   %edi,%edi
  801bf7:	75 0b                	jne    801c04 <__udivdi3+0x38>
  801bf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfe:	31 d2                	xor    %edx,%edx
  801c00:	f7 f7                	div    %edi
  801c02:	89 c5                	mov    %eax,%ebp
  801c04:	31 d2                	xor    %edx,%edx
  801c06:	89 c8                	mov    %ecx,%eax
  801c08:	f7 f5                	div    %ebp
  801c0a:	89 c1                	mov    %eax,%ecx
  801c0c:	89 d8                	mov    %ebx,%eax
  801c0e:	f7 f5                	div    %ebp
  801c10:	89 cf                	mov    %ecx,%edi
  801c12:	89 fa                	mov    %edi,%edx
  801c14:	83 c4 1c             	add    $0x1c,%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5f                   	pop    %edi
  801c1a:	5d                   	pop    %ebp
  801c1b:	c3                   	ret    
  801c1c:	39 ce                	cmp    %ecx,%esi
  801c1e:	77 28                	ja     801c48 <__udivdi3+0x7c>
  801c20:	0f bd fe             	bsr    %esi,%edi
  801c23:	83 f7 1f             	xor    $0x1f,%edi
  801c26:	75 40                	jne    801c68 <__udivdi3+0x9c>
  801c28:	39 ce                	cmp    %ecx,%esi
  801c2a:	72 0a                	jb     801c36 <__udivdi3+0x6a>
  801c2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c30:	0f 87 9e 00 00 00    	ja     801cd4 <__udivdi3+0x108>
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	89 fa                	mov    %edi,%edx
  801c3d:	83 c4 1c             	add    $0x1c,%esp
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    
  801c45:	8d 76 00             	lea    0x0(%esi),%esi
  801c48:	31 ff                	xor    %edi,%edi
  801c4a:	31 c0                	xor    %eax,%eax
  801c4c:	89 fa                	mov    %edi,%edx
  801c4e:	83 c4 1c             	add    $0x1c,%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5f                   	pop    %edi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	89 d8                	mov    %ebx,%eax
  801c5a:	f7 f7                	div    %edi
  801c5c:	31 ff                	xor    %edi,%edi
  801c5e:	89 fa                	mov    %edi,%edx
  801c60:	83 c4 1c             	add    $0x1c,%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5f                   	pop    %edi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    
  801c68:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c6d:	89 eb                	mov    %ebp,%ebx
  801c6f:	29 fb                	sub    %edi,%ebx
  801c71:	89 f9                	mov    %edi,%ecx
  801c73:	d3 e6                	shl    %cl,%esi
  801c75:	89 c5                	mov    %eax,%ebp
  801c77:	88 d9                	mov    %bl,%cl
  801c79:	d3 ed                	shr    %cl,%ebp
  801c7b:	89 e9                	mov    %ebp,%ecx
  801c7d:	09 f1                	or     %esi,%ecx
  801c7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c83:	89 f9                	mov    %edi,%ecx
  801c85:	d3 e0                	shl    %cl,%eax
  801c87:	89 c5                	mov    %eax,%ebp
  801c89:	89 d6                	mov    %edx,%esi
  801c8b:	88 d9                	mov    %bl,%cl
  801c8d:	d3 ee                	shr    %cl,%esi
  801c8f:	89 f9                	mov    %edi,%ecx
  801c91:	d3 e2                	shl    %cl,%edx
  801c93:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c97:	88 d9                	mov    %bl,%cl
  801c99:	d3 e8                	shr    %cl,%eax
  801c9b:	09 c2                	or     %eax,%edx
  801c9d:	89 d0                	mov    %edx,%eax
  801c9f:	89 f2                	mov    %esi,%edx
  801ca1:	f7 74 24 0c          	divl   0xc(%esp)
  801ca5:	89 d6                	mov    %edx,%esi
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	f7 e5                	mul    %ebp
  801cab:	39 d6                	cmp    %edx,%esi
  801cad:	72 19                	jb     801cc8 <__udivdi3+0xfc>
  801caf:	74 0b                	je     801cbc <__udivdi3+0xf0>
  801cb1:	89 d8                	mov    %ebx,%eax
  801cb3:	31 ff                	xor    %edi,%edi
  801cb5:	e9 58 ff ff ff       	jmp    801c12 <__udivdi3+0x46>
  801cba:	66 90                	xchg   %ax,%ax
  801cbc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cc0:	89 f9                	mov    %edi,%ecx
  801cc2:	d3 e2                	shl    %cl,%edx
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 e9                	jae    801cb1 <__udivdi3+0xe5>
  801cc8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ccb:	31 ff                	xor    %edi,%edi
  801ccd:	e9 40 ff ff ff       	jmp    801c12 <__udivdi3+0x46>
  801cd2:	66 90                	xchg   %ax,%ax
  801cd4:	31 c0                	xor    %eax,%eax
  801cd6:	e9 37 ff ff ff       	jmp    801c12 <__udivdi3+0x46>
  801cdb:	90                   	nop

00801cdc <__umoddi3>:
  801cdc:	55                   	push   %ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 1c             	sub    $0x1c,%esp
  801ce3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ce7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ceb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cfb:	89 f3                	mov    %esi,%ebx
  801cfd:	89 fa                	mov    %edi,%edx
  801cff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d03:	89 34 24             	mov    %esi,(%esp)
  801d06:	85 c0                	test   %eax,%eax
  801d08:	75 1a                	jne    801d24 <__umoddi3+0x48>
  801d0a:	39 f7                	cmp    %esi,%edi
  801d0c:	0f 86 a2 00 00 00    	jbe    801db4 <__umoddi3+0xd8>
  801d12:	89 c8                	mov    %ecx,%eax
  801d14:	89 f2                	mov    %esi,%edx
  801d16:	f7 f7                	div    %edi
  801d18:	89 d0                	mov    %edx,%eax
  801d1a:	31 d2                	xor    %edx,%edx
  801d1c:	83 c4 1c             	add    $0x1c,%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    
  801d24:	39 f0                	cmp    %esi,%eax
  801d26:	0f 87 ac 00 00 00    	ja     801dd8 <__umoddi3+0xfc>
  801d2c:	0f bd e8             	bsr    %eax,%ebp
  801d2f:	83 f5 1f             	xor    $0x1f,%ebp
  801d32:	0f 84 ac 00 00 00    	je     801de4 <__umoddi3+0x108>
  801d38:	bf 20 00 00 00       	mov    $0x20,%edi
  801d3d:	29 ef                	sub    %ebp,%edi
  801d3f:	89 fe                	mov    %edi,%esi
  801d41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 e0                	shl    %cl,%eax
  801d49:	89 d7                	mov    %edx,%edi
  801d4b:	89 f1                	mov    %esi,%ecx
  801d4d:	d3 ef                	shr    %cl,%edi
  801d4f:	09 c7                	or     %eax,%edi
  801d51:	89 e9                	mov    %ebp,%ecx
  801d53:	d3 e2                	shl    %cl,%edx
  801d55:	89 14 24             	mov    %edx,(%esp)
  801d58:	89 d8                	mov    %ebx,%eax
  801d5a:	d3 e0                	shl    %cl,%eax
  801d5c:	89 c2                	mov    %eax,%edx
  801d5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d62:	d3 e0                	shl    %cl,%eax
  801d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d6c:	89 f1                	mov    %esi,%ecx
  801d6e:	d3 e8                	shr    %cl,%eax
  801d70:	09 d0                	or     %edx,%eax
  801d72:	d3 eb                	shr    %cl,%ebx
  801d74:	89 da                	mov    %ebx,%edx
  801d76:	f7 f7                	div    %edi
  801d78:	89 d3                	mov    %edx,%ebx
  801d7a:	f7 24 24             	mull   (%esp)
  801d7d:	89 c6                	mov    %eax,%esi
  801d7f:	89 d1                	mov    %edx,%ecx
  801d81:	39 d3                	cmp    %edx,%ebx
  801d83:	0f 82 87 00 00 00    	jb     801e10 <__umoddi3+0x134>
  801d89:	0f 84 91 00 00 00    	je     801e20 <__umoddi3+0x144>
  801d8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d93:	29 f2                	sub    %esi,%edx
  801d95:	19 cb                	sbb    %ecx,%ebx
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d9d:	d3 e0                	shl    %cl,%eax
  801d9f:	89 e9                	mov    %ebp,%ecx
  801da1:	d3 ea                	shr    %cl,%edx
  801da3:	09 d0                	or     %edx,%eax
  801da5:	89 e9                	mov    %ebp,%ecx
  801da7:	d3 eb                	shr    %cl,%ebx
  801da9:	89 da                	mov    %ebx,%edx
  801dab:	83 c4 1c             	add    $0x1c,%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	5d                   	pop    %ebp
  801db2:	c3                   	ret    
  801db3:	90                   	nop
  801db4:	89 fd                	mov    %edi,%ebp
  801db6:	85 ff                	test   %edi,%edi
  801db8:	75 0b                	jne    801dc5 <__umoddi3+0xe9>
  801dba:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbf:	31 d2                	xor    %edx,%edx
  801dc1:	f7 f7                	div    %edi
  801dc3:	89 c5                	mov    %eax,%ebp
  801dc5:	89 f0                	mov    %esi,%eax
  801dc7:	31 d2                	xor    %edx,%edx
  801dc9:	f7 f5                	div    %ebp
  801dcb:	89 c8                	mov    %ecx,%eax
  801dcd:	f7 f5                	div    %ebp
  801dcf:	89 d0                	mov    %edx,%eax
  801dd1:	e9 44 ff ff ff       	jmp    801d1a <__umoddi3+0x3e>
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	89 c8                	mov    %ecx,%eax
  801dda:	89 f2                	mov    %esi,%edx
  801ddc:	83 c4 1c             	add    $0x1c,%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5f                   	pop    %edi
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    
  801de4:	3b 04 24             	cmp    (%esp),%eax
  801de7:	72 06                	jb     801def <__umoddi3+0x113>
  801de9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ded:	77 0f                	ja     801dfe <__umoddi3+0x122>
  801def:	89 f2                	mov    %esi,%edx
  801df1:	29 f9                	sub    %edi,%ecx
  801df3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801df7:	89 14 24             	mov    %edx,(%esp)
  801dfa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dfe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e02:	8b 14 24             	mov    (%esp),%edx
  801e05:	83 c4 1c             	add    $0x1c,%esp
  801e08:	5b                   	pop    %ebx
  801e09:	5e                   	pop    %esi
  801e0a:	5f                   	pop    %edi
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	2b 04 24             	sub    (%esp),%eax
  801e13:	19 fa                	sbb    %edi,%edx
  801e15:	89 d1                	mov    %edx,%ecx
  801e17:	89 c6                	mov    %eax,%esi
  801e19:	e9 71 ff ff ff       	jmp    801d8f <__umoddi3+0xb3>
  801e1e:	66 90                	xchg   %ax,%ax
  801e20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e24:	72 ea                	jb     801e10 <__umoddi3+0x134>
  801e26:	89 d9                	mov    %ebx,%ecx
  801e28:	e9 62 ff ff ff       	jmp    801d8f <__umoddi3+0xb3>
