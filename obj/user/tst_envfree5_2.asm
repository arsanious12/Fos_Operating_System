
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 7b 02 00 00       	call   8002b1 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  800044:	83 ec 04             	sub    $0x4,%esp
  800047:	6a 01                	push   $0x1
  800049:	6a 04                	push   $0x4
  80004b:	68 60 2b 80 00       	push   $0x802b60
  800050:	e8 f9 16 00 00       	call   80174e <smalloc>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	*numOfFinished = 0 ;
  80005b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80005e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800064:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80006a:	bb 63 2d 80 00       	mov    $0x802d63,%ebx
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
  8000a1:	e8 58 1c 00 00       	call   801cfe <sys_utilities>
  8000a6:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  8000a9:	e8 51 18 00 00       	call   8018ff <sys_calculate_free_frames>
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  8000b1:	e8 94 18 00 00       	call   80194a <sys_pf_calculate_allocated_pages>
  8000b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bf:	68 70 2b 80 00       	push   $0x802b70
  8000c4:	e8 7b 06 00 00       	call   800744 <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 3000,100, 50);
  8000cc:	6a 32                	push   $0x32
  8000ce:	6a 64                	push   $0x64
  8000d0:	68 b8 0b 00 00       	push   $0xbb8
  8000d5:	68 a3 2b 80 00       	push   $0x802ba3
  8000da:	e8 7b 19 00 00       	call   801a5a <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 3000,100, 50);
  8000e5:	6a 32                	push   $0x32
  8000e7:	6a 64                	push   $0x64
  8000e9:	68 b8 0b 00 00       	push   $0xbb8
  8000ee:	68 ac 2b 80 00       	push   $0x802bac
  8000f3:	e8 62 19 00 00       	call   801a5a <sys_create_env>
  8000f8:	83 c4 10             	add    $0x10,%esp
  8000fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	sys_run_env(envIdProcessA);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 d8             	pushl  -0x28(%ebp)
  800104:	e8 6f 19 00 00       	call   801a78 <sys_run_env>
  800109:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 98 3a 00 00       	push   $0x3a98
  800114:	e8 18 27 00 00       	call   802831 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	ff 75 d4             	pushl  -0x2c(%ebp)
  800122:	e8 51 19 00 00       	call   801a78 <sys_run_env>
  800127:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  80012a:	90                   	nop
  80012b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	83 f8 02             	cmp    $0x2,%eax
  800133:	75 f6                	jne    80012b <_main+0xf3>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  800135:	e8 c5 17 00 00       	call   8018ff <sys_calculate_free_frames>
  80013a:	83 ec 08             	sub    $0x8,%esp
  80013d:	50                   	push   %eax
  80013e:	68 b8 2b 80 00       	push   $0x802bb8
  800143:	e8 fc 05 00 00       	call   800744 <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  80014b:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	50                   	push   %eax
  800155:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 9d 1b 00 00       	call   801cfe <sys_utilities>
  800161:	83 c4 10             	add    $0x10,%esp

	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800164:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80016a:	bb c7 2d 80 00       	mov    $0x802dc7,%ebx
  80016f:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800174:	89 c7                	mov    %eax,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	89 d1                	mov    %edx,%ecx
  80017a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80017c:	8d 95 02 ff ff ff    	lea    -0xfe(%ebp),%edx
  800182:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800187:	b0 00                	mov    $0x0,%al
  800189:	89 d7                	mov    %edx,%edi
  80018b:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	6a 00                	push   $0x0
  800192:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800198:	50                   	push   %eax
  800199:	e8 60 1b 00 00       	call   801cfe <sys_utilities>
  80019e:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a7:	e8 e8 18 00 00       	call   801a94 <sys_destroy_env>
  8001ac:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8001b5:	e8 da 18 00 00       	call   801a94 <sys_destroy_env>
  8001ba:	83 c4 10             	add    $0x10,%esp
	}
	sys_utilities(changeIntCmd, 1);
  8001bd:	83 ec 08             	sub    $0x8,%esp
  8001c0:	6a 01                	push   $0x1
  8001c2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	e8 30 1b 00 00       	call   801cfe <sys_utilities>
  8001ce:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8001d1:	e8 29 17 00 00       	call   8018ff <sys_calculate_free_frames>
  8001d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8001d9:	e8 6c 17 00 00       	call   80194a <sys_pf_calculate_allocated_pages>
  8001de:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  8001e1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001e8:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  8001ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001f1:	01 d0                	add    %edx,%eax
  8001f3:	48                   	dec    %eax
  8001f4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8001ff:	f7 75 c8             	divl   -0x38(%ebp)
  800202:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800205:	29 d0                	sub    %edx,%eax
  800207:	89 c1                	mov    %eax,%ecx
  800209:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  800210:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800216:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	48                   	dec    %eax
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80021f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800222:	ba 00 00 00 00       	mov    $0x0,%edx
  800227:	f7 75 c0             	divl   -0x40(%ebp)
  80022a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80022d:	29 d0                	sub    %edx,%eax
  80022f:	29 c1                	sub    %eax,%ecx
  800231:	89 c8                	mov    %ecx,%eax
  800233:	c1 e8 0c             	shr    $0xc,%eax
  800236:	89 45 b8             	mov    %eax,-0x48(%ebp)
	cprintf("expected = %d\n",expected);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 b8             	pushl  -0x48(%ebp)
  80023f:	68 ea 2b 80 00       	push   $0x802bea
  800244:	e8 fb 04 00 00       	call   800744 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  80024c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80024f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800255:	74 2e                	je     800285 <_main+0x24d>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800257:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80025a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025d:	ff 75 b8             	pushl  -0x48(%ebp)
  800260:	50                   	push   %eax
  800261:	ff 75 d0             	pushl  -0x30(%ebp)
  800264:	68 fc 2b 80 00       	push   $0x802bfc
  800269:	e8 d6 04 00 00       	call   800744 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  800271:	83 ec 04             	sub    $0x4,%esp
  800274:	68 6c 2c 80 00       	push   $0x802c6c
  800279:	6a 36                	push   $0x36
  80027b:	68 a2 2c 80 00       	push   $0x802ca2
  800280:	e8 f1 01 00 00       	call   800476 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	ff 75 d0             	pushl  -0x30(%ebp)
  80028b:	68 b8 2c 80 00       	push   $0x802cb8
  800290:	e8 af 04 00 00       	call   800744 <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	68 18 2d 80 00       	push   $0x802d18
  8002a0:	e8 9f 04 00 00       	call   800744 <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	return;
  8002a8:	90                   	nop
}
  8002a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002ba:	e8 09 18 00 00       	call   801ac8 <sys_getenvindex>
  8002bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8002c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002c5:	89 d0                	mov    %edx,%eax
  8002c7:	c1 e0 06             	shl    $0x6,%eax
  8002ca:	29 d0                	sub    %edx,%eax
  8002cc:	c1 e0 02             	shl    $0x2,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d8:	01 c8                	add    %ecx,%eax
  8002da:	c1 e0 03             	shl    $0x3,%eax
  8002dd:	01 d0                	add    %edx,%eax
  8002df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e6:	29 c2                	sub    %eax,%edx
  8002e8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002ef:	89 c2                	mov    %eax,%edx
  8002f1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002f7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800301:	8a 40 20             	mov    0x20(%eax),%al
  800304:	84 c0                	test   %al,%al
  800306:	74 0d                	je     800315 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	83 c0 20             	add    $0x20,%eax
  800310:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800319:	7e 0a                	jle    800325 <libmain+0x74>
		binaryname = argv[0];
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 05 fd ff ff       	call   800038 <_main>
  800333:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800336:	a1 00 40 80 00       	mov    0x804000,%eax
  80033b:	85 c0                	test   %eax,%eax
  80033d:	0f 84 01 01 00 00    	je     800444 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800343:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800349:	bb 24 2f 80 00       	mov    $0x802f24,%ebx
  80034e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800353:	89 c7                	mov    %eax,%edi
  800355:	89 de                	mov    %ebx,%esi
  800357:	89 d1                	mov    %edx,%ecx
  800359:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80035b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80035e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800363:	b0 00                	mov    $0x0,%al
  800365:	89 d7                	mov    %edx,%edi
  800367:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800369:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800370:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	50                   	push   %eax
  800377:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80037d:	50                   	push   %eax
  80037e:	e8 7b 19 00 00       	call   801cfe <sys_utilities>
  800383:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800386:	e8 c4 14 00 00       	call   80184f <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80038b:	83 ec 0c             	sub    $0xc,%esp
  80038e:	68 44 2e 80 00       	push   $0x802e44
  800393:	e8 ac 03 00 00       	call   800744 <cprintf>
  800398:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80039b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80039e:	85 c0                	test   %eax,%eax
  8003a0:	74 18                	je     8003ba <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8003a2:	e8 75 19 00 00       	call   801d1c <sys_get_optimal_num_faults>
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	50                   	push   %eax
  8003ab:	68 6c 2e 80 00       	push   $0x802e6c
  8003b0:	e8 8f 03 00 00       	call   800744 <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	eb 59                	jmp    800413 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bf:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8003c5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ca:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	52                   	push   %edx
  8003d4:	50                   	push   %eax
  8003d5:	68 90 2e 80 00       	push   $0x802e90
  8003da:	e8 65 03 00 00       	call   800744 <cprintf>
  8003df:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f2:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fd:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800403:	51                   	push   %ecx
  800404:	52                   	push   %edx
  800405:	50                   	push   %eax
  800406:	68 b8 2e 80 00       	push   $0x802eb8
  80040b:	e8 34 03 00 00       	call   800744 <cprintf>
  800410:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800413:	a1 20 40 80 00       	mov    0x804020,%eax
  800418:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	50                   	push   %eax
  800422:	68 10 2f 80 00       	push   $0x802f10
  800427:	e8 18 03 00 00       	call   800744 <cprintf>
  80042c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80042f:	83 ec 0c             	sub    $0xc,%esp
  800432:	68 44 2e 80 00       	push   $0x802e44
  800437:	e8 08 03 00 00       	call   800744 <cprintf>
  80043c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80043f:	e8 25 14 00 00       	call   801869 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800444:	e8 1f 00 00 00       	call   800468 <exit>
}
  800449:	90                   	nop
  80044a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80044d:	5b                   	pop    %ebx
  80044e:	5e                   	pop    %esi
  80044f:	5f                   	pop    %edi
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	6a 00                	push   $0x0
  80045d:	e8 32 16 00 00       	call   801a94 <sys_destroy_env>
  800462:	83 c4 10             	add    $0x10,%esp
}
  800465:	90                   	nop
  800466:	c9                   	leave  
  800467:	c3                   	ret    

00800468 <exit>:

void
exit(void)
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80046e:	e8 87 16 00 00       	call   801afa <sys_exit_env>
}
  800473:	90                   	nop
  800474:	c9                   	leave  
  800475:	c3                   	ret    

00800476 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80047c:	8d 45 10             	lea    0x10(%ebp),%eax
  80047f:	83 c0 04             	add    $0x4,%eax
  800482:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800485:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80048a:	85 c0                	test   %eax,%eax
  80048c:	74 16                	je     8004a4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80048e:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	50                   	push   %eax
  800497:	68 88 2f 80 00       	push   $0x802f88
  80049c:	e8 a3 02 00 00       	call   800744 <cprintf>
  8004a1:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8004a4:	a1 04 40 80 00       	mov    0x804004,%eax
  8004a9:	83 ec 0c             	sub    $0xc,%esp
  8004ac:	ff 75 0c             	pushl  0xc(%ebp)
  8004af:	ff 75 08             	pushl  0x8(%ebp)
  8004b2:	50                   	push   %eax
  8004b3:	68 90 2f 80 00       	push   $0x802f90
  8004b8:	6a 74                	push   $0x74
  8004ba:	e8 b2 02 00 00       	call   800771 <cprintf_colored>
  8004bf:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8004c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004cb:	50                   	push   %eax
  8004cc:	e8 04 02 00 00       	call   8006d5 <vcprintf>
  8004d1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	68 b8 2f 80 00       	push   $0x802fb8
  8004de:	e8 f2 01 00 00       	call   8006d5 <vcprintf>
  8004e3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004e6:	e8 7d ff ff ff       	call   800468 <exit>

	// should not return here
	while (1) ;
  8004eb:	eb fe                	jmp    8004eb <_panic+0x75>

