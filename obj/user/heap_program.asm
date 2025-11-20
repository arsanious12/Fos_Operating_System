
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 12 02 00 00       	call   800248 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 32 16 00 00       	call   80169d <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 21 16 00 00       	call   80169d <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 5a 18 00 00       	call   8018e1 <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 da 15 00 00       	call   8016cb <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 cc 15 00 00       	call   8016cb <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 8f 17 00 00       	call   801896 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 88 15 00 00       	call   80169d <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 3c 2b 80 00       	mov    $0x802b3c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	e9 81 00 00 00       	jmp    8001f1 <_main+0x1b9>
		{
			int found = 0 ;
  800170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800177:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017e:	eb 3d                	jmp    8001bd <_main+0x185>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  800180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800183:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	8b 98 38 da 01 00    	mov    0x1da38(%eax),%ebx
  800192:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800195:	89 d0                	mov    %edx,%eax
  800197:	01 c0                	add    %eax,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	c1 e0 03             	shl    $0x3,%eax
  80019e:	01 d8                	add    %ebx,%eax
  8001a0:	8b 00                	mov    (%eax),%eax
  8001a2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	39 c1                	cmp    %eax,%ecx
  8001af:	75 09                	jne    8001ba <_main+0x182>
				{
					found = 1 ;
  8001b1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b8:	eb 15                	jmp    8001cf <_main+0x197>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001ba:	ff 45 e0             	incl   -0x20(%ebp)
  8001bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8001c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001cb:	39 c2                	cmp    %eax,%edx
  8001cd:	77 b1                	ja     800180 <_main+0x148>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d3:	75 19                	jne    8001ee <_main+0x1b6>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d8:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001dc:	50                   	push   %eax
  8001dd:	68 40 2a 80 00       	push   $0x802a40
  8001e2:	6a 4c                	push   $0x4c
  8001e4:	68 a1 2a 80 00       	push   $0x802aa1
  8001e9:	e8 1f 02 00 00       	call   80040d <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001ee:	ff 45 e4             	incl   -0x1c(%ebp)
  8001f1:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001f5:	0f 8e 75 ff ff ff    	jle    800170 <_main+0x138>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001fb:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001fe:	e8 93 16 00 00       	call   801896 <sys_calculate_free_frames>
  800203:	29 c3                	sub    %eax,%ebx
  800205:	89 d8                	mov    %ebx,%eax
  800207:	83 f8 06             	cmp    $0x6,%eax
  80020a:	74 23                	je     80022f <_main+0x1f7>
  80020c:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  80020f:	e8 82 16 00 00       	call   801896 <sys_calculate_free_frames>
  800214:	29 c3                	sub    %eax,%ebx
  800216:	89 d8                	mov    %ebx,%eax
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	6a 08                	push   $0x8
  80021d:	50                   	push   %eax
  80021e:	68 b8 2a 80 00       	push   $0x802ab8
  800223:	6a 4f                	push   $0x4f
  800225:	68 a1 2a 80 00       	push   $0x802aa1
  80022a:	e8 de 01 00 00       	call   80040d <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 fc 2a 80 00       	push   $0x802afc
  800237:	e8 9f 04 00 00       	call   8006db <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp


	return;
  80023f:	90                   	nop
}
  800240:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800243:	5b                   	pop    %ebx
  800244:	5e                   	pop    %esi
  800245:	5f                   	pop    %edi
  800246:	5d                   	pop    %ebp
  800247:	c3                   	ret    

00800248 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	57                   	push   %edi
  80024c:	56                   	push   %esi
  80024d:	53                   	push   %ebx
  80024e:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800251:	e8 09 18 00 00       	call   801a5f <sys_getenvindex>
  800256:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800259:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80025c:	89 d0                	mov    %edx,%eax
  80025e:	c1 e0 06             	shl    $0x6,%eax
  800261:	29 d0                	sub    %edx,%eax
  800263:	c1 e0 02             	shl    $0x2,%eax
  800266:	01 d0                	add    %edx,%eax
  800268:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80026f:	01 c8                	add    %ecx,%eax
  800271:	c1 e0 03             	shl    $0x3,%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80027d:	29 c2                	sub    %eax,%edx
  80027f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800286:	89 c2                	mov    %eax,%edx
  800288:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 40 20             	mov    0x20(%eax),%al
  80029b:	84 c0                	test   %al,%al
  80029d:	74 0d                	je     8002ac <libmain+0x64>
		binaryname = myEnv->prog_name;
  80029f:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a4:	83 c0 20             	add    $0x20,%eax
  8002a7:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b0:	7e 0a                	jle    8002bc <libmain+0x74>
		binaryname = argv[0];
  8002b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  8002bc:	83 ec 08             	sub    $0x8,%esp
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	e8 6e fd ff ff       	call   800038 <_main>
  8002ca:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8002cd:	a1 00 40 80 00       	mov    0x804000,%eax
  8002d2:	85 c0                	test   %eax,%eax
  8002d4:	0f 84 01 01 00 00    	je     8003db <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  8002da:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8002e0:	bb 50 2c 80 00       	mov    $0x802c50,%ebx
  8002e5:	ba 0e 00 00 00       	mov    $0xe,%edx
  8002ea:	89 c7                	mov    %eax,%edi
  8002ec:	89 de                	mov    %ebx,%esi
  8002ee:	89 d1                	mov    %edx,%ecx
  8002f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8002f2:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8002f5:	b9 56 00 00 00       	mov    $0x56,%ecx
  8002fa:	b0 00                	mov    $0x0,%al
  8002fc:	89 d7                	mov    %edx,%edi
  8002fe:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800300:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800307:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	50                   	push   %eax
  80030e:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800314:	50                   	push   %eax
  800315:	e8 7b 19 00 00       	call   801c95 <sys_utilities>
  80031a:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80031d:	e8 c4 14 00 00       	call   8017e6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800322:	83 ec 0c             	sub    $0xc,%esp
  800325:	68 70 2b 80 00       	push   $0x802b70
  80032a:	e8 ac 03 00 00       	call   8006db <cprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	85 c0                	test   %eax,%eax
  800337:	74 18                	je     800351 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800339:	e8 75 19 00 00       	call   801cb3 <sys_get_optimal_num_faults>
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 98 2b 80 00       	push   $0x802b98
  800347:	e8 8f 03 00 00       	call   8006db <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
  80034f:	eb 59                	jmp    8003aa <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800351:	a1 20 40 80 00       	mov    0x804020,%eax
  800356:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80035c:	a1 20 40 80 00       	mov    0x804020,%eax
  800361:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	52                   	push   %edx
  80036b:	50                   	push   %eax
  80036c:	68 bc 2b 80 00       	push   $0x802bbc
  800371:	e8 65 03 00 00       	call   8006db <cprintf>
  800376:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800379:	a1 20 40 80 00       	mov    0x804020,%eax
  80037e:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800384:	a1 20 40 80 00       	mov    0x804020,%eax
  800389:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80039a:	51                   	push   %ecx
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	68 e4 2b 80 00       	push   $0x802be4
  8003a2:	e8 34 03 00 00       	call   8006db <cprintf>
  8003a7:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003af:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	50                   	push   %eax
  8003b9:	68 3c 2c 80 00       	push   $0x802c3c
  8003be:	e8 18 03 00 00       	call   8006db <cprintf>
  8003c3:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003c6:	83 ec 0c             	sub    $0xc,%esp
  8003c9:	68 70 2b 80 00       	push   $0x802b70
  8003ce:	e8 08 03 00 00       	call   8006db <cprintf>
  8003d3:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003d6:	e8 25 14 00 00       	call   801800 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003db:	e8 1f 00 00 00       	call   8003ff <exit>
}
  8003e0:	90                   	nop
  8003e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003ef:	83 ec 0c             	sub    $0xc,%esp
  8003f2:	6a 00                	push   $0x0
  8003f4:	e8 32 16 00 00       	call   801a2b <sys_destroy_env>
  8003f9:	83 c4 10             	add    $0x10,%esp
}
  8003fc:	90                   	nop
  8003fd:	c9                   	leave  
  8003fe:	c3                   	ret    

008003ff <exit>:

void
exit(void)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
  800402:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800405:	e8 87 16 00 00       	call   801a91 <sys_exit_env>
}
  80040a:	90                   	nop
  80040b:	c9                   	leave  
  80040c:	c3                   	ret    

0080040d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80040d:	55                   	push   %ebp
  80040e:	89 e5                	mov    %esp,%ebp
  800410:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800413:	8d 45 10             	lea    0x10(%ebp),%eax
  800416:	83 c0 04             	add    $0x4,%eax
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80041c:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800421:	85 c0                	test   %eax,%eax
  800423:	74 16                	je     80043b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800425:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	50                   	push   %eax
  80042e:	68 b4 2c 80 00       	push   $0x802cb4
  800433:	e8 a3 02 00 00       	call   8006db <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80043b:	a1 04 40 80 00       	mov    0x804004,%eax
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	ff 75 0c             	pushl  0xc(%ebp)
  800446:	ff 75 08             	pushl  0x8(%ebp)
  800449:	50                   	push   %eax
  80044a:	68 bc 2c 80 00       	push   $0x802cbc
  80044f:	6a 74                	push   $0x74
  800451:	e8 b2 02 00 00       	call   800708 <cprintf_colored>
  800456:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800459:	8b 45 10             	mov    0x10(%ebp),%eax
  80045c:	83 ec 08             	sub    $0x8,%esp
  80045f:	ff 75 f4             	pushl  -0xc(%ebp)
  800462:	50                   	push   %eax
  800463:	e8 04 02 00 00       	call   80066c <vcprintf>
  800468:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	6a 00                	push   $0x0
  800470:	68 e4 2c 80 00       	push   $0x802ce4
  800475:	e8 f2 01 00 00       	call   80066c <vcprintf>
  80047a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80047d:	e8 7d ff ff ff       	call   8003ff <exit>

	// should not return here
	while (1) ;
  800482:	eb fe                	jmp    800482 <_panic+0x75>

