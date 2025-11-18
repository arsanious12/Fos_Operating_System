
obj/user/tst_envfree3_slave:     file format elf32-i386


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
  800031:	e8 43 01 00 00       	call   800179 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern void destroy(void);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	// Testing scenario 3: using dynamic allocation and free. Kill itself!
	// Testing removing the allocated pages (static & dynamic) in mem, WS, mapped page tables, env's directory and env's page file

	int freeFrames_before = sys_calculate_free_frames() ;
  800044:	e8 d9 13 00 00       	call   801422 <sys_calculate_free_frames>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  80004c:	e8 1c 14 00 00       	call   80146d <sys_pf_calculate_allocated_pages>
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80005a:	68 00 1d 80 00       	push   $0x801d00
  80005f:	e8 ba 03 00 00       	call   80041e <cprintf>
  800064:	83 c4 10             	add    $0x10,%esp

	/*[4] CREATE AND RUN ProcessA & ProcessB*/
	//Create 3 processes
	int32 envIdProcessA = sys_create_env("sc_ms_leak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800067:	a1 20 30 80 00       	mov    0x803020,%eax
  80006c:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800072:	89 c2                	mov    %eax,%edx
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 33 1d 80 00       	push   $0x801d33
  800088:	e8 f0 14 00 00       	call   80157d <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdProcessB = sys_create_env("sc_ms_noleak_small", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 30 80 00       	mov    0x803020,%eax
  800098:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000a5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000ab:	6a 32                	push   $0x32
  8000ad:	52                   	push   %edx
  8000ae:	50                   	push   %eax
  8000af:	68 44 1d 80 00       	push   $0x801d44
  8000b4:	e8 c4 14 00 00       	call   80157d <sys_create_env>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 d8             	mov    %eax,-0x28(%ebp)

	rsttst();
  8000bf:	e8 05 16 00 00       	call   8016c9 <rsttst>

	//Run 2 processes
	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8000ca:	e8 cc 14 00 00       	call   80159b <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8000d8:	e8 be 14 00 00       	call   80159b <sys_run_env>
  8000dd:	83 c4 10             	add    $0x10,%esp

	//env_sleep(30000);

	//to ensure that the slave environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000e0:	90                   	nop
  8000e1:	e8 5d 16 00 00       	call   801743 <gettst>
  8000e6:	83 f8 02             	cmp    $0x2,%eax
  8000e9:	75 f6                	jne    8000e1 <_main+0xa9>

	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000eb:	e8 32 13 00 00       	call   801422 <sys_calculate_free_frames>
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	50                   	push   %eax
  8000f4:	68 58 1d 80 00       	push   $0x801d58
  8000f9:	e8 20 03 00 00       	call   80041e <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	//Kill the 3 processes [including itself]
	//DISABLE the interrupt to ensure the env_free is done as a whole without preemption
	//to avoid context switch (due to clock interrupt) while freeing the env to prevent:
	//	1. context switching to a wrong process specially in the part of temporarily switching the CPU process for freeing shared variables
	//	2. changing the # free frames
	char changeIntCmd[100] = "__changeInterruptStatus__";
  800101:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800107:	bb 8a 1d 80 00       	mov    $0x801d8a,%ebx
  80010c:	ba 1a 00 00 00       	mov    $0x1a,%edx
  800111:	89 c7                	mov    %eax,%edi
  800113:	89 de                	mov    %ebx,%esi
  800115:	89 d1                	mov    %edx,%ecx
  800117:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800119:	8d 55 8e             	lea    -0x72(%ebp),%edx
  80011c:	b9 4a 00 00 00       	mov    $0x4a,%ecx
  800121:	b0 00                	mov    $0x0,%al
  800123:	89 d7                	mov    %edx,%edi
  800125:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(changeIntCmd, 0);
  800127:	83 ec 08             	sub    $0x8,%esp
  80012a:	6a 00                	push   $0x0
  80012c:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800132:	50                   	push   %eax
  800133:	e8 e9 16 00 00       	call   801821 <sys_utilities>
  800138:	83 c4 10             	add    $0x10,%esp
	{
		sys_destroy_env(envIdProcessA);
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	ff 75 dc             	pushl  -0x24(%ebp)
  800141:	e8 71 14 00 00       	call   8015b7 <sys_destroy_env>
  800146:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	ff 75 d8             	pushl  -0x28(%ebp)
  80014f:	e8 63 14 00 00       	call   8015b7 <sys_destroy_env>
  800154:	83 c4 10             	add    $0x10,%esp
		//KILL ITSELF
		destroy();
  800157:	e8 be 01 00 00       	call   80031a <destroy>
	}
	sys_utilities(changeIntCmd, 1);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	6a 01                	push   $0x1
  800161:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 b4 16 00 00       	call   801821 <sys_utilities>
  80016d:	83 c4 10             	add    $0x10,%esp
}
  800170:	90                   	nop
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
  80017f:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800182:	e8 64 14 00 00       	call   8015eb <sys_getenvindex>
  800187:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80018a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80018d:	89 d0                	mov    %edx,%eax
  80018f:	c1 e0 06             	shl    $0x6,%eax
  800192:	29 d0                	sub    %edx,%eax
  800194:	c1 e0 02             	shl    $0x2,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	c1 e0 03             	shl    $0x3,%eax
  8001a5:	01 d0                	add    %edx,%eax
  8001a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001ae:	29 c2                	sub    %eax,%edx
  8001b0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001b7:	89 c2                	mov    %eax,%edx
  8001b9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001bf:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c9:	8a 40 20             	mov    0x20(%eax),%al
  8001cc:	84 c0                	test   %al,%al
  8001ce:	74 0d                	je     8001dd <libmain+0x64>
		binaryname = myEnv->prog_name;
  8001d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001d5:	83 c0 20             	add    $0x20,%eax
  8001d8:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e1:	7e 0a                	jle    8001ed <libmain+0x74>
		binaryname = argv[0];
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	8b 00                	mov    (%eax),%eax
  8001e8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 0c             	pushl  0xc(%ebp)
  8001f3:	ff 75 08             	pushl  0x8(%ebp)
  8001f6:	e8 3d fe ff ff       	call   800038 <_main>
  8001fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800203:	85 c0                	test   %eax,%eax
  800205:	0f 84 01 01 00 00    	je     80030c <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80020b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800211:	bb e8 1e 80 00       	mov    $0x801ee8,%ebx
  800216:	ba 0e 00 00 00       	mov    $0xe,%edx
  80021b:	89 c7                	mov    %eax,%edi
  80021d:	89 de                	mov    %ebx,%esi
  80021f:	89 d1                	mov    %edx,%ecx
  800221:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800223:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800226:	b9 56 00 00 00       	mov    $0x56,%ecx
  80022b:	b0 00                	mov    $0x0,%al
  80022d:	89 d7                	mov    %edx,%edi
  80022f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800231:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800238:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	50                   	push   %eax
  80023f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800245:	50                   	push   %eax
  800246:	e8 d6 15 00 00       	call   801821 <sys_utilities>
  80024b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80024e:	e8 1f 11 00 00       	call   801372 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	68 08 1e 80 00       	push   $0x801e08
  80025b:	e8 be 01 00 00       	call   80041e <cprintf>
  800260:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800263:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800266:	85 c0                	test   %eax,%eax
  800268:	74 18                	je     800282 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80026a:	e8 d0 15 00 00       	call   80183f <sys_get_optimal_num_faults>
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	50                   	push   %eax
  800273:	68 30 1e 80 00       	push   $0x801e30
  800278:	e8 a1 01 00 00       	call   80041e <cprintf>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	eb 59                	jmp    8002db <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800282:	a1 20 30 80 00       	mov    0x803020,%eax
  800287:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80028d:	a1 20 30 80 00       	mov    0x803020,%eax
  800292:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	52                   	push   %edx
  80029c:	50                   	push   %eax
  80029d:	68 54 1e 80 00       	push   $0x801e54
  8002a2:	e8 77 01 00 00       	call   80041e <cprintf>
  8002a7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002af:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ba:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002c5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002cb:	51                   	push   %ecx
  8002cc:	52                   	push   %edx
  8002cd:	50                   	push   %eax
  8002ce:	68 7c 1e 80 00       	push   $0x801e7c
  8002d3:	e8 46 01 00 00       	call   80041e <cprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002db:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e0:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002e6:	83 ec 08             	sub    $0x8,%esp
  8002e9:	50                   	push   %eax
  8002ea:	68 d4 1e 80 00       	push   $0x801ed4
  8002ef:	e8 2a 01 00 00       	call   80041e <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 08 1e 80 00       	push   $0x801e08
  8002ff:	e8 1a 01 00 00       	call   80041e <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800307:	e8 80 10 00 00       	call   80138c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80030c:	e8 1f 00 00 00       	call   800330 <exit>
}
  800311:	90                   	nop
  800312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800315:	5b                   	pop    %ebx
  800316:	5e                   	pop    %esi
  800317:	5f                   	pop    %edi
  800318:	5d                   	pop    %ebp
  800319:	c3                   	ret    

0080031a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	6a 00                	push   $0x0
  800325:	e8 8d 12 00 00       	call   8015b7 <sys_destroy_env>
  80032a:	83 c4 10             	add    $0x10,%esp
}
  80032d:	90                   	nop
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <exit>:

void
exit(void)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800336:	e8 e2 12 00 00       	call   80161d <sys_exit_env>
}
  80033b:	90                   	nop
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	53                   	push   %ebx
  800342:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800345:	8b 45 0c             	mov    0xc(%ebp),%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	8d 48 01             	lea    0x1(%eax),%ecx
  80034d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800350:	89 0a                	mov    %ecx,(%edx)
  800352:	8b 55 08             	mov    0x8(%ebp),%edx
  800355:	88 d1                	mov    %dl,%cl
  800357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80035e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	3d ff 00 00 00       	cmp    $0xff,%eax
  800368:	75 30                	jne    80039a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80036a:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  800370:	a0 44 30 80 00       	mov    0x803044,%al
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037b:	8b 09                	mov    (%ecx),%ecx
  80037d:	89 cb                	mov    %ecx,%ebx
  80037f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800382:	83 c1 08             	add    $0x8,%ecx
  800385:	52                   	push   %edx
  800386:	50                   	push   %eax
  800387:	53                   	push   %ebx
  800388:	51                   	push   %ecx
  800389:	e8 a0 0f 00 00       	call   80132e <sys_cputs>
  80038e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800391:	8b 45 0c             	mov    0xc(%ebp),%eax
  800394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80039a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039d:	8b 40 04             	mov    0x4(%eax),%eax
  8003a0:	8d 50 01             	lea    0x1(%eax),%edx
  8003a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003a9:	90                   	nop
  8003aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    

008003af <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003b8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003bf:	00 00 00 
	b.cnt = 0;
  8003c2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003cc:	ff 75 0c             	pushl  0xc(%ebp)
  8003cf:	ff 75 08             	pushl  0x8(%ebp)
  8003d2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d8:	50                   	push   %eax
  8003d9:	68 3e 03 80 00       	push   $0x80033e
  8003de:	e8 5a 02 00 00       	call   80063d <vprintfmt>
  8003e3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8003e6:	8b 15 18 b1 81 00    	mov    0x81b118,%edx
  8003ec:	a0 44 30 80 00       	mov    0x803044,%al
  8003f1:	0f b6 c0             	movzbl %al,%eax
  8003f4:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	51                   	push   %ecx
  8003fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800403:	83 c0 08             	add    $0x8,%eax
  800406:	50                   	push   %eax
  800407:	e8 22 0f 00 00       	call   80132e <sys_cputs>
  80040c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80040f:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  800416:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80041c:	c9                   	leave  
  80041d:	c3                   	ret    

0080041e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80041e:	55                   	push   %ebp
  80041f:	89 e5                	mov    %esp,%ebp
  800421:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800424:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  80042b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80042e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	83 ec 08             	sub    $0x8,%esp
  800437:	ff 75 f4             	pushl  -0xc(%ebp)
  80043a:	50                   	push   %eax
  80043b:	e8 6f ff ff ff       	call   8003af <vcprintf>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800446:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800451:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	c1 e0 08             	shl    $0x8,%eax
  80045e:	a3 18 b1 81 00       	mov    %eax,0x81b118
	va_start(ap, fmt);
  800463:	8d 45 0c             	lea    0xc(%ebp),%eax
  800466:	83 c0 04             	add    $0x4,%eax
  800469:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	ff 75 f4             	pushl  -0xc(%ebp)
  800475:	50                   	push   %eax
  800476:	e8 34 ff ff ff       	call   8003af <vcprintf>
  80047b:	83 c4 10             	add    $0x10,%esp
  80047e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800481:	c7 05 18 b1 81 00 00 	movl   $0x700,0x81b118
  800488:	07 00 00 

	return cnt;
  80048b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800496:	e8 d7 0e 00 00       	call   801372 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80049b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80049e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	83 ec 08             	sub    $0x8,%esp
  8004a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8004aa:	50                   	push   %eax
  8004ab:	e8 ff fe ff ff       	call   8003af <vcprintf>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8004b6:	e8 d1 0e 00 00       	call   80138c <sys_unlock_cons>
	return cnt;
  8004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 14             	sub    $0x14,%esp
  8004c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004de:	77 55                	ja     800535 <printnum+0x75>
  8004e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004e3:	72 05                	jb     8004ea <printnum+0x2a>
  8004e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004e8:	77 4b                	ja     800535 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f8:	52                   	push   %edx
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8004fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800500:	e8 97 15 00 00       	call   801a9c <__udivdi3>
  800505:	83 c4 10             	add    $0x10,%esp
  800508:	83 ec 04             	sub    $0x4,%esp
  80050b:	ff 75 20             	pushl  0x20(%ebp)
  80050e:	53                   	push   %ebx
  80050f:	ff 75 18             	pushl  0x18(%ebp)
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	ff 75 0c             	pushl  0xc(%ebp)
  800517:	ff 75 08             	pushl  0x8(%ebp)
  80051a:	e8 a1 ff ff ff       	call   8004c0 <printnum>
  80051f:	83 c4 20             	add    $0x20,%esp
  800522:	eb 1a                	jmp    80053e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	ff 75 20             	pushl  0x20(%ebp)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	ff d0                	call   *%eax
  800532:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800535:	ff 4d 1c             	decl   0x1c(%ebp)
  800538:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80053c:	7f e6                	jg     800524 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800541:	bb 00 00 00 00       	mov    $0x0,%ebx
  800546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80054c:	53                   	push   %ebx
  80054d:	51                   	push   %ecx
  80054e:	52                   	push   %edx
  80054f:	50                   	push   %eax
  800550:	e8 57 16 00 00       	call   801bac <__umoddi3>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	05 74 21 80 00       	add    $0x802174,%eax
  80055d:	8a 00                	mov    (%eax),%al
  80055f:	0f be c0             	movsbl %al,%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	ff 75 0c             	pushl  0xc(%ebp)
  800568:	50                   	push   %eax
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	ff d0                	call   *%eax
  80056e:	83 c4 10             	add    $0x10,%esp
}
  800571:	90                   	nop
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80057a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057e:	7e 1c                	jle    80059c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	8d 50 08             	lea    0x8(%eax),%edx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	89 10                	mov    %edx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	83 e8 08             	sub    $0x8,%eax
  800595:	8b 50 04             	mov    0x4(%eax),%edx
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	eb 40                	jmp    8005dc <getuint+0x65>
	else if (lflag)
  80059c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a0:	74 1e                	je     8005c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	8d 50 04             	lea    0x4(%eax),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	89 10                	mov    %edx,(%eax)
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	8b 00                	mov    (%eax),%eax
  8005b4:	83 e8 04             	sub    $0x4,%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005be:	eb 1c                	jmp    8005dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	8d 50 04             	lea    0x4(%eax),%edx
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	89 10                	mov    %edx,(%eax)
  8005cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	83 e8 04             	sub    $0x4,%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005dc:	5d                   	pop    %ebp
  8005dd:	c3                   	ret    