008004ed <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004ed:	55                   	push   %ebp
  8004ee:	89 e5                	mov    %esp,%ebp
  8004f0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	39 c2                	cmp    %eax,%edx
  800503:	74 14                	je     800519 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	68 bc 2f 80 00       	push   $0x802fbc
  80050d:	6a 26                	push   $0x26
  80050f:	68 08 30 80 00       	push   $0x803008
  800514:	e8 5d ff ff ff       	call   800476 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800520:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800527:	e9 c5 00 00 00       	jmp    8005f1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80052c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80052f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	01 d0                	add    %edx,%eax
  80053b:	8b 00                	mov    (%eax),%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 08                	jne    800549 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800541:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800544:	e9 a5 00 00 00       	jmp    8005ee <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800549:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800550:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800557:	eb 69                	jmp    8005c2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800559:	a1 20 40 80 00       	mov    0x804020,%eax
  80055e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800564:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	c1 e0 03             	shl    $0x3,%eax
  800570:	01 c8                	add    %ecx,%eax
  800572:	8a 40 04             	mov    0x4(%eax),%al
  800575:	84 c0                	test   %al,%al
  800577:	75 46                	jne    8005bf <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800579:	a1 20 40 80 00       	mov    0x804020,%eax
  80057e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800584:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800587:	89 d0                	mov    %edx,%eax
  800589:	01 c0                	add    %eax,%eax
  80058b:	01 d0                	add    %edx,%eax
  80058d:	c1 e0 03             	shl    $0x3,%eax
  800590:	01 c8                	add    %ecx,%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	01 c8                	add    %ecx,%eax
  8005b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b2:	39 c2                	cmp    %eax,%edx
  8005b4:	75 09                	jne    8005bf <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8005b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005bd:	eb 15                	jmp    8005d4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005bf:	ff 45 e8             	incl   -0x18(%ebp)
  8005c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d0:	39 c2                	cmp    %eax,%edx
  8005d2:	77 85                	ja     800559 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005d8:	75 14                	jne    8005ee <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	68 14 30 80 00       	push   $0x803014
  8005e2:	6a 3a                	push   $0x3a
  8005e4:	68 08 30 80 00       	push   $0x803008
  8005e9:	e8 88 fe ff ff       	call   800476 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ee:	ff 45 f0             	incl   -0x10(%ebp)
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f7:	0f 8c 2f ff ff ff    	jl     80052c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800604:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80060b:	eb 26                	jmp    800633 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80060d:	a1 20 40 80 00       	mov    0x804020,%eax
  800612:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800618:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80061b:	89 d0                	mov    %edx,%eax
  80061d:	01 c0                	add    %eax,%eax
  80061f:	01 d0                	add    %edx,%eax
  800621:	c1 e0 03             	shl    $0x3,%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8a 40 04             	mov    0x4(%eax),%al
  800629:	3c 01                	cmp    $0x1,%al
  80062b:	75 03                	jne    800630 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80062d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800630:	ff 45 e0             	incl   -0x20(%ebp)
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 c8                	ja     80060d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800648:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80064b:	74 14                	je     800661 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80064d:	83 ec 04             	sub    $0x4,%esp
  800650:	68 68 30 80 00       	push   $0x803068
  800655:	6a 44                	push   $0x44
  800657:	68 08 30 80 00       	push   $0x803008
  80065c:	e8 15 fe ff ff       	call   800476 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800661:	90                   	nop
  800662:	c9                   	leave  
  800663:	c3                   	ret    

00800664 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800664:	55                   	push   %ebp
  800665:	89 e5                	mov    %esp,%ebp
  800667:	53                   	push   %ebx
  800668:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80066b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066e:	8b 00                	mov    (%eax),%eax
  800670:	8d 48 01             	lea    0x1(%eax),%ecx
  800673:	8b 55 0c             	mov    0xc(%ebp),%edx
  800676:	89 0a                	mov    %ecx,(%edx)
  800678:	8b 55 08             	mov    0x8(%ebp),%edx
  80067b:	88 d1                	mov    %dl,%cl
  80067d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800680:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800684:	8b 45 0c             	mov    0xc(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	3d ff 00 00 00       	cmp    $0xff,%eax
  80068e:	75 30                	jne    8006c0 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800690:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800696:	a0 44 40 80 00       	mov    0x804044,%al
  80069b:	0f b6 c0             	movzbl %al,%eax
  80069e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a1:	8b 09                	mov    (%ecx),%ecx
  8006a3:	89 cb                	mov    %ecx,%ebx
  8006a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006a8:	83 c1 08             	add    $0x8,%ecx
  8006ab:	52                   	push   %edx
  8006ac:	50                   	push   %eax
  8006ad:	53                   	push   %ebx
  8006ae:	51                   	push   %ecx
  8006af:	e8 57 11 00 00       	call   80180b <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e5:	00 00 00 
	b.cnt = 0;
  8006e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ef:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006f2:	ff 75 0c             	pushl  0xc(%ebp)
  8006f5:	ff 75 08             	pushl  0x8(%ebp)
  8006f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	68 64 06 80 00       	push   $0x800664
  800704:	e8 5a 02 00 00       	call   800963 <vprintfmt>
  800709:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  80070c:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  800712:	a0 44 40 80 00       	mov    0x804044,%al
  800717:	0f b6 c0             	movzbl %al,%eax
  80071a:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800720:	52                   	push   %edx
  800721:	50                   	push   %eax
  800722:	51                   	push   %ecx
  800723:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800729:	83 c0 08             	add    $0x8,%eax
  80072c:	50                   	push   %eax
  80072d:	e8 d9 10 00 00       	call   80180b <sys_cputs>
  800732:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800735:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  80073c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80074a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800751:	8d 45 0c             	lea    0xc(%ebp),%eax
  800754:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 f4             	pushl  -0xc(%ebp)
  800760:	50                   	push   %eax
  800761:	e8 6f ff ff ff       	call   8006d5 <vcprintf>
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80076c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800771:	55                   	push   %ebp
  800772:	89 e5                	mov    %esp,%ebp
  800774:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800777:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	c1 e0 08             	shl    $0x8,%eax
  800784:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800789:	8d 45 0c             	lea    0xc(%ebp),%eax
  80078c:	83 c0 04             	add    $0x4,%eax
  80078f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 f4             	pushl  -0xc(%ebp)
  80079b:	50                   	push   %eax
  80079c:	e8 34 ff ff ff       	call   8006d5 <vcprintf>
  8007a1:	83 c4 10             	add    $0x10,%esp
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8007a7:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8007ae:	07 00 00 

	return cnt;
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8007bc:	e8 8e 10 00 00       	call   80184f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8007c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 ff fe ff ff       	call   8006d5 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8007dc:	e8 88 10 00 00       	call   801869 <sys_unlock_cons>
	return cnt;
  8007e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	53                   	push   %ebx
  8007ea:	83 ec 14             	sub    $0x14,%esp
  8007ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800801:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800804:	77 55                	ja     80085b <printnum+0x75>
  800806:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800809:	72 05                	jb     800810 <printnum+0x2a>
  80080b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080e:	77 4b                	ja     80085b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800810:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800813:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 f4             	pushl  -0xc(%ebp)
  800823:	ff 75 f0             	pushl  -0x10(%ebp)
  800826:	e8 c5 20 00 00       	call   8028f0 <__udivdi3>
  80082b:	83 c4 10             	add    $0x10,%esp
  80082e:	83 ec 04             	sub    $0x4,%esp
  800831:	ff 75 20             	pushl  0x20(%ebp)
  800834:	53                   	push   %ebx
  800835:	ff 75 18             	pushl  0x18(%ebp)
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	ff 75 0c             	pushl  0xc(%ebp)
  80083d:	ff 75 08             	pushl  0x8(%ebp)
  800840:	e8 a1 ff ff ff       	call   8007e6 <printnum>
  800845:	83 c4 20             	add    $0x20,%esp
  800848:	eb 1a                	jmp    800864 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084a:	83 ec 08             	sub    $0x8,%esp
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 20             	pushl  0x20(%ebp)
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085b:	ff 4d 1c             	decl   0x1c(%ebp)
  80085e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800862:	7f e6                	jg     80084a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800864:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800867:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800872:	53                   	push   %ebx
  800873:	51                   	push   %ecx
  800874:	52                   	push   %edx
  800875:	50                   	push   %eax
  800876:	e8 85 21 00 00       	call   802a00 <__umoddi3>
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	05 d4 32 80 00       	add    $0x8032d4,%eax
  800883:	8a 00                	mov    (%eax),%al
  800885:	0f be c0             	movsbl %al,%eax
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	50                   	push   %eax
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	ff d0                	call   *%eax
  800894:	83 c4 10             	add    $0x10,%esp
}
  800897:	90                   	nop
  800898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a4:	7e 1c                	jle    8008c2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 50 08             	lea    0x8(%eax),%edx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 10                	mov    %edx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	83 e8 08             	sub    $0x8,%eax
  8008bb:	8b 50 04             	mov    0x4(%eax),%edx
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	eb 40                	jmp    800902 <getuint+0x65>
	else if (lflag)
  8008c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c6:	74 1e                	je     8008e6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	8d 50 04             	lea    0x4(%eax),%edx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	89 10                	mov    %edx,(%eax)
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	eb 1c                	jmp    800902 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	8d 50 04             	lea    0x4(%eax),%edx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	89 10                	mov    %edx,(%eax)
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	83 e8 04             	sub    $0x4,%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800907:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090b:	7e 1c                	jle    800929 <getint+0x25>
		return va_arg(*ap, long long);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 08             	lea    0x8(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 08             	sub    $0x8,%eax
  800922:	8b 50 04             	mov    0x4(%eax),%edx
  800925:	8b 00                	mov    (%eax),%eax
  800927:	eb 38                	jmp    800961 <getint+0x5d>
	else if (lflag)
  800929:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092d:	74 1a                	je     800949 <getint+0x45>
		return va_arg(*ap, long);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
  800947:	eb 18                	jmp    800961 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8b 00                	mov    (%eax),%eax
  80094e:	8d 50 04             	lea    0x4(%eax),%edx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	89 10                	mov    %edx,(%eax)
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	99                   	cltd   
}
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	56                   	push   %esi
  800967:	53                   	push   %ebx
  800968:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096b:	eb 17                	jmp    800984 <vprintfmt+0x21>
			if (ch == '\0')
  80096d:	85 db                	test   %ebx,%ebx
  80096f:	0f 84 c1 03 00 00    	je     800d36 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	53                   	push   %ebx
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	ff d0                	call   *%eax
  800981:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800984:	8b 45 10             	mov    0x10(%ebp),%eax
  800987:	8d 50 01             	lea    0x1(%eax),%edx
  80098a:	89 55 10             	mov    %edx,0x10(%ebp)
  80098d:	8a 00                	mov    (%eax),%al
  80098f:	0f b6 d8             	movzbl %al,%ebx
  800992:	83 fb 25             	cmp    $0x25,%ebx
  800995:	75 d6                	jne    80096d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800997:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ba:	8d 50 01             	lea    0x1(%eax),%edx
  8009bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c0:	8a 00                	mov    (%eax),%al
  8009c2:	0f b6 d8             	movzbl %al,%ebx
  8009c5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c8:	83 f8 5b             	cmp    $0x5b,%eax
  8009cb:	0f 87 3d 03 00 00    	ja     800d0e <vprintfmt+0x3ab>
  8009d1:	8b 04 85 f8 32 80 00 	mov    0x8032f8(,%eax,4),%eax
  8009d8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009da:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009de:	eb d7                	jmp    8009b7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e4:	eb d1                	jmp    8009b7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f0:	89 d0                	mov    %edx,%eax
  8009f2:	c1 e0 02             	shl    $0x2,%eax
  8009f5:	01 d0                	add    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d8                	add    %ebx,%eax
  8009fb:	83 e8 30             	sub    $0x30,%eax
  8009fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a01:	8b 45 10             	mov    0x10(%ebp),%eax
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a09:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0c:	7e 3e                	jle    800a4c <vprintfmt+0xe9>
  800a0e:	83 fb 39             	cmp    $0x39,%ebx
  800a11:	7f 39                	jg     800a4c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a13:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a16:	eb d5                	jmp    8009ed <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 c0 04             	add    $0x4,%eax
  800a1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	83 e8 04             	sub    $0x4,%eax
  800a27:	8b 00                	mov    (%eax),%eax
  800a29:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2c:	eb 1f                	jmp    800a4d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a32:	79 83                	jns    8009b7 <vprintfmt+0x54>
				width = 0;
  800a34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3b:	e9 77 ff ff ff       	jmp    8009b7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a40:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a47:	e9 6b ff ff ff       	jmp    8009b7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a51:	0f 89 60 ff ff ff    	jns    8009b7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a64:	e9 4e ff ff ff       	jmp    8009b7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a69:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6c:	e9 46 ff ff ff       	jmp    8009b7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7d:	83 e8 04             	sub    $0x4,%eax
  800a80:	8b 00                	mov    (%eax),%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			break;
  800a91:	e9 9b 02 00 00       	jmp    800d31 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 c0 04             	add    $0x4,%eax
  800a9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	83 e8 04             	sub    $0x4,%eax
  800aa5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa7:	85 db                	test   %ebx,%ebx
  800aa9:	79 02                	jns    800aad <vprintfmt+0x14a>
				err = -err;
  800aab:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aad:	83 fb 64             	cmp    $0x64,%ebx
  800ab0:	7f 0b                	jg     800abd <vprintfmt+0x15a>
  800ab2:	8b 34 9d 40 31 80 00 	mov    0x803140(,%ebx,4),%esi
  800ab9:	85 f6                	test   %esi,%esi
  800abb:	75 19                	jne    800ad6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abd:	53                   	push   %ebx
  800abe:	68 e5 32 80 00       	push   $0x8032e5
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 70 02 00 00       	call   800d3e <printfmt>
  800ace:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad1:	e9 5b 02 00 00       	jmp    800d31 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad6:	56                   	push   %esi
  800ad7:	68 ee 32 80 00       	push   $0x8032ee
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	ff 75 08             	pushl  0x8(%ebp)
  800ae2:	e8 57 02 00 00       	call   800d3e <printfmt>
  800ae7:	83 c4 10             	add    $0x10,%esp
			break;
  800aea:	e9 42 02 00 00       	jmp    800d31 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 c0 04             	add    $0x4,%eax
  800af5:	89 45 14             	mov    %eax,0x14(%ebp)
  800af8:	8b 45 14             	mov    0x14(%ebp),%eax
  800afb:	83 e8 04             	sub    $0x4,%eax
  800afe:	8b 30                	mov    (%eax),%esi
  800b00:	85 f6                	test   %esi,%esi
  800b02:	75 05                	jne    800b09 <vprintfmt+0x1a6>
				p = "(null)";
  800b04:	be f1 32 80 00       	mov    $0x8032f1,%esi
			if (width > 0 && padc != '-')
  800b09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0d:	7e 6d                	jle    800b7c <vprintfmt+0x219>
  800b0f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b13:	74 67                	je     800b7c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	50                   	push   %eax
  800b1c:	56                   	push   %esi
  800b1d:	e8 1e 03 00 00       	call   800e40 <strnlen>
  800b22:	83 c4 10             	add    $0x10,%esp
  800b25:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b28:	eb 16                	jmp    800b40 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	50                   	push   %eax
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b44:	7f e4                	jg     800b2a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b46:	eb 34                	jmp    800b7c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b48:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4c:	74 1c                	je     800b6a <vprintfmt+0x207>
  800b4e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b51:	7e 05                	jle    800b58 <vprintfmt+0x1f5>
  800b53:	83 fb 7e             	cmp    $0x7e,%ebx
  800b56:	7e 12                	jle    800b6a <vprintfmt+0x207>
					putch('?', putdat);
  800b58:	83 ec 08             	sub    $0x8,%esp
  800b5b:	ff 75 0c             	pushl  0xc(%ebp)
  800b5e:	6a 3f                	push   $0x3f
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	ff d0                	call   *%eax
  800b65:	83 c4 10             	add    $0x10,%esp
  800b68:	eb 0f                	jmp    800b79 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6a:	83 ec 08             	sub    $0x8,%esp
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	53                   	push   %ebx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	ff d0                	call   *%eax
  800b76:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b79:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	8d 70 01             	lea    0x1(%eax),%esi
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	0f be d8             	movsbl %al,%ebx
  800b86:	85 db                	test   %ebx,%ebx
  800b88:	74 24                	je     800bae <vprintfmt+0x24b>
  800b8a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8e:	78 b8                	js     800b48 <vprintfmt+0x1e5>
  800b90:	ff 4d e0             	decl   -0x20(%ebp)
  800b93:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b97:	79 af                	jns    800b48 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b99:	eb 13                	jmp    800bae <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	6a 20                	push   $0x20
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	ff d0                	call   *%eax
  800ba8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bab:	ff 4d e4             	decl   -0x1c(%ebp)
  800bae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb2:	7f e7                	jg     800b9b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb4:	e9 78 01 00 00       	jmp    800d31 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 e8             	pushl  -0x18(%ebp)
  800bbf:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	e8 3c fd ff ff       	call   800904 <getint>
  800bc8:	83 c4 10             	add    $0x10,%esp
  800bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bce:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	85 d2                	test   %edx,%edx
  800bd9:	79 23                	jns    800bfe <vprintfmt+0x29b>
				putch('-', putdat);
  800bdb:	83 ec 08             	sub    $0x8,%esp
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	6a 2d                	push   $0x2d
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	ff d0                	call   *%eax
  800be8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf1:	f7 d8                	neg    %eax
  800bf3:	83 d2 00             	adc    $0x0,%edx
  800bf6:	f7 da                	neg    %edx
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bfe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c05:	e9 bc 00 00 00       	jmp    800cc6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800c10:	8d 45 14             	lea    0x14(%ebp),%eax
  800c13:	50                   	push   %eax
  800c14:	e8 84 fc ff ff       	call   80089d <getuint>
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c22:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c29:	e9 98 00 00 00       	jmp    800cc6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 0c             	pushl  0xc(%ebp)
  800c34:	6a 58                	push   $0x58
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	ff d0                	call   *%eax
  800c3b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 0c             	pushl  0xc(%ebp)
  800c44:	6a 58                	push   $0x58
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	ff d0                	call   *%eax
  800c4b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4e:	83 ec 08             	sub    $0x8,%esp
  800c51:	ff 75 0c             	pushl  0xc(%ebp)
  800c54:	6a 58                	push   $0x58
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			break;
  800c5e:	e9 ce 00 00 00       	jmp    800d31 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c63:	83 ec 08             	sub    $0x8,%esp
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	6a 30                	push   $0x30
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	ff d0                	call   *%eax
  800c70:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c73:	83 ec 08             	sub    $0x8,%esp
  800c76:	ff 75 0c             	pushl  0xc(%ebp)
  800c79:	6a 78                	push   $0x78
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	ff d0                	call   *%eax
  800c80:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c83:	8b 45 14             	mov    0x14(%ebp),%eax
  800c86:	83 c0 04             	add    $0x4,%eax
  800c89:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8f:	83 e8 04             	sub    $0x4,%eax
  800c92:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca5:	eb 1f                	jmp    800cc6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca7:	83 ec 08             	sub    $0x8,%esp
  800caa:	ff 75 e8             	pushl  -0x18(%ebp)
  800cad:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb0:	50                   	push   %eax
  800cb1:	e8 e7 fb ff ff       	call   80089d <getuint>
  800cb6:	83 c4 10             	add    $0x10,%esp
  800cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cbf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ccd:	83 ec 04             	sub    $0x4,%esp
  800cd0:	52                   	push   %edx
  800cd1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd4:	50                   	push   %eax
  800cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd8:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	ff 75 08             	pushl  0x8(%ebp)
  800ce1:	e8 00 fb ff ff       	call   8007e6 <printnum>
  800ce6:	83 c4 20             	add    $0x20,%esp
			break;
  800ce9:	eb 46                	jmp    800d31 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	53                   	push   %ebx
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	ff d0                	call   *%eax
  800cf7:	83 c4 10             	add    $0x10,%esp
			break;
  800cfa:	eb 35                	jmp    800d31 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cfc:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800d03:	eb 2c                	jmp    800d31 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d05:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800d0c:	eb 23                	jmp    800d31 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d0e:	83 ec 08             	sub    $0x8,%esp
  800d11:	ff 75 0c             	pushl  0xc(%ebp)
  800d14:	6a 25                	push   $0x25
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	ff d0                	call   *%eax
  800d1b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1e:	ff 4d 10             	decl   0x10(%ebp)
  800d21:	eb 03                	jmp    800d26 <vprintfmt+0x3c3>
  800d23:	ff 4d 10             	decl   0x10(%ebp)
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	48                   	dec    %eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	3c 25                	cmp    $0x25,%al
  800d2e:	75 f3                	jne    800d23 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800d30:	90                   	nop
		}
	}
  800d31:	e9 35 fc ff ff       	jmp    80096b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d36:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    

