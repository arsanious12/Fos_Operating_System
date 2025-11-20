
obj/user/tst_ksemaphore_1slave:     file format elf32-i386


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
  800031:	e8 f4 01 00 00       	call   80022a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
extern volatile bool printStats ;

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 5a 18 00 00       	call   8018a3 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int id = sys_getenvindex();
  80004c:	e8 39 18 00 00       	call   80188a <sys_getenvindex>
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)

	cprintf_colored(TEXT_light_blue, "%d: before the critical section\n", id);
  800054:	83 ec 04             	sub    $0x4,%esp
  800057:	ff 75 e0             	pushl  -0x20(%ebp)
  80005a:	68 80 1e 80 00       	push   $0x801e80
  80005f:	6a 09                	push   $0x9
  800061:	e8 84 06 00 00       	call   8006ea <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	//wait_semaphore(cs1);
	char waitCmd[64] = "__KSem@0@Wait";
  800069:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006c:	bb aa 1f 80 00       	mov    $0x801faa,%ebx
  800071:	ba 0e 00 00 00       	mov    $0xe,%edx
  800076:	89 c7                	mov    %eax,%edi
  800078:	89 de                	mov    %ebx,%esi
  80007a:	89 d1                	mov    %edx,%ecx
  80007c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80007e:	8d 55 a6             	lea    -0x5a(%ebp),%edx
  800081:	b9 32 00 00 00       	mov    $0x32,%ecx
  800086:	b0 00                	mov    $0x0,%al
  800088:	89 d7                	mov    %edx,%edi
  80008a:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd, 0);
  80008c:	83 ec 08             	sub    $0x8,%esp
  80008f:	6a 00                	push   $0x0
  800091:	8d 45 98             	lea    -0x68(%ebp),%eax
  800094:	50                   	push   %eax
  800095:	e8 26 1a 00 00       	call   801ac0 <sys_utilities>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf_colored(TEXT_light_cyan, "%d: inside the critical section\n", id) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000a3:	68 a4 1e 80 00       	push   $0x801ea4
  8000a8:	6a 0b                	push   $0xb
  8000aa:	e8 3b 06 00 00       	call   8006ea <cprintf_colored>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_cyan, "my ID is %d\n", id);
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000b8:	68 c5 1e 80 00       	push   $0x801ec5
  8000bd:	6a 0b                	push   $0xb
  8000bf:	e8 26 06 00 00       	call   8006ea <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
		int sem1val ;
		char getCmd[64] = "__KSem@0@Get";
  8000c7:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000cd:	bb ea 1f 80 00       	mov    $0x801fea,%ebx
  8000d2:	ba 0d 00 00 00       	mov    $0xd,%edx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 de                	mov    %ebx,%esi
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8000df:	8d 95 e1 fe ff ff    	lea    -0x11f(%ebp),%edx
  8000e5:	b9 33 00 00 00       	mov    $0x33,%ecx
  8000ea:	b0 00                	mov    $0x0,%al
  8000ec:	89 d7                	mov    %edx,%edi
  8000ee:	f3 aa                	rep stos %al,%es:(%edi)
		sys_utilities(getCmd, (uint32)(&sem1val));
  8000f0:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	50                   	push   %eax
  8000fa:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  800100:	50                   	push   %eax
  800101:	e8 ba 19 00 00       	call   801ac0 <sys_utilities>
  800106:	83 c4 10             	add    $0x10,%esp
		if (sem1val > 0)
  800109:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80010f:	85 c0                	test   %eax,%eax
  800111:	7e 14                	jle    800127 <_main+0xef>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 d4 1e 80 00       	push   $0x801ed4
  80011b:	6a 17                	push   $0x17
  80011d:	68 2b 1f 80 00       	push   $0x801f2b
  800122:	e8 c8 02 00 00       	call   8003ef <_panic>
		env_sleep(RAND(1000, 5000)) ;
  800127:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	50                   	push   %eax
  80012e:	e8 a3 17 00 00       	call   8018d6 <sys_get_virtual_time>
  800133:	83 c4 0c             	add    $0xc,%esp
  800136:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800139:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	f7 f1                	div    %ecx
  800145:	89 d0                	mov    %edx,%eax
  800147:	05 e8 03 00 00       	add    $0x3e8,%eax
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	50                   	push   %eax
  800150:	e8 f7 19 00 00       	call   801b4c <env_sleep>
  800155:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_blue, "%d: leaving the critical section...\n", id);
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	ff 75 e0             	pushl  -0x20(%ebp)
  80015e:	68 48 1f 80 00       	push   $0x801f48
  800163:	6a 09                	push   $0x9
  800165:	e8 80 05 00 00       	call   8006ea <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	}
	char signalCmd1[64] = "__KSem@0@Signal";
  80016d:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800173:	bb 2a 20 80 00       	mov    $0x80202a,%ebx
  800178:	ba 04 00 00 00       	mov    $0x4,%edx
  80017d:	89 c7                	mov    %eax,%edi
  80017f:	89 de                	mov    %ebx,%esi
  800181:	89 d1                	mov    %edx,%ecx
  800183:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800185:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  80018b:	b9 0c 00 00 00       	mov    $0xc,%ecx
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	89 d7                	mov    %edx,%edi
  800197:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd1, 0);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	6a 00                	push   $0x0
  80019e:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 16 19 00 00       	call   801ac0 <sys_utilities>
  8001aa:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(cs1);
	cprintf_colored(TEXT_light_blue, "%d: after the critical section\n", id);
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b3:	68 70 1f 80 00       	push   $0x801f70
  8001b8:	6a 09                	push   $0x9
  8001ba:	e8 2b 05 00 00       	call   8006ea <cprintf_colored>
  8001bf:	83 c4 10             	add    $0x10,%esp

	//signal_semaphore(depend1);
	char signalCmd2[64] = "__KSem@1@Signal";
  8001c2:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8001c8:	bb 6a 20 80 00       	mov    $0x80206a,%ebx
  8001cd:	ba 04 00 00 00       	mov    $0x4,%edx
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 de                	mov    %ebx,%esi
  8001d6:	89 d1                	mov    %edx,%ecx
  8001d8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8001da:	8d 95 28 ff ff ff    	lea    -0xd8(%ebp),%edx
  8001e0:	b9 0c 00 00 00       	mov    $0xc,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	sys_utilities(signalCmd2, 0);
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	6a 00                	push   $0x0
  8001f3:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	e8 c1 18 00 00       	call   801ac0 <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", id);
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	ff 75 e0             	pushl  -0x20(%ebp)
  800208:	68 90 1f 80 00       	push   $0x801f90
  80020d:	6a 0d                	push   $0xd
  80020f:	e8 d6 04 00 00       	call   8006ea <cprintf_colored>
  800214:	83 c4 10             	add    $0x10,%esp
	printStats = 0;
  800217:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80021e:	00 00 00 

	return;
  800221:	90                   	nop
}
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80022a:	55                   	push   %ebp
  80022b:	89 e5                	mov    %esp,%ebp
  80022d:	57                   	push   %edi
  80022e:	56                   	push   %esi
  80022f:	53                   	push   %ebx
  800230:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800233:	e8 52 16 00 00       	call   80188a <sys_getenvindex>
  800238:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80023b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80023e:	89 d0                	mov    %edx,%eax
  800240:	c1 e0 06             	shl    $0x6,%eax
  800243:	29 d0                	sub    %edx,%eax
  800245:	c1 e0 02             	shl    $0x2,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800251:	01 c8                	add    %ecx,%eax
  800253:	c1 e0 03             	shl    $0x3,%eax
  800256:	01 d0                	add    %edx,%eax
  800258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80025f:	29 c2                	sub    %eax,%edx
  800261:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800268:	89 c2                	mov    %eax,%edx
  80026a:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800270:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	8a 40 20             	mov    0x20(%eax),%al
  80027d:	84 c0                	test   %al,%al
  80027f:	74 0d                	je     80028e <libmain+0x64>
		binaryname = myEnv->prog_name;
  800281:	a1 20 30 80 00       	mov    0x803020,%eax
  800286:	83 c0 20             	add    $0x20,%eax
  800289:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800292:	7e 0a                	jle    80029e <libmain+0x74>
		binaryname = argv[0];
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	8b 00                	mov    (%eax),%eax
  800299:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	ff 75 0c             	pushl  0xc(%ebp)
  8002a4:	ff 75 08             	pushl  0x8(%ebp)
  8002a7:	e8 8c fd ff ff       	call   800038 <_main>
  8002ac:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002af:	a1 00 30 80 00       	mov    0x803000,%eax
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	0f 84 01 01 00 00    	je     8003bd <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002bc:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002c2:	bb a4 21 80 00       	mov    $0x8021a4,%ebx
  8002c7:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002cc:	89 c7                	mov    %eax,%edi
  8002ce:	89 de                	mov    %ebx,%esi
  8002d0:	89 d1                	mov    %edx,%ecx
  8002d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002d4:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002d7:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002dc:	b0 00                	mov    $0x0,%al
  8002de:	89 d7                	mov    %edx,%edi
  8002e0:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002ec:	83 ec 08             	sub    $0x8,%esp
  8002ef:	50                   	push   %eax
  8002f0:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002f6:	50                   	push   %eax
  8002f7:	e8 c4 17 00 00       	call   801ac0 <sys_utilities>
  8002fc:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002ff:	e8 0d 13 00 00       	call   801611 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 c4 20 80 00       	push   $0x8020c4
  80030c:	e8 ac 03 00 00       	call   8006bd <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800317:	85 c0                	test   %eax,%eax
  800319:	74 18                	je     800333 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80031b:	e8 be 17 00 00       	call   801ade <sys_get_optimal_num_faults>
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	50                   	push   %eax
  800324:	68 ec 20 80 00       	push   $0x8020ec
  800329:	e8 8f 03 00 00       	call   8006bd <cprintf>
  80032e:	83 c4 10             	add    $0x10,%esp
  800331:	eb 59                	jmp    80038c <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800333:	a1 20 30 80 00       	mov    0x803020,%eax
  800338:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80033e:	a1 20 30 80 00       	mov    0x803020,%eax
  800343:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	52                   	push   %edx
  80034d:	50                   	push   %eax
  80034e:	68 10 21 80 00       	push   $0x802110
  800353:	e8 65 03 00 00       	call   8006bd <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80035b:	a1 20 30 80 00       	mov    0x803020,%eax
  800360:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800371:	a1 20 30 80 00       	mov    0x803020,%eax
  800376:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80037c:	51                   	push   %ecx
  80037d:	52                   	push   %edx
  80037e:	50                   	push   %eax
  80037f:	68 38 21 80 00       	push   $0x802138
  800384:	e8 34 03 00 00       	call   8006bd <cprintf>
  800389:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	50                   	push   %eax
  80039b:	68 90 21 80 00       	push   $0x802190
  8003a0:	e8 18 03 00 00       	call   8006bd <cprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 c4 20 80 00       	push   $0x8020c4
  8003b0:	e8 08 03 00 00       	call   8006bd <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003b8:	e8 6e 12 00 00       	call   80162b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003bd:	e8 1f 00 00 00       	call   8003e1 <exit>
}
  8003c2:	90                   	nop
  8003c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    

