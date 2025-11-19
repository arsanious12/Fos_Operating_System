
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
  800044:	e8 45 18 00 00       	call   80188e <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int id = sys_getenvindex();
  80004c:	e8 24 18 00 00       	call   801875 <sys_getenvindex>
  800051:	89 45 e0             	mov    %eax,-0x20(%ebp)

	cprintf_colored(TEXT_light_blue, "%d: before the critical section\n", id);
  800054:	83 ec 04             	sub    $0x4,%esp
  800057:	ff 75 e0             	pushl  -0x20(%ebp)
  80005a:	68 60 1e 80 00       	push   $0x801e60
  80005f:	6a 09                	push   $0x9
  800061:	e8 6f 06 00 00       	call   8006d5 <cprintf_colored>
  800066:	83 c4 10             	add    $0x10,%esp
	//wait_semaphore(cs1);
	char waitCmd[64] = "__KSem@0@Wait";
  800069:	8d 45 98             	lea    -0x68(%ebp),%eax
  80006c:	bb 8a 1f 80 00       	mov    $0x801f8a,%ebx
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
  800095:	e8 11 1a 00 00       	call   801aab <sys_utilities>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf_colored(TEXT_light_cyan, "%d: inside the critical section\n", id) ;
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8000a3:	68 84 1e 80 00       	push   $0x801e84
  8000a8:	6a 0b                	push   $0xb
  8000aa:	e8 26 06 00 00       	call   8006d5 <cprintf_colored>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_cyan, "my ID is %d\n", id);
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000b8:	68 a5 1e 80 00       	push   $0x801ea5
  8000bd:	6a 0b                	push   $0xb
  8000bf:	e8 11 06 00 00       	call   8006d5 <cprintf_colored>
  8000c4:	83 c4 10             	add    $0x10,%esp
		int sem1val ;
		char getCmd[64] = "__KSem@0@Get";
  8000c7:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000cd:	bb ca 1f 80 00       	mov    $0x801fca,%ebx
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
  800101:	e8 a5 19 00 00       	call   801aab <sys_utilities>
  800106:	83 c4 10             	add    $0x10,%esp
		if (sem1val > 0)
  800109:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80010f:	85 c0                	test   %eax,%eax
  800111:	7e 14                	jle    800127 <_main+0xef>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 b4 1e 80 00       	push   $0x801eb4
  80011b:	6a 17                	push   $0x17
  80011d:	68 0b 1f 80 00       	push   $0x801f0b
  800122:	e8 b3 02 00 00       	call   8003da <_panic>
		env_sleep(RAND(1000, 5000)) ;
  800127:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	50                   	push   %eax
  80012e:	e8 8e 17 00 00       	call   8018c1 <sys_get_virtual_time>
  800133:	83 c4 0c             	add    $0xc,%esp
  800136:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800139:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	f7 f1                	div    %ecx
  800145:	89 d0                	mov    %edx,%eax
  800147:	05 e8 03 00 00       	add    $0x3e8,%eax
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	50                   	push   %eax
  800150:	e8 e2 19 00 00       	call   801b37 <env_sleep>
  800155:	83 c4 10             	add    $0x10,%esp
		cprintf_colored(TEXT_light_blue, "%d: leaving the critical section...\n", id);
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	ff 75 e0             	pushl  -0x20(%ebp)
  80015e:	68 28 1f 80 00       	push   $0x801f28
  800163:	6a 09                	push   $0x9
  800165:	e8 6b 05 00 00       	call   8006d5 <cprintf_colored>
  80016a:	83 c4 10             	add    $0x10,%esp
	}
	char signalCmd1[64] = "__KSem@0@Signal";
  80016d:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  800173:	bb 0a 20 80 00       	mov    $0x80200a,%ebx
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
  8001a5:	e8 01 19 00 00       	call   801aab <sys_utilities>
  8001aa:	83 c4 10             	add    $0x10,%esp
	//signal_semaphore(cs1);
	cprintf_colored(TEXT_light_blue, "%d: after the critical section\n", id);
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b3:	68 50 1f 80 00       	push   $0x801f50
  8001b8:	6a 09                	push   $0x9
  8001ba:	e8 16 05 00 00       	call   8006d5 <cprintf_colored>
  8001bf:	83 c4 10             	add    $0x10,%esp

	//signal_semaphore(depend1);
	char signalCmd2[64] = "__KSem@1@Signal";
  8001c2:	8d 85 18 ff ff ff    	lea    -0xe8(%ebp),%eax
  8001c8:	bb 4a 20 80 00       	mov    $0x80204a,%ebx
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
  8001fa:	e8 ac 18 00 00       	call   801aab <sys_utilities>
  8001ff:	83 c4 10             	add    $0x10,%esp

	cprintf_colored(TEXT_light_magenta, ">>> Slave %d is Finished\n", id);
  800202:	83 ec 04             	sub    $0x4,%esp
  800205:	ff 75 e0             	pushl  -0x20(%ebp)
  800208:	68 70 1f 80 00       	push   $0x801f70
  80020d:	6a 0d                	push   $0xd
  80020f:	e8 c1 04 00 00       	call   8006d5 <cprintf_colored>
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
  800233:	e8 3d 16 00 00       	call   801875 <sys_getenvindex>
  800238:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80023b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80023e:	89 d0                	mov    %edx,%eax
  800240:	c1 e0 02             	shl    $0x2,%eax
  800243:	01 d0                	add    %edx,%eax
  800245:	c1 e0 03             	shl    $0x3,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 02             	shl    $0x2,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8a 40 20             	mov    0x20(%eax),%al
  800268:	84 c0                	test   %al,%al
  80026a:	74 0d                	je     800279 <libmain+0x4f>
		binaryname = myEnv->prog_name;
  80026c:	a1 20 30 80 00       	mov    0x803020,%eax
  800271:	83 c0 20             	add    $0x20,%eax
  800274:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80027d:	7e 0a                	jle    800289 <libmain+0x5f>
		binaryname = argv[0];
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 a1 fd ff ff       	call   800038 <_main>
  800297:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80029a:	a1 00 30 80 00       	mov    0x803000,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	0f 84 01 01 00 00    	je     8003a8 <libmain+0x17e>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002a7:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002ad:	bb 84 21 80 00       	mov    $0x802184,%ebx
  8002b2:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002bf:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002c2:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002c7:	b0 00                	mov    $0x0,%al
  8002c9:	89 d7                	mov    %edx,%edi
  8002cb:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8002cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8002d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002d7:	83 ec 08             	sub    $0x8,%esp
  8002da:	50                   	push   %eax
  8002db:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002e1:	50                   	push   %eax
  8002e2:	e8 c4 17 00 00       	call   801aab <sys_utilities>
  8002e7:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8002ea:	e8 0d 13 00 00       	call   8015fc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 a4 20 80 00       	push   $0x8020a4
  8002f7:	e8 ac 03 00 00       	call   8006a8 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8002ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	74 18                	je     80031e <libmain+0xf4>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800306:	e8 be 17 00 00       	call   801ac9 <sys_get_optimal_num_faults>
  80030b:	83 ec 08             	sub    $0x8,%esp
  80030e:	50                   	push   %eax
  80030f:	68 cc 20 80 00       	push   $0x8020cc
  800314:	e8 8f 03 00 00       	call   8006a8 <cprintf>
  800319:	83 c4 10             	add    $0x10,%esp
  80031c:	eb 59                	jmp    800377 <libmain+0x14d>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80031e:	a1 20 30 80 00       	mov    0x803020,%eax
  800323:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800329:	a1 20 30 80 00       	mov    0x803020,%eax
  80032e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	52                   	push   %edx
  800338:	50                   	push   %eax
  800339:	68 f0 20 80 00       	push   $0x8020f0
  80033e:	e8 65 03 00 00       	call   8006a8 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800346:	a1 20 30 80 00       	mov    0x803020,%eax
  80034b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800351:	a1 20 30 80 00       	mov    0x803020,%eax
  800356:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80035c:	a1 20 30 80 00       	mov    0x803020,%eax
  800361:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800367:	51                   	push   %ecx
  800368:	52                   	push   %edx
  800369:	50                   	push   %eax
  80036a:	68 18 21 80 00       	push   $0x802118
  80036f:	e8 34 03 00 00       	call   8006a8 <cprintf>
  800374:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800377:	a1 20 30 80 00       	mov    0x803020,%eax
  80037c:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	50                   	push   %eax
  800386:	68 70 21 80 00       	push   $0x802170
  80038b:	e8 18 03 00 00       	call   8006a8 <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	68 a4 20 80 00       	push   $0x8020a4
  80039b:	e8 08 03 00 00       	call   8006a8 <cprintf>
  8003a0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003a3:	e8 6e 12 00 00       	call   801616 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003a8:	e8 1f 00 00 00       	call   8003cc <exit>
}
  8003ad:	90                   	nop
  8003ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b1:	5b                   	pop    %ebx
  8003b2:	5e                   	pop    %esi
  8003b3:	5f                   	pop    %edi
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003bc:	83 ec 0c             	sub    $0xc,%esp
  8003bf:	6a 00                	push   $0x0
  8003c1:	e8 7b 14 00 00       	call   801841 <sys_destroy_env>
  8003c6:	83 c4 10             	add    $0x10,%esp
}
  8003c9:	90                   	nop
  8003ca:	c9                   	leave  
  8003cb:	c3                   	ret    

008003cc <exit>:

void
exit(void)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003d2:	e8 d0 14 00 00       	call   8018a7 <sys_exit_env>
}
  8003d7:	90                   	nop
  8003d8:	c9                   	leave  
  8003d9:	c3                   	ret    