00800d3e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d3e:	55                   	push   %ebp
  800d3f:	89 e5                	mov    %esp,%ebp
  800d41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d44:	8d 45 10             	lea    0x10(%ebp),%eax
  800d47:	83 c0 04             	add    $0x4,%eax
  800d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d50:	ff 75 f4             	pushl  -0xc(%ebp)
  800d53:	50                   	push   %eax
  800d54:	ff 75 0c             	pushl  0xc(%ebp)
  800d57:	ff 75 08             	pushl  0x8(%ebp)
  800d5a:	e8 04 fc ff ff       	call   800963 <vprintfmt>
  800d5f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d62:	90                   	nop
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8b 40 08             	mov    0x8(%eax),%eax
  800d6e:	8d 50 01             	lea    0x1(%eax),%edx
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8b 10                	mov    (%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	8b 40 04             	mov    0x4(%eax),%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	73 12                	jae    800d98 <sprintputch+0x33>
		*b->buf++ = ch;
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8b 00                	mov    (%eax),%eax
  800d8b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d91:	89 0a                	mov    %ecx,(%edx)
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	88 10                	mov    %dl,(%eax)
}
  800d98:	90                   	nop
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	01 d0                	add    %edx,%eax
  800db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc0:	74 06                	je     800dc8 <vsnprintf+0x2d>
  800dc2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc6:	7f 07                	jg     800dcf <vsnprintf+0x34>
		return -E_INVAL;
  800dc8:	b8 03 00 00 00       	mov    $0x3,%eax
  800dcd:	eb 20                	jmp    800def <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dcf:	ff 75 14             	pushl  0x14(%ebp)
  800dd2:	ff 75 10             	pushl  0x10(%ebp)
  800dd5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd8:	50                   	push   %eax
  800dd9:	68 65 0d 80 00       	push   $0x800d65
  800dde:	e8 80 fb ff ff       	call   800963 <vprintfmt>
  800de3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800de9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfa:	83 c0 04             	add    $0x4,%eax
  800dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	ff 75 f4             	pushl  -0xc(%ebp)
  800e06:	50                   	push   %eax
  800e07:	ff 75 0c             	pushl  0xc(%ebp)
  800e0a:	ff 75 08             	pushl  0x8(%ebp)
  800e0d:	e8 89 ff ff ff       	call   800d9b <vsnprintf>
  800e12:	83 c4 10             	add    $0x10,%esp
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2a:	eb 06                	jmp    800e32 <strlen+0x15>
		n++;
  800e2c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2f:	ff 45 08             	incl   0x8(%ebp)
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 f1                	jne    800e2c <strlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4d:	eb 09                	jmp    800e58 <strnlen+0x18>
		n++;
  800e4f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	ff 4d 0c             	decl   0xc(%ebp)
  800e58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5c:	74 09                	je     800e67 <strnlen+0x27>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	84 c0                	test   %al,%al
  800e65:	75 e8                	jne    800e4f <strnlen+0xf>
		n++;
	return n;
  800e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6a:	c9                   	leave  
  800e6b:	c3                   	ret    

00800e6c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e72:	8b 45 08             	mov    0x8(%ebp),%eax
  800e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e78:	90                   	nop
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8d 50 01             	lea    0x1(%eax),%edx
  800e7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8b:	8a 12                	mov    (%edx),%dl
  800e8d:	88 10                	mov    %dl,(%eax)
  800e8f:	8a 00                	mov    (%eax),%al
  800e91:	84 c0                	test   %al,%al
  800e93:	75 e4                	jne    800e79 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ead:	eb 1f                	jmp    800ece <strncpy+0x34>
		*dst++ = *src;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8a 12                	mov    (%edx),%dl
  800ebd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	84 c0                	test   %al,%al
  800ec6:	74 03                	je     800ecb <strncpy+0x31>
			src++;
  800ec8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecb:	ff 45 fc             	incl   -0x4(%ebp)
  800ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed4:	72 d9                	jb     800eaf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eeb:	74 30                	je     800f1d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eed:	eb 16                	jmp    800f05 <strlcpy+0x2a>
			*dst++ = *src++;
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8d 50 01             	lea    0x1(%eax),%edx
  800ef5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800efe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f01:	8a 12                	mov    (%edx),%dl
  800f03:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f05:	ff 4d 10             	decl   0x10(%ebp)
  800f08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0c:	74 09                	je     800f17 <strlcpy+0x3c>
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	84 c0                	test   %al,%al
  800f15:	75 d8                	jne    800eef <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	29 c2                	sub    %eax,%edx
  800f25:	89 d0                	mov    %edx,%eax
}
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f2c:	eb 06                	jmp    800f34 <strcmp+0xb>
		p++, q++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
  800f31:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	84 c0                	test   %al,%al
  800f3b:	74 0e                	je     800f4b <strcmp+0x22>
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	8a 10                	mov    (%eax),%dl
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	38 c2                	cmp    %al,%dl
  800f49:	74 e3                	je     800f2e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f64:	eb 09                	jmp    800f6f <strncmp+0xe>
		n--, p++, q++;
  800f66:	ff 4d 10             	decl   0x10(%ebp)
  800f69:	ff 45 08             	incl   0x8(%ebp)
  800f6c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f73:	74 17                	je     800f8c <strncmp+0x2b>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	84 c0                	test   %al,%al
  800f7c:	74 0e                	je     800f8c <strncmp+0x2b>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 10                	mov    (%eax),%dl
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	8a 00                	mov    (%eax),%al
  800f88:	38 c2                	cmp    %al,%dl
  800f8a:	74 da                	je     800f66 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f90:	75 07                	jne    800f99 <strncmp+0x38>
		return 0;
  800f92:	b8 00 00 00 00       	mov    $0x0,%eax
  800f97:	eb 14                	jmp    800fad <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 d0             	movzbl %al,%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	0f b6 c0             	movzbl %al,%eax
  800fa9:	29 c2                	sub    %eax,%edx
  800fab:	89 d0                	mov    %edx,%eax
}
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	83 ec 04             	sub    $0x4,%esp
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbb:	eb 12                	jmp    800fcf <strchr+0x20>
		if (*s == c)
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc5:	75 05                	jne    800fcc <strchr+0x1d>
			return (char *) s;
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	eb 11                	jmp    800fdd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	84 c0                	test   %al,%al
  800fd6:	75 e5                	jne    800fbd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800feb:	eb 0d                	jmp    800ffa <strfind+0x1b>
		if (*s == c)
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff5:	74 0e                	je     801005 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff7:	ff 45 08             	incl   0x8(%ebp)
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	84 c0                	test   %al,%al
  801001:	75 ea                	jne    800fed <strfind+0xe>
  801003:	eb 01                	jmp    801006 <strfind+0x27>
		if (*s == c)
			break;
  801005:	90                   	nop
	return (char *) s;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801009:	c9                   	leave  
  80100a:	c3                   	ret    

