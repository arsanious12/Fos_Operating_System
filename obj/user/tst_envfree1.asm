
obj/user/tst_envfree1:     file format elf32-i386


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
  800031:	e8 c1 02 00 00       	call   8002f7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests environment free run tef1 5 3
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	rsttst();
  800044:	e8 ec 19 00 00       	call   801a35 <rsttst>
	// Testing scenario 1: without using dynamic allocation/de-allocation, shared variables and semaphores
	// Testing removing the allocated pages in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800049:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80004f:	bb a1 20 80 00       	mov    $0x8020a1,%ebx
  800054:	ba 05 00 00 00       	mov    $0x5,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800061:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800067:	b9 14 00 00 00       	mov    $0x14,%ecx
  80006c:	b8 00 00 00 00       	mov    $0x0,%eax
  800071:	89 d7                	mov    %edx,%edi
  800073:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800075:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	50                   	push   %eax
  80007f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800085:	50                   	push   %eax
  800086:	e8 02 1b 00 00       	call   801b8d <sys_utilities>
  80008b:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  80008e:	e8 fb 16 00 00       	call   80178e <sys_calculate_free_frames>
  800093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800096:	e8 3e 17 00 00       	call   8017d9 <sys_pf_calculate_allocated_pages>
  80009b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80009e:	83 ec 08             	sub    $0x8,%esp
  8000a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a4:	68 80 1e 80 00       	push   $0x801e80
  8000a9:	e8 dc 06 00 00       	call   80078a <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes

	int32 envIdProcessA = sys_create_env("sc_fib_recursive", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000b1:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b6:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000bc:	89 c2                	mov    %eax,%edx
  8000be:	a1 20 30 80 00       	mov    0x803020,%eax
  8000c3:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c9:	6a 32                	push   $0x32
  8000cb:	52                   	push   %edx
  8000cc:	50                   	push   %eax
  8000cd:	68 b3 1e 80 00       	push   $0x801eb3
  8000d2:	e8 12 18 00 00       	call   8018e9 <sys_create_env>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_fact_recursive", (myEnv->page_WS_max_size)*4,(myEnv->SecondListSize), 50);
  8000dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e2:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ef:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f5:	c1 e0 02             	shl    $0x2,%eax
  8000f8:	6a 32                	push   $0x32
  8000fa:	52                   	push   %edx
  8000fb:	50                   	push   %eax
  8000fc:	68 c4 1e 80 00       	push   $0x801ec4
  800101:	e8 e3 17 00 00       	call   8018e9 <sys_create_env>
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessC = sys_create_env("sc_fos_add",(myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800117:	89 c2                	mov    %eax,%edx
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 d6 1e 80 00       	push   $0x801ed6
  80012d:	e8 b7 17 00 00       	call   8018e9 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//Run 3 processes
	sys_run_env(envIdProcessA);
  800138:	83 ec 0c             	sub    $0xc,%esp
  80013b:	ff 75 dc             	pushl  -0x24(%ebp)
  80013e:	e8 c4 17 00 00       	call   801907 <sys_run_env>
  800143:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	ff 75 d8             	pushl  -0x28(%ebp)
  80014c:	e8 b6 17 00 00       	call   801907 <sys_run_env>
  800151:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessC);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	ff 75 d4             	pushl  -0x2c(%ebp)
  80015a:	e8 a8 17 00 00       	call   801907 <sys_run_env>
  80015f:	83 c4 10             	add    $0x10,%esp

	//env_sleep(6000);
	while (gettst() != 3) ;
  800162:	90                   	nop
  800163:	e8 47 19 00 00       	call   801aaf <gettst>
  800168:	83 f8 03             	cmp    $0x3,%eax
  80016b:	75 f6                	jne    800163 <_main+0x12b>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  80016d:	e8 1c 16 00 00       	call   80178e <sys_calculate_free_frames>
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	50                   	push   %eax
  800176:	68 e4 1e 80 00       	push   $0x801ee4
  80017b:	e8 0a 06 00 00       	call   80078a <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800183:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	50                   	push   %eax
  80018d:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	e8 f4 19 00 00       	call   801b8d <sys_utilities>
  800199:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  80019c:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001a2:	bb 05 21 80 00       	mov    $0x802105,%ebx
  8001a7:	ba 1a 00 00 00       	mov    $0x1a,%edx
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 de                	mov    %ebx,%esi
  8001b0:	89 d1                	mov    %edx,%ecx
  8001b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b4:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  8001ba:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  8001bf:	b0 00                	mov    $0x0,%al
  8001c1:	89 d7                	mov    %edx,%edi
  8001c3:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	6a 00                	push   $0x0
  8001ca:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 b7 19 00 00       	call   801b8d <sys_utilities>
  8001d6:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8001df:	e8 3f 17 00 00       	call   801923 <sys_destroy_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ed:	e8 31 17 00 00       	call   801923 <sys_destroy_env>
  8001f2:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessC);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001fb:	e8 23 17 00 00       	call   801923 <sys_destroy_env>
  800200:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	6a 01                	push   $0x1
  800208:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	e8 79 19 00 00       	call   801b8d <sys_utilities>
  800214:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800217:	e8 72 15 00 00       	call   80178e <sys_calculate_free_frames>
  80021c:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  80021f:	e8 b5 15 00 00       	call   8017d9 <sys_pf_calculate_allocated_pages>
  800224:	89 45 cc             	mov    %eax,-0x34(%ebp)

	cprintf("\n---# of free frames after KILLING programs = %d\n", sys_calculate_free_frames());
  800227:	e8 62 15 00 00       	call   80178e <sys_calculate_free_frames>
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 18 1f 80 00       	push   $0x801f18
  800235:	e8 50 05 00 00       	call   80078a <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80023d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  800244:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80024a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	48                   	dec    %eax
  800250:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800253:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800256:	ba 00 00 00 00       	mov    $0x0,%edx
  80025b:	f7 75 c8             	divl   -0x38(%ebp)
  80025e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800261:	29 d0                	sub    %edx,%eax
  800263:	89 c1                	mov    %eax,%ecx
  800265:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  80026c:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800272:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	48                   	dec    %eax
  800278:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80027b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80027e:	ba 00 00 00 00       	mov    $0x0,%edx
  800283:	f7 75 c0             	divl   -0x40(%ebp)
  800286:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800289:	29 d0                	sub    %edx,%eax
  80028b:	29 c1                	sub    %eax,%ecx
  80028d:	89 c8                	mov    %ecx,%eax
  80028f:	c1 e8 0c             	shr    $0xc,%eax
  800292:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if ((freeFrames_before - freeFrames_after) != expected) {
  800295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800298:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80029b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80029e:	74 2e                	je     8002ce <_main+0x296>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  8002a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002a3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002a6:	ff 75 b8             	pushl  -0x48(%ebp)
  8002a9:	50                   	push   %eax
  8002aa:	ff 75 d0             	pushl  -0x30(%ebp)
  8002ad:	68 4c 1f 80 00       	push   $0x801f4c
  8002b2:	e8 d3 04 00 00       	call   80078a <cprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 bc 1f 80 00       	push   $0x801fbc
  8002c2:	6a 3e                	push   $0x3e
  8002c4:	68 f2 1f 80 00       	push   $0x801ff2
  8002c9:	e8 ee 01 00 00       	call   8004bc <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected\n");
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	68 08 20 80 00       	push   $0x802008
  8002d6:	e8 af 04 00 00       	call   80078a <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 1 for envfree completed successfully.\n");
  8002de:	83 ec 0c             	sub    $0xc,%esp
  8002e1:	68 58 20 80 00       	push   $0x802058
  8002e6:	e8 9f 04 00 00       	call   80078a <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
	return;
  8002ee:	90                   	nop
}
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	57                   	push   %edi
  8002fb:	56                   	push   %esi
  8002fc:	53                   	push   %ebx
  8002fd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800300:	e8 52 16 00 00       	call   801957 <sys_getenvindex>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800308:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	c1 e0 06             	shl    $0x6,%eax
  800310:	29 d0                	sub    %edx,%eax
  800312:	c1 e0 02             	shl    $0x2,%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031e:	01 c8                	add    %ecx,%eax
  800320:	c1 e0 03             	shl    $0x3,%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032c:	29 c2                	sub    %eax,%edx
  80032e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800335:	89 c2                	mov    %eax,%edx
  800337:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80033d:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800342:	a1 20 30 80 00       	mov    0x803020,%eax
  800347:	8a 40 20             	mov    0x20(%eax),%al
  80034a:	84 c0                	test   %al,%al
  80034c:	74 0d                	je     80035b <libmain+0x64>
		binaryname = myEnv->prog_name;
  80034e:	a1 20 30 80 00       	mov    0x803020,%eax
  800353:	83 c0 20             	add    $0x20,%eax
  800356:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80035b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80035f:	7e 0a                	jle    80036b <libmain+0x74>
		binaryname = argv[0];
  800361:	8b 45 0c             	mov    0xc(%ebp),%eax
  800364:	8b 00                	mov    (%eax),%eax
  800366:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80036b:	83 ec 08             	sub    $0x8,%esp
  80036e:	ff 75 0c             	pushl  0xc(%ebp)
  800371:	ff 75 08             	pushl  0x8(%ebp)
  800374:	e8 bf fc ff ff       	call   800038 <_main>
  800379:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80037c:	a1 00 30 80 00       	mov    0x803000,%eax
  800381:	85 c0                	test   %eax,%eax
  800383:	0f 84 01 01 00 00    	je     80048a <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800389:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80038f:	bb 64 22 80 00       	mov    $0x802264,%ebx
  800394:	ba 0e 00 00 00       	mov    $0xe,%edx
  800399:	89 c7                	mov    %eax,%edi
  80039b:	89 de                	mov    %ebx,%esi
  80039d:	89 d1                	mov    %edx,%ecx
  80039f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003a1:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003a4:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003a9:	b0 00                	mov    $0x0,%al
  8003ab:	89 d7                	mov    %edx,%edi
  8003ad:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	50                   	push   %eax
  8003bd:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c3:	50                   	push   %eax
  8003c4:	e8 c4 17 00 00       	call   801b8d <sys_utilities>
  8003c9:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8003cc:	e8 0d 13 00 00       	call   8016de <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	68 84 21 80 00       	push   $0x802184
  8003d9:	e8 ac 03 00 00       	call   80078a <cprintf>
  8003de:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8003e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	74 18                	je     800400 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003e8:	e8 be 17 00 00       	call   801bab <sys_get_optimal_num_faults>
  8003ed:	83 ec 08             	sub    $0x8,%esp
  8003f0:	50                   	push   %eax
  8003f1:	68 ac 21 80 00       	push   $0x8021ac
  8003f6:	e8 8f 03 00 00       	call   80078a <cprintf>
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	eb 59                	jmp    800459 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800400:	a1 20 30 80 00       	mov    0x803020,%eax
  800405:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	52                   	push   %edx
  80041a:	50                   	push   %eax
  80041b:	68 d0 21 80 00       	push   $0x8021d0
  800420:	e8 65 03 00 00       	call   80078a <cprintf>
  800425:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800428:	a1 20 30 80 00       	mov    0x803020,%eax
  80042d:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80043e:	a1 20 30 80 00       	mov    0x803020,%eax
  800443:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800449:	51                   	push   %ecx
  80044a:	52                   	push   %edx
  80044b:	50                   	push   %eax
  80044c:	68 f8 21 80 00       	push   $0x8021f8
  800451:	e8 34 03 00 00       	call   80078a <cprintf>
  800456:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800459:	a1 20 30 80 00       	mov    0x803020,%eax
  80045e:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 50 22 80 00       	push   $0x802250
  80046d:	e8 18 03 00 00       	call   80078a <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	68 84 21 80 00       	push   $0x802184
  80047d:	e8 08 03 00 00       	call   80078a <cprintf>
  800482:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800485:	e8 6e 12 00 00       	call   8016f8 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80048a:	e8 1f 00 00 00       	call   8004ae <exit>
}
  80048f:	90                   	nop
  800490:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800493:	5b                   	pop    %ebx
  800494:	5e                   	pop    %esi
  800495:	5f                   	pop    %edi
  800496:	5d                   	pop    %ebp
  800497:	c3                   	ret    

