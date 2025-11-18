
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 3b 02 00 00       	call   800271 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	// Testing scenario 3: using dynamic allocation and free. Kill itself!
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	char getksbrkCmd[100] = "__getKernelSBreak__";
  800044:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80004a:	bb bd 1f 80 00       	mov    $0x801fbd,%ebx
  80004f:	ba 05 00 00 00       	mov    $0x5,%edx
  800054:	89 c7                	mov    %eax,%edi
  800056:	89 de                	mov    %ebx,%esi
  800058:	89 d1                	mov    %edx,%ecx
  80005a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80005c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
  800062:	b9 14 00 00 00       	mov    $0x14,%ecx
  800067:	b8 00 00 00 00       	mov    $0x0,%eax
  80006c:	89 d7                	mov    %edx,%edi
  80006e:	f3 ab                	rep stos %eax,%es:(%edi)
	uint32 ksbrk_before ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_before);
  800070:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800076:	83 ec 08             	sub    $0x8,%esp
  800079:	50                   	push   %eax
  80007a:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800080:	50                   	push   %eax
  800081:	e8 81 1a 00 00       	call   801b07 <sys_utilities>
  800086:	83 c4 10             	add    $0x10,%esp

	int freeFrames_before = sys_calculate_free_frames() ;
  800089:	e8 7a 16 00 00       	call   801708 <sys_calculate_free_frames>
  80008e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800091:	e8 bd 16 00 00       	call   801753 <sys_pf_calculate_allocated_pages>
  800096:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800099:	83 ec 08             	sub    $0x8,%esp
  80009c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80009f:	68 00 1e 80 00       	push   $0x801e00
  8000a4:	e8 5b 06 00 00       	call   800704 <cprintf>
  8000a9:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcess = sys_create_env("tef3_slave", myEnv->page_WS_max_size,(myEnv->SecondListSize), 50);
  8000ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b1:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000b7:	89 c2                	mov    %eax,%edx
  8000b9:	a1 20 30 80 00       	mov    0x803020,%eax
  8000be:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000c4:	6a 32                	push   $0x32
  8000c6:	52                   	push   %edx
  8000c7:	50                   	push   %eax
  8000c8:	68 33 1e 80 00       	push   $0x801e33
  8000cd:	e8 91 17 00 00       	call   801863 <sys_create_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	sys_run_env(envIdProcess);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 dc             	pushl  -0x24(%ebp)
  8000de:	e8 9e 17 00 00       	call   801881 <sys_run_env>
  8000e3:	83 c4 10             	add    $0x10,%esp

	char getProcStateCmd[100] = "__getProcState@";
  8000e6:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  8000ec:	bb 21 20 80 00       	mov    $0x802021,%ebx
  8000f1:	ba 04 00 00 00       	mov    $0x4,%edx
  8000f6:	89 c7                	mov    %eax,%edi
  8000f8:	89 de                	mov    %ebx,%esi
  8000fa:	89 d1                	mov    %edx,%ecx
  8000fc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8000fe:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  800104:	b9 15 00 00 00       	mov    $0x15,%ecx
  800109:	b8 00 00 00 00       	mov    $0x0,%eax
  80010e:	89 d7                	mov    %edx,%edi
  800110:	f3 ab                	rep stos %eax,%es:(%edi)
	int procState = 0;
  800112:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800119:	00 00 00 
	do
	{
		char id[20] ;
		ltostr(envIdProcess, id);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800125:	50                   	push   %eax
  800126:	ff 75 dc             	pushl  -0x24(%ebp)
  800129:	e8 04 12 00 00       	call   801332 <ltostr>
  80012e:	83 c4 10             	add    $0x10,%esp
		char getProcStateWithIDCmd[100] ;
		strcconcat(getProcStateCmd, id, getProcStateWithIDCmd);
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800148:	50                   	push   %eax
  800149:	e8 bd 12 00 00       	call   80140b <strcconcat>
  80014e:	83 c4 10             	add    $0x10,%esp

		sys_utilities(getProcStateWithIDCmd, (uint32)&procState) ;
  800151:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800157:	83 ec 08             	sub    $0x8,%esp
  80015a:	50                   	push   %eax
  80015b:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  800161:	50                   	push   %eax
  800162:	e8 a0 19 00 00       	call   801b07 <sys_utilities>
  800167:	83 c4 10             	add    $0x10,%esp
		//cprintf("status of env %d = %d\n", envIdProcess, procState);
	}
	while (procState != E_BAD_ENV) ;
  80016a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800170:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800173:	75 a7                	jne    80011c <_main+0xe4>

	uint32 ksbrk_after ;
	sys_utilities(getksbrkCmd, (uint32)&ksbrk_after);
  800175:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	50                   	push   %eax
  80017f:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	e8 7c 19 00 00       	call   801b07 <sys_utilities>
  80018b:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80018e:	e8 75 15 00 00       	call   801708 <sys_calculate_free_frames>
  800193:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800196:	e8 b8 15 00 00       	call   801753 <sys_pf_calculate_allocated_pages>
  80019b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int expected = (ROUNDUP((uint32)ksbrk_after, PAGE_SIZE) - ROUNDUP((uint32)ksbrk_before, PAGE_SIZE)) / PAGE_SIZE;
  80019e:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8001a5:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  8001ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ae:	01 d0                	add    %edx,%eax
  8001b0:	48                   	dec    %eax
  8001b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bc:	f7 75 d0             	divl   -0x30(%ebp)
  8001bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001c2:	29 d0                	sub    %edx,%eax
  8001c4:	89 c1                	mov    %eax,%ecx
  8001c6:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8001cd:	8b 95 58 ff ff ff    	mov    -0xa8(%ebp),%edx
  8001d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	48                   	dec    %eax
  8001d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001df:	ba 00 00 00 00       	mov    $0x0,%edx
  8001e4:	f7 75 c8             	divl   -0x38(%ebp)
  8001e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001ea:	29 d0                	sub    %edx,%eax
  8001ec:	29 c1                	sub    %eax,%ecx
  8001ee:	89 c8                	mov    %ecx,%eax
  8001f0:	c1 e8 0c             	shr    $0xc,%eax
  8001f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	cprintf("expected = %d\n",expected);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	ff 75 c0             	pushl  -0x40(%ebp)
  8001fc:	68 3e 1e 80 00       	push   $0x801e3e
  800201:	e8 fe 04 00 00       	call   800704 <cprintf>
  800206:	83 c4 10             	add    $0x10,%esp
	if ((freeFrames_before - freeFrames_after) != expected) {
  800209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80020f:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  800212:	74 2e                	je     800242 <_main+0x20a>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\ndifference = %d, expected = %d\n",
  800214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80021a:	ff 75 c0             	pushl  -0x40(%ebp)
  80021d:	50                   	push   %eax
  80021e:	ff 75 d8             	pushl  -0x28(%ebp)
  800221:	68 50 1e 80 00       	push   $0x801e50
  800226:	e8 d9 04 00 00       	call   800704 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
				freeFrames_after, freeFrames_after - freeFrames_before, expected);
		panic("env_free() does not work correctly... check it again.");
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 c0 1e 80 00       	push   $0x801ec0
  800236:	6a 2f                	push   $0x2f
  800238:	68 f6 1e 80 00       	push   $0x801ef6
  80023d:	e8 f4 01 00 00       	call   800436 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back as expected = %d + kbreak pages (%d)\n", freeFrames_after, expected);
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	ff 75 c0             	pushl  -0x40(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	68 0c 1f 80 00       	push   $0x801f0c
  800250:	e8 af 04 00 00       	call   800704 <cprintf>
  800255:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	68 74 1f 80 00       	push   $0x801f74
  800260:	e8 9f 04 00 00       	call   800704 <cprintf>
  800265:	83 c4 10             	add    $0x10,%esp
	return;
  800268:	90                   	nop
}
  800269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5f                   	pop    %edi
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    