0080100b <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801017:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80101b:	76 63                	jbe    801080 <memset+0x75>
		uint64 data_block = c;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	99                   	cltd   
  801021:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801024:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102d:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801031:	c1 e0 08             	shl    $0x8,%eax
  801034:	09 45 f0             	or     %eax,-0x10(%ebp)
  801037:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80103a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801044:	c1 e0 10             	shl    $0x10,%eax
  801047:	09 45 f0             	or     %eax,-0x10(%ebp)
  80104a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	89 c2                	mov    %eax,%edx
  801055:	b8 00 00 00 00       	mov    $0x0,%eax
  80105a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80105d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801060:	eb 18                	jmp    80107a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801062:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801065:	8d 41 08             	lea    0x8(%ecx),%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80106b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801071:	89 01                	mov    %eax,(%ecx)
  801073:	89 51 04             	mov    %edx,0x4(%ecx)
  801076:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80107a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107e:	77 e2                	ja     801062 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801080:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801084:	74 23                	je     8010a9 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80108c:	eb 0e                	jmp    80109c <memset+0x91>
			*p8++ = (uint8)c;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	75 e5                	jne    80108e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8010c0:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010c4:	76 24                	jbe    8010ea <memcpy+0x3c>
		while(n >= 8){
  8010c6:	eb 1c                	jmp    8010e4 <memcpy+0x36>
			*d64 = *s64;
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	8b 50 04             	mov    0x4(%eax),%edx
  8010ce:	8b 00                	mov    (%eax),%eax
  8010d0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010d3:	89 01                	mov    %eax,(%ecx)
  8010d5:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8010d8:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8010dc:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010e0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010e4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010e8:	77 de                	ja     8010c8 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ee:	74 31                	je     801121 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010fc:	eb 16                	jmp    801114 <memcpy+0x66>
			*d8++ = *s8++;
  8010fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801101:	8d 50 01             	lea    0x1(%eax),%edx
  801104:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80110d:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801110:	8a 12                	mov    (%edx),%dl
  801112:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801114:	8b 45 10             	mov    0x10(%ebp),%eax
  801117:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111a:	89 55 10             	mov    %edx,0x10(%ebp)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	75 dd                	jne    8010fe <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80113e:	73 50                	jae    801190 <memmove+0x6a>
  801140:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801143:	8b 45 10             	mov    0x10(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80114b:	76 43                	jbe    801190 <memmove+0x6a>
		s += n;
  80114d:	8b 45 10             	mov    0x10(%ebp),%eax
  801150:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801153:	8b 45 10             	mov    0x10(%ebp),%eax
  801156:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801159:	eb 10                	jmp    80116b <memmove+0x45>
			*--d = *--s;
  80115b:	ff 4d f8             	decl   -0x8(%ebp)
  80115e:	ff 4d fc             	decl   -0x4(%ebp)
  801161:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801164:	8a 10                	mov    (%eax),%dl
  801166:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801169:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80116b:	8b 45 10             	mov    0x10(%ebp),%eax
  80116e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801171:	89 55 10             	mov    %edx,0x10(%ebp)
  801174:	85 c0                	test   %eax,%eax
  801176:	75 e3                	jne    80115b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801178:	eb 23                	jmp    80119d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117d:	8d 50 01             	lea    0x1(%eax),%edx
  801180:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801183:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801186:	8d 4a 01             	lea    0x1(%edx),%ecx
  801189:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80118c:	8a 12                	mov    (%edx),%dl
  80118e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	8d 50 ff             	lea    -0x1(%eax),%edx
  801196:	89 55 10             	mov    %edx,0x10(%ebp)
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 dd                	jne    80117a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011b4:	eb 2a                	jmp    8011e0 <memcmp+0x3e>
		if (*s1 != *s2)
  8011b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b9:	8a 10                	mov    (%eax),%dl
  8011bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	38 c2                	cmp    %al,%dl
  8011c2:	74 16                	je     8011da <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	0f b6 d0             	movzbl %al,%edx
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	0f b6 c0             	movzbl %al,%eax
  8011d4:	29 c2                	sub    %eax,%edx
  8011d6:	89 d0                	mov    %edx,%eax
  8011d8:	eb 18                	jmp    8011f2 <memcmp+0x50>
		s1++, s2++;
  8011da:	ff 45 fc             	incl   -0x4(%ebp)
  8011dd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	75 c9                	jne    8011b6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 d0                	add    %edx,%eax
  801202:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801205:	eb 15                	jmp    80121c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 d0             	movzbl %al,%edx
  80120f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801212:	0f b6 c0             	movzbl %al,%eax
  801215:	39 c2                	cmp    %eax,%edx
  801217:	74 0d                	je     801226 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801219:	ff 45 08             	incl   0x8(%ebp)
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801222:	72 e3                	jb     801207 <memfind+0x13>
  801224:	eb 01                	jmp    801227 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801226:	90                   	nop
	return (void *) s;
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801239:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801240:	eb 03                	jmp    801245 <strtol+0x19>
		s++;
  801242:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 20                	cmp    $0x20,%al
  80124c:	74 f4                	je     801242 <strtol+0x16>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 09                	cmp    $0x9,%al
  801255:	74 eb                	je     801242 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	3c 2b                	cmp    $0x2b,%al
  80125e:	75 05                	jne    801265 <strtol+0x39>
		s++;
  801260:	ff 45 08             	incl   0x8(%ebp)
  801263:	eb 13                	jmp    801278 <strtol+0x4c>
	else if (*s == '-')
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8a 00                	mov    (%eax),%al
  80126a:	3c 2d                	cmp    $0x2d,%al
  80126c:	75 0a                	jne    801278 <strtol+0x4c>
		s++, neg = 1;
  80126e:	ff 45 08             	incl   0x8(%ebp)
  801271:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801278:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80127c:	74 06                	je     801284 <strtol+0x58>
  80127e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801282:	75 20                	jne    8012a4 <strtol+0x78>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	3c 30                	cmp    $0x30,%al
  80128b:	75 17                	jne    8012a4 <strtol+0x78>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	40                   	inc    %eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 78                	cmp    $0x78,%al
  801295:	75 0d                	jne    8012a4 <strtol+0x78>
		s += 2, base = 16;
  801297:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80129b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012a2:	eb 28                	jmp    8012cc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012a8:	75 15                	jne    8012bf <strtol+0x93>
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	3c 30                	cmp    $0x30,%al
  8012b1:	75 0c                	jne    8012bf <strtol+0x93>
		s++, base = 8;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
  8012b6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012bd:	eb 0d                	jmp    8012cc <strtol+0xa0>
	else if (base == 0)
  8012bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c3:	75 07                	jne    8012cc <strtol+0xa0>
		base = 10;
  8012c5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	3c 2f                	cmp    $0x2f,%al
  8012d3:	7e 19                	jle    8012ee <strtol+0xc2>
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8a 00                	mov    (%eax),%al
  8012da:	3c 39                	cmp    $0x39,%al
  8012dc:	7f 10                	jg     8012ee <strtol+0xc2>
			dig = *s - '0';
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8a 00                	mov    (%eax),%al
  8012e3:	0f be c0             	movsbl %al,%eax
  8012e6:	83 e8 30             	sub    $0x30,%eax
  8012e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ec:	eb 42                	jmp    801330 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 60                	cmp    $0x60,%al
  8012f5:	7e 19                	jle    801310 <strtol+0xe4>
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	3c 7a                	cmp    $0x7a,%al
  8012fe:	7f 10                	jg     801310 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	0f be c0             	movsbl %al,%eax
  801308:	83 e8 57             	sub    $0x57,%eax
  80130b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80130e:	eb 20                	jmp    801330 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 40                	cmp    $0x40,%al
  801317:	7e 39                	jle    801352 <strtol+0x126>
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	3c 5a                	cmp    $0x5a,%al
  801320:	7f 30                	jg     801352 <strtol+0x126>
			dig = *s - 'A' + 10;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	83 e8 37             	sub    $0x37,%eax
  80132d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801333:	3b 45 10             	cmp    0x10(%ebp),%eax
  801336:	7d 19                	jge    801351 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801338:	ff 45 08             	incl   0x8(%ebp)
  80133b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801342:	89 c2                	mov    %eax,%edx
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	01 d0                	add    %edx,%eax
  801349:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80134c:	e9 7b ff ff ff       	jmp    8012cc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801351:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801352:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801356:	74 08                	je     801360 <strtol+0x134>
		*endptr = (char *) s;
  801358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135b:	8b 55 08             	mov    0x8(%ebp),%edx
  80135e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801360:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801364:	74 07                	je     80136d <strtol+0x141>
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	f7 d8                	neg    %eax
  80136b:	eb 03                	jmp    801370 <strtol+0x144>
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <ltostr>:

void
ltostr(long value, char *str)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801378:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80137f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138a:	79 13                	jns    80139f <ltostr+0x2d>
	{
		neg = 1;
  80138c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801399:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80139c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013a7:	99                   	cltd   
  8013a8:	f7 f9                	idiv   %ecx
  8013aa:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b0:	8d 50 01             	lea    0x1(%eax),%edx
  8013b3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013b6:	89 c2                	mov    %eax,%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 d0                	add    %edx,%eax
  8013bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013c0:	83 c2 30             	add    $0x30,%edx
  8013c3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013c8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013cd:	f7 e9                	imul   %ecx
  8013cf:	c1 fa 02             	sar    $0x2,%edx
  8013d2:	89 c8                	mov    %ecx,%eax
  8013d4:	c1 f8 1f             	sar    $0x1f,%eax
  8013d7:	29 c2                	sub    %eax,%edx
  8013d9:	89 d0                	mov    %edx,%eax
  8013db:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8013de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e2:	75 bb                	jne    80139f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ee:	48                   	dec    %eax
  8013ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013f6:	74 3d                	je     801435 <ltostr+0xc3>
		start = 1 ;
  8013f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013ff:	eb 34                	jmp    801435 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801401:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801404:	8b 45 0c             	mov    0xc(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80140e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801411:	8b 45 0c             	mov    0xc(%ebp),%eax
  801414:	01 c2                	add    %eax,%edx
  801416:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141c:	01 c8                	add    %ecx,%eax
  80141e:	8a 00                	mov    (%eax),%al
  801420:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801422:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
  801428:	01 c2                	add    %eax,%edx
  80142a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80142d:	88 02                	mov    %al,(%edx)
		start++ ;
  80142f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801432:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801438:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80143b:	7c c4                	jl     801401 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80143d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	01 d0                	add    %edx,%eax
  801445:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801448:	90                   	nop
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 c4 f9 ff ff       	call   800e1d <strlen>
  801459:	83 c4 04             	add    $0x4,%esp
  80145c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80145f:	ff 75 0c             	pushl  0xc(%ebp)
  801462:	e8 b6 f9 ff ff       	call   800e1d <strlen>
  801467:	83 c4 04             	add    $0x4,%esp
  80146a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80146d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 17                	jmp    801494 <strcconcat+0x49>
		final[s] = str1[s] ;
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8b 45 10             	mov    0x10(%ebp),%eax
  801483:	01 c2                	add    %eax,%edx
  801485:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	01 c8                	add    %ecx,%eax
  80148d:	8a 00                	mov    (%eax),%al
  80148f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801491:	ff 45 fc             	incl   -0x4(%ebp)
  801494:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801497:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80149a:	7c e1                	jl     80147d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014aa:	eb 1f                	jmp    8014cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014af:	8d 50 01             	lea    0x1(%eax),%edx
  8014b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014b5:	89 c2                	mov    %eax,%edx
  8014b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ba:	01 c2                	add    %eax,%edx
  8014bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	01 c8                	add    %ecx,%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8014c8:	ff 45 f8             	incl   -0x8(%ebp)
  8014cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014d1:	7c d9                	jl     8014ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	c6 00 00             	movb   $0x0,(%eax)
}
  8014de:	90                   	nop
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fc:	01 d0                	add    %edx,%eax
  8014fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801504:	eb 0c                	jmp    801512 <strsplit+0x31>
			*string++ = 0;
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8d 50 01             	lea    0x1(%eax),%edx
  80150c:	89 55 08             	mov    %edx,0x8(%ebp)
  80150f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	8a 00                	mov    (%eax),%al
  801517:	84 c0                	test   %al,%al
  801519:	74 18                	je     801533 <strsplit+0x52>
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	0f be c0             	movsbl %al,%eax
  801523:	50                   	push   %eax
  801524:	ff 75 0c             	pushl  0xc(%ebp)
  801527:	e8 83 fa ff ff       	call   800faf <strchr>
  80152c:	83 c4 08             	add    $0x8,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 d3                	jne    801506 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 00                	mov    (%eax),%al
  801538:	84 c0                	test   %al,%al
  80153a:	74 5a                	je     801596 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80153c:	8b 45 14             	mov    0x14(%ebp),%eax
  80153f:	8b 00                	mov    (%eax),%eax
  801541:	83 f8 0f             	cmp    $0xf,%eax
  801544:	75 07                	jne    80154d <strsplit+0x6c>
		{
			return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	eb 66                	jmp    8015b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80154d:	8b 45 14             	mov    0x14(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	8d 48 01             	lea    0x1(%eax),%ecx
  801555:	8b 55 14             	mov    0x14(%ebp),%edx
  801558:	89 0a                	mov    %ecx,(%edx)
  80155a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801561:	8b 45 10             	mov    0x10(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80156b:	eb 03                	jmp    801570 <strsplit+0x8f>
			string++;
  80156d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	84 c0                	test   %al,%al
  801577:	74 8b                	je     801504 <strsplit+0x23>
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	0f be c0             	movsbl %al,%eax
  801581:	50                   	push   %eax
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	e8 25 fa ff ff       	call   800faf <strchr>
  80158a:	83 c4 08             	add    $0x8,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	74 dc                	je     80156d <strsplit+0x8c>
			string++;
	}
  801591:	e9 6e ff ff ff       	jmp    801504 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801596:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801597:	8b 45 14             	mov    0x14(%ebp),%eax
  80159a:	8b 00                	mov    (%eax),%eax
  80159c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	01 d0                	add    %edx,%eax
  8015a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8015c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015c8:	eb 4a                	jmp    801614 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8015ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	01 c2                	add    %eax,%edx
  8015d2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	01 c8                	add    %ecx,%eax
  8015da:	8a 00                	mov    (%eax),%al
  8015dc:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8015de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	01 d0                	add    %edx,%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3c 40                	cmp    $0x40,%al
  8015ea:	7e 25                	jle    801611 <str2lower+0x5c>
  8015ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f2:	01 d0                	add    %edx,%eax
  8015f4:	8a 00                	mov    (%eax),%al
  8015f6:	3c 5a                	cmp    $0x5a,%al
  8015f8:	7f 17                	jg     801611 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	01 d0                	add    %edx,%eax
  801602:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	01 ca                	add    %ecx,%edx
  80160a:	8a 12                	mov    (%edx),%dl
  80160c:	83 c2 20             	add    $0x20,%edx
  80160f:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801611:	ff 45 fc             	incl   -0x4(%ebp)
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	e8 01 f8 ff ff       	call   800e1d <strlen>
  80161c:	83 c4 04             	add    $0x4,%esp
  80161f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801622:	7f a6                	jg     8015ca <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801624:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  80162f:	a1 08 40 80 00       	mov    0x804008,%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 42                	je     80167a <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801638:	83 ec 08             	sub    $0x8,%esp
  80163b:	68 00 00 00 82       	push   $0x82000000
  801640:	68 00 00 00 80       	push   $0x80000000
  801645:	e8 00 08 00 00       	call   801e4a <initialize_dynamic_allocator>
  80164a:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  80164d:	e8 e7 05 00 00       	call   801c39 <sys_get_uheap_strategy>
  801652:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801657:	a1 40 40 80 00       	mov    0x804040,%eax
  80165c:	05 00 10 00 00       	add    $0x1000,%eax
  801661:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801666:	a1 10 c1 81 00       	mov    0x81c110,%eax
  80166b:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801670:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801677:	00 00 00 
	}
}
  80167a:	90                   	nop
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	68 06 04 00 00       	push   $0x406
  801699:	50                   	push   %eax
  80169a:	e8 e4 01 00 00       	call   801883 <__sys_allocate_page>
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a9:	79 14                	jns    8016bf <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	68 68 34 80 00       	push   $0x803468
  8016b3:	6a 1f                	push   $0x1f
  8016b5:	68 a4 34 80 00       	push   $0x8034a4
  8016ba:	e8 b7 ed ff ff       	call   800476 <_panic>
	return 0;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	50                   	push   %eax
  8016de:	e8 e7 01 00 00       	call   8018ca <__sys_unmap_frame>
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8016e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ed:	79 14                	jns    801703 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	68 b0 34 80 00       	push   $0x8034b0
  8016f7:	6a 2a                	push   $0x2a
  8016f9:	68 a4 34 80 00       	push   $0x8034a4
  8016fe:	e8 73 ed ff ff       	call   800476 <_panic>
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80170c:	e8 18 ff ff ff       	call   801629 <uheap_init>
	if (size == 0) return NULL ;
  801711:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801715:	75 07                	jne    80171e <malloc+0x18>
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	eb 14                	jmp    801732 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 f0 34 80 00       	push   $0x8034f0
  801726:	6a 3e                	push   $0x3e
  801728:	68 a4 34 80 00       	push   $0x8034a4
  80172d:	e8 44 ed ff ff       	call   800476 <_panic>
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 18 35 80 00       	push   $0x803518
  801742:	6a 49                	push   $0x49
  801744:	68 a4 34 80 00       	push   $0x8034a4
  801749:	e8 28 ed ff ff       	call   800476 <_panic>

0080174e <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80175a:	e8 ca fe ff ff       	call   801629 <uheap_init>
	if (size == 0) return NULL ;
  80175f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801763:	75 07                	jne    80176c <smalloc+0x1e>
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 14                	jmp    801780 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 3c 35 80 00       	push   $0x80353c
  801774:	6a 5a                	push   $0x5a
  801776:	68 a4 34 80 00       	push   $0x8034a4
  80177b:	e8 f6 ec ff ff       	call   800476 <_panic>
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801788:	e8 9c fe ff ff       	call   801629 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 64 35 80 00       	push   $0x803564
  801795:	6a 6a                	push   $0x6a
  801797:	68 a4 34 80 00       	push   $0x8034a4
  80179c:	e8 d5 ec ff ff       	call   800476 <_panic>

008017a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8017a7:	e8 7d fe ff ff       	call   801629 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 88 35 80 00       	push   $0x803588
  8017b4:	68 88 00 00 00       	push   $0x88
  8017b9:	68 a4 34 80 00       	push   $0x8034a4
  8017be:	e8 b3 ec ff ff       	call   800476 <_panic>

008017c3 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 b0 35 80 00       	push   $0x8035b0
  8017d1:	68 9b 00 00 00       	push   $0x9b
  8017d6:	68 a4 34 80 00       	push   $0x8034a4
  8017db:	e8 96 ec ff ff       	call   800476 <_panic>

008017e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	57                   	push   %edi
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017fb:	cd 30                	int    $0x30
  8017fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5f                   	pop    %edi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	8b 45 10             	mov    0x10(%ebp),%eax
  801814:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801817:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	51                   	push   %ecx
  801824:	52                   	push   %edx
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	50                   	push   %eax
  801829:	6a 00                	push   $0x0
  80182b:	e8 b0 ff ff ff       	call   8017e0 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	90                   	nop
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_cgetc>:

int
sys_cgetc(void)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 02                	push   $0x2
  801845:	e8 96 ff ff ff       	call   8017e0 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 03                	push   $0x3
  80185e:	e8 7d ff ff ff       	call   8017e0 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	90                   	nop
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 04                	push   $0x4
  801878:	e8 63 ff ff ff       	call   8017e0 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	90                   	nop
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 08                	push   $0x8
  801896:	e8 45 ff ff ff       	call   8017e0 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	56                   	push   %esi
  8018b5:	53                   	push   %ebx
  8018b6:	51                   	push   %ecx
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 09                	push   $0x9
  8018bb:	e8 20 ff ff ff       	call   8017e0 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    

008018ca <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	6a 0a                	push   $0xa
  8018da:	e8 01 ff ff ff       	call   8017e0 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	6a 0b                	push   $0xb
  8018f5:	e8 e6 fe ff ff       	call   8017e0 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 0c                	push   $0xc
  80190e:	e8 cd fe ff ff       	call   8017e0 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 0d                	push   $0xd
  801927:	e8 b4 fe ff ff       	call   8017e0 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 0e                	push   $0xe
  801940:	e8 9b fe ff ff       	call   8017e0 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 0f                	push   $0xf
  801959:	e8 82 fe ff ff       	call   8017e0 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	ff 75 08             	pushl  0x8(%ebp)
  801971:	6a 10                	push   $0x10
  801973:	e8 68 fe ff ff       	call   8017e0 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 11                	push   $0x11
  80198c:	e8 4f fe ff ff       	call   8017e0 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_cputc>:

void
sys_cputc(const char c)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 04             	sub    $0x4,%esp
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	50                   	push   %eax
  8019b0:	6a 01                	push   $0x1
  8019b2:	e8 29 fe ff ff       	call   8017e0 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	90                   	nop
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 14                	push   $0x14
  8019cc:	e8 0f fe ff ff       	call   8017e0 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	51                   	push   %ecx
  8019f0:	52                   	push   %edx
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	50                   	push   %eax
  8019f5:	6a 15                	push   $0x15
  8019f7:	e8 e4 fd ff ff       	call   8017e0 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	6a 16                	push   $0x16
  801a14:	e8 c7 fd ff ff       	call   8017e0 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	51                   	push   %ecx
  801a2f:	52                   	push   %edx
  801a30:	50                   	push   %eax
  801a31:	6a 17                	push   $0x17
  801a33:	e8 a8 fd ff ff       	call   8017e0 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 18                	push   $0x18
  801a50:	e8 8b fd ff ff       	call   8017e0 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 14             	pushl  0x14(%ebp)
  801a65:	ff 75 10             	pushl  0x10(%ebp)
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	50                   	push   %eax
  801a6c:	6a 19                	push   $0x19
  801a6e:	e8 6d fd ff ff       	call   8017e0 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	50                   	push   %eax
  801a87:	6a 1a                	push   $0x1a
  801a89:	e8 52 fd ff ff       	call   8017e0 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	50                   	push   %eax
  801aa3:	6a 1b                	push   $0x1b
  801aa5:	e8 36 fd ff ff       	call   8017e0 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 05                	push   $0x5
  801abe:	e8 1d fd ff ff       	call   8017e0 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 06                	push   $0x6
  801ad7:	e8 04 fd ff ff       	call   8017e0 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 07                	push   $0x7
  801af0:	e8 eb fc ff ff       	call   8017e0 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_exit_env>:


void sys_exit_env(void)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 1c                	push   $0x1c
  801b09:	e8 d2 fc ff ff       	call   8017e0 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1d:	8d 50 04             	lea    0x4(%eax),%edx
  801b20:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 1d                	push   $0x1d
  801b2d:	e8 ae fc ff ff       	call   8017e0 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return result;
  801b35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b3e:	89 01                	mov    %eax,(%ecx)
  801b40:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	c9                   	leave  
  801b47:	c2 04 00             	ret    $0x4

00801b4a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 10             	pushl  0x10(%ebp)
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 13                	push   $0x13
  801b5c:	e8 7f fc ff ff       	call   8017e0 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 1e                	push   $0x1e
  801b76:	e8 65 fc ff ff       	call   8017e0 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b8c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	50                   	push   %eax
  801b99:	6a 1f                	push   $0x1f
  801b9b:	e8 40 fc ff ff       	call   8017e0 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba3:	90                   	nop
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <rsttst>:
void rsttst()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 21                	push   $0x21
  801bb5:	e8 26 fc ff ff       	call   8017e0 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbd:	90                   	nop
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bcc:	8b 55 18             	mov    0x18(%ebp),%edx
  801bcf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd3:	52                   	push   %edx
  801bd4:	50                   	push   %eax
  801bd5:	ff 75 10             	pushl  0x10(%ebp)
  801bd8:	ff 75 0c             	pushl  0xc(%ebp)
  801bdb:	ff 75 08             	pushl  0x8(%ebp)
  801bde:	6a 20                	push   $0x20
  801be0:	e8 fb fb ff ff       	call   8017e0 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
	return ;
  801be8:	90                   	nop
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <chktst>:
void chktst(uint32 n)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 08             	pushl  0x8(%ebp)
  801bf9:	6a 22                	push   $0x22
  801bfb:	e8 e0 fb ff ff       	call   8017e0 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <inctst>:

void inctst()
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 23                	push   $0x23
  801c15:	e8 c6 fb ff ff       	call   8017e0 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1d:	90                   	nop
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <gettst>:
uint32 gettst()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 24                	push   $0x24
  801c2f:	e8 ac fb ff ff       	call   8017e0 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 25                	push   $0x25
  801c48:	e8 93 fb ff ff       	call   8017e0 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
  801c50:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801c55:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	6a 26                	push   $0x26
  801c74:	e8 67 fb ff ff       	call   8017e0 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c83:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c86:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	53                   	push   %ebx
  801c92:	51                   	push   %ecx
  801c93:	52                   	push   %edx
  801c94:	50                   	push   %eax
  801c95:	6a 27                	push   $0x27
  801c97:	e8 44 fb ff ff       	call   8017e0 <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 28                	push   $0x28
  801cb7:	e8 24 fb ff ff       	call   8017e0 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801cc4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	51                   	push   %ecx
  801cd0:	ff 75 10             	pushl  0x10(%ebp)
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 29                	push   $0x29
  801cd7:	e8 04 fb ff ff       	call   8017e0 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	ff 75 10             	pushl  0x10(%ebp)
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 12                	push   $0x12
  801cf3:	e8 e8 fa ff ff       	call   8017e0 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	52                   	push   %edx
  801d0e:	50                   	push   %eax
  801d0f:	6a 2a                	push   $0x2a
  801d11:	e8 ca fa ff ff       	call   8017e0 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
	return;
  801d19:	90                   	nop
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 2b                	push   $0x2b
  801d2b:	e8 b0 fa ff ff       	call   8017e0 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	ff 75 0c             	pushl  0xc(%ebp)
  801d41:	ff 75 08             	pushl  0x8(%ebp)
  801d44:	6a 2d                	push   $0x2d
  801d46:	e8 95 fa ff ff       	call   8017e0 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	ff 75 08             	pushl  0x8(%ebp)
  801d60:	6a 2c                	push   $0x2c
  801d62:	e8 79 fa ff ff       	call   8017e0 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6a:	90                   	nop
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	68 d4 35 80 00       	push   $0x8035d4
  801d7b:	68 25 01 00 00       	push   $0x125
  801d80:	68 07 36 80 00       	push   $0x803607
  801d85:	e8 ec e6 ff ff       	call   800476 <_panic>

00801d8a <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801d90:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801d97:	72 09                	jb     801da2 <to_page_va+0x18>
  801d99:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801da0:	72 14                	jb     801db6 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	68 18 36 80 00       	push   $0x803618
  801daa:	6a 15                	push   $0x15
  801dac:	68 43 36 80 00       	push   $0x803643
  801db1:	e8 c0 e6 ff ff       	call   800476 <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	ba 60 40 80 00       	mov    $0x804060,%edx
  801dbe:	29 d0                	sub    %edx,%eax
  801dc0:	c1 f8 02             	sar    $0x2,%eax
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	c1 e0 02             	shl    $0x2,%eax
  801dca:	01 d0                	add    %edx,%eax
  801dcc:	c1 e0 02             	shl    $0x2,%eax
  801dcf:	01 d0                	add    %edx,%eax
  801dd1:	c1 e0 02             	shl    $0x2,%eax
  801dd4:	01 d0                	add    %edx,%eax
  801dd6:	89 c1                	mov    %eax,%ecx
  801dd8:	c1 e1 08             	shl    $0x8,%ecx
  801ddb:	01 c8                	add    %ecx,%eax
  801ddd:	89 c1                	mov    %eax,%ecx
  801ddf:	c1 e1 10             	shl    $0x10,%ecx
  801de2:	01 c8                	add    %ecx,%eax
  801de4:	01 c0                	add    %eax,%eax
  801de6:	01 d0                	add    %edx,%eax
  801de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	c1 e0 0c             	shl    $0xc,%eax
  801df1:	89 c2                	mov    %eax,%edx
  801df3:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801df8:	01 d0                	add    %edx,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801e02:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801e07:	8b 55 08             	mov    0x8(%ebp),%edx
  801e0a:	29 c2                	sub    %eax,%edx
  801e0c:	89 d0                	mov    %edx,%eax
  801e0e:	c1 e8 0c             	shr    $0xc,%eax
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e18:	78 09                	js     801e23 <to_page_info+0x27>
  801e1a:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801e21:	7e 14                	jle    801e37 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 5c 36 80 00       	push   $0x80365c
  801e2b:	6a 22                	push   $0x22
  801e2d:	68 43 36 80 00       	push   $0x803643
  801e32:	e8 3f e6 ff ff       	call   800476 <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	01 c0                	add    %eax,%eax
  801e3e:	01 d0                	add    %edx,%eax
  801e40:	c1 e0 02             	shl    $0x2,%eax
  801e43:	05 60 40 80 00       	add    $0x804060,%eax
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	05 00 00 00 02       	add    $0x2000000,%eax
  801e58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e5b:	73 16                	jae    801e73 <initialize_dynamic_allocator+0x29>
  801e5d:	68 80 36 80 00       	push   $0x803680
  801e62:	68 a6 36 80 00       	push   $0x8036a6
  801e67:	6a 34                	push   $0x34
  801e69:	68 43 36 80 00       	push   $0x803643
  801e6e:	e8 03 e6 ff ff       	call   800476 <_panic>
		is_initialized = 1;
  801e73:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e7a:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e88:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e8d:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801e94:	00 00 00 
  801e97:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801e9e:	00 00 00 
  801ea1:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801ea8:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eae:	2b 45 08             	sub    0x8(%ebp),%eax
  801eb1:	c1 e8 0c             	shr    $0xc,%eax
  801eb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801eb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ebe:	e9 c8 00 00 00       	jmp    801f8b <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	01 c0                	add    %eax,%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c1 e0 02             	shl    $0x2,%eax
  801ecf:	05 68 40 80 00       	add    $0x804068,%eax
  801ed4:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	89 d0                	mov    %edx,%eax
  801ede:	01 c0                	add    %eax,%eax
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	c1 e0 02             	shl    $0x2,%eax
  801ee5:	05 6a 40 80 00       	add    $0x80406a,%eax
  801eea:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801eef:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ef5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ef8:	89 c8                	mov    %ecx,%eax
  801efa:	01 c0                	add    %eax,%eax
  801efc:	01 c8                	add    %ecx,%eax
  801efe:	c1 e0 02             	shl    $0x2,%eax
  801f01:	05 64 40 80 00       	add    $0x804064,%eax
  801f06:	89 10                	mov    %edx,(%eax)
  801f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0b:	89 d0                	mov    %edx,%eax
  801f0d:	01 c0                	add    %eax,%eax
  801f0f:	01 d0                	add    %edx,%eax
  801f11:	c1 e0 02             	shl    $0x2,%eax
  801f14:	05 64 40 80 00       	add    $0x804064,%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	74 1b                	je     801f3a <initialize_dynamic_allocator+0xf0>
  801f1f:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801f25:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f28:	89 c8                	mov    %ecx,%eax
  801f2a:	01 c0                	add    %eax,%eax
  801f2c:	01 c8                	add    %ecx,%eax
  801f2e:	c1 e0 02             	shl    $0x2,%eax
  801f31:	05 60 40 80 00       	add    $0x804060,%eax
  801f36:	89 02                	mov    %eax,(%edx)
  801f38:	eb 16                	jmp    801f50 <initialize_dynamic_allocator+0x106>
  801f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3d:	89 d0                	mov    %edx,%eax
  801f3f:	01 c0                	add    %eax,%eax
  801f41:	01 d0                	add    %edx,%eax
  801f43:	c1 e0 02             	shl    $0x2,%eax
  801f46:	05 60 40 80 00       	add    $0x804060,%eax
  801f4b:	a3 48 40 80 00       	mov    %eax,0x804048
  801f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	01 c0                	add    %eax,%eax
  801f57:	01 d0                	add    %edx,%eax
  801f59:	c1 e0 02             	shl    $0x2,%eax
  801f5c:	05 60 40 80 00       	add    $0x804060,%eax
  801f61:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f69:	89 d0                	mov    %edx,%eax
  801f6b:	01 c0                	add    %eax,%eax
  801f6d:	01 d0                	add    %edx,%eax
  801f6f:	c1 e0 02             	shl    $0x2,%eax
  801f72:	05 60 40 80 00       	add    $0x804060,%eax
  801f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f7d:	a1 54 40 80 00       	mov    0x804054,%eax
  801f82:	40                   	inc    %eax
  801f83:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f88:	ff 45 f4             	incl   -0xc(%ebp)
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f91:	0f 8c 2c ff ff ff    	jl     801ec3 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f9e:	eb 36                	jmp    801fd6 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	c1 e0 04             	shl    $0x4,%eax
  801fa6:	05 80 c0 81 00       	add    $0x81c080,%eax
  801fab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb4:	c1 e0 04             	shl    $0x4,%eax
  801fb7:	05 84 c0 81 00       	add    $0x81c084,%eax
  801fbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	c1 e0 04             	shl    $0x4,%eax
  801fc8:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801fd3:	ff 45 f0             	incl   -0x10(%ebp)
  801fd6:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801fda:	7e c4                	jle    801fa0 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	50                   	push   %eax
  801fec:	e8 0b fe ff ff       	call   801dfc <to_page_info>
  801ff1:	83 c4 10             	add    $0x10,%esp
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	8b 40 08             	mov    0x8(%eax),%eax
  801ffd:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	e8 77 fd ff ff       	call   801d8a <to_page_va>
  802013:	83 c4 10             	add    $0x10,%esp
  802016:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802019:	b8 00 10 00 00       	mov    $0x1000,%eax
  80201e:	ba 00 00 00 00       	mov    $0x0,%edx
  802023:	f7 75 08             	divl   0x8(%ebp)
  802026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	50                   	push   %eax
  802030:	e8 48 f6 ff ff       	call   80167d <get_page>
  802035:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80203e:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  80204c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802053:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80205a:	eb 19                	jmp    802075 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	ba 01 00 00 00       	mov    $0x1,%edx
  802064:	88 c1                	mov    %al,%cl
  802066:	d3 e2                	shl    %cl,%edx
  802068:	89 d0                	mov    %edx,%eax
  80206a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80206d:	74 0e                	je     80207d <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  80206f:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802072:	ff 45 f0             	incl   -0x10(%ebp)
  802075:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802079:	7e e1                	jle    80205c <split_page_to_blocks+0x5a>
  80207b:	eb 01                	jmp    80207e <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  80207d:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80207e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802085:	e9 a7 00 00 00       	jmp    802131 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  80208a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208d:	0f af 45 08          	imul   0x8(%ebp),%eax
  802091:	89 c2                	mov    %eax,%edx
  802093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802096:	01 d0                	add    %edx,%eax
  802098:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  80209b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80209f:	75 14                	jne    8020b5 <split_page_to_blocks+0xb3>
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	68 bc 36 80 00       	push   $0x8036bc
  8020a9:	6a 7c                	push   $0x7c
  8020ab:	68 43 36 80 00       	push   $0x803643
  8020b0:	e8 c1 e3 ff ff       	call   800476 <_panic>
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	c1 e0 04             	shl    $0x4,%eax
  8020bb:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020c0:	8b 10                	mov    (%eax),%edx
  8020c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020c5:	89 50 04             	mov    %edx,0x4(%eax)
  8020c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cb:	8b 40 04             	mov    0x4(%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 14                	je     8020e6 <split_page_to_blocks+0xe4>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	c1 e0 04             	shl    $0x4,%eax
  8020d8:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020dd:	8b 00                	mov    (%eax),%eax
  8020df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e2:	89 10                	mov    %edx,(%eax)
  8020e4:	eb 11                	jmp    8020f7 <split_page_to_blocks+0xf5>
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	c1 e0 04             	shl    $0x4,%eax
  8020ec:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8020f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020f5:	89 02                	mov    %eax,(%edx)
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	c1 e0 04             	shl    $0x4,%eax
  8020fd:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802106:	89 02                	mov    %eax,(%edx)
  802108:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80210b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	c1 e0 04             	shl    $0x4,%eax
  802117:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	8d 50 01             	lea    0x1(%eax),%edx
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	c1 e0 04             	shl    $0x4,%eax
  802127:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80212c:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  80212e:	ff 45 ec             	incl   -0x14(%ebp)
  802131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802134:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  802137:	0f 82 4d ff ff ff    	jb     80208a <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  80213d:	90                   	nop
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  802146:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80214d:	76 19                	jbe    802168 <alloc_block+0x28>
  80214f:	68 e0 36 80 00       	push   $0x8036e0
  802154:	68 a6 36 80 00       	push   $0x8036a6
  802159:	68 8a 00 00 00       	push   $0x8a
  80215e:	68 43 36 80 00       	push   $0x803643
  802163:	e8 0e e3 ff ff       	call   800476 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80216f:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802176:	eb 19                	jmp    802191 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217b:	ba 01 00 00 00       	mov    $0x1,%edx
  802180:	88 c1                	mov    %al,%cl
  802182:	d3 e2                	shl    %cl,%edx
  802184:	89 d0                	mov    %edx,%eax
  802186:	3b 45 08             	cmp    0x8(%ebp),%eax
  802189:	73 0e                	jae    802199 <alloc_block+0x59>
		idx++;
  80218b:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80218e:	ff 45 f0             	incl   -0x10(%ebp)
  802191:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802195:	7e e1                	jle    802178 <alloc_block+0x38>
  802197:	eb 01                	jmp    80219a <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802199:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	c1 e0 04             	shl    $0x4,%eax
  8021a0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 84 df 00 00 00    	je     80228e <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	c1 e0 04             	shl    $0x4,%eax
  8021b5:	05 80 c0 81 00       	add    $0x81c080,%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8021bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021c3:	75 17                	jne    8021dc <alloc_block+0x9c>
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	68 01 37 80 00       	push   $0x803701
  8021cd:	68 9e 00 00 00       	push   $0x9e
  8021d2:	68 43 36 80 00       	push   $0x803643
  8021d7:	e8 9a e2 ff ff       	call   800476 <_panic>
  8021dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	74 10                	je     8021f5 <alloc_block+0xb5>
  8021e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ed:	8b 52 04             	mov    0x4(%edx),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	eb 14                	jmp    802209 <alloc_block+0xc9>
  8021f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f8:	8b 40 04             	mov    0x4(%eax),%eax
  8021fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fe:	c1 e2 04             	shl    $0x4,%edx
  802201:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802207:	89 02                	mov    %eax,(%edx)
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	8b 40 04             	mov    0x4(%eax),%eax
  80220f:	85 c0                	test   %eax,%eax
  802211:	74 0f                	je     802222 <alloc_block+0xe2>
  802213:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802216:	8b 40 04             	mov    0x4(%eax),%eax
  802219:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80221c:	8b 12                	mov    (%edx),%edx
  80221e:	89 10                	mov    %edx,(%eax)
  802220:	eb 13                	jmp    802235 <alloc_block+0xf5>
  802222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802225:	8b 00                	mov    (%eax),%eax
  802227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222a:	c1 e2 04             	shl    $0x4,%edx
  80222d:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802233:	89 02                	mov    %eax,(%edx)
  802235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	c1 e0 04             	shl    $0x4,%eax
  80224e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	8d 50 ff             	lea    -0x1(%eax),%edx
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	c1 e0 04             	shl    $0x4,%eax
  80225e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802263:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802268:	83 ec 0c             	sub    $0xc,%esp
  80226b:	50                   	push   %eax
  80226c:	e8 8b fb ff ff       	call   801dfc <to_page_info>
  802271:	83 c4 10             	add    $0x10,%esp
  802274:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  802277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227a:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80227e:	48                   	dec    %eax
  80227f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802282:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802289:	e9 bc 02 00 00       	jmp    80254a <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  80228e:	a1 54 40 80 00       	mov    0x804054,%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	0f 84 7d 02 00 00    	je     802518 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  80229b:	a1 48 40 80 00       	mov    0x804048,%eax
  8022a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  8022a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022a7:	75 17                	jne    8022c0 <alloc_block+0x180>
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 01 37 80 00       	push   $0x803701
  8022b1:	68 a9 00 00 00       	push   $0xa9
  8022b6:	68 43 36 80 00       	push   $0x803643
  8022bb:	e8 b6 e1 ff ff       	call   800476 <_panic>
  8022c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 10                	je     8022d9 <alloc_block+0x199>
  8022c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022d1:	8b 52 04             	mov    0x4(%edx),%edx
  8022d4:	89 50 04             	mov    %edx,0x4(%eax)
  8022d7:	eb 0b                	jmp    8022e4 <alloc_block+0x1a4>
  8022d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 0f                	je     8022fd <alloc_block+0x1bd>
  8022ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8022f7:	8b 12                	mov    (%edx),%edx
  8022f9:	89 10                	mov    %edx,(%eax)
  8022fb:	eb 0a                	jmp    802307 <alloc_block+0x1c7>
  8022fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	a3 48 40 80 00       	mov    %eax,0x804048
  802307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231a:	a1 54 40 80 00       	mov    0x804054,%eax
  80231f:	48                   	dec    %eax
  802320:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	83 c0 03             	add    $0x3,%eax
  80232b:	ba 01 00 00 00       	mov    $0x1,%edx
  802330:	88 c1                	mov    %al,%cl
  802332:	d3 e2                	shl    %cl,%edx
  802334:	89 d0                	mov    %edx,%eax
  802336:	83 ec 08             	sub    $0x8,%esp
  802339:	ff 75 e4             	pushl  -0x1c(%ebp)
  80233c:	50                   	push   %eax
  80233d:	e8 c0 fc ff ff       	call   802002 <split_page_to_blocks>
  802342:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	c1 e0 04             	shl    $0x4,%eax
  80234b:	05 80 c0 81 00       	add    $0x81c080,%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802355:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802359:	75 17                	jne    802372 <alloc_block+0x232>
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	68 01 37 80 00       	push   $0x803701
  802363:	68 b0 00 00 00       	push   $0xb0
  802368:	68 43 36 80 00       	push   $0x803643
  80236d:	e8 04 e1 ff ff       	call   800476 <_panic>
  802372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 10                	je     80238b <alloc_block+0x24b>
  80237b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802383:	8b 52 04             	mov    0x4(%edx),%edx
  802386:	89 50 04             	mov    %edx,0x4(%eax)
  802389:	eb 14                	jmp    80239f <alloc_block+0x25f>
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	c1 e2 04             	shl    $0x4,%edx
  802397:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80239d:	89 02                	mov    %eax,(%edx)
  80239f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a2:	8b 40 04             	mov    0x4(%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 0f                	je     8023b8 <alloc_block+0x278>
  8023a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ac:	8b 40 04             	mov    0x4(%eax),%eax
  8023af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023b2:	8b 12                	mov    (%edx),%edx
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	eb 13                	jmp    8023cb <alloc_block+0x28b>
  8023b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c0:	c1 e2 04             	shl    $0x4,%edx
  8023c3:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8023c9:	89 02                	mov    %eax,(%edx)
  8023cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c1 e0 04             	shl    $0x4,%eax
  8023e4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c1 e0 04             	shl    $0x4,%eax
  8023f4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023f9:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8023fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fe:	83 ec 0c             	sub    $0xc,%esp
  802401:	50                   	push   %eax
  802402:	e8 f5 f9 ff ff       	call   801dfc <to_page_info>
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  80240d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802410:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802414:	48                   	dec    %eax
  802415:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802418:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  80241c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241f:	e9 26 01 00 00       	jmp    80254a <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802424:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	c1 e0 04             	shl    $0x4,%eax
  80242d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	0f 84 dc 00 00 00    	je     802518 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c1 e0 04             	shl    $0x4,%eax
  802442:	05 80 c0 81 00       	add    $0x81c080,%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  80244c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802450:	75 17                	jne    802469 <alloc_block+0x329>
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	68 01 37 80 00       	push   $0x803701
  80245a:	68 be 00 00 00       	push   $0xbe
  80245f:	68 43 36 80 00       	push   $0x803643
  802464:	e8 0d e0 ff ff       	call   800476 <_panic>
  802469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	85 c0                	test   %eax,%eax
  802470:	74 10                	je     802482 <alloc_block+0x342>
  802472:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80247a:	8b 52 04             	mov    0x4(%edx),%edx
  80247d:	89 50 04             	mov    %edx,0x4(%eax)
  802480:	eb 14                	jmp    802496 <alloc_block+0x356>
  802482:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802485:	8b 40 04             	mov    0x4(%eax),%eax
  802488:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248b:	c1 e2 04             	shl    $0x4,%edx
  80248e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802494:	89 02                	mov    %eax,(%edx)
  802496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 0f                	je     8024af <alloc_block+0x36f>
  8024a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024a9:	8b 12                	mov    (%edx),%edx
  8024ab:	89 10                	mov    %edx,(%eax)
  8024ad:	eb 13                	jmp    8024c2 <alloc_block+0x382>
  8024af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b7:	c1 e2 04             	shl    $0x4,%edx
  8024ba:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024c0:	89 02                	mov    %eax,(%edx)
  8024c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	c1 e0 04             	shl    $0x4,%eax
  8024db:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	c1 e0 04             	shl    $0x4,%eax
  8024eb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024f0:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8024f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	50                   	push   %eax
  8024f9:	e8 fe f8 ff ff       	call   801dfc <to_page_info>
  8024fe:	83 c4 10             	add    $0x10,%esp
  802501:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802504:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802507:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80250b:	48                   	dec    %eax
  80250c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80250f:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802513:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802516:	eb 32                	jmp    80254a <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802518:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  80251c:	77 15                	ja     802533 <alloc_block+0x3f3>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	c1 e0 04             	shl    $0x4,%eax
  802524:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	0f 84 f1 fe ff ff    	je     802424 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802533:	83 ec 04             	sub    $0x4,%esp
  802536:	68 1f 37 80 00       	push   $0x80371f
  80253b:	68 c8 00 00 00       	push   $0xc8
  802540:	68 43 36 80 00       	push   $0x803643
  802545:	e8 2c df ff ff       	call   800476 <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
  802555:	a1 64 c0 81 00       	mov    0x81c064,%eax
  80255a:	39 c2                	cmp    %eax,%edx
  80255c:	72 0c                	jb     80256a <free_block+0x1e>
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	a1 40 40 80 00       	mov    0x804040,%eax
  802566:	39 c2                	cmp    %eax,%edx
  802568:	72 19                	jb     802583 <free_block+0x37>
  80256a:	68 30 37 80 00       	push   $0x803730
  80256f:	68 a6 36 80 00       	push   $0x8036a6
  802574:	68 d7 00 00 00       	push   $0xd7
  802579:	68 43 36 80 00       	push   $0x803643
  80257e:	e8 f3 de ff ff       	call   800476 <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	83 ec 0c             	sub    $0xc,%esp
  80258f:	50                   	push   %eax
  802590:	e8 67 f8 ff ff       	call   801dfc <to_page_info>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 40 08             	mov    0x8(%eax),%eax
  8025a1:	0f b7 c0             	movzwl %ax,%eax
  8025a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  8025a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025ae:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8025b5:	eb 19                	jmp    8025d0 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	ba 01 00 00 00       	mov    $0x1,%edx
  8025bf:	88 c1                	mov    %al,%cl
  8025c1:	d3 e2                	shl    %cl,%edx
  8025c3:	89 d0                	mov    %edx,%eax
  8025c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8025c8:	74 0e                	je     8025d8 <free_block+0x8c>
	        break;
	    idx++;
  8025ca:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8025cd:	ff 45 f0             	incl   -0x10(%ebp)
  8025d0:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8025d4:	7e e1                	jle    8025b7 <free_block+0x6b>
  8025d6:	eb 01                	jmp    8025d9 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8025d8:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8025d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025dc:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8025e0:	40                   	inc    %eax
  8025e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025e4:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8025e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025ec:	75 17                	jne    802605 <free_block+0xb9>
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	68 bc 36 80 00       	push   $0x8036bc
  8025f6:	68 ee 00 00 00       	push   $0xee
  8025fb:	68 43 36 80 00       	push   $0x803643
  802600:	e8 71 de ff ff       	call   800476 <_panic>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	c1 e0 04             	shl    $0x4,%eax
  80260b:	05 84 c0 81 00       	add    $0x81c084,%eax
  802610:	8b 10                	mov    (%eax),%edx
  802612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802615:	89 50 04             	mov    %edx,0x4(%eax)
  802618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261b:	8b 40 04             	mov    0x4(%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 14                	je     802636 <free_block+0xea>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	c1 e0 04             	shl    $0x4,%eax
  802628:	05 84 c0 81 00       	add    $0x81c084,%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802632:	89 10                	mov    %edx,(%eax)
  802634:	eb 11                	jmp    802647 <free_block+0xfb>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	c1 e0 04             	shl    $0x4,%eax
  80263c:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802645:	89 02                	mov    %eax,(%edx)
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	c1 e0 04             	shl    $0x4,%eax
  80264d:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802653:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802656:	89 02                	mov    %eax,(%edx)
  802658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	c1 e0 04             	shl    $0x4,%eax
  802667:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	8d 50 01             	lea    0x1(%eax),%edx
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	c1 e0 04             	shl    $0x4,%eax
  802677:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80267c:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  80267e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802683:	ba 00 00 00 00       	mov    $0x0,%edx
  802688:	f7 75 e0             	divl   -0x20(%ebp)
  80268b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  80268e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802691:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802695:	0f b7 c0             	movzwl %ax,%eax
  802698:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80269b:	0f 85 70 01 00 00    	jne    802811 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026a7:	e8 de f6 ff ff       	call   801d8a <to_page_va>
  8026ac:	83 c4 10             	add    $0x10,%esp
  8026af:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8026b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8026b9:	e9 b7 00 00 00       	jmp    802775 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8026be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8026c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c4:	01 d0                	add    %edx,%eax
  8026c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8026c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8026cd:	75 17                	jne    8026e6 <free_block+0x19a>
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 01 37 80 00       	push   $0x803701
  8026d7:	68 f8 00 00 00       	push   $0xf8
  8026dc:	68 43 36 80 00       	push   $0x803643
  8026e1:	e8 90 dd ff ff       	call   800476 <_panic>
  8026e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 10                	je     8026ff <free_block+0x1b3>
  8026ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026f7:	8b 52 04             	mov    0x4(%edx),%edx
  8026fa:	89 50 04             	mov    %edx,0x4(%eax)
  8026fd:	eb 14                	jmp    802713 <free_block+0x1c7>
  8026ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	c1 e2 04             	shl    $0x4,%edx
  80270b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802711:	89 02                	mov    %eax,(%edx)
  802713:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 0f                	je     80272c <free_block+0x1e0>
  80271d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802726:	8b 12                	mov    (%edx),%edx
  802728:	89 10                	mov    %edx,(%eax)
  80272a:	eb 13                	jmp    80273f <free_block+0x1f3>
  80272c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802734:	c1 e2 04             	shl    $0x4,%edx
  802737:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80273d:	89 02                	mov    %eax,(%edx)
  80273f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802742:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80274b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c1 e0 04             	shl    $0x4,%eax
  802758:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	c1 e0 04             	shl    $0x4,%eax
  802768:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80276d:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  80276f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802772:	01 45 ec             	add    %eax,-0x14(%ebp)
  802775:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  80277c:	0f 86 3c ff ff ff    	jbe    8026be <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  80278b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278e:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802794:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802798:	75 17                	jne    8027b1 <free_block+0x265>
  80279a:	83 ec 04             	sub    $0x4,%esp
  80279d:	68 bc 36 80 00       	push   $0x8036bc
  8027a2:	68 fe 00 00 00       	push   $0xfe
  8027a7:	68 43 36 80 00       	push   $0x803643
  8027ac:	e8 c5 dc ff ff       	call   800476 <_panic>
  8027b1:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8027b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ba:	89 50 04             	mov    %edx,0x4(%eax)
  8027bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 0c                	je     8027d3 <free_block+0x287>
  8027c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027cf:	89 10                	mov    %edx,(%eax)
  8027d1:	eb 08                	jmp    8027db <free_block+0x28f>
  8027d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d6:	a3 48 40 80 00       	mov    %eax,0x804048
  8027db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027de:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8027e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ec:	a1 54 40 80 00       	mov    0x804054,%eax
  8027f1:	40                   	inc    %eax
  8027f2:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8027f7:	83 ec 0c             	sub    $0xc,%esp
  8027fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8027fd:	e8 88 f5 ff ff       	call   801d8a <to_page_va>
  802802:	83 c4 10             	add    $0x10,%esp
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	50                   	push   %eax
  802809:	e8 b8 ee ff ff       	call   8016c6 <return_page>
  80280e:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802811:	90                   	nop
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80281a:	83 ec 04             	sub    $0x4,%esp
  80281d:	68 68 37 80 00       	push   $0x803768
  802822:	68 11 01 00 00       	push   $0x111
  802827:	68 43 36 80 00       	push   $0x803643
  80282c:	e8 45 dc ff ff       	call   800476 <_panic>

00802831 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802831:	55                   	push   %ebp
  802832:	89 e5                	mov    %esp,%ebp
  802834:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802837:	8b 55 08             	mov    0x8(%ebp),%edx
  80283a:	89 d0                	mov    %edx,%eax
  80283c:	c1 e0 02             	shl    $0x2,%eax
  80283f:	01 d0                	add    %edx,%eax
  802841:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802848:	01 d0                	add    %edx,%eax
  80284a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802851:	01 d0                	add    %edx,%eax
  802853:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80285a:	01 d0                	add    %edx,%eax
  80285c:	c1 e0 04             	shl    $0x4,%eax
  80285f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  802862:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  802869:	0f 31                	rdtsc  
  80286b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80286e:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802874:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802877:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80287a:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  80287d:	eb 46                	jmp    8028c5 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  80287f:	0f 31                	rdtsc  
  802881:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802884:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  802887:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80288a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80288d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802890:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	29 c2                	sub    %eax,%edx
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8028a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	89 d1                	mov    %edx,%ecx
  8028a8:	29 c1                	sub    %eax,%ecx
  8028aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8028ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	0f 97 c0             	seta   %al
  8028b5:	0f b6 c0             	movzbl %al,%eax
  8028b8:	29 c1                	sub    %eax,%ecx
  8028ba:	89 c8                	mov    %ecx,%eax
  8028bc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8028bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8028c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  8028c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8028cb:	72 b2                	jb     80287f <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8028cd:	90                   	nop
  8028ce:	c9                   	leave  
  8028cf:	c3                   	ret    

008028d0 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8028d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8028dd:	eb 03                	jmp    8028e2 <busy_wait+0x12>
  8028df:	ff 45 fc             	incl   -0x4(%ebp)
  8028e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e8:	72 f5                	jb     8028df <busy_wait+0xf>
	return i;
  8028ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8028ed:	c9                   	leave  
  8028ee:	c3                   	ret    
  8028ef:	90                   	nop

008028f0 <__udivdi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	53                   	push   %ebx
  8028f4:	83 ec 1c             	sub    $0x1c,%esp
  8028f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802903:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802907:	89 ca                	mov    %ecx,%edx
  802909:	89 f8                	mov    %edi,%eax
  80290b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80290f:	85 f6                	test   %esi,%esi
  802911:	75 2d                	jne    802940 <__udivdi3+0x50>
  802913:	39 cf                	cmp    %ecx,%edi
  802915:	77 65                	ja     80297c <__udivdi3+0x8c>
  802917:	89 fd                	mov    %edi,%ebp
  802919:	85 ff                	test   %edi,%edi
  80291b:	75 0b                	jne    802928 <__udivdi3+0x38>
  80291d:	b8 01 00 00 00       	mov    $0x1,%eax
  802922:	31 d2                	xor    %edx,%edx
  802924:	f7 f7                	div    %edi
  802926:	89 c5                	mov    %eax,%ebp
  802928:	31 d2                	xor    %edx,%edx
  80292a:	89 c8                	mov    %ecx,%eax
  80292c:	f7 f5                	div    %ebp
  80292e:	89 c1                	mov    %eax,%ecx
  802930:	89 d8                	mov    %ebx,%eax
  802932:	f7 f5                	div    %ebp
  802934:	89 cf                	mov    %ecx,%edi
  802936:	89 fa                	mov    %edi,%edx
  802938:	83 c4 1c             	add    $0x1c,%esp
  80293b:	5b                   	pop    %ebx
  80293c:	5e                   	pop    %esi
  80293d:	5f                   	pop    %edi
  80293e:	5d                   	pop    %ebp
  80293f:	c3                   	ret    
  802940:	39 ce                	cmp    %ecx,%esi
  802942:	77 28                	ja     80296c <__udivdi3+0x7c>
  802944:	0f bd fe             	bsr    %esi,%edi
  802947:	83 f7 1f             	xor    $0x1f,%edi
  80294a:	75 40                	jne    80298c <__udivdi3+0x9c>
  80294c:	39 ce                	cmp    %ecx,%esi
  80294e:	72 0a                	jb     80295a <__udivdi3+0x6a>
  802950:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802954:	0f 87 9e 00 00 00    	ja     8029f8 <__udivdi3+0x108>
  80295a:	b8 01 00 00 00       	mov    $0x1,%eax
  80295f:	89 fa                	mov    %edi,%edx
  802961:	83 c4 1c             	add    $0x1c,%esp
  802964:	5b                   	pop    %ebx
  802965:	5e                   	pop    %esi
  802966:	5f                   	pop    %edi
  802967:	5d                   	pop    %ebp
  802968:	c3                   	ret    
  802969:	8d 76 00             	lea    0x0(%esi),%esi
  80296c:	31 ff                	xor    %edi,%edi
  80296e:	31 c0                	xor    %eax,%eax
  802970:	89 fa                	mov    %edi,%edx
  802972:	83 c4 1c             	add    $0x1c,%esp
  802975:	5b                   	pop    %ebx
  802976:	5e                   	pop    %esi
  802977:	5f                   	pop    %edi
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    
  80297a:	66 90                	xchg   %ax,%ax
  80297c:	89 d8                	mov    %ebx,%eax
  80297e:	f7 f7                	div    %edi
  802980:	31 ff                	xor    %edi,%edi
  802982:	89 fa                	mov    %edi,%edx
  802984:	83 c4 1c             	add    $0x1c,%esp
  802987:	5b                   	pop    %ebx
  802988:	5e                   	pop    %esi
  802989:	5f                   	pop    %edi
  80298a:	5d                   	pop    %ebp
  80298b:	c3                   	ret    
  80298c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802991:	89 eb                	mov    %ebp,%ebx
  802993:	29 fb                	sub    %edi,%ebx
  802995:	89 f9                	mov    %edi,%ecx
  802997:	d3 e6                	shl    %cl,%esi
  802999:	89 c5                	mov    %eax,%ebp
  80299b:	88 d9                	mov    %bl,%cl
  80299d:	d3 ed                	shr    %cl,%ebp
  80299f:	89 e9                	mov    %ebp,%ecx
  8029a1:	09 f1                	or     %esi,%ecx
  8029a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029a7:	89 f9                	mov    %edi,%ecx
  8029a9:	d3 e0                	shl    %cl,%eax
  8029ab:	89 c5                	mov    %eax,%ebp
  8029ad:	89 d6                	mov    %edx,%esi
  8029af:	88 d9                	mov    %bl,%cl
  8029b1:	d3 ee                	shr    %cl,%esi
  8029b3:	89 f9                	mov    %edi,%ecx
  8029b5:	d3 e2                	shl    %cl,%edx
  8029b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029bb:	88 d9                	mov    %bl,%cl
  8029bd:	d3 e8                	shr    %cl,%eax
  8029bf:	09 c2                	or     %eax,%edx
  8029c1:	89 d0                	mov    %edx,%eax
  8029c3:	89 f2                	mov    %esi,%edx
  8029c5:	f7 74 24 0c          	divl   0xc(%esp)
  8029c9:	89 d6                	mov    %edx,%esi
  8029cb:	89 c3                	mov    %eax,%ebx
  8029cd:	f7 e5                	mul    %ebp
  8029cf:	39 d6                	cmp    %edx,%esi
  8029d1:	72 19                	jb     8029ec <__udivdi3+0xfc>
  8029d3:	74 0b                	je     8029e0 <__udivdi3+0xf0>
  8029d5:	89 d8                	mov    %ebx,%eax
  8029d7:	31 ff                	xor    %edi,%edi
  8029d9:	e9 58 ff ff ff       	jmp    802936 <__udivdi3+0x46>
  8029de:	66 90                	xchg   %ax,%ax
  8029e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8029e4:	89 f9                	mov    %edi,%ecx
  8029e6:	d3 e2                	shl    %cl,%edx
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	73 e9                	jae    8029d5 <__udivdi3+0xe5>
  8029ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029ef:	31 ff                	xor    %edi,%edi
  8029f1:	e9 40 ff ff ff       	jmp    802936 <__udivdi3+0x46>
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	31 c0                	xor    %eax,%eax
  8029fa:	e9 37 ff ff ff       	jmp    802936 <__udivdi3+0x46>
  8029ff:	90                   	nop

00802a00 <__umoddi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	53                   	push   %ebx
  802a04:	83 ec 1c             	sub    $0x1c,%esp
  802a07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a1f:	89 f3                	mov    %esi,%ebx
  802a21:	89 fa                	mov    %edi,%edx
  802a23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a27:	89 34 24             	mov    %esi,(%esp)
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	75 1a                	jne    802a48 <__umoddi3+0x48>
  802a2e:	39 f7                	cmp    %esi,%edi
  802a30:	0f 86 a2 00 00 00    	jbe    802ad8 <__umoddi3+0xd8>
  802a36:	89 c8                	mov    %ecx,%eax
  802a38:	89 f2                	mov    %esi,%edx
  802a3a:	f7 f7                	div    %edi
  802a3c:	89 d0                	mov    %edx,%eax
  802a3e:	31 d2                	xor    %edx,%edx
  802a40:	83 c4 1c             	add    $0x1c,%esp
  802a43:	5b                   	pop    %ebx
  802a44:	5e                   	pop    %esi
  802a45:	5f                   	pop    %edi
  802a46:	5d                   	pop    %ebp
  802a47:	c3                   	ret    
  802a48:	39 f0                	cmp    %esi,%eax
  802a4a:	0f 87 ac 00 00 00    	ja     802afc <__umoddi3+0xfc>
  802a50:	0f bd e8             	bsr    %eax,%ebp
  802a53:	83 f5 1f             	xor    $0x1f,%ebp
  802a56:	0f 84 ac 00 00 00    	je     802b08 <__umoddi3+0x108>
  802a5c:	bf 20 00 00 00       	mov    $0x20,%edi
  802a61:	29 ef                	sub    %ebp,%edi
  802a63:	89 fe                	mov    %edi,%esi
  802a65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	d3 e0                	shl    %cl,%eax
  802a6d:	89 d7                	mov    %edx,%edi
  802a6f:	89 f1                	mov    %esi,%ecx
  802a71:	d3 ef                	shr    %cl,%edi
  802a73:	09 c7                	or     %eax,%edi
  802a75:	89 e9                	mov    %ebp,%ecx
  802a77:	d3 e2                	shl    %cl,%edx
  802a79:	89 14 24             	mov    %edx,(%esp)
  802a7c:	89 d8                	mov    %ebx,%eax
  802a7e:	d3 e0                	shl    %cl,%eax
  802a80:	89 c2                	mov    %eax,%edx
  802a82:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a86:	d3 e0                	shl    %cl,%eax
  802a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a90:	89 f1                	mov    %esi,%ecx
  802a92:	d3 e8                	shr    %cl,%eax
  802a94:	09 d0                	or     %edx,%eax
  802a96:	d3 eb                	shr    %cl,%ebx
  802a98:	89 da                	mov    %ebx,%edx
  802a9a:	f7 f7                	div    %edi
  802a9c:	89 d3                	mov    %edx,%ebx
  802a9e:	f7 24 24             	mull   (%esp)
  802aa1:	89 c6                	mov    %eax,%esi
  802aa3:	89 d1                	mov    %edx,%ecx
  802aa5:	39 d3                	cmp    %edx,%ebx
  802aa7:	0f 82 87 00 00 00    	jb     802b34 <__umoddi3+0x134>
  802aad:	0f 84 91 00 00 00    	je     802b44 <__umoddi3+0x144>
  802ab3:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ab7:	29 f2                	sub    %esi,%edx
  802ab9:	19 cb                	sbb    %ecx,%ebx
  802abb:	89 d8                	mov    %ebx,%eax
  802abd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802ac1:	d3 e0                	shl    %cl,%eax
  802ac3:	89 e9                	mov    %ebp,%ecx
  802ac5:	d3 ea                	shr    %cl,%edx
  802ac7:	09 d0                	or     %edx,%eax
  802ac9:	89 e9                	mov    %ebp,%ecx
  802acb:	d3 eb                	shr    %cl,%ebx
  802acd:	89 da                	mov    %ebx,%edx
  802acf:	83 c4 1c             	add    $0x1c,%esp
  802ad2:	5b                   	pop    %ebx
  802ad3:	5e                   	pop    %esi
  802ad4:	5f                   	pop    %edi
  802ad5:	5d                   	pop    %ebp
  802ad6:	c3                   	ret    
  802ad7:	90                   	nop
  802ad8:	89 fd                	mov    %edi,%ebp
  802ada:	85 ff                	test   %edi,%edi
  802adc:	75 0b                	jne    802ae9 <__umoddi3+0xe9>
  802ade:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae3:	31 d2                	xor    %edx,%edx
  802ae5:	f7 f7                	div    %edi
  802ae7:	89 c5                	mov    %eax,%ebp
  802ae9:	89 f0                	mov    %esi,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f5                	div    %ebp
  802aef:	89 c8                	mov    %ecx,%eax
  802af1:	f7 f5                	div    %ebp
  802af3:	89 d0                	mov    %edx,%eax
  802af5:	e9 44 ff ff ff       	jmp    802a3e <__umoddi3+0x3e>
  802afa:	66 90                	xchg   %ax,%ax
  802afc:	89 c8                	mov    %ecx,%eax
  802afe:	89 f2                	mov    %esi,%edx
  802b00:	83 c4 1c             	add    $0x1c,%esp
  802b03:	5b                   	pop    %ebx
  802b04:	5e                   	pop    %esi
  802b05:	5f                   	pop    %edi
  802b06:	5d                   	pop    %ebp
  802b07:	c3                   	ret    
  802b08:	3b 04 24             	cmp    (%esp),%eax
  802b0b:	72 06                	jb     802b13 <__umoddi3+0x113>
  802b0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b11:	77 0f                	ja     802b22 <__umoddi3+0x122>
  802b13:	89 f2                	mov    %esi,%edx
  802b15:	29 f9                	sub    %edi,%ecx
  802b17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b1b:	89 14 24             	mov    %edx,(%esp)
  802b1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b22:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b26:	8b 14 24             	mov    (%esp),%edx
  802b29:	83 c4 1c             	add    $0x1c,%esp
  802b2c:	5b                   	pop    %ebx
  802b2d:	5e                   	pop    %esi
  802b2e:	5f                   	pop    %edi
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    
  802b31:	8d 76 00             	lea    0x0(%esi),%esi
  802b34:	2b 04 24             	sub    (%esp),%eax
  802b37:	19 fa                	sbb    %edi,%edx
  802b39:	89 d1                	mov    %edx,%ecx
  802b3b:	89 c6                	mov    %eax,%esi
  802b3d:	e9 71 ff ff ff       	jmp    802ab3 <__umoddi3+0xb3>
  802b42:	66 90                	xchg   %ax,%ax
  802b44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b48:	72 ea                	jb     802b34 <__umoddi3+0x134>
  802b4a:	89 d9                	mov    %ebx,%ecx
  802b4c:	e9 62 ff ff ff       	jmp    802ab3 <__umoddi3+0xb3>
