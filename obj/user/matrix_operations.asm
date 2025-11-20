
obj/user/matrix_operations:     file format elf32-i386


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
  800031:	e8 de 09 00 00       	call   800a14 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements);
int64** MatrixAddition(int **M1, int **M2, int NumOfElements);
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Line[255] ;
	char Chose ;
	int val =0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int NumOfElements = 3;
  800049:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	do
	{
		val = 0;
  800050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		NumOfElements = 3;
  800057:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80005e:	e8 69 1f 00 00       	call   801fcc <sys_lock_cons>
		cprintf("\n");
  800063:	83 ec 0c             	sub    $0xc,%esp
  800066:	68 00 34 80 00       	push   $0x803400
  80006b:	e8 49 0c 00 00       	call   800cb9 <cprintf>
  800070:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 04 34 80 00       	push   $0x803404
  80007b:	e8 39 0c 00 00       	call   800cb9 <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   MATRIX MULTIPLICATION    !!!\n");
  800083:	83 ec 0c             	sub    $0xc,%esp
  800086:	68 28 34 80 00       	push   $0x803428
  80008b:	e8 29 0c 00 00       	call   800cb9 <cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	68 04 34 80 00       	push   $0x803404
  80009b:	e8 19 0c 00 00       	call   800cb9 <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 00 34 80 00       	push   $0x803400
  8000ab:	e8 09 0c 00 00       	call   800cb9 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000bc:	50                   	push   %eax
  8000bd:	68 4c 34 80 00       	push   $0x80344c
  8000c2:	e8 cb 12 00 00       	call   801392 <readline>
  8000c7:	83 c4 10             	add    $0x10,%esp
		NumOfElements = strtol(Line, NULL, 10) ;
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 0a                	push   $0xa
  8000cf:	6a 00                	push   $0x0
  8000d1:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  8000d7:	50                   	push   %eax
  8000d8:	e8 cc 18 00 00       	call   8019a9 <strtol>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	68 6c 34 80 00       	push   $0x80346c
  8000eb:	e8 c9 0b 00 00       	call   800cb9 <cprintf>
  8000f0:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 8e 34 80 00       	push   $0x80348e
  8000fb:	e8 b9 0b 00 00       	call   800cb9 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Identical\n") ;
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	68 9c 34 80 00       	push   $0x80349c
  80010b:	e8 a9 0b 00 00       	call   800cb9 <cprintf>
  800110:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	68 aa 34 80 00       	push   $0x8034aa
  80011b:	e8 99 0b 00 00       	call   800cb9 <cprintf>
  800120:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 ba 34 80 00       	push   $0x8034ba
  80012b:	e8 89 0b 00 00       	call   800cb9 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800133:	e8 bf 08 00 00       	call   8009f7 <getchar>
  800138:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80013b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	50                   	push   %eax
  800143:	e8 90 08 00 00       	call   8009d8 <cputchar>
  800148:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80014b:	83 ec 0c             	sub    $0xc,%esp
  80014e:	6a 0a                	push   $0xa
  800150:	e8 83 08 00 00       	call   8009d8 <cputchar>
  800155:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800158:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  80015c:	74 0c                	je     80016a <_main+0x132>
  80015e:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800162:	74 06                	je     80016a <_main+0x132>
  800164:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  800168:	75 b9                	jne    800123 <_main+0xeb>

		if (Chose == 'b')
  80016a:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  80016e:	75 30                	jne    8001a0 <_main+0x168>
		{
			readline("Enter the value to be initialized: ", Line);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	68 c4 34 80 00       	push   $0x8034c4
  80017f:	e8 0e 12 00 00       	call   801392 <readline>
  800184:	83 c4 10             	add    $0x10,%esp
			val = strtol(Line, NULL, 10) ;
  800187:	83 ec 04             	sub    $0x4,%esp
  80018a:	6a 0a                	push   $0xa
  80018c:	6a 00                	push   $0x0
  80018e:	8d 85 d9 fe ff ff    	lea    -0x127(%ebp),%eax
  800194:	50                   	push   %eax
  800195:	e8 0f 18 00 00       	call   8019a9 <strtol>
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		}
		//2012: lock the interrupt
		sys_unlock_cons();
  8001a0:	e8 41 1e 00 00       	call   801fe6 <sys_unlock_cons>

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
  8001a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a8:	c1 e0 02             	shl    $0x2,%eax
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	50                   	push   %eax
  8001af:	e8 cf 1c 00 00       	call   801e83 <malloc>
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int **M2 = malloc(sizeof(int) * NumOfElements) ;
  8001ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001bd:	c1 e0 02             	shl    $0x2,%eax
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	50                   	push   %eax
  8001c4:	e8 ba 1c 00 00       	call   801e83 <malloc>
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (int i = 0; i < NumOfElements; ++i)
  8001cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001d6:	eb 4b                	jmp    800223 <_main+0x1eb>
		{
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
  8001d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001e5:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  8001e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001eb:	c1 e0 02             	shl    $0x2,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 8c 1c 00 00       	call   801e83 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 03                	mov    %eax,(%ebx)
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
  8001fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800206:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800209:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80020c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020f:	c1 e0 02             	shl    $0x2,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	50                   	push   %eax
  800216:	e8 68 1c 00 00       	call   801e83 <malloc>
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	89 03                	mov    %eax,(%ebx)
		sys_unlock_cons();

		int **M1 = malloc(sizeof(int) * NumOfElements) ;
		int **M2 = malloc(sizeof(int) * NumOfElements) ;

		for (int i = 0; i < NumOfElements; ++i)
  800220:	ff 45 f0             	incl   -0x10(%ebp)
  800223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800226:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800229:	7c ad                	jl     8001d8 <_main+0x1a0>
			M1[i] = malloc(sizeof(int) * NumOfElements) ;
			M2[i] = malloc(sizeof(int) * NumOfElements) ;
		}

		int  i ;
		switch (Chose)
  80022b:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80022f:	83 f8 62             	cmp    $0x62,%eax
  800232:	74 2e                	je     800262 <_main+0x22a>
  800234:	83 f8 63             	cmp    $0x63,%eax
  800237:	74 53                	je     80028c <_main+0x254>
  800239:	83 f8 61             	cmp    $0x61,%eax
  80023c:	75 72                	jne    8002b0 <_main+0x278>
		{
		case 'a':
			InitializeAscending(M1, NumOfElements);
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	ff 75 e4             	pushl  -0x1c(%ebp)
  800244:	ff 75 dc             	pushl  -0x24(%ebp)
  800247:	e8 9b 05 00 00       	call   8007e7 <InitializeAscending>
  80024c:	83 c4 10             	add    $0x10,%esp
			InitializeAscending(M2, NumOfElements);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 e4             	pushl  -0x1c(%ebp)
  800255:	ff 75 d8             	pushl  -0x28(%ebp)
  800258:	e8 8a 05 00 00       	call   8007e7 <InitializeAscending>
  80025d:	83 c4 10             	add    $0x10,%esp
			break ;
  800260:	eb 70                	jmp    8002d2 <_main+0x29a>
		case 'b':
			InitializeIdentical(M1, NumOfElements, val);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	ff 75 f4             	pushl  -0xc(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 dc             	pushl  -0x24(%ebp)
  80026e:	e8 c3 05 00 00       	call   800836 <InitializeIdentical>
  800273:	83 c4 10             	add    $0x10,%esp
			InitializeIdentical(M2, NumOfElements, val);
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	ff 75 f4             	pushl  -0xc(%ebp)
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	ff 75 d8             	pushl  -0x28(%ebp)
  800282:	e8 af 05 00 00       	call   800836 <InitializeIdentical>
  800287:	83 c4 10             	add    $0x10,%esp
			break ;
  80028a:	eb 46                	jmp    8002d2 <_main+0x29a>
		case 'c':
			InitializeSemiRandom(M1, NumOfElements);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	e8 eb 05 00 00       	call   800885 <InitializeSemiRandom>
  80029a:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 da 05 00 00       	call   800885 <InitializeSemiRandom>
  8002ab:	83 c4 10             	add    $0x10,%esp
			//PrintElements(M1, NumOfElements);
			break ;
  8002ae:	eb 22                	jmp    8002d2 <_main+0x29a>
		default:
			InitializeSemiRandom(M1, NumOfElements);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	e8 c7 05 00 00       	call   800885 <InitializeSemiRandom>
  8002be:	83 c4 10             	add    $0x10,%esp
			InitializeSemiRandom(M2, NumOfElements);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 b6 05 00 00       	call   800885 <InitializeSemiRandom>
  8002cf:	83 c4 10             	add    $0x10,%esp
		}

		sys_lock_cons();
  8002d2:	e8 f5 1c 00 00       	call   801fcc <sys_lock_cons>
		cprintf("Chose the desired operation:\n") ;
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 e8 34 80 00       	push   $0x8034e8
  8002df:	e8 d5 09 00 00       	call   800cb9 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Addition       (+)\n") ;
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 06 35 80 00       	push   $0x803506
  8002ef:	e8 c5 09 00 00       	call   800cb9 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Subtraction    (-)\n") ;
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	68 1d 35 80 00       	push   $0x80351d
  8002ff:	e8 b5 09 00 00       	call   800cb9 <cprintf>
  800304:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Multiplication (x)\n");
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 34 35 80 00       	push   $0x803534
  80030f:	e8 a5 09 00 00       	call   800cb9 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	68 ba 34 80 00       	push   $0x8034ba
  80031f:	e8 95 09 00 00       	call   800cb9 <cprintf>
  800324:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  800327:	e8 cb 06 00 00       	call   8009f7 <getchar>
  80032c:	88 45 e3             	mov    %al,-0x1d(%ebp)
			cputchar(Chose);
  80032f:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  800333:	83 ec 0c             	sub    $0xc,%esp
  800336:	50                   	push   %eax
  800337:	e8 9c 06 00 00       	call   8009d8 <cputchar>
  80033c:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 0a                	push   $0xa
  800344:	e8 8f 06 00 00       	call   8009d8 <cputchar>
  800349:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80034c:	80 7d e3 61          	cmpb   $0x61,-0x1d(%ebp)
  800350:	74 0c                	je     80035e <_main+0x326>
  800352:	80 7d e3 62          	cmpb   $0x62,-0x1d(%ebp)
  800356:	74 06                	je     80035e <_main+0x326>
  800358:	80 7d e3 63          	cmpb   $0x63,-0x1d(%ebp)
  80035c:	75 b9                	jne    800317 <_main+0x2df>
		sys_unlock_cons();
  80035e:	e8 83 1c 00 00       	call   801fe6 <sys_unlock_cons>


		int64** Res = NULL ;
  800363:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		switch (Chose)
  80036a:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  80036e:	83 f8 62             	cmp    $0x62,%eax
  800371:	74 23                	je     800396 <_main+0x35e>
  800373:	83 f8 63             	cmp    $0x63,%eax
  800376:	74 37                	je     8003af <_main+0x377>
  800378:	83 f8 61             	cmp    $0x61,%eax
  80037b:	75 4b                	jne    8003c8 <_main+0x390>
		{
		case 'a':
			Res = MatrixAddition(M1, M2, NumOfElements);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	ff 75 e4             	pushl  -0x1c(%ebp)
  800383:	ff 75 d8             	pushl  -0x28(%ebp)
  800386:	ff 75 dc             	pushl  -0x24(%ebp)
  800389:	e8 9f 02 00 00       	call   80062d <MatrixAddition>
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  800394:	eb 49                	jmp    8003df <_main+0x3a7>
		case 'b':
			Res = MatrixSubtraction(M1, M2, NumOfElements);
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039c:	ff 75 d8             	pushl  -0x28(%ebp)
  80039f:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a2:	e8 62 03 00 00       	call   800709 <MatrixSubtraction>
  8003a7:	83 c4 10             	add    $0x10,%esp
  8003aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003ad:	eb 30                	jmp    8003df <_main+0x3a7>
		case 'c':
			Res = MatrixMultiply(M1, M2, NumOfElements);
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003bb:	e8 1d 01 00 00       	call   8004dd <MatrixMultiply>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
			break ;
  8003c6:	eb 17                	jmp    8003df <_main+0x3a7>
		default:
			Res = MatrixAddition(M1, M2, NumOfElements);
  8003c8:	83 ec 04             	sub    $0x4,%esp
  8003cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ce:	ff 75 d8             	pushl  -0x28(%ebp)
  8003d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003d4:	e8 54 02 00 00       	call   80062d <MatrixAddition>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
			//PrintElements64(Res, NumOfElements);
		}


		sys_lock_cons();
  8003df:	e8 e8 1b 00 00       	call   801fcc <sys_lock_cons>
		cprintf("Operation is COMPLETED.\n");
  8003e4:	83 ec 0c             	sub    $0xc,%esp
  8003e7:	68 4b 35 80 00       	push   $0x80354b
  8003ec:	e8 c8 08 00 00       	call   800cb9 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8003f4:	e8 ed 1b 00 00       	call   801fe6 <sys_unlock_cons>

		for (int i = 0; i < NumOfElements; ++i)
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 5a                	jmp    80045c <_main+0x424>
		{
			free(M1[i]);
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	83 ec 0c             	sub    $0xc,%esp
  800416:	50                   	push   %eax
  800417:	e8 95 1a 00 00       	call   801eb1 <free>
  80041c:	83 c4 10             	add    $0x10,%esp
			free(M2[i]);
  80041f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	83 ec 0c             	sub    $0xc,%esp
  800433:	50                   	push   %eax
  800434:	e8 78 1a 00 00       	call   801eb1 <free>
  800439:	83 c4 10             	add    $0x10,%esp
			free(Res[i]);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800449:	01 d0                	add    %edx,%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	83 ec 0c             	sub    $0xc,%esp
  800450:	50                   	push   %eax
  800451:	e8 5b 1a 00 00       	call   801eb1 <free>
  800456:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
		cprintf("Operation is COMPLETED.\n");
		sys_unlock_cons();

		for (int i = 0; i < NumOfElements; ++i)
  800459:	ff 45 e8             	incl   -0x18(%ebp)
  80045c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800462:	7c 9e                	jl     800402 <_main+0x3ca>
		{
			free(M1[i]);
			free(M2[i]);
			free(Res[i]);
		}
		free(M1) ;
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	ff 75 dc             	pushl  -0x24(%ebp)
  80046a:	e8 42 1a 00 00       	call   801eb1 <free>
  80046f:	83 c4 10             	add    $0x10,%esp
		free(M2) ;
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	ff 75 d8             	pushl  -0x28(%ebp)
  800478:	e8 34 1a 00 00       	call   801eb1 <free>
  80047d:	83 c4 10             	add    $0x10,%esp
		free(Res) ;
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	ff 75 ec             	pushl  -0x14(%ebp)
  800486:	e8 26 1a 00 00       	call   801eb1 <free>
  80048b:	83 c4 10             	add    $0x10,%esp


		sys_lock_cons();
  80048e:	e8 39 1b 00 00       	call   801fcc <sys_lock_cons>
		cprintf("Do you want to repeat (y/n): ") ;
  800493:	83 ec 0c             	sub    $0xc,%esp
  800496:	68 64 35 80 00       	push   $0x803564
  80049b:	e8 19 08 00 00       	call   800cb9 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  8004a3:	e8 4f 05 00 00       	call   8009f7 <getchar>
  8004a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
		cputchar(Chose);
  8004ab:	0f be 45 e3          	movsbl -0x1d(%ebp),%eax
  8004af:	83 ec 0c             	sub    $0xc,%esp
  8004b2:	50                   	push   %eax
  8004b3:	e8 20 05 00 00       	call   8009d8 <cputchar>
  8004b8:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  8004bb:	83 ec 0c             	sub    $0xc,%esp
  8004be:	6a 0a                	push   $0xa
  8004c0:	e8 13 05 00 00       	call   8009d8 <cputchar>
  8004c5:	83 c4 10             	add    $0x10,%esp
		sys_unlock_cons();
  8004c8:	e8 19 1b 00 00       	call   801fe6 <sys_unlock_cons>

	} while (Chose == 'y');
  8004cd:	80 7d e3 79          	cmpb   $0x79,-0x1d(%ebp)
  8004d1:	0f 84 79 fb ff ff    	je     800050 <_main+0x18>

}
  8004d7:	90                   	nop
  8004d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004db:	c9                   	leave  
  8004dc:	c3                   	ret    

008004dd <MatrixMultiply>:

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
  8004dd:	55                   	push   %ebp
  8004de:	89 e5                	mov    %esp,%ebp
  8004e0:	57                   	push   %edi
  8004e1:	56                   	push   %esi
  8004e2:	53                   	push   %ebx
  8004e3:	83 ec 2c             	sub    $0x2c,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	c1 e0 03             	shl    $0x3,%eax
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	50                   	push   %eax
  8004f0:	e8 8e 19 00 00       	call   801e83 <malloc>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  8004fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800502:	eb 27                	jmp    80052b <MatrixMultiply+0x4e>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800507:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800514:	8b 45 10             	mov    0x10(%ebp),%eax
  800517:	c1 e0 03             	shl    $0x3,%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 60 19 00 00       	call   801e83 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 03                	mov    %eax,(%ebx)

///MATRIX MULTIPLICATION
int64** MatrixMultiply(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800528:	ff 45 e4             	incl   -0x1c(%ebp)
  80052b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800531:	7c d1                	jl     800504 <MatrixMultiply+0x27>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800533:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80053a:	e9 d7 00 00 00       	jmp    800616 <MatrixMultiply+0x139>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80053f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800546:	e9 bc 00 00 00       	jmp    800607 <MatrixMultiply+0x12a>
		{
			Res[i][j] = 0 ;
  80054b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800558:	01 d0                	add    %edx,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055f:	c1 e2 03             	shl    $0x3,%edx
  800562:	01 d0                	add    %edx,%eax
  800564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80056a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (int k = 0; k < NumOfElements; ++k)
  800571:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800578:	eb 7e                	jmp    8005f8 <MatrixMultiply+0x11b>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
  80057a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80058e:	c1 e2 03             	shl    $0x3,%edx
  800591:	8d 34 10             	lea    (%eax,%edx,1),%esi
  800594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800597:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	01 d0                	add    %edx,%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005a8:	c1 e2 03             	shl    $0x3,%edx
  8005ab:	01 d0                	add    %edx,%eax
  8005ad:	8b 08                	mov    (%eax),%ecx
  8005af:	8b 58 04             	mov    0x4(%eax),%ebx
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c6:	c1 e2 02             	shl    $0x2,%edx
  8005c9:	01 d0                	add    %edx,%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005d0:	8d 3c 85 00 00 00 00 	lea    0x0(,%eax,4),%edi
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	01 f8                	add    %edi,%eax
  8005dc:	8b 00                	mov    (%eax),%eax
  8005de:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005e1:	c1 e7 02             	shl    $0x2,%edi
  8005e4:	01 f8                	add    %edi,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	0f af c2             	imul   %edx,%eax
  8005eb:	99                   	cltd   
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	11 da                	adc    %ebx,%edx
  8005f0:	89 06                	mov    %eax,(%esi)
  8005f2:	89 56 04             	mov    %edx,0x4(%esi)
	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = 0 ;
			for (int k = 0; k < NumOfElements; ++k)
  8005f5:	ff 45 d8             	incl   -0x28(%ebp)
  8005f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005fb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8005fe:	0f 8c 76 ff ff ff    	jl     80057a <MatrixMultiply+0x9d>
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  800604:	ff 45 dc             	incl   -0x24(%ebp)
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80060d:	0f 8c 38 ff ff ff    	jl     80054b <MatrixMultiply+0x6e>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800613:	ff 45 e0             	incl   -0x20(%ebp)
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	3b 45 10             	cmp    0x10(%ebp),%eax
  80061c:	0f 8c 1d ff ff ff    	jl     80053f <MatrixMultiply+0x62>
			{
				Res[i][j] += M1[i][k] * M2[k][j] ;
			}
		}
	}
	return Res;
  800622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800625:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800628:	5b                   	pop    %ebx
  800629:	5e                   	pop    %esi
  80062a:	5f                   	pop    %edi
  80062b:	5d                   	pop    %ebp
  80062c:	c3                   	ret    

0080062d <MatrixAddition>:

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	53                   	push   %ebx
  800631:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800634:	8b 45 10             	mov    0x10(%ebp),%eax
  800637:	c1 e0 03             	shl    $0x3,%eax
  80063a:	83 ec 0c             	sub    $0xc,%esp
  80063d:	50                   	push   %eax
  80063e:	e8 40 18 00 00       	call   801e83 <malloc>
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800650:	eb 27                	jmp    800679 <MatrixAddition+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  800652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800655:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	50                   	push   %eax
  80066c:	e8 12 18 00 00       	call   801e83 <malloc>
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	89 03                	mov    %eax,(%ebx)

///MATRIX ADDITION
int64** MatrixAddition(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800676:	ff 45 f4             	incl   -0xc(%ebp)
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80067f:	7c d1                	jl     800652 <MatrixAddition+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	eb 6f                	jmp    8006f9 <MatrixAddition+0xcc>
	{
		for (int j = 0; j < NumOfElements; ++j)
  80068a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800691:	eb 5b                	jmp    8006ee <MatrixAddition+0xc1>
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
  800693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006a0:	01 d0                	add    %edx,%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006a7:	c1 e2 03             	shl    $0x3,%edx
  8006aa:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	01 d0                	add    %edx,%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c1:	c1 e2 02             	shl    $0x2,%edx
  8006c4:	01 d0                	add    %edx,%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d5:	01 d8                	add    %ebx,%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8006dc:	c1 e3 02             	shl    $0x2,%ebx
  8006df:	01 d8                	add    %ebx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	99                   	cltd   
  8006e6:	89 01                	mov    %eax,(%ecx)
  8006e8:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8006eb:	ff 45 ec             	incl   -0x14(%ebp)
  8006ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006f4:	7c 9d                	jl     800693 <MatrixAddition+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8006f6:	ff 45 f0             	incl   -0x10(%ebp)
  8006f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8006ff:	7c 89                	jl     80068a <MatrixAddition+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] + M2[i][j] ;
		}
	}
	return Res;
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  800704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <MatrixSubtraction>:

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	53                   	push   %ebx
  80070d:	83 ec 14             	sub    $0x14,%esp
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
  800710:	8b 45 10             	mov    0x10(%ebp),%eax
  800713:	c1 e0 03             	shl    $0x3,%eax
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	50                   	push   %eax
  80071a:	e8 64 17 00 00       	call   801e83 <malloc>
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 45 e8             	mov    %eax,-0x18(%ebp)
	for (int i = 0; i < NumOfElements; ++i)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80072c:	eb 27                	jmp    800755 <MatrixSubtraction+0x4c>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
  80072e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800731:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	c1 e0 03             	shl    $0x3,%eax
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	50                   	push   %eax
  800748:	e8 36 17 00 00       	call   801e83 <malloc>
  80074d:	83 c4 10             	add    $0x10,%esp
  800750:	89 03                	mov    %eax,(%ebx)