008005de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005e5:	7e 1c                	jle    800603 <getint+0x25>
		return va_arg(*ap, long long);
  8005e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	8d 50 08             	lea    0x8(%eax),%edx
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	89 10                	mov    %edx,(%eax)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	83 e8 08             	sub    $0x8,%eax
  8005fc:	8b 50 04             	mov    0x4(%eax),%edx
  8005ff:	8b 00                	mov    (%eax),%eax
  800601:	eb 38                	jmp    80063b <getint+0x5d>
	else if (lflag)
  800603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800607:	74 1a                	je     800623 <getint+0x45>
		return va_arg(*ap, long);
  800609:	8b 45 08             	mov    0x8(%ebp),%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	8b 45 08             	mov    0x8(%ebp),%eax
  800614:	89 10                	mov    %edx,(%eax)
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	83 e8 04             	sub    $0x4,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	99                   	cltd   
  800621:	eb 18                	jmp    80063b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800623:	8b 45 08             	mov    0x8(%ebp),%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	8d 50 04             	lea    0x4(%eax),%edx
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 10                	mov    %edx,(%eax)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 e8 04             	sub    $0x4,%eax
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	99                   	cltd   
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	56                   	push   %esi
  800641:	53                   	push   %ebx
  800642:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800645:	eb 17                	jmp    80065e <vprintfmt+0x21>
			if (ch == '\0')
  800647:	85 db                	test   %ebx,%ebx
  800649:	0f 84 c1 03 00 00    	je     800a10 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	53                   	push   %ebx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	ff d0                	call   *%eax
  80065b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80065e:	8b 45 10             	mov    0x10(%ebp),%eax
  800661:	8d 50 01             	lea    0x1(%eax),%edx
  800664:	89 55 10             	mov    %edx,0x10(%ebp)
  800667:	8a 00                	mov    (%eax),%al
  800669:	0f b6 d8             	movzbl %al,%ebx
  80066c:	83 fb 25             	cmp    $0x25,%ebx
  80066f:	75 d6                	jne    800647 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800671:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800675:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80067c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800683:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80068a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800691:	8b 45 10             	mov    0x10(%ebp),%eax
  800694:	8d 50 01             	lea    0x1(%eax),%edx
  800697:	89 55 10             	mov    %edx,0x10(%ebp)
  80069a:	8a 00                	mov    (%eax),%al
  80069c:	0f b6 d8             	movzbl %al,%ebx
  80069f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8006a2:	83 f8 5b             	cmp    $0x5b,%eax
  8006a5:	0f 87 3d 03 00 00    	ja     8009e8 <vprintfmt+0x3ab>
  8006ab:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  8006b2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006b8:	eb d7                	jmp    800691 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006ba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006be:	eb d1                	jmp    800691 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006ca:	89 d0                	mov    %edx,%eax
  8006cc:	c1 e0 02             	shl    $0x2,%eax
  8006cf:	01 d0                	add    %edx,%eax
  8006d1:	01 c0                	add    %eax,%eax
  8006d3:	01 d8                	add    %ebx,%eax
  8006d5:	83 e8 30             	sub    $0x30,%eax
  8006d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006db:	8b 45 10             	mov    0x10(%ebp),%eax
  8006de:	8a 00                	mov    (%eax),%al
  8006e0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006e3:	83 fb 2f             	cmp    $0x2f,%ebx
  8006e6:	7e 3e                	jle    800726 <vprintfmt+0xe9>
  8006e8:	83 fb 39             	cmp    $0x39,%ebx
  8006eb:	7f 39                	jg     800726 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006ed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006f0:	eb d5                	jmp    8006c7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 c0 04             	add    $0x4,%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	83 e8 04             	sub    $0x4,%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800706:	eb 1f                	jmp    800727 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800708:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070c:	79 83                	jns    800691 <vprintfmt+0x54>
				width = 0;
  80070e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800715:	e9 77 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80071a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800721:	e9 6b ff ff ff       	jmp    800691 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800726:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	0f 89 60 ff ff ff    	jns    800691 <vprintfmt+0x54>
				width = precision, precision = -1;
  800731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800737:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80073e:	e9 4e ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800743:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800746:	e9 46 ff ff ff       	jmp    800691 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 c0 04             	add    $0x4,%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
  800754:	8b 45 14             	mov    0x14(%ebp),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	50                   	push   %eax
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			break;
  80076b:	e9 9b 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 c0 04             	add    $0x4,%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	83 e8 04             	sub    $0x4,%eax
  80077f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800781:	85 db                	test   %ebx,%ebx
  800783:	79 02                	jns    800787 <vprintfmt+0x14a>
				err = -err;
  800785:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800787:	83 fb 64             	cmp    $0x64,%ebx
  80078a:	7f 0b                	jg     800797 <vprintfmt+0x15a>
  80078c:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  800793:	85 f6                	test   %esi,%esi
  800795:	75 19                	jne    8007b0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800797:	53                   	push   %ebx
  800798:	68 85 21 80 00       	push   $0x802185
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	ff 75 08             	pushl  0x8(%ebp)
  8007a3:	e8 70 02 00 00       	call   800a18 <printfmt>
  8007a8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007ab:	e9 5b 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007b0:	56                   	push   %esi
  8007b1:	68 8e 21 80 00       	push   $0x80218e
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 57 02 00 00       	call   800a18 <printfmt>
  8007c1:	83 c4 10             	add    $0x10,%esp
			break;
  8007c4:	e9 42 02 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 c0 04             	add    $0x4,%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d5:	83 e8 04             	sub    $0x4,%eax
  8007d8:	8b 30                	mov    (%eax),%esi
  8007da:	85 f6                	test   %esi,%esi
  8007dc:	75 05                	jne    8007e3 <vprintfmt+0x1a6>
				p = "(null)";
  8007de:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  8007e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e7:	7e 6d                	jle    800856 <vprintfmt+0x219>
  8007e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007ed:	74 67                	je     800856 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	50                   	push   %eax
  8007f6:	56                   	push   %esi
  8007f7:	e8 1e 03 00 00       	call   800b1a <strnlen>
  8007fc:	83 c4 10             	add    $0x10,%esp
  8007ff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800802:	eb 16                	jmp    80081a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800804:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800817:	ff 4d e4             	decl   -0x1c(%ebp)
  80081a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081e:	7f e4                	jg     800804 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800820:	eb 34                	jmp    800856 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800822:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800826:	74 1c                	je     800844 <vprintfmt+0x207>
  800828:	83 fb 1f             	cmp    $0x1f,%ebx
  80082b:	7e 05                	jle    800832 <vprintfmt+0x1f5>
  80082d:	83 fb 7e             	cmp    $0x7e,%ebx
  800830:	7e 12                	jle    800844 <vprintfmt+0x207>
					putch('?', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 3f                	push   $0x3f
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	eb 0f                	jmp    800853 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800844:	83 ec 08             	sub    $0x8,%esp
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	53                   	push   %ebx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800853:	ff 4d e4             	decl   -0x1c(%ebp)
  800856:	89 f0                	mov    %esi,%eax
  800858:	8d 70 01             	lea    0x1(%eax),%esi
  80085b:	8a 00                	mov    (%eax),%al
  80085d:	0f be d8             	movsbl %al,%ebx
  800860:	85 db                	test   %ebx,%ebx
  800862:	74 24                	je     800888 <vprintfmt+0x24b>
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	78 b8                	js     800822 <vprintfmt+0x1e5>
  80086a:	ff 4d e0             	decl   -0x20(%ebp)
  80086d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800871:	79 af                	jns    800822 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800873:	eb 13                	jmp    800888 <vprintfmt+0x24b>
				putch(' ', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 20                	push   $0x20
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800885:	ff 4d e4             	decl   -0x1c(%ebp)
  800888:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088c:	7f e7                	jg     800875 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80088e:	e9 78 01 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 e8             	pushl  -0x18(%ebp)
  800899:	8d 45 14             	lea    0x14(%ebp),%eax
  80089c:	50                   	push   %eax
  80089d:	e8 3c fd ff ff       	call   8005de <getint>
  8008a2:	83 c4 10             	add    $0x10,%esp
  8008a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b1:	85 d2                	test   %edx,%edx
  8008b3:	79 23                	jns    8008d8 <vprintfmt+0x29b>
				putch('-', putdat);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 0c             	pushl  0xc(%ebp)
  8008bb:	6a 2d                	push   $0x2d
  8008bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c0:	ff d0                	call   *%eax
  8008c2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	f7 d8                	neg    %eax
  8008cd:	83 d2 00             	adc    $0x0,%edx
  8008d0:	f7 da                	neg    %edx
  8008d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008d8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008df:	e9 bc 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e4:	83 ec 08             	sub    $0x8,%esp
  8008e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ed:	50                   	push   %eax
  8008ee:	e8 84 fc ff ff       	call   800577 <getuint>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008fc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800903:	e9 98 00 00 00       	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	ff 75 0c             	pushl  0xc(%ebp)
  80090e:	6a 58                	push   $0x58
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800918:	83 ec 08             	sub    $0x8,%esp
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	6a 58                	push   $0x58
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	ff d0                	call   *%eax
  800925:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	ff 75 0c             	pushl  0xc(%ebp)
  80092e:	6a 58                	push   $0x58
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
			break;
  800938:	e9 ce 00 00 00       	jmp    800a0b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 30                	push   $0x30
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 78                	push   $0x78
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 c0 04             	add    $0x4,%eax
  800963:	89 45 14             	mov    %eax,0x14(%ebp)
  800966:	8b 45 14             	mov    0x14(%ebp),%eax
  800969:	83 e8 04             	sub    $0x4,%eax
  80096c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80096e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800971:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800978:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80097f:	eb 1f                	jmp    8009a0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 e8             	pushl  -0x18(%ebp)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
  80098a:	50                   	push   %eax
  80098b:	e8 e7 fb ff ff       	call   800577 <getuint>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800999:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a7:	83 ec 04             	sub    $0x4,%esp
  8009aa:	52                   	push   %edx
  8009ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8009b5:	ff 75 0c             	pushl  0xc(%ebp)
  8009b8:	ff 75 08             	pushl  0x8(%ebp)
  8009bb:	e8 00 fb ff ff       	call   8004c0 <printnum>
  8009c0:	83 c4 20             	add    $0x20,%esp
			break;
  8009c3:	eb 46                	jmp    800a0b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 0c             	pushl  0xc(%ebp)
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			break;
  8009d4:	eb 35                	jmp    800a0b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8009d6:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  8009dd:	eb 2c                	jmp    800a0b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8009df:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  8009e6:	eb 23                	jmp    800a0b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 25                	push   $0x25
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f8:	ff 4d 10             	decl   0x10(%ebp)
  8009fb:	eb 03                	jmp    800a00 <vprintfmt+0x3c3>
  8009fd:	ff 4d 10             	decl   0x10(%ebp)
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	48                   	dec    %eax
  800a04:	8a 00                	mov    (%eax),%al
  800a06:	3c 25                	cmp    $0x25,%al
  800a08:	75 f3                	jne    8009fd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800a0a:	90                   	nop
		}
	}
  800a0b:	e9 35 fc ff ff       	jmp    800645 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800a10:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800a11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a21:	83 c0 04             	add    $0x4,%eax
  800a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2d:	50                   	push   %eax
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	ff 75 08             	pushl  0x8(%ebp)
  800a34:	e8 04 fc ff ff       	call   80063d <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a3c:	90                   	nop
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a45:	8b 40 08             	mov    0x8(%eax),%eax
  800a48:	8d 50 01             	lea    0x1(%eax),%edx
  800a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a54:	8b 10                	mov    (%eax),%edx
  800a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a59:	8b 40 04             	mov    0x4(%eax),%eax
  800a5c:	39 c2                	cmp    %eax,%edx
  800a5e:	73 12                	jae    800a72 <sprintputch+0x33>
		*b->buf++ = ch;
  800a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a63:	8b 00                	mov    (%eax),%eax
  800a65:	8d 48 01             	lea    0x1(%eax),%ecx
  800a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6b:	89 0a                	mov    %ecx,(%edx)
  800a6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a70:	88 10                	mov    %dl,(%eax)
}
  800a72:	90                   	nop
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	01 d0                	add    %edx,%eax
  800a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a9a:	74 06                	je     800aa2 <vsnprintf+0x2d>
  800a9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa0:	7f 07                	jg     800aa9 <vsnprintf+0x34>
		return -E_INVAL;
  800aa2:	b8 03 00 00 00       	mov    $0x3,%eax
  800aa7:	eb 20                	jmp    800ac9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa9:	ff 75 14             	pushl  0x14(%ebp)
  800aac:	ff 75 10             	pushl  0x10(%ebp)
  800aaf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ab2:	50                   	push   %eax
  800ab3:	68 3f 0a 80 00       	push   $0x800a3f
  800ab8:	e8 80 fb ff ff       	call   80063d <vprintfmt>
  800abd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    

