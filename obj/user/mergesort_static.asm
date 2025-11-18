
obj/user/mergesort_static:     file format elf32-i386


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
  800031:	e8 d5 06 00 00       	call   80070b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_lock_cons();
  80004b:	e8 a2 1a 00 00       	call   801af2 <sys_lock_cons>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 a0 22 80 00       	push   $0x8022a0
  800058:	e8 41 0b 00 00       	call   800b9e <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 a2 22 80 00       	push   $0x8022a2
  800068:	e8 31 0b 00 00       	call   800b9e <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 b8 22 80 00       	push   $0x8022b8
  800078:	e8 21 0b 00 00       	call   800b9e <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 a2 22 80 00       	push   $0x8022a2
  800088:	e8 11 0b 00 00       	call   800b9e <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 a0 22 80 00       	push   $0x8022a0
  800098:	e8 01 0b 00 00       	call   800b9e <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 800000;
  8000a0:	c7 45 ec 00 35 0c 00 	movl   $0xc3500,-0x14(%ebp)
		cprintf("Enter the number of elements: %d\n", NumOfElements) ;
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8000ad:	68 d0 22 80 00       	push   $0x8022d0
  8000b2:	e8 e7 0a 00 00       	call   800b9e <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp

		cprintf("Chose the initialization method:\n") ;
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 f4 22 80 00       	push   $0x8022f4
  8000c2:	e8 d7 0a 00 00       	call   800b9e <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 16 23 80 00       	push   $0x802316
  8000d2:	e8 c7 0a 00 00       	call   800b9e <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 24 23 80 00       	push   $0x802324
  8000e2:	e8 b7 0a 00 00       	call   800b9e <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 33 23 80 00       	push   $0x802333
  8000f2:	e8 a7 0a 00 00       	call   800b9e <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	68 43 23 80 00       	push   $0x802343
  800102:	e8 97 0a 00 00       	call   800b9e <cprintf>
  800107:	83 c4 10             	add    $0x10,%esp
			Chose = 'c' ;
  80010a:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80010e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	50                   	push   %eax
  800116:	e8 b4 05 00 00       	call   8006cf <cputchar>
  80011b:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	6a 0a                	push   $0xa
  800123:	e8 a7 05 00 00       	call   8006cf <cputchar>
  800128:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  80012b:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80012f:	74 0c                	je     80013d <_main+0x105>
  800131:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800135:	74 06                	je     80013d <_main+0x105>
  800137:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  80013b:	75 bd                	jne    8000fa <_main+0xc2>

		//2012: lock the interrupt
		sys_unlock_cons();
  80013d:	e8 ca 19 00 00       	call   801b0c <sys_unlock_cons>

		//int *Elements = malloc(sizeof(int) * NumOfElements) ;
		int *Elements = __Elements;
  800142:	c7 45 e8 40 85 b2 00 	movl   $0xb28540,-0x18(%ebp)
		int  i ;
		switch (Chose)
  800149:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80014d:	83 f8 62             	cmp    $0x62,%eax
  800150:	74 1d                	je     80016f <_main+0x137>
  800152:	83 f8 63             	cmp    $0x63,%eax
  800155:	74 2b                	je     800182 <_main+0x14a>
  800157:	83 f8 61             	cmp    $0x61,%eax
  80015a:	75 39                	jne    800195 <_main+0x15d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	ff 75 ec             	pushl  -0x14(%ebp)
  800162:	ff 75 e8             	pushl  -0x18(%ebp)
  800165:	e8 e7 01 00 00       	call   800351 <InitializeAscending>
  80016a:	83 c4 10             	add    $0x10,%esp
			break ;
  80016d:	eb 37                	jmp    8001a6 <_main+0x16e>
		case 'b':
			InitializeIdentical(Elements, NumOfElements);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 ec             	pushl  -0x14(%ebp)
  800175:	ff 75 e8             	pushl  -0x18(%ebp)
  800178:	e8 05 02 00 00       	call   800382 <InitializeIdentical>
  80017d:	83 c4 10             	add    $0x10,%esp
			break ;
  800180:	eb 24                	jmp    8001a6 <_main+0x16e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800182:	83 ec 08             	sub    $0x8,%esp
  800185:	ff 75 ec             	pushl  -0x14(%ebp)
  800188:	ff 75 e8             	pushl  -0x18(%ebp)
  80018b:	e8 27 02 00 00       	call   8003b7 <InitializeSemiRandom>
  800190:	83 c4 10             	add    $0x10,%esp
			break ;
  800193:	eb 11                	jmp    8001a6 <_main+0x16e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 ec             	pushl  -0x14(%ebp)
  80019b:	ff 75 e8             	pushl  -0x18(%ebp)
  80019e:	e8 14 02 00 00       	call   8003b7 <InitializeSemiRandom>
  8001a3:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ac:	6a 01                	push   $0x1
  8001ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b1:	e8 e0 02 00 00       	call   800496 <MSort>
  8001b6:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8001b9:	e8 34 19 00 00       	call   801af2 <sys_lock_cons>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 4c 23 80 00       	push   $0x80234c
  8001c6:	e8 d3 09 00 00       	call   800b9e <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_unlock_cons();
  8001ce:	e8 39 19 00 00       	call   801b0c <sys_unlock_cons>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8001dc:	e8 c6 00 00 00       	call   8002a7 <CheckSorted>
  8001e1:	83 c4 10             	add    $0x10,%esp
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8001eb:	75 14                	jne    800201 <_main+0x1c9>
  8001ed:	83 ec 04             	sub    $0x4,%esp
  8001f0:	68 80 23 80 00       	push   $0x802380
  8001f5:	6a 51                	push   $0x51
  8001f7:	68 a2 23 80 00       	push   $0x8023a2
  8001fc:	e8 cf 06 00 00       	call   8008d0 <_panic>
		else
		{
			sys_lock_cons();
  800201:	e8 ec 18 00 00       	call   801af2 <sys_lock_cons>
			cprintf("===============================================\n") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 bc 23 80 00       	push   $0x8023bc
  80020e:	e8 8b 09 00 00       	call   800b9e <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 f0 23 80 00       	push   $0x8023f0
  80021e:	e8 7b 09 00 00       	call   800b9e <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 24 24 80 00       	push   $0x802424
  80022e:	e8 6b 09 00 00       	call   800b9e <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
			sys_unlock_cons();
  800236:	e8 d1 18 00 00       	call   801b0c <sys_unlock_cons>
		}

		//free(Elements) ;

		sys_lock_cons();
  80023b:	e8 b2 18 00 00       	call   801af2 <sys_lock_cons>
		Chose = 0 ;
  800240:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800244:	eb 3e                	jmp    800284 <_main+0x24c>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 56 24 80 00       	push   $0x802456
  80024e:	e8 4b 09 00 00       	call   800b9e <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
			Chose = 'n' ;
  800256:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  80025a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	50                   	push   %eax
  800262:	e8 68 04 00 00       	call   8006cf <cputchar>
  800267:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 0a                	push   $0xa
  80026f:	e8 5b 04 00 00       	call   8006cf <cputchar>
  800274:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	6a 0a                	push   $0xa
  80027c:	e8 4e 04 00 00       	call   8006cf <cputchar>
  800281:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_lock_cons();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800284:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800288:	74 06                	je     800290 <_main+0x258>
  80028a:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80028e:	75 b6                	jne    800246 <_main+0x20e>
			Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_unlock_cons();
  800290:	e8 77 18 00 00       	call   801b0c <sys_unlock_cons>

	} while (Chose == 'y');
  800295:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800299:	0f 84 a9 fd ff ff    	je     800048 <_main+0x10>

	//To indicate that it's completed successfully
	inctst();
  80029f:	e8 05 1c 00 00       	call   801ea9 <inctst>

}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ad:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002bb:	eb 33                	jmp    8002f0 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ca:	01 d0                	add    %edx,%eax
  8002cc:	8b 10                	mov    (%eax),%edx
  8002ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002d1:	40                   	inc    %eax
  8002d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	01 c8                	add    %ecx,%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	39 c2                	cmp    %eax,%edx
  8002e2:	7e 09                	jle    8002ed <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8002e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8002eb:	eb 0c                	jmp    8002f9 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002ed:	ff 45 f8             	incl   -0x8(%ebp)
  8002f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f3:	48                   	dec    %eax
  8002f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8002f7:	7f c4                	jg     8002bd <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8002f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8b 00                	mov    (%eax),%eax
  800315:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800322:	8b 45 08             	mov    0x8(%ebp),%eax
  800325:	01 c2                	add    %eax,%edx
  800327:	8b 45 10             	mov    0x10(%ebp),%eax
  80032a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	01 c8                	add    %ecx,%eax
  800336:	8b 00                	mov    (%eax),%eax
  800338:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80033a:	8b 45 10             	mov    0x10(%ebp),%eax
  80033d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80034c:	89 02                	mov    %eax,(%edx)
}
  80034e:	90                   	nop
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80035e:	eb 17                	jmp    800377 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800360:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800363:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	01 c2                	add    %eax,%edx
  80036f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800372:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	ff 45 fc             	incl   -0x4(%ebp)
  800377:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80037a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80037d:	7c e1                	jl     800360 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <InitializeIdentical>:

void InitializeIdentical(int *Elements, int NumOfElements)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80038f:	eb 1b                	jmp    8003ac <InitializeIdentical+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800391:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039b:	8b 45 08             	mov    0x8(%ebp),%eax
  80039e:	01 c2                	add    %eax,%edx
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a3:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003a6:	48                   	dec    %eax
  8003a7:	89 02                	mov    %eax,(%edx)
}