00800484 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80048a:	a1 20 40 80 00       	mov    0x804020,%eax
  80048f:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800495:	8b 45 0c             	mov    0xc(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	74 14                	je     8004b0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80049c:	83 ec 04             	sub    $0x4,%esp
  80049f:	68 e8 2c 80 00       	push   $0x802ce8
  8004a4:	6a 26                	push   $0x26
  8004a6:	68 34 2d 80 00       	push   $0x802d34
  8004ab:	e8 5d ff ff ff       	call   80040d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004be:	e9 c5 00 00 00       	jmp    800588 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	75 08                	jne    8004e0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004db:	e9 a5 00 00 00       	jmp    800585 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004ee:	eb 69                	jmp    800559 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f5:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8004fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	01 c0                	add    %eax,%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c1 e0 03             	shl    $0x3,%eax
  800507:	01 c8                	add    %ecx,%eax
  800509:	8a 40 04             	mov    0x4(%eax),%al
  80050c:	84 c0                	test   %al,%al
  80050e:	75 46                	jne    800556 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800510:	a1 20 40 80 00       	mov    0x804020,%eax
  800515:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80051b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	c1 e0 03             	shl    $0x3,%eax
  800527:	01 c8                	add    %ecx,%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80052e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800531:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800536:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80053b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	01 c8                	add    %ecx,%eax
  800547:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800549:	39 c2                	cmp    %eax,%edx
  80054b:	75 09                	jne    800556 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80054d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800554:	eb 15                	jmp    80056b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800556:	ff 45 e8             	incl   -0x18(%ebp)
  800559:	a1 20 40 80 00       	mov    0x804020,%eax
  80055e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800567:	39 c2                	cmp    %eax,%edx
  800569:	77 85                	ja     8004f0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80056b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80056f:	75 14                	jne    800585 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800571:	83 ec 04             	sub    $0x4,%esp
  800574:	68 40 2d 80 00       	push   $0x802d40
  800579:	6a 3a                	push   $0x3a
  80057b:	68 34 2d 80 00       	push   $0x802d34
  800580:	e8 88 fe ff ff       	call   80040d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800585:	ff 45 f0             	incl   -0x10(%ebp)
  800588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80058e:	0f 8c 2f ff ff ff    	jl     8004c3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80059b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005a2:	eb 26                	jmp    8005ca <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	89 d0                	mov    %edx,%eax
  8005b4:	01 c0                	add    %eax,%eax
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 c8                	add    %ecx,%eax
  8005bd:	8a 40 04             	mov    0x4(%eax),%al
  8005c0:	3c 01                	cmp    $0x1,%al
  8005c2:	75 03                	jne    8005c7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005c4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c7:	ff 45 e0             	incl   -0x20(%ebp)
  8005ca:	a1 20 40 80 00       	mov    0x804020,%eax
  8005cf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d8:	39 c2                	cmp    %eax,%edx
  8005da:	77 c8                	ja     8005a4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005df:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005e2:	74 14                	je     8005f8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	68 94 2d 80 00       	push   $0x802d94
  8005ec:	6a 44                	push   $0x44
  8005ee:	68 34 2d 80 00       	push   $0x802d34
  8005f3:	e8 15 fe ff ff       	call   80040d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005f8:	90                   	nop
  8005f9:	c9                   	leave  
  8005fa:	c3                   	ret    

008005fb <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8005fb:	55                   	push   %ebp
  8005fc:	89 e5                	mov    %esp,%ebp
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800602:	8b 45 0c             	mov    0xc(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 48 01             	lea    0x1(%eax),%ecx
  80060a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060d:	89 0a                	mov    %ecx,(%edx)
  80060f:	8b 55 08             	mov    0x8(%ebp),%edx
  800612:	88 d1                	mov    %dl,%cl
  800614:	8b 55 0c             	mov    0xc(%ebp),%edx
  800617:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80061b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	3d ff 00 00 00       	cmp    $0xff,%eax
  800625:	75 30                	jne    800657 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800627:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80062d:	a0 44 40 80 00       	mov    0x804044,%al
  800632:	0f b6 c0             	movzbl %al,%eax
  800635:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800638:	8b 09                	mov    (%ecx),%ecx
  80063a:	89 cb                	mov    %ecx,%ebx
  80063c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80063f:	83 c1 08             	add    $0x8,%ecx
  800642:	52                   	push   %edx
  800643:	50                   	push   %eax
  800644:	53                   	push   %ebx
  800645:	51                   	push   %ecx
  800646:	e8 57 11 00 00       	call   8017a2 <sys_cputs>
  80064b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80064e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065a:	8b 40 04             	mov    0x4(%eax),%eax
  80065d:	8d 50 01             	lea    0x1(%eax),%edx
  800660:	8b 45 0c             	mov    0xc(%ebp),%eax
  800663:	89 50 04             	mov    %edx,0x4(%eax)
}
  800666:	90                   	nop
  800667:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80066a:	c9                   	leave  
  80066b:	c3                   	ret    

0080066c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800675:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80067c:	00 00 00 
	b.cnt = 0;
  80067f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800686:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800689:	ff 75 0c             	pushl  0xc(%ebp)
  80068c:	ff 75 08             	pushl  0x8(%ebp)
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	68 fb 05 80 00       	push   $0x8005fb
  80069b:	e8 5a 02 00 00       	call   8008fa <vprintfmt>
  8006a0:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  8006a3:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  8006a9:	a0 44 40 80 00       	mov    0x804044,%al
  8006ae:	0f b6 c0             	movzbl %al,%eax
  8006b1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	51                   	push   %ecx
  8006ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c0:	83 c0 08             	add    $0x8,%eax
  8006c3:	50                   	push   %eax
  8006c4:	e8 d9 10 00 00       	call   8017a2 <sys_cputs>
  8006c9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006cc:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  8006d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006d9:	c9                   	leave  
  8006da:	c3                   	ret    

008006db <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006db:	55                   	push   %ebp
  8006dc:	89 e5                	mov    %esp,%ebp
  8006de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006e1:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 6f ff ff ff       	call   80066c <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800703:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800706:	c9                   	leave  
  800707:	c3                   	ret    

00800708 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80070e:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	c1 e0 08             	shl    $0x8,%eax
  80071b:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800720:	8d 45 0c             	lea    0xc(%ebp),%eax
  800723:	83 c0 04             	add    $0x4,%eax
  800726:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 f4             	pushl  -0xc(%ebp)
  800732:	50                   	push   %eax
  800733:	e8 34 ff ff ff       	call   80066c <vcprintf>
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80073e:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  800745:	07 00 00 

	return cnt;
  800748:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800753:	e8 8e 10 00 00       	call   8017e6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800758:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 f4             	pushl  -0xc(%ebp)
  800767:	50                   	push   %eax
  800768:	e8 ff fe ff ff       	call   80066c <vcprintf>
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800773:	e8 88 10 00 00       	call   801800 <sys_unlock_cons>
	return cnt;
  800778:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    

0080077d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	53                   	push   %ebx
  800781:	83 ec 14             	sub    $0x14,%esp
  800784:	8b 45 10             	mov    0x10(%ebp),%eax
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800790:	8b 45 18             	mov    0x18(%ebp),%eax
  800793:	ba 00 00 00 00       	mov    $0x0,%edx
  800798:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80079b:	77 55                	ja     8007f2 <printnum+0x75>
  80079d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007a0:	72 05                	jb     8007a7 <printnum+0x2a>
  8007a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007a5:	77 4b                	ja     8007f2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007aa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	52                   	push   %edx
  8007b6:	50                   	push   %eax
  8007b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bd:	e8 06 20 00 00       	call   8027c8 <__udivdi3>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	ff 75 20             	pushl  0x20(%ebp)
  8007cb:	53                   	push   %ebx
  8007cc:	ff 75 18             	pushl  0x18(%ebp)
  8007cf:	52                   	push   %edx
  8007d0:	50                   	push   %eax
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	ff 75 08             	pushl  0x8(%ebp)
  8007d7:	e8 a1 ff ff ff       	call   80077d <printnum>
  8007dc:	83 c4 20             	add    $0x20,%esp
  8007df:	eb 1a                	jmp    8007fb <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	ff 75 20             	pushl  0x20(%ebp)
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007f2:	ff 4d 1c             	decl   0x1c(%ebp)
  8007f5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007f9:	7f e6                	jg     8007e1 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007fb:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800809:	53                   	push   %ebx
  80080a:	51                   	push   %ecx
  80080b:	52                   	push   %edx
  80080c:	50                   	push   %eax
  80080d:	e8 c6 20 00 00       	call   8028d8 <__umoddi3>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	05 f4 2f 80 00       	add    $0x802ff4,%eax
  80081a:	8a 00                	mov    (%eax),%al
  80081c:	0f be c0             	movsbl %al,%eax
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	50                   	push   %eax
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
}
  80082e:	90                   	nop
  80082f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800832:	c9                   	leave  
  800833:	c3                   	ret    

00800834 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800837:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083b:	7e 1c                	jle    800859 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	8b 00                	mov    (%eax),%eax
  800842:	8d 50 08             	lea    0x8(%eax),%edx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 10                	mov    %edx,(%eax)
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	8b 00                	mov    (%eax),%eax
  80084f:	83 e8 08             	sub    $0x8,%eax
  800852:	8b 50 04             	mov    0x4(%eax),%edx
  800855:	8b 00                	mov    (%eax),%eax
  800857:	eb 40                	jmp    800899 <getuint+0x65>
	else if (lflag)
  800859:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085d:	74 1e                	je     80087d <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  80087b:	eb 1c                	jmp    800899 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 10                	mov    %edx,(%eax)
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	8b 00                	mov    (%eax),%eax
  80088f:	83 e8 04             	sub    $0x4,%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80089e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a2:	7e 1c                	jle    8008c0 <getint+0x25>
		return va_arg(*ap, long long);
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	8d 50 08             	lea    0x8(%eax),%edx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	89 10                	mov    %edx,(%eax)
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	83 e8 08             	sub    $0x8,%eax
  8008b9:	8b 50 04             	mov    0x4(%eax),%edx
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	eb 38                	jmp    8008f8 <getint+0x5d>
	else if (lflag)
  8008c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c4:	74 1a                	je     8008e0 <getint+0x45>
		return va_arg(*ap, long);
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	8d 50 04             	lea    0x4(%eax),%edx
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	89 10                	mov    %edx,(%eax)
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	99                   	cltd   
  8008de:	eb 18                	jmp    8008f8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	8d 50 04             	lea    0x4(%eax),%edx
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	89 10                	mov    %edx,(%eax)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	83 e8 04             	sub    $0x4,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	99                   	cltd   
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	56                   	push   %esi
  8008fe:	53                   	push   %ebx
  8008ff:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800902:	eb 17                	jmp    80091b <vprintfmt+0x21>
			if (ch == '\0')
  800904:	85 db                	test   %ebx,%ebx
  800906:	0f 84 c1 03 00 00    	je     800ccd <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091b:	8b 45 10             	mov    0x10(%ebp),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	89 55 10             	mov    %edx,0x10(%ebp)
  800924:	8a 00                	mov    (%eax),%al
  800926:	0f b6 d8             	movzbl %al,%ebx
  800929:	83 fb 25             	cmp    $0x25,%ebx
  80092c:	75 d6                	jne    800904 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80092e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800932:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800939:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800940:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800947:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094e:	8b 45 10             	mov    0x10(%ebp),%eax
  800951:	8d 50 01             	lea    0x1(%eax),%edx
  800954:	89 55 10             	mov    %edx,0x10(%ebp)
  800957:	8a 00                	mov    (%eax),%al
  800959:	0f b6 d8             	movzbl %al,%ebx
  80095c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80095f:	83 f8 5b             	cmp    $0x5b,%eax
  800962:	0f 87 3d 03 00 00    	ja     800ca5 <vprintfmt+0x3ab>
  800968:	8b 04 85 18 30 80 00 	mov    0x803018(,%eax,4),%eax
  80096f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800971:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800975:	eb d7                	jmp    80094e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800977:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80097b:	eb d1                	jmp    80094e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80097d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800984:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800987:	89 d0                	mov    %edx,%eax
  800989:	c1 e0 02             	shl    $0x2,%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	01 c0                	add    %eax,%eax
  800990:	01 d8                	add    %ebx,%eax
  800992:	83 e8 30             	sub    $0x30,%eax
  800995:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800998:	8b 45 10             	mov    0x10(%ebp),%eax
  80099b:	8a 00                	mov    (%eax),%al
  80099d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009a0:	83 fb 2f             	cmp    $0x2f,%ebx
  8009a3:	7e 3e                	jle    8009e3 <vprintfmt+0xe9>
  8009a5:	83 fb 39             	cmp    $0x39,%ebx
  8009a8:	7f 39                	jg     8009e3 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ad:	eb d5                	jmp    800984 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	83 c0 04             	add    $0x4,%eax
  8009b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	83 e8 04             	sub    $0x4,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009c3:	eb 1f                	jmp    8009e4 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c9:	79 83                	jns    80094e <vprintfmt+0x54>
				width = 0;
  8009cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009d2:	e9 77 ff ff ff       	jmp    80094e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009d7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009de:	e9 6b ff ff ff       	jmp    80094e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009e3:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e8:	0f 89 60 ff ff ff    	jns    80094e <vprintfmt+0x54>
				width = precision, precision = -1;
  8009ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009fb:	e9 4e ff ff ff       	jmp    80094e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a00:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a03:	e9 46 ff ff ff       	jmp    80094e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a08:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0b:	83 c0 04             	add    $0x4,%eax
  800a0e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a11:	8b 45 14             	mov    0x14(%ebp),%eax
  800a14:	83 e8 04             	sub    $0x4,%eax
  800a17:	8b 00                	mov    (%eax),%eax
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	50                   	push   %eax
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	ff d0                	call   *%eax
  800a25:	83 c4 10             	add    $0x10,%esp
			break;
  800a28:	e9 9b 02 00 00       	jmp    800cc8 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a3e:	85 db                	test   %ebx,%ebx
  800a40:	79 02                	jns    800a44 <vprintfmt+0x14a>
				err = -err;
  800a42:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a44:	83 fb 64             	cmp    $0x64,%ebx
  800a47:	7f 0b                	jg     800a54 <vprintfmt+0x15a>
  800a49:	8b 34 9d 60 2e 80 00 	mov    0x802e60(,%ebx,4),%esi
  800a50:	85 f6                	test   %esi,%esi
  800a52:	75 19                	jne    800a6d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a54:	53                   	push   %ebx
  800a55:	68 05 30 80 00       	push   $0x803005
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	e8 70 02 00 00       	call   800cd5 <printfmt>
  800a65:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a68:	e9 5b 02 00 00       	jmp    800cc8 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a6d:	56                   	push   %esi
  800a6e:	68 0e 30 80 00       	push   $0x80300e
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	ff 75 08             	pushl  0x8(%ebp)
  800a79:	e8 57 02 00 00       	call   800cd5 <printfmt>
  800a7e:	83 c4 10             	add    $0x10,%esp
			break;
  800a81:	e9 42 02 00 00       	jmp    800cc8 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	83 c0 04             	add    $0x4,%eax
  800a8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a92:	83 e8 04             	sub    $0x4,%eax
  800a95:	8b 30                	mov    (%eax),%esi
  800a97:	85 f6                	test   %esi,%esi
  800a99:	75 05                	jne    800aa0 <vprintfmt+0x1a6>
				p = "(null)";
  800a9b:	be 11 30 80 00       	mov    $0x803011,%esi
			if (width > 0 && padc != '-')
  800aa0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa4:	7e 6d                	jle    800b13 <vprintfmt+0x219>
  800aa6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aaa:	74 67                	je     800b13 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	50                   	push   %eax
  800ab3:	56                   	push   %esi
  800ab4:	e8 1e 03 00 00       	call   800dd7 <strnlen>
  800ab9:	83 c4 10             	add    $0x10,%esp
  800abc:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800abf:	eb 16                	jmp    800ad7 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ac1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	50                   	push   %eax
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad4:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adb:	7f e4                	jg     800ac1 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800add:	eb 34                	jmp    800b13 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800adf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ae3:	74 1c                	je     800b01 <vprintfmt+0x207>
  800ae5:	83 fb 1f             	cmp    $0x1f,%ebx
  800ae8:	7e 05                	jle    800aef <vprintfmt+0x1f5>
  800aea:	83 fb 7e             	cmp    $0x7e,%ebx
  800aed:	7e 12                	jle    800b01 <vprintfmt+0x207>
					putch('?', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 3f                	push   $0x3f
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	eb 0f                	jmp    800b10 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b01:	83 ec 08             	sub    $0x8,%esp
  800b04:	ff 75 0c             	pushl  0xc(%ebp)
  800b07:	53                   	push   %ebx
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	ff d0                	call   *%eax
  800b0d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b10:	ff 4d e4             	decl   -0x1c(%ebp)
  800b13:	89 f0                	mov    %esi,%eax
  800b15:	8d 70 01             	lea    0x1(%eax),%esi
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	0f be d8             	movsbl %al,%ebx
  800b1d:	85 db                	test   %ebx,%ebx
  800b1f:	74 24                	je     800b45 <vprintfmt+0x24b>
  800b21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b25:	78 b8                	js     800adf <vprintfmt+0x1e5>
  800b27:	ff 4d e0             	decl   -0x20(%ebp)
  800b2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b2e:	79 af                	jns    800adf <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b30:	eb 13                	jmp    800b45 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b32:	83 ec 08             	sub    $0x8,%esp
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	6a 20                	push   $0x20
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b42:	ff 4d e4             	decl   -0x1c(%ebp)
  800b45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b49:	7f e7                	jg     800b32 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b4b:	e9 78 01 00 00       	jmp    800cc8 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 3c fd ff ff       	call   80089b <getint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b6e:	85 d2                	test   %edx,%edx
  800b70:	79 23                	jns    800b95 <vprintfmt+0x29b>
				putch('-', putdat);
  800b72:	83 ec 08             	sub    $0x8,%esp
  800b75:	ff 75 0c             	pushl  0xc(%ebp)
  800b78:	6a 2d                	push   $0x2d
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	ff d0                	call   *%eax
  800b7f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b88:	f7 d8                	neg    %eax
  800b8a:	83 d2 00             	adc    $0x0,%edx
  800b8d:	f7 da                	neg    %edx
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b95:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b9c:	e9 bc 00 00 00       	jmp    800c5d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 84 fc ff ff       	call   800834 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bb9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc0:	e9 98 00 00 00       	jmp    800c5d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bc5:	83 ec 08             	sub    $0x8,%esp
  800bc8:	ff 75 0c             	pushl  0xc(%ebp)
  800bcb:	6a 58                	push   $0x58
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd5:	83 ec 08             	sub    $0x8,%esp
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	6a 58                	push   $0x58
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	ff d0                	call   *%eax
  800be2:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	6a 58                	push   $0x58
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	ff d0                	call   *%eax
  800bf2:	83 c4 10             	add    $0x10,%esp
			break;
  800bf5:	e9 ce 00 00 00       	jmp    800cc8 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bfa:	83 ec 08             	sub    $0x8,%esp
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	6a 30                	push   $0x30
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	ff d0                	call   *%eax
  800c07:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	6a 78                	push   $0x78
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1d:	83 c0 04             	add    $0x4,%eax
  800c20:	89 45 14             	mov    %eax,0x14(%ebp)
  800c23:	8b 45 14             	mov    0x14(%ebp),%eax
  800c26:	83 e8 04             	sub    $0x4,%eax
  800c29:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c35:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c3c:	eb 1f                	jmp    800c5d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c3e:	83 ec 08             	sub    $0x8,%esp
  800c41:	ff 75 e8             	pushl  -0x18(%ebp)
  800c44:	8d 45 14             	lea    0x14(%ebp),%eax
  800c47:	50                   	push   %eax
  800c48:	e8 e7 fb ff ff       	call   800834 <getuint>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c56:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c5d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c64:	83 ec 04             	sub    $0x4,%esp
  800c67:	52                   	push   %edx
  800c68:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c6b:	50                   	push   %eax
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c72:	ff 75 0c             	pushl  0xc(%ebp)
  800c75:	ff 75 08             	pushl  0x8(%ebp)
  800c78:	e8 00 fb ff ff       	call   80077d <printnum>
  800c7d:	83 c4 20             	add    $0x20,%esp
			break;
  800c80:	eb 46                	jmp    800cc8 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c82:	83 ec 08             	sub    $0x8,%esp
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	53                   	push   %ebx
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	ff d0                	call   *%eax
  800c8e:	83 c4 10             	add    $0x10,%esp
			break;
  800c91:	eb 35                	jmp    800cc8 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c93:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800c9a:	eb 2c                	jmp    800cc8 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c9c:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800ca3:	eb 23                	jmp    800cc8 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ca5:	83 ec 08             	sub    $0x8,%esp
  800ca8:	ff 75 0c             	pushl  0xc(%ebp)
  800cab:	6a 25                	push   $0x25
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cb5:	ff 4d 10             	decl   0x10(%ebp)
  800cb8:	eb 03                	jmp    800cbd <vprintfmt+0x3c3>
  800cba:	ff 4d 10             	decl   0x10(%ebp)
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	48                   	dec    %eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	3c 25                	cmp    $0x25,%al
  800cc5:	75 f3                	jne    800cba <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800cc7:	90                   	nop
		}
	}
  800cc8:	e9 35 fc ff ff       	jmp    800902 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ccd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cde:	83 c0 04             	add    $0x4,%eax
  800ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	ff 75 08             	pushl  0x8(%ebp)
  800cf1:	e8 04 fc ff ff       	call   8008fa <vprintfmt>
  800cf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cf9:	90                   	nop
  800cfa:	c9                   	leave  
  800cfb:	c3                   	ret    