///MATRIX SUBTRACTION
int64** MatrixSubtraction(int **M1, int **M2, int NumOfElements)
{
	int64 **Res = malloc(sizeof(int64) * NumOfElements) ;
	for (int i = 0; i < NumOfElements; ++i)
  800752:	ff 45 f4             	incl   -0xc(%ebp)
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	3b 45 10             	cmp    0x10(%ebp),%eax
  80075b:	7c d1                	jl     80072e <MatrixSubtraction+0x25>
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  80075d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800764:	eb 71                	jmp    8007d7 <MatrixSubtraction+0xce>
	{
		for (int j = 0; j < NumOfElements; ++j)
  800766:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80076d:	eb 5d                	jmp    8007cc <MatrixSubtraction+0xc3>
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800779:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80077c:	01 d0                	add    %edx,%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800783:	c1 e2 03             	shl    $0x3,%edx
  800786:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800793:	8b 45 08             	mov    0x8(%ebp),%eax
  800796:	01 d0                	add    %edx,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80079d:	c1 e2 02             	shl    $0x2,%edx
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	8b 10                	mov    (%eax),%edx
  8007a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a7:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	8b 00                	mov    (%eax),%eax
  8007b5:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8007b8:	c1 e3 02             	shl    $0x2,%ebx
  8007bb:	01 d8                	add    %ebx,%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	29 c2                	sub    %eax,%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	99                   	cltd   
  8007c4:	89 01                	mov    %eax,(%ecx)
  8007c6:	89 51 04             	mov    %edx,0x4(%ecx)
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
	{
		for (int j = 0; j < NumOfElements; ++j)
  8007c9:	ff 45 ec             	incl   -0x14(%ebp)
  8007cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cf:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007d2:	7c 9b                	jl     80076f <MatrixSubtraction+0x66>
	for (int i = 0; i < NumOfElements; ++i)
	{
		Res[i] = malloc(sizeof(int64) * NumOfElements) ;
	}

	for (int i = 0; i < NumOfElements; ++i)
  8007d4:	ff 45 f0             	incl   -0x10(%ebp)
  8007d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007da:	3b 45 10             	cmp    0x10(%ebp),%eax
  8007dd:	7c 87                	jl     800766 <MatrixSubtraction+0x5d>
		for (int j = 0; j < NumOfElements; ++j)
		{
			Res[i][j] = M1[i][j] - M2[i][j] ;
		}
	}
	return Res;
  8007df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8007e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <InitializeAscending>:

///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8007ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8007f4:	eb 35                	jmp    80082b <InitializeAscending+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8007f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8007fd:	eb 21                	jmp    800820 <InitializeAscending+0x39>
		{
			(Elements)[i][j] = j ;
  8007ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800802:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	8b 00                	mov    (%eax),%eax
  800810:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800813:	c1 e2 02             	shl    $0x2,%edx
  800816:	01 c2                	add    %eax,%edx
  800818:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80081b:	89 02                	mov    %eax,(%edx)
void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80081d:	ff 45 f8             	incl   -0x8(%ebp)
  800820:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800823:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800826:	7c d7                	jl     8007ff <InitializeAscending+0x18>
///Private Functions

void InitializeAscending(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800828:	ff 45 fc             	incl   -0x4(%ebp)
  80082b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80082e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800831:	7c c3                	jl     8007f6 <InitializeAscending+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = j ;
		}
	}
}
  800833:	90                   	nop
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <InitializeIdentical>:

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	83 ec 10             	sub    $0x10,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80083c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800843:	eb 35                	jmp    80087a <InitializeIdentical+0x44>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800845:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80084c:	eb 21                	jmp    80086f <InitializeIdentical+0x39>
		{
			(Elements)[i][j] = value ;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800858:	8b 45 08             	mov    0x8(%ebp),%eax
  80085b:	01 d0                	add    %edx,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800862:	c1 e2 02             	shl    $0x2,%edx
  800865:	01 c2                	add    %eax,%edx
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 02                	mov    %eax,(%edx)
void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80086c:	ff 45 f8             	incl   -0x8(%ebp)
  80086f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800872:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800875:	7c d7                	jl     80084e <InitializeIdentical+0x18>
}

void InitializeIdentical(int **Elements, int NumOfElements, int value)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800877:	ff 45 fc             	incl   -0x4(%ebp)
  80087a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800880:	7c c3                	jl     800845 <InitializeIdentical+0xf>
		for (j = 0 ; j < NumOfElements ; j++)
		{
			(Elements)[i][j] = value ;
		}
	}
}
  800882:	90                   	nop
  800883:	c9                   	leave  
  800884:	c3                   	ret    

00800885 <InitializeSemiRandom>:

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 20             	sub    $0x20,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80088c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800893:	eb 56                	jmp    8008eb <InitializeSemiRandom+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800895:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80089c:	eb 42                	jmp    8008e0 <InitializeSemiRandom+0x5b>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
  80089e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	01 d0                	add    %edx,%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b2:	c1 e2 02             	shl    $0x2,%edx
  8008b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  8008b8:	0f 31                	rdtsc  
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	89 55 e8             	mov    %edx,-0x18(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  8008c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d7:	f7 f3                	div    %ebx
  8008d9:	89 d0                	mov    %edx,%eax
  8008db:	89 01                	mov    %eax,(%ecx)
void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8008dd:	ff 45 f4             	incl   -0xc(%ebp)
  8008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008e6:	7c b6                	jl     80089e <InitializeSemiRandom+0x19>
}

void InitializeSemiRandom(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8008e8:	ff 45 f8             	incl   -0x8(%ebp)
  8008eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8008ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f1:	7c a2                	jl     800895 <InitializeSemiRandom+0x10>
		{
			(Elements)[i][j] =  RANDU(0, NumOfElements) ;
			//	cprintf("i=%d\n",i);
		}
	}
}
  8008f3:	90                   	nop
  8008f4:	83 c4 20             	add    $0x20,%esp
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <PrintElements>:

void PrintElements(int **Elements, int NumOfElements)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800907:	eb 53                	jmp    80095c <PrintElements+0x62>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800910:	eb 2f                	jmp    800941 <PrintElements+0x47>
		{
			cprintf("%~%d, ",Elements[i][j]);
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800926:	c1 e2 02             	shl    $0x2,%edx
  800929:	01 d0                	add    %edx,%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 ec 08             	sub    $0x8,%esp
  800930:	50                   	push   %eax
  800931:	68 82 35 80 00       	push   $0x803582
  800936:	e8 7e 03 00 00       	call   800cb9 <cprintf>
  80093b:	83 c4 10             	add    $0x10,%esp
void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  80093e:	ff 45 f0             	incl   -0x10(%ebp)
  800941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800944:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800947:	7c c9                	jl     800912 <PrintElements+0x18>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
  800949:	83 ec 0c             	sub    $0xc,%esp
  80094c:	68 89 35 80 00       	push   $0x803589
  800951:	e8 63 03 00 00       	call   800cb9 <cprintf>
  800956:	83 c4 10             	add    $0x10,%esp
}

void PrintElements(int **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  800959:	ff 45 f4             	incl   -0xc(%ebp)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800962:	7c a5                	jl     800909 <PrintElements+0xf>
		{
			cprintf("%~%d, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <PrintElements64>:

void PrintElements64(int64 **Elements, int NumOfElements)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  80096d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800974:	eb 57                	jmp    8009cd <PrintElements64+0x66>
	{
		for (j = 0 ; j < NumOfElements ; j++)
  800976:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097d:	eb 33                	jmp    8009b2 <PrintElements64+0x4b>
		{
			cprintf("%~%lld, ",Elements[i][j]);
  80097f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800982:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	01 d0                	add    %edx,%eax
  80098e:	8b 00                	mov    (%eax),%eax
  800990:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800993:	c1 e2 03             	shl    $0x3,%edx
  800996:	01 d0                	add    %edx,%eax
  800998:	8b 50 04             	mov    0x4(%eax),%edx
  80099b:	8b 00                	mov    (%eax),%eax
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	52                   	push   %edx
  8009a1:	50                   	push   %eax
  8009a2:	68 8d 35 80 00       	push   $0x80358d
  8009a7:	e8 0d 03 00 00       	call   800cb9 <cprintf>
  8009ac:	83 c4 10             	add    $0x10,%esp
void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
	{
		for (j = 0 ; j < NumOfElements ; j++)
  8009af:	ff 45 f0             	incl   -0x10(%ebp)
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009b8:	7c c5                	jl     80097f <PrintElements64+0x18>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
  8009ba:	83 ec 0c             	sub    $0xc,%esp
  8009bd:	68 89 35 80 00       	push   $0x803589
  8009c2:	e8 f2 02 00 00       	call   800cb9 <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
}

void PrintElements64(int64 **Elements, int NumOfElements)
{
	int i, j ;
	for (i = 0 ; i < NumOfElements ; i++)
  8009ca:	ff 45 f4             	incl   -0xc(%ebp)
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009d3:	7c a1                	jl     800976 <PrintElements64+0xf>
		{
			cprintf("%~%lld, ",Elements[i][j]);
		}
		cprintf("%~\n");
	}
}
  8009d5:	90                   	nop
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8009e4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	50                   	push   %eax
  8009ec:	e8 23 17 00 00       	call   802114 <sys_cputc>
  8009f1:	83 c4 10             	add    $0x10,%esp
}
  8009f4:	90                   	nop
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <getchar>:


int
getchar(void)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8009fd:	e8 b1 15 00 00       	call   801fb3 <sys_cgetc>
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <iscons>:

int iscons(int fdnum)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800a0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800a1d:	e8 23 18 00 00       	call   802245 <sys_getenvindex>
  800a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800a25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	c1 e0 06             	shl    $0x6,%eax
  800a2d:	29 d0                	sub    %edx,%eax
  800a2f:	c1 e0 02             	shl    $0x2,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a3b:	01 c8                	add    %ecx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 d0                	add    %edx,%eax
  800a42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a49:	29 c2                	sub    %eax,%edx
  800a4b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800a5a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800a5f:	a1 20 40 80 00       	mov    0x804020,%eax
  800a64:	8a 40 20             	mov    0x20(%eax),%al
  800a67:	84 c0                	test   %al,%al
  800a69:	74 0d                	je     800a78 <libmain+0x64>
		binaryname = myEnv->prog_name;
  800a6b:	a1 20 40 80 00       	mov    0x804020,%eax
  800a70:	83 c0 20             	add    $0x20,%eax
  800a73:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7c:	7e 0a                	jle    800a88 <libmain+0x74>
		binaryname = argv[0];
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a2 f5 ff ff       	call   800038 <_main>
  800a96:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800a99:	a1 00 40 80 00       	mov    0x804000,%eax
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	0f 84 01 01 00 00    	je     800ba7 <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800aa6:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800aac:	bb 90 36 80 00       	mov    $0x803690,%ebx
  800ab1:	ba 0e 00 00 00       	mov    $0xe,%edx
  800ab6:	89 c7                	mov    %eax,%edi
  800ab8:	89 de                	mov    %ebx,%esi
  800aba:	89 d1                	mov    %edx,%ecx
  800abc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800abe:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800ac1:	b9 56 00 00 00       	mov    $0x56,%ecx
  800ac6:	b0 00                	mov    $0x0,%al
  800ac8:	89 d7                	mov    %edx,%edi
  800aca:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800acc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800ad3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ad6:	83 ec 08             	sub    $0x8,%esp
  800ad9:	50                   	push   %eax
  800ada:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800ae0:	50                   	push   %eax
  800ae1:	e8 95 19 00 00       	call   80247b <sys_utilities>
  800ae6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  800ae9:	e8 de 14 00 00       	call   801fcc <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800aee:	83 ec 0c             	sub    $0xc,%esp
  800af1:	68 b0 35 80 00       	push   $0x8035b0
  800af6:	e8 be 01 00 00       	call   800cb9 <cprintf>
  800afb:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b01:	85 c0                	test   %eax,%eax
  800b03:	74 18                	je     800b1d <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800b05:	e8 8f 19 00 00       	call   802499 <sys_get_optimal_num_faults>
  800b0a:	83 ec 08             	sub    $0x8,%esp
  800b0d:	50                   	push   %eax
  800b0e:	68 d8 35 80 00       	push   $0x8035d8
  800b13:	e8 a1 01 00 00       	call   800cb9 <cprintf>
  800b18:	83 c4 10             	add    $0x10,%esp
  800b1b:	eb 59                	jmp    800b76 <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b1d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b22:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800b28:	a1 20 40 80 00       	mov    0x804020,%eax
  800b2d:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800b33:	83 ec 04             	sub    $0x4,%esp
  800b36:	52                   	push   %edx
  800b37:	50                   	push   %eax
  800b38:	68 fc 35 80 00       	push   $0x8035fc
  800b3d:	e8 77 01 00 00       	call   800cb9 <cprintf>
  800b42:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800b45:	a1 20 40 80 00       	mov    0x804020,%eax
  800b4a:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800b50:	a1 20 40 80 00       	mov    0x804020,%eax
  800b55:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800b5b:	a1 20 40 80 00       	mov    0x804020,%eax
  800b60:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800b66:	51                   	push   %ecx
  800b67:	52                   	push   %edx
  800b68:	50                   	push   %eax
  800b69:	68 24 36 80 00       	push   $0x803624
  800b6e:	e8 46 01 00 00       	call   800cb9 <cprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800b76:	a1 20 40 80 00       	mov    0x804020,%eax
  800b7b:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	50                   	push   %eax
  800b85:	68 7c 36 80 00       	push   $0x80367c
  800b8a:	e8 2a 01 00 00       	call   800cb9 <cprintf>
  800b8f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	68 b0 35 80 00       	push   $0x8035b0
  800b9a:	e8 1a 01 00 00       	call   800cb9 <cprintf>
  800b9f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800ba2:	e8 3f 14 00 00       	call   801fe6 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800ba7:	e8 1f 00 00 00       	call   800bcb <exit>
}
  800bac:	90                   	nop
  800bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	6a 00                	push   $0x0
  800bc0:	e8 4c 16 00 00       	call   802211 <sys_destroy_env>
  800bc5:	83 c4 10             	add    $0x10,%esp
}
  800bc8:	90                   	nop
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <exit>:

void
exit(void)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800bd1:	e8 a1 16 00 00       	call   802277 <sys_exit_env>
}
  800bd6:	90                   	nop
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	53                   	push   %ebx
  800bdd:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	8d 48 01             	lea    0x1(%eax),%ecx
  800be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800beb:	89 0a                	mov    %ecx,(%edx)
  800bed:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf0:	88 d1                	mov    %dl,%cl
  800bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	8b 00                	mov    (%eax),%eax
  800bfe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c03:	75 30                	jne    800c35 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800c05:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800c0b:	a0 44 40 80 00       	mov    0x804044,%al
  800c10:	0f b6 c0             	movzbl %al,%eax
  800c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c16:	8b 09                	mov    (%ecx),%ecx
  800c18:	89 cb                	mov    %ecx,%ebx
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	83 c1 08             	add    $0x8,%ecx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	53                   	push   %ebx
  800c23:	51                   	push   %ecx
  800c24:	e8 5f 13 00 00       	call   801f88 <sys_cputs>
  800c29:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	8b 40 04             	mov    0x4(%eax),%eax
  800c3b:	8d 50 01             	lea    0x1(%eax),%edx
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c44:	90                   	nop
  800c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c5a:	00 00 00 
	b.cnt = 0;
  800c5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	ff 75 08             	pushl  0x8(%ebp)
  800c6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c73:	50                   	push   %eax
  800c74:	68 d9 0b 80 00       	push   $0x800bd9
  800c79:	e8 5a 02 00 00       	call   800ed8 <vprintfmt>
  800c7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800c81:	8b 15 18 c1 81 00    	mov    0x81c118,%edx
  800c87:	a0 44 40 80 00       	mov    0x804044,%al
  800c8c:	0f b6 c0             	movzbl %al,%eax
  800c8f:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800c95:	52                   	push   %edx
  800c96:	50                   	push   %eax
  800c97:	51                   	push   %ecx
  800c98:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c9e:	83 c0 08             	add    $0x8,%eax
  800ca1:	50                   	push   %eax
  800ca2:	e8 e1 12 00 00       	call   801f88 <sys_cputs>
  800ca7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800caa:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800cb1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cbf:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800cc6:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	83 ec 08             	sub    $0x8,%esp
  800cd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	e8 6f ff ff ff       	call   800c4a <vcprintf>
  800cdb:	83 c4 10             	add    $0x10,%esp
  800cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cec:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	c1 e0 08             	shl    $0x8,%eax
  800cf9:	a3 18 c1 81 00       	mov    %eax,0x81c118
	va_start(ap, fmt);
  800cfe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d01:	83 c0 04             	add    $0x4,%eax
  800d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	83 ec 08             	sub    $0x8,%esp
  800d0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800d10:	50                   	push   %eax
  800d11:	e8 34 ff ff ff       	call   800c4a <vcprintf>
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800d1c:	c7 05 18 c1 81 00 00 	movl   $0x700,0x81c118
  800d23:	07 00 00 

	return cnt;
  800d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d31:	e8 96 12 00 00       	call   801fcc <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d36:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	83 ec 08             	sub    $0x8,%esp
  800d42:	ff 75 f4             	pushl  -0xc(%ebp)
  800d45:	50                   	push   %eax
  800d46:	e8 ff fe ff ff       	call   800c4a <vcprintf>
  800d4b:	83 c4 10             	add    $0x10,%esp
  800d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d51:	e8 90 12 00 00       	call   801fe6 <sys_unlock_cons>
	return cnt;
  800d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d59:	c9                   	leave  
  800d5a:	c3                   	ret    