008003cb <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	6a 00                	push   $0x0
  8003d6:	e8 7b 14 00 00       	call   801856 <sys_destroy_env>
  8003db:	83 c4 10             	add    $0x10,%esp
}
  8003de:	90                   	nop
  8003df:	c9                   	leave  
  8003e0:	c3                   	ret    

008003e1 <exit>:

void
exit(void)
{
  8003e1:	55                   	push   %ebp
  8003e2:	89 e5                	mov    %esp,%ebp
  8003e4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003e7:	e8 d0 14 00 00       	call   8018bc <sys_exit_env>
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003f5:	8d 45 10             	lea    0x10(%ebp),%eax
  8003f8:	83 c0 04             	add    $0x4,%eax
  8003fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003fe:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	74 16                	je     80041d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800407:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	50                   	push   %eax
  800410:	68 08 22 80 00       	push   $0x802208
  800415:	e8 a3 02 00 00       	call   8006bd <cprintf>
  80041a:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80041d:	a1 04 30 80 00       	mov    0x803004,%eax
  800422:	83 ec 0c             	sub    $0xc,%esp
  800425:	ff 75 0c             	pushl  0xc(%ebp)
  800428:	ff 75 08             	pushl  0x8(%ebp)
  80042b:	50                   	push   %eax
  80042c:	68 10 22 80 00       	push   $0x802210
  800431:	6a 74                	push   $0x74
  800433:	e8 b2 02 00 00       	call   8006ea <cprintf_colored>
  800438:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 04 02 00 00       	call   80064e <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 38 22 80 00       	push   $0x802238
  800457:	e8 f2 01 00 00       	call   80064e <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 7d ff ff ff       	call   8003e1 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x75>

00800466 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	74 14                	je     800492 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	68 3c 22 80 00       	push   $0x80223c
  800486:	6a 26                	push   $0x26
  800488:	68 88 22 80 00       	push   $0x802288
  80048d:	e8 5d ff ff ff       	call   8003ef <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800499:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a0:	e9 c5 00 00 00       	jmp    80056a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	75 08                	jne    8004c2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004ba:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004bd:	e9 a5 00 00 00       	jmp    800567 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d0:	eb 69                	jmp    80053b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e0:	89 d0                	mov    %edx,%eax
  8004e2:	01 c0                	add    %eax,%eax
  8004e4:	01 d0                	add    %edx,%eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	01 c8                	add    %ecx,%eax
  8004eb:	8a 40 04             	mov    0x4(%eax),%al
  8004ee:	84 c0                	test   %al,%al
  8004f0:	75 46                	jne    800538 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f7:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800500:	89 d0                	mov    %edx,%eax
  800502:	01 c0                	add    %eax,%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	c1 e0 03             	shl    $0x3,%eax
  800509:	01 c8                	add    %ecx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800518:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	01 c8                	add    %ecx,%eax
  800529:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80052b:	39 c2                	cmp    %eax,%edx
  80052d:	75 09                	jne    800538 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80052f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800536:	eb 15                	jmp    80054d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800538:	ff 45 e8             	incl   -0x18(%ebp)
  80053b:	a1 20 30 80 00       	mov    0x803020,%eax
  800540:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800546:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800549:	39 c2                	cmp    %eax,%edx
  80054b:	77 85                	ja     8004d2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800551:	75 14                	jne    800567 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800553:	83 ec 04             	sub    $0x4,%esp
  800556:	68 94 22 80 00       	push   $0x802294
  80055b:	6a 3a                	push   $0x3a
  80055d:	68 88 22 80 00       	push   $0x802288
  800562:	e8 88 fe ff ff       	call   8003ef <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800567:	ff 45 f0             	incl   -0x10(%ebp)
  80056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800570:	0f 8c 2f ff ff ff    	jl     8004a5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800576:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800584:	eb 26                	jmp    8005ac <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800586:	a1 20 30 80 00       	mov    0x803020,%eax
  80058b:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800591:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800594:	89 d0                	mov    %edx,%eax
  800596:	01 c0                	add    %eax,%eax
  800598:	01 d0                	add    %edx,%eax
  80059a:	c1 e0 03             	shl    $0x3,%eax
  80059d:	01 c8                	add    %ecx,%eax
  80059f:	8a 40 04             	mov    0x4(%eax),%al
  8005a2:	3c 01                	cmp    $0x1,%al
  8005a4:	75 03                	jne    8005a9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005a6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a9:	ff 45 e0             	incl   -0x20(%ebp)
  8005ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ba:	39 c2                	cmp    %eax,%edx
  8005bc:	77 c8                	ja     800586 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c4:	74 14                	je     8005da <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005c6:	83 ec 04             	sub    $0x4,%esp
  8005c9:	68 e8 22 80 00       	push   $0x8022e8
  8005ce:	6a 44                	push   $0x44
  8005d0:	68 88 22 80 00       	push   $0x802288
  8005d5:	e8 15 fe ff ff       	call   8003ef <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005da:	90                   	nop
  8005db:	c9                   	leave  
  8005dc:	c3                   	ret    

008005dd <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	53                   	push   %ebx
  8005e1:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	89 0a                	mov    %ecx,(%edx)
  8005f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f4:	88 d1                	mov    %dl,%cl
  8005f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	3d ff 00 00 00       	cmp    $0xff,%eax
  800607:	75 30                	jne    800639 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800609:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80060f:	a0 44 30 80 00       	mov    0x803044,%al
  800614:	0f b6 c0             	movzbl %al,%eax
  800617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80061a:	8b 09                	mov    (%ecx),%ecx
  80061c:	89 cb                	mov    %ecx,%ebx
  80061e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800621:	83 c1 08             	add    $0x8,%ecx
  800624:	52                   	push   %edx
  800625:	50                   	push   %eax
  800626:	53                   	push   %ebx
  800627:	51                   	push   %ecx
  800628:	e8 a0 0f 00 00       	call   8015cd <sys_cputs>
  80062d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063c:	8b 40 04             	mov    0x4(%eax),%eax
  80063f:	8d 50 01             	lea    0x1(%eax),%edx
  800642:	8b 45 0c             	mov    0xc(%ebp),%eax
  800645:	89 50 04             	mov    %edx,0x4(%eax)
}
  800648:	90                   	nop
  800649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800657:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80065e:	00 00 00 
	b.cnt = 0;
  800661:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800668:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80066b:	ff 75 0c             	pushl  0xc(%ebp)
  80066e:	ff 75 08             	pushl  0x8(%ebp)
  800671:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800677:	50                   	push   %eax
  800678:	68 dd 05 80 00       	push   $0x8005dd
  80067d:	e8 5a 02 00 00       	call   8008dc <vprintfmt>
  800682:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800685:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80068b:	a0 44 30 80 00       	mov    0x803044,%al
  800690:	0f b6 c0             	movzbl %al,%eax
  800693:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800699:	52                   	push   %edx
  80069a:	50                   	push   %eax
  80069b:	51                   	push   %ecx
  80069c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a2:	83 c0 08             	add    $0x8,%eax
  8006a5:	50                   	push   %eax
  8006a6:	e8 22 0f 00 00       	call   8015cd <sys_cputs>
  8006ab:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006ae:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006b5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006c3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006ca:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006d9:	50                   	push   %eax
  8006da:	e8 6f ff ff ff       	call   80064e <vcprintf>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006e8:	c9                   	leave  
  8006e9:	c3                   	ret    