00800cfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	8b 40 08             	mov    0x8(%eax),%eax
  800d05:	8d 50 01             	lea    0x1(%eax),%edx
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8b 10                	mov    (%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8b 40 04             	mov    0x4(%eax),%eax
  800d19:	39 c2                	cmp    %eax,%edx
  800d1b:	73 12                	jae    800d2f <sprintputch+0x33>
		*b->buf++ = ch;
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 48 01             	lea    0x1(%eax),%ecx
  800d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d28:	89 0a                	mov    %ecx,(%edx)
  800d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2d:	88 10                	mov    %dl,(%eax)
}
  800d2f:	90                   	nop
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	01 d0                	add    %edx,%eax
  800d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d57:	74 06                	je     800d5f <vsnprintf+0x2d>
  800d59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5d:	7f 07                	jg     800d66 <vsnprintf+0x34>
		return -E_INVAL;
  800d5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d64:	eb 20                	jmp    800d86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d66:	ff 75 14             	pushl  0x14(%ebp)
  800d69:	ff 75 10             	pushl  0x10(%ebp)
  800d6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d6f:	50                   	push   %eax
  800d70:	68 fc 0c 80 00       	push   $0x800cfc
  800d75:	e8 80 fb ff ff       	call   8008fa <vprintfmt>
  800d7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d91:	83 c0 04             	add    $0x4,%eax
  800d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d97:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d9d:	50                   	push   %eax
  800d9e:	ff 75 0c             	pushl  0xc(%ebp)
  800da1:	ff 75 08             	pushl  0x8(%ebp)
  800da4:	e8 89 ff ff ff       	call   800d32 <vsnprintf>
  800da9:	83 c4 10             	add    $0x10,%esp
  800dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc1:	eb 06                	jmp    800dc9 <strlen+0x15>
		n++;
  800dc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 f1                	jne    800dc3 <strlen+0xf>
		n++;
	return n;
  800dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800de4:	eb 09                	jmp    800def <strnlen+0x18>
		n++;
  800de6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de9:	ff 45 08             	incl   0x8(%ebp)
  800dec:	ff 4d 0c             	decl   0xc(%ebp)
  800def:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df3:	74 09                	je     800dfe <strnlen+0x27>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	84 c0                	test   %al,%al
  800dfc:	75 e8                	jne    800de6 <strnlen+0xf>
		n++;
	return n;
  800dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e0f:	90                   	nop
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8d 50 01             	lea    0x1(%eax),%edx
  800e16:	89 55 08             	mov    %edx,0x8(%ebp)
  800e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e22:	8a 12                	mov    (%edx),%dl
  800e24:	88 10                	mov    %dl,(%eax)
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 e4                	jne    800e10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    

00800e31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e31:	55                   	push   %ebp
  800e32:	89 e5                	mov    %esp,%ebp
  800e34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e44:	eb 1f                	jmp    800e65 <strncpy+0x34>
		*dst++ = *src;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	8d 50 01             	lea    0x1(%eax),%edx
  800e4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e52:	8a 12                	mov    (%edx),%dl
  800e54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	74 03                	je     800e62 <strncpy+0x31>
			src++;
  800e5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e62:	ff 45 fc             	incl   -0x4(%ebp)
  800e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e6b:	72 d9                	jb     800e46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e70:	c9                   	leave  
  800e71:	c3                   	ret    

