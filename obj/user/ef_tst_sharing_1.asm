
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 73 03 00 00       	call   8003a9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
//#endif
//	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80003f:	c7 45 f0 00 10 00 82 	movl   $0x82001000,-0x10(%ebp)

	cprintf("STEP A: checking the creation of shared variables...\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 2b 80 00       	push   $0x802ba0
  80004e:	e8 e9 07 00 00       	call   80083c <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800056:	e8 9c 19 00 00       	call   8019f7 <sys_calculate_free_frames>
  80005b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	68 00 10 00 00       	push   $0x1000
  800068:	68 d6 2b 80 00       	push   $0x802bd6
  80006d:	e8 d4 17 00 00       	call   801846 <smalloc>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != (uint32*)pagealloc_start) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  80007e:	74 14                	je     800094 <_main+0x5c>
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	68 d8 2b 80 00       	push   $0x802bd8
  800088:	6a 1a                	push   $0x1a
  80008a:	68 44 2c 80 00       	push   $0x802c44
  80008f:	e8 da 04 00 00       	call   80056e <_panic>
		expected = 1+1 ; /*1page +1table*/
  800094:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  80009b:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80009e:	e8 54 19 00 00       	call   8019f7 <sys_calculate_free_frames>
  8000a3:	29 c3                	sub    %eax,%ebx
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8000aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b0:	72 0d                	jb     8000bf <_main+0x87>
  8000b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b5:	8d 50 02             	lea    0x2(%eax),%edx
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	39 c2                	cmp    %eax,%edx
  8000bd:	73 24                	jae    8000e3 <_main+0xab>
  8000bf:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000c2:	e8 30 19 00 00       	call   8019f7 <sys_calculate_free_frames>
  8000c7:	29 c3                	sub    %eax,%ebx
  8000c9:	89 d8                	mov    %ebx,%eax
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d1:	50                   	push   %eax
  8000d2:	68 5c 2c 80 00       	push   $0x802c5c
  8000d7:	6a 1d                	push   $0x1d
  8000d9:	68 44 2c 80 00       	push   $0x802c44
  8000de:	e8 8b 04 00 00       	call   80056e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8000e3:	e8 0f 19 00 00       	call   8019f7 <sys_calculate_free_frames>
  8000e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  8000eb:	83 ec 04             	sub    $0x4,%esp
  8000ee:	6a 01                	push   $0x1
  8000f0:	68 04 10 00 00       	push   $0x1004
  8000f5:	68 f4 2c 80 00       	push   $0x802cf4
  8000fa:	e8 47 17 00 00       	call   801846 <smalloc>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800108:	05 00 10 00 00       	add    $0x1000,%eax
  80010d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800110:	74 14                	je     800126 <_main+0xee>
  800112:	83 ec 04             	sub    $0x4,%esp
  800115:	68 d8 2b 80 00       	push   $0x802bd8
  80011a:	6a 21                	push   $0x21
  80011c:	68 44 2c 80 00       	push   $0x802c44
  800121:	e8 48 04 00 00       	call   80056e <_panic>
		expected = 2 ; /*2pages*/
  800126:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  80012d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800130:	e8 c2 18 00 00       	call   8019f7 <sys_calculate_free_frames>
  800135:	29 c3                	sub    %eax,%ebx
  800137:	89 d8                	mov    %ebx,%eax
  800139:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  80013c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80013f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800142:	72 0d                	jb     800151 <_main+0x119>
  800144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800147:	8d 50 02             	lea    0x2(%eax),%edx
  80014a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	73 24                	jae    800175 <_main+0x13d>
  800151:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800154:	e8 9e 18 00 00       	call   8019f7 <sys_calculate_free_frames>
  800159:	29 c3                	sub    %eax,%ebx
  80015b:	89 d8                	mov    %ebx,%eax
  80015d:	83 ec 0c             	sub    $0xc,%esp
  800160:	ff 75 e4             	pushl  -0x1c(%ebp)
  800163:	50                   	push   %eax
  800164:	68 5c 2c 80 00       	push   $0x802c5c
  800169:	6a 24                	push   $0x24
  80016b:	68 44 2c 80 00       	push   $0x802c44
  800170:	e8 f9 03 00 00       	call   80056e <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800175:	e8 7d 18 00 00       	call   8019f7 <sys_calculate_free_frames>
  80017a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		y = smalloc("y", 4, 1);
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	6a 01                	push   $0x1
  800182:	6a 04                	push   $0x4
  800184:	68 f6 2c 80 00       	push   $0x802cf6
  800189:	e8 b8 16 00 00       	call   801846 <smalloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE)) {panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800197:	05 00 30 00 00       	add    $0x3000,%eax
  80019c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80019f:	74 14                	je     8001b5 <_main+0x17d>
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 d8 2b 80 00       	push   $0x802bd8
  8001a9:	6a 28                	push   $0x28
  8001ab:	68 44 2c 80 00       	push   $0x802c44
  8001b0:	e8 b9 03 00 00       	call   80056e <_panic>
		expected = 1 ; /*1page*/
  8001b5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8001bc:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001bf:	e8 33 18 00 00       	call   8019f7 <sys_calculate_free_frames>
  8001c4:	29 c3                	sub    %eax,%ebx
  8001c6:	89 d8                	mov    %ebx,%eax
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (diff < expected || diff > expected +1+1 /*extra 1 page & 1 table for sbrk (at max)*/) {panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8001cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8001d1:	72 0d                	jb     8001e0 <_main+0x1a8>
  8001d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d6:	8d 50 02             	lea    0x2(%eax),%edx
  8001d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001dc:	39 c2                	cmp    %eax,%edx
  8001de:	73 24                	jae    800204 <_main+0x1cc>
  8001e0:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001e3:	e8 0f 18 00 00       	call   8019f7 <sys_calculate_free_frames>
  8001e8:	29 c3                	sub    %eax,%ebx
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	50                   	push   %eax
  8001f3:	68 5c 2c 80 00       	push   $0x802c5c
  8001f8:	6a 2b                	push   $0x2b
  8001fa:	68 44 2c 80 00       	push   $0x802c44
  8001ff:	e8 6a 03 00 00       	call   80056e <_panic>
	}
	cprintf("Step A is finished!!\n\n\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 f8 2c 80 00       	push   $0x802cf8
  80020c:	e8 2b 06 00 00       	call   80083c <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	68 10 2d 80 00       	push   $0x802d10
  80021c:	e8 1b 06 00 00       	call   80083c <cprintf>
  800221:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  800224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  80022b:	eb 2d                	jmp    80025a <_main+0x222>
		{
			x[i] = -1;
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80024f:	01 d0                	add    %edx,%eax
  800251:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800257:	ff 45 f4             	incl   -0xc(%ebp)
  80025a:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800261:	7e ca                	jle    80022d <_main+0x1f5>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  800263:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  80026a:	eb 18                	jmp    800284 <_main+0x24c>
		{
			z[i] = -1;
  80026c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80026f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800276:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800279:	01 d0                	add    %edx,%eax
  80027b:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800281:	ff 45 f4             	incl   -0xc(%ebp)
  800284:	81 7d f4 ff 07 00 00 	cmpl   $0x7ff,-0xc(%ebp)
  80028b:	7e df                	jle    80026c <_main+0x234>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80028d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800290:	8b 00                	mov    (%eax),%eax
  800292:	83 f8 ff             	cmp    $0xffffffff,%eax
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 38 2d 80 00       	push   $0x802d38
  80029f:	6a 3f                	push   $0x3f
  8002a1:	68 44 2c 80 00       	push   $0x802c44
  8002a6:	e8 c3 02 00 00       	call   80056e <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b8:	74 14                	je     8002ce <_main+0x296>
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 38 2d 80 00       	push   $0x802d38
  8002c2:	6a 40                	push   $0x40
  8002c4:	68 44 2c 80 00       	push   $0x802c44
  8002c9:	e8 a0 02 00 00       	call   80056e <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d1:	8b 00                	mov    (%eax),%eax
  8002d3:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d6:	74 14                	je     8002ec <_main+0x2b4>
  8002d8:	83 ec 04             	sub    $0x4,%esp
  8002db:	68 38 2d 80 00       	push   $0x802d38
  8002e0:	6a 42                	push   $0x42
  8002e2:	68 44 2c 80 00       	push   $0x802c44
  8002e7:	e8 82 02 00 00       	call   80056e <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ef:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002f4:	8b 00                	mov    (%eax),%eax
  8002f6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f9:	74 14                	je     80030f <_main+0x2d7>
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	68 38 2d 80 00       	push   $0x802d38
  800303:	6a 43                	push   $0x43
  800305:	68 44 2c 80 00       	push   $0x802c44
  80030a:	e8 5f 02 00 00       	call   80056e <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 f8 ff             	cmp    $0xffffffff,%eax
  800317:	74 14                	je     80032d <_main+0x2f5>
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	68 38 2d 80 00       	push   $0x802d38
  800321:	6a 45                	push   $0x45
  800323:	68 44 2c 80 00       	push   $0x802c44
  800328:	e8 41 02 00 00       	call   80056e <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  80032d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800330:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	83 f8 ff             	cmp    $0xffffffff,%eax
  80033a:	74 14                	je     800350 <_main+0x318>
  80033c:	83 ec 04             	sub    $0x4,%esp
  80033f:	68 38 2d 80 00       	push   $0x802d38
  800344:	6a 46                	push   $0x46
  800346:	68 44 2c 80 00       	push   $0x802c44
  80034b:	e8 1e 02 00 00       	call   80056e <_panic>
	}

	cprintf("test sharing 1 [Create] is finished!!\n\n\n");
  800350:	83 ec 0c             	sub    $0xc,%esp
  800353:	68 64 2d 80 00       	push   $0x802d64
  800358:	e8 df 04 00 00       	call   80083c <cprintf>
  80035d:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800360:	e8 74 18 00 00       	call   801bd9 <sys_getparentenvid>
  800365:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(parentenvID > 0)
  800368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80036c:	7e 35                	jle    8003a3 <_main+0x36b>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  80036e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	68 8d 2d 80 00       	push   $0x802d8d
  80037d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800380:	e8 f5 14 00 00       	call   80187a <sget>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)
		sys_lock_cons();
  80038b:	e8 b7 15 00 00       	call   801947 <sys_lock_cons>
		{
			(*finishedCount)++ ;
  800390:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	8d 50 01             	lea    0x1(%eax),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	89 10                	mov    %edx,(%eax)
		}
		sys_unlock_cons();
  80039d:	e8 bf 15 00 00       	call   801961 <sys_unlock_cons>
	}

	return;
  8003a2:	90                   	nop
  8003a3:	90                   	nop
}
  8003a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	57                   	push   %edi
  8003ad:	56                   	push   %esi
  8003ae:	53                   	push   %ebx
  8003af:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8003b2:	e8 09 18 00 00       	call   801bc0 <sys_getenvindex>
  8003b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	c1 e0 06             	shl    $0x6,%eax
  8003c2:	29 d0                	sub    %edx,%eax
  8003c4:	c1 e0 02             	shl    $0x2,%eax
  8003c7:	01 d0                	add    %edx,%eax
  8003c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d0:	01 c8                	add    %ecx,%eax
  8003d2:	c1 e0 03             	shl    $0x3,%eax
  8003d5:	01 d0                	add    %edx,%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	29 c2                	sub    %eax,%edx
  8003e0:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8003ef:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f9:	8a 40 20             	mov    0x20(%eax),%al
  8003fc:	84 c0                	test   %al,%al
  8003fe:	74 0d                	je     80040d <libmain+0x64>
		binaryname = myEnv->prog_name;
  800400:	a1 20 40 80 00       	mov    0x804020,%eax
  800405:	83 c0 20             	add    $0x20,%eax
  800408:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80040d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800411:	7e 0a                	jle    80041d <libmain+0x74>
		binaryname = argv[0];
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	ff 75 0c             	pushl  0xc(%ebp)
  800423:	ff 75 08             	pushl  0x8(%ebp)
  800426:	e8 0d fc ff ff       	call   800038 <_main>
  80042b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80042e:	a1 00 40 80 00       	mov    0x804000,%eax
  800433:	85 c0                	test   %eax,%eax
  800435:	0f 84 01 01 00 00    	je     80053c <libmain+0x193>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80043b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800441:	bb 94 2e 80 00       	mov    $0x802e94,%ebx
  800446:	ba 0e 00 00 00       	mov    $0xe,%edx
  80044b:	89 c7                	mov    %eax,%edi
  80044d:	89 de                	mov    %ebx,%esi
  80044f:	89 d1                	mov    %edx,%ecx
  800451:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800453:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800456:	b9 56 00 00 00       	mov    $0x56,%ecx
  80045b:	b0 00                	mov    $0x0,%al
  80045d:	89 d7                	mov    %edx,%edi
  80045f:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  800461:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800468:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	50                   	push   %eax
  80046f:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800475:	50                   	push   %eax
  800476:	e8 7b 19 00 00       	call   801df6 <sys_utilities>
  80047b:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80047e:	e8 c4 14 00 00       	call   801947 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800483:	83 ec 0c             	sub    $0xc,%esp
  800486:	68 b4 2d 80 00       	push   $0x802db4
  80048b:	e8 ac 03 00 00       	call   80083c <cprintf>
  800490:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  800493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	74 18                	je     8004b2 <libmain+0x109>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  80049a:	e8 75 19 00 00       	call   801e14 <sys_get_optimal_num_faults>
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	50                   	push   %eax
  8004a3:	68 dc 2d 80 00       	push   $0x802ddc
  8004a8:	e8 8f 03 00 00       	call   80083c <cprintf>
  8004ad:	83 c4 10             	add    $0x10,%esp
  8004b0:	eb 59                	jmp    80050b <libmain+0x162>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8004bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c2:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	52                   	push   %edx
  8004cc:	50                   	push   %eax
  8004cd:	68 00 2e 80 00       	push   $0x802e00
  8004d2:	e8 65 03 00 00       	call   80083c <cprintf>
  8004d7:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004da:	a1 20 40 80 00       	mov    0x804020,%eax
  8004df:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8004e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ea:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8004f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f5:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8004fb:	51                   	push   %ecx
  8004fc:	52                   	push   %edx
  8004fd:	50                   	push   %eax
  8004fe:	68 28 2e 80 00       	push   $0x802e28
  800503:	e8 34 03 00 00       	call   80083c <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80050b:	a1 20 40 80 00       	mov    0x804020,%eax
  800510:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	50                   	push   %eax
  80051a:	68 80 2e 80 00       	push   $0x802e80
  80051f:	e8 18 03 00 00       	call   80083c <cprintf>
  800524:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800527:	83 ec 0c             	sub    $0xc,%esp
  80052a:	68 b4 2d 80 00       	push   $0x802db4
  80052f:	e8 08 03 00 00       	call   80083c <cprintf>
  800534:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800537:	e8 25 14 00 00       	call   801961 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80053c:	e8 1f 00 00 00       	call   800560 <exit>
}
  800541:	90                   	nop
  800542:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800545:	5b                   	pop    %ebx
  800546:	5e                   	pop    %esi
  800547:	5f                   	pop    %edi
  800548:	5d                   	pop    %ebp
  800549:	c3                   	ret    

0080054a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	6a 00                	push   $0x0
  800555:	e8 32 16 00 00       	call   801b8c <sys_destroy_env>
  80055a:	83 c4 10             	add    $0x10,%esp
}
  80055d:	90                   	nop
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <exit>:

void
exit(void)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800566:	e8 87 16 00 00       	call   801bf2 <sys_exit_env>
}
  80056b:	90                   	nop
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800574:	8d 45 10             	lea    0x10(%ebp),%eax
  800577:	83 c0 04             	add    $0x4,%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80057d:	a1 18 c1 81 00       	mov    0x81c118,%eax
  800582:	85 c0                	test   %eax,%eax
  800584:	74 16                	je     80059c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800586:	a1 18 c1 81 00       	mov    0x81c118,%eax
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	50                   	push   %eax
  80058f:	68 f8 2e 80 00       	push   $0x802ef8
  800594:	e8 a3 02 00 00       	call   80083c <cprintf>
  800599:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  80059c:	a1 04 40 80 00       	mov    0x804004,%eax
  8005a1:	83 ec 0c             	sub    $0xc,%esp
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	ff 75 08             	pushl  0x8(%ebp)
  8005aa:	50                   	push   %eax
  8005ab:	68 00 2f 80 00       	push   $0x802f00
  8005b0:	6a 74                	push   $0x74
  8005b2:	e8 b2 02 00 00       	call   800869 <cprintf_colored>
  8005b7:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8005ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c3:	50                   	push   %eax
  8005c4:	e8 04 02 00 00       	call   8007cd <vcprintf>
  8005c9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	6a 00                	push   $0x0
  8005d1:	68 28 2f 80 00       	push   $0x802f28
  8005d6:	e8 f2 01 00 00       	call   8007cd <vcprintf>
  8005db:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005de:	e8 7d ff ff ff       	call   800560 <exit>

	// should not return here
	while (1) ;
  8005e3:	eb fe                	jmp    8005e3 <_panic+0x75>