008003da <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003e0:	8d 45 10             	lea    0x10(%ebp),%eax
  8003e3:	83 c0 04             	add    $0x4,%eax
  8003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003e9:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003ee:	85 c0                	test   %eax,%eax
  8003f0:	74 16                	je     800408 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003f2:	a1 18 b1 81 00       	mov    0x81b118,%eax
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	50                   	push   %eax
  8003fb:	68 e8 21 80 00       	push   $0x8021e8
  800400:	e8 a3 02 00 00       	call   8006a8 <cprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800408:	a1 04 30 80 00       	mov    0x803004,%eax
  80040d:	83 ec 0c             	sub    $0xc,%esp
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	50                   	push   %eax
  800417:	68 f0 21 80 00       	push   $0x8021f0
  80041c:	6a 74                	push   $0x74
  80041e:	e8 b2 02 00 00       	call   8006d5 <cprintf_colored>
  800423:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800426:	8b 45 10             	mov    0x10(%ebp),%eax
  800429:	83 ec 08             	sub    $0x8,%esp
  80042c:	ff 75 f4             	pushl  -0xc(%ebp)
  80042f:	50                   	push   %eax
  800430:	e8 04 02 00 00       	call   800639 <vcprintf>
  800435:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	6a 00                	push   $0x0
  80043d:	68 18 22 80 00       	push   $0x802218
  800442:	e8 f2 01 00 00       	call   800639 <vcprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80044a:	e8 7d ff ff ff       	call   8003cc <exit>

	// should not return here
	while (1) ;
  80044f:	eb fe                	jmp    80044f <_panic+0x75>

00800451 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800457:	a1 20 30 80 00       	mov    0x803020,%eax
  80045c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800462:	8b 45 0c             	mov    0xc(%ebp),%eax
  800465:	39 c2                	cmp    %eax,%edx
  800467:	74 14                	je     80047d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800469:	83 ec 04             	sub    $0x4,%esp
  80046c:	68 1c 22 80 00       	push   $0x80221c
  800471:	6a 26                	push   $0x26
  800473:	68 68 22 80 00       	push   $0x802268
  800478:	e8 5d ff ff ff       	call   8003da <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80047d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80048b:	e9 c5 00 00 00       	jmp    800555 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800493:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	85 c0                	test   %eax,%eax
  8004a3:	75 08                	jne    8004ad <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004a5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004a8:	e9 a5 00 00 00       	jmp    800552 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004bb:	eb 69                	jmp    800526 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004cb:	89 d0                	mov    %edx,%eax
  8004cd:	01 c0                	add    %eax,%eax
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	c1 e0 03             	shl    $0x3,%eax
  8004d4:	01 c8                	add    %ecx,%eax
  8004d6:	8a 40 04             	mov    0x4(%eax),%al
  8004d9:	84 c0                	test   %al,%al
  8004db:	75 46                	jne    800523 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e2:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  8004e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	01 c0                	add    %eax,%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	c1 e0 03             	shl    $0x3,%eax
  8004f4:	01 c8                	add    %ecx,%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800503:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800508:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	01 c8                	add    %ecx,%eax
  800514:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800516:	39 c2                	cmp    %eax,%edx
  800518:	75 09                	jne    800523 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80051a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800521:	eb 15                	jmp    800538 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800523:	ff 45 e8             	incl   -0x18(%ebp)
  800526:	a1 20 30 80 00       	mov    0x803020,%eax
  80052b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800534:	39 c2                	cmp    %eax,%edx
  800536:	77 85                	ja     8004bd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80053c:	75 14                	jne    800552 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80053e:	83 ec 04             	sub    $0x4,%esp
  800541:	68 74 22 80 00       	push   $0x802274
  800546:	6a 3a                	push   $0x3a
  800548:	68 68 22 80 00       	push   $0x802268
  80054d:	e8 88 fe ff ff       	call   8003da <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800552:	ff 45 f0             	incl   -0x10(%ebp)
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80055b:	0f 8c 2f ff ff ff    	jl     800490 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800561:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800568:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80056f:	eb 26                	jmp    800597 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800571:	a1 20 30 80 00       	mov    0x803020,%eax
  800576:	8b 88 90 05 00 00    	mov    0x590(%eax),%ecx
  80057c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	01 c0                	add    %eax,%eax
  800583:	01 d0                	add    %edx,%eax
  800585:	c1 e0 03             	shl    $0x3,%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	8a 40 04             	mov    0x4(%eax),%al
  80058d:	3c 01                	cmp    $0x1,%al
  80058f:	75 03                	jne    800594 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800591:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800594:	ff 45 e0             	incl   -0x20(%ebp)
  800597:	a1 20 30 80 00       	mov    0x803020,%eax
  80059c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a5:	39 c2                	cmp    %eax,%edx
  8005a7:	77 c8                	ja     800571 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005af:	74 14                	je     8005c5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 c8 22 80 00       	push   $0x8022c8
  8005b9:	6a 44                	push   $0x44
  8005bb:	68 68 22 80 00       	push   $0x802268
  8005c0:	e8 15 fe ff ff       	call   8003da <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005c5:	90                   	nop
  8005c6:	c9                   	leave  
  8005c7:	c3                   	ret    

008005c8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	53                   	push   %ebx
  8005cc:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8005d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005da:	89 0a                	mov    %ecx,(%edx)
  8005dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005df:	88 d1                	mov    %dl,%cl
  8005e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005f2:	75 30                	jne    800624 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  8005f4:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  8005fa:	a0 44 30 80 00       	mov    0x803044,%al
  8005ff:	0f b6 c0             	movzbl %al,%eax
  800602:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800605:	8b 09                	mov    (%ecx),%ecx
  800607:	89 cb                	mov    %ecx,%ebx
  800609:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80060c:	83 c1 08             	add    $0x8,%ecx
  80060f:	52                   	push   %edx
  800610:	50                   	push   %eax
  800611:	53                   	push   %ebx
  800612:	51                   	push   %ecx
  800613:	e8 a0 0f 00 00       	call   8015b8 <sys_cputs>
  800618:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800624:	8b 45 0c             	mov    0xc(%ebp),%eax
  800627:	8b 40 04             	mov    0x4(%eax),%eax
  80062a:	8d 50 01             	lea    0x1(%eax),%edx
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	89 50 04             	mov    %edx,0x4(%eax)
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
  80063c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800642:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800649:	00 00 00 
	b.cnt = 0;
  80064c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800653:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800656:	ff 75 0c             	pushl  0xc(%ebp)
  800659:	ff 75 08             	pushl  0x8(%ebp)
  80065c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800662:	50                   	push   %eax
  800663:	68 c8 05 80 00       	push   $0x8005c8
  800668:	e8 5a 02 00 00       	call   8008c7 <vprintfmt>
  80066d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800670:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800676:	a0 44 30 80 00       	mov    0x803044,%al
  80067b:	0f b6 c0             	movzbl %al,%eax
  80067e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	51                   	push   %ecx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 22 0f 00 00       	call   8015b8 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 6f ff ff ff       	call   800639 <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006db:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	c1 e0 08             	shl    $0x8,%eax
  8006e8:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  8006ed:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f0:	83 c0 04             	add    $0x4,%eax
  8006f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f9:	83 ec 08             	sub    $0x8,%esp
  8006fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ff:	50                   	push   %eax
  800700:	e8 34 ff ff ff       	call   800639 <vcprintf>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80070b:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  800712:	07 00 00 

	return cnt;
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800720:	e8 d7 0e 00 00       	call   8015fc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800725:	8d 45 0c             	lea    0xc(%ebp),%eax
  800728:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 f4             	pushl  -0xc(%ebp)
  800734:	50                   	push   %eax
  800735:	e8 ff fe ff ff       	call   800639 <vcprintf>
  80073a:	83 c4 10             	add    $0x10,%esp
  80073d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800740:	e8 d1 0e 00 00       	call   801616 <sys_unlock_cons>
	return cnt;
  800745:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	53                   	push   %ebx
  80074e:	83 ec 14             	sub    $0x14,%esp
  800751:	8b 45 10             	mov    0x10(%ebp),%eax
  800754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075d:	8b 45 18             	mov    0x18(%ebp),%eax
  800760:	ba 00 00 00 00       	mov    $0x0,%edx
  800765:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800768:	77 55                	ja     8007bf <printnum+0x75>
  80076a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80076d:	72 05                	jb     800774 <printnum+0x2a>
  80076f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800772:	77 4b                	ja     8007bf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800774:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800777:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80077a:	8b 45 18             	mov    0x18(%ebp),%eax
  80077d:	ba 00 00 00 00       	mov    $0x0,%edx
  800782:	52                   	push   %edx
  800783:	50                   	push   %eax
  800784:	ff 75 f4             	pushl  -0xc(%ebp)
  800787:	ff 75 f0             	pushl  -0x10(%ebp)
  80078a:	e8 69 14 00 00       	call   801bf8 <__udivdi3>
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	83 ec 04             	sub    $0x4,%esp
  800795:	ff 75 20             	pushl  0x20(%ebp)
  800798:	53                   	push   %ebx
  800799:	ff 75 18             	pushl  0x18(%ebp)
  80079c:	52                   	push   %edx
  80079d:	50                   	push   %eax
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	ff 75 08             	pushl  0x8(%ebp)
  8007a4:	e8 a1 ff ff ff       	call   80074a <printnum>
  8007a9:	83 c4 20             	add    $0x20,%esp
  8007ac:	eb 1a                	jmp    8007c8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	ff 75 0c             	pushl  0xc(%ebp)
  8007b4:	ff 75 20             	pushl  0x20(%ebp)
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	ff d0                	call   *%eax
  8007bc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007bf:	ff 4d 1c             	decl   0x1c(%ebp)
  8007c2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007c6:	7f e6                	jg     8007ae <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	53                   	push   %ebx
  8007d7:	51                   	push   %ecx
  8007d8:	52                   	push   %edx
  8007d9:	50                   	push   %eax
  8007da:	e8 29 15 00 00       	call   801d08 <__umoddi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	05 34 25 80 00       	add    $0x802534,%eax
  8007e7:	8a 00                	mov    (%eax),%al
  8007e9:	0f be c0             	movsbl %al,%eax
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	50                   	push   %eax
  8007f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f6:	ff d0                	call   *%eax
  8007f8:	83 c4 10             	add    $0x10,%esp
}
  8007fb:	90                   	nop
  8007fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ff:	c9                   	leave  
  800800:	c3                   	ret    