00800271 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	57                   	push   %edi
  800275:	56                   	push   %esi
  800276:	53                   	push   %ebx
  800277:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80027a:	e8 52 16 00 00       	call   8018d1 <sys_getenvindex>
  80027f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800285:	89 d0                	mov    %edx,%eax
  800287:	c1 e0 06             	shl    $0x6,%eax
  80028a:	29 d0                	sub    %edx,%eax
  80028c:	c1 e0 02             	shl    $0x2,%eax
  80028f:	01 d0                	add    %edx,%eax
  800291:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800298:	01 c8                	add    %ecx,%eax
  80029a:	c1 e0 03             	shl    $0x3,%eax
  80029d:	01 d0                	add    %edx,%eax
  80029f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a6:	29 c2                	sub    %eax,%edx
  8002a8:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8002b7:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c1:	8a 40 20             	mov    0x20(%eax),%al
  8002c4:	84 c0                	test   %al,%al
  8002c6:	74 0d                	je     8002d5 <libmain+0x64>
		binaryname = myEnv->prog_name;
  8002c8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002cd:	83 c0 20             	add    $0x20,%eax
  8002d0:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002d9:	7e 0a                	jle    8002e5 <libmain+0x74>
		binaryname = argv[0];
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	ff 75 0c             	pushl  0xc(%ebp)
  8002eb:	ff 75 08             	pushl  0x8(%ebp)
  8002ee:	e8 45 fd ff ff       	call   800038 <_main>
  8002f3:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002f6:	a1 00 30 80 00       	mov    0x803000,%eax
  8002fb:	85 c0                	test   %eax,%eax
  8002fd:	0f 84 01 01 00 00    	je     800404 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800303:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800309:	bb 80 21 80 00       	mov    $0x802180,%ebx
  80030e:	ba 0e 00 00 00       	mov    $0xe,%edx
  800313:	89 c7                	mov    %eax,%edi
  800315:	89 de                	mov    %ebx,%esi
  800317:	89 d1                	mov    %edx,%ecx
  800319:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80031b:	8d 55 8a             	lea    -0x76(%ebp),%edx
  80031e:	b9 56 00 00 00       	mov    $0x56,%ecx
  800323:	b0 00                	mov    $0x0,%al
  800325:	89 d7                	mov    %edx,%edi
  800327:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800330:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	50                   	push   %eax
  800337:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80033d:	50                   	push   %eax
  80033e:	e8 c4 17 00 00       	call   801b07 <sys_utilities>
  800343:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800346:	e8 0d 13 00 00       	call   801658 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 a0 20 80 00       	push   $0x8020a0
  800353:	e8 ac 03 00 00       	call   800704 <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80035b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035e:	85 c0                	test   %eax,%eax
  800360:	74 18                	je     80037a <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800362:	e8 be 17 00 00       	call   801b25 <sys_get_optimal_num_faults>
  800367:	83 ec 08             	sub    $0x8,%esp
  80036a:	50                   	push   %eax
  80036b:	68 c8 20 80 00       	push   $0x8020c8
  800370:	e8 8f 03 00 00       	call   800704 <cprintf>
  800375:	83 c4 10             	add    $0x10,%esp
  800378:	eb 59                	jmp    8003d3 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80037a:	a1 20 30 80 00       	mov    0x803020,%eax
  80037f:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800385:	a1 20 30 80 00       	mov    0x803020,%eax
  80038a:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	52                   	push   %edx
  800394:	50                   	push   %eax
  800395:	68 ec 20 80 00       	push   $0x8020ec
  80039a:	e8 65 03 00 00       	call   800704 <cprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003a2:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a7:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8003ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b2:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8003b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bd:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8003c3:	51                   	push   %ecx
  8003c4:	52                   	push   %edx
  8003c5:	50                   	push   %eax
  8003c6:	68 14 21 80 00       	push   $0x802114
  8003cb:	e8 34 03 00 00       	call   800704 <cprintf>
  8003d0:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d8:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	50                   	push   %eax
  8003e2:	68 6c 21 80 00       	push   $0x80216c
  8003e7:	e8 18 03 00 00       	call   800704 <cprintf>
  8003ec:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	68 a0 20 80 00       	push   $0x8020a0
  8003f7:	e8 08 03 00 00       	call   800704 <cprintf>
  8003fc:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003ff:	e8 6e 12 00 00       	call   801672 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800404:	e8 1f 00 00 00       	call   800428 <exit>
}
  800409:	90                   	nop
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	6a 00                	push   $0x0
  80041d:	e8 7b 14 00 00       	call   80189d <sys_destroy_env>
  800422:	83 c4 10             	add    $0x10,%esp
}
  800425:	90                   	nop
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <exit>:

void
exit(void)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80042e:	e8 d0 14 00 00       	call   801903 <sys_exit_env>
}
  800433:	90                   	nop
  800434:	c9                   	leave  
  800435:	c3                   	ret    

00800436 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80043c:	8d 45 10             	lea    0x10(%ebp),%eax
  80043f:	83 c0 04             	add    $0x4,%eax
  800442:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800445:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80044a:	85 c0                	test   %eax,%eax
  80044c:	74 16                	je     800464 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80044e:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800453:	83 ec 08             	sub    $0x8,%esp
  800456:	50                   	push   %eax
  800457:	68 e4 21 80 00       	push   $0x8021e4
  80045c:	e8 a3 02 00 00       	call   800704 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800464:	a1 04 30 80 00       	mov    0x803004,%eax
  800469:	83 ec 0c             	sub    $0xc,%esp
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	ff 75 08             	pushl  0x8(%ebp)
  800472:	50                   	push   %eax
  800473:	68 ec 21 80 00       	push   $0x8021ec
  800478:	6a 74                	push   $0x74
  80047a:	e8 b2 02 00 00       	call   800731 <cprintf_colored>
  80047f:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800482:	8b 45 10             	mov    0x10(%ebp),%eax
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	ff 75 f4             	pushl  -0xc(%ebp)
  80048b:	50                   	push   %eax
  80048c:	e8 04 02 00 00       	call   800695 <vcprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	6a 00                	push   $0x0
  800499:	68 14 22 80 00       	push   $0x802214
  80049e:	e8 f2 01 00 00       	call   800695 <vcprintf>
  8004a3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004a6:	e8 7d ff ff ff       	call   800428 <exit>

	// should not return here
	while (1) ;
  8004ab:	eb fe                	jmp    8004ab <_panic+0x75>

008004ad <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	39 c2                	cmp    %eax,%edx
  8004c3:	74 14                	je     8004d9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004c5:	83 ec 04             	sub    $0x4,%esp
  8004c8:	68 18 22 80 00       	push   $0x802218
  8004cd:	6a 26                	push   $0x26
  8004cf:	68 64 22 80 00       	push   $0x802264
  8004d4:	e8 5d ff ff ff       	call   800436 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004e7:	e9 c5 00 00 00       	jmp    8005b1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	01 d0                	add    %edx,%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	85 c0                	test   %eax,%eax
  8004ff:	75 08                	jne    800509 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800501:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800504:	e9 a5 00 00 00       	jmp    8005ae <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800510:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800517:	eb 69                	jmp    800582 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800519:	a1 20 30 80 00       	mov    0x803020,%eax
  80051e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800524:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8a 40 04             	mov    0x4(%eax),%al
  800535:	84 c0                	test   %al,%al
  800537:	75 46                	jne    80057f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800539:	a1 20 30 80 00       	mov    0x803020,%eax
  80053e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800544:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800547:	89 d0                	mov    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	01 d0                	add    %edx,%eax
  80054d:	c1 e0 03             	shl    $0x3,%eax
  800550:	01 c8                	add    %ecx,%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800557:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80055f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800564:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	01 c8                	add    %ecx,%eax
  800570:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800572:	39 c2                	cmp    %eax,%edx
  800574:	75 09                	jne    80057f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800576:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80057d:	eb 15                	jmp    800594 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	ff 45 e8             	incl   -0x18(%ebp)
  800582:	a1 20 30 80 00       	mov    0x803020,%eax
  800587:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80058d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800590:	39 c2                	cmp    %eax,%edx
  800592:	77 85                	ja     800519 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800594:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800598:	75 14                	jne    8005ae <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 70 22 80 00       	push   $0x802270
  8005a2:	6a 3a                	push   $0x3a
  8005a4:	68 64 22 80 00       	push   $0x802264
  8005a9:	e8 88 fe ff ff       	call   800436 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005ae:	ff 45 f0             	incl   -0x10(%ebp)
  8005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005b7:	0f 8c 2f ff ff ff    	jl     8004ec <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005cb:	eb 26                	jmp    8005f3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005cd:	a1 20 30 80 00       	mov    0x803020,%eax
  8005d2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	3c 01                	cmp    $0x1,%al
  8005eb:	75 03                	jne    8005f0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	ff 45 e0             	incl   -0x20(%ebp)
  8005f3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800601:	39 c2                	cmp    %eax,%edx
  800603:	77 c8                	ja     8005cd <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800608:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80060b:	74 14                	je     800621 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80060d:	83 ec 04             	sub    $0x4,%esp
  800610:	68 c4 22 80 00       	push   $0x8022c4
  800615:	6a 44                	push   $0x44
  800617:	68 64 22 80 00       	push   $0x802264
  80061c:	e8 15 fe ff ff       	call   800436 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800621:	90                   	nop
  800622:	c9                   	leave  
  800623:	c3                   	ret    