00800d5b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 14             	sub    $0x14,%esp
  800d62:	8b 45 10             	mov    0x10(%ebp),%eax
  800d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d68:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d6e:	8b 45 18             	mov    0x18(%ebp),%eax
  800d71:	ba 00 00 00 00       	mov    $0x0,%edx
  800d76:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d79:	77 55                	ja     800dd0 <printnum+0x75>
  800d7b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d7e:	72 05                	jb     800d85 <printnum+0x2a>
  800d80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d83:	77 4b                	ja     800dd0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d85:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d88:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d8b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d93:	52                   	push   %edx
  800d94:	50                   	push   %eax
  800d95:	ff 75 f4             	pushl  -0xc(%ebp)
  800d98:	ff 75 f0             	pushl  -0x10(%ebp)
  800d9b:	e8 fc 23 00 00       	call   80319c <__udivdi3>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	83 ec 04             	sub    $0x4,%esp
  800da6:	ff 75 20             	pushl  0x20(%ebp)
  800da9:	53                   	push   %ebx
  800daa:	ff 75 18             	pushl  0x18(%ebp)
  800dad:	52                   	push   %edx
  800dae:	50                   	push   %eax
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	ff 75 08             	pushl  0x8(%ebp)
  800db5:	e8 a1 ff ff ff       	call   800d5b <printnum>
  800dba:	83 c4 20             	add    $0x20,%esp
  800dbd:	eb 1a                	jmp    800dd9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800dbf:	83 ec 08             	sub    $0x8,%esp
  800dc2:	ff 75 0c             	pushl  0xc(%ebp)
  800dc5:	ff 75 20             	pushl  0x20(%ebp)
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcb:	ff d0                	call   *%eax
  800dcd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dd0:	ff 4d 1c             	decl   0x1c(%ebp)
  800dd3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800dd7:	7f e6                	jg     800dbf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800dd9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de7:	53                   	push   %ebx
  800de8:	51                   	push   %ecx
  800de9:	52                   	push   %edx
  800dea:	50                   	push   %eax
  800deb:	e8 bc 24 00 00       	call   8032ac <__umoddi3>
  800df0:	83 c4 10             	add    $0x10,%esp
  800df3:	05 14 39 80 00       	add    $0x803914,%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	0f be c0             	movsbl %al,%eax
  800dfd:	83 ec 08             	sub    $0x8,%esp
  800e00:	ff 75 0c             	pushl  0xc(%ebp)
  800e03:	50                   	push   %eax
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	ff d0                	call   *%eax
  800e09:	83 c4 10             	add    $0x10,%esp
}
  800e0c:	90                   	nop
  800e0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e15:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e19:	7e 1c                	jle    800e37 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8b 00                	mov    (%eax),%eax
  800e20:	8d 50 08             	lea    0x8(%eax),%edx
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	89 10                	mov    %edx,(%eax)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	83 e8 08             	sub    $0x8,%eax
  800e30:	8b 50 04             	mov    0x4(%eax),%edx
  800e33:	8b 00                	mov    (%eax),%eax
  800e35:	eb 40                	jmp    800e77 <getuint+0x65>
	else if (lflag)
  800e37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e3b:	74 1e                	je     800e5b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8b 00                	mov    (%eax),%eax
  800e42:	8d 50 04             	lea    0x4(%eax),%edx
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	89 10                	mov    %edx,(%eax)
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	83 e8 04             	sub    $0x4,%eax
  800e52:	8b 00                	mov    (%eax),%eax
  800e54:	ba 00 00 00 00       	mov    $0x0,%edx
  800e59:	eb 1c                	jmp    800e77 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	8d 50 04             	lea    0x4(%eax),%edx
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	89 10                	mov    %edx,(%eax)
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8b 00                	mov    (%eax),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e7c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e80:	7e 1c                	jle    800e9e <getint+0x25>
		return va_arg(*ap, long long);
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	8d 50 08             	lea    0x8(%eax),%edx
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	89 10                	mov    %edx,(%eax)
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8b 00                	mov    (%eax),%eax
  800e94:	83 e8 08             	sub    $0x8,%eax
  800e97:	8b 50 04             	mov    0x4(%eax),%edx
  800e9a:	8b 00                	mov    (%eax),%eax
  800e9c:	eb 38                	jmp    800ed6 <getint+0x5d>
	else if (lflag)
  800e9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea2:	74 1a                	je     800ebe <getint+0x45>
		return va_arg(*ap, long);
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	8b 00                	mov    (%eax),%eax
  800ea9:	8d 50 04             	lea    0x4(%eax),%edx
  800eac:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaf:	89 10                	mov    %edx,(%eax)
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8b 00                	mov    (%eax),%eax
  800eb6:	83 e8 04             	sub    $0x4,%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	99                   	cltd   
  800ebc:	eb 18                	jmp    800ed6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8b 00                	mov    (%eax),%eax
  800ec3:	8d 50 04             	lea    0x4(%eax),%edx
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	89 10                	mov    %edx,(%eax)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8b 00                	mov    (%eax),%eax
  800ed0:	83 e8 04             	sub    $0x4,%eax
  800ed3:	8b 00                	mov    (%eax),%eax
  800ed5:	99                   	cltd   
}
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ee0:	eb 17                	jmp    800ef9 <vprintfmt+0x21>
			if (ch == '\0')
  800ee2:	85 db                	test   %ebx,%ebx
  800ee4:	0f 84 c1 03 00 00    	je     8012ab <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	53                   	push   %ebx
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 10             	mov    %edx,0x10(%ebp)
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d8             	movzbl %al,%ebx
  800f07:	83 fb 25             	cmp    $0x25,%ebx
  800f0a:	75 d6                	jne    800ee2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 10             	mov    %edx,0x10(%ebp)
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f b6 d8             	movzbl %al,%ebx
  800f3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f3d:	83 f8 5b             	cmp    $0x5b,%eax
  800f40:	0f 87 3d 03 00 00    	ja     801283 <vprintfmt+0x3ab>
  800f46:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  800f4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f53:	eb d7                	jmp    800f2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f59:	eb d1                	jmp    800f2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f65:	89 d0                	mov    %edx,%eax
  800f67:	c1 e0 02             	shl    $0x2,%eax
  800f6a:	01 d0                	add    %edx,%eax
  800f6c:	01 c0                	add    %eax,%eax
  800f6e:	01 d8                	add    %ebx,%eax
  800f70:	83 e8 30             	sub    $0x30,%eax
  800f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f76:	8b 45 10             	mov    0x10(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800f81:	7e 3e                	jle    800fc1 <vprintfmt+0xe9>
  800f83:	83 fb 39             	cmp    $0x39,%ebx
  800f86:	7f 39                	jg     800fc1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f8b:	eb d5                	jmp    800f62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f90:	83 c0 04             	add    $0x4,%eax
  800f93:	89 45 14             	mov    %eax,0x14(%ebp)
  800f96:	8b 45 14             	mov    0x14(%ebp),%eax
  800f99:	83 e8 04             	sub    $0x4,%eax
  800f9c:	8b 00                	mov    (%eax),%eax
  800f9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fa1:	eb 1f                	jmp    800fc2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa7:	79 83                	jns    800f2c <vprintfmt+0x54>
				width = 0;
  800fa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fb0:	e9 77 ff ff ff       	jmp    800f2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fb5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fbc:	e9 6b ff ff ff       	jmp    800f2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fc1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fc2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc6:	0f 89 60 ff ff ff    	jns    800f2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800fcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fd2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fd9:	e9 4e ff ff ff       	jmp    800f2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fde:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fe1:	e9 46 ff ff ff       	jmp    800f2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fe6:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe9:	83 c0 04             	add    $0x4,%eax
  800fec:	89 45 14             	mov    %eax,0x14(%ebp)
  800fef:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff2:	83 e8 04             	sub    $0x4,%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			break;
  801006:	e9 9b 02 00 00       	jmp    8012a6 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80100b:	8b 45 14             	mov    0x14(%ebp),%eax
  80100e:	83 c0 04             	add    $0x4,%eax
  801011:	89 45 14             	mov    %eax,0x14(%ebp)
  801014:	8b 45 14             	mov    0x14(%ebp),%eax
  801017:	83 e8 04             	sub    $0x4,%eax
  80101a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80101c:	85 db                	test   %ebx,%ebx
  80101e:	79 02                	jns    801022 <vprintfmt+0x14a>
				err = -err;
  801020:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801022:	83 fb 64             	cmp    $0x64,%ebx
  801025:	7f 0b                	jg     801032 <vprintfmt+0x15a>
  801027:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  80102e:	85 f6                	test   %esi,%esi
  801030:	75 19                	jne    80104b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801032:	53                   	push   %ebx
  801033:	68 25 39 80 00       	push   $0x803925
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	ff 75 08             	pushl  0x8(%ebp)
  80103e:	e8 70 02 00 00       	call   8012b3 <printfmt>
  801043:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801046:	e9 5b 02 00 00       	jmp    8012a6 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80104b:	56                   	push   %esi
  80104c:	68 2e 39 80 00       	push   $0x80392e
  801051:	ff 75 0c             	pushl  0xc(%ebp)
  801054:	ff 75 08             	pushl  0x8(%ebp)
  801057:	e8 57 02 00 00       	call   8012b3 <printfmt>
  80105c:	83 c4 10             	add    $0x10,%esp
			break;
  80105f:	e9 42 02 00 00       	jmp    8012a6 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801064:	8b 45 14             	mov    0x14(%ebp),%eax
  801067:	83 c0 04             	add    $0x4,%eax
  80106a:	89 45 14             	mov    %eax,0x14(%ebp)
  80106d:	8b 45 14             	mov    0x14(%ebp),%eax
  801070:	83 e8 04             	sub    $0x4,%eax
  801073:	8b 30                	mov    (%eax),%esi
  801075:	85 f6                	test   %esi,%esi
  801077:	75 05                	jne    80107e <vprintfmt+0x1a6>
				p = "(null)";
  801079:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  80107e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801082:	7e 6d                	jle    8010f1 <vprintfmt+0x219>
  801084:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801088:	74 67                	je     8010f1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80108a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	50                   	push   %eax
  801091:	56                   	push   %esi
  801092:	e8 26 05 00 00       	call   8015bd <strnlen>
  801097:	83 c4 10             	add    $0x10,%esp
  80109a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80109d:	eb 16                	jmp    8010b5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80109f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010a3:	83 ec 08             	sub    $0x8,%esp
  8010a6:	ff 75 0c             	pushl  0xc(%ebp)
  8010a9:	50                   	push   %eax
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	ff d0                	call   *%eax
  8010af:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010b2:	ff 4d e4             	decl   -0x1c(%ebp)
  8010b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b9:	7f e4                	jg     80109f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010bb:	eb 34                	jmp    8010f1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010c1:	74 1c                	je     8010df <vprintfmt+0x207>
  8010c3:	83 fb 1f             	cmp    $0x1f,%ebx
  8010c6:	7e 05                	jle    8010cd <vprintfmt+0x1f5>
  8010c8:	83 fb 7e             	cmp    $0x7e,%ebx
  8010cb:	7e 12                	jle    8010df <vprintfmt+0x207>
					putch('?', putdat);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	6a 3f                	push   $0x3f
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	eb 0f                	jmp    8010ee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010df:	83 ec 08             	sub    $0x8,%esp
  8010e2:	ff 75 0c             	pushl  0xc(%ebp)
  8010e5:	53                   	push   %ebx
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	ff d0                	call   *%eax
  8010eb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ee:	ff 4d e4             	decl   -0x1c(%ebp)
  8010f1:	89 f0                	mov    %esi,%eax
  8010f3:	8d 70 01             	lea    0x1(%eax),%esi
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	0f be d8             	movsbl %al,%ebx
  8010fb:	85 db                	test   %ebx,%ebx
  8010fd:	74 24                	je     801123 <vprintfmt+0x24b>
  8010ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801103:	78 b8                	js     8010bd <vprintfmt+0x1e5>
  801105:	ff 4d e0             	decl   -0x20(%ebp)
  801108:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80110c:	79 af                	jns    8010bd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80110e:	eb 13                	jmp    801123 <vprintfmt+0x24b>
				putch(' ', putdat);
  801110:	83 ec 08             	sub    $0x8,%esp
  801113:	ff 75 0c             	pushl  0xc(%ebp)
  801116:	6a 20                	push   $0x20
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	ff d0                	call   *%eax
  80111d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801120:	ff 4d e4             	decl   -0x1c(%ebp)
  801123:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801127:	7f e7                	jg     801110 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801129:	e9 78 01 00 00       	jmp    8012a6 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	ff 75 e8             	pushl  -0x18(%ebp)
  801134:	8d 45 14             	lea    0x14(%ebp),%eax
  801137:	50                   	push   %eax
  801138:	e8 3c fd ff ff       	call   800e79 <getint>
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801143:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	85 d2                	test   %edx,%edx
  80114e:	79 23                	jns    801173 <vprintfmt+0x29b>
				putch('-', putdat);
  801150:	83 ec 08             	sub    $0x8,%esp
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	6a 2d                	push   $0x2d
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	ff d0                	call   *%eax
  80115d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801163:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801166:	f7 d8                	neg    %eax
  801168:	83 d2 00             	adc    $0x0,%edx
  80116b:	f7 da                	neg    %edx
  80116d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801170:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801173:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117a:	e9 bc 00 00 00       	jmp    80123b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80117f:	83 ec 08             	sub    $0x8,%esp
  801182:	ff 75 e8             	pushl  -0x18(%ebp)
  801185:	8d 45 14             	lea    0x14(%ebp),%eax
  801188:	50                   	push   %eax
  801189:	e8 84 fc ff ff       	call   800e12 <getuint>
  80118e:	83 c4 10             	add    $0x10,%esp
  801191:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801194:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801197:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80119e:	e9 98 00 00 00       	jmp    80123b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011a3:	83 ec 08             	sub    $0x8,%esp
  8011a6:	ff 75 0c             	pushl  0xc(%ebp)
  8011a9:	6a 58                	push   $0x58
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	ff d0                	call   *%eax
  8011b0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	6a 58                	push   $0x58
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	ff d0                	call   *%eax
  8011c0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011c3:	83 ec 08             	sub    $0x8,%esp
  8011c6:	ff 75 0c             	pushl  0xc(%ebp)
  8011c9:	6a 58                	push   $0x58
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
			break;
  8011d3:	e9 ce 00 00 00       	jmp    8012a6 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	ff 75 0c             	pushl  0xc(%ebp)
  8011de:	6a 30                	push   $0x30
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	ff d0                	call   *%eax
  8011e5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ee:	6a 78                	push   $0x78
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	ff d0                	call   *%eax
  8011f5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	83 c0 04             	add    $0x4,%eax
  8011fe:	89 45 14             	mov    %eax,0x14(%ebp)
  801201:	8b 45 14             	mov    0x14(%ebp),%eax
  801204:	83 e8 04             	sub    $0x4,%eax
  801207:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801209:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801213:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80121a:	eb 1f                	jmp    80123b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80121c:	83 ec 08             	sub    $0x8,%esp
  80121f:	ff 75 e8             	pushl  -0x18(%ebp)
  801222:	8d 45 14             	lea    0x14(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	e8 e7 fb ff ff       	call   800e12 <getuint>
  80122b:	83 c4 10             	add    $0x10,%esp
  80122e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801231:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801234:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80123b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80123f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801242:	83 ec 04             	sub    $0x4,%esp
  801245:	52                   	push   %edx
  801246:	ff 75 e4             	pushl  -0x1c(%ebp)
  801249:	50                   	push   %eax
  80124a:	ff 75 f4             	pushl  -0xc(%ebp)
  80124d:	ff 75 f0             	pushl  -0x10(%ebp)
  801250:	ff 75 0c             	pushl  0xc(%ebp)
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 00 fb ff ff       	call   800d5b <printnum>
  80125b:	83 c4 20             	add    $0x20,%esp
			break;
  80125e:	eb 46                	jmp    8012a6 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801260:	83 ec 08             	sub    $0x8,%esp
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	53                   	push   %ebx
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	ff d0                	call   *%eax
  80126c:	83 c4 10             	add    $0x10,%esp
			break;
  80126f:	eb 35                	jmp    8012a6 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801271:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  801278:	eb 2c                	jmp    8012a6 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80127a:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  801281:	eb 23                	jmp    8012a6 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801283:	83 ec 08             	sub    $0x8,%esp
  801286:	ff 75 0c             	pushl  0xc(%ebp)
  801289:	6a 25                	push   $0x25
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	ff d0                	call   *%eax
  801290:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801293:	ff 4d 10             	decl   0x10(%ebp)
  801296:	eb 03                	jmp    80129b <vprintfmt+0x3c3>
  801298:	ff 4d 10             	decl   0x10(%ebp)
  80129b:	8b 45 10             	mov    0x10(%ebp),%eax
  80129e:	48                   	dec    %eax
  80129f:	8a 00                	mov    (%eax),%al
  8012a1:	3c 25                	cmp    $0x25,%al
  8012a3:	75 f3                	jne    801298 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8012a5:	90                   	nop
		}
	}
  8012a6:	e9 35 fc ff ff       	jmp    800ee0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012ab:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8012bc:	83 c0 04             	add    $0x4,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c8:	50                   	push   %eax
  8012c9:	ff 75 0c             	pushl  0xc(%ebp)
  8012cc:	ff 75 08             	pushl  0x8(%ebp)
  8012cf:	e8 04 fc ff ff       	call   800ed8 <vprintfmt>
  8012d4:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012d7:	90                   	nop
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	8b 40 08             	mov    0x8(%eax),%eax
  8012e3:	8d 50 01             	lea    0x1(%eax),%edx
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ef:	8b 10                	mov    (%eax),%edx
  8012f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f4:	8b 40 04             	mov    0x4(%eax),%eax
  8012f7:	39 c2                	cmp    %eax,%edx
  8012f9:	73 12                	jae    80130d <sprintputch+0x33>
		*b->buf++ = ch;
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	8b 00                	mov    (%eax),%eax
  801300:	8d 48 01             	lea    0x1(%eax),%ecx
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	89 0a                	mov    %ecx,(%edx)
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	88 10                	mov    %dl,(%eax)
}
  80130d:	90                   	nop
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	01 d0                	add    %edx,%eax
  801327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80132a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801335:	74 06                	je     80133d <vsnprintf+0x2d>
  801337:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80133b:	7f 07                	jg     801344 <vsnprintf+0x34>
		return -E_INVAL;
  80133d:	b8 03 00 00 00       	mov    $0x3,%eax
  801342:	eb 20                	jmp    801364 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801344:	ff 75 14             	pushl  0x14(%ebp)
  801347:	ff 75 10             	pushl  0x10(%ebp)
  80134a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80134d:	50                   	push   %eax
  80134e:	68 da 12 80 00       	push   $0x8012da
  801353:	e8 80 fb ff ff       	call   800ed8 <vprintfmt>
  801358:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80135b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80136c:	8d 45 10             	lea    0x10(%ebp),%eax
  80136f:	83 c0 04             	add    $0x4,%eax
  801372:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801375:	8b 45 10             	mov    0x10(%ebp),%eax
  801378:	ff 75 f4             	pushl  -0xc(%ebp)
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 89 ff ff ff       	call   801310 <vsnprintf>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80139c:	74 13                	je     8013b1 <readline+0x1f>
		cprintf("%s", prompt);
  80139e:	83 ec 08             	sub    $0x8,%esp
  8013a1:	ff 75 08             	pushl  0x8(%ebp)
  8013a4:	68 a8 3a 80 00       	push   $0x803aa8
  8013a9:	e8 0b f9 ff ff       	call   800cb9 <cprintf>
  8013ae:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	6a 00                	push   $0x0
  8013bd:	e8 48 f6 ff ff       	call   800a0a <iscons>
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8013c8:	e8 2a f6 ff ff       	call   8009f7 <getchar>
  8013cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8013d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013d4:	79 22                	jns    8013f8 <readline+0x66>
			if (c != -E_EOF)
  8013d6:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8013da:	0f 84 ad 00 00 00    	je     80148d <readline+0xfb>
				cprintf("read error: %e\n", c);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8013e6:	68 ab 3a 80 00       	push   $0x803aab
  8013eb:	e8 c9 f8 ff ff       	call   800cb9 <cprintf>
  8013f0:	83 c4 10             	add    $0x10,%esp
			break;
  8013f3:	e9 95 00 00 00       	jmp    80148d <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013f8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013fc:	7e 34                	jle    801432 <readline+0xa0>
  8013fe:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801405:	7f 2b                	jg     801432 <readline+0xa0>
			if (echoing)
  801407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80140b:	74 0e                	je     80141b <readline+0x89>
				cputchar(c);
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	ff 75 ec             	pushl  -0x14(%ebp)
  801413:	e8 c0 f5 ff ff       	call   8009d8 <cputchar>
  801418:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80141b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80141e:	8d 50 01             	lea    0x1(%eax),%edx
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801424:	89 c2                	mov    %eax,%edx
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	01 d0                	add    %edx,%eax
  80142b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142e:	88 10                	mov    %dl,(%eax)
  801430:	eb 56                	jmp    801488 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801432:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801436:	75 1f                	jne    801457 <readline+0xc5>
  801438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80143c:	7e 19                	jle    801457 <readline+0xc5>
			if (echoing)
  80143e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801442:	74 0e                	je     801452 <readline+0xc0>
				cputchar(c);
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	ff 75 ec             	pushl  -0x14(%ebp)
  80144a:	e8 89 f5 ff ff       	call   8009d8 <cputchar>
  80144f:	83 c4 10             	add    $0x10,%esp

			i--;
  801452:	ff 4d f4             	decl   -0xc(%ebp)
  801455:	eb 31                	jmp    801488 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801457:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80145b:	74 0a                	je     801467 <readline+0xd5>
  80145d:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801461:	0f 85 61 ff ff ff    	jne    8013c8 <readline+0x36>
			if (echoing)
  801467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80146b:	74 0e                	je     80147b <readline+0xe9>
				cputchar(c);
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	ff 75 ec             	pushl  -0x14(%ebp)
  801473:	e8 60 f5 ff ff       	call   8009d8 <cputchar>
  801478:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80147b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801486:	eb 06                	jmp    80148e <readline+0xfc>
		}
	}
  801488:	e9 3b ff ff ff       	jmp    8013c8 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  80148d:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  80148e:	90                   	nop
  80148f:	c9                   	leave  
  801490:	c3                   	ret    