00800801 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800804:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800808:	7e 1c                	jle    800826 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 00                	mov    (%eax),%eax
  80080f:	8d 50 08             	lea    0x8(%eax),%edx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	89 10                	mov    %edx,(%eax)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	83 e8 08             	sub    $0x8,%eax
  80081f:	8b 50 04             	mov    0x4(%eax),%edx
  800822:	8b 00                	mov    (%eax),%eax
  800824:	eb 40                	jmp    800866 <getuint+0x65>
	else if (lflag)
  800826:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082a:	74 1e                	je     80084a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 00                	mov    (%eax),%eax
  800843:	ba 00 00 00 00       	mov    $0x0,%edx
  800848:	eb 1c                	jmp    800866 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	8d 50 04             	lea    0x4(%eax),%edx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	89 10                	mov    %edx,(%eax)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 00                	mov    (%eax),%eax
  80085c:	83 e8 04             	sub    $0x4,%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80086b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80086f:	7e 1c                	jle    80088d <getint+0x25>
		return va_arg(*ap, long long);
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	8d 50 08             	lea    0x8(%eax),%edx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	89 10                	mov    %edx,(%eax)
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 00                	mov    (%eax),%eax
  800883:	83 e8 08             	sub    $0x8,%eax
  800886:	8b 50 04             	mov    0x4(%eax),%edx
  800889:	8b 00                	mov    (%eax),%eax
  80088b:	eb 38                	jmp    8008c5 <getint+0x5d>
	else if (lflag)
  80088d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800891:	74 1a                	je     8008ad <getint+0x45>
		return va_arg(*ap, long);
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 00                	mov    (%eax),%eax
  800898:	8d 50 04             	lea    0x4(%eax),%edx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	89 10                	mov    %edx,(%eax)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 00                	mov    (%eax),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	99                   	cltd   
  8008ab:	eb 18                	jmp    8008c5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 00                	mov    (%eax),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 10                	mov    %edx,(%eax)
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 00                	mov    (%eax),%eax
  8008bf:	83 e8 04             	sub    $0x4,%eax
  8008c2:	8b 00                	mov    (%eax),%eax
  8008c4:	99                   	cltd   
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	56                   	push   %esi
  8008cb:	53                   	push   %ebx
  8008cc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008cf:	eb 17                	jmp    8008e8 <vprintfmt+0x21>
			if (ch == '\0')
  8008d1:	85 db                	test   %ebx,%ebx
  8008d3:	0f 84 c1 03 00 00    	je     800c9a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008d9:	83 ec 08             	sub    $0x8,%esp
  8008dc:	ff 75 0c             	pushl  0xc(%ebp)
  8008df:	53                   	push   %ebx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	ff d0                	call   *%eax
  8008e5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008eb:	8d 50 01             	lea    0x1(%eax),%edx
  8008ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8008f1:	8a 00                	mov    (%eax),%al
  8008f3:	0f b6 d8             	movzbl %al,%ebx
  8008f6:	83 fb 25             	cmp    $0x25,%ebx
  8008f9:	75 d6                	jne    8008d1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008fb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ff:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80090d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800914:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091b:	8b 45 10             	mov    0x10(%ebp),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	89 55 10             	mov    %edx,0x10(%ebp)
  800924:	8a 00                	mov    (%eax),%al
  800926:	0f b6 d8             	movzbl %al,%ebx
  800929:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80092c:	83 f8 5b             	cmp    $0x5b,%eax
  80092f:	0f 87 3d 03 00 00    	ja     800c72 <vprintfmt+0x3ab>
  800935:	8b 04 85 58 25 80 00 	mov    0x802558(,%eax,4),%eax
  80093c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80093e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800942:	eb d7                	jmp    80091b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800944:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800948:	eb d1                	jmp    80091b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80094a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800951:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800954:	89 d0                	mov    %edx,%eax
  800956:	c1 e0 02             	shl    $0x2,%eax
  800959:	01 d0                	add    %edx,%eax
  80095b:	01 c0                	add    %eax,%eax
  80095d:	01 d8                	add    %ebx,%eax
  80095f:	83 e8 30             	sub    $0x30,%eax
  800962:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800965:	8b 45 10             	mov    0x10(%ebp),%eax
  800968:	8a 00                	mov    (%eax),%al
  80096a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80096d:	83 fb 2f             	cmp    $0x2f,%ebx
  800970:	7e 3e                	jle    8009b0 <vprintfmt+0xe9>
  800972:	83 fb 39             	cmp    $0x39,%ebx
  800975:	7f 39                	jg     8009b0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800977:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80097a:	eb d5                	jmp    800951 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80097c:	8b 45 14             	mov    0x14(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 14             	mov    %eax,0x14(%ebp)
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 e8 04             	sub    $0x4,%eax
  80098b:	8b 00                	mov    (%eax),%eax
  80098d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800990:	eb 1f                	jmp    8009b1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800992:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800996:	79 83                	jns    80091b <vprintfmt+0x54>
				width = 0;
  800998:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80099f:	e9 77 ff ff ff       	jmp    80091b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009a4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009ab:	e9 6b ff ff ff       	jmp    80091b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009b0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b5:	0f 89 60 ff ff ff    	jns    80091b <vprintfmt+0x54>
				width = precision, precision = -1;
  8009bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009c8:	e9 4e ff ff ff       	jmp    80091b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009cd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009d0:	e9 46 ff ff ff       	jmp    80091b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 c0 04             	add    $0x4,%eax
  8009db:	89 45 14             	mov    %eax,0x14(%ebp)
  8009de:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e1:	83 e8 04             	sub    $0x4,%eax
  8009e4:	8b 00                	mov    (%eax),%eax
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	50                   	push   %eax
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
			break;
  8009f5:	e9 9b 02 00 00       	jmp    800c95 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fd:	83 c0 04             	add    $0x4,%eax
  800a00:	89 45 14             	mov    %eax,0x14(%ebp)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 e8 04             	sub    $0x4,%eax
  800a09:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a0b:	85 db                	test   %ebx,%ebx
  800a0d:	79 02                	jns    800a11 <vprintfmt+0x14a>
				err = -err;
  800a0f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a11:	83 fb 64             	cmp    $0x64,%ebx
  800a14:	7f 0b                	jg     800a21 <vprintfmt+0x15a>
  800a16:	8b 34 9d a0 23 80 00 	mov    0x8023a0(,%ebx,4),%esi
  800a1d:	85 f6                	test   %esi,%esi
  800a1f:	75 19                	jne    800a3a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a21:	53                   	push   %ebx
  800a22:	68 45 25 80 00       	push   $0x802545
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 70 02 00 00       	call   800ca2 <printfmt>
  800a32:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a35:	e9 5b 02 00 00       	jmp    800c95 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a3a:	56                   	push   %esi
  800a3b:	68 4e 25 80 00       	push   $0x80254e
  800a40:	ff 75 0c             	pushl  0xc(%ebp)
  800a43:	ff 75 08             	pushl  0x8(%ebp)
  800a46:	e8 57 02 00 00       	call   800ca2 <printfmt>
  800a4b:	83 c4 10             	add    $0x10,%esp
			break;
  800a4e:	e9 42 02 00 00       	jmp    800c95 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 c0 04             	add    $0x4,%eax
  800a59:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5f:	83 e8 04             	sub    $0x4,%eax
  800a62:	8b 30                	mov    (%eax),%esi
  800a64:	85 f6                	test   %esi,%esi
  800a66:	75 05                	jne    800a6d <vprintfmt+0x1a6>
				p = "(null)";
  800a68:	be 51 25 80 00       	mov    $0x802551,%esi
			if (width > 0 && padc != '-')
  800a6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a71:	7e 6d                	jle    800ae0 <vprintfmt+0x219>
  800a73:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a77:	74 67                	je     800ae0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	50                   	push   %eax
  800a80:	56                   	push   %esi
  800a81:	e8 1e 03 00 00       	call   800da4 <strnlen>
  800a86:	83 c4 10             	add    $0x10,%esp
  800a89:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a8c:	eb 16                	jmp    800aa4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a8e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a92:	83 ec 08             	sub    $0x8,%esp
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	50                   	push   %eax
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa1:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa8:	7f e4                	jg     800a8e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aaa:	eb 34                	jmp    800ae0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ab0:	74 1c                	je     800ace <vprintfmt+0x207>
  800ab2:	83 fb 1f             	cmp    $0x1f,%ebx
  800ab5:	7e 05                	jle    800abc <vprintfmt+0x1f5>
  800ab7:	83 fb 7e             	cmp    $0x7e,%ebx
  800aba:	7e 12                	jle    800ace <vprintfmt+0x207>
					putch('?', putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	6a 3f                	push   $0x3f
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ff d0                	call   *%eax
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	eb 0f                	jmp    800add <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	53                   	push   %ebx
  800ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad8:	ff d0                	call   *%eax
  800ada:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800add:	ff 4d e4             	decl   -0x1c(%ebp)
  800ae0:	89 f0                	mov    %esi,%eax
  800ae2:	8d 70 01             	lea    0x1(%eax),%esi
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	0f be d8             	movsbl %al,%ebx
  800aea:	85 db                	test   %ebx,%ebx
  800aec:	74 24                	je     800b12 <vprintfmt+0x24b>
  800aee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800af2:	78 b8                	js     800aac <vprintfmt+0x1e5>
  800af4:	ff 4d e0             	decl   -0x20(%ebp)
  800af7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800afb:	79 af                	jns    800aac <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800afd:	eb 13                	jmp    800b12 <vprintfmt+0x24b>
				putch(' ', putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	6a 20                	push   $0x20
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e7                	jg     800aff <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b18:	e9 78 01 00 00       	jmp    800c95 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b1d:	83 ec 08             	sub    $0x8,%esp
  800b20:	ff 75 e8             	pushl  -0x18(%ebp)
  800b23:	8d 45 14             	lea    0x14(%ebp),%eax
  800b26:	50                   	push   %eax
  800b27:	e8 3c fd ff ff       	call   800868 <getint>
  800b2c:	83 c4 10             	add    $0x10,%esp
  800b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b3b:	85 d2                	test   %edx,%edx
  800b3d:	79 23                	jns    800b62 <vprintfmt+0x29b>
				putch('-', putdat);
  800b3f:	83 ec 08             	sub    $0x8,%esp
  800b42:	ff 75 0c             	pushl  0xc(%ebp)
  800b45:	6a 2d                	push   $0x2d
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	ff d0                	call   *%eax
  800b4c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b55:	f7 d8                	neg    %eax
  800b57:	83 d2 00             	adc    $0x0,%edx
  800b5a:	f7 da                	neg    %edx
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b69:	e9 bc 00 00 00       	jmp    800c2a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 e8             	pushl  -0x18(%ebp)
  800b74:	8d 45 14             	lea    0x14(%ebp),%eax
  800b77:	50                   	push   %eax
  800b78:	e8 84 fc ff ff       	call   800801 <getuint>
  800b7d:	83 c4 10             	add    $0x10,%esp
  800b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b83:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b86:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b8d:	e9 98 00 00 00       	jmp    800c2a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 58                	push   $0x58
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ba2:	83 ec 08             	sub    $0x8,%esp
  800ba5:	ff 75 0c             	pushl  0xc(%ebp)
  800ba8:	6a 58                	push   $0x58
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bb2:	83 ec 08             	sub    $0x8,%esp
  800bb5:	ff 75 0c             	pushl  0xc(%ebp)
  800bb8:	6a 58                	push   $0x58
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	e9 ce 00 00 00       	jmp    800c95 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 30                	push   $0x30
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	6a 78                	push   $0x78
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	ff d0                	call   *%eax
  800be4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800be7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bea:	83 c0 04             	add    $0x4,%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	83 e8 04             	sub    $0x4,%eax
  800bf6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c02:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c09:	eb 1f                	jmp    800c2a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 e7 fb ff ff       	call   800801 <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c23:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c2a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c31:	83 ec 04             	sub    $0x4,%esp
  800c34:	52                   	push   %edx
  800c35:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c38:	50                   	push   %eax
  800c39:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c3f:	ff 75 0c             	pushl  0xc(%ebp)
  800c42:	ff 75 08             	pushl  0x8(%ebp)
  800c45:	e8 00 fb ff ff       	call   80074a <printnum>
  800c4a:	83 c4 20             	add    $0x20,%esp
			break;
  800c4d:	eb 46                	jmp    800c95 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	53                   	push   %ebx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	ff d0                	call   *%eax
  800c5b:	83 c4 10             	add    $0x10,%esp
			break;
  800c5e:	eb 35                	jmp    800c95 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c60:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800c67:	eb 2c                	jmp    800c95 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c69:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800c70:	eb 23                	jmp    800c95 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c72:	83 ec 08             	sub    $0x8,%esp
  800c75:	ff 75 0c             	pushl  0xc(%ebp)
  800c78:	6a 25                	push   $0x25
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	ff d0                	call   *%eax
  800c7f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c82:	ff 4d 10             	decl   0x10(%ebp)
  800c85:	eb 03                	jmp    800c8a <vprintfmt+0x3c3>
  800c87:	ff 4d 10             	decl   0x10(%ebp)
  800c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8d:	48                   	dec    %eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	3c 25                	cmp    $0x25,%al
  800c92:	75 f3                	jne    800c87 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c94:	90                   	nop
		}
	}
  800c95:	e9 35 fc ff ff       	jmp    8008cf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c9a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ca8:	8d 45 10             	lea    0x10(%ebp),%eax
  800cab:	83 c0 04             	add    $0x4,%eax
  800cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb7:	50                   	push   %eax
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	ff 75 08             	pushl  0x8(%ebp)
  800cbe:	e8 04 fc ff ff       	call   8008c7 <vprintfmt>
  800cc3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cc6:	90                   	nop
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8b 40 08             	mov    0x8(%eax),%eax
  800cd2:	8d 50 01             	lea    0x1(%eax),%edx
  800cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cde:	8b 10                	mov    (%eax),%edx
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	8b 40 04             	mov    0x4(%eax),%eax
  800ce6:	39 c2                	cmp    %eax,%edx
  800ce8:	73 12                	jae    800cfc <sprintputch+0x33>
		*b->buf++ = ch;
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	8d 48 01             	lea    0x1(%eax),%ecx
  800cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cf5:	89 0a                	mov    %ecx,(%edx)
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	88 10                	mov    %dl,(%eax)
}
  800cfc:	90                   	nop
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	01 d0                	add    %edx,%eax
  800d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d24:	74 06                	je     800d2c <vsnprintf+0x2d>
  800d26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2a:	7f 07                	jg     800d33 <vsnprintf+0x34>
		return -E_INVAL;
  800d2c:	b8 03 00 00 00       	mov    $0x3,%eax
  800d31:	eb 20                	jmp    800d53 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d33:	ff 75 14             	pushl  0x14(%ebp)
  800d36:	ff 75 10             	pushl  0x10(%ebp)
  800d39:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d3c:	50                   	push   %eax
  800d3d:	68 c9 0c 80 00       	push   $0x800cc9
  800d42:	e8 80 fb ff ff       	call   8008c7 <vprintfmt>
  800d47:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d4d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d5b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d5e:	83 c0 04             	add    $0x4,%eax
  800d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d64:	8b 45 10             	mov    0x10(%ebp),%eax
  800d67:	ff 75 f4             	pushl  -0xc(%ebp)
  800d6a:	50                   	push   %eax
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	ff 75 08             	pushl  0x8(%ebp)
  800d71:	e8 89 ff ff ff       	call   800cff <vsnprintf>
  800d76:	83 c4 10             	add    $0x10,%esp
  800d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d8e:	eb 06                	jmp    800d96 <strlen+0x15>
		n++;
  800d90:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d93:	ff 45 08             	incl   0x8(%ebp)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	84 c0                	test   %al,%al
  800d9d:	75 f1                	jne    800d90 <strlen+0xf>
		n++;
	return n;
  800d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db1:	eb 09                	jmp    800dbc <strnlen+0x18>
		n++;
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	ff 4d 0c             	decl   0xc(%ebp)
  800dbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc0:	74 09                	je     800dcb <strnlen+0x27>
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	84 c0                	test   %al,%al
  800dc9:	75 e8                	jne    800db3 <strnlen+0xf>
		n++;
	return n;
  800dcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ddc:	90                   	nop
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8d 50 01             	lea    0x1(%eax),%edx
  800de3:	89 55 08             	mov    %edx,0x8(%ebp)
  800de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800def:	8a 12                	mov    (%edx),%dl
  800df1:	88 10                	mov    %dl,(%eax)
  800df3:	8a 00                	mov    (%eax),%al
  800df5:	84 c0                	test   %al,%al
  800df7:	75 e4                	jne    800ddd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfc:	c9                   	leave  
  800dfd:	c3                   	ret    