00800e72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e82:	74 30                	je     800eb4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e84:	eb 16                	jmp    800e9c <strlcpy+0x2a>
			*dst++ = *src++;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8d 50 01             	lea    0x1(%eax),%edx
  800e8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e98:	8a 12                	mov    (%edx),%dl
  800e9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e9c:	ff 4d 10             	decl   0x10(%ebp)
  800e9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea3:	74 09                	je     800eae <strlcpy+0x3c>
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	84 c0                	test   %al,%al
  800eac:	75 d8                	jne    800e86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	29 c2                	sub    %eax,%edx
  800ebc:	89 d0                	mov    %edx,%eax
}
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ec3:	eb 06                	jmp    800ecb <strcmp+0xb>
		p++, q++;
  800ec5:	ff 45 08             	incl   0x8(%ebp)
  800ec8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	84 c0                	test   %al,%al
  800ed2:	74 0e                	je     800ee2 <strcmp+0x22>
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	8a 10                	mov    (%eax),%dl
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	38 c2                	cmp    %al,%dl
  800ee0:	74 e3                	je     800ec5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	8a 00                	mov    (%eax),%al
  800eef:	0f b6 c0             	movzbl %al,%eax
  800ef2:	29 c2                	sub    %eax,%edx
  800ef4:	89 d0                	mov    %edx,%eax
}
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800efb:	eb 09                	jmp    800f06 <strncmp+0xe>
		n--, p++, q++;
  800efd:	ff 4d 10             	decl   0x10(%ebp)
  800f00:	ff 45 08             	incl   0x8(%ebp)
  800f03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0a:	74 17                	je     800f23 <strncmp+0x2b>
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	84 c0                	test   %al,%al
  800f13:	74 0e                	je     800f23 <strncmp+0x2b>
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	8a 10                	mov    (%eax),%dl
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	38 c2                	cmp    %al,%dl
  800f21:	74 da                	je     800efd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f27:	75 07                	jne    800f30 <strncmp+0x38>
		return 0;
  800f29:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2e:	eb 14                	jmp    800f44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 00                	mov    (%eax),%al
  800f35:	0f b6 d0             	movzbl %al,%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	0f b6 c0             	movzbl %al,%eax
  800f40:	29 c2                	sub    %eax,%edx
  800f42:	89 d0                	mov    %edx,%eax
}
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f52:	eb 12                	jmp    800f66 <strchr+0x20>
		if (*s == c)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f5c:	75 05                	jne    800f63 <strchr+0x1d>
			return (char *) s;
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	eb 11                	jmp    800f74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f63:	ff 45 08             	incl   0x8(%ebp)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	84 c0                	test   %al,%al
  800f6d:	75 e5                	jne    800f54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 04             	sub    $0x4,%esp
  800f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f82:	eb 0d                	jmp    800f91 <strfind+0x1b>
		if (*s == c)
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f8c:	74 0e                	je     800f9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	84 c0                	test   %al,%al
  800f98:	75 ea                	jne    800f84 <strfind+0xe>
  800f9a:	eb 01                	jmp    800f9d <strfind+0x27>
		if (*s == c)
			break;
  800f9c:	90                   	nop
	return (char *) s;
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  800fae:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  800fb2:	76 63                	jbe    801017 <memset+0x75>
		uint64 data_block = c;
  800fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb7:	99                   	cltd   
  800fb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  800fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc4:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  800fc8:	c1 e0 08             	shl    $0x8,%eax
  800fcb:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fce:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  800fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd7:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  800fdb:	c1 e0 10             	shl    $0x10,%eax
  800fde:	09 45 f0             	or     %eax,-0x10(%ebp)
  800fe1:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	89 c2                	mov    %eax,%edx
  800fec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff1:	09 45 f0             	or     %eax,-0x10(%ebp)
  800ff4:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  800ff7:	eb 18                	jmp    801011 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  800ff9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ffc:	8d 41 08             	lea    0x8(%ecx),%eax
  800fff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801008:	89 01                	mov    %eax,(%ecx)
  80100a:	89 51 04             	mov    %edx,0x4(%ecx)
  80100d:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801011:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801015:	77 e2                	ja     800ff9 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 23                	je     801040 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80101d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801020:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801023:	eb 0e                	jmp    801033 <memset+0x91>
			*p8++ = (uint8)c;
  801025:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801028:	8d 50 01             	lea    0x1(%eax),%edx
  80102b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801031:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	8d 50 ff             	lea    -0x1(%eax),%edx
  801039:	89 55 10             	mov    %edx,0x10(%ebp)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	75 e5                	jne    801025 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801057:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80105b:	76 24                	jbe    801081 <memcpy+0x3c>
		while(n >= 8){
  80105d:	eb 1c                	jmp    80107b <memcpy+0x36>
			*d64 = *s64;
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801062:	8b 50 04             	mov    0x4(%eax),%edx
  801065:	8b 00                	mov    (%eax),%eax
  801067:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80106a:	89 01                	mov    %eax,(%ecx)
  80106c:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  80106f:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801073:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801077:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80107b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80107f:	77 de                	ja     80105f <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801085:	74 31                	je     8010b8 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  801087:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801093:	eb 16                	jmp    8010ab <memcpy+0x66>
			*d8++ = *s8++;
  801095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801098:	8d 50 01             	lea    0x1(%eax),%edx
  80109b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80109e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a4:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8010a7:	8a 12                	mov    (%edx),%dl
  8010a9:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 dd                	jne    801095 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bb:	c9                   	leave  
  8010bc:	c3                   	ret    

008010bd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d5:	73 50                	jae    801127 <memmove+0x6a>
  8010d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010da:	8b 45 10             	mov    0x10(%ebp),%eax
  8010dd:	01 d0                	add    %edx,%eax
  8010df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010e2:	76 43                	jbe    801127 <memmove+0x6a>
		s += n;
  8010e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ed:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010f0:	eb 10                	jmp    801102 <memmove+0x45>
			*--d = *--s;
  8010f2:	ff 4d f8             	decl   -0x8(%ebp)
  8010f5:	ff 4d fc             	decl   -0x4(%ebp)
  8010f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010fb:	8a 10                	mov    (%eax),%dl
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801100:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	8d 50 ff             	lea    -0x1(%eax),%edx
  801108:	89 55 10             	mov    %edx,0x10(%ebp)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	75 e3                	jne    8010f2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80110f:	eb 23                	jmp    801134 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801111:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801114:	8d 50 01             	lea    0x1(%eax),%edx
  801117:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80111d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801120:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801123:	8a 12                	mov    (%edx),%dl
  801125:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80112d:	89 55 10             	mov    %edx,0x10(%ebp)
  801130:	85 c0                	test   %eax,%eax
  801132:	75 dd                	jne    801111 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80114b:	eb 2a                	jmp    801177 <memcmp+0x3e>
		if (*s1 != *s2)
  80114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801150:	8a 10                	mov    (%eax),%dl
  801152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	38 c2                	cmp    %al,%dl
  801159:	74 16                	je     801171 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80115b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f b6 d0             	movzbl %al,%edx
  801163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 c0             	movzbl %al,%eax
  80116b:	29 c2                	sub    %eax,%edx
  80116d:	89 d0                	mov    %edx,%eax
  80116f:	eb 18                	jmp    801189 <memcmp+0x50>
		s1++, s2++;
  801171:	ff 45 fc             	incl   -0x4(%ebp)
  801174:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801177:	8b 45 10             	mov    0x10(%ebp),%eax
  80117a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80117d:	89 55 10             	mov    %edx,0x10(%ebp)
  801180:	85 c0                	test   %eax,%eax
  801182:	75 c9                	jne    80114d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801184:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80119c:	eb 15                	jmp    8011b3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f b6 d0             	movzbl %al,%edx
  8011a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a9:	0f b6 c0             	movzbl %al,%eax
  8011ac:	39 c2                	cmp    %eax,%edx
  8011ae:	74 0d                	je     8011bd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011b0:	ff 45 08             	incl   0x8(%ebp)
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011b9:	72 e3                	jb     80119e <memfind+0x13>
  8011bb:	eb 01                	jmp    8011be <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011bd:	90                   	nop
	return (void *) s;
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011d7:	eb 03                	jmp    8011dc <strtol+0x19>
		s++;
  8011d9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8a 00                	mov    (%eax),%al
  8011e1:	3c 20                	cmp    $0x20,%al
  8011e3:	74 f4                	je     8011d9 <strtol+0x16>
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	3c 09                	cmp    $0x9,%al
  8011ec:	74 eb                	je     8011d9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3c 2b                	cmp    $0x2b,%al
  8011f5:	75 05                	jne    8011fc <strtol+0x39>
		s++;
  8011f7:	ff 45 08             	incl   0x8(%ebp)
  8011fa:	eb 13                	jmp    80120f <strtol+0x4c>
	else if (*s == '-')
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 2d                	cmp    $0x2d,%al
  801203:	75 0a                	jne    80120f <strtol+0x4c>
		s++, neg = 1;
  801205:	ff 45 08             	incl   0x8(%ebp)
  801208:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80120f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801213:	74 06                	je     80121b <strtol+0x58>
  801215:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801219:	75 20                	jne    80123b <strtol+0x78>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	3c 30                	cmp    $0x30,%al
  801222:	75 17                	jne    80123b <strtol+0x78>
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	40                   	inc    %eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	3c 78                	cmp    $0x78,%al
  80122c:	75 0d                	jne    80123b <strtol+0x78>
		s += 2, base = 16;
  80122e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801232:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801239:	eb 28                	jmp    801263 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80123b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80123f:	75 15                	jne    801256 <strtol+0x93>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	3c 30                	cmp    $0x30,%al
  801248:	75 0c                	jne    801256 <strtol+0x93>
		s++, base = 8;
  80124a:	ff 45 08             	incl   0x8(%ebp)
  80124d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801254:	eb 0d                	jmp    801263 <strtol+0xa0>
	else if (base == 0)
  801256:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125a:	75 07                	jne    801263 <strtol+0xa0>
		base = 10;
  80125c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	8a 00                	mov    (%eax),%al
  801268:	3c 2f                	cmp    $0x2f,%al
  80126a:	7e 19                	jle    801285 <strtol+0xc2>
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 39                	cmp    $0x39,%al
  801273:	7f 10                	jg     801285 <strtol+0xc2>
			dig = *s - '0';
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	83 e8 30             	sub    $0x30,%eax
  801280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801283:	eb 42                	jmp    8012c7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	3c 60                	cmp    $0x60,%al
  80128c:	7e 19                	jle    8012a7 <strtol+0xe4>
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	3c 7a                	cmp    $0x7a,%al
  801295:	7f 10                	jg     8012a7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	8a 00                	mov    (%eax),%al
  80129c:	0f be c0             	movsbl %al,%eax
  80129f:	83 e8 57             	sub    $0x57,%eax
  8012a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a5:	eb 20                	jmp    8012c7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 40                	cmp    $0x40,%al
  8012ae:	7e 39                	jle    8012e9 <strtol+0x126>
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	3c 5a                	cmp    $0x5a,%al
  8012b7:	7f 30                	jg     8012e9 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	83 e8 37             	sub    $0x37,%eax
  8012c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ca:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012cd:	7d 19                	jge    8012e8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012cf:	ff 45 08             	incl   0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012d9:	89 c2                	mov    %eax,%edx
  8012db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012de:	01 d0                	add    %edx,%eax
  8012e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012e3:	e9 7b ff ff ff       	jmp    801263 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012e8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012ed:	74 08                	je     8012f7 <strtol+0x134>
		*endptr = (char *) s;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012fb:	74 07                	je     801304 <strtol+0x141>
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	f7 d8                	neg    %eax
  801302:	eb 03                	jmp    801307 <strtol+0x144>
  801304:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <ltostr>:

void
ltostr(long value, char *str)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80130f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80131d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801321:	79 13                	jns    801336 <ltostr+0x2d>
	{
		neg = 1;
  801323:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801330:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801333:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80133e:	99                   	cltd   
  80133f:	f7 f9                	idiv   %ecx
  801341:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801344:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801347:	8d 50 01             	lea    0x1(%eax),%edx
  80134a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80134d:	89 c2                	mov    %eax,%edx
  80134f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801352:	01 d0                	add    %edx,%eax
  801354:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801357:	83 c2 30             	add    $0x30,%edx
  80135a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80135c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801364:	f7 e9                	imul   %ecx
  801366:	c1 fa 02             	sar    $0x2,%edx
  801369:	89 c8                	mov    %ecx,%eax
  80136b:	c1 f8 1f             	sar    $0x1f,%eax
  80136e:	29 c2                	sub    %eax,%edx
  801370:	89 d0                	mov    %edx,%eax
  801372:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801379:	75 bb                	jne    801336 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80137b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801382:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801385:	48                   	dec    %eax
  801386:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801389:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80138d:	74 3d                	je     8013cc <ltostr+0xc3>
		start = 1 ;
  80138f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801396:	eb 34                	jmp    8013cc <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80139b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	8a 00                	mov    (%eax),%al
  8013a2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	01 c2                	add    %eax,%edx
  8013ad:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b3:	01 c8                	add    %ecx,%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	01 c2                	add    %eax,%edx
  8013c1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013c4:	88 02                	mov    %al,(%edx)
		start++ ;
  8013c6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d2:	7c c4                	jl     801398 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013df:	90                   	nop
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013e8:	ff 75 08             	pushl  0x8(%ebp)
  8013eb:	e8 c4 f9 ff ff       	call   800db4 <strlen>
  8013f0:	83 c4 04             	add    $0x4,%esp
  8013f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013f6:	ff 75 0c             	pushl  0xc(%ebp)
  8013f9:	e8 b6 f9 ff ff       	call   800db4 <strlen>
  8013fe:	83 c4 04             	add    $0x4,%esp
  801401:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80140b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801412:	eb 17                	jmp    80142b <strcconcat+0x49>
		final[s] = str1[s] ;
  801414:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	01 c2                	add    %eax,%edx
  80141c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	01 c8                	add    %ecx,%eax
  801424:	8a 00                	mov    (%eax),%al
  801426:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801428:	ff 45 fc             	incl   -0x4(%ebp)
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801431:	7c e1                	jl     801414 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801433:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80143a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801441:	eb 1f                	jmp    801462 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801443:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801446:	8d 50 01             	lea    0x1(%eax),%edx
  801449:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144c:	89 c2                	mov    %eax,%edx
  80144e:	8b 45 10             	mov    0x10(%ebp),%eax
  801451:	01 c2                	add    %eax,%edx
  801453:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	01 c8                	add    %ecx,%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80145f:	ff 45 f8             	incl   -0x8(%ebp)
  801462:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801465:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801468:	7c d9                	jl     801443 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80146a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80146d:	8b 45 10             	mov    0x10(%ebp),%eax
  801470:	01 d0                	add    %edx,%eax
  801472:	c6 00 00             	movb   $0x0,(%eax)
}
  801475:	90                   	nop
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80147b:	8b 45 14             	mov    0x14(%ebp),%eax
  80147e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801484:	8b 45 14             	mov    0x14(%ebp),%eax
  801487:	8b 00                	mov    (%eax),%eax
  801489:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801490:	8b 45 10             	mov    0x10(%ebp),%eax
  801493:	01 d0                	add    %edx,%eax
  801495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80149b:	eb 0c                	jmp    8014a9 <strsplit+0x31>
			*string++ = 0;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8d 50 01             	lea    0x1(%eax),%edx
  8014a3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	84 c0                	test   %al,%al
  8014b0:	74 18                	je     8014ca <strsplit+0x52>
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8a 00                	mov    (%eax),%al
  8014b7:	0f be c0             	movsbl %al,%eax
  8014ba:	50                   	push   %eax
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	e8 83 fa ff ff       	call   800f46 <strchr>
  8014c3:	83 c4 08             	add    $0x8,%esp
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	75 d3                	jne    80149d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	74 5a                	je     80152d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d6:	8b 00                	mov    (%eax),%eax
  8014d8:	83 f8 0f             	cmp    $0xf,%eax
  8014db:	75 07                	jne    8014e4 <strsplit+0x6c>
		{
			return 0;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb 66                	jmp    80154a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e7:	8b 00                	mov    (%eax),%eax
  8014e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8014ec:	8b 55 14             	mov    0x14(%ebp),%edx
  8014ef:	89 0a                	mov    %ecx,(%edx)
  8014f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fb:	01 c2                	add    %eax,%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801502:	eb 03                	jmp    801507 <strsplit+0x8f>
			string++;
  801504:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	84 c0                	test   %al,%al
  80150e:	74 8b                	je     80149b <strsplit+0x23>
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	0f be c0             	movsbl %al,%eax
  801518:	50                   	push   %eax
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	e8 25 fa ff ff       	call   800f46 <strchr>
  801521:	83 c4 08             	add    $0x8,%esp
  801524:	85 c0                	test   %eax,%eax
  801526:	74 dc                	je     801504 <strsplit+0x8c>
			string++;
	}
  801528:	e9 6e ff ff ff       	jmp    80149b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80152d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80152e:	8b 45 14             	mov    0x14(%ebp),%eax
  801531:	8b 00                	mov    (%eax),%eax
  801533:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80153a:	8b 45 10             	mov    0x10(%ebp),%eax
  80153d:	01 d0                	add    %edx,%eax
  80153f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801545:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801558:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80155f:	eb 4a                	jmp    8015ab <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801561:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	01 c2                	add    %eax,%edx
  801569:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	01 c8                	add    %ecx,%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801578:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	8a 00                	mov    (%eax),%al
  80157f:	3c 40                	cmp    $0x40,%al
  801581:	7e 25                	jle    8015a8 <str2lower+0x5c>
  801583:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	01 d0                	add    %edx,%eax
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	3c 5a                	cmp    $0x5a,%al
  80158f:	7f 17                	jg     8015a8 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801591:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	01 d0                	add    %edx,%eax
  801599:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80159c:	8b 55 08             	mov    0x8(%ebp),%edx
  80159f:	01 ca                	add    %ecx,%edx
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	83 c2 20             	add    $0x20,%edx
  8015a6:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  8015a8:	ff 45 fc             	incl   -0x4(%ebp)
  8015ab:	ff 75 0c             	pushl  0xc(%ebp)
  8015ae:	e8 01 f8 ff ff       	call   800db4 <strlen>
  8015b3:	83 c4 04             	add    $0x4,%esp
  8015b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b9:	7f a6                	jg     801561 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  8015bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  8015c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	74 42                	je     801611 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  8015cf:	83 ec 08             	sub    $0x8,%esp
  8015d2:	68 00 00 00 82       	push   $0x82000000
  8015d7:	68 00 00 00 80       	push   $0x80000000
  8015dc:	e8 00 08 00 00       	call   801de1 <initialize_dynamic_allocator>
  8015e1:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  8015e4:	e8 e7 05 00 00       	call   801bd0 <sys_get_uheap_strategy>
  8015e9:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  8015ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8015f3:	05 00 10 00 00       	add    $0x1000,%eax
  8015f8:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  8015fd:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801602:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801607:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80160e:	00 00 00 
	}
}
  801611:	90                   	nop
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	68 06 04 00 00       	push   $0x406
  801630:	50                   	push   %eax
  801631:	e8 e4 01 00 00       	call   80181a <__sys_allocate_page>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80163c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801640:	79 14                	jns    801656 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 88 31 80 00       	push   $0x803188
  80164a:	6a 1f                	push   $0x1f
  80164c:	68 c4 31 80 00       	push   $0x8031c4
  801651:	e8 b7 ed ff ff       	call   80040d <_panic>
	return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	50                   	push   %eax
  801675:	e8 e7 01 00 00       	call   801861 <__sys_unmap_frame>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801680:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801684:	79 14                	jns    80169a <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 d0 31 80 00       	push   $0x8031d0
  80168e:	6a 2a                	push   $0x2a
  801690:	68 c4 31 80 00       	push   $0x8031c4
  801695:	e8 73 ed ff ff       	call   80040d <_panic>
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016a3:	e8 18 ff ff ff       	call   8015c0 <uheap_init>
	if (size == 0) return NULL ;
  8016a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016ac:	75 07                	jne    8016b5 <malloc+0x18>
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	eb 14                	jmp    8016c9 <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 10 32 80 00       	push   $0x803210
  8016bd:	6a 3e                	push   $0x3e
  8016bf:	68 c4 31 80 00       	push   $0x8031c4
  8016c4:	e8 44 ed ff ff       	call   80040d <_panic>
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 38 32 80 00       	push   $0x803238
  8016d9:	6a 49                	push   $0x49
  8016db:	68 c4 31 80 00       	push   $0x8031c4
  8016e0:	e8 28 ed ff ff       	call   80040d <_panic>