00801491 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801497:	e8 30 0b 00 00       	call   801fcc <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  80149c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a0:	74 13                	je     8014b5 <atomic_readline+0x24>
			cprintf("%s", prompt);
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	ff 75 08             	pushl  0x8(%ebp)
  8014a8:	68 a8 3a 80 00       	push   $0x803aa8
  8014ad:	e8 07 f8 ff ff       	call   800cb9 <cprintf>
  8014b2:	83 c4 10             	add    $0x10,%esp

		i = 0;
  8014b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a 00                	push   $0x0
  8014c1:	e8 44 f5 ff ff       	call   800a0a <iscons>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  8014cc:	e8 26 f5 ff ff       	call   8009f7 <getchar>
  8014d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  8014d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014d8:	79 22                	jns    8014fc <atomic_readline+0x6b>
				if (c != -E_EOF)
  8014da:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8014de:	0f 84 ad 00 00 00    	je     801591 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  8014e4:	83 ec 08             	sub    $0x8,%esp
  8014e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ea:	68 ab 3a 80 00       	push   $0x803aab
  8014ef:	e8 c5 f7 ff ff       	call   800cb9 <cprintf>
  8014f4:	83 c4 10             	add    $0x10,%esp
				break;
  8014f7:	e9 95 00 00 00       	jmp    801591 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  8014fc:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801500:	7e 34                	jle    801536 <atomic_readline+0xa5>
  801502:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801509:	7f 2b                	jg     801536 <atomic_readline+0xa5>
				if (echoing)
  80150b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80150f:	74 0e                	je     80151f <atomic_readline+0x8e>
					cputchar(c);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	ff 75 ec             	pushl  -0x14(%ebp)
  801517:	e8 bc f4 ff ff       	call   8009d8 <cputchar>
  80151c:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  80151f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801522:	8d 50 01             	lea    0x1(%eax),%edx
  801525:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801528:	89 c2                	mov    %eax,%edx
  80152a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152d:	01 d0                	add    %edx,%eax
  80152f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801532:	88 10                	mov    %dl,(%eax)
  801534:	eb 56                	jmp    80158c <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801536:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80153a:	75 1f                	jne    80155b <atomic_readline+0xca>
  80153c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801540:	7e 19                	jle    80155b <atomic_readline+0xca>
				if (echoing)
  801542:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801546:	74 0e                	je     801556 <atomic_readline+0xc5>
					cputchar(c);
  801548:	83 ec 0c             	sub    $0xc,%esp
  80154b:	ff 75 ec             	pushl  -0x14(%ebp)
  80154e:	e8 85 f4 ff ff       	call   8009d8 <cputchar>
  801553:	83 c4 10             	add    $0x10,%esp
				i--;
  801556:	ff 4d f4             	decl   -0xc(%ebp)
  801559:	eb 31                	jmp    80158c <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  80155b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80155f:	74 0a                	je     80156b <atomic_readline+0xda>
  801561:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801565:	0f 85 61 ff ff ff    	jne    8014cc <atomic_readline+0x3b>
				if (echoing)
  80156b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80156f:	74 0e                	je     80157f <atomic_readline+0xee>
					cputchar(c);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	ff 75 ec             	pushl  -0x14(%ebp)
  801577:	e8 5c f4 ff ff       	call   8009d8 <cputchar>
  80157c:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  80157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801582:	8b 45 0c             	mov    0xc(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	c6 00 00             	movb   $0x0,(%eax)
				break;
  80158a:	eb 06                	jmp    801592 <atomic_readline+0x101>
			}
		}
  80158c:	e9 3b ff ff ff       	jmp    8014cc <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801591:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801592:	e8 4f 0a 00 00       	call   801fe6 <sys_unlock_cons>
}
  801597:	90                   	nop
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015a7:	eb 06                	jmp    8015af <strlen+0x15>
		n++;
  8015a9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015ac:	ff 45 08             	incl   0x8(%ebp)
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	8a 00                	mov    (%eax),%al
  8015b4:	84 c0                	test   %al,%al
  8015b6:	75 f1                	jne    8015a9 <strlen+0xf>
		n++;
	return n;
  8015b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 09                	jmp    8015d5 <strnlen+0x18>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	ff 4d 0c             	decl   0xc(%ebp)
  8015d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d9:	74 09                	je     8015e4 <strnlen+0x27>
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	84 c0                	test   %al,%al
  8015e2:	75 e8                	jne    8015cc <strnlen+0xf>
		n++;
	return n;
  8015e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015f5:	90                   	nop
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	8d 50 01             	lea    0x1(%eax),%edx
  8015fc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801602:	8d 4a 01             	lea    0x1(%edx),%ecx
  801605:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801608:	8a 12                	mov    (%edx),%dl
  80160a:	88 10                	mov    %dl,(%eax)
  80160c:	8a 00                	mov    (%eax),%al
  80160e:	84 c0                	test   %al,%al
  801610:	75 e4                	jne    8015f6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801612:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801623:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80162a:	eb 1f                	jmp    80164b <strncpy+0x34>
		*dst++ = *src;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8d 50 01             	lea    0x1(%eax),%edx
  801632:	89 55 08             	mov    %edx,0x8(%ebp)
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8a 12                	mov    (%edx),%dl
  80163a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	8a 00                	mov    (%eax),%al
  801641:	84 c0                	test   %al,%al
  801643:	74 03                	je     801648 <strncpy+0x31>
			src++;
  801645:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801648:	ff 45 fc             	incl   -0x4(%ebp)
  80164b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801651:	72 d9                	jb     80162c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801653:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801664:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801668:	74 30                	je     80169a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80166a:	eb 16                	jmp    801682 <strlcpy+0x2a>
			*dst++ = *src++;
  80166c:	8b 45 08             	mov    0x8(%ebp),%eax
  80166f:	8d 50 01             	lea    0x1(%eax),%edx
  801672:	89 55 08             	mov    %edx,0x8(%ebp)
  801675:	8b 55 0c             	mov    0xc(%ebp),%edx
  801678:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801682:	ff 4d 10             	decl   0x10(%ebp)
  801685:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801689:	74 09                	je     801694 <strlcpy+0x3c>
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	75 d8                	jne    80166c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80169a:	8b 55 08             	mov    0x8(%ebp),%edx
  80169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a0:	29 c2                	sub    %eax,%edx
  8016a2:	89 d0                	mov    %edx,%eax
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016a9:	eb 06                	jmp    8016b1 <strcmp+0xb>
		p++, q++;
  8016ab:	ff 45 08             	incl   0x8(%ebp)
  8016ae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	84 c0                	test   %al,%al
  8016b8:	74 0e                	je     8016c8 <strcmp+0x22>
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8a 10                	mov    (%eax),%dl
  8016bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	38 c2                	cmp    %al,%dl
  8016c6:	74 e3                	je     8016ab <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	0f b6 d0             	movzbl %al,%edx
  8016d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d3:	8a 00                	mov    (%eax),%al
  8016d5:	0f b6 c0             	movzbl %al,%eax
  8016d8:	29 c2                	sub    %eax,%edx
  8016da:	89 d0                	mov    %edx,%eax
}
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016e1:	eb 09                	jmp    8016ec <strncmp+0xe>
		n--, p++, q++;
  8016e3:	ff 4d 10             	decl   0x10(%ebp)
  8016e6:	ff 45 08             	incl   0x8(%ebp)
  8016e9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f0:	74 17                	je     801709 <strncmp+0x2b>
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	8a 00                	mov    (%eax),%al
  8016f7:	84 c0                	test   %al,%al
  8016f9:	74 0e                	je     801709 <strncmp+0x2b>
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 10                	mov    (%eax),%dl
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	38 c2                	cmp    %al,%dl
  801707:	74 da                	je     8016e3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	75 07                	jne    801716 <strncmp+0x38>
		return 0;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
  801714:	eb 14                	jmp    80172a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 d0             	movzbl %al,%edx
  80171e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801721:	8a 00                	mov    (%eax),%al
  801723:	0f b6 c0             	movzbl %al,%eax
  801726:	29 c2                	sub    %eax,%edx
  801728:	89 d0                	mov    %edx,%eax
}
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	8b 45 0c             	mov    0xc(%ebp),%eax
  801735:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801738:	eb 12                	jmp    80174c <strchr+0x20>
		if (*s == c)
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8a 00                	mov    (%eax),%al
  80173f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801742:	75 05                	jne    801749 <strchr+0x1d>
			return (char *) s;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	eb 11                	jmp    80175a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801749:	ff 45 08             	incl   0x8(%ebp)
  80174c:	8b 45 08             	mov    0x8(%ebp),%eax
  80174f:	8a 00                	mov    (%eax),%al
  801751:	84 c0                	test   %al,%al
  801753:	75 e5                	jne    80173a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	8b 45 0c             	mov    0xc(%ebp),%eax
  801765:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801768:	eb 0d                	jmp    801777 <strfind+0x1b>
		if (*s == c)
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801772:	74 0e                	je     801782 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801774:	ff 45 08             	incl   0x8(%ebp)
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	8a 00                	mov    (%eax),%al
  80177c:	84 c0                	test   %al,%al
  80177e:	75 ea                	jne    80176a <strfind+0xe>
  801780:	eb 01                	jmp    801783 <strfind+0x27>
		if (*s == c)
			break;
  801782:	90                   	nop
	return (char *) s;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801794:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801798:	76 63                	jbe    8017fd <memset+0x75>
		uint64 data_block = c;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	99                   	cltd   
  80179e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017aa:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  8017ae:	c1 e0 08             	shl    $0x8,%eax
  8017b1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017b4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bd:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  8017c1:	c1 e0 10             	shl    $0x10,%eax
  8017c4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017c7:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d0:	89 c2                	mov    %eax,%edx
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d7:	09 45 f0             	or     %eax,-0x10(%ebp)
  8017da:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8017dd:	eb 18                	jmp    8017f7 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8017df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8017e2:	8d 41 08             	lea    0x8(%ecx),%eax
  8017e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ee:	89 01                	mov    %eax,(%ecx)
  8017f0:	89 51 04             	mov    %edx,0x4(%ecx)
  8017f3:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8017f7:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8017fb:	77 e2                	ja     8017df <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8017fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801801:	74 23                	je     801826 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801806:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801809:	eb 0e                	jmp    801819 <memset+0x91>
			*p8++ = (uint8)c;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	8d 50 01             	lea    0x1(%eax),%edx
  801811:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e5                	jne    80180b <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80183d:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801841:	76 24                	jbe    801867 <memcpy+0x3c>
		while(n >= 8){
  801843:	eb 1c                	jmp    801861 <memcpy+0x36>
			*d64 = *s64;
  801845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801848:	8b 50 04             	mov    0x4(%eax),%edx
  80184b:	8b 00                	mov    (%eax),%eax
  80184d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801850:	89 01                	mov    %eax,(%ecx)
  801852:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801855:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801859:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80185d:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801861:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801865:	77 de                	ja     801845 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801867:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80186b:	74 31                	je     80189e <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801870:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801879:	eb 16                	jmp    801891 <memcpy+0x66>
			*d8++ = *s8++;
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	8d 50 01             	lea    0x1(%eax),%edx
  801881:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801887:	8d 4a 01             	lea    0x1(%edx),%ecx
  80188a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80188d:	8a 12                	mov    (%edx),%dl
  80188f:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  801891:	8b 45 10             	mov    0x10(%ebp),%eax
  801894:	8d 50 ff             	lea    -0x1(%eax),%edx
  801897:	89 55 10             	mov    %edx,0x10(%ebp)
  80189a:	85 c0                	test   %eax,%eax
  80189c:	75 dd                	jne    80187b <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018bb:	73 50                	jae    80190d <memmove+0x6a>
  8018bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c3:	01 d0                	add    %edx,%eax
  8018c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018c8:	76 43                	jbe    80190d <memmove+0x6a>
		s += n;
  8018ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018d6:	eb 10                	jmp    8018e8 <memmove+0x45>
			*--d = *--s;
  8018d8:	ff 4d f8             	decl   -0x8(%ebp)
  8018db:	ff 4d fc             	decl   -0x4(%ebp)
  8018de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e1:	8a 10                	mov    (%eax),%dl
  8018e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	75 e3                	jne    8018d8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8018f5:	eb 23                	jmp    80191a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8018f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fa:	8d 50 01             	lea    0x1(%eax),%edx
  8018fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801900:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801903:	8d 4a 01             	lea    0x1(%edx),%ecx
  801906:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801909:	8a 12                	mov    (%edx),%dl
  80190b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80190d:	8b 45 10             	mov    0x10(%ebp),%eax
  801910:	8d 50 ff             	lea    -0x1(%eax),%edx
  801913:	89 55 10             	mov    %edx,0x10(%ebp)
  801916:	85 c0                	test   %eax,%eax
  801918:	75 dd                	jne    8018f7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80192b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801931:	eb 2a                	jmp    80195d <memcmp+0x3e>
		if (*s1 != *s2)
  801933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801936:	8a 10                	mov    (%eax),%dl
  801938:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193b:	8a 00                	mov    (%eax),%al
  80193d:	38 c2                	cmp    %al,%dl
  80193f:	74 16                	je     801957 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801944:	8a 00                	mov    (%eax),%al
  801946:	0f b6 d0             	movzbl %al,%edx
  801949:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80194c:	8a 00                	mov    (%eax),%al
  80194e:	0f b6 c0             	movzbl %al,%eax
  801951:	29 c2                	sub    %eax,%edx
  801953:	89 d0                	mov    %edx,%eax
  801955:	eb 18                	jmp    80196f <memcmp+0x50>
		s1++, s2++;
  801957:	ff 45 fc             	incl   -0x4(%ebp)
  80195a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80195d:	8b 45 10             	mov    0x10(%ebp),%eax
  801960:	8d 50 ff             	lea    -0x1(%eax),%edx
  801963:	89 55 10             	mov    %edx,0x10(%ebp)
  801966:	85 c0                	test   %eax,%eax
  801968:	75 c9                	jne    801933 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80196a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801977:	8b 55 08             	mov    0x8(%ebp),%edx
  80197a:	8b 45 10             	mov    0x10(%ebp),%eax
  80197d:	01 d0                	add    %edx,%eax
  80197f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801982:	eb 15                	jmp    801999 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	8a 00                	mov    (%eax),%al
  801989:	0f b6 d0             	movzbl %al,%edx
  80198c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198f:	0f b6 c0             	movzbl %al,%eax
  801992:	39 c2                	cmp    %eax,%edx
  801994:	74 0d                	je     8019a3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801996:	ff 45 08             	incl   0x8(%ebp)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80199f:	72 e3                	jb     801984 <memfind+0x13>
  8019a1:	eb 01                	jmp    8019a4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019a3:	90                   	nop
	return (void *) s;
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019b6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019bd:	eb 03                	jmp    8019c2 <strtol+0x19>
		s++;
  8019bf:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	3c 20                	cmp    $0x20,%al
  8019c9:	74 f4                	je     8019bf <strtol+0x16>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	3c 09                	cmp    $0x9,%al
  8019d2:	74 eb                	je     8019bf <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	3c 2b                	cmp    $0x2b,%al
  8019db:	75 05                	jne    8019e2 <strtol+0x39>
		s++;
  8019dd:	ff 45 08             	incl   0x8(%ebp)
  8019e0:	eb 13                	jmp    8019f5 <strtol+0x4c>
	else if (*s == '-')
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	3c 2d                	cmp    $0x2d,%al
  8019e9:	75 0a                	jne    8019f5 <strtol+0x4c>
		s++, neg = 1;
  8019eb:	ff 45 08             	incl   0x8(%ebp)
  8019ee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f9:	74 06                	je     801a01 <strtol+0x58>
  8019fb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8019ff:	75 20                	jne    801a21 <strtol+0x78>
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 30                	cmp    $0x30,%al
  801a08:	75 17                	jne    801a21 <strtol+0x78>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	40                   	inc    %eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 78                	cmp    $0x78,%al
  801a12:	75 0d                	jne    801a21 <strtol+0x78>
		s += 2, base = 16;
  801a14:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a18:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a1f:	eb 28                	jmp    801a49 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a25:	75 15                	jne    801a3c <strtol+0x93>
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	3c 30                	cmp    $0x30,%al
  801a2e:	75 0c                	jne    801a3c <strtol+0x93>
		s++, base = 8;
  801a30:	ff 45 08             	incl   0x8(%ebp)
  801a33:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a3a:	eb 0d                	jmp    801a49 <strtol+0xa0>
	else if (base == 0)
  801a3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a40:	75 07                	jne    801a49 <strtol+0xa0>
		base = 10;
  801a42:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8a 00                	mov    (%eax),%al
  801a4e:	3c 2f                	cmp    $0x2f,%al
  801a50:	7e 19                	jle    801a6b <strtol+0xc2>
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	8a 00                	mov    (%eax),%al
  801a57:	3c 39                	cmp    $0x39,%al
  801a59:	7f 10                	jg     801a6b <strtol+0xc2>
			dig = *s - '0';
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	8a 00                	mov    (%eax),%al
  801a60:	0f be c0             	movsbl %al,%eax
  801a63:	83 e8 30             	sub    $0x30,%eax
  801a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a69:	eb 42                	jmp    801aad <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	8a 00                	mov    (%eax),%al
  801a70:	3c 60                	cmp    $0x60,%al
  801a72:	7e 19                	jle    801a8d <strtol+0xe4>
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8a 00                	mov    (%eax),%al
  801a79:	3c 7a                	cmp    $0x7a,%al
  801a7b:	7f 10                	jg     801a8d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8a 00                	mov    (%eax),%al
  801a82:	0f be c0             	movsbl %al,%eax
  801a85:	83 e8 57             	sub    $0x57,%eax
  801a88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a8b:	eb 20                	jmp    801aad <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8a 00                	mov    (%eax),%al
  801a92:	3c 40                	cmp    $0x40,%al
  801a94:	7e 39                	jle    801acf <strtol+0x126>
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8a 00                	mov    (%eax),%al
  801a9b:	3c 5a                	cmp    $0x5a,%al
  801a9d:	7f 30                	jg     801acf <strtol+0x126>
			dig = *s - 'A' + 10;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8a 00                	mov    (%eax),%al
  801aa4:	0f be c0             	movsbl %al,%eax
  801aa7:	83 e8 37             	sub    $0x37,%eax
  801aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab0:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ab3:	7d 19                	jge    801ace <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801ab5:	ff 45 08             	incl   0x8(%ebp)
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	0f af 45 10          	imul   0x10(%ebp),%eax
  801abf:	89 c2                	mov    %eax,%edx
  801ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac4:	01 d0                	add    %edx,%eax
  801ac6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ac9:	e9 7b ff ff ff       	jmp    801a49 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ace:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad3:	74 08                	je     801add <strtol+0x134>
		*endptr = (char *) s;
  801ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  801adb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801add:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ae1:	74 07                	je     801aea <strtol+0x141>
  801ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae6:	f7 d8                	neg    %eax
  801ae8:	eb 03                	jmp    801aed <strtol+0x144>
  801aea:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <ltostr>:

void
ltostr(long value, char *str)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801af5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801afc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b07:	79 13                	jns    801b1c <ltostr+0x2d>
	{
		neg = 1;
  801b09:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b16:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b19:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b24:	99                   	cltd   
  801b25:	f7 f9                	idiv   %ecx
  801b27:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b2d:	8d 50 01             	lea    0x1(%eax),%edx
  801b30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b33:	89 c2                	mov    %eax,%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 d0                	add    %edx,%eax
  801b3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b3d:	83 c2 30             	add    $0x30,%edx
  801b40:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b45:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b4a:	f7 e9                	imul   %ecx
  801b4c:	c1 fa 02             	sar    $0x2,%edx
  801b4f:	89 c8                	mov    %ecx,%eax
  801b51:	c1 f8 1f             	sar    $0x1f,%eax
  801b54:	29 c2                	sub    %eax,%edx
  801b56:	89 d0                	mov    %edx,%eax
  801b58:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b5f:	75 bb                	jne    801b1c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b6b:	48                   	dec    %eax
  801b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b73:	74 3d                	je     801bb2 <ltostr+0xc3>
		start = 1 ;
  801b75:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b7c:	eb 34                	jmp    801bb2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b84:	01 d0                	add    %edx,%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b91:	01 c2                	add    %eax,%edx
  801b93:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	01 c8                	add    %ecx,%eax
  801b9b:	8a 00                	mov    (%eax),%al
  801b9d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba5:	01 c2                	add    %eax,%edx
  801ba7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801baa:	88 02                	mov    %al,(%edx)
		start++ ;
  801bac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801baf:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bb8:	7c c4                	jl     801b7e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc0:	01 d0                	add    %edx,%eax
  801bc2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bc5:	90                   	nop
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	e8 c4 f9 ff ff       	call   80159a <strlen>
  801bd6:	83 c4 04             	add    $0x4,%esp
  801bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	e8 b6 f9 ff ff       	call   80159a <strlen>
  801be4:	83 c4 04             	add    $0x4,%esp
  801be7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801bea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bf8:	eb 17                	jmp    801c11 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801c00:	01 c2                	add    %eax,%edx
  801c02:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	01 c8                	add    %ecx,%eax
  801c0a:	8a 00                	mov    (%eax),%al
  801c0c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c0e:	ff 45 fc             	incl   -0x4(%ebp)
  801c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c17:	7c e1                	jl     801bfa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c20:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c27:	eb 1f                	jmp    801c48 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c2c:	8d 50 01             	lea    0x1(%eax),%edx
  801c2f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c32:	89 c2                	mov    %eax,%edx
  801c34:	8b 45 10             	mov    0x10(%ebp),%eax
  801c37:	01 c2                	add    %eax,%edx
  801c39:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3f:	01 c8                	add    %ecx,%eax
  801c41:	8a 00                	mov    (%eax),%al
  801c43:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c45:	ff 45 f8             	incl   -0x8(%ebp)
  801c48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c4e:	7c d9                	jl     801c29 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c53:	8b 45 10             	mov    0x10(%ebp),%eax
  801c56:	01 d0                	add    %edx,%eax
  801c58:	c6 00 00             	movb   $0x0,(%eax)
}
  801c5b:	90                   	nop
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c61:	8b 45 14             	mov    0x14(%ebp),%eax
  801c64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6d:	8b 00                	mov    (%eax),%eax
  801c6f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c76:	8b 45 10             	mov    0x10(%ebp),%eax
  801c79:	01 d0                	add    %edx,%eax
  801c7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c81:	eb 0c                	jmp    801c8f <strsplit+0x31>
			*string++ = 0;
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8d 50 01             	lea    0x1(%eax),%edx
  801c89:	89 55 08             	mov    %edx,0x8(%ebp)
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	8a 00                	mov    (%eax),%al
  801c94:	84 c0                	test   %al,%al
  801c96:	74 18                	je     801cb0 <strsplit+0x52>
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	8a 00                	mov    (%eax),%al
  801c9d:	0f be c0             	movsbl %al,%eax
  801ca0:	50                   	push   %eax
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	e8 83 fa ff ff       	call   80172c <strchr>
  801ca9:	83 c4 08             	add    $0x8,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	75 d3                	jne    801c83 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	84 c0                	test   %al,%al
  801cb7:	74 5a                	je     801d13 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbc:	8b 00                	mov    (%eax),%eax
  801cbe:	83 f8 0f             	cmp    $0xf,%eax
  801cc1:	75 07                	jne    801cca <strsplit+0x6c>
		{
			return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb 66                	jmp    801d30 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd2:	8b 55 14             	mov    0x14(%ebp),%edx
  801cd5:	89 0a                	mov    %ecx,(%edx)
  801cd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cde:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce1:	01 c2                	add    %eax,%edx
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ce8:	eb 03                	jmp    801ced <strsplit+0x8f>
			string++;
  801cea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	8a 00                	mov    (%eax),%al
  801cf2:	84 c0                	test   %al,%al
  801cf4:	74 8b                	je     801c81 <strsplit+0x23>
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	8a 00                	mov    (%eax),%al
  801cfb:	0f be c0             	movsbl %al,%eax
  801cfe:	50                   	push   %eax
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	e8 25 fa ff ff       	call   80172c <strchr>
  801d07:	83 c4 08             	add    $0x8,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	74 dc                	je     801cea <strsplit+0x8c>
			string++;
	}
  801d0e:	e9 6e ff ff ff       	jmp    801c81 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d13:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d14:	8b 45 14             	mov    0x14(%ebp),%eax
  801d17:	8b 00                	mov    (%eax),%eax
  801d19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d20:	8b 45 10             	mov    0x10(%ebp),%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d2b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d45:	eb 4a                	jmp    801d91 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801d47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	01 c2                	add    %eax,%edx
  801d4f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d55:	01 c8                	add    %ecx,%eax
  801d57:	8a 00                	mov    (%eax),%al
  801d59:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801d5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	8a 00                	mov    (%eax),%al
  801d65:	3c 40                	cmp    $0x40,%al
  801d67:	7e 25                	jle    801d8e <str2lower+0x5c>
  801d69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6f:	01 d0                	add    %edx,%eax
  801d71:	8a 00                	mov    (%eax),%al
  801d73:	3c 5a                	cmp    $0x5a,%al
  801d75:	7f 17                	jg     801d8e <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801d77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d82:	8b 55 08             	mov    0x8(%ebp),%edx
  801d85:	01 ca                	add    %ecx,%edx
  801d87:	8a 12                	mov    (%edx),%dl
  801d89:	83 c2 20             	add    $0x20,%edx
  801d8c:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801d8e:	ff 45 fc             	incl   -0x4(%ebp)
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	e8 01 f8 ff ff       	call   80159a <strlen>
  801d99:	83 c4 04             	add    $0x4,%esp
  801d9c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d9f:	7f a6                	jg     801d47 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801da1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801dac:	a1 08 40 80 00       	mov    0x804008,%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	74 42                	je     801df7 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801db5:	83 ec 08             	sub    $0x8,%esp
  801db8:	68 00 00 00 82       	push   $0x82000000
  801dbd:	68 00 00 00 80       	push   $0x80000000
  801dc2:	e8 00 08 00 00       	call   8025c7 <initialize_dynamic_allocator>
  801dc7:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801dca:	e8 e7 05 00 00       	call   8023b6 <sys_get_uheap_strategy>
  801dcf:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801dd4:	a1 40 40 80 00       	mov    0x804040,%eax
  801dd9:	05 00 10 00 00       	add    $0x1000,%eax
  801dde:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  801de3:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801de8:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801ded:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  801df4:	00 00 00 
	}
}
  801df7:	90                   	nop
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	68 06 04 00 00       	push   $0x406
  801e16:	50                   	push   %eax
  801e17:	e8 e4 01 00 00       	call   802000 <__sys_allocate_page>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e26:	79 14                	jns    801e3c <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 bc 3a 80 00       	push   $0x803abc
  801e30:	6a 1f                	push   $0x1f
  801e32:	68 f8 3a 80 00       	push   $0x803af8
  801e37:	e8 72 11 00 00       	call   802fae <_panic>
	return 0;
  801e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	50                   	push   %eax
  801e5b:	e8 e7 01 00 00       	call   802047 <__sys_unmap_frame>
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801e66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e6a:	79 14                	jns    801e80 <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 04 3b 80 00       	push   $0x803b04
  801e74:	6a 2a                	push   $0x2a
  801e76:	68 f8 3a 80 00       	push   $0x803af8
  801e7b:	e8 2e 11 00 00       	call   802fae <_panic>
}
  801e80:	90                   	nop
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801e89:	e8 18 ff ff ff       	call   801da6 <uheap_init>
	if (size == 0) return NULL ;
  801e8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e92:	75 07                	jne    801e9b <malloc+0x18>
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	eb 14                	jmp    801eaf <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 44 3b 80 00       	push   $0x803b44
  801ea3:	6a 3e                	push   $0x3e
  801ea5:	68 f8 3a 80 00       	push   $0x803af8
  801eaa:	e8 ff 10 00 00       	call   802fae <_panic>
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801eb7:	83 ec 04             	sub    $0x4,%esp
  801eba:	68 6c 3b 80 00       	push   $0x803b6c
  801ebf:	6a 49                	push   $0x49
  801ec1:	68 f8 3a 80 00       	push   $0x803af8
  801ec6:	e8 e3 10 00 00       	call   802fae <_panic>