00800498 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800498:	55                   	push   %ebp
  800499:	89 e5                	mov    %esp,%ebp
  80049b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049e:	83 ec 0c             	sub    $0xc,%esp
  8004a1:	6a 00                	push   $0x0
  8004a3:	e8 7b 14 00 00       	call   801923 <sys_destroy_env>
  8004a8:	83 c4 10             	add    $0x10,%esp
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <exit>:

void
exit(void)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b4:	e8 d0 14 00 00       	call   801989 <sys_exit_env>
}
  8004b9:	90                   	nop
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c5:	83 c0 04             	add    $0x4,%eax
  8004c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004cb:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004d0:	85 c0                	test   %eax,%eax
  8004d2:	74 16                	je     8004ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d4:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	50                   	push   %eax
  8004dd:	68 c8 22 80 00       	push   $0x8022c8
  8004e2:	e8 a3 02 00 00       	call   80078a <cprintf>
  8004e7:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8004ef:	83 ec 0c             	sub    $0xc,%esp
  8004f2:	ff 75 0c             	pushl  0xc(%ebp)
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	68 d0 22 80 00       	push   $0x8022d0
  8004fe:	6a 74                	push   $0x74
  800500:	e8 b2 02 00 00       	call   8007b7 <cprintf_colored>
  800505:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800508:	8b 45 10             	mov    0x10(%ebp),%eax
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 f4             	pushl  -0xc(%ebp)
  800511:	50                   	push   %eax
  800512:	e8 04 02 00 00       	call   80071b <vcprintf>
  800517:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	6a 00                	push   $0x0
  80051f:	68 f8 22 80 00       	push   $0x8022f8
  800524:	e8 f2 01 00 00       	call   80071b <vcprintf>
  800529:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80052c:	e8 7d ff ff ff       	call   8004ae <exit>

	// should not return here
	while (1) ;
  800531:	eb fe                	jmp    800531 <_panic+0x75>

00800533 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800539:	a1 20 30 80 00       	mov    0x803020,%eax
  80053e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800544:	8b 45 0c             	mov    0xc(%ebp),%eax
  800547:	39 c2                	cmp    %eax,%edx
  800549:	74 14                	je     80055f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	68 fc 22 80 00       	push   $0x8022fc
  800553:	6a 26                	push   $0x26
  800555:	68 48 23 80 00       	push   $0x802348
  80055a:	e8 5d ff ff ff       	call   8004bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80055f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800566:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056d:	e9 c5 00 00 00       	jmp    800637 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800575:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	01 d0                	add    %edx,%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	85 c0                	test   %eax,%eax
  800585:	75 08                	jne    80058f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800587:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80058a:	e9 a5 00 00 00       	jmp    800634 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80058f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800596:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80059d:	eb 69                	jmp    800608 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80059f:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ad:	89 d0                	mov    %edx,%eax
  8005af:	01 c0                	add    %eax,%eax
  8005b1:	01 d0                	add    %edx,%eax
  8005b3:	c1 e0 03             	shl    $0x3,%eax
  8005b6:	01 c8                	add    %ecx,%eax
  8005b8:	8a 40 04             	mov    0x4(%eax),%al
  8005bb:	84 c0                	test   %al,%al
  8005bd:	75 46                	jne    800605 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bf:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c4:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005cd:	89 d0                	mov    %edx,%eax
  8005cf:	01 c0                	add    %eax,%eax
  8005d1:	01 d0                	add    %edx,%eax
  8005d3:	c1 e0 03             	shl    $0x3,%eax
  8005d6:	01 c8                	add    %ecx,%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	01 c8                	add    %ecx,%eax
  8005f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f8:	39 c2                	cmp    %eax,%edx
  8005fa:	75 09                	jne    800605 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800603:	eb 15                	jmp    80061a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800605:	ff 45 e8             	incl   -0x18(%ebp)
  800608:	a1 20 30 80 00       	mov    0x803020,%eax
  80060d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800616:	39 c2                	cmp    %eax,%edx
  800618:	77 85                	ja     80059f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80061a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80061e:	75 14                	jne    800634 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800620:	83 ec 04             	sub    $0x4,%esp
  800623:	68 54 23 80 00       	push   $0x802354
  800628:	6a 3a                	push   $0x3a
  80062a:	68 48 23 80 00       	push   $0x802348
  80062f:	e8 88 fe ff ff       	call   8004bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800634:	ff 45 f0             	incl   -0x10(%ebp)
  800637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80063d:	0f 8c 2f ff ff ff    	jl     800572 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800643:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 26                	jmp    800679 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800653:	a1 20 30 80 00       	mov    0x803020,%eax
  800658:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8a 40 04             	mov    0x4(%eax),%al
  80066f:	3c 01                	cmp    $0x1,%al
  800671:	75 03                	jne    800676 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800673:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800676:	ff 45 e0             	incl   -0x20(%ebp)
  800679:	a1 20 30 80 00       	mov    0x803020,%eax
  80067e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	39 c2                	cmp    %eax,%edx
  800689:	77 c8                	ja     800653 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80068b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80068e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800691:	74 14                	je     8006a7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800693:	83 ec 04             	sub    $0x4,%esp
  800696:	68 a8 23 80 00       	push   $0x8023a8
  80069b:	6a 44                	push   $0x44
  80069d:	68 48 23 80 00       	push   $0x802348
  8006a2:	e8 15 fe ff ff       	call   8004bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006a7:	90                   	nop
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	53                   	push   %ebx
  8006ae:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b4:	8b 00                	mov    (%eax),%eax
  8006b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bc:	89 0a                	mov    %ecx,(%edx)
  8006be:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c1:	88 d1                	mov    %dl,%cl
  8006c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006d4:	75 30                	jne    800706 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8006d6:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006dc:	a0 44 30 80 00       	mov    0x803044,%al
  8006e1:	0f b6 c0             	movzbl %al,%eax
  8006e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006e7:	8b 09                	mov    (%ecx),%ecx
  8006e9:	89 cb                	mov    %ecx,%ebx
  8006eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006ee:	83 c1 08             	add    $0x8,%ecx
  8006f1:	52                   	push   %edx
  8006f2:	50                   	push   %eax
  8006f3:	53                   	push   %ebx
  8006f4:	51                   	push   %ecx
  8006f5:	e8 a0 0f 00 00       	call   80169a <sys_cputs>
  8006fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800706:	8b 45 0c             	mov    0xc(%ebp),%eax
  800709:	8b 40 04             	mov    0x4(%eax),%eax
  80070c:	8d 50 01             	lea    0x1(%eax),%edx
  80070f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800712:	89 50 04             	mov    %edx,0x4(%eax)
}
  800715:	90                   	nop
  800716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800719:	c9                   	leave  
  80071a:	c3                   	ret    