00800dfe <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e11:	eb 1f                	jmp    800e32 <strncpy+0x34>
		*dst++ = *src;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8d 50 01             	lea    0x1(%eax),%edx
  800e19:	89 55 08             	mov    %edx,0x8(%ebp)
  800e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1f:	8a 12                	mov    (%edx),%dl
  800e21:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	74 03                	je     800e2f <strncpy+0x31>
			src++;
  800e2c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e2f:	ff 45 fc             	incl   -0x4(%ebp)
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e38:	72 d9                	jb     800e13 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e3d:	c9                   	leave  
  800e3e:	c3                   	ret    

00800e3f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4f:	74 30                	je     800e81 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e51:	eb 16                	jmp    800e69 <strlcpy+0x2a>
			*dst++ = *src++;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8d 50 01             	lea    0x1(%eax),%edx
  800e59:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e62:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e65:	8a 12                	mov    (%edx),%dl
  800e67:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e69:	ff 4d 10             	decl   0x10(%ebp)
  800e6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e70:	74 09                	je     800e7b <strlcpy+0x3c>
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	8a 00                	mov    (%eax),%al
  800e77:	84 c0                	test   %al,%al
  800e79:	75 d8                	jne    800e53 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e87:	29 c2                	sub    %eax,%edx
  800e89:	89 d0                	mov    %edx,%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e90:	eb 06                	jmp    800e98 <strcmp+0xb>
		p++, q++;
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	84 c0                	test   %al,%al
  800e9f:	74 0e                	je     800eaf <strcmp+0x22>
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 10                	mov    (%eax),%dl
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	38 c2                	cmp    %al,%dl
  800ead:	74 e3                	je     800e92 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 d0             	movzbl %al,%edx
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f b6 c0             	movzbl %al,%eax
  800ebf:	29 c2                	sub    %eax,%edx
  800ec1:	89 d0                	mov    %edx,%eax
}
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ec8:	eb 09                	jmp    800ed3 <strncmp+0xe>
		n--, p++, q++;
  800eca:	ff 4d 10             	decl   0x10(%ebp)
  800ecd:	ff 45 08             	incl   0x8(%ebp)
  800ed0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ed3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed7:	74 17                	je     800ef0 <strncmp+0x2b>
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	84 c0                	test   %al,%al
  800ee0:	74 0e                	je     800ef0 <strncmp+0x2b>
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 10                	mov    (%eax),%dl
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	8a 00                	mov    (%eax),%al
  800eec:	38 c2                	cmp    %al,%dl
  800eee:	74 da                	je     800eca <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ef0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef4:	75 07                	jne    800efd <strncmp+0x38>
		return 0;
  800ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  800efb:	eb 14                	jmp    800f11 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f1f:	eb 12                	jmp    800f33 <strchr+0x20>
		if (*s == c)
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f29:	75 05                	jne    800f30 <strchr+0x1d>
			return (char *) s;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	eb 11                	jmp    800f41 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f30:	ff 45 08             	incl   0x8(%ebp)
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	84 c0                	test   %al,%al
  800f3a:	75 e5                	jne    800f21 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f41:	c9                   	leave  
  800f42:	c3                   	ret    