00801ecb <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 18             	sub    $0x18,%esp
  801ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801ed7:	e8 ca fe ff ff       	call   801da6 <uheap_init>
	if (size == 0) return NULL ;
  801edc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ee0:	75 07                	jne    801ee9 <smalloc+0x1e>
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	eb 14                	jmp    801efd <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	68 90 3b 80 00       	push   $0x803b90
  801ef1:	6a 5a                	push   $0x5a
  801ef3:	68 f8 3a 80 00       	push   $0x803af8
  801ef8:	e8 b1 10 00 00       	call   802fae <_panic>
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f05:	e8 9c fe ff ff       	call   801da6 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	68 b8 3b 80 00       	push   $0x803bb8
  801f12:	6a 6a                	push   $0x6a
  801f14:	68 f8 3a 80 00       	push   $0x803af8
  801f19:	e8 90 10 00 00       	call   802fae <_panic>

00801f1e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801f24:	e8 7d fe ff ff       	call   801da6 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	68 dc 3b 80 00       	push   $0x803bdc
  801f31:	68 88 00 00 00       	push   $0x88
  801f36:	68 f8 3a 80 00       	push   $0x803af8
  801f3b:	e8 6e 10 00 00       	call   802fae <_panic>

00801f40 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  801f46:	83 ec 04             	sub    $0x4,%esp
  801f49:	68 04 3c 80 00       	push   $0x803c04
  801f4e:	68 9b 00 00 00       	push   $0x9b
  801f53:	68 f8 3a 80 00       	push   $0x803af8
  801f58:	e8 51 10 00 00       	call   802fae <_panic>

00801f5d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	57                   	push   %edi
  801f61:	56                   	push   %esi
  801f62:	53                   	push   %ebx
  801f63:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f72:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f75:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f78:	cd 30                	int    $0x30
  801f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	5b                   	pop    %ebx
  801f84:	5e                   	pop    %esi
  801f85:	5f                   	pop    %edi
  801f86:	5d                   	pop    %ebp
  801f87:	c3                   	ret    

00801f88 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 04             	sub    $0x4,%esp
  801f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f91:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801f94:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f97:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	6a 00                	push   $0x0
  801fa0:	51                   	push   %ecx
  801fa1:	52                   	push   %edx
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	50                   	push   %eax
  801fa6:	6a 00                	push   $0x0
  801fa8:	e8 b0 ff ff ff       	call   801f5d <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	90                   	nop
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 02                	push   $0x2
  801fc2:	e8 96 ff ff ff       	call   801f5d <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_lock_cons>:

void sys_lock_cons(void)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 03                	push   $0x3
  801fdb:	e8 7d ff ff ff       	call   801f5d <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	90                   	nop
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 04                	push   $0x4
  801ff5:	e8 63 ff ff ff       	call   801f5d <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	90                   	nop
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	52                   	push   %edx
  802010:	50                   	push   %eax
  802011:	6a 08                	push   $0x8
  802013:	e8 45 ff ff ff       	call   801f5d <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802022:	8b 75 18             	mov    0x18(%ebp),%esi
  802025:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802028:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	56                   	push   %esi
  802032:	53                   	push   %ebx
  802033:	51                   	push   %ecx
  802034:	52                   	push   %edx
  802035:	50                   	push   %eax
  802036:	6a 09                	push   $0x9
  802038:	e8 20 ff ff ff       	call   801f5d <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
}
  802040:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	ff 75 08             	pushl  0x8(%ebp)
  802055:	6a 0a                	push   $0xa
  802057:	e8 01 ff ff ff       	call   801f5d <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	ff 75 0c             	pushl  0xc(%ebp)
  80206d:	ff 75 08             	pushl  0x8(%ebp)
  802070:	6a 0b                	push   $0xb
  802072:	e8 e6 fe ff ff       	call   801f5d <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 0c                	push   $0xc
  80208b:	e8 cd fe ff ff       	call   801f5d <syscall>
  802090:	83 c4 18             	add    $0x18,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 0d                	push   $0xd
  8020a4:	e8 b4 fe ff ff       	call   801f5d <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 0e                	push   $0xe
  8020bd:	e8 9b fe ff ff       	call   801f5d <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 0f                	push   $0xf
  8020d6:	e8 82 fe ff ff       	call   801f5d <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 08             	pushl  0x8(%ebp)
  8020ee:	6a 10                	push   $0x10
  8020f0:	e8 68 fe ff ff       	call   801f5d <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 11                	push   $0x11
  802109:	e8 4f fe ff ff       	call   801f5d <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	90                   	nop
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_cputc>:

void
sys_cputc(const char c)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 04             	sub    $0x4,%esp
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802120:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	50                   	push   %eax
  80212d:	6a 01                	push   $0x1
  80212f:	e8 29 fe ff ff       	call   801f5d <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	90                   	nop
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 14                	push   $0x14
  802149:	e8 0f fe ff ff       	call   801f5d <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	8b 45 10             	mov    0x10(%ebp),%eax
  80215d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802160:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802163:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	51                   	push   %ecx
  80216d:	52                   	push   %edx
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	50                   	push   %eax
  802172:	6a 15                	push   $0x15
  802174:	e8 e4 fd ff ff       	call   801f5d <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 16                	push   $0x16
  802191:	e8 c7 fd ff ff       	call   801f5d <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80219e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	51                   	push   %ecx
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 17                	push   $0x17
  8021b0:	e8 a8 fd ff ff       	call   801f5d <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	52                   	push   %edx
  8021ca:	50                   	push   %eax
  8021cb:	6a 18                	push   $0x18
  8021cd:	e8 8b fd ff ff       	call   801f5d <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	6a 00                	push   $0x0
  8021df:	ff 75 14             	pushl  0x14(%ebp)
  8021e2:	ff 75 10             	pushl  0x10(%ebp)
  8021e5:	ff 75 0c             	pushl  0xc(%ebp)
  8021e8:	50                   	push   %eax
  8021e9:	6a 19                	push   $0x19
  8021eb:	e8 6d fd ff ff       	call   801f5d <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	50                   	push   %eax
  802204:	6a 1a                	push   $0x1a
  802206:	e8 52 fd ff ff       	call   801f5d <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	90                   	nop
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	50                   	push   %eax
  802220:	6a 1b                	push   $0x1b
  802222:	e8 36 fd ff ff       	call   801f5d <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 05                	push   $0x5
  80223b:	e8 1d fd ff ff       	call   801f5d <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 06                	push   $0x6
  802254:	e8 04 fd ff ff       	call   801f5d <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 07                	push   $0x7
  80226d:	e8 eb fc ff ff       	call   801f5d <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_exit_env>:


void sys_exit_env(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 1c                	push   $0x1c
  802286:	e8 d2 fc ff ff       	call   801f5d <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802297:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80229a:	8d 50 04             	lea    0x4(%eax),%edx
  80229d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	52                   	push   %edx
  8022a7:	50                   	push   %eax
  8022a8:	6a 1d                	push   $0x1d
  8022aa:	e8 ae fc ff ff       	call   801f5d <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
	return result;
  8022b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022bb:	89 01                	mov    %eax,(%ecx)
  8022bd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	c9                   	leave  
  8022c4:	c2 04 00             	ret    $0x4

008022c7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	ff 75 10             	pushl  0x10(%ebp)
  8022d1:	ff 75 0c             	pushl  0xc(%ebp)
  8022d4:	ff 75 08             	pushl  0x8(%ebp)
  8022d7:	6a 13                	push   $0x13
  8022d9:	e8 7f fc ff ff       	call   801f5d <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return ;
  8022e1:	90                   	nop
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 1e                	push   $0x1e
  8022f3:	e8 65 fc ff ff       	call   801f5d <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802309:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	50                   	push   %eax
  802316:	6a 1f                	push   $0x1f
  802318:	e8 40 fc ff ff       	call   801f5d <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
	return ;
  802320:	90                   	nop
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <rsttst>:
void rsttst()
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 21                	push   $0x21
  802332:	e8 26 fc ff ff       	call   801f5d <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return ;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	8b 45 14             	mov    0x14(%ebp),%eax
  802346:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802349:	8b 55 18             	mov    0x18(%ebp),%edx
  80234c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802350:	52                   	push   %edx
  802351:	50                   	push   %eax
  802352:	ff 75 10             	pushl  0x10(%ebp)
  802355:	ff 75 0c             	pushl  0xc(%ebp)
  802358:	ff 75 08             	pushl  0x8(%ebp)
  80235b:	6a 20                	push   $0x20
  80235d:	e8 fb fb ff ff       	call   801f5d <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
	return ;
  802365:	90                   	nop
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <chktst>:
void chktst(uint32 n)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	ff 75 08             	pushl  0x8(%ebp)
  802376:	6a 22                	push   $0x22
  802378:	e8 e0 fb ff ff       	call   801f5d <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
	return ;
  802380:	90                   	nop
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <inctst>:

void inctst()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 23                	push   $0x23
  802392:	e8 c6 fb ff ff       	call   801f5d <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
	return ;
  80239a:	90                   	nop
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <gettst>:
uint32 gettst()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 24                	push   $0x24
  8023ac:	e8 ac fb ff ff       	call   801f5d <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 25                	push   $0x25
  8023c5:	e8 93 fb ff ff       	call   801f5d <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
  8023cd:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  8023d2:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	ff 75 08             	pushl  0x8(%ebp)
  8023ef:	6a 26                	push   $0x26
  8023f1:	e8 67 fb ff ff       	call   801f5d <syscall>
  8023f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f9:	90                   	nop
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802400:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802403:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802406:	8b 55 0c             	mov    0xc(%ebp),%edx
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	6a 00                	push   $0x0
  80240e:	53                   	push   %ebx
  80240f:	51                   	push   %ecx
  802410:	52                   	push   %edx
  802411:	50                   	push   %eax
  802412:	6a 27                	push   $0x27
  802414:	e8 44 fb ff ff       	call   801f5d <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802424:	8b 55 0c             	mov    0xc(%ebp),%edx
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	52                   	push   %edx
  802431:	50                   	push   %eax
  802432:	6a 28                	push   $0x28
  802434:	e8 24 fb ff ff       	call   801f5d <syscall>
  802439:	83 c4 18             	add    $0x18,%esp
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  802441:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802444:	8b 55 0c             	mov    0xc(%ebp),%edx
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	6a 00                	push   $0x0
  80244c:	51                   	push   %ecx
  80244d:	ff 75 10             	pushl  0x10(%ebp)
  802450:	52                   	push   %edx
  802451:	50                   	push   %eax
  802452:	6a 29                	push   $0x29
  802454:	e8 04 fb ff ff       	call   801f5d <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	ff 75 10             	pushl  0x10(%ebp)
  802468:	ff 75 0c             	pushl  0xc(%ebp)
  80246b:	ff 75 08             	pushl  0x8(%ebp)
  80246e:	6a 12                	push   $0x12
  802470:	e8 e8 fa ff ff       	call   801f5d <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
	return ;
  802478:	90                   	nop
}
  802479:	c9                   	leave  
  80247a:	c3                   	ret    

0080247b <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80247e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802481:	8b 45 08             	mov    0x8(%ebp),%eax
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	52                   	push   %edx
  80248b:	50                   	push   %eax
  80248c:	6a 2a                	push   $0x2a
  80248e:	e8 ca fa ff ff       	call   801f5d <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
	return;
  802496:	90                   	nop
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 2b                	push   $0x2b
  8024a8:	e8 b0 fa ff ff       	call   801f5d <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	ff 75 0c             	pushl  0xc(%ebp)
  8024be:	ff 75 08             	pushl  0x8(%ebp)
  8024c1:	6a 2d                	push   $0x2d
  8024c3:	e8 95 fa ff ff       	call   801f5d <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
	return;
  8024cb:	90                   	nop
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	ff 75 0c             	pushl  0xc(%ebp)
  8024da:	ff 75 08             	pushl  0x8(%ebp)
  8024dd:	6a 2c                	push   $0x2c
  8024df:	e8 79 fa ff ff       	call   801f5d <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e7:	90                   	nop
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	68 28 3c 80 00       	push   $0x803c28
  8024f8:	68 25 01 00 00       	push   $0x125
  8024fd:	68 5b 3c 80 00       	push   $0x803c5b
  802502:	e8 a7 0a 00 00       	call   802fae <_panic>

00802507 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  80250d:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  802514:	72 09                	jb     80251f <to_page_va+0x18>
  802516:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  80251d:	72 14                	jb     802533 <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	68 6c 3c 80 00       	push   $0x803c6c
  802527:	6a 15                	push   $0x15
  802529:	68 97 3c 80 00       	push   $0x803c97
  80252e:	e8 7b 0a 00 00       	call   802fae <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	ba 60 40 80 00       	mov    $0x804060,%edx
  80253b:	29 d0                	sub    %edx,%eax
  80253d:	c1 f8 02             	sar    $0x2,%eax
  802540:	89 c2                	mov    %eax,%edx
  802542:	89 d0                	mov    %edx,%eax
  802544:	c1 e0 02             	shl    $0x2,%eax
  802547:	01 d0                	add    %edx,%eax
  802549:	c1 e0 02             	shl    $0x2,%eax
  80254c:	01 d0                	add    %edx,%eax
  80254e:	c1 e0 02             	shl    $0x2,%eax
  802551:	01 d0                	add    %edx,%eax
  802553:	89 c1                	mov    %eax,%ecx
  802555:	c1 e1 08             	shl    $0x8,%ecx
  802558:	01 c8                	add    %ecx,%eax
  80255a:	89 c1                	mov    %eax,%ecx
  80255c:	c1 e1 10             	shl    $0x10,%ecx
  80255f:	01 c8                	add    %ecx,%eax
  802561:	01 c0                	add    %eax,%eax
  802563:	01 d0                	add    %edx,%eax
  802565:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	c1 e0 0c             	shl    $0xc,%eax
  80256e:	89 c2                	mov    %eax,%edx
  802570:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802575:	01 d0                	add    %edx,%eax
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  80257f:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802584:	8b 55 08             	mov    0x8(%ebp),%edx
  802587:	29 c2                	sub    %eax,%edx
  802589:	89 d0                	mov    %edx,%eax
  80258b:	c1 e8 0c             	shr    $0xc,%eax
  80258e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	78 09                	js     8025a0 <to_page_info+0x27>
  802597:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  80259e:	7e 14                	jle    8025b4 <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 b0 3c 80 00       	push   $0x803cb0
  8025a8:	6a 22                	push   $0x22
  8025aa:	68 97 3c 80 00       	push   $0x803c97
  8025af:	e8 fa 09 00 00       	call   802fae <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  8025b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b7:	89 d0                	mov    %edx,%eax
  8025b9:	01 c0                	add    %eax,%eax
  8025bb:	01 d0                	add    %edx,%eax
  8025bd:	c1 e0 02             	shl    $0x2,%eax
  8025c0:	05 60 40 80 00       	add    $0x804060,%eax
}
  8025c5:	c9                   	leave  
  8025c6:	c3                   	ret    

008025c7 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8025c7:	55                   	push   %ebp
  8025c8:	89 e5                	mov    %esp,%ebp
  8025ca:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8025cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d0:	05 00 00 00 02       	add    $0x2000000,%eax
  8025d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025d8:	73 16                	jae    8025f0 <initialize_dynamic_allocator+0x29>
  8025da:	68 d4 3c 80 00       	push   $0x803cd4
  8025df:	68 fa 3c 80 00       	push   $0x803cfa
  8025e4:	6a 34                	push   $0x34
  8025e6:	68 97 3c 80 00       	push   $0x803c97
  8025eb:	e8 be 09 00 00       	call   802fae <_panic>
		is_initialized = 1;
  8025f0:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  8025f7:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  802602:	8b 45 0c             	mov    0xc(%ebp),%eax
  802605:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  80260a:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  802611:	00 00 00 
  802614:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80261b:	00 00 00 
  80261e:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  802625:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  802628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262b:	2b 45 08             	sub    0x8(%ebp),%eax
  80262e:	c1 e8 0c             	shr    $0xc,%eax
  802631:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802634:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80263b:	e9 c8 00 00 00       	jmp    802708 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  802640:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802643:	89 d0                	mov    %edx,%eax
  802645:	01 c0                	add    %eax,%eax
  802647:	01 d0                	add    %edx,%eax
  802649:	c1 e0 02             	shl    $0x2,%eax
  80264c:	05 68 40 80 00       	add    $0x804068,%eax
  802651:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	89 d0                	mov    %edx,%eax
  80265b:	01 c0                	add    %eax,%eax
  80265d:	01 d0                	add    %edx,%eax
  80265f:	c1 e0 02             	shl    $0x2,%eax
  802662:	05 6a 40 80 00       	add    $0x80406a,%eax
  802667:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80266c:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802672:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802675:	89 c8                	mov    %ecx,%eax
  802677:	01 c0                	add    %eax,%eax
  802679:	01 c8                	add    %ecx,%eax
  80267b:	c1 e0 02             	shl    $0x2,%eax
  80267e:	05 64 40 80 00       	add    $0x804064,%eax
  802683:	89 10                	mov    %edx,(%eax)
  802685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802688:	89 d0                	mov    %edx,%eax
  80268a:	01 c0                	add    %eax,%eax
  80268c:	01 d0                	add    %edx,%eax
  80268e:	c1 e0 02             	shl    $0x2,%eax
  802691:	05 64 40 80 00       	add    $0x804064,%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 1b                	je     8026b7 <initialize_dynamic_allocator+0xf0>
  80269c:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8026a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026a5:	89 c8                	mov    %ecx,%eax
  8026a7:	01 c0                	add    %eax,%eax
  8026a9:	01 c8                	add    %ecx,%eax
  8026ab:	c1 e0 02             	shl    $0x2,%eax
  8026ae:	05 60 40 80 00       	add    $0x804060,%eax
  8026b3:	89 02                	mov    %eax,(%edx)
  8026b5:	eb 16                	jmp    8026cd <initialize_dynamic_allocator+0x106>
  8026b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ba:	89 d0                	mov    %edx,%eax
  8026bc:	01 c0                	add    %eax,%eax
  8026be:	01 d0                	add    %edx,%eax
  8026c0:	c1 e0 02             	shl    $0x2,%eax
  8026c3:	05 60 40 80 00       	add    $0x804060,%eax
  8026c8:	a3 48 40 80 00       	mov    %eax,0x804048
  8026cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d0:	89 d0                	mov    %edx,%eax
  8026d2:	01 c0                	add    %eax,%eax
  8026d4:	01 d0                	add    %edx,%eax
  8026d6:	c1 e0 02             	shl    $0x2,%eax
  8026d9:	05 60 40 80 00       	add    $0x804060,%eax
  8026de:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	89 d0                	mov    %edx,%eax
  8026e8:	01 c0                	add    %eax,%eax
  8026ea:	01 d0                	add    %edx,%eax
  8026ec:	c1 e0 02             	shl    $0x2,%eax
  8026ef:	05 60 40 80 00       	add    $0x804060,%eax
  8026f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fa:	a1 54 40 80 00       	mov    0x804054,%eax
  8026ff:	40                   	inc    %eax
  802700:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802705:	ff 45 f4             	incl   -0xc(%ebp)
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80270e:	0f 8c 2c ff ff ff    	jl     802640 <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80271b:	eb 36                	jmp    802753 <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	c1 e0 04             	shl    $0x4,%eax
  802723:	05 80 c0 81 00       	add    $0x81c080,%eax
  802728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	c1 e0 04             	shl    $0x4,%eax
  802734:	05 84 c0 81 00       	add    $0x81c084,%eax
  802739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	c1 e0 04             	shl    $0x4,%eax
  802745:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80274a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  802750:	ff 45 f0             	incl   -0x10(%ebp)
  802753:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  802757:	7e c4                	jle    80271d <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  802759:	90                   	nop
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	83 ec 0c             	sub    $0xc,%esp
  802768:	50                   	push   %eax
  802769:	e8 0b fe ff ff       	call   802579 <to_page_info>
  80276e:	83 c4 10             	add    $0x10,%esp
  802771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 08             	mov    0x8(%eax),%eax
  80277a:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	ff 75 0c             	pushl  0xc(%ebp)
  80278b:	e8 77 fd ff ff       	call   802507 <to_page_va>
  802790:	83 c4 10             	add    $0x10,%esp
  802793:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802796:	b8 00 10 00 00       	mov    $0x1000,%eax
  80279b:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a0:	f7 75 08             	divl   0x8(%ebp)
  8027a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  8027a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a9:	83 ec 0c             	sub    $0xc,%esp
  8027ac:	50                   	push   %eax
  8027ad:	e8 48 f6 ff ff       	call   801dfa <get_page>
  8027b2:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  8027b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027bb:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  8027c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8027d0:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8027d7:	eb 19                	jmp    8027f2 <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	ba 01 00 00 00       	mov    $0x1,%edx
  8027e1:	88 c1                	mov    %al,%cl
  8027e3:	d3 e2                	shl    %cl,%edx
  8027e5:	89 d0                	mov    %edx,%eax
  8027e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ea:	74 0e                	je     8027fa <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  8027ec:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8027ef:	ff 45 f0             	incl   -0x10(%ebp)
  8027f2:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8027f6:	7e e1                	jle    8027d9 <split_page_to_blocks+0x5a>
  8027f8:	eb 01                	jmp    8027fb <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  8027fa:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8027fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802802:	e9 a7 00 00 00       	jmp    8028ae <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	0f af 45 08          	imul   0x8(%ebp),%eax
  80280e:	89 c2                	mov    %eax,%edx
  802810:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802813:	01 d0                	add    %edx,%eax
  802815:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802818:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80281c:	75 14                	jne    802832 <split_page_to_blocks+0xb3>
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	68 10 3d 80 00       	push   $0x803d10
  802826:	6a 7c                	push   $0x7c
  802828:	68 97 3c 80 00       	push   $0x803c97
  80282d:	e8 7c 07 00 00       	call   802fae <_panic>
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c1 e0 04             	shl    $0x4,%eax
  802838:	05 84 c0 81 00       	add    $0x81c084,%eax
  80283d:	8b 10                	mov    (%eax),%edx
  80283f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 14                	je     802863 <split_page_to_blocks+0xe4>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	c1 e0 04             	shl    $0x4,%eax
  802855:	05 84 c0 81 00       	add    $0x81c084,%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	eb 11                	jmp    802874 <split_page_to_blocks+0xf5>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	c1 e0 04             	shl    $0x4,%eax
  802869:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80286f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802872:	89 02                	mov    %eax,(%edx)
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	c1 e0 04             	shl    $0x4,%eax
  80287a:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802883:	89 02                	mov    %eax,(%edx)
  802885:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802888:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	c1 e0 04             	shl    $0x4,%eax
  802894:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	8d 50 01             	lea    0x1(%eax),%edx
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	c1 e0 04             	shl    $0x4,%eax
  8028a4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8028a9:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  8028ab:	ff 45 ec             	incl   -0x14(%ebp)
  8028ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b1:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  8028b4:	0f 82 4d ff ff ff    	jb     802807 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  8028ba:	90                   	nop
  8028bb:	c9                   	leave  
  8028bc:	c3                   	ret    

