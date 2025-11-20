
obj/user/tst_ksemaphore_1master:     file format elf32-i386


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
  800031:	e8 f7 02 00 00       	call   80032d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ec 01 00 00    	sub    $0x1ec,%esp
	int envID = sys_getenvid();
  800044:	e8 2b 19 00 00       	call   801974 <sys_getenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int semVal ;
	//Initialize the kernel semaphores
	char initCmd1[64] = "__KSem@0@Init";
  80004c:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80004f:	bb 9e 1f 80 00       	mov    $0x801f9e,%ebx
  800054:	ba 0e 00 00 00       	mov    $0xe,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800061:	8d 55 a2             	lea    -0x5e(%ebp),%edx
  800064:	b9 32 00 00 00       	mov    $0x32,%ecx
  800069:	b0 00                	mov    $0x0,%al
  80006b:	89 d7                	mov    %edx,%edi
  80006d:	f3 aa                	rep stos %al,%es:(%edi)
	char initCmd2[64] = "__KSem@1@Init";
  80006f:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  800075:	bb de 1f 80 00       	mov    $0x801fde,%ebx
  80007a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80007f:	89 c7                	mov    %eax,%edi
  800081:	89 de                	mov    %ebx,%esi
  800083:	89 d1                	mov    %edx,%ecx
  800085:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800087:	8d 95 62 ff ff ff    	lea    -0x9e(%ebp),%edx
  80008d:	b9 32 00 00 00       	mov    $0x32,%ecx
  800092:	b0 00                	mov    $0x0,%al
  800094:	89 d7                	mov    %edx,%edi
  800096:	f3 aa                	rep stos %al,%es:(%edi)
	semVal = 1;
  800098:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	sys_utilities(initCmd1, (uint32)(&semVal));
  80009f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000a9:	50                   	push   %eax
  8000aa:	e8 14 1b 00 00       	call   801bc3 <sys_utilities>
  8000af:	83 c4 10             	add    $0x10,%esp
	semVal = 0;
  8000b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	sys_utilities(initCmd2, (uint32)(&semVal));
  8000b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	50                   	push   %eax
  8000c0:	8d 85 54 ff ff ff    	lea    -0xac(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 f7 1a 00 00       	call   801bc3 <sys_utilities>
  8000cc:	83 c4 10             	add    $0x10,%esp

	//Run Slave Processes
	int id1, id2, id3;
	id1 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000cf:	a1 20 30 80 00       	mov    0x803020,%eax
  8000d4:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000da:	a1 20 30 80 00       	mov    0x803020,%eax
  8000df:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000e5:	89 c1                	mov    %eax,%ecx
  8000e7:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ec:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 c0 1e 80 00       	push   $0x801ec0
  8000fa:	e8 20 18 00 00       	call   80191f <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 e0             	mov    %eax,-0x20(%ebp)
	id2 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800105:	a1 20 30 80 00       	mov    0x803020,%eax
  80010a:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800110:	a1 20 30 80 00       	mov    0x803020,%eax
  800115:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80011b:	89 c1                	mov    %eax,%ecx
  80011d:	a1 20 30 80 00       	mov    0x803020,%eax
  800122:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800128:	52                   	push   %edx
  800129:	51                   	push   %ecx
  80012a:	50                   	push   %eax
  80012b:	68 c0 1e 80 00       	push   $0x801ec0
  800130:	e8 ea 17 00 00       	call   80191f <sys_create_env>
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id3 = sys_create_env("ksem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013b:	a1 20 30 80 00       	mov    0x803020,%eax
  800140:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800146:	a1 20 30 80 00       	mov    0x803020,%eax
  80014b:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800151:	89 c1                	mov    %eax,%ecx
  800153:	a1 20 30 80 00       	mov    0x803020,%eax
  800158:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80015e:	52                   	push   %edx
  80015f:	51                   	push   %ecx
  800160:	50                   	push   %eax
  800161:	68 c0 1e 80 00       	push   $0x801ec0
  800166:	e8 b4 17 00 00       	call   80191f <sys_create_env>
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	89 45 d8             	mov    %eax,-0x28(%ebp)

	sys_run_env(id1);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 e0             	pushl  -0x20(%ebp)
  800177:	e8 c1 17 00 00       	call   80193d <sys_run_env>
  80017c:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 dc             	pushl  -0x24(%ebp)
  800185:	e8 b3 17 00 00       	call   80193d <sys_run_env>
  80018a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80018d:	83 ec 0c             	sub    $0xc,%esp
  800190:	ff 75 d8             	pushl  -0x28(%ebp)
  800193:	e8 a5 17 00 00       	call   80193d <sys_run_env>
  800198:	83 c4 10             	add    $0x10,%esp

	//Wait until all finished
	char waitCmd1[64] = "__KSem@1@Wait";
  80019b:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8001a1:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  8001a6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ab:	89 c7                	mov    %eax,%edi
  8001ad:	89 de                	mov    %ebx,%esi
  8001af:	89 d1                	mov    %edx,%ecx
  8001b1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001b3:	8d 95 22 ff ff ff    	lea    -0xde(%ebp),%edx
  8001b9:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001be:	b0 00                	mov    $0x0,%al
  8001c0:	89 d7                	mov    %edx,%edi
  8001c2:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd1, 0);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	6a 00                	push   $0x0
  8001c9:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8001cf:	50                   	push   %eax
  8001d0:	e8 ee 19 00 00       	call   801bc3 <sys_utilities>
  8001d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 1st wait\n");
	char waitCmd2[64] = "__KSem@1@Wait";
  8001d8:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8001de:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  8001e3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001e8:	89 c7                	mov    %eax,%edi
  8001ea:	89 de                	mov    %ebx,%esi
  8001ec:	89 d1                	mov    %edx,%ecx
  8001ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8001f0:	8d 95 e2 fe ff ff    	lea    -0x11e(%ebp),%edx
  8001f6:	b9 32 00 00 00       	mov    $0x32,%ecx
  8001fb:	b0 00                	mov    $0x0,%al
  8001fd:	89 d7                	mov    %edx,%edi
  8001ff:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd2, 0);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	6a 00                	push   $0x0
  800206:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  80020c:	50                   	push   %eax
  80020d:	e8 b1 19 00 00       	call   801bc3 <sys_utilities>
  800212:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 2nd wait\n");
	char waitCmd3[64] = "__KSem@1@Wait";
  800215:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  80021b:	bb 1e 20 80 00       	mov    $0x80201e,%ebx
  800220:	ba 0e 00 00 00       	mov    $0xe,%edx
  800225:	89 c7                	mov    %eax,%edi
  800227:	89 de                	mov    %ebx,%esi
  800229:	89 d1                	mov    %edx,%ecx
  80022b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80022d:	8d 95 a2 fe ff ff    	lea    -0x15e(%ebp),%edx
  800233:	b9 32 00 00 00       	mov    $0x32,%ecx
  800238:	b0 00                	mov    $0x0,%al
  80023a:	89 d7                	mov    %edx,%edi
  80023c:	f3 aa                	rep stos %al,%es:(%edi)
	sys_utilities(waitCmd3, 0);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	6a 00                	push   $0x0
  800243:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800249:	50                   	push   %eax
  80024a:	e8 74 19 00 00       	call   801bc3 <sys_utilities>
  80024f:	83 c4 10             	add    $0x10,%esp
	//cprintf("after 3rd wait\n");

	//Check Sem Values
	int sem1val ;
	int sem2val ;
	char getCmd1[64] = "__KSem@0@Get";
  800252:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  800258:	bb 5e 20 80 00       	mov    $0x80205e,%ebx
  80025d:	ba 0d 00 00 00       	mov    $0xd,%edx
  800262:	89 c7                	mov    %eax,%edi
  800264:	89 de                	mov    %ebx,%esi
  800266:	89 d1                	mov    %edx,%ecx
  800268:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80026a:	8d 95 59 fe ff ff    	lea    -0x1a7(%ebp),%edx
  800270:	b9 33 00 00 00       	mov    $0x33,%ecx
  800275:	b0 00                	mov    $0x0,%al
  800277:	89 d7                	mov    %edx,%edi
  800279:	f3 aa                	rep stos %al,%es:(%edi)
	char getCmd2[64] = "__KSem@1@Get";
  80027b:	8d 85 0c fe ff ff    	lea    -0x1f4(%ebp),%eax
  800281:	bb 9e 20 80 00       	mov    $0x80209e,%ebx
  800286:	ba 0d 00 00 00       	mov    $0xd,%edx
  80028b:	89 c7                	mov    %eax,%edi
  80028d:	89 de                	mov    %ebx,%esi
  80028f:	89 d1                	mov    %edx,%ecx
  800291:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800293:	8d 95 19 fe ff ff    	lea    -0x1e7(%ebp),%edx
  800299:	b9 33 00 00 00       	mov    $0x33,%ecx
  80029e:	b0 00                	mov    $0x0,%al
  8002a0:	89 d7                	mov    %edx,%edi
  8002a2:	f3 aa                	rep stos %al,%es:(%edi)

	sys_utilities(getCmd1, (uint32)(&sem1val));
  8002a4:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	50                   	push   %eax
  8002ae:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  8002b4:	50                   	push   %eax
  8002b5:	e8 09 19 00 00       	call   801bc3 <sys_utilities>
  8002ba:	83 c4 10             	add    $0x10,%esp
	sys_utilities(getCmd2, (uint32)(&sem2val));
  8002bd:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	8d 85 0c fe ff ff    	lea    -0x1f4(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	e8 f0 18 00 00       	call   801bc3 <sys_utilities>
  8002d3:	83 c4 10             	add    $0x10,%esp

	if (sem2val == 0 && sem1val == 1)
  8002d6:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	75 1f                	jne    8002ff <_main+0x2c7>
  8002e0:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  8002e6:	83 f8 01             	cmp    $0x1,%eax
  8002e9:	75 14                	jne    8002ff <_main+0x2c7>
		cprintf_colored(TEXT_light_green, "Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	68 cc 1e 80 00       	push   $0x801ecc
  8002f3:	6a 0a                	push   $0xa
  8002f5:	e8 f3 04 00 00       	call   8007ed <cprintf_colored>
  8002fa:	83 c4 10             	add    $0x10,%esp
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);

	return;
  8002fd:	eb 26                	jmp    800325 <_main+0x2ed>
	sys_utilities(getCmd2, (uint32)(&sem2val));

	if (sem2val == 0 && sem1val == 1)
		cprintf_colored(TEXT_light_green, "Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);
  8002ff:	8b 95 8c fe ff ff    	mov    -0x174(%ebp),%edx
  800305:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  80030b:	83 ec 04             	sub    $0x4,%esp
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	6a 00                	push   $0x0
  800312:	6a 01                	push   $0x1
  800314:	68 14 1f 80 00       	push   $0x801f14
  800319:	6a 33                	push   $0x33
  80031b:	68 80 1f 80 00       	push   $0x801f80
  800320:	e8 cd 01 00 00       	call   8004f2 <_panic>

	return;
}
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    

0080032d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	57                   	push   %edi
  800331:	56                   	push   %esi
  800332:	53                   	push   %ebx
  800333:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800336:	e8 52 16 00 00       	call   80198d <sys_getenvindex>
  80033b:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80033e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800341:	89 d0                	mov    %edx,%eax
  800343:	c1 e0 06             	shl    $0x6,%eax
  800346:	29 d0                	sub    %edx,%eax
  800348:	c1 e0 02             	shl    $0x2,%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800354:	01 c8                	add    %ecx,%eax
  800356:	c1 e0 03             	shl    $0x3,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800362:	29 c2                	sub    %eax,%edx
  800364:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80036b:	89 c2                	mov    %eax,%edx
  80036d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800373:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800378:	a1 20 30 80 00       	mov    0x803020,%eax
  80037d:	8a 40 20             	mov    0x20(%eax),%al
  800380:	84 c0                	test   %al,%al
  800382:	74 0d                	je     800391 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800384:	a1 20 30 80 00       	mov    0x803020,%eax
  800389:	83 c0 20             	add    $0x20,%eax
  80038c:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800395:	7e 0a                	jle    8003a1 <libmain+0x74>
		binaryname = argv[0];
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	ff 75 0c             	pushl  0xc(%ebp)
  8003a7:	ff 75 08             	pushl  0x8(%ebp)
  8003aa:	e8 89 fc ff ff       	call   800038 <_main>
  8003af:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8003b2:	a1 00 30 80 00       	mov    0x803000,%eax
  8003b7:	85 c0                	test   %eax,%eax
  8003b9:	0f 84 01 01 00 00    	je     8004c0 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8003bf:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003c5:	bb d8 21 80 00       	mov    $0x8021d8,%ebx
  8003ca:	ba 0e 00 00 00       	mov    $0xe,%edx
  8003cf:	89 c7                	mov    %eax,%edi
  8003d1:	89 de                	mov    %ebx,%esi
  8003d3:	89 d1                	mov    %edx,%ecx
  8003d5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8003d7:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8003da:	b9 56 00 00 00       	mov    $0x56,%ecx
  8003df:	b0 00                	mov    $0x0,%al
  8003e1:	89 d7                	mov    %edx,%edi
  8003e3:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8003e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8003ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	50                   	push   %eax
  8003f3:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8003f9:	50                   	push   %eax
  8003fa:	e8 c4 17 00 00       	call   801bc3 <sys_utilities>
  8003ff:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800402:	e8 0d 13 00 00       	call   801714 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	68 f8 20 80 00       	push   $0x8020f8
  80040f:	e8 ac 03 00 00       	call   8007c0 <cprintf>
  800414:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041a:	85 c0                	test   %eax,%eax
  80041c:	74 18                	je     800436 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80041e:	e8 be 17 00 00       	call   801be1 <sys_get_optimal_num_faults>
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	50                   	push   %eax
  800427:	68 20 21 80 00       	push   $0x802120
  80042c:	e8 8f 03 00 00       	call   8007c0 <cprintf>
  800431:	83 c4 10             	add    $0x10,%esp
  800434:	eb 59                	jmp    80048f <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800436:	a1 20 30 80 00       	mov    0x803020,%eax
  80043b:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800441:	a1 20 30 80 00       	mov    0x803020,%eax
  800446:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 44 21 80 00       	push   $0x802144
  800456:	e8 65 03 00 00       	call   8007c0 <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80045e:	a1 20 30 80 00       	mov    0x803020,%eax
  800463:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800469:	a1 20 30 80 00       	mov    0x803020,%eax
  80046e:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800474:	a1 20 30 80 00       	mov    0x803020,%eax
  800479:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	50                   	push   %eax
  800482:	68 6c 21 80 00       	push   $0x80216c
  800487:	e8 34 03 00 00       	call   8007c0 <cprintf>
  80048c:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80048f:	a1 20 30 80 00       	mov    0x803020,%eax
  800494:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	50                   	push   %eax
  80049e:	68 c4 21 80 00       	push   $0x8021c4
  8004a3:	e8 18 03 00 00       	call   8007c0 <cprintf>
  8004a8:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8004ab:	83 ec 0c             	sub    $0xc,%esp
  8004ae:	68 f8 20 80 00       	push   $0x8020f8
  8004b3:	e8 08 03 00 00       	call   8007c0 <cprintf>
  8004b8:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8004bb:	e8 6e 12 00 00       	call   80172e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8004c0:	e8 1f 00 00 00       	call   8004e4 <exit>
}
  8004c5:	90                   	nop
  8004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8004c9:	5b                   	pop    %ebx
  8004ca:	5e                   	pop    %esi
  8004cb:	5f                   	pop    %edi
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 7b 14 00 00       	call   801959 <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 d0 14 00 00       	call   8019bf <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 18 b1 81 00       	mov    0x81b118,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 18 b1 81 00       	mov    0x81b118,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 3c 22 80 00       	push   $0x80223c
  800518:	e8 a3 02 00 00       	call   8007c0 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 04 30 80 00       	mov    0x803004,%eax
  800525:	83 ec 0c             	sub    $0xc,%esp
  800528:	ff 75 0c             	pushl  0xc(%ebp)
  80052b:	ff 75 08             	pushl  0x8(%ebp)
  80052e:	50                   	push   %eax
  80052f:	68 44 22 80 00       	push   $0x802244
  800534:	6a 74                	push   $0x74
  800536:	e8 b2 02 00 00       	call   8007ed <cprintf_colored>
  80053b:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80053e:	8b 45 10             	mov    0x10(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 04 02 00 00       	call   800751 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	6a 00                	push   $0x0
  800555:	68 6c 22 80 00       	push   $0x80226c
  80055a:	e8 f2 01 00 00       	call   800751 <vcprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800562:	e8 7d ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800567:	eb fe                	jmp    800567 <_panic+0x75>

00800569 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056f:	a1 20 30 80 00       	mov    0x803020,%eax
  800574:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80057d:	39 c2                	cmp    %eax,%edx
  80057f:	74 14                	je     800595 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	68 70 22 80 00       	push   $0x802270
  800589:	6a 26                	push   $0x26
  80058b:	68 bc 22 80 00       	push   $0x8022bc
  800590:	e8 5d ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800595:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80059c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005a3:	e9 c5 00 00 00       	jmp    80066d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8005a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	01 d0                	add    %edx,%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	75 08                	jne    8005c5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8005bd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005c0:	e9 a5 00 00 00       	jmp    80066a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8005c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d3:	eb 69                	jmp    80063e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005da:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	01 c0                	add    %eax,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	c1 e0 03             	shl    $0x3,%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8a 40 04             	mov    0x4(%eax),%al
  8005f1:	84 c0                	test   %al,%al
  8005f3:	75 46                	jne    80063b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fa:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800600:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800603:	89 d0                	mov    %edx,%eax
  800605:	01 c0                	add    %eax,%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	c1 e0 03             	shl    $0x3,%eax
  80060c:	01 c8                	add    %ecx,%eax
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800613:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800616:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80061b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80061d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800620:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	01 c8                	add    %ecx,%eax
  80062c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80062e:	39 c2                	cmp    %eax,%edx
  800630:	75 09                	jne    80063b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800632:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800639:	eb 15                	jmp    800650 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063b:	ff 45 e8             	incl   -0x18(%ebp)
  80063e:	a1 20 30 80 00       	mov    0x803020,%eax
  800643:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80064c:	39 c2                	cmp    %eax,%edx
  80064e:	77 85                	ja     8005d5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800654:	75 14                	jne    80066a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800656:	83 ec 04             	sub    $0x4,%esp
  800659:	68 c8 22 80 00       	push   $0x8022c8
  80065e:	6a 3a                	push   $0x3a
  800660:	68 bc 22 80 00       	push   $0x8022bc
  800665:	e8 88 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80066a:	ff 45 f0             	incl   -0x10(%ebp)
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800673:	0f 8c 2f ff ff ff    	jl     8005a8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800679:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800680:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800687:	eb 26                	jmp    8006af <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800689:	a1 20 30 80 00       	mov    0x803020,%eax
  80068e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800694:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	01 c0                	add    %eax,%eax
  80069b:	01 d0                	add    %edx,%eax
  80069d:	c1 e0 03             	shl    $0x3,%eax
  8006a0:	01 c8                	add    %ecx,%eax
  8006a2:	8a 40 04             	mov    0x4(%eax),%al
  8006a5:	3c 01                	cmp    $0x1,%al
  8006a7:	75 03                	jne    8006ac <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8006a9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006ac:	ff 45 e0             	incl   -0x20(%ebp)
  8006af:	a1 20 30 80 00       	mov    0x803020,%eax
  8006b4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bd:	39 c2                	cmp    %eax,%edx
  8006bf:	77 c8                	ja     800689 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006c7:	74 14                	je     8006dd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8006c9:	83 ec 04             	sub    $0x4,%esp
  8006cc:	68 1c 23 80 00       	push   $0x80231c
  8006d1:	6a 44                	push   $0x44
  8006d3:	68 bc 22 80 00       	push   $0x8022bc
  8006d8:	e8 15 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	8d 48 01             	lea    0x1(%eax),%ecx
  8006ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f2:	89 0a                	mov    %ecx,(%edx)
  8006f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f7:	88 d1                	mov    %dl,%cl
  8006f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800700:	8b 45 0c             	mov    0xc(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	3d ff 00 00 00       	cmp    $0xff,%eax
  80070a:	75 30                	jne    80073c <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80070c:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  800712:	a0 44 30 80 00       	mov    0x803044,%al
  800717:	0f b6 c0             	movzbl %al,%eax
  80071a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80071d:	8b 09                	mov    (%ecx),%ecx
  80071f:	89 cb                	mov    %ecx,%ebx
  800721:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800724:	83 c1 08             	add    $0x8,%ecx
  800727:	52                   	push   %edx
  800728:	50                   	push   %eax
  800729:	53                   	push   %ebx
  80072a:	51                   	push   %ecx
  80072b:	e8 a0 0f 00 00       	call   8016d0 <sys_cputs>
  800730:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80073f:	8b 40 04             	mov    0x4(%eax),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	8b 45 0c             	mov    0xc(%ebp),%eax
  800748:	89 50 04             	mov    %edx,0x4(%eax)
}
  80074b:	90                   	nop
  80074c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80074f:	c9                   	leave  
  800750:	c3                   	ret    

00800751 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800751:	55                   	push   %ebp
  800752:	89 e5                	mov    %esp,%ebp
  800754:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80075a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800761:	00 00 00 
	b.cnt = 0;
  800764:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80076b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	ff 75 08             	pushl  0x8(%ebp)
  800774:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80077a:	50                   	push   %eax
  80077b:	68 e0 06 80 00       	push   $0x8006e0
  800780:	e8 5a 02 00 00       	call   8009df <vprintfmt>
  800785:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800788:	8b 15 1c b1 81 00    	mov    0x81b11c,%edx
  80078e:	a0 44 30 80 00       	mov    0x803044,%al
  800793:	0f b6 c0             	movzbl %al,%eax
  800796:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80079c:	52                   	push   %edx
  80079d:	50                   	push   %eax
  80079e:	51                   	push   %ecx
  80079f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007a5:	83 c0 08             	add    $0x8,%eax
  8007a8:	50                   	push   %eax
  8007a9:	e8 22 0f 00 00       	call   8016d0 <sys_cputs>
  8007ae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007b1:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
	return b.cnt;
  8007b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007c6:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	va_start(ap, fmt);
  8007cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	83 ec 08             	sub    $0x8,%esp
  8007d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007dc:	50                   	push   %eax
  8007dd:	e8 6f ff ff ff       	call   800751 <vcprintf>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007f3:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
	curTextClr = (textClr << 8) ; //set text color by the given value
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	c1 e0 08             	shl    $0x8,%eax
  800800:	a3 1c b1 81 00       	mov    %eax,0x81b11c
	va_start(ap, fmt);
  800805:	8d 45 0c             	lea    0xc(%ebp),%eax
  800808:	83 c0 04             	add    $0x4,%eax
  80080b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	83 ec 08             	sub    $0x8,%esp
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	50                   	push   %eax
  800818:	e8 34 ff ff ff       	call   800751 <vcprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800823:	c7 05 1c b1 81 00 00 	movl   $0x700,0x81b11c
  80082a:	07 00 00 

	return cnt;
  80082d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    

00800832 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800838:	e8 d7 0e 00 00       	call   801714 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80083d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800840:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	83 ec 08             	sub    $0x8,%esp
  800849:	ff 75 f4             	pushl  -0xc(%ebp)
  80084c:	50                   	push   %eax
  80084d:	e8 ff fe ff ff       	call   800751 <vcprintf>
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800858:	e8 d1 0e 00 00       	call   80172e <sys_unlock_cons>
	return cnt;
  80085d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800860:	c9                   	leave  
  800861:	c3                   	ret    

00800862 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	83 ec 14             	sub    $0x14,%esp
  800869:	8b 45 10             	mov    0x10(%ebp),%eax
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800875:	8b 45 18             	mov    0x18(%ebp),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
  80087d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800880:	77 55                	ja     8008d7 <printnum+0x75>
  800882:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800885:	72 05                	jb     80088c <printnum+0x2a>
  800887:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80088a:	77 4b                	ja     8008d7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80088c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80088f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800892:	8b 45 18             	mov    0x18(%ebp),%eax
  800895:	ba 00 00 00 00       	mov    $0x0,%edx
  80089a:	52                   	push   %edx
  80089b:	50                   	push   %eax
  80089c:	ff 75 f4             	pushl  -0xc(%ebp)
  80089f:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a2:	e8 a9 13 00 00       	call   801c50 <__udivdi3>
  8008a7:	83 c4 10             	add    $0x10,%esp
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	ff 75 20             	pushl  0x20(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	ff 75 18             	pushl  0x18(%ebp)
  8008b4:	52                   	push   %edx
  8008b5:	50                   	push   %eax
  8008b6:	ff 75 0c             	pushl  0xc(%ebp)
  8008b9:	ff 75 08             	pushl  0x8(%ebp)
  8008bc:	e8 a1 ff ff ff       	call   800862 <printnum>
  8008c1:	83 c4 20             	add    $0x20,%esp
  8008c4:	eb 1a                	jmp    8008e0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 20             	pushl  0x20(%ebp)
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	ff d0                	call   *%eax
  8008d4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d7:	ff 4d 1c             	decl   0x1c(%ebp)
  8008da:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008de:	7f e6                	jg     8008c6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008e0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ee:	53                   	push   %ebx
  8008ef:	51                   	push   %ecx
  8008f0:	52                   	push   %edx
  8008f1:	50                   	push   %eax
  8008f2:	e8 69 14 00 00       	call   801d60 <__umoddi3>
  8008f7:	83 c4 10             	add    $0x10,%esp
  8008fa:	05 94 25 80 00       	add    $0x802594,%eax
  8008ff:	8a 00                	mov    (%eax),%al
  800901:	0f be c0             	movsbl %al,%eax
  800904:	83 ec 08             	sub    $0x8,%esp
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	50                   	push   %eax
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	ff d0                	call   *%eax
  800910:	83 c4 10             	add    $0x10,%esp
}
  800913:	90                   	nop
  800914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800917:	c9                   	leave  
  800918:	c3                   	ret    

00800919 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800919:	55                   	push   %ebp
  80091a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800920:	7e 1c                	jle    80093e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	8d 50 08             	lea    0x8(%eax),%edx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	89 10                	mov    %edx,(%eax)
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	83 e8 08             	sub    $0x8,%eax
  800937:	8b 50 04             	mov    0x4(%eax),%edx
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	eb 40                	jmp    80097e <getuint+0x65>
	else if (lflag)
  80093e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800942:	74 1e                	je     800962 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	8d 50 04             	lea    0x4(%eax),%edx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 10                	mov    %edx,(%eax)
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 00                	mov    (%eax),%eax
  800956:	83 e8 04             	sub    $0x4,%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	ba 00 00 00 00       	mov    $0x0,%edx
  800960:	eb 1c                	jmp    80097e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	8b 00                	mov    (%eax),%eax
  800967:	8d 50 04             	lea    0x4(%eax),%edx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	89 10                	mov    %edx,(%eax)
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 00                	mov    (%eax),%eax
  800974:	83 e8 04             	sub    $0x4,%eax
  800977:	8b 00                	mov    (%eax),%eax
  800979:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800983:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800987:	7e 1c                	jle    8009a5 <getint+0x25>
		return va_arg(*ap, long long);
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 00                	mov    (%eax),%eax
  80098e:	8d 50 08             	lea    0x8(%eax),%edx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	89 10                	mov    %edx,(%eax)
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	8b 00                	mov    (%eax),%eax
  80099b:	83 e8 08             	sub    $0x8,%eax
  80099e:	8b 50 04             	mov    0x4(%eax),%edx
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	eb 38                	jmp    8009dd <getint+0x5d>
	else if (lflag)
  8009a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a9:	74 1a                	je     8009c5 <getint+0x45>
		return va_arg(*ap, long);
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	8d 50 04             	lea    0x4(%eax),%edx
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	89 10                	mov    %edx,(%eax)
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	83 e8 04             	sub    $0x4,%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	99                   	cltd   
  8009c3:	eb 18                	jmp    8009dd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	8d 50 04             	lea    0x4(%eax),%edx
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	89 10                	mov    %edx,(%eax)
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	83 e8 04             	sub    $0x4,%eax
  8009da:	8b 00                	mov    (%eax),%eax
  8009dc:	99                   	cltd   
}
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e7:	eb 17                	jmp    800a00 <vprintfmt+0x21>
			if (ch == '\0')
  8009e9:	85 db                	test   %ebx,%ebx
  8009eb:	0f 84 c1 03 00 00    	je     800db2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	53                   	push   %ebx
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	8d 50 01             	lea    0x1(%eax),%edx
  800a06:	89 55 10             	mov    %edx,0x10(%ebp)
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	0f b6 d8             	movzbl %al,%ebx
  800a0e:	83 fb 25             	cmp    $0x25,%ebx
  800a11:	75 d6                	jne    8009e9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a13:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a17:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a1e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a25:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a33:	8b 45 10             	mov    0x10(%ebp),%eax
  800a36:	8d 50 01             	lea    0x1(%eax),%edx
  800a39:	89 55 10             	mov    %edx,0x10(%ebp)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f b6 d8             	movzbl %al,%ebx
  800a41:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a44:	83 f8 5b             	cmp    $0x5b,%eax
  800a47:	0f 87 3d 03 00 00    	ja     800d8a <vprintfmt+0x3ab>
  800a4d:	8b 04 85 b8 25 80 00 	mov    0x8025b8(,%eax,4),%eax
  800a54:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a56:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a5a:	eb d7                	jmp    800a33 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a5c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a60:	eb d1                	jmp    800a33 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a62:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a6c:	89 d0                	mov    %edx,%eax
  800a6e:	c1 e0 02             	shl    $0x2,%eax
  800a71:	01 d0                	add    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d8                	add    %ebx,%eax
  800a77:	83 e8 30             	sub    $0x30,%eax
  800a7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a80:	8a 00                	mov    (%eax),%al
  800a82:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a85:	83 fb 2f             	cmp    $0x2f,%ebx
  800a88:	7e 3e                	jle    800ac8 <vprintfmt+0xe9>
  800a8a:	83 fb 39             	cmp    $0x39,%ebx
  800a8d:	7f 39                	jg     800ac8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a8f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a92:	eb d5                	jmp    800a69 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a94:	8b 45 14             	mov    0x14(%ebp),%eax
  800a97:	83 c0 04             	add    $0x4,%eax
  800a9a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa0:	83 e8 04             	sub    $0x4,%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa8:	eb 1f                	jmp    800ac9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aaa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aae:	79 83                	jns    800a33 <vprintfmt+0x54>
				width = 0;
  800ab0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab7:	e9 77 ff ff ff       	jmp    800a33 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800abc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ac3:	e9 6b ff ff ff       	jmp    800a33 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800acd:	0f 89 60 ff ff ff    	jns    800a33 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ae0:	e9 4e ff ff ff       	jmp    800a33 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ae5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae8:	e9 46 ff ff ff       	jmp    800a33 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aed:	8b 45 14             	mov    0x14(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 14             	mov    %eax,0x14(%ebp)
  800af6:	8b 45 14             	mov    0x14(%ebp),%eax
  800af9:	83 e8 04             	sub    $0x4,%eax
  800afc:	8b 00                	mov    (%eax),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	ff 75 0c             	pushl  0xc(%ebp)
  800b04:	50                   	push   %eax
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	ff d0                	call   *%eax
  800b0a:	83 c4 10             	add    $0x10,%esp
			break;
  800b0d:	e9 9b 02 00 00       	jmp    800dad <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b12:	8b 45 14             	mov    0x14(%ebp),%eax
  800b15:	83 c0 04             	add    $0x4,%eax
  800b18:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1e:	83 e8 04             	sub    $0x4,%eax
  800b21:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	79 02                	jns    800b29 <vprintfmt+0x14a>
				err = -err;
  800b27:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b29:	83 fb 64             	cmp    $0x64,%ebx
  800b2c:	7f 0b                	jg     800b39 <vprintfmt+0x15a>
  800b2e:	8b 34 9d 00 24 80 00 	mov    0x802400(,%ebx,4),%esi
  800b35:	85 f6                	test   %esi,%esi
  800b37:	75 19                	jne    800b52 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b39:	53                   	push   %ebx
  800b3a:	68 a5 25 80 00       	push   $0x8025a5
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	ff 75 08             	pushl  0x8(%ebp)
  800b45:	e8 70 02 00 00       	call   800dba <printfmt>
  800b4a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b4d:	e9 5b 02 00 00       	jmp    800dad <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b52:	56                   	push   %esi
  800b53:	68 ae 25 80 00       	push   $0x8025ae
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	ff 75 08             	pushl  0x8(%ebp)
  800b5e:	e8 57 02 00 00       	call   800dba <printfmt>
  800b63:	83 c4 10             	add    $0x10,%esp
			break;
  800b66:	e9 42 02 00 00       	jmp    800dad <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 14             	mov    %eax,0x14(%ebp)
  800b74:	8b 45 14             	mov    0x14(%ebp),%eax
  800b77:	83 e8 04             	sub    $0x4,%eax
  800b7a:	8b 30                	mov    (%eax),%esi
  800b7c:	85 f6                	test   %esi,%esi
  800b7e:	75 05                	jne    800b85 <vprintfmt+0x1a6>
				p = "(null)";
  800b80:	be b1 25 80 00       	mov    $0x8025b1,%esi
			if (width > 0 && padc != '-')
  800b85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b89:	7e 6d                	jle    800bf8 <vprintfmt+0x219>
  800b8b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b8f:	74 67                	je     800bf8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	50                   	push   %eax
  800b98:	56                   	push   %esi
  800b99:	e8 1e 03 00 00       	call   800ebc <strnlen>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ba4:	eb 16                	jmp    800bbc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ba6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	50                   	push   %eax
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	ff d0                	call   *%eax
  800bb6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb9:	ff 4d e4             	decl   -0x1c(%ebp)
  800bbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc0:	7f e4                	jg     800ba6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc2:	eb 34                	jmp    800bf8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bc4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc8:	74 1c                	je     800be6 <vprintfmt+0x207>
  800bca:	83 fb 1f             	cmp    $0x1f,%ebx
  800bcd:	7e 05                	jle    800bd4 <vprintfmt+0x1f5>
  800bcf:	83 fb 7e             	cmp    $0x7e,%ebx
  800bd2:	7e 12                	jle    800be6 <vprintfmt+0x207>
					putch('?', putdat);
  800bd4:	83 ec 08             	sub    $0x8,%esp
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	6a 3f                	push   $0x3f
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	ff d0                	call   *%eax
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	eb 0f                	jmp    800bf5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800be6:	83 ec 08             	sub    $0x8,%esp
  800be9:	ff 75 0c             	pushl  0xc(%ebp)
  800bec:	53                   	push   %ebx
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bf5:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf8:	89 f0                	mov    %esi,%eax
  800bfa:	8d 70 01             	lea    0x1(%eax),%esi
  800bfd:	8a 00                	mov    (%eax),%al
  800bff:	0f be d8             	movsbl %al,%ebx
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	74 24                	je     800c2a <vprintfmt+0x24b>
  800c06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0a:	78 b8                	js     800bc4 <vprintfmt+0x1e5>
  800c0c:	ff 4d e0             	decl   -0x20(%ebp)
  800c0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c13:	79 af                	jns    800bc4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c15:	eb 13                	jmp    800c2a <vprintfmt+0x24b>
				putch(' ', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 20                	push   $0x20
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c27:	ff 4d e4             	decl   -0x1c(%ebp)
  800c2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2e:	7f e7                	jg     800c17 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c30:	e9 78 01 00 00       	jmp    800dad <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 e8             	pushl  -0x18(%ebp)
  800c3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 3c fd ff ff       	call   800980 <getint>
  800c44:	83 c4 10             	add    $0x10,%esp
  800c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c53:	85 d2                	test   %edx,%edx
  800c55:	79 23                	jns    800c7a <vprintfmt+0x29b>
				putch('-', putdat);
  800c57:	83 ec 08             	sub    $0x8,%esp
  800c5a:	ff 75 0c             	pushl  0xc(%ebp)
  800c5d:	6a 2d                	push   $0x2d
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	ff d0                	call   *%eax
  800c64:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6d:	f7 d8                	neg    %eax
  800c6f:	83 d2 00             	adc    $0x0,%edx
  800c72:	f7 da                	neg    %edx
  800c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c81:	e9 bc 00 00 00       	jmp    800d42 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8c:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8f:	50                   	push   %eax
  800c90:	e8 84 fc ff ff       	call   800919 <getuint>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c9e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ca5:	e9 98 00 00 00       	jmp    800d42 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800caa:	83 ec 08             	sub    $0x8,%esp
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	6a 58                	push   $0x58
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	ff d0                	call   *%eax
  800cb7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	6a 58                	push   $0x58
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	ff d0                	call   *%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	ff 75 0c             	pushl  0xc(%ebp)
  800cd0:	6a 58                	push   $0x58
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 ce 00 00 00       	jmp    800dad <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800cdf:	83 ec 08             	sub    $0x8,%esp
  800ce2:	ff 75 0c             	pushl  0xc(%ebp)
  800ce5:	6a 30                	push   $0x30
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	ff d0                	call   *%eax
  800cec:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cef:	83 ec 08             	sub    $0x8,%esp
  800cf2:	ff 75 0c             	pushl  0xc(%ebp)
  800cf5:	6a 78                	push   $0x78
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	ff d0                	call   *%eax
  800cfc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d1a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d21:	eb 1f                	jmp    800d42 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d23:	83 ec 08             	sub    $0x8,%esp
  800d26:	ff 75 e8             	pushl  -0x18(%ebp)
  800d29:	8d 45 14             	lea    0x14(%ebp),%eax
  800d2c:	50                   	push   %eax
  800d2d:	e8 e7 fb ff ff       	call   800919 <getuint>
  800d32:	83 c4 10             	add    $0x10,%esp
  800d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d38:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d3b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d42:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d49:	83 ec 04             	sub    $0x4,%esp
  800d4c:	52                   	push   %edx
  800d4d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d50:	50                   	push   %eax
  800d51:	ff 75 f4             	pushl  -0xc(%ebp)
  800d54:	ff 75 f0             	pushl  -0x10(%ebp)
  800d57:	ff 75 0c             	pushl  0xc(%ebp)
  800d5a:	ff 75 08             	pushl  0x8(%ebp)
  800d5d:	e8 00 fb ff ff       	call   800862 <printnum>
  800d62:	83 c4 20             	add    $0x20,%esp
			break;
  800d65:	eb 46                	jmp    800dad <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d67:	83 ec 08             	sub    $0x8,%esp
  800d6a:	ff 75 0c             	pushl  0xc(%ebp)
  800d6d:	53                   	push   %ebx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	ff d0                	call   *%eax
  800d73:	83 c4 10             	add    $0x10,%esp
			break;
  800d76:	eb 35                	jmp    800dad <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800d78:	c6 05 44 30 80 00 00 	movb   $0x0,0x803044
			break;
  800d7f:	eb 2c                	jmp    800dad <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800d81:	c6 05 44 30 80 00 01 	movb   $0x1,0x803044
			break;
  800d88:	eb 23                	jmp    800dad <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 0c             	pushl  0xc(%ebp)
  800d90:	6a 25                	push   $0x25
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	ff d0                	call   *%eax
  800d97:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d9a:	ff 4d 10             	decl   0x10(%ebp)
  800d9d:	eb 03                	jmp    800da2 <vprintfmt+0x3c3>
  800d9f:	ff 4d 10             	decl   0x10(%ebp)
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	48                   	dec    %eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 25                	cmp    $0x25,%al
  800daa:	75 f3                	jne    800d9f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800dac:	90                   	nop
		}
	}
  800dad:	e9 35 fc ff ff       	jmp    8009e7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800db2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800dc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc3:	83 c0 04             	add    $0x4,%eax
  800dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	ff 75 f4             	pushl  -0xc(%ebp)
  800dcf:	50                   	push   %eax
  800dd0:	ff 75 0c             	pushl  0xc(%ebp)
  800dd3:	ff 75 08             	pushl  0x8(%ebp)
  800dd6:	e8 04 fc ff ff       	call   8009df <vprintfmt>
  800ddb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dde:	90                   	nop
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de7:	8b 40 08             	mov    0x8(%eax),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df6:	8b 10                	mov    (%eax),%edx
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8b 40 04             	mov    0x4(%eax),%eax
  800dfe:	39 c2                	cmp    %eax,%edx
  800e00:	73 12                	jae    800e14 <sprintputch+0x33>
		*b->buf++ = ch;
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	8d 48 01             	lea    0x1(%eax),%ecx
  800e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0d:	89 0a                	mov    %ecx,(%edx)
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
}
  800e14:	90                   	nop
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e3c:	74 06                	je     800e44 <vsnprintf+0x2d>
  800e3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e42:	7f 07                	jg     800e4b <vsnprintf+0x34>
		return -E_INVAL;
  800e44:	b8 03 00 00 00       	mov    $0x3,%eax
  800e49:	eb 20                	jmp    800e6b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e4b:	ff 75 14             	pushl  0x14(%ebp)
  800e4e:	ff 75 10             	pushl  0x10(%ebp)
  800e51:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e54:	50                   	push   %eax
  800e55:	68 e1 0d 80 00       	push   $0x800de1
  800e5a:	e8 80 fb ff ff       	call   8009df <vprintfmt>
  800e5f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e65:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e73:	8d 45 10             	lea    0x10(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e82:	50                   	push   %eax
  800e83:	ff 75 0c             	pushl  0xc(%ebp)
  800e86:	ff 75 08             	pushl  0x8(%ebp)
  800e89:	e8 89 ff ff ff       	call   800e17 <vsnprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e97:	c9                   	leave  
  800e98:	c3                   	ret    

00800e99 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ea6:	eb 06                	jmp    800eae <strlen+0x15>
		n++;
  800ea8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800eab:	ff 45 08             	incl   0x8(%ebp)
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	75 f1                	jne    800ea8 <strlen+0xf>
		n++;
	return n;
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec9:	eb 09                	jmp    800ed4 <strnlen+0x18>
		n++;
  800ecb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ece:	ff 45 08             	incl   0x8(%ebp)
  800ed1:	ff 4d 0c             	decl   0xc(%ebp)
  800ed4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed8:	74 09                	je     800ee3 <strnlen+0x27>
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 e8                	jne    800ecb <strnlen+0xf>
		n++;
	return n;
  800ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ee6:	c9                   	leave  
  800ee7:	c3                   	ret    

00800ee8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ef4:	90                   	nop
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8d 50 01             	lea    0x1(%eax),%edx
  800efb:	89 55 08             	mov    %edx,0x8(%ebp)
  800efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f01:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f07:	8a 12                	mov    (%edx),%dl
  800f09:	88 10                	mov    %dl,(%eax)
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	75 e4                	jne    800ef5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f22:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f29:	eb 1f                	jmp    800f4a <strncpy+0x34>
		*dst++ = *src;
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8d 50 01             	lea    0x1(%eax),%edx
  800f31:	89 55 08             	mov    %edx,0x8(%ebp)
  800f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f37:	8a 12                	mov    (%edx),%dl
  800f39:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	84 c0                	test   %al,%al
  800f42:	74 03                	je     800f47 <strncpy+0x31>
			src++;
  800f44:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f47:	ff 45 fc             	incl   -0x4(%ebp)
  800f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f50:	72 d9                	jb     800f2b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f67:	74 30                	je     800f99 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f69:	eb 16                	jmp    800f81 <strlcpy+0x2a>
			*dst++ = *src++;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8d 50 01             	lea    0x1(%eax),%edx
  800f71:	89 55 08             	mov    %edx,0x8(%ebp)
  800f74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f77:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f7a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f7d:	8a 12                	mov    (%edx),%dl
  800f7f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f81:	ff 4d 10             	decl   0x10(%ebp)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	74 09                	je     800f93 <strlcpy+0x3c>
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	84 c0                	test   %al,%al
  800f91:	75 d8                	jne    800f6b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	29 c2                	sub    %eax,%edx
  800fa1:	89 d0                	mov    %edx,%eax
}
  800fa3:	c9                   	leave  
  800fa4:	c3                   	ret    