00800acb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ad1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad4:	83 c0 04             	add    $0x4,%eax
  800ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ada:	8b 45 10             	mov    0x10(%ebp),%eax
  800add:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae0:	50                   	push   %eax
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	ff 75 08             	pushl  0x8(%ebp)
  800ae7:	e8 89 ff ff ff       	call   800a75 <vsnprintf>
  800aec:	83 c4 10             	add    $0x10,%esp
  800aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800afd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b04:	eb 06                	jmp    800b0c <strlen+0x15>
		n++;
  800b06:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b09:	ff 45 08             	incl   0x8(%ebp)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8a 00                	mov    (%eax),%al
  800b11:	84 c0                	test   %al,%al
  800b13:	75 f1                	jne    800b06 <strlen+0xf>
		n++;
	return n;
  800b15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b27:	eb 09                	jmp    800b32 <strnlen+0x18>
		n++;
  800b29:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2c:	ff 45 08             	incl   0x8(%ebp)
  800b2f:	ff 4d 0c             	decl   0xc(%ebp)
  800b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b36:	74 09                	je     800b41 <strnlen+0x27>
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 00                	mov    (%eax),%al
  800b3d:	84 c0                	test   %al,%al
  800b3f:	75 e8                	jne    800b29 <strnlen+0xf>
		n++;
	return n;
  800b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b44:	c9                   	leave  
  800b45:	c3                   	ret    

00800b46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b52:	90                   	nop
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8d 50 01             	lea    0x1(%eax),%edx
  800b59:	89 55 08             	mov    %edx,0x8(%ebp)
  800b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b62:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b65:	8a 12                	mov    (%edx),%dl
  800b67:	88 10                	mov    %dl,(%eax)
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	84 c0                	test   %al,%al
  800b6d:	75 e4                	jne    800b53 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b87:	eb 1f                	jmp    800ba8 <strncpy+0x34>
		*dst++ = *src;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8d 50 01             	lea    0x1(%eax),%edx
  800b8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b95:	8a 12                	mov    (%edx),%dl
  800b97:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9c:	8a 00                	mov    (%eax),%al
  800b9e:	84 c0                	test   %al,%al
  800ba0:	74 03                	je     800ba5 <strncpy+0x31>
			src++;
  800ba2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba5:	ff 45 fc             	incl   -0x4(%ebp)
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	3b 45 10             	cmp    0x10(%ebp),%eax
  800bae:	72 d9                	jb     800b89 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800bc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc5:	74 30                	je     800bf7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bc7:	eb 16                	jmp    800bdf <strlcpy+0x2a>
			*dst++ = *src++;
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8d 50 01             	lea    0x1(%eax),%edx
  800bcf:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bdb:	8a 12                	mov    (%edx),%dl
  800bdd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bdf:	ff 4d 10             	decl   0x10(%ebp)
  800be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be6:	74 09                	je     800bf1 <strlcpy+0x3c>
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 d8                	jne    800bc9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfd:	29 c2                	sub    %eax,%edx
  800bff:	89 d0                	mov    %edx,%eax
}
  800c01:	c9                   	leave  
  800c02:	c3                   	ret    