008006ea <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006ea:	55                   	push   %ebp
  8006eb:	89 e5                	mov    %esp,%ebp
  8006ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006f0:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	c1 e0 08             	shl    $0x8,%eax
  8006fd:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800702:	8d 45 0c             	lea    0xc(%ebp),%eax
  800705:	83 c0 04             	add    $0x4,%eax
  800708:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80070b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 f4             	pushl  -0xc(%ebp)
  800714:	50                   	push   %eax
  800715:	e8 34 ff ff ff       	call   80064e <vcprintf>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800720:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800727:	07 00 00 

	return cnt;
  80072a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800735:	e8 d7 0e 00 00       	call   801611 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80073a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80073d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 f4             	pushl  -0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	e8 ff fe ff ff       	call   80064e <vcprintf>
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800755:	e8 d1 0e 00 00       	call   80162b <sys_unlock_cons>
	return cnt;
  80075a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	53                   	push   %ebx
  800763:	83 ec 14             	sub    $0x14,%esp
  800766:	8b 45 10             	mov    0x10(%ebp),%eax
  800769:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800772:	8b 45 18             	mov    0x18(%ebp),%eax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80077d:	77 55                	ja     8007d4 <printnum+0x75>
  80077f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800782:	72 05                	jb     800789 <printnum+0x2a>
  800784:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800787:	77 4b                	ja     8007d4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800789:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80078c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80078f:	8b 45 18             	mov    0x18(%ebp),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
  800797:	52                   	push   %edx
  800798:	50                   	push   %eax
  800799:	ff 75 f4             	pushl  -0xc(%ebp)
  80079c:	ff 75 f0             	pushl  -0x10(%ebp)
  80079f:	e8 68 14 00 00       	call   801c0c <__udivdi3>
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	83 ec 04             	sub    $0x4,%esp
  8007aa:	ff 75 20             	pushl  0x20(%ebp)
  8007ad:	53                   	push   %ebx
  8007ae:	ff 75 18             	pushl  0x18(%ebp)
  8007b1:	52                   	push   %edx
  8007b2:	50                   	push   %eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	e8 a1 ff ff ff       	call   80075f <printnum>
  8007be:	83 c4 20             	add    $0x20,%esp
  8007c1:	eb 1a                	jmp    8007dd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 20             	pushl  0x20(%ebp)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	ff d0                	call   *%eax
  8007d1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007d4:	ff 4d 1c             	decl   0x1c(%ebp)
  8007d7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007db:	7f e6                	jg     8007c3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007dd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007eb:	53                   	push   %ebx
  8007ec:	51                   	push   %ecx
  8007ed:	52                   	push   %edx
  8007ee:	50                   	push   %eax
  8007ef:	e8 28 15 00 00       	call   801d1c <__umoddi3>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	05 54 25 80 00       	add    $0x802554,%eax
  8007fc:	8a 00                	mov    (%eax),%al
  8007fe:	0f be c0             	movsbl %al,%eax
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	50                   	push   %eax
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
}
  800810:	90                   	nop
  800811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800819:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80081d:	7e 1c                	jle    80083b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	8d 50 08             	lea    0x8(%eax),%edx
  800827:	8b 45 08             	mov    0x8(%ebp),%eax
  80082a:	89 10                	mov    %edx,(%eax)
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	83 e8 08             	sub    $0x8,%eax
  800834:	8b 50 04             	mov    0x4(%eax),%edx
  800837:	8b 00                	mov    (%eax),%eax
  800839:	eb 40                	jmp    80087b <getuint+0x65>
	else if (lflag)
  80083b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80083f:	74 1e                	je     80085f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	8d 50 04             	lea    0x4(%eax),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	89 10                	mov    %edx,(%eax)
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	83 e8 04             	sub    $0x4,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
  80085d:	eb 1c                	jmp    80087b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 00                	mov    (%eax),%eax
  800864:	8d 50 04             	lea    0x4(%eax),%edx
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	89 10                	mov    %edx,(%eax)
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	8b 00                	mov    (%eax),%eax
  800871:	83 e8 04             	sub    $0x4,%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800880:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800884:	7e 1c                	jle    8008a2 <getint+0x25>
		return va_arg(*ap, long long);
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	8d 50 08             	lea    0x8(%eax),%edx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	89 10                	mov    %edx,(%eax)
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	83 e8 08             	sub    $0x8,%eax
  80089b:	8b 50 04             	mov    0x4(%eax),%edx
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	eb 38                	jmp    8008da <getint+0x5d>
	else if (lflag)
  8008a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a6:	74 1a                	je     8008c2 <getint+0x45>
		return va_arg(*ap, long);
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	8d 50 04             	lea    0x4(%eax),%edx
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	89 10                	mov    %edx,(%eax)
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	83 e8 04             	sub    $0x4,%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	99                   	cltd   
  8008c0:	eb 18                	jmp    8008da <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	8b 00                	mov    (%eax),%eax
  8008c7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	89 10                	mov    %edx,(%eax)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 00                	mov    (%eax),%eax
  8008d4:	83 e8 04             	sub    $0x4,%eax
  8008d7:	8b 00                	mov    (%eax),%eax
  8008d9:	99                   	cltd   
}
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	56                   	push   %esi
  8008e0:	53                   	push   %ebx
  8008e1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e4:	eb 17                	jmp    8008fd <vprintfmt+0x21>
			if (ch == '\0')
  8008e6:	85 db                	test   %ebx,%ebx
  8008e8:	0f 84 c1 03 00 00    	je     800caf <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800900:	8d 50 01             	lea    0x1(%eax),%edx
  800903:	89 55 10             	mov    %edx,0x10(%ebp)
  800906:	8a 00                	mov    (%eax),%al
  800908:	0f b6 d8             	movzbl %al,%ebx
  80090b:	83 fb 25             	cmp    $0x25,%ebx
  80090e:	75 d6                	jne    8008e6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800910:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800914:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80091b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800922:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800929:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800930:	8b 45 10             	mov    0x10(%ebp),%eax
  800933:	8d 50 01             	lea    0x1(%eax),%edx
  800936:	89 55 10             	mov    %edx,0x10(%ebp)
  800939:	8a 00                	mov    (%eax),%al
  80093b:	0f b6 d8             	movzbl %al,%ebx
  80093e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800941:	83 f8 5b             	cmp    $0x5b,%eax
  800944:	0f 87 3d 03 00 00    	ja     800c87 <vprintfmt+0x3ab>
  80094a:	8b 04 85 78 25 80 00 	mov    0x802578(,%eax,4),%eax
  800951:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800953:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800957:	eb d7                	jmp    800930 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800959:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80095d:	eb d1                	jmp    800930 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800966:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800969:	89 d0                	mov    %edx,%eax
  80096b:	c1 e0 02             	shl    $0x2,%eax
  80096e:	01 d0                	add    %edx,%eax
  800970:	01 c0                	add    %eax,%eax
  800972:	01 d8                	add    %ebx,%eax
  800974:	83 e8 30             	sub    $0x30,%eax
  800977:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80097a:	8b 45 10             	mov    0x10(%ebp),%eax
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800982:	83 fb 2f             	cmp    $0x2f,%ebx
  800985:	7e 3e                	jle    8009c5 <vprintfmt+0xe9>
  800987:	83 fb 39             	cmp    $0x39,%ebx
  80098a:	7f 39                	jg     8009c5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80098c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80098f:	eb d5                	jmp    800966 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 c0 04             	add    $0x4,%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	83 e8 04             	sub    $0x4,%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009a5:	eb 1f                	jmp    8009c6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	79 83                	jns    800930 <vprintfmt+0x54>
				width = 0;
  8009ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009b4:	e9 77 ff ff ff       	jmp    800930 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009b9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009c0:	e9 6b ff ff ff       	jmp    800930 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009c5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ca:	0f 89 60 ff ff ff    	jns    800930 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009d6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009dd:	e9 4e ff ff ff       	jmp    800930 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009e2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009e5:	e9 46 ff ff ff       	jmp    800930 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	50                   	push   %eax
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			break;
  800a0a:	e9 9b 02 00 00       	jmp    800caa <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	83 c0 04             	add    $0x4,%eax
  800a15:	89 45 14             	mov    %eax,0x14(%ebp)
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a20:	85 db                	test   %ebx,%ebx
  800a22:	79 02                	jns    800a26 <vprintfmt+0x14a>
				err = -err;
  800a24:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a26:	83 fb 64             	cmp    $0x64,%ebx
  800a29:	7f 0b                	jg     800a36 <vprintfmt+0x15a>
  800a2b:	8b 34 9d c0 23 80 00 	mov    0x8023c0(,%ebx,4),%esi
  800a32:	85 f6                	test   %esi,%esi
  800a34:	75 19                	jne    800a4f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a36:	53                   	push   %ebx
  800a37:	68 65 25 80 00       	push   $0x802565
  800a3c:	ff 75 0c             	pushl  0xc(%ebp)
  800a3f:	ff 75 08             	pushl  0x8(%ebp)
  800a42:	e8 70 02 00 00       	call   800cb7 <printfmt>
  800a47:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a4a:	e9 5b 02 00 00       	jmp    800caa <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a4f:	56                   	push   %esi
  800a50:	68 6e 25 80 00       	push   $0x80256e
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	ff 75 08             	pushl  0x8(%ebp)
  800a5b:	e8 57 02 00 00       	call   800cb7 <printfmt>
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 42 02 00 00       	jmp    800caa <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 30                	mov    (%eax),%esi
  800a79:	85 f6                	test   %esi,%esi
  800a7b:	75 05                	jne    800a82 <vprintfmt+0x1a6>
				p = "(null)";
  800a7d:	be 71 25 80 00       	mov    $0x802571,%esi
			if (width > 0 && padc != '-')
  800a82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a86:	7e 6d                	jle    800af5 <vprintfmt+0x219>
  800a88:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a8c:	74 67                	je     800af5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	50                   	push   %eax
  800a95:	56                   	push   %esi
  800a96:	e8 1e 03 00 00       	call   800db9 <strnlen>
  800a9b:	83 c4 10             	add    $0x10,%esp
  800a9e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aa1:	eb 16                	jmp    800ab9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aa3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	50                   	push   %eax
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ab6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ab9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abd:	7f e4                	jg     800aa3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800abf:	eb 34                	jmp    800af5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ac1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ac5:	74 1c                	je     800ae3 <vprintfmt+0x207>
  800ac7:	83 fb 1f             	cmp    $0x1f,%ebx
  800aca:	7e 05                	jle    800ad1 <vprintfmt+0x1f5>
  800acc:	83 fb 7e             	cmp    $0x7e,%ebx
  800acf:	7e 12                	jle    800ae3 <vprintfmt+0x207>
					putch('?', putdat);
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	6a 3f                	push   $0x3f
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	ff d0                	call   *%eax
  800ade:	83 c4 10             	add    $0x10,%esp
  800ae1:	eb 0f                	jmp    800af2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	53                   	push   %ebx
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800af2:	ff 4d e4             	decl   -0x1c(%ebp)
  800af5:	89 f0                	mov    %esi,%eax
  800af7:	8d 70 01             	lea    0x1(%eax),%esi
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	0f be d8             	movsbl %al,%ebx
  800aff:	85 db                	test   %ebx,%ebx
  800b01:	74 24                	je     800b27 <vprintfmt+0x24b>
  800b03:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b07:	78 b8                	js     800ac1 <vprintfmt+0x1e5>
  800b09:	ff 4d e0             	decl   -0x20(%ebp)
  800b0c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b10:	79 af                	jns    800ac1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b12:	eb 13                	jmp    800b27 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	6a 20                	push   $0x20
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	ff d0                	call   *%eax
  800b21:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b24:	ff 4d e4             	decl   -0x1c(%ebp)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	7f e7                	jg     800b14 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b2d:	e9 78 01 00 00       	jmp    800caa <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 e8             	pushl  -0x18(%ebp)
  800b38:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3b:	50                   	push   %eax
  800b3c:	e8 3c fd ff ff       	call   80087d <getint>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b50:	85 d2                	test   %edx,%edx
  800b52:	79 23                	jns    800b77 <vprintfmt+0x29b>
				putch('-', putdat);
  800b54:	83 ec 08             	sub    $0x8,%esp
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	6a 2d                	push   $0x2d
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	ff d0                	call   *%eax
  800b61:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6a:	f7 d8                	neg    %eax
  800b6c:	83 d2 00             	adc    $0x0,%edx
  800b6f:	f7 da                	neg    %edx
  800b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b74:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b77:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b7e:	e9 bc 00 00 00       	jmp    800c3f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 e8             	pushl  -0x18(%ebp)
  800b89:	8d 45 14             	lea    0x14(%ebp),%eax
  800b8c:	50                   	push   %eax
  800b8d:	e8 84 fc ff ff       	call   800816 <getuint>
  800b92:	83 c4 10             	add    $0x10,%esp
  800b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b98:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b9b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ba2:	e9 98 00 00 00       	jmp    800c3f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ba7:	83 ec 08             	sub    $0x8,%esp
  800baa:	ff 75 0c             	pushl  0xc(%ebp)
  800bad:	6a 58                	push   $0x58
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	ff d0                	call   *%eax
  800bb4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 58                	push   $0x58
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 58                	push   $0x58
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
			break;
  800bd7:	e9 ce 00 00 00       	jmp    800caa <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 30                	push   $0x30
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bec:	83 ec 08             	sub    $0x8,%esp
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	6a 78                	push   $0x78
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	ff d0                	call   *%eax
  800bf9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800bff:	83 c0 04             	add    $0x4,%eax
  800c02:	89 45 14             	mov    %eax,0x14(%ebp)
  800c05:	8b 45 14             	mov    0x14(%ebp),%eax
  800c08:	83 e8 04             	sub    $0x4,%eax
  800c0b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c17:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c1e:	eb 1f                	jmp    800c3f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 e8             	pushl  -0x18(%ebp)
  800c26:	8d 45 14             	lea    0x14(%ebp),%eax
  800c29:	50                   	push   %eax
  800c2a:	e8 e7 fb ff ff       	call   800816 <getuint>
  800c2f:	83 c4 10             	add    $0x10,%esp
  800c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c38:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c3f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c46:	83 ec 04             	sub    $0x4,%esp
  800c49:	52                   	push   %edx
  800c4a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c4d:	50                   	push   %eax
  800c4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c51:	ff 75 f0             	pushl  -0x10(%ebp)
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	ff 75 08             	pushl  0x8(%ebp)
  800c5a:	e8 00 fb ff ff       	call   80075f <printnum>
  800c5f:	83 c4 20             	add    $0x20,%esp
			break;
  800c62:	eb 46                	jmp    800caa <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	53                   	push   %ebx
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	ff d0                	call   *%eax
  800c70:	83 c4 10             	add    $0x10,%esp
			break;
  800c73:	eb 35                	jmp    800caa <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c75:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c7c:	eb 2c                	jmp    800caa <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c7e:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c85:	eb 23                	jmp    800caa <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 25                	push   $0x25
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c97:	ff 4d 10             	decl   0x10(%ebp)
  800c9a:	eb 03                	jmp    800c9f <vprintfmt+0x3c3>
  800c9c:	ff 4d 10             	decl   0x10(%ebp)
  800c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca2:	48                   	dec    %eax
  800ca3:	8a 00                	mov    (%eax),%al
  800ca5:	3c 25                	cmp    $0x25,%al
  800ca7:	75 f3                	jne    800c9c <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ca9:	90                   	nop
		}
	}
  800caa:	e9 35 fc ff ff       	jmp    8008e4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800caf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cbd:	8d 45 10             	lea    0x10(%ebp),%eax
  800cc0:	83 c0 04             	add    $0x4,%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cc6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc9:	ff 75 f4             	pushl  -0xc(%ebp)
  800ccc:	50                   	push   %eax
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	ff 75 08             	pushl  0x8(%ebp)
  800cd3:	e8 04 fc ff ff       	call   8008dc <vprintfmt>
  800cd8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cdb:	90                   	nop
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce4:	8b 40 08             	mov    0x8(%eax),%eax
  800ce7:	8d 50 01             	lea    0x1(%eax),%edx
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf3:	8b 10                	mov    (%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8b 40 04             	mov    0x4(%eax),%eax
  800cfb:	39 c2                	cmp    %eax,%edx
  800cfd:	73 12                	jae    800d11 <sprintputch+0x33>
		*b->buf++ = ch;
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 48 01             	lea    0x1(%eax),%ecx
  800d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0a:	89 0a                	mov    %ecx,(%edx)
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	88 10                	mov    %dl,(%eax)
}
  800d11:	90                   	nop
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	01 d0                	add    %edx,%eax
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d39:	74 06                	je     800d41 <vsnprintf+0x2d>
  800d3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d3f:	7f 07                	jg     800d48 <vsnprintf+0x34>
		return -E_INVAL;
  800d41:	b8 03 00 00 00       	mov    $0x3,%eax
  800d46:	eb 20                	jmp    800d68 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d48:	ff 75 14             	pushl  0x14(%ebp)
  800d4b:	ff 75 10             	pushl  0x10(%ebp)
  800d4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d51:	50                   	push   %eax
  800d52:	68 de 0c 80 00       	push   $0x800cde
  800d57:	e8 80 fb ff ff       	call   8008dc <vprintfmt>
  800d5c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d62:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d70:	8d 45 10             	lea    0x10(%ebp),%eax
  800d73:	83 c0 04             	add    $0x4,%eax
  800d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d79:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d7f:	50                   	push   %eax
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 08             	pushl  0x8(%ebp)
  800d86:	e8 89 ff ff ff       	call   800d14 <vsnprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da3:	eb 06                	jmp    800dab <strlen+0x15>
		n++;
  800da5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	84 c0                	test   %al,%al
  800db2:	75 f1                	jne    800da5 <strlen+0xf>
		n++;
	return n;
  800db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc6:	eb 09                	jmp    800dd1 <strnlen+0x18>
		n++;
  800dc8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcb:	ff 45 08             	incl   0x8(%ebp)
  800dce:	ff 4d 0c             	decl   0xc(%ebp)
  800dd1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd5:	74 09                	je     800de0 <strnlen+0x27>
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	84 c0                	test   %al,%al
  800dde:	75 e8                	jne    800dc8 <strnlen+0xf>
		n++;
	return n;
  800de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800df1:	90                   	nop
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8d 50 01             	lea    0x1(%eax),%edx
  800df8:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e01:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e04:	8a 12                	mov    (%edx),%dl
  800e06:	88 10                	mov    %dl,(%eax)
  800e08:	8a 00                	mov    (%eax),%al
  800e0a:	84 c0                	test   %al,%al
  800e0c:	75 e4                	jne    800df2 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e11:	c9                   	leave  
  800e12:	c3                   	ret    