0080071b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071b:	55                   	push   %ebp
  80071c:	89 e5                	mov    %esp,%ebp
  80071e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800724:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072b:	00 00 00 
	b.cnt = 0;
  80072e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800735:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	ff 75 08             	pushl  0x8(%ebp)
  80073e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	68 aa 06 80 00       	push   $0x8006aa
  80074a:	e8 5a 02 00 00       	call   8009a9 <vprintfmt>
  80074f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800752:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800758:	a0 44 30 80 00       	mov    0x803044,%al
  80075d:	0f b6 c0             	movzbl %al,%eax
  800760:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800766:	52                   	push   %edx
  800767:	50                   	push   %eax
  800768:	51                   	push   %ecx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 22 0f 00 00       	call   80169a <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 6f ff ff ff       	call   80071b <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007bd:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	c1 e0 08             	shl    $0x8,%eax
  8007ca:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8007cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d2:	83 c0 04             	add    $0x4,%eax
  8007d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 34 ff ff ff       	call   80071b <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007ed:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  8007f4:	07 00 00 

	return cnt;
  8007f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800802:	e8 d7 0e 00 00       	call   8016de <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800807:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 f4             	pushl  -0xc(%ebp)
  800816:	50                   	push   %eax
  800817:	e8 ff fe ff ff       	call   80071b <vcprintf>
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800822:	e8 d1 0e 00 00       	call   8016f8 <sys_unlock_cons>
	return cnt;
  800827:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082a:	c9                   	leave  
  80082b:	c3                   	ret    

0080082c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	53                   	push   %ebx
  800830:	83 ec 14             	sub    $0x14,%esp
  800833:	8b 45 10             	mov    0x10(%ebp),%eax
  800836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800839:	8b 45 14             	mov    0x14(%ebp),%eax
  80083c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80083f:	8b 45 18             	mov    0x18(%ebp),%eax
  800842:	ba 00 00 00 00       	mov    $0x0,%edx
  800847:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084a:	77 55                	ja     8008a1 <printnum+0x75>
  80084c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084f:	72 05                	jb     800856 <printnum+0x2a>
  800851:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800854:	77 4b                	ja     8008a1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800856:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800859:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80085c:	8b 45 18             	mov    0x18(%ebp),%eax
  80085f:	ba 00 00 00 00       	mov    $0x0,%edx
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	ff 75 f4             	pushl  -0xc(%ebp)
  800869:	ff 75 f0             	pushl  -0x10(%ebp)
  80086c:	e8 ab 13 00 00       	call   801c1c <__udivdi3>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	83 ec 04             	sub    $0x4,%esp
  800877:	ff 75 20             	pushl  0x20(%ebp)
  80087a:	53                   	push   %ebx
  80087b:	ff 75 18             	pushl  0x18(%ebp)
  80087e:	52                   	push   %edx
  80087f:	50                   	push   %eax
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	ff 75 08             	pushl  0x8(%ebp)
  800886:	e8 a1 ff ff ff       	call   80082c <printnum>
  80088b:	83 c4 20             	add    $0x20,%esp
  80088e:	eb 1a                	jmp    8008aa <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800890:	83 ec 08             	sub    $0x8,%esp
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	ff 75 20             	pushl  0x20(%ebp)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	ff d0                	call   *%eax
  80089e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a1:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008a8:	7f e6                	jg     800890 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008aa:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b8:	53                   	push   %ebx
  8008b9:	51                   	push   %ecx
  8008ba:	52                   	push   %edx
  8008bb:	50                   	push   %eax
  8008bc:	e8 6b 14 00 00       	call   801d2c <__umoddi3>
  8008c1:	83 c4 10             	add    $0x10,%esp
  8008c4:	05 14 26 80 00       	add    $0x802614,%eax
  8008c9:	8a 00                	mov    (%eax),%al
  8008cb:	0f be c0             	movsbl %al,%eax
  8008ce:	83 ec 08             	sub    $0x8,%esp
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	50                   	push   %eax
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	ff d0                	call   *%eax
  8008da:	83 c4 10             	add    $0x10,%esp
}
  8008dd:	90                   	nop
  8008de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ea:	7e 1c                	jle    800908 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	8d 50 08             	lea    0x8(%eax),%edx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 10                	mov    %edx,(%eax)
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	83 e8 08             	sub    $0x8,%eax
  800901:	8b 50 04             	mov    0x4(%eax),%edx
  800904:	8b 00                	mov    (%eax),%eax
  800906:	eb 40                	jmp    800948 <getuint+0x65>
	else if (lflag)
  800908:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090c:	74 1e                	je     80092c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 04             	lea    0x4(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 04             	sub    $0x4,%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	ba 00 00 00 00       	mov    $0x0,%edx
  80092a:	eb 1c                	jmp    800948 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	8b 00                	mov    (%eax),%eax
  800931:	8d 50 04             	lea    0x4(%eax),%edx
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	89 10                	mov    %edx,(%eax)
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	83 e8 04             	sub    $0x4,%eax
  800941:	8b 00                	mov    (%eax),%eax
  800943:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80094d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800951:	7e 1c                	jle    80096f <getint+0x25>
		return va_arg(*ap, long long);
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 00                	mov    (%eax),%eax
  800958:	8d 50 08             	lea    0x8(%eax),%edx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 10                	mov    %edx,(%eax)
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	8b 00                	mov    (%eax),%eax
  800965:	83 e8 08             	sub    $0x8,%eax
  800968:	8b 50 04             	mov    0x4(%eax),%edx
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	eb 38                	jmp    8009a7 <getint+0x5d>
	else if (lflag)
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	74 1a                	je     80098f <getint+0x45>
		return va_arg(*ap, long);
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8b 00                	mov    (%eax),%eax
  80097a:	8d 50 04             	lea    0x4(%eax),%edx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	89 10                	mov    %edx,(%eax)
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	83 e8 04             	sub    $0x4,%eax
  80098a:	8b 00                	mov    (%eax),%eax
  80098c:	99                   	cltd   
  80098d:	eb 18                	jmp    8009a7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	8d 50 04             	lea    0x4(%eax),%edx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	89 10                	mov    %edx,(%eax)
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 e8 04             	sub    $0x4,%eax
  8009a4:	8b 00                	mov    (%eax),%eax
  8009a6:	99                   	cltd   
}
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	56                   	push   %esi
  8009ad:	53                   	push   %ebx
  8009ae:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b1:	eb 17                	jmp    8009ca <vprintfmt+0x21>
			if (ch == '\0')
  8009b3:	85 db                	test   %ebx,%ebx
  8009b5:	0f 84 c1 03 00 00    	je     800d7c <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f b6 d8             	movzbl %al,%ebx
  8009d8:	83 fb 25             	cmp    $0x25,%ebx
  8009db:	75 d6                	jne    8009b3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009dd:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009e1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800a00:	8d 50 01             	lea    0x1(%eax),%edx
  800a03:	89 55 10             	mov    %edx,0x10(%ebp)
  800a06:	8a 00                	mov    (%eax),%al
  800a08:	0f b6 d8             	movzbl %al,%ebx
  800a0b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a0e:	83 f8 5b             	cmp    $0x5b,%eax
  800a11:	0f 87 3d 03 00 00    	ja     800d54 <vprintfmt+0x3ab>
  800a17:	8b 04 85 38 26 80 00 	mov    0x802638(,%eax,4),%eax
  800a1e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a20:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a24:	eb d7                	jmp    8009fd <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a26:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a2a:	eb d1                	jmp    8009fd <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a36:	89 d0                	mov    %edx,%eax
  800a38:	c1 e0 02             	shl    $0x2,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	01 d8                	add    %ebx,%eax
  800a41:	83 e8 30             	sub    $0x30,%eax
  800a44:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a4f:	83 fb 2f             	cmp    $0x2f,%ebx
  800a52:	7e 3e                	jle    800a92 <vprintfmt+0xe9>
  800a54:	83 fb 39             	cmp    $0x39,%ebx
  800a57:	7f 39                	jg     800a92 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a59:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a5c:	eb d5                	jmp    800a33 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	83 c0 04             	add    $0x4,%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	83 e8 04             	sub    $0x4,%eax
  800a6d:	8b 00                	mov    (%eax),%eax
  800a6f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a72:	eb 1f                	jmp    800a93 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a78:	79 83                	jns    8009fd <vprintfmt+0x54>
				width = 0;
  800a7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a81:	e9 77 ff ff ff       	jmp    8009fd <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a86:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a8d:	e9 6b ff ff ff       	jmp    8009fd <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a92:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a97:	0f 89 60 ff ff ff    	jns    8009fd <vprintfmt+0x54>
				width = precision, precision = -1;
  800a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aaa:	e9 4e ff ff ff       	jmp    8009fd <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800aaf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ab2:	e9 46 ff ff ff       	jmp    8009fd <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 c0 04             	add    $0x4,%eax
  800abd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	83 e8 04             	sub    $0x4,%eax
  800ac6:	8b 00                	mov    (%eax),%eax
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	50                   	push   %eax
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	e9 9b 02 00 00       	jmp    800d77 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800adc:	8b 45 14             	mov    0x14(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae8:	83 e8 04             	sub    $0x4,%eax
  800aeb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aed:	85 db                	test   %ebx,%ebx
  800aef:	79 02                	jns    800af3 <vprintfmt+0x14a>
				err = -err;
  800af1:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800af3:	83 fb 64             	cmp    $0x64,%ebx
  800af6:	7f 0b                	jg     800b03 <vprintfmt+0x15a>
  800af8:	8b 34 9d 80 24 80 00 	mov    0x802480(,%ebx,4),%esi
  800aff:	85 f6                	test   %esi,%esi
  800b01:	75 19                	jne    800b1c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b03:	53                   	push   %ebx
  800b04:	68 25 26 80 00       	push   $0x802625
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 08             	pushl  0x8(%ebp)
  800b0f:	e8 70 02 00 00       	call   800d84 <printfmt>
  800b14:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b17:	e9 5b 02 00 00       	jmp    800d77 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b1c:	56                   	push   %esi
  800b1d:	68 2e 26 80 00       	push   $0x80262e
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	ff 75 08             	pushl  0x8(%ebp)
  800b28:	e8 57 02 00 00       	call   800d84 <printfmt>
  800b2d:	83 c4 10             	add    $0x10,%esp
			break;
  800b30:	e9 42 02 00 00       	jmp    800d77 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 c0 04             	add    $0x4,%eax
  800b3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 30                	mov    (%eax),%esi
  800b46:	85 f6                	test   %esi,%esi
  800b48:	75 05                	jne    800b4f <vprintfmt+0x1a6>
				p = "(null)";
  800b4a:	be 31 26 80 00       	mov    $0x802631,%esi
			if (width > 0 && padc != '-')
  800b4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b53:	7e 6d                	jle    800bc2 <vprintfmt+0x219>
  800b55:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b59:	74 67                	je     800bc2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	50                   	push   %eax
  800b62:	56                   	push   %esi
  800b63:	e8 1e 03 00 00       	call   800e86 <strnlen>
  800b68:	83 c4 10             	add    $0x10,%esp
  800b6b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b6e:	eb 16                	jmp    800b86 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b70:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	ff d0                	call   *%eax
  800b80:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b83:	ff 4d e4             	decl   -0x1c(%ebp)
  800b86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8a:	7f e4                	jg     800b70 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	eb 34                	jmp    800bc2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b8e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b92:	74 1c                	je     800bb0 <vprintfmt+0x207>
  800b94:	83 fb 1f             	cmp    $0x1f,%ebx
  800b97:	7e 05                	jle    800b9e <vprintfmt+0x1f5>
  800b99:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9c:	7e 12                	jle    800bb0 <vprintfmt+0x207>
					putch('?', putdat);
  800b9e:	83 ec 08             	sub    $0x8,%esp
  800ba1:	ff 75 0c             	pushl  0xc(%ebp)
  800ba4:	6a 3f                	push   $0x3f
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	ff d0                	call   *%eax
  800bab:	83 c4 10             	add    $0x10,%esp
  800bae:	eb 0f                	jmp    800bbf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bb0:	83 ec 08             	sub    $0x8,%esp
  800bb3:	ff 75 0c             	pushl  0xc(%ebp)
  800bb6:	53                   	push   %ebx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	ff d0                	call   *%eax
  800bbc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbf:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc2:	89 f0                	mov    %esi,%eax
  800bc4:	8d 70 01             	lea    0x1(%eax),%esi
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	0f be d8             	movsbl %al,%ebx
  800bcc:	85 db                	test   %ebx,%ebx
  800bce:	74 24                	je     800bf4 <vprintfmt+0x24b>
  800bd0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd4:	78 b8                	js     800b8e <vprintfmt+0x1e5>
  800bd6:	ff 4d e0             	decl   -0x20(%ebp)
  800bd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bdd:	79 af                	jns    800b8e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bdf:	eb 13                	jmp    800bf4 <vprintfmt+0x24b>
				putch(' ', putdat);
  800be1:	83 ec 08             	sub    $0x8,%esp
  800be4:	ff 75 0c             	pushl  0xc(%ebp)
  800be7:	6a 20                	push   $0x20
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	ff d0                	call   *%eax
  800bee:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf1:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bf8:	7f e7                	jg     800be1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bfa:	e9 78 01 00 00       	jmp    800d77 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	ff 75 e8             	pushl  -0x18(%ebp)
  800c05:	8d 45 14             	lea    0x14(%ebp),%eax
  800c08:	50                   	push   %eax
  800c09:	e8 3c fd ff ff       	call   80094a <getint>
  800c0e:	83 c4 10             	add    $0x10,%esp
  800c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1d:	85 d2                	test   %edx,%edx
  800c1f:	79 23                	jns    800c44 <vprintfmt+0x29b>
				putch('-', putdat);
  800c21:	83 ec 08             	sub    $0x8,%esp
  800c24:	ff 75 0c             	pushl  0xc(%ebp)
  800c27:	6a 2d                	push   $0x2d
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	ff d0                	call   *%eax
  800c2e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c37:	f7 d8                	neg    %eax
  800c39:	83 d2 00             	adc    $0x0,%edx
  800c3c:	f7 da                	neg    %edx
  800c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4b:	e9 bc 00 00 00       	jmp    800d0c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 e8             	pushl  -0x18(%ebp)
  800c56:	8d 45 14             	lea    0x14(%ebp),%eax
  800c59:	50                   	push   %eax
  800c5a:	e8 84 fc ff ff       	call   8008e3 <getuint>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c68:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c6f:	e9 98 00 00 00       	jmp    800d0c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 58                	push   $0x58
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	6a 58                	push   $0x58
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	ff d0                	call   *%eax
  800c91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c94:	83 ec 08             	sub    $0x8,%esp
  800c97:	ff 75 0c             	pushl  0xc(%ebp)
  800c9a:	6a 58                	push   $0x58
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	ff d0                	call   *%eax
  800ca1:	83 c4 10             	add    $0x10,%esp
			break;
  800ca4:	e9 ce 00 00 00       	jmp    800d77 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800ca9:	83 ec 08             	sub    $0x8,%esp
  800cac:	ff 75 0c             	pushl  0xc(%ebp)
  800caf:	6a 30                	push   $0x30
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	ff d0                	call   *%eax
  800cb6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cb9:	83 ec 08             	sub    $0x8,%esp
  800cbc:	ff 75 0c             	pushl  0xc(%ebp)
  800cbf:	6a 78                	push   $0x78
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	ff d0                	call   *%eax
  800cc6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	83 c0 04             	add    $0x4,%eax
  800ccf:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd5:	83 e8 04             	sub    $0x4,%eax
  800cd8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ceb:	eb 1f                	jmp    800d0c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ced:	83 ec 08             	sub    $0x8,%esp
  800cf0:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf6:	50                   	push   %eax
  800cf7:	e8 e7 fb ff ff       	call   8008e3 <getuint>
  800cfc:	83 c4 10             	add    $0x10,%esp
  800cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d05:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d0c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	52                   	push   %edx
  800d17:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d1a:	50                   	push   %eax
  800d1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1e:	ff 75 f0             	pushl  -0x10(%ebp)
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	ff 75 08             	pushl  0x8(%ebp)
  800d27:	e8 00 fb ff ff       	call   80082c <printnum>
  800d2c:	83 c4 20             	add    $0x20,%esp
			break;
  800d2f:	eb 46                	jmp    800d77 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d31:	83 ec 08             	sub    $0x8,%esp
  800d34:	ff 75 0c             	pushl  0xc(%ebp)
  800d37:	53                   	push   %ebx
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	ff d0                	call   *%eax
  800d3d:	83 c4 10             	add    $0x10,%esp
			break;
  800d40:	eb 35                	jmp    800d77 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d42:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d49:	eb 2c                	jmp    800d77 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d4b:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d52:	eb 23                	jmp    800d77 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d54:	83 ec 08             	sub    $0x8,%esp
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	6a 25                	push   $0x25
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d64:	ff 4d 10             	decl   0x10(%ebp)
  800d67:	eb 03                	jmp    800d6c <vprintfmt+0x3c3>
  800d69:	ff 4d 10             	decl   0x10(%ebp)
  800d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6f:	48                   	dec    %eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	3c 25                	cmp    $0x25,%al
  800d74:	75 f3                	jne    800d69 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d76:	90                   	nop
		}
	}
  800d77:	e9 35 fc ff ff       	jmp    8009b1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d7c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d8a:	8d 45 10             	lea    0x10(%ebp),%eax
  800d8d:	83 c0 04             	add    $0x4,%eax
  800d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d93:	8b 45 10             	mov    0x10(%ebp),%eax
  800d96:	ff 75 f4             	pushl  -0xc(%ebp)
  800d99:	50                   	push   %eax
  800d9a:	ff 75 0c             	pushl  0xc(%ebp)
  800d9d:	ff 75 08             	pushl  0x8(%ebp)
  800da0:	e8 04 fc ff ff       	call   8009a9 <vprintfmt>
  800da5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800da8:	90                   	nop
  800da9:	c9                   	leave  
  800daa:	c3                   	ret    