008005e5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005e5:	55                   	push   %ebp
  8005e6:	89 e5                	mov    %esp,%ebp
  8005e8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f9:	39 c2                	cmp    %eax,%edx
  8005fb:	74 14                	je     800611 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005fd:	83 ec 04             	sub    $0x4,%esp
  800600:	68 2c 2f 80 00       	push   $0x802f2c
  800605:	6a 26                	push   $0x26
  800607:	68 78 2f 80 00       	push   $0x802f78
  80060c:	e8 5d ff ff ff       	call   80056e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800611:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80061f:	e9 c5 00 00 00       	jmp    8006e9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800627:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	01 d0                	add    %edx,%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	85 c0                	test   %eax,%eax
  800637:	75 08                	jne    800641 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800639:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80063c:	e9 a5 00 00 00       	jmp    8006e6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800641:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80064f:	eb 69                	jmp    8006ba <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800651:	a1 20 40 80 00       	mov    0x804020,%eax
  800656:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80065c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80065f:	89 d0                	mov    %edx,%eax
  800661:	01 c0                	add    %eax,%eax
  800663:	01 d0                	add    %edx,%eax
  800665:	c1 e0 03             	shl    $0x3,%eax
  800668:	01 c8                	add    %ecx,%eax
  80066a:	8a 40 04             	mov    0x4(%eax),%al
  80066d:	84 c0                	test   %al,%al
  80066f:	75 46                	jne    8006b7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800671:	a1 20 40 80 00       	mov    0x804020,%eax
  800676:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80067c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	c1 e0 03             	shl    $0x3,%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80068f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800692:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800697:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	01 c8                	add    %ecx,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	75 09                	jne    8006b7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8006ae:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006b5:	eb 15                	jmp    8006cc <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006b7:	ff 45 e8             	incl   -0x18(%ebp)
  8006ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8006bf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8006c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c8:	39 c2                	cmp    %eax,%edx
  8006ca:	77 85                	ja     800651 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8006cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006d0:	75 14                	jne    8006e6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8006d2:	83 ec 04             	sub    $0x4,%esp
  8006d5:	68 84 2f 80 00       	push   $0x802f84
  8006da:	6a 3a                	push   $0x3a
  8006dc:	68 78 2f 80 00       	push   $0x802f78
  8006e1:	e8 88 fe ff ff       	call   80056e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006e6:	ff 45 f0             	incl   -0x10(%ebp)
  8006e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	0f 8c 2f ff ff ff    	jl     800624 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800703:	eb 26                	jmp    80072b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800705:	a1 20 40 80 00       	mov    0x804020,%eax
  80070a:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  800710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800713:	89 d0                	mov    %edx,%eax
  800715:	01 c0                	add    %eax,%eax
  800717:	01 d0                	add    %edx,%eax
  800719:	c1 e0 03             	shl    $0x3,%eax
  80071c:	01 c8                	add    %ecx,%eax
  80071e:	8a 40 04             	mov    0x4(%eax),%al
  800721:	3c 01                	cmp    $0x1,%al
  800723:	75 03                	jne    800728 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800725:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800728:	ff 45 e0             	incl   -0x20(%ebp)
  80072b:	a1 20 40 80 00       	mov    0x804020,%eax
  800730:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800739:	39 c2                	cmp    %eax,%edx
  80073b:	77 c8                	ja     800705 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800740:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800743:	74 14                	je     800759 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 d8 2f 80 00       	push   $0x802fd8
  80074d:	6a 44                	push   $0x44
  80074f:	68 78 2f 80 00       	push   $0x802f78
  800754:	e8 15 fe ff ff       	call   80056e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	53                   	push   %ebx
  800760:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800763:	8b 45 0c             	mov    0xc(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	8d 48 01             	lea    0x1(%eax),%ecx
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076e:	89 0a                	mov    %ecx,(%edx)
  800770:	8b 55 08             	mov    0x8(%ebp),%edx
  800773:	88 d1                	mov    %dl,%cl
  800775:	8b 55 0c             	mov    0xc(%ebp),%edx
  800778:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	3d ff 00 00 00       	cmp    $0xff,%eax
  800786:	75 30                	jne    8007b8 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800788:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80078e:	a0 44 40 80 00       	mov    0x804044,%al
  800793:	0f b6 c0             	movzbl %al,%eax
  800796:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800799:	8b 09                	mov    (%ecx),%ecx
  80079b:	89 cb                	mov    %ecx,%ebx
  80079d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a0:	83 c1 08             	add    $0x8,%ecx
  8007a3:	52                   	push   %edx
  8007a4:	50                   	push   %eax
  8007a5:	53                   	push   %ebx
  8007a6:	51                   	push   %ecx
  8007a7:	e8 57 11 00 00       	call   801903 <sys_cputs>
  8007ac:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bb:	8b 40 04             	mov    0x4(%eax),%eax
  8007be:	8d 50 01             	lea    0x1(%eax),%edx
  8007c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007c7:	90                   	nop
  8007c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    

008007cd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8007d6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007dd:	00 00 00 
	b.cnt = 0;
  8007e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007e7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	ff 75 08             	pushl  0x8(%ebp)
  8007f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007f6:	50                   	push   %eax
  8007f7:	68 5c 07 80 00       	push   $0x80075c
  8007fc:	e8 5a 02 00 00       	call   800a5b <vprintfmt>
  800801:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800804:	8b 15 1c c1 81 00    	mov    0x81c11c,%edx
  80080a:	a0 44 40 80 00       	mov    0x804044,%al
  80080f:	0f b6 c0             	movzbl %al,%eax
  800812:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800818:	52                   	push   %edx
  800819:	50                   	push   %eax
  80081a:	51                   	push   %ecx
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	83 c0 08             	add    $0x8,%eax
  800824:	50                   	push   %eax
  800825:	e8 d9 10 00 00       	call   801903 <sys_cputs>
  80082a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80082d:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
	return b.cnt;
  800834:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800842:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	va_start(ap, fmt);
  800849:	8d 45 0c             	lea    0xc(%ebp),%eax
  80084c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	ff 75 f4             	pushl  -0xc(%ebp)
  800858:	50                   	push   %eax
  800859:	e8 6f ff ff ff       	call   8007cd <vcprintf>
  80085e:	83 c4 10             	add    $0x10,%esp
  800861:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800864:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800867:	c9                   	leave  
  800868:	c3                   	ret    

00800869 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80086f:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	c1 e0 08             	shl    $0x8,%eax
  80087c:	a3 1c c1 81 00       	mov    %eax,0x81c11c
	va_start(ap, fmt);
  800881:	8d 45 0c             	lea    0xc(%ebp),%eax
  800884:	83 c0 04             	add    $0x4,%eax
  800887:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 f4             	pushl  -0xc(%ebp)
  800893:	50                   	push   %eax
  800894:	e8 34 ff ff ff       	call   8007cd <vcprintf>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  80089f:	c7 05 1c c1 81 00 00 	movl   $0x700,0x81c11c
  8008a6:	07 00 00 

	return cnt;
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ac:	c9                   	leave  
  8008ad:	c3                   	ret    

008008ae <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8008b4:	e8 8e 10 00 00       	call   801947 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8008b9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8008bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8008bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	e8 ff fe ff ff       	call   8007cd <vcprintf>
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8008d4:	e8 88 10 00 00       	call   801961 <sys_unlock_cons>
	return cnt;
  8008d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008dc:	c9                   	leave  
  8008dd:	c3                   	ret    

008008de <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008de:	55                   	push   %ebp
  8008df:	89 e5                	mov    %esp,%ebp
  8008e1:	53                   	push   %ebx
  8008e2:	83 ec 14             	sub    $0x14,%esp
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008fc:	77 55                	ja     800953 <printnum+0x75>
  8008fe:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800901:	72 05                	jb     800908 <printnum+0x2a>
  800903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800906:	77 4b                	ja     800953 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800908:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80090b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80090e:	8b 45 18             	mov    0x18(%ebp),%eax
  800911:	ba 00 00 00 00       	mov    $0x0,%edx
  800916:	52                   	push   %edx
  800917:	50                   	push   %eax
  800918:	ff 75 f4             	pushl  -0xc(%ebp)
  80091b:	ff 75 f0             	pushl  -0x10(%ebp)
  80091e:	e8 09 20 00 00       	call   80292c <__udivdi3>
  800923:	83 c4 10             	add    $0x10,%esp
  800926:	83 ec 04             	sub    $0x4,%esp
  800929:	ff 75 20             	pushl  0x20(%ebp)
  80092c:	53                   	push   %ebx
  80092d:	ff 75 18             	pushl  0x18(%ebp)
  800930:	52                   	push   %edx
  800931:	50                   	push   %eax
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 a1 ff ff ff       	call   8008de <printnum>
  80093d:	83 c4 20             	add    $0x20,%esp
  800940:	eb 1a                	jmp    80095c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	ff 75 20             	pushl  0x20(%ebp)
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800953:	ff 4d 1c             	decl   0x1c(%ebp)
  800956:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80095a:	7f e6                	jg     800942 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80095c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80095f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096a:	53                   	push   %ebx
  80096b:	51                   	push   %ecx
  80096c:	52                   	push   %edx
  80096d:	50                   	push   %eax
  80096e:	e8 c9 20 00 00       	call   802a3c <__umoddi3>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	05 54 32 80 00       	add    $0x803254,%eax
  80097b:	8a 00                	mov    (%eax),%al
  80097d:	0f be c0             	movsbl %al,%eax
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	50                   	push   %eax
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
  80098c:	83 c4 10             	add    $0x10,%esp
}
  80098f:	90                   	nop
  800990:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800998:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80099c:	7e 1c                	jle    8009ba <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	8d 50 08             	lea    0x8(%eax),%edx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	89 10                	mov    %edx,(%eax)
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	83 e8 08             	sub    $0x8,%eax
  8009b3:	8b 50 04             	mov    0x4(%eax),%edx
  8009b6:	8b 00                	mov    (%eax),%eax
  8009b8:	eb 40                	jmp    8009fa <getuint+0x65>
	else if (lflag)
  8009ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009be:	74 1e                	je     8009de <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009dc:	eb 1c                	jmp    8009fa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 00                	mov    (%eax),%eax
  8009e3:	8d 50 04             	lea    0x4(%eax),%edx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	89 10                	mov    %edx,(%eax)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 00                	mov    (%eax),%eax
  8009f0:	83 e8 04             	sub    $0x4,%eax
  8009f3:	8b 00                	mov    (%eax),%eax
  8009f5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a03:	7e 1c                	jle    800a21 <getint+0x25>
		return va_arg(*ap, long long);
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 00                	mov    (%eax),%eax
  800a0a:	8d 50 08             	lea    0x8(%eax),%edx
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	89 10                	mov    %edx,(%eax)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	83 e8 08             	sub    $0x8,%eax
  800a1a:	8b 50 04             	mov    0x4(%eax),%edx
  800a1d:	8b 00                	mov    (%eax),%eax
  800a1f:	eb 38                	jmp    800a59 <getint+0x5d>
	else if (lflag)
  800a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a25:	74 1a                	je     800a41 <getint+0x45>
		return va_arg(*ap, long);
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 00                	mov    (%eax),%eax
  800a2c:	8d 50 04             	lea    0x4(%eax),%edx
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	89 10                	mov    %edx,(%eax)
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax
  800a3e:	99                   	cltd   
  800a3f:	eb 18                	jmp    800a59 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	8d 50 04             	lea    0x4(%eax),%edx
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	89 10                	mov    %edx,(%eax)
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 00                	mov    (%eax),%eax
  800a53:	83 e8 04             	sub    $0x4,%eax
  800a56:	8b 00                	mov    (%eax),%eax
  800a58:	99                   	cltd   
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a63:	eb 17                	jmp    800a7c <vprintfmt+0x21>
			if (ch == '\0')
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	0f 84 c1 03 00 00    	je     800e2e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	53                   	push   %ebx
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7f:	8d 50 01             	lea    0x1(%eax),%edx
  800a82:	89 55 10             	mov    %edx,0x10(%ebp)
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	0f b6 d8             	movzbl %al,%ebx
  800a8a:	83 fb 25             	cmp    $0x25,%ebx
  800a8d:	75 d6                	jne    800a65 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a8f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a93:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a9a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800aa1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800aa8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab2:	8d 50 01             	lea    0x1(%eax),%edx
  800ab5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ab8:	8a 00                	mov    (%eax),%al
  800aba:	0f b6 d8             	movzbl %al,%ebx
  800abd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ac0:	83 f8 5b             	cmp    $0x5b,%eax
  800ac3:	0f 87 3d 03 00 00    	ja     800e06 <vprintfmt+0x3ab>
  800ac9:	8b 04 85 78 32 80 00 	mov    0x803278(,%eax,4),%eax
  800ad0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ad2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ad6:	eb d7                	jmp    800aaf <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ad8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800adc:	eb d1                	jmp    800aaf <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ade:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae8:	89 d0                	mov    %edx,%eax
  800aea:	c1 e0 02             	shl    $0x2,%eax
  800aed:	01 d0                	add    %edx,%eax
  800aef:	01 c0                	add    %eax,%eax
  800af1:	01 d8                	add    %ebx,%eax
  800af3:	83 e8 30             	sub    $0x30,%eax
  800af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800af9:	8b 45 10             	mov    0x10(%ebp),%eax
  800afc:	8a 00                	mov    (%eax),%al
  800afe:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b01:	83 fb 2f             	cmp    $0x2f,%ebx
  800b04:	7e 3e                	jle    800b44 <vprintfmt+0xe9>
  800b06:	83 fb 39             	cmp    $0x39,%ebx
  800b09:	7f 39                	jg     800b44 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b0b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b0e:	eb d5                	jmp    800ae5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b10:	8b 45 14             	mov    0x14(%ebp),%eax
  800b13:	83 c0 04             	add    $0x4,%eax
  800b16:	89 45 14             	mov    %eax,0x14(%ebp)
  800b19:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1c:	83 e8 04             	sub    $0x4,%eax
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b24:	eb 1f                	jmp    800b45 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	79 83                	jns    800aaf <vprintfmt+0x54>
				width = 0;
  800b2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b33:	e9 77 ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b38:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b3f:	e9 6b ff ff ff       	jmp    800aaf <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b44:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b49:	0f 89 60 ff ff ff    	jns    800aaf <vprintfmt+0x54>
				width = precision, precision = -1;
  800b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b55:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b5c:	e9 4e ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b61:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b64:	e9 46 ff ff ff       	jmp    800aaf <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b69:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6c:	83 c0 04             	add    $0x4,%eax
  800b6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b72:	8b 45 14             	mov    0x14(%ebp),%eax
  800b75:	83 e8 04             	sub    $0x4,%eax
  800b78:	8b 00                	mov    (%eax),%eax
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	50                   	push   %eax
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			break;
  800b89:	e9 9b 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	83 c0 04             	add    $0x4,%eax
  800b94:	89 45 14             	mov    %eax,0x14(%ebp)
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 e8 04             	sub    $0x4,%eax
  800b9d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b9f:	85 db                	test   %ebx,%ebx
  800ba1:	79 02                	jns    800ba5 <vprintfmt+0x14a>
				err = -err;
  800ba3:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ba5:	83 fb 64             	cmp    $0x64,%ebx
  800ba8:	7f 0b                	jg     800bb5 <vprintfmt+0x15a>
  800baa:	8b 34 9d c0 30 80 00 	mov    0x8030c0(,%ebx,4),%esi
  800bb1:	85 f6                	test   %esi,%esi
  800bb3:	75 19                	jne    800bce <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800bb5:	53                   	push   %ebx
  800bb6:	68 65 32 80 00       	push   $0x803265
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	ff 75 08             	pushl  0x8(%ebp)
  800bc1:	e8 70 02 00 00       	call   800e36 <printfmt>
  800bc6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bc9:	e9 5b 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bce:	56                   	push   %esi
  800bcf:	68 6e 32 80 00       	push   $0x80326e
  800bd4:	ff 75 0c             	pushl  0xc(%ebp)
  800bd7:	ff 75 08             	pushl  0x8(%ebp)
  800bda:	e8 57 02 00 00       	call   800e36 <printfmt>
  800bdf:	83 c4 10             	add    $0x10,%esp
			break;
  800be2:	e9 42 02 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800be7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bea:	83 c0 04             	add    $0x4,%eax
  800bed:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf3:	83 e8 04             	sub    $0x4,%eax
  800bf6:	8b 30                	mov    (%eax),%esi
  800bf8:	85 f6                	test   %esi,%esi
  800bfa:	75 05                	jne    800c01 <vprintfmt+0x1a6>
				p = "(null)";
  800bfc:	be 71 32 80 00       	mov    $0x803271,%esi
			if (width > 0 && padc != '-')
  800c01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c05:	7e 6d                	jle    800c74 <vprintfmt+0x219>
  800c07:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800c0b:	74 67                	je     800c74 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	50                   	push   %eax
  800c14:	56                   	push   %esi
  800c15:	e8 1e 03 00 00       	call   800f38 <strnlen>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c20:	eb 16                	jmp    800c38 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c22:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c26:	83 ec 08             	sub    $0x8,%esp
  800c29:	ff 75 0c             	pushl  0xc(%ebp)
  800c2c:	50                   	push   %eax
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	ff d0                	call   *%eax
  800c32:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c35:	ff 4d e4             	decl   -0x1c(%ebp)
  800c38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3c:	7f e4                	jg     800c22 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c3e:	eb 34                	jmp    800c74 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c40:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c44:	74 1c                	je     800c62 <vprintfmt+0x207>
  800c46:	83 fb 1f             	cmp    $0x1f,%ebx
  800c49:	7e 05                	jle    800c50 <vprintfmt+0x1f5>
  800c4b:	83 fb 7e             	cmp    $0x7e,%ebx
  800c4e:	7e 12                	jle    800c62 <vprintfmt+0x207>
					putch('?', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 3f                	push   $0x3f
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
  800c60:	eb 0f                	jmp    800c71 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c62:	83 ec 08             	sub    $0x8,%esp
  800c65:	ff 75 0c             	pushl  0xc(%ebp)
  800c68:	53                   	push   %ebx
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c71:	ff 4d e4             	decl   -0x1c(%ebp)
  800c74:	89 f0                	mov    %esi,%eax
  800c76:	8d 70 01             	lea    0x1(%eax),%esi
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	0f be d8             	movsbl %al,%ebx
  800c7e:	85 db                	test   %ebx,%ebx
  800c80:	74 24                	je     800ca6 <vprintfmt+0x24b>
  800c82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c86:	78 b8                	js     800c40 <vprintfmt+0x1e5>
  800c88:	ff 4d e0             	decl   -0x20(%ebp)
  800c8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c8f:	79 af                	jns    800c40 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c91:	eb 13                	jmp    800ca6 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 0c             	pushl  0xc(%ebp)
  800c99:	6a 20                	push   $0x20
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	ff d0                	call   *%eax
  800ca0:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ca3:	ff 4d e4             	decl   -0x1c(%ebp)
  800ca6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800caa:	7f e7                	jg     800c93 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800cac:	e9 78 01 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800cb1:	83 ec 08             	sub    $0x8,%esp
  800cb4:	ff 75 e8             	pushl  -0x18(%ebp)
  800cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  800cba:	50                   	push   %eax
  800cbb:	e8 3c fd ff ff       	call   8009fc <getint>
  800cc0:	83 c4 10             	add    $0x10,%esp
  800cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccf:	85 d2                	test   %edx,%edx
  800cd1:	79 23                	jns    800cf6 <vprintfmt+0x29b>
				putch('-', putdat);
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	6a 2d                	push   $0x2d
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	ff d0                	call   *%eax
  800ce0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce9:	f7 d8                	neg    %eax
  800ceb:	83 d2 00             	adc    $0x0,%edx
  800cee:	f7 da                	neg    %edx
  800cf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cf6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cfd:	e9 bc 00 00 00       	jmp    800dbe <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	ff 75 e8             	pushl  -0x18(%ebp)
  800d08:	8d 45 14             	lea    0x14(%ebp),%eax
  800d0b:	50                   	push   %eax
  800d0c:	e8 84 fc ff ff       	call   800995 <getuint>
  800d11:	83 c4 10             	add    $0x10,%esp
  800d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800d1a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d21:	e9 98 00 00 00       	jmp    800dbe <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d26:	83 ec 08             	sub    $0x8,%esp
  800d29:	ff 75 0c             	pushl  0xc(%ebp)
  800d2c:	6a 58                	push   $0x58
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	ff d0                	call   *%eax
  800d33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 58                	push   $0x58
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	ff 75 0c             	pushl  0xc(%ebp)
  800d4c:	6a 58                	push   $0x58
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	ff d0                	call   *%eax
  800d53:	83 c4 10             	add    $0x10,%esp
			break;
  800d56:	e9 ce 00 00 00       	jmp    800e29 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800d5b:	83 ec 08             	sub    $0x8,%esp
  800d5e:	ff 75 0c             	pushl  0xc(%ebp)
  800d61:	6a 30                	push   $0x30
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	ff d0                	call   *%eax
  800d68:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d6b:	83 ec 08             	sub    $0x8,%esp
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	6a 78                	push   $0x78
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	ff d0                	call   *%eax
  800d78:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7e:	83 c0 04             	add    $0x4,%eax
  800d81:	89 45 14             	mov    %eax,0x14(%ebp)
  800d84:	8b 45 14             	mov    0x14(%ebp),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d9d:	eb 1f                	jmp    800dbe <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	ff 75 e8             	pushl  -0x18(%ebp)
  800da5:	8d 45 14             	lea    0x14(%ebp),%eax
  800da8:	50                   	push   %eax
  800da9:	e8 e7 fb ff ff       	call   800995 <getuint>
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800db7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800dbe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc5:	83 ec 04             	sub    $0x4,%esp
  800dc8:	52                   	push   %edx
  800dc9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dcc:	50                   	push   %eax
  800dcd:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd0:	ff 75 f0             	pushl  -0x10(%ebp)
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	ff 75 08             	pushl  0x8(%ebp)
  800dd9:	e8 00 fb ff ff       	call   8008de <printnum>
  800dde:	83 c4 20             	add    $0x20,%esp
			break;
  800de1:	eb 46                	jmp    800e29 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800de3:	83 ec 08             	sub    $0x8,%esp
  800de6:	ff 75 0c             	pushl  0xc(%ebp)
  800de9:	53                   	push   %ebx
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	ff d0                	call   *%eax
  800def:	83 c4 10             	add    $0x10,%esp
			break;
  800df2:	eb 35                	jmp    800e29 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800df4:	c6 05 44 40 80 00 00 	movb   $0x0,0x804044
			break;
  800dfb:	eb 2c                	jmp    800e29 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800dfd:	c6 05 44 40 80 00 01 	movb   $0x1,0x804044
			break;
  800e04:	eb 23                	jmp    800e29 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e06:	83 ec 08             	sub    $0x8,%esp
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	6a 25                	push   $0x25
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	ff d0                	call   *%eax
  800e13:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e16:	ff 4d 10             	decl   0x10(%ebp)
  800e19:	eb 03                	jmp    800e1e <vprintfmt+0x3c3>
  800e1b:	ff 4d 10             	decl   0x10(%ebp)
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	48                   	dec    %eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 25                	cmp    $0x25,%al
  800e26:	75 f3                	jne    800e1b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800e28:	90                   	nop
		}
	}
  800e29:	e9 35 fc ff ff       	jmp    800a63 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800e2e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e3c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e3f:	83 c0 04             	add    $0x4,%eax
  800e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	ff 75 f4             	pushl  -0xc(%ebp)
  800e4b:	50                   	push   %eax
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	ff 75 08             	pushl  0x8(%ebp)
  800e52:	e8 04 fc ff ff       	call   800a5b <vprintfmt>
  800e57:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e5a:	90                   	nop
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8b 40 08             	mov    0x8(%eax),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8b 10                	mov    (%eax),%edx
  800e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e77:	8b 40 04             	mov    0x4(%eax),%eax
  800e7a:	39 c2                	cmp    %eax,%edx
  800e7c:	73 12                	jae    800e90 <sprintputch+0x33>
		*b->buf++ = ch;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	8d 48 01             	lea    0x1(%eax),%ecx
  800e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e89:	89 0a                	mov    %ecx,(%edx)
  800e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8e:	88 10                	mov    %dl,(%eax)
}
  800e90:	90                   	nop
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	01 d0                	add    %edx,%eax
  800eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800eb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eb8:	74 06                	je     800ec0 <vsnprintf+0x2d>
  800eba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebe:	7f 07                	jg     800ec7 <vsnprintf+0x34>
		return -E_INVAL;
  800ec0:	b8 03 00 00 00       	mov    $0x3,%eax
  800ec5:	eb 20                	jmp    800ee7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ec7:	ff 75 14             	pushl  0x14(%ebp)
  800eca:	ff 75 10             	pushl  0x10(%ebp)
  800ecd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ed0:	50                   	push   %eax
  800ed1:	68 5d 0e 80 00       	push   $0x800e5d
  800ed6:	e8 80 fb ff ff       	call   800a5b <vprintfmt>
  800edb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ee1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800eef:	8d 45 10             	lea    0x10(%ebp),%eax
  800ef2:	83 c0 04             	add    $0x4,%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	ff 75 f4             	pushl  -0xc(%ebp)
  800efe:	50                   	push   %eax
  800eff:	ff 75 0c             	pushl  0xc(%ebp)
  800f02:	ff 75 08             	pushl  0x8(%ebp)
  800f05:	e8 89 ff ff ff       	call   800e93 <vsnprintf>
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f22:	eb 06                	jmp    800f2a <strlen+0x15>
		n++;
  800f24:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f27:	ff 45 08             	incl   0x8(%ebp)
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	84 c0                	test   %al,%al
  800f31:	75 f1                	jne    800f24 <strlen+0xf>
		n++;
	return n;
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f45:	eb 09                	jmp    800f50 <strnlen+0x18>
		n++;
  800f47:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	ff 4d 0c             	decl   0xc(%ebp)
  800f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f54:	74 09                	je     800f5f <strnlen+0x27>
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	75 e8                	jne    800f47 <strnlen+0xf>
		n++;
	return n;
  800f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f70:	90                   	nop
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8d 50 01             	lea    0x1(%eax),%edx
  800f77:	89 55 08             	mov    %edx,0x8(%ebp)
  800f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	84 c0                	test   %al,%al
  800f8b:	75 e4                	jne    800f71 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fa5:	eb 1f                	jmp    800fc6 <strncpy+0x34>
		*dst++ = *src;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8d 50 01             	lea    0x1(%eax),%edx
  800fad:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb3:	8a 12                	mov    (%edx),%dl
  800fb5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 03                	je     800fc3 <strncpy+0x31>
			src++;
  800fc0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc3:	ff 45 fc             	incl   -0x4(%ebp)
  800fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fcc:	72 d9                	jb     800fa7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	74 30                	je     801015 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fe5:	eb 16                	jmp    800ffd <strlcpy+0x2a>
			*dst++ = *src++;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8d 50 01             	lea    0x1(%eax),%edx
  800fed:	89 55 08             	mov    %edx,0x8(%ebp)
  800ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ff6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ff9:	8a 12                	mov    (%edx),%dl
  800ffb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ffd:	ff 4d 10             	decl   0x10(%ebp)
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	74 09                	je     80100f <strlcpy+0x3c>
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	75 d8                	jne    800fe7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101b:	29 c2                	sub    %eax,%edx
  80101d:	89 d0                	mov    %edx,%eax
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801024:	eb 06                	jmp    80102c <strcmp+0xb>
		p++, q++;
  801026:	ff 45 08             	incl   0x8(%ebp)
  801029:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	74 0e                	je     801043 <strcmp+0x22>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 10                	mov    (%eax),%dl
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	38 c2                	cmp    %al,%dl
  801041:	74 e3                	je     801026 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	8a 00                	mov    (%eax),%al
  801048:	0f b6 d0             	movzbl %al,%edx
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f b6 c0             	movzbl %al,%eax
  801053:	29 c2                	sub    %eax,%edx
  801055:	89 d0                	mov    %edx,%eax
}
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80105c:	eb 09                	jmp    801067 <strncmp+0xe>
		n--, p++, q++;
  80105e:	ff 4d 10             	decl   0x10(%ebp)
  801061:	ff 45 08             	incl   0x8(%ebp)
  801064:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801067:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106b:	74 17                	je     801084 <strncmp+0x2b>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	84 c0                	test   %al,%al
  801074:	74 0e                	je     801084 <strncmp+0x2b>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 10                	mov    (%eax),%dl
  80107b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	38 c2                	cmp    %al,%dl
  801082:	74 da                	je     80105e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801084:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801088:	75 07                	jne    801091 <strncmp+0x38>
		return 0;
  80108a:	b8 00 00 00 00       	mov    $0x0,%eax
  80108f:	eb 14                	jmp    8010a5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	0f b6 d0             	movzbl %al,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	0f b6 c0             	movzbl %al,%eax
  8010a1:	29 c2                	sub    %eax,%edx
  8010a3:	89 d0                	mov    %edx,%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 12                	jmp    8010c7 <strchr+0x20>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	75 05                	jne    8010c4 <strchr+0x1d>
			return (char *) s;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	eb 11                	jmp    8010d5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	84 c0                	test   %al,%al
  8010ce:	75 e5                	jne    8010b5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010e3:	eb 0d                	jmp    8010f2 <strfind+0x1b>
		if (*s == c)
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010ed:	74 0e                	je     8010fd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010ef:	ff 45 08             	incl   0x8(%ebp)
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	84 c0                	test   %al,%al
  8010f9:	75 ea                	jne    8010e5 <strfind+0xe>
  8010fb:	eb 01                	jmp    8010fe <strfind+0x27>
		if (*s == c)
			break;
  8010fd:	90                   	nop
	return (char *) s;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80110f:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801113:	76 63                	jbe    801178 <memset+0x75>
		uint64 data_block = c;
  801115:	8b 45 0c             	mov    0xc(%ebp),%eax
  801118:	99                   	cltd   
  801119:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80111c:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80111f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801125:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801129:	c1 e0 08             	shl    $0x8,%eax
  80112c:	09 45 f0             	or     %eax,-0x10(%ebp)
  80112f:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801138:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  80113c:	c1 e0 10             	shl    $0x10,%eax
  80113f:	09 45 f0             	or     %eax,-0x10(%ebp)
  801142:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	09 45 f0             	or     %eax,-0x10(%ebp)
  801155:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801158:	eb 18                	jmp    801172 <memset+0x6f>
			*p64++ = data_block, n -= 8;
  80115a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115d:	8d 41 08             	lea    0x8(%ecx),%eax
  801160:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801169:	89 01                	mov    %eax,(%ecx)
  80116b:	89 51 04             	mov    %edx,0x4(%ecx)
  80116e:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801172:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801176:	77 e2                	ja     80115a <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801178:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117c:	74 23                	je     8011a1 <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801181:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801184:	eb 0e                	jmp    801194 <memset+0x91>
			*p8++ = (uint8)c;
  801186:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801189:	8d 50 01             	lea    0x1(%eax),%edx
  80118c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801192:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 e5                	jne    801186 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8011ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8011b8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011bc:	76 24                	jbe    8011e2 <memcpy+0x3c>
		while(n >= 8){
  8011be:	eb 1c                	jmp    8011dc <memcpy+0x36>
			*d64 = *s64;
  8011c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c3:	8b 50 04             	mov    0x4(%eax),%edx
  8011c6:	8b 00                	mov    (%eax),%eax
  8011c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011cb:	89 01                	mov    %eax,(%ecx)
  8011cd:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8011d0:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8011d4:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8011d8:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8011dc:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8011e0:	77 de                	ja     8011c0 <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8011e2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e6:	74 31                	je     801219 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8011e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8011ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8011f4:	eb 16                	jmp    80120c <memcpy+0x66>
			*d8++ = *s8++;
  8011f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f9:	8d 50 01             	lea    0x1(%eax),%edx
  8011fc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8011ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801202:	8d 4a 01             	lea    0x1(%edx),%ecx
  801205:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  801208:	8a 12                	mov    (%edx),%dl
  80120a:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801212:	89 55 10             	mov    %edx,0x10(%ebp)
  801215:	85 c0                	test   %eax,%eax
  801217:	75 dd                	jne    8011f6 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801224:	8b 45 0c             	mov    0xc(%ebp),%eax
  801227:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801230:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801233:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801236:	73 50                	jae    801288 <memmove+0x6a>
  801238:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123b:	8b 45 10             	mov    0x10(%ebp),%eax
  80123e:	01 d0                	add    %edx,%eax
  801240:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801243:	76 43                	jbe    801288 <memmove+0x6a>
		s += n;
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80124b:	8b 45 10             	mov    0x10(%ebp),%eax
  80124e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801251:	eb 10                	jmp    801263 <memmove+0x45>
			*--d = *--s;
  801253:	ff 4d f8             	decl   -0x8(%ebp)
  801256:	ff 4d fc             	decl   -0x4(%ebp)
  801259:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125c:	8a 10                	mov    (%eax),%dl
  80125e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801261:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	8d 50 ff             	lea    -0x1(%eax),%edx
  801269:	89 55 10             	mov    %edx,0x10(%ebp)
  80126c:	85 c0                	test   %eax,%eax
  80126e:	75 e3                	jne    801253 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801270:	eb 23                	jmp    801295 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801272:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801275:	8d 50 01             	lea    0x1(%eax),%edx
  801278:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80127b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801281:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801284:	8a 12                	mov    (%edx),%dl
  801286:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 dd                	jne    801272 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801298:	c9                   	leave  
  801299:	c3                   	ret    

0080129a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ac:	eb 2a                	jmp    8012d8 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b1:	8a 10                	mov    (%eax),%dl
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	38 c2                	cmp    %al,%dl
  8012ba:	74 16                	je     8012d2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bf:	8a 00                	mov    (%eax),%al
  8012c1:	0f b6 d0             	movzbl %al,%edx
  8012c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	0f b6 c0             	movzbl %al,%eax
  8012cc:	29 c2                	sub    %eax,%edx
  8012ce:	89 d0                	mov    %edx,%eax
  8012d0:	eb 18                	jmp    8012ea <memcmp+0x50>
		s1++, s2++;
  8012d2:	ff 45 fc             	incl   -0x4(%ebp)
  8012d5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012de:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	75 c9                	jne    8012ae <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8012f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f8:	01 d0                	add    %edx,%eax
  8012fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8012fd:	eb 15                	jmp    801314 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	8a 00                	mov    (%eax),%al
  801304:	0f b6 d0             	movzbl %al,%edx
  801307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	39 c2                	cmp    %eax,%edx
  80130f:	74 0d                	je     80131e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801311:	ff 45 08             	incl   0x8(%ebp)
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80131a:	72 e3                	jb     8012ff <memfind+0x13>
  80131c:	eb 01                	jmp    80131f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80131e:	90                   	nop
	return (void *) s;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801322:	c9                   	leave  
  801323:	c3                   	ret    

00801324 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801324:	55                   	push   %ebp
  801325:	89 e5                	mov    %esp,%ebp
  801327:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80132a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801331:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801338:	eb 03                	jmp    80133d <strtol+0x19>
		s++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	3c 20                	cmp    $0x20,%al
  801344:	74 f4                	je     80133a <strtol+0x16>
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	3c 09                	cmp    $0x9,%al
  80134d:	74 eb                	je     80133a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	3c 2b                	cmp    $0x2b,%al
  801356:	75 05                	jne    80135d <strtol+0x39>
		s++;
  801358:	ff 45 08             	incl   0x8(%ebp)
  80135b:	eb 13                	jmp    801370 <strtol+0x4c>
	else if (*s == '-')
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	8a 00                	mov    (%eax),%al
  801362:	3c 2d                	cmp    $0x2d,%al
  801364:	75 0a                	jne    801370 <strtol+0x4c>
		s++, neg = 1;
  801366:	ff 45 08             	incl   0x8(%ebp)
  801369:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801370:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801374:	74 06                	je     80137c <strtol+0x58>
  801376:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80137a:	75 20                	jne    80139c <strtol+0x78>
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	8a 00                	mov    (%eax),%al
  801381:	3c 30                	cmp    $0x30,%al
  801383:	75 17                	jne    80139c <strtol+0x78>
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	40                   	inc    %eax
  801389:	8a 00                	mov    (%eax),%al
  80138b:	3c 78                	cmp    $0x78,%al
  80138d:	75 0d                	jne    80139c <strtol+0x78>
		s += 2, base = 16;
  80138f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801393:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80139a:	eb 28                	jmp    8013c4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80139c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013a0:	75 15                	jne    8013b7 <strtol+0x93>
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 30                	cmp    $0x30,%al
  8013a9:	75 0c                	jne    8013b7 <strtol+0x93>
		s++, base = 8;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013b5:	eb 0d                	jmp    8013c4 <strtol+0xa0>
	else if (base == 0)
  8013b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bb:	75 07                	jne    8013c4 <strtol+0xa0>
		base = 10;
  8013bd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	3c 2f                	cmp    $0x2f,%al
  8013cb:	7e 19                	jle    8013e6 <strtol+0xc2>
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 39                	cmp    $0x39,%al
  8013d4:	7f 10                	jg     8013e6 <strtol+0xc2>
			dig = *s - '0';
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	0f be c0             	movsbl %al,%eax
  8013de:	83 e8 30             	sub    $0x30,%eax
  8013e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013e4:	eb 42                	jmp    801428 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	3c 60                	cmp    $0x60,%al
  8013ed:	7e 19                	jle    801408 <strtol+0xe4>
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8a 00                	mov    (%eax),%al
  8013f4:	3c 7a                	cmp    $0x7a,%al
  8013f6:	7f 10                	jg     801408 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	8a 00                	mov    (%eax),%al
  8013fd:	0f be c0             	movsbl %al,%eax
  801400:	83 e8 57             	sub    $0x57,%eax
  801403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801406:	eb 20                	jmp    801428 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 40                	cmp    $0x40,%al
  80140f:	7e 39                	jle    80144a <strtol+0x126>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 5a                	cmp    $0x5a,%al
  801418:	7f 30                	jg     80144a <strtol+0x126>
			dig = *s - 'A' + 10;
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	0f be c0             	movsbl %al,%eax
  801422:	83 e8 37             	sub    $0x37,%eax
  801425:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80142e:	7d 19                	jge    801449 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801430:	ff 45 08             	incl   0x8(%ebp)
  801433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801436:	0f af 45 10          	imul   0x10(%ebp),%eax
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801444:	e9 7b ff ff ff       	jmp    8013c4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801449:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80144a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80144e:	74 08                	je     801458 <strtol+0x134>
		*endptr = (char *) s;
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	8b 55 08             	mov    0x8(%ebp),%edx
  801456:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801458:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80145c:	74 07                	je     801465 <strtol+0x141>
  80145e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801461:	f7 d8                	neg    %eax
  801463:	eb 03                	jmp    801468 <strtol+0x144>
  801465:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <ltostr>:

void
ltostr(long value, char *str)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801477:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80147e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801482:	79 13                	jns    801497 <ltostr+0x2d>
	{
		neg = 1;
  801484:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80148b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801491:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801494:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80149f:	99                   	cltd   
  8014a0:	f7 f9                	idiv   %ecx
  8014a2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ae:	89 c2                	mov    %eax,%edx
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	01 d0                	add    %edx,%eax
  8014b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014b8:	83 c2 30             	add    $0x30,%edx
  8014bb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014c0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014c5:	f7 e9                	imul   %ecx
  8014c7:	c1 fa 02             	sar    $0x2,%edx
  8014ca:	89 c8                	mov    %ecx,%eax
  8014cc:	c1 f8 1f             	sar    $0x1f,%eax
  8014cf:	29 c2                	sub    %eax,%edx
  8014d1:	89 d0                	mov    %edx,%eax
  8014d3:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8014d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014da:	75 bb                	jne    801497 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8014dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8014e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e6:	48                   	dec    %eax
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8014ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ee:	74 3d                	je     80152d <ltostr+0xc3>
		start = 1 ;
  8014f0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8014f7:	eb 34                	jmp    80152d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8014f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	01 d0                	add    %edx,%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801506:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150c:	01 c2                	add    %eax,%edx
  80150e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	01 c8                	add    %ecx,%eax
  801516:	8a 00                	mov    (%eax),%al
  801518:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80151a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80151d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801520:	01 c2                	add    %eax,%edx
  801522:	8a 45 eb             	mov    -0x15(%ebp),%al
  801525:	88 02                	mov    %al,(%edx)
		start++ ;
  801527:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80152a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801530:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801533:	7c c4                	jl     8014f9 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801535:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	01 d0                	add    %edx,%eax
  80153d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	e8 c4 f9 ff ff       	call   800f15 <strlen>
  801551:	83 c4 04             	add    $0x4,%esp
  801554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801557:	ff 75 0c             	pushl  0xc(%ebp)
  80155a:	e8 b6 f9 ff ff       	call   800f15 <strlen>
  80155f:	83 c4 04             	add    $0x4,%esp
  801562:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80156c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801573:	eb 17                	jmp    80158c <strcconcat+0x49>
		final[s] = str1[s] ;
  801575:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801578:	8b 45 10             	mov    0x10(%ebp),%eax
  80157b:	01 c2                	add    %eax,%edx
  80157d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	01 c8                	add    %ecx,%eax
  801585:	8a 00                	mov    (%eax),%al
  801587:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801589:	ff 45 fc             	incl   -0x4(%ebp)
  80158c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80158f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801592:	7c e1                	jl     801575 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801594:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80159b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015a2:	eb 1f                	jmp    8015c3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a7:	8d 50 01             	lea    0x1(%eax),%edx
  8015aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015ad:	89 c2                	mov    %eax,%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 c2                	add    %eax,%edx
  8015b4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	01 c8                	add    %ecx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015c0:	ff 45 f8             	incl   -0x8(%ebp)
  8015c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c9:	7c d9                	jl     8015a4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8015cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d1:	01 d0                	add    %edx,%eax
  8015d3:	c6 00 00             	movb   $0x0,(%eax)
}
  8015d6:	90                   	nop
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8015dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8015df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8015e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f4:	01 d0                	add    %edx,%eax
  8015f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8015fc:	eb 0c                	jmp    80160a <strsplit+0x31>
			*string++ = 0;
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8d 50 01             	lea    0x1(%eax),%edx
  801604:	89 55 08             	mov    %edx,0x8(%ebp)
  801607:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8a 00                	mov    (%eax),%al
  80160f:	84 c0                	test   %al,%al
  801611:	74 18                	je     80162b <strsplit+0x52>
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	8a 00                	mov    (%eax),%al
  801618:	0f be c0             	movsbl %al,%eax
  80161b:	50                   	push   %eax
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	e8 83 fa ff ff       	call   8010a7 <strchr>
  801624:	83 c4 08             	add    $0x8,%esp
  801627:	85 c0                	test   %eax,%eax
  801629:	75 d3                	jne    8015fe <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	84 c0                	test   %al,%al
  801632:	74 5a                	je     80168e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801634:	8b 45 14             	mov    0x14(%ebp),%eax
  801637:	8b 00                	mov    (%eax),%eax
  801639:	83 f8 0f             	cmp    $0xf,%eax
  80163c:	75 07                	jne    801645 <strsplit+0x6c>
		{
			return 0;
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax
  801643:	eb 66                	jmp    8016ab <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 48 01             	lea    0x1(%eax),%ecx
  80164d:	8b 55 14             	mov    0x14(%ebp),%edx
  801650:	89 0a                	mov    %ecx,(%edx)
  801652:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	01 c2                	add    %eax,%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801663:	eb 03                	jmp    801668 <strsplit+0x8f>
			string++;
  801665:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	84 c0                	test   %al,%al
  80166f:	74 8b                	je     8015fc <strsplit+0x23>
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8a 00                	mov    (%eax),%al
  801676:	0f be c0             	movsbl %al,%eax
  801679:	50                   	push   %eax
  80167a:	ff 75 0c             	pushl  0xc(%ebp)
  80167d:	e8 25 fa ff ff       	call   8010a7 <strchr>
  801682:	83 c4 08             	add    $0x8,%esp
  801685:	85 c0                	test   %eax,%eax
  801687:	74 dc                	je     801665 <strsplit+0x8c>
			string++;
	}
  801689:	e9 6e ff ff ff       	jmp    8015fc <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80168e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80168f:	8b 45 14             	mov    0x14(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169b:	8b 45 10             	mov    0x10(%ebp),%eax
  80169e:	01 d0                	add    %edx,%eax
  8016a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 4a                	jmp    80170c <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8016d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	01 d0                	add    %edx,%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	3c 40                	cmp    $0x40,%al
  8016e2:	7e 25                	jle    801709 <str2lower+0x5c>
  8016e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	8a 00                	mov    (%eax),%al
  8016ee:	3c 5a                	cmp    $0x5a,%al
  8016f0:	7f 17                	jg     801709 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8016f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	01 d0                	add    %edx,%eax
  8016fa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801700:	01 ca                	add    %ecx,%edx
  801702:	8a 12                	mov    (%edx),%dl
  801704:	83 c2 20             	add    $0x20,%edx
  801707:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801709:	ff 45 fc             	incl   -0x4(%ebp)
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	e8 01 f8 ff ff       	call   800f15 <strlen>
  801714:	83 c4 04             	add    $0x4,%esp
  801717:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80171a:	7f a6                	jg     8016c2 <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  80171c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801727:	a1 08 40 80 00       	mov    0x804008,%eax
  80172c:	85 c0                	test   %eax,%eax
  80172e:	74 42                	je     801772 <uheap_init+0x51>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	68 00 00 00 82       	push   $0x82000000
  801738:	68 00 00 00 80       	push   $0x80000000
  80173d:	e8 00 08 00 00       	call   801f42 <initialize_dynamic_allocator>
  801742:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801745:	e8 e7 05 00 00       	call   801d31 <sys_get_uheap_strategy>
  80174a:	a3 60 c0 81 00       	mov    %eax,0x81c060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80174f:	a1 40 40 80 00       	mov    0x804040,%eax
  801754:	05 00 10 00 00       	add    $0x1000,%eax
  801759:	a3 10 c1 81 00       	mov    %eax,0x81c110
		uheapPageAllocBreak = uheapPageAllocStart;
  80175e:	a1 10 c1 81 00       	mov    0x81c110,%eax
  801763:	a3 68 c0 81 00       	mov    %eax,0x81c068

		__firstTimeFlag = 0;
  801768:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80176f:	00 00 00 
	}
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	68 06 04 00 00       	push   $0x406
  801791:	50                   	push   %eax
  801792:	e8 e4 01 00 00       	call   80197b <__sys_allocate_page>
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80179d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a1:	79 14                	jns    8017b7 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 e8 33 80 00       	push   $0x8033e8
  8017ab:	6a 1f                	push   $0x1f
  8017ad:	68 24 34 80 00       	push   $0x803424
  8017b2:	e8 b7 ed ff ff       	call   80056e <_panic>
	return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d2:	83 ec 0c             	sub    $0xc,%esp
  8017d5:	50                   	push   %eax
  8017d6:	e8 e7 01 00 00       	call   8019c2 <__sys_unmap_frame>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8017e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017e5:	79 14                	jns    8017fb <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  8017e7:	83 ec 04             	sub    $0x4,%esp
  8017ea:	68 30 34 80 00       	push   $0x803430
  8017ef:	6a 2a                	push   $0x2a
  8017f1:	68 24 34 80 00       	push   $0x803424
  8017f6:	e8 73 ed ff ff       	call   80056e <_panic>
}
  8017fb:	90                   	nop
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801804:	e8 18 ff ff ff       	call   801721 <uheap_init>
	if (size == 0) return NULL ;
  801809:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80180d:	75 07                	jne    801816 <malloc+0x18>
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax
  801814:	eb 14                	jmp    80182a <malloc+0x2c>
	//==============================================================
	//TODO: [PROJECT'25.IM#2] USER HEAP - #1 malloc
	//Your code is here
	//Comment the following line
	panic("malloc() is not implemented yet...!!");
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 70 34 80 00       	push   $0x803470
  80181e:	6a 3e                	push   $0x3e
  801820:	68 24 34 80 00       	push   $0x803424
  801825:	e8 44 ed ff ff       	call   80056e <_panic>
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#2] USER HEAP - #3 free
	//Your code is here
	//Comment the following line
	panic("free() is not implemented yet...!!");
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	68 98 34 80 00       	push   $0x803498
  80183a:	6a 49                	push   $0x49
  80183c:	68 24 34 80 00       	push   $0x803424
  801841:	e8 28 ed ff ff       	call   80056e <_panic>