00800f43 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	83 ec 04             	sub    $0x4,%esp
  800f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f4f:	eb 0d                	jmp    800f5e <strfind+0x1b>
		if (*s == c)
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f59:	74 0e                	je     800f69 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f5b:	ff 45 08             	incl   0x8(%ebp)
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	84 c0                	test   %al,%al
  800f65:	75 ea                	jne    800f51 <strfind+0xe>
  800f67:	eb 01                	jmp    800f6a <strfind+0x27>
		if (*s == c)
			break;
  800f69:	90                   	nop
	return (char *) s;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800f7b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800f7f:	76 63                	jbe    800fe4 <memset+0x75>
		uint64 data_block = c;
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	99                   	cltd   
  800f85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f88:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f91:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800f95:	c1 e0 08             	shl    $0x8,%eax
  800f98:	09 45 f0             	or     %eax,-0x10(%ebp)
  800f9b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fa4:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fa8:	c1 e0 10             	shl    $0x10,%eax
  800fab:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fae:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb7:	89 c2                	mov    %eax,%edx
  800fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fbe:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fc1:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800fc4:	eb 18                	jmp    800fde <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800fc6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fc9:	8d 41 08             	lea    0x8(%ecx),%eax
  800fcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  800fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd5:	89 01                	mov    %eax,(%ecx)
  800fd7:	89 51 04             	mov    %edx,0x4(%ecx)
  800fda:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  800fde:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fe2:	77 e2                	ja     800fc6 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  800fe4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe8:	74 23                	je     80100d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  800fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fed:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ff0:	eb 0e                	jmp    801000 <memset+0x91>
			*p8++ = (uint8)c;
  800ff2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff5:	8d 50 01             	lea    0x1(%eax),%edx
  800ff8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffe:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	8d 50 ff             	lea    -0x1(%eax),%edx
  801006:	89 55 10             	mov    %edx,0x10(%ebp)
  801009:	85 c0                	test   %eax,%eax
  80100b:	75 e5                	jne    800ff2 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801010:	c9                   	leave  
  801011:	c3                   	ret    