008016e5 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 18             	sub    $0x18,%esp
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8016f1:	e8 ca fe ff ff       	call   8015c0 <uheap_init>
	if (size == 0) return NULL ;
  8016f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016fa:	75 07                	jne    801703 <smalloc+0x1e>
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801701:	eb 14                	jmp    801717 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801703:	83 ec 04             	sub    $0x4,%esp
  801706:	68 5c 32 80 00       	push   $0x80325c
  80170b:	6a 5a                	push   $0x5a
  80170d:	68 c4 31 80 00       	push   $0x8031c4
  801712:	e8 f6 ec ff ff       	call   80040d <_panic>
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80171f:	e8 9c fe ff ff       	call   8015c0 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	68 84 32 80 00       	push   $0x803284
  80172c:	6a 6a                	push   $0x6a
  80172e:	68 c4 31 80 00       	push   $0x8031c4
  801733:	e8 d5 ec ff ff       	call   80040d <_panic>

00801738 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80173e:	e8 7d fe ff ff       	call   8015c0 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	68 a8 32 80 00       	push   $0x8032a8
  80174b:	68 88 00 00 00       	push   $0x88
  801750:	68 c4 31 80 00       	push   $0x8031c4
  801755:	e8 b3 ec ff ff       	call   80040d <_panic>

0080175a <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	68 d0 32 80 00       	push   $0x8032d0
  801768:	68 9b 00 00 00       	push   $0x9b
  80176d:	68 c4 31 80 00       	push   $0x8031c4
  801772:	e8 96 ec ff ff       	call   80040d <_panic>

00801777 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	57                   	push   %edi
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
  80177d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801789:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80178f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801792:	cd 30                	int    $0x30
  801794:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5f                   	pop    %edi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8017ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	51                   	push   %ecx
  8017bb:	52                   	push   %edx
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	e8 b0 ff ff ff       	call   801777 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	90                   	nop
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 02                	push   $0x2
  8017dc:	e8 96 ff ff ff       	call   801777 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 03                	push   $0x3
  8017f5:	e8 7d ff ff ff       	call   801777 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 04                	push   $0x4
  80180f:	e8 63 ff ff ff       	call   801777 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	90                   	nop
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	52                   	push   %edx
  80182a:	50                   	push   %eax
  80182b:	6a 08                	push   $0x8
  80182d:	e8 45 ff ff ff       	call   801777 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	56                   	push   %esi
  80183b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80183c:	8b 75 18             	mov    0x18(%ebp),%esi
  80183f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801842:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	56                   	push   %esi
  80184c:	53                   	push   %ebx
  80184d:	51                   	push   %ecx
  80184e:	52                   	push   %edx
  80184f:	50                   	push   %eax
  801850:	6a 09                	push   $0x9
  801852:	e8 20 ff ff ff       	call   801777 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5d                   	pop    %ebp
  801860:	c3                   	ret    

00801861 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	ff 75 08             	pushl  0x8(%ebp)
  80186f:	6a 0a                	push   $0xa
  801871:	e8 01 ff ff ff       	call   801777 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 0b                	push   $0xb
  80188c:	e8 e6 fe ff ff       	call   801777 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 0c                	push   $0xc
  8018a5:	e8 cd fe ff ff       	call   801777 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 0d                	push   $0xd
  8018be:	e8 b4 fe ff ff       	call   801777 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 0e                	push   $0xe
  8018d7:	e8 9b fe ff ff       	call   801777 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 0f                	push   $0xf
  8018f0:	e8 82 fe ff ff       	call   801777 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	6a 10                	push   $0x10
  80190a:	e8 68 fe ff ff       	call   801777 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 11                	push   $0x11
  801923:	e8 4f fe ff ff       	call   801777 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_cputc>:

void
sys_cputc(const char c)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 04             	sub    $0x4,%esp
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80193a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	50                   	push   %eax
  801947:	6a 01                	push   $0x1
  801949:	e8 29 fe ff ff       	call   801777 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 14                	push   $0x14
  801963:	e8 0f fe ff ff       	call   801777 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	8b 45 10             	mov    0x10(%ebp),%eax
  801977:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80197a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	51                   	push   %ecx
  801987:	52                   	push   %edx
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	50                   	push   %eax
  80198c:	6a 15                	push   $0x15
  80198e:	e8 e4 fd ff ff       	call   801777 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 16                	push   $0x16
  8019ab:	e8 c7 fd ff ff       	call   801777 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	51                   	push   %ecx
  8019c6:	52                   	push   %edx
  8019c7:	50                   	push   %eax
  8019c8:	6a 17                	push   $0x17
  8019ca:	e8 a8 fd ff ff       	call   801777 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	52                   	push   %edx
  8019e4:	50                   	push   %eax
  8019e5:	6a 18                	push   $0x18
  8019e7:	e8 8b fd ff ff       	call   801777 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 14             	pushl  0x14(%ebp)
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	50                   	push   %eax
  801a03:	6a 19                	push   $0x19
  801a05:	e8 6d fd ff ff       	call   801777 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	50                   	push   %eax
  801a1e:	6a 1a                	push   $0x1a
  801a20:	e8 52 fd ff ff       	call   801777 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	50                   	push   %eax
  801a3a:	6a 1b                	push   $0x1b
  801a3c:	e8 36 fd ff ff       	call   801777 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 05                	push   $0x5
  801a55:	e8 1d fd ff ff       	call   801777 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 06                	push   $0x6
  801a6e:	e8 04 fd ff ff       	call   801777 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 07                	push   $0x7
  801a87:	e8 eb fc ff ff       	call   801777 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_exit_env>:


void sys_exit_env(void)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 1c                	push   $0x1c
  801aa0:	e8 d2 fc ff ff       	call   801777 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ab1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab4:	8d 50 04             	lea    0x4(%eax),%edx
  801ab7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	52                   	push   %edx
  801ac1:	50                   	push   %eax
  801ac2:	6a 1d                	push   $0x1d
  801ac4:	e8 ae fc ff ff       	call   801777 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return result;
  801acc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801acf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad5:	89 01                	mov    %eax,(%ecx)
  801ad7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	c9                   	leave  
  801ade:	c2 04 00             	ret    $0x4

00801ae1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	ff 75 10             	pushl  0x10(%ebp)
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	ff 75 08             	pushl  0x8(%ebp)
  801af1:	6a 13                	push   $0x13
  801af3:	e8 7f fc ff ff       	call   801777 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
	return ;
  801afb:	90                   	nop
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_rcr2>:
uint32 sys_rcr2()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 1e                	push   $0x1e
  801b0d:	e8 65 fc ff ff       	call   801777 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	50                   	push   %eax
  801b30:	6a 1f                	push   $0x1f
  801b32:	e8 40 fc ff ff       	call   801777 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3a:	90                   	nop
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <rsttst>:
void rsttst()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 21                	push   $0x21
  801b4c:	e8 26 fc ff ff       	call   801777 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
	return ;
  801b54:	90                   	nop
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b63:	8b 55 18             	mov    0x18(%ebp),%edx
  801b66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	ff 75 10             	pushl  0x10(%ebp)
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	ff 75 08             	pushl  0x8(%ebp)
  801b75:	6a 20                	push   $0x20
  801b77:	e8 fb fb ff ff       	call   801777 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7f:	90                   	nop
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <chktst>:
void chktst(uint32 n)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 22                	push   $0x22
  801b92:	e8 e0 fb ff ff       	call   801777 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <inctst>:

void inctst()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 23                	push   $0x23
  801bac:	e8 c6 fb ff ff       	call   801777 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <gettst>:
uint32 gettst()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 24                	push   $0x24
  801bc6:	e8 ac fb ff ff       	call   801777 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 25                	push   $0x25
  801bdf:	e8 93 fb ff ff       	call   801777 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
  801be7:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801bec:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 26                	push   $0x26
  801c0b:	e8 67 fb ff ff       	call   801777 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	53                   	push   %ebx
  801c29:	51                   	push   %ecx
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 27                	push   $0x27
  801c2e:	e8 44 fb ff ff       	call   801777 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	52                   	push   %edx
  801c4b:	50                   	push   %eax
  801c4c:	6a 28                	push   $0x28
  801c4e:	e8 24 fb ff ff       	call   801777 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	51                   	push   %ecx
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 29                	push   $0x29
  801c6e:	e8 04 fb ff ff       	call   801777 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 10             	pushl  0x10(%ebp)
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	ff 75 08             	pushl  0x8(%ebp)
  801c88:	6a 12                	push   $0x12
  801c8a:	e8 e8 fa ff ff       	call   801777 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	52                   	push   %edx
  801ca5:	50                   	push   %eax
  801ca6:	6a 2a                	push   $0x2a
  801ca8:	e8 ca fa ff ff       	call   801777 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 2b                	push   $0x2b
  801cc2:	e8 b0 fa ff ff       	call   801777 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 2d                	push   $0x2d
  801cdd:	e8 95 fa ff ff       	call   801777 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 2c                	push   $0x2c
  801cf9:	e8 79 fa ff ff       	call   801777 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	68 f4 32 80 00       	push   $0x8032f4
  801d12:	68 25 01 00 00       	push   $0x125
  801d17:	68 27 33 80 00       	push   $0x803327
  801d1c:	e8 ec e6 ff ff       	call   80040d <_panic>