00801846 <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 18             	sub    $0x18,%esp
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801852:	e8 ca fe ff ff       	call   801721 <uheap_init>
	if (size == 0) return NULL ;
  801857:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80185b:	75 07                	jne    801864 <smalloc+0x1e>
  80185d:	b8 00 00 00 00       	mov    $0x0,%eax
  801862:	eb 14                	jmp    801878 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #2 smalloc
	//Your code is here
	//Comment the following line
	panic("smalloc() is not implemented yet...!!");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 bc 34 80 00       	push   $0x8034bc
  80186c:	6a 5a                	push   $0x5a
  80186e:	68 24 34 80 00       	push   $0x803424
  801873:	e8 f6 ec ff ff       	call   80056e <_panic>
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801880:	e8 9c fe ff ff       	call   801721 <uheap_init>
	//==============================================================

	//TODO: [PROJECT'25.IM#3] SHARED MEMORY - #4 sget
	//Your code is here
	//Comment the following line
	panic("sget() is not implemented yet...!!");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 e4 34 80 00       	push   $0x8034e4
  80188d:	6a 6a                	push   $0x6a
  80188f:	68 24 34 80 00       	push   $0x803424
  801894:	e8 d5 ec ff ff       	call   80056e <_panic>

00801899 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80189f:	e8 7d fe ff ff       	call   801721 <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	68 08 35 80 00       	push   $0x803508
  8018ac:	68 88 00 00 00       	push   $0x88
  8018b1:	68 24 34 80 00       	push   $0x803424
  8018b6:	e8 b3 ec ff ff       	call   80056e <_panic>