00800c03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c06:	eb 06                	jmp    800c0e <strcmp+0xb>
		p++, q++;
  800c08:	ff 45 08             	incl   0x8(%ebp)
  800c0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	84 c0                	test   %al,%al
  800c15:	74 0e                	je     800c25 <strcmp+0x22>
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	8a 10                	mov    (%eax),%dl
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	38 c2                	cmp    %al,%dl
  800c23:	74 e3                	je     800c08 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	0f b6 d0             	movzbl %al,%edx
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	0f b6 c0             	movzbl %al,%eax
  800c35:	29 c2                	sub    %eax,%edx
  800c37:	89 d0                	mov    %edx,%eax
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c3e:	eb 09                	jmp    800c49 <strncmp+0xe>
		n--, p++, q++;
  800c40:	ff 4d 10             	decl   0x10(%ebp)
  800c43:	ff 45 08             	incl   0x8(%ebp)
  800c46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4d:	74 17                	je     800c66 <strncmp+0x2b>
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 0e                	je     800c66 <strncmp+0x2b>
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 10                	mov    (%eax),%dl
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	38 c2                	cmp    %al,%dl
  800c64:	74 da                	je     800c40 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c6a:	75 07                	jne    800c73 <strncmp+0x38>
		return 0;
  800c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c71:	eb 14                	jmp    800c87 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	0f b6 d0             	movzbl %al,%edx
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	0f b6 c0             	movzbl %al,%eax
  800c83:	29 c2                	sub    %eax,%edx
  800c85:	89 d0                	mov    %edx,%eax
}
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	83 ec 04             	sub    $0x4,%esp
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c95:	eb 12                	jmp    800ca9 <strchr+0x20>
		if (*s == c)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c9f:	75 05                	jne    800ca6 <strchr+0x1d>
			return (char *) s;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	eb 11                	jmp    800cb7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ca6:	ff 45 08             	incl   0x8(%ebp)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 e5                	jne    800c97 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800cc5:	eb 0d                	jmp    800cd4 <strfind+0x1b>
		if (*s == c)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ccf:	74 0e                	je     800cdf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cd1:	ff 45 08             	incl   0x8(%ebp)
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	84 c0                	test   %al,%al
  800cdb:	75 ea                	jne    800cc7 <strfind+0xe>
  800cdd:	eb 01                	jmp    800ce0 <strfind+0x27>
		if (*s == c)
			break;
  800cdf:	90                   	nop
	return (char *) s;
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800cf1:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800cf5:	76 63                	jbe    800d5a <memset+0x75>
		uint64 data_block = c;
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	99                   	cltd   
  800cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cfe:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d07:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800d0b:	c1 e0 08             	shl    $0x8,%eax
  800d0e:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d11:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d1a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800d1e:	c1 e0 10             	shl    $0x10,%eax
  800d21:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d24:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d34:	09 45 f0             	or     %eax,-0x10(%ebp)
  800d37:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800d3a:	eb 18                	jmp    800d54 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800d3c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800d3f:	8d 41 08             	lea    0x8(%ecx),%eax
  800d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d4b:	89 01                	mov    %eax,(%ecx)
  800d4d:	89 51 04             	mov    %edx,0x4(%ecx)
  800d50:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800d54:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d58:	77 e2                	ja     800d3c <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800d5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5e:	74 23                	je     800d83 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d66:	eb 0e                	jmp    800d76 <memset+0x91>
			*p8++ = (uint8)c;
  800d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d6b:	8d 50 01             	lea    0x1(%eax),%edx
  800d6e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d74:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  800d76:	8b 45 10             	mov    0x10(%ebp),%eax
  800d79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	75 e5                	jne    800d68 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  800d9a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800d9e:	76 24                	jbe    800dc4 <memcpy+0x3c>
		while(n >= 8){
  800da0:	eb 1c                	jmp    800dbe <memcpy+0x36>
			*d64 = *s64;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da5:	8b 50 04             	mov    0x4(%eax),%edx
  800da8:	8b 00                	mov    (%eax),%eax
  800daa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800dad:	89 01                	mov    %eax,(%ecx)
  800daf:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  800db2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  800db6:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  800dba:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  800dbe:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800dc2:	77 de                	ja     800da2 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  800dc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc8:	74 31                	je     800dfb <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  800dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  800dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  800dd6:	eb 16                	jmp    800dee <memcpy+0x66>
			*d8++ = *s8++;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ddb:	8d 50 01             	lea    0x1(%eax),%edx
  800dde:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de7:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  800dea:	8a 12                	mov    (%edx),%dl
  800dec:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	75 dd                	jne    800dd8 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e18:	73 50                	jae    800e6a <memmove+0x6a>
  800e1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e25:	76 43                	jbe    800e6a <memmove+0x6a>
		s += n;
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e33:	eb 10                	jmp    800e45 <memmove+0x45>
			*--d = *--s;
  800e35:	ff 4d f8             	decl   -0x8(%ebp)
  800e38:	ff 4d fc             	decl   -0x4(%ebp)
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3e:	8a 10                	mov    (%eax),%dl
  800e40:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e43:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	75 e3                	jne    800e35 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e52:	eb 23                	jmp    800e77 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e57:	8d 50 01             	lea    0x1(%eax),%edx
  800e5a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e60:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e63:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e66:	8a 12                	mov    (%edx),%dl
  800e68:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e70:	89 55 10             	mov    %edx,0x10(%ebp)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	75 dd                	jne    800e54 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8e:	eb 2a                	jmp    800eba <memcmp+0x3e>
		if (*s1 != *s2)
  800e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e93:	8a 10                	mov    (%eax),%dl
  800e95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	38 c2                	cmp    %al,%dl
  800e9c:	74 16                	je     800eb4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 d0             	movzbl %al,%edx
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 c0             	movzbl %al,%eax
  800eae:	29 c2                	sub    %eax,%edx
  800eb0:	89 d0                	mov    %edx,%eax
  800eb2:	eb 18                	jmp    800ecc <memcmp+0x50>
		s1++, s2++;
  800eb4:	ff 45 fc             	incl   -0x4(%ebp)
  800eb7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	75 c9                	jne    800e90 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecc:	c9                   	leave  
  800ecd:	c3                   	ret    

00800ece <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eda:	01 d0                	add    %edx,%eax
  800edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edf:	eb 15                	jmp    800ef6 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	8a 00                	mov    (%eax),%al
  800ee6:	0f b6 d0             	movzbl %al,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	0f b6 c0             	movzbl %al,%eax
  800eef:	39 c2                	cmp    %eax,%edx
  800ef1:	74 0d                	je     800f00 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef3:	ff 45 08             	incl   0x8(%ebp)
  800ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efc:	72 e3                	jb     800ee1 <memfind+0x13>
  800efe:	eb 01                	jmp    800f01 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f00:	90                   	nop
	return (void *) s;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1a:	eb 03                	jmp    800f1f <strtol+0x19>
		s++;
  800f1c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	3c 20                	cmp    $0x20,%al
  800f26:	74 f4                	je     800f1c <strtol+0x16>
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	3c 09                	cmp    $0x9,%al
  800f2f:	74 eb                	je     800f1c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 2b                	cmp    $0x2b,%al
  800f38:	75 05                	jne    800f3f <strtol+0x39>
		s++;
  800f3a:	ff 45 08             	incl   0x8(%ebp)
  800f3d:	eb 13                	jmp    800f52 <strtol+0x4c>
	else if (*s == '-')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 2d                	cmp    $0x2d,%al
  800f46:	75 0a                	jne    800f52 <strtol+0x4c>
		s++, neg = 1;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f56:	74 06                	je     800f5e <strtol+0x58>
  800f58:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5c:	75 20                	jne    800f7e <strtol+0x78>
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 30                	cmp    $0x30,%al
  800f65:	75 17                	jne    800f7e <strtol+0x78>
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	40                   	inc    %eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 78                	cmp    $0x78,%al
  800f6f:	75 0d                	jne    800f7e <strtol+0x78>
		s += 2, base = 16;
  800f71:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f75:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7c:	eb 28                	jmp    800fa6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f82:	75 15                	jne    800f99 <strtol+0x93>
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3c 30                	cmp    $0x30,%al
  800f8b:	75 0c                	jne    800f99 <strtol+0x93>
		s++, base = 8;
  800f8d:	ff 45 08             	incl   0x8(%ebp)
  800f90:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f97:	eb 0d                	jmp    800fa6 <strtol+0xa0>
	else if (base == 0)
  800f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9d:	75 07                	jne    800fa6 <strtol+0xa0>
		base = 10;
  800f9f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	3c 2f                	cmp    $0x2f,%al
  800fad:	7e 19                	jle    800fc8 <strtol+0xc2>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	3c 39                	cmp    $0x39,%al
  800fb6:	7f 10                	jg     800fc8 <strtol+0xc2>
			dig = *s - '0';
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f be c0             	movsbl %al,%eax
  800fc0:	83 e8 30             	sub    $0x30,%eax
  800fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc6:	eb 42                	jmp    80100a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3c 60                	cmp    $0x60,%al
  800fcf:	7e 19                	jle    800fea <strtol+0xe4>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 7a                	cmp    $0x7a,%al
  800fd8:	7f 10                	jg     800fea <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	0f be c0             	movsbl %al,%eax
  800fe2:	83 e8 57             	sub    $0x57,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe8:	eb 20                	jmp    80100a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	3c 40                	cmp    $0x40,%al
  800ff1:	7e 39                	jle    80102c <strtol+0x126>
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 5a                	cmp    $0x5a,%al
  800ffa:	7f 30                	jg     80102c <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f be c0             	movsbl %al,%eax
  801004:	83 e8 37             	sub    $0x37,%eax
  801007:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801010:	7d 19                	jge    80102b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801012:	ff 45 08             	incl   0x8(%ebp)
  801015:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801018:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801021:	01 d0                	add    %edx,%eax
  801023:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801026:	e9 7b ff ff ff       	jmp    800fa6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801030:	74 08                	je     80103a <strtol+0x134>
		*endptr = (char *) s;
  801032:	8b 45 0c             	mov    0xc(%ebp),%eax
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103e:	74 07                	je     801047 <strtol+0x141>
  801040:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801043:	f7 d8                	neg    %eax
  801045:	eb 03                	jmp    80104a <strtol+0x144>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104a:	c9                   	leave  
  80104b:	c3                   	ret    

0080104c <ltostr>:

void
ltostr(long value, char *str)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801052:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801059:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801064:	79 13                	jns    801079 <ltostr+0x2d>
	{
		neg = 1;
  801066:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801073:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801076:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801081:	99                   	cltd   
  801082:	f7 f9                	idiv   %ecx
  801084:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801087:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108a:	8d 50 01             	lea    0x1(%eax),%edx
  80108d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801090:	89 c2                	mov    %eax,%edx
  801092:	8b 45 0c             	mov    0xc(%ebp),%eax
  801095:	01 d0                	add    %edx,%eax
  801097:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109a:	83 c2 30             	add    $0x30,%edx
  80109d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a7:	f7 e9                	imul   %ecx
  8010a9:	c1 fa 02             	sar    $0x2,%edx
  8010ac:	89 c8                	mov    %ecx,%eax
  8010ae:	c1 f8 1f             	sar    $0x1f,%eax
  8010b1:	29 c2                	sub    %eax,%edx
  8010b3:	89 d0                	mov    %edx,%eax
  8010b5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bc:	75 bb                	jne    801079 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c8:	48                   	dec    %eax
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d0:	74 3d                	je     80110f <ltostr+0xc3>
		start = 1 ;
  8010d2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d9:	eb 34                	jmp    80110f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e1:	01 d0                	add    %edx,%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	01 c2                	add    %eax,%edx
  8010f0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 c8                	add    %ecx,%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801102:	01 c2                	add    %eax,%edx
  801104:	8a 45 eb             	mov    -0x15(%ebp),%al
  801107:	88 02                	mov    %al,(%edx)
		start++ ;
  801109:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801112:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801115:	7c c4                	jl     8010db <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801117:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801122:	90                   	nop
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	e8 c4 f9 ff ff       	call   800af7 <strlen>
  801133:	83 c4 04             	add    $0x4,%esp
  801136:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801139:	ff 75 0c             	pushl  0xc(%ebp)
  80113c:	e8 b6 f9 ff ff       	call   800af7 <strlen>
  801141:	83 c4 04             	add    $0x4,%esp
  801144:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801147:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801155:	eb 17                	jmp    80116e <strcconcat+0x49>
		final[s] = str1[s] ;
  801157:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115a:	8b 45 10             	mov    0x10(%ebp),%eax
  80115d:	01 c2                	add    %eax,%edx
  80115f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	01 c8                	add    %ecx,%eax
  801167:	8a 00                	mov    (%eax),%al
  801169:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
  80116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801171:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801174:	7c e1                	jl     801157 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801176:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801184:	eb 1f                	jmp    8011a5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118f:	89 c2                	mov    %eax,%edx
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	01 c2                	add    %eax,%edx
  801196:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119c:	01 c8                	add    %ecx,%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a2:	ff 45 f8             	incl   -0x8(%ebp)
  8011a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ab:	7c d9                	jl     801186 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	01 d0                	add    %edx,%eax
  8011b5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b8:	90                   	nop
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011be:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ca:	8b 00                	mov    (%eax),%eax
  8011cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011de:	eb 0c                	jmp    8011ec <strsplit+0x31>
			*string++ = 0;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8d 50 01             	lea    0x1(%eax),%edx
  8011e6:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e9:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	8a 00                	mov    (%eax),%al
  8011f1:	84 c0                	test   %al,%al
  8011f3:	74 18                	je     80120d <strsplit+0x52>
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	0f be c0             	movsbl %al,%eax
  8011fd:	50                   	push   %eax
  8011fe:	ff 75 0c             	pushl  0xc(%ebp)
  801201:	e8 83 fa ff ff       	call   800c89 <strchr>
  801206:	83 c4 08             	add    $0x8,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	75 d3                	jne    8011e0 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120d:	8b 45 08             	mov    0x8(%ebp),%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	84 c0                	test   %al,%al
  801214:	74 5a                	je     801270 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801216:	8b 45 14             	mov    0x14(%ebp),%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	83 f8 0f             	cmp    $0xf,%eax
  80121e:	75 07                	jne    801227 <strsplit+0x6c>
		{
			return 0;
  801220:	b8 00 00 00 00       	mov    $0x0,%eax
  801225:	eb 66                	jmp    80128d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801227:	8b 45 14             	mov    0x14(%ebp),%eax
  80122a:	8b 00                	mov    (%eax),%eax
  80122c:	8d 48 01             	lea    0x1(%eax),%ecx
  80122f:	8b 55 14             	mov    0x14(%ebp),%edx
  801232:	89 0a                	mov    %ecx,(%edx)
  801234:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 c2                	add    %eax,%edx
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801245:	eb 03                	jmp    80124a <strsplit+0x8f>
			string++;
  801247:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 8b                	je     8011de <strsplit+0x23>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	0f be c0             	movsbl %al,%eax
  80125b:	50                   	push   %eax
  80125c:	ff 75 0c             	pushl  0xc(%ebp)
  80125f:	e8 25 fa ff ff       	call   800c89 <strchr>
  801264:	83 c4 08             	add    $0x8,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	74 dc                	je     801247 <strsplit+0x8c>
			string++;
	}
  80126b:	e9 6e ff ff ff       	jmp    8011de <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801270:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801271:	8b 45 14             	mov    0x14(%ebp),%eax
  801274:	8b 00                	mov    (%eax),%eax
  801276:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127d:	8b 45 10             	mov    0x10(%ebp),%eax
  801280:	01 d0                	add    %edx,%eax
  801282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801288:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80129b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a2:	eb 4a                	jmp    8012ee <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8012a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b2:	01 c8                	add    %ecx,%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8012b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8a 00                	mov    (%eax),%al
  8012c2:	3c 40                	cmp    $0x40,%al
  8012c4:	7e 25                	jle    8012eb <str2lower+0x5c>
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	3c 5a                	cmp    $0x5a,%al
  8012d2:	7f 17                	jg     8012eb <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8012d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012da:	01 d0                	add    %edx,%eax
  8012dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012df:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e2:	01 ca                	add    %ecx,%edx
  8012e4:	8a 12                	mov    (%edx),%dl
  8012e6:	83 c2 20             	add    $0x20,%edx
  8012e9:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8012eb:	ff 45 fc             	incl   -0x4(%ebp)
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	e8 01 f8 ff ff       	call   800af7 <strlen>
  8012f6:	83 c4 04             	add    $0x4,%esp
  8012f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8012fc:	7f a6                	jg     8012a4 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8012fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	57                   	push   %edi
  801307:	56                   	push   %esi
  801308:	53                   	push   %ebx
  801309:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801312:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801315:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801318:	8b 7d 18             	mov    0x18(%ebp),%edi
  80131b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80131e:	cd 30                	int    $0x30
  801320:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801323:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	5b                   	pop    %ebx
  80132a:	5e                   	pop    %esi
  80132b:	5f                   	pop    %edi
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80133a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80133d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	6a 00                	push   $0x0
  801346:	51                   	push   %ecx
  801347:	52                   	push   %edx
  801348:	ff 75 0c             	pushl  0xc(%ebp)
  80134b:	50                   	push   %eax
  80134c:	6a 00                	push   $0x0
  80134e:	e8 b0 ff ff ff       	call   801303 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	90                   	nop
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_cgetc>:

int
sys_cgetc(void)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 02                	push   $0x2
  801368:	e8 96 ff ff ff       	call   801303 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 03                	push   $0x3
  801381:	e8 7d ff ff ff       	call   801303 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	90                   	nop
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 04                	push   $0x4
  80139b:	e8 63 ff ff ff       	call   801303 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	90                   	nop
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	52                   	push   %edx
  8013b6:	50                   	push   %eax
  8013b7:	6a 08                	push   $0x8
  8013b9:	e8 45 ff ff ff       	call   801303 <syscall>
  8013be:	83 c4 18             	add    $0x18,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8013cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	51                   	push   %ecx
  8013da:	52                   	push   %edx
  8013db:	50                   	push   %eax
  8013dc:	6a 09                	push   $0x9
  8013de:	e8 20 ff ff ff       	call   801303 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5e                   	pop    %esi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	6a 0a                	push   $0xa
  8013fd:	e8 01 ff ff ff       	call   801303 <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	ff 75 08             	pushl  0x8(%ebp)
  801416:	6a 0b                	push   $0xb
  801418:	e8 e6 fe ff ff       	call   801303 <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 0c                	push   $0xc
  801431:	e8 cd fe ff ff       	call   801303 <syscall>
  801436:	83 c4 18             	add    $0x18,%esp
}
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 0d                	push   $0xd
  80144a:	e8 b4 fe ff ff       	call   801303 <syscall>
  80144f:	83 c4 18             	add    $0x18,%esp
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 0e                	push   $0xe
  801463:	e8 9b fe ff ff       	call   801303 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 0f                	push   $0xf
  80147c:	e8 82 fe ff ff       	call   801303 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	ff 75 08             	pushl  0x8(%ebp)
  801494:	6a 10                	push   $0x10
  801496:	e8 68 fe ff ff       	call   801303 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 11                	push   $0x11
  8014af:	e8 4f fe ff ff       	call   801303 <syscall>
  8014b4:	83 c4 18             	add    $0x18,%esp
}
  8014b7:	90                   	nop
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <sys_cputc>:

void
sys_cputc(const char c)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	50                   	push   %eax
  8014d3:	6a 01                	push   $0x1
  8014d5:	e8 29 fe ff ff       	call   801303 <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	90                   	nop
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 14                	push   $0x14
  8014ef:	e8 0f fe ff ff       	call   801303 <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	90                   	nop
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	8b 45 10             	mov    0x10(%ebp),%eax
  801503:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801506:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801509:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	51                   	push   %ecx
  801513:	52                   	push   %edx
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	50                   	push   %eax
  801518:	6a 15                	push   $0x15
  80151a:	e8 e4 fd ff ff       	call   801303 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	52                   	push   %edx
  801534:	50                   	push   %eax
  801535:	6a 16                	push   $0x16
  801537:	e8 c7 fd ff ff       	call   801303 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801544:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	51                   	push   %ecx
  801552:	52                   	push   %edx
  801553:	50                   	push   %eax
  801554:	6a 17                	push   $0x17
  801556:	e8 a8 fd ff ff       	call   801303 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	6a 18                	push   $0x18
  801573:	e8 8b fd ff ff       	call   801303 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	6a 00                	push   $0x0
  801585:	ff 75 14             	pushl  0x14(%ebp)
  801588:	ff 75 10             	pushl  0x10(%ebp)
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	50                   	push   %eax
  80158f:	6a 19                	push   $0x19
  801591:	e8 6d fd ff ff       	call   801303 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	50                   	push   %eax
  8015aa:	6a 1a                	push   $0x1a
  8015ac:	e8 52 fd ff ff       	call   801303 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	90                   	nop
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	50                   	push   %eax
  8015c6:	6a 1b                	push   $0x1b
  8015c8:	e8 36 fd ff ff       	call   801303 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 05                	push   $0x5
  8015e1:	e8 1d fd ff ff       	call   801303 <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 06                	push   $0x6
  8015fa:	e8 04 fd ff ff       	call   801303 <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 07                	push   $0x7
  801613:	e8 eb fc ff ff       	call   801303 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_exit_env>:


void sys_exit_env(void)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 1c                	push   $0x1c
  80162c:	e8 d2 fc ff ff       	call   801303 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80163d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801640:	8d 50 04             	lea    0x4(%eax),%edx
  801643:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	52                   	push   %edx
  80164d:	50                   	push   %eax
  80164e:	6a 1d                	push   $0x1d
  801650:	e8 ae fc ff ff       	call   801303 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
	return result;
  801658:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801661:	89 01                	mov    %eax,(%ecx)
  801663:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	c9                   	leave  
  80166a:	c2 04 00             	ret    $0x4

0080166d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	ff 75 10             	pushl  0x10(%ebp)
  801677:	ff 75 0c             	pushl  0xc(%ebp)
  80167a:	ff 75 08             	pushl  0x8(%ebp)
  80167d:	6a 13                	push   $0x13
  80167f:	e8 7f fc ff ff       	call   801303 <syscall>
  801684:	83 c4 18             	add    $0x18,%esp
	return ;
  801687:	90                   	nop
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_rcr2>:
uint32 sys_rcr2()
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 1e                	push   $0x1e
  801699:	e8 65 fc ff ff       	call   801303 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016af:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	50                   	push   %eax
  8016bc:	6a 1f                	push   $0x1f
  8016be:	e8 40 fc ff ff       	call   801303 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c6:	90                   	nop
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <rsttst>:
void rsttst()
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 21                	push   $0x21
  8016d8:	e8 26 fc ff ff       	call   801303 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e0:	90                   	nop
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 04             	sub    $0x4,%esp
  8016e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ef:	8b 55 18             	mov    0x18(%ebp),%edx
  8016f2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	ff 75 10             	pushl  0x10(%ebp)
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	6a 20                	push   $0x20
  801703:	e8 fb fb ff ff       	call   801303 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return ;
  80170b:	90                   	nop
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <chktst>:
void chktst(uint32 n)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	6a 22                	push   $0x22
  80171e:	e8 e0 fb ff ff       	call   801303 <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
	return ;
  801726:	90                   	nop
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <inctst>:

void inctst()
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 23                	push   $0x23
  801738:	e8 c6 fb ff ff       	call   801303 <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
	return ;
  801740:	90                   	nop
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <gettst>:
uint32 gettst()
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 24                	push   $0x24
  801752:	e8 ac fb ff ff       	call   801303 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 25                	push   $0x25
  80176b:	e8 93 fb ff ff       	call   801303 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
  801773:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801778:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 26                	push   $0x26
  801797:	e8 67 fb ff ff       	call   801303 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
	return ;
  80179f:	90                   	nop
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	6a 00                	push   $0x0
  8017b4:	53                   	push   %ebx
  8017b5:	51                   	push   %ecx
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	6a 27                	push   $0x27
  8017ba:	e8 44 fb ff ff       	call   801303 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 28                	push   $0x28
  8017da:	e8 24 fb ff ff       	call   801303 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017e7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	51                   	push   %ecx
  8017f3:	ff 75 10             	pushl  0x10(%ebp)
  8017f6:	52                   	push   %edx
  8017f7:	50                   	push   %eax
  8017f8:	6a 29                	push   $0x29
  8017fa:	e8 04 fb ff ff       	call   801303 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	6a 12                	push   $0x12
  801816:	e8 e8 fa ff ff       	call   801303 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
	return ;
  80181e:	90                   	nop
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	6a 2a                	push   $0x2a
  801834:	e8 ca fa ff ff       	call   801303 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
	return;
  80183c:	90                   	nop
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 2b                	push   $0x2b
  80184e:	e8 b0 fa ff ff       	call   801303 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	6a 2d                	push   $0x2d
  801869:	e8 95 fa ff ff       	call   801303 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
	return;
  801871:	90                   	nop
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	6a 2c                	push   $0x2c
  801885:	e8 79 fa ff ff       	call   801303 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
	return ;
  80188d:	90                   	nop
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 08 23 80 00       	push   $0x802308
  80189e:	68 25 01 00 00       	push   $0x125
  8018a3:	68 3b 23 80 00       	push   $0x80233b
  8018a8:	e8 00 00 00 00       	call   8018ad <_panic>

008018ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8018b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8018b6:	83 c0 04             	add    $0x4,%eax
  8018b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8018bc:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	74 16                	je     8018db <_panic+0x2e>
		cprintf("%s: ", argv0);
  8018c5:	a1 1c b1 81 00       	mov    0x81b11c,%eax
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	50                   	push   %eax
  8018ce:	68 4c 23 80 00       	push   $0x80234c
  8018d3:	e8 46 eb ff ff       	call   80041e <cprintf>
  8018d8:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8018db:	a1 04 30 80 00       	mov    0x803004,%eax
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	50                   	push   %eax
  8018ea:	68 54 23 80 00       	push   $0x802354
  8018ef:	6a 74                	push   $0x74
  8018f1:	e8 55 eb ff ff       	call   80044b <cprintf_colored>
  8018f6:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8018f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fc:	83 ec 08             	sub    $0x8,%esp
  8018ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801902:	50                   	push   %eax
  801903:	e8 a7 ea ff ff       	call   8003af <vcprintf>
  801908:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	6a 00                	push   $0x0
  801910:	68 7c 23 80 00       	push   $0x80237c
  801915:	e8 95 ea ff ff       	call   8003af <vcprintf>
  80191a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80191d:	e8 0e ea ff ff       	call   800330 <exit>

	// should not return here
	while (1) ;
  801922:	eb fe                	jmp    801922 <_panic+0x75>

00801924 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80192a:	a1 20 30 80 00       	mov    0x803020,%eax
  80192f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801935:	8b 45 0c             	mov    0xc(%ebp),%eax
  801938:	39 c2                	cmp    %eax,%edx
  80193a:	74 14                	je     801950 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 80 23 80 00       	push   $0x802380
  801944:	6a 26                	push   $0x26
  801946:	68 cc 23 80 00       	push   $0x8023cc
  80194b:	e8 5d ff ff ff       	call   8018ad <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801950:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801957:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80195e:	e9 c5 00 00 00       	jmp    801a28 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801966:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	01 d0                	add    %edx,%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	85 c0                	test   %eax,%eax
  801976:	75 08                	jne    801980 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801978:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80197b:	e9 a5 00 00 00       	jmp    801a25 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801980:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801987:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80198e:	eb 69                	jmp    8019f9 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801990:	a1 20 30 80 00       	mov    0x803020,%eax
  801995:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80199b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80199e:	89 d0                	mov    %edx,%eax
  8019a0:	01 c0                	add    %eax,%eax
  8019a2:	01 d0                	add    %edx,%eax
  8019a4:	c1 e0 03             	shl    $0x3,%eax
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	8a 40 04             	mov    0x4(%eax),%al
  8019ac:	84 c0                	test   %al,%al
  8019ae:	75 46                	jne    8019f6 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8019b5:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019be:	89 d0                	mov    %edx,%eax
  8019c0:	01 c0                	add    %eax,%eax
  8019c2:	01 d0                	add    %edx,%eax
  8019c4:	c1 e0 03             	shl    $0x3,%eax
  8019c7:	01 c8                	add    %ecx,%eax
  8019c9:	8b 00                	mov    (%eax),%eax
  8019cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8019ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	01 c8                	add    %ecx,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8019e9:	39 c2                	cmp    %eax,%edx
  8019eb:	75 09                	jne    8019f6 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8019ed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8019f4:	eb 15                	jmp    801a0b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019f6:	ff 45 e8             	incl   -0x18(%ebp)
  8019f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8019fe:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a07:	39 c2                	cmp    %eax,%edx
  801a09:	77 85                	ja     801990 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a0f:	75 14                	jne    801a25 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	68 d8 23 80 00       	push   $0x8023d8
  801a19:	6a 3a                	push   $0x3a
  801a1b:	68 cc 23 80 00       	push   $0x8023cc
  801a20:	e8 88 fe ff ff       	call   8018ad <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a25:	ff 45 f0             	incl   -0x10(%ebp)
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801a2e:	0f 8c 2f ff ff ff    	jl     801963 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801a34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a42:	eb 26                	jmp    801a6a <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801a44:	a1 20 30 80 00       	mov    0x803020,%eax
  801a49:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a52:	89 d0                	mov    %edx,%eax
  801a54:	01 c0                	add    %eax,%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c1 e0 03             	shl    $0x3,%eax
  801a5b:	01 c8                	add    %ecx,%eax
  801a5d:	8a 40 04             	mov    0x4(%eax),%al
  801a60:	3c 01                	cmp    $0x1,%al
  801a62:	75 03                	jne    801a67 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a64:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a67:	ff 45 e0             	incl   -0x20(%ebp)
  801a6a:	a1 20 30 80 00       	mov    0x803020,%eax
  801a6f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	77 c8                	ja     801a44 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a82:	74 14                	je     801a98 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	68 2c 24 80 00       	push   $0x80242c
  801a8c:	6a 44                	push   $0x44
  801a8e:	68 cc 23 80 00       	push   $0x8023cc
  801a93:	e8 15 fe ff ff       	call   8018ad <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a98:	90                   	nop
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    
  801a9b:	90                   	nop