00801d21 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801d27:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801d2e:	72 09                	jb     801d39 <to_page_va+0x18>
  801d30:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801d37:	72 14                	jb     801d4d <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801d39:	83 ec 04             	sub    $0x4,%esp
  801d3c:	68 38 33 80 00       	push   $0x803338
  801d41:	6a 15                	push   $0x15
  801d43:	68 63 33 80 00       	push   $0x803363
  801d48:	e8 c0 e6 ff ff       	call   80040d <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	ba 60 40 80 00       	mov    $0x804060,%edx
  801d55:	29 d0                	sub    %edx,%eax
  801d57:	c1 f8 02             	sar    $0x2,%eax
  801d5a:	89 c2                	mov    %eax,%edx
  801d5c:	89 d0                	mov    %edx,%eax
  801d5e:	c1 e0 02             	shl    $0x2,%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	c1 e0 02             	shl    $0x2,%eax
  801d66:	01 d0                	add    %edx,%eax
  801d68:	c1 e0 02             	shl    $0x2,%eax
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	89 c1                	mov    %eax,%ecx
  801d6f:	c1 e1 08             	shl    $0x8,%ecx
  801d72:	01 c8                	add    %ecx,%eax
  801d74:	89 c1                	mov    %eax,%ecx
  801d76:	c1 e1 10             	shl    $0x10,%ecx
  801d79:	01 c8                	add    %ecx,%eax
  801d7b:	01 c0                	add    %eax,%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	c1 e0 0c             	shl    $0xc,%eax
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d8f:	01 d0                	add    %edx,%eax
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801d99:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801da1:	29 c2                	sub    %eax,%edx
  801da3:	89 d0                	mov    %edx,%eax
  801da5:	c1 e8 0c             	shr    $0xc,%eax
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801daf:	78 09                	js     801dba <to_page_info+0x27>
  801db1:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801db8:	7e 14                	jle    801dce <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	68 7c 33 80 00       	push   $0x80337c
  801dc2:	6a 22                	push   $0x22
  801dc4:	68 63 33 80 00       	push   $0x803363
  801dc9:	e8 3f e6 ff ff       	call   80040d <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd1:	89 d0                	mov    %edx,%eax
  801dd3:	01 c0                	add    %eax,%eax
  801dd5:	01 d0                	add    %edx,%eax
  801dd7:	c1 e0 02             	shl    $0x2,%eax
  801dda:	05 60 40 80 00       	add    $0x804060,%eax
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	05 00 00 00 02       	add    $0x2000000,%eax
  801def:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801df2:	73 16                	jae    801e0a <initialize_dynamic_allocator+0x29>
  801df4:	68 a0 33 80 00       	push   $0x8033a0
  801df9:	68 c6 33 80 00       	push   $0x8033c6
  801dfe:	6a 34                	push   $0x34
  801e00:	68 63 33 80 00       	push   $0x803363
  801e05:	e8 03 e6 ff ff       	call   80040d <_panic>
		is_initialized = 1;
  801e0a:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801e11:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801e24:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801e2b:	00 00 00 
  801e2e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801e35:	00 00 00 
  801e38:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801e3f:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	2b 45 08             	sub    0x8(%ebp),%eax
  801e48:	c1 e8 0c             	shr    $0xc,%eax
  801e4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801e4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e55:	e9 c8 00 00 00       	jmp    801f22 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5d:	89 d0                	mov    %edx,%eax
  801e5f:	01 c0                	add    %eax,%eax
  801e61:	01 d0                	add    %edx,%eax
  801e63:	c1 e0 02             	shl    $0x2,%eax
  801e66:	05 68 40 80 00       	add    $0x804068,%eax
  801e6b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801e70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e73:	89 d0                	mov    %edx,%eax
  801e75:	01 c0                	add    %eax,%eax
  801e77:	01 d0                	add    %edx,%eax
  801e79:	c1 e0 02             	shl    $0x2,%eax
  801e7c:	05 6a 40 80 00       	add    $0x80406a,%eax
  801e81:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801e86:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801e8c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e8f:	89 c8                	mov    %ecx,%eax
  801e91:	01 c0                	add    %eax,%eax
  801e93:	01 c8                	add    %ecx,%eax
  801e95:	c1 e0 02             	shl    $0x2,%eax
  801e98:	05 64 40 80 00       	add    $0x804064,%eax
  801e9d:	89 10                	mov    %edx,(%eax)
  801e9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea2:	89 d0                	mov    %edx,%eax
  801ea4:	01 c0                	add    %eax,%eax
  801ea6:	01 d0                	add    %edx,%eax
  801ea8:	c1 e0 02             	shl    $0x2,%eax
  801eab:	05 64 40 80 00       	add    $0x804064,%eax
  801eb0:	8b 00                	mov    (%eax),%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	74 1b                	je     801ed1 <initialize_dynamic_allocator+0xf0>
  801eb6:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801ebc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ebf:	89 c8                	mov    %ecx,%eax
  801ec1:	01 c0                	add    %eax,%eax
  801ec3:	01 c8                	add    %ecx,%eax
  801ec5:	c1 e0 02             	shl    $0x2,%eax
  801ec8:	05 60 40 80 00       	add    $0x804060,%eax
  801ecd:	89 02                	mov    %eax,(%edx)
  801ecf:	eb 16                	jmp    801ee7 <initialize_dynamic_allocator+0x106>
  801ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed4:	89 d0                	mov    %edx,%eax
  801ed6:	01 c0                	add    %eax,%eax
  801ed8:	01 d0                	add    %edx,%eax
  801eda:	c1 e0 02             	shl    $0x2,%eax
  801edd:	05 60 40 80 00       	add    $0x804060,%eax
  801ee2:	a3 48 40 80 00       	mov    %eax,0x804048
  801ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	01 c0                	add    %eax,%eax
  801eee:	01 d0                	add    %edx,%eax
  801ef0:	c1 e0 02             	shl    $0x2,%eax
  801ef3:	05 60 40 80 00       	add    $0x804060,%eax
  801ef8:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f00:	89 d0                	mov    %edx,%eax
  801f02:	01 c0                	add    %eax,%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	c1 e0 02             	shl    $0x2,%eax
  801f09:	05 60 40 80 00       	add    $0x804060,%eax
  801f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f14:	a1 54 40 80 00       	mov    0x804054,%eax
  801f19:	40                   	inc    %eax
  801f1a:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801f1f:	ff 45 f4             	incl   -0xc(%ebp)
  801f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f25:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f28:	0f 8c 2c ff ff ff    	jl     801e5a <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801f35:	eb 36                	jmp    801f6d <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	c1 e0 04             	shl    $0x4,%eax
  801f3d:	05 80 c0 81 00       	add    $0x81c080,%eax
  801f42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	c1 e0 04             	shl    $0x4,%eax
  801f4e:	05 84 c0 81 00       	add    $0x81c084,%eax
  801f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	c1 e0 04             	shl    $0x4,%eax
  801f5f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  801f64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  801f6a:	ff 45 f0             	incl   -0x10(%ebp)
  801f6d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  801f71:	7e c4                	jle    801f37 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	50                   	push   %eax
  801f83:	e8 0b fe ff ff       	call   801d93 <to_page_info>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 40 08             	mov    0x8(%eax),%eax
  801f94:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	e8 77 fd ff ff       	call   801d21 <to_page_va>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  801fb0:	b8 00 10 00 00       	mov    $0x1000,%eax
  801fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fba:	f7 75 08             	divl   0x8(%ebp)
  801fbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  801fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc3:	83 ec 0c             	sub    $0xc,%esp
  801fc6:	50                   	push   %eax
  801fc7:	e8 48 f6 ff ff       	call   801614 <get_page>
  801fcc:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  801fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd5:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdf:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  801fe3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  801fea:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  801ff1:	eb 19                	jmp    80200c <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	ba 01 00 00 00       	mov    $0x1,%edx
  801ffb:	88 c1                	mov    %al,%cl
  801ffd:	d3 e2                	shl    %cl,%edx
  801fff:	89 d0                	mov    %edx,%eax
  802001:	3b 45 08             	cmp    0x8(%ebp),%eax
  802004:	74 0e                	je     802014 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802006:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802009:	ff 45 f0             	incl   -0x10(%ebp)
  80200c:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802010:	7e e1                	jle    801ff3 <split_page_to_blocks+0x5a>
  802012:	eb 01                	jmp    802015 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802014:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802015:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80201c:	e9 a7 00 00 00       	jmp    8020c8 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802024:	0f af 45 08          	imul   0x8(%ebp),%eax
  802028:	89 c2                	mov    %eax,%edx
  80202a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80202d:	01 d0                	add    %edx,%eax
  80202f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802032:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802036:	75 14                	jne    80204c <split_page_to_blocks+0xb3>
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 dc 33 80 00       	push   $0x8033dc
  802040:	6a 7c                	push   $0x7c
  802042:	68 63 33 80 00       	push   $0x803363
  802047:	e8 c1 e3 ff ff       	call   80040d <_panic>
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	c1 e0 04             	shl    $0x4,%eax
  802052:	05 84 c0 81 00       	add    $0x81c084,%eax
  802057:	8b 10                	mov    (%eax),%edx
  802059:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80205c:	89 50 04             	mov    %edx,0x4(%eax)
  80205f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802062:	8b 40 04             	mov    0x4(%eax),%eax
  802065:	85 c0                	test   %eax,%eax
  802067:	74 14                	je     80207d <split_page_to_blocks+0xe4>
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	c1 e0 04             	shl    $0x4,%eax
  80206f:	05 84 c0 81 00       	add    $0x81c084,%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802079:	89 10                	mov    %edx,(%eax)
  80207b:	eb 11                	jmp    80208e <split_page_to_blocks+0xf5>
  80207d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802080:	c1 e0 04             	shl    $0x4,%eax
  802083:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802089:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208c:	89 02                	mov    %eax,(%edx)
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	c1 e0 04             	shl    $0x4,%eax
  802094:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80209a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80209d:	89 02                	mov    %eax,(%edx)
  80209f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	c1 e0 04             	shl    $0x4,%eax
  8020ae:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020b3:	8b 00                	mov    (%eax),%eax
  8020b5:	8d 50 01             	lea    0x1(%eax),%edx
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c1 e0 04             	shl    $0x4,%eax
  8020be:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020c3:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8020c5:	ff 45 ec             	incl   -0x14(%ebp)
  8020c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020cb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8020ce:	0f 82 4d ff ff ff    	jb     802021 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8020dd:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8020e4:	76 19                	jbe    8020ff <alloc_block+0x28>
  8020e6:	68 00 34 80 00       	push   $0x803400
  8020eb:	68 c6 33 80 00       	push   $0x8033c6
  8020f0:	68 8a 00 00 00       	push   $0x8a
  8020f5:	68 63 33 80 00       	push   $0x803363
  8020fa:	e8 0e e3 ff ff       	call   80040d <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8020ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802106:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80210d:	eb 19                	jmp    802128 <alloc_block+0x51>
		if((1 << i) >= size) break;
  80210f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802112:	ba 01 00 00 00       	mov    $0x1,%edx
  802117:	88 c1                	mov    %al,%cl
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802120:	73 0e                	jae    802130 <alloc_block+0x59>
		idx++;
  802122:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802125:	ff 45 f0             	incl   -0x10(%ebp)
  802128:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80212c:	7e e1                	jle    80210f <alloc_block+0x38>
  80212e:	eb 01                	jmp    802131 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802130:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	c1 e0 04             	shl    $0x4,%eax
  802137:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	0f 84 df 00 00 00    	je     802225 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	c1 e0 04             	shl    $0x4,%eax
  80214c:	05 80 c0 81 00       	add    $0x81c080,%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  802156:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80215a:	75 17                	jne    802173 <alloc_block+0x9c>
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	68 21 34 80 00       	push   $0x803421
  802164:	68 9e 00 00 00       	push   $0x9e
  802169:	68 63 33 80 00       	push   $0x803363
  80216e:	e8 9a e2 ff ff       	call   80040d <_panic>
  802173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802176:	8b 00                	mov    (%eax),%eax
  802178:	85 c0                	test   %eax,%eax
  80217a:	74 10                	je     80218c <alloc_block+0xb5>
  80217c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802184:	8b 52 04             	mov    0x4(%edx),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	eb 14                	jmp    8021a0 <alloc_block+0xc9>
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	8b 40 04             	mov    0x4(%eax),%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	c1 e2 04             	shl    $0x4,%edx
  802198:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80219e:	89 02                	mov    %eax,(%edx)
  8021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a3:	8b 40 04             	mov    0x4(%eax),%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	74 0f                	je     8021b9 <alloc_block+0xe2>
  8021aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ad:	8b 40 04             	mov    0x4(%eax),%eax
  8021b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021b3:	8b 12                	mov    (%edx),%edx
  8021b5:	89 10                	mov    %edx,(%eax)
  8021b7:	eb 13                	jmp    8021cc <alloc_block+0xf5>
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c1:	c1 e2 04             	shl    $0x4,%edx
  8021c4:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8021ca:	89 02                	mov    %eax,(%edx)
  8021cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	c1 e0 04             	shl    $0x4,%eax
  8021e5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	c1 e0 04             	shl    $0x4,%eax
  8021f5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8021fa:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8021fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ff:	83 ec 0c             	sub    $0xc,%esp
  802202:	50                   	push   %eax
  802203:	e8 8b fb ff ff       	call   801d93 <to_page_info>
  802208:	83 c4 10             	add    $0x10,%esp
  80220b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80220e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802211:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802215:	48                   	dec    %eax
  802216:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802219:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802220:	e9 bc 02 00 00       	jmp    8024e1 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802225:	a1 54 40 80 00       	mov    0x804054,%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	0f 84 7d 02 00 00    	je     8024af <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802232:	a1 48 40 80 00       	mov    0x804048,%eax
  802237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80223a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80223e:	75 17                	jne    802257 <alloc_block+0x180>
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 21 34 80 00       	push   $0x803421
  802248:	68 a9 00 00 00       	push   $0xa9
  80224d:	68 63 33 80 00       	push   $0x803363
  802252:	e8 b6 e1 ff ff       	call   80040d <_panic>
  802257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 10                	je     802270 <alloc_block+0x199>
  802260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802268:	8b 52 04             	mov    0x4(%edx),%edx
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
  80226e:	eb 0b                	jmp    80227b <alloc_block+0x1a4>
  802270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802273:	8b 40 04             	mov    0x4(%eax),%eax
  802276:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80227b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 0f                	je     802294 <alloc_block+0x1bd>
  802285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802288:	8b 40 04             	mov    0x4(%eax),%eax
  80228b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80228e:	8b 12                	mov    (%edx),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	eb 0a                	jmp    80229e <alloc_block+0x1c7>
  802294:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	a3 48 40 80 00       	mov    %eax,0x804048
  80229e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b1:	a1 54 40 80 00       	mov    0x804054,%eax
  8022b6:	48                   	dec    %eax
  8022b7:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	83 c0 03             	add    $0x3,%eax
  8022c2:	ba 01 00 00 00       	mov    $0x1,%edx
  8022c7:	88 c1                	mov    %al,%cl
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 d0                	mov    %edx,%eax
  8022cd:	83 ec 08             	sub    $0x8,%esp
  8022d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022d3:	50                   	push   %eax
  8022d4:	e8 c0 fc ff ff       	call   801f99 <split_page_to_blocks>
  8022d9:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	c1 e0 04             	shl    $0x4,%eax
  8022e2:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8022f0:	75 17                	jne    802309 <alloc_block+0x232>
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	68 21 34 80 00       	push   $0x803421
  8022fa:	68 b0 00 00 00       	push   $0xb0
  8022ff:	68 63 33 80 00       	push   $0x803363
  802304:	e8 04 e1 ff ff       	call   80040d <_panic>
  802309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	74 10                	je     802322 <alloc_block+0x24b>
  802312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80231a:	8b 52 04             	mov    0x4(%edx),%edx
  80231d:	89 50 04             	mov    %edx,0x4(%eax)
  802320:	eb 14                	jmp    802336 <alloc_block+0x25f>
  802322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802325:	8b 40 04             	mov    0x4(%eax),%eax
  802328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232b:	c1 e2 04             	shl    $0x4,%edx
  80232e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802334:	89 02                	mov    %eax,(%edx)
  802336:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802339:	8b 40 04             	mov    0x4(%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 0f                	je     80234f <alloc_block+0x278>
  802340:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802349:	8b 12                	mov    (%edx),%edx
  80234b:	89 10                	mov    %edx,(%eax)
  80234d:	eb 13                	jmp    802362 <alloc_block+0x28b>
  80234f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802357:	c1 e2 04             	shl    $0x4,%edx
  80235a:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802360:	89 02                	mov    %eax,(%edx)
  802362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	c1 e0 04             	shl    $0x4,%eax
  80237b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	8d 50 ff             	lea    -0x1(%eax),%edx
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c1 e0 04             	shl    $0x4,%eax
  80238b:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802390:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	50                   	push   %eax
  802399:	e8 f5 f9 ff ff       	call   801d93 <to_page_info>
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  8023a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023a7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8023ab:	48                   	dec    %eax
  8023ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023af:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  8023b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b6:	e9 26 01 00 00       	jmp    8024e1 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  8023bb:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	c1 e0 04             	shl    $0x4,%eax
  8023c4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	0f 84 dc 00 00 00    	je     8024af <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c1 e0 04             	shl    $0x4,%eax
  8023d9:	05 80 c0 81 00       	add    $0x81c080,%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  8023e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8023e7:	75 17                	jne    802400 <alloc_block+0x329>
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	68 21 34 80 00       	push   $0x803421
  8023f1:	68 be 00 00 00       	push   $0xbe
  8023f6:	68 63 33 80 00       	push   $0x803363
  8023fb:	e8 0d e0 ff ff       	call   80040d <_panic>
  802400:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 10                	je     802419 <alloc_block+0x342>
  802409:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802411:	8b 52 04             	mov    0x4(%edx),%edx
  802414:	89 50 04             	mov    %edx,0x4(%eax)
  802417:	eb 14                	jmp    80242d <alloc_block+0x356>
  802419:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802422:	c1 e2 04             	shl    $0x4,%edx
  802425:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80242b:	89 02                	mov    %eax,(%edx)
  80242d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0f                	je     802446 <alloc_block+0x36f>
  802437:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80243a:	8b 40 04             	mov    0x4(%eax),%eax
  80243d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802440:	8b 12                	mov    (%edx),%edx
  802442:	89 10                	mov    %edx,(%eax)
  802444:	eb 13                	jmp    802459 <alloc_block+0x382>
  802446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244e:	c1 e2 04             	shl    $0x4,%edx
  802451:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802457:	89 02                	mov    %eax,(%edx)
  802459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802462:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802465:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	c1 e0 04             	shl    $0x4,%eax
  802472:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	8d 50 ff             	lea    -0x1(%eax),%edx
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	c1 e0 04             	shl    $0x4,%eax
  802482:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802487:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802489:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80248c:	83 ec 0c             	sub    $0xc,%esp
  80248f:	50                   	push   %eax
  802490:	e8 fe f8 ff ff       	call   801d93 <to_page_info>
  802495:	83 c4 10             	add    $0x10,%esp
  802498:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  80249b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80249e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8024a2:	48                   	dec    %eax
  8024a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8024a6:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  8024aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024ad:	eb 32                	jmp    8024e1 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  8024af:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  8024b3:	77 15                	ja     8024ca <alloc_block+0x3f3>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	c1 e0 04             	shl    $0x4,%eax
  8024bb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	0f 84 f1 fe ff ff    	je     8023bb <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	68 3f 34 80 00       	push   $0x80343f
  8024d2:	68 c8 00 00 00       	push   $0xc8
  8024d7:	68 63 33 80 00       	push   $0x803363
  8024dc:	e8 2c df ff ff       	call   80040d <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8024e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ec:	a1 64 c0 81 00       	mov    0x81c064,%eax
  8024f1:	39 c2                	cmp    %eax,%edx
  8024f3:	72 0c                	jb     802501 <free_block+0x1e>
  8024f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8024fd:	39 c2                	cmp    %eax,%edx
  8024ff:	72 19                	jb     80251a <free_block+0x37>
  802501:	68 50 34 80 00       	push   $0x803450
  802506:	68 c6 33 80 00       	push   $0x8033c6
  80250b:	68 d7 00 00 00       	push   $0xd7
  802510:	68 63 33 80 00       	push   $0x803363
  802515:	e8 f3 de ff ff       	call   80040d <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	50                   	push   %eax
  802527:	e8 67 f8 ff ff       	call   801d93 <to_page_info>
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802535:	8b 40 08             	mov    0x8(%eax),%eax
  802538:	0f b7 c0             	movzwl %ax,%eax
  80253b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80253e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802545:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80254c:	eb 19                	jmp    802567 <free_block+0x84>
	    if ((1 << i) == blk_size)
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	ba 01 00 00 00       	mov    $0x1,%edx
  802556:	88 c1                	mov    %al,%cl
  802558:	d3 e2                	shl    %cl,%edx
  80255a:	89 d0                	mov    %edx,%eax
  80255c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80255f:	74 0e                	je     80256f <free_block+0x8c>
	        break;
	    idx++;
  802561:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802564:	ff 45 f0             	incl   -0x10(%ebp)
  802567:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80256b:	7e e1                	jle    80254e <free_block+0x6b>
  80256d:	eb 01                	jmp    802570 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  80256f:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802573:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802577:	40                   	inc    %eax
  802578:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257b:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  80257f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802583:	75 17                	jne    80259c <free_block+0xb9>
  802585:	83 ec 04             	sub    $0x4,%esp
  802588:	68 dc 33 80 00       	push   $0x8033dc
  80258d:	68 ee 00 00 00       	push   $0xee
  802592:	68 63 33 80 00       	push   $0x803363
  802597:	e8 71 de ff ff       	call   80040d <_panic>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c1 e0 04             	shl    $0x4,%eax
  8025a2:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025a7:	8b 10                	mov    (%eax),%edx
  8025a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ac:	89 50 04             	mov    %edx,0x4(%eax)
  8025af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 14                	je     8025cd <free_block+0xea>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	c1 e0 04             	shl    $0x4,%eax
  8025bf:	05 84 c0 81 00       	add    $0x81c084,%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c9:	89 10                	mov    %edx,(%eax)
  8025cb:	eb 11                	jmp    8025de <free_block+0xfb>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	c1 e0 04             	shl    $0x4,%eax
  8025d3:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8025d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025dc:	89 02                	mov    %eax,(%edx)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c1 e0 04             	shl    $0x4,%eax
  8025e4:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8025ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ed:	89 02                	mov    %eax,(%edx)
  8025ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	c1 e0 04             	shl    $0x4,%eax
  8025fe:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	8d 50 01             	lea    0x1(%eax),%edx
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	c1 e0 04             	shl    $0x4,%eax
  80260e:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802613:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802615:	b8 00 10 00 00       	mov    $0x1000,%eax
  80261a:	ba 00 00 00 00       	mov    $0x0,%edx
  80261f:	f7 75 e0             	divl   -0x20(%ebp)
  802622:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802628:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80262c:	0f b7 c0             	movzwl %ax,%eax
  80262f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802632:	0f 85 70 01 00 00    	jne    8027a8 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80263e:	e8 de f6 ff ff       	call   801d21 <to_page_va>
  802643:	83 c4 10             	add    $0x10,%esp
  802646:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802649:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802650:	e9 b7 00 00 00       	jmp    80270c <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802655:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802660:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802664:	75 17                	jne    80267d <free_block+0x19a>
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 21 34 80 00       	push   $0x803421
  80266e:	68 f8 00 00 00       	push   $0xf8
  802673:	68 63 33 80 00       	push   $0x803363
  802678:	e8 90 dd ff ff       	call   80040d <_panic>
  80267d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 10                	je     802696 <free_block+0x1b3>
  802686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80268e:	8b 52 04             	mov    0x4(%edx),%edx
  802691:	89 50 04             	mov    %edx,0x4(%eax)
  802694:	eb 14                	jmp    8026aa <free_block+0x1c7>
  802696:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269f:	c1 e2 04             	shl    $0x4,%edx
  8026a2:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8026a8:	89 02                	mov    %eax,(%edx)
  8026aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0f                	je     8026c3 <free_block+0x1e0>
  8026b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8026bd:	8b 12                	mov    (%edx),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 13                	jmp    8026d6 <free_block+0x1f3>
  8026c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	c1 e2 04             	shl    $0x4,%edx
  8026ce:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8026d4:	89 02                	mov    %eax,(%edx)
  8026d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c1 e0 04             	shl    $0x4,%eax
  8026ef:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	c1 e0 04             	shl    $0x4,%eax
  8026ff:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802704:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802709:	01 45 ec             	add    %eax,-0x14(%ebp)
  80270c:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802713:	0f 86 3c ff ff ff    	jbe    802655 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80272b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80272f:	75 17                	jne    802748 <free_block+0x265>
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	68 dc 33 80 00       	push   $0x8033dc
  802739:	68 fe 00 00 00       	push   $0xfe
  80273e:	68 63 33 80 00       	push   $0x803363
  802743:	e8 c5 dc ff ff       	call   80040d <_panic>
  802748:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80274e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802751:	89 50 04             	mov    %edx,0x4(%eax)
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	74 0c                	je     80276a <free_block+0x287>
  80275e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802766:	89 10                	mov    %edx,(%eax)
  802768:	eb 08                	jmp    802772 <free_block+0x28f>
  80276a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276d:	a3 48 40 80 00       	mov    %eax,0x804048
  802772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802775:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802783:	a1 54 40 80 00       	mov    0x804054,%eax
  802788:	40                   	inc    %eax
  802789:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	ff 75 e4             	pushl  -0x1c(%ebp)
  802794:	e8 88 f5 ff ff       	call   801d21 <to_page_va>
  802799:	83 c4 10             	add    $0x10,%esp
  80279c:	83 ec 0c             	sub    $0xc,%esp
  80279f:	50                   	push   %eax
  8027a0:	e8 b8 ee ff ff       	call   80165d <return_page>
  8027a5:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  8027a8:	90                   	nop
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
  8027ae:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	68 88 34 80 00       	push   $0x803488
  8027b9:	68 11 01 00 00       	push   $0x111
  8027be:	68 63 33 80 00       	push   $0x803363
  8027c3:	e8 45 dc ff ff       	call   80040d <_panic>

008027c8 <__udivdi3>:
  8027c8:	55                   	push   %ebp
  8027c9:	57                   	push   %edi
  8027ca:	56                   	push   %esi
  8027cb:	53                   	push   %ebx
  8027cc:	83 ec 1c             	sub    $0x1c,%esp
  8027cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8027d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8027d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8027db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027df:	89 ca                	mov    %ecx,%edx
  8027e1:	89 f8                	mov    %edi,%eax
  8027e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8027e7:	85 f6                	test   %esi,%esi
  8027e9:	75 2d                	jne    802818 <__udivdi3+0x50>
  8027eb:	39 cf                	cmp    %ecx,%edi
  8027ed:	77 65                	ja     802854 <__udivdi3+0x8c>
  8027ef:	89 fd                	mov    %edi,%ebp
  8027f1:	85 ff                	test   %edi,%edi
  8027f3:	75 0b                	jne    802800 <__udivdi3+0x38>
  8027f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8027fa:	31 d2                	xor    %edx,%edx
  8027fc:	f7 f7                	div    %edi
  8027fe:	89 c5                	mov    %eax,%ebp
  802800:	31 d2                	xor    %edx,%edx
  802802:	89 c8                	mov    %ecx,%eax
  802804:	f7 f5                	div    %ebp
  802806:	89 c1                	mov    %eax,%ecx
  802808:	89 d8                	mov    %ebx,%eax
  80280a:	f7 f5                	div    %ebp
  80280c:	89 cf                	mov    %ecx,%edi
  80280e:	89 fa                	mov    %edi,%edx
  802810:	83 c4 1c             	add    $0x1c,%esp
  802813:	5b                   	pop    %ebx
  802814:	5e                   	pop    %esi
  802815:	5f                   	pop    %edi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    
  802818:	39 ce                	cmp    %ecx,%esi
  80281a:	77 28                	ja     802844 <__udivdi3+0x7c>
  80281c:	0f bd fe             	bsr    %esi,%edi
  80281f:	83 f7 1f             	xor    $0x1f,%edi
  802822:	75 40                	jne    802864 <__udivdi3+0x9c>
  802824:	39 ce                	cmp    %ecx,%esi
  802826:	72 0a                	jb     802832 <__udivdi3+0x6a>
  802828:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80282c:	0f 87 9e 00 00 00    	ja     8028d0 <__udivdi3+0x108>
  802832:	b8 01 00 00 00       	mov    $0x1,%eax
  802837:	89 fa                	mov    %edi,%edx
  802839:	83 c4 1c             	add    $0x1c,%esp
  80283c:	5b                   	pop    %ebx
  80283d:	5e                   	pop    %esi
  80283e:	5f                   	pop    %edi
  80283f:	5d                   	pop    %ebp
  802840:	c3                   	ret    
  802841:	8d 76 00             	lea    0x0(%esi),%esi
  802844:	31 ff                	xor    %edi,%edi
  802846:	31 c0                	xor    %eax,%eax
  802848:	89 fa                	mov    %edi,%edx
  80284a:	83 c4 1c             	add    $0x1c,%esp
  80284d:	5b                   	pop    %ebx
  80284e:	5e                   	pop    %esi
  80284f:	5f                   	pop    %edi
  802850:	5d                   	pop    %ebp
  802851:	c3                   	ret    
  802852:	66 90                	xchg   %ax,%ax
  802854:	89 d8                	mov    %ebx,%eax
  802856:	f7 f7                	div    %edi
  802858:	31 ff                	xor    %edi,%edi
  80285a:	89 fa                	mov    %edi,%edx
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
  802864:	bd 20 00 00 00       	mov    $0x20,%ebp
  802869:	89 eb                	mov    %ebp,%ebx
  80286b:	29 fb                	sub    %edi,%ebx
  80286d:	89 f9                	mov    %edi,%ecx
  80286f:	d3 e6                	shl    %cl,%esi
  802871:	89 c5                	mov    %eax,%ebp
  802873:	88 d9                	mov    %bl,%cl
  802875:	d3 ed                	shr    %cl,%ebp
  802877:	89 e9                	mov    %ebp,%ecx
  802879:	09 f1                	or     %esi,%ecx
  80287b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80287f:	89 f9                	mov    %edi,%ecx
  802881:	d3 e0                	shl    %cl,%eax
  802883:	89 c5                	mov    %eax,%ebp
  802885:	89 d6                	mov    %edx,%esi
  802887:	88 d9                	mov    %bl,%cl
  802889:	d3 ee                	shr    %cl,%esi
  80288b:	89 f9                	mov    %edi,%ecx
  80288d:	d3 e2                	shl    %cl,%edx
  80288f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802893:	88 d9                	mov    %bl,%cl
  802895:	d3 e8                	shr    %cl,%eax
  802897:	09 c2                	or     %eax,%edx
  802899:	89 d0                	mov    %edx,%eax
  80289b:	89 f2                	mov    %esi,%edx
  80289d:	f7 74 24 0c          	divl   0xc(%esp)
  8028a1:	89 d6                	mov    %edx,%esi
  8028a3:	89 c3                	mov    %eax,%ebx
  8028a5:	f7 e5                	mul    %ebp
  8028a7:	39 d6                	cmp    %edx,%esi
  8028a9:	72 19                	jb     8028c4 <__udivdi3+0xfc>
  8028ab:	74 0b                	je     8028b8 <__udivdi3+0xf0>
  8028ad:	89 d8                	mov    %ebx,%eax
  8028af:	31 ff                	xor    %edi,%edi
  8028b1:	e9 58 ff ff ff       	jmp    80280e <__udivdi3+0x46>
  8028b6:	66 90                	xchg   %ax,%ax
  8028b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8028bc:	89 f9                	mov    %edi,%ecx
  8028be:	d3 e2                	shl    %cl,%edx
  8028c0:	39 c2                	cmp    %eax,%edx
  8028c2:	73 e9                	jae    8028ad <__udivdi3+0xe5>
  8028c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028c7:	31 ff                	xor    %edi,%edi
  8028c9:	e9 40 ff ff ff       	jmp    80280e <__udivdi3+0x46>
  8028ce:	66 90                	xchg   %ax,%ax
  8028d0:	31 c0                	xor    %eax,%eax
  8028d2:	e9 37 ff ff ff       	jmp    80280e <__udivdi3+0x46>
  8028d7:	90                   	nop

008028d8 <__umoddi3>:
  8028d8:	55                   	push   %ebp
  8028d9:	57                   	push   %edi
  8028da:	56                   	push   %esi
  8028db:	53                   	push   %ebx
  8028dc:	83 ec 1c             	sub    $0x1c,%esp
  8028df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8028e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8028e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028f7:	89 f3                	mov    %esi,%ebx
  8028f9:	89 fa                	mov    %edi,%edx
  8028fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8028ff:	89 34 24             	mov    %esi,(%esp)
  802902:	85 c0                	test   %eax,%eax
  802904:	75 1a                	jne    802920 <__umoddi3+0x48>
  802906:	39 f7                	cmp    %esi,%edi
  802908:	0f 86 a2 00 00 00    	jbe    8029b0 <__umoddi3+0xd8>
  80290e:	89 c8                	mov    %ecx,%eax
  802910:	89 f2                	mov    %esi,%edx
  802912:	f7 f7                	div    %edi
  802914:	89 d0                	mov    %edx,%eax
  802916:	31 d2                	xor    %edx,%edx
  802918:	83 c4 1c             	add    $0x1c,%esp
  80291b:	5b                   	pop    %ebx
  80291c:	5e                   	pop    %esi
  80291d:	5f                   	pop    %edi
  80291e:	5d                   	pop    %ebp
  80291f:	c3                   	ret    
  802920:	39 f0                	cmp    %esi,%eax
  802922:	0f 87 ac 00 00 00    	ja     8029d4 <__umoddi3+0xfc>
  802928:	0f bd e8             	bsr    %eax,%ebp
  80292b:	83 f5 1f             	xor    $0x1f,%ebp
  80292e:	0f 84 ac 00 00 00    	je     8029e0 <__umoddi3+0x108>
  802934:	bf 20 00 00 00       	mov    $0x20,%edi
  802939:	29 ef                	sub    %ebp,%edi
  80293b:	89 fe                	mov    %edi,%esi
  80293d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802941:	89 e9                	mov    %ebp,%ecx
  802943:	d3 e0                	shl    %cl,%eax
  802945:	89 d7                	mov    %edx,%edi
  802947:	89 f1                	mov    %esi,%ecx
  802949:	d3 ef                	shr    %cl,%edi
  80294b:	09 c7                	or     %eax,%edi
  80294d:	89 e9                	mov    %ebp,%ecx
  80294f:	d3 e2                	shl    %cl,%edx
  802951:	89 14 24             	mov    %edx,(%esp)
  802954:	89 d8                	mov    %ebx,%eax
  802956:	d3 e0                	shl    %cl,%eax
  802958:	89 c2                	mov    %eax,%edx
  80295a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80295e:	d3 e0                	shl    %cl,%eax
  802960:	89 44 24 04          	mov    %eax,0x4(%esp)
  802964:	8b 44 24 08          	mov    0x8(%esp),%eax
  802968:	89 f1                	mov    %esi,%ecx
  80296a:	d3 e8                	shr    %cl,%eax
  80296c:	09 d0                	or     %edx,%eax
  80296e:	d3 eb                	shr    %cl,%ebx
  802970:	89 da                	mov    %ebx,%edx
  802972:	f7 f7                	div    %edi
  802974:	89 d3                	mov    %edx,%ebx
  802976:	f7 24 24             	mull   (%esp)
  802979:	89 c6                	mov    %eax,%esi
  80297b:	89 d1                	mov    %edx,%ecx
  80297d:	39 d3                	cmp    %edx,%ebx
  80297f:	0f 82 87 00 00 00    	jb     802a0c <__umoddi3+0x134>
  802985:	0f 84 91 00 00 00    	je     802a1c <__umoddi3+0x144>
  80298b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80298f:	29 f2                	sub    %esi,%edx
  802991:	19 cb                	sbb    %ecx,%ebx
  802993:	89 d8                	mov    %ebx,%eax
  802995:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802999:	d3 e0                	shl    %cl,%eax
  80299b:	89 e9                	mov    %ebp,%ecx
  80299d:	d3 ea                	shr    %cl,%edx
  80299f:	09 d0                	or     %edx,%eax
  8029a1:	89 e9                	mov    %ebp,%ecx
  8029a3:	d3 eb                	shr    %cl,%ebx
  8029a5:	89 da                	mov    %ebx,%edx
  8029a7:	83 c4 1c             	add    $0x1c,%esp
  8029aa:	5b                   	pop    %ebx
  8029ab:	5e                   	pop    %esi
  8029ac:	5f                   	pop    %edi
  8029ad:	5d                   	pop    %ebp
  8029ae:	c3                   	ret    
  8029af:	90                   	nop
  8029b0:	89 fd                	mov    %edi,%ebp
  8029b2:	85 ff                	test   %edi,%edi
  8029b4:	75 0b                	jne    8029c1 <__umoddi3+0xe9>
  8029b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	f7 f7                	div    %edi
  8029bf:	89 c5                	mov    %eax,%ebp
  8029c1:	89 f0                	mov    %esi,%eax
  8029c3:	31 d2                	xor    %edx,%edx
  8029c5:	f7 f5                	div    %ebp
  8029c7:	89 c8                	mov    %ecx,%eax
  8029c9:	f7 f5                	div    %ebp
  8029cb:	89 d0                	mov    %edx,%eax
  8029cd:	e9 44 ff ff ff       	jmp    802916 <__umoddi3+0x3e>
  8029d2:	66 90                	xchg   %ax,%ax
  8029d4:	89 c8                	mov    %ecx,%eax
  8029d6:	89 f2                	mov    %esi,%edx
  8029d8:	83 c4 1c             	add    $0x1c,%esp
  8029db:	5b                   	pop    %ebx
  8029dc:	5e                   	pop    %esi
  8029dd:	5f                   	pop    %edi
  8029de:	5d                   	pop    %ebp
  8029df:	c3                   	ret    
  8029e0:	3b 04 24             	cmp    (%esp),%eax
  8029e3:	72 06                	jb     8029eb <__umoddi3+0x113>
  8029e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8029e9:	77 0f                	ja     8029fa <__umoddi3+0x122>
  8029eb:	89 f2                	mov    %esi,%edx
  8029ed:	29 f9                	sub    %edi,%ecx
  8029ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8029f3:	89 14 24             	mov    %edx,(%esp)
  8029f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029fe:	8b 14 24             	mov    (%esp),%edx
  802a01:	83 c4 1c             	add    $0x1c,%esp
  802a04:	5b                   	pop    %ebx
  802a05:	5e                   	pop    %esi
  802a06:	5f                   	pop    %edi
  802a07:	5d                   	pop    %ebp
  802a08:	c3                   	ret    
  802a09:	8d 76 00             	lea    0x0(%esi),%esi
  802a0c:	2b 04 24             	sub    (%esp),%eax
  802a0f:	19 fa                	sbb    %edi,%edx
  802a11:	89 d1                	mov    %edx,%ecx
  802a13:	89 c6                	mov    %eax,%esi
  802a15:	e9 71 ff ff ff       	jmp    80298b <__umoddi3+0xb3>
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802a20:	72 ea                	jb     802a0c <__umoddi3+0x134>
  802a22:	89 d9                	mov    %ebx,%ecx
  802a24:	e9 62 ff ff ff       	jmp    80298b <__umoddi3+0xb3>