void InitializeIdentical(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	ff 45 fc             	incl   -0x4(%ebp)
  8003ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003b2:	7c dd                	jl     800391 <InitializeIdentical+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003b4:	90                   	nop
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c0:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003c5:	f7 e9                	imul   %ecx
  8003c7:	c1 f9 1f             	sar    $0x1f,%ecx
  8003ca:	89 d0                	mov    %edx,%eax
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (Repetition == 0)
  8003d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8003d5:	75 07                	jne    8003de <InitializeSemiRandom+0x27>
			Repetition = 3;
  8003d7:	c7 45 f8 03 00 00 00 	movl   $0x3,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e5:	eb 1e                	jmp    800405 <InitializeSemiRandom+0x4e>
	{
		Elements[i] = i % Repetition ;
  8003e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	99                   	cltd   
  8003fb:	f7 7d f8             	idivl  -0x8(%ebp)
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	89 01                	mov    %eax,(%ecx)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	if (Repetition == 0)
			Repetition = 3;
	for (i = 0 ; i < NumOfElements ; i++)
  800402:	ff 45 fc             	incl   -0x4(%ebp)
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80040b:	7c da                	jl     8003e7 <InitializeSemiRandom+0x30>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80040d:	90                   	nop
  80040e:	c9                   	leave  
  80040f:	c3                   	ret    

00800410 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800416:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80041d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800424:	eb 42                	jmp    800468 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800429:	99                   	cltd   
  80042a:	f7 7d f0             	idivl  -0x10(%ebp)
  80042d:	89 d0                	mov    %edx,%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	75 10                	jne    800443 <PrintElements+0x33>
			cprintf("\n");
  800433:	83 ec 0c             	sub    $0xc,%esp
  800436:	68 a0 22 80 00       	push   $0x8022a0
  80043b:	e8 5e 07 00 00       	call   800b9e <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	01 d0                	add    %edx,%eax
  800452:	8b 00                	mov    (%eax),%eax
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	50                   	push   %eax
  800458:	68 74 24 80 00       	push   $0x802474
  80045d:	e8 3c 07 00 00       	call   800b9e <cprintf>
  800462:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800465:	ff 45 f4             	incl   -0xc(%ebp)
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	48                   	dec    %eax
  80046c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80046f:	7f b5                	jg     800426 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	01 d0                	add    %edx,%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	50                   	push   %eax
  800486:	68 79 24 80 00       	push   $0x802479
  80048b:	e8 0e 07 00 00       	call   800b9e <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp

}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <MSort>:


void MSort(int* A, int p, int r)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004a2:	7d 54                	jge    8004f8 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	89 c2                	mov    %eax,%edx
  8004ae:	c1 ea 1f             	shr    $0x1f,%edx
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	d1 f8                	sar    %eax
  8004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004b8:	83 ec 04             	sub    $0x4,%esp
  8004bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	ff 75 08             	pushl  0x8(%ebp)
  8004c4:	e8 cd ff ff ff       	call   800496 <MSort>
  8004c9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004cf:	40                   	inc    %eax
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	ff 75 10             	pushl  0x10(%ebp)
  8004d6:	50                   	push   %eax
  8004d7:	ff 75 08             	pushl  0x8(%ebp)
  8004da:	e8 b7 ff ff ff       	call   800496 <MSort>
  8004df:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004e2:	ff 75 10             	pushl  0x10(%ebp)
  8004e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	e8 08 00 00 00       	call   8004fb <Merge>
  8004f3:	83 c4 10             	add    $0x10,%esp
  8004f6:	eb 01                	jmp    8004f9 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  8004f8:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <Merge>:

void Merge(int* A, int p, int q, int r)
{
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	83 ec 30             	sub    $0x30,%esp
	int leftCapacity = q - p + 1;
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	2b 45 0c             	sub    0xc(%ebp),%eax
  800507:	40                   	inc    %eax
  800508:	89 45 e8             	mov    %eax,-0x18(%ebp)

	int rightCapacity = r - q;
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	2b 45 10             	sub    0x10(%ebp),%eax
  800511:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int leftIndex = 0;
  800514:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int rightIndex = 0;
  80051b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	//int* Left = malloc(sizeof(int) * leftCapacity);
	int* Left = __Left ;
  800522:	c7 45 e0 60 30 80 00 	movl   $0x803060,-0x20(%ebp)
	int* Right = __Right;
  800529:	c7 45 dc 40 59 e3 00 	movl   $0xe35940,-0x24(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800530:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800537:	eb 2f                	jmp    800568 <Merge+0x6d>
	{
		Left[i] = A[p + i - 1];
  800539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80053c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800546:	01 c2                	add    %eax,%edx
  800548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80054e:	01 c8                	add    %ecx,%eax
  800550:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800555:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80055c:	8b 45 08             	mov    0x8(%ebp),%eax
  80055f:	01 c8                	add    %ecx,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800565:	ff 45 f4             	incl   -0xc(%ebp)
  800568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80056b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80056e:	7c c9                	jl     800539 <Merge+0x3e>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800570:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800577:	eb 2a                	jmp    8005a3 <Merge+0xa8>
	{
		Right[j] = A[q + j];
  800579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80057c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800586:	01 c2                	add    %eax,%edx
  800588:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80058e:	01 c8                	add    %ecx,%eax
  800590:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800597:	8b 45 08             	mov    0x8(%ebp),%eax
  80059a:	01 c8                	add    %ecx,%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005a0:	ff 45 f0             	incl   -0x10(%ebp)
  8005a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005a9:	7c ce                	jl     800579 <Merge+0x7e>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8005b1:	e9 0a 01 00 00       	jmp    8006c0 <Merge+0x1c5>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005b9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8005bc:	0f 8d 95 00 00 00    	jge    800657 <Merge+0x15c>
  8005c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c8:	0f 8d 89 00 00 00    	jge    800657 <Merge+0x15c>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005db:	01 d0                	add    %edx,%eax
  8005dd:	8b 10                	mov    (%eax),%edx
  8005df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ec:	01 c8                	add    %ecx,%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	39 c2                	cmp    %eax,%edx
  8005f2:	7d 33                	jge    800627 <Merge+0x12c>
			{
				A[k - 1] = Left[leftIndex++];
  8005f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005f7:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800612:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	01 d0                	add    %edx,%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800622:	e9 96 00 00 00       	jmp    8006bd <Merge+0x1c2>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80062a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80062f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800636:	8b 45 08             	mov    0x8(%ebp),%eax
  800639:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80063c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80063f:	8d 50 01             	lea    0x1(%eax),%edx
  800642:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800645:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	01 d0                	add    %edx,%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800655:	eb 66                	jmp    8006bd <Merge+0x1c2>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80065a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80065d:	7d 30                	jge    80068f <Merge+0x194>
		{
			A[k - 1] = Left[leftIndex++];
  80065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800662:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800667:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800674:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800677:	8d 50 01             	lea    0x1(%eax),%edx
  80067a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80067d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 01                	mov    %eax,(%ecx)
  80068d:	eb 2e                	jmp    8006bd <Merge+0x1c2>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  80068f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800692:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800697:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a7:	8d 50 01             	lea    0x1(%eax),%edx
  8006aa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8006ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b7:	01 d0                	add    %edx,%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006bd:	ff 45 ec             	incl   -0x14(%ebp)
  8006c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006c3:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006c6:	0f 8e ea fe ff ff    	jle    8005b6 <Merge+0xbb>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006df:	83 ec 0c             	sub    $0xc,%esp
  8006e2:	50                   	push   %eax
  8006e3:	e8 52 15 00 00       	call   801c3a <sys_cputc>
  8006e8:	83 c4 10             	add    $0x10,%esp
}
  8006eb:	90                   	nop
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getchar>:


int
getchar(void)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8006f4:	e8 e0 13 00 00       	call   801ad9 <sys_cgetc>
  8006f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8006fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8006ff:	c9                   	leave  
  800700:	c3                   	ret    

00800701 <iscons>:

int iscons(int fdnum)
{
  800701:	55                   	push   %ebp
  800702:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800704:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	57                   	push   %edi
  80070f:	56                   	push   %esi
  800710:	53                   	push   %ebx
  800711:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800714:	e8 52 16 00 00       	call   801d6b <sys_getenvindex>
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  80071c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80071f:	89 d0                	mov    %edx,%eax
  800721:	c1 e0 06             	shl    $0x6,%eax
  800724:	29 d0                	sub    %edx,%eax
  800726:	c1 e0 02             	shl    $0x2,%eax
  800729:	01 d0                	add    %edx,%eax
  80072b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800732:	01 c8                	add    %ecx,%eax
  800734:	c1 e0 03             	shl    $0x3,%eax
  800737:	01 d0                	add    %edx,%eax
  800739:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800740:	29 c2                	sub    %eax,%edx
  800742:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800749:	89 c2                	mov    %eax,%edx
  80074b:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800751:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800756:	a1 20 30 80 00       	mov    0x803020,%eax
  80075b:	8a 40 20             	mov    0x20(%eax),%al
  80075e:	84 c0                	test   %al,%al
  800760:	74 0d                	je     80076f <libmain+0x64>
		binaryname = myEnv->prog_name;
  800762:	a1 20 30 80 00       	mov    0x803020,%eax
  800767:	83 c0 20             	add    $0x20,%eax
  80076a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80076f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800773:	7e 0a                	jle    80077f <libmain+0x74>
		binaryname = argv[0];
  800775:	8b 45 0c             	mov    0xc(%ebp),%eax
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	ff 75 08             	pushl  0x8(%ebp)
  800788:	e8 ab f8 ff ff       	call   800038 <_main>
  80078d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800790:	a1 00 30 80 00       	mov    0x803000,%eax
  800795:	85 c0                	test   %eax,%eax
  800797:	0f 84 01 01 00 00    	je     80089e <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80079d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007a3:	bb 78 25 80 00       	mov    $0x802578,%ebx
  8007a8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8007ad:	89 c7                	mov    %eax,%edi
  8007af:	89 de                	mov    %ebx,%esi
  8007b1:	89 d1                	mov    %edx,%ecx
  8007b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8007b5:	8d 55 8a             	lea    -0x76(%ebp),%edx
  8007b8:	b9 56 00 00 00       	mov    $0x56,%ecx
  8007bd:	b0 00                	mov    $0x0,%al
  8007bf:	89 d7                	mov    %edx,%edi
  8007c1:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  8007ca:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	50                   	push   %eax
  8007d1:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	e8 c4 17 00 00       	call   801fa1 <sys_utilities>
  8007dd:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  8007e0:	e8 0d 13 00 00       	call   801af2 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8007e5:	83 ec 0c             	sub    $0xc,%esp
  8007e8:	68 98 24 80 00       	push   $0x802498
  8007ed:	e8 ac 03 00 00       	call   800b9e <cprintf>
  8007f2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8007f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	74 18                	je     800814 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8007fc:	e8 be 17 00 00       	call   801fbf <sys_get_optimal_num_faults>
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	50                   	push   %eax
  800805:	68 c0 24 80 00       	push   $0x8024c0
  80080a:	e8 8f 03 00 00       	call   800b9e <cprintf>
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	eb 59                	jmp    80086d <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800814:	a1 20 30 80 00       	mov    0x803020,%eax
  800819:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80081f:	a1 20 30 80 00       	mov    0x803020,%eax
  800824:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	52                   	push   %edx
  80082e:	50                   	push   %eax
  80082f:	68 e4 24 80 00       	push   $0x8024e4
  800834:	e8 65 03 00 00       	call   800b9e <cprintf>
  800839:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80083c:	a1 20 30 80 00       	mov    0x803020,%eax
  800841:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800847:	a1 20 30 80 00       	mov    0x803020,%eax
  80084c:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800852:	a1 20 30 80 00       	mov    0x803020,%eax
  800857:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80085d:	51                   	push   %ecx
  80085e:	52                   	push   %edx
  80085f:	50                   	push   %eax
  800860:	68 0c 25 80 00       	push   $0x80250c
  800865:	e8 34 03 00 00       	call   800b9e <cprintf>
  80086a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80086d:	a1 20 30 80 00       	mov    0x803020,%eax
  800872:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	50                   	push   %eax
  80087c:	68 64 25 80 00       	push   $0x802564
  800881:	e8 18 03 00 00       	call   800b9e <cprintf>
  800886:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800889:	83 ec 0c             	sub    $0xc,%esp
  80088c:	68 98 24 80 00       	push   $0x802498
  800891:	e8 08 03 00 00       	call   800b9e <cprintf>
  800896:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800899:	e8 6e 12 00 00       	call   801b0c <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80089e:	e8 1f 00 00 00       	call   8008c2 <exit>
}
  8008a3:	90                   	nop
  8008a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5f                   	pop    %edi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	6a 00                	push   $0x0
  8008b7:	e8 7b 14 00 00       	call   801d37 <sys_destroy_env>
  8008bc:	83 c4 10             	add    $0x10,%esp
}
  8008bf:	90                   	nop
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    

008008c2 <exit>:

void
exit(void)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008c8:	e8 d0 14 00 00       	call   801d9d <sys_exit_env>
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008d6:	8d 45 10             	lea    0x10(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008df:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008e4:	85 c0                	test   %eax,%eax
  8008e6:	74 16                	je     8008fe <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008e8:	a1 44 2d 14 01       	mov    0x1142d44,%eax
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	50                   	push   %eax
  8008f1:	68 dc 25 80 00       	push   $0x8025dc
  8008f6:	e8 a3 02 00 00       	call   800b9e <cprintf>
  8008fb:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8008fe:	a1 04 30 80 00       	mov    0x803004,%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	50                   	push   %eax
  80090d:	68 e4 25 80 00       	push   $0x8025e4
  800912:	6a 74                	push   $0x74
  800914:	e8 b2 02 00 00       	call   800bcb <cprintf_colored>
  800919:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  80091c:	8b 45 10             	mov    0x10(%ebp),%eax
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 f4             	pushl  -0xc(%ebp)
  800925:	50                   	push   %eax
  800926:	e8 04 02 00 00       	call   800b2f <vcprintf>
  80092b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80092e:	83 ec 08             	sub    $0x8,%esp
  800931:	6a 00                	push   $0x0
  800933:	68 0c 26 80 00       	push   $0x80260c
  800938:	e8 f2 01 00 00       	call   800b2f <vcprintf>
  80093d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800940:	e8 7d ff ff ff       	call   8008c2 <exit>

	// should not return here
	while (1) ;
  800945:	eb fe                	jmp    800945 <_panic+0x75>

00800947 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094d:	a1 20 30 80 00       	mov    0x803020,%eax
  800952:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	39 c2                	cmp    %eax,%edx
  80095d:	74 14                	je     800973 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095f:	83 ec 04             	sub    $0x4,%esp
  800962:	68 10 26 80 00       	push   $0x802610
  800967:	6a 26                	push   $0x26
  800969:	68 5c 26 80 00       	push   $0x80265c
  80096e:	e8 5d ff ff ff       	call   8008d0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800973:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80097a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800981:	e9 c5 00 00 00       	jmp    800a4b <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	85 c0                	test   %eax,%eax
  800999:	75 08                	jne    8009a3 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80099b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099e:	e9 a5 00 00 00       	jmp    800a48 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8009a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b1:	eb 69                	jmp    800a1c <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8009b8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c1:	89 d0                	mov    %edx,%eax
  8009c3:	01 c0                	add    %eax,%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	c1 e0 03             	shl    $0x3,%eax
  8009ca:	01 c8                	add    %ecx,%eax
  8009cc:	8a 40 04             	mov    0x4(%eax),%al
  8009cf:	84 c0                	test   %al,%al
  8009d1:	75 46                	jne    800a19 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d3:	a1 20 30 80 00       	mov    0x803020,%eax
  8009d8:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8009de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e1:	89 d0                	mov    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d0                	add    %edx,%eax
  8009e7:	c1 e0 03             	shl    $0x3,%eax
  8009ea:	01 c8                	add    %ecx,%eax
  8009ec:	8b 00                	mov    (%eax),%eax
  8009ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	01 c8                	add    %ecx,%eax
  800a0a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0c:	39 c2                	cmp    %eax,%edx
  800a0e:	75 09                	jne    800a19 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a10:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a17:	eb 15                	jmp    800a2e <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a19:	ff 45 e8             	incl   -0x18(%ebp)
  800a1c:	a1 20 30 80 00       	mov    0x803020,%eax
  800a21:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a2a:	39 c2                	cmp    %eax,%edx
  800a2c:	77 85                	ja     8009b3 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a32:	75 14                	jne    800a48 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800a34:	83 ec 04             	sub    $0x4,%esp
  800a37:	68 68 26 80 00       	push   $0x802668
  800a3c:	6a 3a                	push   $0x3a
  800a3e:	68 5c 26 80 00       	push   $0x80265c
  800a43:	e8 88 fe ff ff       	call   8008d0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a48:	ff 45 f0             	incl   -0x10(%ebp)
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a51:	0f 8c 2f ff ff ff    	jl     800986 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a65:	eb 26                	jmp    800a8d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a67:	a1 20 30 80 00       	mov    0x803020,%eax
  800a6c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800a72:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a75:	89 d0                	mov    %edx,%eax
  800a77:	01 c0                	add    %eax,%eax
  800a79:	01 d0                	add    %edx,%eax
  800a7b:	c1 e0 03             	shl    $0x3,%eax
  800a7e:	01 c8                	add    %ecx,%eax
  800a80:	8a 40 04             	mov    0x4(%eax),%al
  800a83:	3c 01                	cmp    $0x1,%al
  800a85:	75 03                	jne    800a8a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800a87:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8a:	ff 45 e0             	incl   -0x20(%ebp)
  800a8d:	a1 20 30 80 00       	mov    0x803020,%eax
  800a92:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a9b:	39 c2                	cmp    %eax,%edx
  800a9d:	77 c8                	ja     800a67 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aa2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aa5:	74 14                	je     800abb <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800aa7:	83 ec 04             	sub    $0x4,%esp
  800aaa:	68 bc 26 80 00       	push   $0x8026bc
  800aaf:	6a 44                	push   $0x44
  800ab1:	68 5c 26 80 00       	push   $0x80265c
  800ab6:	e8 15 fe ff ff       	call   8008d0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800abb:	90                   	nop
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	53                   	push   %ebx
  800ac2:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	8b 00                	mov    (%eax),%eax
  800aca:	8d 48 01             	lea    0x1(%eax),%ecx
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	89 0a                	mov    %ecx,(%edx)
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	88 d1                	mov    %dl,%cl
  800ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ada:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae8:	75 30                	jne    800b1a <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800aea:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800af0:	a0 60 04 b1 00       	mov    0xb10460,%al
  800af5:	0f b6 c0             	movzbl %al,%eax
  800af8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afb:	8b 09                	mov    (%ecx),%ecx
  800afd:	89 cb                	mov    %ecx,%ebx
  800aff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b02:	83 c1 08             	add    $0x8,%ecx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	53                   	push   %ebx
  800b08:	51                   	push   %ecx
  800b09:	e8 a0 0f 00 00       	call   801aae <sys_cputs>
  800b0e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8b 40 04             	mov    0x4(%eax),%eax
  800b20:	8d 50 01             	lea    0x1(%eax),%edx
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b29:	90                   	nop
  800b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b38:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b3f:	00 00 00 
	b.cnt = 0;
  800b42:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b49:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b4c:	ff 75 0c             	pushl  0xc(%ebp)
  800b4f:	ff 75 08             	pushl  0x8(%ebp)
  800b52:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b58:	50                   	push   %eax
  800b59:	68 be 0a 80 00       	push   $0x800abe
  800b5e:	e8 5a 02 00 00       	call   800dbd <vprintfmt>
  800b63:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800b66:	8b 15 48 2d 14 01    	mov    0x1142d48,%edx
  800b6c:	a0 60 04 b1 00       	mov    0xb10460,%al
  800b71:	0f b6 c0             	movzbl %al,%eax
  800b74:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800b7a:	52                   	push   %edx
  800b7b:	50                   	push   %eax
  800b7c:	51                   	push   %ecx
  800b7d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b83:	83 c0 08             	add    $0x8,%eax
  800b86:	50                   	push   %eax
  800b87:	e8 22 0f 00 00       	call   801aae <sys_cputs>
  800b8c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b8f:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
	return b.cnt;
  800b96:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b9c:	c9                   	leave  
  800b9d:	c3                   	ret    

00800b9e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ba4:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	va_start(ap, fmt);
  800bab:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb4:	83 ec 08             	sub    $0x8,%esp
  800bb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bba:	50                   	push   %eax
  800bbb:	e8 6f ff ff ff       	call   800b2f <vcprintf>
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bd1:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
	curTextClr = (textClr << 8) ; //set text color by the given value
  800bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdb:	c1 e0 08             	shl    $0x8,%eax
  800bde:	a3 48 2d 14 01       	mov    %eax,0x1142d48
	va_start(ap, fmt);
  800be3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be6:	83 c0 04             	add    $0x4,%eax
  800be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	83 ec 08             	sub    $0x8,%esp
  800bf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf5:	50                   	push   %eax
  800bf6:	e8 34 ff ff ff       	call   800b2f <vcprintf>
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c01:	c7 05 48 2d 14 01 00 	movl   $0x700,0x1142d48
  800c08:	07 00 00 

	return cnt;
  800c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c0e:	c9                   	leave  
  800c0f:	c3                   	ret    

00800c10 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c16:	e8 d7 0e 00 00       	call   801af2 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c1b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2a:	50                   	push   %eax
  800c2b:	e8 ff fe ff ff       	call   800b2f <vcprintf>
  800c30:	83 c4 10             	add    $0x10,%esp
  800c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800c36:	e8 d1 0e 00 00       	call   801b0c <sys_unlock_cons>
	return cnt;
  800c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	53                   	push   %ebx
  800c44:	83 ec 14             	sub    $0x14,%esp
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c53:	8b 45 18             	mov    0x18(%ebp),%eax
  800c56:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c5e:	77 55                	ja     800cb5 <printnum+0x75>
  800c60:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c63:	72 05                	jb     800c6a <printnum+0x2a>
  800c65:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c68:	77 4b                	ja     800cb5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c6a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c6d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c70:	8b 45 18             	mov    0x18(%ebp),%eax
  800c73:	ba 00 00 00 00       	mov    $0x0,%edx
  800c78:	52                   	push   %edx
  800c79:	50                   	push   %eax
  800c7a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c7d:	ff 75 f0             	pushl  -0x10(%ebp)
  800c80:	e8 ab 13 00 00       	call   802030 <__udivdi3>
  800c85:	83 c4 10             	add    $0x10,%esp
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	ff 75 20             	pushl  0x20(%ebp)
  800c8e:	53                   	push   %ebx
  800c8f:	ff 75 18             	pushl  0x18(%ebp)
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	ff 75 08             	pushl  0x8(%ebp)
  800c9a:	e8 a1 ff ff ff       	call   800c40 <printnum>
  800c9f:	83 c4 20             	add    $0x20,%esp
  800ca2:	eb 1a                	jmp    800cbe <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	ff 75 0c             	pushl  0xc(%ebp)
  800caa:	ff 75 20             	pushl  0x20(%ebp)
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800cb5:	ff 4d 1c             	decl   0x1c(%ebp)
  800cb8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800cbc:	7f e6                	jg     800ca4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cbe:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccc:	53                   	push   %ebx
  800ccd:	51                   	push   %ecx
  800cce:	52                   	push   %edx
  800ccf:	50                   	push   %eax
  800cd0:	e8 6b 14 00 00       	call   802140 <__umoddi3>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	05 34 29 80 00       	add    $0x802934,%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	0f be c0             	movsbl %al,%eax
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	50                   	push   %eax
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	ff d0                	call   *%eax
  800cee:	83 c4 10             	add    $0x10,%esp
}
  800cf1:	90                   	nop
  800cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cfa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cfe:	7e 1c                	jle    800d1c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8b 00                	mov    (%eax),%eax
  800d05:	8d 50 08             	lea    0x8(%eax),%edx
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	89 10                	mov    %edx,(%eax)
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	83 e8 08             	sub    $0x8,%eax
  800d15:	8b 50 04             	mov    0x4(%eax),%edx
  800d18:	8b 00                	mov    (%eax),%eax
  800d1a:	eb 40                	jmp    800d5c <getuint+0x65>
	else if (lflag)
  800d1c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d20:	74 1e                	je     800d40 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8b 00                	mov    (%eax),%eax
  800d27:	8d 50 04             	lea    0x4(%eax),%edx
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	89 10                	mov    %edx,(%eax)
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	83 e8 04             	sub    $0x4,%eax
  800d37:	8b 00                	mov    (%eax),%eax
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	eb 1c                	jmp    800d5c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	8d 50 04             	lea    0x4(%eax),%edx
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	89 10                	mov    %edx,(%eax)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	83 e8 04             	sub    $0x4,%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d61:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d65:	7e 1c                	jle    800d83 <getint+0x25>
		return va_arg(*ap, long long);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 08             	lea    0x8(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 08             	sub    $0x8,%eax
  800d7c:	8b 50 04             	mov    0x4(%eax),%edx
  800d7f:	8b 00                	mov    (%eax),%eax
  800d81:	eb 38                	jmp    800dbb <getint+0x5d>
	else if (lflag)
  800d83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d87:	74 1a                	je     800da3 <getint+0x45>
		return va_arg(*ap, long);
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8b 00                	mov    (%eax),%eax
  800d8e:	8d 50 04             	lea    0x4(%eax),%edx
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	89 10                	mov    %edx,(%eax)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8b 00                	mov    (%eax),%eax
  800d9b:	83 e8 04             	sub    $0x4,%eax
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	99                   	cltd   
  800da1:	eb 18                	jmp    800dbb <getint+0x5d>
	else
		return va_arg(*ap, int);
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8b 00                	mov    (%eax),%eax
  800da8:	8d 50 04             	lea    0x4(%eax),%edx
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	89 10                	mov    %edx,(%eax)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8b 00                	mov    (%eax),%eax
  800db5:	83 e8 04             	sub    $0x4,%eax
  800db8:	8b 00                	mov    (%eax),%eax
  800dba:	99                   	cltd   
}
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dc5:	eb 17                	jmp    800dde <vprintfmt+0x21>
			if (ch == '\0')
  800dc7:	85 db                	test   %ebx,%ebx
  800dc9:	0f 84 c1 03 00 00    	je     801190 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800dcf:	83 ec 08             	sub    $0x8,%esp
  800dd2:	ff 75 0c             	pushl  0xc(%ebp)
  800dd5:	53                   	push   %ebx
  800dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd9:	ff d0                	call   *%eax
  800ddb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dde:	8b 45 10             	mov    0x10(%ebp),%eax
  800de1:	8d 50 01             	lea    0x1(%eax),%edx
  800de4:	89 55 10             	mov    %edx,0x10(%ebp)
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	0f b6 d8             	movzbl %al,%ebx
  800dec:	83 fb 25             	cmp    $0x25,%ebx
  800def:	75 d6                	jne    800dc7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800df1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800df5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dfc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e03:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e0a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	8d 50 01             	lea    0x1(%eax),%edx
  800e17:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d8             	movzbl %al,%ebx
  800e1f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e22:	83 f8 5b             	cmp    $0x5b,%eax
  800e25:	0f 87 3d 03 00 00    	ja     801168 <vprintfmt+0x3ab>
  800e2b:	8b 04 85 58 29 80 00 	mov    0x802958(,%eax,4),%eax
  800e32:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e34:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e38:	eb d7                	jmp    800e11 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e3a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e3e:	eb d1                	jmp    800e11 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e4a:	89 d0                	mov    %edx,%eax
  800e4c:	c1 e0 02             	shl    $0x2,%eax
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	01 c0                	add    %eax,%eax
  800e53:	01 d8                	add    %ebx,%eax
  800e55:	83 e8 30             	sub    $0x30,%eax
  800e58:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e63:	83 fb 2f             	cmp    $0x2f,%ebx
  800e66:	7e 3e                	jle    800ea6 <vprintfmt+0xe9>
  800e68:	83 fb 39             	cmp    $0x39,%ebx
  800e6b:	7f 39                	jg     800ea6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e6d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e70:	eb d5                	jmp    800e47 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e72:	8b 45 14             	mov    0x14(%ebp),%eax
  800e75:	83 c0 04             	add    $0x4,%eax
  800e78:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7e:	83 e8 04             	sub    $0x4,%eax
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e86:	eb 1f                	jmp    800ea7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e8c:	79 83                	jns    800e11 <vprintfmt+0x54>
				width = 0;
  800e8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e95:	e9 77 ff ff ff       	jmp    800e11 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e9a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ea1:	e9 6b ff ff ff       	jmp    800e11 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ea6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ea7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eab:	0f 89 60 ff ff ff    	jns    800e11 <vprintfmt+0x54>
				width = precision, precision = -1;
  800eb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eb7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ebe:	e9 4e ff ff ff       	jmp    800e11 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ec3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ec6:	e9 46 ff ff ff       	jmp    800e11 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 c0 04             	add    $0x4,%eax
  800ed1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 e8 04             	sub    $0x4,%eax
  800eda:	8b 00                	mov    (%eax),%eax
  800edc:	83 ec 08             	sub    $0x8,%esp
  800edf:	ff 75 0c             	pushl  0xc(%ebp)
  800ee2:	50                   	push   %eax
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	ff d0                	call   *%eax
  800ee8:	83 c4 10             	add    $0x10,%esp
			break;
  800eeb:	e9 9b 02 00 00       	jmp    80118b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ef0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef3:	83 c0 04             	add    $0x4,%eax
  800ef6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef9:	8b 45 14             	mov    0x14(%ebp),%eax
  800efc:	83 e8 04             	sub    $0x4,%eax
  800eff:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f01:	85 db                	test   %ebx,%ebx
  800f03:	79 02                	jns    800f07 <vprintfmt+0x14a>
				err = -err;
  800f05:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f07:	83 fb 64             	cmp    $0x64,%ebx
  800f0a:	7f 0b                	jg     800f17 <vprintfmt+0x15a>
  800f0c:	8b 34 9d a0 27 80 00 	mov    0x8027a0(,%ebx,4),%esi
  800f13:	85 f6                	test   %esi,%esi
  800f15:	75 19                	jne    800f30 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f17:	53                   	push   %ebx
  800f18:	68 45 29 80 00       	push   $0x802945
  800f1d:	ff 75 0c             	pushl  0xc(%ebp)
  800f20:	ff 75 08             	pushl  0x8(%ebp)
  800f23:	e8 70 02 00 00       	call   801198 <printfmt>
  800f28:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f2b:	e9 5b 02 00 00       	jmp    80118b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f30:	56                   	push   %esi
  800f31:	68 4e 29 80 00       	push   $0x80294e
  800f36:	ff 75 0c             	pushl  0xc(%ebp)
  800f39:	ff 75 08             	pushl  0x8(%ebp)
  800f3c:	e8 57 02 00 00       	call   801198 <printfmt>
  800f41:	83 c4 10             	add    $0x10,%esp
			break;
  800f44:	e9 42 02 00 00       	jmp    80118b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 30                	mov    (%eax),%esi
  800f5a:	85 f6                	test   %esi,%esi
  800f5c:	75 05                	jne    800f63 <vprintfmt+0x1a6>
				p = "(null)";
  800f5e:	be 51 29 80 00       	mov    $0x802951,%esi
			if (width > 0 && padc != '-')
  800f63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f67:	7e 6d                	jle    800fd6 <vprintfmt+0x219>
  800f69:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f6d:	74 67                	je     800fd6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	50                   	push   %eax
  800f76:	56                   	push   %esi
  800f77:	e8 1e 03 00 00       	call   80129a <strnlen>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f82:	eb 16                	jmp    800f9a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f84:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	50                   	push   %eax
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f9e:	7f e4                	jg     800f84 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa0:	eb 34                	jmp    800fd6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800fa2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800fa6:	74 1c                	je     800fc4 <vprintfmt+0x207>
  800fa8:	83 fb 1f             	cmp    $0x1f,%ebx
  800fab:	7e 05                	jle    800fb2 <vprintfmt+0x1f5>
  800fad:	83 fb 7e             	cmp    $0x7e,%ebx
  800fb0:	7e 12                	jle    800fc4 <vprintfmt+0x207>
					putch('?', putdat);
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 0c             	pushl  0xc(%ebp)
  800fb8:	6a 3f                	push   $0x3f
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	ff d0                	call   *%eax
  800fbf:	83 c4 10             	add    $0x10,%esp
  800fc2:	eb 0f                	jmp    800fd3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	53                   	push   %ebx
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	ff d0                	call   *%eax
  800fd0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd3:	ff 4d e4             	decl   -0x1c(%ebp)
  800fd6:	89 f0                	mov    %esi,%eax
  800fd8:	8d 70 01             	lea    0x1(%eax),%esi
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be d8             	movsbl %al,%ebx
  800fe0:	85 db                	test   %ebx,%ebx
  800fe2:	74 24                	je     801008 <vprintfmt+0x24b>
  800fe4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fe8:	78 b8                	js     800fa2 <vprintfmt+0x1e5>
  800fea:	ff 4d e0             	decl   -0x20(%ebp)
  800fed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ff1:	79 af                	jns    800fa2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ff3:	eb 13                	jmp    801008 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ff5:	83 ec 08             	sub    $0x8,%esp
  800ff8:	ff 75 0c             	pushl  0xc(%ebp)
  800ffb:	6a 20                	push   $0x20
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	ff d0                	call   *%eax
  801002:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801005:	ff 4d e4             	decl   -0x1c(%ebp)
  801008:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80100c:	7f e7                	jg     800ff5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80100e:	e9 78 01 00 00       	jmp    80118b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801013:	83 ec 08             	sub    $0x8,%esp
  801016:	ff 75 e8             	pushl  -0x18(%ebp)
  801019:	8d 45 14             	lea    0x14(%ebp),%eax
  80101c:	50                   	push   %eax
  80101d:	e8 3c fd ff ff       	call   800d5e <getint>
  801022:	83 c4 10             	add    $0x10,%esp
  801025:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801028:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80102b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801031:	85 d2                	test   %edx,%edx
  801033:	79 23                	jns    801058 <vprintfmt+0x29b>
				putch('-', putdat);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	6a 2d                	push   $0x2d
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	ff d0                	call   *%eax
  801042:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80104b:	f7 d8                	neg    %eax
  80104d:	83 d2 00             	adc    $0x0,%edx
  801050:	f7 da                	neg    %edx
  801052:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801055:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801058:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80105f:	e9 bc 00 00 00       	jmp    801120 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801064:	83 ec 08             	sub    $0x8,%esp
  801067:	ff 75 e8             	pushl  -0x18(%ebp)
  80106a:	8d 45 14             	lea    0x14(%ebp),%eax
  80106d:	50                   	push   %eax
  80106e:	e8 84 fc ff ff       	call   800cf7 <getuint>
  801073:	83 c4 10             	add    $0x10,%esp
  801076:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801079:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80107c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801083:	e9 98 00 00 00       	jmp    801120 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801088:	83 ec 08             	sub    $0x8,%esp
  80108b:	ff 75 0c             	pushl  0xc(%ebp)
  80108e:	6a 58                	push   $0x58
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	ff d0                	call   *%eax
  801095:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801098:	83 ec 08             	sub    $0x8,%esp
  80109b:	ff 75 0c             	pushl  0xc(%ebp)
  80109e:	6a 58                	push   $0x58
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	ff d0                	call   *%eax
  8010a5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 58                	push   $0x58
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
			break;
  8010b8:	e9 ce 00 00 00       	jmp    80118b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 0c             	pushl  0xc(%ebp)
  8010c3:	6a 30                	push   $0x30
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010cd:	83 ec 08             	sub    $0x8,%esp
  8010d0:	ff 75 0c             	pushl  0xc(%ebp)
  8010d3:	6a 78                	push   $0x78
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	ff d0                	call   *%eax
  8010da:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e0:	83 c0 04             	add    $0x4,%eax
  8010e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8010e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e9:	83 e8 04             	sub    $0x4,%eax
  8010ec:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010f8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010ff:	eb 1f                	jmp    801120 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	ff 75 e8             	pushl  -0x18(%ebp)
  801107:	8d 45 14             	lea    0x14(%ebp),%eax
  80110a:	50                   	push   %eax
  80110b:	e8 e7 fb ff ff       	call   800cf7 <getuint>
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801116:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801119:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801120:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	52                   	push   %edx
  80112b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80112e:	50                   	push   %eax
  80112f:	ff 75 f4             	pushl  -0xc(%ebp)
  801132:	ff 75 f0             	pushl  -0x10(%ebp)
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	ff 75 08             	pushl  0x8(%ebp)
  80113b:	e8 00 fb ff ff       	call   800c40 <printnum>
  801140:	83 c4 20             	add    $0x20,%esp
			break;
  801143:	eb 46                	jmp    80118b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801145:	83 ec 08             	sub    $0x8,%esp
  801148:	ff 75 0c             	pushl  0xc(%ebp)
  80114b:	53                   	push   %ebx
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	ff d0                	call   *%eax
  801151:	83 c4 10             	add    $0x10,%esp
			break;
  801154:	eb 35                	jmp    80118b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801156:	c6 05 60 04 b1 00 00 	movb   $0x0,0xb10460
			break;
  80115d:	eb 2c                	jmp    80118b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80115f:	c6 05 60 04 b1 00 01 	movb   $0x1,0xb10460
			break;
  801166:	eb 23                	jmp    80118b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	6a 25                	push   $0x25
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	ff d0                	call   *%eax
  801175:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801178:	ff 4d 10             	decl   0x10(%ebp)
  80117b:	eb 03                	jmp    801180 <vprintfmt+0x3c3>
  80117d:	ff 4d 10             	decl   0x10(%ebp)
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	48                   	dec    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 25                	cmp    $0x25,%al
  801188:	75 f3                	jne    80117d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80118a:	90                   	nop
		}
	}
  80118b:	e9 35 fc ff ff       	jmp    800dc5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801190:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801191:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80119e:	8d 45 10             	lea    0x10(%ebp),%eax
  8011a1:	83 c0 04             	add    $0x4,%eax
  8011a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8011a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ad:	50                   	push   %eax
  8011ae:	ff 75 0c             	pushl  0xc(%ebp)
  8011b1:	ff 75 08             	pushl  0x8(%ebp)
  8011b4:	e8 04 fc ff ff       	call   800dbd <vprintfmt>
  8011b9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8011bc:	90                   	nop
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8b 40 08             	mov    0x8(%eax),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	8b 10                	mov    (%eax),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8b 40 04             	mov    0x4(%eax),%eax
  8011dc:	39 c2                	cmp    %eax,%edx
  8011de:	73 12                	jae    8011f2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	8b 00                	mov    (%eax),%eax
  8011e5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011eb:	89 0a                	mov    %ecx,(%edx)
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	88 10                	mov    %dl,(%eax)
}
  8011f2:	90                   	nop
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    

008011f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011f5:	55                   	push   %ebp
  8011f6:	89 e5                	mov    %esp,%ebp
  8011f8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	8d 50 ff             	lea    -0x1(%eax),%edx
  801207:	8b 45 08             	mov    0x8(%ebp),%eax
  80120a:	01 d0                	add    %edx,%eax
  80120c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80121a:	74 06                	je     801222 <vsnprintf+0x2d>
  80121c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801220:	7f 07                	jg     801229 <vsnprintf+0x34>
		return -E_INVAL;
  801222:	b8 03 00 00 00       	mov    $0x3,%eax
  801227:	eb 20                	jmp    801249 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801229:	ff 75 14             	pushl  0x14(%ebp)
  80122c:	ff 75 10             	pushl  0x10(%ebp)
  80122f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801232:	50                   	push   %eax
  801233:	68 bf 11 80 00       	push   $0x8011bf
  801238:	e8 80 fb ff ff       	call   800dbd <vprintfmt>
  80123d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801243:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801246:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801251:	8d 45 10             	lea    0x10(%ebp),%eax
  801254:	83 c0 04             	add    $0x4,%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	ff 75 f4             	pushl  -0xc(%ebp)
  801260:	50                   	push   %eax
  801261:	ff 75 0c             	pushl  0xc(%ebp)
  801264:	ff 75 08             	pushl  0x8(%ebp)
  801267:	e8 89 ff ff ff       	call   8011f5 <vsnprintf>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801272:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801275:	c9                   	leave  
  801276:	c3                   	ret    

00801277 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80127d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801284:	eb 06                	jmp    80128c <strlen+0x15>
		n++;
  801286:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801289:	ff 45 08             	incl   0x8(%ebp)
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	8a 00                	mov    (%eax),%al
  801291:	84 c0                	test   %al,%al
  801293:	75 f1                	jne    801286 <strlen+0xf>
		n++;
	return n;
  801295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a7:	eb 09                	jmp    8012b2 <strnlen+0x18>
		n++;
  8012a9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ac:	ff 45 08             	incl   0x8(%ebp)
  8012af:	ff 4d 0c             	decl   0xc(%ebp)
  8012b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b6:	74 09                	je     8012c1 <strnlen+0x27>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	75 e8                	jne    8012a9 <strnlen+0xf>
		n++;
	return n;
  8012c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012c4:	c9                   	leave  
  8012c5:	c3                   	ret    

008012c6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012d2:	90                   	nop
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012e5:	8a 12                	mov    (%edx),%dl
  8012e7:	88 10                	mov    %dl,(%eax)
  8012e9:	8a 00                	mov    (%eax),%al
  8012eb:	84 c0                	test   %al,%al
  8012ed:	75 e4                	jne    8012d3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801307:	eb 1f                	jmp    801328 <strncpy+0x34>
		*dst++ = *src;
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 08             	mov    %edx,0x8(%ebp)
  801312:	8b 55 0c             	mov    0xc(%ebp),%edx
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 03                	je     801325 <strncpy+0x31>
			src++;
  801322:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80132e:	72 d9                	jb     801309 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801330:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801341:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801345:	74 30                	je     801377 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801347:	eb 16                	jmp    80135f <strlcpy+0x2a>
			*dst++ = *src++;
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8d 50 01             	lea    0x1(%eax),%edx
  80134f:	89 55 08             	mov    %edx,0x8(%ebp)
  801352:	8b 55 0c             	mov    0xc(%ebp),%edx
  801355:	8d 4a 01             	lea    0x1(%edx),%ecx
  801358:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80135b:	8a 12                	mov    (%edx),%dl
  80135d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80135f:	ff 4d 10             	decl   0x10(%ebp)
  801362:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801366:	74 09                	je     801371 <strlcpy+0x3c>
  801368:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136b:	8a 00                	mov    (%eax),%al
  80136d:	84 c0                	test   %al,%al
  80136f:	75 d8                	jne    801349 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801377:	8b 55 08             	mov    0x8(%ebp),%edx
  80137a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137d:	29 c2                	sub    %eax,%edx
  80137f:	89 d0                	mov    %edx,%eax
}
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801386:	eb 06                	jmp    80138e <strcmp+0xb>
		p++, q++;
  801388:	ff 45 08             	incl   0x8(%ebp)
  80138b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8a 00                	mov    (%eax),%al
  801393:	84 c0                	test   %al,%al
  801395:	74 0e                	je     8013a5 <strcmp+0x22>
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 10                	mov    (%eax),%dl
  80139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	38 c2                	cmp    %al,%dl
  8013a3:	74 e3                	je     801388 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013be:	eb 09                	jmp    8013c9 <strncmp+0xe>
		n--, p++, q++;
  8013c0:	ff 4d 10             	decl   0x10(%ebp)
  8013c3:	ff 45 08             	incl   0x8(%ebp)
  8013c6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013cd:	74 17                	je     8013e6 <strncmp+0x2b>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	84 c0                	test   %al,%al
  8013d6:	74 0e                	je     8013e6 <strncmp+0x2b>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	8a 10                	mov    (%eax),%dl
  8013dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e0:	8a 00                	mov    (%eax),%al
  8013e2:	38 c2                	cmp    %al,%dl
  8013e4:	74 da                	je     8013c0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ea:	75 07                	jne    8013f3 <strncmp+0x38>
		return 0;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	eb 14                	jmp    801407 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	8a 00                	mov    (%eax),%al
  8013f8:	0f b6 d0             	movzbl %al,%edx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 c0             	movzbl %al,%eax
  801403:	29 c2                	sub    %eax,%edx
  801405:	89 d0                	mov    %edx,%eax
}
  801407:	5d                   	pop    %ebp
  801408:	c3                   	ret    