00800dab <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8b 40 08             	mov    0x8(%eax),%eax
  800db4:	8d 50 01             	lea    0x1(%eax),%edx
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8b 10                	mov    (%eax),%edx
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8b 40 04             	mov    0x4(%eax),%eax
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	73 12                	jae    800dde <sprintputch+0x33>
		*b->buf++ = ch;
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	8d 48 01             	lea    0x1(%eax),%ecx
  800dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd7:	89 0a                	mov    %ecx,(%edx)
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	88 10                	mov    %dl,(%eax)
}
  800dde:	90                   	nop
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	01 d0                	add    %edx,%eax
  800df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e06:	74 06                	je     800e0e <vsnprintf+0x2d>
  800e08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0c:	7f 07                	jg     800e15 <vsnprintf+0x34>
		return -E_INVAL;
  800e0e:	b8 03 00 00 00       	mov    $0x3,%eax
  800e13:	eb 20                	jmp    800e35 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e15:	ff 75 14             	pushl  0x14(%ebp)
  800e18:	ff 75 10             	pushl  0x10(%ebp)
  800e1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e1e:	50                   	push   %eax
  800e1f:	68 ab 0d 80 00       	push   $0x800dab
  800e24:	e8 80 fb ff ff       	call   8009a9 <vprintfmt>
  800e29:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e3d:	8d 45 10             	lea    0x10(%ebp),%eax
  800e40:	83 c0 04             	add    $0x4,%eax
  800e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4c:	50                   	push   %eax
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	ff 75 08             	pushl  0x8(%ebp)
  800e53:	e8 89 ff ff ff       	call   800de1 <vsnprintf>
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e61:	c9                   	leave  
  800e62:	c3                   	ret    

00800e63 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e70:	eb 06                	jmp    800e78 <strlen+0x15>
		n++;
  800e72:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 f1                	jne    800e72 <strlen+0xf>
		n++;
	return n;
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e84:	c9                   	leave  
  800e85:	c3                   	ret    