00801012 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801024:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801028:	76 24                	jbe    80104e <memcpy+0x3c>
		while(n >= 8){
  80102a:	eb 1c                	jmp    801048 <memcpy+0x36>
			*d64 = *s64;
  80102c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102f:	8b 50 04             	mov    0x4(%eax),%edx
  801032:	8b 00                	mov    (%eax),%eax
  801034:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801037:	89 01                	mov    %eax,(%ecx)
  801039:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80103c:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801040:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801044:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801048:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80104c:	77 de                	ja     80102c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  80104e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801052:	74 31                	je     801085 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801060:	eb 16                	jmp    801078 <memcpy+0x66>
			*d8++ = *s8++;
  801062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801065:	8d 50 01             	lea    0x1(%eax),%edx
  801068:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80106b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801071:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801074:	8a 12                	mov    (%edx),%dl
  801076:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80107e:	89 55 10             	mov    %edx,0x10(%ebp)
  801081:	85 c0                	test   %eax,%eax
  801083:	75 dd                	jne    801062 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80109c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a2:	73 50                	jae    8010f4 <memmove+0x6a>
  8010a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 d0                	add    %edx,%eax
  8010ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010af:	76 43                	jbe    8010f4 <memmove+0x6a>
		s += n;
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ba:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010bd:	eb 10                	jmp    8010cf <memmove+0x45>
			*--d = *--s;
  8010bf:	ff 4d f8             	decl   -0x8(%ebp)
  8010c2:	ff 4d fc             	decl   -0x4(%ebp)
  8010c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c8:	8a 10                	mov    (%eax),%dl
  8010ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d5:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	75 e3                	jne    8010bf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010dc:	eb 23                	jmp    801101 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e1:	8d 50 01             	lea    0x1(%eax),%edx
  8010e4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ed:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010f0:	8a 12                	mov    (%edx),%dl
  8010f2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	75 dd                	jne    8010de <memmove+0x54>
			*d++ = *s++;

	return dst;
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801118:	eb 2a                	jmp    801144 <memcmp+0x3e>
		if (*s1 != *s2)
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	8a 10                	mov    (%eax),%dl
  80111f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	38 c2                	cmp    %al,%dl
  801126:	74 16                	je     80113e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 d0             	movzbl %al,%edx
  801130:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	0f b6 c0             	movzbl %al,%eax
  801138:	29 c2                	sub    %eax,%edx
  80113a:	89 d0                	mov    %edx,%eax
  80113c:	eb 18                	jmp    801156 <memcmp+0x50>
		s1++, s2++;
  80113e:	ff 45 fc             	incl   -0x4(%ebp)
  801141:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 c9                	jne    80111a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80115e:	8b 55 08             	mov    0x8(%ebp),%edx
  801161:	8b 45 10             	mov    0x10(%ebp),%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801169:	eb 15                	jmp    801180 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	0f b6 d0             	movzbl %al,%edx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	0f b6 c0             	movzbl %al,%eax
  801179:	39 c2                	cmp    %eax,%edx
  80117b:	74 0d                	je     80118a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801186:	72 e3                	jb     80116b <memfind+0x13>
  801188:	eb 01                	jmp    80118b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80118a:	90                   	nop
	return (void *) s;
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x19>
		s++;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 20                	cmp    $0x20,%al
  8011b0:	74 f4                	je     8011a6 <strtol+0x16>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8a 00                	mov    (%eax),%al
  8011b7:	3c 09                	cmp    $0x9,%al
  8011b9:	74 eb                	je     8011a6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 2b                	cmp    $0x2b,%al
  8011c2:	75 05                	jne    8011c9 <strtol+0x39>
		s++;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	eb 13                	jmp    8011dc <strtol+0x4c>
	else if (*s == '-')
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	3c 2d                	cmp    $0x2d,%al
  8011d0:	75 0a                	jne    8011dc <strtol+0x4c>
		s++, neg = 1;
  8011d2:	ff 45 08             	incl   0x8(%ebp)
  8011d5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e0:	74 06                	je     8011e8 <strtol+0x58>
  8011e2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011e6:	75 20                	jne    801208 <strtol+0x78>
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 30                	cmp    $0x30,%al
  8011ef:	75 17                	jne    801208 <strtol+0x78>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	40                   	inc    %eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 78                	cmp    $0x78,%al
  8011f9:	75 0d                	jne    801208 <strtol+0x78>
		s += 2, base = 16;
  8011fb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801206:	eb 28                	jmp    801230 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801208:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80120c:	75 15                	jne    801223 <strtol+0x93>
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	3c 30                	cmp    $0x30,%al
  801215:	75 0c                	jne    801223 <strtol+0x93>
		s++, base = 8;
  801217:	ff 45 08             	incl   0x8(%ebp)
  80121a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801221:	eb 0d                	jmp    801230 <strtol+0xa0>
	else if (base == 0)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	75 07                	jne    801230 <strtol+0xa0>
		base = 10;
  801229:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	3c 2f                	cmp    $0x2f,%al
  801237:	7e 19                	jle    801252 <strtol+0xc2>
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	3c 39                	cmp    $0x39,%al
  801240:	7f 10                	jg     801252 <strtol+0xc2>
			dig = *s - '0';
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	0f be c0             	movsbl %al,%eax
  80124a:	83 e8 30             	sub    $0x30,%eax
  80124d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801250:	eb 42                	jmp    801294 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	3c 60                	cmp    $0x60,%al
  801259:	7e 19                	jle    801274 <strtol+0xe4>
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 7a                	cmp    $0x7a,%al
  801262:	7f 10                	jg     801274 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	8a 00                	mov    (%eax),%al
  801269:	0f be c0             	movsbl %al,%eax
  80126c:	83 e8 57             	sub    $0x57,%eax
  80126f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801272:	eb 20                	jmp    801294 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	3c 40                	cmp    $0x40,%al
  80127b:	7e 39                	jle    8012b6 <strtol+0x126>
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	3c 5a                	cmp    $0x5a,%al
  801284:	7f 30                	jg     8012b6 <strtol+0x126>
			dig = *s - 'A' + 10;
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	0f be c0             	movsbl %al,%eax
  80128e:	83 e8 37             	sub    $0x37,%eax
  801291:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801297:	3b 45 10             	cmp    0x10(%ebp),%eax
  80129a:	7d 19                	jge    8012b5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80129c:	ff 45 08             	incl   0x8(%ebp)
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012a6:	89 c2                	mov    %eax,%edx
  8012a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012b0:	e9 7b ff ff ff       	jmp    801230 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012b5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ba:	74 08                	je     8012c4 <strtol+0x134>
		*endptr = (char *) s;
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c8:	74 07                	je     8012d1 <strtol+0x141>
  8012ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cd:	f7 d8                	neg    %eax
  8012cf:	eb 03                	jmp    8012d4 <strtol+0x144>
  8012d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <ltostr>:

void
ltostr(long value, char *str)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012e3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ee:	79 13                	jns    801303 <ltostr+0x2d>
	{
		neg = 1;
  8012f0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012fd:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801300:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80130b:	99                   	cltd   
  80130c:	f7 f9                	idiv   %ecx
  80130e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801314:	8d 50 01             	lea    0x1(%eax),%edx
  801317:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80131a:	89 c2                	mov    %eax,%edx
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	01 d0                	add    %edx,%eax
  801321:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801324:	83 c2 30             	add    $0x30,%edx
  801327:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801331:	f7 e9                	imul   %ecx
  801333:	c1 fa 02             	sar    $0x2,%edx
  801336:	89 c8                	mov    %ecx,%eax
  801338:	c1 f8 1f             	sar    $0x1f,%eax
  80133b:	29 c2                	sub    %eax,%edx
  80133d:	89 d0                	mov    %edx,%eax
  80133f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801346:	75 bb                	jne    801303 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801352:	48                   	dec    %eax
  801353:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801356:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80135a:	74 3d                	je     801399 <ltostr+0xc3>
		start = 1 ;
  80135c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801363:	eb 34                	jmp    801399 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	01 d0                	add    %edx,%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	01 c2                	add    %eax,%edx
  80137a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80137d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801380:	01 c8                	add    %ecx,%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801386:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138c:	01 c2                	add    %eax,%edx
  80138e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801391:	88 02                	mov    %al,(%edx)
		start++ ;
  801393:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801396:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139f:	7c c4                	jl     801365 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a7:	01 d0                	add    %edx,%eax
  8013a9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ac:	90                   	nop
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b5:	ff 75 08             	pushl  0x8(%ebp)
  8013b8:	e8 c4 f9 ff ff       	call   800d81 <strlen>
  8013bd:	83 c4 04             	add    $0x4,%esp
  8013c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013c3:	ff 75 0c             	pushl  0xc(%ebp)
  8013c6:	e8 b6 f9 ff ff       	call   800d81 <strlen>
  8013cb:	83 c4 04             	add    $0x4,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013df:	eb 17                	jmp    8013f8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f5:	ff 45 fc             	incl   -0x4(%ebp)
  8013f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013fb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013fe:	7c e1                	jl     8013e1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801400:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801407:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80140e:	eb 1f                	jmp    80142f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801419:	89 c2                	mov    %eax,%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 c2                	add    %eax,%edx
  801420:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801423:	8b 45 0c             	mov    0xc(%ebp),%eax
  801426:	01 c8                	add    %ecx,%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80142c:	ff 45 f8             	incl   -0x8(%ebp)
  80142f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801432:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801435:	7c d9                	jl     801410 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801437:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143a:	8b 45 10             	mov    0x10(%ebp),%eax
  80143d:	01 d0                	add    %edx,%eax
  80143f:	c6 00 00             	movb   $0x0,(%eax)
}
  801442:	90                   	nop
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801448:	8b 45 14             	mov    0x14(%ebp),%eax
  80144b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801451:	8b 45 14             	mov    0x14(%ebp),%eax
  801454:	8b 00                	mov    (%eax),%eax
  801456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80145d:	8b 45 10             	mov    0x10(%ebp),%eax
  801460:	01 d0                	add    %edx,%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801468:	eb 0c                	jmp    801476 <strsplit+0x31>
			*string++ = 0;
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8d 50 01             	lea    0x1(%eax),%edx
  801470:	89 55 08             	mov    %edx,0x8(%ebp)
  801473:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	84 c0                	test   %al,%al
  80147d:	74 18                	je     801497 <strsplit+0x52>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	0f be c0             	movsbl %al,%eax
  801487:	50                   	push   %eax
  801488:	ff 75 0c             	pushl  0xc(%ebp)
  80148b:	e8 83 fa ff ff       	call   800f13 <strchr>
  801490:	83 c4 08             	add    $0x8,%esp
  801493:	85 c0                	test   %eax,%eax
  801495:	75 d3                	jne    80146a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	84 c0                	test   %al,%al
  80149e:	74 5a                	je     8014fa <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	83 f8 0f             	cmp    $0xf,%eax
  8014a8:	75 07                	jne    8014b1 <strsplit+0x6c>
		{
			return 0;
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	eb 66                	jmp    801517 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b4:	8b 00                	mov    (%eax),%eax
  8014b6:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8014bc:	89 0a                	mov    %ecx,(%edx)
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 c2                	add    %eax,%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	eb 03                	jmp    8014d4 <strsplit+0x8f>
			string++;
  8014d1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d7:	8a 00                	mov    (%eax),%al
  8014d9:	84 c0                	test   %al,%al
  8014db:	74 8b                	je     801468 <strsplit+0x23>
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8a 00                	mov    (%eax),%al
  8014e2:	0f be c0             	movsbl %al,%eax
  8014e5:	50                   	push   %eax
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	e8 25 fa ff ff       	call   800f13 <strchr>
  8014ee:	83 c4 08             	add    $0x8,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	74 dc                	je     8014d1 <strsplit+0x8c>
			string++;
	}
  8014f5:	e9 6e ff ff ff       	jmp    801468 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014fa:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014fe:	8b 00                	mov    (%eax),%eax
  801500:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801507:	8b 45 10             	mov    0x10(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801512:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
  80151c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801525:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80152c:	eb 4a                	jmp    801578 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  80152e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	01 c2                	add    %eax,%edx
  801536:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153c:	01 c8                	add    %ecx,%eax
  80153e:	8a 00                	mov    (%eax),%al
  801540:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801542:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801545:	8b 45 0c             	mov    0xc(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	8a 00                	mov    (%eax),%al
  80154c:	3c 40                	cmp    $0x40,%al
  80154e:	7e 25                	jle    801575 <str2lower+0x5c>
  801550:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801553:	8b 45 0c             	mov    0xc(%ebp),%eax
  801556:	01 d0                	add    %edx,%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	3c 5a                	cmp    $0x5a,%al
  80155c:	7f 17                	jg     801575 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80155e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801569:	8b 55 08             	mov    0x8(%ebp),%edx
  80156c:	01 ca                	add    %ecx,%edx
  80156e:	8a 12                	mov    (%edx),%dl
  801570:	83 c2 20             	add    $0x20,%edx
  801573:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801575:	ff 45 fc             	incl   -0x4(%ebp)
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	e8 01 f8 ff ff       	call   800d81 <strlen>
  801580:	83 c4 04             	add    $0x4,%esp
  801583:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801586:	7f a6                	jg     80152e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801588:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	57                   	push   %edi
  801591:	56                   	push   %esi
  801592:	53                   	push   %ebx
  801593:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80159f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015a8:	cd 30                	int    $0x30
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5f                   	pop    %edi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8015c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ce:	6a 00                	push   $0x0
  8015d0:	51                   	push   %ecx
  8015d1:	52                   	push   %edx
  8015d2:	ff 75 0c             	pushl  0xc(%ebp)
  8015d5:	50                   	push   %eax
  8015d6:	6a 00                	push   $0x0
  8015d8:	e8 b0 ff ff ff       	call   80158d <syscall>
  8015dd:	83 c4 18             	add    $0x18,%esp
}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 02                	push   $0x2
  8015f2:	e8 96 ff ff ff       	call   80158d <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 03                	push   $0x3
  80160b:	e8 7d ff ff ff       	call   80158d <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	90                   	nop
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 04                	push   $0x4
  801625:	e8 63 ff ff ff       	call   80158d <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	90                   	nop
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801633:	8b 55 0c             	mov    0xc(%ebp),%edx
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	52                   	push   %edx
  801640:	50                   	push   %eax
  801641:	6a 08                	push   $0x8
  801643:	e8 45 ff ff ff       	call   80158d <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801652:	8b 75 18             	mov    0x18(%ebp),%esi
  801655:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	51                   	push   %ecx
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	6a 09                	push   $0x9
  801668:	e8 20 ff ff ff       	call   80158d <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	ff 75 08             	pushl  0x8(%ebp)
  801685:	6a 0a                	push   $0xa
  801687:	e8 01 ff ff ff       	call   80158d <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 0b                	push   $0xb
  8016a2:	e8 e6 fe ff ff       	call   80158d <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 0c                	push   $0xc
  8016bb:	e8 cd fe ff ff       	call   80158d <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 0d                	push   $0xd
  8016d4:	e8 b4 fe ff ff       	call   80158d <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 0e                	push   $0xe
  8016ed:	e8 9b fe ff ff       	call   80158d <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0f                	push   $0xf
  801706:	e8 82 fe ff ff       	call   80158d <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	6a 10                	push   $0x10
  801720:	e8 68 fe ff ff       	call   80158d <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 11                	push   $0x11
  801739:	e8 4f fe ff ff       	call   80158d <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	90                   	nop
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_cputc>:

void
sys_cputc(const char c)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801750:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	50                   	push   %eax
  80175d:	6a 01                	push   $0x1
  80175f:	e8 29 fe ff ff       	call   80158d <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
}
  801767:	90                   	nop
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 14                	push   $0x14
  801779:	e8 0f fe ff ff       	call   80158d <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	90                   	nop
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	8b 45 10             	mov    0x10(%ebp),%eax
  80178d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801790:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801793:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	51                   	push   %ecx
  80179d:	52                   	push   %edx
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	50                   	push   %eax
  8017a2:	6a 15                	push   $0x15
  8017a4:	e8 e4 fd ff ff       	call   80158d <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	6a 16                	push   $0x16
  8017c1:	e8 c7 fd ff ff       	call   80158d <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	51                   	push   %ecx
  8017dc:	52                   	push   %edx
  8017dd:	50                   	push   %eax
  8017de:	6a 17                	push   $0x17
  8017e0:	e8 a8 fd ff ff       	call   80158d <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	52                   	push   %edx
  8017fa:	50                   	push   %eax
  8017fb:	6a 18                	push   $0x18
  8017fd:	e8 8b fd ff ff       	call   80158d <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	ff 75 14             	pushl  0x14(%ebp)
  801812:	ff 75 10             	pushl  0x10(%ebp)
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	50                   	push   %eax
  801819:	6a 19                	push   $0x19
  80181b:	e8 6d fd ff ff       	call   80158d <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	50                   	push   %eax
  801834:	6a 1a                	push   $0x1a
  801836:	e8 52 fd ff ff       	call   80158d <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	50                   	push   %eax
  801850:	6a 1b                	push   $0x1b
  801852:	e8 36 fd ff ff       	call   80158d <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 05                	push   $0x5
  80186b:	e8 1d fd ff ff       	call   80158d <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 06                	push   $0x6
  801884:	e8 04 fd ff ff       	call   80158d <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 07                	push   $0x7
  80189d:	e8 eb fc ff ff       	call   80158d <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 1c                	push   $0x1c
  8018b6:	e8 d2 fc ff ff       	call   80158d <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ca:	8d 50 04             	lea    0x4(%eax),%edx
  8018cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 1d                	push   $0x1d
  8018da:	e8 ae fc ff ff       	call   80158d <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
	return result;
  8018e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018eb:	89 01                	mov    %eax,(%ecx)
  8018ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	c9                   	leave  
  8018f4:	c2 04 00             	ret    $0x4

008018f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 10             	pushl  0x10(%ebp)
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	6a 13                	push   $0x13
  801909:	e8 7f fc ff ff       	call   80158d <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_rcr2>:
uint32 sys_rcr2()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 1e                	push   $0x1e
  801923:	e8 65 fc ff ff       	call   80158d <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 04             	sub    $0x4,%esp
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801939:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	50                   	push   %eax
  801946:	6a 1f                	push   $0x1f
  801948:	e8 40 fc ff ff       	call   80158d <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
	return ;
  801950:	90                   	nop
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <rsttst>:
void rsttst()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 21                	push   $0x21
  801962:	e8 26 fc ff ff       	call   80158d <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
	return ;
  80196a:	90                   	nop
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	8b 45 14             	mov    0x14(%ebp),%eax
  801976:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801979:	8b 55 18             	mov    0x18(%ebp),%edx
  80197c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	ff 75 10             	pushl  0x10(%ebp)
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 20                	push   $0x20
  80198d:	e8 fb fb ff ff       	call   80158d <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return ;
  801995:	90                   	nop
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <chktst>:
void chktst(uint32 n)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 22                	push   $0x22
  8019a8:	e8 e0 fb ff ff       	call   80158d <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <inctst>:

void inctst()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 23                	push   $0x23
  8019c2:	e8 c6 fb ff ff       	call   80158d <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ca:	90                   	nop
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <gettst>:
uint32 gettst()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 24                	push   $0x24
  8019dc:	e8 ac fb ff ff       	call   80158d <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 25                	push   $0x25
  8019f5:	e8 93 fb ff ff       	call   80158d <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
  8019fd:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801a02:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 26                	push   $0x26
  801a21:	e8 67 fb ff ff       	call   80158d <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	53                   	push   %ebx
  801a3f:	51                   	push   %ecx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 27                	push   $0x27
  801a44:	e8 44 fb ff ff       	call   80158d <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 28                	push   $0x28
  801a64:	e8 24 fb ff ff       	call   80158d <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	51                   	push   %ecx
  801a7d:	ff 75 10             	pushl  0x10(%ebp)
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 29                	push   $0x29
  801a84:	e8 04 fb ff ff       	call   80158d <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	ff 75 10             	pushl  0x10(%ebp)
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 12                	push   $0x12
  801aa0:	e8 e8 fa ff ff       	call   80158d <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 2a                	push   $0x2a
  801abe:	e8 ca fa ff ff       	call   80158d <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
	return;
  801ac6:	90                   	nop
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 2b                	push   $0x2b
  801ad8:	e8 b0 fa ff ff       	call   80158d <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 2d                	push   $0x2d
  801af3:	e8 95 fa ff ff       	call   80158d <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
	return;
  801afb:	90                   	nop
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	6a 2c                	push   $0x2c
  801b0f:	e8 79 fa ff ff       	call   80158d <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
	return ;
  801b17:	90                   	nop
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801b20:	83 ec 04             	sub    $0x4,%esp
  801b23:	68 c8 26 80 00       	push   $0x8026c8
  801b28:	68 25 01 00 00       	push   $0x125
  801b2d:	68 fb 26 80 00       	push   $0x8026fb
  801b32:	e8 a3 e8 ff ff       	call   8003da <_panic>

00801b37 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b40:	89 d0                	mov    %edx,%eax
  801b42:	c1 e0 02             	shl    $0x2,%eax
  801b45:	01 d0                	add    %edx,%eax
  801b47:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b4e:	01 d0                	add    %edx,%eax
  801b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b57:	01 d0                	add    %edx,%eax
  801b59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b60:	01 d0                	add    %edx,%eax
  801b62:	c1 e0 04             	shl    $0x4,%eax
  801b65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  801b68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b6f:	0f 31                	rdtsc  
  801b71:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b74:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b80:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801b83:	eb 46                	jmp    801bcb <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  801b85:	0f 31                	rdtsc  
  801b87:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b8a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  801b8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801b93:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b96:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9f:	29 c2                	sub    %eax,%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801ba6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	89 d1                	mov    %edx,%ecx
  801bae:	29 c1                	sub    %eax,%ecx
  801bb0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb6:	39 c2                	cmp    %eax,%edx
  801bb8:	0f 97 c0             	seta   %al
  801bbb:	0f b6 c0             	movzbl %al,%eax
  801bbe:	29 c1                	sub    %eax,%ecx
  801bc0:	89 c8                	mov    %ecx,%eax
  801bc2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801bc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  801bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801bd1:	72 b2                	jb     801b85 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801bd3:	90                   	nop
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801bdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801be3:	eb 03                	jmp    801be8 <busy_wait+0x12>
  801be5:	ff 45 fc             	incl   -0x4(%ebp)
  801be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801beb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bee:	72 f5                	jb     801be5 <busy_wait+0xf>
	return i;
  801bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    
  801bf5:	66 90                	xchg   %ax,%ax
  801bf7:	90                   	nop

00801bf8 <__udivdi3>:
  801bf8:	55                   	push   %ebp
  801bf9:	57                   	push   %edi
  801bfa:	56                   	push   %esi
  801bfb:	53                   	push   %ebx
  801bfc:	83 ec 1c             	sub    $0x1c,%esp
  801bff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c03:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c0f:	89 ca                	mov    %ecx,%edx
  801c11:	89 f8                	mov    %edi,%eax
  801c13:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c17:	85 f6                	test   %esi,%esi
  801c19:	75 2d                	jne    801c48 <__udivdi3+0x50>
  801c1b:	39 cf                	cmp    %ecx,%edi
  801c1d:	77 65                	ja     801c84 <__udivdi3+0x8c>
  801c1f:	89 fd                	mov    %edi,%ebp
  801c21:	85 ff                	test   %edi,%edi
  801c23:	75 0b                	jne    801c30 <__udivdi3+0x38>
  801c25:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2a:	31 d2                	xor    %edx,%edx
  801c2c:	f7 f7                	div    %edi
  801c2e:	89 c5                	mov    %eax,%ebp
  801c30:	31 d2                	xor    %edx,%edx
  801c32:	89 c8                	mov    %ecx,%eax
  801c34:	f7 f5                	div    %ebp
  801c36:	89 c1                	mov    %eax,%ecx
  801c38:	89 d8                	mov    %ebx,%eax
  801c3a:	f7 f5                	div    %ebp
  801c3c:	89 cf                	mov    %ecx,%edi
  801c3e:	89 fa                	mov    %edi,%edx
  801c40:	83 c4 1c             	add    $0x1c,%esp
  801c43:	5b                   	pop    %ebx
  801c44:	5e                   	pop    %esi
  801c45:	5f                   	pop    %edi
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    
  801c48:	39 ce                	cmp    %ecx,%esi
  801c4a:	77 28                	ja     801c74 <__udivdi3+0x7c>
  801c4c:	0f bd fe             	bsr    %esi,%edi
  801c4f:	83 f7 1f             	xor    $0x1f,%edi
  801c52:	75 40                	jne    801c94 <__udivdi3+0x9c>
  801c54:	39 ce                	cmp    %ecx,%esi
  801c56:	72 0a                	jb     801c62 <__udivdi3+0x6a>
  801c58:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c5c:	0f 87 9e 00 00 00    	ja     801d00 <__udivdi3+0x108>
  801c62:	b8 01 00 00 00       	mov    $0x1,%eax
  801c67:	89 fa                	mov    %edi,%edx
  801c69:	83 c4 1c             	add    $0x1c,%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5f                   	pop    %edi
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    
  801c71:	8d 76 00             	lea    0x0(%esi),%esi
  801c74:	31 ff                	xor    %edi,%edi
  801c76:	31 c0                	xor    %eax,%eax
  801c78:	89 fa                	mov    %edi,%edx
  801c7a:	83 c4 1c             	add    $0x1c,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5e                   	pop    %esi
  801c7f:	5f                   	pop    %edi
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	f7 f7                	div    %edi
  801c88:	31 ff                	xor    %edi,%edi
  801c8a:	89 fa                	mov    %edi,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c99:	89 eb                	mov    %ebp,%ebx
  801c9b:	29 fb                	sub    %edi,%ebx
  801c9d:	89 f9                	mov    %edi,%ecx
  801c9f:	d3 e6                	shl    %cl,%esi
  801ca1:	89 c5                	mov    %eax,%ebp
  801ca3:	88 d9                	mov    %bl,%cl
  801ca5:	d3 ed                	shr    %cl,%ebp
  801ca7:	89 e9                	mov    %ebp,%ecx
  801ca9:	09 f1                	or     %esi,%ecx
  801cab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801caf:	89 f9                	mov    %edi,%ecx
  801cb1:	d3 e0                	shl    %cl,%eax
  801cb3:	89 c5                	mov    %eax,%ebp
  801cb5:	89 d6                	mov    %edx,%esi
  801cb7:	88 d9                	mov    %bl,%cl
  801cb9:	d3 ee                	shr    %cl,%esi
  801cbb:	89 f9                	mov    %edi,%ecx
  801cbd:	d3 e2                	shl    %cl,%edx
  801cbf:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cc3:	88 d9                	mov    %bl,%cl
  801cc5:	d3 e8                	shr    %cl,%eax
  801cc7:	09 c2                	or     %eax,%edx
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	89 f2                	mov    %esi,%edx
  801ccd:	f7 74 24 0c          	divl   0xc(%esp)
  801cd1:	89 d6                	mov    %edx,%esi
  801cd3:	89 c3                	mov    %eax,%ebx
  801cd5:	f7 e5                	mul    %ebp
  801cd7:	39 d6                	cmp    %edx,%esi
  801cd9:	72 19                	jb     801cf4 <__udivdi3+0xfc>
  801cdb:	74 0b                	je     801ce8 <__udivdi3+0xf0>
  801cdd:	89 d8                	mov    %ebx,%eax
  801cdf:	31 ff                	xor    %edi,%edi
  801ce1:	e9 58 ff ff ff       	jmp    801c3e <__udivdi3+0x46>
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cec:	89 f9                	mov    %edi,%ecx
  801cee:	d3 e2                	shl    %cl,%edx
  801cf0:	39 c2                	cmp    %eax,%edx
  801cf2:	73 e9                	jae    801cdd <__udivdi3+0xe5>
  801cf4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cf7:	31 ff                	xor    %edi,%edi
  801cf9:	e9 40 ff ff ff       	jmp    801c3e <__udivdi3+0x46>
  801cfe:	66 90                	xchg   %ax,%ax
  801d00:	31 c0                	xor    %eax,%eax
  801d02:	e9 37 ff ff ff       	jmp    801c3e <__udivdi3+0x46>
  801d07:	90                   	nop

00801d08 <__umoddi3>:
  801d08:	55                   	push   %ebp
  801d09:	57                   	push   %edi
  801d0a:	56                   	push   %esi
  801d0b:	53                   	push   %ebx
  801d0c:	83 ec 1c             	sub    $0x1c,%esp
  801d0f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d13:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d17:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d1b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d27:	89 f3                	mov    %esi,%ebx
  801d29:	89 fa                	mov    %edi,%edx
  801d2b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d2f:	89 34 24             	mov    %esi,(%esp)
  801d32:	85 c0                	test   %eax,%eax
  801d34:	75 1a                	jne    801d50 <__umoddi3+0x48>
  801d36:	39 f7                	cmp    %esi,%edi
  801d38:	0f 86 a2 00 00 00    	jbe    801de0 <__umoddi3+0xd8>
  801d3e:	89 c8                	mov    %ecx,%eax
  801d40:	89 f2                	mov    %esi,%edx
  801d42:	f7 f7                	div    %edi
  801d44:	89 d0                	mov    %edx,%eax
  801d46:	31 d2                	xor    %edx,%edx
  801d48:	83 c4 1c             	add    $0x1c,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5e                   	pop    %esi
  801d4d:	5f                   	pop    %edi
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    
  801d50:	39 f0                	cmp    %esi,%eax
  801d52:	0f 87 ac 00 00 00    	ja     801e04 <__umoddi3+0xfc>
  801d58:	0f bd e8             	bsr    %eax,%ebp
  801d5b:	83 f5 1f             	xor    $0x1f,%ebp
  801d5e:	0f 84 ac 00 00 00    	je     801e10 <__umoddi3+0x108>
  801d64:	bf 20 00 00 00       	mov    $0x20,%edi
  801d69:	29 ef                	sub    %ebp,%edi
  801d6b:	89 fe                	mov    %edi,%esi
  801d6d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d71:	89 e9                	mov    %ebp,%ecx
  801d73:	d3 e0                	shl    %cl,%eax
  801d75:	89 d7                	mov    %edx,%edi
  801d77:	89 f1                	mov    %esi,%ecx
  801d79:	d3 ef                	shr    %cl,%edi
  801d7b:	09 c7                	or     %eax,%edi
  801d7d:	89 e9                	mov    %ebp,%ecx
  801d7f:	d3 e2                	shl    %cl,%edx
  801d81:	89 14 24             	mov    %edx,(%esp)
  801d84:	89 d8                	mov    %ebx,%eax
  801d86:	d3 e0                	shl    %cl,%eax
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d8e:	d3 e0                	shl    %cl,%eax
  801d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d94:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d98:	89 f1                	mov    %esi,%ecx
  801d9a:	d3 e8                	shr    %cl,%eax
  801d9c:	09 d0                	or     %edx,%eax
  801d9e:	d3 eb                	shr    %cl,%ebx
  801da0:	89 da                	mov    %ebx,%edx
  801da2:	f7 f7                	div    %edi
  801da4:	89 d3                	mov    %edx,%ebx
  801da6:	f7 24 24             	mull   (%esp)
  801da9:	89 c6                	mov    %eax,%esi
  801dab:	89 d1                	mov    %edx,%ecx
  801dad:	39 d3                	cmp    %edx,%ebx
  801daf:	0f 82 87 00 00 00    	jb     801e3c <__umoddi3+0x134>
  801db5:	0f 84 91 00 00 00    	je     801e4c <__umoddi3+0x144>
  801dbb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dbf:	29 f2                	sub    %esi,%edx
  801dc1:	19 cb                	sbb    %ecx,%ebx
  801dc3:	89 d8                	mov    %ebx,%eax
  801dc5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801dc9:	d3 e0                	shl    %cl,%eax
  801dcb:	89 e9                	mov    %ebp,%ecx
  801dcd:	d3 ea                	shr    %cl,%edx
  801dcf:	09 d0                	or     %edx,%eax
  801dd1:	89 e9                	mov    %ebp,%ecx
  801dd3:	d3 eb                	shr    %cl,%ebx
  801dd5:	89 da                	mov    %ebx,%edx
  801dd7:	83 c4 1c             	add    $0x1c,%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5f                   	pop    %edi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    
  801ddf:	90                   	nop
  801de0:	89 fd                	mov    %edi,%ebp
  801de2:	85 ff                	test   %edi,%edi
  801de4:	75 0b                	jne    801df1 <__umoddi3+0xe9>
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	31 d2                	xor    %edx,%edx
  801ded:	f7 f7                	div    %edi
  801def:	89 c5                	mov    %eax,%ebp
  801df1:	89 f0                	mov    %esi,%eax
  801df3:	31 d2                	xor    %edx,%edx
  801df5:	f7 f5                	div    %ebp
  801df7:	89 c8                	mov    %ecx,%eax
  801df9:	f7 f5                	div    %ebp
  801dfb:	89 d0                	mov    %edx,%eax
  801dfd:	e9 44 ff ff ff       	jmp    801d46 <__umoddi3+0x3e>
  801e02:	66 90                	xchg   %ax,%ax
  801e04:	89 c8                	mov    %ecx,%eax
  801e06:	89 f2                	mov    %esi,%edx
  801e08:	83 c4 1c             	add    $0x1c,%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5f                   	pop    %edi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    
  801e10:	3b 04 24             	cmp    (%esp),%eax
  801e13:	72 06                	jb     801e1b <__umoddi3+0x113>
  801e15:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e19:	77 0f                	ja     801e2a <__umoddi3+0x122>
  801e1b:	89 f2                	mov    %esi,%edx
  801e1d:	29 f9                	sub    %edi,%ecx
  801e1f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e23:	89 14 24             	mov    %edx,(%esp)
  801e26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e2a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e2e:	8b 14 24             	mov    (%esp),%edx
  801e31:	83 c4 1c             	add    $0x1c,%esp
  801e34:	5b                   	pop    %ebx
  801e35:	5e                   	pop    %esi
  801e36:	5f                   	pop    %edi
  801e37:	5d                   	pop    %ebp
  801e38:	c3                   	ret    
  801e39:	8d 76 00             	lea    0x0(%esi),%esi
  801e3c:	2b 04 24             	sub    (%esp),%eax
  801e3f:	19 fa                	sbb    %edi,%edx
  801e41:	89 d1                	mov    %edx,%ecx
  801e43:	89 c6                	mov    %eax,%esi
  801e45:	e9 71 ff ff ff       	jmp    801dbb <__umoddi3+0xb3>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e50:	72 ea                	jb     801e3c <__umoddi3+0x134>
  801e52:	89 d9                	mov    %ebx,%ecx
  801e54:	e9 62 ff ff ff       	jmp    801dbb <__umoddi3+0xb3>