00801409 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801412:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801415:	eb 12                	jmp    801429 <strchr+0x20>
		if (*s == c)
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141f:	75 05                	jne    801426 <strchr+0x1d>
			return (char *) s;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	eb 11                	jmp    801437 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801426:	ff 45 08             	incl   0x8(%ebp)
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	84 c0                	test   %al,%al
  801430:	75 e5                	jne    801417 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801437:	c9                   	leave  
  801438:	c3                   	ret    

00801439 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801442:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801445:	eb 0d                	jmp    801454 <strfind+0x1b>
		if (*s == c)
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80144f:	74 0e                	je     80145f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801451:	ff 45 08             	incl   0x8(%ebp)
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 ea                	jne    801447 <strfind+0xe>
  80145d:	eb 01                	jmp    801460 <strfind+0x27>
		if (*s == c)
			break;
  80145f:	90                   	nop
	return (char *) s;
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801471:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801475:	76 63                	jbe    8014da <memset+0x75>
		uint64 data_block = c;
  801477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147a:	99                   	cltd   
  80147b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147e:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801487:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  80148b:	c1 e0 08             	shl    $0x8,%eax
  80148e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801491:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149a:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80149e:	c1 e0 10             	shl    $0x10,%eax
  8014a1:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014a4:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ad:	89 c2                	mov    %eax,%edx
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b4:	09 45 f0             	or     %eax,-0x10(%ebp)
  8014b7:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  8014ba:	eb 18                	jmp    8014d4 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  8014bc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014bf:	8d 41 08             	lea    0x8(%ecx),%eax
  8014c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cb:	89 01                	mov    %eax,(%ecx)
  8014cd:	89 51 04             	mov    %edx,0x4(%ecx)
  8014d0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  8014d4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014d8:	77 e2                	ja     8014bc <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  8014da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014de:	74 23                	je     801503 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014e6:	eb 0e                	jmp    8014f6 <memset+0x91>
			*p8++ = (uint8)c;
  8014e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014eb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  8014f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ff:	85 c0                	test   %eax,%eax
  801501:	75 e5                	jne    8014e8 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  80150e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801511:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  80151a:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80151e:	76 24                	jbe    801544 <memcpy+0x3c>
		while(n >= 8){
  801520:	eb 1c                	jmp    80153e <memcpy+0x36>
			*d64 = *s64;
  801522:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801525:	8b 50 04             	mov    0x4(%eax),%edx
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80152d:	89 01                	mov    %eax,(%ecx)
  80152f:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801532:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801536:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  80153a:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  80153e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801542:	77 de                	ja     801522 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801544:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801548:	74 31                	je     80157b <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  80154a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  801550:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801553:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  801556:	eb 16                	jmp    80156e <memcpy+0x66>
			*d8++ = *s8++;
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	8d 50 01             	lea    0x1(%eax),%edx
  80155e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  801561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801564:	8d 4a 01             	lea    0x1(%edx),%ecx
  801567:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80156a:	8a 12                	mov    (%edx),%dl
  80156c:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80156e:	8b 45 10             	mov    0x10(%ebp),%eax
  801571:	8d 50 ff             	lea    -0x1(%eax),%edx
  801574:	89 55 10             	mov    %edx,0x10(%ebp)
  801577:	85 c0                	test   %eax,%eax
  801579:	75 dd                	jne    801558 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801586:	8b 45 0c             	mov    0xc(%ebp),%eax
  801589:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801592:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801595:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801598:	73 50                	jae    8015ea <memmove+0x6a>
  80159a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159d:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a0:	01 d0                	add    %edx,%eax
  8015a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015a5:	76 43                	jbe    8015ea <memmove+0x6a>
		s += n;
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b0:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015b3:	eb 10                	jmp    8015c5 <memmove+0x45>
			*--d = *--s;
  8015b5:	ff 4d f8             	decl   -0x8(%ebp)
  8015b8:	ff 4d fc             	decl   -0x4(%ebp)
  8015bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015be:	8a 10                	mov    (%eax),%dl
  8015c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c3:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	75 e3                	jne    8015b5 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015d2:	eb 23                	jmp    8015f7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d7:	8d 50 01             	lea    0x1(%eax),%edx
  8015da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015e6:	8a 12                	mov    (%edx),%dl
  8015e8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	75 dd                	jne    8015d4 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801608:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160b:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80160e:	eb 2a                	jmp    80163a <memcmp+0x3e>
		if (*s1 != *s2)
  801610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801613:	8a 10                	mov    (%eax),%dl
  801615:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	38 c2                	cmp    %al,%dl
  80161c:	74 16                	je     801634 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80161e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801621:	8a 00                	mov    (%eax),%al
  801623:	0f b6 d0             	movzbl %al,%edx
  801626:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801629:	8a 00                	mov    (%eax),%al
  80162b:	0f b6 c0             	movzbl %al,%eax
  80162e:	29 c2                	sub    %eax,%edx
  801630:	89 d0                	mov    %edx,%eax
  801632:	eb 18                	jmp    80164c <memcmp+0x50>
		s1++, s2++;
  801634:	ff 45 fc             	incl   -0x4(%ebp)
  801637:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80163a:	8b 45 10             	mov    0x10(%ebp),%eax
  80163d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801640:	89 55 10             	mov    %edx,0x10(%ebp)
  801643:	85 c0                	test   %eax,%eax
  801645:	75 c9                	jne    801610 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801654:	8b 55 08             	mov    0x8(%ebp),%edx
  801657:	8b 45 10             	mov    0x10(%ebp),%eax
  80165a:	01 d0                	add    %edx,%eax
  80165c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80165f:	eb 15                	jmp    801676 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8a 00                	mov    (%eax),%al
  801666:	0f b6 d0             	movzbl %al,%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	0f b6 c0             	movzbl %al,%eax
  80166f:	39 c2                	cmp    %eax,%edx
  801671:	74 0d                	je     801680 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801673:	ff 45 08             	incl   0x8(%ebp)
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80167c:	72 e3                	jb     801661 <memfind+0x13>
  80167e:	eb 01                	jmp    801681 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801680:	90                   	nop
	return (void *) s;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80168c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801693:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80169a:	eb 03                	jmp    80169f <strtol+0x19>
		s++;
  80169c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	3c 20                	cmp    $0x20,%al
  8016a6:	74 f4                	je     80169c <strtol+0x16>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	3c 09                	cmp    $0x9,%al
  8016af:	74 eb                	je     80169c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8a 00                	mov    (%eax),%al
  8016b6:	3c 2b                	cmp    $0x2b,%al
  8016b8:	75 05                	jne    8016bf <strtol+0x39>
		s++;
  8016ba:	ff 45 08             	incl   0x8(%ebp)
  8016bd:	eb 13                	jmp    8016d2 <strtol+0x4c>
	else if (*s == '-')
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	3c 2d                	cmp    $0x2d,%al
  8016c6:	75 0a                	jne    8016d2 <strtol+0x4c>
		s++, neg = 1;
  8016c8:	ff 45 08             	incl   0x8(%ebp)
  8016cb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d6:	74 06                	je     8016de <strtol+0x58>
  8016d8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016dc:	75 20                	jne    8016fe <strtol+0x78>
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 30                	cmp    $0x30,%al
  8016e5:	75 17                	jne    8016fe <strtol+0x78>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	40                   	inc    %eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 78                	cmp    $0x78,%al
  8016ef:	75 0d                	jne    8016fe <strtol+0x78>
		s += 2, base = 16;
  8016f1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8016f5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016fc:	eb 28                	jmp    801726 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801702:	75 15                	jne    801719 <strtol+0x93>
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	3c 30                	cmp    $0x30,%al
  80170b:	75 0c                	jne    801719 <strtol+0x93>
		s++, base = 8;
  80170d:	ff 45 08             	incl   0x8(%ebp)
  801710:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801717:	eb 0d                	jmp    801726 <strtol+0xa0>
	else if (base == 0)
  801719:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171d:	75 07                	jne    801726 <strtol+0xa0>
		base = 10;
  80171f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	3c 2f                	cmp    $0x2f,%al
  80172d:	7e 19                	jle    801748 <strtol+0xc2>
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8a 00                	mov    (%eax),%al
  801734:	3c 39                	cmp    $0x39,%al
  801736:	7f 10                	jg     801748 <strtol+0xc2>
			dig = *s - '0';
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	0f be c0             	movsbl %al,%eax
  801740:	83 e8 30             	sub    $0x30,%eax
  801743:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801746:	eb 42                	jmp    80178a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	8a 00                	mov    (%eax),%al
  80174d:	3c 60                	cmp    $0x60,%al
  80174f:	7e 19                	jle    80176a <strtol+0xe4>
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	8a 00                	mov    (%eax),%al
  801756:	3c 7a                	cmp    $0x7a,%al
  801758:	7f 10                	jg     80176a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8a 00                	mov    (%eax),%al
  80175f:	0f be c0             	movsbl %al,%eax
  801762:	83 e8 57             	sub    $0x57,%eax
  801765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801768:	eb 20                	jmp    80178a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	3c 40                	cmp    $0x40,%al
  801771:	7e 39                	jle    8017ac <strtol+0x126>
  801773:	8b 45 08             	mov    0x8(%ebp),%eax
  801776:	8a 00                	mov    (%eax),%al
  801778:	3c 5a                	cmp    $0x5a,%al
  80177a:	7f 30                	jg     8017ac <strtol+0x126>
			dig = *s - 'A' + 10;
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8a 00                	mov    (%eax),%al
  801781:	0f be c0             	movsbl %al,%eax
  801784:	83 e8 37             	sub    $0x37,%eax
  801787:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801790:	7d 19                	jge    8017ab <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801792:	ff 45 08             	incl   0x8(%ebp)
  801795:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801798:	0f af 45 10          	imul   0x10(%ebp),%eax
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017a6:	e9 7b ff ff ff       	jmp    801726 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017ab:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017b0:	74 08                	je     8017ba <strtol+0x134>
		*endptr = (char *) s;
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b8:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017be:	74 07                	je     8017c7 <strtol+0x141>
  8017c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c3:	f7 d8                	neg    %eax
  8017c5:	eb 03                	jmp    8017ca <strtol+0x144>
  8017c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <ltostr>:

void
ltostr(long value, char *str)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017e4:	79 13                	jns    8017f9 <ltostr+0x2d>
	{
		neg = 1;
  8017e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8017ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8017f3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8017f6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801801:	99                   	cltd   
  801802:	f7 f9                	idiv   %ecx
  801804:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801807:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180a:	8d 50 01             	lea    0x1(%eax),%edx
  80180d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801810:	89 c2                	mov    %eax,%edx
  801812:	8b 45 0c             	mov    0xc(%ebp),%eax
  801815:	01 d0                	add    %edx,%eax
  801817:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80181a:	83 c2 30             	add    $0x30,%edx
  80181d:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80181f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801822:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801827:	f7 e9                	imul   %ecx
  801829:	c1 fa 02             	sar    $0x2,%edx
  80182c:	89 c8                	mov    %ecx,%eax
  80182e:	c1 f8 1f             	sar    $0x1f,%eax
  801831:	29 c2                	sub    %eax,%edx
  801833:	89 d0                	mov    %edx,%eax
  801835:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801838:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80183c:	75 bb                	jne    8017f9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80183e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801845:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801848:	48                   	dec    %eax
  801849:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80184c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801850:	74 3d                	je     80188f <ltostr+0xc3>
		start = 1 ;
  801852:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801859:	eb 34                	jmp    80188f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80185b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	01 d0                	add    %edx,%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186e:	01 c2                	add    %eax,%edx
  801870:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	01 c8                	add    %ecx,%eax
  801878:	8a 00                	mov    (%eax),%al
  80187a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80187c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80187f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801882:	01 c2                	add    %eax,%edx
  801884:	8a 45 eb             	mov    -0x15(%ebp),%al
  801887:	88 02                	mov    %al,(%edx)
		start++ ;
  801889:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80188c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801895:	7c c4                	jl     80185b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801897:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	01 d0                	add    %edx,%eax
  80189f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	e8 c4 f9 ff ff       	call   801277 <strlen>
  8018b3:	83 c4 04             	add    $0x4,%esp
  8018b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 b6 f9 ff ff       	call   801277 <strlen>
  8018c1:	83 c4 04             	add    $0x4,%esp
  8018c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8018ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018d5:	eb 17                	jmp    8018ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8018d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018da:	8b 45 10             	mov    0x10(%ebp),%eax
  8018dd:	01 c2                	add    %eax,%edx
  8018df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	01 c8                	add    %ecx,%eax
  8018e7:	8a 00                	mov    (%eax),%al
  8018e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018eb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018f4:	7c e1                	jl     8018d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801904:	eb 1f                	jmp    801925 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801906:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801909:	8d 50 01             	lea    0x1(%eax),%edx
  80190c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80190f:	89 c2                	mov    %eax,%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 c2                	add    %eax,%edx
  801916:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191c:	01 c8                	add    %ecx,%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801922:	ff 45 f8             	incl   -0x8(%ebp)
  801925:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801928:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80192b:	7c d9                	jl     801906 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	c6 00 00             	movb   $0x0,(%eax)
}
  801938:	90                   	nop
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80193e:	8b 45 14             	mov    0x14(%ebp),%eax
  801941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801947:	8b 45 14             	mov    0x14(%ebp),%eax
  80194a:	8b 00                	mov    (%eax),%eax
  80194c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
  801956:	01 d0                	add    %edx,%eax
  801958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80195e:	eb 0c                	jmp    80196c <strsplit+0x31>
			*string++ = 0;
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8d 50 01             	lea    0x1(%eax),%edx
  801966:	89 55 08             	mov    %edx,0x8(%ebp)
  801969:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	84 c0                	test   %al,%al
  801973:	74 18                	je     80198d <strsplit+0x52>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	0f be c0             	movsbl %al,%eax
  80197d:	50                   	push   %eax
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	e8 83 fa ff ff       	call   801409 <strchr>
  801986:	83 c4 08             	add    $0x8,%esp
  801989:	85 c0                	test   %eax,%eax
  80198b:	75 d3                	jne    801960 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	8a 00                	mov    (%eax),%al
  801992:	84 c0                	test   %al,%al
  801994:	74 5a                	je     8019f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801996:	8b 45 14             	mov    0x14(%ebp),%eax
  801999:	8b 00                	mov    (%eax),%eax
  80199b:	83 f8 0f             	cmp    $0xf,%eax
  80199e:	75 07                	jne    8019a7 <strsplit+0x6c>
		{
			return 0;
  8019a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a5:	eb 66                	jmp    801a0d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019aa:	8b 00                	mov    (%eax),%eax
  8019ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8019af:	8b 55 14             	mov    0x14(%ebp),%edx
  8019b2:	89 0a                	mov    %ecx,(%edx)
  8019b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019be:	01 c2                	add    %eax,%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019c5:	eb 03                	jmp    8019ca <strsplit+0x8f>
			string++;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8a 00                	mov    (%eax),%al
  8019cf:	84 c0                	test   %al,%al
  8019d1:	74 8b                	je     80195e <strsplit+0x23>
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	8a 00                	mov    (%eax),%al
  8019d8:	0f be c0             	movsbl %al,%eax
  8019db:	50                   	push   %eax
  8019dc:	ff 75 0c             	pushl  0xc(%ebp)
  8019df:	e8 25 fa ff ff       	call   801409 <strchr>
  8019e4:	83 c4 08             	add    $0x8,%esp
  8019e7:	85 c0                	test   %eax,%eax
  8019e9:	74 dc                	je     8019c7 <strsplit+0x8c>
			string++;
	}
  8019eb:	e9 6e ff ff ff       	jmp    80195e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f4:	8b 00                	mov    (%eax),%eax
  8019f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801a00:	01 d0                	add    %edx,%eax
  801a02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a08:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a22:	eb 4a                	jmp    801a6e <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a24:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	01 c2                	add    %eax,%edx
  801a2c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a32:	01 c8                	add    %ecx,%eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801a38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3e:	01 d0                	add    %edx,%eax
  801a40:	8a 00                	mov    (%eax),%al
  801a42:	3c 40                	cmp    $0x40,%al
  801a44:	7e 25                	jle    801a6b <str2lower+0x5c>
  801a46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	01 d0                	add    %edx,%eax
  801a4e:	8a 00                	mov    (%eax),%al
  801a50:	3c 5a                	cmp    $0x5a,%al
  801a52:	7f 17                	jg     801a6b <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801a54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 d0                	add    %edx,%eax
  801a5c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a62:	01 ca                	add    %ecx,%edx
  801a64:	8a 12                	mov    (%edx),%dl
  801a66:	83 c2 20             	add    $0x20,%edx
  801a69:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801a6b:	ff 45 fc             	incl   -0x4(%ebp)
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	e8 01 f8 ff ff       	call   801277 <strlen>
  801a76:	83 c4 04             	add    $0x4,%esp
  801a79:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7c:	7f a6                	jg     801a24 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	57                   	push   %edi
  801a87:	56                   	push   %esi
  801a88:	53                   	push   %ebx
  801a89:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a98:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a9b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a9e:	cd 30                	int    $0x30
  801aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5e                   	pop    %esi
  801aab:	5f                   	pop    %edi
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    

00801aae <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  801aba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	51                   	push   %ecx
  801ac7:	52                   	push   %edx
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	50                   	push   %eax
  801acc:	6a 00                	push   $0x0
  801ace:	e8 b0 ff ff ff       	call   801a83 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 02                	push   $0x2
  801ae8:	e8 96 ff ff ff       	call   801a83 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 03                	push   $0x3
  801b01:	e8 7d ff ff ff       	call   801a83 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 04                	push   $0x4
  801b1b:	e8 63 ff ff ff       	call   801a83 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 08                	push   $0x8
  801b39:	e8 45 ff ff ff       	call   801a83 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b48:	8b 75 18             	mov    0x18(%ebp),%esi
  801b4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 09                	push   $0x9
  801b5e:	e8 20 ff ff ff       	call   801a83 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 0a                	push   $0xa
  801b7d:	e8 01 ff ff ff       	call   801a83 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	6a 0b                	push   $0xb
  801b98:	e8 e6 fe ff ff       	call   801a83 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 0c                	push   $0xc
  801bb1:	e8 cd fe ff ff       	call   801a83 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 0d                	push   $0xd
  801bca:	e8 b4 fe ff ff       	call   801a83 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 0e                	push   $0xe
  801be3:	e8 9b fe ff ff       	call   801a83 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 0f                	push   $0xf
  801bfc:	e8 82 fe ff ff       	call   801a83 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	6a 10                	push   $0x10
  801c16:	e8 68 fe ff ff       	call   801a83 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 11                	push   $0x11
  801c2f:	e8 4f fe ff ff       	call   801a83 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_cputc>:

void
sys_cputc(const char c)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 04             	sub    $0x4,%esp
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c46:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	50                   	push   %eax
  801c53:	6a 01                	push   $0x1
  801c55:	e8 29 fe ff ff       	call   801a83 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	90                   	nop
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 14                	push   $0x14
  801c6f:	e8 0f fe ff ff       	call   801a83 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	90                   	nop
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
  801c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	51                   	push   %ecx
  801c93:	52                   	push   %edx
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	50                   	push   %eax
  801c98:	6a 15                	push   $0x15
  801c9a:	e8 e4 fd ff ff       	call   801a83 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 16                	push   $0x16
  801cb7:	e8 c7 fd ff ff       	call   801a83 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	51                   	push   %ecx
  801cd2:	52                   	push   %edx
  801cd3:	50                   	push   %eax
  801cd4:	6a 17                	push   $0x17
  801cd6:	e8 a8 fd ff ff       	call   801a83 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 18                	push   $0x18
  801cf3:	e8 8b fd ff ff       	call   801a83 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	ff 75 14             	pushl  0x14(%ebp)
  801d08:	ff 75 10             	pushl  0x10(%ebp)
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	50                   	push   %eax
  801d0f:	6a 19                	push   $0x19
  801d11:	e8 6d fd ff ff       	call   801a83 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_run_env>:

void sys_run_env(int32 envId)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	50                   	push   %eax
  801d2a:	6a 1a                	push   $0x1a
  801d2c:	e8 52 fd ff ff       	call   801a83 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	90                   	nop
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	50                   	push   %eax
  801d46:	6a 1b                	push   $0x1b
  801d48:	e8 36 fd ff ff       	call   801a83 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 05                	push   $0x5
  801d61:	e8 1d fd ff ff       	call   801a83 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 06                	push   $0x6
  801d7a:	e8 04 fd ff ff       	call   801a83 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 07                	push   $0x7
  801d93:	e8 eb fc ff ff       	call   801a83 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_exit_env>:


void sys_exit_env(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 1c                	push   $0x1c
  801dac:	e8 d2 fc ff ff       	call   801a83 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dbd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dc0:	8d 50 04             	lea    0x4(%eax),%edx
  801dc3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 1d                	push   $0x1d
  801dd0:	e8 ae fc ff ff       	call   801a83 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return result;
  801dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801de1:	89 01                	mov    %eax,(%ecx)
  801de3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	c9                   	leave  
  801dea:	c2 04 00             	ret    $0x4

00801ded <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	6a 13                	push   $0x13
  801dff:	e8 7f fc ff ff       	call   801a83 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
	return ;
  801e07:	90                   	nop
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 1e                	push   $0x1e
  801e19:	e8 65 fc ff ff       	call   801a83 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e2f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	50                   	push   %eax
  801e3c:	6a 1f                	push   $0x1f
  801e3e:	e8 40 fc ff ff       	call   801a83 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <rsttst>:
void rsttst()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 21                	push   $0x21
  801e58:	e8 26 fc ff ff       	call   801a83 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 04             	sub    $0x4,%esp
  801e69:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e6f:	8b 55 18             	mov    0x18(%ebp),%edx
  801e72:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	ff 75 10             	pushl  0x10(%ebp)
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 20                	push   $0x20
  801e83:	e8 fb fb ff ff       	call   801a83 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <chktst>:
void chktst(uint32 n)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	ff 75 08             	pushl  0x8(%ebp)
  801e9c:	6a 22                	push   $0x22
  801e9e:	e8 e0 fb ff ff       	call   801a83 <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea6:	90                   	nop
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <inctst>:

void inctst()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 23                	push   $0x23
  801eb8:	e8 c6 fb ff ff       	call   801a83 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <gettst>:
uint32 gettst()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 24                	push   $0x24
  801ed2:	e8 ac fb ff ff       	call   801a83 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 25                	push   $0x25
  801eeb:	e8 93 fb ff ff       	call   801a83 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
  801ef3:	a3 80 84 b2 00       	mov    %eax,0xb28480
	return uheapPlaceStrategy ;
  801ef8:	a1 80 84 b2 00       	mov    0xb28480,%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	a3 80 84 b2 00       	mov    %eax,0xb28480
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	6a 26                	push   $0x26
  801f17:	e8 67 fb ff ff       	call   801a83 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	53                   	push   %ebx
  801f35:	51                   	push   %ecx
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 27                	push   $0x27
  801f3a:	e8 44 fb ff ff       	call   801a83 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 28                	push   $0x28
  801f5a:	e8 24 fb ff ff       	call   801a83 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f67:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	6a 00                	push   $0x0
  801f72:	51                   	push   %ecx
  801f73:	ff 75 10             	pushl  0x10(%ebp)
  801f76:	52                   	push   %edx
  801f77:	50                   	push   %eax
  801f78:	6a 29                	push   $0x29
  801f7a:	e8 04 fb ff ff       	call   801a83 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	ff 75 10             	pushl  0x10(%ebp)
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	6a 12                	push   $0x12
  801f96:	e8 e8 fa ff ff       	call   801a83 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	52                   	push   %edx
  801fb1:	50                   	push   %eax
  801fb2:	6a 2a                	push   $0x2a
  801fb4:	e8 ca fa ff ff       	call   801a83 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
	return;
  801fbc:	90                   	nop
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 2b                	push   $0x2b
  801fce:	e8 b0 fa ff ff       	call   801a83 <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	ff 75 0c             	pushl  0xc(%ebp)
  801fe4:	ff 75 08             	pushl  0x8(%ebp)
  801fe7:	6a 2d                	push   $0x2d
  801fe9:	e8 95 fa ff ff       	call   801a83 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
	return;
  801ff1:	90                   	nop
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	ff 75 08             	pushl  0x8(%ebp)
  802003:	6a 2c                	push   $0x2c
  802005:	e8 79 fa ff ff       	call   801a83 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
	return ;
  80200d:	90                   	nop
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	68 c8 2a 80 00       	push   $0x802ac8
  80201e:	68 25 01 00 00       	push   $0x125
  802023:	68 fb 2a 80 00       	push   $0x802afb
  802028:	e8 a3 e8 ff ff       	call   8008d0 <_panic>
  80202d:	66 90                	xchg   %ax,%ax
  80202f:	90                   	nop

00802030 <__udivdi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80203b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80203f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802047:	89 ca                	mov    %ecx,%edx
  802049:	89 f8                	mov    %edi,%eax
  80204b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80204f:	85 f6                	test   %esi,%esi
  802051:	75 2d                	jne    802080 <__udivdi3+0x50>
  802053:	39 cf                	cmp    %ecx,%edi
  802055:	77 65                	ja     8020bc <__udivdi3+0x8c>
  802057:	89 fd                	mov    %edi,%ebp
  802059:	85 ff                	test   %edi,%edi
  80205b:	75 0b                	jne    802068 <__udivdi3+0x38>
  80205d:	b8 01 00 00 00       	mov    $0x1,%eax
  802062:	31 d2                	xor    %edx,%edx
  802064:	f7 f7                	div    %edi
  802066:	89 c5                	mov    %eax,%ebp
  802068:	31 d2                	xor    %edx,%edx
  80206a:	89 c8                	mov    %ecx,%eax
  80206c:	f7 f5                	div    %ebp
  80206e:	89 c1                	mov    %eax,%ecx
  802070:	89 d8                	mov    %ebx,%eax
  802072:	f7 f5                	div    %ebp
  802074:	89 cf                	mov    %ecx,%edi
  802076:	89 fa                	mov    %edi,%edx
  802078:	83 c4 1c             	add    $0x1c,%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5f                   	pop    %edi
  80207e:	5d                   	pop    %ebp
  80207f:	c3                   	ret    
  802080:	39 ce                	cmp    %ecx,%esi
  802082:	77 28                	ja     8020ac <__udivdi3+0x7c>
  802084:	0f bd fe             	bsr    %esi,%edi
  802087:	83 f7 1f             	xor    $0x1f,%edi
  80208a:	75 40                	jne    8020cc <__udivdi3+0x9c>
  80208c:	39 ce                	cmp    %ecx,%esi
  80208e:	72 0a                	jb     80209a <__udivdi3+0x6a>
  802090:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802094:	0f 87 9e 00 00 00    	ja     802138 <__udivdi3+0x108>
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	89 fa                	mov    %edi,%edx
  8020a1:	83 c4 1c             	add    $0x1c,%esp
  8020a4:	5b                   	pop    %ebx
  8020a5:	5e                   	pop    %esi
  8020a6:	5f                   	pop    %edi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
  8020a9:	8d 76 00             	lea    0x0(%esi),%esi
  8020ac:	31 ff                	xor    %edi,%edi
  8020ae:	31 c0                	xor    %eax,%eax
  8020b0:	89 fa                	mov    %edi,%edx
  8020b2:	83 c4 1c             	add    $0x1c,%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5e                   	pop    %esi
  8020b7:	5f                   	pop    %edi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	89 d8                	mov    %ebx,%eax
  8020be:	f7 f7                	div    %edi
  8020c0:	31 ff                	xor    %edi,%edi
  8020c2:	89 fa                	mov    %edi,%edx
  8020c4:	83 c4 1c             	add    $0x1c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    
  8020cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020d1:	89 eb                	mov    %ebp,%ebx
  8020d3:	29 fb                	sub    %edi,%ebx
  8020d5:	89 f9                	mov    %edi,%ecx
  8020d7:	d3 e6                	shl    %cl,%esi
  8020d9:	89 c5                	mov    %eax,%ebp
  8020db:	88 d9                	mov    %bl,%cl
  8020dd:	d3 ed                	shr    %cl,%ebp
  8020df:	89 e9                	mov    %ebp,%ecx
  8020e1:	09 f1                	or     %esi,%ecx
  8020e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8020e7:	89 f9                	mov    %edi,%ecx
  8020e9:	d3 e0                	shl    %cl,%eax
  8020eb:	89 c5                	mov    %eax,%ebp
  8020ed:	89 d6                	mov    %edx,%esi
  8020ef:	88 d9                	mov    %bl,%cl
  8020f1:	d3 ee                	shr    %cl,%esi
  8020f3:	89 f9                	mov    %edi,%ecx
  8020f5:	d3 e2                	shl    %cl,%edx
  8020f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020fb:	88 d9                	mov    %bl,%cl
  8020fd:	d3 e8                	shr    %cl,%eax
  8020ff:	09 c2                	or     %eax,%edx
  802101:	89 d0                	mov    %edx,%eax
  802103:	89 f2                	mov    %esi,%edx
  802105:	f7 74 24 0c          	divl   0xc(%esp)
  802109:	89 d6                	mov    %edx,%esi
  80210b:	89 c3                	mov    %eax,%ebx
  80210d:	f7 e5                	mul    %ebp
  80210f:	39 d6                	cmp    %edx,%esi
  802111:	72 19                	jb     80212c <__udivdi3+0xfc>
  802113:	74 0b                	je     802120 <__udivdi3+0xf0>
  802115:	89 d8                	mov    %ebx,%eax
  802117:	31 ff                	xor    %edi,%edi
  802119:	e9 58 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  80211e:	66 90                	xchg   %ax,%ax
  802120:	8b 54 24 08          	mov    0x8(%esp),%edx
  802124:	89 f9                	mov    %edi,%ecx
  802126:	d3 e2                	shl    %cl,%edx
  802128:	39 c2                	cmp    %eax,%edx
  80212a:	73 e9                	jae    802115 <__udivdi3+0xe5>
  80212c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80212f:	31 ff                	xor    %edi,%edi
  802131:	e9 40 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  802136:	66 90                	xchg   %ax,%ax
  802138:	31 c0                	xor    %eax,%eax
  80213a:	e9 37 ff ff ff       	jmp    802076 <__udivdi3+0x46>
  80213f:	90                   	nop

00802140 <__umoddi3>:
  802140:	55                   	push   %ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 1c             	sub    $0x1c,%esp
  802147:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80214b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80214f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802153:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80215f:	89 f3                	mov    %esi,%ebx
  802161:	89 fa                	mov    %edi,%edx
  802163:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802167:	89 34 24             	mov    %esi,(%esp)
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 1a                	jne    802188 <__umoddi3+0x48>
  80216e:	39 f7                	cmp    %esi,%edi
  802170:	0f 86 a2 00 00 00    	jbe    802218 <__umoddi3+0xd8>
  802176:	89 c8                	mov    %ecx,%eax
  802178:	89 f2                	mov    %esi,%edx
  80217a:	f7 f7                	div    %edi
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	31 d2                	xor    %edx,%edx
  802180:	83 c4 1c             	add    $0x1c,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
  802188:	39 f0                	cmp    %esi,%eax
  80218a:	0f 87 ac 00 00 00    	ja     80223c <__umoddi3+0xfc>
  802190:	0f bd e8             	bsr    %eax,%ebp
  802193:	83 f5 1f             	xor    $0x1f,%ebp
  802196:	0f 84 ac 00 00 00    	je     802248 <__umoddi3+0x108>
  80219c:	bf 20 00 00 00       	mov    $0x20,%edi
  8021a1:	29 ef                	sub    %ebp,%edi
  8021a3:	89 fe                	mov    %edi,%esi
  8021a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021a9:	89 e9                	mov    %ebp,%ecx
  8021ab:	d3 e0                	shl    %cl,%eax
  8021ad:	89 d7                	mov    %edx,%edi
  8021af:	89 f1                	mov    %esi,%ecx
  8021b1:	d3 ef                	shr    %cl,%edi
  8021b3:	09 c7                	or     %eax,%edi
  8021b5:	89 e9                	mov    %ebp,%ecx
  8021b7:	d3 e2                	shl    %cl,%edx
  8021b9:	89 14 24             	mov    %edx,(%esp)
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	d3 e0                	shl    %cl,%eax
  8021c0:	89 c2                	mov    %eax,%edx
  8021c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021c6:	d3 e0                	shl    %cl,%eax
  8021c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8021d0:	89 f1                	mov    %esi,%ecx
  8021d2:	d3 e8                	shr    %cl,%eax
  8021d4:	09 d0                	or     %edx,%eax
  8021d6:	d3 eb                	shr    %cl,%ebx
  8021d8:	89 da                	mov    %ebx,%edx
  8021da:	f7 f7                	div    %edi
  8021dc:	89 d3                	mov    %edx,%ebx
  8021de:	f7 24 24             	mull   (%esp)
  8021e1:	89 c6                	mov    %eax,%esi
  8021e3:	89 d1                	mov    %edx,%ecx
  8021e5:	39 d3                	cmp    %edx,%ebx
  8021e7:	0f 82 87 00 00 00    	jb     802274 <__umoddi3+0x134>
  8021ed:	0f 84 91 00 00 00    	je     802284 <__umoddi3+0x144>
  8021f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021f7:	29 f2                	sub    %esi,%edx
  8021f9:	19 cb                	sbb    %ecx,%ebx
  8021fb:	89 d8                	mov    %ebx,%eax
  8021fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 e9                	mov    %ebp,%ecx
  802205:	d3 ea                	shr    %cl,%edx
  802207:	09 d0                	or     %edx,%eax
  802209:	89 e9                	mov    %ebp,%ecx
  80220b:	d3 eb                	shr    %cl,%ebx
  80220d:	89 da                	mov    %ebx,%edx
  80220f:	83 c4 1c             	add    $0x1c,%esp
  802212:	5b                   	pop    %ebx
  802213:	5e                   	pop    %esi
  802214:	5f                   	pop    %edi
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    
  802217:	90                   	nop
  802218:	89 fd                	mov    %edi,%ebp
  80221a:	85 ff                	test   %edi,%edi
  80221c:	75 0b                	jne    802229 <__umoddi3+0xe9>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c5                	mov    %eax,%ebp
  802229:	89 f0                	mov    %esi,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f5                	div    %ebp
  80222f:	89 c8                	mov    %ecx,%eax
  802231:	f7 f5                	div    %ebp
  802233:	89 d0                	mov    %edx,%eax
  802235:	e9 44 ff ff ff       	jmp    80217e <__umoddi3+0x3e>
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	89 c8                	mov    %ecx,%eax
  80223e:	89 f2                	mov    %esi,%edx
  802240:	83 c4 1c             	add    $0x1c,%esp
  802243:	5b                   	pop    %ebx
  802244:	5e                   	pop    %esi
  802245:	5f                   	pop    %edi
  802246:	5d                   	pop    %ebp
  802247:	c3                   	ret    
  802248:	3b 04 24             	cmp    (%esp),%eax
  80224b:	72 06                	jb     802253 <__umoddi3+0x113>
  80224d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802251:	77 0f                	ja     802262 <__umoddi3+0x122>
  802253:	89 f2                	mov    %esi,%edx
  802255:	29 f9                	sub    %edi,%ecx
  802257:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80225b:	89 14 24             	mov    %edx,(%esp)
  80225e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802262:	8b 44 24 04          	mov    0x4(%esp),%eax
  802266:	8b 14 24             	mov    (%esp),%edx
  802269:	83 c4 1c             	add    $0x1c,%esp
  80226c:	5b                   	pop    %ebx
  80226d:	5e                   	pop    %esi
  80226e:	5f                   	pop    %edi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    
  802271:	8d 76 00             	lea    0x0(%esi),%esi
  802274:	2b 04 24             	sub    (%esp),%eax
  802277:	19 fa                	sbb    %edi,%edx
  802279:	89 d1                	mov    %edx,%ecx
  80227b:	89 c6                	mov    %eax,%esi
  80227d:	e9 71 ff ff ff       	jmp    8021f3 <__umoddi3+0xb3>
  802282:	66 90                	xchg   %ax,%ax
  802284:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802288:	72 ea                	jb     802274 <__umoddi3+0x134>
  80228a:	89 d9                	mov    %ebx,%ecx
  80228c:	e9 62 ff ff ff       	jmp    8021f3 <__umoddi3+0xb3>