00800e86 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e93:	eb 09                	jmp    800e9e <strnlen+0x18>
		n++;
  800e95:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e98:	ff 45 08             	incl   0x8(%ebp)
  800e9b:	ff 4d 0c             	decl   0xc(%ebp)
  800e9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea2:	74 09                	je     800ead <strnlen+0x27>
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	84 c0                	test   %al,%al
  800eab:	75 e8                	jne    800e95 <strnlen+0xf>
		n++;
	return n;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb0:	c9                   	leave  
  800eb1:	c3                   	ret    

00800eb2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ebe:	90                   	nop
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8d 50 01             	lea    0x1(%eax),%edx
  800ec5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ece:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed1:	8a 12                	mov    (%edx),%dl
  800ed3:	88 10                	mov    %dl,(%eax)
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	84 c0                	test   %al,%al
  800ed9:	75 e4                	jne    800ebf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef3:	eb 1f                	jmp    800f14 <strncpy+0x34>
		*dst++ = *src;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8d 50 01             	lea    0x1(%eax),%edx
  800efb:	89 55 08             	mov    %edx,0x8(%ebp)
  800efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f01:	8a 12                	mov    (%edx),%dl
  800f03:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	84 c0                	test   %al,%al
  800f0c:	74 03                	je     800f11 <strncpy+0x31>
			src++;
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f11:	ff 45 fc             	incl   -0x4(%ebp)
  800f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f17:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f1a:	72 d9                	jb     800ef5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f31:	74 30                	je     800f63 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f33:	eb 16                	jmp    800f4b <strlcpy+0x2a>
			*dst++ = *src++;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8d 50 01             	lea    0x1(%eax),%edx
  800f3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f47:	8a 12                	mov    (%edx),%dl
  800f49:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f4b:	ff 4d 10             	decl   0x10(%ebp)
  800f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f52:	74 09                	je     800f5d <strlcpy+0x3c>
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 d8                	jne    800f35 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f63:	8b 55 08             	mov    0x8(%ebp),%edx
  800f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f72:	eb 06                	jmp    800f7a <strcmp+0xb>
		p++, q++;
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	84 c0                	test   %al,%al
  800f81:	74 0e                	je     800f91 <strcmp+0x22>
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	8a 10                	mov    (%eax),%dl
  800f88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	38 c2                	cmp    %al,%dl
  800f8f:	74 e3                	je     800f74 <strcmp+0x5>
		p++, q++;
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

00800fa7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800faa:	eb 09                	jmp    800fb5 <strncmp+0xe>
		n--, p++, q++;
  800fac:	ff 4d 10             	decl   0x10(%ebp)
  800faf:	ff 45 08             	incl   0x8(%ebp)
  800fb2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb9:	74 17                	je     800fd2 <strncmp+0x2b>
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	84 c0                	test   %al,%al
  800fc2:	74 0e                	je     800fd2 <strncmp+0x2b>
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 10                	mov    (%eax),%dl
  800fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	38 c2                	cmp    %al,%dl
  800fd0:	74 da                	je     800fac <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	75 07                	jne    800fdf <strncmp+0x38>
		return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdd:	eb 14                	jmp    800ff3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f b6 c0             	movzbl %al,%eax
  800fef:	29 c2                	sub    %eax,%edx
  800ff1:	89 d0                	mov    %edx,%eax
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 04             	sub    $0x4,%esp
  800ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801001:	eb 12                	jmp    801015 <strchr+0x20>
		if (*s == c)
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80100b:	75 05                	jne    801012 <strchr+0x1d>
			return (char *) s;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	eb 11                	jmp    801023 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801012:	ff 45 08             	incl   0x8(%ebp)
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	84 c0                	test   %al,%al
  80101c:	75 e5                	jne    801003 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80101e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801023:	c9                   	leave  
  801024:	c3                   	ret    