008028bd <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  8028bd:	55                   	push   %ebp
  8028be:	89 e5                	mov    %esp,%ebp
  8028c0:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8028c3:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8028ca:	76 19                	jbe    8028e5 <alloc_block+0x28>
  8028cc:	68 34 3d 80 00       	push   $0x803d34
  8028d1:	68 fa 3c 80 00       	push   $0x803cfa
  8028d6:	68 8a 00 00 00       	push   $0x8a
  8028db:	68 97 3c 80 00       	push   $0x803c97
  8028e0:	e8 c9 06 00 00       	call   802fae <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  8028e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  8028ec:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8028f3:	eb 19                	jmp    80290e <alloc_block+0x51>
		if((1 << i) >= size) break;
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	ba 01 00 00 00       	mov    $0x1,%edx
  8028fd:	88 c1                	mov    %al,%cl
  8028ff:	d3 e2                	shl    %cl,%edx
  802901:	89 d0                	mov    %edx,%eax
  802903:	3b 45 08             	cmp    0x8(%ebp),%eax
  802906:	73 0e                	jae    802916 <alloc_block+0x59>
		idx++;
  802908:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  80290b:	ff 45 f0             	incl   -0x10(%ebp)
  80290e:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802912:	7e e1                	jle    8028f5 <alloc_block+0x38>
  802914:	eb 01                	jmp    802917 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802916:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c1 e0 04             	shl    $0x4,%eax
  80291d:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	0f 84 df 00 00 00    	je     802a0b <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	c1 e0 04             	shl    $0x4,%eax
  802932:	05 80 c0 81 00       	add    $0x81c080,%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  80293c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802940:	75 17                	jne    802959 <alloc_block+0x9c>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 55 3d 80 00       	push   $0x803d55
  80294a:	68 9e 00 00 00       	push   $0x9e
  80294f:	68 97 3c 80 00       	push   $0x803c97
  802954:	e8 55 06 00 00       	call   802fae <_panic>
  802959:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 10                	je     802972 <alloc_block+0xb5>
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80296a:	8b 52 04             	mov    0x4(%edx),%edx
  80296d:	89 50 04             	mov    %edx,0x4(%eax)
  802970:	eb 14                	jmp    802986 <alloc_block+0xc9>
  802972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297b:	c1 e2 04             	shl    $0x4,%edx
  80297e:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802984:	89 02                	mov    %eax,(%edx)
  802986:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802989:	8b 40 04             	mov    0x4(%eax),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 0f                	je     80299f <alloc_block+0xe2>
  802990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802999:	8b 12                	mov    (%edx),%edx
  80299b:	89 10                	mov    %edx,(%eax)
  80299d:	eb 13                	jmp    8029b2 <alloc_block+0xf5>
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	c1 e2 04             	shl    $0x4,%edx
  8029aa:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8029b0:	89 02                	mov    %eax,(%edx)
  8029b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	c1 e0 04             	shl    $0x4,%eax
  8029cb:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	c1 e0 04             	shl    $0x4,%eax
  8029db:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8029e0:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	83 ec 0c             	sub    $0xc,%esp
  8029e8:	50                   	push   %eax
  8029e9:	e8 8b fb ff ff       	call   802579 <to_page_info>
  8029ee:	83 c4 10             	add    $0x10,%esp
  8029f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  8029f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f7:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8029fb:	48                   	dec    %eax
  8029fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029ff:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	e9 bc 02 00 00       	jmp    802cc7 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802a0b:	a1 54 40 80 00       	mov    0x804054,%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	0f 84 7d 02 00 00    	je     802c95 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802a18:	a1 48 40 80 00       	mov    0x804048,%eax
  802a1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  802a20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a24:	75 17                	jne    802a3d <alloc_block+0x180>
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	68 55 3d 80 00       	push   $0x803d55
  802a2e:	68 a9 00 00 00       	push   $0xa9
  802a33:	68 97 3c 80 00       	push   $0x803c97
  802a38:	e8 71 05 00 00       	call   802fae <_panic>
  802a3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 10                	je     802a56 <alloc_block+0x199>
  802a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a4e:	8b 52 04             	mov    0x4(%edx),%edx
  802a51:	89 50 04             	mov    %edx,0x4(%eax)
  802a54:	eb 0b                	jmp    802a61 <alloc_block+0x1a4>
  802a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0f                	je     802a7a <alloc_block+0x1bd>
  802a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a74:	8b 12                	mov    (%edx),%edx
  802a76:	89 10                	mov    %edx,(%eax)
  802a78:	eb 0a                	jmp    802a84 <alloc_block+0x1c7>
  802a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	a3 48 40 80 00       	mov    %eax,0x804048
  802a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a97:	a1 54 40 80 00       	mov    0x804054,%eax
  802a9c:	48                   	dec    %eax
  802a9d:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	83 c0 03             	add    $0x3,%eax
  802aa8:	ba 01 00 00 00       	mov    $0x1,%edx
  802aad:	88 c1                	mov    %al,%cl
  802aaf:	d3 e2                	shl    %cl,%edx
  802ab1:	89 d0                	mov    %edx,%eax
  802ab3:	83 ec 08             	sub    $0x8,%esp
  802ab6:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ab9:	50                   	push   %eax
  802aba:	e8 c0 fc ff ff       	call   80277f <split_page_to_blocks>
  802abf:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	c1 e0 04             	shl    $0x4,%eax
  802ac8:	05 80 c0 81 00       	add    $0x81c080,%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  802ad2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ad6:	75 17                	jne    802aef <alloc_block+0x232>
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	68 55 3d 80 00       	push   $0x803d55
  802ae0:	68 b0 00 00 00       	push   $0xb0
  802ae5:	68 97 3c 80 00       	push   $0x803c97
  802aea:	e8 bf 04 00 00       	call   802fae <_panic>
  802aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 10                	je     802b08 <alloc_block+0x24b>
  802af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b00:	8b 52 04             	mov    0x4(%edx),%edx
  802b03:	89 50 04             	mov    %edx,0x4(%eax)
  802b06:	eb 14                	jmp    802b1c <alloc_block+0x25f>
  802b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	c1 e2 04             	shl    $0x4,%edx
  802b14:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802b1a:	89 02                	mov    %eax,(%edx)
  802b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0f                	je     802b35 <alloc_block+0x278>
  802b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b2f:	8b 12                	mov    (%edx),%edx
  802b31:	89 10                	mov    %edx,(%eax)
  802b33:	eb 13                	jmp    802b48 <alloc_block+0x28b>
  802b35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3d:	c1 e2 04             	shl    $0x4,%edx
  802b40:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802b46:	89 02                	mov    %eax,(%edx)
  802b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c1 e0 04             	shl    $0x4,%eax
  802b61:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	8d 50 ff             	lea    -0x1(%eax),%edx
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	c1 e0 04             	shl    $0x4,%eax
  802b71:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802b76:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802b78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7b:	83 ec 0c             	sub    $0xc,%esp
  802b7e:	50                   	push   %eax
  802b7f:	e8 f5 f9 ff ff       	call   802579 <to_page_info>
  802b84:	83 c4 10             	add    $0x10,%esp
  802b87:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802b8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b8d:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802b91:	48                   	dec    %eax
  802b92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b95:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802b99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9c:	e9 26 01 00 00       	jmp    802cc7 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  802ba1:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	c1 e0 04             	shl    $0x4,%eax
  802baa:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	0f 84 dc 00 00 00    	je     802c95 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	c1 e0 04             	shl    $0x4,%eax
  802bbf:	05 80 c0 81 00       	add    $0x81c080,%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802bc9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block+0x329>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 55 3d 80 00       	push   $0x803d55
  802bd7:	68 be 00 00 00       	push   $0xbe
  802bdc:	68 97 3c 80 00       	push   $0x803c97
  802be1:	e8 c8 03 00 00       	call   802fae <_panic>
  802be6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 10                	je     802bff <alloc_block+0x342>
  802bef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bf7:	8b 52 04             	mov    0x4(%edx),%edx
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	eb 14                	jmp    802c13 <alloc_block+0x356>
  802bff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c08:	c1 e2 04             	shl    $0x4,%edx
  802c0b:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802c11:	89 02                	mov    %eax,(%edx)
  802c13:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 0f                	je     802c2c <alloc_block+0x36f>
  802c1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c26:	8b 12                	mov    (%edx),%edx
  802c28:	89 10                	mov    %edx,(%eax)
  802c2a:	eb 13                	jmp    802c3f <alloc_block+0x382>
  802c2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c34:	c1 e2 04             	shl    $0x4,%edx
  802c37:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802c3d:	89 02                	mov    %eax,(%edx)
  802c3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	c1 e0 04             	shl    $0x4,%eax
  802c58:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	c1 e0 04             	shl    $0x4,%eax
  802c68:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802c6d:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  802c6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c72:	83 ec 0c             	sub    $0xc,%esp
  802c75:	50                   	push   %eax
  802c76:	e8 fe f8 ff ff       	call   802579 <to_page_info>
  802c7b:	83 c4 10             	add    $0x10,%esp
  802c7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  802c81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c84:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802c88:	48                   	dec    %eax
  802c89:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802c8c:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  802c90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c93:	eb 32                	jmp    802cc7 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802c95:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802c99:	77 15                	ja     802cb0 <alloc_block+0x3f3>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	c1 e0 04             	shl    $0x4,%eax
  802ca1:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	0f 84 f1 fe ff ff    	je     802ba1 <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  802cb0:	83 ec 04             	sub    $0x4,%esp
  802cb3:	68 73 3d 80 00       	push   $0x803d73
  802cb8:	68 c8 00 00 00       	push   $0xc8
  802cbd:	68 97 3c 80 00       	push   $0x803c97
  802cc2:	e8 e7 02 00 00       	call   802fae <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802cc7:	c9                   	leave  
  802cc8:	c3                   	ret    