00800e13 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e1f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e26:	eb 1f                	jmp    800e47 <strncpy+0x34>
		*dst++ = *src;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8d 50 01             	lea    0x1(%eax),%edx
  800e2e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e31:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e34:	8a 12                	mov    (%edx),%dl
  800e36:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	84 c0                	test   %al,%al
  800e3f:	74 03                	je     800e44 <strncpy+0x31>
			src++;
  800e41:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e44:	ff 45 fc             	incl   -0x4(%ebp)
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e4d:	72 d9                	jb     800e28 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e64:	74 30                	je     800e96 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e66:	eb 16                	jmp    800e7e <strlcpy+0x2a>
			*dst++ = *src++;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e7e:	ff 4d 10             	decl   0x10(%ebp)
  800e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e85:	74 09                	je     800e90 <strlcpy+0x3c>
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	8a 00                	mov    (%eax),%al
  800e8c:	84 c0                	test   %al,%al
  800e8e:	75 d8                	jne    800e68 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	29 c2                	sub    %eax,%edx
  800e9e:	89 d0                	mov    %edx,%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ea5:	eb 06                	jmp    800ead <strcmp+0xb>
		p++, q++;
  800ea7:	ff 45 08             	incl   0x8(%ebp)
  800eaa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	84 c0                	test   %al,%al
  800eb4:	74 0e                	je     800ec4 <strcmp+0x22>
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8a 10                	mov    (%eax),%dl
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	38 c2                	cmp    %al,%dl
  800ec2:	74 e3                	je     800ea7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 00                	mov    (%eax),%al
  800ec9:	0f b6 d0             	movzbl %al,%edx
  800ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 c0             	movzbl %al,%eax
  800ed4:	29 c2                	sub    %eax,%edx
  800ed6:	89 d0                	mov    %edx,%eax
}
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800edd:	eb 09                	jmp    800ee8 <strncmp+0xe>
		n--, p++, q++;
  800edf:	ff 4d 10             	decl   0x10(%ebp)
  800ee2:	ff 45 08             	incl   0x8(%ebp)
  800ee5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eec:	74 17                	je     800f05 <strncmp+0x2b>
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	84 c0                	test   %al,%al
  800ef5:	74 0e                	je     800f05 <strncmp+0x2b>
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	8a 10                	mov    (%eax),%dl
  800efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	38 c2                	cmp    %al,%dl
  800f03:	74 da                	je     800edf <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f09:	75 07                	jne    800f12 <strncmp+0x38>
		return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	eb 14                	jmp    800f26 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	0f b6 d0             	movzbl %al,%edx
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
}
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 04             	sub    $0x4,%esp
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f34:	eb 12                	jmp    800f48 <strchr+0x20>
		if (*s == c)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8a 00                	mov    (%eax),%al
  800f3b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f3e:	75 05                	jne    800f45 <strchr+0x1d>
			return (char *) s;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	eb 11                	jmp    800f56 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f45:	ff 45 08             	incl   0x8(%ebp)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	84 c0                	test   %al,%al
  800f4f:	75 e5                	jne    800f36 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f56:	c9                   	leave  
  800f57:	c3                   	ret    