008018bb <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	68 30 35 80 00       	push   $0x803530
  8018c9:	68 9b 00 00 00       	push   $0x9b
  8018ce:	68 24 34 80 00       	push   $0x803424
  8018d3:	e8 96 ec ff ff       	call   80056e <_panic>

008018d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	57                   	push   %edi
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ed:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018f0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f3:	cd 30                	int    $0x30
  8018f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8018f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	5f                   	pop    %edi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 45 10             	mov    0x10(%ebp),%eax
  80190c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80190f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801912:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	51                   	push   %ecx
  80191c:	52                   	push   %edx
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	50                   	push   %eax
  801921:	6a 00                	push   $0x0
  801923:	e8 b0 ff ff ff       	call   8018d8 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_cgetc>:

int
sys_cgetc(void)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 02                	push   $0x2
  80193d:	e8 96 ff ff ff       	call   8018d8 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 03                	push   $0x3
  801956:	e8 7d ff ff ff       	call   8018d8 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 04                	push   $0x4
  801970:	e8 63 ff ff ff       	call   8018d8 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	50                   	push   %eax
  80198c:	6a 08                	push   $0x8
  80198e:	e8 45 ff ff ff       	call   8018d8 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	56                   	push   %esi
  80199c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80199d:	8b 75 18             	mov    0x18(%ebp),%esi
  8019a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	56                   	push   %esi
  8019ad:	53                   	push   %ebx
  8019ae:	51                   	push   %ecx
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 09                	push   $0x9
  8019b3:	e8 20 ff ff ff       	call   8018d8 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5d                   	pop    %ebp
  8019c1:	c3                   	ret    

008019c2 <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	6a 0a                	push   $0xa
  8019d2:	e8 01 ff ff ff       	call   8018d8 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	6a 0b                	push   $0xb
  8019ed:	e8 e6 fe ff ff       	call   8018d8 <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 0c                	push   $0xc
  801a06:	e8 cd fe ff ff       	call   8018d8 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 0d                	push   $0xd
  801a1f:	e8 b4 fe ff ff       	call   8018d8 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 0e                	push   $0xe
  801a38:	e8 9b fe ff ff       	call   8018d8 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 0f                	push   $0xf
  801a51:	e8 82 fe ff ff       	call   8018d8 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	ff 75 08             	pushl  0x8(%ebp)
  801a69:	6a 10                	push   $0x10
  801a6b:	e8 68 fe ff ff       	call   8018d8 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 11                	push   $0x11
  801a84:	e8 4f fe ff ff       	call   8018d8 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_cputc>:

void
sys_cputc(const char c)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 01                	push   $0x1
  801aaa:	e8 29 fe ff ff       	call   8018d8 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 14                	push   $0x14
  801ac4:	e8 0f fe ff ff       	call   8018d8 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801adb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ade:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	51                   	push   %ecx
  801ae8:	52                   	push   %edx
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	50                   	push   %eax
  801aed:	6a 15                	push   $0x15
  801aef:	e8 e4 fd ff ff       	call   8018d8 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	52                   	push   %edx
  801b09:	50                   	push   %eax
  801b0a:	6a 16                	push   $0x16
  801b0c:	e8 c7 fd ff ff       	call   8018d8 <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	51                   	push   %ecx
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	6a 17                	push   $0x17
  801b2b:	e8 a8 fd ff ff       	call   8018d8 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 18                	push   $0x18
  801b48:	e8 8b fd ff ff       	call   8018d8 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 14             	pushl  0x14(%ebp)
  801b5d:	ff 75 10             	pushl  0x10(%ebp)
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	50                   	push   %eax
  801b64:	6a 19                	push   $0x19
  801b66:	e8 6d fd ff ff       	call   8018d8 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 1a                	push   $0x1a
  801b81:	e8 52 fd ff ff       	call   8018d8 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 1b                	push   $0x1b
  801b9d:	e8 36 fd ff ff       	call   8018d8 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 05                	push   $0x5
  801bb6:	e8 1d fd ff ff       	call   8018d8 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 06                	push   $0x6
  801bcf:	e8 04 fd ff ff       	call   8018d8 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 07                	push   $0x7
  801be8:	e8 eb fc ff ff       	call   8018d8 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 1c                	push   $0x1c
  801c01:	e8 d2 fc ff ff       	call   8018d8 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c15:	8d 50 04             	lea    0x4(%eax),%edx
  801c18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 1d                	push   $0x1d
  801c25:	e8 ae fc ff ff       	call   8018d8 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c36:	89 01                	mov    %eax,(%ecx)
  801c38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	c9                   	leave  
  801c3f:	c2 04 00             	ret    $0x4

00801c42 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 13                	push   $0x13
  801c54:	e8 7f fc ff ff       	call   8018d8 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 1e                	push   $0x1e
  801c6e:	e8 65 fc ff ff       	call   8018d8 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 1f                	push   $0x1f
  801c93:	e8 40 fc ff ff       	call   8018d8 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <rsttst>:
void rsttst()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 21                	push   $0x21
  801cad:	e8 26 fc ff ff       	call   8018d8 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	ff 75 08             	pushl  0x8(%ebp)
  801cd6:	6a 20                	push   $0x20
  801cd8:	e8 fb fb ff ff       	call   8018d8 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <chktst>:
void chktst(uint32 n)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 22                	push   $0x22
  801cf3:	e8 e0 fb ff ff       	call   8018d8 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <inctst>:

void inctst()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 23                	push   $0x23
  801d0d:	e8 c6 fb ff ff       	call   8018d8 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return ;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <gettst>:
uint32 gettst()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 24                	push   $0x24
  801d27:	e8 ac fb ff ff       	call   8018d8 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 25                	push   $0x25
  801d40:	e8 93 fb ff ff       	call   8018d8 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
  801d48:	a3 60 c0 81 00       	mov    %eax,0x81c060
	return uheapPlaceStrategy ;
  801d4d:	a1 60 c0 81 00       	mov    0x81c060,%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	a3 60 c0 81 00       	mov    %eax,0x81c060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	ff 75 08             	pushl  0x8(%ebp)
  801d6a:	6a 26                	push   $0x26
  801d6c:	e8 67 fb ff ff       	call   8018d8 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
	return ;
  801d74:	90                   	nop
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d7b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	53                   	push   %ebx
  801d8a:	51                   	push   %ecx
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 27                	push   $0x27
  801d8f:	e8 44 fb ff ff       	call   8018d8 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 28                	push   $0x28
  801daf:	e8 24 fb ff ff       	call   8018d8 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dbc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	51                   	push   %ecx
  801dc8:	ff 75 10             	pushl  0x10(%ebp)
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	6a 29                	push   $0x29
  801dcf:	e8 04 fb ff ff       	call   8018d8 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	ff 75 10             	pushl  0x10(%ebp)
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	6a 12                	push   $0x12
  801deb:	e8 e8 fa ff ff       	call   8018d8 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
	return ;
  801df3:	90                   	nop
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 2a                	push   $0x2a
  801e09:	e8 ca fa ff ff       	call   8018d8 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
	return;
  801e11:	90                   	nop
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 2b                	push   $0x2b
  801e23:	e8 b0 fa ff ff       	call   8018d8 <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 2d                	push   $0x2d
  801e3e:	e8 95 fa ff ff       	call   8018d8 <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	6a 2c                	push   $0x2c
  801e5a:	e8 79 fa ff ff       	call   8018d8 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e62:	90                   	nop
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	panic("sys_env_set_priority() is not implemented yet...!!");
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	68 54 35 80 00       	push   $0x803554
  801e73:	68 25 01 00 00       	push   $0x125
  801e78:	68 87 35 80 00       	push   $0x803587
  801e7d:	e8 ec e6 ff ff       	call   80056e <_panic>

00801e82 <to_page_va>:
//==================================
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 18             	sub    $0x18,%esp
	if (ptrPageInfo < &pageBlockInfoArr[0] || ptrPageInfo >= &pageBlockInfoArr[DYN_ALLOC_MAX_SIZE/PAGE_SIZE])
  801e88:	81 7d 08 60 40 80 00 	cmpl   $0x804060,0x8(%ebp)
  801e8f:	72 09                	jb     801e9a <to_page_va+0x18>
  801e91:	81 7d 08 60 c0 81 00 	cmpl   $0x81c060,0x8(%ebp)
  801e98:	72 14                	jb     801eae <to_page_va+0x2c>
			panic("to_page_va called with invalid pageInfoPtr");
  801e9a:	83 ec 04             	sub    $0x4,%esp
  801e9d:	68 98 35 80 00       	push   $0x803598
  801ea2:	6a 15                	push   $0x15
  801ea4:	68 c3 35 80 00       	push   $0x8035c3
  801ea9:	e8 c0 e6 ff ff       	call   80056e <_panic>
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	ba 60 40 80 00       	mov    $0x804060,%edx
  801eb6:	29 d0                	sub    %edx,%eax
  801eb8:	c1 f8 02             	sar    $0x2,%eax
  801ebb:	89 c2                	mov    %eax,%edx
  801ebd:	89 d0                	mov    %edx,%eax
  801ebf:	c1 e0 02             	shl    $0x2,%eax
  801ec2:	01 d0                	add    %edx,%eax
  801ec4:	c1 e0 02             	shl    $0x2,%eax
  801ec7:	01 d0                	add    %edx,%eax
  801ec9:	c1 e0 02             	shl    $0x2,%eax
  801ecc:	01 d0                	add    %edx,%eax
  801ece:	89 c1                	mov    %eax,%ecx
  801ed0:	c1 e1 08             	shl    $0x8,%ecx
  801ed3:	01 c8                	add    %ecx,%eax
  801ed5:	89 c1                	mov    %eax,%ecx
  801ed7:	c1 e1 10             	shl    $0x10,%ecx
  801eda:	01 c8                	add    %ecx,%eax
  801edc:	01 c0                	add    %eax,%eax
  801ede:	01 d0                	add    %edx,%eax
  801ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	c1 e0 0c             	shl    $0xc,%eax
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801ef0:	01 d0                	add    %edx,%eax
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <to_page_info>:

//==================================
// [2] GET PAGE INFO OF PAGE VA:
//==================================
__inline__ struct PageInfoElement * to_page_info(uint32 va)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 18             	sub    $0x18,%esp
	int idxInPageInfoArr = (va - dynAllocStart) >> PGSHIFT;
  801efa:	a1 64 c0 81 00       	mov    0x81c064,%eax
  801eff:	8b 55 08             	mov    0x8(%ebp),%edx
  801f02:	29 c2                	sub    %eax,%edx
  801f04:	89 d0                	mov    %edx,%eax
  801f06:	c1 e8 0c             	shr    $0xc,%eax
  801f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (idxInPageInfoArr < 0 || idxInPageInfoArr >= DYN_ALLOC_MAX_SIZE/PAGE_SIZE)
  801f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f10:	78 09                	js     801f1b <to_page_info+0x27>
  801f12:	81 7d f4 ff 1f 00 00 	cmpl   $0x1fff,-0xc(%ebp)
  801f19:	7e 14                	jle    801f2f <to_page_info+0x3b>
		panic("to_page_info called with invalid pa");
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	68 dc 35 80 00       	push   $0x8035dc
  801f23:	6a 22                	push   $0x22
  801f25:	68 c3 35 80 00       	push   $0x8035c3
  801f2a:	e8 3f e6 ff ff       	call   80056e <_panic>
	return &pageBlockInfoArr[idxInPageInfoArr];
  801f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f32:	89 d0                	mov    %edx,%eax
  801f34:	01 c0                	add    %eax,%eax
  801f36:	01 d0                	add    %edx,%eax
  801f38:	c1 e0 02             	shl    $0x2,%eax
  801f3b:	05 60 40 80 00       	add    $0x804060,%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	05 00 00 00 02       	add    $0x2000000,%eax
  801f50:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f53:	73 16                	jae    801f6b <initialize_dynamic_allocator+0x29>
  801f55:	68 00 36 80 00       	push   $0x803600
  801f5a:	68 26 36 80 00       	push   $0x803626
  801f5f:	6a 34                	push   $0x34
  801f61:	68 c3 35 80 00       	push   $0x8035c3
  801f66:	e8 03 e6 ff ff       	call   80056e <_panic>
		is_initialized = 1;
  801f6b:	c7 05 24 40 80 00 01 	movl   $0x1,0x804024
  801f72:	00 00 00 
	//==================================================================================
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here
	// init bounds of the dynalloc
	dynAllocStart = daStart;
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	a3 64 c0 81 00       	mov    %eax,0x81c064
	dynAllocEnd = daEnd;
  801f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f80:	a3 40 40 80 00       	mov    %eax,0x804040
	// init the list that keep track of all free pageBlockInfoArr instances.
	LIST_INIT(&freePagesList);
  801f85:	c7 05 48 40 80 00 00 	movl   $0x0,0x804048
  801f8c:	00 00 00 
  801f8f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801f96:	00 00 00 
  801f99:	c7 05 54 40 80 00 00 	movl   $0x0,0x804054
  801fa0:	00 00 00 

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	2b 45 08             	sub    0x8(%ebp),%eax
  801fa9:	c1 e8 0c             	shr    $0xc,%eax
  801fac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  801faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb6:	e9 c8 00 00 00       	jmp    802083 <initialize_dynamic_allocator+0x141>
	    pageBlockInfoArr[i].block_size = 0;
  801fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbe:	89 d0                	mov    %edx,%eax
  801fc0:	01 c0                	add    %eax,%eax
  801fc2:	01 d0                	add    %edx,%eax
  801fc4:	c1 e0 02             	shl    $0x2,%eax
  801fc7:	05 68 40 80 00       	add    $0x804068,%eax
  801fcc:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks = 0;
  801fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd4:	89 d0                	mov    %edx,%eax
  801fd6:	01 c0                	add    %eax,%eax
  801fd8:	01 d0                	add    %edx,%eax
  801fda:	c1 e0 02             	shl    $0x2,%eax
  801fdd:	05 6a 40 80 00       	add    $0x80406a,%eax
  801fe2:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  801fe7:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  801fed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ff0:	89 c8                	mov    %ecx,%eax
  801ff2:	01 c0                	add    %eax,%eax
  801ff4:	01 c8                	add    %ecx,%eax
  801ff6:	c1 e0 02             	shl    $0x2,%eax
  801ff9:	05 64 40 80 00       	add    $0x804064,%eax
  801ffe:	89 10                	mov    %edx,(%eax)
  802000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802003:	89 d0                	mov    %edx,%eax
  802005:	01 c0                	add    %eax,%eax
  802007:	01 d0                	add    %edx,%eax
  802009:	c1 e0 02             	shl    $0x2,%eax
  80200c:	05 64 40 80 00       	add    $0x804064,%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	74 1b                	je     802032 <initialize_dynamic_allocator+0xf0>
  802017:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  80201d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802020:	89 c8                	mov    %ecx,%eax
  802022:	01 c0                	add    %eax,%eax
  802024:	01 c8                	add    %ecx,%eax
  802026:	c1 e0 02             	shl    $0x2,%eax
  802029:	05 60 40 80 00       	add    $0x804060,%eax
  80202e:	89 02                	mov    %eax,(%edx)
  802030:	eb 16                	jmp    802048 <initialize_dynamic_allocator+0x106>
  802032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802035:	89 d0                	mov    %edx,%eax
  802037:	01 c0                	add    %eax,%eax
  802039:	01 d0                	add    %edx,%eax
  80203b:	c1 e0 02             	shl    $0x2,%eax
  80203e:	05 60 40 80 00       	add    $0x804060,%eax
  802043:	a3 48 40 80 00       	mov    %eax,0x804048
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	01 c0                	add    %eax,%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	c1 e0 02             	shl    $0x2,%eax
  802054:	05 60 40 80 00       	add    $0x804060,%eax
  802059:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80205e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802061:	89 d0                	mov    %edx,%eax
  802063:	01 c0                	add    %eax,%eax
  802065:	01 d0                	add    %edx,%eax
  802067:	c1 e0 02             	shl    $0x2,%eax
  80206a:	05 60 40 80 00       	add    $0x804060,%eax
  80206f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802075:	a1 54 40 80 00       	mov    0x804054,%eax
  80207a:	40                   	inc    %eax
  80207b:	a3 54 40 80 00       	mov    %eax,0x804054
	LIST_INIT(&freePagesList);

	// no.of pages in the dynamic allocator.
	int pCount = (daEnd - daStart) / PAGE_SIZE;
	// iterate over each page and init its data in pageBlockInfoArr and reset it.
	for (int i = 0; i < pCount; ++i) {
  802080:	ff 45 f4             	incl   -0xc(%ebp)
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802089:	0f 8c 2c ff ff ff    	jl     801fbb <initialize_dynamic_allocator+0x79>
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  80208f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802096:	eb 36                	jmp    8020ce <initialize_dynamic_allocator+0x18c>
		LIST_INIT(&freeBlockLists[i]);
  802098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209b:	c1 e0 04             	shl    $0x4,%eax
  80209e:	05 80 c0 81 00       	add    $0x81c080,%eax
  8020a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ac:	c1 e0 04             	shl    $0x4,%eax
  8020af:	05 84 c0 81 00       	add    $0x81c084,%eax
  8020b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	c1 e0 04             	shl    $0x4,%eax
  8020c0:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8020c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}
	// init the array of lists of each size..
	// 8 16 32 64 128 256 512 1024 2056
	// 0 1  2  3   4  5    6   7    8
	for (int i = 0; i <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE); ++i){
  8020cb:	ff 45 f0             	incl   -0x10(%ebp)
  8020ce:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  8020d2:	7e c4                	jle    802098 <initialize_dynamic_allocator+0x156>
		LIST_INIT(&freeBlockLists[i]);
	}
	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <get_block_size>:

//===========================
// [2] GET BLOCK SIZE:
//===========================
__inline__ uint32 get_block_size(void *va)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here
	// get the page that saves this va
	struct PageInfoElement* ptr = to_page_info((uint32)va);
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	50                   	push   %eax
  8020e4:	e8 0b fe ff ff       	call   801ef4 <to_page_info>
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return ptr->block_size;
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <split_page_to_blocks>:
// =====================
// h) split page to blocks and add them in freeBlockLists
// =====================
// function that split the page provided into same sized blocks
//and putem in suitable freeblockList index according to size.
 void split_page_to_blocks(uint32 blk_size, struct PageInfoElement *pageInfo) {
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	83 ec 28             	sub    $0x28,%esp
	 // cur page virtual address by the pageInfo.
	 uint32 page_va = (uint32)to_page_va(pageInfo);
  802100:	83 ec 0c             	sub    $0xc,%esp
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	e8 77 fd ff ff       	call   801e82 <to_page_va>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 // no. of blks to save in freeblockList.
	 int blk_count = PAGE_SIZE / blk_size;
  802111:	b8 00 10 00 00       	mov    $0x1000,%eax
  802116:	ba 00 00 00 00       	mov    $0x0,%edx
  80211b:	f7 75 08             	divl   0x8(%ebp)
  80211e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	 // save page in memory.
	 get_page((uint32*)page_va);
  802121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	50                   	push   %eax
  802128:	e8 48 f6 ff ff       	call   801775 <get_page>
  80212d:	83 c4 10             	add    $0x10,%esp
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
  802130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802133:	8b 55 0c             	mov    0xc(%ebp),%edx
  802136:	66 89 42 0a          	mov    %ax,0xa(%edx)
	 pageInfo->block_size = blk_size;
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	66 89 42 08          	mov    %ax,0x8(%edx)
	 // get index by size block in freeblocklist.
	 int idx = 0;
  802144:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80214b:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  802152:	eb 19                	jmp    80216d <split_page_to_blocks+0x73>
	     if ((1 << i) == blk_size)
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	ba 01 00 00 00       	mov    $0x1,%edx
  80215c:	88 c1                	mov    %al,%cl
  80215e:	d3 e2                	shl    %cl,%edx
  802160:	89 d0                	mov    %edx,%eax
  802162:	3b 45 08             	cmp    0x8(%ebp),%eax
  802165:	74 0e                	je     802175 <split_page_to_blocks+0x7b>
	         break;
	     idx++;
  802167:	ff 45 f4             	incl   -0xc(%ebp)
	 // assigning the pageInfo data block size, free block which is whole block count.
	 pageInfo->num_of_free_blocks = blk_count;
	 pageInfo->block_size = blk_size;
	 // get index by size block in freeblocklist.
	 int idx = 0;
	 for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  80216a:	ff 45 f0             	incl   -0x10(%ebp)
  80216d:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  802171:	7e e1                	jle    802154 <split_page_to_blocks+0x5a>
  802173:	eb 01                	jmp    802176 <split_page_to_blocks+0x7c>
	     if ((1 << i) == blk_size)
	         break;
  802175:	90                   	nop
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802176:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80217d:	e9 a7 00 00 00       	jmp    802229 <split_page_to_blocks+0x12f>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
  802182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802185:	0f af 45 08          	imul   0x8(%ebp),%eax
  802189:	89 c2                	mov    %eax,%edx
  80218b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218e:	01 d0                	add    %edx,%eax
  802190:	89 45 e0             	mov    %eax,-0x20(%ebp)
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
  802193:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802197:	75 14                	jne    8021ad <split_page_to_blocks+0xb3>
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 3c 36 80 00       	push   $0x80363c
  8021a1:	6a 7c                	push   $0x7c
  8021a3:	68 c3 35 80 00       	push   $0x8035c3
  8021a8:	e8 c1 e3 ff ff       	call   80056e <_panic>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	c1 e0 04             	shl    $0x4,%eax
  8021b3:	05 84 c0 81 00       	add    $0x81c084,%eax
  8021b8:	8b 10                	mov    (%eax),%edx
  8021ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bd:	89 50 04             	mov    %edx,0x4(%eax)
  8021c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c3:	8b 40 04             	mov    0x4(%eax),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 14                	je     8021de <split_page_to_blocks+0xe4>
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c1 e0 04             	shl    $0x4,%eax
  8021d0:	05 84 c0 81 00       	add    $0x81c084,%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021da:	89 10                	mov    %edx,(%eax)
  8021dc:	eb 11                	jmp    8021ef <split_page_to_blocks+0xf5>
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	c1 e0 04             	shl    $0x4,%eax
  8021e4:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  8021ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ed:	89 02                	mov    %eax,(%edx)
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	c1 e0 04             	shl    $0x4,%eax
  8021f5:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  8021fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fe:	89 02                	mov    %eax,(%edx)
  802200:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	c1 e0 04             	shl    $0x4,%eax
  80220f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	8d 50 01             	lea    0x1(%eax),%edx
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	c1 e0 04             	shl    $0x4,%eax
  80221f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802224:	89 10                	mov    %edx,(%eax)
	         break;
	     idx++;
	 }
	 // iterate over each blk and make and element of it by passing its address in blockElement pointer and save those in the list.
	 // starting from the page_va.
	 for (uint32 i = 0; i < blk_count; ++i) {
  802226:	ff 45 ec             	incl   -0x14(%ebp)
  802229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80222c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  80222f:	0f 82 4d ff ff ff    	jb     802182 <split_page_to_blocks+0x88>
	     struct BlockElement *blk =(struct BlockElement*)(page_va + i * blk_size);
	     LIST_INSERT_TAIL(&freeBlockLists[idx],blk);
	 }
 }
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  80223e:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802245:	76 19                	jbe    802260 <alloc_block+0x28>
  802247:	68 60 36 80 00       	push   $0x803660
  80224c:	68 26 36 80 00       	push   $0x803626
  802251:	68 8a 00 00 00       	push   $0x8a
  802256:	68 c3 35 80 00       	push   $0x8035c3
  80225b:	e8 0e e3 ff ff       	call   80056e <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
  802260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802267:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  80226e:	eb 19                	jmp    802289 <alloc_block+0x51>
		if((1 << i) >= size) break;
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	ba 01 00 00 00       	mov    $0x1,%edx
  802278:	88 c1                	mov    %al,%cl
  80227a:	d3 e2                	shl    %cl,%edx
  80227c:	89 d0                	mov    %edx,%eax
  80227e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802281:	73 0e                	jae    802291 <alloc_block+0x59>
		idx++;
  802283:	ff 45 f4             	incl   -0xc(%ebp)
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here
	//Comment the following line
	// get index in freeBlockList by size.
	uint32 idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; ++i){
  802286:	ff 45 f0             	incl   -0x10(%ebp)
  802289:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  80228d:	7e e1                	jle    802270 <alloc_block+0x38>
  80228f:	eb 01                	jmp    802292 <alloc_block+0x5a>
		if((1 << i) >= size) break;
  802291:	90                   	nop
		idx++;
	}

	//case 1: the free block of the cur size is available.
	if (freeBlockLists[idx].size > 0) {
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	c1 e0 04             	shl    $0x4,%eax
  802298:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	0f 84 df 00 00 00    	je     802386 <alloc_block+0x14e>

		// remove from the list and updat the pageInfoArr free blocks.
		// pop from the freeBlockList.
		struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	c1 e0 04             	shl    $0x4,%eax
  8022ad:	05 80 c0 81 00       	add    $0x81c080,%eax
  8022b2:	8b 00                	mov    (%eax),%eax
  8022b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    LIST_REMOVE(&freeBlockLists[idx], blk);
  8022b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022bb:	75 17                	jne    8022d4 <alloc_block+0x9c>
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	68 81 36 80 00       	push   $0x803681
  8022c5:	68 9e 00 00 00       	push   $0x9e
  8022ca:	68 c3 35 80 00       	push   $0x8035c3
  8022cf:	e8 9a e2 ff ff       	call   80056e <_panic>
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 10                	je     8022ed <alloc_block+0xb5>
  8022dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022e5:	8b 52 04             	mov    0x4(%edx),%edx
  8022e8:	89 50 04             	mov    %edx,0x4(%eax)
  8022eb:	eb 14                	jmp    802301 <alloc_block+0xc9>
  8022ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f0:	8b 40 04             	mov    0x4(%eax),%eax
  8022f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f6:	c1 e2 04             	shl    $0x4,%edx
  8022f9:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  8022ff:	89 02                	mov    %eax,(%edx)
  802301:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	74 0f                	je     80231a <alloc_block+0xe2>
  80230b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802314:	8b 12                	mov    (%edx),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	eb 13                	jmp    80232d <alloc_block+0xf5>
  80231a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	c1 e2 04             	shl    $0x4,%edx
  802325:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  80232b:	89 02                	mov    %eax,(%edx)
  80232d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802330:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802339:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	c1 e0 04             	shl    $0x4,%eax
  802346:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	8d 50 ff             	lea    -0x1(%eax),%edx
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	c1 e0 04             	shl    $0x4,%eax
  802356:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80235b:	89 10                	mov    %edx,(%eax)
	    // update pageBlockInfoArr
	    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  80235d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	50                   	push   %eax
  802364:	e8 8b fb ff ff       	call   801ef4 <to_page_info>
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	    pageInfo->num_of_free_blocks--;
  80236f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802372:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802376:	48                   	dec    %eax
  802377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80237a:	66 89 42 0a          	mov    %ax,0xa(%edx)
	    return blk;
  80237e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802381:	e9 bc 02 00 00       	jmp    802642 <alloc_block+0x40a>
	}else{ //case(2, 3): 2. no free blocks available in the freeblocklist but there is free pages.
				//3. no free blocks and no available freepages so search in higher block sizes.
		// case 2:
		if(freePagesList.size > 0){ //have free pages.
  802386:	a1 54 40 80 00       	mov    0x804054,%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	0f 84 7d 02 00 00    	je     802610 <alloc_block+0x3d8>
			// get page to split and use from freepagesList.
			struct PageInfoElement *ptr_new_page = LIST_FIRST(&freePagesList);
  802393:	a1 48 40 80 00       	mov    0x804048,%eax
  802398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			LIST_REMOVE(&freePagesList, ptr_new_page);
  80239b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80239f:	75 17                	jne    8023b8 <alloc_block+0x180>
  8023a1:	83 ec 04             	sub    $0x4,%esp
  8023a4:	68 81 36 80 00       	push   $0x803681
  8023a9:	68 a9 00 00 00       	push   $0xa9
  8023ae:	68 c3 35 80 00       	push   $0x8035c3
  8023b3:	e8 b6 e1 ff ff       	call   80056e <_panic>
  8023b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	74 10                	je     8023d1 <alloc_block+0x199>
  8023c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c4:	8b 00                	mov    (%eax),%eax
  8023c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c9:	8b 52 04             	mov    0x4(%edx),%edx
  8023cc:	89 50 04             	mov    %edx,0x4(%eax)
  8023cf:	eb 0b                	jmp    8023dc <alloc_block+0x1a4>
  8023d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023df:	8b 40 04             	mov    0x4(%eax),%eax
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	74 0f                	je     8023f5 <alloc_block+0x1bd>
  8023e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ef:	8b 12                	mov    (%edx),%edx
  8023f1:	89 10                	mov    %edx,(%eax)
  8023f3:	eb 0a                	jmp    8023ff <alloc_block+0x1c7>
  8023f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	a3 48 40 80 00       	mov    %eax,0x804048
  8023ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802402:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802412:	a1 54 40 80 00       	mov    0x804054,%eax
  802417:	48                   	dec    %eax
  802418:	a3 54 40 80 00       	mov    %eax,0x804054
			// from page to freeblockList by the pageInfo and the block size.
			split_page_to_blocks(1 << (idx + LOG2_MIN_SIZE), ptr_new_page);
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	83 c0 03             	add    $0x3,%eax
  802423:	ba 01 00 00 00       	mov    $0x1,%edx
  802428:	88 c1                	mov    %al,%cl
  80242a:	d3 e2                	shl    %cl,%edx
  80242c:	89 d0                	mov    %edx,%eax
  80242e:	83 ec 08             	sub    $0x8,%esp
  802431:	ff 75 e4             	pushl  -0x1c(%ebp)
  802434:	50                   	push   %eax
  802435:	e8 c0 fc ff ff       	call   8020fa <split_page_to_blocks>
  80243a:	83 c4 10             	add    $0x10,%esp

			// remove from the list and updat the pageInfoArr free blocks.
			// pop from the freeBlockList.
			struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	c1 e0 04             	shl    $0x4,%eax
  802443:	05 80 c0 81 00       	add    $0x81c080,%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		    LIST_REMOVE(&freeBlockLists[idx], blk);
  80244d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802451:	75 17                	jne    80246a <alloc_block+0x232>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 81 36 80 00       	push   $0x803681
  80245b:	68 b0 00 00 00       	push   $0xb0
  802460:	68 c3 35 80 00       	push   $0x8035c3
  802465:	e8 04 e1 ff ff       	call   80056e <_panic>
  80246a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 10                	je     802483 <alloc_block+0x24b>
  802473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80247b:	8b 52 04             	mov    0x4(%edx),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	eb 14                	jmp    802497 <alloc_block+0x25f>
  802483:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248c:	c1 e2 04             	shl    $0x4,%edx
  80248f:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802495:	89 02                	mov    %eax,(%edx)
  802497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 0f                	je     8024b0 <alloc_block+0x278>
  8024a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024aa:	8b 12                	mov    (%edx),%edx
  8024ac:	89 10                	mov    %edx,(%eax)
  8024ae:	eb 13                	jmp    8024c3 <alloc_block+0x28b>
  8024b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	c1 e2 04             	shl    $0x4,%edx
  8024bb:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8024c1:	89 02                	mov    %eax,(%edx)
  8024c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	c1 e0 04             	shl    $0x4,%eax
  8024dc:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	c1 e0 04             	shl    $0x4,%eax
  8024ec:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8024f1:	89 10                	mov    %edx,(%eax)
		    // update pageBlockInfoArr
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8024f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	50                   	push   %eax
  8024fa:	e8 f5 f9 ff ff       	call   801ef4 <to_page_info>
  8024ff:	83 c4 10             	add    $0x10,%esp
  802502:	89 45 dc             	mov    %eax,-0x24(%ebp)
		    pageInfo->num_of_free_blocks--;
  802505:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802508:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80250c:	48                   	dec    %eax
  80250d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802510:	66 89 42 0a          	mov    %ax,0xa(%edx)
		    return blk;
  802514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802517:	e9 26 01 00 00       	jmp    802642 <alloc_block+0x40a>
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
				idx++;
  80251c:	ff 45 f4             	incl   -0xc(%ebp)
				// found free block
				if(freeBlockLists[idx].size > 0){
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c1 e0 04             	shl    $0x4,%eax
  802525:	05 8c c0 81 00       	add    $0x81c08c,%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	0f 84 dc 00 00 00    	je     802610 <alloc_block+0x3d8>
					// remove from the list and updat the pageInfoArr free blocks.
					// pop from the freeBlockList.
					struct BlockElement *blk = LIST_FIRST(&freeBlockLists[idx]);
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	c1 e0 04             	shl    $0x4,%eax
  80253a:	05 80 c0 81 00       	add    $0x81c080,%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	89 45 d8             	mov    %eax,-0x28(%ebp)
				    LIST_REMOVE(&freeBlockLists[idx], blk);
  802544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802548:	75 17                	jne    802561 <alloc_block+0x329>
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 81 36 80 00       	push   $0x803681
  802552:	68 be 00 00 00       	push   $0xbe
  802557:	68 c3 35 80 00       	push   $0x8035c3
  80255c:	e8 0d e0 ff ff       	call   80056e <_panic>
  802561:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 10                	je     80257a <alloc_block+0x342>
  80256a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802572:	8b 52 04             	mov    0x4(%edx),%edx
  802575:	89 50 04             	mov    %edx,0x4(%eax)
  802578:	eb 14                	jmp    80258e <alloc_block+0x356>
  80257a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802583:	c1 e2 04             	shl    $0x4,%edx
  802586:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  80258c:	89 02                	mov    %eax,(%edx)
  80258e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	85 c0                	test   %eax,%eax
  802596:	74 0f                	je     8025a7 <alloc_block+0x36f>
  802598:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025a1:	8b 12                	mov    (%edx),%edx
  8025a3:	89 10                	mov    %edx,(%eax)
  8025a5:	eb 13                	jmp    8025ba <alloc_block+0x382>
  8025a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025af:	c1 e2 04             	shl    $0x4,%edx
  8025b2:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  8025b8:	89 02                	mov    %eax,(%edx)
  8025ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	c1 e0 04             	shl    $0x4,%eax
  8025d3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	c1 e0 04             	shl    $0x4,%eax
  8025e3:	05 8c c0 81 00       	add    $0x81c08c,%eax
  8025e8:	89 10                	mov    %edx,(%eax)
				    // update pageBlockInfoArr
				    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
  8025ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ed:	83 ec 0c             	sub    $0xc,%esp
  8025f0:	50                   	push   %eax
  8025f1:	e8 fe f8 ff ff       	call   801ef4 <to_page_info>
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				    pageInfo->num_of_free_blocks--;
  8025fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ff:	66 8b 40 0a          	mov    0xa(%eax),%ax
  802603:	48                   	dec    %eax
  802604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802607:	66 89 42 0a          	mov    %ax,0xa(%edx)
				    return blk;
  80260b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80260e:	eb 32                	jmp    802642 <alloc_block+0x40a>
		    struct PageInfoElement *pageInfo = to_page_info((uint32)blk);
		    pageInfo->num_of_free_blocks--;
		    return blk;
		}else{//case 3: no free block and no free page so iterate and try to find bigger size.
			// iterate over the list until finding available block
			while (idx <= (LOG2_MAX_SIZE - LOG2_MIN_SIZE) && freeBlockLists[idx].size == 0) {
  802610:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  802614:	77 15                	ja     80262b <alloc_block+0x3f3>
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	c1 e0 04             	shl    $0x4,%eax
  80261c:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 84 f1 fe ff ff    	je     80251c <alloc_block+0x2e4>
				}
			}
		}
	}
	//case4: no free blocks or pages.
	panic("no free blocks!");
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 9f 36 80 00       	push   $0x80369f
  802633:	68 c8 00 00 00       	push   $0xc8
  802638:	68 c3 35 80 00       	push   $0x8035c3
  80263d:	e8 2c df ff ff       	call   80056e <_panic>
	//panic("alloc_block() Not implemented yet");
	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
	return NULL;
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  80264a:	8b 55 08             	mov    0x8(%ebp),%edx
  80264d:	a1 64 c0 81 00       	mov    0x81c064,%eax
  802652:	39 c2                	cmp    %eax,%edx
  802654:	72 0c                	jb     802662 <free_block+0x1e>
  802656:	8b 55 08             	mov    0x8(%ebp),%edx
  802659:	a1 40 40 80 00       	mov    0x804040,%eax
  80265e:	39 c2                	cmp    %eax,%edx
  802660:	72 19                	jb     80267b <free_block+0x37>
  802662:	68 b0 36 80 00       	push   $0x8036b0
  802667:	68 26 36 80 00       	push   $0x803626
  80266c:	68 d7 00 00 00       	push   $0xd7
  802671:	68 c3 35 80 00       	push   $0x8035c3
  802676:	e8 f3 de ff ff       	call   80056e <_panic>
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here
	//Comment the following line
	// va of a piece in memory to free so:
	// 1. get its page, and make blk with this address to be put in the freeBlockList.
	struct BlockElement* blk_to_free = (struct BlockElement*)va;
  80267b:	8b 45 08             	mov    0x8(%ebp),%eax
  80267e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
  802681:	8b 45 08             	mov    0x8(%ebp),%eax
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	50                   	push   %eax
  802688:	e8 67 f8 ff ff       	call   801ef4 <to_page_info>
  80268d:	83 c4 10             	add    $0x10,%esp
  802690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 blk_size = pageInfo->block_size;
  802693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802696:	8b 40 08             	mov    0x8(%eax),%eax
  802699:	0f b7 c0             	movzwl %ax,%eax
  80269c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	// its index in the freeBlocklist.
	int idx = 0;
  80269f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8026a6:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  8026ad:	eb 19                	jmp    8026c8 <free_block+0x84>
	    if ((1 << i) == blk_size)
  8026af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b2:	ba 01 00 00 00       	mov    $0x1,%edx
  8026b7:	88 c1                	mov    %al,%cl
  8026b9:	d3 e2                	shl    %cl,%edx
  8026bb:	89 d0                	mov    %edx,%eax
  8026bd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8026c0:	74 0e                	je     8026d0 <free_block+0x8c>
	        break;
	    idx++;
  8026c2:	ff 45 f4             	incl   -0xc(%ebp)
	struct PageInfoElement *pageInfo = to_page_info((uint32)va);
	uint32 blk_size = pageInfo->block_size;

	// its index in the freeBlocklist.
	int idx = 0;
	for (int i = LOG2_MIN_SIZE; i <= LOG2_MAX_SIZE; i++) {
  8026c5:	ff 45 f0             	incl   -0x10(%ebp)
  8026c8:	83 7d f0 0b          	cmpl   $0xb,-0x10(%ebp)
  8026cc:	7e e1                	jle    8026af <free_block+0x6b>
  8026ce:	eb 01                	jmp    8026d1 <free_block+0x8d>
	    if ((1 << i) == blk_size)
	        break;
  8026d0:	90                   	nop
	    idx++;
	}

	pageInfo->num_of_free_blocks++;
  8026d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d4:	66 8b 40 0a          	mov    0xa(%eax),%ax
  8026d8:	40                   	inc    %eax
  8026d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026dc:	66 89 42 0a          	mov    %ax,0xa(%edx)
	LIST_INSERT_TAIL(&freeBlockLists[idx], blk_to_free);
  8026e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026e4:	75 17                	jne    8026fd <free_block+0xb9>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 3c 36 80 00       	push   $0x80363c
  8026ee:	68 ee 00 00 00       	push   $0xee
  8026f3:	68 c3 35 80 00       	push   $0x8035c3
  8026f8:	e8 71 de ff ff       	call   80056e <_panic>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	c1 e0 04             	shl    $0x4,%eax
  802703:	05 84 c0 81 00       	add    $0x81c084,%eax
  802708:	8b 10                	mov    (%eax),%edx
  80270a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270d:	89 50 04             	mov    %edx,0x4(%eax)
  802710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 14                	je     80272e <free_block+0xea>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	c1 e0 04             	shl    $0x4,%eax
  802720:	05 84 c0 81 00       	add    $0x81c084,%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272a:	89 10                	mov    %edx,(%eax)
  80272c:	eb 11                	jmp    80273f <free_block+0xfb>
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	c1 e0 04             	shl    $0x4,%eax
  802734:	8d 90 80 c0 81 00    	lea    0x81c080(%eax),%edx
  80273a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273d:	89 02                	mov    %eax,(%edx)
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	c1 e0 04             	shl    $0x4,%eax
  802745:	8d 90 84 c0 81 00    	lea    0x81c084(%eax),%edx
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	89 02                	mov    %eax,(%edx)
  802750:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802753:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	c1 e0 04             	shl    $0x4,%eax
  80275f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8d 50 01             	lea    0x1(%eax),%edx
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	c1 e0 04             	shl    $0x4,%eax
  80276f:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802774:	89 10                	mov    %edx,(%eax)

	// now, case 1: the page all blocks are freed so you free the page.
	int blk_count = PAGE_SIZE / blk_size;
  802776:	b8 00 10 00 00       	mov    $0x1000,%eax
  80277b:	ba 00 00 00 00       	mov    $0x0,%edx
  802780:	f7 75 e0             	divl   -0x20(%ebp)
  802783:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
  802786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802789:	66 8b 40 0a          	mov    0xa(%eax),%ax
  80278d:	0f b7 c0             	movzwl %ax,%eax
  802790:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802793:	0f 85 70 01 00 00    	jne    802909 <free_block+0x2c5>
		uint32 page_va = to_page_va(pageInfo);
  802799:	83 ec 0c             	sub    $0xc,%esp
  80279c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80279f:	e8 de f6 ff ff       	call   801e82 <to_page_va>
  8027a4:	83 c4 10             	add    $0x10,%esp
  8027a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  8027aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8027b1:	e9 b7 00 00 00       	jmp    80286d <free_block+0x229>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
  8027b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bc:	01 d0                	add    %edx,%eax
  8027be:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			LIST_REMOVE(&freeBlockLists[idx], blk);
  8027c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8027c5:	75 17                	jne    8027de <free_block+0x19a>
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	68 81 36 80 00       	push   $0x803681
  8027cf:	68 f8 00 00 00       	push   $0xf8
  8027d4:	68 c3 35 80 00       	push   $0x8035c3
  8027d9:	e8 90 dd ff ff       	call   80056e <_panic>
  8027de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	74 10                	je     8027f7 <free_block+0x1b3>
  8027e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027ef:	8b 52 04             	mov    0x4(%edx),%edx
  8027f2:	89 50 04             	mov    %edx,0x4(%eax)
  8027f5:	eb 14                	jmp    80280b <free_block+0x1c7>
  8027f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802800:	c1 e2 04             	shl    $0x4,%edx
  802803:	81 c2 84 c0 81 00    	add    $0x81c084,%edx
  802809:	89 02                	mov    %eax,(%edx)
  80280b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <free_block+0x1e0>
  802815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 13                	jmp    802837 <free_block+0x1f3>
  802824:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	c1 e2 04             	shl    $0x4,%edx
  80282f:	81 c2 80 c0 81 00    	add    $0x81c080,%edx
  802835:	89 02                	mov    %eax,(%edx)
  802837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80283a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	c1 e0 04             	shl    $0x4,%eax
  802850:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	8d 50 ff             	lea    -0x1(%eax),%edx
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	c1 e0 04             	shl    $0x4,%eax
  802860:	05 8c c0 81 00       	add    $0x81c08c,%eax
  802865:	89 10                	mov    %edx,(%eax)
	int blk_count = PAGE_SIZE / blk_size;
	// the blk count in the page is same as number fo free blocks free up the page.
	if (pageInfo->num_of_free_blocks == blk_count) {
		uint32 page_va = to_page_va(pageInfo);
		// remove all blk in the freeBlockList.
		for (uint32 off = 0; off < PAGE_SIZE; off += blk_size) {
  802867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286a:	01 45 ec             	add    %eax,-0x14(%ebp)
  80286d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
  802874:	0f 86 3c ff ff ff    	jbe    8027b6 <free_block+0x172>
			struct BlockElement *blk = (struct BlockElement*)(page_va + off);
			LIST_REMOVE(&freeBlockLists[idx], blk);
		}
		// reset page info.
		pageInfo->block_size = 0;
  80287a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287d:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
		pageInfo->num_of_free_blocks = 0;
  802883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802886:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
		// add it to the available pages.
		LIST_INSERT_TAIL(&freePagesList, pageInfo);
  80288c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802890:	75 17                	jne    8028a9 <free_block+0x265>
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	68 3c 36 80 00       	push   $0x80363c
  80289a:	68 fe 00 00 00       	push   $0xfe
  80289f:	68 c3 35 80 00       	push   $0x8035c3
  8028a4:	e8 c5 dc ff ff       	call   80056e <_panic>
  8028a9:	8b 15 4c 40 80 00    	mov    0x80404c,%edx
  8028af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b2:	89 50 04             	mov    %edx,0x4(%eax)
  8028b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 0c                	je     8028cb <free_block+0x287>
  8028bf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8028c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028c7:	89 10                	mov    %edx,(%eax)
  8028c9:	eb 08                	jmp    8028d3 <free_block+0x28f>
  8028cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ce:	a3 48 40 80 00       	mov    %eax,0x804048
  8028d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8028db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	a1 54 40 80 00       	mov    0x804054,%eax
  8028e9:	40                   	inc    %eax
  8028ea:	a3 54 40 80 00       	mov    %eax,0x804054
		// make it available in memory.
		return_page((uint32 *)to_page_va(pageInfo));
  8028ef:	83 ec 0c             	sub    $0xc,%esp
  8028f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8028f5:	e8 88 f5 ff ff       	call   801e82 <to_page_va>
  8028fa:	83 c4 10             	add    $0x10,%esp
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	50                   	push   %eax
  802901:	e8 b8 ee ff ff       	call   8017be <return_page>
  802906:	83 c4 10             	add    $0x10,%esp
	}
	//panic("free_block() Not implemented yet");
}
  802909:	90                   	nop
  80290a:	c9                   	leave  
  80290b:	c3                   	ret    