00800fa5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800fa8:	eb 06                	jmp    800fb0 <strcmp+0xb>
		p++, q++;
  800faa:	ff 45 08             	incl   0x8(%ebp)
  800fad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	84 c0                	test   %al,%al
  800fb7:	74 0e                	je     800fc7 <strcmp+0x22>
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 10                	mov    (%eax),%dl
  800fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	38 c2                	cmp    %al,%dl
  800fc5:	74 e3                	je     800faa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f b6 d0             	movzbl %al,%edx
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	0f b6 c0             	movzbl %al,%eax
  800fd7:	29 c2                	sub    %eax,%edx
  800fd9:	89 d0                	mov    %edx,%eax
}
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fe0:	eb 09                	jmp    800feb <strncmp+0xe>
		n--, p++, q++;
  800fe2:	ff 4d 10             	decl   0x10(%ebp)
  800fe5:	ff 45 08             	incl   0x8(%ebp)
  800fe8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fef:	74 17                	je     801008 <strncmp+0x2b>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	74 0e                	je     801008 <strncmp+0x2b>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 10                	mov    (%eax),%dl
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	38 c2                	cmp    %al,%dl
  801006:	74 da                	je     800fe2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	75 07                	jne    801015 <strncmp+0x38>
		return 0;
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	eb 14                	jmp    801029 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	0f b6 d0             	movzbl %al,%edx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f b6 c0             	movzbl %al,%eax
  801025:	29 c2                	sub    %eax,%edx
  801027:	89 d0                	mov    %edx,%eax
}
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 04             	sub    $0x4,%esp
  801031:	8b 45 0c             	mov    0xc(%ebp),%eax
  801034:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801037:	eb 12                	jmp    80104b <strchr+0x20>
		if (*s == c)
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801041:	75 05                	jne    801048 <strchr+0x1d>
			return (char *) s;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	eb 11                	jmp    801059 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	84 c0                	test   %al,%al
  801052:	75 e5                	jne    801039 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 04             	sub    $0x4,%esp
  801061:	8b 45 0c             	mov    0xc(%ebp),%eax
  801064:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801067:	eb 0d                	jmp    801076 <strfind+0x1b>
		if (*s == c)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801071:	74 0e                	je     801081 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	84 c0                	test   %al,%al
  80107d:	75 ea                	jne    801069 <strfind+0xe>
  80107f:	eb 01                	jmp    801082 <strfind+0x27>
		if (*s == c)
			break;
  801081:	90                   	nop
	return (char *) s;
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801093:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801097:	76 63                	jbe    8010fc <memset+0x75>
		uint64 data_block = c;
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	99                   	cltd   
  80109d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8010a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a9:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8010ad:	c1 e0 08             	shl    $0x8,%eax
  8010b0:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010b3:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8010b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bc:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8010c0:	c1 e0 10             	shl    $0x10,%eax
  8010c3:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010c6:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8010c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010cf:	89 c2                	mov    %eax,%edx
  8010d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d6:	09 45 f0             	or     %eax,-0x10(%ebp)
  8010d9:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8010dc:	eb 18                	jmp    8010f6 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8010de:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010e1:	8d 41 08             	lea    0x8(%ecx),%eax
  8010e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8010e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ed:	89 01                	mov    %eax,(%ecx)
  8010ef:	89 51 04             	mov    %edx,0x4(%ecx)
  8010f2:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8010f6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8010fa:	77 e2                	ja     8010de <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8010fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801100:	74 23                	je     801125 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801105:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801108:	eb 0e                	jmp    801118 <memset+0x91>
			*p8++ = (uint8)c;
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	8d 50 01             	lea    0x1(%eax),%edx
  801110:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801113:	8b 55 0c             	mov    0xc(%ebp),%edx
  801116:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	89 55 10             	mov    %edx,0x10(%ebp)
  801121:	85 c0                	test   %eax,%eax
  801123:	75 e5                	jne    80110a <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80113c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801140:	76 24                	jbe    801166 <memcpy+0x3c>
		while(n >= 8){
  801142:	eb 1c                	jmp    801160 <memcpy+0x36>
			*d64 = *s64;
  801144:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801147:	8b 50 04             	mov    0x4(%eax),%edx
  80114a:	8b 00                	mov    (%eax),%eax
  80114c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80114f:	89 01                	mov    %eax,(%ecx)
  801151:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801154:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801158:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80115c:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801160:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801164:	77 de                	ja     801144 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801166:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116a:	74 31                	je     80119d <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80116c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801172:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801178:	eb 16                	jmp    801190 <memcpy+0x66>
			*d8++ = *s8++;
  80117a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117d:	8d 50 01             	lea    0x1(%eax),%edx
  801180:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801186:	8d 4a 01             	lea    0x1(%edx),%ecx
  801189:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80118c:	8a 12                	mov    (%edx),%dl
  80118e:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	8d 50 ff             	lea    -0x1(%eax),%edx
  801196:	89 55 10             	mov    %edx,0x10(%ebp)
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 dd                	jne    80117a <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011ba:	73 50                	jae    80120c <memmove+0x6a>
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8011c7:	76 43                	jbe    80120c <memmove+0x6a>
		s += n;
  8011c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cc:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8011d5:	eb 10                	jmp    8011e7 <memmove+0x45>
			*--d = *--s;
  8011d7:	ff 4d f8             	decl   -0x8(%ebp)
  8011da:	ff 4d fc             	decl   -0x4(%ebp)
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 10                	mov    (%eax),%dl
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8011e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	75 e3                	jne    8011d7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011f4:	eb 23                	jmp    801219 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8011f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f9:	8d 50 01             	lea    0x1(%eax),%edx
  8011fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801202:	8d 4a 01             	lea    0x1(%edx),%ecx
  801205:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801208:	8a 12                	mov    (%edx),%dl
  80120a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801212:	89 55 10             	mov    %edx,0x10(%ebp)
  801215:	85 c0                	test   %eax,%eax
  801217:	75 dd                	jne    8011f6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801230:	eb 2a                	jmp    80125c <memcmp+0x3e>
		if (*s1 != *s2)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 16                	je     801256 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f b6 d0             	movzbl %al,%edx
  801248:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	0f b6 c0             	movzbl %al,%eax
  801250:	29 c2                	sub    %eax,%edx
  801252:	89 d0                	mov    %edx,%eax
  801254:	eb 18                	jmp    80126e <memcmp+0x50>
		s1++, s2++;
  801256:	ff 45 fc             	incl   -0x4(%ebp)
  801259:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80125c:	8b 45 10             	mov    0x10(%ebp),%eax
  80125f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801262:	89 55 10             	mov    %edx,0x10(%ebp)
  801265:	85 c0                	test   %eax,%eax
  801267:	75 c9                	jne    801232 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801276:	8b 55 08             	mov    0x8(%ebp),%edx
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801281:	eb 15                	jmp    801298 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	0f b6 d0             	movzbl %al,%edx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	0f b6 c0             	movzbl %al,%eax
  801291:	39 c2                	cmp    %eax,%edx
  801293:	74 0d                	je     8012a2 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801295:	ff 45 08             	incl   0x8(%ebp)
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80129e:	72 e3                	jb     801283 <memfind+0x13>
  8012a0:	eb 01                	jmp    8012a3 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8012a2:	90                   	nop
	return (void *) s;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8012ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012bc:	eb 03                	jmp    8012c1 <strtol+0x19>
		s++;
  8012be:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 20                	cmp    $0x20,%al
  8012c8:	74 f4                	je     8012be <strtol+0x16>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 09                	cmp    $0x9,%al
  8012d1:	74 eb                	je     8012be <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	3c 2b                	cmp    $0x2b,%al
  8012da:	75 05                	jne    8012e1 <strtol+0x39>
		s++;
  8012dc:	ff 45 08             	incl   0x8(%ebp)
  8012df:	eb 13                	jmp    8012f4 <strtol+0x4c>
	else if (*s == '-')
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	3c 2d                	cmp    $0x2d,%al
  8012e8:	75 0a                	jne    8012f4 <strtol+0x4c>
		s++, neg = 1;
  8012ea:	ff 45 08             	incl   0x8(%ebp)
  8012ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f8:	74 06                	je     801300 <strtol+0x58>
  8012fa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8012fe:	75 20                	jne    801320 <strtol+0x78>
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	3c 30                	cmp    $0x30,%al
  801307:	75 17                	jne    801320 <strtol+0x78>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	40                   	inc    %eax
  80130d:	8a 00                	mov    (%eax),%al
  80130f:	3c 78                	cmp    $0x78,%al
  801311:	75 0d                	jne    801320 <strtol+0x78>
		s += 2, base = 16;
  801313:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801317:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80131e:	eb 28                	jmp    801348 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801324:	75 15                	jne    80133b <strtol+0x93>
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	3c 30                	cmp    $0x30,%al
  80132d:	75 0c                	jne    80133b <strtol+0x93>
		s++, base = 8;
  80132f:	ff 45 08             	incl   0x8(%ebp)
  801332:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801339:	eb 0d                	jmp    801348 <strtol+0xa0>
	else if (base == 0)
  80133b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80133f:	75 07                	jne    801348 <strtol+0xa0>
		base = 10;
  801341:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801348:	8b 45 08             	mov    0x8(%ebp),%eax
  80134b:	8a 00                	mov    (%eax),%al
  80134d:	3c 2f                	cmp    $0x2f,%al
  80134f:	7e 19                	jle    80136a <strtol+0xc2>
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	8a 00                	mov    (%eax),%al
  801356:	3c 39                	cmp    $0x39,%al
  801358:	7f 10                	jg     80136a <strtol+0xc2>
			dig = *s - '0';
  80135a:	8b 45 08             	mov    0x8(%ebp),%eax
  80135d:	8a 00                	mov    (%eax),%al
  80135f:	0f be c0             	movsbl %al,%eax
  801362:	83 e8 30             	sub    $0x30,%eax
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801368:	eb 42                	jmp    8013ac <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	3c 60                	cmp    $0x60,%al
  801371:	7e 19                	jle    80138c <strtol+0xe4>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	3c 7a                	cmp    $0x7a,%al
  80137a:	7f 10                	jg     80138c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	0f be c0             	movsbl %al,%eax
  801384:	83 e8 57             	sub    $0x57,%eax
  801387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80138a:	eb 20                	jmp    8013ac <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	3c 40                	cmp    $0x40,%al
  801393:	7e 39                	jle    8013ce <strtol+0x126>
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	3c 5a                	cmp    $0x5a,%al
  80139c:	7f 30                	jg     8013ce <strtol+0x126>
			dig = *s - 'A' + 10;
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	0f be c0             	movsbl %al,%eax
  8013a6:	83 e8 37             	sub    $0x37,%eax
  8013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013b2:	7d 19                	jge    8013cd <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8013b4:	ff 45 08             	incl   0x8(%ebp)
  8013b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ba:	0f af 45 10          	imul   0x10(%ebp),%eax
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8013c8:	e9 7b ff ff ff       	jmp    801348 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8013cd:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8013ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013d2:	74 08                	je     8013dc <strtol+0x134>
		*endptr = (char *) s;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8013da:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8013dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013e0:	74 07                	je     8013e9 <strtol+0x141>
  8013e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e5:	f7 d8                	neg    %eax
  8013e7:	eb 03                	jmp    8013ec <strtol+0x144>
  8013e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <ltostr>:

void
ltostr(long value, char *str)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8013f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801402:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801406:	79 13                	jns    80141b <ltostr+0x2d>
	{
		neg = 1;
  801408:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801415:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801418:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801423:	99                   	cltd   
  801424:	f7 f9                	idiv   %ecx
  801426:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801429:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142c:	8d 50 01             	lea    0x1(%eax),%edx
  80142f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801432:	89 c2                	mov    %eax,%edx
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	01 d0                	add    %edx,%eax
  801439:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80143c:	83 c2 30             	add    $0x30,%edx
  80143f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801441:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801444:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801449:	f7 e9                	imul   %ecx
  80144b:	c1 fa 02             	sar    $0x2,%edx
  80144e:	89 c8                	mov    %ecx,%eax
  801450:	c1 f8 1f             	sar    $0x1f,%eax
  801453:	29 c2                	sub    %eax,%edx
  801455:	89 d0                	mov    %edx,%eax
  801457:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80145a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80145e:	75 bb                	jne    80141b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801467:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80146a:	48                   	dec    %eax
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80146e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801472:	74 3d                	je     8014b1 <ltostr+0xc3>
		start = 1 ;
  801474:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80147b:	eb 34                	jmp    8014b1 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80147d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801480:	8b 45 0c             	mov    0xc(%ebp),%eax
  801483:	01 d0                	add    %edx,%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	01 c2                	add    %eax,%edx
  801492:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	01 c8                	add    %ecx,%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80149e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	01 c2                	add    %eax,%edx
  8014a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8014a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8014ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8014ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014b7:	7c c4                	jl     80147d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8014b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	01 d0                	add    %edx,%eax
  8014c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8014c4:	90                   	nop
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8014cd:	ff 75 08             	pushl  0x8(%ebp)
  8014d0:	e8 c4 f9 ff ff       	call   800e99 <strlen>
  8014d5:	83 c4 04             	add    $0x4,%esp
  8014d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	e8 b6 f9 ff ff       	call   800e99 <strlen>
  8014e3:	83 c4 04             	add    $0x4,%esp
  8014e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014f7:	eb 17                	jmp    801510 <strcconcat+0x49>
		final[s] = str1[s] ;
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	01 c2                	add    %eax,%edx
  801501:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	01 c8                	add    %ecx,%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80150d:	ff 45 fc             	incl   -0x4(%ebp)
  801510:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801513:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801516:	7c e1                	jl     8014f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801518:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80151f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801526:	eb 1f                	jmp    801547 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	8d 50 01             	lea    0x1(%eax),%edx
  80152e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801531:	89 c2                	mov    %eax,%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 c2                	add    %eax,%edx
  801538:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80153b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153e:	01 c8                	add    %ecx,%eax
  801540:	8a 00                	mov    (%eax),%al
  801542:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801544:	ff 45 f8             	incl   -0x8(%ebp)
  801547:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80154a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80154d:	7c d9                	jl     801528 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80154f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801552:	8b 45 10             	mov    0x10(%ebp),%eax
  801555:	01 d0                	add    %edx,%eax
  801557:	c6 00 00             	movb   $0x0,(%eax)
}
  80155a:	90                   	nop
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801569:	8b 45 14             	mov    0x14(%ebp),%eax
  80156c:	8b 00                	mov    (%eax),%eax
  80156e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	01 d0                	add    %edx,%eax
  80157a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801580:	eb 0c                	jmp    80158e <strsplit+0x31>
			*string++ = 0;
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	8d 50 01             	lea    0x1(%eax),%edx
  801588:	89 55 08             	mov    %edx,0x8(%ebp)
  80158b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	8a 00                	mov    (%eax),%al
  801593:	84 c0                	test   %al,%al
  801595:	74 18                	je     8015af <strsplit+0x52>
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f be c0             	movsbl %al,%eax
  80159f:	50                   	push   %eax
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	e8 83 fa ff ff       	call   80102b <strchr>
  8015a8:	83 c4 08             	add    $0x8,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	75 d3                	jne    801582 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	84 c0                	test   %al,%al
  8015b6:	74 5a                	je     801612 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	8b 00                	mov    (%eax),%eax
  8015bd:	83 f8 0f             	cmp    $0xf,%eax
  8015c0:	75 07                	jne    8015c9 <strsplit+0x6c>
		{
			return 0;
  8015c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c7:	eb 66                	jmp    80162f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8015c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8015d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8015d4:	89 0a                	mov    %ecx,(%edx)
  8015d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e0:	01 c2                	add    %eax,%edx
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015e7:	eb 03                	jmp    8015ec <strsplit+0x8f>
			string++;
  8015e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	8a 00                	mov    (%eax),%al
  8015f1:	84 c0                	test   %al,%al
  8015f3:	74 8b                	je     801580 <strsplit+0x23>
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	0f be c0             	movsbl %al,%eax
  8015fd:	50                   	push   %eax
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	e8 25 fa ff ff       	call   80102b <strchr>
  801606:	83 c4 08             	add    $0x8,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 dc                	je     8015e9 <strsplit+0x8c>
			string++;
	}
  80160d:	e9 6e ff ff ff       	jmp    801580 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801612:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801613:	8b 45 14             	mov    0x14(%ebp),%eax
  801616:	8b 00                	mov    (%eax),%eax
  801618:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80161f:	8b 45 10             	mov    0x10(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80162a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  80163d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801644:	eb 4a                	jmp    801690 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801646:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801649:	8b 45 08             	mov    0x8(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801651:	8b 45 0c             	mov    0xc(%ebp),%eax
  801654:	01 c8                	add    %ecx,%eax
  801656:	8a 00                	mov    (%eax),%al
  801658:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  80165a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801660:	01 d0                	add    %edx,%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	3c 40                	cmp    $0x40,%al
  801666:	7e 25                	jle    80168d <str2lower+0x5c>
  801668:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 5a                	cmp    $0x5a,%al
  801674:	7f 17                	jg     80168d <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801676:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801681:	8b 55 08             	mov    0x8(%ebp),%edx
  801684:	01 ca                	add    %ecx,%edx
  801686:	8a 12                	mov    (%edx),%dl
  801688:	83 c2 20             	add    $0x20,%edx
  80168b:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  80168d:	ff 45 fc             	incl   -0x4(%ebp)
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	e8 01 f8 ff ff       	call   800e99 <strlen>
  801698:	83 c4 04             	add    $0x4,%esp
  80169b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80169e:	7f a6                	jg     801646 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8016a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	57                   	push   %edi
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016c0:	cd 30                	int    $0x30
  8016c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8016dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	6a 00                	push   $0x0
  8016e8:	51                   	push   %ecx
  8016e9:	52                   	push   %edx
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	50                   	push   %eax
  8016ee:	6a 00                	push   $0x0
  8016f0:	e8 b0 ff ff ff       	call   8016a5 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	90                   	nop
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <sys_cgetc>:

int
sys_cgetc(void)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 02                	push   $0x2
  80170a:	e8 96 ff ff ff       	call   8016a5 <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 03                	push   $0x3
  801723:	e8 7d ff ff ff       	call   8016a5 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 04                	push   $0x4
  80173d:	e8 63 ff ff ff       	call   8016a5 <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	90                   	nop
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80174b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	52                   	push   %edx
  801758:	50                   	push   %eax
  801759:	6a 08                	push   $0x8
  80175b:	e8 45 ff ff ff       	call   8016a5 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80176a:	8b 75 18             	mov    0x18(%ebp),%esi
  80176d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801770:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801773:	8b 55 0c             	mov    0xc(%ebp),%edx
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	51                   	push   %ecx
  80177c:	52                   	push   %edx
  80177d:	50                   	push   %eax
  80177e:	6a 09                	push   $0x9
  801780:	e8 20 ff ff ff       	call   8016a5 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178b:	5b                   	pop    %ebx
  80178c:	5e                   	pop    %esi
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    

0080178f <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	ff 75 08             	pushl  0x8(%ebp)
  80179d:	6a 0a                	push   $0xa
  80179f:	e8 01 ff ff ff       	call   8016a5 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	ff 75 0c             	pushl  0xc(%ebp)
  8017b5:	ff 75 08             	pushl  0x8(%ebp)
  8017b8:	6a 0b                	push   $0xb
  8017ba:	e8 e6 fe ff ff       	call   8016a5 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 0c                	push   $0xc
  8017d3:	e8 cd fe ff ff       	call   8016a5 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 0d                	push   $0xd
  8017ec:	e8 b4 fe ff ff       	call   8016a5 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 0e                	push   $0xe
  801805:	e8 9b fe ff ff       	call   8016a5 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 0f                	push   $0xf
  80181e:	e8 82 fe ff ff       	call   8016a5 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 10                	push   $0x10
  801838:	e8 68 fe ff ff       	call   8016a5 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 11                	push   $0x11
  801851:	e8 4f fe ff ff       	call   8016a5 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	90                   	nop
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_cputc>:

void
sys_cputc(const char c)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801868:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	50                   	push   %eax
  801875:	6a 01                	push   $0x1
  801877:	e8 29 fe ff ff       	call   8016a5 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 14                	push   $0x14
  801891:	e8 0f fe ff ff       	call   8016a5 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	51                   	push   %ecx
  8018b5:	52                   	push   %edx
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	6a 15                	push   $0x15
  8018bc:	e8 e4 fd ff ff       	call   8016a5 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 16                	push   $0x16
  8018d9:	e8 c7 fd ff ff       	call   8016a5 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	51                   	push   %ecx
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 17                	push   $0x17
  8018f8:	e8 a8 fd ff ff       	call   8016a5 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 18                	push   $0x18
  801915:	e8 8b fd ff ff       	call   8016a5 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	ff 75 14             	pushl  0x14(%ebp)
  80192a:	ff 75 10             	pushl  0x10(%ebp)
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	50                   	push   %eax
  801931:	6a 19                	push   $0x19
  801933:	e8 6d fd ff ff       	call   8016a5 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_run_env>:

void sys_run_env(int32 envId)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	50                   	push   %eax
  80194c:	6a 1a                	push   $0x1a
  80194e:	e8 52 fd ff ff       	call   8016a5 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	50                   	push   %eax
  801968:	6a 1b                	push   $0x1b
  80196a:	e8 36 fd ff ff       	call   8016a5 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 05                	push   $0x5
  801983:	e8 1d fd ff ff       	call   8016a5 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 06                	push   $0x6
  80199c:	e8 04 fd ff ff       	call   8016a5 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 07                	push   $0x7
  8019b5:	e8 eb fc ff ff       	call   8016a5 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_exit_env>:


void sys_exit_env(void)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 1c                	push   $0x1c
  8019ce:	e8 d2 fc ff ff       	call   8016a5 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019df:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019e2:	8d 50 04             	lea    0x4(%eax),%edx
  8019e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 1d                	push   $0x1d
  8019f2:	e8 ae fc ff ff       	call   8016a5 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return result;
  8019fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a03:	89 01                	mov    %eax,(%ecx)
  801a05:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	c9                   	leave  
  801a0c:	c2 04 00             	ret    $0x4

00801a0f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	6a 13                	push   $0x13
  801a21:	e8 7f fc ff ff       	call   8016a5 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_rcr2>:
uint32 sys_rcr2()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 1e                	push   $0x1e
  801a3b:	e8 65 fc ff ff       	call   8016a5 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a51:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	50                   	push   %eax
  801a5e:	6a 1f                	push   $0x1f
  801a60:	e8 40 fc ff ff       	call   8016a5 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
	return ;
  801a68:	90                   	nop
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <rsttst>:
void rsttst()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 21                	push   $0x21
  801a7a:	e8 26 fc ff ff       	call   8016a5 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a82:	90                   	nop
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a91:	8b 55 18             	mov    0x18(%ebp),%edx
  801a94:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a98:	52                   	push   %edx
  801a99:	50                   	push   %eax
  801a9a:	ff 75 10             	pushl  0x10(%ebp)
  801a9d:	ff 75 0c             	pushl  0xc(%ebp)
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	6a 20                	push   $0x20
  801aa5:	e8 fb fb ff ff       	call   8016a5 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
	return ;
  801aad:	90                   	nop
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <chktst>:
void chktst(uint32 n)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 22                	push   $0x22
  801ac0:	e8 e0 fb ff ff       	call   8016a5 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <inctst>:

void inctst()
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 23                	push   $0x23
  801ada:	e8 c6 fb ff ff       	call   8016a5 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae2:	90                   	nop
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <gettst>:
uint32 gettst()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 24                	push   $0x24
  801af4:	e8 ac fb ff ff       	call   8016a5 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 25                	push   $0x25
  801b0d:	e8 93 fb ff ff       	call   8016a5 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
  801b15:	a3 60 b0 81 00       	mov    %eax,0x81b060
	return uheapPlaceStrategy ;
  801b1a:	a1 60 b0 81 00       	mov    0x81b060,%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 60 b0 81 00       	mov    %eax,0x81b060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 08             	pushl  0x8(%ebp)
  801b37:	6a 26                	push   $0x26
  801b39:	e8 67 fb ff ff       	call   8016a5 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b41:	90                   	nop
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	53                   	push   %ebx
  801b57:	51                   	push   %ecx
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 27                	push   $0x27
  801b5c:	e8 44 fb ff ff       	call   8016a5 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	52                   	push   %edx
  801b79:	50                   	push   %eax
  801b7a:	6a 28                	push   $0x28
  801b7c:	e8 24 fb ff ff       	call   8016a5 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b89:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	51                   	push   %ecx
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 29                	push   $0x29
  801b9c:	e8 04 fb ff ff       	call   8016a5 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 10             	pushl  0x10(%ebp)
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 12                	push   $0x12
  801bb8:	e8 e8 fa ff ff       	call   8016a5 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 2a                	push   $0x2a
  801bd6:	e8 ca fa ff ff       	call   8016a5 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 2b                	push   $0x2b
  801bf0:	e8 b0 fa ff ff       	call   8016a5 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 2d                	push   $0x2d
  801c0b:	e8 95 fa ff ff       	call   8016a5 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	ff 75 0c             	pushl  0xc(%ebp)
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 2c                	push   $0x2c
  801c27:	e8 79 fa ff ff       	call   8016a5 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	68 28 27 80 00       	push   $0x802728
  801c40:	68 25 01 00 00       	push   $0x125
  801c45:	68 5b 27 80 00       	push   $0x80275b
  801c4a:	e8 a3 e8 ff ff       	call   8004f2 <_panic>
  801c4f:	90                   	nop

00801c50 <__udivdi3>:
  801c50:	55                   	push   %ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
  801c57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c67:	89 ca                	mov    %ecx,%edx
  801c69:	89 f8                	mov    %edi,%eax
  801c6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c6f:	85 f6                	test   %esi,%esi
  801c71:	75 2d                	jne    801ca0 <__udivdi3+0x50>
  801c73:	39 cf                	cmp    %ecx,%edi
  801c75:	77 65                	ja     801cdc <__udivdi3+0x8c>
  801c77:	89 fd                	mov    %edi,%ebp
  801c79:	85 ff                	test   %edi,%edi
  801c7b:	75 0b                	jne    801c88 <__udivdi3+0x38>
  801c7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c82:	31 d2                	xor    %edx,%edx
  801c84:	f7 f7                	div    %edi
  801c86:	89 c5                	mov    %eax,%ebp
  801c88:	31 d2                	xor    %edx,%edx
  801c8a:	89 c8                	mov    %ecx,%eax
  801c8c:	f7 f5                	div    %ebp
  801c8e:	89 c1                	mov    %eax,%ecx
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	f7 f5                	div    %ebp
  801c94:	89 cf                	mov    %ecx,%edi
  801c96:	89 fa                	mov    %edi,%edx
  801c98:	83 c4 1c             	add    $0x1c,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    
  801ca0:	39 ce                	cmp    %ecx,%esi
  801ca2:	77 28                	ja     801ccc <__udivdi3+0x7c>
  801ca4:	0f bd fe             	bsr    %esi,%edi
  801ca7:	83 f7 1f             	xor    $0x1f,%edi
  801caa:	75 40                	jne    801cec <__udivdi3+0x9c>
  801cac:	39 ce                	cmp    %ecx,%esi
  801cae:	72 0a                	jb     801cba <__udivdi3+0x6a>
  801cb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801cb4:	0f 87 9e 00 00 00    	ja     801d58 <__udivdi3+0x108>
  801cba:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbf:	89 fa                	mov    %edi,%edx
  801cc1:	83 c4 1c             	add    $0x1c,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
  801cc9:	8d 76 00             	lea    0x0(%esi),%esi
  801ccc:	31 ff                	xor    %edi,%edi
  801cce:	31 c0                	xor    %eax,%eax
  801cd0:	89 fa                	mov    %edi,%edx
  801cd2:	83 c4 1c             	add    $0x1c,%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	f7 f7                	div    %edi
  801ce0:	31 ff                	xor    %edi,%edi
  801ce2:	89 fa                	mov    %edi,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cf1:	89 eb                	mov    %ebp,%ebx
  801cf3:	29 fb                	sub    %edi,%ebx
  801cf5:	89 f9                	mov    %edi,%ecx
  801cf7:	d3 e6                	shl    %cl,%esi
  801cf9:	89 c5                	mov    %eax,%ebp
  801cfb:	88 d9                	mov    %bl,%cl
  801cfd:	d3 ed                	shr    %cl,%ebp
  801cff:	89 e9                	mov    %ebp,%ecx
  801d01:	09 f1                	or     %esi,%ecx
  801d03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d07:	89 f9                	mov    %edi,%ecx
  801d09:	d3 e0                	shl    %cl,%eax
  801d0b:	89 c5                	mov    %eax,%ebp
  801d0d:	89 d6                	mov    %edx,%esi
  801d0f:	88 d9                	mov    %bl,%cl
  801d11:	d3 ee                	shr    %cl,%esi
  801d13:	89 f9                	mov    %edi,%ecx
  801d15:	d3 e2                	shl    %cl,%edx
  801d17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1b:	88 d9                	mov    %bl,%cl
  801d1d:	d3 e8                	shr    %cl,%eax
  801d1f:	09 c2                	or     %eax,%edx
  801d21:	89 d0                	mov    %edx,%eax
  801d23:	89 f2                	mov    %esi,%edx
  801d25:	f7 74 24 0c          	divl   0xc(%esp)
  801d29:	89 d6                	mov    %edx,%esi
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	f7 e5                	mul    %ebp
  801d2f:	39 d6                	cmp    %edx,%esi
  801d31:	72 19                	jb     801d4c <__udivdi3+0xfc>
  801d33:	74 0b                	je     801d40 <__udivdi3+0xf0>
  801d35:	89 d8                	mov    %ebx,%eax
  801d37:	31 ff                	xor    %edi,%edi
  801d39:	e9 58 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d3e:	66 90                	xchg   %ax,%ax
  801d40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d44:	89 f9                	mov    %edi,%ecx
  801d46:	d3 e2                	shl    %cl,%edx
  801d48:	39 c2                	cmp    %eax,%edx
  801d4a:	73 e9                	jae    801d35 <__udivdi3+0xe5>
  801d4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d4f:	31 ff                	xor    %edi,%edi
  801d51:	e9 40 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	31 c0                	xor    %eax,%eax
  801d5a:	e9 37 ff ff ff       	jmp    801c96 <__udivdi3+0x46>
  801d5f:	90                   	nop

00801d60 <__umoddi3>:
  801d60:	55                   	push   %ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 1c             	sub    $0x1c,%esp
  801d67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d7f:	89 f3                	mov    %esi,%ebx
  801d81:	89 fa                	mov    %edi,%edx
  801d83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d87:	89 34 24             	mov    %esi,(%esp)
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	75 1a                	jne    801da8 <__umoddi3+0x48>
  801d8e:	39 f7                	cmp    %esi,%edi
  801d90:	0f 86 a2 00 00 00    	jbe    801e38 <__umoddi3+0xd8>
  801d96:	89 c8                	mov    %ecx,%eax
  801d98:	89 f2                	mov    %esi,%edx
  801d9a:	f7 f7                	div    %edi
  801d9c:	89 d0                	mov    %edx,%eax
  801d9e:	31 d2                	xor    %edx,%edx
  801da0:	83 c4 1c             	add    $0x1c,%esp
  801da3:	5b                   	pop    %ebx
  801da4:	5e                   	pop    %esi
  801da5:	5f                   	pop    %edi
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    
  801da8:	39 f0                	cmp    %esi,%eax
  801daa:	0f 87 ac 00 00 00    	ja     801e5c <__umoddi3+0xfc>
  801db0:	0f bd e8             	bsr    %eax,%ebp
  801db3:	83 f5 1f             	xor    $0x1f,%ebp
  801db6:	0f 84 ac 00 00 00    	je     801e68 <__umoddi3+0x108>
  801dbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801dc1:	29 ef                	sub    %ebp,%edi
  801dc3:	89 fe                	mov    %edi,%esi
  801dc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 e0                	shl    %cl,%eax
  801dcd:	89 d7                	mov    %edx,%edi
  801dcf:	89 f1                	mov    %esi,%ecx
  801dd1:	d3 ef                	shr    %cl,%edi
  801dd3:	09 c7                	or     %eax,%edi
  801dd5:	89 e9                	mov    %ebp,%ecx
  801dd7:	d3 e2                	shl    %cl,%edx
  801dd9:	89 14 24             	mov    %edx,(%esp)
  801ddc:	89 d8                	mov    %ebx,%eax
  801dde:	d3 e0                	shl    %cl,%eax
  801de0:	89 c2                	mov    %eax,%edx
  801de2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de6:	d3 e0                	shl    %cl,%eax
  801de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801df0:	89 f1                	mov    %esi,%ecx
  801df2:	d3 e8                	shr    %cl,%eax
  801df4:	09 d0                	or     %edx,%eax
  801df6:	d3 eb                	shr    %cl,%ebx
  801df8:	89 da                	mov    %ebx,%edx
  801dfa:	f7 f7                	div    %edi
  801dfc:	89 d3                	mov    %edx,%ebx
  801dfe:	f7 24 24             	mull   (%esp)
  801e01:	89 c6                	mov    %eax,%esi
  801e03:	89 d1                	mov    %edx,%ecx
  801e05:	39 d3                	cmp    %edx,%ebx
  801e07:	0f 82 87 00 00 00    	jb     801e94 <__umoddi3+0x134>
  801e0d:	0f 84 91 00 00 00    	je     801ea4 <__umoddi3+0x144>
  801e13:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e17:	29 f2                	sub    %esi,%edx
  801e19:	19 cb                	sbb    %ecx,%ebx
  801e1b:	89 d8                	mov    %ebx,%eax
  801e1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e21:	d3 e0                	shl    %cl,%eax
  801e23:	89 e9                	mov    %ebp,%ecx
  801e25:	d3 ea                	shr    %cl,%edx
  801e27:	09 d0                	or     %edx,%eax
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	d3 eb                	shr    %cl,%ebx
  801e2d:	89 da                	mov    %ebx,%edx
  801e2f:	83 c4 1c             	add    $0x1c,%esp
  801e32:	5b                   	pop    %ebx
  801e33:	5e                   	pop    %esi
  801e34:	5f                   	pop    %edi
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    
  801e37:	90                   	nop
  801e38:	89 fd                	mov    %edi,%ebp
  801e3a:	85 ff                	test   %edi,%edi
  801e3c:	75 0b                	jne    801e49 <__umoddi3+0xe9>
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	31 d2                	xor    %edx,%edx
  801e45:	f7 f7                	div    %edi
  801e47:	89 c5                	mov    %eax,%ebp
  801e49:	89 f0                	mov    %esi,%eax
  801e4b:	31 d2                	xor    %edx,%edx
  801e4d:	f7 f5                	div    %ebp
  801e4f:	89 c8                	mov    %ecx,%eax
  801e51:	f7 f5                	div    %ebp
  801e53:	89 d0                	mov    %edx,%eax
  801e55:	e9 44 ff ff ff       	jmp    801d9e <__umoddi3+0x3e>
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	89 c8                	mov    %ecx,%eax
  801e5e:	89 f2                	mov    %esi,%edx
  801e60:	83 c4 1c             	add    $0x1c,%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    
  801e68:	3b 04 24             	cmp    (%esp),%eax
  801e6b:	72 06                	jb     801e73 <__umoddi3+0x113>
  801e6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e71:	77 0f                	ja     801e82 <__umoddi3+0x122>
  801e73:	89 f2                	mov    %esi,%edx
  801e75:	29 f9                	sub    %edi,%ecx
  801e77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e7b:	89 14 24             	mov    %edx,(%esp)
  801e7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e82:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e86:	8b 14 24             	mov    (%esp),%edx
  801e89:	83 c4 1c             	add    $0x1c,%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5f                   	pop    %edi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    
  801e91:	8d 76 00             	lea    0x0(%esi),%esi
  801e94:	2b 04 24             	sub    (%esp),%eax
  801e97:	19 fa                	sbb    %edi,%edx
  801e99:	89 d1                	mov    %edx,%ecx
  801e9b:	89 c6                	mov    %eax,%esi
  801e9d:	e9 71 ff ff ff       	jmp    801e13 <__umoddi3+0xb3>
  801ea2:	66 90                	xchg   %ax,%ax
  801ea4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ea8:	72 ea                	jb     801e94 <__umoddi3+0x134>
  801eaa:	89 d9                	mov    %ebx,%ecx
  801eac:	e9 62 ff ff ff       	jmp    801e13 <__umoddi3+0xb3>