00800f58 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	83 ec 04             	sub    $0x4,%esp
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f64:	eb 0d                	jmp    800f73 <strfind+0x1b>
		if (*s == c)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f6e:	74 0e                	je     800f7e <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f70:	ff 45 08             	incl   0x8(%ebp)
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	84 c0                	test   %al,%al
  800f7a:	75 ea                	jne    800f66 <strfind+0xe>
  800f7c:	eb 01                	jmp    800f7f <strfind+0x27>
		if (*s == c)
			break;
  800f7e:	90                   	nop
	return (char *) s;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f90:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f94:	76 63                	jbe    800ff9 <memset+0x75>
		uint64 data_block = c;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	99                   	cltd   
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa6:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800faa:	c1 e0 08             	shl    $0x8,%eax
  800fad:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fb0:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fbd:	c1 e0 10             	shl    $0x10,%eax
  800fc0:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fc3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcc:	89 c2                	mov    %eax,%edx
  800fce:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd3:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fd6:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fd9:	eb 18                	jmp    800ff3 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fdb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fde:	8d 41 08             	lea    0x8(%ecx),%eax
  800fe1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	89 01                	mov    %eax,(%ecx)
  800fec:	89 51 04             	mov    %edx,0x4(%ecx)
  800fef:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800ff3:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800ff7:	77 e2                	ja     800fdb <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800ff9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffd:	74 23                	je     801022 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801002:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801005:	eb 0e                	jmp    801015 <memset+0x91>
			*p8++ = (uint8)c;
  801007:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80100a:	8d 50 01             	lea    0x1(%eax),%edx
  80100d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801010:	8b 55 0c             	mov    0xc(%ebp),%edx
  801013:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801015:	8b 45 10             	mov    0x10(%ebp),%eax
  801018:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101b:	89 55 10             	mov    %edx,0x10(%ebp)
  80101e:	85 c0                	test   %eax,%eax
  801020:	75 e5                	jne    801007 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801025:	c9                   	leave  
  801026:	c3                   	ret    