00800624 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800624:	55                   	push   %ebp
  800625:	89 e5                	mov    %esp,%ebp
  800627:	53                   	push   %ebx
  800628:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 00                	mov    (%eax),%eax
  800630:	8d 48 01             	lea    0x1(%eax),%ecx
  800633:	8b 55 0c             	mov    0xc(%ebp),%edx
  800636:	89 0a                	mov    %ecx,(%edx)
  800638:	8b 55 08             	mov    0x8(%ebp),%edx
  80063b:	88 d1                	mov    %dl,%cl
  80063d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800640:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	8b 00                	mov    (%eax),%eax
  800649:	3d ff 00 00 00       	cmp    $0xff,%eax
  80064e:	75 30                	jne    800680 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800650:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800656:	a0 44 30 80 00       	mov    0x803044,%al
  80065b:	0f b6 c0             	movzbl %al,%eax
  80065e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800661:	8b 09                	mov    (%ecx),%ecx
  800663:	89 cb                	mov    %ecx,%ebx
  800665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800668:	83 c1 08             	add    $0x8,%ecx
  80066b:	52                   	push   %edx
  80066c:	50                   	push   %eax
  80066d:	53                   	push   %ebx
  80066e:	51                   	push   %ecx
  80066f:	e8 a0 0f 00 00       	call   801614 <sys_cputs>
  800674:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800680:	8b 45 0c             	mov    0xc(%ebp),%eax
  800683:	8b 40 04             	mov    0x4(%eax),%eax
  800686:	8d 50 01             	lea    0x1(%eax),%edx
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80068f:	90                   	nop
  800690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800693:	c9                   	leave  
  800694:	c3                   	ret    

00800695 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
  800698:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80069e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006a5:	00 00 00 
	b.cnt = 0;
  8006a8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006af:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	ff 75 08             	pushl  0x8(%ebp)
  8006b8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006be:	50                   	push   %eax
  8006bf:	68 24 06 80 00       	push   $0x800624
  8006c4:	e8 5a 02 00 00       	call   800923 <vprintfmt>
  8006c9:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006cc:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8006d2:	a0 44 30 80 00       	mov    0x803044,%al
  8006d7:	0f b6 c0             	movzbl %al,%eax
  8006da:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006e0:	52                   	push   %edx
  8006e1:	50                   	push   %eax
  8006e2:	51                   	push   %ecx
  8006e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e9:	83 c0 08             	add    $0x8,%eax
  8006ec:	50                   	push   %eax
  8006ed:	e8 22 0f 00 00       	call   801614 <sys_cputs>
  8006f2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006f5:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006fc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80070a:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  800711:	8d 45 0c             	lea    0xc(%ebp),%eax
  800714:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 f4             	pushl  -0xc(%ebp)
  800720:	50                   	push   %eax
  800721:	e8 6f ff ff ff       	call   800695 <vcprintf>
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80072c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80072f:	c9                   	leave  
  800730:	c3                   	ret    

00800731 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800737:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	c1 e0 08             	shl    $0x8,%eax
  800744:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800749:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074c:	83 c0 04             	add    $0x4,%eax
  80074f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800752:	8b 45 0c             	mov    0xc(%ebp),%eax
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 f4             	pushl  -0xc(%ebp)
  80075b:	50                   	push   %eax
  80075c:	e8 34 ff ff ff       	call   800695 <vcprintf>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800767:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80076e:	07 00 00 

	return cnt;
  800771:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800774:	c9                   	leave  
  800775:	c3                   	ret    

00800776 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80077c:	e8 d7 0e 00 00       	call   801658 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800781:	8d 45 0c             	lea    0xc(%ebp),%eax
  800784:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	ff 75 f4             	pushl  -0xc(%ebp)
  800790:	50                   	push   %eax
  800791:	e8 ff fe ff ff       	call   800695 <vcprintf>
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80079c:	e8 d1 0e 00 00       	call   801672 <sys_unlock_cons>
	return cnt;
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	53                   	push   %ebx
  8007aa:	83 ec 14             	sub    $0x14,%esp
  8007ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8007bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c4:	77 55                	ja     80081b <printnum+0x75>
  8007c6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c9:	72 05                	jb     8007d0 <printnum+0x2a>
  8007cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ce:	77 4b                	ja     80081b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	52                   	push   %edx
  8007df:	50                   	push   %eax
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007e6:	e8 a9 13 00 00       	call   801b94 <__udivdi3>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	83 ec 04             	sub    $0x4,%esp
  8007f1:	ff 75 20             	pushl  0x20(%ebp)
  8007f4:	53                   	push   %ebx
  8007f5:	ff 75 18             	pushl  0x18(%ebp)
  8007f8:	52                   	push   %edx
  8007f9:	50                   	push   %eax
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	ff 75 08             	pushl  0x8(%ebp)
  800800:	e8 a1 ff ff ff       	call   8007a6 <printnum>
  800805:	83 c4 20             	add    $0x20,%esp
  800808:	eb 1a                	jmp    800824 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	ff 75 20             	pushl  0x20(%ebp)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	ff d0                	call   *%eax
  800818:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081b:	ff 4d 1c             	decl   0x1c(%ebp)
  80081e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800822:	7f e6                	jg     80080a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800824:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800827:	bb 00 00 00 00       	mov    $0x0,%ebx
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800832:	53                   	push   %ebx
  800833:	51                   	push   %ecx
  800834:	52                   	push   %edx
  800835:	50                   	push   %eax
  800836:	e8 69 14 00 00       	call   801ca4 <__umoddi3>
  80083b:	83 c4 10             	add    $0x10,%esp
  80083e:	05 34 25 80 00       	add    $0x802534,%eax
  800843:	8a 00                	mov    (%eax),%al
  800845:	0f be c0             	movsbl %al,%eax
  800848:	83 ec 08             	sub    $0x8,%esp
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	50                   	push   %eax
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
  800854:	83 c4 10             	add    $0x10,%esp
}
  800857:	90                   	nop
  800858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085b:	c9                   	leave  
  80085c:	c3                   	ret    