00801a9c <__udivdi3>:
  801a9c:	55                   	push   %ebp
  801a9d:	57                   	push   %edi
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 1c             	sub    $0x1c,%esp
  801aa3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801aa7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aaf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ab3:	89 ca                	mov    %ecx,%edx
  801ab5:	89 f8                	mov    %edi,%eax
  801ab7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801abb:	85 f6                	test   %esi,%esi
  801abd:	75 2d                	jne    801aec <__udivdi3+0x50>
  801abf:	39 cf                	cmp    %ecx,%edi
  801ac1:	77 65                	ja     801b28 <__udivdi3+0x8c>
  801ac3:	89 fd                	mov    %edi,%ebp
  801ac5:	85 ff                	test   %edi,%edi
  801ac7:	75 0b                	jne    801ad4 <__udivdi3+0x38>
  801ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	f7 f7                	div    %edi
  801ad2:	89 c5                	mov    %eax,%ebp
  801ad4:	31 d2                	xor    %edx,%edx
  801ad6:	89 c8                	mov    %ecx,%eax
  801ad8:	f7 f5                	div    %ebp
  801ada:	89 c1                	mov    %eax,%ecx
  801adc:	89 d8                	mov    %ebx,%eax
  801ade:	f7 f5                	div    %ebp
  801ae0:	89 cf                	mov    %ecx,%edi
  801ae2:	89 fa                	mov    %edi,%edx
  801ae4:	83 c4 1c             	add    $0x1c,%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5f                   	pop    %edi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    
  801aec:	39 ce                	cmp    %ecx,%esi
  801aee:	77 28                	ja     801b18 <__udivdi3+0x7c>
  801af0:	0f bd fe             	bsr    %esi,%edi
  801af3:	83 f7 1f             	xor    $0x1f,%edi
  801af6:	75 40                	jne    801b38 <__udivdi3+0x9c>
  801af8:	39 ce                	cmp    %ecx,%esi
  801afa:	72 0a                	jb     801b06 <__udivdi3+0x6a>
  801afc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b00:	0f 87 9e 00 00 00    	ja     801ba4 <__udivdi3+0x108>
  801b06:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0b:	89 fa                	mov    %edi,%edx
  801b0d:	83 c4 1c             	add    $0x1c,%esp
  801b10:	5b                   	pop    %ebx
  801b11:	5e                   	pop    %esi
  801b12:	5f                   	pop    %edi
  801b13:	5d                   	pop    %ebp
  801b14:	c3                   	ret    
  801b15:	8d 76 00             	lea    0x0(%esi),%esi
  801b18:	31 ff                	xor    %edi,%edi
  801b1a:	31 c0                	xor    %eax,%eax
  801b1c:	89 fa                	mov    %edi,%edx
  801b1e:	83 c4 1c             	add    $0x1c,%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    
  801b26:	66 90                	xchg   %ax,%ax
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	f7 f7                	div    %edi
  801b2c:	31 ff                	xor    %edi,%edi
  801b2e:	89 fa                	mov    %edi,%edx
  801b30:	83 c4 1c             	add    $0x1c,%esp
  801b33:	5b                   	pop    %ebx
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
  801b38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b3d:	89 eb                	mov    %ebp,%ebx
  801b3f:	29 fb                	sub    %edi,%ebx
  801b41:	89 f9                	mov    %edi,%ecx
  801b43:	d3 e6                	shl    %cl,%esi
  801b45:	89 c5                	mov    %eax,%ebp
  801b47:	88 d9                	mov    %bl,%cl
  801b49:	d3 ed                	shr    %cl,%ebp
  801b4b:	89 e9                	mov    %ebp,%ecx
  801b4d:	09 f1                	or     %esi,%ecx
  801b4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b53:	89 f9                	mov    %edi,%ecx
  801b55:	d3 e0                	shl    %cl,%eax
  801b57:	89 c5                	mov    %eax,%ebp
  801b59:	89 d6                	mov    %edx,%esi
  801b5b:	88 d9                	mov    %bl,%cl
  801b5d:	d3 ee                	shr    %cl,%esi
  801b5f:	89 f9                	mov    %edi,%ecx
  801b61:	d3 e2                	shl    %cl,%edx
  801b63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b67:	88 d9                	mov    %bl,%cl
  801b69:	d3 e8                	shr    %cl,%eax
  801b6b:	09 c2                	or     %eax,%edx
  801b6d:	89 d0                	mov    %edx,%eax
  801b6f:	89 f2                	mov    %esi,%edx
  801b71:	f7 74 24 0c          	divl   0xc(%esp)
  801b75:	89 d6                	mov    %edx,%esi
  801b77:	89 c3                	mov    %eax,%ebx
  801b79:	f7 e5                	mul    %ebp
  801b7b:	39 d6                	cmp    %edx,%esi
  801b7d:	72 19                	jb     801b98 <__udivdi3+0xfc>
  801b7f:	74 0b                	je     801b8c <__udivdi3+0xf0>
  801b81:	89 d8                	mov    %ebx,%eax
  801b83:	31 ff                	xor    %edi,%edi
  801b85:	e9 58 ff ff ff       	jmp    801ae2 <__udivdi3+0x46>
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b90:	89 f9                	mov    %edi,%ecx
  801b92:	d3 e2                	shl    %cl,%edx
  801b94:	39 c2                	cmp    %eax,%edx
  801b96:	73 e9                	jae    801b81 <__udivdi3+0xe5>
  801b98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b9b:	31 ff                	xor    %edi,%edi
  801b9d:	e9 40 ff ff ff       	jmp    801ae2 <__udivdi3+0x46>
  801ba2:	66 90                	xchg   %ax,%ax
  801ba4:	31 c0                	xor    %eax,%eax
  801ba6:	e9 37 ff ff ff       	jmp    801ae2 <__udivdi3+0x46>
  801bab:	90                   	nop

00801bac <__umoddi3>:
  801bac:	55                   	push   %ebp
  801bad:	57                   	push   %edi
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
  801bb3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801bb7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bcb:	89 f3                	mov    %esi,%ebx
  801bcd:	89 fa                	mov    %edi,%edx
  801bcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd3:	89 34 24             	mov    %esi,(%esp)
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	75 1a                	jne    801bf4 <__umoddi3+0x48>
  801bda:	39 f7                	cmp    %esi,%edi
  801bdc:	0f 86 a2 00 00 00    	jbe    801c84 <__umoddi3+0xd8>
  801be2:	89 c8                	mov    %ecx,%eax
  801be4:	89 f2                	mov    %esi,%edx
  801be6:	f7 f7                	div    %edi
  801be8:	89 d0                	mov    %edx,%eax
  801bea:	31 d2                	xor    %edx,%edx
  801bec:	83 c4 1c             	add    $0x1c,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5f                   	pop    %edi
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    
  801bf4:	39 f0                	cmp    %esi,%eax
  801bf6:	0f 87 ac 00 00 00    	ja     801ca8 <__umoddi3+0xfc>
  801bfc:	0f bd e8             	bsr    %eax,%ebp
  801bff:	83 f5 1f             	xor    $0x1f,%ebp
  801c02:	0f 84 ac 00 00 00    	je     801cb4 <__umoddi3+0x108>
  801c08:	bf 20 00 00 00       	mov    $0x20,%edi
  801c0d:	29 ef                	sub    %ebp,%edi
  801c0f:	89 fe                	mov    %edi,%esi
  801c11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c15:	89 e9                	mov    %ebp,%ecx
  801c17:	d3 e0                	shl    %cl,%eax
  801c19:	89 d7                	mov    %edx,%edi
  801c1b:	89 f1                	mov    %esi,%ecx
  801c1d:	d3 ef                	shr    %cl,%edi
  801c1f:	09 c7                	or     %eax,%edi
  801c21:	89 e9                	mov    %ebp,%ecx
  801c23:	d3 e2                	shl    %cl,%edx
  801c25:	89 14 24             	mov    %edx,(%esp)
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	d3 e0                	shl    %cl,%eax
  801c2c:	89 c2                	mov    %eax,%edx
  801c2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c32:	d3 e0                	shl    %cl,%eax
  801c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3c:	89 f1                	mov    %esi,%ecx
  801c3e:	d3 e8                	shr    %cl,%eax
  801c40:	09 d0                	or     %edx,%eax
  801c42:	d3 eb                	shr    %cl,%ebx
  801c44:	89 da                	mov    %ebx,%edx
  801c46:	f7 f7                	div    %edi
  801c48:	89 d3                	mov    %edx,%ebx
  801c4a:	f7 24 24             	mull   (%esp)
  801c4d:	89 c6                	mov    %eax,%esi
  801c4f:	89 d1                	mov    %edx,%ecx
  801c51:	39 d3                	cmp    %edx,%ebx
  801c53:	0f 82 87 00 00 00    	jb     801ce0 <__umoddi3+0x134>
  801c59:	0f 84 91 00 00 00    	je     801cf0 <__umoddi3+0x144>
  801c5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c63:	29 f2                	sub    %esi,%edx
  801c65:	19 cb                	sbb    %ecx,%ebx
  801c67:	89 d8                	mov    %ebx,%eax
  801c69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c6d:	d3 e0                	shl    %cl,%eax
  801c6f:	89 e9                	mov    %ebp,%ecx
  801c71:	d3 ea                	shr    %cl,%edx
  801c73:	09 d0                	or     %edx,%eax
  801c75:	89 e9                	mov    %ebp,%ecx
  801c77:	d3 eb                	shr    %cl,%ebx
  801c79:	89 da                	mov    %ebx,%edx
  801c7b:	83 c4 1c             	add    $0x1c,%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5e                   	pop    %esi
  801c80:	5f                   	pop    %edi
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    
  801c83:	90                   	nop
  801c84:	89 fd                	mov    %edi,%ebp
  801c86:	85 ff                	test   %edi,%edi
  801c88:	75 0b                	jne    801c95 <__umoddi3+0xe9>
  801c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8f:	31 d2                	xor    %edx,%edx
  801c91:	f7 f7                	div    %edi
  801c93:	89 c5                	mov    %eax,%ebp
  801c95:	89 f0                	mov    %esi,%eax
  801c97:	31 d2                	xor    %edx,%edx
  801c99:	f7 f5                	div    %ebp
  801c9b:	89 c8                	mov    %ecx,%eax
  801c9d:	f7 f5                	div    %ebp
  801c9f:	89 d0                	mov    %edx,%eax
  801ca1:	e9 44 ff ff ff       	jmp    801bea <__umoddi3+0x3e>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	89 c8                	mov    %ecx,%eax
  801caa:	89 f2                	mov    %esi,%edx
  801cac:	83 c4 1c             	add    $0x1c,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5f                   	pop    %edi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
  801cb4:	3b 04 24             	cmp    (%esp),%eax
  801cb7:	72 06                	jb     801cbf <__umoddi3+0x113>
  801cb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cbd:	77 0f                	ja     801cce <__umoddi3+0x122>
  801cbf:	89 f2                	mov    %esi,%edx
  801cc1:	29 f9                	sub    %edi,%ecx
  801cc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cc7:	89 14 24             	mov    %edx,(%esp)
  801cca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cce:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cd2:	8b 14 24             	mov    (%esp),%edx
  801cd5:	83 c4 1c             	add    $0x1c,%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5f                   	pop    %edi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    
  801cdd:	8d 76 00             	lea    0x0(%esi),%esi
  801ce0:	2b 04 24             	sub    (%esp),%eax
  801ce3:	19 fa                	sbb    %edi,%edx
  801ce5:	89 d1                	mov    %edx,%ecx
  801ce7:	89 c6                	mov    %eax,%esi
  801ce9:	e9 71 ff ff ff       	jmp    801c5f <__umoddi3+0xb3>
  801cee:	66 90                	xchg   %ax,%ax
  801cf0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cf4:	72 ea                	jb     801ce0 <__umoddi3+0x134>
  801cf6:	89 d9                	mov    %ebx,%ecx
  801cf8:	e9 62 ff ff ff       	jmp    801c5f <__umoddi3+0xb3>