00801025 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 04             	sub    $0x4,%esp
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801031:	eb 0d                	jmp    801040 <strfind+0x1b>
		if (*s == c)
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80103b:	74 0e                	je     80104b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80103d:	ff 45 08             	incl   0x8(%ebp)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	84 c0                	test   %al,%al
  801047:	75 ea                	jne    801033 <strfind+0xe>
  801049:	eb 01                	jmp    80104c <strfind+0x27>
		if (*s == c)
			break;
  80104b:	90                   	nop
	return (char *) s;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80105d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801061:	76 63                	jbe    8010c6 <memset+0x75>
		uint64 data_block = c;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	99                   	cltd   
  801067:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80106a:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80106d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801073:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801077:	c1 e0 08             	shl    $0x8,%eax
  80107a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80107d:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801086:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80108a:	c1 e0 10             	shl    $0x10,%eax
  80108d:	09 45 f0             	or     %eax,-0x10(%ebp)
  801090:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801099:	89 c2                	mov    %eax,%edx
  80109b:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010a3:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010a6:	eb 18                	jmp    8010c0 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010a8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010ab:	8d 41 08             	lea    0x8(%ecx),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010b7:	89 01                	mov    %eax,(%ecx)
  8010b9:	89 51 04             	mov    %edx,0x4(%ecx)
  8010bc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010c0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c4:	77 e2                	ja     8010a8 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	74 23                	je     8010ef <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d2:	eb 0e                	jmp    8010e2 <memset+0x91>
			*p8++ = (uint8)c;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e0:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	75 e5                	jne    8010d4 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801106:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80110a:	76 24                	jbe    801130 <memcpy+0x3c>
		while(n >= 8){
  80110c:	eb 1c                	jmp    80112a <memcpy+0x36>
			*d64 = *s64;
  80110e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801111:	8b 50 04             	mov    0x4(%eax),%edx
  801114:	8b 00                	mov    (%eax),%eax
  801116:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801119:	89 01                	mov    %eax,(%ecx)
  80111b:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80111e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801122:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801126:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80112a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80112e:	77 de                	ja     80110e <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801130:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801134:	74 31                	je     801167 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801139:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801142:	eb 16                	jmp    80115a <memcpy+0x66>
			*d8++ = *s8++;
  801144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801147:	8d 50 01             	lea    0x1(%eax),%edx
  80114a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8d 4a 01             	lea    0x1(%edx),%ecx
  801153:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801156:	8a 12                	mov    (%edx),%dl
  801158:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801160:	89 55 10             	mov    %edx,0x10(%ebp)
  801163:	85 c0                	test   %eax,%eax
  801165:	75 dd                	jne    801144 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801172:	8b 45 0c             	mov    0xc(%ebp),%eax
  801175:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801184:	73 50                	jae    8011d6 <memmove+0x6a>
  801186:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801189:	8b 45 10             	mov    0x10(%ebp),%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801191:	76 43                	jbe    8011d6 <memmove+0x6a>
		s += n;
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80119f:	eb 10                	jmp    8011b1 <memmove+0x45>
			*--d = *--s;
  8011a1:	ff 4d f8             	decl   -0x8(%ebp)
  8011a4:	ff 4d fc             	decl   -0x4(%ebp)
  8011a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011aa:	8a 10                	mov    (%eax),%dl
  8011ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011af:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8011ba:	85 c0                	test   %eax,%eax
  8011bc:	75 e3                	jne    8011a1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011be:	eb 23                	jmp    8011e3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c3:	8d 50 01             	lea    0x1(%eax),%edx
  8011c6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011cf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011d2:	8a 12                	mov    (%edx),%dl
  8011d4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	75 dd                	jne    8011c0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011e6:	c9                   	leave  
  8011e7:	c3                   	ret    

008011e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011e8:	55                   	push   %ebp
  8011e9:	89 e5                	mov    %esp,%ebp
  8011eb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011fa:	eb 2a                	jmp    801226 <memcmp+0x3e>
		if (*s1 != *s2)
  8011fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ff:	8a 10                	mov    (%eax),%dl
  801201:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801204:	8a 00                	mov    (%eax),%al
  801206:	38 c2                	cmp    %al,%dl
  801208:	74 16                	je     801220 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80120a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120d:	8a 00                	mov    (%eax),%al
  80120f:	0f b6 d0             	movzbl %al,%edx
  801212:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	0f b6 c0             	movzbl %al,%eax
  80121a:	29 c2                	sub    %eax,%edx
  80121c:	89 d0                	mov    %edx,%eax
  80121e:	eb 18                	jmp    801238 <memcmp+0x50>
		s1++, s2++;
  801220:	ff 45 fc             	incl   -0x4(%ebp)
  801223:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122c:	89 55 10             	mov    %edx,0x10(%ebp)
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 c9                	jne    8011fc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801238:	c9                   	leave  
  801239:	c3                   	ret    

0080123a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801240:	8b 55 08             	mov    0x8(%ebp),%edx
  801243:	8b 45 10             	mov    0x10(%ebp),%eax
  801246:	01 d0                	add    %edx,%eax
  801248:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80124b:	eb 15                	jmp    801262 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	0f b6 c0             	movzbl %al,%eax
  80125b:	39 c2                	cmp    %eax,%edx
  80125d:	74 0d                	je     80126c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80125f:	ff 45 08             	incl   0x8(%ebp)
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801268:	72 e3                	jb     80124d <memfind+0x13>
  80126a:	eb 01                	jmp    80126d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80126c:	90                   	nop
	return (void *) s;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80127f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801286:	eb 03                	jmp    80128b <strtol+0x19>
		s++;
  801288:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	3c 20                	cmp    $0x20,%al
  801292:	74 f4                	je     801288 <strtol+0x16>
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	8a 00                	mov    (%eax),%al
  801299:	3c 09                	cmp    $0x9,%al
  80129b:	74 eb                	je     801288 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 2b                	cmp    $0x2b,%al
  8012a4:	75 05                	jne    8012ab <strtol+0x39>
		s++;
  8012a6:	ff 45 08             	incl   0x8(%ebp)
  8012a9:	eb 13                	jmp    8012be <strtol+0x4c>
	else if (*s == '-')
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 2d                	cmp    $0x2d,%al
  8012b2:	75 0a                	jne    8012be <strtol+0x4c>
		s++, neg = 1;
  8012b4:	ff 45 08             	incl   0x8(%ebp)
  8012b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c2:	74 06                	je     8012ca <strtol+0x58>
  8012c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012c8:	75 20                	jne    8012ea <strtol+0x78>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 30                	cmp    $0x30,%al
  8012d1:	75 17                	jne    8012ea <strtol+0x78>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	40                   	inc    %eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	3c 78                	cmp    $0x78,%al
  8012db:	75 0d                	jne    8012ea <strtol+0x78>
		s += 2, base = 16;
  8012dd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012e1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012e8:	eb 28                	jmp    801312 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ee:	75 15                	jne    801305 <strtol+0x93>
  8012f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f3:	8a 00                	mov    (%eax),%al
  8012f5:	3c 30                	cmp    $0x30,%al
  8012f7:	75 0c                	jne    801305 <strtol+0x93>
		s++, base = 8;
  8012f9:	ff 45 08             	incl   0x8(%ebp)
  8012fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801303:	eb 0d                	jmp    801312 <strtol+0xa0>
	else if (base == 0)
  801305:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801309:	75 07                	jne    801312 <strtol+0xa0>
		base = 10;
  80130b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	3c 2f                	cmp    $0x2f,%al
  801319:	7e 19                	jle    801334 <strtol+0xc2>
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	8a 00                	mov    (%eax),%al
  801320:	3c 39                	cmp    $0x39,%al
  801322:	7f 10                	jg     801334 <strtol+0xc2>
			dig = *s - '0';
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f be c0             	movsbl %al,%eax
  80132c:	83 e8 30             	sub    $0x30,%eax
  80132f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801332:	eb 42                	jmp    801376 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	3c 60                	cmp    $0x60,%al
  80133b:	7e 19                	jle    801356 <strtol+0xe4>
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	3c 7a                	cmp    $0x7a,%al
  801344:	7f 10                	jg     801356 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	0f be c0             	movsbl %al,%eax
  80134e:	83 e8 57             	sub    $0x57,%eax
  801351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801354:	eb 20                	jmp    801376 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8a 00                	mov    (%eax),%al
  80135b:	3c 40                	cmp    $0x40,%al
  80135d:	7e 39                	jle    801398 <strtol+0x126>
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	3c 5a                	cmp    $0x5a,%al
  801366:	7f 30                	jg     801398 <strtol+0x126>
			dig = *s - 'A' + 10;
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	0f be c0             	movsbl %al,%eax
  801370:	83 e8 37             	sub    $0x37,%eax
  801373:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801379:	3b 45 10             	cmp    0x10(%ebp),%eax
  80137c:	7d 19                	jge    801397 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801384:	0f af 45 10          	imul   0x10(%ebp),%eax
  801388:	89 c2                	mov    %eax,%edx
  80138a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801392:	e9 7b ff ff ff       	jmp    801312 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801397:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 08                	je     8013a6 <strtol+0x134>
		*endptr = (char *) s;
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013aa:	74 07                	je     8013b3 <strtol+0x141>
  8013ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013af:	f7 d8                	neg    %eax
  8013b1:	eb 03                	jmp    8013b6 <strtol+0x144>
  8013b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <ltostr>:

void
ltostr(long value, char *str)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8013cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013d0:	79 13                	jns    8013e5 <ltostr+0x2d>
	{
		neg = 1;
  8013d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013df:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013ed:	99                   	cltd   
  8013ee:	f7 f9                	idiv   %ecx
  8013f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f6:	8d 50 01             	lea    0x1(%eax),%edx
  8013f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	01 d0                	add    %edx,%eax
  801403:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801406:	83 c2 30             	add    $0x30,%edx
  801409:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80140b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801413:	f7 e9                	imul   %ecx
  801415:	c1 fa 02             	sar    $0x2,%edx
  801418:	89 c8                	mov    %ecx,%eax
  80141a:	c1 f8 1f             	sar    $0x1f,%eax
  80141d:	29 c2                	sub    %eax,%edx
  80141f:	89 d0                	mov    %edx,%eax
  801421:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801428:	75 bb                	jne    8013e5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80142a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801431:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801434:	48                   	dec    %eax
  801435:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801438:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80143c:	74 3d                	je     80147b <ltostr+0xc3>
		start = 1 ;
  80143e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801445:	eb 34                	jmp    80147b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801447:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144d:	01 d0                	add    %edx,%eax
  80144f:	8a 00                	mov    (%eax),%al
  801451:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801454:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	01 c2                	add    %eax,%edx
  80145c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80145f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801462:	01 c8                	add    %ecx,%eax
  801464:	8a 00                	mov    (%eax),%al
  801466:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801468:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80146b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146e:	01 c2                	add    %eax,%edx
  801470:	8a 45 eb             	mov    -0x15(%ebp),%al
  801473:	88 02                	mov    %al,(%edx)
		start++ ;
  801475:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801478:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801481:	7c c4                	jl     801447 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801483:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	01 d0                	add    %edx,%eax
  80148b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80148e:	90                   	nop
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801497:	ff 75 08             	pushl  0x8(%ebp)
  80149a:	e8 c4 f9 ff ff       	call   800e63 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	e8 b6 f9 ff ff       	call   800e63 <strlen>
  8014ad:	83 c4 04             	add    $0x4,%esp
  8014b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014c1:	eb 17                	jmp    8014da <strcconcat+0x49>
		final[s] = str1[s] ;
  8014c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	01 c2                	add    %eax,%edx
  8014cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	01 c8                	add    %ecx,%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014d7:	ff 45 fc             	incl   -0x4(%ebp)
  8014da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014e0:	7c e1                	jl     8014c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014f0:	eb 1f                	jmp    801511 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f5:	8d 50 01             	lea    0x1(%eax),%edx
  8014f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014fb:	89 c2                	mov    %eax,%edx
  8014fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801500:	01 c2                	add    %eax,%edx
  801502:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	01 c8                	add    %ecx,%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80150e:	ff 45 f8             	incl   -0x8(%ebp)
  801511:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801514:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801517:	7c d9                	jl     8014f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8b 45 10             	mov    0x10(%ebp),%eax
  80151f:	01 d0                	add    %edx,%eax
  801521:	c6 00 00             	movb   $0x0,(%eax)
}
  801524:	90                   	nop
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80152a:	8b 45 14             	mov    0x14(%ebp),%eax
  80152d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801533:	8b 45 14             	mov    0x14(%ebp),%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80153f:	8b 45 10             	mov    0x10(%ebp),%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	eb 0c                	jmp    801558 <strsplit+0x31>
			*string++ = 0;
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8d 50 01             	lea    0x1(%eax),%edx
  801552:	89 55 08             	mov    %edx,0x8(%ebp)
  801555:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	8a 00                	mov    (%eax),%al
  80155d:	84 c0                	test   %al,%al
  80155f:	74 18                	je     801579 <strsplit+0x52>
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	8a 00                	mov    (%eax),%al
  801566:	0f be c0             	movsbl %al,%eax
  801569:	50                   	push   %eax
  80156a:	ff 75 0c             	pushl  0xc(%ebp)
  80156d:	e8 83 fa ff ff       	call   800ff5 <strchr>
  801572:	83 c4 08             	add    $0x8,%esp
  801575:	85 c0                	test   %eax,%eax
  801577:	75 d3                	jne    80154c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	84 c0                	test   %al,%al
  801580:	74 5a                	je     8015dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	83 f8 0f             	cmp    $0xf,%eax
  80158a:	75 07                	jne    801593 <strsplit+0x6c>
		{
			return 0;
  80158c:	b8 00 00 00 00       	mov    $0x0,%eax
  801591:	eb 66                	jmp    8015f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801593:	8b 45 14             	mov    0x14(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8d 48 01             	lea    0x1(%eax),%ecx
  80159b:	8b 55 14             	mov    0x14(%ebp),%edx
  80159e:	89 0a                	mov    %ecx,(%edx)
  8015a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	01 c2                	add    %eax,%edx
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b1:	eb 03                	jmp    8015b6 <strsplit+0x8f>
			string++;
  8015b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	74 8b                	je     80154a <strsplit+0x23>
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8a 00                	mov    (%eax),%al
  8015c4:	0f be c0             	movsbl %al,%eax
  8015c7:	50                   	push   %eax
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	e8 25 fa ff ff       	call   800ff5 <strchr>
  8015d0:	83 c4 08             	add    $0x8,%esp
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 dc                	je     8015b3 <strsplit+0x8c>
			string++;
	}
  8015d7:	e9 6e ff ff ff       	jmp    80154a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e0:	8b 00                	mov    (%eax),%eax
  8015e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ec:	01 d0                	add    %edx,%eax
  8015ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801607:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160e:	eb 4a                	jmp    80165a <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801610:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	01 c2                	add    %eax,%edx
  801618:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80161b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161e:	01 c8                	add    %ecx,%eax
  801620:	8a 00                	mov    (%eax),%al
  801622:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162a:	01 d0                	add    %edx,%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 40                	cmp    $0x40,%al
  801630:	7e 25                	jle    801657 <str2lower+0x5c>
  801632:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	8a 00                	mov    (%eax),%al
  80163c:	3c 5a                	cmp    $0x5a,%al
  80163e:	7f 17                	jg     801657 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801640:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	01 d0                	add    %edx,%eax
  801648:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80164b:	8b 55 08             	mov    0x8(%ebp),%edx
  80164e:	01 ca                	add    %ecx,%edx
  801650:	8a 12                	mov    (%edx),%dl
  801652:	83 c2 20             	add    $0x20,%edx
  801655:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801657:	ff 45 fc             	incl   -0x4(%ebp)
  80165a:	ff 75 0c             	pushl  0xc(%ebp)
  80165d:	e8 01 f8 ff ff       	call   800e63 <strlen>
  801662:	83 c4 04             	add    $0x4,%esp
  801665:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801668:	7f a6                	jg     801610 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801678:	8b 45 08             	mov    0x8(%ebp),%eax
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801681:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801684:	8b 7d 18             	mov    0x18(%ebp),%edi
  801687:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80168a:	cd 30                	int    $0x30
  80168c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	51                   	push   %ecx
  8016b3:	52                   	push   %edx
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	50                   	push   %eax
  8016b8:	6a 00                	push   $0x0
  8016ba:	e8 b0 ff ff ff       	call   80166f <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 02                	push   $0x2
  8016d4:	e8 96 ff ff ff       	call   80166f <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 03                	push   $0x3
  8016ed:	e8 7d ff ff ff       	call   80166f <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 04                	push   $0x4
  801707:	e8 63 ff ff ff       	call   80166f <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 08                	push   $0x8
  801725:	e8 45 ff ff ff       	call   80166f <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801734:	8b 75 18             	mov    0x18(%ebp),%esi
  801737:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	51                   	push   %ecx
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 09                	push   $0x9
  80174a:	e8 20 ff ff ff       	call   80166f <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	ff 75 08             	pushl  0x8(%ebp)
  801767:	6a 0a                	push   $0xa
  801769:	e8 01 ff ff ff       	call   80166f <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	ff 75 08             	pushl  0x8(%ebp)
  801782:	6a 0b                	push   $0xb
  801784:	e8 e6 fe ff ff       	call   80166f <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 0c                	push   $0xc
  80179d:	e8 cd fe ff ff       	call   80166f <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 0d                	push   $0xd
  8017b6:	e8 b4 fe ff ff       	call   80166f <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 0e                	push   $0xe
  8017cf:	e8 9b fe ff ff       	call   80166f <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 0f                	push   $0xf
  8017e8:	e8 82 fe ff ff       	call   80166f <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	ff 75 08             	pushl  0x8(%ebp)
  801800:	6a 10                	push   $0x10
  801802:	e8 68 fe ff ff       	call   80166f <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 11                	push   $0x11
  80181b:	e8 4f fe ff ff       	call   80166f <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	90                   	nop
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_cputc>:

void
sys_cputc(const char c)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801832:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	50                   	push   %eax
  80183f:	6a 01                	push   $0x1
  801841:	e8 29 fe ff ff       	call   80166f <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	90                   	nop
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 14                	push   $0x14
  80185b:	e8 0f fe ff ff       	call   80166f <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	90                   	nop
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801872:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801875:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	51                   	push   %ecx
  80187f:	52                   	push   %edx
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	50                   	push   %eax
  801884:	6a 15                	push   $0x15
  801886:	e8 e4 fd ff ff       	call   80166f <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	6a 16                	push   $0x16
  8018a3:	e8 c7 fd ff ff       	call   80166f <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 17                	push   $0x17
  8018c2:	e8 a8 fd ff ff       	call   80166f <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 18                	push   $0x18
  8018df:	e8 8b fd ff ff       	call   80166f <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 14             	pushl  0x14(%ebp)
  8018f4:	ff 75 10             	pushl  0x10(%ebp)
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	50                   	push   %eax
  8018fb:	6a 19                	push   $0x19
  8018fd:	e8 6d fd ff ff       	call   80166f <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	50                   	push   %eax
  801916:	6a 1a                	push   $0x1a
  801918:	e8 52 fd ff ff       	call   80166f <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 1b                	push   $0x1b
  801934:	e8 36 fd ff ff       	call   80166f <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 05                	push   $0x5
  80194d:	e8 1d fd ff ff       	call   80166f <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 06                	push   $0x6
  801966:	e8 04 fd ff ff       	call   80166f <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 07                	push   $0x7
  80197f:	e8 eb fc ff ff       	call   80166f <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_exit_env>:


void sys_exit_env(void)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 1c                	push   $0x1c
  801998:	e8 d2 fc ff ff       	call   80166f <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	90                   	nop
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ac:	8d 50 04             	lea    0x4(%eax),%edx
  8019af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 1d                	push   $0x1d
  8019bc:	e8 ae fc ff ff       	call   80166f <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
	return result;
  8019c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019cd:	89 01                	mov    %eax,(%ecx)
  8019cf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	c9                   	leave  
  8019d6:	c2 04 00             	ret    $0x4

008019d9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	ff 75 10             	pushl  0x10(%ebp)
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 13                	push   $0x13
  8019eb:	e8 7f fc ff ff       	call   80166f <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f3:	90                   	nop
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 1e                	push   $0x1e
  801a05:	e8 65 fc ff ff       	call   80166f <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a1b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	50                   	push   %eax
  801a28:	6a 1f                	push   $0x1f
  801a2a:	e8 40 fc ff ff       	call   80166f <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a32:	90                   	nop
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <rsttst>:
void rsttst()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 21                	push   $0x21
  801a44:	e8 26 fc ff ff       	call   80166f <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4c:	90                   	nop
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	8b 45 14             	mov    0x14(%ebp),%eax
  801a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a5b:	8b 55 18             	mov    0x18(%ebp),%edx
  801a5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	ff 75 10             	pushl  0x10(%ebp)
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	ff 75 08             	pushl  0x8(%ebp)
  801a6d:	6a 20                	push   $0x20
  801a6f:	e8 fb fb ff ff       	call   80166f <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
	return ;
  801a77:	90                   	nop
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <chktst>:
void chktst(uint32 n)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	6a 22                	push   $0x22
  801a8a:	e8 e0 fb ff ff       	call   80166f <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a92:	90                   	nop
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <inctst>:

void inctst()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 23                	push   $0x23
  801aa4:	e8 c6 fb ff ff       	call   80166f <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aac:	90                   	nop
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <gettst>:
uint32 gettst()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 24                	push   $0x24
  801abe:	e8 ac fb ff ff       	call   80166f <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 25                	push   $0x25
  801ad7:	e8 93 fb ff ff       	call   80166f <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
  801adf:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801ae4:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	ff 75 08             	pushl  0x8(%ebp)
  801b01:	6a 26                	push   $0x26
  801b03:	e8 67 fb ff ff       	call   80166f <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0b:	90                   	nop
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	53                   	push   %ebx
  801b21:	51                   	push   %ecx
  801b22:	52                   	push   %edx
  801b23:	50                   	push   %eax
  801b24:	6a 27                	push   $0x27
  801b26:	e8 44 fb ff ff       	call   80166f <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	52                   	push   %edx
  801b43:	50                   	push   %eax
  801b44:	6a 28                	push   $0x28
  801b46:	e8 24 fb ff ff       	call   80166f <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b53:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	51                   	push   %ecx
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 29                	push   $0x29
  801b66:	e8 04 fb ff ff       	call   80166f <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 10             	pushl  0x10(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 12                	push   $0x12
  801b82:	e8 e8 fa ff ff       	call   80166f <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 2a                	push   $0x2a
  801ba0:	e8 ca fa ff ff       	call   80166f <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 2b                	push   $0x2b
  801bba:	e8 b0 fa ff ff       	call   80166f <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	ff 75 08             	pushl  0x8(%ebp)
  801bd3:	6a 2d                	push   $0x2d
  801bd5:	e8 95 fa ff ff       	call   80166f <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return;
  801bdd:	90                   	nop
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	6a 2c                	push   $0x2c
  801bf1:	e8 79 fa ff ff       	call   80166f <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf9:	90                   	nop
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 a8 27 80 00       	push   $0x8027a8
  801c0a:	68 25 01 00 00       	push   $0x125
  801c0f:	68 db 27 80 00       	push   $0x8027db
  801c14:	e8 a3 e8 ff ff       	call   8004bc <_panic>
  801c19:	66 90                	xchg   %ax,%ax
  801c1b:	90                   	nop

00801c1c <__udivdi3>:
  801c1c:	55                   	push   %ebp
  801c1d:	57                   	push   %edi
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 1c             	sub    $0x1c,%esp
  801c23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c33:	89 ca                	mov    %ecx,%edx
  801c35:	89 f8                	mov    %edi,%eax
  801c37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c3b:	85 f6                	test   %esi,%esi
  801c3d:	75 2d                	jne    801c6c <__udivdi3+0x50>
  801c3f:	39 cf                	cmp    %ecx,%edi
  801c41:	77 65                	ja     801ca8 <__udivdi3+0x8c>
  801c43:	89 fd                	mov    %edi,%ebp
  801c45:	85 ff                	test   %edi,%edi
  801c47:	75 0b                	jne    801c54 <__udivdi3+0x38>
  801c49:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4e:	31 d2                	xor    %edx,%edx
  801c50:	f7 f7                	div    %edi
  801c52:	89 c5                	mov    %eax,%ebp
  801c54:	31 d2                	xor    %edx,%edx
  801c56:	89 c8                	mov    %ecx,%eax
  801c58:	f7 f5                	div    %ebp
  801c5a:	89 c1                	mov    %eax,%ecx
  801c5c:	89 d8                	mov    %ebx,%eax
  801c5e:	f7 f5                	div    %ebp
  801c60:	89 cf                	mov    %ecx,%edi
  801c62:	89 fa                	mov    %edi,%edx
  801c64:	83 c4 1c             	add    $0x1c,%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    
  801c6c:	39 ce                	cmp    %ecx,%esi
  801c6e:	77 28                	ja     801c98 <__udivdi3+0x7c>
  801c70:	0f bd fe             	bsr    %esi,%edi
  801c73:	83 f7 1f             	xor    $0x1f,%edi
  801c76:	75 40                	jne    801cb8 <__udivdi3+0x9c>
  801c78:	39 ce                	cmp    %ecx,%esi
  801c7a:	72 0a                	jb     801c86 <__udivdi3+0x6a>
  801c7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c80:	0f 87 9e 00 00 00    	ja     801d24 <__udivdi3+0x108>
  801c86:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8b:	89 fa                	mov    %edi,%edx
  801c8d:	83 c4 1c             	add    $0x1c,%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5f                   	pop    %edi
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    
  801c95:	8d 76 00             	lea    0x0(%esi),%esi
  801c98:	31 ff                	xor    %edi,%edi
  801c9a:	31 c0                	xor    %eax,%eax
  801c9c:	89 fa                	mov    %edi,%edx
  801c9e:	83 c4 1c             	add    $0x1c,%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5e                   	pop    %esi
  801ca3:	5f                   	pop    %edi
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	89 d8                	mov    %ebx,%eax
  801caa:	f7 f7                	div    %edi
  801cac:	31 ff                	xor    %edi,%edi
  801cae:	89 fa                	mov    %edi,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cbd:	89 eb                	mov    %ebp,%ebx
  801cbf:	29 fb                	sub    %edi,%ebx
  801cc1:	89 f9                	mov    %edi,%ecx
  801cc3:	d3 e6                	shl    %cl,%esi
  801cc5:	89 c5                	mov    %eax,%ebp
  801cc7:	88 d9                	mov    %bl,%cl
  801cc9:	d3 ed                	shr    %cl,%ebp
  801ccb:	89 e9                	mov    %ebp,%ecx
  801ccd:	09 f1                	or     %esi,%ecx
  801ccf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cd3:	89 f9                	mov    %edi,%ecx
  801cd5:	d3 e0                	shl    %cl,%eax
  801cd7:	89 c5                	mov    %eax,%ebp
  801cd9:	89 d6                	mov    %edx,%esi
  801cdb:	88 d9                	mov    %bl,%cl
  801cdd:	d3 ee                	shr    %cl,%esi
  801cdf:	89 f9                	mov    %edi,%ecx
  801ce1:	d3 e2                	shl    %cl,%edx
  801ce3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce7:	88 d9                	mov    %bl,%cl
  801ce9:	d3 e8                	shr    %cl,%eax
  801ceb:	09 c2                	or     %eax,%edx
  801ced:	89 d0                	mov    %edx,%eax
  801cef:	89 f2                	mov    %esi,%edx
  801cf1:	f7 74 24 0c          	divl   0xc(%esp)
  801cf5:	89 d6                	mov    %edx,%esi
  801cf7:	89 c3                	mov    %eax,%ebx
  801cf9:	f7 e5                	mul    %ebp
  801cfb:	39 d6                	cmp    %edx,%esi
  801cfd:	72 19                	jb     801d18 <__udivdi3+0xfc>
  801cff:	74 0b                	je     801d0c <__udivdi3+0xf0>
  801d01:	89 d8                	mov    %ebx,%eax
  801d03:	31 ff                	xor    %edi,%edi
  801d05:	e9 58 ff ff ff       	jmp    801c62 <__udivdi3+0x46>
  801d0a:	66 90                	xchg   %ax,%ax
  801d0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d10:	89 f9                	mov    %edi,%ecx
  801d12:	d3 e2                	shl    %cl,%edx
  801d14:	39 c2                	cmp    %eax,%edx
  801d16:	73 e9                	jae    801d01 <__udivdi3+0xe5>
  801d18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d1b:	31 ff                	xor    %edi,%edi
  801d1d:	e9 40 ff ff ff       	jmp    801c62 <__udivdi3+0x46>
  801d22:	66 90                	xchg   %ax,%ax
  801d24:	31 c0                	xor    %eax,%eax
  801d26:	e9 37 ff ff ff       	jmp    801c62 <__udivdi3+0x46>
  801d2b:	90                   	nop

00801d2c <__umoddi3>:
  801d2c:	55                   	push   %ebp
  801d2d:	57                   	push   %edi
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 1c             	sub    $0x1c,%esp
  801d33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d4b:	89 f3                	mov    %esi,%ebx
  801d4d:	89 fa                	mov    %edi,%edx
  801d4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d53:	89 34 24             	mov    %esi,(%esp)
  801d56:	85 c0                	test   %eax,%eax
  801d58:	75 1a                	jne    801d74 <__umoddi3+0x48>
  801d5a:	39 f7                	cmp    %esi,%edi
  801d5c:	0f 86 a2 00 00 00    	jbe    801e04 <__umoddi3+0xd8>
  801d62:	89 c8                	mov    %ecx,%eax
  801d64:	89 f2                	mov    %esi,%edx
  801d66:	f7 f7                	div    %edi
  801d68:	89 d0                	mov    %edx,%eax
  801d6a:	31 d2                	xor    %edx,%edx
  801d6c:	83 c4 1c             	add    $0x1c,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5f                   	pop    %edi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    
  801d74:	39 f0                	cmp    %esi,%eax
  801d76:	0f 87 ac 00 00 00    	ja     801e28 <__umoddi3+0xfc>
  801d7c:	0f bd e8             	bsr    %eax,%ebp
  801d7f:	83 f5 1f             	xor    $0x1f,%ebp
  801d82:	0f 84 ac 00 00 00    	je     801e34 <__umoddi3+0x108>
  801d88:	bf 20 00 00 00       	mov    $0x20,%edi
  801d8d:	29 ef                	sub    %ebp,%edi
  801d8f:	89 fe                	mov    %edi,%esi
  801d91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d95:	89 e9                	mov    %ebp,%ecx
  801d97:	d3 e0                	shl    %cl,%eax
  801d99:	89 d7                	mov    %edx,%edi
  801d9b:	89 f1                	mov    %esi,%ecx
  801d9d:	d3 ef                	shr    %cl,%edi
  801d9f:	09 c7                	or     %eax,%edi
  801da1:	89 e9                	mov    %ebp,%ecx
  801da3:	d3 e2                	shl    %cl,%edx
  801da5:	89 14 24             	mov    %edx,(%esp)
  801da8:	89 d8                	mov    %ebx,%eax
  801daa:	d3 e0                	shl    %cl,%eax
  801dac:	89 c2                	mov    %eax,%edx
  801dae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801db2:	d3 e0                	shl    %cl,%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dbc:	89 f1                	mov    %esi,%ecx
  801dbe:	d3 e8                	shr    %cl,%eax
  801dc0:	09 d0                	or     %edx,%eax
  801dc2:	d3 eb                	shr    %cl,%ebx
  801dc4:	89 da                	mov    %ebx,%edx
  801dc6:	f7 f7                	div    %edi
  801dc8:	89 d3                	mov    %edx,%ebx
  801dca:	f7 24 24             	mull   (%esp)
  801dcd:	89 c6                	mov    %eax,%esi
  801dcf:	89 d1                	mov    %edx,%ecx
  801dd1:	39 d3                	cmp    %edx,%ebx
  801dd3:	0f 82 87 00 00 00    	jb     801e60 <__umoddi3+0x134>
  801dd9:	0f 84 91 00 00 00    	je     801e70 <__umoddi3+0x144>
  801ddf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801de3:	29 f2                	sub    %esi,%edx
  801de5:	19 cb                	sbb    %ecx,%ebx
  801de7:	89 d8                	mov    %ebx,%eax
  801de9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ded:	d3 e0                	shl    %cl,%eax
  801def:	89 e9                	mov    %ebp,%ecx
  801df1:	d3 ea                	shr    %cl,%edx
  801df3:	09 d0                	or     %edx,%eax
  801df5:	89 e9                	mov    %ebp,%ecx
  801df7:	d3 eb                	shr    %cl,%ebx
  801df9:	89 da                	mov    %ebx,%edx
  801dfb:	83 c4 1c             	add    $0x1c,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5f                   	pop    %edi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    
  801e03:	90                   	nop
  801e04:	89 fd                	mov    %edi,%ebp
  801e06:	85 ff                	test   %edi,%edi
  801e08:	75 0b                	jne    801e15 <__umoddi3+0xe9>
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	31 d2                	xor    %edx,%edx
  801e11:	f7 f7                	div    %edi
  801e13:	89 c5                	mov    %eax,%ebp
  801e15:	89 f0                	mov    %esi,%eax
  801e17:	31 d2                	xor    %edx,%edx
  801e19:	f7 f5                	div    %ebp
  801e1b:	89 c8                	mov    %ecx,%eax
  801e1d:	f7 f5                	div    %ebp
  801e1f:	89 d0                	mov    %edx,%eax
  801e21:	e9 44 ff ff ff       	jmp    801d6a <__umoddi3+0x3e>
  801e26:	66 90                	xchg   %ax,%ax
  801e28:	89 c8                	mov    %ecx,%eax
  801e2a:	89 f2                	mov    %esi,%edx
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
  801e34:	3b 04 24             	cmp    (%esp),%eax
  801e37:	72 06                	jb     801e3f <__umoddi3+0x113>
  801e39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e3d:	77 0f                	ja     801e4e <__umoddi3+0x122>
  801e3f:	89 f2                	mov    %esi,%edx
  801e41:	29 f9                	sub    %edi,%ecx
  801e43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e47:	89 14 24             	mov    %edx,(%esp)
  801e4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e52:	8b 14 24             	mov    (%esp),%edx
  801e55:	83 c4 1c             	add    $0x1c,%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5f                   	pop    %edi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
  801e5d:	8d 76 00             	lea    0x0(%esi),%esi
  801e60:	2b 04 24             	sub    (%esp),%eax
  801e63:	19 fa                	sbb    %edi,%edx
  801e65:	89 d1                	mov    %edx,%ecx
  801e67:	89 c6                	mov    %eax,%esi
  801e69:	e9 71 ff ff ff       	jmp    801ddf <__umoddi3+0xb3>
  801e6e:	66 90                	xchg   %ax,%ax
  801e70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e74:	72 ea                	jb     801e60 <__umoddi3+0x134>
  801e76:	89 d9                	mov    %ebx,%ecx
  801e78:	e9 62 ff ff ff       	jmp    801ddf <__umoddi3+0xb3>