0080290c <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
  80290f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 e8 36 80 00       	push   $0x8036e8
  80291a:	68 11 01 00 00       	push   $0x111
  80291f:	68 c3 35 80 00       	push   $0x8035c3
  802924:	e8 45 dc ff ff       	call   80056e <_panic>
  802929:	66 90                	xchg   %ax,%ax
  80292b:	90                   	nop

0080292c <__udivdi3>:
  80292c:	55                   	push   %ebp
  80292d:	57                   	push   %edi
  80292e:	56                   	push   %esi
  80292f:	53                   	push   %ebx
  802930:	83 ec 1c             	sub    $0x1c,%esp
  802933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80293b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80293f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802943:	89 ca                	mov    %ecx,%edx
  802945:	89 f8                	mov    %edi,%eax
  802947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80294b:	85 f6                	test   %esi,%esi
  80294d:	75 2d                	jne    80297c <__udivdi3+0x50>
  80294f:	39 cf                	cmp    %ecx,%edi
  802951:	77 65                	ja     8029b8 <__udivdi3+0x8c>
  802953:	89 fd                	mov    %edi,%ebp
  802955:	85 ff                	test   %edi,%edi
  802957:	75 0b                	jne    802964 <__udivdi3+0x38>
  802959:	b8 01 00 00 00       	mov    $0x1,%eax
  80295e:	31 d2                	xor    %edx,%edx
  802960:	f7 f7                	div    %edi
  802962:	89 c5                	mov    %eax,%ebp
  802964:	31 d2                	xor    %edx,%edx
  802966:	89 c8                	mov    %ecx,%eax
  802968:	f7 f5                	div    %ebp
  80296a:	89 c1                	mov    %eax,%ecx
  80296c:	89 d8                	mov    %ebx,%eax
  80296e:	f7 f5                	div    %ebp
  802970:	89 cf                	mov    %ecx,%edi
  802972:	89 fa                	mov    %edi,%edx
  802974:	83 c4 1c             	add    $0x1c,%esp
  802977:	5b                   	pop    %ebx
  802978:	5e                   	pop    %esi
  802979:	5f                   	pop    %edi
  80297a:	5d                   	pop    %ebp
  80297b:	c3                   	ret    
  80297c:	39 ce                	cmp    %ecx,%esi
  80297e:	77 28                	ja     8029a8 <__udivdi3+0x7c>
  802980:	0f bd fe             	bsr    %esi,%edi
  802983:	83 f7 1f             	xor    $0x1f,%edi
  802986:	75 40                	jne    8029c8 <__udivdi3+0x9c>
  802988:	39 ce                	cmp    %ecx,%esi
  80298a:	72 0a                	jb     802996 <__udivdi3+0x6a>
  80298c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802990:	0f 87 9e 00 00 00    	ja     802a34 <__udivdi3+0x108>
  802996:	b8 01 00 00 00       	mov    $0x1,%eax
  80299b:	89 fa                	mov    %edi,%edx
  80299d:	83 c4 1c             	add    $0x1c,%esp
  8029a0:	5b                   	pop    %ebx
  8029a1:	5e                   	pop    %esi
  8029a2:	5f                   	pop    %edi
  8029a3:	5d                   	pop    %ebp
  8029a4:	c3                   	ret    
  8029a5:	8d 76 00             	lea    0x0(%esi),%esi
  8029a8:	31 ff                	xor    %edi,%edi
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	89 fa                	mov    %edi,%edx
  8029ae:	83 c4 1c             	add    $0x1c,%esp
  8029b1:	5b                   	pop    %ebx
  8029b2:	5e                   	pop    %esi
  8029b3:	5f                   	pop    %edi
  8029b4:	5d                   	pop    %ebp
  8029b5:	c3                   	ret    
  8029b6:	66 90                	xchg   %ax,%ax
  8029b8:	89 d8                	mov    %ebx,%eax
  8029ba:	f7 f7                	div    %edi
  8029bc:	31 ff                	xor    %edi,%edi
  8029be:	89 fa                	mov    %edi,%edx
  8029c0:	83 c4 1c             	add    $0x1c,%esp
  8029c3:	5b                   	pop    %ebx
  8029c4:	5e                   	pop    %esi
  8029c5:	5f                   	pop    %edi
  8029c6:	5d                   	pop    %ebp
  8029c7:	c3                   	ret    
  8029c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8029cd:	89 eb                	mov    %ebp,%ebx
  8029cf:	29 fb                	sub    %edi,%ebx
  8029d1:	89 f9                	mov    %edi,%ecx
  8029d3:	d3 e6                	shl    %cl,%esi
  8029d5:	89 c5                	mov    %eax,%ebp
  8029d7:	88 d9                	mov    %bl,%cl
  8029d9:	d3 ed                	shr    %cl,%ebp
  8029db:	89 e9                	mov    %ebp,%ecx
  8029dd:	09 f1                	or     %esi,%ecx
  8029df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8029e3:	89 f9                	mov    %edi,%ecx
  8029e5:	d3 e0                	shl    %cl,%eax
  8029e7:	89 c5                	mov    %eax,%ebp
  8029e9:	89 d6                	mov    %edx,%esi
  8029eb:	88 d9                	mov    %bl,%cl
  8029ed:	d3 ee                	shr    %cl,%esi
  8029ef:	89 f9                	mov    %edi,%ecx
  8029f1:	d3 e2                	shl    %cl,%edx
  8029f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029f7:	88 d9                	mov    %bl,%cl
  8029f9:	d3 e8                	shr    %cl,%eax
  8029fb:	09 c2                	or     %eax,%edx
  8029fd:	89 d0                	mov    %edx,%eax
  8029ff:	89 f2                	mov    %esi,%edx
  802a01:	f7 74 24 0c          	divl   0xc(%esp)
  802a05:	89 d6                	mov    %edx,%esi
  802a07:	89 c3                	mov    %eax,%ebx
  802a09:	f7 e5                	mul    %ebp
  802a0b:	39 d6                	cmp    %edx,%esi
  802a0d:	72 19                	jb     802a28 <__udivdi3+0xfc>
  802a0f:	74 0b                	je     802a1c <__udivdi3+0xf0>
  802a11:	89 d8                	mov    %ebx,%eax
  802a13:	31 ff                	xor    %edi,%edi
  802a15:	e9 58 ff ff ff       	jmp    802972 <__udivdi3+0x46>
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a20:	89 f9                	mov    %edi,%ecx
  802a22:	d3 e2                	shl    %cl,%edx
  802a24:	39 c2                	cmp    %eax,%edx
  802a26:	73 e9                	jae    802a11 <__udivdi3+0xe5>
  802a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802a2b:	31 ff                	xor    %edi,%edi
  802a2d:	e9 40 ff ff ff       	jmp    802972 <__udivdi3+0x46>
  802a32:	66 90                	xchg   %ax,%ax
  802a34:	31 c0                	xor    %eax,%eax
  802a36:	e9 37 ff ff ff       	jmp    802972 <__udivdi3+0x46>
  802a3b:	90                   	nop

00802a3c <__umoddi3>:
  802a3c:	55                   	push   %ebp
  802a3d:	57                   	push   %edi
  802a3e:	56                   	push   %esi
  802a3f:	53                   	push   %ebx
  802a40:	83 ec 1c             	sub    $0x1c,%esp
  802a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  802a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a5b:	89 f3                	mov    %esi,%ebx
  802a5d:	89 fa                	mov    %edi,%edx
  802a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802a63:	89 34 24             	mov    %esi,(%esp)
  802a66:	85 c0                	test   %eax,%eax
  802a68:	75 1a                	jne    802a84 <__umoddi3+0x48>
  802a6a:	39 f7                	cmp    %esi,%edi
  802a6c:	0f 86 a2 00 00 00    	jbe    802b14 <__umoddi3+0xd8>
  802a72:	89 c8                	mov    %ecx,%eax
  802a74:	89 f2                	mov    %esi,%edx
  802a76:	f7 f7                	div    %edi
  802a78:	89 d0                	mov    %edx,%eax
  802a7a:	31 d2                	xor    %edx,%edx
  802a7c:	83 c4 1c             	add    $0x1c,%esp
  802a7f:	5b                   	pop    %ebx
  802a80:	5e                   	pop    %esi
  802a81:	5f                   	pop    %edi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
  802a84:	39 f0                	cmp    %esi,%eax
  802a86:	0f 87 ac 00 00 00    	ja     802b38 <__umoddi3+0xfc>
  802a8c:	0f bd e8             	bsr    %eax,%ebp
  802a8f:	83 f5 1f             	xor    $0x1f,%ebp
  802a92:	0f 84 ac 00 00 00    	je     802b44 <__umoddi3+0x108>
  802a98:	bf 20 00 00 00       	mov    $0x20,%edi
  802a9d:	29 ef                	sub    %ebp,%edi
  802a9f:	89 fe                	mov    %edi,%esi
  802aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aa5:	89 e9                	mov    %ebp,%ecx
  802aa7:	d3 e0                	shl    %cl,%eax
  802aa9:	89 d7                	mov    %edx,%edi
  802aab:	89 f1                	mov    %esi,%ecx
  802aad:	d3 ef                	shr    %cl,%edi
  802aaf:	09 c7                	or     %eax,%edi
  802ab1:	89 e9                	mov    %ebp,%ecx
  802ab3:	d3 e2                	shl    %cl,%edx
  802ab5:	89 14 24             	mov    %edx,(%esp)
  802ab8:	89 d8                	mov    %ebx,%eax
  802aba:	d3 e0                	shl    %cl,%eax
  802abc:	89 c2                	mov    %eax,%edx
  802abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ac2:	d3 e0                	shl    %cl,%eax
  802ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  802acc:	89 f1                	mov    %esi,%ecx
  802ace:	d3 e8                	shr    %cl,%eax
  802ad0:	09 d0                	or     %edx,%eax
  802ad2:	d3 eb                	shr    %cl,%ebx
  802ad4:	89 da                	mov    %ebx,%edx
  802ad6:	f7 f7                	div    %edi
  802ad8:	89 d3                	mov    %edx,%ebx
  802ada:	f7 24 24             	mull   (%esp)
  802add:	89 c6                	mov    %eax,%esi
  802adf:	89 d1                	mov    %edx,%ecx
  802ae1:	39 d3                	cmp    %edx,%ebx
  802ae3:	0f 82 87 00 00 00    	jb     802b70 <__umoddi3+0x134>
  802ae9:	0f 84 91 00 00 00    	je     802b80 <__umoddi3+0x144>
  802aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  802af3:	29 f2                	sub    %esi,%edx
  802af5:	19 cb                	sbb    %ecx,%ebx
  802af7:	89 d8                	mov    %ebx,%eax
  802af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802afd:	d3 e0                	shl    %cl,%eax
  802aff:	89 e9                	mov    %ebp,%ecx
  802b01:	d3 ea                	shr    %cl,%edx
  802b03:	09 d0                	or     %edx,%eax
  802b05:	89 e9                	mov    %ebp,%ecx
  802b07:	d3 eb                	shr    %cl,%ebx
  802b09:	89 da                	mov    %ebx,%edx
  802b0b:	83 c4 1c             	add    $0x1c,%esp
  802b0e:	5b                   	pop    %ebx
  802b0f:	5e                   	pop    %esi
  802b10:	5f                   	pop    %edi
  802b11:	5d                   	pop    %ebp
  802b12:	c3                   	ret    
  802b13:	90                   	nop
  802b14:	89 fd                	mov    %edi,%ebp
  802b16:	85 ff                	test   %edi,%edi
  802b18:	75 0b                	jne    802b25 <__umoddi3+0xe9>
  802b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1f:	31 d2                	xor    %edx,%edx
  802b21:	f7 f7                	div    %edi
  802b23:	89 c5                	mov    %eax,%ebp
  802b25:	89 f0                	mov    %esi,%eax
  802b27:	31 d2                	xor    %edx,%edx
  802b29:	f7 f5                	div    %ebp
  802b2b:	89 c8                	mov    %ecx,%eax
  802b2d:	f7 f5                	div    %ebp
  802b2f:	89 d0                	mov    %edx,%eax
  802b31:	e9 44 ff ff ff       	jmp    802a7a <__umoddi3+0x3e>
  802b36:	66 90                	xchg   %ax,%ax
  802b38:	89 c8                	mov    %ecx,%eax
  802b3a:	89 f2                	mov    %esi,%edx
  802b3c:	83 c4 1c             	add    $0x1c,%esp
  802b3f:	5b                   	pop    %ebx
  802b40:	5e                   	pop    %esi
  802b41:	5f                   	pop    %edi
  802b42:	5d                   	pop    %ebp
  802b43:	c3                   	ret    
  802b44:	3b 04 24             	cmp    (%esp),%eax
  802b47:	72 06                	jb     802b4f <__umoddi3+0x113>
  802b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802b4d:	77 0f                	ja     802b5e <__umoddi3+0x122>
  802b4f:	89 f2                	mov    %esi,%edx
  802b51:	29 f9                	sub    %edi,%ecx
  802b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802b57:	89 14 24             	mov    %edx,(%esp)
  802b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b62:	8b 14 24             	mov    (%esp),%edx
  802b65:	83 c4 1c             	add    $0x1c,%esp
  802b68:	5b                   	pop    %ebx
  802b69:	5e                   	pop    %esi
  802b6a:	5f                   	pop    %edi
  802b6b:	5d                   	pop    %ebp
  802b6c:	c3                   	ret    
  802b6d:	8d 76 00             	lea    0x0(%esi),%esi
  802b70:	2b 04 24             	sub    (%esp),%eax
  802b73:	19 fa                	sbb    %edi,%edx
  802b75:	89 d1                	mov    %edx,%ecx
  802b77:	89 c6                	mov    %eax,%esi
  802b79:	e9 71 ff ff ff       	jmp    802aef <__umoddi3+0xb3>
  802b7e:	66 90                	xchg   %ax,%ax
  802b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802b84:	72 ea                	jb     802b70 <__umoddi3+0x134>
  802b86:	89 d9                	mov    %ebx,%ecx
  802b88:	e9 62 ff ff ff       	jmp    802aef <__umoddi3+0xb3>