00802cc9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  802ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd2:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802cd7:	39 c2                	cmp    %eax,%edx
  802cd9:	72 0c                	jb     802ce7 <free_block+0x1e>
  802cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cde:	a1 40 40 80 00       	mov    0x804040,%eax
  802ce3:	39 c2                	cmp    %eax,%edx
  802ce5:	72 19                	jb     802d00 <free_block+0x37>
  802ce7:	68 84 3d 80 00       	push   $0x803d84
  802cec:	68 fa 3c 80 00       	push   $0x803cfa
  802cf1:	68 d7 00 00 00       	push   $0xd7
  802cf6:	68 97 3c 80 00       	push   $0x803c97
  802cfb:	e8 ae 02 00 00       	call   802fae <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	83 ec 0c             	sub    $0xc,%esp
  802d0c:	50                   	push   %eax
  802d0d:	e8 67 f8 ff ff       	call   802579 <to_page_info>
  802d12:	83 c4 10             	add    $0x10,%esp
  802d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	0f b7 c0             	movzwl %ax,%eax
  802d21:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  802d24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802d2b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802d32:	eb 19                	jmp    802d4d <free_block+0x84>
	    if ((1 << i) == blk_size)
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	ba 01 00 00 00       	mov    $0x1,%edx
  802d3c:	88 c1                	mov    %al,%cl
  802d3e:	d3 e2                	shl    %cl,%edx
  802d40:	89 d0                	mov    %edx,%eax
  802d42:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d45:	74 0e                	je     802d55 <free_block+0x8c>
	        break;
	    idx++;
  802d47:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  802d4a:	ff 45 f0             	incl   -0x10(%ebp)
  802d4d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802d51:	7e e1                	jle    802d34 <free_block+0x6b>
  802d53:	eb 01                	jmp    802d56 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  802d55:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  802d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d59:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802d5d:	40                   	inc    %eax
  802d5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d61:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  802d65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d69:	75 17                	jne    802d82 <free_block+0xb9>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 10 3d 80 00       	push   $0x803d10
  802d73:	68 ee 00 00 00       	push   $0xee
  802d78:	68 97 3c 80 00       	push   $0x803c97
  802d7d:	e8 2c 02 00 00       	call   802fae <_panic>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	c1 e0 04             	shl    $0x4,%eax
  802d88:	05 84 c0 81 00       	add    $0x81c084,%eax
  802d8d:	8b 10                	mov    (%eax),%edx
  802d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d92:	89 50 04             	mov    %edx,0x4(%eax)
  802d95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 14                	je     802db3 <free_block+0xea>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c1 e0 04             	shl    $0x4,%eax
  802da5:	05 84 c0 81 00       	add    $0x81c084,%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	eb 11                	jmp    802dc4 <free_block+0xfb>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	c1 e0 04             	shl    $0x4,%eax
  802db9:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  802dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc2:	89 02                	mov    %eax,(%edx)
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	c1 e0 04             	shl    $0x4,%eax
  802dca:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	89 02                	mov    %eax,(%edx)
  802dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	c1 e0 04             	shl    $0x4,%eax
  802de4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	8d 50 01             	lea    0x1(%eax),%edx
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	c1 e0 04             	shl    $0x4,%eax
  802df4:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802df9:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802dfb:	b8 00 10 00 00       	mov    $0x1000,%eax
  802e00:	ba 00 00 00 00       	mov    $0x0,%edx
  802e05:	f7 75 e0             	divl   -0x20(%ebp)
  802e08:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0e:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802e12:	0f b7 c0             	movzwl %ax,%eax
  802e15:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802e18:	0f 85 70 01 00 00    	jne    802f8e <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802e1e:	83 ec 0c             	sub    $0xc,%esp
  802e21:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e24:	e8 de f6 ff ff       	call   802507 <to_page_va>
  802e29:	83 c4 10             	add    $0x10,%esp
  802e2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802e2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  802e36:	e9 b7 00 00 00       	jmp    802ef2 <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  802e3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	01 d0                	add    %edx,%eax
  802e43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  802e46:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802e4a:	75 17                	jne    802e63 <free_block+0x19a>
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	68 55 3d 80 00       	push   $0x803d55
  802e54:	68 f8 00 00 00       	push   $0xf8
  802e59:	68 97 3c 80 00       	push   $0x803c97
  802e5e:	e8 4b 01 00 00       	call   802fae <_panic>
  802e63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 10                	je     802e7c <free_block+0x1b3>
  802e6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802e74:	8b 52 04             	mov    0x4(%edx),%edx
  802e77:	89 50 04             	mov    %edx,0x4(%eax)
  802e7a:	eb 14                	jmp    802e90 <free_block+0x1c7>
  802e7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e85:	c1 e2 04             	shl    $0x4,%edx
  802e88:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802e8e:	89 02                	mov    %eax,(%edx)
  802e90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e93:	8b 40 04             	mov    0x4(%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0f                	je     802ea9 <free_block+0x1e0>
  802e9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802e9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ea0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802ea3:	8b 12                	mov    (%edx),%edx
  802ea5:	89 10                	mov    %edx,(%eax)
  802ea7:	eb 13                	jmp    802ebc <free_block+0x1f3>
  802ea9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb1:	c1 e2 04             	shl    $0x4,%edx
  802eb4:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802eba:	89 02                	mov    %eax,(%edx)
  802ebc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	c1 e0 04             	shl    $0x4,%eax
  802ed5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	8d 50 ff             	lea    -0x1(%eax),%edx
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	c1 e0 04             	shl    $0x4,%eax
  802ee5:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802eea:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eef:	01 45 ec             	add    %eax,-0x14(%ebp)
  802ef2:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802ef9:	0f 86 3c ff ff ff    	jbe    802e3b <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  802eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f02:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0b:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  802f11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f15:	75 17                	jne    802f2e <free_block+0x265>
  802f17:	83 ec 04             	sub    $0x4,%esp
  802f1a:	68 10 3d 80 00       	push   $0x803d10
  802f1f:	68 fe 00 00 00       	push   $0xfe
  802f24:	68 97 3c 80 00       	push   $0x803c97
  802f29:	e8 80 00 00 00       	call   802fae <_panic>
  802f2e:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  802f34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f37:	89 50 04             	mov    %edx,0x4(%eax)
  802f3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	85 c0                	test   %eax,%eax
  802f42:	74 0c                	je     802f50 <free_block+0x287>
  802f44:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802f49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f4c:	89 10                	mov    %edx,(%eax)
  802f4e:	eb 08                	jmp    802f58 <free_block+0x28f>
  802f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f53:	a3 48 40 80 00       	mov    %eax,0x804048
  802f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5b:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f69:	a1 54 40 80 00       	mov    0x804054,%eax
  802f6e:	40                   	inc    %eax
  802f6f:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  802f74:	83 ec 0c             	sub    $0xc,%esp
  802f77:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f7a:	e8 88 f5 ff ff       	call   802507 <to_page_va>
  802f7f:	83 c4 10             	add    $0x10,%esp
  802f82:	83 ec 0c             	sub    $0xc,%esp
  802f85:	50                   	push   %eax
  802f86:	e8 b8 ee ff ff       	call   801e43 <return_page>
  802f8b:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802f8e:	90                   	nop
  802f8f:	c9                   	leave  
  802f90:	c3                   	ret    

00802f91 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  802f91:	55                   	push   %ebp
  802f92:	89 e5                	mov    %esp,%ebp
  802f94:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 bc 3d 80 00       	push   $0x803dbc
  802f9f:	68 11 01 00 00       	push   $0x111
  802fa4:	68 97 3c 80 00       	push   $0x803c97
  802fa9:	e8 00 00 00 00       	call   802fae <_panic>

00802fae <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
  802fb1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802fb4:	8d 45 10             	lea    0x10(%ebp),%eax
  802fb7:	83 c0 04             	add    $0x4,%eax
  802fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802fbd:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 16                	je     802fdc <_panic+0x2e>
		cprintf("%s: ", argv0);
  802fc6:	a1 1c c1 81 00       	mov    0x81c11c,%eax
  802fcb:	83 ec 08             	sub    $0x8,%esp
  802fce:	50                   	push   %eax
  802fcf:	68 e0 3d 80 00       	push   $0x803de0
  802fd4:	e8 e0 dc ff ff       	call   800cb9 <cprintf>
  802fd9:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  802fdc:	a1 04 40 80 00       	mov    0x804004,%eax
  802fe1:	83 ec 0c             	sub    $0xc,%esp
  802fe4:	ff 75 0c             	pushl  0xc(%ebp)
  802fe7:	ff 75 08             	pushl  0x8(%ebp)
  802fea:	50                   	push   %eax
  802feb:	68 e8 3d 80 00       	push   $0x803de8
  802ff0:	6a 74                	push   $0x74
  802ff2:	e8 ef dc ff ff       	call   800ce6 <cprintf_colored>
  802ff7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  802ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  802ffd:	83 ec 08             	sub    $0x8,%esp
  803000:	ff 75 f4             	pushl  -0xc(%ebp)
  803003:	50                   	push   %eax
  803004:	e8 41 dc ff ff       	call   800c4a <vcprintf>
  803009:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80300c:	83 ec 08             	sub    $0x8,%esp
  80300f:	6a 00                	push   $0x0
  803011:	68 10 3e 80 00       	push   $0x803e10
  803016:	e8 2f dc ff ff       	call   800c4a <vcprintf>
  80301b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80301e:	e8 a8 db ff ff       	call   800bcb <exit>

	// should not return here
	while (1) ;
  803023:	eb fe                	jmp    803023 <_panic+0x75>

00803025 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
  803028:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80302b:	a1 20 40 80 00       	mov    0x804020,%eax
  803030:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803036:	8b 45 0c             	mov    0xc(%ebp),%eax
  803039:	39 c2                	cmp    %eax,%edx
  80303b:	74 14                	je     803051 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 14 3e 80 00       	push   $0x803e14
  803045:	6a 26                	push   $0x26
  803047:	68 60 3e 80 00       	push   $0x803e60
  80304c:	e8 5d ff ff ff       	call   802fae <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803051:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803058:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80305f:	e9 c5 00 00 00       	jmp    803129 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803067:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	01 d0                	add    %edx,%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	75 08                	jne    803081 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803079:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80307c:	e9 a5 00 00 00       	jmp    803126 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803081:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803088:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80308f:	eb 69                	jmp    8030fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803091:	a1 20 40 80 00       	mov    0x804020,%eax
  803096:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80309c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309f:	89 d0                	mov    %edx,%eax
  8030a1:	01 c0                	add    %eax,%eax
  8030a3:	01 d0                	add    %edx,%eax
  8030a5:	c1 e0 03             	shl    $0x3,%eax
  8030a8:	01 c8                	add    %ecx,%eax
  8030aa:	8a 40 04             	mov    0x4(%eax),%al
  8030ad:	84 c0                	test   %al,%al
  8030af:	75 46                	jne    8030f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8030b6:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8030bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bf:	89 d0                	mov    %edx,%eax
  8030c1:	01 c0                	add    %eax,%eax
  8030c3:	01 d0                	add    %edx,%eax
  8030c5:	c1 e0 03             	shl    $0x3,%eax
  8030c8:	01 c8                	add    %ecx,%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8030d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	01 c8                	add    %ecx,%eax
  8030e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030ea:	39 c2                	cmp    %eax,%edx
  8030ec:	75 09                	jne    8030f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8030ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8030f5:	eb 15                	jmp    80310c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030f7:	ff 45 e8             	incl   -0x18(%ebp)
  8030fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	39 c2                	cmp    %eax,%edx
  80310a:	77 85                	ja     803091 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80310c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803110:	75 14                	jne    803126 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 6c 3e 80 00       	push   $0x803e6c
  80311a:	6a 3a                	push   $0x3a
  80311c:	68 60 3e 80 00       	push   $0x803e60
  803121:	e8 88 fe ff ff       	call   802fae <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803126:	ff 45 f0             	incl   -0x10(%ebp)
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80312f:	0f 8c 2f ff ff ff    	jl     803064 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803135:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80313c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803143:	eb 26                	jmp    80316b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803145:	a1 20 40 80 00       	mov    0x804020,%eax
  80314a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  803150:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803153:	89 d0                	mov    %edx,%eax
  803155:	01 c0                	add    %eax,%eax
  803157:	01 d0                	add    %edx,%eax
  803159:	c1 e0 03             	shl    $0x3,%eax
  80315c:	01 c8                	add    %ecx,%eax
  80315e:	8a 40 04             	mov    0x4(%eax),%al
  803161:	3c 01                	cmp    $0x1,%al
  803163:	75 03                	jne    803168 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803165:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803168:	ff 45 e0             	incl   -0x20(%ebp)
  80316b:	a1 20 40 80 00       	mov    0x804020,%eax
  803170:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  803176:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803179:	39 c2                	cmp    %eax,%edx
  80317b:	77 c8                	ja     803145 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803183:	74 14                	je     803199 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	68 c0 3e 80 00       	push   $0x803ec0
  80318d:	6a 44                	push   $0x44
  80318f:	68 60 3e 80 00       	push   $0x803e60
  803194:	e8 15 fe ff ff       	call   802fae <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803199:	90                   	nop
  80319a:	c9                   	leave  
  80319b:	c3                   	ret    

0080319c <__udivdi3>:
  80319c:	55                   	push   %ebp
  80319d:	57                   	push   %edi
  80319e:	56                   	push   %esi
  80319f:	53                   	push   %ebx
  8031a0:	83 ec 1c             	sub    $0x1c,%esp
  8031a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031b3:	89 ca                	mov    %ecx,%edx
  8031b5:	89 f8                	mov    %edi,%eax
  8031b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031bb:	85 f6                	test   %esi,%esi
  8031bd:	75 2d                	jne    8031ec <__udivdi3+0x50>
  8031bf:	39 cf                	cmp    %ecx,%edi
  8031c1:	77 65                	ja     803228 <__udivdi3+0x8c>
  8031c3:	89 fd                	mov    %edi,%ebp
  8031c5:	85 ff                	test   %edi,%edi
  8031c7:	75 0b                	jne    8031d4 <__udivdi3+0x38>
  8031c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ce:	31 d2                	xor    %edx,%edx
  8031d0:	f7 f7                	div    %edi
  8031d2:	89 c5                	mov    %eax,%ebp
  8031d4:	31 d2                	xor    %edx,%edx
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	f7 f5                	div    %ebp
  8031da:	89 c1                	mov    %eax,%ecx
  8031dc:	89 d8                	mov    %ebx,%eax
  8031de:	f7 f5                	div    %ebp
  8031e0:	89 cf                	mov    %ecx,%edi
  8031e2:	89 fa                	mov    %edi,%edx
  8031e4:	83 c4 1c             	add    $0x1c,%esp
  8031e7:	5b                   	pop    %ebx
  8031e8:	5e                   	pop    %esi
  8031e9:	5f                   	pop    %edi
  8031ea:	5d                   	pop    %ebp
  8031eb:	c3                   	ret    
  8031ec:	39 ce                	cmp    %ecx,%esi
  8031ee:	77 28                	ja     803218 <__udivdi3+0x7c>
  8031f0:	0f bd fe             	bsr    %esi,%edi
  8031f3:	83 f7 1f             	xor    $0x1f,%edi
  8031f6:	75 40                	jne    803238 <__udivdi3+0x9c>
  8031f8:	39 ce                	cmp    %ecx,%esi
  8031fa:	72 0a                	jb     803206 <__udivdi3+0x6a>
  8031fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803200:	0f 87 9e 00 00 00    	ja     8032a4 <__udivdi3+0x108>
  803206:	b8 01 00 00 00       	mov    $0x1,%eax
  80320b:	89 fa                	mov    %edi,%edx
  80320d:	83 c4 1c             	add    $0x1c,%esp
  803210:	5b                   	pop    %ebx
  803211:	5e                   	pop    %esi
  803212:	5f                   	pop    %edi
  803213:	5d                   	pop    %ebp
  803214:	c3                   	ret    
  803215:	8d 76 00             	lea    0x0(%esi),%esi
  803218:	31 ff                	xor    %edi,%edi
  80321a:	31 c0                	xor    %eax,%eax
  80321c:	89 fa                	mov    %edi,%edx
  80321e:	83 c4 1c             	add    $0x1c,%esp
  803221:	5b                   	pop    %ebx
  803222:	5e                   	pop    %esi
  803223:	5f                   	pop    %edi
  803224:	5d                   	pop    %ebp
  803225:	c3                   	ret    
  803226:	66 90                	xchg   %ax,%ax
  803228:	89 d8                	mov    %ebx,%eax
  80322a:	f7 f7                	div    %edi
  80322c:	31 ff                	xor    %edi,%edi
  80322e:	89 fa                	mov    %edi,%edx
  803230:	83 c4 1c             	add    $0x1c,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    
  803238:	bd 20 00 00 00       	mov    $0x20,%ebp
  80323d:	89 eb                	mov    %ebp,%ebx
  80323f:	29 fb                	sub    %edi,%ebx
  803241:	89 f9                	mov    %edi,%ecx
  803243:	d3 e6                	shl    %cl,%esi
  803245:	89 c5                	mov    %eax,%ebp
  803247:	88 d9                	mov    %bl,%cl
  803249:	d3 ed                	shr    %cl,%ebp
  80324b:	89 e9                	mov    %ebp,%ecx
  80324d:	09 f1                	or     %esi,%ecx
  80324f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803253:	89 f9                	mov    %edi,%ecx
  803255:	d3 e0                	shl    %cl,%eax
  803257:	89 c5                	mov    %eax,%ebp
  803259:	89 d6                	mov    %edx,%esi
  80325b:	88 d9                	mov    %bl,%cl
  80325d:	d3 ee                	shr    %cl,%esi
  80325f:	89 f9                	mov    %edi,%ecx
  803261:	d3 e2                	shl    %cl,%edx
  803263:	8b 44 24 08          	mov    0x8(%esp),%eax
  803267:	88 d9                	mov    %bl,%cl
  803269:	d3 e8                	shr    %cl,%eax
  80326b:	09 c2                	or     %eax,%edx
  80326d:	89 d0                	mov    %edx,%eax
  80326f:	89 f2                	mov    %esi,%edx
  803271:	f7 74 24 0c          	divl   0xc(%esp)
  803275:	89 d6                	mov    %edx,%esi
  803277:	89 c3                	mov    %eax,%ebx
  803279:	f7 e5                	mul    %ebp
  80327b:	39 d6                	cmp    %edx,%esi
  80327d:	72 19                	jb     803298 <__udivdi3+0xfc>
  80327f:	74 0b                	je     80328c <__udivdi3+0xf0>
  803281:	89 d8                	mov    %ebx,%eax
  803283:	31 ff                	xor    %edi,%edi
  803285:	e9 58 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803290:	89 f9                	mov    %edi,%ecx
  803292:	d3 e2                	shl    %cl,%edx
  803294:	39 c2                	cmp    %eax,%edx
  803296:	73 e9                	jae    803281 <__udivdi3+0xe5>
  803298:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80329b:	31 ff                	xor    %edi,%edi
  80329d:	e9 40 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	31 c0                	xor    %eax,%eax
  8032a6:	e9 37 ff ff ff       	jmp    8031e2 <__udivdi3+0x46>
  8032ab:	90                   	nop

008032ac <__umoddi3>:
  8032ac:	55                   	push   %ebp
  8032ad:	57                   	push   %edi
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032cb:	89 f3                	mov    %esi,%ebx
  8032cd:	89 fa                	mov    %edi,%edx
  8032cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032d3:	89 34 24             	mov    %esi,(%esp)
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	75 1a                	jne    8032f4 <__umoddi3+0x48>
  8032da:	39 f7                	cmp    %esi,%edi
  8032dc:	0f 86 a2 00 00 00    	jbe    803384 <__umoddi3+0xd8>
  8032e2:	89 c8                	mov    %ecx,%eax
  8032e4:	89 f2                	mov    %esi,%edx
  8032e6:	f7 f7                	div    %edi
  8032e8:	89 d0                	mov    %edx,%eax
  8032ea:	31 d2                	xor    %edx,%edx
  8032ec:	83 c4 1c             	add    $0x1c,%esp
  8032ef:	5b                   	pop    %ebx
  8032f0:	5e                   	pop    %esi
  8032f1:	5f                   	pop    %edi
  8032f2:	5d                   	pop    %ebp
  8032f3:	c3                   	ret    
  8032f4:	39 f0                	cmp    %esi,%eax
  8032f6:	0f 87 ac 00 00 00    	ja     8033a8 <__umoddi3+0xfc>
  8032fc:	0f bd e8             	bsr    %eax,%ebp
  8032ff:	83 f5 1f             	xor    $0x1f,%ebp
  803302:	0f 84 ac 00 00 00    	je     8033b4 <__umoddi3+0x108>
  803308:	bf 20 00 00 00       	mov    $0x20,%edi
  80330d:	29 ef                	sub    %ebp,%edi
  80330f:	89 fe                	mov    %edi,%esi
  803311:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803315:	89 e9                	mov    %ebp,%ecx
  803317:	d3 e0                	shl    %cl,%eax
  803319:	89 d7                	mov    %edx,%edi
  80331b:	89 f1                	mov    %esi,%ecx
  80331d:	d3 ef                	shr    %cl,%edi
  80331f:	09 c7                	or     %eax,%edi
  803321:	89 e9                	mov    %ebp,%ecx
  803323:	d3 e2                	shl    %cl,%edx
  803325:	89 14 24             	mov    %edx,(%esp)
  803328:	89 d8                	mov    %ebx,%eax
  80332a:	d3 e0                	shl    %cl,%eax
  80332c:	89 c2                	mov    %eax,%edx
  80332e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803332:	d3 e0                	shl    %cl,%eax
  803334:	89 44 24 04          	mov    %eax,0x4(%esp)
  803338:	8b 44 24 08          	mov    0x8(%esp),%eax
  80333c:	89 f1                	mov    %esi,%ecx
  80333e:	d3 e8                	shr    %cl,%eax
  803340:	09 d0                	or     %edx,%eax
  803342:	d3 eb                	shr    %cl,%ebx
  803344:	89 da                	mov    %ebx,%edx
  803346:	f7 f7                	div    %edi
  803348:	89 d3                	mov    %edx,%ebx
  80334a:	f7 24 24             	mull   (%esp)
  80334d:	89 c6                	mov    %eax,%esi
  80334f:	89 d1                	mov    %edx,%ecx
  803351:	39 d3                	cmp    %edx,%ebx
  803353:	0f 82 87 00 00 00    	jb     8033e0 <__umoddi3+0x134>
  803359:	0f 84 91 00 00 00    	je     8033f0 <__umoddi3+0x144>
  80335f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803363:	29 f2                	sub    %esi,%edx
  803365:	19 cb                	sbb    %ecx,%ebx
  803367:	89 d8                	mov    %ebx,%eax
  803369:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80336d:	d3 e0                	shl    %cl,%eax
  80336f:	89 e9                	mov    %ebp,%ecx
  803371:	d3 ea                	shr    %cl,%edx
  803373:	09 d0                	or     %edx,%eax
  803375:	89 e9                	mov    %ebp,%ecx
  803377:	d3 eb                	shr    %cl,%ebx
  803379:	89 da                	mov    %ebx,%edx
  80337b:	83 c4 1c             	add    $0x1c,%esp
  80337e:	5b                   	pop    %ebx
  80337f:	5e                   	pop    %esi
  803380:	5f                   	pop    %edi
  803381:	5d                   	pop    %ebp
  803382:	c3                   	ret    
  803383:	90                   	nop
  803384:	89 fd                	mov    %edi,%ebp
  803386:	85 ff                	test   %edi,%edi
  803388:	75 0b                	jne    803395 <__umoddi3+0xe9>
  80338a:	b8 01 00 00 00       	mov    $0x1,%eax
  80338f:	31 d2                	xor    %edx,%edx
  803391:	f7 f7                	div    %edi
  803393:	89 c5                	mov    %eax,%ebp
  803395:	89 f0                	mov    %esi,%eax
  803397:	31 d2                	xor    %edx,%edx
  803399:	f7 f5                	div    %ebp
  80339b:	89 c8                	mov    %ecx,%eax
  80339d:	f7 f5                	div    %ebp
  80339f:	89 d0                	mov    %edx,%eax
  8033a1:	e9 44 ff ff ff       	jmp    8032ea <__umoddi3+0x3e>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	89 c8                	mov    %ecx,%eax
  8033aa:	89 f2                	mov    %esi,%edx
  8033ac:	83 c4 1c             	add    $0x1c,%esp
  8033af:	5b                   	pop    %ebx
  8033b0:	5e                   	pop    %esi
  8033b1:	5f                   	pop    %edi
  8033b2:	5d                   	pop    %ebp
  8033b3:	c3                   	ret    
  8033b4:	3b 04 24             	cmp    (%esp),%eax
  8033b7:	72 06                	jb     8033bf <__umoddi3+0x113>
  8033b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033bd:	77 0f                	ja     8033ce <__umoddi3+0x122>
  8033bf:	89 f2                	mov    %esi,%edx
  8033c1:	29 f9                	sub    %edi,%ecx
  8033c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033c7:	89 14 24             	mov    %edx,(%esp)
  8033ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033d2:	8b 14 24             	mov    (%esp),%edx
  8033d5:	83 c4 1c             	add    $0x1c,%esp
  8033d8:	5b                   	pop    %ebx
  8033d9:	5e                   	pop    %esi
  8033da:	5f                   	pop    %edi
  8033db:	5d                   	pop    %ebp
  8033dc:	c3                   	ret    
  8033dd:	8d 76 00             	lea    0x0(%esi),%esi
  8033e0:	2b 04 24             	sub    (%esp),%eax
  8033e3:	19 fa                	sbb    %edi,%edx
  8033e5:	89 d1                	mov    %edx,%ecx
  8033e7:	89 c6                	mov    %eax,%esi
  8033e9:	e9 71 ff ff ff       	jmp    80335f <__umoddi3+0xb3>
  8033ee:	66 90                	xchg   %ax,%ax
  8033f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033f4:	72 ea                	jb     8033e0 <__umoddi3+0x134>
  8033f6:	89 d9                	mov    %ebx,%ecx
  8033f8:	e9 62 ff ff ff       	jmp    80335f <__umoddi3+0xb3>