00801027 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80102d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801030:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801039:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80103d:	76 24                	jbe    801063 <memcpy+0x3c>
		while(n >= 8){
  80103f:	eb 1c                	jmp    80105d <memcpy+0x36>
			*d64 = *s64;
  801041:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801044:	8b 50 04             	mov    0x4(%eax),%edx
  801047:	8b 00                	mov    (%eax),%eax
  801049:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80104c:	89 01                	mov    %eax,(%ecx)
  80104e:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801051:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801055:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801059:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80105d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801061:	77 de                	ja     801041 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801067:	74 31                	je     80109a <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80106f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801072:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801075:	eb 16                	jmp    80108d <memcpy+0x66>
			*d8++ = *s8++;
  801077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107a:	8d 50 01             	lea    0x1(%eax),%edx
  80107d:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801083:	8d 4a 01             	lea    0x1(%edx),%ecx
  801086:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801089:	8a 12                	mov    (%edx),%dl
  80108b:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	8d 50 ff             	lea    -0x1(%eax),%edx
  801093:	89 55 10             	mov    %edx,0x10(%ebp)
  801096:	85 c0                	test   %eax,%eax
  801098:	75 dd                	jne    801077 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109d:	c9                   	leave  
  80109e:	c3                   	ret    

0080109f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010b7:	73 50                	jae    801109 <memmove+0x6a>
  8010b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bf:	01 d0                	add    %edx,%eax
  8010c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c4:	76 43                	jbe    801109 <memmove+0x6a>
		s += n;
  8010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010d2:	eb 10                	jmp    8010e4 <memmove+0x45>
			*--d = *--s;
  8010d4:	ff 4d f8             	decl   -0x8(%ebp)
  8010d7:	ff 4d fc             	decl   -0x4(%ebp)
  8010da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010dd:	8a 10                	mov    (%eax),%dl
  8010df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	75 e3                	jne    8010d4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010f1:	eb 23                	jmp    801116 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  801102:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801105:	8a 12                	mov    (%edx),%dl
  801107:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110f:	89 55 10             	mov    %edx,0x10(%ebp)
  801112:	85 c0                	test   %eax,%eax
  801114:	75 dd                	jne    8010f3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80112d:	eb 2a                	jmp    801159 <memcmp+0x3e>
		if (*s1 != *s2)
  80112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801132:	8a 10                	mov    (%eax),%dl
  801134:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	38 c2                	cmp    %al,%dl
  80113b:	74 16                	je     801153 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80113d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f b6 d0             	movzbl %al,%edx
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 c0             	movzbl %al,%eax
  80114d:	29 c2                	sub    %eax,%edx
  80114f:	89 d0                	mov    %edx,%eax
  801151:	eb 18                	jmp    80116b <memcmp+0x50>
		s1++, s2++;
  801153:	ff 45 fc             	incl   -0x4(%ebp)
  801156:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	85 c0                	test   %eax,%eax
  801164:	75 c9                	jne    80112f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801166:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801173:	8b 55 08             	mov    0x8(%ebp),%edx
  801176:	8b 45 10             	mov    0x10(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80117e:	eb 15                	jmp    801195 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 d0             	movzbl %al,%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	0f b6 c0             	movzbl %al,%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	74 0d                	je     80119f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801192:	ff 45 08             	incl   0x8(%ebp)
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80119b:	72 e3                	jb     801180 <memfind+0x13>
  80119d:	eb 01                	jmp    8011a0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80119f:	90                   	nop
	return (void *) s;
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b9:	eb 03                	jmp    8011be <strtol+0x19>
		s++;
  8011bb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 20                	cmp    $0x20,%al
  8011c5:	74 f4                	je     8011bb <strtol+0x16>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 09                	cmp    $0x9,%al
  8011ce:	74 eb                	je     8011bb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	3c 2b                	cmp    $0x2b,%al
  8011d7:	75 05                	jne    8011de <strtol+0x39>
		s++;
  8011d9:	ff 45 08             	incl   0x8(%ebp)
  8011dc:	eb 13                	jmp    8011f1 <strtol+0x4c>
	else if (*s == '-')
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	3c 2d                	cmp    $0x2d,%al
  8011e5:	75 0a                	jne    8011f1 <strtol+0x4c>
		s++, neg = 1;
  8011e7:	ff 45 08             	incl   0x8(%ebp)
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011f5:	74 06                	je     8011fd <strtol+0x58>
  8011f7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011fb:	75 20                	jne    80121d <strtol+0x78>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	3c 30                	cmp    $0x30,%al
  801204:	75 17                	jne    80121d <strtol+0x78>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	40                   	inc    %eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	3c 78                	cmp    $0x78,%al
  80120e:	75 0d                	jne    80121d <strtol+0x78>
		s += 2, base = 16;
  801210:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801214:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80121b:	eb 28                	jmp    801245 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80121d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801221:	75 15                	jne    801238 <strtol+0x93>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	3c 30                	cmp    $0x30,%al
  80122a:	75 0c                	jne    801238 <strtol+0x93>
		s++, base = 8;
  80122c:	ff 45 08             	incl   0x8(%ebp)
  80122f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801236:	eb 0d                	jmp    801245 <strtol+0xa0>
	else if (base == 0)
  801238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123c:	75 07                	jne    801245 <strtol+0xa0>
		base = 10;
  80123e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 2f                	cmp    $0x2f,%al
  80124c:	7e 19                	jle    801267 <strtol+0xc2>
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	3c 39                	cmp    $0x39,%al
  801255:	7f 10                	jg     801267 <strtol+0xc2>
			dig = *s - '0';
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	0f be c0             	movsbl %al,%eax
  80125f:	83 e8 30             	sub    $0x30,%eax
  801262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801265:	eb 42                	jmp    8012a9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 60                	cmp    $0x60,%al
  80126e:	7e 19                	jle    801289 <strtol+0xe4>
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 7a                	cmp    $0x7a,%al
  801277:	7f 10                	jg     801289 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	83 e8 57             	sub    $0x57,%eax
  801284:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801287:	eb 20                	jmp    8012a9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 40                	cmp    $0x40,%al
  801290:	7e 39                	jle    8012cb <strtol+0x126>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3c 5a                	cmp    $0x5a,%al
  801299:	7f 30                	jg     8012cb <strtol+0x126>
			dig = *s - 'A' + 10;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	0f be c0             	movsbl %al,%eax
  8012a3:	83 e8 37             	sub    $0x37,%eax
  8012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012af:	7d 19                	jge    8012ca <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012b1:	ff 45 08             	incl   0x8(%ebp)
  8012b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b7:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012bb:	89 c2                	mov    %eax,%edx
  8012bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012c5:	e9 7b ff ff ff       	jmp    801245 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ca:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012cf:	74 08                	je     8012d9 <strtol+0x134>
		*endptr = (char *) s;
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012dd:	74 07                	je     8012e6 <strtol+0x141>
  8012df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e2:	f7 d8                	neg    %eax
  8012e4:	eb 03                	jmp    8012e9 <strtol+0x144>
  8012e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <ltostr>:

void
ltostr(long value, char *str)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801303:	79 13                	jns    801318 <ltostr+0x2d>
	{
		neg = 1;
  801305:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801312:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801315:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801320:	99                   	cltd   
  801321:	f7 f9                	idiv   %ecx
  801323:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801329:	8d 50 01             	lea    0x1(%eax),%edx
  80132c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	01 d0                	add    %edx,%eax
  801336:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801339:	83 c2 30             	add    $0x30,%edx
  80133c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80133e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801341:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801346:	f7 e9                	imul   %ecx
  801348:	c1 fa 02             	sar    $0x2,%edx
  80134b:	89 c8                	mov    %ecx,%eax
  80134d:	c1 f8 1f             	sar    $0x1f,%eax
  801350:	29 c2                	sub    %eax,%edx
  801352:	89 d0                	mov    %edx,%eax
  801354:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801357:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135b:	75 bb                	jne    801318 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801364:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801367:	48                   	dec    %eax
  801368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80136f:	74 3d                	je     8013ae <ltostr+0xc3>
		start = 1 ;
  801371:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801378:	eb 34                	jmp    8013ae <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801380:	01 d0                	add    %edx,%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 c2                	add    %eax,%edx
  80138f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801392:	8b 45 0c             	mov    0xc(%ebp),%eax
  801395:	01 c8                	add    %ecx,%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a1:	01 c2                	add    %eax,%edx
  8013a3:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a6:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a8:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ab:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b4:	7c c4                	jl     80137a <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bc:	01 d0                	add    %edx,%eax
  8013be:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c1:	90                   	nop
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	e8 c4 f9 ff ff       	call   800d96 <strlen>
  8013d2:	83 c4 04             	add    $0x4,%esp
  8013d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d8:	ff 75 0c             	pushl  0xc(%ebp)
  8013db:	e8 b6 f9 ff ff       	call   800d96 <strlen>
  8013e0:	83 c4 04             	add    $0x4,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f4:	eb 17                	jmp    80140d <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fc:	01 c2                	add    %eax,%edx
  8013fe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	01 c8                	add    %ecx,%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140a:	ff 45 fc             	incl   -0x4(%ebp)
  80140d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801410:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801413:	7c e1                	jl     8013f6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801415:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801423:	eb 1f                	jmp    801444 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801425:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801428:	8d 50 01             	lea    0x1(%eax),%edx
  80142b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80142e:	89 c2                	mov    %eax,%edx
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	01 c2                	add    %eax,%edx
  801435:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143b:	01 c8                	add    %ecx,%eax
  80143d:	8a 00                	mov    (%eax),%al
  80143f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801441:	ff 45 f8             	incl   -0x8(%ebp)
  801444:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144a:	7c d9                	jl     801425 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144f:	8b 45 10             	mov    0x10(%ebp),%eax
  801452:	01 d0                	add    %edx,%eax
  801454:	c6 00 00             	movb   $0x0,(%eax)
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145d:	8b 45 14             	mov    0x14(%ebp),%eax
  801460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801472:	8b 45 10             	mov    0x10(%ebp),%eax
  801475:	01 d0                	add    %edx,%eax
  801477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147d:	eb 0c                	jmp    80148b <strsplit+0x31>
			*string++ = 0;
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 08             	mov    %edx,0x8(%ebp)
  801488:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 18                	je     8014ac <strsplit+0x52>
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be c0             	movsbl %al,%eax
  80149c:	50                   	push   %eax
  80149d:	ff 75 0c             	pushl  0xc(%ebp)
  8014a0:	e8 83 fa ff ff       	call   800f28 <strchr>
  8014a5:	83 c4 08             	add    $0x8,%esp
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	75 d3                	jne    80147f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	74 5a                	je     80150f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	83 f8 0f             	cmp    $0xf,%eax
  8014bd:	75 07                	jne    8014c6 <strsplit+0x6c>
		{
			return 0;
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	eb 66                	jmp    80152c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c9:	8b 00                	mov    (%eax),%eax
  8014cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ce:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d1:	89 0a                	mov    %ecx,(%edx)
  8014d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014da:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dd:	01 c2                	add    %eax,%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e4:	eb 03                	jmp    8014e9 <strsplit+0x8f>
			string++;
  8014e6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8a 00                	mov    (%eax),%al
  8014ee:	84 c0                	test   %al,%al
  8014f0:	74 8b                	je     80147d <strsplit+0x23>
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	0f be c0             	movsbl %al,%eax
  8014fa:	50                   	push   %eax
  8014fb:	ff 75 0c             	pushl  0xc(%ebp)
  8014fe:	e8 25 fa ff ff       	call   800f28 <strchr>
  801503:	83 c4 08             	add    $0x8,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	74 dc                	je     8014e6 <strsplit+0x8c>
			string++;
	}
  80150a:	e9 6e ff ff ff       	jmp    80147d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80150f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801510:	8b 45 14             	mov    0x14(%ebp),%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151c:	8b 45 10             	mov    0x10(%ebp),%eax
  80151f:	01 d0                	add    %edx,%eax
  801521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801527:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80153a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801541:	eb 4a                	jmp    80158d <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801543:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	01 c2                	add    %eax,%edx
  80154b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80154e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801551:	01 c8                	add    %ecx,%eax
  801553:	8a 00                	mov    (%eax),%al
  801555:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801557:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	3c 40                	cmp    $0x40,%al
  801563:	7e 25                	jle    80158a <str2lower+0x5c>
  801565:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	01 d0                	add    %edx,%eax
  80156d:	8a 00                	mov    (%eax),%al
  80156f:	3c 5a                	cmp    $0x5a,%al
  801571:	7f 17                	jg     80158a <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80157e:	8b 55 08             	mov    0x8(%ebp),%edx
  801581:	01 ca                	add    %ecx,%edx
  801583:	8a 12                	mov    (%edx),%dl
  801585:	83 c2 20             	add    $0x20,%edx
  801588:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80158a:	ff 45 fc             	incl   -0x4(%ebp)
  80158d:	ff 75 0c             	pushl  0xc(%ebp)
  801590:	e8 01 f8 ff ff       	call   800d96 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80159b:	7f a6                	jg     801543 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80159d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	57                   	push   %edi
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015bd:	cd 30                	int    $0x30
  8015bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	5b                   	pop    %ebx
  8015c9:	5e                   	pop    %esi
  8015ca:	5f                   	pop    %edi
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    

008015cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	51                   	push   %ecx
  8015e6:	52                   	push   %edx
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	50                   	push   %eax
  8015eb:	6a 00                	push   $0x0
  8015ed:	e8 b0 ff ff ff       	call   8015a2 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	90                   	nop
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 02                	push   $0x2
  801607:	e8 96 ff ff ff       	call   8015a2 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 03                	push   $0x3
  801620:	e8 7d ff ff ff       	call   8015a2 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 04                	push   $0x4
  80163a:	e8 63 ff ff ff       	call   8015a2 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	52                   	push   %edx
  801655:	50                   	push   %eax
  801656:	6a 08                	push   $0x8
  801658:	e8 45 ff ff ff       	call   8015a2 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	56                   	push   %esi
  801666:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801667:	8b 75 18             	mov    0x18(%ebp),%esi
  80166a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	56                   	push   %esi
  801677:	53                   	push   %ebx
  801678:	51                   	push   %ecx
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 09                	push   $0x9
  80167d:	e8 20 ff ff ff       	call   8015a2 <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801688:	5b                   	pop    %ebx
  801689:	5e                   	pop    %esi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	ff 75 08             	pushl  0x8(%ebp)
  80169a:	6a 0a                	push   $0xa
  80169c:	e8 01 ff ff ff       	call   8015a2 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	ff 75 08             	pushl  0x8(%ebp)
  8016b5:	6a 0b                	push   $0xb
  8016b7:	e8 e6 fe ff ff       	call   8015a2 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 0c                	push   $0xc
  8016d0:	e8 cd fe ff ff       	call   8015a2 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 0d                	push   $0xd
  8016e9:	e8 b4 fe ff ff       	call   8015a2 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 0e                	push   $0xe
  801702:	e8 9b fe ff ff       	call   8015a2 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 0f                	push   $0xf
  80171b:	e8 82 fe ff ff       	call   8015a2 <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	6a 10                	push   $0x10
  801735:	e8 68 fe ff ff       	call   8015a2 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 11                	push   $0x11
  80174e:	e8 4f fe ff ff       	call   8015a2 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	90                   	nop
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_cputc>:

void
sys_cputc(const char c)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801765:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	50                   	push   %eax
  801772:	6a 01                	push   $0x1
  801774:	e8 29 fe ff ff       	call   8015a2 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	90                   	nop
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 14                	push   $0x14
  80178e:	e8 0f fe ff ff       	call   8015a2 <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	90                   	nop
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 04             	sub    $0x4,%esp
  80179f:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	51                   	push   %ecx
  8017b2:	52                   	push   %edx
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	50                   	push   %eax
  8017b7:	6a 15                	push   $0x15
  8017b9:	e8 e4 fd ff ff       	call   8015a2 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	52                   	push   %edx
  8017d3:	50                   	push   %eax
  8017d4:	6a 16                	push   $0x16
  8017d6:	e8 c7 fd ff ff       	call   8015a2 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	51                   	push   %ecx
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 17                	push   $0x17
  8017f5:	e8 a8 fd ff ff       	call   8015a2 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 18                	push   $0x18
  801812:	e8 8b fd ff ff       	call   8015a2 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	ff 75 14             	pushl  0x14(%ebp)
  801827:	ff 75 10             	pushl  0x10(%ebp)
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	50                   	push   %eax
  80182e:	6a 19                	push   $0x19
  801830:	e8 6d fd ff ff       	call   8015a2 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	50                   	push   %eax
  801849:	6a 1a                	push   $0x1a
  80184b:	e8 52 fd ff ff       	call   8015a2 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	50                   	push   %eax
  801865:	6a 1b                	push   $0x1b
  801867:	e8 36 fd ff ff       	call   8015a2 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 05                	push   $0x5
  801880:	e8 1d fd ff ff       	call   8015a2 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 06                	push   $0x6
  801899:	e8 04 fd ff ff       	call   8015a2 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 07                	push   $0x7
  8018b2:	e8 eb fc ff ff       	call   8015a2 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_exit_env>:


void sys_exit_env(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 1c                	push   $0x1c
  8018cb:	e8 d2 fc ff ff       	call   8015a2 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	90                   	nop
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018df:	8d 50 04             	lea    0x4(%eax),%edx
  8018e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 1d                	push   $0x1d
  8018ef:	e8 ae fc ff ff       	call   8015a2 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801900:	89 01                	mov    %eax,(%ecx)
  801902:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	c9                   	leave  
  801909:	c2 04 00             	ret    $0x4

0080190c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	ff 75 10             	pushl  0x10(%ebp)
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	6a 13                	push   $0x13
  80191e:	e8 7f fc ff ff       	call   8015a2 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return ;
  801926:	90                   	nop
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_rcr2>:
uint32 sys_rcr2()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 1e                	push   $0x1e
  801938:	e8 65 fc ff ff       	call   8015a2 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80194e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	50                   	push   %eax
  80195b:	6a 1f                	push   $0x1f
  80195d:	e8 40 fc ff ff       	call   8015a2 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
	return ;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <rsttst>:
void rsttst()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 21                	push   $0x21
  801977:	e8 26 fc ff ff       	call   8015a2 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
	return ;
  80197f:	90                   	nop
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	8b 45 14             	mov    0x14(%ebp),%eax
  80198b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80198e:	8b 55 18             	mov    0x18(%ebp),%edx
  801991:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 20                	push   $0x20
  8019a2:	e8 fb fb ff ff       	call   8015a2 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <chktst>:
void chktst(uint32 n)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	ff 75 08             	pushl  0x8(%ebp)
  8019bb:	6a 22                	push   $0x22
  8019bd:	e8 e0 fb ff ff       	call   8015a2 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c5:	90                   	nop
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <inctst>:

void inctst()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 23                	push   $0x23
  8019d7:	e8 c6 fb ff ff       	call   8015a2 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019df:	90                   	nop
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <gettst>:
uint32 gettst()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 24                	push   $0x24
  8019f1:	e8 ac fb ff ff       	call   8015a2 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 25                	push   $0x25
  801a0a:	e8 93 fb ff ff       	call   8015a2 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
  801a12:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a17:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 26                	push   $0x26
  801a36:	e8 67 fb ff ff       	call   8015a2 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3e:	90                   	nop
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	53                   	push   %ebx
  801a54:	51                   	push   %ecx
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 27                	push   $0x27
  801a59:	e8 44 fb ff ff       	call   8015a2 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 28                	push   $0x28
  801a79:	e8 24 fb ff ff       	call   8015a2 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	51                   	push   %ecx
  801a92:	ff 75 10             	pushl  0x10(%ebp)
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 29                	push   $0x29
  801a99:	e8 04 fb ff ff       	call   8015a2 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	ff 75 08             	pushl  0x8(%ebp)
  801ab3:	6a 12                	push   $0x12
  801ab5:	e8 e8 fa ff ff       	call   8015a2 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
	return ;
  801abd:	90                   	nop
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 2a                	push   $0x2a
  801ad3:	e8 ca fa ff ff       	call   8015a2 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 2b                	push   $0x2b
  801aed:	e8 b0 fa ff ff       	call   8015a2 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	6a 2d                	push   $0x2d
  801b08:	e8 95 fa ff ff       	call   8015a2 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
	return;
  801b10:	90                   	nop
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 2c                	push   $0x2c
  801b24:	e8 79 fa ff ff       	call   8015a2 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2c:	90                   	nop
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	68 e8 26 80 00       	push   $0x8026e8
  801b3d:	68 25 01 00 00       	push   $0x125
  801b42:	68 1b 27 80 00       	push   $0x80271b
  801b47:	e8 a3 e8 ff ff       	call   8003ef <_panic>

00801b4c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b52:	8b 55 08             	mov    0x8(%ebp),%edx
  801b55:	89 d0                	mov    %edx,%eax
  801b57:	c1 e0 02             	shl    $0x2,%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b63:	01 d0                	add    %edx,%eax
  801b65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b6c:	01 d0                	add    %edx,%eax
  801b6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b75:	01 d0                	add    %edx,%eax
  801b77:	c1 e0 04             	shl    $0x4,%eax
  801b7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b84:	0f 31                	rdtsc  
  801b86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b89:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b95:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b98:	eb 46                	jmp    801be0 <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b9a:	0f 31                	rdtsc  
  801b9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b9f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801ba2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ba5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801ba8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bab:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801bae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb4:	29 c2                	sub    %eax,%edx
  801bb6:	89 d0                	mov    %edx,%eax
  801bb8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801bbb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc1:	89 d1                	mov    %edx,%ecx
  801bc3:	29 c1                	sub    %eax,%ecx
  801bc5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bcb:	39 c2                	cmp    %eax,%edx
  801bcd:	0f 97 c0             	seta   %al
  801bd0:	0f b6 c0             	movzbl %al,%eax
  801bd3:	29 c1                	sub    %eax,%ecx
  801bd5:	89 c8                	mov    %ecx,%eax
  801bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801bda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801be6:	72 b2                	jb     801b9a <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801bf8:	eb 03                	jmp    801bfd <busy_wait+0x12>
  801bfa:	ff 45 fc             	incl   -0x4(%ebp)
  801bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c00:	3b 45 08             	cmp    0x8(%ebp),%eax
  801c03:	72 f5                	jb     801bfa <busy_wait+0xf>
	return i;
  801c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    
  801c0a:	66 90                	xchg   %ax,%ax

00801c0c <__udivdi3>:
  801c0c:	55                   	push   %ebp
  801c0d:	57                   	push   %edi
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 1c             	sub    $0x1c,%esp
  801c13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c23:	89 ca                	mov    %ecx,%edx
  801c25:	89 f8                	mov    %edi,%eax
  801c27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c2b:	85 f6                	test   %esi,%esi
  801c2d:	75 2d                	jne    801c5c <__udivdi3+0x50>
  801c2f:	39 cf                	cmp    %ecx,%edi
  801c31:	77 65                	ja     801c98 <__udivdi3+0x8c>
  801c33:	89 fd                	mov    %edi,%ebp
  801c35:	85 ff                	test   %edi,%edi
  801c37:	75 0b                	jne    801c44 <__udivdi3+0x38>
  801c39:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3e:	31 d2                	xor    %edx,%edx
  801c40:	f7 f7                	div    %edi
  801c42:	89 c5                	mov    %eax,%ebp
  801c44:	31 d2                	xor    %edx,%edx
  801c46:	89 c8                	mov    %ecx,%eax
  801c48:	f7 f5                	div    %ebp
  801c4a:	89 c1                	mov    %eax,%ecx
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	f7 f5                	div    %ebp
  801c50:	89 cf                	mov    %ecx,%edi
  801c52:	89 fa                	mov    %edi,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	77 28                	ja     801c88 <__udivdi3+0x7c>
  801c60:	0f bd fe             	bsr    %esi,%edi
  801c63:	83 f7 1f             	xor    $0x1f,%edi
  801c66:	75 40                	jne    801ca8 <__udivdi3+0x9c>
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	72 0a                	jb     801c76 <__udivdi3+0x6a>
  801c6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c70:	0f 87 9e 00 00 00    	ja     801d14 <__udivdi3+0x108>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	89 fa                	mov    %edi,%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	31 ff                	xor    %edi,%edi
  801c8a:	31 c0                	xor    %eax,%eax
  801c8c:	89 fa                	mov    %edi,%edx
  801c8e:	83 c4 1c             	add    $0x1c,%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	f7 f7                	div    %edi
  801c9c:	31 ff                	xor    %edi,%edi
  801c9e:	89 fa                	mov    %edi,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cad:	89 eb                	mov    %ebp,%ebx
  801caf:	29 fb                	sub    %edi,%ebx
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	d3 e6                	shl    %cl,%esi
  801cb5:	89 c5                	mov    %eax,%ebp
  801cb7:	88 d9                	mov    %bl,%cl
  801cb9:	d3 ed                	shr    %cl,%ebp
  801cbb:	89 e9                	mov    %ebp,%ecx
  801cbd:	09 f1                	or     %esi,%ecx
  801cbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e0                	shl    %cl,%eax
  801cc7:	89 c5                	mov    %eax,%ebp
  801cc9:	89 d6                	mov    %edx,%esi
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 ee                	shr    %cl,%esi
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e2                	shl    %cl,%edx
  801cd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 e8                	shr    %cl,%eax
  801cdb:	09 c2                	or     %eax,%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	f7 74 24 0c          	divl   0xc(%esp)
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	f7 e5                	mul    %ebp
  801ceb:	39 d6                	cmp    %edx,%esi
  801ced:	72 19                	jb     801d08 <__udivdi3+0xfc>
  801cef:	74 0b                	je     801cfc <__udivdi3+0xf0>
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	31 ff                	xor    %edi,%edi
  801cf5:	e9 58 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d00:	89 f9                	mov    %edi,%ecx
  801d02:	d3 e2                	shl    %cl,%edx
  801d04:	39 c2                	cmp    %eax,%edx
  801d06:	73 e9                	jae    801cf1 <__udivdi3+0xe5>
  801d08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d0b:	31 ff                	xor    %edi,%edi
  801d0d:	e9 40 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	31 c0                	xor    %eax,%eax
  801d16:	e9 37 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d1b:	90                   	nop

00801d1c <__umoddi3>:
  801d1c:	55                   	push   %ebp
  801d1d:	57                   	push   %edi
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 1c             	sub    $0x1c,%esp
  801d23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3b:	89 f3                	mov    %esi,%ebx
  801d3d:	89 fa                	mov    %edi,%edx
  801d3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d43:	89 34 24             	mov    %esi,(%esp)
  801d46:	85 c0                	test   %eax,%eax
  801d48:	75 1a                	jne    801d64 <__umoddi3+0x48>
  801d4a:	39 f7                	cmp    %esi,%edi
  801d4c:	0f 86 a2 00 00 00    	jbe    801df4 <__umoddi3+0xd8>
  801d52:	89 c8                	mov    %ecx,%eax
  801d54:	89 f2                	mov    %esi,%edx
  801d56:	f7 f7                	div    %edi
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	31 d2                	xor    %edx,%edx
  801d5c:	83 c4 1c             	add    $0x1c,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
  801d64:	39 f0                	cmp    %esi,%eax
  801d66:	0f 87 ac 00 00 00    	ja     801e18 <__umoddi3+0xfc>
  801d6c:	0f bd e8             	bsr    %eax,%ebp
  801d6f:	83 f5 1f             	xor    $0x1f,%ebp
  801d72:	0f 84 ac 00 00 00    	je     801e24 <__umoddi3+0x108>
  801d78:	bf 20 00 00 00       	mov    $0x20,%edi
  801d7d:	29 ef                	sub    %ebp,%edi
  801d7f:	89 fe                	mov    %edi,%esi
  801d81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e0                	shl    %cl,%eax
  801d89:	89 d7                	mov    %edx,%edi
  801d8b:	89 f1                	mov    %esi,%ecx
  801d8d:	d3 ef                	shr    %cl,%edi
  801d8f:	09 c7                	or     %eax,%edi
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e2                	shl    %cl,%edx
  801d95:	89 14 24             	mov    %edx,(%esp)
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	d3 e0                	shl    %cl,%eax
  801d9c:	89 c2                	mov    %eax,%edx
  801d9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da2:	d3 e0                	shl    %cl,%eax
  801da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dac:	89 f1                	mov    %esi,%ecx
  801dae:	d3 e8                	shr    %cl,%eax
  801db0:	09 d0                	or     %edx,%eax
  801db2:	d3 eb                	shr    %cl,%ebx
  801db4:	89 da                	mov    %ebx,%edx
  801db6:	f7 f7                	div    %edi
  801db8:	89 d3                	mov    %edx,%ebx
  801dba:	f7 24 24             	mull   (%esp)
  801dbd:	89 c6                	mov    %eax,%esi
  801dbf:	89 d1                	mov    %edx,%ecx
  801dc1:	39 d3                	cmp    %edx,%ebx
  801dc3:	0f 82 87 00 00 00    	jb     801e50 <__umoddi3+0x134>
  801dc9:	0f 84 91 00 00 00    	je     801e60 <__umoddi3+0x144>
  801dcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd3:	29 f2                	sub    %esi,%edx
  801dd5:	19 cb                	sbb    %ecx,%ebx
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ddd:	d3 e0                	shl    %cl,%eax
  801ddf:	89 e9                	mov    %ebp,%ecx
  801de1:	d3 ea                	shr    %cl,%edx
  801de3:	09 d0                	or     %edx,%eax
  801de5:	89 e9                	mov    %ebp,%ecx
  801de7:	d3 eb                	shr    %cl,%ebx
  801de9:	89 da                	mov    %ebx,%edx
  801deb:	83 c4 1c             	add    $0x1c,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    
  801df3:	90                   	nop
  801df4:	89 fd                	mov    %edi,%ebp
  801df6:	85 ff                	test   %edi,%edi
  801df8:	75 0b                	jne    801e05 <__umoddi3+0xe9>
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	31 d2                	xor    %edx,%edx
  801e01:	f7 f7                	div    %edi
  801e03:	89 c5                	mov    %eax,%ebp
  801e05:	89 f0                	mov    %esi,%eax
  801e07:	31 d2                	xor    %edx,%edx
  801e09:	f7 f5                	div    %ebp
  801e0b:	89 c8                	mov    %ecx,%eax
  801e0d:	f7 f5                	div    %ebp
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	e9 44 ff ff ff       	jmp    801d5a <__umoddi3+0x3e>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	89 c8                	mov    %ecx,%eax
  801e1a:	89 f2                	mov    %esi,%edx
  801e1c:	83 c4 1c             	add    $0x1c,%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
  801e24:	3b 04 24             	cmp    (%esp),%eax
  801e27:	72 06                	jb     801e2f <__umoddi3+0x113>
  801e29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e2d:	77 0f                	ja     801e3e <__umoddi3+0x122>
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	29 f9                	sub    %edi,%ecx
  801e33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e37:	89 14 24             	mov    %edx,(%esp)
  801e3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e42:	8b 14 24             	mov    (%esp),%edx
  801e45:	83 c4 1c             	add    $0x1c,%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5f                   	pop    %edi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	2b 04 24             	sub    (%esp),%eax
  801e53:	19 fa                	sbb    %edi,%edx
  801e55:	89 d1                	mov    %edx,%ecx
  801e57:	89 c6                	mov    %eax,%esi
  801e59:	e9 71 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e64:	72 ea                	jb     801e50 <__umoddi3+0x134>
  801e66:	89 d9                	mov    %ebx,%ecx
  801e68:	e9 62 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