0080085d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800860:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800864:	7e 1c                	jle    800882 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 00                	mov    (%eax),%eax
  80086b:	8d 50 08             	lea    0x8(%eax),%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	89 10                	mov    %edx,(%eax)
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	83 e8 08             	sub    $0x8,%eax
  80087b:	8b 50 04             	mov    0x4(%eax),%edx
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	eb 40                	jmp    8008c2 <getuint+0x65>
	else if (lflag)
  800882:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800886:	74 1e                	je     8008a6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 00                	mov    (%eax),%eax
  80088d:	8d 50 04             	lea    0x4(%eax),%edx
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 10                	mov    %edx,(%eax)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 00                	mov    (%eax),%eax
  80089a:	83 e8 04             	sub    $0x4,%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a4:	eb 1c                	jmp    8008c2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 50 04             	lea    0x4(%eax),%edx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 10                	mov    %edx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	83 e8 04             	sub    $0x4,%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cb:	7e 1c                	jle    8008e9 <getint+0x25>
		return va_arg(*ap, long long);
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	8d 50 08             	lea    0x8(%eax),%edx
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 10                	mov    %edx,(%eax)
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	83 e8 08             	sub    $0x8,%eax
  8008e2:	8b 50 04             	mov    0x4(%eax),%edx
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	eb 38                	jmp    800921 <getint+0x5d>
	else if (lflag)
  8008e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ed:	74 1a                	je     800909 <getint+0x45>
		return va_arg(*ap, long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 04             	lea    0x4(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	99                   	cltd   
  800907:	eb 18                	jmp    800921 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	8b 00                	mov    (%eax),%eax
  80090e:	8d 50 04             	lea    0x4(%eax),%edx
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	89 10                	mov    %edx,(%eax)
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 e8 04             	sub    $0x4,%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	99                   	cltd   
}
  800921:	5d                   	pop    %ebp
  800922:	c3                   	ret    

00800923 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800923:	55                   	push   %ebp
  800924:	89 e5                	mov    %esp,%ebp
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092b:	eb 17                	jmp    800944 <vprintfmt+0x21>
			if (ch == '\0')
  80092d:	85 db                	test   %ebx,%ebx
  80092f:	0f 84 c1 03 00 00    	je     800cf6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800944:	8b 45 10             	mov    0x10(%ebp),%eax
  800947:	8d 50 01             	lea    0x1(%eax),%edx
  80094a:	89 55 10             	mov    %edx,0x10(%ebp)
  80094d:	8a 00                	mov    (%eax),%al
  80094f:	0f b6 d8             	movzbl %al,%ebx
  800952:	83 fb 25             	cmp    $0x25,%ebx
  800955:	75 d6                	jne    80092d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800957:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800962:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800969:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800970:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800977:	8b 45 10             	mov    0x10(%ebp),%eax
  80097a:	8d 50 01             	lea    0x1(%eax),%edx
  80097d:	89 55 10             	mov    %edx,0x10(%ebp)
  800980:	8a 00                	mov    (%eax),%al
  800982:	0f b6 d8             	movzbl %al,%ebx
  800985:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800988:	83 f8 5b             	cmp    $0x5b,%eax
  80098b:	0f 87 3d 03 00 00    	ja     800cce <vprintfmt+0x3ab>
  800991:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  800998:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80099e:	eb d7                	jmp    800977 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a4:	eb d1                	jmp    800977 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b0:	89 d0                	mov    %edx,%eax
  8009b2:	c1 e0 02             	shl    $0x2,%eax
  8009b5:	01 d0                	add    %edx,%eax
  8009b7:	01 c0                	add    %eax,%eax
  8009b9:	01 d8                	add    %ebx,%eax
  8009bb:	83 e8 30             	sub    $0x30,%eax
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c4:	8a 00                	mov    (%eax),%al
  8009c6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009c9:	83 fb 2f             	cmp    $0x2f,%ebx
  8009cc:	7e 3e                	jle    800a0c <vprintfmt+0xe9>
  8009ce:	83 fb 39             	cmp    $0x39,%ebx
  8009d1:	7f 39                	jg     800a0c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009d6:	eb d5                	jmp    8009ad <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e4:	83 e8 04             	sub    $0x4,%eax
  8009e7:	8b 00                	mov    (%eax),%eax
  8009e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009ec:	eb 1f                	jmp    800a0d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	79 83                	jns    800977 <vprintfmt+0x54>
				width = 0;
  8009f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009fb:	e9 77 ff ff ff       	jmp    800977 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a00:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a07:	e9 6b ff ff ff       	jmp    800977 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a0c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a11:	0f 89 60 ff ff ff    	jns    800977 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a1d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a24:	e9 4e ff ff ff       	jmp    800977 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a29:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a2c:	e9 46 ff ff ff       	jmp    800977 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a31:	8b 45 14             	mov    0x14(%ebp),%eax
  800a34:	83 c0 04             	add    $0x4,%eax
  800a37:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3d:	83 e8 04             	sub    $0x4,%eax
  800a40:	8b 00                	mov    (%eax),%eax
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	50                   	push   %eax
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
			break;
  800a51:	e9 9b 02 00 00       	jmp    800cf1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a56:	8b 45 14             	mov    0x14(%ebp),%eax
  800a59:	83 c0 04             	add    $0x4,%eax
  800a5c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a62:	83 e8 04             	sub    $0x4,%eax
  800a65:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a67:	85 db                	test   %ebx,%ebx
  800a69:	79 02                	jns    800a6d <vprintfmt+0x14a>
				err = -err;
  800a6b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a6d:	83 fb 64             	cmp    $0x64,%ebx
  800a70:	7f 0b                	jg     800a7d <vprintfmt+0x15a>
  800a72:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800a79:	85 f6                	test   %esi,%esi
  800a7b:	75 19                	jne    800a96 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a7d:	53                   	push   %ebx
  800a7e:	68 45 25 80 00       	push   $0x802545
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 70 02 00 00       	call   800cfe <printfmt>
  800a8e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a91:	e9 5b 02 00 00       	jmp    800cf1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a96:	56                   	push   %esi
  800a97:	68 4e 25 80 00       	push   $0x80254e
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	ff 75 08             	pushl  0x8(%ebp)
  800aa2:	e8 57 02 00 00       	call   800cfe <printfmt>
  800aa7:	83 c4 10             	add    $0x10,%esp
			break;
  800aaa:	e9 42 02 00 00       	jmp    800cf1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	83 c0 04             	add    $0x4,%eax
  800ab5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  800abb:	83 e8 04             	sub    $0x4,%eax
  800abe:	8b 30                	mov    (%eax),%esi
  800ac0:	85 f6                	test   %esi,%esi
  800ac2:	75 05                	jne    800ac9 <vprintfmt+0x1a6>
				p = "(null)";
  800ac4:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800ac9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acd:	7e 6d                	jle    800b3c <vprintfmt+0x219>
  800acf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad3:	74 67                	je     800b3c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	50                   	push   %eax
  800adc:	56                   	push   %esi
  800add:	e8 1e 03 00 00       	call   800e00 <strnlen>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ae8:	eb 16                	jmp    800b00 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aea:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	ff 75 0c             	pushl  0xc(%ebp)
  800af4:	50                   	push   %eax
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	ff d0                	call   *%eax
  800afa:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800afd:	ff 4d e4             	decl   -0x1c(%ebp)
  800b00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b04:	7f e4                	jg     800aea <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b06:	eb 34                	jmp    800b3c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b0c:	74 1c                	je     800b2a <vprintfmt+0x207>
  800b0e:	83 fb 1f             	cmp    $0x1f,%ebx
  800b11:	7e 05                	jle    800b18 <vprintfmt+0x1f5>
  800b13:	83 fb 7e             	cmp    $0x7e,%ebx
  800b16:	7e 12                	jle    800b2a <vprintfmt+0x207>
					putch('?', putdat);
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	6a 3f                	push   $0x3f
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
  800b28:	eb 0f                	jmp    800b39 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	53                   	push   %ebx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	ff d0                	call   *%eax
  800b36:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b39:	ff 4d e4             	decl   -0x1c(%ebp)
  800b3c:	89 f0                	mov    %esi,%eax
  800b3e:	8d 70 01             	lea    0x1(%eax),%esi
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	0f be d8             	movsbl %al,%ebx
  800b46:	85 db                	test   %ebx,%ebx
  800b48:	74 24                	je     800b6e <vprintfmt+0x24b>
  800b4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4e:	78 b8                	js     800b08 <vprintfmt+0x1e5>
  800b50:	ff 4d e0             	decl   -0x20(%ebp)
  800b53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b57:	79 af                	jns    800b08 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b59:	eb 13                	jmp    800b6e <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	6a 20                	push   $0x20
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b72:	7f e7                	jg     800b5b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b74:	e9 78 01 00 00       	jmp    800cf1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b82:	50                   	push   %eax
  800b83:	e8 3c fd ff ff       	call   8008c4 <getint>
  800b88:	83 c4 10             	add    $0x10,%esp
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b97:	85 d2                	test   %edx,%edx
  800b99:	79 23                	jns    800bbe <vprintfmt+0x29b>
				putch('-', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	6a 2d                	push   $0x2d
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	ff d0                	call   *%eax
  800ba8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb1:	f7 d8                	neg    %eax
  800bb3:	83 d2 00             	adc    $0x0,%edx
  800bb6:	f7 da                	neg    %edx
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bbe:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc5:	e9 bc 00 00 00       	jmp    800c86 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bca:	83 ec 08             	sub    $0x8,%esp
  800bcd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd3:	50                   	push   %eax
  800bd4:	e8 84 fc ff ff       	call   80085d <getuint>
  800bd9:	83 c4 10             	add    $0x10,%esp
  800bdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be9:	e9 98 00 00 00       	jmp    800c86 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 58                	push   $0x58
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bfe:	83 ec 08             	sub    $0x8,%esp
  800c01:	ff 75 0c             	pushl  0xc(%ebp)
  800c04:	6a 58                	push   $0x58
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	ff d0                	call   *%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c0e:	83 ec 08             	sub    $0x8,%esp
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	6a 58                	push   $0x58
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	ff d0                	call   *%eax
  800c1b:	83 c4 10             	add    $0x10,%esp
			break;
  800c1e:	e9 ce 00 00 00       	jmp    800cf1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 30                	push   $0x30
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c33:	83 ec 08             	sub    $0x8,%esp
  800c36:	ff 75 0c             	pushl  0xc(%ebp)
  800c39:	6a 78                	push   $0x78
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	ff d0                	call   *%eax
  800c40:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c43:	8b 45 14             	mov    0x14(%ebp),%eax
  800c46:	83 c0 04             	add    $0x4,%eax
  800c49:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4f:	83 e8 04             	sub    $0x4,%eax
  800c52:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c5e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c65:	eb 1f                	jmp    800c86 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c67:	83 ec 08             	sub    $0x8,%esp
  800c6a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c6d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c70:	50                   	push   %eax
  800c71:	e8 e7 fb ff ff       	call   80085d <getuint>
  800c76:	83 c4 10             	add    $0x10,%esp
  800c79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c86:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8d:	83 ec 04             	sub    $0x4,%esp
  800c90:	52                   	push   %edx
  800c91:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c94:	50                   	push   %eax
  800c95:	ff 75 f4             	pushl  -0xc(%ebp)
  800c98:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9b:	ff 75 0c             	pushl  0xc(%ebp)
  800c9e:	ff 75 08             	pushl  0x8(%ebp)
  800ca1:	e8 00 fb ff ff       	call   8007a6 <printnum>
  800ca6:	83 c4 20             	add    $0x20,%esp
			break;
  800ca9:	eb 46                	jmp    800cf1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cab:	83 ec 08             	sub    $0x8,%esp
  800cae:	ff 75 0c             	pushl  0xc(%ebp)
  800cb1:	53                   	push   %ebx
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	ff d0                	call   *%eax
  800cb7:	83 c4 10             	add    $0x10,%esp
			break;
  800cba:	eb 35                	jmp    800cf1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800cbc:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800cc3:	eb 2c                	jmp    800cf1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800cc5:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3c3>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 35 fc ff ff       	jmp    80092b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 04 fc ff ff       	call   800923 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 80 fb ff ff       	call   800923 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fd7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fdb:	76 63                	jbe    801040 <memset+0x75>
		uint64 data_block = c;
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	99                   	cltd   
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe4:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fed:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800ff1:	c1 e0 08             	shl    $0x8,%eax
  800ff4:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801000:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801004:	c1 e0 10             	shl    $0x10,%eax
  801007:	09 45 f0             	or     %eax,-0x10(%ebp)
  80100a:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  80100d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801013:	89 c2                	mov    %eax,%edx
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
  80101a:	09 45 f0             	or     %eax,-0x10(%ebp)
  80101d:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801020:	eb 18                	jmp    80103a <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801022:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801025:	8d 41 08             	lea    0x8(%ecx),%eax
  801028:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80102b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801031:	89 01                	mov    %eax,(%ecx)
  801033:	89 51 04             	mov    %edx,0x4(%ecx)
  801036:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80103a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80103e:	77 e2                	ja     801022 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801040:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801044:	74 23                	je     801069 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801046:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801049:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 0e                	jmp    80105c <memset+0x91>
			*p8++ = (uint8)c;
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801051:	8d 50 01             	lea    0x1(%eax),%edx
  801054:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801057:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105a:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801062:	89 55 10             	mov    %edx,0x10(%ebp)
  801065:	85 c0                	test   %eax,%eax
  801067:	75 e5                	jne    80104e <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801080:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801084:	76 24                	jbe    8010aa <memcpy+0x3c>
		while(n >= 8){
  801086:	eb 1c                	jmp    8010a4 <memcpy+0x36>
			*d64 = *s64;
  801088:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108b:	8b 50 04             	mov    0x4(%eax),%edx
  80108e:	8b 00                	mov    (%eax),%eax
  801090:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801093:	89 01                	mov    %eax,(%ecx)
  801095:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801098:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  80109c:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8010a0:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8010a4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010a8:	77 de                	ja     801088 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8010aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ae:	74 31                	je     8010e1 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8010b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8010b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8010bc:	eb 16                	jmp    8010d4 <memcpy+0x66>
			*d8++ = *s8++;
  8010be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c1:	8d 50 01             	lea    0x1(%eax),%edx
  8010c4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8010c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010cd:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010d0:	8a 12                	mov    (%edx),%dl
  8010d2:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010da:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	75 dd                	jne    8010be <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010fe:	73 50                	jae    801150 <memmove+0x6a>
  801100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80110b:	76 43                	jbe    801150 <memmove+0x6a>
		s += n;
  80110d:	8b 45 10             	mov    0x10(%ebp),%eax
  801110:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801113:	8b 45 10             	mov    0x10(%ebp),%eax
  801116:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801119:	eb 10                	jmp    80112b <memmove+0x45>
			*--d = *--s;
  80111b:	ff 4d f8             	decl   -0x8(%ebp)
  80111e:	ff 4d fc             	decl   -0x4(%ebp)
  801121:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801124:	8a 10                	mov    (%eax),%dl
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80112b:	8b 45 10             	mov    0x10(%ebp),%eax
  80112e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801131:	89 55 10             	mov    %edx,0x10(%ebp)
  801134:	85 c0                	test   %eax,%eax
  801136:	75 e3                	jne    80111b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801138:	eb 23                	jmp    80115d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	8d 50 01             	lea    0x1(%eax),%edx
  801140:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801143:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801146:	8d 4a 01             	lea    0x1(%edx),%ecx
  801149:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80114c:	8a 12                	mov    (%edx),%dl
  80114e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	8d 50 ff             	lea    -0x1(%eax),%edx
  801156:	89 55 10             	mov    %edx,0x10(%ebp)
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 dd                	jne    80113a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801174:	eb 2a                	jmp    8011a0 <memcmp+0x3e>
		if (*s1 != *s2)
  801176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801179:	8a 10                	mov    (%eax),%dl
  80117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117e:	8a 00                	mov    (%eax),%al
  801180:	38 c2                	cmp    %al,%dl
  801182:	74 16                	je     80119a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801184:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	0f b6 d0             	movzbl %al,%edx
  80118c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118f:	8a 00                	mov    (%eax),%al
  801191:	0f b6 c0             	movzbl %al,%eax
  801194:	29 c2                	sub    %eax,%edx
  801196:	89 d0                	mov    %edx,%eax
  801198:	eb 18                	jmp    8011b2 <memcmp+0x50>
		s1++, s2++;
  80119a:	ff 45 fc             	incl   -0x4(%ebp)
  80119d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	75 c9                	jne    801176 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 d0                	add    %edx,%eax
  8011c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011c5:	eb 15                	jmp    8011dc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	0f b6 d0             	movzbl %al,%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	0f b6 c0             	movzbl %al,%eax
  8011d5:	39 c2                	cmp    %eax,%edx
  8011d7:	74 0d                	je     8011e6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011d9:	ff 45 08             	incl   0x8(%ebp)
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011e2:	72 e3                	jb     8011c7 <memfind+0x13>
  8011e4:	eb 01                	jmp    8011e7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011e6:	90                   	nop
	return (void *) s;
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011f9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801200:	eb 03                	jmp    801205 <strtol+0x19>
		s++;
  801202:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	8a 00                	mov    (%eax),%al
  80120a:	3c 20                	cmp    $0x20,%al
  80120c:	74 f4                	je     801202 <strtol+0x16>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 09                	cmp    $0x9,%al
  801215:	74 eb                	je     801202 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	3c 2b                	cmp    $0x2b,%al
  80121e:	75 05                	jne    801225 <strtol+0x39>
		s++;
  801220:	ff 45 08             	incl   0x8(%ebp)
  801223:	eb 13                	jmp    801238 <strtol+0x4c>
	else if (*s == '-')
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 2d                	cmp    $0x2d,%al
  80122c:	75 0a                	jne    801238 <strtol+0x4c>
		s++, neg = 1;
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123c:	74 06                	je     801244 <strtol+0x58>
  80123e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801242:	75 20                	jne    801264 <strtol+0x78>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 30                	cmp    $0x30,%al
  80124b:	75 17                	jne    801264 <strtol+0x78>
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	40                   	inc    %eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 78                	cmp    $0x78,%al
  801255:	75 0d                	jne    801264 <strtol+0x78>
		s += 2, base = 16;
  801257:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80125b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801262:	eb 28                	jmp    80128c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801264:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801268:	75 15                	jne    80127f <strtol+0x93>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	3c 30                	cmp    $0x30,%al
  801271:	75 0c                	jne    80127f <strtol+0x93>
		s++, base = 8;
  801273:	ff 45 08             	incl   0x8(%ebp)
  801276:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80127d:	eb 0d                	jmp    80128c <strtol+0xa0>
	else if (base == 0)
  80127f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801283:	75 07                	jne    80128c <strtol+0xa0>
		base = 10;
  801285:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	3c 2f                	cmp    $0x2f,%al
  801293:	7e 19                	jle    8012ae <strtol+0xc2>
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	3c 39                	cmp    $0x39,%al
  80129c:	7f 10                	jg     8012ae <strtol+0xc2>
			dig = *s - '0';
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	0f be c0             	movsbl %al,%eax
  8012a6:	83 e8 30             	sub    $0x30,%eax
  8012a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ac:	eb 42                	jmp    8012f0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	3c 60                	cmp    $0x60,%al
  8012b5:	7e 19                	jle    8012d0 <strtol+0xe4>
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8a 00                	mov    (%eax),%al
  8012bc:	3c 7a                	cmp    $0x7a,%al
  8012be:	7f 10                	jg     8012d0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	8a 00                	mov    (%eax),%al
  8012c5:	0f be c0             	movsbl %al,%eax
  8012c8:	83 e8 57             	sub    $0x57,%eax
  8012cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012ce:	eb 20                	jmp    8012f0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	3c 40                	cmp    $0x40,%al
  8012d7:	7e 39                	jle    801312 <strtol+0x126>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	3c 5a                	cmp    $0x5a,%al
  8012e0:	7f 30                	jg     801312 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	0f be c0             	movsbl %al,%eax
  8012ea:	83 e8 37             	sub    $0x37,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f6:	7d 19                	jge    801311 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012f8:	ff 45 08             	incl   0x8(%ebp)
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012fe:	0f af 45 10          	imul   0x10(%ebp),%eax
  801302:	89 c2                	mov    %eax,%edx
  801304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80130c:	e9 7b ff ff ff       	jmp    80128c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801311:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801312:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801316:	74 08                	je     801320 <strtol+0x134>
		*endptr = (char *) s;
  801318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801320:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801324:	74 07                	je     80132d <strtol+0x141>
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	f7 d8                	neg    %eax
  80132b:	eb 03                	jmp    801330 <strtol+0x144>
  80132d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <ltostr>:

void
ltostr(long value, char *str)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801338:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80133f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801346:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80134a:	79 13                	jns    80135f <ltostr+0x2d>
	{
		neg = 1;
  80134c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801359:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80135c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801367:	99                   	cltd   
  801368:	f7 f9                	idiv   %ecx
  80136a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80136d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801370:	8d 50 01             	lea    0x1(%eax),%edx
  801373:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801376:	89 c2                	mov    %eax,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801380:	83 c2 30             	add    $0x30,%edx
  801383:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801388:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80138d:	f7 e9                	imul   %ecx
  80138f:	c1 fa 02             	sar    $0x2,%edx
  801392:	89 c8                	mov    %ecx,%eax
  801394:	c1 f8 1f             	sar    $0x1f,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80139e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a2:	75 bb                	jne    80135f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ae:	48                   	dec    %eax
  8013af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013b6:	74 3d                	je     8013f5 <ltostr+0xc3>
		start = 1 ;
  8013b8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013bf:	eb 34                	jmp    8013f5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c2                	add    %eax,%edx
  8013d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dc:	01 c8                	add    %ecx,%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e8:	01 c2                	add    %eax,%edx
  8013ea:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013ed:	88 02                	mov    %al,(%edx)
		start++ ;
  8013ef:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013f2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013fb:	7c c4                	jl     8013c1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801400:	8b 45 0c             	mov    0xc(%ebp),%eax
  801403:	01 d0                	add    %edx,%eax
  801405:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801408:	90                   	nop
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801411:	ff 75 08             	pushl  0x8(%ebp)
  801414:	e8 c4 f9 ff ff       	call   800ddd <strlen>
  801419:	83 c4 04             	add    $0x4,%esp
  80141c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80141f:	ff 75 0c             	pushl  0xc(%ebp)
  801422:	e8 b6 f9 ff ff       	call   800ddd <strlen>
  801427:	83 c4 04             	add    $0x4,%esp
  80142a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80142d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801434:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80143b:	eb 17                	jmp    801454 <strcconcat+0x49>
		final[s] = str1[s] ;
  80143d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801440:	8b 45 10             	mov    0x10(%ebp),%eax
  801443:	01 c2                	add    %eax,%edx
  801445:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801448:	8b 45 08             	mov    0x8(%ebp),%eax
  80144b:	01 c8                	add    %ecx,%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801451:	ff 45 fc             	incl   -0x4(%ebp)
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80145a:	7c e1                	jl     80143d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80145c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801463:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80146a:	eb 1f                	jmp    80148b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146f:	8d 50 01             	lea    0x1(%eax),%edx
  801472:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801475:	89 c2                	mov    %eax,%edx
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	01 c2                	add    %eax,%edx
  80147c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80147f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801482:	01 c8                	add    %ecx,%eax
  801484:	8a 00                	mov    (%eax),%al
  801486:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801488:	ff 45 f8             	incl   -0x8(%ebp)
  80148b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80148e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801491:	7c d9                	jl     80146c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801493:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801496:	8b 45 10             	mov    0x10(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	c6 00 00             	movb   $0x0,(%eax)
}
  80149e:	90                   	nop
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c4:	eb 0c                	jmp    8014d2 <strsplit+0x31>
			*string++ = 0;
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	8d 50 01             	lea    0x1(%eax),%edx
  8014cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8014cf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	8a 00                	mov    (%eax),%al
  8014d7:	84 c0                	test   %al,%al
  8014d9:	74 18                	je     8014f3 <strsplit+0x52>
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	8a 00                	mov    (%eax),%al
  8014e0:	0f be c0             	movsbl %al,%eax
  8014e3:	50                   	push   %eax
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	e8 83 fa ff ff       	call   800f6f <strchr>
  8014ec:	83 c4 08             	add    $0x8,%esp
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	75 d3                	jne    8014c6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	74 5a                	je     801556 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	83 f8 0f             	cmp    $0xf,%eax
  801504:	75 07                	jne    80150d <strsplit+0x6c>
		{
			return 0;
  801506:	b8 00 00 00 00       	mov    $0x0,%eax
  80150b:	eb 66                	jmp    801573 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	8b 00                	mov    (%eax),%eax
  801512:	8d 48 01             	lea    0x1(%eax),%ecx
  801515:	8b 55 14             	mov    0x14(%ebp),%edx
  801518:	89 0a                	mov    %ecx,(%edx)
  80151a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	01 c2                	add    %eax,%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80152b:	eb 03                	jmp    801530 <strsplit+0x8f>
			string++;
  80152d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	8a 00                	mov    (%eax),%al
  801535:	84 c0                	test   %al,%al
  801537:	74 8b                	je     8014c4 <strsplit+0x23>
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	8a 00                	mov    (%eax),%al
  80153e:	0f be c0             	movsbl %al,%eax
  801541:	50                   	push   %eax
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	e8 25 fa ff ff       	call   800f6f <strchr>
  80154a:	83 c4 08             	add    $0x8,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 dc                	je     80152d <strsplit+0x8c>
			string++;
	}
  801551:	e9 6e ff ff ff       	jmp    8014c4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801556:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801557:	8b 45 14             	mov    0x14(%ebp),%eax
  80155a:	8b 00                	mov    (%eax),%eax
  80155c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	01 d0                	add    %edx,%eax
  801568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80156e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801588:	eb 4a                	jmp    8015d4 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80158a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	01 c2                	add    %eax,%edx
  801592:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801595:	8b 45 0c             	mov    0xc(%ebp),%eax
  801598:	01 c8                	add    %ecx,%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80159e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	01 d0                	add    %edx,%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	3c 40                	cmp    $0x40,%al
  8015aa:	7e 25                	jle    8015d1 <str2lower+0x5c>
  8015ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	01 d0                	add    %edx,%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	3c 5a                	cmp    $0x5a,%al
  8015b8:	7f 17                	jg     8015d1 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8015ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c8:	01 ca                	add    %ecx,%edx
  8015ca:	8a 12                	mov    (%edx),%dl
  8015cc:	83 c2 20             	add    $0x20,%edx
  8015cf:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015d1:	ff 45 fc             	incl   -0x4(%ebp)
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	e8 01 f8 ff ff       	call   800ddd <strlen>
  8015dc:	83 c4 04             	add    $0x4,%esp
  8015df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015e2:	7f a6                	jg     80158a <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	57                   	push   %edi
  8015ed:	56                   	push   %esi
  8015ee:	53                   	push   %ebx
  8015ef:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015fe:	8b 7d 18             	mov    0x18(%ebp),%edi
  801601:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801604:	cd 30                	int    $0x30
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5f                   	pop    %edi
  801612:	5d                   	pop    %ebp
  801613:	c3                   	ret    

00801614 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	8b 45 10             	mov    0x10(%ebp),%eax
  80161d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801620:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801623:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	6a 00                	push   $0x0
  80162c:	51                   	push   %ecx
  80162d:	52                   	push   %edx
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	50                   	push   %eax
  801632:	6a 00                	push   $0x0
  801634:	e8 b0 ff ff ff       	call   8015e9 <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_cgetc>:

int
sys_cgetc(void)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 02                	push   $0x2
  80164e:	e8 96 ff ff ff       	call   8015e9 <syscall>
  801653:	83 c4 18             	add    $0x18,%esp
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 03                	push   $0x3
  801667:	e8 7d ff ff ff       	call   8015e9 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 04                	push   $0x4
  801681:	e8 63 ff ff ff       	call   8015e9 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	90                   	nop
  80168a:	c9                   	leave  
  80168b:	c3                   	ret    

0080168c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80168f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	6a 08                	push   $0x8
  80169f:	e8 45 ff ff ff       	call   8015e9 <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	56                   	push   %esi
  8016ad:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016ae:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	56                   	push   %esi
  8016be:	53                   	push   %ebx
  8016bf:	51                   	push   %ecx
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 09                	push   $0x9
  8016c4:	e8 20 ff ff ff       	call   8015e9 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	ff 75 08             	pushl  0x8(%ebp)
  8016e1:	6a 0a                	push   $0xa
  8016e3:	e8 01 ff ff ff       	call   8015e9 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	6a 0b                	push   $0xb
  8016fe:	e8 e6 fe ff ff       	call   8015e9 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 0c                	push   $0xc
  801717:	e8 cd fe ff ff       	call   8015e9 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 0d                	push   $0xd
  801730:	e8 b4 fe ff ff       	call   8015e9 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 0e                	push   $0xe
  801749:	e8 9b fe ff ff       	call   8015e9 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 0f                	push   $0xf
  801762:	e8 82 fe ff ff       	call   8015e9 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	6a 10                	push   $0x10
  80177c:	e8 68 fe ff ff       	call   8015e9 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 11                	push   $0x11
  801795:	e8 4f fe ff ff       	call   8015e9 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	90                   	nop
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	50                   	push   %eax
  8017b9:	6a 01                	push   $0x1
  8017bb:	e8 29 fe ff ff       	call   8015e9 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	90                   	nop
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 14                	push   $0x14
  8017d5:	e8 0f fe ff ff       	call   8015e9 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 04             	sub    $0x4,%esp
  8017e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	51                   	push   %ecx
  8017f9:	52                   	push   %edx
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	6a 15                	push   $0x15
  801800:	e8 e4 fd ff ff       	call   8015e9 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 16                	push   $0x16
  80181d:	e8 c7 fd ff ff       	call   8015e9 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80182a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	51                   	push   %ecx
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 17                	push   $0x17
  80183c:	e8 a8 fd ff ff       	call   8015e9 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184c:	8b 45 08             	mov    0x8(%ebp),%eax
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	52                   	push   %edx
  801856:	50                   	push   %eax
  801857:	6a 18                	push   $0x18
  801859:	e8 8b fd ff ff       	call   8015e9 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	ff 75 14             	pushl  0x14(%ebp)
  80186e:	ff 75 10             	pushl  0x10(%ebp)
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	6a 19                	push   $0x19
  801877:	e8 6d fd ff ff       	call   8015e9 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	50                   	push   %eax
  801890:	6a 1a                	push   $0x1a
  801892:	e8 52 fd ff ff       	call   8015e9 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	50                   	push   %eax
  8018ac:	6a 1b                	push   $0x1b
  8018ae:	e8 36 fd ff ff       	call   8015e9 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 05                	push   $0x5
  8018c7:	e8 1d fd ff ff       	call   8015e9 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 06                	push   $0x6
  8018e0:	e8 04 fd ff ff       	call   8015e9 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 07                	push   $0x7
  8018f9:	e8 eb fc ff ff       	call   8015e9 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_exit_env>:


void sys_exit_env(void)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 1c                	push   $0x1c
  801912:	e8 d2 fc ff ff       	call   8015e9 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	90                   	nop
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801923:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801926:	8d 50 04             	lea    0x4(%eax),%edx
  801929:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 1d                	push   $0x1d
  801936:	e8 ae fc ff ff       	call   8015e9 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
	return result;
  80193e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801941:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801944:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801947:	89 01                	mov    %eax,(%ecx)
  801949:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	c9                   	leave  
  801950:	c2 04 00             	ret    $0x4

00801953 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 10             	pushl  0x10(%ebp)
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	6a 13                	push   $0x13
  801965:	e8 7f fc ff ff       	call   8015e9 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_rcr2>:
uint32 sys_rcr2()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 1e                	push   $0x1e
  80197f:	e8 65 fc ff ff       	call   8015e9 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801995:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	50                   	push   %eax
  8019a2:	6a 1f                	push   $0x1f
  8019a4:	e8 40 fc ff ff       	call   8015e9 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <rsttst>:
void rsttst()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 21                	push   $0x21
  8019be:	e8 26 fc ff ff       	call   8015e9 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019d5:	8b 55 18             	mov    0x18(%ebp),%edx
  8019d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	ff 75 10             	pushl  0x10(%ebp)
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	ff 75 08             	pushl  0x8(%ebp)
  8019e7:	6a 20                	push   $0x20
  8019e9:	e8 fb fb ff ff       	call   8015e9 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f1:	90                   	nop
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <chktst>:
void chktst(uint32 n)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	ff 75 08             	pushl  0x8(%ebp)
  801a02:	6a 22                	push   $0x22
  801a04:	e8 e0 fb ff ff       	call   8015e9 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0c:	90                   	nop
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <inctst>:

void inctst()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 23                	push   $0x23
  801a1e:	e8 c6 fb ff ff       	call   8015e9 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <gettst>:
uint32 gettst()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 24                	push   $0x24
  801a38:	e8 ac fb ff ff       	call   8015e9 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 25                	push   $0x25
  801a51:	e8 93 fb ff ff       	call   8015e9 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
  801a59:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a5e:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 26                	push   $0x26
  801a7d:	e8 67 fb ff ff       	call   8015e9 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	53                   	push   %ebx
  801a9b:	51                   	push   %ecx
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 27                	push   $0x27
  801aa0:	e8 44 fb ff ff       	call   8015e9 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 28                	push   $0x28
  801ac0:	e8 24 fb ff ff       	call   8015e9 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801acd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	51                   	push   %ecx
  801ad9:	ff 75 10             	pushl  0x10(%ebp)
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 29                	push   $0x29
  801ae0:	e8 04 fb ff ff       	call   8015e9 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 10             	pushl  0x10(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	6a 12                	push   $0x12
  801afc:	e8 e8 fa ff ff       	call   8015e9 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
	return ;
  801b04:	90                   	nop
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 2a                	push   $0x2a
  801b1a:	e8 ca fa ff ff       	call   8015e9 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
	return;
  801b22:	90                   	nop
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 2b                	push   $0x2b
  801b34:	e8 b0 fa ff ff       	call   8015e9 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	ff 75 08             	pushl  0x8(%ebp)
  801b4d:	6a 2d                	push   $0x2d
  801b4f:	e8 95 fa ff ff       	call   8015e9 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
	return;
  801b57:	90                   	nop
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	6a 2c                	push   $0x2c
  801b6b:	e8 79 fa ff ff       	call   8015e9 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return ;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	68 c8 26 80 00       	push   $0x8026c8
  801b84:	68 25 01 00 00       	push   $0x125
  801b89:	68 fb 26 80 00       	push   $0x8026fb
  801b8e:	e8 a3 e8 ff ff       	call   800436 <_panic>
  801b93:	90                   	nop

00801b94 <__udivdi3>:
  801b94:	55                   	push   %ebp
  801b95:	57                   	push   %edi
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 1c             	sub    $0x1c,%esp
  801b9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ba7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bab:	89 ca                	mov    %ecx,%edx
  801bad:	89 f8                	mov    %edi,%eax
  801baf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bb3:	85 f6                	test   %esi,%esi
  801bb5:	75 2d                	jne    801be4 <__udivdi3+0x50>
  801bb7:	39 cf                	cmp    %ecx,%edi
  801bb9:	77 65                	ja     801c20 <__udivdi3+0x8c>
  801bbb:	89 fd                	mov    %edi,%ebp
  801bbd:	85 ff                	test   %edi,%edi
  801bbf:	75 0b                	jne    801bcc <__udivdi3+0x38>
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	31 d2                	xor    %edx,%edx
  801bc8:	f7 f7                	div    %edi
  801bca:	89 c5                	mov    %eax,%ebp
  801bcc:	31 d2                	xor    %edx,%edx
  801bce:	89 c8                	mov    %ecx,%eax
  801bd0:	f7 f5                	div    %ebp
  801bd2:	89 c1                	mov    %eax,%ecx
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	f7 f5                	div    %ebp
  801bd8:	89 cf                	mov    %ecx,%edi
  801bda:	89 fa                	mov    %edi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	39 ce                	cmp    %ecx,%esi
  801be6:	77 28                	ja     801c10 <__udivdi3+0x7c>
  801be8:	0f bd fe             	bsr    %esi,%edi
  801beb:	83 f7 1f             	xor    $0x1f,%edi
  801bee:	75 40                	jne    801c30 <__udivdi3+0x9c>
  801bf0:	39 ce                	cmp    %ecx,%esi
  801bf2:	72 0a                	jb     801bfe <__udivdi3+0x6a>
  801bf4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bf8:	0f 87 9e 00 00 00    	ja     801c9c <__udivdi3+0x108>
  801bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  801c03:	89 fa                	mov    %edi,%edx
  801c05:	83 c4 1c             	add    $0x1c,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	31 ff                	xor    %edi,%edi
  801c12:	31 c0                	xor    %eax,%eax
  801c14:	89 fa                	mov    %edi,%edx
  801c16:	83 c4 1c             	add    $0x1c,%esp
  801c19:	5b                   	pop    %ebx
  801c1a:	5e                   	pop    %esi
  801c1b:	5f                   	pop    %edi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	f7 f7                	div    %edi
  801c24:	31 ff                	xor    %edi,%edi
  801c26:	89 fa                	mov    %edi,%edx
  801c28:	83 c4 1c             	add    $0x1c,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	5f                   	pop    %edi
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    
  801c30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c35:	89 eb                	mov    %ebp,%ebx
  801c37:	29 fb                	sub    %edi,%ebx
  801c39:	89 f9                	mov    %edi,%ecx
  801c3b:	d3 e6                	shl    %cl,%esi
  801c3d:	89 c5                	mov    %eax,%ebp
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 ed                	shr    %cl,%ebp
  801c43:	89 e9                	mov    %ebp,%ecx
  801c45:	09 f1                	or     %esi,%ecx
  801c47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c4b:	89 f9                	mov    %edi,%ecx
  801c4d:	d3 e0                	shl    %cl,%eax
  801c4f:	89 c5                	mov    %eax,%ebp
  801c51:	89 d6                	mov    %edx,%esi
  801c53:	88 d9                	mov    %bl,%cl
  801c55:	d3 ee                	shr    %cl,%esi
  801c57:	89 f9                	mov    %edi,%ecx
  801c59:	d3 e2                	shl    %cl,%edx
  801c5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c5f:	88 d9                	mov    %bl,%cl
  801c61:	d3 e8                	shr    %cl,%eax
  801c63:	09 c2                	or     %eax,%edx
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	89 f2                	mov    %esi,%edx
  801c69:	f7 74 24 0c          	divl   0xc(%esp)
  801c6d:	89 d6                	mov    %edx,%esi
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	f7 e5                	mul    %ebp
  801c73:	39 d6                	cmp    %edx,%esi
  801c75:	72 19                	jb     801c90 <__udivdi3+0xfc>
  801c77:	74 0b                	je     801c84 <__udivdi3+0xf0>
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	31 ff                	xor    %edi,%edi
  801c7d:	e9 58 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c88:	89 f9                	mov    %edi,%ecx
  801c8a:	d3 e2                	shl    %cl,%edx
  801c8c:	39 c2                	cmp    %eax,%edx
  801c8e:	73 e9                	jae    801c79 <__udivdi3+0xe5>
  801c90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c93:	31 ff                	xor    %edi,%edi
  801c95:	e9 40 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	31 c0                	xor    %eax,%eax
  801c9e:	e9 37 ff ff ff       	jmp    801bda <__udivdi3+0x46>
  801ca3:	90                   	nop

00801ca4 <__umoddi3>:
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801caf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cc3:	89 f3                	mov    %esi,%ebx
  801cc5:	89 fa                	mov    %edi,%edx
  801cc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ccb:	89 34 24             	mov    %esi,(%esp)
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	75 1a                	jne    801cec <__umoddi3+0x48>
  801cd2:	39 f7                	cmp    %esi,%edi
  801cd4:	0f 86 a2 00 00 00    	jbe    801d7c <__umoddi3+0xd8>
  801cda:	89 c8                	mov    %ecx,%eax
  801cdc:	89 f2                	mov    %esi,%edx
  801cde:	f7 f7                	div    %edi
  801ce0:	89 d0                	mov    %edx,%eax
  801ce2:	31 d2                	xor    %edx,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 f0                	cmp    %esi,%eax
  801cee:	0f 87 ac 00 00 00    	ja     801da0 <__umoddi3+0xfc>
  801cf4:	0f bd e8             	bsr    %eax,%ebp
  801cf7:	83 f5 1f             	xor    $0x1f,%ebp
  801cfa:	0f 84 ac 00 00 00    	je     801dac <__umoddi3+0x108>
  801d00:	bf 20 00 00 00       	mov    $0x20,%edi
  801d05:	29 ef                	sub    %ebp,%edi
  801d07:	89 fe                	mov    %edi,%esi
  801d09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d0d:	89 e9                	mov    %ebp,%ecx
  801d0f:	d3 e0                	shl    %cl,%eax
  801d11:	89 d7                	mov    %edx,%edi
  801d13:	89 f1                	mov    %esi,%ecx
  801d15:	d3 ef                	shr    %cl,%edi
  801d17:	09 c7                	or     %eax,%edi
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 e2                	shl    %cl,%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	89 d8                	mov    %ebx,%eax
  801d22:	d3 e0                	shl    %cl,%eax
  801d24:	89 c2                	mov    %eax,%edx
  801d26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d2a:	d3 e0                	shl    %cl,%eax
  801d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d34:	89 f1                	mov    %esi,%ecx
  801d36:	d3 e8                	shr    %cl,%eax
  801d38:	09 d0                	or     %edx,%eax
  801d3a:	d3 eb                	shr    %cl,%ebx
  801d3c:	89 da                	mov    %ebx,%edx
  801d3e:	f7 f7                	div    %edi
  801d40:	89 d3                	mov    %edx,%ebx
  801d42:	f7 24 24             	mull   (%esp)
  801d45:	89 c6                	mov    %eax,%esi
  801d47:	89 d1                	mov    %edx,%ecx
  801d49:	39 d3                	cmp    %edx,%ebx
  801d4b:	0f 82 87 00 00 00    	jb     801dd8 <__umoddi3+0x134>
  801d51:	0f 84 91 00 00 00    	je     801de8 <__umoddi3+0x144>
  801d57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d5b:	29 f2                	sub    %esi,%edx
  801d5d:	19 cb                	sbb    %ecx,%ebx
  801d5f:	89 d8                	mov    %ebx,%eax
  801d61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d65:	d3 e0                	shl    %cl,%eax
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 ea                	shr    %cl,%edx
  801d6b:	09 d0                	or     %edx,%eax
  801d6d:	89 e9                	mov    %ebp,%ecx
  801d6f:	d3 eb                	shr    %cl,%ebx
  801d71:	89 da                	mov    %ebx,%edx
  801d73:	83 c4 1c             	add    $0x1c,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5f                   	pop    %edi
  801d79:	5d                   	pop    %ebp
  801d7a:	c3                   	ret    
  801d7b:	90                   	nop
  801d7c:	89 fd                	mov    %edi,%ebp
  801d7e:	85 ff                	test   %edi,%edi
  801d80:	75 0b                	jne    801d8d <__umoddi3+0xe9>
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	31 d2                	xor    %edx,%edx
  801d89:	f7 f7                	div    %edi
  801d8b:	89 c5                	mov    %eax,%ebp
  801d8d:	89 f0                	mov    %esi,%eax
  801d8f:	31 d2                	xor    %edx,%edx
  801d91:	f7 f5                	div    %ebp
  801d93:	89 c8                	mov    %ecx,%eax
  801d95:	f7 f5                	div    %ebp
  801d97:	89 d0                	mov    %edx,%eax
  801d99:	e9 44 ff ff ff       	jmp    801ce2 <__umoddi3+0x3e>
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	89 c8                	mov    %ecx,%eax
  801da2:	89 f2                	mov    %esi,%edx
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
  801dac:	3b 04 24             	cmp    (%esp),%eax
  801daf:	72 06                	jb     801db7 <__umoddi3+0x113>
  801db1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801db5:	77 0f                	ja     801dc6 <__umoddi3+0x122>
  801db7:	89 f2                	mov    %esi,%edx
  801db9:	29 f9                	sub    %edi,%ecx
  801dbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dbf:	89 14 24             	mov    %edx,(%esp)
  801dc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dca:	8b 14 24             	mov    (%esp),%edx
  801dcd:	83 c4 1c             	add    $0x1c,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
  801dd5:	8d 76 00             	lea    0x0(%esi),%esi
  801dd8:	2b 04 24             	sub    (%esp),%eax
  801ddb:	19 fa                	sbb    %edi,%edx
  801ddd:	89 d1                	mov    %edx,%ecx
  801ddf:	89 c6                	mov    %eax,%esi
  801de1:	e9 71 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
  801de6:	66 90                	xchg   %ax,%ax
  801de8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dec:	72 ea                	jb     801dd8 <__umoddi3+0x134>
  801dee:	89 d9                	mov    %ebx,%ecx
  801df0:	e9 62 ff ff ff       	jmp    801d57 <__umoddi3+0xb3>
