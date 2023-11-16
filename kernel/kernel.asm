
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0a3050ef          	jal	ra,800058b8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fd078793          	addi	a5,a5,-48 # 80022000 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	94090913          	addi	s2,s2,-1728 # 80008990 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	24a080e7          	jalr	586(ra) # 800062a4 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2ea080e7          	jalr	746(ra) # 80006358 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ce2080e7          	jalr	-798(ra) # 80005d6c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	8a250513          	addi	a0,a0,-1886 # 80008990 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	11e080e7          	jalr	286(ra) # 80006214 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	efe50513          	addi	a0,a0,-258 # 80022000 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	86c48493          	addi	s1,s1,-1940 # 80008990 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	176080e7          	jalr	374(ra) # 800062a4 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	85450513          	addi	a0,a0,-1964 # 80008990 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	212080e7          	jalr	530(ra) # 80006358 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	82850513          	addi	a0,a0,-2008 # 80008990 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1e8080e7          	jalr	488(ra) # 80006358 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd001>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	c08080e7          	jalr	-1016(ra) # 80000f30 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	63070713          	addi	a4,a4,1584 # 80008960 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	bec080e7          	jalr	-1044(ra) # 80000f30 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a60080e7          	jalr	-1440(ra) # 80005db6 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	944080e7          	jalr	-1724(ra) # 80001caa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f02080e7          	jalr	-254(ra) # 80005270 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	18c080e7          	jalr	396(ra) # 80001502 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	8fe080e7          	jalr	-1794(ra) # 80005c7c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c10080e7          	jalr	-1008(ra) # 80005f96 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a20080e7          	jalr	-1504(ra) # 80005db6 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a10080e7          	jalr	-1520(ra) # 80005db6 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a00080e7          	jalr	-1536(ra) # 80005db6 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	aa8080e7          	jalr	-1368(ra) # 80000e7e <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	8a4080e7          	jalr	-1884(ra) # 80001c82 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	8c4080e7          	jalr	-1852(ra) # 80001caa <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e6c080e7          	jalr	-404(ra) # 8000525a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e7a080e7          	jalr	-390(ra) # 80005270 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	ff6080e7          	jalr	-10(ra) # 800023f4 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	696080e7          	jalr	1686(ra) # 80002a9c <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	63c080e7          	jalr	1596(ra) # 80003a4a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	f62080e7          	jalr	-158(ra) # 80005378 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	ec6080e7          	jalr	-314(ra) # 800012e4 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	52f72a23          	sw	a5,1332(a4) # 80008960 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	5287b783          	ld	a5,1320(a5) # 80008968 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	8e0080e7          	jalr	-1824(ra) # 80005d6c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcff7>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
        return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    return 0;
    8000050c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if(pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    return 0;
    8000052c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
    return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if(*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
    panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	7ba080e7          	jalr	1978(ra) # 80005d6c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	7aa080e7          	jalr	1962(ra) # 80005d6c <panic>
      return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
    panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	75e080e7          	jalr	1886(ra) # 80005d6c <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	714080e7          	jalr	1812(ra) # 80000dea <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
{
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	26a7b623          	sd	a0,620(a5) # 80008968 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
    panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	612080e7          	jalr	1554(ra) # 80005d6c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	602080e7          	jalr	1538(ra) # 80005d6c <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	5f2080e7          	jalr	1522(ra) # 80005d6c <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	5e2080e7          	jalr	1506(ra) # 80005d6c <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if(do_free){
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	504080e7          	jalr	1284(ra) # 80005d6c <panic>

0000000080000870 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if(newsz < oldsz)
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
    return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	3b8080e7          	jalr	952(ra) # 80005d6c <panic>
    }
  }
  kfree((void*)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
{
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	2da080e7          	jalr	730(ra) # 80005d6c <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	2ca080e7          	jalr	714(ra) # 80005d6c <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if(pte == 0)
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
    panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	260080e7          	jalr	608(ra) # 80005d6c <panic>

0000000080000b14 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
{
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
      return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
{
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cae:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd000>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if(got_null){
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <__vmprint>:

void __vmprint(pagetable_t pagetable, int level) {
    80000cde:	7119                	addi	sp,sp,-128
    80000ce0:	fc86                	sd	ra,120(sp)
    80000ce2:	f8a2                	sd	s0,112(sp)
    80000ce4:	f4a6                	sd	s1,104(sp)
    80000ce6:	f0ca                	sd	s2,96(sp)
    80000ce8:	ecce                	sd	s3,88(sp)
    80000cea:	e8d2                	sd	s4,80(sp)
    80000cec:	e4d6                	sd	s5,72(sp)
    80000cee:	e0da                	sd	s6,64(sp)
    80000cf0:	fc5e                	sd	s7,56(sp)
    80000cf2:	f862                	sd	s8,48(sp)
    80000cf4:	f466                	sd	s9,40(sp)
    80000cf6:	f06a                	sd	s10,32(sp)
    80000cf8:	ec6e                	sd	s11,24(sp)
    80000cfa:	0100                	addi	s0,sp,128
    80000cfc:	8aae                	mv	s5,a1
  for(int i = 0; i < 512; i++){
    80000cfe:	89aa                	mv	s3,a0
    80000d00:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
	uint64 child = PTE2PA(pte);
	switch (level) {
    80000d02:	4c05                	li	s8,1
			break;
		default:
			break;
	}
    	if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
		__vmprint((pagetable_t) child, level + 1);
    80000d04:	0015879b          	addiw	a5,a1,1
    80000d08:	f8f43423          	sd	a5,-120(s0)
			printf(".. ..%d: pte %p pa %p\n", i, pte, child);
    80000d0c:	00007d97          	auipc	s11,0x7
    80000d10:	464d8d93          	addi	s11,s11,1124 # 80008170 <etext+0x170>
	switch (level) {
    80000d14:	4b89                	li	s7,2
			printf(".. .. ..%d: pte %p pa %p\n", i, pte, child);
    80000d16:	00007d17          	auipc	s10,0x7
    80000d1a:	472d0d13          	addi	s10,s10,1138 # 80008188 <etext+0x188>
			printf(".. %d: pte %p pa %p\n", i, pte, child);
    80000d1e:	00007c97          	auipc	s9,0x7
    80000d22:	43ac8c93          	addi	s9,s9,1082 # 80008158 <etext+0x158>
  for(int i = 0; i < 512; i++){
    80000d26:	20000b13          	li	s6,512
    80000d2a:	a839                	j	80000d48 <__vmprint+0x6a>
			printf(".. ..%d: pte %p pa %p\n", i, pte, child);
    80000d2c:	86d2                	mv	a3,s4
    80000d2e:	8626                	mv	a2,s1
    80000d30:	85ca                	mv	a1,s2
    80000d32:	856e                	mv	a0,s11
    80000d34:	00005097          	auipc	ra,0x5
    80000d38:	082080e7          	jalr	130(ra) # 80005db6 <printf>
    	if ((pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d3c:	88b9                	andi	s1,s1,14
    80000d3e:	c4a9                	beqz	s1,80000d88 <__vmprint+0xaa>
  for(int i = 0; i < 512; i++){
    80000d40:	2905                	addiw	s2,s2,1 # 1001 <_entry-0x7fffefff>
    80000d42:	09a1                	addi	s3,s3,8 # 1008 <_entry-0x7fffeff8>
    80000d44:	05690a63          	beq	s2,s6,80000d98 <__vmprint+0xba>
    pte_t pte = pagetable[i];
    80000d48:	0009b483          	ld	s1,0(s3)
    if (pte & PTE_V) {
    80000d4c:	0014f793          	andi	a5,s1,1
    80000d50:	dbe5                	beqz	a5,80000d40 <__vmprint+0x62>
	uint64 child = PTE2PA(pte);
    80000d52:	00a4da13          	srli	s4,s1,0xa
    80000d56:	0a32                	slli	s4,s4,0xc
	switch (level) {
    80000d58:	fd8a8ae3          	beq	s5,s8,80000d2c <__vmprint+0x4e>
    80000d5c:	017a8d63          	beq	s5,s7,80000d76 <__vmprint+0x98>
    80000d60:	fc0a9ee3          	bnez	s5,80000d3c <__vmprint+0x5e>
			printf(".. %d: pte %p pa %p\n", i, pte, child);
    80000d64:	86d2                	mv	a3,s4
    80000d66:	8626                	mv	a2,s1
    80000d68:	85ca                	mv	a1,s2
    80000d6a:	8566                	mv	a0,s9
    80000d6c:	00005097          	auipc	ra,0x5
    80000d70:	04a080e7          	jalr	74(ra) # 80005db6 <printf>
			break;
    80000d74:	b7e1                	j	80000d3c <__vmprint+0x5e>
			printf(".. .. ..%d: pte %p pa %p\n", i, pte, child);
    80000d76:	86d2                	mv	a3,s4
    80000d78:	8626                	mv	a2,s1
    80000d7a:	85ca                	mv	a1,s2
    80000d7c:	856a                	mv	a0,s10
    80000d7e:	00005097          	auipc	ra,0x5
    80000d82:	038080e7          	jalr	56(ra) # 80005db6 <printf>
			break;
    80000d86:	bf5d                	j	80000d3c <__vmprint+0x5e>
		__vmprint((pagetable_t) child, level + 1);
    80000d88:	f8843583          	ld	a1,-120(s0)
    80000d8c:	8552                	mv	a0,s4
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	f50080e7          	jalr	-176(ra) # 80000cde <__vmprint>
    80000d96:	b76d                	j	80000d40 <__vmprint+0x62>
	}
    }
  }
}
    80000d98:	70e6                	ld	ra,120(sp)
    80000d9a:	7446                	ld	s0,112(sp)
    80000d9c:	74a6                	ld	s1,104(sp)
    80000d9e:	7906                	ld	s2,96(sp)
    80000da0:	69e6                	ld	s3,88(sp)
    80000da2:	6a46                	ld	s4,80(sp)
    80000da4:	6aa6                	ld	s5,72(sp)
    80000da6:	6b06                	ld	s6,64(sp)
    80000da8:	7be2                	ld	s7,56(sp)
    80000daa:	7c42                	ld	s8,48(sp)
    80000dac:	7ca2                	ld	s9,40(sp)
    80000dae:	7d02                	ld	s10,32(sp)
    80000db0:	6de2                	ld	s11,24(sp)
    80000db2:	6109                	addi	sp,sp,128
    80000db4:	8082                	ret

0000000080000db6 <vmprint>:

void vmprint(pagetable_t pagetable) {
    80000db6:	1101                	addi	sp,sp,-32
    80000db8:	ec06                	sd	ra,24(sp)
    80000dba:	e822                	sd	s0,16(sp)
    80000dbc:	e426                	sd	s1,8(sp)
    80000dbe:	1000                	addi	s0,sp,32
    80000dc0:	84aa                	mv	s1,a0
	printf("page table %p\n", pagetable);
    80000dc2:	85aa                	mv	a1,a0
    80000dc4:	00007517          	auipc	a0,0x7
    80000dc8:	3e450513          	addi	a0,a0,996 # 800081a8 <etext+0x1a8>
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	fea080e7          	jalr	-22(ra) # 80005db6 <printf>
	__vmprint(pagetable, 0);
    80000dd4:	4581                	li	a1,0
    80000dd6:	8526                	mv	a0,s1
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f06080e7          	jalr	-250(ra) # 80000cde <__vmprint>
}
    80000de0:	60e2                	ld	ra,24(sp)
    80000de2:	6442                	ld	s0,16(sp)
    80000de4:	64a2                	ld	s1,8(sp)
    80000de6:	6105                	addi	sp,sp,32
    80000de8:	8082                	ret

0000000080000dea <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dea:	7139                	addi	sp,sp,-64
    80000dec:	fc06                	sd	ra,56(sp)
    80000dee:	f822                	sd	s0,48(sp)
    80000df0:	f426                	sd	s1,40(sp)
    80000df2:	f04a                	sd	s2,32(sp)
    80000df4:	ec4e                	sd	s3,24(sp)
    80000df6:	e852                	sd	s4,16(sp)
    80000df8:	e456                	sd	s5,8(sp)
    80000dfa:	e05a                	sd	s6,0(sp)
    80000dfc:	0080                	addi	s0,sp,64
    80000dfe:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	00008497          	auipc	s1,0x8
    80000e04:	fe048493          	addi	s1,s1,-32 # 80008de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e08:	8b26                	mv	s6,s1
    80000e0a:	00007a97          	auipc	s5,0x7
    80000e0e:	1f6a8a93          	addi	s5,s5,502 # 80008000 <etext>
    80000e12:	01000937          	lui	s2,0x1000
    80000e16:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e18:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1a:	0000ea17          	auipc	s4,0xe
    80000e1e:	bc6a0a13          	addi	s4,s4,-1082 # 8000e9e0 <tickslock>
    char *pa = kalloc();
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	2f8080e7          	jalr	760(ra) # 8000011a <kalloc>
    80000e2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000e2c:	c129                	beqz	a0,80000e6e <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e2e:	416485b3          	sub	a1,s1,s6
    80000e32:	8591                	srai	a1,a1,0x4
    80000e34:	000ab783          	ld	a5,0(s5)
    80000e38:	02f585b3          	mul	a1,a1,a5
    80000e3c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e40:	4719                	li	a4,6
    80000e42:	6685                	lui	a3,0x1
    80000e44:	40b905b3          	sub	a1,s2,a1
    80000e48:	854e                	mv	a0,s3
    80000e4a:	fffff097          	auipc	ra,0xfffff
    80000e4e:	79c080e7          	jalr	1948(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	17048493          	addi	s1,s1,368
    80000e56:	fd4496e3          	bne	s1,s4,80000e22 <proc_mapstacks+0x38>
  }
}
    80000e5a:	70e2                	ld	ra,56(sp)
    80000e5c:	7442                	ld	s0,48(sp)
    80000e5e:	74a2                	ld	s1,40(sp)
    80000e60:	7902                	ld	s2,32(sp)
    80000e62:	69e2                	ld	s3,24(sp)
    80000e64:	6a42                	ld	s4,16(sp)
    80000e66:	6aa2                	ld	s5,8(sp)
    80000e68:	6b02                	ld	s6,0(sp)
    80000e6a:	6121                	addi	sp,sp,64
    80000e6c:	8082                	ret
      panic("kalloc");
    80000e6e:	00007517          	auipc	a0,0x7
    80000e72:	34a50513          	addi	a0,a0,842 # 800081b8 <etext+0x1b8>
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	ef6080e7          	jalr	-266(ra) # 80005d6c <panic>

0000000080000e7e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e7e:	7139                	addi	sp,sp,-64
    80000e80:	fc06                	sd	ra,56(sp)
    80000e82:	f822                	sd	s0,48(sp)
    80000e84:	f426                	sd	s1,40(sp)
    80000e86:	f04a                	sd	s2,32(sp)
    80000e88:	ec4e                	sd	s3,24(sp)
    80000e8a:	e852                	sd	s4,16(sp)
    80000e8c:	e456                	sd	s5,8(sp)
    80000e8e:	e05a                	sd	s6,0(sp)
    80000e90:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e92:	00007597          	auipc	a1,0x7
    80000e96:	32e58593          	addi	a1,a1,814 # 800081c0 <etext+0x1c0>
    80000e9a:	00008517          	auipc	a0,0x8
    80000e9e:	b1650513          	addi	a0,a0,-1258 # 800089b0 <pid_lock>
    80000ea2:	00005097          	auipc	ra,0x5
    80000ea6:	372080e7          	jalr	882(ra) # 80006214 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eaa:	00007597          	auipc	a1,0x7
    80000eae:	31e58593          	addi	a1,a1,798 # 800081c8 <etext+0x1c8>
    80000eb2:	00008517          	auipc	a0,0x8
    80000eb6:	b1650513          	addi	a0,a0,-1258 # 800089c8 <wait_lock>
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	35a080e7          	jalr	858(ra) # 80006214 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec2:	00008497          	auipc	s1,0x8
    80000ec6:	f1e48493          	addi	s1,s1,-226 # 80008de0 <proc>
      initlock(&p->lock, "proc");
    80000eca:	00007b17          	auipc	s6,0x7
    80000ece:	30eb0b13          	addi	s6,s6,782 # 800081d8 <etext+0x1d8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ed2:	8aa6                	mv	s5,s1
    80000ed4:	00007a17          	auipc	s4,0x7
    80000ed8:	12ca0a13          	addi	s4,s4,300 # 80008000 <etext>
    80000edc:	01000937          	lui	s2,0x1000
    80000ee0:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ee2:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee4:	0000e997          	auipc	s3,0xe
    80000ee8:	afc98993          	addi	s3,s3,-1284 # 8000e9e0 <tickslock>
      initlock(&p->lock, "proc");
    80000eec:	85da                	mv	a1,s6
    80000eee:	8526                	mv	a0,s1
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	324080e7          	jalr	804(ra) # 80006214 <initlock>
      p->state = UNUSED;
    80000ef8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000efc:	415487b3          	sub	a5,s1,s5
    80000f00:	8791                	srai	a5,a5,0x4
    80000f02:	000a3703          	ld	a4,0(s4)
    80000f06:	02e787b3          	mul	a5,a5,a4
    80000f0a:	00d7979b          	slliw	a5,a5,0xd
    80000f0e:	40f907b3          	sub	a5,s2,a5
    80000f12:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f14:	17048493          	addi	s1,s1,368
    80000f18:	fd349ae3          	bne	s1,s3,80000eec <procinit+0x6e>
  }
}
    80000f1c:	70e2                	ld	ra,56(sp)
    80000f1e:	7442                	ld	s0,48(sp)
    80000f20:	74a2                	ld	s1,40(sp)
    80000f22:	7902                	ld	s2,32(sp)
    80000f24:	69e2                	ld	s3,24(sp)
    80000f26:	6a42                	ld	s4,16(sp)
    80000f28:	6aa2                	ld	s5,8(sp)
    80000f2a:	6b02                	ld	s6,0(sp)
    80000f2c:	6121                	addi	sp,sp,64
    80000f2e:	8082                	ret

0000000080000f30 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e422                	sd	s0,8(sp)
    80000f34:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f36:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f38:	2501                	sext.w	a0,a0
    80000f3a:	6422                	ld	s0,8(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f40:	1141                	addi	sp,sp,-16
    80000f42:	e422                	sd	s0,8(sp)
    80000f44:	0800                	addi	s0,sp,16
    80000f46:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f48:	2781                	sext.w	a5,a5
    80000f4a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f4c:	00008517          	auipc	a0,0x8
    80000f50:	a9450513          	addi	a0,a0,-1388 # 800089e0 <cpus>
    80000f54:	953e                	add	a0,a0,a5
    80000f56:	6422                	ld	s0,8(sp)
    80000f58:	0141                	addi	sp,sp,16
    80000f5a:	8082                	ret

0000000080000f5c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f5c:	1101                	addi	sp,sp,-32
    80000f5e:	ec06                	sd	ra,24(sp)
    80000f60:	e822                	sd	s0,16(sp)
    80000f62:	e426                	sd	s1,8(sp)
    80000f64:	1000                	addi	s0,sp,32
  push_off();
    80000f66:	00005097          	auipc	ra,0x5
    80000f6a:	2f2080e7          	jalr	754(ra) # 80006258 <push_off>
    80000f6e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f70:	2781                	sext.w	a5,a5
    80000f72:	079e                	slli	a5,a5,0x7
    80000f74:	00008717          	auipc	a4,0x8
    80000f78:	a3c70713          	addi	a4,a4,-1476 # 800089b0 <pid_lock>
    80000f7c:	97ba                	add	a5,a5,a4
    80000f7e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	378080e7          	jalr	888(ra) # 800062f8 <pop_off>
  return p;
}
    80000f88:	8526                	mv	a0,s1
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6105                	addi	sp,sp,32
    80000f92:	8082                	ret

0000000080000f94 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f94:	1141                	addi	sp,sp,-16
    80000f96:	e406                	sd	ra,8(sp)
    80000f98:	e022                	sd	s0,0(sp)
    80000f9a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	fc0080e7          	jalr	-64(ra) # 80000f5c <myproc>
    80000fa4:	00005097          	auipc	ra,0x5
    80000fa8:	3b4080e7          	jalr	948(ra) # 80006358 <release>

  if (first) {
    80000fac:	00008797          	auipc	a5,0x8
    80000fb0:	9447a783          	lw	a5,-1724(a5) # 800088f0 <first.1>
    80000fb4:	eb89                	bnez	a5,80000fc6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fb6:	00001097          	auipc	ra,0x1
    80000fba:	d0c080e7          	jalr	-756(ra) # 80001cc2 <usertrapret>
}
    80000fbe:	60a2                	ld	ra,8(sp)
    80000fc0:	6402                	ld	s0,0(sp)
    80000fc2:	0141                	addi	sp,sp,16
    80000fc4:	8082                	ret
    first = 0;
    80000fc6:	00008797          	auipc	a5,0x8
    80000fca:	9207a523          	sw	zero,-1750(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    80000fce:	4505                	li	a0,1
    80000fd0:	00002097          	auipc	ra,0x2
    80000fd4:	a4c080e7          	jalr	-1460(ra) # 80002a1c <fsinit>
    80000fd8:	bff9                	j	80000fb6 <forkret+0x22>

0000000080000fda <allocpid>:
{
    80000fda:	1101                	addi	sp,sp,-32
    80000fdc:	ec06                	sd	ra,24(sp)
    80000fde:	e822                	sd	s0,16(sp)
    80000fe0:	e426                	sd	s1,8(sp)
    80000fe2:	e04a                	sd	s2,0(sp)
    80000fe4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fe6:	00008917          	auipc	s2,0x8
    80000fea:	9ca90913          	addi	s2,s2,-1590 # 800089b0 <pid_lock>
    80000fee:	854a                	mv	a0,s2
    80000ff0:	00005097          	auipc	ra,0x5
    80000ff4:	2b4080e7          	jalr	692(ra) # 800062a4 <acquire>
  pid = nextpid;
    80000ff8:	00008797          	auipc	a5,0x8
    80000ffc:	8fc78793          	addi	a5,a5,-1796 # 800088f4 <nextpid>
    80001000:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001002:	0014871b          	addiw	a4,s1,1
    80001006:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001008:	854a                	mv	a0,s2
    8000100a:	00005097          	auipc	ra,0x5
    8000100e:	34e080e7          	jalr	846(ra) # 80006358 <release>
}
    80001012:	8526                	mv	a0,s1
    80001014:	60e2                	ld	ra,24(sp)
    80001016:	6442                	ld	s0,16(sp)
    80001018:	64a2                	ld	s1,8(sp)
    8000101a:	6902                	ld	s2,0(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret

0000000080001020 <proc_pagetable>:
{
    80001020:	1101                	addi	sp,sp,-32
    80001022:	ec06                	sd	ra,24(sp)
    80001024:	e822                	sd	s0,16(sp)
    80001026:	e426                	sd	s1,8(sp)
    80001028:	e04a                	sd	s2,0(sp)
    8000102a:	1000                	addi	s0,sp,32
    8000102c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	7a2080e7          	jalr	1954(ra) # 800007d0 <uvmcreate>
    80001036:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001038:	cd39                	beqz	a0,80001096 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000103a:	4729                	li	a4,10
    8000103c:	00006697          	auipc	a3,0x6
    80001040:	fc468693          	addi	a3,a3,-60 # 80007000 <_trampoline>
    80001044:	6605                	lui	a2,0x1
    80001046:	040005b7          	lui	a1,0x4000
    8000104a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104c:	05b2                	slli	a1,a1,0xc
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	4f8080e7          	jalr	1272(ra) # 80000546 <mappages>
    80001056:	04054763          	bltz	a0,800010a4 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000105a:	4719                	li	a4,6
    8000105c:	05893683          	ld	a3,88(s2)
    80001060:	6605                	lui	a2,0x1
    80001062:	020005b7          	lui	a1,0x2000
    80001066:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001068:	05b6                	slli	a1,a1,0xd
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	4da080e7          	jalr	1242(ra) # 80000546 <mappages>
    80001074:	04054063          	bltz	a0,800010b4 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001078:	4749                	li	a4,18
    8000107a:	06093683          	ld	a3,96(s2)
    8000107e:	6605                	lui	a2,0x1
    80001080:	040005b7          	lui	a1,0x4000
    80001084:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001086:	05b2                	slli	a1,a1,0xc
    80001088:	8526                	mv	a0,s1
    8000108a:	fffff097          	auipc	ra,0xfffff
    8000108e:	4bc080e7          	jalr	1212(ra) # 80000546 <mappages>
    80001092:	04054463          	bltz	a0,800010da <proc_pagetable+0xba>
}
    80001096:	8526                	mv	a0,s1
    80001098:	60e2                	ld	ra,24(sp)
    8000109a:	6442                	ld	s0,16(sp)
    8000109c:	64a2                	ld	s1,8(sp)
    8000109e:	6902                	ld	s2,0(sp)
    800010a0:	6105                	addi	sp,sp,32
    800010a2:	8082                	ret
    uvmfree(pagetable, 0);
    800010a4:	4581                	li	a1,0
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	92e080e7          	jalr	-1746(ra) # 800009d6 <uvmfree>
    return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	b7d5                	j	80001096 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b4:	4681                	li	a3,0
    800010b6:	4605                	li	a2,1
    800010b8:	040005b7          	lui	a1,0x4000
    800010bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010be:	05b2                	slli	a1,a1,0xc
    800010c0:	8526                	mv	a0,s1
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	64a080e7          	jalr	1610(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    800010ca:	4581                	li	a1,0
    800010cc:	8526                	mv	a0,s1
    800010ce:	00000097          	auipc	ra,0x0
    800010d2:	908080e7          	jalr	-1784(ra) # 800009d6 <uvmfree>
    return 0;
    800010d6:	4481                	li	s1,0
    800010d8:	bf7d                	j	80001096 <proc_pagetable+0x76>
  	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010da:	4681                	li	a3,0
    800010dc:	4605                	li	a2,1
    800010de:	040005b7          	lui	a1,0x4000
    800010e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010e4:	05b2                	slli	a1,a1,0xc
    800010e6:	8526                	mv	a0,s1
    800010e8:	fffff097          	auipc	ra,0xfffff
    800010ec:	624080e7          	jalr	1572(ra) # 8000070c <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010f0:	4681                	li	a3,0
    800010f2:	4605                	li	a2,1
    800010f4:	020005b7          	lui	a1,0x2000
    800010f8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010fa:	05b6                	slli	a1,a1,0xd
    800010fc:	8526                	mv	a0,s1
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	60e080e7          	jalr	1550(ra) # 8000070c <uvmunmap>
	uvmfree(pagetable, 0);
    80001106:	4581                	li	a1,0
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	8cc080e7          	jalr	-1844(ra) # 800009d6 <uvmfree>
	return 0;
    80001112:	4481                	li	s1,0
    80001114:	b749                	j	80001096 <proc_pagetable+0x76>

0000000080001116 <proc_freepagetable>:
{
    80001116:	7179                	addi	sp,sp,-48
    80001118:	f406                	sd	ra,40(sp)
    8000111a:	f022                	sd	s0,32(sp)
    8000111c:	ec26                	sd	s1,24(sp)
    8000111e:	e84a                	sd	s2,16(sp)
    80001120:	e44e                	sd	s3,8(sp)
    80001122:	1800                	addi	s0,sp,48
    80001124:	84aa                	mv	s1,a0
    80001126:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001128:	4681                	li	a3,0
    8000112a:	4605                	li	a2,1
    8000112c:	04000937          	lui	s2,0x4000
    80001130:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001134:	05b2                	slli	a1,a1,0xc
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	5d6080e7          	jalr	1494(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000113e:	4681                	li	a3,0
    80001140:	4605                	li	a2,1
    80001142:	020005b7          	lui	a1,0x2000
    80001146:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001148:	05b6                	slli	a1,a1,0xd
    8000114a:	8526                	mv	a0,s1
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	5c0080e7          	jalr	1472(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001154:	4681                	li	a3,0
    80001156:	4605                	li	a2,1
    80001158:	1975                	addi	s2,s2,-3
    8000115a:	00c91593          	slli	a1,s2,0xc
    8000115e:	8526                	mv	a0,s1
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	5ac080e7          	jalr	1452(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    80001168:	85ce                	mv	a1,s3
    8000116a:	8526                	mv	a0,s1
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	86a080e7          	jalr	-1942(ra) # 800009d6 <uvmfree>
}
    80001174:	70a2                	ld	ra,40(sp)
    80001176:	7402                	ld	s0,32(sp)
    80001178:	64e2                	ld	s1,24(sp)
    8000117a:	6942                	ld	s2,16(sp)
    8000117c:	69a2                	ld	s3,8(sp)
    8000117e:	6145                	addi	sp,sp,48
    80001180:	8082                	ret

0000000080001182 <freeproc>:
{
    80001182:	1101                	addi	sp,sp,-32
    80001184:	ec06                	sd	ra,24(sp)
    80001186:	e822                	sd	s0,16(sp)
    80001188:	e426                	sd	s1,8(sp)
    8000118a:	1000                	addi	s0,sp,32
    8000118c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000118e:	6d28                	ld	a0,88(a0)
    80001190:	c509                	beqz	a0,8000119a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	e8a080e7          	jalr	-374(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000119a:	0404bc23          	sd	zero,88(s1)
  if(p->uframe)
    8000119e:	70a8                	ld	a0,96(s1)
    800011a0:	c509                	beqz	a0,800011aa <freeproc+0x28>
	  kfree((void*)p->uframe);
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	e7a080e7          	jalr	-390(ra) # 8000001c <kfree>
  p->uframe = 0;
    800011aa:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011ae:	68a8                	ld	a0,80(s1)
    800011b0:	c511                	beqz	a0,800011bc <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b2:	64ac                	ld	a1,72(s1)
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f62080e7          	jalr	-158(ra) # 80001116 <proc_freepagetable>
  p->pagetable = 0;
    800011bc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011c0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011cc:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011d0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011dc:	0004ac23          	sw	zero,24(s1)
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret

00000000800011ea <allocproc>:
{
    800011ea:	1101                	addi	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	e04a                	sd	s2,0(sp)
    800011f4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f6:	00008497          	auipc	s1,0x8
    800011fa:	bea48493          	addi	s1,s1,-1046 # 80008de0 <proc>
    800011fe:	0000d917          	auipc	s2,0xd
    80001202:	7e290913          	addi	s2,s2,2018 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	09c080e7          	jalr	156(ra) # 800062a4 <acquire>
    if(p->state == UNUSED) {
    80001210:	4c9c                	lw	a5,24(s1)
    80001212:	cf81                	beqz	a5,8000122a <allocproc+0x40>
      release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	142080e7          	jalr	322(ra) # 80006358 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121e:	17048493          	addi	s1,s1,368
    80001222:	ff2492e3          	bne	s1,s2,80001206 <allocproc+0x1c>
  return 0;
    80001226:	4481                	li	s1,0
    80001228:	a09d                	j	8000128e <allocproc+0xa4>
  p->pid = allocpid();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	db0080e7          	jalr	-592(ra) # 80000fda <allocpid>
    80001232:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001234:	4785                	li	a5,1
    80001236:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	ee2080e7          	jalr	-286(ra) # 8000011a <kalloc>
    80001240:	892a                	mv	s2,a0
    80001242:	eca8                	sd	a0,88(s1)
    80001244:	cd21                	beqz	a0,8000129c <allocproc+0xb2>
  if((p->uframe = (struct usyscall *)kalloc()) == 0) {
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	ed4080e7          	jalr	-300(ra) # 8000011a <kalloc>
    8000124e:	892a                	mv	s2,a0
    80001250:	f0a8                	sd	a0,96(s1)
    80001252:	c12d                	beqz	a0,800012b4 <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    80001254:	8526                	mv	a0,s1
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	dca080e7          	jalr	-566(ra) # 80001020 <proc_pagetable>
    8000125e:	892a                	mv	s2,a0
    80001260:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001262:	c52d                	beqz	a0,800012cc <allocproc+0xe2>
  p->uframe->pid = p->pid;
    80001264:	70bc                	ld	a5,96(s1)
    80001266:	5898                	lw	a4,48(s1)
    80001268:	c398                	sw	a4,0(a5)
  memset(&p->context, 0, sizeof(p->context));
    8000126a:	07000613          	li	a2,112
    8000126e:	4581                	li	a1,0
    80001270:	06848513          	addi	a0,s1,104
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	f06080e7          	jalr	-250(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000127c:	00000797          	auipc	a5,0x0
    80001280:	d1878793          	addi	a5,a5,-744 # 80000f94 <forkret>
    80001284:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001286:	60bc                	ld	a5,64(s1)
    80001288:	6705                	lui	a4,0x1
    8000128a:	97ba                	add	a5,a5,a4
    8000128c:	f8bc                	sd	a5,112(s1)
}
    8000128e:	8526                	mv	a0,s1
    80001290:	60e2                	ld	ra,24(sp)
    80001292:	6442                	ld	s0,16(sp)
    80001294:	64a2                	ld	s1,8(sp)
    80001296:	6902                	ld	s2,0(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret
    freeproc(p);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	ee4080e7          	jalr	-284(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	0b0080e7          	jalr	176(ra) # 80006358 <release>
    return 0;
    800012b0:	84ca                	mv	s1,s2
    800012b2:	bff1                	j	8000128e <allocproc+0xa4>
  	freeproc(p);
    800012b4:	8526                	mv	a0,s1
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	ecc080e7          	jalr	-308(ra) # 80001182 <freeproc>
	release(&p->lock);
    800012be:	8526                	mv	a0,s1
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	098080e7          	jalr	152(ra) # 80006358 <release>
	return 0;
    800012c8:	84ca                	mv	s1,s2
    800012ca:	b7d1                	j	8000128e <allocproc+0xa4>
    freeproc(p);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	eb4080e7          	jalr	-332(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	080080e7          	jalr	128(ra) # 80006358 <release>
    return 0;
    800012e0:	84ca                	mv	s1,s2
    800012e2:	b775                	j	8000128e <allocproc+0xa4>

00000000800012e4 <userinit>:
{
    800012e4:	1101                	addi	sp,sp,-32
    800012e6:	ec06                	sd	ra,24(sp)
    800012e8:	e822                	sd	s0,16(sp)
    800012ea:	e426                	sd	s1,8(sp)
    800012ec:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	efc080e7          	jalr	-260(ra) # 800011ea <allocproc>
    800012f6:	84aa                	mv	s1,a0
  initproc = p;
    800012f8:	00007797          	auipc	a5,0x7
    800012fc:	66a7bc23          	sd	a0,1656(a5) # 80008970 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001300:	03400613          	li	a2,52
    80001304:	00007597          	auipc	a1,0x7
    80001308:	5fc58593          	addi	a1,a1,1532 # 80008900 <initcode>
    8000130c:	6928                	ld	a0,80(a0)
    8000130e:	fffff097          	auipc	ra,0xfffff
    80001312:	4f0080e7          	jalr	1264(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    80001316:	6785                	lui	a5,0x1
    80001318:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000131a:	6cb8                	ld	a4,88(s1)
    8000131c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001320:	6cb8                	ld	a4,88(s1)
    80001322:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001324:	4641                	li	a2,16
    80001326:	00007597          	auipc	a1,0x7
    8000132a:	eba58593          	addi	a1,a1,-326 # 800081e0 <etext+0x1e0>
    8000132e:	16048513          	addi	a0,s1,352
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	f92080e7          	jalr	-110(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    8000133a:	00007517          	auipc	a0,0x7
    8000133e:	eb650513          	addi	a0,a0,-330 # 800081f0 <etext+0x1f0>
    80001342:	00002097          	auipc	ra,0x2
    80001346:	104080e7          	jalr	260(ra) # 80003446 <namei>
    8000134a:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000134e:	478d                	li	a5,3
    80001350:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001352:	8526                	mv	a0,s1
    80001354:	00005097          	auipc	ra,0x5
    80001358:	004080e7          	jalr	4(ra) # 80006358 <release>
}
    8000135c:	60e2                	ld	ra,24(sp)
    8000135e:	6442                	ld	s0,16(sp)
    80001360:	64a2                	ld	s1,8(sp)
    80001362:	6105                	addi	sp,sp,32
    80001364:	8082                	ret

0000000080001366 <growproc>:
{
    80001366:	1101                	addi	sp,sp,-32
    80001368:	ec06                	sd	ra,24(sp)
    8000136a:	e822                	sd	s0,16(sp)
    8000136c:	e426                	sd	s1,8(sp)
    8000136e:	e04a                	sd	s2,0(sp)
    80001370:	1000                	addi	s0,sp,32
    80001372:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001374:	00000097          	auipc	ra,0x0
    80001378:	be8080e7          	jalr	-1048(ra) # 80000f5c <myproc>
    8000137c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000137e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001380:	01204c63          	bgtz	s2,80001398 <growproc+0x32>
  } else if(n < 0){
    80001384:	02094663          	bltz	s2,800013b0 <growproc+0x4a>
  p->sz = sz;
    80001388:	e4ac                	sd	a1,72(s1)
  return 0;
    8000138a:	4501                	li	a0,0
}
    8000138c:	60e2                	ld	ra,24(sp)
    8000138e:	6442                	ld	s0,16(sp)
    80001390:	64a2                	ld	s1,8(sp)
    80001392:	6902                	ld	s2,0(sp)
    80001394:	6105                	addi	sp,sp,32
    80001396:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001398:	4691                	li	a3,4
    8000139a:	00b90633          	add	a2,s2,a1
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	518080e7          	jalr	1304(ra) # 800008b8 <uvmalloc>
    800013a8:	85aa                	mv	a1,a0
    800013aa:	fd79                	bnez	a0,80001388 <growproc+0x22>
      return -1;
    800013ac:	557d                	li	a0,-1
    800013ae:	bff9                	j	8000138c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013b0:	00b90633          	add	a2,s2,a1
    800013b4:	6928                	ld	a0,80(a0)
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	4ba080e7          	jalr	1210(ra) # 80000870 <uvmdealloc>
    800013be:	85aa                	mv	a1,a0
    800013c0:	b7e1                	j	80001388 <growproc+0x22>

00000000800013c2 <fork>:
{
    800013c2:	7139                	addi	sp,sp,-64
    800013c4:	fc06                	sd	ra,56(sp)
    800013c6:	f822                	sd	s0,48(sp)
    800013c8:	f426                	sd	s1,40(sp)
    800013ca:	f04a                	sd	s2,32(sp)
    800013cc:	ec4e                	sd	s3,24(sp)
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	e456                	sd	s5,8(sp)
    800013d2:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013d4:	00000097          	auipc	ra,0x0
    800013d8:	b88080e7          	jalr	-1144(ra) # 80000f5c <myproc>
    800013dc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013de:	00000097          	auipc	ra,0x0
    800013e2:	e0c080e7          	jalr	-500(ra) # 800011ea <allocproc>
    800013e6:	10050c63          	beqz	a0,800014fe <fork+0x13c>
    800013ea:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013ec:	048ab603          	ld	a2,72(s5)
    800013f0:	692c                	ld	a1,80(a0)
    800013f2:	050ab503          	ld	a0,80(s5)
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	61a080e7          	jalr	1562(ra) # 80000a10 <uvmcopy>
    800013fe:	04054863          	bltz	a0,8000144e <fork+0x8c>
  np->sz = p->sz;
    80001402:	048ab783          	ld	a5,72(s5)
    80001406:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000140a:	058ab683          	ld	a3,88(s5)
    8000140e:	87b6                	mv	a5,a3
    80001410:	058a3703          	ld	a4,88(s4)
    80001414:	12068693          	addi	a3,a3,288
    80001418:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000141c:	6788                	ld	a0,8(a5)
    8000141e:	6b8c                	ld	a1,16(a5)
    80001420:	6f90                	ld	a2,24(a5)
    80001422:	01073023          	sd	a6,0(a4)
    80001426:	e708                	sd	a0,8(a4)
    80001428:	eb0c                	sd	a1,16(a4)
    8000142a:	ef10                	sd	a2,24(a4)
    8000142c:	02078793          	addi	a5,a5,32
    80001430:	02070713          	addi	a4,a4,32
    80001434:	fed792e3          	bne	a5,a3,80001418 <fork+0x56>
  np->trapframe->a0 = 0;
    80001438:	058a3783          	ld	a5,88(s4)
    8000143c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001440:	0d8a8493          	addi	s1,s5,216
    80001444:	0d8a0913          	addi	s2,s4,216
    80001448:	158a8993          	addi	s3,s5,344
    8000144c:	a00d                	j	8000146e <fork+0xac>
    freeproc(np);
    8000144e:	8552                	mv	a0,s4
    80001450:	00000097          	auipc	ra,0x0
    80001454:	d32080e7          	jalr	-718(ra) # 80001182 <freeproc>
    release(&np->lock);
    80001458:	8552                	mv	a0,s4
    8000145a:	00005097          	auipc	ra,0x5
    8000145e:	efe080e7          	jalr	-258(ra) # 80006358 <release>
    return -1;
    80001462:	597d                	li	s2,-1
    80001464:	a059                	j	800014ea <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001466:	04a1                	addi	s1,s1,8
    80001468:	0921                	addi	s2,s2,8
    8000146a:	01348b63          	beq	s1,s3,80001480 <fork+0xbe>
    if(p->ofile[i])
    8000146e:	6088                	ld	a0,0(s1)
    80001470:	d97d                	beqz	a0,80001466 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001472:	00002097          	auipc	ra,0x2
    80001476:	66a080e7          	jalr	1642(ra) # 80003adc <filedup>
    8000147a:	00a93023          	sd	a0,0(s2)
    8000147e:	b7e5                	j	80001466 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001480:	158ab503          	ld	a0,344(s5)
    80001484:	00001097          	auipc	ra,0x1
    80001488:	7d8080e7          	jalr	2008(ra) # 80002c5c <idup>
    8000148c:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001490:	4641                	li	a2,16
    80001492:	160a8593          	addi	a1,s5,352
    80001496:	160a0513          	addi	a0,s4,352
    8000149a:	fffff097          	auipc	ra,0xfffff
    8000149e:	e2a080e7          	jalr	-470(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800014a2:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014a6:	8552                	mv	a0,s4
    800014a8:	00005097          	auipc	ra,0x5
    800014ac:	eb0080e7          	jalr	-336(ra) # 80006358 <release>
  acquire(&wait_lock);
    800014b0:	00007497          	auipc	s1,0x7
    800014b4:	51848493          	addi	s1,s1,1304 # 800089c8 <wait_lock>
    800014b8:	8526                	mv	a0,s1
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	dea080e7          	jalr	-534(ra) # 800062a4 <acquire>
  np->parent = p;
    800014c2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014c6:	8526                	mv	a0,s1
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	e90080e7          	jalr	-368(ra) # 80006358 <release>
  acquire(&np->lock);
    800014d0:	8552                	mv	a0,s4
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	dd2080e7          	jalr	-558(ra) # 800062a4 <acquire>
  np->state = RUNNABLE;
    800014da:	478d                	li	a5,3
    800014dc:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014e0:	8552                	mv	a0,s4
    800014e2:	00005097          	auipc	ra,0x5
    800014e6:	e76080e7          	jalr	-394(ra) # 80006358 <release>
}
    800014ea:	854a                	mv	a0,s2
    800014ec:	70e2                	ld	ra,56(sp)
    800014ee:	7442                	ld	s0,48(sp)
    800014f0:	74a2                	ld	s1,40(sp)
    800014f2:	7902                	ld	s2,32(sp)
    800014f4:	69e2                	ld	s3,24(sp)
    800014f6:	6a42                	ld	s4,16(sp)
    800014f8:	6aa2                	ld	s5,8(sp)
    800014fa:	6121                	addi	sp,sp,64
    800014fc:	8082                	ret
    return -1;
    800014fe:	597d                	li	s2,-1
    80001500:	b7ed                	j	800014ea <fork+0x128>

0000000080001502 <scheduler>:
{
    80001502:	7139                	addi	sp,sp,-64
    80001504:	fc06                	sd	ra,56(sp)
    80001506:	f822                	sd	s0,48(sp)
    80001508:	f426                	sd	s1,40(sp)
    8000150a:	f04a                	sd	s2,32(sp)
    8000150c:	ec4e                	sd	s3,24(sp)
    8000150e:	e852                	sd	s4,16(sp)
    80001510:	e456                	sd	s5,8(sp)
    80001512:	e05a                	sd	s6,0(sp)
    80001514:	0080                	addi	s0,sp,64
    80001516:	8792                	mv	a5,tp
  int id = r_tp();
    80001518:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000151a:	00779a93          	slli	s5,a5,0x7
    8000151e:	00007717          	auipc	a4,0x7
    80001522:	49270713          	addi	a4,a4,1170 # 800089b0 <pid_lock>
    80001526:	9756                	add	a4,a4,s5
    80001528:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000152c:	00007717          	auipc	a4,0x7
    80001530:	4bc70713          	addi	a4,a4,1212 # 800089e8 <cpus+0x8>
    80001534:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001536:	498d                	li	s3,3
        p->state = RUNNING;
    80001538:	4b11                	li	s6,4
        c->proc = p;
    8000153a:	079e                	slli	a5,a5,0x7
    8000153c:	00007a17          	auipc	s4,0x7
    80001540:	474a0a13          	addi	s4,s4,1140 # 800089b0 <pid_lock>
    80001544:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001546:	0000d917          	auipc	s2,0xd
    8000154a:	49a90913          	addi	s2,s2,1178 # 8000e9e0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001552:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001556:	10079073          	csrw	sstatus,a5
    8000155a:	00008497          	auipc	s1,0x8
    8000155e:	88648493          	addi	s1,s1,-1914 # 80008de0 <proc>
    80001562:	a811                	j	80001576 <scheduler+0x74>
      release(&p->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	df2080e7          	jalr	-526(ra) # 80006358 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000156e:	17048493          	addi	s1,s1,368
    80001572:	fd248ee3          	beq	s1,s2,8000154e <scheduler+0x4c>
      acquire(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	d2c080e7          	jalr	-724(ra) # 800062a4 <acquire>
      if(p->state == RUNNABLE) {
    80001580:	4c9c                	lw	a5,24(s1)
    80001582:	ff3791e3          	bne	a5,s3,80001564 <scheduler+0x62>
        p->state = RUNNING;
    80001586:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000158a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000158e:	06848593          	addi	a1,s1,104
    80001592:	8556                	mv	a0,s5
    80001594:	00000097          	auipc	ra,0x0
    80001598:	684080e7          	jalr	1668(ra) # 80001c18 <swtch>
        c->proc = 0;
    8000159c:	020a3823          	sd	zero,48(s4)
    800015a0:	b7d1                	j	80001564 <scheduler+0x62>

00000000800015a2 <sched>:
{
    800015a2:	7179                	addi	sp,sp,-48
    800015a4:	f406                	sd	ra,40(sp)
    800015a6:	f022                	sd	s0,32(sp)
    800015a8:	ec26                	sd	s1,24(sp)
    800015aa:	e84a                	sd	s2,16(sp)
    800015ac:	e44e                	sd	s3,8(sp)
    800015ae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	9ac080e7          	jalr	-1620(ra) # 80000f5c <myproc>
    800015b8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	c70080e7          	jalr	-912(ra) # 8000622a <holding>
    800015c2:	c93d                	beqz	a0,80001638 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015c4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015c6:	2781                	sext.w	a5,a5
    800015c8:	079e                	slli	a5,a5,0x7
    800015ca:	00007717          	auipc	a4,0x7
    800015ce:	3e670713          	addi	a4,a4,998 # 800089b0 <pid_lock>
    800015d2:	97ba                	add	a5,a5,a4
    800015d4:	0a87a703          	lw	a4,168(a5)
    800015d8:	4785                	li	a5,1
    800015da:	06f71763          	bne	a4,a5,80001648 <sched+0xa6>
  if(p->state == RUNNING)
    800015de:	4c98                	lw	a4,24(s1)
    800015e0:	4791                	li	a5,4
    800015e2:	06f70b63          	beq	a4,a5,80001658 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015ea:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015ec:	efb5                	bnez	a5,80001668 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015f0:	00007917          	auipc	s2,0x7
    800015f4:	3c090913          	addi	s2,s2,960 # 800089b0 <pid_lock>
    800015f8:	2781                	sext.w	a5,a5
    800015fa:	079e                	slli	a5,a5,0x7
    800015fc:	97ca                	add	a5,a5,s2
    800015fe:	0ac7a983          	lw	s3,172(a5)
    80001602:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001604:	2781                	sext.w	a5,a5
    80001606:	079e                	slli	a5,a5,0x7
    80001608:	00007597          	auipc	a1,0x7
    8000160c:	3e058593          	addi	a1,a1,992 # 800089e8 <cpus+0x8>
    80001610:	95be                	add	a1,a1,a5
    80001612:	06848513          	addi	a0,s1,104
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	602080e7          	jalr	1538(ra) # 80001c18 <swtch>
    8000161e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001620:	2781                	sext.w	a5,a5
    80001622:	079e                	slli	a5,a5,0x7
    80001624:	993e                	add	s2,s2,a5
    80001626:	0b392623          	sw	s3,172(s2)
}
    8000162a:	70a2                	ld	ra,40(sp)
    8000162c:	7402                	ld	s0,32(sp)
    8000162e:	64e2                	ld	s1,24(sp)
    80001630:	6942                	ld	s2,16(sp)
    80001632:	69a2                	ld	s3,8(sp)
    80001634:	6145                	addi	sp,sp,48
    80001636:	8082                	ret
    panic("sched p->lock");
    80001638:	00007517          	auipc	a0,0x7
    8000163c:	bc050513          	addi	a0,a0,-1088 # 800081f8 <etext+0x1f8>
    80001640:	00004097          	auipc	ra,0x4
    80001644:	72c080e7          	jalr	1836(ra) # 80005d6c <panic>
    panic("sched locks");
    80001648:	00007517          	auipc	a0,0x7
    8000164c:	bc050513          	addi	a0,a0,-1088 # 80008208 <etext+0x208>
    80001650:	00004097          	auipc	ra,0x4
    80001654:	71c080e7          	jalr	1820(ra) # 80005d6c <panic>
    panic("sched running");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	bc050513          	addi	a0,a0,-1088 # 80008218 <etext+0x218>
    80001660:	00004097          	auipc	ra,0x4
    80001664:	70c080e7          	jalr	1804(ra) # 80005d6c <panic>
    panic("sched interruptible");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	bc050513          	addi	a0,a0,-1088 # 80008228 <etext+0x228>
    80001670:	00004097          	auipc	ra,0x4
    80001674:	6fc080e7          	jalr	1788(ra) # 80005d6c <panic>

0000000080001678 <yield>:
{
    80001678:	1101                	addi	sp,sp,-32
    8000167a:	ec06                	sd	ra,24(sp)
    8000167c:	e822                	sd	s0,16(sp)
    8000167e:	e426                	sd	s1,8(sp)
    80001680:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	8da080e7          	jalr	-1830(ra) # 80000f5c <myproc>
    8000168a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	c18080e7          	jalr	-1000(ra) # 800062a4 <acquire>
  p->state = RUNNABLE;
    80001694:	478d                	li	a5,3
    80001696:	cc9c                	sw	a5,24(s1)
  sched();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	f0a080e7          	jalr	-246(ra) # 800015a2 <sched>
  release(&p->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	00005097          	auipc	ra,0x5
    800016a6:	cb6080e7          	jalr	-842(ra) # 80006358 <release>
}
    800016aa:	60e2                	ld	ra,24(sp)
    800016ac:	6442                	ld	s0,16(sp)
    800016ae:	64a2                	ld	s1,8(sp)
    800016b0:	6105                	addi	sp,sp,32
    800016b2:	8082                	ret

00000000800016b4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016b4:	7179                	addi	sp,sp,-48
    800016b6:	f406                	sd	ra,40(sp)
    800016b8:	f022                	sd	s0,32(sp)
    800016ba:	ec26                	sd	s1,24(sp)
    800016bc:	e84a                	sd	s2,16(sp)
    800016be:	e44e                	sd	s3,8(sp)
    800016c0:	1800                	addi	s0,sp,48
    800016c2:	89aa                	mv	s3,a0
    800016c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	896080e7          	jalr	-1898(ra) # 80000f5c <myproc>
    800016ce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	bd4080e7          	jalr	-1068(ra) # 800062a4 <acquire>
  release(lk);
    800016d8:	854a                	mv	a0,s2
    800016da:	00005097          	auipc	ra,0x5
    800016de:	c7e080e7          	jalr	-898(ra) # 80006358 <release>

  // Go to sleep.
  p->chan = chan;
    800016e2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016e6:	4789                	li	a5,2
    800016e8:	cc9c                	sw	a5,24(s1)

  sched();
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	eb8080e7          	jalr	-328(ra) # 800015a2 <sched>

  // Tidy up.
  p->chan = 0;
    800016f2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016f6:	8526                	mv	a0,s1
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	c60080e7          	jalr	-928(ra) # 80006358 <release>
  acquire(lk);
    80001700:	854a                	mv	a0,s2
    80001702:	00005097          	auipc	ra,0x5
    80001706:	ba2080e7          	jalr	-1118(ra) # 800062a4 <acquire>
}
    8000170a:	70a2                	ld	ra,40(sp)
    8000170c:	7402                	ld	s0,32(sp)
    8000170e:	64e2                	ld	s1,24(sp)
    80001710:	6942                	ld	s2,16(sp)
    80001712:	69a2                	ld	s3,8(sp)
    80001714:	6145                	addi	sp,sp,48
    80001716:	8082                	ret

0000000080001718 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001718:	7139                	addi	sp,sp,-64
    8000171a:	fc06                	sd	ra,56(sp)
    8000171c:	f822                	sd	s0,48(sp)
    8000171e:	f426                	sd	s1,40(sp)
    80001720:	f04a                	sd	s2,32(sp)
    80001722:	ec4e                	sd	s3,24(sp)
    80001724:	e852                	sd	s4,16(sp)
    80001726:	e456                	sd	s5,8(sp)
    80001728:	0080                	addi	s0,sp,64
    8000172a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000172c:	00007497          	auipc	s1,0x7
    80001730:	6b448493          	addi	s1,s1,1716 # 80008de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001734:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001736:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001738:	0000d917          	auipc	s2,0xd
    8000173c:	2a890913          	addi	s2,s2,680 # 8000e9e0 <tickslock>
    80001740:	a811                	j	80001754 <wakeup+0x3c>
      }
      release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	c14080e7          	jalr	-1004(ra) # 80006358 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000174c:	17048493          	addi	s1,s1,368
    80001750:	03248663          	beq	s1,s2,8000177c <wakeup+0x64>
    if(p != myproc()){
    80001754:	00000097          	auipc	ra,0x0
    80001758:	808080e7          	jalr	-2040(ra) # 80000f5c <myproc>
    8000175c:	fea488e3          	beq	s1,a0,8000174c <wakeup+0x34>
      acquire(&p->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	b42080e7          	jalr	-1214(ra) # 800062a4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000176a:	4c9c                	lw	a5,24(s1)
    8000176c:	fd379be3          	bne	a5,s3,80001742 <wakeup+0x2a>
    80001770:	709c                	ld	a5,32(s1)
    80001772:	fd4798e3          	bne	a5,s4,80001742 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001776:	0154ac23          	sw	s5,24(s1)
    8000177a:	b7e1                	j	80001742 <wakeup+0x2a>
    }
  }
}
    8000177c:	70e2                	ld	ra,56(sp)
    8000177e:	7442                	ld	s0,48(sp)
    80001780:	74a2                	ld	s1,40(sp)
    80001782:	7902                	ld	s2,32(sp)
    80001784:	69e2                	ld	s3,24(sp)
    80001786:	6a42                	ld	s4,16(sp)
    80001788:	6aa2                	ld	s5,8(sp)
    8000178a:	6121                	addi	sp,sp,64
    8000178c:	8082                	ret

000000008000178e <reparent>:
{
    8000178e:	7179                	addi	sp,sp,-48
    80001790:	f406                	sd	ra,40(sp)
    80001792:	f022                	sd	s0,32(sp)
    80001794:	ec26                	sd	s1,24(sp)
    80001796:	e84a                	sd	s2,16(sp)
    80001798:	e44e                	sd	s3,8(sp)
    8000179a:	e052                	sd	s4,0(sp)
    8000179c:	1800                	addi	s0,sp,48
    8000179e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017a0:	00007497          	auipc	s1,0x7
    800017a4:	64048493          	addi	s1,s1,1600 # 80008de0 <proc>
      pp->parent = initproc;
    800017a8:	00007a17          	auipc	s4,0x7
    800017ac:	1c8a0a13          	addi	s4,s4,456 # 80008970 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017b0:	0000d997          	auipc	s3,0xd
    800017b4:	23098993          	addi	s3,s3,560 # 8000e9e0 <tickslock>
    800017b8:	a029                	j	800017c2 <reparent+0x34>
    800017ba:	17048493          	addi	s1,s1,368
    800017be:	01348d63          	beq	s1,s3,800017d8 <reparent+0x4a>
    if(pp->parent == p){
    800017c2:	7c9c                	ld	a5,56(s1)
    800017c4:	ff279be3          	bne	a5,s2,800017ba <reparent+0x2c>
      pp->parent = initproc;
    800017c8:	000a3503          	ld	a0,0(s4)
    800017cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017ce:	00000097          	auipc	ra,0x0
    800017d2:	f4a080e7          	jalr	-182(ra) # 80001718 <wakeup>
    800017d6:	b7d5                	j	800017ba <reparent+0x2c>
}
    800017d8:	70a2                	ld	ra,40(sp)
    800017da:	7402                	ld	s0,32(sp)
    800017dc:	64e2                	ld	s1,24(sp)
    800017de:	6942                	ld	s2,16(sp)
    800017e0:	69a2                	ld	s3,8(sp)
    800017e2:	6a02                	ld	s4,0(sp)
    800017e4:	6145                	addi	sp,sp,48
    800017e6:	8082                	ret

00000000800017e8 <exit>:
{
    800017e8:	7179                	addi	sp,sp,-48
    800017ea:	f406                	sd	ra,40(sp)
    800017ec:	f022                	sd	s0,32(sp)
    800017ee:	ec26                	sd	s1,24(sp)
    800017f0:	e84a                	sd	s2,16(sp)
    800017f2:	e44e                	sd	s3,8(sp)
    800017f4:	e052                	sd	s4,0(sp)
    800017f6:	1800                	addi	s0,sp,48
    800017f8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	762080e7          	jalr	1890(ra) # 80000f5c <myproc>
    80001802:	89aa                	mv	s3,a0
  if(p == initproc)
    80001804:	00007797          	auipc	a5,0x7
    80001808:	16c7b783          	ld	a5,364(a5) # 80008970 <initproc>
    8000180c:	0d850493          	addi	s1,a0,216
    80001810:	15850913          	addi	s2,a0,344
    80001814:	02a79363          	bne	a5,a0,8000183a <exit+0x52>
    panic("init exiting");
    80001818:	00007517          	auipc	a0,0x7
    8000181c:	a2850513          	addi	a0,a0,-1496 # 80008240 <etext+0x240>
    80001820:	00004097          	auipc	ra,0x4
    80001824:	54c080e7          	jalr	1356(ra) # 80005d6c <panic>
      fileclose(f);
    80001828:	00002097          	auipc	ra,0x2
    8000182c:	306080e7          	jalr	774(ra) # 80003b2e <fileclose>
      p->ofile[fd] = 0;
    80001830:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001834:	04a1                	addi	s1,s1,8
    80001836:	01248563          	beq	s1,s2,80001840 <exit+0x58>
    if(p->ofile[fd]){
    8000183a:	6088                	ld	a0,0(s1)
    8000183c:	f575                	bnez	a0,80001828 <exit+0x40>
    8000183e:	bfdd                	j	80001834 <exit+0x4c>
  begin_op();
    80001840:	00002097          	auipc	ra,0x2
    80001844:	e26080e7          	jalr	-474(ra) # 80003666 <begin_op>
  iput(p->cwd);
    80001848:	1589b503          	ld	a0,344(s3)
    8000184c:	00001097          	auipc	ra,0x1
    80001850:	608080e7          	jalr	1544(ra) # 80002e54 <iput>
  end_op();
    80001854:	00002097          	auipc	ra,0x2
    80001858:	e90080e7          	jalr	-368(ra) # 800036e4 <end_op>
  p->cwd = 0;
    8000185c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001860:	00007497          	auipc	s1,0x7
    80001864:	16848493          	addi	s1,s1,360 # 800089c8 <wait_lock>
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	a3a080e7          	jalr	-1478(ra) # 800062a4 <acquire>
  reparent(p);
    80001872:	854e                	mv	a0,s3
    80001874:	00000097          	auipc	ra,0x0
    80001878:	f1a080e7          	jalr	-230(ra) # 8000178e <reparent>
  wakeup(p->parent);
    8000187c:	0389b503          	ld	a0,56(s3)
    80001880:	00000097          	auipc	ra,0x0
    80001884:	e98080e7          	jalr	-360(ra) # 80001718 <wakeup>
  acquire(&p->lock);
    80001888:	854e                	mv	a0,s3
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	a1a080e7          	jalr	-1510(ra) # 800062a4 <acquire>
  p->xstate = status;
    80001892:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001896:	4795                	li	a5,5
    80001898:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	aba080e7          	jalr	-1350(ra) # 80006358 <release>
  sched();
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	cfc080e7          	jalr	-772(ra) # 800015a2 <sched>
  panic("zombie exit");
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	9a250513          	addi	a0,a0,-1630 # 80008250 <etext+0x250>
    800018b6:	00004097          	auipc	ra,0x4
    800018ba:	4b6080e7          	jalr	1206(ra) # 80005d6c <panic>

00000000800018be <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018be:	7179                	addi	sp,sp,-48
    800018c0:	f406                	sd	ra,40(sp)
    800018c2:	f022                	sd	s0,32(sp)
    800018c4:	ec26                	sd	s1,24(sp)
    800018c6:	e84a                	sd	s2,16(sp)
    800018c8:	e44e                	sd	s3,8(sp)
    800018ca:	1800                	addi	s0,sp,48
    800018cc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	00007497          	auipc	s1,0x7
    800018d2:	51248493          	addi	s1,s1,1298 # 80008de0 <proc>
    800018d6:	0000d997          	auipc	s3,0xd
    800018da:	10a98993          	addi	s3,s3,266 # 8000e9e0 <tickslock>
    acquire(&p->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	9c4080e7          	jalr	-1596(ra) # 800062a4 <acquire>
    if(p->pid == pid){
    800018e8:	589c                	lw	a5,48(s1)
    800018ea:	01278d63          	beq	a5,s2,80001904 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a68080e7          	jalr	-1432(ra) # 80006358 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018f8:	17048493          	addi	s1,s1,368
    800018fc:	ff3491e3          	bne	s1,s3,800018de <kill+0x20>
  }
  return -1;
    80001900:	557d                	li	a0,-1
    80001902:	a829                	j	8000191c <kill+0x5e>
      p->killed = 1;
    80001904:	4785                	li	a5,1
    80001906:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001908:	4c98                	lw	a4,24(s1)
    8000190a:	4789                	li	a5,2
    8000190c:	00f70f63          	beq	a4,a5,8000192a <kill+0x6c>
      release(&p->lock);
    80001910:	8526                	mv	a0,s1
    80001912:	00005097          	auipc	ra,0x5
    80001916:	a46080e7          	jalr	-1466(ra) # 80006358 <release>
      return 0;
    8000191a:	4501                	li	a0,0
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6145                	addi	sp,sp,48
    80001928:	8082                	ret
        p->state = RUNNABLE;
    8000192a:	478d                	li	a5,3
    8000192c:	cc9c                	sw	a5,24(s1)
    8000192e:	b7cd                	j	80001910 <kill+0x52>

0000000080001930 <setkilled>:

void
setkilled(struct proc *p)
{
    80001930:	1101                	addi	sp,sp,-32
    80001932:	ec06                	sd	ra,24(sp)
    80001934:	e822                	sd	s0,16(sp)
    80001936:	e426                	sd	s1,8(sp)
    80001938:	1000                	addi	s0,sp,32
    8000193a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000193c:	00005097          	auipc	ra,0x5
    80001940:	968080e7          	jalr	-1688(ra) # 800062a4 <acquire>
  p->killed = 1;
    80001944:	4785                	li	a5,1
    80001946:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001948:	8526                	mv	a0,s1
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	a0e080e7          	jalr	-1522(ra) # 80006358 <release>
}
    80001952:	60e2                	ld	ra,24(sp)
    80001954:	6442                	ld	s0,16(sp)
    80001956:	64a2                	ld	s1,8(sp)
    80001958:	6105                	addi	sp,sp,32
    8000195a:	8082                	ret

000000008000195c <killed>:

int
killed(struct proc *p)
{
    8000195c:	1101                	addi	sp,sp,-32
    8000195e:	ec06                	sd	ra,24(sp)
    80001960:	e822                	sd	s0,16(sp)
    80001962:	e426                	sd	s1,8(sp)
    80001964:	e04a                	sd	s2,0(sp)
    80001966:	1000                	addi	s0,sp,32
    80001968:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000196a:	00005097          	auipc	ra,0x5
    8000196e:	93a080e7          	jalr	-1734(ra) # 800062a4 <acquire>
  k = p->killed;
    80001972:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001976:	8526                	mv	a0,s1
    80001978:	00005097          	auipc	ra,0x5
    8000197c:	9e0080e7          	jalr	-1568(ra) # 80006358 <release>
  return k;
}
    80001980:	854a                	mv	a0,s2
    80001982:	60e2                	ld	ra,24(sp)
    80001984:	6442                	ld	s0,16(sp)
    80001986:	64a2                	ld	s1,8(sp)
    80001988:	6902                	ld	s2,0(sp)
    8000198a:	6105                	addi	sp,sp,32
    8000198c:	8082                	ret

000000008000198e <wait>:
{
    8000198e:	715d                	addi	sp,sp,-80
    80001990:	e486                	sd	ra,72(sp)
    80001992:	e0a2                	sd	s0,64(sp)
    80001994:	fc26                	sd	s1,56(sp)
    80001996:	f84a                	sd	s2,48(sp)
    80001998:	f44e                	sd	s3,40(sp)
    8000199a:	f052                	sd	s4,32(sp)
    8000199c:	ec56                	sd	s5,24(sp)
    8000199e:	e85a                	sd	s6,16(sp)
    800019a0:	e45e                	sd	s7,8(sp)
    800019a2:	e062                	sd	s8,0(sp)
    800019a4:	0880                	addi	s0,sp,80
    800019a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	5b4080e7          	jalr	1460(ra) # 80000f5c <myproc>
    800019b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800019b2:	00007517          	auipc	a0,0x7
    800019b6:	01650513          	addi	a0,a0,22 # 800089c8 <wait_lock>
    800019ba:	00005097          	auipc	ra,0x5
    800019be:	8ea080e7          	jalr	-1814(ra) # 800062a4 <acquire>
    havekids = 0;
    800019c2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019c4:	4a15                	li	s4,5
        havekids = 1;
    800019c6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019c8:	0000d997          	auipc	s3,0xd
    800019cc:	01898993          	addi	s3,s3,24 # 8000e9e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019d0:	00007c17          	auipc	s8,0x7
    800019d4:	ff8c0c13          	addi	s8,s8,-8 # 800089c8 <wait_lock>
    havekids = 0;
    800019d8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019da:	00007497          	auipc	s1,0x7
    800019de:	40648493          	addi	s1,s1,1030 # 80008de0 <proc>
    800019e2:	a0bd                	j	80001a50 <wait+0xc2>
          pid = pp->pid;
    800019e4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019e8:	000b0e63          	beqz	s6,80001a04 <wait+0x76>
    800019ec:	4691                	li	a3,4
    800019ee:	02c48613          	addi	a2,s1,44
    800019f2:	85da                	mv	a1,s6
    800019f4:	05093503          	ld	a0,80(s2)
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	11c080e7          	jalr	284(ra) # 80000b14 <copyout>
    80001a00:	02054563          	bltz	a0,80001a2a <wait+0x9c>
          freeproc(pp);
    80001a04:	8526                	mv	a0,s1
    80001a06:	fffff097          	auipc	ra,0xfffff
    80001a0a:	77c080e7          	jalr	1916(ra) # 80001182 <freeproc>
          release(&pp->lock);
    80001a0e:	8526                	mv	a0,s1
    80001a10:	00005097          	auipc	ra,0x5
    80001a14:	948080e7          	jalr	-1720(ra) # 80006358 <release>
          release(&wait_lock);
    80001a18:	00007517          	auipc	a0,0x7
    80001a1c:	fb050513          	addi	a0,a0,-80 # 800089c8 <wait_lock>
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	938080e7          	jalr	-1736(ra) # 80006358 <release>
          return pid;
    80001a28:	a0b5                	j	80001a94 <wait+0x106>
            release(&pp->lock);
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	00005097          	auipc	ra,0x5
    80001a30:	92c080e7          	jalr	-1748(ra) # 80006358 <release>
            release(&wait_lock);
    80001a34:	00007517          	auipc	a0,0x7
    80001a38:	f9450513          	addi	a0,a0,-108 # 800089c8 <wait_lock>
    80001a3c:	00005097          	auipc	ra,0x5
    80001a40:	91c080e7          	jalr	-1764(ra) # 80006358 <release>
            return -1;
    80001a44:	59fd                	li	s3,-1
    80001a46:	a0b9                	j	80001a94 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a48:	17048493          	addi	s1,s1,368
    80001a4c:	03348463          	beq	s1,s3,80001a74 <wait+0xe6>
      if(pp->parent == p){
    80001a50:	7c9c                	ld	a5,56(s1)
    80001a52:	ff279be3          	bne	a5,s2,80001a48 <wait+0xba>
        acquire(&pp->lock);
    80001a56:	8526                	mv	a0,s1
    80001a58:	00005097          	auipc	ra,0x5
    80001a5c:	84c080e7          	jalr	-1972(ra) # 800062a4 <acquire>
        if(pp->state == ZOMBIE){
    80001a60:	4c9c                	lw	a5,24(s1)
    80001a62:	f94781e3          	beq	a5,s4,800019e4 <wait+0x56>
        release(&pp->lock);
    80001a66:	8526                	mv	a0,s1
    80001a68:	00005097          	auipc	ra,0x5
    80001a6c:	8f0080e7          	jalr	-1808(ra) # 80006358 <release>
        havekids = 1;
    80001a70:	8756                	mv	a4,s5
    80001a72:	bfd9                	j	80001a48 <wait+0xba>
    if(!havekids || killed(p)){
    80001a74:	c719                	beqz	a4,80001a82 <wait+0xf4>
    80001a76:	854a                	mv	a0,s2
    80001a78:	00000097          	auipc	ra,0x0
    80001a7c:	ee4080e7          	jalr	-284(ra) # 8000195c <killed>
    80001a80:	c51d                	beqz	a0,80001aae <wait+0x120>
      release(&wait_lock);
    80001a82:	00007517          	auipc	a0,0x7
    80001a86:	f4650513          	addi	a0,a0,-186 # 800089c8 <wait_lock>
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	8ce080e7          	jalr	-1842(ra) # 80006358 <release>
      return -1;
    80001a92:	59fd                	li	s3,-1
}
    80001a94:	854e                	mv	a0,s3
    80001a96:	60a6                	ld	ra,72(sp)
    80001a98:	6406                	ld	s0,64(sp)
    80001a9a:	74e2                	ld	s1,56(sp)
    80001a9c:	7942                	ld	s2,48(sp)
    80001a9e:	79a2                	ld	s3,40(sp)
    80001aa0:	7a02                	ld	s4,32(sp)
    80001aa2:	6ae2                	ld	s5,24(sp)
    80001aa4:	6b42                	ld	s6,16(sp)
    80001aa6:	6ba2                	ld	s7,8(sp)
    80001aa8:	6c02                	ld	s8,0(sp)
    80001aaa:	6161                	addi	sp,sp,80
    80001aac:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001aae:	85e2                	mv	a1,s8
    80001ab0:	854a                	mv	a0,s2
    80001ab2:	00000097          	auipc	ra,0x0
    80001ab6:	c02080e7          	jalr	-1022(ra) # 800016b4 <sleep>
    havekids = 0;
    80001aba:	bf39                	j	800019d8 <wait+0x4a>

0000000080001abc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001abc:	7179                	addi	sp,sp,-48
    80001abe:	f406                	sd	ra,40(sp)
    80001ac0:	f022                	sd	s0,32(sp)
    80001ac2:	ec26                	sd	s1,24(sp)
    80001ac4:	e84a                	sd	s2,16(sp)
    80001ac6:	e44e                	sd	s3,8(sp)
    80001ac8:	e052                	sd	s4,0(sp)
    80001aca:	1800                	addi	s0,sp,48
    80001acc:	84aa                	mv	s1,a0
    80001ace:	892e                	mv	s2,a1
    80001ad0:	89b2                	mv	s3,a2
    80001ad2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	488080e7          	jalr	1160(ra) # 80000f5c <myproc>
  if(user_dst){
    80001adc:	c08d                	beqz	s1,80001afe <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ade:	86d2                	mv	a3,s4
    80001ae0:	864e                	mv	a2,s3
    80001ae2:	85ca                	mv	a1,s2
    80001ae4:	6928                	ld	a0,80(a0)
    80001ae6:	fffff097          	auipc	ra,0xfffff
    80001aea:	02e080e7          	jalr	46(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aee:	70a2                	ld	ra,40(sp)
    80001af0:	7402                	ld	s0,32(sp)
    80001af2:	64e2                	ld	s1,24(sp)
    80001af4:	6942                	ld	s2,16(sp)
    80001af6:	69a2                	ld	s3,8(sp)
    80001af8:	6a02                	ld	s4,0(sp)
    80001afa:	6145                	addi	sp,sp,48
    80001afc:	8082                	ret
    memmove((char *)dst, src, len);
    80001afe:	000a061b          	sext.w	a2,s4
    80001b02:	85ce                	mv	a1,s3
    80001b04:	854a                	mv	a0,s2
    80001b06:	ffffe097          	auipc	ra,0xffffe
    80001b0a:	6d0080e7          	jalr	1744(ra) # 800001d6 <memmove>
    return 0;
    80001b0e:	8526                	mv	a0,s1
    80001b10:	bff9                	j	80001aee <either_copyout+0x32>

0000000080001b12 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b12:	7179                	addi	sp,sp,-48
    80001b14:	f406                	sd	ra,40(sp)
    80001b16:	f022                	sd	s0,32(sp)
    80001b18:	ec26                	sd	s1,24(sp)
    80001b1a:	e84a                	sd	s2,16(sp)
    80001b1c:	e44e                	sd	s3,8(sp)
    80001b1e:	e052                	sd	s4,0(sp)
    80001b20:	1800                	addi	s0,sp,48
    80001b22:	892a                	mv	s2,a0
    80001b24:	84ae                	mv	s1,a1
    80001b26:	89b2                	mv	s3,a2
    80001b28:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b2a:	fffff097          	auipc	ra,0xfffff
    80001b2e:	432080e7          	jalr	1074(ra) # 80000f5c <myproc>
  if(user_src){
    80001b32:	c08d                	beqz	s1,80001b54 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b34:	86d2                	mv	a3,s4
    80001b36:	864e                	mv	a2,s3
    80001b38:	85ca                	mv	a1,s2
    80001b3a:	6928                	ld	a0,80(a0)
    80001b3c:	fffff097          	auipc	ra,0xfffff
    80001b40:	064080e7          	jalr	100(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b44:	70a2                	ld	ra,40(sp)
    80001b46:	7402                	ld	s0,32(sp)
    80001b48:	64e2                	ld	s1,24(sp)
    80001b4a:	6942                	ld	s2,16(sp)
    80001b4c:	69a2                	ld	s3,8(sp)
    80001b4e:	6a02                	ld	s4,0(sp)
    80001b50:	6145                	addi	sp,sp,48
    80001b52:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b54:	000a061b          	sext.w	a2,s4
    80001b58:	85ce                	mv	a1,s3
    80001b5a:	854a                	mv	a0,s2
    80001b5c:	ffffe097          	auipc	ra,0xffffe
    80001b60:	67a080e7          	jalr	1658(ra) # 800001d6 <memmove>
    return 0;
    80001b64:	8526                	mv	a0,s1
    80001b66:	bff9                	j	80001b44 <either_copyin+0x32>

0000000080001b68 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b68:	715d                	addi	sp,sp,-80
    80001b6a:	e486                	sd	ra,72(sp)
    80001b6c:	e0a2                	sd	s0,64(sp)
    80001b6e:	fc26                	sd	s1,56(sp)
    80001b70:	f84a                	sd	s2,48(sp)
    80001b72:	f44e                	sd	s3,40(sp)
    80001b74:	f052                	sd	s4,32(sp)
    80001b76:	ec56                	sd	s5,24(sp)
    80001b78:	e85a                	sd	s6,16(sp)
    80001b7a:	e45e                	sd	s7,8(sp)
    80001b7c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b7e:	00006517          	auipc	a0,0x6
    80001b82:	4ca50513          	addi	a0,a0,1226 # 80008048 <etext+0x48>
    80001b86:	00004097          	auipc	ra,0x4
    80001b8a:	230080e7          	jalr	560(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8e:	00007497          	auipc	s1,0x7
    80001b92:	3b248493          	addi	s1,s1,946 # 80008f40 <proc+0x160>
    80001b96:	0000d917          	auipc	s2,0xd
    80001b9a:	faa90913          	addi	s2,s2,-86 # 8000eb40 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b9e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ba0:	00006997          	auipc	s3,0x6
    80001ba4:	6c098993          	addi	s3,s3,1728 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001ba8:	00006a97          	auipc	s5,0x6
    80001bac:	6c0a8a93          	addi	s5,s5,1728 # 80008268 <etext+0x268>
    printf("\n");
    80001bb0:	00006a17          	auipc	s4,0x6
    80001bb4:	498a0a13          	addi	s4,s4,1176 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb8:	00006b97          	auipc	s7,0x6
    80001bbc:	6f0b8b93          	addi	s7,s7,1776 # 800082a8 <states.0>
    80001bc0:	a00d                	j	80001be2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bc2:	ed06a583          	lw	a1,-304(a3)
    80001bc6:	8556                	mv	a0,s5
    80001bc8:	00004097          	auipc	ra,0x4
    80001bcc:	1ee080e7          	jalr	494(ra) # 80005db6 <printf>
    printf("\n");
    80001bd0:	8552                	mv	a0,s4
    80001bd2:	00004097          	auipc	ra,0x4
    80001bd6:	1e4080e7          	jalr	484(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bda:	17048493          	addi	s1,s1,368
    80001bde:	03248263          	beq	s1,s2,80001c02 <procdump+0x9a>
    if(p->state == UNUSED)
    80001be2:	86a6                	mv	a3,s1
    80001be4:	eb84a783          	lw	a5,-328(s1)
    80001be8:	dbed                	beqz	a5,80001bda <procdump+0x72>
      state = "???";
    80001bea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bec:	fcfb6be3          	bltu	s6,a5,80001bc2 <procdump+0x5a>
    80001bf0:	02079713          	slli	a4,a5,0x20
    80001bf4:	01d75793          	srli	a5,a4,0x1d
    80001bf8:	97de                	add	a5,a5,s7
    80001bfa:	6390                	ld	a2,0(a5)
    80001bfc:	f279                	bnez	a2,80001bc2 <procdump+0x5a>
      state = "???";
    80001bfe:	864e                	mv	a2,s3
    80001c00:	b7c9                	j	80001bc2 <procdump+0x5a>
  }
}
    80001c02:	60a6                	ld	ra,72(sp)
    80001c04:	6406                	ld	s0,64(sp)
    80001c06:	74e2                	ld	s1,56(sp)
    80001c08:	7942                	ld	s2,48(sp)
    80001c0a:	79a2                	ld	s3,40(sp)
    80001c0c:	7a02                	ld	s4,32(sp)
    80001c0e:	6ae2                	ld	s5,24(sp)
    80001c10:	6b42                	ld	s6,16(sp)
    80001c12:	6ba2                	ld	s7,8(sp)
    80001c14:	6161                	addi	sp,sp,80
    80001c16:	8082                	ret

0000000080001c18 <swtch>:
    80001c18:	00153023          	sd	ra,0(a0)
    80001c1c:	00253423          	sd	sp,8(a0)
    80001c20:	e900                	sd	s0,16(a0)
    80001c22:	ed04                	sd	s1,24(a0)
    80001c24:	03253023          	sd	s2,32(a0)
    80001c28:	03353423          	sd	s3,40(a0)
    80001c2c:	03453823          	sd	s4,48(a0)
    80001c30:	03553c23          	sd	s5,56(a0)
    80001c34:	05653023          	sd	s6,64(a0)
    80001c38:	05753423          	sd	s7,72(a0)
    80001c3c:	05853823          	sd	s8,80(a0)
    80001c40:	05953c23          	sd	s9,88(a0)
    80001c44:	07a53023          	sd	s10,96(a0)
    80001c48:	07b53423          	sd	s11,104(a0)
    80001c4c:	0005b083          	ld	ra,0(a1)
    80001c50:	0085b103          	ld	sp,8(a1)
    80001c54:	6980                	ld	s0,16(a1)
    80001c56:	6d84                	ld	s1,24(a1)
    80001c58:	0205b903          	ld	s2,32(a1)
    80001c5c:	0285b983          	ld	s3,40(a1)
    80001c60:	0305ba03          	ld	s4,48(a1)
    80001c64:	0385ba83          	ld	s5,56(a1)
    80001c68:	0405bb03          	ld	s6,64(a1)
    80001c6c:	0485bb83          	ld	s7,72(a1)
    80001c70:	0505bc03          	ld	s8,80(a1)
    80001c74:	0585bc83          	ld	s9,88(a1)
    80001c78:	0605bd03          	ld	s10,96(a1)
    80001c7c:	0685bd83          	ld	s11,104(a1)
    80001c80:	8082                	ret

0000000080001c82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c82:	1141                	addi	sp,sp,-16
    80001c84:	e406                	sd	ra,8(sp)
    80001c86:	e022                	sd	s0,0(sp)
    80001c88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c8a:	00006597          	auipc	a1,0x6
    80001c8e:	64e58593          	addi	a1,a1,1614 # 800082d8 <states.0+0x30>
    80001c92:	0000d517          	auipc	a0,0xd
    80001c96:	d4e50513          	addi	a0,a0,-690 # 8000e9e0 <tickslock>
    80001c9a:	00004097          	auipc	ra,0x4
    80001c9e:	57a080e7          	jalr	1402(ra) # 80006214 <initlock>
}
    80001ca2:	60a2                	ld	ra,8(sp)
    80001ca4:	6402                	ld	s0,0(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e422                	sd	s0,8(sp)
    80001cae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	00003797          	auipc	a5,0x3
    80001cb4:	4f078793          	addi	a5,a5,1264 # 800051a0 <kernelvec>
    80001cb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cbc:	6422                	ld	s0,8(sp)
    80001cbe:	0141                	addi	sp,sp,16
    80001cc0:	8082                	ret

0000000080001cc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e406                	sd	ra,8(sp)
    80001cc6:	e022                	sd	s0,0(sp)
    80001cc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cca:	fffff097          	auipc	ra,0xfffff
    80001cce:	292080e7          	jalr	658(ra) # 80000f5c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cdc:	00005697          	auipc	a3,0x5
    80001ce0:	32468693          	addi	a3,a3,804 # 80007000 <_trampoline>
    80001ce4:	00005717          	auipc	a4,0x5
    80001ce8:	31c70713          	addi	a4,a4,796 # 80007000 <_trampoline>
    80001cec:	8f15                	sub	a4,a4,a3
    80001cee:	040007b7          	lui	a5,0x4000
    80001cf2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cf4:	07b2                	slli	a5,a5,0xc
    80001cf6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cfe:	18002673          	csrr	a2,satp
    80001d02:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d04:	6d30                	ld	a2,88(a0)
    80001d06:	6138                	ld	a4,64(a0)
    80001d08:	6585                	lui	a1,0x1
    80001d0a:	972e                	add	a4,a4,a1
    80001d0c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d0e:	6d38                	ld	a4,88(a0)
    80001d10:	00000617          	auipc	a2,0x0
    80001d14:	13060613          	addi	a2,a2,304 # 80001e40 <usertrap>
    80001d18:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d1c:	8612                	mv	a2,tp
    80001d1e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d24:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d28:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d32:	6f18                	ld	a4,24(a4)
    80001d34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d38:	6928                	ld	a0,80(a0)
    80001d3a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d3c:	00005717          	auipc	a4,0x5
    80001d40:	36070713          	addi	a4,a4,864 # 8000709c <userret>
    80001d44:	8f15                	sub	a4,a4,a3
    80001d46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d48:	577d                	li	a4,-1
    80001d4a:	177e                	slli	a4,a4,0x3f
    80001d4c:	8d59                	or	a0,a0,a4
    80001d4e:	9782                	jalr	a5
}
    80001d50:	60a2                	ld	ra,8(sp)
    80001d52:	6402                	ld	s0,0(sp)
    80001d54:	0141                	addi	sp,sp,16
    80001d56:	8082                	ret

0000000080001d58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d58:	1101                	addi	sp,sp,-32
    80001d5a:	ec06                	sd	ra,24(sp)
    80001d5c:	e822                	sd	s0,16(sp)
    80001d5e:	e426                	sd	s1,8(sp)
    80001d60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d62:	0000d497          	auipc	s1,0xd
    80001d66:	c7e48493          	addi	s1,s1,-898 # 8000e9e0 <tickslock>
    80001d6a:	8526                	mv	a0,s1
    80001d6c:	00004097          	auipc	ra,0x4
    80001d70:	538080e7          	jalr	1336(ra) # 800062a4 <acquire>
  ticks++;
    80001d74:	00007517          	auipc	a0,0x7
    80001d78:	c0450513          	addi	a0,a0,-1020 # 80008978 <ticks>
    80001d7c:	411c                	lw	a5,0(a0)
    80001d7e:	2785                	addiw	a5,a5,1
    80001d80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	996080e7          	jalr	-1642(ra) # 80001718 <wakeup>
  release(&tickslock);
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	5cc080e7          	jalr	1484(ra) # 80006358 <release>
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6105                	addi	sp,sp,32
    80001d9c:	8082                	ret

0000000080001d9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d9e:	1101                	addi	sp,sp,-32
    80001da0:	ec06                	sd	ra,24(sp)
    80001da2:	e822                	sd	s0,16(sp)
    80001da4:	e426                	sd	s1,8(sp)
    80001da6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dac:	00074d63          	bltz	a4,80001dc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001db0:	57fd                	li	a5,-1
    80001db2:	17fe                	slli	a5,a5,0x3f
    80001db4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001db6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001db8:	06f70363          	beq	a4,a5,80001e1e <devintr+0x80>
  }
}
    80001dbc:	60e2                	ld	ra,24(sp)
    80001dbe:	6442                	ld	s0,16(sp)
    80001dc0:	64a2                	ld	s1,8(sp)
    80001dc2:	6105                	addi	sp,sp,32
    80001dc4:	8082                	ret
     (scause & 0xff) == 9){
    80001dc6:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001dca:	46a5                	li	a3,9
    80001dcc:	fed792e3          	bne	a5,a3,80001db0 <devintr+0x12>
    int irq = plic_claim();
    80001dd0:	00003097          	auipc	ra,0x3
    80001dd4:	4d8080e7          	jalr	1240(ra) # 800052a8 <plic_claim>
    80001dd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dda:	47a9                	li	a5,10
    80001ddc:	02f50763          	beq	a0,a5,80001e0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001de0:	4785                	li	a5,1
    80001de2:	02f50963          	beq	a0,a5,80001e14 <devintr+0x76>
    return 1;
    80001de6:	4505                	li	a0,1
    } else if(irq){
    80001de8:	d8f1                	beqz	s1,80001dbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dea:	85a6                	mv	a1,s1
    80001dec:	00006517          	auipc	a0,0x6
    80001df0:	4f450513          	addi	a0,a0,1268 # 800082e0 <states.0+0x38>
    80001df4:	00004097          	auipc	ra,0x4
    80001df8:	fc2080e7          	jalr	-62(ra) # 80005db6 <printf>
      plic_complete(irq);
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	00003097          	auipc	ra,0x3
    80001e02:	4ce080e7          	jalr	1230(ra) # 800052cc <plic_complete>
    return 1;
    80001e06:	4505                	li	a0,1
    80001e08:	bf55                	j	80001dbc <devintr+0x1e>
      uartintr();
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	3ba080e7          	jalr	954(ra) # 800061c4 <uartintr>
    80001e12:	b7ed                	j	80001dfc <devintr+0x5e>
      virtio_disk_intr();
    80001e14:	00004097          	auipc	ra,0x4
    80001e18:	980080e7          	jalr	-1664(ra) # 80005794 <virtio_disk_intr>
    80001e1c:	b7c5                	j	80001dfc <devintr+0x5e>
    if(cpuid() == 0){
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	112080e7          	jalr	274(ra) # 80000f30 <cpuid>
    80001e26:	c901                	beqz	a0,80001e36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e2e:	14479073          	csrw	sip,a5
    return 2;
    80001e32:	4509                	li	a0,2
    80001e34:	b761                	j	80001dbc <devintr+0x1e>
      clockintr();
    80001e36:	00000097          	auipc	ra,0x0
    80001e3a:	f22080e7          	jalr	-222(ra) # 80001d58 <clockintr>
    80001e3e:	b7ed                	j	80001e28 <devintr+0x8a>

0000000080001e40 <usertrap>:
{
    80001e40:	1101                	addi	sp,sp,-32
    80001e42:	ec06                	sd	ra,24(sp)
    80001e44:	e822                	sd	s0,16(sp)
    80001e46:	e426                	sd	s1,8(sp)
    80001e48:	e04a                	sd	s2,0(sp)
    80001e4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e50:	1007f793          	andi	a5,a5,256
    80001e54:	e3b1                	bnez	a5,80001e98 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e56:	00003797          	auipc	a5,0x3
    80001e5a:	34a78793          	addi	a5,a5,842 # 800051a0 <kernelvec>
    80001e5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	0fa080e7          	jalr	250(ra) # 80000f5c <myproc>
    80001e6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e6c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e6e:	14102773          	csrr	a4,sepc
    80001e72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e78:	47a1                	li	a5,8
    80001e7a:	02f70763          	beq	a4,a5,80001ea8 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	f20080e7          	jalr	-224(ra) # 80001d9e <devintr>
    80001e86:	892a                	mv	s2,a0
    80001e88:	c151                	beqz	a0,80001f0c <usertrap+0xcc>
  if(killed(p))
    80001e8a:	8526                	mv	a0,s1
    80001e8c:	00000097          	auipc	ra,0x0
    80001e90:	ad0080e7          	jalr	-1328(ra) # 8000195c <killed>
    80001e94:	c929                	beqz	a0,80001ee6 <usertrap+0xa6>
    80001e96:	a099                	j	80001edc <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e98:	00006517          	auipc	a0,0x6
    80001e9c:	46850513          	addi	a0,a0,1128 # 80008300 <states.0+0x58>
    80001ea0:	00004097          	auipc	ra,0x4
    80001ea4:	ecc080e7          	jalr	-308(ra) # 80005d6c <panic>
    if(killed(p))
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	ab4080e7          	jalr	-1356(ra) # 8000195c <killed>
    80001eb0:	e921                	bnez	a0,80001f00 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001eb2:	6cb8                	ld	a4,88(s1)
    80001eb4:	6f1c                	ld	a5,24(a4)
    80001eb6:	0791                	addi	a5,a5,4
    80001eb8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ebe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	2d4080e7          	jalr	724(ra) # 8000219a <syscall>
  if(killed(p))
    80001ece:	8526                	mv	a0,s1
    80001ed0:	00000097          	auipc	ra,0x0
    80001ed4:	a8c080e7          	jalr	-1396(ra) # 8000195c <killed>
    80001ed8:	c911                	beqz	a0,80001eec <usertrap+0xac>
    80001eda:	4901                	li	s2,0
    exit(-1);
    80001edc:	557d                	li	a0,-1
    80001ede:	00000097          	auipc	ra,0x0
    80001ee2:	90a080e7          	jalr	-1782(ra) # 800017e8 <exit>
  if(which_dev == 2)
    80001ee6:	4789                	li	a5,2
    80001ee8:	04f90f63          	beq	s2,a5,80001f46 <usertrap+0x106>
  usertrapret();
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	dd6080e7          	jalr	-554(ra) # 80001cc2 <usertrapret>
}
    80001ef4:	60e2                	ld	ra,24(sp)
    80001ef6:	6442                	ld	s0,16(sp)
    80001ef8:	64a2                	ld	s1,8(sp)
    80001efa:	6902                	ld	s2,0(sp)
    80001efc:	6105                	addi	sp,sp,32
    80001efe:	8082                	ret
      exit(-1);
    80001f00:	557d                	li	a0,-1
    80001f02:	00000097          	auipc	ra,0x0
    80001f06:	8e6080e7          	jalr	-1818(ra) # 800017e8 <exit>
    80001f0a:	b765                	j	80001eb2 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f0c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f10:	5890                	lw	a2,48(s1)
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	40e50513          	addi	a0,a0,1038 # 80008320 <states.0+0x78>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	e9c080e7          	jalr	-356(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f26:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f2a:	00006517          	auipc	a0,0x6
    80001f2e:	42650513          	addi	a0,a0,1062 # 80008350 <states.0+0xa8>
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	e84080e7          	jalr	-380(ra) # 80005db6 <printf>
    setkilled(p);
    80001f3a:	8526                	mv	a0,s1
    80001f3c:	00000097          	auipc	ra,0x0
    80001f40:	9f4080e7          	jalr	-1548(ra) # 80001930 <setkilled>
    80001f44:	b769                	j	80001ece <usertrap+0x8e>
    yield();
    80001f46:	fffff097          	auipc	ra,0xfffff
    80001f4a:	732080e7          	jalr	1842(ra) # 80001678 <yield>
    80001f4e:	bf79                	j	80001eec <usertrap+0xac>

0000000080001f50 <kerneltrap>:
{
    80001f50:	7179                	addi	sp,sp,-48
    80001f52:	f406                	sd	ra,40(sp)
    80001f54:	f022                	sd	s0,32(sp)
    80001f56:	ec26                	sd	s1,24(sp)
    80001f58:	e84a                	sd	s2,16(sp)
    80001f5a:	e44e                	sd	s3,8(sp)
    80001f5c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f5e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f62:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f66:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f6a:	1004f793          	andi	a5,s1,256
    80001f6e:	cb85                	beqz	a5,80001f9e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f70:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f74:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f76:	ef85                	bnez	a5,80001fae <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f78:	00000097          	auipc	ra,0x0
    80001f7c:	e26080e7          	jalr	-474(ra) # 80001d9e <devintr>
    80001f80:	cd1d                	beqz	a0,80001fbe <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f82:	4789                	li	a5,2
    80001f84:	06f50a63          	beq	a0,a5,80001ff8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f88:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8c:	10049073          	csrw	sstatus,s1
}
    80001f90:	70a2                	ld	ra,40(sp)
    80001f92:	7402                	ld	s0,32(sp)
    80001f94:	64e2                	ld	s1,24(sp)
    80001f96:	6942                	ld	s2,16(sp)
    80001f98:	69a2                	ld	s3,8(sp)
    80001f9a:	6145                	addi	sp,sp,48
    80001f9c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f9e:	00006517          	auipc	a0,0x6
    80001fa2:	3d250513          	addi	a0,a0,978 # 80008370 <states.0+0xc8>
    80001fa6:	00004097          	auipc	ra,0x4
    80001faa:	dc6080e7          	jalr	-570(ra) # 80005d6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	3ea50513          	addi	a0,a0,1002 # 80008398 <states.0+0xf0>
    80001fb6:	00004097          	auipc	ra,0x4
    80001fba:	db6080e7          	jalr	-586(ra) # 80005d6c <panic>
    printf("scause %p\n", scause);
    80001fbe:	85ce                	mv	a1,s3
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	3f850513          	addi	a0,a0,1016 # 800083b8 <states.0+0x110>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	dee080e7          	jalr	-530(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fd4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	3f050513          	addi	a0,a0,1008 # 800083c8 <states.0+0x120>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	dd6080e7          	jalr	-554(ra) # 80005db6 <printf>
    panic("kerneltrap");
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	3f850513          	addi	a0,a0,1016 # 800083e0 <states.0+0x138>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	d7c080e7          	jalr	-644(ra) # 80005d6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ff8:	fffff097          	auipc	ra,0xfffff
    80001ffc:	f64080e7          	jalr	-156(ra) # 80000f5c <myproc>
    80002000:	d541                	beqz	a0,80001f88 <kerneltrap+0x38>
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	f5a080e7          	jalr	-166(ra) # 80000f5c <myproc>
    8000200a:	4d18                	lw	a4,24(a0)
    8000200c:	4791                	li	a5,4
    8000200e:	f6f71de3          	bne	a4,a5,80001f88 <kerneltrap+0x38>
    yield();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	666080e7          	jalr	1638(ra) # 80001678 <yield>
    8000201a:	b7bd                	j	80001f88 <kerneltrap+0x38>

000000008000201c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	1000                	addi	s0,sp,32
    80002026:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	f34080e7          	jalr	-204(ra) # 80000f5c <myproc>
  switch (n) {
    80002030:	4795                	li	a5,5
    80002032:	0497e163          	bltu	a5,s1,80002074 <argraw+0x58>
    80002036:	048a                	slli	s1,s1,0x2
    80002038:	00006717          	auipc	a4,0x6
    8000203c:	3e070713          	addi	a4,a4,992 # 80008418 <states.0+0x170>
    80002040:	94ba                	add	s1,s1,a4
    80002042:	409c                	lw	a5,0(s1)
    80002044:	97ba                	add	a5,a5,a4
    80002046:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002048:	6d3c                	ld	a5,88(a0)
    8000204a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6105                	addi	sp,sp,32
    80002054:	8082                	ret
    return p->trapframe->a1;
    80002056:	6d3c                	ld	a5,88(a0)
    80002058:	7fa8                	ld	a0,120(a5)
    8000205a:	bfcd                	j	8000204c <argraw+0x30>
    return p->trapframe->a2;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	63c8                	ld	a0,128(a5)
    80002060:	b7f5                	j	8000204c <argraw+0x30>
    return p->trapframe->a3;
    80002062:	6d3c                	ld	a5,88(a0)
    80002064:	67c8                	ld	a0,136(a5)
    80002066:	b7dd                	j	8000204c <argraw+0x30>
    return p->trapframe->a4;
    80002068:	6d3c                	ld	a5,88(a0)
    8000206a:	6bc8                	ld	a0,144(a5)
    8000206c:	b7c5                	j	8000204c <argraw+0x30>
    return p->trapframe->a5;
    8000206e:	6d3c                	ld	a5,88(a0)
    80002070:	6fc8                	ld	a0,152(a5)
    80002072:	bfe9                	j	8000204c <argraw+0x30>
  panic("argraw");
    80002074:	00006517          	auipc	a0,0x6
    80002078:	37c50513          	addi	a0,a0,892 # 800083f0 <states.0+0x148>
    8000207c:	00004097          	auipc	ra,0x4
    80002080:	cf0080e7          	jalr	-784(ra) # 80005d6c <panic>

0000000080002084 <fetchaddr>:
{
    80002084:	1101                	addi	sp,sp,-32
    80002086:	ec06                	sd	ra,24(sp)
    80002088:	e822                	sd	s0,16(sp)
    8000208a:	e426                	sd	s1,8(sp)
    8000208c:	e04a                	sd	s2,0(sp)
    8000208e:	1000                	addi	s0,sp,32
    80002090:	84aa                	mv	s1,a0
    80002092:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	ec8080e7          	jalr	-312(ra) # 80000f5c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000209c:	653c                	ld	a5,72(a0)
    8000209e:	02f4f863          	bgeu	s1,a5,800020ce <fetchaddr+0x4a>
    800020a2:	00848713          	addi	a4,s1,8
    800020a6:	02e7e663          	bltu	a5,a4,800020d2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020aa:	46a1                	li	a3,8
    800020ac:	8626                	mv	a2,s1
    800020ae:	85ca                	mv	a1,s2
    800020b0:	6928                	ld	a0,80(a0)
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	aee080e7          	jalr	-1298(ra) # 80000ba0 <copyin>
    800020ba:	00a03533          	snez	a0,a0
    800020be:	40a00533          	neg	a0,a0
}
    800020c2:	60e2                	ld	ra,24(sp)
    800020c4:	6442                	ld	s0,16(sp)
    800020c6:	64a2                	ld	s1,8(sp)
    800020c8:	6902                	ld	s2,0(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret
    return -1;
    800020ce:	557d                	li	a0,-1
    800020d0:	bfcd                	j	800020c2 <fetchaddr+0x3e>
    800020d2:	557d                	li	a0,-1
    800020d4:	b7fd                	j	800020c2 <fetchaddr+0x3e>

00000000800020d6 <fetchstr>:
{
    800020d6:	7179                	addi	sp,sp,-48
    800020d8:	f406                	sd	ra,40(sp)
    800020da:	f022                	sd	s0,32(sp)
    800020dc:	ec26                	sd	s1,24(sp)
    800020de:	e84a                	sd	s2,16(sp)
    800020e0:	e44e                	sd	s3,8(sp)
    800020e2:	1800                	addi	s0,sp,48
    800020e4:	892a                	mv	s2,a0
    800020e6:	84ae                	mv	s1,a1
    800020e8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	e72080e7          	jalr	-398(ra) # 80000f5c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020f2:	86ce                	mv	a3,s3
    800020f4:	864a                	mv	a2,s2
    800020f6:	85a6                	mv	a1,s1
    800020f8:	6928                	ld	a0,80(a0)
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	b34080e7          	jalr	-1228(ra) # 80000c2e <copyinstr>
    80002102:	00054e63          	bltz	a0,8000211e <fetchstr+0x48>
  return strlen(buf);
    80002106:	8526                	mv	a0,s1
    80002108:	ffffe097          	auipc	ra,0xffffe
    8000210c:	1ee080e7          	jalr	494(ra) # 800002f6 <strlen>
}
    80002110:	70a2                	ld	ra,40(sp)
    80002112:	7402                	ld	s0,32(sp)
    80002114:	64e2                	ld	s1,24(sp)
    80002116:	6942                	ld	s2,16(sp)
    80002118:	69a2                	ld	s3,8(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret
    return -1;
    8000211e:	557d                	li	a0,-1
    80002120:	bfc5                	j	80002110 <fetchstr+0x3a>

0000000080002122 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	e426                	sd	s1,8(sp)
    8000212a:	1000                	addi	s0,sp,32
    8000212c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	eee080e7          	jalr	-274(ra) # 8000201c <argraw>
    80002136:	c088                	sw	a0,0(s1)
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	1000                	addi	s0,sp,32
    8000214c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	ece080e7          	jalr	-306(ra) # 8000201c <argraw>
    80002156:	e088                	sd	a0,0(s1)
}
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	64a2                	ld	s1,8(sp)
    8000215e:	6105                	addi	sp,sp,32
    80002160:	8082                	ret

0000000080002162 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002162:	7179                	addi	sp,sp,-48
    80002164:	f406                	sd	ra,40(sp)
    80002166:	f022                	sd	s0,32(sp)
    80002168:	ec26                	sd	s1,24(sp)
    8000216a:	e84a                	sd	s2,16(sp)
    8000216c:	1800                	addi	s0,sp,48
    8000216e:	84ae                	mv	s1,a1
    80002170:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002172:	fd840593          	addi	a1,s0,-40
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	fcc080e7          	jalr	-52(ra) # 80002142 <argaddr>
  return fetchstr(addr, buf, max);
    8000217e:	864a                	mv	a2,s2
    80002180:	85a6                	mv	a1,s1
    80002182:	fd843503          	ld	a0,-40(s0)
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	f50080e7          	jalr	-176(ra) # 800020d6 <fetchstr>
}
    8000218e:	70a2                	ld	ra,40(sp)
    80002190:	7402                	ld	s0,32(sp)
    80002192:	64e2                	ld	s1,24(sp)
    80002194:	6942                	ld	s2,16(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret

000000008000219a <syscall>:



void
syscall(void)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	e04a                	sd	s2,0(sp)
    800021a4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	db6080e7          	jalr	-586(ra) # 80000f5c <myproc>
    800021ae:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021b0:	05853903          	ld	s2,88(a0)
    800021b4:	0a893783          	ld	a5,168(s2)
    800021b8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021bc:	37fd                	addiw	a5,a5,-1
    800021be:	4775                	li	a4,29
    800021c0:	00f76f63          	bltu	a4,a5,800021de <syscall+0x44>
    800021c4:	00369713          	slli	a4,a3,0x3
    800021c8:	00006797          	auipc	a5,0x6
    800021cc:	26878793          	addi	a5,a5,616 # 80008430 <syscalls>
    800021d0:	97ba                	add	a5,a5,a4
    800021d2:	639c                	ld	a5,0(a5)
    800021d4:	c789                	beqz	a5,800021de <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021d6:	9782                	jalr	a5
    800021d8:	06a93823          	sd	a0,112(s2)
    800021dc:	a839                	j	800021fa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021de:	16048613          	addi	a2,s1,352
    800021e2:	588c                	lw	a1,48(s1)
    800021e4:	00006517          	auipc	a0,0x6
    800021e8:	21450513          	addi	a0,a0,532 # 800083f8 <states.0+0x150>
    800021ec:	00004097          	auipc	ra,0x4
    800021f0:	bca080e7          	jalr	-1078(ra) # 80005db6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021f4:	6cbc                	ld	a5,88(s1)
    800021f6:	577d                	li	a4,-1
    800021f8:	fbb8                	sd	a4,112(a5)
  }
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6902                	ld	s2,0(sp)
    80002202:	6105                	addi	sp,sp,32
    80002204:	8082                	ret

0000000080002206 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002206:	1101                	addi	sp,sp,-32
    80002208:	ec06                	sd	ra,24(sp)
    8000220a:	e822                	sd	s0,16(sp)
    8000220c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000220e:	fec40593          	addi	a1,s0,-20
    80002212:	4501                	li	a0,0
    80002214:	00000097          	auipc	ra,0x0
    80002218:	f0e080e7          	jalr	-242(ra) # 80002122 <argint>
  exit(n);
    8000221c:	fec42503          	lw	a0,-20(s0)
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	5c8080e7          	jalr	1480(ra) # 800017e8 <exit>
  return 0;  // not reached
}
    80002228:	4501                	li	a0,0
    8000222a:	60e2                	ld	ra,24(sp)
    8000222c:	6442                	ld	s0,16(sp)
    8000222e:	6105                	addi	sp,sp,32
    80002230:	8082                	ret

0000000080002232 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002232:	1141                	addi	sp,sp,-16
    80002234:	e406                	sd	ra,8(sp)
    80002236:	e022                	sd	s0,0(sp)
    80002238:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	d22080e7          	jalr	-734(ra) # 80000f5c <myproc>
}
    80002242:	5908                	lw	a0,48(a0)
    80002244:	60a2                	ld	ra,8(sp)
    80002246:	6402                	ld	s0,0(sp)
    80002248:	0141                	addi	sp,sp,16
    8000224a:	8082                	ret

000000008000224c <sys_fork>:

uint64
sys_fork(void)
{
    8000224c:	1141                	addi	sp,sp,-16
    8000224e:	e406                	sd	ra,8(sp)
    80002250:	e022                	sd	s0,0(sp)
    80002252:	0800                	addi	s0,sp,16
  return fork();
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	16e080e7          	jalr	366(ra) # 800013c2 <fork>
}
    8000225c:	60a2                	ld	ra,8(sp)
    8000225e:	6402                	ld	s0,0(sp)
    80002260:	0141                	addi	sp,sp,16
    80002262:	8082                	ret

0000000080002264 <sys_wait>:

uint64
sys_wait(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000226c:	fe840593          	addi	a1,s0,-24
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	ed0080e7          	jalr	-304(ra) # 80002142 <argaddr>
  return wait(p);
    8000227a:	fe843503          	ld	a0,-24(s0)
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	710080e7          	jalr	1808(ra) # 8000198e <wait>
}
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	6105                	addi	sp,sp,32
    8000228c:	8082                	ret

000000008000228e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000228e:	7179                	addi	sp,sp,-48
    80002290:	f406                	sd	ra,40(sp)
    80002292:	f022                	sd	s0,32(sp)
    80002294:	ec26                	sd	s1,24(sp)
    80002296:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002298:	fdc40593          	addi	a1,s0,-36
    8000229c:	4501                	li	a0,0
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	e84080e7          	jalr	-380(ra) # 80002122 <argint>
  addr = myproc()->sz;
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	cb6080e7          	jalr	-842(ra) # 80000f5c <myproc>
    800022ae:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022b0:	fdc42503          	lw	a0,-36(s0)
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	0b2080e7          	jalr	178(ra) # 80001366 <growproc>
    800022bc:	00054863          	bltz	a0,800022cc <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022c0:	8526                	mv	a0,s1
    800022c2:	70a2                	ld	ra,40(sp)
    800022c4:	7402                	ld	s0,32(sp)
    800022c6:	64e2                	ld	s1,24(sp)
    800022c8:	6145                	addi	sp,sp,48
    800022ca:	8082                	ret
    return -1;
    800022cc:	54fd                	li	s1,-1
    800022ce:	bfcd                	j	800022c0 <sys_sbrk+0x32>

00000000800022d0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022d0:	7139                	addi	sp,sp,-64
    800022d2:	fc06                	sd	ra,56(sp)
    800022d4:	f822                	sd	s0,48(sp)
    800022d6:	f426                	sd	s1,40(sp)
    800022d8:	f04a                	sd	s2,32(sp)
    800022da:	ec4e                	sd	s3,24(sp)
    800022dc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022de:	fcc40593          	addi	a1,s0,-52
    800022e2:	4501                	li	a0,0
    800022e4:	00000097          	auipc	ra,0x0
    800022e8:	e3e080e7          	jalr	-450(ra) # 80002122 <argint>
  acquire(&tickslock);
    800022ec:	0000c517          	auipc	a0,0xc
    800022f0:	6f450513          	addi	a0,a0,1780 # 8000e9e0 <tickslock>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	fb0080e7          	jalr	-80(ra) # 800062a4 <acquire>
  ticks0 = ticks;
    800022fc:	00006917          	auipc	s2,0x6
    80002300:	67c92903          	lw	s2,1660(s2) # 80008978 <ticks>
  while(ticks - ticks0 < n){
    80002304:	fcc42783          	lw	a5,-52(s0)
    80002308:	cf9d                	beqz	a5,80002346 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000230a:	0000c997          	auipc	s3,0xc
    8000230e:	6d698993          	addi	s3,s3,1750 # 8000e9e0 <tickslock>
    80002312:	00006497          	auipc	s1,0x6
    80002316:	66648493          	addi	s1,s1,1638 # 80008978 <ticks>
    if(killed(myproc())){
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	c42080e7          	jalr	-958(ra) # 80000f5c <myproc>
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	63a080e7          	jalr	1594(ra) # 8000195c <killed>
    8000232a:	ed15                	bnez	a0,80002366 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000232c:	85ce                	mv	a1,s3
    8000232e:	8526                	mv	a0,s1
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	384080e7          	jalr	900(ra) # 800016b4 <sleep>
  while(ticks - ticks0 < n){
    80002338:	409c                	lw	a5,0(s1)
    8000233a:	412787bb          	subw	a5,a5,s2
    8000233e:	fcc42703          	lw	a4,-52(s0)
    80002342:	fce7ece3          	bltu	a5,a4,8000231a <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002346:	0000c517          	auipc	a0,0xc
    8000234a:	69a50513          	addi	a0,a0,1690 # 8000e9e0 <tickslock>
    8000234e:	00004097          	auipc	ra,0x4
    80002352:	00a080e7          	jalr	10(ra) # 80006358 <release>
  return 0;
    80002356:	4501                	li	a0,0
}
    80002358:	70e2                	ld	ra,56(sp)
    8000235a:	7442                	ld	s0,48(sp)
    8000235c:	74a2                	ld	s1,40(sp)
    8000235e:	7902                	ld	s2,32(sp)
    80002360:	69e2                	ld	s3,24(sp)
    80002362:	6121                	addi	sp,sp,64
    80002364:	8082                	ret
      release(&tickslock);
    80002366:	0000c517          	auipc	a0,0xc
    8000236a:	67a50513          	addi	a0,a0,1658 # 8000e9e0 <tickslock>
    8000236e:	00004097          	auipc	ra,0x4
    80002372:	fea080e7          	jalr	-22(ra) # 80006358 <release>
      return -1;
    80002376:	557d                	li	a0,-1
    80002378:	b7c5                	j	80002358 <sys_sleep+0x88>

000000008000237a <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000237a:	1141                	addi	sp,sp,-16
    8000237c:	e422                	sd	s0,8(sp)
    8000237e:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002380:	4501                	li	a0,0
    80002382:	6422                	ld	s0,8(sp)
    80002384:	0141                	addi	sp,sp,16
    80002386:	8082                	ret

0000000080002388 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002388:	1101                	addi	sp,sp,-32
    8000238a:	ec06                	sd	ra,24(sp)
    8000238c:	e822                	sd	s0,16(sp)
    8000238e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002390:	fec40593          	addi	a1,s0,-20
    80002394:	4501                	li	a0,0
    80002396:	00000097          	auipc	ra,0x0
    8000239a:	d8c080e7          	jalr	-628(ra) # 80002122 <argint>
  return kill(pid);
    8000239e:	fec42503          	lw	a0,-20(s0)
    800023a2:	fffff097          	auipc	ra,0xfffff
    800023a6:	51c080e7          	jalr	1308(ra) # 800018be <kill>
}
    800023aa:	60e2                	ld	ra,24(sp)
    800023ac:	6442                	ld	s0,16(sp)
    800023ae:	6105                	addi	sp,sp,32
    800023b0:	8082                	ret

00000000800023b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023b2:	1101                	addi	sp,sp,-32
    800023b4:	ec06                	sd	ra,24(sp)
    800023b6:	e822                	sd	s0,16(sp)
    800023b8:	e426                	sd	s1,8(sp)
    800023ba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023bc:	0000c517          	auipc	a0,0xc
    800023c0:	62450513          	addi	a0,a0,1572 # 8000e9e0 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	ee0080e7          	jalr	-288(ra) # 800062a4 <acquire>
  xticks = ticks;
    800023cc:	00006497          	auipc	s1,0x6
    800023d0:	5ac4a483          	lw	s1,1452(s1) # 80008978 <ticks>
  release(&tickslock);
    800023d4:	0000c517          	auipc	a0,0xc
    800023d8:	60c50513          	addi	a0,a0,1548 # 8000e9e0 <tickslock>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	f7c080e7          	jalr	-132(ra) # 80006358 <release>
  return xticks;
}
    800023e4:	02049513          	slli	a0,s1,0x20
    800023e8:	9101                	srli	a0,a0,0x20
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	addi	sp,sp,32
    800023f2:	8082                	ret

00000000800023f4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023f4:	7179                	addi	sp,sp,-48
    800023f6:	f406                	sd	ra,40(sp)
    800023f8:	f022                	sd	s0,32(sp)
    800023fa:	ec26                	sd	s1,24(sp)
    800023fc:	e84a                	sd	s2,16(sp)
    800023fe:	e44e                	sd	s3,8(sp)
    80002400:	e052                	sd	s4,0(sp)
    80002402:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002404:	00006597          	auipc	a1,0x6
    80002408:	12458593          	addi	a1,a1,292 # 80008528 <syscalls+0xf8>
    8000240c:	0000c517          	auipc	a0,0xc
    80002410:	5ec50513          	addi	a0,a0,1516 # 8000e9f8 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	e00080e7          	jalr	-512(ra) # 80006214 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000241c:	00014797          	auipc	a5,0x14
    80002420:	5dc78793          	addi	a5,a5,1500 # 800169f8 <bcache+0x8000>
    80002424:	00015717          	auipc	a4,0x15
    80002428:	83c70713          	addi	a4,a4,-1988 # 80016c60 <bcache+0x8268>
    8000242c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002430:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002434:	0000c497          	auipc	s1,0xc
    80002438:	5dc48493          	addi	s1,s1,1500 # 8000ea10 <bcache+0x18>
    b->next = bcache.head.next;
    8000243c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000243e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002440:	00006a17          	auipc	s4,0x6
    80002444:	0f0a0a13          	addi	s4,s4,240 # 80008530 <syscalls+0x100>
    b->next = bcache.head.next;
    80002448:	2b893783          	ld	a5,696(s2)
    8000244c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000244e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002452:	85d2                	mv	a1,s4
    80002454:	01048513          	addi	a0,s1,16
    80002458:	00001097          	auipc	ra,0x1
    8000245c:	4c8080e7          	jalr	1224(ra) # 80003920 <initsleeplock>
    bcache.head.next->prev = b;
    80002460:	2b893783          	ld	a5,696(s2)
    80002464:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002466:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000246a:	45848493          	addi	s1,s1,1112
    8000246e:	fd349de3          	bne	s1,s3,80002448 <binit+0x54>
  }
}
    80002472:	70a2                	ld	ra,40(sp)
    80002474:	7402                	ld	s0,32(sp)
    80002476:	64e2                	ld	s1,24(sp)
    80002478:	6942                	ld	s2,16(sp)
    8000247a:	69a2                	ld	s3,8(sp)
    8000247c:	6a02                	ld	s4,0(sp)
    8000247e:	6145                	addi	sp,sp,48
    80002480:	8082                	ret

0000000080002482 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002482:	7179                	addi	sp,sp,-48
    80002484:	f406                	sd	ra,40(sp)
    80002486:	f022                	sd	s0,32(sp)
    80002488:	ec26                	sd	s1,24(sp)
    8000248a:	e84a                	sd	s2,16(sp)
    8000248c:	e44e                	sd	s3,8(sp)
    8000248e:	1800                	addi	s0,sp,48
    80002490:	892a                	mv	s2,a0
    80002492:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002494:	0000c517          	auipc	a0,0xc
    80002498:	56450513          	addi	a0,a0,1380 # 8000e9f8 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	e08080e7          	jalr	-504(ra) # 800062a4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024a4:	00015497          	auipc	s1,0x15
    800024a8:	80c4b483          	ld	s1,-2036(s1) # 80016cb0 <bcache+0x82b8>
    800024ac:	00014797          	auipc	a5,0x14
    800024b0:	7b478793          	addi	a5,a5,1972 # 80016c60 <bcache+0x8268>
    800024b4:	02f48f63          	beq	s1,a5,800024f2 <bread+0x70>
    800024b8:	873e                	mv	a4,a5
    800024ba:	a021                	j	800024c2 <bread+0x40>
    800024bc:	68a4                	ld	s1,80(s1)
    800024be:	02e48a63          	beq	s1,a4,800024f2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024c2:	449c                	lw	a5,8(s1)
    800024c4:	ff279ce3          	bne	a5,s2,800024bc <bread+0x3a>
    800024c8:	44dc                	lw	a5,12(s1)
    800024ca:	ff3799e3          	bne	a5,s3,800024bc <bread+0x3a>
      b->refcnt++;
    800024ce:	40bc                	lw	a5,64(s1)
    800024d0:	2785                	addiw	a5,a5,1
    800024d2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024d4:	0000c517          	auipc	a0,0xc
    800024d8:	52450513          	addi	a0,a0,1316 # 8000e9f8 <bcache>
    800024dc:	00004097          	auipc	ra,0x4
    800024e0:	e7c080e7          	jalr	-388(ra) # 80006358 <release>
      acquiresleep(&b->lock);
    800024e4:	01048513          	addi	a0,s1,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	472080e7          	jalr	1138(ra) # 8000395a <acquiresleep>
      return b;
    800024f0:	a8b9                	j	8000254e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f2:	00014497          	auipc	s1,0x14
    800024f6:	7b64b483          	ld	s1,1974(s1) # 80016ca8 <bcache+0x82b0>
    800024fa:	00014797          	auipc	a5,0x14
    800024fe:	76678793          	addi	a5,a5,1894 # 80016c60 <bcache+0x8268>
    80002502:	00f48863          	beq	s1,a5,80002512 <bread+0x90>
    80002506:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002508:	40bc                	lw	a5,64(s1)
    8000250a:	cf81                	beqz	a5,80002522 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000250c:	64a4                	ld	s1,72(s1)
    8000250e:	fee49de3          	bne	s1,a4,80002508 <bread+0x86>
  panic("bget: no buffers");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	02650513          	addi	a0,a0,38 # 80008538 <syscalls+0x108>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	852080e7          	jalr	-1966(ra) # 80005d6c <panic>
      b->dev = dev;
    80002522:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002526:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000252a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000252e:	4785                	li	a5,1
    80002530:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002532:	0000c517          	auipc	a0,0xc
    80002536:	4c650513          	addi	a0,a0,1222 # 8000e9f8 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	e1e080e7          	jalr	-482(ra) # 80006358 <release>
      acquiresleep(&b->lock);
    80002542:	01048513          	addi	a0,s1,16
    80002546:	00001097          	auipc	ra,0x1
    8000254a:	414080e7          	jalr	1044(ra) # 8000395a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000254e:	409c                	lw	a5,0(s1)
    80002550:	cb89                	beqz	a5,80002562 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002552:	8526                	mv	a0,s1
    80002554:	70a2                	ld	ra,40(sp)
    80002556:	7402                	ld	s0,32(sp)
    80002558:	64e2                	ld	s1,24(sp)
    8000255a:	6942                	ld	s2,16(sp)
    8000255c:	69a2                	ld	s3,8(sp)
    8000255e:	6145                	addi	sp,sp,48
    80002560:	8082                	ret
    virtio_disk_rw(b, 0);
    80002562:	4581                	li	a1,0
    80002564:	8526                	mv	a0,s1
    80002566:	00003097          	auipc	ra,0x3
    8000256a:	ffc080e7          	jalr	-4(ra) # 80005562 <virtio_disk_rw>
    b->valid = 1;
    8000256e:	4785                	li	a5,1
    80002570:	c09c                	sw	a5,0(s1)
  return b;
    80002572:	b7c5                	j	80002552 <bread+0xd0>

0000000080002574 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002574:	1101                	addi	sp,sp,-32
    80002576:	ec06                	sd	ra,24(sp)
    80002578:	e822                	sd	s0,16(sp)
    8000257a:	e426                	sd	s1,8(sp)
    8000257c:	1000                	addi	s0,sp,32
    8000257e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002580:	0541                	addi	a0,a0,16
    80002582:	00001097          	auipc	ra,0x1
    80002586:	472080e7          	jalr	1138(ra) # 800039f4 <holdingsleep>
    8000258a:	cd01                	beqz	a0,800025a2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000258c:	4585                	li	a1,1
    8000258e:	8526                	mv	a0,s1
    80002590:	00003097          	auipc	ra,0x3
    80002594:	fd2080e7          	jalr	-46(ra) # 80005562 <virtio_disk_rw>
}
    80002598:	60e2                	ld	ra,24(sp)
    8000259a:	6442                	ld	s0,16(sp)
    8000259c:	64a2                	ld	s1,8(sp)
    8000259e:	6105                	addi	sp,sp,32
    800025a0:	8082                	ret
    panic("bwrite");
    800025a2:	00006517          	auipc	a0,0x6
    800025a6:	fae50513          	addi	a0,a0,-82 # 80008550 <syscalls+0x120>
    800025aa:	00003097          	auipc	ra,0x3
    800025ae:	7c2080e7          	jalr	1986(ra) # 80005d6c <panic>

00000000800025b2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025b2:	1101                	addi	sp,sp,-32
    800025b4:	ec06                	sd	ra,24(sp)
    800025b6:	e822                	sd	s0,16(sp)
    800025b8:	e426                	sd	s1,8(sp)
    800025ba:	e04a                	sd	s2,0(sp)
    800025bc:	1000                	addi	s0,sp,32
    800025be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025c0:	01050913          	addi	s2,a0,16
    800025c4:	854a                	mv	a0,s2
    800025c6:	00001097          	auipc	ra,0x1
    800025ca:	42e080e7          	jalr	1070(ra) # 800039f4 <holdingsleep>
    800025ce:	c92d                	beqz	a0,80002640 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025d0:	854a                	mv	a0,s2
    800025d2:	00001097          	auipc	ra,0x1
    800025d6:	3de080e7          	jalr	990(ra) # 800039b0 <releasesleep>

  acquire(&bcache.lock);
    800025da:	0000c517          	auipc	a0,0xc
    800025de:	41e50513          	addi	a0,a0,1054 # 8000e9f8 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	cc2080e7          	jalr	-830(ra) # 800062a4 <acquire>
  b->refcnt--;
    800025ea:	40bc                	lw	a5,64(s1)
    800025ec:	37fd                	addiw	a5,a5,-1
    800025ee:	0007871b          	sext.w	a4,a5
    800025f2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025f4:	eb05                	bnez	a4,80002624 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025f6:	68bc                	ld	a5,80(s1)
    800025f8:	64b8                	ld	a4,72(s1)
    800025fa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025fc:	64bc                	ld	a5,72(s1)
    800025fe:	68b8                	ld	a4,80(s1)
    80002600:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002602:	00014797          	auipc	a5,0x14
    80002606:	3f678793          	addi	a5,a5,1014 # 800169f8 <bcache+0x8000>
    8000260a:	2b87b703          	ld	a4,696(a5)
    8000260e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002610:	00014717          	auipc	a4,0x14
    80002614:	65070713          	addi	a4,a4,1616 # 80016c60 <bcache+0x8268>
    80002618:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000261a:	2b87b703          	ld	a4,696(a5)
    8000261e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002620:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002624:	0000c517          	auipc	a0,0xc
    80002628:	3d450513          	addi	a0,a0,980 # 8000e9f8 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	d2c080e7          	jalr	-724(ra) # 80006358 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6902                	ld	s2,0(sp)
    8000263c:	6105                	addi	sp,sp,32
    8000263e:	8082                	ret
    panic("brelse");
    80002640:	00006517          	auipc	a0,0x6
    80002644:	f1850513          	addi	a0,a0,-232 # 80008558 <syscalls+0x128>
    80002648:	00003097          	auipc	ra,0x3
    8000264c:	724080e7          	jalr	1828(ra) # 80005d6c <panic>

0000000080002650 <bpin>:

void
bpin(struct buf *b) {
    80002650:	1101                	addi	sp,sp,-32
    80002652:	ec06                	sd	ra,24(sp)
    80002654:	e822                	sd	s0,16(sp)
    80002656:	e426                	sd	s1,8(sp)
    80002658:	1000                	addi	s0,sp,32
    8000265a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000265c:	0000c517          	auipc	a0,0xc
    80002660:	39c50513          	addi	a0,a0,924 # 8000e9f8 <bcache>
    80002664:	00004097          	auipc	ra,0x4
    80002668:	c40080e7          	jalr	-960(ra) # 800062a4 <acquire>
  b->refcnt++;
    8000266c:	40bc                	lw	a5,64(s1)
    8000266e:	2785                	addiw	a5,a5,1
    80002670:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002672:	0000c517          	auipc	a0,0xc
    80002676:	38650513          	addi	a0,a0,902 # 8000e9f8 <bcache>
    8000267a:	00004097          	auipc	ra,0x4
    8000267e:	cde080e7          	jalr	-802(ra) # 80006358 <release>
}
    80002682:	60e2                	ld	ra,24(sp)
    80002684:	6442                	ld	s0,16(sp)
    80002686:	64a2                	ld	s1,8(sp)
    80002688:	6105                	addi	sp,sp,32
    8000268a:	8082                	ret

000000008000268c <bunpin>:

void
bunpin(struct buf *b) {
    8000268c:	1101                	addi	sp,sp,-32
    8000268e:	ec06                	sd	ra,24(sp)
    80002690:	e822                	sd	s0,16(sp)
    80002692:	e426                	sd	s1,8(sp)
    80002694:	1000                	addi	s0,sp,32
    80002696:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002698:	0000c517          	auipc	a0,0xc
    8000269c:	36050513          	addi	a0,a0,864 # 8000e9f8 <bcache>
    800026a0:	00004097          	auipc	ra,0x4
    800026a4:	c04080e7          	jalr	-1020(ra) # 800062a4 <acquire>
  b->refcnt--;
    800026a8:	40bc                	lw	a5,64(s1)
    800026aa:	37fd                	addiw	a5,a5,-1
    800026ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026ae:	0000c517          	auipc	a0,0xc
    800026b2:	34a50513          	addi	a0,a0,842 # 8000e9f8 <bcache>
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	ca2080e7          	jalr	-862(ra) # 80006358 <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	e04a                	sd	s2,0(sp)
    800026d2:	1000                	addi	s0,sp,32
    800026d4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026d6:	00d5d59b          	srliw	a1,a1,0xd
    800026da:	00015797          	auipc	a5,0x15
    800026de:	9fa7a783          	lw	a5,-1542(a5) # 800170d4 <sb+0x1c>
    800026e2:	9dbd                	addw	a1,a1,a5
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	d9e080e7          	jalr	-610(ra) # 80002482 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026ec:	0074f713          	andi	a4,s1,7
    800026f0:	4785                	li	a5,1
    800026f2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026f6:	14ce                	slli	s1,s1,0x33
    800026f8:	90d9                	srli	s1,s1,0x36
    800026fa:	00950733          	add	a4,a0,s1
    800026fe:	05874703          	lbu	a4,88(a4)
    80002702:	00e7f6b3          	and	a3,a5,a4
    80002706:	c69d                	beqz	a3,80002734 <bfree+0x6c>
    80002708:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000270a:	94aa                	add	s1,s1,a0
    8000270c:	fff7c793          	not	a5,a5
    80002710:	8f7d                	and	a4,a4,a5
    80002712:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002716:	00001097          	auipc	ra,0x1
    8000271a:	126080e7          	jalr	294(ra) # 8000383c <log_write>
  brelse(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00000097          	auipc	ra,0x0
    80002724:	e92080e7          	jalr	-366(ra) # 800025b2 <brelse>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6902                	ld	s2,0(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret
    panic("freeing free block");
    80002734:	00006517          	auipc	a0,0x6
    80002738:	e2c50513          	addi	a0,a0,-468 # 80008560 <syscalls+0x130>
    8000273c:	00003097          	auipc	ra,0x3
    80002740:	630080e7          	jalr	1584(ra) # 80005d6c <panic>

0000000080002744 <balloc>:
{
    80002744:	711d                	addi	sp,sp,-96
    80002746:	ec86                	sd	ra,88(sp)
    80002748:	e8a2                	sd	s0,80(sp)
    8000274a:	e4a6                	sd	s1,72(sp)
    8000274c:	e0ca                	sd	s2,64(sp)
    8000274e:	fc4e                	sd	s3,56(sp)
    80002750:	f852                	sd	s4,48(sp)
    80002752:	f456                	sd	s5,40(sp)
    80002754:	f05a                	sd	s6,32(sp)
    80002756:	ec5e                	sd	s7,24(sp)
    80002758:	e862                	sd	s8,16(sp)
    8000275a:	e466                	sd	s9,8(sp)
    8000275c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000275e:	00015797          	auipc	a5,0x15
    80002762:	95e7a783          	lw	a5,-1698(a5) # 800170bc <sb+0x4>
    80002766:	cff5                	beqz	a5,80002862 <balloc+0x11e>
    80002768:	8baa                	mv	s7,a0
    8000276a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000276c:	00015b17          	auipc	s6,0x15
    80002770:	94cb0b13          	addi	s6,s6,-1716 # 800170b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002774:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002776:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002778:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000277a:	6c89                	lui	s9,0x2
    8000277c:	a061                	j	80002804 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000277e:	97ca                	add	a5,a5,s2
    80002780:	8e55                	or	a2,a2,a3
    80002782:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00001097          	auipc	ra,0x1
    8000278c:	0b4080e7          	jalr	180(ra) # 8000383c <log_write>
        brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	e20080e7          	jalr	-480(ra) # 800025b2 <brelse>
  bp = bread(dev, bno);
    8000279a:	85a6                	mv	a1,s1
    8000279c:	855e                	mv	a0,s7
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	ce4080e7          	jalr	-796(ra) # 80002482 <bread>
    800027a6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027a8:	40000613          	li	a2,1024
    800027ac:	4581                	li	a1,0
    800027ae:	05850513          	addi	a0,a0,88
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	9c8080e7          	jalr	-1592(ra) # 8000017a <memset>
  log_write(bp);
    800027ba:	854a                	mv	a0,s2
    800027bc:	00001097          	auipc	ra,0x1
    800027c0:	080080e7          	jalr	128(ra) # 8000383c <log_write>
  brelse(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	dec080e7          	jalr	-532(ra) # 800025b2 <brelse>
}
    800027ce:	8526                	mv	a0,s1
    800027d0:	60e6                	ld	ra,88(sp)
    800027d2:	6446                	ld	s0,80(sp)
    800027d4:	64a6                	ld	s1,72(sp)
    800027d6:	6906                	ld	s2,64(sp)
    800027d8:	79e2                	ld	s3,56(sp)
    800027da:	7a42                	ld	s4,48(sp)
    800027dc:	7aa2                	ld	s5,40(sp)
    800027de:	7b02                	ld	s6,32(sp)
    800027e0:	6be2                	ld	s7,24(sp)
    800027e2:	6c42                	ld	s8,16(sp)
    800027e4:	6ca2                	ld	s9,8(sp)
    800027e6:	6125                	addi	sp,sp,96
    800027e8:	8082                	ret
    brelse(bp);
    800027ea:	854a                	mv	a0,s2
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	dc6080e7          	jalr	-570(ra) # 800025b2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027f4:	015c87bb          	addw	a5,s9,s5
    800027f8:	00078a9b          	sext.w	s5,a5
    800027fc:	004b2703          	lw	a4,4(s6)
    80002800:	06eaf163          	bgeu	s5,a4,80002862 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002804:	41fad79b          	sraiw	a5,s5,0x1f
    80002808:	0137d79b          	srliw	a5,a5,0x13
    8000280c:	015787bb          	addw	a5,a5,s5
    80002810:	40d7d79b          	sraiw	a5,a5,0xd
    80002814:	01cb2583          	lw	a1,28(s6)
    80002818:	9dbd                	addw	a1,a1,a5
    8000281a:	855e                	mv	a0,s7
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	c66080e7          	jalr	-922(ra) # 80002482 <bread>
    80002824:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002826:	004b2503          	lw	a0,4(s6)
    8000282a:	000a849b          	sext.w	s1,s5
    8000282e:	8762                	mv	a4,s8
    80002830:	faa4fde3          	bgeu	s1,a0,800027ea <balloc+0xa6>
      m = 1 << (bi % 8);
    80002834:	00777693          	andi	a3,a4,7
    80002838:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000283c:	41f7579b          	sraiw	a5,a4,0x1f
    80002840:	01d7d79b          	srliw	a5,a5,0x1d
    80002844:	9fb9                	addw	a5,a5,a4
    80002846:	4037d79b          	sraiw	a5,a5,0x3
    8000284a:	00f90633          	add	a2,s2,a5
    8000284e:	05864603          	lbu	a2,88(a2)
    80002852:	00c6f5b3          	and	a1,a3,a2
    80002856:	d585                	beqz	a1,8000277e <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002858:	2705                	addiw	a4,a4,1
    8000285a:	2485                	addiw	s1,s1,1
    8000285c:	fd471ae3          	bne	a4,s4,80002830 <balloc+0xec>
    80002860:	b769                	j	800027ea <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002862:	00006517          	auipc	a0,0x6
    80002866:	d1650513          	addi	a0,a0,-746 # 80008578 <syscalls+0x148>
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	54c080e7          	jalr	1356(ra) # 80005db6 <printf>
  return 0;
    80002872:	4481                	li	s1,0
    80002874:	bfa9                	j	800027ce <balloc+0x8a>

0000000080002876 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002876:	7179                	addi	sp,sp,-48
    80002878:	f406                	sd	ra,40(sp)
    8000287a:	f022                	sd	s0,32(sp)
    8000287c:	ec26                	sd	s1,24(sp)
    8000287e:	e84a                	sd	s2,16(sp)
    80002880:	e44e                	sd	s3,8(sp)
    80002882:	e052                	sd	s4,0(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002888:	47ad                	li	a5,11
    8000288a:	02b7e863          	bltu	a5,a1,800028ba <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000288e:	02059793          	slli	a5,a1,0x20
    80002892:	01e7d593          	srli	a1,a5,0x1e
    80002896:	00b504b3          	add	s1,a0,a1
    8000289a:	0504a903          	lw	s2,80(s1)
    8000289e:	06091e63          	bnez	s2,8000291a <bmap+0xa4>
      addr = balloc(ip->dev);
    800028a2:	4108                	lw	a0,0(a0)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	ea0080e7          	jalr	-352(ra) # 80002744 <balloc>
    800028ac:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028b0:	06090563          	beqz	s2,8000291a <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800028b4:	0524a823          	sw	s2,80(s1)
    800028b8:	a08d                	j	8000291a <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028ba:	ff45849b          	addiw	s1,a1,-12
    800028be:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028c2:	0ff00793          	li	a5,255
    800028c6:	08e7e563          	bltu	a5,a4,80002950 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028ca:	08052903          	lw	s2,128(a0)
    800028ce:	00091d63          	bnez	s2,800028e8 <bmap+0x72>
      addr = balloc(ip->dev);
    800028d2:	4108                	lw	a0,0(a0)
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	e70080e7          	jalr	-400(ra) # 80002744 <balloc>
    800028dc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028e0:	02090d63          	beqz	s2,8000291a <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028e4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028e8:	85ca                	mv	a1,s2
    800028ea:	0009a503          	lw	a0,0(s3)
    800028ee:	00000097          	auipc	ra,0x0
    800028f2:	b94080e7          	jalr	-1132(ra) # 80002482 <bread>
    800028f6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028f8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028fc:	02049713          	slli	a4,s1,0x20
    80002900:	01e75593          	srli	a1,a4,0x1e
    80002904:	00b784b3          	add	s1,a5,a1
    80002908:	0004a903          	lw	s2,0(s1)
    8000290c:	02090063          	beqz	s2,8000292c <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002910:	8552                	mv	a0,s4
    80002912:	00000097          	auipc	ra,0x0
    80002916:	ca0080e7          	jalr	-864(ra) # 800025b2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000291a:	854a                	mv	a0,s2
    8000291c:	70a2                	ld	ra,40(sp)
    8000291e:	7402                	ld	s0,32(sp)
    80002920:	64e2                	ld	s1,24(sp)
    80002922:	6942                	ld	s2,16(sp)
    80002924:	69a2                	ld	s3,8(sp)
    80002926:	6a02                	ld	s4,0(sp)
    80002928:	6145                	addi	sp,sp,48
    8000292a:	8082                	ret
      addr = balloc(ip->dev);
    8000292c:	0009a503          	lw	a0,0(s3)
    80002930:	00000097          	auipc	ra,0x0
    80002934:	e14080e7          	jalr	-492(ra) # 80002744 <balloc>
    80002938:	0005091b          	sext.w	s2,a0
      if(addr){
    8000293c:	fc090ae3          	beqz	s2,80002910 <bmap+0x9a>
        a[bn] = addr;
    80002940:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002944:	8552                	mv	a0,s4
    80002946:	00001097          	auipc	ra,0x1
    8000294a:	ef6080e7          	jalr	-266(ra) # 8000383c <log_write>
    8000294e:	b7c9                	j	80002910 <bmap+0x9a>
  panic("bmap: out of range");
    80002950:	00006517          	auipc	a0,0x6
    80002954:	c4050513          	addi	a0,a0,-960 # 80008590 <syscalls+0x160>
    80002958:	00003097          	auipc	ra,0x3
    8000295c:	414080e7          	jalr	1044(ra) # 80005d6c <panic>

0000000080002960 <iget>:
{
    80002960:	7179                	addi	sp,sp,-48
    80002962:	f406                	sd	ra,40(sp)
    80002964:	f022                	sd	s0,32(sp)
    80002966:	ec26                	sd	s1,24(sp)
    80002968:	e84a                	sd	s2,16(sp)
    8000296a:	e44e                	sd	s3,8(sp)
    8000296c:	e052                	sd	s4,0(sp)
    8000296e:	1800                	addi	s0,sp,48
    80002970:	89aa                	mv	s3,a0
    80002972:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002974:	00014517          	auipc	a0,0x14
    80002978:	76450513          	addi	a0,a0,1892 # 800170d8 <itable>
    8000297c:	00004097          	auipc	ra,0x4
    80002980:	928080e7          	jalr	-1752(ra) # 800062a4 <acquire>
  empty = 0;
    80002984:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002986:	00014497          	auipc	s1,0x14
    8000298a:	76a48493          	addi	s1,s1,1898 # 800170f0 <itable+0x18>
    8000298e:	00016697          	auipc	a3,0x16
    80002992:	1f268693          	addi	a3,a3,498 # 80018b80 <log>
    80002996:	a039                	j	800029a4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002998:	02090b63          	beqz	s2,800029ce <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299c:	08848493          	addi	s1,s1,136
    800029a0:	02d48a63          	beq	s1,a3,800029d4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029a4:	449c                	lw	a5,8(s1)
    800029a6:	fef059e3          	blez	a5,80002998 <iget+0x38>
    800029aa:	4098                	lw	a4,0(s1)
    800029ac:	ff3716e3          	bne	a4,s3,80002998 <iget+0x38>
    800029b0:	40d8                	lw	a4,4(s1)
    800029b2:	ff4713e3          	bne	a4,s4,80002998 <iget+0x38>
      ip->ref++;
    800029b6:	2785                	addiw	a5,a5,1
    800029b8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029ba:	00014517          	auipc	a0,0x14
    800029be:	71e50513          	addi	a0,a0,1822 # 800170d8 <itable>
    800029c2:	00004097          	auipc	ra,0x4
    800029c6:	996080e7          	jalr	-1642(ra) # 80006358 <release>
      return ip;
    800029ca:	8926                	mv	s2,s1
    800029cc:	a03d                	j	800029fa <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ce:	f7f9                	bnez	a5,8000299c <iget+0x3c>
    800029d0:	8926                	mv	s2,s1
    800029d2:	b7e9                	j	8000299c <iget+0x3c>
  if(empty == 0)
    800029d4:	02090c63          	beqz	s2,80002a0c <iget+0xac>
  ip->dev = dev;
    800029d8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029dc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029e0:	4785                	li	a5,1
    800029e2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029e6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029ea:	00014517          	auipc	a0,0x14
    800029ee:	6ee50513          	addi	a0,a0,1774 # 800170d8 <itable>
    800029f2:	00004097          	auipc	ra,0x4
    800029f6:	966080e7          	jalr	-1690(ra) # 80006358 <release>
}
    800029fa:	854a                	mv	a0,s2
    800029fc:	70a2                	ld	ra,40(sp)
    800029fe:	7402                	ld	s0,32(sp)
    80002a00:	64e2                	ld	s1,24(sp)
    80002a02:	6942                	ld	s2,16(sp)
    80002a04:	69a2                	ld	s3,8(sp)
    80002a06:	6a02                	ld	s4,0(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret
    panic("iget: no inodes");
    80002a0c:	00006517          	auipc	a0,0x6
    80002a10:	b9c50513          	addi	a0,a0,-1124 # 800085a8 <syscalls+0x178>
    80002a14:	00003097          	auipc	ra,0x3
    80002a18:	358080e7          	jalr	856(ra) # 80005d6c <panic>

0000000080002a1c <fsinit>:
fsinit(int dev) {
    80002a1c:	7179                	addi	sp,sp,-48
    80002a1e:	f406                	sd	ra,40(sp)
    80002a20:	f022                	sd	s0,32(sp)
    80002a22:	ec26                	sd	s1,24(sp)
    80002a24:	e84a                	sd	s2,16(sp)
    80002a26:	e44e                	sd	s3,8(sp)
    80002a28:	1800                	addi	s0,sp,48
    80002a2a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a2c:	4585                	li	a1,1
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	a54080e7          	jalr	-1452(ra) # 80002482 <bread>
    80002a36:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a38:	00014997          	auipc	s3,0x14
    80002a3c:	68098993          	addi	s3,s3,1664 # 800170b8 <sb>
    80002a40:	02000613          	li	a2,32
    80002a44:	05850593          	addi	a1,a0,88
    80002a48:	854e                	mv	a0,s3
    80002a4a:	ffffd097          	auipc	ra,0xffffd
    80002a4e:	78c080e7          	jalr	1932(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a52:	8526                	mv	a0,s1
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	b5e080e7          	jalr	-1186(ra) # 800025b2 <brelse>
  if(sb.magic != FSMAGIC)
    80002a5c:	0009a703          	lw	a4,0(s3)
    80002a60:	102037b7          	lui	a5,0x10203
    80002a64:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a68:	02f71263          	bne	a4,a5,80002a8c <fsinit+0x70>
  initlog(dev, &sb);
    80002a6c:	00014597          	auipc	a1,0x14
    80002a70:	64c58593          	addi	a1,a1,1612 # 800170b8 <sb>
    80002a74:	854a                	mv	a0,s2
    80002a76:	00001097          	auipc	ra,0x1
    80002a7a:	b4a080e7          	jalr	-1206(ra) # 800035c0 <initlog>
}
    80002a7e:	70a2                	ld	ra,40(sp)
    80002a80:	7402                	ld	s0,32(sp)
    80002a82:	64e2                	ld	s1,24(sp)
    80002a84:	6942                	ld	s2,16(sp)
    80002a86:	69a2                	ld	s3,8(sp)
    80002a88:	6145                	addi	sp,sp,48
    80002a8a:	8082                	ret
    panic("invalid file system");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	b2c50513          	addi	a0,a0,-1236 # 800085b8 <syscalls+0x188>
    80002a94:	00003097          	auipc	ra,0x3
    80002a98:	2d8080e7          	jalr	728(ra) # 80005d6c <panic>

0000000080002a9c <iinit>:
{
    80002a9c:	7179                	addi	sp,sp,-48
    80002a9e:	f406                	sd	ra,40(sp)
    80002aa0:	f022                	sd	s0,32(sp)
    80002aa2:	ec26                	sd	s1,24(sp)
    80002aa4:	e84a                	sd	s2,16(sp)
    80002aa6:	e44e                	sd	s3,8(sp)
    80002aa8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aaa:	00006597          	auipc	a1,0x6
    80002aae:	b2658593          	addi	a1,a1,-1242 # 800085d0 <syscalls+0x1a0>
    80002ab2:	00014517          	auipc	a0,0x14
    80002ab6:	62650513          	addi	a0,a0,1574 # 800170d8 <itable>
    80002aba:	00003097          	auipc	ra,0x3
    80002abe:	75a080e7          	jalr	1882(ra) # 80006214 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ac2:	00014497          	auipc	s1,0x14
    80002ac6:	63e48493          	addi	s1,s1,1598 # 80017100 <itable+0x28>
    80002aca:	00016997          	auipc	s3,0x16
    80002ace:	0c698993          	addi	s3,s3,198 # 80018b90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ad2:	00006917          	auipc	s2,0x6
    80002ad6:	b0690913          	addi	s2,s2,-1274 # 800085d8 <syscalls+0x1a8>
    80002ada:	85ca                	mv	a1,s2
    80002adc:	8526                	mv	a0,s1
    80002ade:	00001097          	auipc	ra,0x1
    80002ae2:	e42080e7          	jalr	-446(ra) # 80003920 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ae6:	08848493          	addi	s1,s1,136
    80002aea:	ff3498e3          	bne	s1,s3,80002ada <iinit+0x3e>
}
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6145                	addi	sp,sp,48
    80002afa:	8082                	ret

0000000080002afc <ialloc>:
{
    80002afc:	715d                	addi	sp,sp,-80
    80002afe:	e486                	sd	ra,72(sp)
    80002b00:	e0a2                	sd	s0,64(sp)
    80002b02:	fc26                	sd	s1,56(sp)
    80002b04:	f84a                	sd	s2,48(sp)
    80002b06:	f44e                	sd	s3,40(sp)
    80002b08:	f052                	sd	s4,32(sp)
    80002b0a:	ec56                	sd	s5,24(sp)
    80002b0c:	e85a                	sd	s6,16(sp)
    80002b0e:	e45e                	sd	s7,8(sp)
    80002b10:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b12:	00014717          	auipc	a4,0x14
    80002b16:	5b272703          	lw	a4,1458(a4) # 800170c4 <sb+0xc>
    80002b1a:	4785                	li	a5,1
    80002b1c:	04e7fa63          	bgeu	a5,a4,80002b70 <ialloc+0x74>
    80002b20:	8aaa                	mv	s5,a0
    80002b22:	8bae                	mv	s7,a1
    80002b24:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b26:	00014a17          	auipc	s4,0x14
    80002b2a:	592a0a13          	addi	s4,s4,1426 # 800170b8 <sb>
    80002b2e:	00048b1b          	sext.w	s6,s1
    80002b32:	0044d593          	srli	a1,s1,0x4
    80002b36:	018a2783          	lw	a5,24(s4)
    80002b3a:	9dbd                	addw	a1,a1,a5
    80002b3c:	8556                	mv	a0,s5
    80002b3e:	00000097          	auipc	ra,0x0
    80002b42:	944080e7          	jalr	-1724(ra) # 80002482 <bread>
    80002b46:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b48:	05850993          	addi	s3,a0,88
    80002b4c:	00f4f793          	andi	a5,s1,15
    80002b50:	079a                	slli	a5,a5,0x6
    80002b52:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b54:	00099783          	lh	a5,0(s3)
    80002b58:	c3a1                	beqz	a5,80002b98 <ialloc+0x9c>
    brelse(bp);
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	a58080e7          	jalr	-1448(ra) # 800025b2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b62:	0485                	addi	s1,s1,1
    80002b64:	00ca2703          	lw	a4,12(s4)
    80002b68:	0004879b          	sext.w	a5,s1
    80002b6c:	fce7e1e3          	bltu	a5,a4,80002b2e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b70:	00006517          	auipc	a0,0x6
    80002b74:	a7050513          	addi	a0,a0,-1424 # 800085e0 <syscalls+0x1b0>
    80002b78:	00003097          	auipc	ra,0x3
    80002b7c:	23e080e7          	jalr	574(ra) # 80005db6 <printf>
  return 0;
    80002b80:	4501                	li	a0,0
}
    80002b82:	60a6                	ld	ra,72(sp)
    80002b84:	6406                	ld	s0,64(sp)
    80002b86:	74e2                	ld	s1,56(sp)
    80002b88:	7942                	ld	s2,48(sp)
    80002b8a:	79a2                	ld	s3,40(sp)
    80002b8c:	7a02                	ld	s4,32(sp)
    80002b8e:	6ae2                	ld	s5,24(sp)
    80002b90:	6b42                	ld	s6,16(sp)
    80002b92:	6ba2                	ld	s7,8(sp)
    80002b94:	6161                	addi	sp,sp,80
    80002b96:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b98:	04000613          	li	a2,64
    80002b9c:	4581                	li	a1,0
    80002b9e:	854e                	mv	a0,s3
    80002ba0:	ffffd097          	auipc	ra,0xffffd
    80002ba4:	5da080e7          	jalr	1498(ra) # 8000017a <memset>
      dip->type = type;
    80002ba8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bac:	854a                	mv	a0,s2
    80002bae:	00001097          	auipc	ra,0x1
    80002bb2:	c8e080e7          	jalr	-882(ra) # 8000383c <log_write>
      brelse(bp);
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	9fa080e7          	jalr	-1542(ra) # 800025b2 <brelse>
      return iget(dev, inum);
    80002bc0:	85da                	mv	a1,s6
    80002bc2:	8556                	mv	a0,s5
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	d9c080e7          	jalr	-612(ra) # 80002960 <iget>
    80002bcc:	bf5d                	j	80002b82 <ialloc+0x86>

0000000080002bce <iupdate>:
{
    80002bce:	1101                	addi	sp,sp,-32
    80002bd0:	ec06                	sd	ra,24(sp)
    80002bd2:	e822                	sd	s0,16(sp)
    80002bd4:	e426                	sd	s1,8(sp)
    80002bd6:	e04a                	sd	s2,0(sp)
    80002bd8:	1000                	addi	s0,sp,32
    80002bda:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bdc:	415c                	lw	a5,4(a0)
    80002bde:	0047d79b          	srliw	a5,a5,0x4
    80002be2:	00014597          	auipc	a1,0x14
    80002be6:	4ee5a583          	lw	a1,1262(a1) # 800170d0 <sb+0x18>
    80002bea:	9dbd                	addw	a1,a1,a5
    80002bec:	4108                	lw	a0,0(a0)
    80002bee:	00000097          	auipc	ra,0x0
    80002bf2:	894080e7          	jalr	-1900(ra) # 80002482 <bread>
    80002bf6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf8:	05850793          	addi	a5,a0,88
    80002bfc:	40d8                	lw	a4,4(s1)
    80002bfe:	8b3d                	andi	a4,a4,15
    80002c00:	071a                	slli	a4,a4,0x6
    80002c02:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c04:	04449703          	lh	a4,68(s1)
    80002c08:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c0c:	04649703          	lh	a4,70(s1)
    80002c10:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c14:	04849703          	lh	a4,72(s1)
    80002c18:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c1c:	04a49703          	lh	a4,74(s1)
    80002c20:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c24:	44f8                	lw	a4,76(s1)
    80002c26:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c28:	03400613          	li	a2,52
    80002c2c:	05048593          	addi	a1,s1,80
    80002c30:	00c78513          	addi	a0,a5,12
    80002c34:	ffffd097          	auipc	ra,0xffffd
    80002c38:	5a2080e7          	jalr	1442(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c3c:	854a                	mv	a0,s2
    80002c3e:	00001097          	auipc	ra,0x1
    80002c42:	bfe080e7          	jalr	-1026(ra) # 8000383c <log_write>
  brelse(bp);
    80002c46:	854a                	mv	a0,s2
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	96a080e7          	jalr	-1686(ra) # 800025b2 <brelse>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6902                	ld	s2,0(sp)
    80002c58:	6105                	addi	sp,sp,32
    80002c5a:	8082                	ret

0000000080002c5c <idup>:
{
    80002c5c:	1101                	addi	sp,sp,-32
    80002c5e:	ec06                	sd	ra,24(sp)
    80002c60:	e822                	sd	s0,16(sp)
    80002c62:	e426                	sd	s1,8(sp)
    80002c64:	1000                	addi	s0,sp,32
    80002c66:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c68:	00014517          	auipc	a0,0x14
    80002c6c:	47050513          	addi	a0,a0,1136 # 800170d8 <itable>
    80002c70:	00003097          	auipc	ra,0x3
    80002c74:	634080e7          	jalr	1588(ra) # 800062a4 <acquire>
  ip->ref++;
    80002c78:	449c                	lw	a5,8(s1)
    80002c7a:	2785                	addiw	a5,a5,1
    80002c7c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c7e:	00014517          	auipc	a0,0x14
    80002c82:	45a50513          	addi	a0,a0,1114 # 800170d8 <itable>
    80002c86:	00003097          	auipc	ra,0x3
    80002c8a:	6d2080e7          	jalr	1746(ra) # 80006358 <release>
}
    80002c8e:	8526                	mv	a0,s1
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6105                	addi	sp,sp,32
    80002c98:	8082                	ret

0000000080002c9a <ilock>:
{
    80002c9a:	1101                	addi	sp,sp,-32
    80002c9c:	ec06                	sd	ra,24(sp)
    80002c9e:	e822                	sd	s0,16(sp)
    80002ca0:	e426                	sd	s1,8(sp)
    80002ca2:	e04a                	sd	s2,0(sp)
    80002ca4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ca6:	c115                	beqz	a0,80002cca <ilock+0x30>
    80002ca8:	84aa                	mv	s1,a0
    80002caa:	451c                	lw	a5,8(a0)
    80002cac:	00f05f63          	blez	a5,80002cca <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cb0:	0541                	addi	a0,a0,16
    80002cb2:	00001097          	auipc	ra,0x1
    80002cb6:	ca8080e7          	jalr	-856(ra) # 8000395a <acquiresleep>
  if(ip->valid == 0){
    80002cba:	40bc                	lw	a5,64(s1)
    80002cbc:	cf99                	beqz	a5,80002cda <ilock+0x40>
}
    80002cbe:	60e2                	ld	ra,24(sp)
    80002cc0:	6442                	ld	s0,16(sp)
    80002cc2:	64a2                	ld	s1,8(sp)
    80002cc4:	6902                	ld	s2,0(sp)
    80002cc6:	6105                	addi	sp,sp,32
    80002cc8:	8082                	ret
    panic("ilock");
    80002cca:	00006517          	auipc	a0,0x6
    80002cce:	92e50513          	addi	a0,a0,-1746 # 800085f8 <syscalls+0x1c8>
    80002cd2:	00003097          	auipc	ra,0x3
    80002cd6:	09a080e7          	jalr	154(ra) # 80005d6c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cda:	40dc                	lw	a5,4(s1)
    80002cdc:	0047d79b          	srliw	a5,a5,0x4
    80002ce0:	00014597          	auipc	a1,0x14
    80002ce4:	3f05a583          	lw	a1,1008(a1) # 800170d0 <sb+0x18>
    80002ce8:	9dbd                	addw	a1,a1,a5
    80002cea:	4088                	lw	a0,0(s1)
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	796080e7          	jalr	1942(ra) # 80002482 <bread>
    80002cf4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cf6:	05850593          	addi	a1,a0,88
    80002cfa:	40dc                	lw	a5,4(s1)
    80002cfc:	8bbd                	andi	a5,a5,15
    80002cfe:	079a                	slli	a5,a5,0x6
    80002d00:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d02:	00059783          	lh	a5,0(a1)
    80002d06:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d0a:	00259783          	lh	a5,2(a1)
    80002d0e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d12:	00459783          	lh	a5,4(a1)
    80002d16:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d1a:	00659783          	lh	a5,6(a1)
    80002d1e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d22:	459c                	lw	a5,8(a1)
    80002d24:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d26:	03400613          	li	a2,52
    80002d2a:	05b1                	addi	a1,a1,12
    80002d2c:	05048513          	addi	a0,s1,80
    80002d30:	ffffd097          	auipc	ra,0xffffd
    80002d34:	4a6080e7          	jalr	1190(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d38:	854a                	mv	a0,s2
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	878080e7          	jalr	-1928(ra) # 800025b2 <brelse>
    ip->valid = 1;
    80002d42:	4785                	li	a5,1
    80002d44:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d46:	04449783          	lh	a5,68(s1)
    80002d4a:	fbb5                	bnez	a5,80002cbe <ilock+0x24>
      panic("ilock: no type");
    80002d4c:	00006517          	auipc	a0,0x6
    80002d50:	8b450513          	addi	a0,a0,-1868 # 80008600 <syscalls+0x1d0>
    80002d54:	00003097          	auipc	ra,0x3
    80002d58:	018080e7          	jalr	24(ra) # 80005d6c <panic>

0000000080002d5c <iunlock>:
{
    80002d5c:	1101                	addi	sp,sp,-32
    80002d5e:	ec06                	sd	ra,24(sp)
    80002d60:	e822                	sd	s0,16(sp)
    80002d62:	e426                	sd	s1,8(sp)
    80002d64:	e04a                	sd	s2,0(sp)
    80002d66:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d68:	c905                	beqz	a0,80002d98 <iunlock+0x3c>
    80002d6a:	84aa                	mv	s1,a0
    80002d6c:	01050913          	addi	s2,a0,16
    80002d70:	854a                	mv	a0,s2
    80002d72:	00001097          	auipc	ra,0x1
    80002d76:	c82080e7          	jalr	-894(ra) # 800039f4 <holdingsleep>
    80002d7a:	cd19                	beqz	a0,80002d98 <iunlock+0x3c>
    80002d7c:	449c                	lw	a5,8(s1)
    80002d7e:	00f05d63          	blez	a5,80002d98 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d82:	854a                	mv	a0,s2
    80002d84:	00001097          	auipc	ra,0x1
    80002d88:	c2c080e7          	jalr	-980(ra) # 800039b0 <releasesleep>
}
    80002d8c:	60e2                	ld	ra,24(sp)
    80002d8e:	6442                	ld	s0,16(sp)
    80002d90:	64a2                	ld	s1,8(sp)
    80002d92:	6902                	ld	s2,0(sp)
    80002d94:	6105                	addi	sp,sp,32
    80002d96:	8082                	ret
    panic("iunlock");
    80002d98:	00006517          	auipc	a0,0x6
    80002d9c:	87850513          	addi	a0,a0,-1928 # 80008610 <syscalls+0x1e0>
    80002da0:	00003097          	auipc	ra,0x3
    80002da4:	fcc080e7          	jalr	-52(ra) # 80005d6c <panic>

0000000080002da8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002da8:	7179                	addi	sp,sp,-48
    80002daa:	f406                	sd	ra,40(sp)
    80002dac:	f022                	sd	s0,32(sp)
    80002dae:	ec26                	sd	s1,24(sp)
    80002db0:	e84a                	sd	s2,16(sp)
    80002db2:	e44e                	sd	s3,8(sp)
    80002db4:	e052                	sd	s4,0(sp)
    80002db6:	1800                	addi	s0,sp,48
    80002db8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dba:	05050493          	addi	s1,a0,80
    80002dbe:	08050913          	addi	s2,a0,128
    80002dc2:	a021                	j	80002dca <itrunc+0x22>
    80002dc4:	0491                	addi	s1,s1,4
    80002dc6:	01248d63          	beq	s1,s2,80002de0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dca:	408c                	lw	a1,0(s1)
    80002dcc:	dde5                	beqz	a1,80002dc4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dce:	0009a503          	lw	a0,0(s3)
    80002dd2:	00000097          	auipc	ra,0x0
    80002dd6:	8f6080e7          	jalr	-1802(ra) # 800026c8 <bfree>
      ip->addrs[i] = 0;
    80002dda:	0004a023          	sw	zero,0(s1)
    80002dde:	b7dd                	j	80002dc4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002de0:	0809a583          	lw	a1,128(s3)
    80002de4:	e185                	bnez	a1,80002e04 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002de6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dea:	854e                	mv	a0,s3
    80002dec:	00000097          	auipc	ra,0x0
    80002df0:	de2080e7          	jalr	-542(ra) # 80002bce <iupdate>
}
    80002df4:	70a2                	ld	ra,40(sp)
    80002df6:	7402                	ld	s0,32(sp)
    80002df8:	64e2                	ld	s1,24(sp)
    80002dfa:	6942                	ld	s2,16(sp)
    80002dfc:	69a2                	ld	s3,8(sp)
    80002dfe:	6a02                	ld	s4,0(sp)
    80002e00:	6145                	addi	sp,sp,48
    80002e02:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e04:	0009a503          	lw	a0,0(s3)
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	67a080e7          	jalr	1658(ra) # 80002482 <bread>
    80002e10:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e12:	05850493          	addi	s1,a0,88
    80002e16:	45850913          	addi	s2,a0,1112
    80002e1a:	a021                	j	80002e22 <itrunc+0x7a>
    80002e1c:	0491                	addi	s1,s1,4
    80002e1e:	01248b63          	beq	s1,s2,80002e34 <itrunc+0x8c>
      if(a[j])
    80002e22:	408c                	lw	a1,0(s1)
    80002e24:	dde5                	beqz	a1,80002e1c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e26:	0009a503          	lw	a0,0(s3)
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	89e080e7          	jalr	-1890(ra) # 800026c8 <bfree>
    80002e32:	b7ed                	j	80002e1c <itrunc+0x74>
    brelse(bp);
    80002e34:	8552                	mv	a0,s4
    80002e36:	fffff097          	auipc	ra,0xfffff
    80002e3a:	77c080e7          	jalr	1916(ra) # 800025b2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e3e:	0809a583          	lw	a1,128(s3)
    80002e42:	0009a503          	lw	a0,0(s3)
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	882080e7          	jalr	-1918(ra) # 800026c8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e4e:	0809a023          	sw	zero,128(s3)
    80002e52:	bf51                	j	80002de6 <itrunc+0x3e>

0000000080002e54 <iput>:
{
    80002e54:	1101                	addi	sp,sp,-32
    80002e56:	ec06                	sd	ra,24(sp)
    80002e58:	e822                	sd	s0,16(sp)
    80002e5a:	e426                	sd	s1,8(sp)
    80002e5c:	e04a                	sd	s2,0(sp)
    80002e5e:	1000                	addi	s0,sp,32
    80002e60:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e62:	00014517          	auipc	a0,0x14
    80002e66:	27650513          	addi	a0,a0,630 # 800170d8 <itable>
    80002e6a:	00003097          	auipc	ra,0x3
    80002e6e:	43a080e7          	jalr	1082(ra) # 800062a4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e72:	4498                	lw	a4,8(s1)
    80002e74:	4785                	li	a5,1
    80002e76:	02f70363          	beq	a4,a5,80002e9c <iput+0x48>
  ip->ref--;
    80002e7a:	449c                	lw	a5,8(s1)
    80002e7c:	37fd                	addiw	a5,a5,-1
    80002e7e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e80:	00014517          	auipc	a0,0x14
    80002e84:	25850513          	addi	a0,a0,600 # 800170d8 <itable>
    80002e88:	00003097          	auipc	ra,0x3
    80002e8c:	4d0080e7          	jalr	1232(ra) # 80006358 <release>
}
    80002e90:	60e2                	ld	ra,24(sp)
    80002e92:	6442                	ld	s0,16(sp)
    80002e94:	64a2                	ld	s1,8(sp)
    80002e96:	6902                	ld	s2,0(sp)
    80002e98:	6105                	addi	sp,sp,32
    80002e9a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e9c:	40bc                	lw	a5,64(s1)
    80002e9e:	dff1                	beqz	a5,80002e7a <iput+0x26>
    80002ea0:	04a49783          	lh	a5,74(s1)
    80002ea4:	fbf9                	bnez	a5,80002e7a <iput+0x26>
    acquiresleep(&ip->lock);
    80002ea6:	01048913          	addi	s2,s1,16
    80002eaa:	854a                	mv	a0,s2
    80002eac:	00001097          	auipc	ra,0x1
    80002eb0:	aae080e7          	jalr	-1362(ra) # 8000395a <acquiresleep>
    release(&itable.lock);
    80002eb4:	00014517          	auipc	a0,0x14
    80002eb8:	22450513          	addi	a0,a0,548 # 800170d8 <itable>
    80002ebc:	00003097          	auipc	ra,0x3
    80002ec0:	49c080e7          	jalr	1180(ra) # 80006358 <release>
    itrunc(ip);
    80002ec4:	8526                	mv	a0,s1
    80002ec6:	00000097          	auipc	ra,0x0
    80002eca:	ee2080e7          	jalr	-286(ra) # 80002da8 <itrunc>
    ip->type = 0;
    80002ece:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	00000097          	auipc	ra,0x0
    80002ed8:	cfa080e7          	jalr	-774(ra) # 80002bce <iupdate>
    ip->valid = 0;
    80002edc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ee0:	854a                	mv	a0,s2
    80002ee2:	00001097          	auipc	ra,0x1
    80002ee6:	ace080e7          	jalr	-1330(ra) # 800039b0 <releasesleep>
    acquire(&itable.lock);
    80002eea:	00014517          	auipc	a0,0x14
    80002eee:	1ee50513          	addi	a0,a0,494 # 800170d8 <itable>
    80002ef2:	00003097          	auipc	ra,0x3
    80002ef6:	3b2080e7          	jalr	946(ra) # 800062a4 <acquire>
    80002efa:	b741                	j	80002e7a <iput+0x26>

0000000080002efc <iunlockput>:
{
    80002efc:	1101                	addi	sp,sp,-32
    80002efe:	ec06                	sd	ra,24(sp)
    80002f00:	e822                	sd	s0,16(sp)
    80002f02:	e426                	sd	s1,8(sp)
    80002f04:	1000                	addi	s0,sp,32
    80002f06:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	e54080e7          	jalr	-428(ra) # 80002d5c <iunlock>
  iput(ip);
    80002f10:	8526                	mv	a0,s1
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	f42080e7          	jalr	-190(ra) # 80002e54 <iput>
}
    80002f1a:	60e2                	ld	ra,24(sp)
    80002f1c:	6442                	ld	s0,16(sp)
    80002f1e:	64a2                	ld	s1,8(sp)
    80002f20:	6105                	addi	sp,sp,32
    80002f22:	8082                	ret

0000000080002f24 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f24:	1141                	addi	sp,sp,-16
    80002f26:	e422                	sd	s0,8(sp)
    80002f28:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f2a:	411c                	lw	a5,0(a0)
    80002f2c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f2e:	415c                	lw	a5,4(a0)
    80002f30:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f32:	04451783          	lh	a5,68(a0)
    80002f36:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f3a:	04a51783          	lh	a5,74(a0)
    80002f3e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f42:	04c56783          	lwu	a5,76(a0)
    80002f46:	e99c                	sd	a5,16(a1)
}
    80002f48:	6422                	ld	s0,8(sp)
    80002f4a:	0141                	addi	sp,sp,16
    80002f4c:	8082                	ret

0000000080002f4e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4e:	457c                	lw	a5,76(a0)
    80002f50:	0ed7e963          	bltu	a5,a3,80003042 <readi+0xf4>
{
    80002f54:	7159                	addi	sp,sp,-112
    80002f56:	f486                	sd	ra,104(sp)
    80002f58:	f0a2                	sd	s0,96(sp)
    80002f5a:	eca6                	sd	s1,88(sp)
    80002f5c:	e8ca                	sd	s2,80(sp)
    80002f5e:	e4ce                	sd	s3,72(sp)
    80002f60:	e0d2                	sd	s4,64(sp)
    80002f62:	fc56                	sd	s5,56(sp)
    80002f64:	f85a                	sd	s6,48(sp)
    80002f66:	f45e                	sd	s7,40(sp)
    80002f68:	f062                	sd	s8,32(sp)
    80002f6a:	ec66                	sd	s9,24(sp)
    80002f6c:	e86a                	sd	s10,16(sp)
    80002f6e:	e46e                	sd	s11,8(sp)
    80002f70:	1880                	addi	s0,sp,112
    80002f72:	8b2a                	mv	s6,a0
    80002f74:	8bae                	mv	s7,a1
    80002f76:	8a32                	mv	s4,a2
    80002f78:	84b6                	mv	s1,a3
    80002f7a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f7c:	9f35                	addw	a4,a4,a3
    return 0;
    80002f7e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f80:	0ad76063          	bltu	a4,a3,80003020 <readi+0xd2>
  if(off + n > ip->size)
    80002f84:	00e7f463          	bgeu	a5,a4,80002f8c <readi+0x3e>
    n = ip->size - off;
    80002f88:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f8c:	0a0a8963          	beqz	s5,8000303e <readi+0xf0>
    80002f90:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f92:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f96:	5c7d                	li	s8,-1
    80002f98:	a82d                	j	80002fd2 <readi+0x84>
    80002f9a:	020d1d93          	slli	s11,s10,0x20
    80002f9e:	020ddd93          	srli	s11,s11,0x20
    80002fa2:	05890613          	addi	a2,s2,88
    80002fa6:	86ee                	mv	a3,s11
    80002fa8:	963a                	add	a2,a2,a4
    80002faa:	85d2                	mv	a1,s4
    80002fac:	855e                	mv	a0,s7
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	b0e080e7          	jalr	-1266(ra) # 80001abc <either_copyout>
    80002fb6:	05850d63          	beq	a0,s8,80003010 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fba:	854a                	mv	a0,s2
    80002fbc:	fffff097          	auipc	ra,0xfffff
    80002fc0:	5f6080e7          	jalr	1526(ra) # 800025b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc4:	013d09bb          	addw	s3,s10,s3
    80002fc8:	009d04bb          	addw	s1,s10,s1
    80002fcc:	9a6e                	add	s4,s4,s11
    80002fce:	0559f763          	bgeu	s3,s5,8000301c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fd2:	00a4d59b          	srliw	a1,s1,0xa
    80002fd6:	855a                	mv	a0,s6
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	89e080e7          	jalr	-1890(ra) # 80002876 <bmap>
    80002fe0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fe4:	cd85                	beqz	a1,8000301c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fe6:	000b2503          	lw	a0,0(s6)
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	498080e7          	jalr	1176(ra) # 80002482 <bread>
    80002ff2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff4:	3ff4f713          	andi	a4,s1,1023
    80002ff8:	40ec87bb          	subw	a5,s9,a4
    80002ffc:	413a86bb          	subw	a3,s5,s3
    80003000:	8d3e                	mv	s10,a5
    80003002:	2781                	sext.w	a5,a5
    80003004:	0006861b          	sext.w	a2,a3
    80003008:	f8f679e3          	bgeu	a2,a5,80002f9a <readi+0x4c>
    8000300c:	8d36                	mv	s10,a3
    8000300e:	b771                	j	80002f9a <readi+0x4c>
      brelse(bp);
    80003010:	854a                	mv	a0,s2
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	5a0080e7          	jalr	1440(ra) # 800025b2 <brelse>
      tot = -1;
    8000301a:	59fd                	li	s3,-1
  }
  return tot;
    8000301c:	0009851b          	sext.w	a0,s3
}
    80003020:	70a6                	ld	ra,104(sp)
    80003022:	7406                	ld	s0,96(sp)
    80003024:	64e6                	ld	s1,88(sp)
    80003026:	6946                	ld	s2,80(sp)
    80003028:	69a6                	ld	s3,72(sp)
    8000302a:	6a06                	ld	s4,64(sp)
    8000302c:	7ae2                	ld	s5,56(sp)
    8000302e:	7b42                	ld	s6,48(sp)
    80003030:	7ba2                	ld	s7,40(sp)
    80003032:	7c02                	ld	s8,32(sp)
    80003034:	6ce2                	ld	s9,24(sp)
    80003036:	6d42                	ld	s10,16(sp)
    80003038:	6da2                	ld	s11,8(sp)
    8000303a:	6165                	addi	sp,sp,112
    8000303c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000303e:	89d6                	mv	s3,s5
    80003040:	bff1                	j	8000301c <readi+0xce>
    return 0;
    80003042:	4501                	li	a0,0
}
    80003044:	8082                	ret

0000000080003046 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003046:	457c                	lw	a5,76(a0)
    80003048:	10d7e863          	bltu	a5,a3,80003158 <writei+0x112>
{
    8000304c:	7159                	addi	sp,sp,-112
    8000304e:	f486                	sd	ra,104(sp)
    80003050:	f0a2                	sd	s0,96(sp)
    80003052:	eca6                	sd	s1,88(sp)
    80003054:	e8ca                	sd	s2,80(sp)
    80003056:	e4ce                	sd	s3,72(sp)
    80003058:	e0d2                	sd	s4,64(sp)
    8000305a:	fc56                	sd	s5,56(sp)
    8000305c:	f85a                	sd	s6,48(sp)
    8000305e:	f45e                	sd	s7,40(sp)
    80003060:	f062                	sd	s8,32(sp)
    80003062:	ec66                	sd	s9,24(sp)
    80003064:	e86a                	sd	s10,16(sp)
    80003066:	e46e                	sd	s11,8(sp)
    80003068:	1880                	addi	s0,sp,112
    8000306a:	8aaa                	mv	s5,a0
    8000306c:	8bae                	mv	s7,a1
    8000306e:	8a32                	mv	s4,a2
    80003070:	8936                	mv	s2,a3
    80003072:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003074:	00e687bb          	addw	a5,a3,a4
    80003078:	0ed7e263          	bltu	a5,a3,8000315c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000307c:	00043737          	lui	a4,0x43
    80003080:	0ef76063          	bltu	a4,a5,80003160 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003084:	0c0b0863          	beqz	s6,80003154 <writei+0x10e>
    80003088:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000308a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000308e:	5c7d                	li	s8,-1
    80003090:	a091                	j	800030d4 <writei+0x8e>
    80003092:	020d1d93          	slli	s11,s10,0x20
    80003096:	020ddd93          	srli	s11,s11,0x20
    8000309a:	05848513          	addi	a0,s1,88
    8000309e:	86ee                	mv	a3,s11
    800030a0:	8652                	mv	a2,s4
    800030a2:	85de                	mv	a1,s7
    800030a4:	953a                	add	a0,a0,a4
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	a6c080e7          	jalr	-1428(ra) # 80001b12 <either_copyin>
    800030ae:	07850263          	beq	a0,s8,80003112 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030b2:	8526                	mv	a0,s1
    800030b4:	00000097          	auipc	ra,0x0
    800030b8:	788080e7          	jalr	1928(ra) # 8000383c <log_write>
    brelse(bp);
    800030bc:	8526                	mv	a0,s1
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	4f4080e7          	jalr	1268(ra) # 800025b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c6:	013d09bb          	addw	s3,s10,s3
    800030ca:	012d093b          	addw	s2,s10,s2
    800030ce:	9a6e                	add	s4,s4,s11
    800030d0:	0569f663          	bgeu	s3,s6,8000311c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030d4:	00a9559b          	srliw	a1,s2,0xa
    800030d8:	8556                	mv	a0,s5
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	79c080e7          	jalr	1948(ra) # 80002876 <bmap>
    800030e2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030e6:	c99d                	beqz	a1,8000311c <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030e8:	000aa503          	lw	a0,0(s5)
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	396080e7          	jalr	918(ra) # 80002482 <bread>
    800030f4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f6:	3ff97713          	andi	a4,s2,1023
    800030fa:	40ec87bb          	subw	a5,s9,a4
    800030fe:	413b06bb          	subw	a3,s6,s3
    80003102:	8d3e                	mv	s10,a5
    80003104:	2781                	sext.w	a5,a5
    80003106:	0006861b          	sext.w	a2,a3
    8000310a:	f8f674e3          	bgeu	a2,a5,80003092 <writei+0x4c>
    8000310e:	8d36                	mv	s10,a3
    80003110:	b749                	j	80003092 <writei+0x4c>
      brelse(bp);
    80003112:	8526                	mv	a0,s1
    80003114:	fffff097          	auipc	ra,0xfffff
    80003118:	49e080e7          	jalr	1182(ra) # 800025b2 <brelse>
  }

  if(off > ip->size)
    8000311c:	04caa783          	lw	a5,76(s5)
    80003120:	0127f463          	bgeu	a5,s2,80003128 <writei+0xe2>
    ip->size = off;
    80003124:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003128:	8556                	mv	a0,s5
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	aa4080e7          	jalr	-1372(ra) # 80002bce <iupdate>

  return tot;
    80003132:	0009851b          	sext.w	a0,s3
}
    80003136:	70a6                	ld	ra,104(sp)
    80003138:	7406                	ld	s0,96(sp)
    8000313a:	64e6                	ld	s1,88(sp)
    8000313c:	6946                	ld	s2,80(sp)
    8000313e:	69a6                	ld	s3,72(sp)
    80003140:	6a06                	ld	s4,64(sp)
    80003142:	7ae2                	ld	s5,56(sp)
    80003144:	7b42                	ld	s6,48(sp)
    80003146:	7ba2                	ld	s7,40(sp)
    80003148:	7c02                	ld	s8,32(sp)
    8000314a:	6ce2                	ld	s9,24(sp)
    8000314c:	6d42                	ld	s10,16(sp)
    8000314e:	6da2                	ld	s11,8(sp)
    80003150:	6165                	addi	sp,sp,112
    80003152:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003154:	89da                	mv	s3,s6
    80003156:	bfc9                	j	80003128 <writei+0xe2>
    return -1;
    80003158:	557d                	li	a0,-1
}
    8000315a:	8082                	ret
    return -1;
    8000315c:	557d                	li	a0,-1
    8000315e:	bfe1                	j	80003136 <writei+0xf0>
    return -1;
    80003160:	557d                	li	a0,-1
    80003162:	bfd1                	j	80003136 <writei+0xf0>

0000000080003164 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003164:	1141                	addi	sp,sp,-16
    80003166:	e406                	sd	ra,8(sp)
    80003168:	e022                	sd	s0,0(sp)
    8000316a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000316c:	4639                	li	a2,14
    8000316e:	ffffd097          	auipc	ra,0xffffd
    80003172:	0dc080e7          	jalr	220(ra) # 8000024a <strncmp>
}
    80003176:	60a2                	ld	ra,8(sp)
    80003178:	6402                	ld	s0,0(sp)
    8000317a:	0141                	addi	sp,sp,16
    8000317c:	8082                	ret

000000008000317e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000317e:	7139                	addi	sp,sp,-64
    80003180:	fc06                	sd	ra,56(sp)
    80003182:	f822                	sd	s0,48(sp)
    80003184:	f426                	sd	s1,40(sp)
    80003186:	f04a                	sd	s2,32(sp)
    80003188:	ec4e                	sd	s3,24(sp)
    8000318a:	e852                	sd	s4,16(sp)
    8000318c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000318e:	04451703          	lh	a4,68(a0)
    80003192:	4785                	li	a5,1
    80003194:	00f71a63          	bne	a4,a5,800031a8 <dirlookup+0x2a>
    80003198:	892a                	mv	s2,a0
    8000319a:	89ae                	mv	s3,a1
    8000319c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000319e:	457c                	lw	a5,76(a0)
    800031a0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031a2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a4:	e79d                	bnez	a5,800031d2 <dirlookup+0x54>
    800031a6:	a8a5                	j	8000321e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031a8:	00005517          	auipc	a0,0x5
    800031ac:	47050513          	addi	a0,a0,1136 # 80008618 <syscalls+0x1e8>
    800031b0:	00003097          	auipc	ra,0x3
    800031b4:	bbc080e7          	jalr	-1092(ra) # 80005d6c <panic>
      panic("dirlookup read");
    800031b8:	00005517          	auipc	a0,0x5
    800031bc:	47850513          	addi	a0,a0,1144 # 80008630 <syscalls+0x200>
    800031c0:	00003097          	auipc	ra,0x3
    800031c4:	bac080e7          	jalr	-1108(ra) # 80005d6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c8:	24c1                	addiw	s1,s1,16
    800031ca:	04c92783          	lw	a5,76(s2)
    800031ce:	04f4f763          	bgeu	s1,a5,8000321c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031d2:	4741                	li	a4,16
    800031d4:	86a6                	mv	a3,s1
    800031d6:	fc040613          	addi	a2,s0,-64
    800031da:	4581                	li	a1,0
    800031dc:	854a                	mv	a0,s2
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	d70080e7          	jalr	-656(ra) # 80002f4e <readi>
    800031e6:	47c1                	li	a5,16
    800031e8:	fcf518e3          	bne	a0,a5,800031b8 <dirlookup+0x3a>
    if(de.inum == 0)
    800031ec:	fc045783          	lhu	a5,-64(s0)
    800031f0:	dfe1                	beqz	a5,800031c8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031f2:	fc240593          	addi	a1,s0,-62
    800031f6:	854e                	mv	a0,s3
    800031f8:	00000097          	auipc	ra,0x0
    800031fc:	f6c080e7          	jalr	-148(ra) # 80003164 <namecmp>
    80003200:	f561                	bnez	a0,800031c8 <dirlookup+0x4a>
      if(poff)
    80003202:	000a0463          	beqz	s4,8000320a <dirlookup+0x8c>
        *poff = off;
    80003206:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000320a:	fc045583          	lhu	a1,-64(s0)
    8000320e:	00092503          	lw	a0,0(s2)
    80003212:	fffff097          	auipc	ra,0xfffff
    80003216:	74e080e7          	jalr	1870(ra) # 80002960 <iget>
    8000321a:	a011                	j	8000321e <dirlookup+0xa0>
  return 0;
    8000321c:	4501                	li	a0,0
}
    8000321e:	70e2                	ld	ra,56(sp)
    80003220:	7442                	ld	s0,48(sp)
    80003222:	74a2                	ld	s1,40(sp)
    80003224:	7902                	ld	s2,32(sp)
    80003226:	69e2                	ld	s3,24(sp)
    80003228:	6a42                	ld	s4,16(sp)
    8000322a:	6121                	addi	sp,sp,64
    8000322c:	8082                	ret

000000008000322e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000322e:	711d                	addi	sp,sp,-96
    80003230:	ec86                	sd	ra,88(sp)
    80003232:	e8a2                	sd	s0,80(sp)
    80003234:	e4a6                	sd	s1,72(sp)
    80003236:	e0ca                	sd	s2,64(sp)
    80003238:	fc4e                	sd	s3,56(sp)
    8000323a:	f852                	sd	s4,48(sp)
    8000323c:	f456                	sd	s5,40(sp)
    8000323e:	f05a                	sd	s6,32(sp)
    80003240:	ec5e                	sd	s7,24(sp)
    80003242:	e862                	sd	s8,16(sp)
    80003244:	e466                	sd	s9,8(sp)
    80003246:	e06a                	sd	s10,0(sp)
    80003248:	1080                	addi	s0,sp,96
    8000324a:	84aa                	mv	s1,a0
    8000324c:	8b2e                	mv	s6,a1
    8000324e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003250:	00054703          	lbu	a4,0(a0)
    80003254:	02f00793          	li	a5,47
    80003258:	02f70363          	beq	a4,a5,8000327e <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	d00080e7          	jalr	-768(ra) # 80000f5c <myproc>
    80003264:	15853503          	ld	a0,344(a0)
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	9f4080e7          	jalr	-1548(ra) # 80002c5c <idup>
    80003270:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003272:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003276:	4cb5                	li	s9,13
  len = path - s;
    80003278:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000327a:	4c05                	li	s8,1
    8000327c:	a87d                	j	8000333a <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000327e:	4585                	li	a1,1
    80003280:	4505                	li	a0,1
    80003282:	fffff097          	auipc	ra,0xfffff
    80003286:	6de080e7          	jalr	1758(ra) # 80002960 <iget>
    8000328a:	8a2a                	mv	s4,a0
    8000328c:	b7dd                	j	80003272 <namex+0x44>
      iunlockput(ip);
    8000328e:	8552                	mv	a0,s4
    80003290:	00000097          	auipc	ra,0x0
    80003294:	c6c080e7          	jalr	-916(ra) # 80002efc <iunlockput>
      return 0;
    80003298:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000329a:	8552                	mv	a0,s4
    8000329c:	60e6                	ld	ra,88(sp)
    8000329e:	6446                	ld	s0,80(sp)
    800032a0:	64a6                	ld	s1,72(sp)
    800032a2:	6906                	ld	s2,64(sp)
    800032a4:	79e2                	ld	s3,56(sp)
    800032a6:	7a42                	ld	s4,48(sp)
    800032a8:	7aa2                	ld	s5,40(sp)
    800032aa:	7b02                	ld	s6,32(sp)
    800032ac:	6be2                	ld	s7,24(sp)
    800032ae:	6c42                	ld	s8,16(sp)
    800032b0:	6ca2                	ld	s9,8(sp)
    800032b2:	6d02                	ld	s10,0(sp)
    800032b4:	6125                	addi	sp,sp,96
    800032b6:	8082                	ret
      iunlock(ip);
    800032b8:	8552                	mv	a0,s4
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	aa2080e7          	jalr	-1374(ra) # 80002d5c <iunlock>
      return ip;
    800032c2:	bfe1                	j	8000329a <namex+0x6c>
      iunlockput(ip);
    800032c4:	8552                	mv	a0,s4
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	c36080e7          	jalr	-970(ra) # 80002efc <iunlockput>
      return 0;
    800032ce:	8a4e                	mv	s4,s3
    800032d0:	b7e9                	j	8000329a <namex+0x6c>
  len = path - s;
    800032d2:	40998633          	sub	a2,s3,s1
    800032d6:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032da:	09acd863          	bge	s9,s10,8000336a <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032de:	4639                	li	a2,14
    800032e0:	85a6                	mv	a1,s1
    800032e2:	8556                	mv	a0,s5
    800032e4:	ffffd097          	auipc	ra,0xffffd
    800032e8:	ef2080e7          	jalr	-270(ra) # 800001d6 <memmove>
    800032ec:	84ce                	mv	s1,s3
  while(*path == '/')
    800032ee:	0004c783          	lbu	a5,0(s1)
    800032f2:	01279763          	bne	a5,s2,80003300 <namex+0xd2>
    path++;
    800032f6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	ff278de3          	beq	a5,s2,800032f6 <namex+0xc8>
    ilock(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	998080e7          	jalr	-1640(ra) # 80002c9a <ilock>
    if(ip->type != T_DIR){
    8000330a:	044a1783          	lh	a5,68(s4)
    8000330e:	f98790e3          	bne	a5,s8,8000328e <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003312:	000b0563          	beqz	s6,8000331c <namex+0xee>
    80003316:	0004c783          	lbu	a5,0(s1)
    8000331a:	dfd9                	beqz	a5,800032b8 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000331c:	865e                	mv	a2,s7
    8000331e:	85d6                	mv	a1,s5
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	e5c080e7          	jalr	-420(ra) # 8000317e <dirlookup>
    8000332a:	89aa                	mv	s3,a0
    8000332c:	dd41                	beqz	a0,800032c4 <namex+0x96>
    iunlockput(ip);
    8000332e:	8552                	mv	a0,s4
    80003330:	00000097          	auipc	ra,0x0
    80003334:	bcc080e7          	jalr	-1076(ra) # 80002efc <iunlockput>
    ip = next;
    80003338:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000333a:	0004c783          	lbu	a5,0(s1)
    8000333e:	01279763          	bne	a5,s2,8000334c <namex+0x11e>
    path++;
    80003342:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003344:	0004c783          	lbu	a5,0(s1)
    80003348:	ff278de3          	beq	a5,s2,80003342 <namex+0x114>
  if(*path == 0)
    8000334c:	cb9d                	beqz	a5,80003382 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	89a6                	mv	s3,s1
  len = path - s;
    80003354:	8d5e                	mv	s10,s7
    80003356:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003358:	01278963          	beq	a5,s2,8000336a <namex+0x13c>
    8000335c:	dbbd                	beqz	a5,800032d2 <namex+0xa4>
    path++;
    8000335e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003360:	0009c783          	lbu	a5,0(s3)
    80003364:	ff279ce3          	bne	a5,s2,8000335c <namex+0x12e>
    80003368:	b7ad                	j	800032d2 <namex+0xa4>
    memmove(name, s, len);
    8000336a:	2601                	sext.w	a2,a2
    8000336c:	85a6                	mv	a1,s1
    8000336e:	8556                	mv	a0,s5
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	e66080e7          	jalr	-410(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003378:	9d56                	add	s10,s10,s5
    8000337a:	000d0023          	sb	zero,0(s10)
    8000337e:	84ce                	mv	s1,s3
    80003380:	b7bd                	j	800032ee <namex+0xc0>
  if(nameiparent){
    80003382:	f00b0ce3          	beqz	s6,8000329a <namex+0x6c>
    iput(ip);
    80003386:	8552                	mv	a0,s4
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	acc080e7          	jalr	-1332(ra) # 80002e54 <iput>
    return 0;
    80003390:	4a01                	li	s4,0
    80003392:	b721                	j	8000329a <namex+0x6c>

0000000080003394 <dirlink>:
{
    80003394:	7139                	addi	sp,sp,-64
    80003396:	fc06                	sd	ra,56(sp)
    80003398:	f822                	sd	s0,48(sp)
    8000339a:	f426                	sd	s1,40(sp)
    8000339c:	f04a                	sd	s2,32(sp)
    8000339e:	ec4e                	sd	s3,24(sp)
    800033a0:	e852                	sd	s4,16(sp)
    800033a2:	0080                	addi	s0,sp,64
    800033a4:	892a                	mv	s2,a0
    800033a6:	8a2e                	mv	s4,a1
    800033a8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033aa:	4601                	li	a2,0
    800033ac:	00000097          	auipc	ra,0x0
    800033b0:	dd2080e7          	jalr	-558(ra) # 8000317e <dirlookup>
    800033b4:	e93d                	bnez	a0,8000342a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033b6:	04c92483          	lw	s1,76(s2)
    800033ba:	c49d                	beqz	s1,800033e8 <dirlink+0x54>
    800033bc:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033be:	4741                	li	a4,16
    800033c0:	86a6                	mv	a3,s1
    800033c2:	fc040613          	addi	a2,s0,-64
    800033c6:	4581                	li	a1,0
    800033c8:	854a                	mv	a0,s2
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	b84080e7          	jalr	-1148(ra) # 80002f4e <readi>
    800033d2:	47c1                	li	a5,16
    800033d4:	06f51163          	bne	a0,a5,80003436 <dirlink+0xa2>
    if(de.inum == 0)
    800033d8:	fc045783          	lhu	a5,-64(s0)
    800033dc:	c791                	beqz	a5,800033e8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033de:	24c1                	addiw	s1,s1,16
    800033e0:	04c92783          	lw	a5,76(s2)
    800033e4:	fcf4ede3          	bltu	s1,a5,800033be <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033e8:	4639                	li	a2,14
    800033ea:	85d2                	mv	a1,s4
    800033ec:	fc240513          	addi	a0,s0,-62
    800033f0:	ffffd097          	auipc	ra,0xffffd
    800033f4:	e96080e7          	jalr	-362(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033f8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033fc:	4741                	li	a4,16
    800033fe:	86a6                	mv	a3,s1
    80003400:	fc040613          	addi	a2,s0,-64
    80003404:	4581                	li	a1,0
    80003406:	854a                	mv	a0,s2
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	c3e080e7          	jalr	-962(ra) # 80003046 <writei>
    80003410:	1541                	addi	a0,a0,-16
    80003412:	00a03533          	snez	a0,a0
    80003416:	40a00533          	neg	a0,a0
}
    8000341a:	70e2                	ld	ra,56(sp)
    8000341c:	7442                	ld	s0,48(sp)
    8000341e:	74a2                	ld	s1,40(sp)
    80003420:	7902                	ld	s2,32(sp)
    80003422:	69e2                	ld	s3,24(sp)
    80003424:	6a42                	ld	s4,16(sp)
    80003426:	6121                	addi	sp,sp,64
    80003428:	8082                	ret
    iput(ip);
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	a2a080e7          	jalr	-1494(ra) # 80002e54 <iput>
    return -1;
    80003432:	557d                	li	a0,-1
    80003434:	b7dd                	j	8000341a <dirlink+0x86>
      panic("dirlink read");
    80003436:	00005517          	auipc	a0,0x5
    8000343a:	20a50513          	addi	a0,a0,522 # 80008640 <syscalls+0x210>
    8000343e:	00003097          	auipc	ra,0x3
    80003442:	92e080e7          	jalr	-1746(ra) # 80005d6c <panic>

0000000080003446 <namei>:

struct inode*
namei(char *path)
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000344e:	fe040613          	addi	a2,s0,-32
    80003452:	4581                	li	a1,0
    80003454:	00000097          	auipc	ra,0x0
    80003458:	dda080e7          	jalr	-550(ra) # 8000322e <namex>
}
    8000345c:	60e2                	ld	ra,24(sp)
    8000345e:	6442                	ld	s0,16(sp)
    80003460:	6105                	addi	sp,sp,32
    80003462:	8082                	ret

0000000080003464 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003464:	1141                	addi	sp,sp,-16
    80003466:	e406                	sd	ra,8(sp)
    80003468:	e022                	sd	s0,0(sp)
    8000346a:	0800                	addi	s0,sp,16
    8000346c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000346e:	4585                	li	a1,1
    80003470:	00000097          	auipc	ra,0x0
    80003474:	dbe080e7          	jalr	-578(ra) # 8000322e <namex>
}
    80003478:	60a2                	ld	ra,8(sp)
    8000347a:	6402                	ld	s0,0(sp)
    8000347c:	0141                	addi	sp,sp,16
    8000347e:	8082                	ret

0000000080003480 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003480:	1101                	addi	sp,sp,-32
    80003482:	ec06                	sd	ra,24(sp)
    80003484:	e822                	sd	s0,16(sp)
    80003486:	e426                	sd	s1,8(sp)
    80003488:	e04a                	sd	s2,0(sp)
    8000348a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000348c:	00015917          	auipc	s2,0x15
    80003490:	6f490913          	addi	s2,s2,1780 # 80018b80 <log>
    80003494:	01892583          	lw	a1,24(s2)
    80003498:	02892503          	lw	a0,40(s2)
    8000349c:	fffff097          	auipc	ra,0xfffff
    800034a0:	fe6080e7          	jalr	-26(ra) # 80002482 <bread>
    800034a4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034a6:	02c92683          	lw	a3,44(s2)
    800034aa:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034ac:	02d05863          	blez	a3,800034dc <write_head+0x5c>
    800034b0:	00015797          	auipc	a5,0x15
    800034b4:	70078793          	addi	a5,a5,1792 # 80018bb0 <log+0x30>
    800034b8:	05c50713          	addi	a4,a0,92
    800034bc:	36fd                	addiw	a3,a3,-1
    800034be:	02069613          	slli	a2,a3,0x20
    800034c2:	01e65693          	srli	a3,a2,0x1e
    800034c6:	00015617          	auipc	a2,0x15
    800034ca:	6ee60613          	addi	a2,a2,1774 # 80018bb4 <log+0x34>
    800034ce:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034d0:	4390                	lw	a2,0(a5)
    800034d2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d4:	0791                	addi	a5,a5,4
    800034d6:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800034d8:	fed79ce3          	bne	a5,a3,800034d0 <write_head+0x50>
  }
  bwrite(buf);
    800034dc:	8526                	mv	a0,s1
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	096080e7          	jalr	150(ra) # 80002574 <bwrite>
  brelse(buf);
    800034e6:	8526                	mv	a0,s1
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	0ca080e7          	jalr	202(ra) # 800025b2 <brelse>
}
    800034f0:	60e2                	ld	ra,24(sp)
    800034f2:	6442                	ld	s0,16(sp)
    800034f4:	64a2                	ld	s1,8(sp)
    800034f6:	6902                	ld	s2,0(sp)
    800034f8:	6105                	addi	sp,sp,32
    800034fa:	8082                	ret

00000000800034fc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034fc:	00015797          	auipc	a5,0x15
    80003500:	6b07a783          	lw	a5,1712(a5) # 80018bac <log+0x2c>
    80003504:	0af05d63          	blez	a5,800035be <install_trans+0xc2>
{
    80003508:	7139                	addi	sp,sp,-64
    8000350a:	fc06                	sd	ra,56(sp)
    8000350c:	f822                	sd	s0,48(sp)
    8000350e:	f426                	sd	s1,40(sp)
    80003510:	f04a                	sd	s2,32(sp)
    80003512:	ec4e                	sd	s3,24(sp)
    80003514:	e852                	sd	s4,16(sp)
    80003516:	e456                	sd	s5,8(sp)
    80003518:	e05a                	sd	s6,0(sp)
    8000351a:	0080                	addi	s0,sp,64
    8000351c:	8b2a                	mv	s6,a0
    8000351e:	00015a97          	auipc	s5,0x15
    80003522:	692a8a93          	addi	s5,s5,1682 # 80018bb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003526:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003528:	00015997          	auipc	s3,0x15
    8000352c:	65898993          	addi	s3,s3,1624 # 80018b80 <log>
    80003530:	a00d                	j	80003552 <install_trans+0x56>
    brelse(lbuf);
    80003532:	854a                	mv	a0,s2
    80003534:	fffff097          	auipc	ra,0xfffff
    80003538:	07e080e7          	jalr	126(ra) # 800025b2 <brelse>
    brelse(dbuf);
    8000353c:	8526                	mv	a0,s1
    8000353e:	fffff097          	auipc	ra,0xfffff
    80003542:	074080e7          	jalr	116(ra) # 800025b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003546:	2a05                	addiw	s4,s4,1
    80003548:	0a91                	addi	s5,s5,4
    8000354a:	02c9a783          	lw	a5,44(s3)
    8000354e:	04fa5e63          	bge	s4,a5,800035aa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003552:	0189a583          	lw	a1,24(s3)
    80003556:	014585bb          	addw	a1,a1,s4
    8000355a:	2585                	addiw	a1,a1,1
    8000355c:	0289a503          	lw	a0,40(s3)
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	f22080e7          	jalr	-222(ra) # 80002482 <bread>
    80003568:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000356a:	000aa583          	lw	a1,0(s5)
    8000356e:	0289a503          	lw	a0,40(s3)
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	f10080e7          	jalr	-240(ra) # 80002482 <bread>
    8000357a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000357c:	40000613          	li	a2,1024
    80003580:	05890593          	addi	a1,s2,88
    80003584:	05850513          	addi	a0,a0,88
    80003588:	ffffd097          	auipc	ra,0xffffd
    8000358c:	c4e080e7          	jalr	-946(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003590:	8526                	mv	a0,s1
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	fe2080e7          	jalr	-30(ra) # 80002574 <bwrite>
    if(recovering == 0)
    8000359a:	f80b1ce3          	bnez	s6,80003532 <install_trans+0x36>
      bunpin(dbuf);
    8000359e:	8526                	mv	a0,s1
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	0ec080e7          	jalr	236(ra) # 8000268c <bunpin>
    800035a8:	b769                	j	80003532 <install_trans+0x36>
}
    800035aa:	70e2                	ld	ra,56(sp)
    800035ac:	7442                	ld	s0,48(sp)
    800035ae:	74a2                	ld	s1,40(sp)
    800035b0:	7902                	ld	s2,32(sp)
    800035b2:	69e2                	ld	s3,24(sp)
    800035b4:	6a42                	ld	s4,16(sp)
    800035b6:	6aa2                	ld	s5,8(sp)
    800035b8:	6b02                	ld	s6,0(sp)
    800035ba:	6121                	addi	sp,sp,64
    800035bc:	8082                	ret
    800035be:	8082                	ret

00000000800035c0 <initlog>:
{
    800035c0:	7179                	addi	sp,sp,-48
    800035c2:	f406                	sd	ra,40(sp)
    800035c4:	f022                	sd	s0,32(sp)
    800035c6:	ec26                	sd	s1,24(sp)
    800035c8:	e84a                	sd	s2,16(sp)
    800035ca:	e44e                	sd	s3,8(sp)
    800035cc:	1800                	addi	s0,sp,48
    800035ce:	892a                	mv	s2,a0
    800035d0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035d2:	00015497          	auipc	s1,0x15
    800035d6:	5ae48493          	addi	s1,s1,1454 # 80018b80 <log>
    800035da:	00005597          	auipc	a1,0x5
    800035de:	07658593          	addi	a1,a1,118 # 80008650 <syscalls+0x220>
    800035e2:	8526                	mv	a0,s1
    800035e4:	00003097          	auipc	ra,0x3
    800035e8:	c30080e7          	jalr	-976(ra) # 80006214 <initlock>
  log.start = sb->logstart;
    800035ec:	0149a583          	lw	a1,20(s3)
    800035f0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035f2:	0109a783          	lw	a5,16(s3)
    800035f6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035f8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035fc:	854a                	mv	a0,s2
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	e84080e7          	jalr	-380(ra) # 80002482 <bread>
  log.lh.n = lh->n;
    80003606:	4d34                	lw	a3,88(a0)
    80003608:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000360a:	02d05663          	blez	a3,80003636 <initlog+0x76>
    8000360e:	05c50793          	addi	a5,a0,92
    80003612:	00015717          	auipc	a4,0x15
    80003616:	59e70713          	addi	a4,a4,1438 # 80018bb0 <log+0x30>
    8000361a:	36fd                	addiw	a3,a3,-1
    8000361c:	02069613          	slli	a2,a3,0x20
    80003620:	01e65693          	srli	a3,a2,0x1e
    80003624:	06050613          	addi	a2,a0,96
    80003628:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000362a:	4390                	lw	a2,0(a5)
    8000362c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000362e:	0791                	addi	a5,a5,4
    80003630:	0711                	addi	a4,a4,4
    80003632:	fed79ce3          	bne	a5,a3,8000362a <initlog+0x6a>
  brelse(buf);
    80003636:	fffff097          	auipc	ra,0xfffff
    8000363a:	f7c080e7          	jalr	-132(ra) # 800025b2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000363e:	4505                	li	a0,1
    80003640:	00000097          	auipc	ra,0x0
    80003644:	ebc080e7          	jalr	-324(ra) # 800034fc <install_trans>
  log.lh.n = 0;
    80003648:	00015797          	auipc	a5,0x15
    8000364c:	5607a223          	sw	zero,1380(a5) # 80018bac <log+0x2c>
  write_head(); // clear the log
    80003650:	00000097          	auipc	ra,0x0
    80003654:	e30080e7          	jalr	-464(ra) # 80003480 <write_head>
}
    80003658:	70a2                	ld	ra,40(sp)
    8000365a:	7402                	ld	s0,32(sp)
    8000365c:	64e2                	ld	s1,24(sp)
    8000365e:	6942                	ld	s2,16(sp)
    80003660:	69a2                	ld	s3,8(sp)
    80003662:	6145                	addi	sp,sp,48
    80003664:	8082                	ret

0000000080003666 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003666:	1101                	addi	sp,sp,-32
    80003668:	ec06                	sd	ra,24(sp)
    8000366a:	e822                	sd	s0,16(sp)
    8000366c:	e426                	sd	s1,8(sp)
    8000366e:	e04a                	sd	s2,0(sp)
    80003670:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003672:	00015517          	auipc	a0,0x15
    80003676:	50e50513          	addi	a0,a0,1294 # 80018b80 <log>
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	c2a080e7          	jalr	-982(ra) # 800062a4 <acquire>
  while(1){
    if(log.committing){
    80003682:	00015497          	auipc	s1,0x15
    80003686:	4fe48493          	addi	s1,s1,1278 # 80018b80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368a:	4979                	li	s2,30
    8000368c:	a039                	j	8000369a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000368e:	85a6                	mv	a1,s1
    80003690:	8526                	mv	a0,s1
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	022080e7          	jalr	34(ra) # 800016b4 <sleep>
    if(log.committing){
    8000369a:	50dc                	lw	a5,36(s1)
    8000369c:	fbed                	bnez	a5,8000368e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000369e:	5098                	lw	a4,32(s1)
    800036a0:	2705                	addiw	a4,a4,1
    800036a2:	0007069b          	sext.w	a3,a4
    800036a6:	0027179b          	slliw	a5,a4,0x2
    800036aa:	9fb9                	addw	a5,a5,a4
    800036ac:	0017979b          	slliw	a5,a5,0x1
    800036b0:	54d8                	lw	a4,44(s1)
    800036b2:	9fb9                	addw	a5,a5,a4
    800036b4:	00f95963          	bge	s2,a5,800036c6 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036b8:	85a6                	mv	a1,s1
    800036ba:	8526                	mv	a0,s1
    800036bc:	ffffe097          	auipc	ra,0xffffe
    800036c0:	ff8080e7          	jalr	-8(ra) # 800016b4 <sleep>
    800036c4:	bfd9                	j	8000369a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036c6:	00015517          	auipc	a0,0x15
    800036ca:	4ba50513          	addi	a0,a0,1210 # 80018b80 <log>
    800036ce:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	c88080e7          	jalr	-888(ra) # 80006358 <release>
      break;
    }
  }
}
    800036d8:	60e2                	ld	ra,24(sp)
    800036da:	6442                	ld	s0,16(sp)
    800036dc:	64a2                	ld	s1,8(sp)
    800036de:	6902                	ld	s2,0(sp)
    800036e0:	6105                	addi	sp,sp,32
    800036e2:	8082                	ret

00000000800036e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036e4:	7139                	addi	sp,sp,-64
    800036e6:	fc06                	sd	ra,56(sp)
    800036e8:	f822                	sd	s0,48(sp)
    800036ea:	f426                	sd	s1,40(sp)
    800036ec:	f04a                	sd	s2,32(sp)
    800036ee:	ec4e                	sd	s3,24(sp)
    800036f0:	e852                	sd	s4,16(sp)
    800036f2:	e456                	sd	s5,8(sp)
    800036f4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036f6:	00015497          	auipc	s1,0x15
    800036fa:	48a48493          	addi	s1,s1,1162 # 80018b80 <log>
    800036fe:	8526                	mv	a0,s1
    80003700:	00003097          	auipc	ra,0x3
    80003704:	ba4080e7          	jalr	-1116(ra) # 800062a4 <acquire>
  log.outstanding -= 1;
    80003708:	509c                	lw	a5,32(s1)
    8000370a:	37fd                	addiw	a5,a5,-1
    8000370c:	0007891b          	sext.w	s2,a5
    80003710:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003712:	50dc                	lw	a5,36(s1)
    80003714:	e7b9                	bnez	a5,80003762 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003716:	04091e63          	bnez	s2,80003772 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000371a:	00015497          	auipc	s1,0x15
    8000371e:	46648493          	addi	s1,s1,1126 # 80018b80 <log>
    80003722:	4785                	li	a5,1
    80003724:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	c30080e7          	jalr	-976(ra) # 80006358 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003730:	54dc                	lw	a5,44(s1)
    80003732:	06f04763          	bgtz	a5,800037a0 <end_op+0xbc>
    acquire(&log.lock);
    80003736:	00015497          	auipc	s1,0x15
    8000373a:	44a48493          	addi	s1,s1,1098 # 80018b80 <log>
    8000373e:	8526                	mv	a0,s1
    80003740:	00003097          	auipc	ra,0x3
    80003744:	b64080e7          	jalr	-1180(ra) # 800062a4 <acquire>
    log.committing = 0;
    80003748:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000374c:	8526                	mv	a0,s1
    8000374e:	ffffe097          	auipc	ra,0xffffe
    80003752:	fca080e7          	jalr	-54(ra) # 80001718 <wakeup>
    release(&log.lock);
    80003756:	8526                	mv	a0,s1
    80003758:	00003097          	auipc	ra,0x3
    8000375c:	c00080e7          	jalr	-1024(ra) # 80006358 <release>
}
    80003760:	a03d                	j	8000378e <end_op+0xaa>
    panic("log.committing");
    80003762:	00005517          	auipc	a0,0x5
    80003766:	ef650513          	addi	a0,a0,-266 # 80008658 <syscalls+0x228>
    8000376a:	00002097          	auipc	ra,0x2
    8000376e:	602080e7          	jalr	1538(ra) # 80005d6c <panic>
    wakeup(&log);
    80003772:	00015497          	auipc	s1,0x15
    80003776:	40e48493          	addi	s1,s1,1038 # 80018b80 <log>
    8000377a:	8526                	mv	a0,s1
    8000377c:	ffffe097          	auipc	ra,0xffffe
    80003780:	f9c080e7          	jalr	-100(ra) # 80001718 <wakeup>
  release(&log.lock);
    80003784:	8526                	mv	a0,s1
    80003786:	00003097          	auipc	ra,0x3
    8000378a:	bd2080e7          	jalr	-1070(ra) # 80006358 <release>
}
    8000378e:	70e2                	ld	ra,56(sp)
    80003790:	7442                	ld	s0,48(sp)
    80003792:	74a2                	ld	s1,40(sp)
    80003794:	7902                	ld	s2,32(sp)
    80003796:	69e2                	ld	s3,24(sp)
    80003798:	6a42                	ld	s4,16(sp)
    8000379a:	6aa2                	ld	s5,8(sp)
    8000379c:	6121                	addi	sp,sp,64
    8000379e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a0:	00015a97          	auipc	s5,0x15
    800037a4:	410a8a93          	addi	s5,s5,1040 # 80018bb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037a8:	00015a17          	auipc	s4,0x15
    800037ac:	3d8a0a13          	addi	s4,s4,984 # 80018b80 <log>
    800037b0:	018a2583          	lw	a1,24(s4)
    800037b4:	012585bb          	addw	a1,a1,s2
    800037b8:	2585                	addiw	a1,a1,1
    800037ba:	028a2503          	lw	a0,40(s4)
    800037be:	fffff097          	auipc	ra,0xfffff
    800037c2:	cc4080e7          	jalr	-828(ra) # 80002482 <bread>
    800037c6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037c8:	000aa583          	lw	a1,0(s5)
    800037cc:	028a2503          	lw	a0,40(s4)
    800037d0:	fffff097          	auipc	ra,0xfffff
    800037d4:	cb2080e7          	jalr	-846(ra) # 80002482 <bread>
    800037d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037da:	40000613          	li	a2,1024
    800037de:	05850593          	addi	a1,a0,88
    800037e2:	05848513          	addi	a0,s1,88
    800037e6:	ffffd097          	auipc	ra,0xffffd
    800037ea:	9f0080e7          	jalr	-1552(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037ee:	8526                	mv	a0,s1
    800037f0:	fffff097          	auipc	ra,0xfffff
    800037f4:	d84080e7          	jalr	-636(ra) # 80002574 <bwrite>
    brelse(from);
    800037f8:	854e                	mv	a0,s3
    800037fa:	fffff097          	auipc	ra,0xfffff
    800037fe:	db8080e7          	jalr	-584(ra) # 800025b2 <brelse>
    brelse(to);
    80003802:	8526                	mv	a0,s1
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	dae080e7          	jalr	-594(ra) # 800025b2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380c:	2905                	addiw	s2,s2,1
    8000380e:	0a91                	addi	s5,s5,4
    80003810:	02ca2783          	lw	a5,44(s4)
    80003814:	f8f94ee3          	blt	s2,a5,800037b0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003818:	00000097          	auipc	ra,0x0
    8000381c:	c68080e7          	jalr	-920(ra) # 80003480 <write_head>
    install_trans(0); // Now install writes to home locations
    80003820:	4501                	li	a0,0
    80003822:	00000097          	auipc	ra,0x0
    80003826:	cda080e7          	jalr	-806(ra) # 800034fc <install_trans>
    log.lh.n = 0;
    8000382a:	00015797          	auipc	a5,0x15
    8000382e:	3807a123          	sw	zero,898(a5) # 80018bac <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003832:	00000097          	auipc	ra,0x0
    80003836:	c4e080e7          	jalr	-946(ra) # 80003480 <write_head>
    8000383a:	bdf5                	j	80003736 <end_op+0x52>

000000008000383c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000383c:	1101                	addi	sp,sp,-32
    8000383e:	ec06                	sd	ra,24(sp)
    80003840:	e822                	sd	s0,16(sp)
    80003842:	e426                	sd	s1,8(sp)
    80003844:	e04a                	sd	s2,0(sp)
    80003846:	1000                	addi	s0,sp,32
    80003848:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000384a:	00015917          	auipc	s2,0x15
    8000384e:	33690913          	addi	s2,s2,822 # 80018b80 <log>
    80003852:	854a                	mv	a0,s2
    80003854:	00003097          	auipc	ra,0x3
    80003858:	a50080e7          	jalr	-1456(ra) # 800062a4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000385c:	02c92603          	lw	a2,44(s2)
    80003860:	47f5                	li	a5,29
    80003862:	06c7c563          	blt	a5,a2,800038cc <log_write+0x90>
    80003866:	00015797          	auipc	a5,0x15
    8000386a:	3367a783          	lw	a5,822(a5) # 80018b9c <log+0x1c>
    8000386e:	37fd                	addiw	a5,a5,-1
    80003870:	04f65e63          	bge	a2,a5,800038cc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003874:	00015797          	auipc	a5,0x15
    80003878:	32c7a783          	lw	a5,812(a5) # 80018ba0 <log+0x20>
    8000387c:	06f05063          	blez	a5,800038dc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003880:	4781                	li	a5,0
    80003882:	06c05563          	blez	a2,800038ec <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003886:	44cc                	lw	a1,12(s1)
    80003888:	00015717          	auipc	a4,0x15
    8000388c:	32870713          	addi	a4,a4,808 # 80018bb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003890:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003892:	4314                	lw	a3,0(a4)
    80003894:	04b68c63          	beq	a3,a1,800038ec <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003898:	2785                	addiw	a5,a5,1
    8000389a:	0711                	addi	a4,a4,4
    8000389c:	fef61be3          	bne	a2,a5,80003892 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038a0:	0621                	addi	a2,a2,8
    800038a2:	060a                	slli	a2,a2,0x2
    800038a4:	00015797          	auipc	a5,0x15
    800038a8:	2dc78793          	addi	a5,a5,732 # 80018b80 <log>
    800038ac:	97b2                	add	a5,a5,a2
    800038ae:	44d8                	lw	a4,12(s1)
    800038b0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038b2:	8526                	mv	a0,s1
    800038b4:	fffff097          	auipc	ra,0xfffff
    800038b8:	d9c080e7          	jalr	-612(ra) # 80002650 <bpin>
    log.lh.n++;
    800038bc:	00015717          	auipc	a4,0x15
    800038c0:	2c470713          	addi	a4,a4,708 # 80018b80 <log>
    800038c4:	575c                	lw	a5,44(a4)
    800038c6:	2785                	addiw	a5,a5,1
    800038c8:	d75c                	sw	a5,44(a4)
    800038ca:	a82d                	j	80003904 <log_write+0xc8>
    panic("too big a transaction");
    800038cc:	00005517          	auipc	a0,0x5
    800038d0:	d9c50513          	addi	a0,a0,-612 # 80008668 <syscalls+0x238>
    800038d4:	00002097          	auipc	ra,0x2
    800038d8:	498080e7          	jalr	1176(ra) # 80005d6c <panic>
    panic("log_write outside of trans");
    800038dc:	00005517          	auipc	a0,0x5
    800038e0:	da450513          	addi	a0,a0,-604 # 80008680 <syscalls+0x250>
    800038e4:	00002097          	auipc	ra,0x2
    800038e8:	488080e7          	jalr	1160(ra) # 80005d6c <panic>
  log.lh.block[i] = b->blockno;
    800038ec:	00878693          	addi	a3,a5,8
    800038f0:	068a                	slli	a3,a3,0x2
    800038f2:	00015717          	auipc	a4,0x15
    800038f6:	28e70713          	addi	a4,a4,654 # 80018b80 <log>
    800038fa:	9736                	add	a4,a4,a3
    800038fc:	44d4                	lw	a3,12(s1)
    800038fe:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003900:	faf609e3          	beq	a2,a5,800038b2 <log_write+0x76>
  }
  release(&log.lock);
    80003904:	00015517          	auipc	a0,0x15
    80003908:	27c50513          	addi	a0,a0,636 # 80018b80 <log>
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	a4c080e7          	jalr	-1460(ra) # 80006358 <release>
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	addi	sp,sp,32
    8000391e:	8082                	ret

0000000080003920 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003920:	1101                	addi	sp,sp,-32
    80003922:	ec06                	sd	ra,24(sp)
    80003924:	e822                	sd	s0,16(sp)
    80003926:	e426                	sd	s1,8(sp)
    80003928:	e04a                	sd	s2,0(sp)
    8000392a:	1000                	addi	s0,sp,32
    8000392c:	84aa                	mv	s1,a0
    8000392e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003930:	00005597          	auipc	a1,0x5
    80003934:	d7058593          	addi	a1,a1,-656 # 800086a0 <syscalls+0x270>
    80003938:	0521                	addi	a0,a0,8
    8000393a:	00003097          	auipc	ra,0x3
    8000393e:	8da080e7          	jalr	-1830(ra) # 80006214 <initlock>
  lk->name = name;
    80003942:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003946:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000394a:	0204a423          	sw	zero,40(s1)
}
    8000394e:	60e2                	ld	ra,24(sp)
    80003950:	6442                	ld	s0,16(sp)
    80003952:	64a2                	ld	s1,8(sp)
    80003954:	6902                	ld	s2,0(sp)
    80003956:	6105                	addi	sp,sp,32
    80003958:	8082                	ret

000000008000395a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000395a:	1101                	addi	sp,sp,-32
    8000395c:	ec06                	sd	ra,24(sp)
    8000395e:	e822                	sd	s0,16(sp)
    80003960:	e426                	sd	s1,8(sp)
    80003962:	e04a                	sd	s2,0(sp)
    80003964:	1000                	addi	s0,sp,32
    80003966:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003968:	00850913          	addi	s2,a0,8
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	936080e7          	jalr	-1738(ra) # 800062a4 <acquire>
  while (lk->locked) {
    80003976:	409c                	lw	a5,0(s1)
    80003978:	cb89                	beqz	a5,8000398a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000397a:	85ca                	mv	a1,s2
    8000397c:	8526                	mv	a0,s1
    8000397e:	ffffe097          	auipc	ra,0xffffe
    80003982:	d36080e7          	jalr	-714(ra) # 800016b4 <sleep>
  while (lk->locked) {
    80003986:	409c                	lw	a5,0(s1)
    80003988:	fbed                	bnez	a5,8000397a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000398a:	4785                	li	a5,1
    8000398c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	5ce080e7          	jalr	1486(ra) # 80000f5c <myproc>
    80003996:	591c                	lw	a5,48(a0)
    80003998:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	9bc080e7          	jalr	-1604(ra) # 80006358 <release>
}
    800039a4:	60e2                	ld	ra,24(sp)
    800039a6:	6442                	ld	s0,16(sp)
    800039a8:	64a2                	ld	s1,8(sp)
    800039aa:	6902                	ld	s2,0(sp)
    800039ac:	6105                	addi	sp,sp,32
    800039ae:	8082                	ret

00000000800039b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039b0:	1101                	addi	sp,sp,-32
    800039b2:	ec06                	sd	ra,24(sp)
    800039b4:	e822                	sd	s0,16(sp)
    800039b6:	e426                	sd	s1,8(sp)
    800039b8:	e04a                	sd	s2,0(sp)
    800039ba:	1000                	addi	s0,sp,32
    800039bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039be:	00850913          	addi	s2,a0,8
    800039c2:	854a                	mv	a0,s2
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	8e0080e7          	jalr	-1824(ra) # 800062a4 <acquire>
  lk->locked = 0;
    800039cc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039d4:	8526                	mv	a0,s1
    800039d6:	ffffe097          	auipc	ra,0xffffe
    800039da:	d42080e7          	jalr	-702(ra) # 80001718 <wakeup>
  release(&lk->lk);
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	978080e7          	jalr	-1672(ra) # 80006358 <release>
}
    800039e8:	60e2                	ld	ra,24(sp)
    800039ea:	6442                	ld	s0,16(sp)
    800039ec:	64a2                	ld	s1,8(sp)
    800039ee:	6902                	ld	s2,0(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039f4:	7179                	addi	sp,sp,-48
    800039f6:	f406                	sd	ra,40(sp)
    800039f8:	f022                	sd	s0,32(sp)
    800039fa:	ec26                	sd	s1,24(sp)
    800039fc:	e84a                	sd	s2,16(sp)
    800039fe:	e44e                	sd	s3,8(sp)
    80003a00:	1800                	addi	s0,sp,48
    80003a02:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a04:	00850913          	addi	s2,a0,8
    80003a08:	854a                	mv	a0,s2
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	89a080e7          	jalr	-1894(ra) # 800062a4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a12:	409c                	lw	a5,0(s1)
    80003a14:	ef99                	bnez	a5,80003a32 <holdingsleep+0x3e>
    80003a16:	4481                	li	s1,0
  release(&lk->lk);
    80003a18:	854a                	mv	a0,s2
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	93e080e7          	jalr	-1730(ra) # 80006358 <release>
  return r;
}
    80003a22:	8526                	mv	a0,s1
    80003a24:	70a2                	ld	ra,40(sp)
    80003a26:	7402                	ld	s0,32(sp)
    80003a28:	64e2                	ld	s1,24(sp)
    80003a2a:	6942                	ld	s2,16(sp)
    80003a2c:	69a2                	ld	s3,8(sp)
    80003a2e:	6145                	addi	sp,sp,48
    80003a30:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a32:	0284a983          	lw	s3,40(s1)
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	526080e7          	jalr	1318(ra) # 80000f5c <myproc>
    80003a3e:	5904                	lw	s1,48(a0)
    80003a40:	413484b3          	sub	s1,s1,s3
    80003a44:	0014b493          	seqz	s1,s1
    80003a48:	bfc1                	j	80003a18 <holdingsleep+0x24>

0000000080003a4a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a4a:	1141                	addi	sp,sp,-16
    80003a4c:	e406                	sd	ra,8(sp)
    80003a4e:	e022                	sd	s0,0(sp)
    80003a50:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a52:	00005597          	auipc	a1,0x5
    80003a56:	c5e58593          	addi	a1,a1,-930 # 800086b0 <syscalls+0x280>
    80003a5a:	00015517          	auipc	a0,0x15
    80003a5e:	26e50513          	addi	a0,a0,622 # 80018cc8 <ftable>
    80003a62:	00002097          	auipc	ra,0x2
    80003a66:	7b2080e7          	jalr	1970(ra) # 80006214 <initlock>
}
    80003a6a:	60a2                	ld	ra,8(sp)
    80003a6c:	6402                	ld	s0,0(sp)
    80003a6e:	0141                	addi	sp,sp,16
    80003a70:	8082                	ret

0000000080003a72 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a72:	1101                	addi	sp,sp,-32
    80003a74:	ec06                	sd	ra,24(sp)
    80003a76:	e822                	sd	s0,16(sp)
    80003a78:	e426                	sd	s1,8(sp)
    80003a7a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a7c:	00015517          	auipc	a0,0x15
    80003a80:	24c50513          	addi	a0,a0,588 # 80018cc8 <ftable>
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	820080e7          	jalr	-2016(ra) # 800062a4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a8c:	00015497          	auipc	s1,0x15
    80003a90:	25448493          	addi	s1,s1,596 # 80018ce0 <ftable+0x18>
    80003a94:	00016717          	auipc	a4,0x16
    80003a98:	1ec70713          	addi	a4,a4,492 # 80019c80 <disk>
    if(f->ref == 0){
    80003a9c:	40dc                	lw	a5,4(s1)
    80003a9e:	cf99                	beqz	a5,80003abc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa0:	02848493          	addi	s1,s1,40
    80003aa4:	fee49ce3          	bne	s1,a4,80003a9c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aa8:	00015517          	auipc	a0,0x15
    80003aac:	22050513          	addi	a0,a0,544 # 80018cc8 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	8a8080e7          	jalr	-1880(ra) # 80006358 <release>
  return 0;
    80003ab8:	4481                	li	s1,0
    80003aba:	a819                	j	80003ad0 <filealloc+0x5e>
      f->ref = 1;
    80003abc:	4785                	li	a5,1
    80003abe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ac0:	00015517          	auipc	a0,0x15
    80003ac4:	20850513          	addi	a0,a0,520 # 80018cc8 <ftable>
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	890080e7          	jalr	-1904(ra) # 80006358 <release>
}
    80003ad0:	8526                	mv	a0,s1
    80003ad2:	60e2                	ld	ra,24(sp)
    80003ad4:	6442                	ld	s0,16(sp)
    80003ad6:	64a2                	ld	s1,8(sp)
    80003ad8:	6105                	addi	sp,sp,32
    80003ada:	8082                	ret

0000000080003adc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003adc:	1101                	addi	sp,sp,-32
    80003ade:	ec06                	sd	ra,24(sp)
    80003ae0:	e822                	sd	s0,16(sp)
    80003ae2:	e426                	sd	s1,8(sp)
    80003ae4:	1000                	addi	s0,sp,32
    80003ae6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ae8:	00015517          	auipc	a0,0x15
    80003aec:	1e050513          	addi	a0,a0,480 # 80018cc8 <ftable>
    80003af0:	00002097          	auipc	ra,0x2
    80003af4:	7b4080e7          	jalr	1972(ra) # 800062a4 <acquire>
  if(f->ref < 1)
    80003af8:	40dc                	lw	a5,4(s1)
    80003afa:	02f05263          	blez	a5,80003b1e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003afe:	2785                	addiw	a5,a5,1
    80003b00:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b02:	00015517          	auipc	a0,0x15
    80003b06:	1c650513          	addi	a0,a0,454 # 80018cc8 <ftable>
    80003b0a:	00003097          	auipc	ra,0x3
    80003b0e:	84e080e7          	jalr	-1970(ra) # 80006358 <release>
  return f;
}
    80003b12:	8526                	mv	a0,s1
    80003b14:	60e2                	ld	ra,24(sp)
    80003b16:	6442                	ld	s0,16(sp)
    80003b18:	64a2                	ld	s1,8(sp)
    80003b1a:	6105                	addi	sp,sp,32
    80003b1c:	8082                	ret
    panic("filedup");
    80003b1e:	00005517          	auipc	a0,0x5
    80003b22:	b9a50513          	addi	a0,a0,-1126 # 800086b8 <syscalls+0x288>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	246080e7          	jalr	582(ra) # 80005d6c <panic>

0000000080003b2e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b2e:	7139                	addi	sp,sp,-64
    80003b30:	fc06                	sd	ra,56(sp)
    80003b32:	f822                	sd	s0,48(sp)
    80003b34:	f426                	sd	s1,40(sp)
    80003b36:	f04a                	sd	s2,32(sp)
    80003b38:	ec4e                	sd	s3,24(sp)
    80003b3a:	e852                	sd	s4,16(sp)
    80003b3c:	e456                	sd	s5,8(sp)
    80003b3e:	0080                	addi	s0,sp,64
    80003b40:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b42:	00015517          	auipc	a0,0x15
    80003b46:	18650513          	addi	a0,a0,390 # 80018cc8 <ftable>
    80003b4a:	00002097          	auipc	ra,0x2
    80003b4e:	75a080e7          	jalr	1882(ra) # 800062a4 <acquire>
  if(f->ref < 1)
    80003b52:	40dc                	lw	a5,4(s1)
    80003b54:	06f05163          	blez	a5,80003bb6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b58:	37fd                	addiw	a5,a5,-1
    80003b5a:	0007871b          	sext.w	a4,a5
    80003b5e:	c0dc                	sw	a5,4(s1)
    80003b60:	06e04363          	bgtz	a4,80003bc6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b64:	0004a903          	lw	s2,0(s1)
    80003b68:	0094ca83          	lbu	s5,9(s1)
    80003b6c:	0104ba03          	ld	s4,16(s1)
    80003b70:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b74:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b78:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b7c:	00015517          	auipc	a0,0x15
    80003b80:	14c50513          	addi	a0,a0,332 # 80018cc8 <ftable>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	7d4080e7          	jalr	2004(ra) # 80006358 <release>

  if(ff.type == FD_PIPE){
    80003b8c:	4785                	li	a5,1
    80003b8e:	04f90d63          	beq	s2,a5,80003be8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b92:	3979                	addiw	s2,s2,-2
    80003b94:	4785                	li	a5,1
    80003b96:	0527e063          	bltu	a5,s2,80003bd6 <fileclose+0xa8>
    begin_op();
    80003b9a:	00000097          	auipc	ra,0x0
    80003b9e:	acc080e7          	jalr	-1332(ra) # 80003666 <begin_op>
    iput(ff.ip);
    80003ba2:	854e                	mv	a0,s3
    80003ba4:	fffff097          	auipc	ra,0xfffff
    80003ba8:	2b0080e7          	jalr	688(ra) # 80002e54 <iput>
    end_op();
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	b38080e7          	jalr	-1224(ra) # 800036e4 <end_op>
    80003bb4:	a00d                	j	80003bd6 <fileclose+0xa8>
    panic("fileclose");
    80003bb6:	00005517          	auipc	a0,0x5
    80003bba:	b0a50513          	addi	a0,a0,-1270 # 800086c0 <syscalls+0x290>
    80003bbe:	00002097          	auipc	ra,0x2
    80003bc2:	1ae080e7          	jalr	430(ra) # 80005d6c <panic>
    release(&ftable.lock);
    80003bc6:	00015517          	auipc	a0,0x15
    80003bca:	10250513          	addi	a0,a0,258 # 80018cc8 <ftable>
    80003bce:	00002097          	auipc	ra,0x2
    80003bd2:	78a080e7          	jalr	1930(ra) # 80006358 <release>
  }
}
    80003bd6:	70e2                	ld	ra,56(sp)
    80003bd8:	7442                	ld	s0,48(sp)
    80003bda:	74a2                	ld	s1,40(sp)
    80003bdc:	7902                	ld	s2,32(sp)
    80003bde:	69e2                	ld	s3,24(sp)
    80003be0:	6a42                	ld	s4,16(sp)
    80003be2:	6aa2                	ld	s5,8(sp)
    80003be4:	6121                	addi	sp,sp,64
    80003be6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003be8:	85d6                	mv	a1,s5
    80003bea:	8552                	mv	a0,s4
    80003bec:	00000097          	auipc	ra,0x0
    80003bf0:	34c080e7          	jalr	844(ra) # 80003f38 <pipeclose>
    80003bf4:	b7cd                	j	80003bd6 <fileclose+0xa8>

0000000080003bf6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bf6:	715d                	addi	sp,sp,-80
    80003bf8:	e486                	sd	ra,72(sp)
    80003bfa:	e0a2                	sd	s0,64(sp)
    80003bfc:	fc26                	sd	s1,56(sp)
    80003bfe:	f84a                	sd	s2,48(sp)
    80003c00:	f44e                	sd	s3,40(sp)
    80003c02:	0880                	addi	s0,sp,80
    80003c04:	84aa                	mv	s1,a0
    80003c06:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c08:	ffffd097          	auipc	ra,0xffffd
    80003c0c:	354080e7          	jalr	852(ra) # 80000f5c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c10:	409c                	lw	a5,0(s1)
    80003c12:	37f9                	addiw	a5,a5,-2
    80003c14:	4705                	li	a4,1
    80003c16:	04f76763          	bltu	a4,a5,80003c64 <filestat+0x6e>
    80003c1a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c1c:	6c88                	ld	a0,24(s1)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	07c080e7          	jalr	124(ra) # 80002c9a <ilock>
    stati(f->ip, &st);
    80003c26:	fb840593          	addi	a1,s0,-72
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	2f8080e7          	jalr	760(ra) # 80002f24 <stati>
    iunlock(f->ip);
    80003c34:	6c88                	ld	a0,24(s1)
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	126080e7          	jalr	294(ra) # 80002d5c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c3e:	46e1                	li	a3,24
    80003c40:	fb840613          	addi	a2,s0,-72
    80003c44:	85ce                	mv	a1,s3
    80003c46:	05093503          	ld	a0,80(s2)
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	eca080e7          	jalr	-310(ra) # 80000b14 <copyout>
    80003c52:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c56:	60a6                	ld	ra,72(sp)
    80003c58:	6406                	ld	s0,64(sp)
    80003c5a:	74e2                	ld	s1,56(sp)
    80003c5c:	7942                	ld	s2,48(sp)
    80003c5e:	79a2                	ld	s3,40(sp)
    80003c60:	6161                	addi	sp,sp,80
    80003c62:	8082                	ret
  return -1;
    80003c64:	557d                	li	a0,-1
    80003c66:	bfc5                	j	80003c56 <filestat+0x60>

0000000080003c68 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c68:	7179                	addi	sp,sp,-48
    80003c6a:	f406                	sd	ra,40(sp)
    80003c6c:	f022                	sd	s0,32(sp)
    80003c6e:	ec26                	sd	s1,24(sp)
    80003c70:	e84a                	sd	s2,16(sp)
    80003c72:	e44e                	sd	s3,8(sp)
    80003c74:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c76:	00854783          	lbu	a5,8(a0)
    80003c7a:	c3d5                	beqz	a5,80003d1e <fileread+0xb6>
    80003c7c:	84aa                	mv	s1,a0
    80003c7e:	89ae                	mv	s3,a1
    80003c80:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c82:	411c                	lw	a5,0(a0)
    80003c84:	4705                	li	a4,1
    80003c86:	04e78963          	beq	a5,a4,80003cd8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c8a:	470d                	li	a4,3
    80003c8c:	04e78d63          	beq	a5,a4,80003ce6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c90:	4709                	li	a4,2
    80003c92:	06e79e63          	bne	a5,a4,80003d0e <fileread+0xa6>
    ilock(f->ip);
    80003c96:	6d08                	ld	a0,24(a0)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	002080e7          	jalr	2(ra) # 80002c9a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ca0:	874a                	mv	a4,s2
    80003ca2:	5094                	lw	a3,32(s1)
    80003ca4:	864e                	mv	a2,s3
    80003ca6:	4585                	li	a1,1
    80003ca8:	6c88                	ld	a0,24(s1)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	2a4080e7          	jalr	676(ra) # 80002f4e <readi>
    80003cb2:	892a                	mv	s2,a0
    80003cb4:	00a05563          	blez	a0,80003cbe <fileread+0x56>
      f->off += r;
    80003cb8:	509c                	lw	a5,32(s1)
    80003cba:	9fa9                	addw	a5,a5,a0
    80003cbc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cbe:	6c88                	ld	a0,24(s1)
    80003cc0:	fffff097          	auipc	ra,0xfffff
    80003cc4:	09c080e7          	jalr	156(ra) # 80002d5c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cc8:	854a                	mv	a0,s2
    80003cca:	70a2                	ld	ra,40(sp)
    80003ccc:	7402                	ld	s0,32(sp)
    80003cce:	64e2                	ld	s1,24(sp)
    80003cd0:	6942                	ld	s2,16(sp)
    80003cd2:	69a2                	ld	s3,8(sp)
    80003cd4:	6145                	addi	sp,sp,48
    80003cd6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cd8:	6908                	ld	a0,16(a0)
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	3c6080e7          	jalr	966(ra) # 800040a0 <piperead>
    80003ce2:	892a                	mv	s2,a0
    80003ce4:	b7d5                	j	80003cc8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ce6:	02451783          	lh	a5,36(a0)
    80003cea:	03079693          	slli	a3,a5,0x30
    80003cee:	92c1                	srli	a3,a3,0x30
    80003cf0:	4725                	li	a4,9
    80003cf2:	02d76863          	bltu	a4,a3,80003d22 <fileread+0xba>
    80003cf6:	0792                	slli	a5,a5,0x4
    80003cf8:	00015717          	auipc	a4,0x15
    80003cfc:	f3070713          	addi	a4,a4,-208 # 80018c28 <devsw>
    80003d00:	97ba                	add	a5,a5,a4
    80003d02:	639c                	ld	a5,0(a5)
    80003d04:	c38d                	beqz	a5,80003d26 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d06:	4505                	li	a0,1
    80003d08:	9782                	jalr	a5
    80003d0a:	892a                	mv	s2,a0
    80003d0c:	bf75                	j	80003cc8 <fileread+0x60>
    panic("fileread");
    80003d0e:	00005517          	auipc	a0,0x5
    80003d12:	9c250513          	addi	a0,a0,-1598 # 800086d0 <syscalls+0x2a0>
    80003d16:	00002097          	auipc	ra,0x2
    80003d1a:	056080e7          	jalr	86(ra) # 80005d6c <panic>
    return -1;
    80003d1e:	597d                	li	s2,-1
    80003d20:	b765                	j	80003cc8 <fileread+0x60>
      return -1;
    80003d22:	597d                	li	s2,-1
    80003d24:	b755                	j	80003cc8 <fileread+0x60>
    80003d26:	597d                	li	s2,-1
    80003d28:	b745                	j	80003cc8 <fileread+0x60>

0000000080003d2a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d2a:	715d                	addi	sp,sp,-80
    80003d2c:	e486                	sd	ra,72(sp)
    80003d2e:	e0a2                	sd	s0,64(sp)
    80003d30:	fc26                	sd	s1,56(sp)
    80003d32:	f84a                	sd	s2,48(sp)
    80003d34:	f44e                	sd	s3,40(sp)
    80003d36:	f052                	sd	s4,32(sp)
    80003d38:	ec56                	sd	s5,24(sp)
    80003d3a:	e85a                	sd	s6,16(sp)
    80003d3c:	e45e                	sd	s7,8(sp)
    80003d3e:	e062                	sd	s8,0(sp)
    80003d40:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d42:	00954783          	lbu	a5,9(a0)
    80003d46:	10078663          	beqz	a5,80003e52 <filewrite+0x128>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	8b2e                	mv	s6,a1
    80003d4e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d50:	411c                	lw	a5,0(a0)
    80003d52:	4705                	li	a4,1
    80003d54:	02e78263          	beq	a5,a4,80003d78 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d58:	470d                	li	a4,3
    80003d5a:	02e78663          	beq	a5,a4,80003d86 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d5e:	4709                	li	a4,2
    80003d60:	0ee79163          	bne	a5,a4,80003e42 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d64:	0ac05d63          	blez	a2,80003e1e <filewrite+0xf4>
    int i = 0;
    80003d68:	4981                	li	s3,0
    80003d6a:	6b85                	lui	s7,0x1
    80003d6c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d70:	6c05                	lui	s8,0x1
    80003d72:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d76:	a861                	j	80003e0e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d78:	6908                	ld	a0,16(a0)
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	22e080e7          	jalr	558(ra) # 80003fa8 <pipewrite>
    80003d82:	8a2a                	mv	s4,a0
    80003d84:	a045                	j	80003e24 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d86:	02451783          	lh	a5,36(a0)
    80003d8a:	03079693          	slli	a3,a5,0x30
    80003d8e:	92c1                	srli	a3,a3,0x30
    80003d90:	4725                	li	a4,9
    80003d92:	0cd76263          	bltu	a4,a3,80003e56 <filewrite+0x12c>
    80003d96:	0792                	slli	a5,a5,0x4
    80003d98:	00015717          	auipc	a4,0x15
    80003d9c:	e9070713          	addi	a4,a4,-368 # 80018c28 <devsw>
    80003da0:	97ba                	add	a5,a5,a4
    80003da2:	679c                	ld	a5,8(a5)
    80003da4:	cbdd                	beqz	a5,80003e5a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003da6:	4505                	li	a0,1
    80003da8:	9782                	jalr	a5
    80003daa:	8a2a                	mv	s4,a0
    80003dac:	a8a5                	j	80003e24 <filewrite+0xfa>
    80003dae:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	8b4080e7          	jalr	-1868(ra) # 80003666 <begin_op>
      ilock(f->ip);
    80003dba:	01893503          	ld	a0,24(s2)
    80003dbe:	fffff097          	auipc	ra,0xfffff
    80003dc2:	edc080e7          	jalr	-292(ra) # 80002c9a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dc6:	8756                	mv	a4,s5
    80003dc8:	02092683          	lw	a3,32(s2)
    80003dcc:	01698633          	add	a2,s3,s6
    80003dd0:	4585                	li	a1,1
    80003dd2:	01893503          	ld	a0,24(s2)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	270080e7          	jalr	624(ra) # 80003046 <writei>
    80003dde:	84aa                	mv	s1,a0
    80003de0:	00a05763          	blez	a0,80003dee <filewrite+0xc4>
        f->off += r;
    80003de4:	02092783          	lw	a5,32(s2)
    80003de8:	9fa9                	addw	a5,a5,a0
    80003dea:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dee:	01893503          	ld	a0,24(s2)
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	f6a080e7          	jalr	-150(ra) # 80002d5c <iunlock>
      end_op();
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	8ea080e7          	jalr	-1814(ra) # 800036e4 <end_op>

      if(r != n1){
    80003e02:	009a9f63          	bne	s5,s1,80003e20 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e06:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e0a:	0149db63          	bge	s3,s4,80003e20 <filewrite+0xf6>
      int n1 = n - i;
    80003e0e:	413a04bb          	subw	s1,s4,s3
    80003e12:	0004879b          	sext.w	a5,s1
    80003e16:	f8fbdce3          	bge	s7,a5,80003dae <filewrite+0x84>
    80003e1a:	84e2                	mv	s1,s8
    80003e1c:	bf49                	j	80003dae <filewrite+0x84>
    int i = 0;
    80003e1e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e20:	013a1f63          	bne	s4,s3,80003e3e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e24:	8552                	mv	a0,s4
    80003e26:	60a6                	ld	ra,72(sp)
    80003e28:	6406                	ld	s0,64(sp)
    80003e2a:	74e2                	ld	s1,56(sp)
    80003e2c:	7942                	ld	s2,48(sp)
    80003e2e:	79a2                	ld	s3,40(sp)
    80003e30:	7a02                	ld	s4,32(sp)
    80003e32:	6ae2                	ld	s5,24(sp)
    80003e34:	6b42                	ld	s6,16(sp)
    80003e36:	6ba2                	ld	s7,8(sp)
    80003e38:	6c02                	ld	s8,0(sp)
    80003e3a:	6161                	addi	sp,sp,80
    80003e3c:	8082                	ret
    ret = (i == n ? n : -1);
    80003e3e:	5a7d                	li	s4,-1
    80003e40:	b7d5                	j	80003e24 <filewrite+0xfa>
    panic("filewrite");
    80003e42:	00005517          	auipc	a0,0x5
    80003e46:	89e50513          	addi	a0,a0,-1890 # 800086e0 <syscalls+0x2b0>
    80003e4a:	00002097          	auipc	ra,0x2
    80003e4e:	f22080e7          	jalr	-222(ra) # 80005d6c <panic>
    return -1;
    80003e52:	5a7d                	li	s4,-1
    80003e54:	bfc1                	j	80003e24 <filewrite+0xfa>
      return -1;
    80003e56:	5a7d                	li	s4,-1
    80003e58:	b7f1                	j	80003e24 <filewrite+0xfa>
    80003e5a:	5a7d                	li	s4,-1
    80003e5c:	b7e1                	j	80003e24 <filewrite+0xfa>

0000000080003e5e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e5e:	7179                	addi	sp,sp,-48
    80003e60:	f406                	sd	ra,40(sp)
    80003e62:	f022                	sd	s0,32(sp)
    80003e64:	ec26                	sd	s1,24(sp)
    80003e66:	e84a                	sd	s2,16(sp)
    80003e68:	e44e                	sd	s3,8(sp)
    80003e6a:	e052                	sd	s4,0(sp)
    80003e6c:	1800                	addi	s0,sp,48
    80003e6e:	84aa                	mv	s1,a0
    80003e70:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e72:	0005b023          	sd	zero,0(a1)
    80003e76:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	bf8080e7          	jalr	-1032(ra) # 80003a72 <filealloc>
    80003e82:	e088                	sd	a0,0(s1)
    80003e84:	c551                	beqz	a0,80003f10 <pipealloc+0xb2>
    80003e86:	00000097          	auipc	ra,0x0
    80003e8a:	bec080e7          	jalr	-1044(ra) # 80003a72 <filealloc>
    80003e8e:	00aa3023          	sd	a0,0(s4)
    80003e92:	c92d                	beqz	a0,80003f04 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e94:	ffffc097          	auipc	ra,0xffffc
    80003e98:	286080e7          	jalr	646(ra) # 8000011a <kalloc>
    80003e9c:	892a                	mv	s2,a0
    80003e9e:	c125                	beqz	a0,80003efe <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ea0:	4985                	li	s3,1
    80003ea2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ea6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003eaa:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eae:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003eb2:	00005597          	auipc	a1,0x5
    80003eb6:	83e58593          	addi	a1,a1,-1986 # 800086f0 <syscalls+0x2c0>
    80003eba:	00002097          	auipc	ra,0x2
    80003ebe:	35a080e7          	jalr	858(ra) # 80006214 <initlock>
  (*f0)->type = FD_PIPE;
    80003ec2:	609c                	ld	a5,0(s1)
    80003ec4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ec8:	609c                	ld	a5,0(s1)
    80003eca:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ece:	609c                	ld	a5,0(s1)
    80003ed0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ed4:	609c                	ld	a5,0(s1)
    80003ed6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eda:	000a3783          	ld	a5,0(s4)
    80003ede:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ee2:	000a3783          	ld	a5,0(s4)
    80003ee6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eea:	000a3783          	ld	a5,0(s4)
    80003eee:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ef2:	000a3783          	ld	a5,0(s4)
    80003ef6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003efa:	4501                	li	a0,0
    80003efc:	a025                	j	80003f24 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003efe:	6088                	ld	a0,0(s1)
    80003f00:	e501                	bnez	a0,80003f08 <pipealloc+0xaa>
    80003f02:	a039                	j	80003f10 <pipealloc+0xb2>
    80003f04:	6088                	ld	a0,0(s1)
    80003f06:	c51d                	beqz	a0,80003f34 <pipealloc+0xd6>
    fileclose(*f0);
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	c26080e7          	jalr	-986(ra) # 80003b2e <fileclose>
  if(*f1)
    80003f10:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f14:	557d                	li	a0,-1
  if(*f1)
    80003f16:	c799                	beqz	a5,80003f24 <pipealloc+0xc6>
    fileclose(*f1);
    80003f18:	853e                	mv	a0,a5
    80003f1a:	00000097          	auipc	ra,0x0
    80003f1e:	c14080e7          	jalr	-1004(ra) # 80003b2e <fileclose>
  return -1;
    80003f22:	557d                	li	a0,-1
}
    80003f24:	70a2                	ld	ra,40(sp)
    80003f26:	7402                	ld	s0,32(sp)
    80003f28:	64e2                	ld	s1,24(sp)
    80003f2a:	6942                	ld	s2,16(sp)
    80003f2c:	69a2                	ld	s3,8(sp)
    80003f2e:	6a02                	ld	s4,0(sp)
    80003f30:	6145                	addi	sp,sp,48
    80003f32:	8082                	ret
  return -1;
    80003f34:	557d                	li	a0,-1
    80003f36:	b7fd                	j	80003f24 <pipealloc+0xc6>

0000000080003f38 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f38:	1101                	addi	sp,sp,-32
    80003f3a:	ec06                	sd	ra,24(sp)
    80003f3c:	e822                	sd	s0,16(sp)
    80003f3e:	e426                	sd	s1,8(sp)
    80003f40:	e04a                	sd	s2,0(sp)
    80003f42:	1000                	addi	s0,sp,32
    80003f44:	84aa                	mv	s1,a0
    80003f46:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f48:	00002097          	auipc	ra,0x2
    80003f4c:	35c080e7          	jalr	860(ra) # 800062a4 <acquire>
  if(writable){
    80003f50:	02090d63          	beqz	s2,80003f8a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f54:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f58:	21848513          	addi	a0,s1,536
    80003f5c:	ffffd097          	auipc	ra,0xffffd
    80003f60:	7bc080e7          	jalr	1980(ra) # 80001718 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f64:	2204b783          	ld	a5,544(s1)
    80003f68:	eb95                	bnez	a5,80003f9c <pipeclose+0x64>
    release(&pi->lock);
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	00002097          	auipc	ra,0x2
    80003f70:	3ec080e7          	jalr	1004(ra) # 80006358 <release>
    kfree((char*)pi);
    80003f74:	8526                	mv	a0,s1
    80003f76:	ffffc097          	auipc	ra,0xffffc
    80003f7a:	0a6080e7          	jalr	166(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f7e:	60e2                	ld	ra,24(sp)
    80003f80:	6442                	ld	s0,16(sp)
    80003f82:	64a2                	ld	s1,8(sp)
    80003f84:	6902                	ld	s2,0(sp)
    80003f86:	6105                	addi	sp,sp,32
    80003f88:	8082                	ret
    pi->readopen = 0;
    80003f8a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f8e:	21c48513          	addi	a0,s1,540
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	786080e7          	jalr	1926(ra) # 80001718 <wakeup>
    80003f9a:	b7e9                	j	80003f64 <pipeclose+0x2c>
    release(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	3ba080e7          	jalr	954(ra) # 80006358 <release>
}
    80003fa6:	bfe1                	j	80003f7e <pipeclose+0x46>

0000000080003fa8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fa8:	711d                	addi	sp,sp,-96
    80003faa:	ec86                	sd	ra,88(sp)
    80003fac:	e8a2                	sd	s0,80(sp)
    80003fae:	e4a6                	sd	s1,72(sp)
    80003fb0:	e0ca                	sd	s2,64(sp)
    80003fb2:	fc4e                	sd	s3,56(sp)
    80003fb4:	f852                	sd	s4,48(sp)
    80003fb6:	f456                	sd	s5,40(sp)
    80003fb8:	f05a                	sd	s6,32(sp)
    80003fba:	ec5e                	sd	s7,24(sp)
    80003fbc:	e862                	sd	s8,16(sp)
    80003fbe:	1080                	addi	s0,sp,96
    80003fc0:	84aa                	mv	s1,a0
    80003fc2:	8aae                	mv	s5,a1
    80003fc4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	f96080e7          	jalr	-106(ra) # 80000f5c <myproc>
    80003fce:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	00002097          	auipc	ra,0x2
    80003fd6:	2d2080e7          	jalr	722(ra) # 800062a4 <acquire>
  while(i < n){
    80003fda:	0b405663          	blez	s4,80004086 <pipewrite+0xde>
  int i = 0;
    80003fde:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fe0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fe2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fe6:	21c48b93          	addi	s7,s1,540
    80003fea:	a089                	j	8000402c <pipewrite+0x84>
      release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	36a080e7          	jalr	874(ra) # 80006358 <release>
      return -1;
    80003ff6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ff8:	854a                	mv	a0,s2
    80003ffa:	60e6                	ld	ra,88(sp)
    80003ffc:	6446                	ld	s0,80(sp)
    80003ffe:	64a6                	ld	s1,72(sp)
    80004000:	6906                	ld	s2,64(sp)
    80004002:	79e2                	ld	s3,56(sp)
    80004004:	7a42                	ld	s4,48(sp)
    80004006:	7aa2                	ld	s5,40(sp)
    80004008:	7b02                	ld	s6,32(sp)
    8000400a:	6be2                	ld	s7,24(sp)
    8000400c:	6c42                	ld	s8,16(sp)
    8000400e:	6125                	addi	sp,sp,96
    80004010:	8082                	ret
      wakeup(&pi->nread);
    80004012:	8562                	mv	a0,s8
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	704080e7          	jalr	1796(ra) # 80001718 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000401c:	85a6                	mv	a1,s1
    8000401e:	855e                	mv	a0,s7
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	694080e7          	jalr	1684(ra) # 800016b4 <sleep>
  while(i < n){
    80004028:	07495063          	bge	s2,s4,80004088 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000402c:	2204a783          	lw	a5,544(s1)
    80004030:	dfd5                	beqz	a5,80003fec <pipewrite+0x44>
    80004032:	854e                	mv	a0,s3
    80004034:	ffffe097          	auipc	ra,0xffffe
    80004038:	928080e7          	jalr	-1752(ra) # 8000195c <killed>
    8000403c:	f945                	bnez	a0,80003fec <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000403e:	2184a783          	lw	a5,536(s1)
    80004042:	21c4a703          	lw	a4,540(s1)
    80004046:	2007879b          	addiw	a5,a5,512
    8000404a:	fcf704e3          	beq	a4,a5,80004012 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000404e:	4685                	li	a3,1
    80004050:	01590633          	add	a2,s2,s5
    80004054:	faf40593          	addi	a1,s0,-81
    80004058:	0509b503          	ld	a0,80(s3)
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	b44080e7          	jalr	-1212(ra) # 80000ba0 <copyin>
    80004064:	03650263          	beq	a0,s6,80004088 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004068:	21c4a783          	lw	a5,540(s1)
    8000406c:	0017871b          	addiw	a4,a5,1
    80004070:	20e4ae23          	sw	a4,540(s1)
    80004074:	1ff7f793          	andi	a5,a5,511
    80004078:	97a6                	add	a5,a5,s1
    8000407a:	faf44703          	lbu	a4,-81(s0)
    8000407e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004082:	2905                	addiw	s2,s2,1
    80004084:	b755                	j	80004028 <pipewrite+0x80>
  int i = 0;
    80004086:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004088:	21848513          	addi	a0,s1,536
    8000408c:	ffffd097          	auipc	ra,0xffffd
    80004090:	68c080e7          	jalr	1676(ra) # 80001718 <wakeup>
  release(&pi->lock);
    80004094:	8526                	mv	a0,s1
    80004096:	00002097          	auipc	ra,0x2
    8000409a:	2c2080e7          	jalr	706(ra) # 80006358 <release>
  return i;
    8000409e:	bfa9                	j	80003ff8 <pipewrite+0x50>

00000000800040a0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040a0:	715d                	addi	sp,sp,-80
    800040a2:	e486                	sd	ra,72(sp)
    800040a4:	e0a2                	sd	s0,64(sp)
    800040a6:	fc26                	sd	s1,56(sp)
    800040a8:	f84a                	sd	s2,48(sp)
    800040aa:	f44e                	sd	s3,40(sp)
    800040ac:	f052                	sd	s4,32(sp)
    800040ae:	ec56                	sd	s5,24(sp)
    800040b0:	e85a                	sd	s6,16(sp)
    800040b2:	0880                	addi	s0,sp,80
    800040b4:	84aa                	mv	s1,a0
    800040b6:	892e                	mv	s2,a1
    800040b8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040ba:	ffffd097          	auipc	ra,0xffffd
    800040be:	ea2080e7          	jalr	-350(ra) # 80000f5c <myproc>
    800040c2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	1de080e7          	jalr	478(ra) # 800062a4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ce:	2184a703          	lw	a4,536(s1)
    800040d2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040da:	02f71763          	bne	a4,a5,80004108 <piperead+0x68>
    800040de:	2244a783          	lw	a5,548(s1)
    800040e2:	c39d                	beqz	a5,80004108 <piperead+0x68>
    if(killed(pr)){
    800040e4:	8552                	mv	a0,s4
    800040e6:	ffffe097          	auipc	ra,0xffffe
    800040ea:	876080e7          	jalr	-1930(ra) # 8000195c <killed>
    800040ee:	e949                	bnez	a0,80004180 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f0:	85a6                	mv	a1,s1
    800040f2:	854e                	mv	a0,s3
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	5c0080e7          	jalr	1472(ra) # 800016b4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040fc:	2184a703          	lw	a4,536(s1)
    80004100:	21c4a783          	lw	a5,540(s1)
    80004104:	fcf70de3          	beq	a4,a5,800040de <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004108:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000410a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000410c:	05505463          	blez	s5,80004154 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004110:	2184a783          	lw	a5,536(s1)
    80004114:	21c4a703          	lw	a4,540(s1)
    80004118:	02f70e63          	beq	a4,a5,80004154 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000411c:	0017871b          	addiw	a4,a5,1
    80004120:	20e4ac23          	sw	a4,536(s1)
    80004124:	1ff7f793          	andi	a5,a5,511
    80004128:	97a6                	add	a5,a5,s1
    8000412a:	0187c783          	lbu	a5,24(a5)
    8000412e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004132:	4685                	li	a3,1
    80004134:	fbf40613          	addi	a2,s0,-65
    80004138:	85ca                	mv	a1,s2
    8000413a:	050a3503          	ld	a0,80(s4)
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	9d6080e7          	jalr	-1578(ra) # 80000b14 <copyout>
    80004146:	01650763          	beq	a0,s6,80004154 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000414a:	2985                	addiw	s3,s3,1
    8000414c:	0905                	addi	s2,s2,1
    8000414e:	fd3a91e3          	bne	s5,s3,80004110 <piperead+0x70>
    80004152:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004154:	21c48513          	addi	a0,s1,540
    80004158:	ffffd097          	auipc	ra,0xffffd
    8000415c:	5c0080e7          	jalr	1472(ra) # 80001718 <wakeup>
  release(&pi->lock);
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	1f6080e7          	jalr	502(ra) # 80006358 <release>
  return i;
}
    8000416a:	854e                	mv	a0,s3
    8000416c:	60a6                	ld	ra,72(sp)
    8000416e:	6406                	ld	s0,64(sp)
    80004170:	74e2                	ld	s1,56(sp)
    80004172:	7942                	ld	s2,48(sp)
    80004174:	79a2                	ld	s3,40(sp)
    80004176:	7a02                	ld	s4,32(sp)
    80004178:	6ae2                	ld	s5,24(sp)
    8000417a:	6b42                	ld	s6,16(sp)
    8000417c:	6161                	addi	sp,sp,80
    8000417e:	8082                	ret
      release(&pi->lock);
    80004180:	8526                	mv	a0,s1
    80004182:	00002097          	auipc	ra,0x2
    80004186:	1d6080e7          	jalr	470(ra) # 80006358 <release>
      return -1;
    8000418a:	59fd                	li	s3,-1
    8000418c:	bff9                	j	8000416a <piperead+0xca>

000000008000418e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000418e:	1141                	addi	sp,sp,-16
    80004190:	e422                	sd	s0,8(sp)
    80004192:	0800                	addi	s0,sp,16
    80004194:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004196:	8905                	andi	a0,a0,1
    80004198:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000419a:	8b89                	andi	a5,a5,2
    8000419c:	c399                	beqz	a5,800041a2 <flags2perm+0x14>
      perm |= PTE_W;
    8000419e:	00456513          	ori	a0,a0,4
    return perm;
}
    800041a2:	6422                	ld	s0,8(sp)
    800041a4:	0141                	addi	sp,sp,16
    800041a6:	8082                	ret

00000000800041a8 <exec>:

int
exec(char *path, char **argv)
{
    800041a8:	de010113          	addi	sp,sp,-544
    800041ac:	20113c23          	sd	ra,536(sp)
    800041b0:	20813823          	sd	s0,528(sp)
    800041b4:	20913423          	sd	s1,520(sp)
    800041b8:	21213023          	sd	s2,512(sp)
    800041bc:	ffce                	sd	s3,504(sp)
    800041be:	fbd2                	sd	s4,496(sp)
    800041c0:	f7d6                	sd	s5,488(sp)
    800041c2:	f3da                	sd	s6,480(sp)
    800041c4:	efde                	sd	s7,472(sp)
    800041c6:	ebe2                	sd	s8,464(sp)
    800041c8:	e7e6                	sd	s9,456(sp)
    800041ca:	e3ea                	sd	s10,448(sp)
    800041cc:	ff6e                	sd	s11,440(sp)
    800041ce:	1400                	addi	s0,sp,544
    800041d0:	892a                	mv	s2,a0
    800041d2:	dea43423          	sd	a0,-536(s0)
    800041d6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	d82080e7          	jalr	-638(ra) # 80000f5c <myproc>
    800041e2:	84aa                	mv	s1,a0

  begin_op();
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	482080e7          	jalr	1154(ra) # 80003666 <begin_op>

  if((ip = namei(path)) == 0){
    800041ec:	854a                	mv	a0,s2
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	258080e7          	jalr	600(ra) # 80003446 <namei>
    800041f6:	c93d                	beqz	a0,8000426c <exec+0xc4>
    800041f8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	aa0080e7          	jalr	-1376(ra) # 80002c9a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004202:	04000713          	li	a4,64
    80004206:	4681                	li	a3,0
    80004208:	e5040613          	addi	a2,s0,-432
    8000420c:	4581                	li	a1,0
    8000420e:	8556                	mv	a0,s5
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	d3e080e7          	jalr	-706(ra) # 80002f4e <readi>
    80004218:	04000793          	li	a5,64
    8000421c:	00f51a63          	bne	a0,a5,80004230 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004220:	e5042703          	lw	a4,-432(s0)
    80004224:	464c47b7          	lui	a5,0x464c4
    80004228:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000422c:	04f70663          	beq	a4,a5,80004278 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004230:	8556                	mv	a0,s5
    80004232:	fffff097          	auipc	ra,0xfffff
    80004236:	cca080e7          	jalr	-822(ra) # 80002efc <iunlockput>
    end_op();
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	4aa080e7          	jalr	1194(ra) # 800036e4 <end_op>
  }
  return -1;
    80004242:	557d                	li	a0,-1
}
    80004244:	21813083          	ld	ra,536(sp)
    80004248:	21013403          	ld	s0,528(sp)
    8000424c:	20813483          	ld	s1,520(sp)
    80004250:	20013903          	ld	s2,512(sp)
    80004254:	79fe                	ld	s3,504(sp)
    80004256:	7a5e                	ld	s4,496(sp)
    80004258:	7abe                	ld	s5,488(sp)
    8000425a:	7b1e                	ld	s6,480(sp)
    8000425c:	6bfe                	ld	s7,472(sp)
    8000425e:	6c5e                	ld	s8,464(sp)
    80004260:	6cbe                	ld	s9,456(sp)
    80004262:	6d1e                	ld	s10,448(sp)
    80004264:	7dfa                	ld	s11,440(sp)
    80004266:	22010113          	addi	sp,sp,544
    8000426a:	8082                	ret
    end_op();
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	478080e7          	jalr	1144(ra) # 800036e4 <end_op>
    return -1;
    80004274:	557d                	li	a0,-1
    80004276:	b7f9                	j	80004244 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004278:	8526                	mv	a0,s1
    8000427a:	ffffd097          	auipc	ra,0xffffd
    8000427e:	da6080e7          	jalr	-602(ra) # 80001020 <proc_pagetable>
    80004282:	8b2a                	mv	s6,a0
    80004284:	d555                	beqz	a0,80004230 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004286:	e7042783          	lw	a5,-400(s0)
    8000428a:	e8845703          	lhu	a4,-376(s0)
    8000428e:	c735                	beqz	a4,800042fa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004290:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004292:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004296:	6a05                	lui	s4,0x1
    80004298:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000429c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042a0:	6d85                	lui	s11,0x1
    800042a2:	7d7d                	lui	s10,0xfffff
    800042a4:	ac99                	j	800044fa <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042a6:	00004517          	auipc	a0,0x4
    800042aa:	45250513          	addi	a0,a0,1106 # 800086f8 <syscalls+0x2c8>
    800042ae:	00002097          	auipc	ra,0x2
    800042b2:	abe080e7          	jalr	-1346(ra) # 80005d6c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042b6:	874a                	mv	a4,s2
    800042b8:	009c86bb          	addw	a3,s9,s1
    800042bc:	4581                	li	a1,0
    800042be:	8556                	mv	a0,s5
    800042c0:	fffff097          	auipc	ra,0xfffff
    800042c4:	c8e080e7          	jalr	-882(ra) # 80002f4e <readi>
    800042c8:	2501                	sext.w	a0,a0
    800042ca:	1ca91563          	bne	s2,a0,80004494 <exec+0x2ec>
  for(i = 0; i < sz; i += PGSIZE){
    800042ce:	009d84bb          	addw	s1,s11,s1
    800042d2:	013d09bb          	addw	s3,s10,s3
    800042d6:	2174f263          	bgeu	s1,s7,800044da <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    800042da:	02049593          	slli	a1,s1,0x20
    800042de:	9181                	srli	a1,a1,0x20
    800042e0:	95e2                	add	a1,a1,s8
    800042e2:	855a                	mv	a0,s6
    800042e4:	ffffc097          	auipc	ra,0xffffc
    800042e8:	220080e7          	jalr	544(ra) # 80000504 <walkaddr>
    800042ec:	862a                	mv	a2,a0
    if(pa == 0)
    800042ee:	dd45                	beqz	a0,800042a6 <exec+0xfe>
      n = PGSIZE;
    800042f0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042f2:	fd49f2e3          	bgeu	s3,s4,800042b6 <exec+0x10e>
      n = sz - i;
    800042f6:	894e                	mv	s2,s3
    800042f8:	bf7d                	j	800042b6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042fa:	4901                	li	s2,0
  iunlockput(ip);
    800042fc:	8556                	mv	a0,s5
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	bfe080e7          	jalr	-1026(ra) # 80002efc <iunlockput>
  end_op();
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	3de080e7          	jalr	990(ra) # 800036e4 <end_op>
  p = myproc();
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	c4e080e7          	jalr	-946(ra) # 80000f5c <myproc>
    80004316:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004318:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000431c:	6785                	lui	a5,0x1
    8000431e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004320:	97ca                	add	a5,a5,s2
    80004322:	777d                	lui	a4,0xfffff
    80004324:	8ff9                	and	a5,a5,a4
    80004326:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000432a:	4691                	li	a3,4
    8000432c:	6609                	lui	a2,0x2
    8000432e:	963e                	add	a2,a2,a5
    80004330:	85be                	mv	a1,a5
    80004332:	855a                	mv	a0,s6
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	584080e7          	jalr	1412(ra) # 800008b8 <uvmalloc>
    8000433c:	8c2a                	mv	s8,a0
  ip = 0;
    8000433e:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004340:	14050a63          	beqz	a0,80004494 <exec+0x2ec>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004344:	75f9                	lui	a1,0xffffe
    80004346:	95aa                	add	a1,a1,a0
    80004348:	855a                	mv	a0,s6
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	798080e7          	jalr	1944(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004352:	7afd                	lui	s5,0xfffff
    80004354:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004356:	df043783          	ld	a5,-528(s0)
    8000435a:	6388                	ld	a0,0(a5)
    8000435c:	c925                	beqz	a0,800043cc <exec+0x224>
    8000435e:	e9040993          	addi	s3,s0,-368
    80004362:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004366:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004368:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	f8c080e7          	jalr	-116(ra) # 800002f6 <strlen>
    80004372:	0015079b          	addiw	a5,a0,1
    80004376:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000437a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000437e:	15596263          	bltu	s2,s5,800044c2 <exec+0x31a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004382:	df043d83          	ld	s11,-528(s0)
    80004386:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000438a:	8552                	mv	a0,s4
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	f6a080e7          	jalr	-150(ra) # 800002f6 <strlen>
    80004394:	0015069b          	addiw	a3,a0,1
    80004398:	8652                	mv	a2,s4
    8000439a:	85ca                	mv	a1,s2
    8000439c:	855a                	mv	a0,s6
    8000439e:	ffffc097          	auipc	ra,0xffffc
    800043a2:	776080e7          	jalr	1910(ra) # 80000b14 <copyout>
    800043a6:	12054263          	bltz	a0,800044ca <exec+0x322>
    ustack[argc] = sp;
    800043aa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ae:	0485                	addi	s1,s1,1
    800043b0:	008d8793          	addi	a5,s11,8
    800043b4:	def43823          	sd	a5,-528(s0)
    800043b8:	008db503          	ld	a0,8(s11)
    800043bc:	c911                	beqz	a0,800043d0 <exec+0x228>
    if(argc >= MAXARG)
    800043be:	09a1                	addi	s3,s3,8
    800043c0:	fb3c95e3          	bne	s9,s3,8000436a <exec+0x1c2>
  sz = sz1;
    800043c4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c8:	4a81                	li	s5,0
    800043ca:	a0e9                	j	80004494 <exec+0x2ec>
  sp = sz;
    800043cc:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043ce:	4481                	li	s1,0
  ustack[argc] = 0;
    800043d0:	00349793          	slli	a5,s1,0x3
    800043d4:	f9078793          	addi	a5,a5,-112
    800043d8:	97a2                	add	a5,a5,s0
    800043da:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043de:	00148693          	addi	a3,s1,1
    800043e2:	068e                	slli	a3,a3,0x3
    800043e4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043e8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ec:	01597663          	bgeu	s2,s5,800043f8 <exec+0x250>
  sz = sz1;
    800043f0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043f4:	4a81                	li	s5,0
    800043f6:	a879                	j	80004494 <exec+0x2ec>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043f8:	e9040613          	addi	a2,s0,-368
    800043fc:	85ca                	mv	a1,s2
    800043fe:	855a                	mv	a0,s6
    80004400:	ffffc097          	auipc	ra,0xffffc
    80004404:	714080e7          	jalr	1812(ra) # 80000b14 <copyout>
    80004408:	0c054563          	bltz	a0,800044d2 <exec+0x32a>
  p->trapframe->a1 = sp;
    8000440c:	058bb783          	ld	a5,88(s7)
    80004410:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004414:	de843783          	ld	a5,-536(s0)
    80004418:	0007c703          	lbu	a4,0(a5)
    8000441c:	cf11                	beqz	a4,80004438 <exec+0x290>
    8000441e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004420:	02f00693          	li	a3,47
    80004424:	a039                	j	80004432 <exec+0x28a>
      last = s+1;
    80004426:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000442a:	0785                	addi	a5,a5,1
    8000442c:	fff7c703          	lbu	a4,-1(a5)
    80004430:	c701                	beqz	a4,80004438 <exec+0x290>
    if(*s == '/')
    80004432:	fed71ce3          	bne	a4,a3,8000442a <exec+0x282>
    80004436:	bfc5                	j	80004426 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004438:	4641                	li	a2,16
    8000443a:	de843583          	ld	a1,-536(s0)
    8000443e:	160b8513          	addi	a0,s7,352
    80004442:	ffffc097          	auipc	ra,0xffffc
    80004446:	e82080e7          	jalr	-382(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    8000444a:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000444e:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004452:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004456:	058bb783          	ld	a5,88(s7)
    8000445a:	e6843703          	ld	a4,-408(s0)
    8000445e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004460:	058bb783          	ld	a5,88(s7)
    80004464:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004468:	85ea                	mv	a1,s10
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	cac080e7          	jalr	-852(ra) # 80001116 <proc_freepagetable>
  if (p->pid == 1) {
    80004472:	030ba703          	lw	a4,48(s7)
    80004476:	4785                	li	a5,1
    80004478:	00f70563          	beq	a4,a5,80004482 <exec+0x2da>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000447c:	0004851b          	sext.w	a0,s1
    80004480:	b3d1                	j	80004244 <exec+0x9c>
  	vmprint(p->pagetable);
    80004482:	050bb503          	ld	a0,80(s7)
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	930080e7          	jalr	-1744(ra) # 80000db6 <vmprint>
    8000448e:	b7fd                	j	8000447c <exec+0x2d4>
    80004490:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004494:	df843583          	ld	a1,-520(s0)
    80004498:	855a                	mv	a0,s6
    8000449a:	ffffd097          	auipc	ra,0xffffd
    8000449e:	c7c080e7          	jalr	-900(ra) # 80001116 <proc_freepagetable>
  if(ip){
    800044a2:	d80a97e3          	bnez	s5,80004230 <exec+0x88>
  return -1;
    800044a6:	557d                	li	a0,-1
    800044a8:	bb71                	j	80004244 <exec+0x9c>
    800044aa:	df243c23          	sd	s2,-520(s0)
    800044ae:	b7dd                	j	80004494 <exec+0x2ec>
    800044b0:	df243c23          	sd	s2,-520(s0)
    800044b4:	b7c5                	j	80004494 <exec+0x2ec>
    800044b6:	df243c23          	sd	s2,-520(s0)
    800044ba:	bfe9                	j	80004494 <exec+0x2ec>
    800044bc:	df243c23          	sd	s2,-520(s0)
    800044c0:	bfd1                	j	80004494 <exec+0x2ec>
  sz = sz1;
    800044c2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044c6:	4a81                	li	s5,0
    800044c8:	b7f1                	j	80004494 <exec+0x2ec>
  sz = sz1;
    800044ca:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044ce:	4a81                	li	s5,0
    800044d0:	b7d1                	j	80004494 <exec+0x2ec>
  sz = sz1;
    800044d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044d6:	4a81                	li	s5,0
    800044d8:	bf75                	j	80004494 <exec+0x2ec>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044da:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044de:	e0843783          	ld	a5,-504(s0)
    800044e2:	0017869b          	addiw	a3,a5,1
    800044e6:	e0d43423          	sd	a3,-504(s0)
    800044ea:	e0043783          	ld	a5,-512(s0)
    800044ee:	0387879b          	addiw	a5,a5,56
    800044f2:	e8845703          	lhu	a4,-376(s0)
    800044f6:	e0e6d3e3          	bge	a3,a4,800042fc <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044fa:	2781                	sext.w	a5,a5
    800044fc:	e0f43023          	sd	a5,-512(s0)
    80004500:	03800713          	li	a4,56
    80004504:	86be                	mv	a3,a5
    80004506:	e1840613          	addi	a2,s0,-488
    8000450a:	4581                	li	a1,0
    8000450c:	8556                	mv	a0,s5
    8000450e:	fffff097          	auipc	ra,0xfffff
    80004512:	a40080e7          	jalr	-1472(ra) # 80002f4e <readi>
    80004516:	03800793          	li	a5,56
    8000451a:	f6f51be3          	bne	a0,a5,80004490 <exec+0x2e8>
    if(ph.type != ELF_PROG_LOAD)
    8000451e:	e1842783          	lw	a5,-488(s0)
    80004522:	4705                	li	a4,1
    80004524:	fae79de3          	bne	a5,a4,800044de <exec+0x336>
    if(ph.memsz < ph.filesz)
    80004528:	e4043483          	ld	s1,-448(s0)
    8000452c:	e3843783          	ld	a5,-456(s0)
    80004530:	f6f4ede3          	bltu	s1,a5,800044aa <exec+0x302>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004534:	e2843783          	ld	a5,-472(s0)
    80004538:	94be                	add	s1,s1,a5
    8000453a:	f6f4ebe3          	bltu	s1,a5,800044b0 <exec+0x308>
    if(ph.vaddr % PGSIZE != 0)
    8000453e:	de043703          	ld	a4,-544(s0)
    80004542:	8ff9                	and	a5,a5,a4
    80004544:	fbad                	bnez	a5,800044b6 <exec+0x30e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004546:	e1c42503          	lw	a0,-484(s0)
    8000454a:	00000097          	auipc	ra,0x0
    8000454e:	c44080e7          	jalr	-956(ra) # 8000418e <flags2perm>
    80004552:	86aa                	mv	a3,a0
    80004554:	8626                	mv	a2,s1
    80004556:	85ca                	mv	a1,s2
    80004558:	855a                	mv	a0,s6
    8000455a:	ffffc097          	auipc	ra,0xffffc
    8000455e:	35e080e7          	jalr	862(ra) # 800008b8 <uvmalloc>
    80004562:	dea43c23          	sd	a0,-520(s0)
    80004566:	d939                	beqz	a0,800044bc <exec+0x314>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004568:	e2843c03          	ld	s8,-472(s0)
    8000456c:	e2042c83          	lw	s9,-480(s0)
    80004570:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004574:	f60b83e3          	beqz	s7,800044da <exec+0x332>
    80004578:	89de                	mv	s3,s7
    8000457a:	4481                	li	s1,0
    8000457c:	bbb9                	j	800042da <exec+0x132>

000000008000457e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000457e:	7179                	addi	sp,sp,-48
    80004580:	f406                	sd	ra,40(sp)
    80004582:	f022                	sd	s0,32(sp)
    80004584:	ec26                	sd	s1,24(sp)
    80004586:	e84a                	sd	s2,16(sp)
    80004588:	1800                	addi	s0,sp,48
    8000458a:	892e                	mv	s2,a1
    8000458c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000458e:	fdc40593          	addi	a1,s0,-36
    80004592:	ffffe097          	auipc	ra,0xffffe
    80004596:	b90080e7          	jalr	-1136(ra) # 80002122 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000459a:	fdc42703          	lw	a4,-36(s0)
    8000459e:	47bd                	li	a5,15
    800045a0:	02e7eb63          	bltu	a5,a4,800045d6 <argfd+0x58>
    800045a4:	ffffd097          	auipc	ra,0xffffd
    800045a8:	9b8080e7          	jalr	-1608(ra) # 80000f5c <myproc>
    800045ac:	fdc42703          	lw	a4,-36(s0)
    800045b0:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd01a>
    800045b4:	078e                	slli	a5,a5,0x3
    800045b6:	953e                	add	a0,a0,a5
    800045b8:	651c                	ld	a5,8(a0)
    800045ba:	c385                	beqz	a5,800045da <argfd+0x5c>
    return -1;
  if(pfd)
    800045bc:	00090463          	beqz	s2,800045c4 <argfd+0x46>
    *pfd = fd;
    800045c0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045c4:	4501                	li	a0,0
  if(pf)
    800045c6:	c091                	beqz	s1,800045ca <argfd+0x4c>
    *pf = f;
    800045c8:	e09c                	sd	a5,0(s1)
}
    800045ca:	70a2                	ld	ra,40(sp)
    800045cc:	7402                	ld	s0,32(sp)
    800045ce:	64e2                	ld	s1,24(sp)
    800045d0:	6942                	ld	s2,16(sp)
    800045d2:	6145                	addi	sp,sp,48
    800045d4:	8082                	ret
    return -1;
    800045d6:	557d                	li	a0,-1
    800045d8:	bfcd                	j	800045ca <argfd+0x4c>
    800045da:	557d                	li	a0,-1
    800045dc:	b7fd                	j	800045ca <argfd+0x4c>

00000000800045de <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045de:	1101                	addi	sp,sp,-32
    800045e0:	ec06                	sd	ra,24(sp)
    800045e2:	e822                	sd	s0,16(sp)
    800045e4:	e426                	sd	s1,8(sp)
    800045e6:	1000                	addi	s0,sp,32
    800045e8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045ea:	ffffd097          	auipc	ra,0xffffd
    800045ee:	972080e7          	jalr	-1678(ra) # 80000f5c <myproc>
    800045f2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045f4:	0d850793          	addi	a5,a0,216
    800045f8:	4501                	li	a0,0
    800045fa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045fc:	6398                	ld	a4,0(a5)
    800045fe:	cb19                	beqz	a4,80004614 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004600:	2505                	addiw	a0,a0,1
    80004602:	07a1                	addi	a5,a5,8
    80004604:	fed51ce3          	bne	a0,a3,800045fc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004608:	557d                	li	a0,-1
}
    8000460a:	60e2                	ld	ra,24(sp)
    8000460c:	6442                	ld	s0,16(sp)
    8000460e:	64a2                	ld	s1,8(sp)
    80004610:	6105                	addi	sp,sp,32
    80004612:	8082                	ret
      p->ofile[fd] = f;
    80004614:	01a50793          	addi	a5,a0,26
    80004618:	078e                	slli	a5,a5,0x3
    8000461a:	963e                	add	a2,a2,a5
    8000461c:	e604                	sd	s1,8(a2)
      return fd;
    8000461e:	b7f5                	j	8000460a <fdalloc+0x2c>

0000000080004620 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004620:	715d                	addi	sp,sp,-80
    80004622:	e486                	sd	ra,72(sp)
    80004624:	e0a2                	sd	s0,64(sp)
    80004626:	fc26                	sd	s1,56(sp)
    80004628:	f84a                	sd	s2,48(sp)
    8000462a:	f44e                	sd	s3,40(sp)
    8000462c:	f052                	sd	s4,32(sp)
    8000462e:	ec56                	sd	s5,24(sp)
    80004630:	e85a                	sd	s6,16(sp)
    80004632:	0880                	addi	s0,sp,80
    80004634:	8b2e                	mv	s6,a1
    80004636:	89b2                	mv	s3,a2
    80004638:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000463a:	fb040593          	addi	a1,s0,-80
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	e26080e7          	jalr	-474(ra) # 80003464 <nameiparent>
    80004646:	84aa                	mv	s1,a0
    80004648:	14050f63          	beqz	a0,800047a6 <create+0x186>
    return 0;

  ilock(dp);
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	64e080e7          	jalr	1614(ra) # 80002c9a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004654:	4601                	li	a2,0
    80004656:	fb040593          	addi	a1,s0,-80
    8000465a:	8526                	mv	a0,s1
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	b22080e7          	jalr	-1246(ra) # 8000317e <dirlookup>
    80004664:	8aaa                	mv	s5,a0
    80004666:	c931                	beqz	a0,800046ba <create+0x9a>
    iunlockput(dp);
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	892080e7          	jalr	-1902(ra) # 80002efc <iunlockput>
    ilock(ip);
    80004672:	8556                	mv	a0,s5
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	626080e7          	jalr	1574(ra) # 80002c9a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000467c:	000b059b          	sext.w	a1,s6
    80004680:	4789                	li	a5,2
    80004682:	02f59563          	bne	a1,a5,800046ac <create+0x8c>
    80004686:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd044>
    8000468a:	37f9                	addiw	a5,a5,-2
    8000468c:	17c2                	slli	a5,a5,0x30
    8000468e:	93c1                	srli	a5,a5,0x30
    80004690:	4705                	li	a4,1
    80004692:	00f76d63          	bltu	a4,a5,800046ac <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004696:	8556                	mv	a0,s5
    80004698:	60a6                	ld	ra,72(sp)
    8000469a:	6406                	ld	s0,64(sp)
    8000469c:	74e2                	ld	s1,56(sp)
    8000469e:	7942                	ld	s2,48(sp)
    800046a0:	79a2                	ld	s3,40(sp)
    800046a2:	7a02                	ld	s4,32(sp)
    800046a4:	6ae2                	ld	s5,24(sp)
    800046a6:	6b42                	ld	s6,16(sp)
    800046a8:	6161                	addi	sp,sp,80
    800046aa:	8082                	ret
    iunlockput(ip);
    800046ac:	8556                	mv	a0,s5
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	84e080e7          	jalr	-1970(ra) # 80002efc <iunlockput>
    return 0;
    800046b6:	4a81                	li	s5,0
    800046b8:	bff9                	j	80004696 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046ba:	85da                	mv	a1,s6
    800046bc:	4088                	lw	a0,0(s1)
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	43e080e7          	jalr	1086(ra) # 80002afc <ialloc>
    800046c6:	8a2a                	mv	s4,a0
    800046c8:	c539                	beqz	a0,80004716 <create+0xf6>
  ilock(ip);
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	5d0080e7          	jalr	1488(ra) # 80002c9a <ilock>
  ip->major = major;
    800046d2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046d6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046da:	4905                	li	s2,1
    800046dc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046e0:	8552                	mv	a0,s4
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	4ec080e7          	jalr	1260(ra) # 80002bce <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046ea:	000b059b          	sext.w	a1,s6
    800046ee:	03258b63          	beq	a1,s2,80004724 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f2:	004a2603          	lw	a2,4(s4)
    800046f6:	fb040593          	addi	a1,s0,-80
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	c98080e7          	jalr	-872(ra) # 80003394 <dirlink>
    80004704:	06054f63          	bltz	a0,80004782 <create+0x162>
  iunlockput(dp);
    80004708:	8526                	mv	a0,s1
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	7f2080e7          	jalr	2034(ra) # 80002efc <iunlockput>
  return ip;
    80004712:	8ad2                	mv	s5,s4
    80004714:	b749                	j	80004696 <create+0x76>
    iunlockput(dp);
    80004716:	8526                	mv	a0,s1
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	7e4080e7          	jalr	2020(ra) # 80002efc <iunlockput>
    return 0;
    80004720:	8ad2                	mv	s5,s4
    80004722:	bf95                	j	80004696 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004724:	004a2603          	lw	a2,4(s4)
    80004728:	00004597          	auipc	a1,0x4
    8000472c:	ff058593          	addi	a1,a1,-16 # 80008718 <syscalls+0x2e8>
    80004730:	8552                	mv	a0,s4
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	c62080e7          	jalr	-926(ra) # 80003394 <dirlink>
    8000473a:	04054463          	bltz	a0,80004782 <create+0x162>
    8000473e:	40d0                	lw	a2,4(s1)
    80004740:	00004597          	auipc	a1,0x4
    80004744:	fe058593          	addi	a1,a1,-32 # 80008720 <syscalls+0x2f0>
    80004748:	8552                	mv	a0,s4
    8000474a:	fffff097          	auipc	ra,0xfffff
    8000474e:	c4a080e7          	jalr	-950(ra) # 80003394 <dirlink>
    80004752:	02054863          	bltz	a0,80004782 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004756:	004a2603          	lw	a2,4(s4)
    8000475a:	fb040593          	addi	a1,s0,-80
    8000475e:	8526                	mv	a0,s1
    80004760:	fffff097          	auipc	ra,0xfffff
    80004764:	c34080e7          	jalr	-972(ra) # 80003394 <dirlink>
    80004768:	00054d63          	bltz	a0,80004782 <create+0x162>
    dp->nlink++;  // for ".."
    8000476c:	04a4d783          	lhu	a5,74(s1)
    80004770:	2785                	addiw	a5,a5,1
    80004772:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004776:	8526                	mv	a0,s1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	456080e7          	jalr	1110(ra) # 80002bce <iupdate>
    80004780:	b761                	j	80004708 <create+0xe8>
  ip->nlink = 0;
    80004782:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004786:	8552                	mv	a0,s4
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	446080e7          	jalr	1094(ra) # 80002bce <iupdate>
  iunlockput(ip);
    80004790:	8552                	mv	a0,s4
    80004792:	ffffe097          	auipc	ra,0xffffe
    80004796:	76a080e7          	jalr	1898(ra) # 80002efc <iunlockput>
  iunlockput(dp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	760080e7          	jalr	1888(ra) # 80002efc <iunlockput>
  return 0;
    800047a4:	bdcd                	j	80004696 <create+0x76>
    return 0;
    800047a6:	8aaa                	mv	s5,a0
    800047a8:	b5fd                	j	80004696 <create+0x76>

00000000800047aa <sys_dup>:
{
    800047aa:	7179                	addi	sp,sp,-48
    800047ac:	f406                	sd	ra,40(sp)
    800047ae:	f022                	sd	s0,32(sp)
    800047b0:	ec26                	sd	s1,24(sp)
    800047b2:	e84a                	sd	s2,16(sp)
    800047b4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047b6:	fd840613          	addi	a2,s0,-40
    800047ba:	4581                	li	a1,0
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	dc0080e7          	jalr	-576(ra) # 8000457e <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047c8:	02054363          	bltz	a0,800047ee <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047cc:	fd843903          	ld	s2,-40(s0)
    800047d0:	854a                	mv	a0,s2
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	e0c080e7          	jalr	-500(ra) # 800045de <fdalloc>
    800047da:	84aa                	mv	s1,a0
    return -1;
    800047dc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047de:	00054863          	bltz	a0,800047ee <sys_dup+0x44>
  filedup(f);
    800047e2:	854a                	mv	a0,s2
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	2f8080e7          	jalr	760(ra) # 80003adc <filedup>
  return fd;
    800047ec:	87a6                	mv	a5,s1
}
    800047ee:	853e                	mv	a0,a5
    800047f0:	70a2                	ld	ra,40(sp)
    800047f2:	7402                	ld	s0,32(sp)
    800047f4:	64e2                	ld	s1,24(sp)
    800047f6:	6942                	ld	s2,16(sp)
    800047f8:	6145                	addi	sp,sp,48
    800047fa:	8082                	ret

00000000800047fc <sys_read>:
{
    800047fc:	7179                	addi	sp,sp,-48
    800047fe:	f406                	sd	ra,40(sp)
    80004800:	f022                	sd	s0,32(sp)
    80004802:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004804:	fd840593          	addi	a1,s0,-40
    80004808:	4505                	li	a0,1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	938080e7          	jalr	-1736(ra) # 80002142 <argaddr>
  argint(2, &n);
    80004812:	fe440593          	addi	a1,s0,-28
    80004816:	4509                	li	a0,2
    80004818:	ffffe097          	auipc	ra,0xffffe
    8000481c:	90a080e7          	jalr	-1782(ra) # 80002122 <argint>
  if(argfd(0, 0, &f) < 0)
    80004820:	fe840613          	addi	a2,s0,-24
    80004824:	4581                	li	a1,0
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	d56080e7          	jalr	-682(ra) # 8000457e <argfd>
    80004830:	87aa                	mv	a5,a0
    return -1;
    80004832:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004834:	0007cc63          	bltz	a5,8000484c <sys_read+0x50>
  return fileread(f, p, n);
    80004838:	fe442603          	lw	a2,-28(s0)
    8000483c:	fd843583          	ld	a1,-40(s0)
    80004840:	fe843503          	ld	a0,-24(s0)
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	424080e7          	jalr	1060(ra) # 80003c68 <fileread>
}
    8000484c:	70a2                	ld	ra,40(sp)
    8000484e:	7402                	ld	s0,32(sp)
    80004850:	6145                	addi	sp,sp,48
    80004852:	8082                	ret

0000000080004854 <sys_write>:
{
    80004854:	7179                	addi	sp,sp,-48
    80004856:	f406                	sd	ra,40(sp)
    80004858:	f022                	sd	s0,32(sp)
    8000485a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000485c:	fd840593          	addi	a1,s0,-40
    80004860:	4505                	li	a0,1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	8e0080e7          	jalr	-1824(ra) # 80002142 <argaddr>
  argint(2, &n);
    8000486a:	fe440593          	addi	a1,s0,-28
    8000486e:	4509                	li	a0,2
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	8b2080e7          	jalr	-1870(ra) # 80002122 <argint>
  if(argfd(0, 0, &f) < 0)
    80004878:	fe840613          	addi	a2,s0,-24
    8000487c:	4581                	li	a1,0
    8000487e:	4501                	li	a0,0
    80004880:	00000097          	auipc	ra,0x0
    80004884:	cfe080e7          	jalr	-770(ra) # 8000457e <argfd>
    80004888:	87aa                	mv	a5,a0
    return -1;
    8000488a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000488c:	0007cc63          	bltz	a5,800048a4 <sys_write+0x50>
  return filewrite(f, p, n);
    80004890:	fe442603          	lw	a2,-28(s0)
    80004894:	fd843583          	ld	a1,-40(s0)
    80004898:	fe843503          	ld	a0,-24(s0)
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	48e080e7          	jalr	1166(ra) # 80003d2a <filewrite>
}
    800048a4:	70a2                	ld	ra,40(sp)
    800048a6:	7402                	ld	s0,32(sp)
    800048a8:	6145                	addi	sp,sp,48
    800048aa:	8082                	ret

00000000800048ac <sys_close>:
{
    800048ac:	1101                	addi	sp,sp,-32
    800048ae:	ec06                	sd	ra,24(sp)
    800048b0:	e822                	sd	s0,16(sp)
    800048b2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048b4:	fe040613          	addi	a2,s0,-32
    800048b8:	fec40593          	addi	a1,s0,-20
    800048bc:	4501                	li	a0,0
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	cc0080e7          	jalr	-832(ra) # 8000457e <argfd>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048c8:	02054463          	bltz	a0,800048f0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048cc:	ffffc097          	auipc	ra,0xffffc
    800048d0:	690080e7          	jalr	1680(ra) # 80000f5c <myproc>
    800048d4:	fec42783          	lw	a5,-20(s0)
    800048d8:	07e9                	addi	a5,a5,26
    800048da:	078e                	slli	a5,a5,0x3
    800048dc:	953e                	add	a0,a0,a5
    800048de:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800048e2:	fe043503          	ld	a0,-32(s0)
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	248080e7          	jalr	584(ra) # 80003b2e <fileclose>
  return 0;
    800048ee:	4781                	li	a5,0
}
    800048f0:	853e                	mv	a0,a5
    800048f2:	60e2                	ld	ra,24(sp)
    800048f4:	6442                	ld	s0,16(sp)
    800048f6:	6105                	addi	sp,sp,32
    800048f8:	8082                	ret

00000000800048fa <sys_fstat>:
{
    800048fa:	1101                	addi	sp,sp,-32
    800048fc:	ec06                	sd	ra,24(sp)
    800048fe:	e822                	sd	s0,16(sp)
    80004900:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004902:	fe040593          	addi	a1,s0,-32
    80004906:	4505                	li	a0,1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	83a080e7          	jalr	-1990(ra) # 80002142 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004910:	fe840613          	addi	a2,s0,-24
    80004914:	4581                	li	a1,0
    80004916:	4501                	li	a0,0
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	c66080e7          	jalr	-922(ra) # 8000457e <argfd>
    80004920:	87aa                	mv	a5,a0
    return -1;
    80004922:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004924:	0007ca63          	bltz	a5,80004938 <sys_fstat+0x3e>
  return filestat(f, st);
    80004928:	fe043583          	ld	a1,-32(s0)
    8000492c:	fe843503          	ld	a0,-24(s0)
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	2c6080e7          	jalr	710(ra) # 80003bf6 <filestat>
}
    80004938:	60e2                	ld	ra,24(sp)
    8000493a:	6442                	ld	s0,16(sp)
    8000493c:	6105                	addi	sp,sp,32
    8000493e:	8082                	ret

0000000080004940 <sys_link>:
{
    80004940:	7169                	addi	sp,sp,-304
    80004942:	f606                	sd	ra,296(sp)
    80004944:	f222                	sd	s0,288(sp)
    80004946:	ee26                	sd	s1,280(sp)
    80004948:	ea4a                	sd	s2,272(sp)
    8000494a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494c:	08000613          	li	a2,128
    80004950:	ed040593          	addi	a1,s0,-304
    80004954:	4501                	li	a0,0
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	80c080e7          	jalr	-2036(ra) # 80002162 <argstr>
    return -1;
    8000495e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004960:	10054e63          	bltz	a0,80004a7c <sys_link+0x13c>
    80004964:	08000613          	li	a2,128
    80004968:	f5040593          	addi	a1,s0,-176
    8000496c:	4505                	li	a0,1
    8000496e:	ffffd097          	auipc	ra,0xffffd
    80004972:	7f4080e7          	jalr	2036(ra) # 80002162 <argstr>
    return -1;
    80004976:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004978:	10054263          	bltz	a0,80004a7c <sys_link+0x13c>
  begin_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	cea080e7          	jalr	-790(ra) # 80003666 <begin_op>
  if((ip = namei(old)) == 0){
    80004984:	ed040513          	addi	a0,s0,-304
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	abe080e7          	jalr	-1346(ra) # 80003446 <namei>
    80004990:	84aa                	mv	s1,a0
    80004992:	c551                	beqz	a0,80004a1e <sys_link+0xde>
  ilock(ip);
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	306080e7          	jalr	774(ra) # 80002c9a <ilock>
  if(ip->type == T_DIR){
    8000499c:	04449703          	lh	a4,68(s1)
    800049a0:	4785                	li	a5,1
    800049a2:	08f70463          	beq	a4,a5,80004a2a <sys_link+0xea>
  ip->nlink++;
    800049a6:	04a4d783          	lhu	a5,74(s1)
    800049aa:	2785                	addiw	a5,a5,1
    800049ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	21c080e7          	jalr	540(ra) # 80002bce <iupdate>
  iunlock(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	3a0080e7          	jalr	928(ra) # 80002d5c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049c4:	fd040593          	addi	a1,s0,-48
    800049c8:	f5040513          	addi	a0,s0,-176
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	a98080e7          	jalr	-1384(ra) # 80003464 <nameiparent>
    800049d4:	892a                	mv	s2,a0
    800049d6:	c935                	beqz	a0,80004a4a <sys_link+0x10a>
  ilock(dp);
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	2c2080e7          	jalr	706(ra) # 80002c9a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049e0:	00092703          	lw	a4,0(s2)
    800049e4:	409c                	lw	a5,0(s1)
    800049e6:	04f71d63          	bne	a4,a5,80004a40 <sys_link+0x100>
    800049ea:	40d0                	lw	a2,4(s1)
    800049ec:	fd040593          	addi	a1,s0,-48
    800049f0:	854a                	mv	a0,s2
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	9a2080e7          	jalr	-1630(ra) # 80003394 <dirlink>
    800049fa:	04054363          	bltz	a0,80004a40 <sys_link+0x100>
  iunlockput(dp);
    800049fe:	854a                	mv	a0,s2
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	4fc080e7          	jalr	1276(ra) # 80002efc <iunlockput>
  iput(ip);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	44a080e7          	jalr	1098(ra) # 80002e54 <iput>
  end_op();
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	cd2080e7          	jalr	-814(ra) # 800036e4 <end_op>
  return 0;
    80004a1a:	4781                	li	a5,0
    80004a1c:	a085                	j	80004a7c <sys_link+0x13c>
    end_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	cc6080e7          	jalr	-826(ra) # 800036e4 <end_op>
    return -1;
    80004a26:	57fd                	li	a5,-1
    80004a28:	a891                	j	80004a7c <sys_link+0x13c>
    iunlockput(ip);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffe097          	auipc	ra,0xffffe
    80004a30:	4d0080e7          	jalr	1232(ra) # 80002efc <iunlockput>
    end_op();
    80004a34:	fffff097          	auipc	ra,0xfffff
    80004a38:	cb0080e7          	jalr	-848(ra) # 800036e4 <end_op>
    return -1;
    80004a3c:	57fd                	li	a5,-1
    80004a3e:	a83d                	j	80004a7c <sys_link+0x13c>
    iunlockput(dp);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	4ba080e7          	jalr	1210(ra) # 80002efc <iunlockput>
  ilock(ip);
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	24e080e7          	jalr	590(ra) # 80002c9a <ilock>
  ip->nlink--;
    80004a54:	04a4d783          	lhu	a5,74(s1)
    80004a58:	37fd                	addiw	a5,a5,-1
    80004a5a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	16e080e7          	jalr	366(ra) # 80002bce <iupdate>
  iunlockput(ip);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	492080e7          	jalr	1170(ra) # 80002efc <iunlockput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	c72080e7          	jalr	-910(ra) # 800036e4 <end_op>
  return -1;
    80004a7a:	57fd                	li	a5,-1
}
    80004a7c:	853e                	mv	a0,a5
    80004a7e:	70b2                	ld	ra,296(sp)
    80004a80:	7412                	ld	s0,288(sp)
    80004a82:	64f2                	ld	s1,280(sp)
    80004a84:	6952                	ld	s2,272(sp)
    80004a86:	6155                	addi	sp,sp,304
    80004a88:	8082                	ret

0000000080004a8a <sys_unlink>:
{
    80004a8a:	7151                	addi	sp,sp,-240
    80004a8c:	f586                	sd	ra,232(sp)
    80004a8e:	f1a2                	sd	s0,224(sp)
    80004a90:	eda6                	sd	s1,216(sp)
    80004a92:	e9ca                	sd	s2,208(sp)
    80004a94:	e5ce                	sd	s3,200(sp)
    80004a96:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a98:	08000613          	li	a2,128
    80004a9c:	f3040593          	addi	a1,s0,-208
    80004aa0:	4501                	li	a0,0
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	6c0080e7          	jalr	1728(ra) # 80002162 <argstr>
    80004aaa:	18054163          	bltz	a0,80004c2c <sys_unlink+0x1a2>
  begin_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	bb8080e7          	jalr	-1096(ra) # 80003666 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ab6:	fb040593          	addi	a1,s0,-80
    80004aba:	f3040513          	addi	a0,s0,-208
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	9a6080e7          	jalr	-1626(ra) # 80003464 <nameiparent>
    80004ac6:	84aa                	mv	s1,a0
    80004ac8:	c979                	beqz	a0,80004b9e <sys_unlink+0x114>
  ilock(dp);
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	1d0080e7          	jalr	464(ra) # 80002c9a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad2:	00004597          	auipc	a1,0x4
    80004ad6:	c4658593          	addi	a1,a1,-954 # 80008718 <syscalls+0x2e8>
    80004ada:	fb040513          	addi	a0,s0,-80
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	686080e7          	jalr	1670(ra) # 80003164 <namecmp>
    80004ae6:	14050a63          	beqz	a0,80004c3a <sys_unlink+0x1b0>
    80004aea:	00004597          	auipc	a1,0x4
    80004aee:	c3658593          	addi	a1,a1,-970 # 80008720 <syscalls+0x2f0>
    80004af2:	fb040513          	addi	a0,s0,-80
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	66e080e7          	jalr	1646(ra) # 80003164 <namecmp>
    80004afe:	12050e63          	beqz	a0,80004c3a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b02:	f2c40613          	addi	a2,s0,-212
    80004b06:	fb040593          	addi	a1,s0,-80
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	672080e7          	jalr	1650(ra) # 8000317e <dirlookup>
    80004b14:	892a                	mv	s2,a0
    80004b16:	12050263          	beqz	a0,80004c3a <sys_unlink+0x1b0>
  ilock(ip);
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	180080e7          	jalr	384(ra) # 80002c9a <ilock>
  if(ip->nlink < 1)
    80004b22:	04a91783          	lh	a5,74(s2)
    80004b26:	08f05263          	blez	a5,80004baa <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b2a:	04491703          	lh	a4,68(s2)
    80004b2e:	4785                	li	a5,1
    80004b30:	08f70563          	beq	a4,a5,80004bba <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b34:	4641                	li	a2,16
    80004b36:	4581                	li	a1,0
    80004b38:	fc040513          	addi	a0,s0,-64
    80004b3c:	ffffb097          	auipc	ra,0xffffb
    80004b40:	63e080e7          	jalr	1598(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b44:	4741                	li	a4,16
    80004b46:	f2c42683          	lw	a3,-212(s0)
    80004b4a:	fc040613          	addi	a2,s0,-64
    80004b4e:	4581                	li	a1,0
    80004b50:	8526                	mv	a0,s1
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	4f4080e7          	jalr	1268(ra) # 80003046 <writei>
    80004b5a:	47c1                	li	a5,16
    80004b5c:	0af51563          	bne	a0,a5,80004c06 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b60:	04491703          	lh	a4,68(s2)
    80004b64:	4785                	li	a5,1
    80004b66:	0af70863          	beq	a4,a5,80004c16 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	390080e7          	jalr	912(ra) # 80002efc <iunlockput>
  ip->nlink--;
    80004b74:	04a95783          	lhu	a5,74(s2)
    80004b78:	37fd                	addiw	a5,a5,-1
    80004b7a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b7e:	854a                	mv	a0,s2
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	04e080e7          	jalr	78(ra) # 80002bce <iupdate>
  iunlockput(ip);
    80004b88:	854a                	mv	a0,s2
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	372080e7          	jalr	882(ra) # 80002efc <iunlockput>
  end_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	b52080e7          	jalr	-1198(ra) # 800036e4 <end_op>
  return 0;
    80004b9a:	4501                	li	a0,0
    80004b9c:	a84d                	j	80004c4e <sys_unlink+0x1c4>
    end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	b46080e7          	jalr	-1210(ra) # 800036e4 <end_op>
    return -1;
    80004ba6:	557d                	li	a0,-1
    80004ba8:	a05d                	j	80004c4e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004baa:	00004517          	auipc	a0,0x4
    80004bae:	b7e50513          	addi	a0,a0,-1154 # 80008728 <syscalls+0x2f8>
    80004bb2:	00001097          	auipc	ra,0x1
    80004bb6:	1ba080e7          	jalr	442(ra) # 80005d6c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bba:	04c92703          	lw	a4,76(s2)
    80004bbe:	02000793          	li	a5,32
    80004bc2:	f6e7f9e3          	bgeu	a5,a4,80004b34 <sys_unlink+0xaa>
    80004bc6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bca:	4741                	li	a4,16
    80004bcc:	86ce                	mv	a3,s3
    80004bce:	f1840613          	addi	a2,s0,-232
    80004bd2:	4581                	li	a1,0
    80004bd4:	854a                	mv	a0,s2
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	378080e7          	jalr	888(ra) # 80002f4e <readi>
    80004bde:	47c1                	li	a5,16
    80004be0:	00f51b63          	bne	a0,a5,80004bf6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004be4:	f1845783          	lhu	a5,-232(s0)
    80004be8:	e7a1                	bnez	a5,80004c30 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bea:	29c1                	addiw	s3,s3,16
    80004bec:	04c92783          	lw	a5,76(s2)
    80004bf0:	fcf9ede3          	bltu	s3,a5,80004bca <sys_unlink+0x140>
    80004bf4:	b781                	j	80004b34 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bf6:	00004517          	auipc	a0,0x4
    80004bfa:	b4a50513          	addi	a0,a0,-1206 # 80008740 <syscalls+0x310>
    80004bfe:	00001097          	auipc	ra,0x1
    80004c02:	16e080e7          	jalr	366(ra) # 80005d6c <panic>
    panic("unlink: writei");
    80004c06:	00004517          	auipc	a0,0x4
    80004c0a:	b5250513          	addi	a0,a0,-1198 # 80008758 <syscalls+0x328>
    80004c0e:	00001097          	auipc	ra,0x1
    80004c12:	15e080e7          	jalr	350(ra) # 80005d6c <panic>
    dp->nlink--;
    80004c16:	04a4d783          	lhu	a5,74(s1)
    80004c1a:	37fd                	addiw	a5,a5,-1
    80004c1c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c20:	8526                	mv	a0,s1
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	fac080e7          	jalr	-84(ra) # 80002bce <iupdate>
    80004c2a:	b781                	j	80004b6a <sys_unlink+0xe0>
    return -1;
    80004c2c:	557d                	li	a0,-1
    80004c2e:	a005                	j	80004c4e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c30:	854a                	mv	a0,s2
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	2ca080e7          	jalr	714(ra) # 80002efc <iunlockput>
  iunlockput(dp);
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	2c0080e7          	jalr	704(ra) # 80002efc <iunlockput>
  end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	aa0080e7          	jalr	-1376(ra) # 800036e4 <end_op>
  return -1;
    80004c4c:	557d                	li	a0,-1
}
    80004c4e:	70ae                	ld	ra,232(sp)
    80004c50:	740e                	ld	s0,224(sp)
    80004c52:	64ee                	ld	s1,216(sp)
    80004c54:	694e                	ld	s2,208(sp)
    80004c56:	69ae                	ld	s3,200(sp)
    80004c58:	616d                	addi	sp,sp,240
    80004c5a:	8082                	ret

0000000080004c5c <sys_open>:

uint64
sys_open(void)
{
    80004c5c:	7131                	addi	sp,sp,-192
    80004c5e:	fd06                	sd	ra,184(sp)
    80004c60:	f922                	sd	s0,176(sp)
    80004c62:	f526                	sd	s1,168(sp)
    80004c64:	f14a                	sd	s2,160(sp)
    80004c66:	ed4e                	sd	s3,152(sp)
    80004c68:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c6a:	f4c40593          	addi	a1,s0,-180
    80004c6e:	4505                	li	a0,1
    80004c70:	ffffd097          	auipc	ra,0xffffd
    80004c74:	4b2080e7          	jalr	1202(ra) # 80002122 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c78:	08000613          	li	a2,128
    80004c7c:	f5040593          	addi	a1,s0,-176
    80004c80:	4501                	li	a0,0
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	4e0080e7          	jalr	1248(ra) # 80002162 <argstr>
    80004c8a:	87aa                	mv	a5,a0
    return -1;
    80004c8c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c8e:	0a07c963          	bltz	a5,80004d40 <sys_open+0xe4>

  begin_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	9d4080e7          	jalr	-1580(ra) # 80003666 <begin_op>

  if(omode & O_CREATE){
    80004c9a:	f4c42783          	lw	a5,-180(s0)
    80004c9e:	2007f793          	andi	a5,a5,512
    80004ca2:	cfc5                	beqz	a5,80004d5a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ca4:	4681                	li	a3,0
    80004ca6:	4601                	li	a2,0
    80004ca8:	4589                	li	a1,2
    80004caa:	f5040513          	addi	a0,s0,-176
    80004cae:	00000097          	auipc	ra,0x0
    80004cb2:	972080e7          	jalr	-1678(ra) # 80004620 <create>
    80004cb6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cb8:	c959                	beqz	a0,80004d4e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cba:	04449703          	lh	a4,68(s1)
    80004cbe:	478d                	li	a5,3
    80004cc0:	00f71763          	bne	a4,a5,80004cce <sys_open+0x72>
    80004cc4:	0464d703          	lhu	a4,70(s1)
    80004cc8:	47a5                	li	a5,9
    80004cca:	0ce7ed63          	bltu	a5,a4,80004da4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	da4080e7          	jalr	-604(ra) # 80003a72 <filealloc>
    80004cd6:	89aa                	mv	s3,a0
    80004cd8:	10050363          	beqz	a0,80004dde <sys_open+0x182>
    80004cdc:	00000097          	auipc	ra,0x0
    80004ce0:	902080e7          	jalr	-1790(ra) # 800045de <fdalloc>
    80004ce4:	892a                	mv	s2,a0
    80004ce6:	0e054763          	bltz	a0,80004dd4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cea:	04449703          	lh	a4,68(s1)
    80004cee:	478d                	li	a5,3
    80004cf0:	0cf70563          	beq	a4,a5,80004dba <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cf4:	4789                	li	a5,2
    80004cf6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cfa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cfe:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d02:	f4c42783          	lw	a5,-180(s0)
    80004d06:	0017c713          	xori	a4,a5,1
    80004d0a:	8b05                	andi	a4,a4,1
    80004d0c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d10:	0037f713          	andi	a4,a5,3
    80004d14:	00e03733          	snez	a4,a4
    80004d18:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d1c:	4007f793          	andi	a5,a5,1024
    80004d20:	c791                	beqz	a5,80004d2c <sys_open+0xd0>
    80004d22:	04449703          	lh	a4,68(s1)
    80004d26:	4789                	li	a5,2
    80004d28:	0af70063          	beq	a4,a5,80004dc8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d2c:	8526                	mv	a0,s1
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	02e080e7          	jalr	46(ra) # 80002d5c <iunlock>
  end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	9ae080e7          	jalr	-1618(ra) # 800036e4 <end_op>

  return fd;
    80004d3e:	854a                	mv	a0,s2
}
    80004d40:	70ea                	ld	ra,184(sp)
    80004d42:	744a                	ld	s0,176(sp)
    80004d44:	74aa                	ld	s1,168(sp)
    80004d46:	790a                	ld	s2,160(sp)
    80004d48:	69ea                	ld	s3,152(sp)
    80004d4a:	6129                	addi	sp,sp,192
    80004d4c:	8082                	ret
      end_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	996080e7          	jalr	-1642(ra) # 800036e4 <end_op>
      return -1;
    80004d56:	557d                	li	a0,-1
    80004d58:	b7e5                	j	80004d40 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d5a:	f5040513          	addi	a0,s0,-176
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	6e8080e7          	jalr	1768(ra) # 80003446 <namei>
    80004d66:	84aa                	mv	s1,a0
    80004d68:	c905                	beqz	a0,80004d98 <sys_open+0x13c>
    ilock(ip);
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	f30080e7          	jalr	-208(ra) # 80002c9a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d72:	04449703          	lh	a4,68(s1)
    80004d76:	4785                	li	a5,1
    80004d78:	f4f711e3          	bne	a4,a5,80004cba <sys_open+0x5e>
    80004d7c:	f4c42783          	lw	a5,-180(s0)
    80004d80:	d7b9                	beqz	a5,80004cce <sys_open+0x72>
      iunlockput(ip);
    80004d82:	8526                	mv	a0,s1
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	178080e7          	jalr	376(ra) # 80002efc <iunlockput>
      end_op();
    80004d8c:	fffff097          	auipc	ra,0xfffff
    80004d90:	958080e7          	jalr	-1704(ra) # 800036e4 <end_op>
      return -1;
    80004d94:	557d                	li	a0,-1
    80004d96:	b76d                	j	80004d40 <sys_open+0xe4>
      end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	94c080e7          	jalr	-1716(ra) # 800036e4 <end_op>
      return -1;
    80004da0:	557d                	li	a0,-1
    80004da2:	bf79                	j	80004d40 <sys_open+0xe4>
    iunlockput(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	156080e7          	jalr	342(ra) # 80002efc <iunlockput>
    end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	936080e7          	jalr	-1738(ra) # 800036e4 <end_op>
    return -1;
    80004db6:	557d                	li	a0,-1
    80004db8:	b761                	j	80004d40 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dba:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dbe:	04649783          	lh	a5,70(s1)
    80004dc2:	02f99223          	sh	a5,36(s3)
    80004dc6:	bf25                	j	80004cfe <sys_open+0xa2>
    itrunc(ip);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	fde080e7          	jalr	-34(ra) # 80002da8 <itrunc>
    80004dd2:	bfa9                	j	80004d2c <sys_open+0xd0>
      fileclose(f);
    80004dd4:	854e                	mv	a0,s3
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	d58080e7          	jalr	-680(ra) # 80003b2e <fileclose>
    iunlockput(ip);
    80004dde:	8526                	mv	a0,s1
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	11c080e7          	jalr	284(ra) # 80002efc <iunlockput>
    end_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	8fc080e7          	jalr	-1796(ra) # 800036e4 <end_op>
    return -1;
    80004df0:	557d                	li	a0,-1
    80004df2:	b7b9                	j	80004d40 <sys_open+0xe4>

0000000080004df4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004df4:	7175                	addi	sp,sp,-144
    80004df6:	e506                	sd	ra,136(sp)
    80004df8:	e122                	sd	s0,128(sp)
    80004dfa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	86a080e7          	jalr	-1942(ra) # 80003666 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e04:	08000613          	li	a2,128
    80004e08:	f7040593          	addi	a1,s0,-144
    80004e0c:	4501                	li	a0,0
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	354080e7          	jalr	852(ra) # 80002162 <argstr>
    80004e16:	02054963          	bltz	a0,80004e48 <sys_mkdir+0x54>
    80004e1a:	4681                	li	a3,0
    80004e1c:	4601                	li	a2,0
    80004e1e:	4585                	li	a1,1
    80004e20:	f7040513          	addi	a0,s0,-144
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	7fc080e7          	jalr	2044(ra) # 80004620 <create>
    80004e2c:	cd11                	beqz	a0,80004e48 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	0ce080e7          	jalr	206(ra) # 80002efc <iunlockput>
  end_op();
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	8ae080e7          	jalr	-1874(ra) # 800036e4 <end_op>
  return 0;
    80004e3e:	4501                	li	a0,0
}
    80004e40:	60aa                	ld	ra,136(sp)
    80004e42:	640a                	ld	s0,128(sp)
    80004e44:	6149                	addi	sp,sp,144
    80004e46:	8082                	ret
    end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	89c080e7          	jalr	-1892(ra) # 800036e4 <end_op>
    return -1;
    80004e50:	557d                	li	a0,-1
    80004e52:	b7fd                	j	80004e40 <sys_mkdir+0x4c>

0000000080004e54 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e54:	7135                	addi	sp,sp,-160
    80004e56:	ed06                	sd	ra,152(sp)
    80004e58:	e922                	sd	s0,144(sp)
    80004e5a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	80a080e7          	jalr	-2038(ra) # 80003666 <begin_op>
  argint(1, &major);
    80004e64:	f6c40593          	addi	a1,s0,-148
    80004e68:	4505                	li	a0,1
    80004e6a:	ffffd097          	auipc	ra,0xffffd
    80004e6e:	2b8080e7          	jalr	696(ra) # 80002122 <argint>
  argint(2, &minor);
    80004e72:	f6840593          	addi	a1,s0,-152
    80004e76:	4509                	li	a0,2
    80004e78:	ffffd097          	auipc	ra,0xffffd
    80004e7c:	2aa080e7          	jalr	682(ra) # 80002122 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e80:	08000613          	li	a2,128
    80004e84:	f7040593          	addi	a1,s0,-144
    80004e88:	4501                	li	a0,0
    80004e8a:	ffffd097          	auipc	ra,0xffffd
    80004e8e:	2d8080e7          	jalr	728(ra) # 80002162 <argstr>
    80004e92:	02054b63          	bltz	a0,80004ec8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e96:	f6841683          	lh	a3,-152(s0)
    80004e9a:	f6c41603          	lh	a2,-148(s0)
    80004e9e:	458d                	li	a1,3
    80004ea0:	f7040513          	addi	a0,s0,-144
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	77c080e7          	jalr	1916(ra) # 80004620 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eac:	cd11                	beqz	a0,80004ec8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	04e080e7          	jalr	78(ra) # 80002efc <iunlockput>
  end_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	82e080e7          	jalr	-2002(ra) # 800036e4 <end_op>
  return 0;
    80004ebe:	4501                	li	a0,0
}
    80004ec0:	60ea                	ld	ra,152(sp)
    80004ec2:	644a                	ld	s0,144(sp)
    80004ec4:	610d                	addi	sp,sp,160
    80004ec6:	8082                	ret
    end_op();
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	81c080e7          	jalr	-2020(ra) # 800036e4 <end_op>
    return -1;
    80004ed0:	557d                	li	a0,-1
    80004ed2:	b7fd                	j	80004ec0 <sys_mknod+0x6c>

0000000080004ed4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ed4:	7135                	addi	sp,sp,-160
    80004ed6:	ed06                	sd	ra,152(sp)
    80004ed8:	e922                	sd	s0,144(sp)
    80004eda:	e526                	sd	s1,136(sp)
    80004edc:	e14a                	sd	s2,128(sp)
    80004ede:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ee0:	ffffc097          	auipc	ra,0xffffc
    80004ee4:	07c080e7          	jalr	124(ra) # 80000f5c <myproc>
    80004ee8:	892a                	mv	s2,a0
  
  begin_op();
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	77c080e7          	jalr	1916(ra) # 80003666 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ef2:	08000613          	li	a2,128
    80004ef6:	f6040593          	addi	a1,s0,-160
    80004efa:	4501                	li	a0,0
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	266080e7          	jalr	614(ra) # 80002162 <argstr>
    80004f04:	04054b63          	bltz	a0,80004f5a <sys_chdir+0x86>
    80004f08:	f6040513          	addi	a0,s0,-160
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	53a080e7          	jalr	1338(ra) # 80003446 <namei>
    80004f14:	84aa                	mv	s1,a0
    80004f16:	c131                	beqz	a0,80004f5a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	d82080e7          	jalr	-638(ra) # 80002c9a <ilock>
  if(ip->type != T_DIR){
    80004f20:	04449703          	lh	a4,68(s1)
    80004f24:	4785                	li	a5,1
    80004f26:	04f71063          	bne	a4,a5,80004f66 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f2a:	8526                	mv	a0,s1
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	e30080e7          	jalr	-464(ra) # 80002d5c <iunlock>
  iput(p->cwd);
    80004f34:	15893503          	ld	a0,344(s2)
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	f1c080e7          	jalr	-228(ra) # 80002e54 <iput>
  end_op();
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	7a4080e7          	jalr	1956(ra) # 800036e4 <end_op>
  p->cwd = ip;
    80004f48:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f4c:	4501                	li	a0,0
}
    80004f4e:	60ea                	ld	ra,152(sp)
    80004f50:	644a                	ld	s0,144(sp)
    80004f52:	64aa                	ld	s1,136(sp)
    80004f54:	690a                	ld	s2,128(sp)
    80004f56:	610d                	addi	sp,sp,160
    80004f58:	8082                	ret
    end_op();
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	78a080e7          	jalr	1930(ra) # 800036e4 <end_op>
    return -1;
    80004f62:	557d                	li	a0,-1
    80004f64:	b7ed                	j	80004f4e <sys_chdir+0x7a>
    iunlockput(ip);
    80004f66:	8526                	mv	a0,s1
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	f94080e7          	jalr	-108(ra) # 80002efc <iunlockput>
    end_op();
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	774080e7          	jalr	1908(ra) # 800036e4 <end_op>
    return -1;
    80004f78:	557d                	li	a0,-1
    80004f7a:	bfd1                	j	80004f4e <sys_chdir+0x7a>

0000000080004f7c <sys_exec>:

uint64
sys_exec(void)
{
    80004f7c:	7145                	addi	sp,sp,-464
    80004f7e:	e786                	sd	ra,456(sp)
    80004f80:	e3a2                	sd	s0,448(sp)
    80004f82:	ff26                	sd	s1,440(sp)
    80004f84:	fb4a                	sd	s2,432(sp)
    80004f86:	f74e                	sd	s3,424(sp)
    80004f88:	f352                	sd	s4,416(sp)
    80004f8a:	ef56                	sd	s5,408(sp)
    80004f8c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f8e:	e3840593          	addi	a1,s0,-456
    80004f92:	4505                	li	a0,1
    80004f94:	ffffd097          	auipc	ra,0xffffd
    80004f98:	1ae080e7          	jalr	430(ra) # 80002142 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f9c:	08000613          	li	a2,128
    80004fa0:	f4040593          	addi	a1,s0,-192
    80004fa4:	4501                	li	a0,0
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	1bc080e7          	jalr	444(ra) # 80002162 <argstr>
    80004fae:	87aa                	mv	a5,a0
    return -1;
    80004fb0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fb2:	0c07c363          	bltz	a5,80005078 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004fb6:	10000613          	li	a2,256
    80004fba:	4581                	li	a1,0
    80004fbc:	e4040513          	addi	a0,s0,-448
    80004fc0:	ffffb097          	auipc	ra,0xffffb
    80004fc4:	1ba080e7          	jalr	442(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fc8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fcc:	89a6                	mv	s3,s1
    80004fce:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fd0:	02000a13          	li	s4,32
    80004fd4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fd8:	00391513          	slli	a0,s2,0x3
    80004fdc:	e3040593          	addi	a1,s0,-464
    80004fe0:	e3843783          	ld	a5,-456(s0)
    80004fe4:	953e                	add	a0,a0,a5
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	09e080e7          	jalr	158(ra) # 80002084 <fetchaddr>
    80004fee:	02054a63          	bltz	a0,80005022 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ff2:	e3043783          	ld	a5,-464(s0)
    80004ff6:	c3b9                	beqz	a5,8000503c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ff8:	ffffb097          	auipc	ra,0xffffb
    80004ffc:	122080e7          	jalr	290(ra) # 8000011a <kalloc>
    80005000:	85aa                	mv	a1,a0
    80005002:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005006:	cd11                	beqz	a0,80005022 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005008:	6605                	lui	a2,0x1
    8000500a:	e3043503          	ld	a0,-464(s0)
    8000500e:	ffffd097          	auipc	ra,0xffffd
    80005012:	0c8080e7          	jalr	200(ra) # 800020d6 <fetchstr>
    80005016:	00054663          	bltz	a0,80005022 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    8000501a:	0905                	addi	s2,s2,1
    8000501c:	09a1                	addi	s3,s3,8
    8000501e:	fb491be3          	bne	s2,s4,80004fd4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005022:	f4040913          	addi	s2,s0,-192
    80005026:	6088                	ld	a0,0(s1)
    80005028:	c539                	beqz	a0,80005076 <sys_exec+0xfa>
    kfree(argv[i]);
    8000502a:	ffffb097          	auipc	ra,0xffffb
    8000502e:	ff2080e7          	jalr	-14(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005032:	04a1                	addi	s1,s1,8
    80005034:	ff2499e3          	bne	s1,s2,80005026 <sys_exec+0xaa>
  return -1;
    80005038:	557d                	li	a0,-1
    8000503a:	a83d                	j	80005078 <sys_exec+0xfc>
      argv[i] = 0;
    8000503c:	0a8e                	slli	s5,s5,0x3
    8000503e:	fc0a8793          	addi	a5,s5,-64
    80005042:	00878ab3          	add	s5,a5,s0
    80005046:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000504a:	e4040593          	addi	a1,s0,-448
    8000504e:	f4040513          	addi	a0,s0,-192
    80005052:	fffff097          	auipc	ra,0xfffff
    80005056:	156080e7          	jalr	342(ra) # 800041a8 <exec>
    8000505a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505c:	f4040993          	addi	s3,s0,-192
    80005060:	6088                	ld	a0,0(s1)
    80005062:	c901                	beqz	a0,80005072 <sys_exec+0xf6>
    kfree(argv[i]);
    80005064:	ffffb097          	auipc	ra,0xffffb
    80005068:	fb8080e7          	jalr	-72(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506c:	04a1                	addi	s1,s1,8
    8000506e:	ff3499e3          	bne	s1,s3,80005060 <sys_exec+0xe4>
  return ret;
    80005072:	854a                	mv	a0,s2
    80005074:	a011                	j	80005078 <sys_exec+0xfc>
  return -1;
    80005076:	557d                	li	a0,-1
}
    80005078:	60be                	ld	ra,456(sp)
    8000507a:	641e                	ld	s0,448(sp)
    8000507c:	74fa                	ld	s1,440(sp)
    8000507e:	795a                	ld	s2,432(sp)
    80005080:	79ba                	ld	s3,424(sp)
    80005082:	7a1a                	ld	s4,416(sp)
    80005084:	6afa                	ld	s5,408(sp)
    80005086:	6179                	addi	sp,sp,464
    80005088:	8082                	ret

000000008000508a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000508a:	7139                	addi	sp,sp,-64
    8000508c:	fc06                	sd	ra,56(sp)
    8000508e:	f822                	sd	s0,48(sp)
    80005090:	f426                	sd	s1,40(sp)
    80005092:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005094:	ffffc097          	auipc	ra,0xffffc
    80005098:	ec8080e7          	jalr	-312(ra) # 80000f5c <myproc>
    8000509c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000509e:	fd840593          	addi	a1,s0,-40
    800050a2:	4501                	li	a0,0
    800050a4:	ffffd097          	auipc	ra,0xffffd
    800050a8:	09e080e7          	jalr	158(ra) # 80002142 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050ac:	fc840593          	addi	a1,s0,-56
    800050b0:	fd040513          	addi	a0,s0,-48
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	daa080e7          	jalr	-598(ra) # 80003e5e <pipealloc>
    return -1;
    800050bc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050be:	0c054463          	bltz	a0,80005186 <sys_pipe+0xfc>
  fd0 = -1;
    800050c2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050c6:	fd043503          	ld	a0,-48(s0)
    800050ca:	fffff097          	auipc	ra,0xfffff
    800050ce:	514080e7          	jalr	1300(ra) # 800045de <fdalloc>
    800050d2:	fca42223          	sw	a0,-60(s0)
    800050d6:	08054b63          	bltz	a0,8000516c <sys_pipe+0xe2>
    800050da:	fc843503          	ld	a0,-56(s0)
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	500080e7          	jalr	1280(ra) # 800045de <fdalloc>
    800050e6:	fca42023          	sw	a0,-64(s0)
    800050ea:	06054863          	bltz	a0,8000515a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ee:	4691                	li	a3,4
    800050f0:	fc440613          	addi	a2,s0,-60
    800050f4:	fd843583          	ld	a1,-40(s0)
    800050f8:	68a8                	ld	a0,80(s1)
    800050fa:	ffffc097          	auipc	ra,0xffffc
    800050fe:	a1a080e7          	jalr	-1510(ra) # 80000b14 <copyout>
    80005102:	02054063          	bltz	a0,80005122 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005106:	4691                	li	a3,4
    80005108:	fc040613          	addi	a2,s0,-64
    8000510c:	fd843583          	ld	a1,-40(s0)
    80005110:	0591                	addi	a1,a1,4
    80005112:	68a8                	ld	a0,80(s1)
    80005114:	ffffc097          	auipc	ra,0xffffc
    80005118:	a00080e7          	jalr	-1536(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000511c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511e:	06055463          	bgez	a0,80005186 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005122:	fc442783          	lw	a5,-60(s0)
    80005126:	07e9                	addi	a5,a5,26
    80005128:	078e                	slli	a5,a5,0x3
    8000512a:	97a6                	add	a5,a5,s1
    8000512c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005130:	fc042783          	lw	a5,-64(s0)
    80005134:	07e9                	addi	a5,a5,26
    80005136:	078e                	slli	a5,a5,0x3
    80005138:	94be                	add	s1,s1,a5
    8000513a:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000513e:	fd043503          	ld	a0,-48(s0)
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	9ec080e7          	jalr	-1556(ra) # 80003b2e <fileclose>
    fileclose(wf);
    8000514a:	fc843503          	ld	a0,-56(s0)
    8000514e:	fffff097          	auipc	ra,0xfffff
    80005152:	9e0080e7          	jalr	-1568(ra) # 80003b2e <fileclose>
    return -1;
    80005156:	57fd                	li	a5,-1
    80005158:	a03d                	j	80005186 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000515a:	fc442783          	lw	a5,-60(s0)
    8000515e:	0007c763          	bltz	a5,8000516c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005162:	07e9                	addi	a5,a5,26
    80005164:	078e                	slli	a5,a5,0x3
    80005166:	97a6                	add	a5,a5,s1
    80005168:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000516c:	fd043503          	ld	a0,-48(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	9be080e7          	jalr	-1602(ra) # 80003b2e <fileclose>
    fileclose(wf);
    80005178:	fc843503          	ld	a0,-56(s0)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	9b2080e7          	jalr	-1614(ra) # 80003b2e <fileclose>
    return -1;
    80005184:	57fd                	li	a5,-1
}
    80005186:	853e                	mv	a0,a5
    80005188:	70e2                	ld	ra,56(sp)
    8000518a:	7442                	ld	s0,48(sp)
    8000518c:	74a2                	ld	s1,40(sp)
    8000518e:	6121                	addi	sp,sp,64
    80005190:	8082                	ret
	...

00000000800051a0 <kernelvec>:
    800051a0:	7111                	addi	sp,sp,-256
    800051a2:	e006                	sd	ra,0(sp)
    800051a4:	e40a                	sd	sp,8(sp)
    800051a6:	e80e                	sd	gp,16(sp)
    800051a8:	ec12                	sd	tp,24(sp)
    800051aa:	f016                	sd	t0,32(sp)
    800051ac:	f41a                	sd	t1,40(sp)
    800051ae:	f81e                	sd	t2,48(sp)
    800051b0:	fc22                	sd	s0,56(sp)
    800051b2:	e0a6                	sd	s1,64(sp)
    800051b4:	e4aa                	sd	a0,72(sp)
    800051b6:	e8ae                	sd	a1,80(sp)
    800051b8:	ecb2                	sd	a2,88(sp)
    800051ba:	f0b6                	sd	a3,96(sp)
    800051bc:	f4ba                	sd	a4,104(sp)
    800051be:	f8be                	sd	a5,112(sp)
    800051c0:	fcc2                	sd	a6,120(sp)
    800051c2:	e146                	sd	a7,128(sp)
    800051c4:	e54a                	sd	s2,136(sp)
    800051c6:	e94e                	sd	s3,144(sp)
    800051c8:	ed52                	sd	s4,152(sp)
    800051ca:	f156                	sd	s5,160(sp)
    800051cc:	f55a                	sd	s6,168(sp)
    800051ce:	f95e                	sd	s7,176(sp)
    800051d0:	fd62                	sd	s8,184(sp)
    800051d2:	e1e6                	sd	s9,192(sp)
    800051d4:	e5ea                	sd	s10,200(sp)
    800051d6:	e9ee                	sd	s11,208(sp)
    800051d8:	edf2                	sd	t3,216(sp)
    800051da:	f1f6                	sd	t4,224(sp)
    800051dc:	f5fa                	sd	t5,232(sp)
    800051de:	f9fe                	sd	t6,240(sp)
    800051e0:	d71fc0ef          	jal	ra,80001f50 <kerneltrap>
    800051e4:	6082                	ld	ra,0(sp)
    800051e6:	6122                	ld	sp,8(sp)
    800051e8:	61c2                	ld	gp,16(sp)
    800051ea:	7282                	ld	t0,32(sp)
    800051ec:	7322                	ld	t1,40(sp)
    800051ee:	73c2                	ld	t2,48(sp)
    800051f0:	7462                	ld	s0,56(sp)
    800051f2:	6486                	ld	s1,64(sp)
    800051f4:	6526                	ld	a0,72(sp)
    800051f6:	65c6                	ld	a1,80(sp)
    800051f8:	6666                	ld	a2,88(sp)
    800051fa:	7686                	ld	a3,96(sp)
    800051fc:	7726                	ld	a4,104(sp)
    800051fe:	77c6                	ld	a5,112(sp)
    80005200:	7866                	ld	a6,120(sp)
    80005202:	688a                	ld	a7,128(sp)
    80005204:	692a                	ld	s2,136(sp)
    80005206:	69ca                	ld	s3,144(sp)
    80005208:	6a6a                	ld	s4,152(sp)
    8000520a:	7a8a                	ld	s5,160(sp)
    8000520c:	7b2a                	ld	s6,168(sp)
    8000520e:	7bca                	ld	s7,176(sp)
    80005210:	7c6a                	ld	s8,184(sp)
    80005212:	6c8e                	ld	s9,192(sp)
    80005214:	6d2e                	ld	s10,200(sp)
    80005216:	6dce                	ld	s11,208(sp)
    80005218:	6e6e                	ld	t3,216(sp)
    8000521a:	7e8e                	ld	t4,224(sp)
    8000521c:	7f2e                	ld	t5,232(sp)
    8000521e:	7fce                	ld	t6,240(sp)
    80005220:	6111                	addi	sp,sp,256
    80005222:	10200073          	sret
    80005226:	00000013          	nop
    8000522a:	00000013          	nop
    8000522e:	0001                	nop

0000000080005230 <timervec>:
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	e10c                	sd	a1,0(a0)
    80005236:	e510                	sd	a2,8(a0)
    80005238:	e914                	sd	a3,16(a0)
    8000523a:	6d0c                	ld	a1,24(a0)
    8000523c:	7110                	ld	a2,32(a0)
    8000523e:	6194                	ld	a3,0(a1)
    80005240:	96b2                	add	a3,a3,a2
    80005242:	e194                	sd	a3,0(a1)
    80005244:	4589                	li	a1,2
    80005246:	14459073          	csrw	sip,a1
    8000524a:	6914                	ld	a3,16(a0)
    8000524c:	6510                	ld	a2,8(a0)
    8000524e:	610c                	ld	a1,0(a0)
    80005250:	34051573          	csrrw	a0,mscratch,a0
    80005254:	30200073          	mret
	...

000000008000525a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000525a:	1141                	addi	sp,sp,-16
    8000525c:	e422                	sd	s0,8(sp)
    8000525e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005260:	0c0007b7          	lui	a5,0xc000
    80005264:	4705                	li	a4,1
    80005266:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005268:	c3d8                	sw	a4,4(a5)
}
    8000526a:	6422                	ld	s0,8(sp)
    8000526c:	0141                	addi	sp,sp,16
    8000526e:	8082                	ret

0000000080005270 <plicinithart>:

void
plicinithart(void)
{
    80005270:	1141                	addi	sp,sp,-16
    80005272:	e406                	sd	ra,8(sp)
    80005274:	e022                	sd	s0,0(sp)
    80005276:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	cb8080e7          	jalr	-840(ra) # 80000f30 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005280:	0085171b          	slliw	a4,a0,0x8
    80005284:	0c0027b7          	lui	a5,0xc002
    80005288:	97ba                	add	a5,a5,a4
    8000528a:	40200713          	li	a4,1026
    8000528e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005292:	00d5151b          	slliw	a0,a0,0xd
    80005296:	0c2017b7          	lui	a5,0xc201
    8000529a:	97aa                	add	a5,a5,a0
    8000529c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052a0:	60a2                	ld	ra,8(sp)
    800052a2:	6402                	ld	s0,0(sp)
    800052a4:	0141                	addi	sp,sp,16
    800052a6:	8082                	ret

00000000800052a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052a8:	1141                	addi	sp,sp,-16
    800052aa:	e406                	sd	ra,8(sp)
    800052ac:	e022                	sd	s0,0(sp)
    800052ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b0:	ffffc097          	auipc	ra,0xffffc
    800052b4:	c80080e7          	jalr	-896(ra) # 80000f30 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052b8:	00d5151b          	slliw	a0,a0,0xd
    800052bc:	0c2017b7          	lui	a5,0xc201
    800052c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800052c2:	43c8                	lw	a0,4(a5)
    800052c4:	60a2                	ld	ra,8(sp)
    800052c6:	6402                	ld	s0,0(sp)
    800052c8:	0141                	addi	sp,sp,16
    800052ca:	8082                	ret

00000000800052cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052cc:	1101                	addi	sp,sp,-32
    800052ce:	ec06                	sd	ra,24(sp)
    800052d0:	e822                	sd	s0,16(sp)
    800052d2:	e426                	sd	s1,8(sp)
    800052d4:	1000                	addi	s0,sp,32
    800052d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	c58080e7          	jalr	-936(ra) # 80000f30 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052e0:	00d5151b          	slliw	a0,a0,0xd
    800052e4:	0c2017b7          	lui	a5,0xc201
    800052e8:	97aa                	add	a5,a5,a0
    800052ea:	c3c4                	sw	s1,4(a5)
}
    800052ec:	60e2                	ld	ra,24(sp)
    800052ee:	6442                	ld	s0,16(sp)
    800052f0:	64a2                	ld	s1,8(sp)
    800052f2:	6105                	addi	sp,sp,32
    800052f4:	8082                	ret

00000000800052f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052f6:	1141                	addi	sp,sp,-16
    800052f8:	e406                	sd	ra,8(sp)
    800052fa:	e022                	sd	s0,0(sp)
    800052fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052fe:	479d                	li	a5,7
    80005300:	04a7cc63          	blt	a5,a0,80005358 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005304:	00015797          	auipc	a5,0x15
    80005308:	97c78793          	addi	a5,a5,-1668 # 80019c80 <disk>
    8000530c:	97aa                	add	a5,a5,a0
    8000530e:	0187c783          	lbu	a5,24(a5)
    80005312:	ebb9                	bnez	a5,80005368 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005314:	00451693          	slli	a3,a0,0x4
    80005318:	00015797          	auipc	a5,0x15
    8000531c:	96878793          	addi	a5,a5,-1688 # 80019c80 <disk>
    80005320:	6398                	ld	a4,0(a5)
    80005322:	9736                	add	a4,a4,a3
    80005324:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005328:	6398                	ld	a4,0(a5)
    8000532a:	9736                	add	a4,a4,a3
    8000532c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005330:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005334:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005338:	97aa                	add	a5,a5,a0
    8000533a:	4705                	li	a4,1
    8000533c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005340:	00015517          	auipc	a0,0x15
    80005344:	95850513          	addi	a0,a0,-1704 # 80019c98 <disk+0x18>
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	3d0080e7          	jalr	976(ra) # 80001718 <wakeup>
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret
    panic("free_desc 1");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	41050513          	addi	a0,a0,1040 # 80008768 <syscalls+0x338>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	a0c080e7          	jalr	-1524(ra) # 80005d6c <panic>
    panic("free_desc 2");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	41050513          	addi	a0,a0,1040 # 80008778 <syscalls+0x348>
    80005370:	00001097          	auipc	ra,0x1
    80005374:	9fc080e7          	jalr	-1540(ra) # 80005d6c <panic>

0000000080005378 <virtio_disk_init>:
{
    80005378:	1101                	addi	sp,sp,-32
    8000537a:	ec06                	sd	ra,24(sp)
    8000537c:	e822                	sd	s0,16(sp)
    8000537e:	e426                	sd	s1,8(sp)
    80005380:	e04a                	sd	s2,0(sp)
    80005382:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005384:	00003597          	auipc	a1,0x3
    80005388:	40458593          	addi	a1,a1,1028 # 80008788 <syscalls+0x358>
    8000538c:	00015517          	auipc	a0,0x15
    80005390:	a1c50513          	addi	a0,a0,-1508 # 80019da8 <disk+0x128>
    80005394:	00001097          	auipc	ra,0x1
    80005398:	e80080e7          	jalr	-384(ra) # 80006214 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000539c:	100017b7          	lui	a5,0x10001
    800053a0:	4398                	lw	a4,0(a5)
    800053a2:	2701                	sext.w	a4,a4
    800053a4:	747277b7          	lui	a5,0x74727
    800053a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053ac:	14f71b63          	bne	a4,a5,80005502 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053b0:	100017b7          	lui	a5,0x10001
    800053b4:	43dc                	lw	a5,4(a5)
    800053b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b8:	4709                	li	a4,2
    800053ba:	14e79463          	bne	a5,a4,80005502 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053be:	100017b7          	lui	a5,0x10001
    800053c2:	479c                	lw	a5,8(a5)
    800053c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800053c6:	12e79e63          	bne	a5,a4,80005502 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053ca:	100017b7          	lui	a5,0x10001
    800053ce:	47d8                	lw	a4,12(a5)
    800053d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d2:	554d47b7          	lui	a5,0x554d4
    800053d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053da:	12f71463          	bne	a4,a5,80005502 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053de:	100017b7          	lui	a5,0x10001
    800053e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e6:	4705                	li	a4,1
    800053e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ea:	470d                	li	a4,3
    800053ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053ee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800053f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc75f>
    800053f8:	8f75                	and	a4,a4,a3
    800053fa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053fc:	472d                	li	a4,11
    800053fe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005400:	5bbc                	lw	a5,112(a5)
    80005402:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005406:	8ba1                	andi	a5,a5,8
    80005408:	10078563          	beqz	a5,80005512 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005414:	43fc                	lw	a5,68(a5)
    80005416:	2781                	sext.w	a5,a5
    80005418:	10079563          	bnez	a5,80005522 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000541c:	100017b7          	lui	a5,0x10001
    80005420:	5bdc                	lw	a5,52(a5)
    80005422:	2781                	sext.w	a5,a5
  if(max == 0)
    80005424:	10078763          	beqz	a5,80005532 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005428:	471d                	li	a4,7
    8000542a:	10f77c63          	bgeu	a4,a5,80005542 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000542e:	ffffb097          	auipc	ra,0xffffb
    80005432:	cec080e7          	jalr	-788(ra) # 8000011a <kalloc>
    80005436:	00015497          	auipc	s1,0x15
    8000543a:	84a48493          	addi	s1,s1,-1974 # 80019c80 <disk>
    8000543e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005440:	ffffb097          	auipc	ra,0xffffb
    80005444:	cda080e7          	jalr	-806(ra) # 8000011a <kalloc>
    80005448:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000544a:	ffffb097          	auipc	ra,0xffffb
    8000544e:	cd0080e7          	jalr	-816(ra) # 8000011a <kalloc>
    80005452:	87aa                	mv	a5,a0
    80005454:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005456:	6088                	ld	a0,0(s1)
    80005458:	cd6d                	beqz	a0,80005552 <virtio_disk_init+0x1da>
    8000545a:	00015717          	auipc	a4,0x15
    8000545e:	82e73703          	ld	a4,-2002(a4) # 80019c88 <disk+0x8>
    80005462:	cb65                	beqz	a4,80005552 <virtio_disk_init+0x1da>
    80005464:	c7fd                	beqz	a5,80005552 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005466:	6605                	lui	a2,0x1
    80005468:	4581                	li	a1,0
    8000546a:	ffffb097          	auipc	ra,0xffffb
    8000546e:	d10080e7          	jalr	-752(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005472:	00015497          	auipc	s1,0x15
    80005476:	80e48493          	addi	s1,s1,-2034 # 80019c80 <disk>
    8000547a:	6605                	lui	a2,0x1
    8000547c:	4581                	li	a1,0
    8000547e:	6488                	ld	a0,8(s1)
    80005480:	ffffb097          	auipc	ra,0xffffb
    80005484:	cfa080e7          	jalr	-774(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005488:	6605                	lui	a2,0x1
    8000548a:	4581                	li	a1,0
    8000548c:	6888                	ld	a0,16(s1)
    8000548e:	ffffb097          	auipc	ra,0xffffb
    80005492:	cec080e7          	jalr	-788(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	4721                	li	a4,8
    8000549c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000549e:	4098                	lw	a4,0(s1)
    800054a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800054a4:	40d8                	lw	a4,4(s1)
    800054a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800054aa:	6498                	ld	a4,8(s1)
    800054ac:	0007069b          	sext.w	a3,a4
    800054b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800054b4:	9701                	srai	a4,a4,0x20
    800054b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800054ba:	6898                	ld	a4,16(s1)
    800054bc:	0007069b          	sext.w	a3,a4
    800054c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800054c4:	9701                	srai	a4,a4,0x20
    800054c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800054ca:	4705                	li	a4,1
    800054cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800054ce:	00e48c23          	sb	a4,24(s1)
    800054d2:	00e48ca3          	sb	a4,25(s1)
    800054d6:	00e48d23          	sb	a4,26(s1)
    800054da:	00e48da3          	sb	a4,27(s1)
    800054de:	00e48e23          	sb	a4,28(s1)
    800054e2:	00e48ea3          	sb	a4,29(s1)
    800054e6:	00e48f23          	sb	a4,30(s1)
    800054ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054ee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f2:	0727a823          	sw	s2,112(a5)
}
    800054f6:	60e2                	ld	ra,24(sp)
    800054f8:	6442                	ld	s0,16(sp)
    800054fa:	64a2                	ld	s1,8(sp)
    800054fc:	6902                	ld	s2,0(sp)
    800054fe:	6105                	addi	sp,sp,32
    80005500:	8082                	ret
    panic("could not find virtio disk");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	29650513          	addi	a0,a0,662 # 80008798 <syscalls+0x368>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	862080e7          	jalr	-1950(ra) # 80005d6c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	2a650513          	addi	a0,a0,678 # 800087b8 <syscalls+0x388>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	852080e7          	jalr	-1966(ra) # 80005d6c <panic>
    panic("virtio disk should not be ready");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	2b650513          	addi	a0,a0,694 # 800087d8 <syscalls+0x3a8>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	842080e7          	jalr	-1982(ra) # 80005d6c <panic>
    panic("virtio disk has no queue 0");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	2c650513          	addi	a0,a0,710 # 800087f8 <syscalls+0x3c8>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	832080e7          	jalr	-1998(ra) # 80005d6c <panic>
    panic("virtio disk max queue too short");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	2d650513          	addi	a0,a0,726 # 80008818 <syscalls+0x3e8>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	822080e7          	jalr	-2014(ra) # 80005d6c <panic>
    panic("virtio disk kalloc");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	2e650513          	addi	a0,a0,742 # 80008838 <syscalls+0x408>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	812080e7          	jalr	-2030(ra) # 80005d6c <panic>

0000000080005562 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005562:	7119                	addi	sp,sp,-128
    80005564:	fc86                	sd	ra,120(sp)
    80005566:	f8a2                	sd	s0,112(sp)
    80005568:	f4a6                	sd	s1,104(sp)
    8000556a:	f0ca                	sd	s2,96(sp)
    8000556c:	ecce                	sd	s3,88(sp)
    8000556e:	e8d2                	sd	s4,80(sp)
    80005570:	e4d6                	sd	s5,72(sp)
    80005572:	e0da                	sd	s6,64(sp)
    80005574:	fc5e                	sd	s7,56(sp)
    80005576:	f862                	sd	s8,48(sp)
    80005578:	f466                	sd	s9,40(sp)
    8000557a:	f06a                	sd	s10,32(sp)
    8000557c:	ec6e                	sd	s11,24(sp)
    8000557e:	0100                	addi	s0,sp,128
    80005580:	8aaa                	mv	s5,a0
    80005582:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005584:	00c52d03          	lw	s10,12(a0)
    80005588:	001d1d1b          	slliw	s10,s10,0x1
    8000558c:	1d02                	slli	s10,s10,0x20
    8000558e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005592:	00015517          	auipc	a0,0x15
    80005596:	81650513          	addi	a0,a0,-2026 # 80019da8 <disk+0x128>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	d0a080e7          	jalr	-758(ra) # 800062a4 <acquire>
  for(int i = 0; i < 3; i++){
    800055a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055a6:	00014b97          	auipc	s7,0x14
    800055aa:	6dab8b93          	addi	s7,s7,1754 # 80019c80 <disk>
  for(int i = 0; i < 3; i++){
    800055ae:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b0:	00014c97          	auipc	s9,0x14
    800055b4:	7f8c8c93          	addi	s9,s9,2040 # 80019da8 <disk+0x128>
    800055b8:	a08d                	j	8000561a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800055ba:	00fb8733          	add	a4,s7,a5
    800055be:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055c2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055c4:	0207c563          	bltz	a5,800055ee <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800055c8:	2905                	addiw	s2,s2,1
    800055ca:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800055cc:	05690c63          	beq	s2,s6,80005624 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800055d0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055d2:	00014717          	auipc	a4,0x14
    800055d6:	6ae70713          	addi	a4,a4,1710 # 80019c80 <disk>
    800055da:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055dc:	01874683          	lbu	a3,24(a4)
    800055e0:	fee9                	bnez	a3,800055ba <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800055e2:	2785                	addiw	a5,a5,1
    800055e4:	0705                	addi	a4,a4,1
    800055e6:	fe979be3          	bne	a5,s1,800055dc <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055ea:	57fd                	li	a5,-1
    800055ec:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055ee:	01205d63          	blez	s2,80005608 <virtio_disk_rw+0xa6>
    800055f2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055f4:	000a2503          	lw	a0,0(s4)
    800055f8:	00000097          	auipc	ra,0x0
    800055fc:	cfe080e7          	jalr	-770(ra) # 800052f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005600:	2d85                	addiw	s11,s11,1
    80005602:	0a11                	addi	s4,s4,4
    80005604:	ff2d98e3          	bne	s11,s2,800055f4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005608:	85e6                	mv	a1,s9
    8000560a:	00014517          	auipc	a0,0x14
    8000560e:	68e50513          	addi	a0,a0,1678 # 80019c98 <disk+0x18>
    80005612:	ffffc097          	auipc	ra,0xffffc
    80005616:	0a2080e7          	jalr	162(ra) # 800016b4 <sleep>
  for(int i = 0; i < 3; i++){
    8000561a:	f8040a13          	addi	s4,s0,-128
{
    8000561e:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005620:	894e                	mv	s2,s3
    80005622:	b77d                	j	800055d0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005624:	f8042503          	lw	a0,-128(s0)
    80005628:	00a50713          	addi	a4,a0,10
    8000562c:	0712                	slli	a4,a4,0x4

  if(write)
    8000562e:	00014797          	auipc	a5,0x14
    80005632:	65278793          	addi	a5,a5,1618 # 80019c80 <disk>
    80005636:	00e786b3          	add	a3,a5,a4
    8000563a:	01803633          	snez	a2,s8
    8000563e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005640:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005644:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005648:	f6070613          	addi	a2,a4,-160
    8000564c:	6394                	ld	a3,0(a5)
    8000564e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005650:	00870593          	addi	a1,a4,8
    80005654:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005656:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005658:	0007b803          	ld	a6,0(a5)
    8000565c:	9642                	add	a2,a2,a6
    8000565e:	46c1                	li	a3,16
    80005660:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005662:	4585                	li	a1,1
    80005664:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005668:	f8442683          	lw	a3,-124(s0)
    8000566c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005670:	0692                	slli	a3,a3,0x4
    80005672:	9836                	add	a6,a6,a3
    80005674:	058a8613          	addi	a2,s5,88
    80005678:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000567c:	0007b803          	ld	a6,0(a5)
    80005680:	96c2                	add	a3,a3,a6
    80005682:	40000613          	li	a2,1024
    80005686:	c690                	sw	a2,8(a3)
  if(write)
    80005688:	001c3613          	seqz	a2,s8
    8000568c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005690:	00166613          	ori	a2,a2,1
    80005694:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005698:	f8842603          	lw	a2,-120(s0)
    8000569c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a0:	00250693          	addi	a3,a0,2
    800056a4:	0692                	slli	a3,a3,0x4
    800056a6:	96be                	add	a3,a3,a5
    800056a8:	58fd                	li	a7,-1
    800056aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056ae:	0612                	slli	a2,a2,0x4
    800056b0:	9832                	add	a6,a6,a2
    800056b2:	f9070713          	addi	a4,a4,-112
    800056b6:	973e                	add	a4,a4,a5
    800056b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800056bc:	6398                	ld	a4,0(a5)
    800056be:	9732                	add	a4,a4,a2
    800056c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056c2:	4609                	li	a2,2
    800056c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800056c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056cc:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800056d0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056d4:	6794                	ld	a3,8(a5)
    800056d6:	0026d703          	lhu	a4,2(a3)
    800056da:	8b1d                	andi	a4,a4,7
    800056dc:	0706                	slli	a4,a4,0x1
    800056de:	96ba                	add	a3,a3,a4
    800056e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056e8:	6798                	ld	a4,8(a5)
    800056ea:	00275783          	lhu	a5,2(a4)
    800056ee:	2785                	addiw	a5,a5,1
    800056f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056f8:	100017b7          	lui	a5,0x10001
    800056fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005700:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005704:	00014917          	auipc	s2,0x14
    80005708:	6a490913          	addi	s2,s2,1700 # 80019da8 <disk+0x128>
  while(b->disk == 1) {
    8000570c:	4485                	li	s1,1
    8000570e:	00b79c63          	bne	a5,a1,80005726 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005712:	85ca                	mv	a1,s2
    80005714:	8556                	mv	a0,s5
    80005716:	ffffc097          	auipc	ra,0xffffc
    8000571a:	f9e080e7          	jalr	-98(ra) # 800016b4 <sleep>
  while(b->disk == 1) {
    8000571e:	004aa783          	lw	a5,4(s5)
    80005722:	fe9788e3          	beq	a5,s1,80005712 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005726:	f8042903          	lw	s2,-128(s0)
    8000572a:	00290713          	addi	a4,s2,2
    8000572e:	0712                	slli	a4,a4,0x4
    80005730:	00014797          	auipc	a5,0x14
    80005734:	55078793          	addi	a5,a5,1360 # 80019c80 <disk>
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000573e:	00014997          	auipc	s3,0x14
    80005742:	54298993          	addi	s3,s3,1346 # 80019c80 <disk>
    80005746:	00491713          	slli	a4,s2,0x4
    8000574a:	0009b783          	ld	a5,0(s3)
    8000574e:	97ba                	add	a5,a5,a4
    80005750:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005754:	854a                	mv	a0,s2
    80005756:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000575a:	00000097          	auipc	ra,0x0
    8000575e:	b9c080e7          	jalr	-1124(ra) # 800052f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005762:	8885                	andi	s1,s1,1
    80005764:	f0ed                	bnez	s1,80005746 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005766:	00014517          	auipc	a0,0x14
    8000576a:	64250513          	addi	a0,a0,1602 # 80019da8 <disk+0x128>
    8000576e:	00001097          	auipc	ra,0x1
    80005772:	bea080e7          	jalr	-1046(ra) # 80006358 <release>
}
    80005776:	70e6                	ld	ra,120(sp)
    80005778:	7446                	ld	s0,112(sp)
    8000577a:	74a6                	ld	s1,104(sp)
    8000577c:	7906                	ld	s2,96(sp)
    8000577e:	69e6                	ld	s3,88(sp)
    80005780:	6a46                	ld	s4,80(sp)
    80005782:	6aa6                	ld	s5,72(sp)
    80005784:	6b06                	ld	s6,64(sp)
    80005786:	7be2                	ld	s7,56(sp)
    80005788:	7c42                	ld	s8,48(sp)
    8000578a:	7ca2                	ld	s9,40(sp)
    8000578c:	7d02                	ld	s10,32(sp)
    8000578e:	6de2                	ld	s11,24(sp)
    80005790:	6109                	addi	sp,sp,128
    80005792:	8082                	ret

0000000080005794 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005794:	1101                	addi	sp,sp,-32
    80005796:	ec06                	sd	ra,24(sp)
    80005798:	e822                	sd	s0,16(sp)
    8000579a:	e426                	sd	s1,8(sp)
    8000579c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000579e:	00014497          	auipc	s1,0x14
    800057a2:	4e248493          	addi	s1,s1,1250 # 80019c80 <disk>
    800057a6:	00014517          	auipc	a0,0x14
    800057aa:	60250513          	addi	a0,a0,1538 # 80019da8 <disk+0x128>
    800057ae:	00001097          	auipc	ra,0x1
    800057b2:	af6080e7          	jalr	-1290(ra) # 800062a4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b6:	10001737          	lui	a4,0x10001
    800057ba:	533c                	lw	a5,96(a4)
    800057bc:	8b8d                	andi	a5,a5,3
    800057be:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057c0:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c4:	689c                	ld	a5,16(s1)
    800057c6:	0204d703          	lhu	a4,32(s1)
    800057ca:	0027d783          	lhu	a5,2(a5)
    800057ce:	04f70863          	beq	a4,a5,8000581e <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057d2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d6:	6898                	ld	a4,16(s1)
    800057d8:	0204d783          	lhu	a5,32(s1)
    800057dc:	8b9d                	andi	a5,a5,7
    800057de:	078e                	slli	a5,a5,0x3
    800057e0:	97ba                	add	a5,a5,a4
    800057e2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057e4:	00278713          	addi	a4,a5,2
    800057e8:	0712                	slli	a4,a4,0x4
    800057ea:	9726                	add	a4,a4,s1
    800057ec:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057f0:	e721                	bnez	a4,80005838 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057f2:	0789                	addi	a5,a5,2
    800057f4:	0792                	slli	a5,a5,0x4
    800057f6:	97a6                	add	a5,a5,s1
    800057f8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057fa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057fe:	ffffc097          	auipc	ra,0xffffc
    80005802:	f1a080e7          	jalr	-230(ra) # 80001718 <wakeup>

    disk.used_idx += 1;
    80005806:	0204d783          	lhu	a5,32(s1)
    8000580a:	2785                	addiw	a5,a5,1
    8000580c:	17c2                	slli	a5,a5,0x30
    8000580e:	93c1                	srli	a5,a5,0x30
    80005810:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005814:	6898                	ld	a4,16(s1)
    80005816:	00275703          	lhu	a4,2(a4)
    8000581a:	faf71ce3          	bne	a4,a5,800057d2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000581e:	00014517          	auipc	a0,0x14
    80005822:	58a50513          	addi	a0,a0,1418 # 80019da8 <disk+0x128>
    80005826:	00001097          	auipc	ra,0x1
    8000582a:	b32080e7          	jalr	-1230(ra) # 80006358 <release>
}
    8000582e:	60e2                	ld	ra,24(sp)
    80005830:	6442                	ld	s0,16(sp)
    80005832:	64a2                	ld	s1,8(sp)
    80005834:	6105                	addi	sp,sp,32
    80005836:	8082                	ret
      panic("virtio_disk_intr status");
    80005838:	00003517          	auipc	a0,0x3
    8000583c:	01850513          	addi	a0,a0,24 # 80008850 <syscalls+0x420>
    80005840:	00000097          	auipc	ra,0x0
    80005844:	52c080e7          	jalr	1324(ra) # 80005d6c <panic>

0000000080005848 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005848:	1141                	addi	sp,sp,-16
    8000584a:	e422                	sd	s0,8(sp)
    8000584c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000584e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005852:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005856:	0037979b          	slliw	a5,a5,0x3
    8000585a:	02004737          	lui	a4,0x2004
    8000585e:	97ba                	add	a5,a5,a4
    80005860:	0200c737          	lui	a4,0x200c
    80005864:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005868:	000f4637          	lui	a2,0xf4
    8000586c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005870:	9732                	add	a4,a4,a2
    80005872:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005874:	00259693          	slli	a3,a1,0x2
    80005878:	96ae                	add	a3,a3,a1
    8000587a:	068e                	slli	a3,a3,0x3
    8000587c:	00014717          	auipc	a4,0x14
    80005880:	54470713          	addi	a4,a4,1348 # 80019dc0 <timer_scratch>
    80005884:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005886:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005888:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000588a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000588e:	00000797          	auipc	a5,0x0
    80005892:	9a278793          	addi	a5,a5,-1630 # 80005230 <timervec>
    80005896:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000589a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000589e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058a6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058aa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058ae:	30479073          	csrw	mie,a5
}
    800058b2:	6422                	ld	s0,8(sp)
    800058b4:	0141                	addi	sp,sp,16
    800058b6:	8082                	ret

00000000800058b8 <start>:
{
    800058b8:	1141                	addi	sp,sp,-16
    800058ba:	e406                	sd	ra,8(sp)
    800058bc:	e022                	sd	s0,0(sp)
    800058be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058c4:	7779                	lui	a4,0xffffe
    800058c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ff>
    800058ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058cc:	6705                	lui	a4,0x1
    800058ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058d8:	ffffb797          	auipc	a5,0xffffb
    800058dc:	a4878793          	addi	a5,a5,-1464 # 80000320 <main>
    800058e0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058e4:	4781                	li	a5,0
    800058e6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ea:	67c1                	lui	a5,0x10
    800058ec:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058ee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058fe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005902:	57fd                	li	a5,-1
    80005904:	83a9                	srli	a5,a5,0xa
    80005906:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000590a:	47bd                	li	a5,15
    8000590c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005910:	00000097          	auipc	ra,0x0
    80005914:	f38080e7          	jalr	-200(ra) # 80005848 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005918:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000591c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000591e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005920:	30200073          	mret
}
    80005924:	60a2                	ld	ra,8(sp)
    80005926:	6402                	ld	s0,0(sp)
    80005928:	0141                	addi	sp,sp,16
    8000592a:	8082                	ret

000000008000592c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000592c:	715d                	addi	sp,sp,-80
    8000592e:	e486                	sd	ra,72(sp)
    80005930:	e0a2                	sd	s0,64(sp)
    80005932:	fc26                	sd	s1,56(sp)
    80005934:	f84a                	sd	s2,48(sp)
    80005936:	f44e                	sd	s3,40(sp)
    80005938:	f052                	sd	s4,32(sp)
    8000593a:	ec56                	sd	s5,24(sp)
    8000593c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000593e:	04c05763          	blez	a2,8000598c <consolewrite+0x60>
    80005942:	8a2a                	mv	s4,a0
    80005944:	84ae                	mv	s1,a1
    80005946:	89b2                	mv	s3,a2
    80005948:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000594a:	5afd                	li	s5,-1
    8000594c:	4685                	li	a3,1
    8000594e:	8626                	mv	a2,s1
    80005950:	85d2                	mv	a1,s4
    80005952:	fbf40513          	addi	a0,s0,-65
    80005956:	ffffc097          	auipc	ra,0xffffc
    8000595a:	1bc080e7          	jalr	444(ra) # 80001b12 <either_copyin>
    8000595e:	01550d63          	beq	a0,s5,80005978 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005962:	fbf44503          	lbu	a0,-65(s0)
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	784080e7          	jalr	1924(ra) # 800060ea <uartputc>
  for(i = 0; i < n; i++){
    8000596e:	2905                	addiw	s2,s2,1
    80005970:	0485                	addi	s1,s1,1
    80005972:	fd299de3          	bne	s3,s2,8000594c <consolewrite+0x20>
    80005976:	894e                	mv	s2,s3
  }

  return i;
}
    80005978:	854a                	mv	a0,s2
    8000597a:	60a6                	ld	ra,72(sp)
    8000597c:	6406                	ld	s0,64(sp)
    8000597e:	74e2                	ld	s1,56(sp)
    80005980:	7942                	ld	s2,48(sp)
    80005982:	79a2                	ld	s3,40(sp)
    80005984:	7a02                	ld	s4,32(sp)
    80005986:	6ae2                	ld	s5,24(sp)
    80005988:	6161                	addi	sp,sp,80
    8000598a:	8082                	ret
  for(i = 0; i < n; i++){
    8000598c:	4901                	li	s2,0
    8000598e:	b7ed                	j	80005978 <consolewrite+0x4c>

0000000080005990 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005990:	7159                	addi	sp,sp,-112
    80005992:	f486                	sd	ra,104(sp)
    80005994:	f0a2                	sd	s0,96(sp)
    80005996:	eca6                	sd	s1,88(sp)
    80005998:	e8ca                	sd	s2,80(sp)
    8000599a:	e4ce                	sd	s3,72(sp)
    8000599c:	e0d2                	sd	s4,64(sp)
    8000599e:	fc56                	sd	s5,56(sp)
    800059a0:	f85a                	sd	s6,48(sp)
    800059a2:	f45e                	sd	s7,40(sp)
    800059a4:	f062                	sd	s8,32(sp)
    800059a6:	ec66                	sd	s9,24(sp)
    800059a8:	e86a                	sd	s10,16(sp)
    800059aa:	1880                	addi	s0,sp,112
    800059ac:	8aaa                	mv	s5,a0
    800059ae:	8a2e                	mv	s4,a1
    800059b0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059b2:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059b6:	0001c517          	auipc	a0,0x1c
    800059ba:	54a50513          	addi	a0,a0,1354 # 80021f00 <cons>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	8e6080e7          	jalr	-1818(ra) # 800062a4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059c6:	0001c497          	auipc	s1,0x1c
    800059ca:	53a48493          	addi	s1,s1,1338 # 80021f00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ce:	0001c917          	auipc	s2,0x1c
    800059d2:	5ca90913          	addi	s2,s2,1482 # 80021f98 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059d6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059d8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059da:	4ca9                	li	s9,10
  while(n > 0){
    800059dc:	07305b63          	blez	s3,80005a52 <consoleread+0xc2>
    while(cons.r == cons.w){
    800059e0:	0984a783          	lw	a5,152(s1)
    800059e4:	09c4a703          	lw	a4,156(s1)
    800059e8:	02f71763          	bne	a4,a5,80005a16 <consoleread+0x86>
      if(killed(myproc())){
    800059ec:	ffffb097          	auipc	ra,0xffffb
    800059f0:	570080e7          	jalr	1392(ra) # 80000f5c <myproc>
    800059f4:	ffffc097          	auipc	ra,0xffffc
    800059f8:	f68080e7          	jalr	-152(ra) # 8000195c <killed>
    800059fc:	e535                	bnez	a0,80005a68 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059fe:	85a6                	mv	a1,s1
    80005a00:	854a                	mv	a0,s2
    80005a02:	ffffc097          	auipc	ra,0xffffc
    80005a06:	cb2080e7          	jalr	-846(ra) # 800016b4 <sleep>
    while(cons.r == cons.w){
    80005a0a:	0984a783          	lw	a5,152(s1)
    80005a0e:	09c4a703          	lw	a4,156(s1)
    80005a12:	fcf70de3          	beq	a4,a5,800059ec <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a16:	0017871b          	addiw	a4,a5,1
    80005a1a:	08e4ac23          	sw	a4,152(s1)
    80005a1e:	07f7f713          	andi	a4,a5,127
    80005a22:	9726                	add	a4,a4,s1
    80005a24:	01874703          	lbu	a4,24(a4)
    80005a28:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a2c:	077d0563          	beq	s10,s7,80005a96 <consoleread+0x106>
    cbuf = c;
    80005a30:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a34:	4685                	li	a3,1
    80005a36:	f9f40613          	addi	a2,s0,-97
    80005a3a:	85d2                	mv	a1,s4
    80005a3c:	8556                	mv	a0,s5
    80005a3e:	ffffc097          	auipc	ra,0xffffc
    80005a42:	07e080e7          	jalr	126(ra) # 80001abc <either_copyout>
    80005a46:	01850663          	beq	a0,s8,80005a52 <consoleread+0xc2>
    dst++;
    80005a4a:	0a05                	addi	s4,s4,1
    --n;
    80005a4c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a4e:	f99d17e3          	bne	s10,s9,800059dc <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a52:	0001c517          	auipc	a0,0x1c
    80005a56:	4ae50513          	addi	a0,a0,1198 # 80021f00 <cons>
    80005a5a:	00001097          	auipc	ra,0x1
    80005a5e:	8fe080e7          	jalr	-1794(ra) # 80006358 <release>

  return target - n;
    80005a62:	413b053b          	subw	a0,s6,s3
    80005a66:	a811                	j	80005a7a <consoleread+0xea>
        release(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	49850513          	addi	a0,a0,1176 # 80021f00 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	8e8080e7          	jalr	-1816(ra) # 80006358 <release>
        return -1;
    80005a78:	557d                	li	a0,-1
}
    80005a7a:	70a6                	ld	ra,104(sp)
    80005a7c:	7406                	ld	s0,96(sp)
    80005a7e:	64e6                	ld	s1,88(sp)
    80005a80:	6946                	ld	s2,80(sp)
    80005a82:	69a6                	ld	s3,72(sp)
    80005a84:	6a06                	ld	s4,64(sp)
    80005a86:	7ae2                	ld	s5,56(sp)
    80005a88:	7b42                	ld	s6,48(sp)
    80005a8a:	7ba2                	ld	s7,40(sp)
    80005a8c:	7c02                	ld	s8,32(sp)
    80005a8e:	6ce2                	ld	s9,24(sp)
    80005a90:	6d42                	ld	s10,16(sp)
    80005a92:	6165                	addi	sp,sp,112
    80005a94:	8082                	ret
      if(n < target){
    80005a96:	0009871b          	sext.w	a4,s3
    80005a9a:	fb677ce3          	bgeu	a4,s6,80005a52 <consoleread+0xc2>
        cons.r--;
    80005a9e:	0001c717          	auipc	a4,0x1c
    80005aa2:	4ef72d23          	sw	a5,1274(a4) # 80021f98 <cons+0x98>
    80005aa6:	b775                	j	80005a52 <consoleread+0xc2>

0000000080005aa8 <consputc>:
{
    80005aa8:	1141                	addi	sp,sp,-16
    80005aaa:	e406                	sd	ra,8(sp)
    80005aac:	e022                	sd	s0,0(sp)
    80005aae:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ab0:	10000793          	li	a5,256
    80005ab4:	00f50a63          	beq	a0,a5,80005ac8 <consputc+0x20>
    uartputc_sync(c);
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	560080e7          	jalr	1376(ra) # 80006018 <uartputc_sync>
}
    80005ac0:	60a2                	ld	ra,8(sp)
    80005ac2:	6402                	ld	s0,0(sp)
    80005ac4:	0141                	addi	sp,sp,16
    80005ac6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac8:	4521                	li	a0,8
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	54e080e7          	jalr	1358(ra) # 80006018 <uartputc_sync>
    80005ad2:	02000513          	li	a0,32
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	542080e7          	jalr	1346(ra) # 80006018 <uartputc_sync>
    80005ade:	4521                	li	a0,8
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	538080e7          	jalr	1336(ra) # 80006018 <uartputc_sync>
    80005ae8:	bfe1                	j	80005ac0 <consputc+0x18>

0000000080005aea <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005aea:	1101                	addi	sp,sp,-32
    80005aec:	ec06                	sd	ra,24(sp)
    80005aee:	e822                	sd	s0,16(sp)
    80005af0:	e426                	sd	s1,8(sp)
    80005af2:	e04a                	sd	s2,0(sp)
    80005af4:	1000                	addi	s0,sp,32
    80005af6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005af8:	0001c517          	auipc	a0,0x1c
    80005afc:	40850513          	addi	a0,a0,1032 # 80021f00 <cons>
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	7a4080e7          	jalr	1956(ra) # 800062a4 <acquire>

  switch(c){
    80005b08:	47d5                	li	a5,21
    80005b0a:	0af48663          	beq	s1,a5,80005bb6 <consoleintr+0xcc>
    80005b0e:	0297ca63          	blt	a5,s1,80005b42 <consoleintr+0x58>
    80005b12:	47a1                	li	a5,8
    80005b14:	0ef48763          	beq	s1,a5,80005c02 <consoleintr+0x118>
    80005b18:	47c1                	li	a5,16
    80005b1a:	10f49a63          	bne	s1,a5,80005c2e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b1e:	ffffc097          	auipc	ra,0xffffc
    80005b22:	04a080e7          	jalr	74(ra) # 80001b68 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b26:	0001c517          	auipc	a0,0x1c
    80005b2a:	3da50513          	addi	a0,a0,986 # 80021f00 <cons>
    80005b2e:	00001097          	auipc	ra,0x1
    80005b32:	82a080e7          	jalr	-2006(ra) # 80006358 <release>
}
    80005b36:	60e2                	ld	ra,24(sp)
    80005b38:	6442                	ld	s0,16(sp)
    80005b3a:	64a2                	ld	s1,8(sp)
    80005b3c:	6902                	ld	s2,0(sp)
    80005b3e:	6105                	addi	sp,sp,32
    80005b40:	8082                	ret
  switch(c){
    80005b42:	07f00793          	li	a5,127
    80005b46:	0af48e63          	beq	s1,a5,80005c02 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b4a:	0001c717          	auipc	a4,0x1c
    80005b4e:	3b670713          	addi	a4,a4,950 # 80021f00 <cons>
    80005b52:	0a072783          	lw	a5,160(a4)
    80005b56:	09872703          	lw	a4,152(a4)
    80005b5a:	9f99                	subw	a5,a5,a4
    80005b5c:	07f00713          	li	a4,127
    80005b60:	fcf763e3          	bltu	a4,a5,80005b26 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b64:	47b5                	li	a5,13
    80005b66:	0cf48763          	beq	s1,a5,80005c34 <consoleintr+0x14a>
      consputc(c);
    80005b6a:	8526                	mv	a0,s1
    80005b6c:	00000097          	auipc	ra,0x0
    80005b70:	f3c080e7          	jalr	-196(ra) # 80005aa8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b74:	0001c797          	auipc	a5,0x1c
    80005b78:	38c78793          	addi	a5,a5,908 # 80021f00 <cons>
    80005b7c:	0a07a683          	lw	a3,160(a5)
    80005b80:	0016871b          	addiw	a4,a3,1
    80005b84:	0007061b          	sext.w	a2,a4
    80005b88:	0ae7a023          	sw	a4,160(a5)
    80005b8c:	07f6f693          	andi	a3,a3,127
    80005b90:	97b6                	add	a5,a5,a3
    80005b92:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b96:	47a9                	li	a5,10
    80005b98:	0cf48563          	beq	s1,a5,80005c62 <consoleintr+0x178>
    80005b9c:	4791                	li	a5,4
    80005b9e:	0cf48263          	beq	s1,a5,80005c62 <consoleintr+0x178>
    80005ba2:	0001c797          	auipc	a5,0x1c
    80005ba6:	3f67a783          	lw	a5,1014(a5) # 80021f98 <cons+0x98>
    80005baa:	9f1d                	subw	a4,a4,a5
    80005bac:	08000793          	li	a5,128
    80005bb0:	f6f71be3          	bne	a4,a5,80005b26 <consoleintr+0x3c>
    80005bb4:	a07d                	j	80005c62 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bb6:	0001c717          	auipc	a4,0x1c
    80005bba:	34a70713          	addi	a4,a4,842 # 80021f00 <cons>
    80005bbe:	0a072783          	lw	a5,160(a4)
    80005bc2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bc6:	0001c497          	auipc	s1,0x1c
    80005bca:	33a48493          	addi	s1,s1,826 # 80021f00 <cons>
    while(cons.e != cons.w &&
    80005bce:	4929                	li	s2,10
    80005bd0:	f4f70be3          	beq	a4,a5,80005b26 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bd4:	37fd                	addiw	a5,a5,-1
    80005bd6:	07f7f713          	andi	a4,a5,127
    80005bda:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bdc:	01874703          	lbu	a4,24(a4)
    80005be0:	f52703e3          	beq	a4,s2,80005b26 <consoleintr+0x3c>
      cons.e--;
    80005be4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005be8:	10000513          	li	a0,256
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	ebc080e7          	jalr	-324(ra) # 80005aa8 <consputc>
    while(cons.e != cons.w &&
    80005bf4:	0a04a783          	lw	a5,160(s1)
    80005bf8:	09c4a703          	lw	a4,156(s1)
    80005bfc:	fcf71ce3          	bne	a4,a5,80005bd4 <consoleintr+0xea>
    80005c00:	b71d                	j	80005b26 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c02:	0001c717          	auipc	a4,0x1c
    80005c06:	2fe70713          	addi	a4,a4,766 # 80021f00 <cons>
    80005c0a:	0a072783          	lw	a5,160(a4)
    80005c0e:	09c72703          	lw	a4,156(a4)
    80005c12:	f0f70ae3          	beq	a4,a5,80005b26 <consoleintr+0x3c>
      cons.e--;
    80005c16:	37fd                	addiw	a5,a5,-1
    80005c18:	0001c717          	auipc	a4,0x1c
    80005c1c:	38f72423          	sw	a5,904(a4) # 80021fa0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c20:	10000513          	li	a0,256
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e84080e7          	jalr	-380(ra) # 80005aa8 <consputc>
    80005c2c:	bded                	j	80005b26 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c2e:	ee048ce3          	beqz	s1,80005b26 <consoleintr+0x3c>
    80005c32:	bf21                	j	80005b4a <consoleintr+0x60>
      consputc(c);
    80005c34:	4529                	li	a0,10
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	e72080e7          	jalr	-398(ra) # 80005aa8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c3e:	0001c797          	auipc	a5,0x1c
    80005c42:	2c278793          	addi	a5,a5,706 # 80021f00 <cons>
    80005c46:	0a07a703          	lw	a4,160(a5)
    80005c4a:	0017069b          	addiw	a3,a4,1
    80005c4e:	0006861b          	sext.w	a2,a3
    80005c52:	0ad7a023          	sw	a3,160(a5)
    80005c56:	07f77713          	andi	a4,a4,127
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	4729                	li	a4,10
    80005c5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c62:	0001c797          	auipc	a5,0x1c
    80005c66:	32c7ad23          	sw	a2,826(a5) # 80021f9c <cons+0x9c>
        wakeup(&cons.r);
    80005c6a:	0001c517          	auipc	a0,0x1c
    80005c6e:	32e50513          	addi	a0,a0,814 # 80021f98 <cons+0x98>
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	aa6080e7          	jalr	-1370(ra) # 80001718 <wakeup>
    80005c7a:	b575                	j	80005b26 <consoleintr+0x3c>

0000000080005c7c <consoleinit>:

void
consoleinit(void)
{
    80005c7c:	1141                	addi	sp,sp,-16
    80005c7e:	e406                	sd	ra,8(sp)
    80005c80:	e022                	sd	s0,0(sp)
    80005c82:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c84:	00003597          	auipc	a1,0x3
    80005c88:	be458593          	addi	a1,a1,-1052 # 80008868 <syscalls+0x438>
    80005c8c:	0001c517          	auipc	a0,0x1c
    80005c90:	27450513          	addi	a0,a0,628 # 80021f00 <cons>
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	580080e7          	jalr	1408(ra) # 80006214 <initlock>

  uartinit();
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	32c080e7          	jalr	812(ra) # 80005fc8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ca4:	00013797          	auipc	a5,0x13
    80005ca8:	f8478793          	addi	a5,a5,-124 # 80018c28 <devsw>
    80005cac:	00000717          	auipc	a4,0x0
    80005cb0:	ce470713          	addi	a4,a4,-796 # 80005990 <consoleread>
    80005cb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cb6:	00000717          	auipc	a4,0x0
    80005cba:	c7670713          	addi	a4,a4,-906 # 8000592c <consolewrite>
    80005cbe:	ef98                	sd	a4,24(a5)
}
    80005cc0:	60a2                	ld	ra,8(sp)
    80005cc2:	6402                	ld	s0,0(sp)
    80005cc4:	0141                	addi	sp,sp,16
    80005cc6:	8082                	ret

0000000080005cc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cc8:	7179                	addi	sp,sp,-48
    80005cca:	f406                	sd	ra,40(sp)
    80005ccc:	f022                	sd	s0,32(sp)
    80005cce:	ec26                	sd	s1,24(sp)
    80005cd0:	e84a                	sd	s2,16(sp)
    80005cd2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cd4:	c219                	beqz	a2,80005cda <printint+0x12>
    80005cd6:	08054763          	bltz	a0,80005d64 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005cda:	2501                	sext.w	a0,a0
    80005cdc:	4881                	li	a7,0
    80005cde:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ce2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ce4:	2581                	sext.w	a1,a1
    80005ce6:	00003617          	auipc	a2,0x3
    80005cea:	bb260613          	addi	a2,a2,-1102 # 80008898 <digits>
    80005cee:	883a                	mv	a6,a4
    80005cf0:	2705                	addiw	a4,a4,1
    80005cf2:	02b577bb          	remuw	a5,a0,a1
    80005cf6:	1782                	slli	a5,a5,0x20
    80005cf8:	9381                	srli	a5,a5,0x20
    80005cfa:	97b2                	add	a5,a5,a2
    80005cfc:	0007c783          	lbu	a5,0(a5)
    80005d00:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d04:	0005079b          	sext.w	a5,a0
    80005d08:	02b5553b          	divuw	a0,a0,a1
    80005d0c:	0685                	addi	a3,a3,1
    80005d0e:	feb7f0e3          	bgeu	a5,a1,80005cee <printint+0x26>

  if(sign)
    80005d12:	00088c63          	beqz	a7,80005d2a <printint+0x62>
    buf[i++] = '-';
    80005d16:	fe070793          	addi	a5,a4,-32
    80005d1a:	00878733          	add	a4,a5,s0
    80005d1e:	02d00793          	li	a5,45
    80005d22:	fef70823          	sb	a5,-16(a4)
    80005d26:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d2a:	02e05763          	blez	a4,80005d58 <printint+0x90>
    80005d2e:	fd040793          	addi	a5,s0,-48
    80005d32:	00e784b3          	add	s1,a5,a4
    80005d36:	fff78913          	addi	s2,a5,-1
    80005d3a:	993a                	add	s2,s2,a4
    80005d3c:	377d                	addiw	a4,a4,-1
    80005d3e:	1702                	slli	a4,a4,0x20
    80005d40:	9301                	srli	a4,a4,0x20
    80005d42:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d46:	fff4c503          	lbu	a0,-1(s1)
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	d5e080e7          	jalr	-674(ra) # 80005aa8 <consputc>
  while(--i >= 0)
    80005d52:	14fd                	addi	s1,s1,-1
    80005d54:	ff2499e3          	bne	s1,s2,80005d46 <printint+0x7e>
}
    80005d58:	70a2                	ld	ra,40(sp)
    80005d5a:	7402                	ld	s0,32(sp)
    80005d5c:	64e2                	ld	s1,24(sp)
    80005d5e:	6942                	ld	s2,16(sp)
    80005d60:	6145                	addi	sp,sp,48
    80005d62:	8082                	ret
    x = -xx;
    80005d64:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d68:	4885                	li	a7,1
    x = -xx;
    80005d6a:	bf95                	j	80005cde <printint+0x16>

0000000080005d6c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d6c:	1101                	addi	sp,sp,-32
    80005d6e:	ec06                	sd	ra,24(sp)
    80005d70:	e822                	sd	s0,16(sp)
    80005d72:	e426                	sd	s1,8(sp)
    80005d74:	1000                	addi	s0,sp,32
    80005d76:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d78:	0001c797          	auipc	a5,0x1c
    80005d7c:	2407a423          	sw	zero,584(a5) # 80021fc0 <pr+0x18>
  printf("panic: ");
    80005d80:	00003517          	auipc	a0,0x3
    80005d84:	af050513          	addi	a0,a0,-1296 # 80008870 <syscalls+0x440>
    80005d88:	00000097          	auipc	ra,0x0
    80005d8c:	02e080e7          	jalr	46(ra) # 80005db6 <printf>
  printf(s);
    80005d90:	8526                	mv	a0,s1
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	024080e7          	jalr	36(ra) # 80005db6 <printf>
  printf("\n");
    80005d9a:	00002517          	auipc	a0,0x2
    80005d9e:	2ae50513          	addi	a0,a0,686 # 80008048 <etext+0x48>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	014080e7          	jalr	20(ra) # 80005db6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005daa:	4785                	li	a5,1
    80005dac:	00003717          	auipc	a4,0x3
    80005db0:	bcf72823          	sw	a5,-1072(a4) # 8000897c <panicked>
  for(;;)
    80005db4:	a001                	j	80005db4 <panic+0x48>

0000000080005db6 <printf>:
{
    80005db6:	7131                	addi	sp,sp,-192
    80005db8:	fc86                	sd	ra,120(sp)
    80005dba:	f8a2                	sd	s0,112(sp)
    80005dbc:	f4a6                	sd	s1,104(sp)
    80005dbe:	f0ca                	sd	s2,96(sp)
    80005dc0:	ecce                	sd	s3,88(sp)
    80005dc2:	e8d2                	sd	s4,80(sp)
    80005dc4:	e4d6                	sd	s5,72(sp)
    80005dc6:	e0da                	sd	s6,64(sp)
    80005dc8:	fc5e                	sd	s7,56(sp)
    80005dca:	f862                	sd	s8,48(sp)
    80005dcc:	f466                	sd	s9,40(sp)
    80005dce:	f06a                	sd	s10,32(sp)
    80005dd0:	ec6e                	sd	s11,24(sp)
    80005dd2:	0100                	addi	s0,sp,128
    80005dd4:	8a2a                	mv	s4,a0
    80005dd6:	e40c                	sd	a1,8(s0)
    80005dd8:	e810                	sd	a2,16(s0)
    80005dda:	ec14                	sd	a3,24(s0)
    80005ddc:	f018                	sd	a4,32(s0)
    80005dde:	f41c                	sd	a5,40(s0)
    80005de0:	03043823          	sd	a6,48(s0)
    80005de4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005de8:	0001cd97          	auipc	s11,0x1c
    80005dec:	1d8dad83          	lw	s11,472(s11) # 80021fc0 <pr+0x18>
  if(locking)
    80005df0:	020d9b63          	bnez	s11,80005e26 <printf+0x70>
  if (fmt == 0)
    80005df4:	040a0263          	beqz	s4,80005e38 <printf+0x82>
  va_start(ap, fmt);
    80005df8:	00840793          	addi	a5,s0,8
    80005dfc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e00:	000a4503          	lbu	a0,0(s4)
    80005e04:	14050f63          	beqz	a0,80005f62 <printf+0x1ac>
    80005e08:	4981                	li	s3,0
    if(c != '%'){
    80005e0a:	02500a93          	li	s5,37
    switch(c){
    80005e0e:	07000b93          	li	s7,112
  consputc('x');
    80005e12:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e14:	00003b17          	auipc	s6,0x3
    80005e18:	a84b0b13          	addi	s6,s6,-1404 # 80008898 <digits>
    switch(c){
    80005e1c:	07300c93          	li	s9,115
    80005e20:	06400c13          	li	s8,100
    80005e24:	a82d                	j	80005e5e <printf+0xa8>
    acquire(&pr.lock);
    80005e26:	0001c517          	auipc	a0,0x1c
    80005e2a:	18250513          	addi	a0,a0,386 # 80021fa8 <pr>
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	476080e7          	jalr	1142(ra) # 800062a4 <acquire>
    80005e36:	bf7d                	j	80005df4 <printf+0x3e>
    panic("null fmt");
    80005e38:	00003517          	auipc	a0,0x3
    80005e3c:	a4850513          	addi	a0,a0,-1464 # 80008880 <syscalls+0x450>
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	f2c080e7          	jalr	-212(ra) # 80005d6c <panic>
      consputc(c);
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	c60080e7          	jalr	-928(ra) # 80005aa8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e50:	2985                	addiw	s3,s3,1
    80005e52:	013a07b3          	add	a5,s4,s3
    80005e56:	0007c503          	lbu	a0,0(a5)
    80005e5a:	10050463          	beqz	a0,80005f62 <printf+0x1ac>
    if(c != '%'){
    80005e5e:	ff5515e3          	bne	a0,s5,80005e48 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e62:	2985                	addiw	s3,s3,1
    80005e64:	013a07b3          	add	a5,s4,s3
    80005e68:	0007c783          	lbu	a5,0(a5)
    80005e6c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e70:	cbed                	beqz	a5,80005f62 <printf+0x1ac>
    switch(c){
    80005e72:	05778a63          	beq	a5,s7,80005ec6 <printf+0x110>
    80005e76:	02fbf663          	bgeu	s7,a5,80005ea2 <printf+0xec>
    80005e7a:	09978863          	beq	a5,s9,80005f0a <printf+0x154>
    80005e7e:	07800713          	li	a4,120
    80005e82:	0ce79563          	bne	a5,a4,80005f4c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e86:	f8843783          	ld	a5,-120(s0)
    80005e8a:	00878713          	addi	a4,a5,8
    80005e8e:	f8e43423          	sd	a4,-120(s0)
    80005e92:	4605                	li	a2,1
    80005e94:	85ea                	mv	a1,s10
    80005e96:	4388                	lw	a0,0(a5)
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	e30080e7          	jalr	-464(ra) # 80005cc8 <printint>
      break;
    80005ea0:	bf45                	j	80005e50 <printf+0x9a>
    switch(c){
    80005ea2:	09578f63          	beq	a5,s5,80005f40 <printf+0x18a>
    80005ea6:	0b879363          	bne	a5,s8,80005f4c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005eaa:	f8843783          	ld	a5,-120(s0)
    80005eae:	00878713          	addi	a4,a5,8
    80005eb2:	f8e43423          	sd	a4,-120(s0)
    80005eb6:	4605                	li	a2,1
    80005eb8:	45a9                	li	a1,10
    80005eba:	4388                	lw	a0,0(a5)
    80005ebc:	00000097          	auipc	ra,0x0
    80005ec0:	e0c080e7          	jalr	-500(ra) # 80005cc8 <printint>
      break;
    80005ec4:	b771                	j	80005e50 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ec6:	f8843783          	ld	a5,-120(s0)
    80005eca:	00878713          	addi	a4,a5,8
    80005ece:	f8e43423          	sd	a4,-120(s0)
    80005ed2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ed6:	03000513          	li	a0,48
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	bce080e7          	jalr	-1074(ra) # 80005aa8 <consputc>
  consputc('x');
    80005ee2:	07800513          	li	a0,120
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	bc2080e7          	jalr	-1086(ra) # 80005aa8 <consputc>
    80005eee:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ef0:	03c95793          	srli	a5,s2,0x3c
    80005ef4:	97da                	add	a5,a5,s6
    80005ef6:	0007c503          	lbu	a0,0(a5)
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	bae080e7          	jalr	-1106(ra) # 80005aa8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f02:	0912                	slli	s2,s2,0x4
    80005f04:	34fd                	addiw	s1,s1,-1
    80005f06:	f4ed                	bnez	s1,80005ef0 <printf+0x13a>
    80005f08:	b7a1                	j	80005e50 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f0a:	f8843783          	ld	a5,-120(s0)
    80005f0e:	00878713          	addi	a4,a5,8
    80005f12:	f8e43423          	sd	a4,-120(s0)
    80005f16:	6384                	ld	s1,0(a5)
    80005f18:	cc89                	beqz	s1,80005f32 <printf+0x17c>
      for(; *s; s++)
    80005f1a:	0004c503          	lbu	a0,0(s1)
    80005f1e:	d90d                	beqz	a0,80005e50 <printf+0x9a>
        consputc(*s);
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	b88080e7          	jalr	-1144(ra) # 80005aa8 <consputc>
      for(; *s; s++)
    80005f28:	0485                	addi	s1,s1,1
    80005f2a:	0004c503          	lbu	a0,0(s1)
    80005f2e:	f96d                	bnez	a0,80005f20 <printf+0x16a>
    80005f30:	b705                	j	80005e50 <printf+0x9a>
        s = "(null)";
    80005f32:	00003497          	auipc	s1,0x3
    80005f36:	94648493          	addi	s1,s1,-1722 # 80008878 <syscalls+0x448>
      for(; *s; s++)
    80005f3a:	02800513          	li	a0,40
    80005f3e:	b7cd                	j	80005f20 <printf+0x16a>
      consputc('%');
    80005f40:	8556                	mv	a0,s5
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	b66080e7          	jalr	-1178(ra) # 80005aa8 <consputc>
      break;
    80005f4a:	b719                	j	80005e50 <printf+0x9a>
      consputc('%');
    80005f4c:	8556                	mv	a0,s5
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	b5a080e7          	jalr	-1190(ra) # 80005aa8 <consputc>
      consputc(c);
    80005f56:	8526                	mv	a0,s1
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	b50080e7          	jalr	-1200(ra) # 80005aa8 <consputc>
      break;
    80005f60:	bdc5                	j	80005e50 <printf+0x9a>
  if(locking)
    80005f62:	020d9163          	bnez	s11,80005f84 <printf+0x1ce>
}
    80005f66:	70e6                	ld	ra,120(sp)
    80005f68:	7446                	ld	s0,112(sp)
    80005f6a:	74a6                	ld	s1,104(sp)
    80005f6c:	7906                	ld	s2,96(sp)
    80005f6e:	69e6                	ld	s3,88(sp)
    80005f70:	6a46                	ld	s4,80(sp)
    80005f72:	6aa6                	ld	s5,72(sp)
    80005f74:	6b06                	ld	s6,64(sp)
    80005f76:	7be2                	ld	s7,56(sp)
    80005f78:	7c42                	ld	s8,48(sp)
    80005f7a:	7ca2                	ld	s9,40(sp)
    80005f7c:	7d02                	ld	s10,32(sp)
    80005f7e:	6de2                	ld	s11,24(sp)
    80005f80:	6129                	addi	sp,sp,192
    80005f82:	8082                	ret
    release(&pr.lock);
    80005f84:	0001c517          	auipc	a0,0x1c
    80005f88:	02450513          	addi	a0,a0,36 # 80021fa8 <pr>
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	3cc080e7          	jalr	972(ra) # 80006358 <release>
}
    80005f94:	bfc9                	j	80005f66 <printf+0x1b0>

0000000080005f96 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f96:	1101                	addi	sp,sp,-32
    80005f98:	ec06                	sd	ra,24(sp)
    80005f9a:	e822                	sd	s0,16(sp)
    80005f9c:	e426                	sd	s1,8(sp)
    80005f9e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fa0:	0001c497          	auipc	s1,0x1c
    80005fa4:	00848493          	addi	s1,s1,8 # 80021fa8 <pr>
    80005fa8:	00003597          	auipc	a1,0x3
    80005fac:	8e858593          	addi	a1,a1,-1816 # 80008890 <syscalls+0x460>
    80005fb0:	8526                	mv	a0,s1
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	262080e7          	jalr	610(ra) # 80006214 <initlock>
  pr.locking = 1;
    80005fba:	4785                	li	a5,1
    80005fbc:	cc9c                	sw	a5,24(s1)
}
    80005fbe:	60e2                	ld	ra,24(sp)
    80005fc0:	6442                	ld	s0,16(sp)
    80005fc2:	64a2                	ld	s1,8(sp)
    80005fc4:	6105                	addi	sp,sp,32
    80005fc6:	8082                	ret

0000000080005fc8 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fc8:	1141                	addi	sp,sp,-16
    80005fca:	e406                	sd	ra,8(sp)
    80005fcc:	e022                	sd	s0,0(sp)
    80005fce:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fd0:	100007b7          	lui	a5,0x10000
    80005fd4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fd8:	f8000713          	li	a4,-128
    80005fdc:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fe0:	470d                	li	a4,3
    80005fe2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fe6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fea:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fee:	469d                	li	a3,7
    80005ff0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ff4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ff8:	00003597          	auipc	a1,0x3
    80005ffc:	8b858593          	addi	a1,a1,-1864 # 800088b0 <digits+0x18>
    80006000:	0001c517          	auipc	a0,0x1c
    80006004:	fc850513          	addi	a0,a0,-56 # 80021fc8 <uart_tx_lock>
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	20c080e7          	jalr	524(ra) # 80006214 <initlock>
}
    80006010:	60a2                	ld	ra,8(sp)
    80006012:	6402                	ld	s0,0(sp)
    80006014:	0141                	addi	sp,sp,16
    80006016:	8082                	ret

0000000080006018 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006018:	1101                	addi	sp,sp,-32
    8000601a:	ec06                	sd	ra,24(sp)
    8000601c:	e822                	sd	s0,16(sp)
    8000601e:	e426                	sd	s1,8(sp)
    80006020:	1000                	addi	s0,sp,32
    80006022:	84aa                	mv	s1,a0
  push_off();
    80006024:	00000097          	auipc	ra,0x0
    80006028:	234080e7          	jalr	564(ra) # 80006258 <push_off>

  if(panicked){
    8000602c:	00003797          	auipc	a5,0x3
    80006030:	9507a783          	lw	a5,-1712(a5) # 8000897c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006034:	10000737          	lui	a4,0x10000
  if(panicked){
    80006038:	c391                	beqz	a5,8000603c <uartputc_sync+0x24>
    for(;;)
    8000603a:	a001                	j	8000603a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000603c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006040:	0207f793          	andi	a5,a5,32
    80006044:	dfe5                	beqz	a5,8000603c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006046:	0ff4f513          	zext.b	a0,s1
    8000604a:	100007b7          	lui	a5,0x10000
    8000604e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006052:	00000097          	auipc	ra,0x0
    80006056:	2a6080e7          	jalr	678(ra) # 800062f8 <pop_off>
}
    8000605a:	60e2                	ld	ra,24(sp)
    8000605c:	6442                	ld	s0,16(sp)
    8000605e:	64a2                	ld	s1,8(sp)
    80006060:	6105                	addi	sp,sp,32
    80006062:	8082                	ret

0000000080006064 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006064:	00003797          	auipc	a5,0x3
    80006068:	91c7b783          	ld	a5,-1764(a5) # 80008980 <uart_tx_r>
    8000606c:	00003717          	auipc	a4,0x3
    80006070:	91c73703          	ld	a4,-1764(a4) # 80008988 <uart_tx_w>
    80006074:	06f70a63          	beq	a4,a5,800060e8 <uartstart+0x84>
{
    80006078:	7139                	addi	sp,sp,-64
    8000607a:	fc06                	sd	ra,56(sp)
    8000607c:	f822                	sd	s0,48(sp)
    8000607e:	f426                	sd	s1,40(sp)
    80006080:	f04a                	sd	s2,32(sp)
    80006082:	ec4e                	sd	s3,24(sp)
    80006084:	e852                	sd	s4,16(sp)
    80006086:	e456                	sd	s5,8(sp)
    80006088:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000608a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000608e:	0001ca17          	auipc	s4,0x1c
    80006092:	f3aa0a13          	addi	s4,s4,-198 # 80021fc8 <uart_tx_lock>
    uart_tx_r += 1;
    80006096:	00003497          	auipc	s1,0x3
    8000609a:	8ea48493          	addi	s1,s1,-1814 # 80008980 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000609e:	00003997          	auipc	s3,0x3
    800060a2:	8ea98993          	addi	s3,s3,-1814 # 80008988 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060a6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060aa:	02077713          	andi	a4,a4,32
    800060ae:	c705                	beqz	a4,800060d6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b0:	01f7f713          	andi	a4,a5,31
    800060b4:	9752                	add	a4,a4,s4
    800060b6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ba:	0785                	addi	a5,a5,1
    800060bc:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060be:	8526                	mv	a0,s1
    800060c0:	ffffb097          	auipc	ra,0xffffb
    800060c4:	658080e7          	jalr	1624(ra) # 80001718 <wakeup>
    
    WriteReg(THR, c);
    800060c8:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060cc:	609c                	ld	a5,0(s1)
    800060ce:	0009b703          	ld	a4,0(s3)
    800060d2:	fcf71ae3          	bne	a4,a5,800060a6 <uartstart+0x42>
  }
}
    800060d6:	70e2                	ld	ra,56(sp)
    800060d8:	7442                	ld	s0,48(sp)
    800060da:	74a2                	ld	s1,40(sp)
    800060dc:	7902                	ld	s2,32(sp)
    800060de:	69e2                	ld	s3,24(sp)
    800060e0:	6a42                	ld	s4,16(sp)
    800060e2:	6aa2                	ld	s5,8(sp)
    800060e4:	6121                	addi	sp,sp,64
    800060e6:	8082                	ret
    800060e8:	8082                	ret

00000000800060ea <uartputc>:
{
    800060ea:	7179                	addi	sp,sp,-48
    800060ec:	f406                	sd	ra,40(sp)
    800060ee:	f022                	sd	s0,32(sp)
    800060f0:	ec26                	sd	s1,24(sp)
    800060f2:	e84a                	sd	s2,16(sp)
    800060f4:	e44e                	sd	s3,8(sp)
    800060f6:	e052                	sd	s4,0(sp)
    800060f8:	1800                	addi	s0,sp,48
    800060fa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060fc:	0001c517          	auipc	a0,0x1c
    80006100:	ecc50513          	addi	a0,a0,-308 # 80021fc8 <uart_tx_lock>
    80006104:	00000097          	auipc	ra,0x0
    80006108:	1a0080e7          	jalr	416(ra) # 800062a4 <acquire>
  if(panicked){
    8000610c:	00003797          	auipc	a5,0x3
    80006110:	8707a783          	lw	a5,-1936(a5) # 8000897c <panicked>
    80006114:	e7c9                	bnez	a5,8000619e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006116:	00003717          	auipc	a4,0x3
    8000611a:	87273703          	ld	a4,-1934(a4) # 80008988 <uart_tx_w>
    8000611e:	00003797          	auipc	a5,0x3
    80006122:	8627b783          	ld	a5,-1950(a5) # 80008980 <uart_tx_r>
    80006126:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000612a:	0001c997          	auipc	s3,0x1c
    8000612e:	e9e98993          	addi	s3,s3,-354 # 80021fc8 <uart_tx_lock>
    80006132:	00003497          	auipc	s1,0x3
    80006136:	84e48493          	addi	s1,s1,-1970 # 80008980 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613a:	00003917          	auipc	s2,0x3
    8000613e:	84e90913          	addi	s2,s2,-1970 # 80008988 <uart_tx_w>
    80006142:	00e79f63          	bne	a5,a4,80006160 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006146:	85ce                	mv	a1,s3
    80006148:	8526                	mv	a0,s1
    8000614a:	ffffb097          	auipc	ra,0xffffb
    8000614e:	56a080e7          	jalr	1386(ra) # 800016b4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006152:	00093703          	ld	a4,0(s2)
    80006156:	609c                	ld	a5,0(s1)
    80006158:	02078793          	addi	a5,a5,32
    8000615c:	fee785e3          	beq	a5,a4,80006146 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006160:	0001c497          	auipc	s1,0x1c
    80006164:	e6848493          	addi	s1,s1,-408 # 80021fc8 <uart_tx_lock>
    80006168:	01f77793          	andi	a5,a4,31
    8000616c:	97a6                	add	a5,a5,s1
    8000616e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006172:	0705                	addi	a4,a4,1
    80006174:	00003797          	auipc	a5,0x3
    80006178:	80e7ba23          	sd	a4,-2028(a5) # 80008988 <uart_tx_w>
  uartstart();
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	ee8080e7          	jalr	-280(ra) # 80006064 <uartstart>
  release(&uart_tx_lock);
    80006184:	8526                	mv	a0,s1
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	1d2080e7          	jalr	466(ra) # 80006358 <release>
}
    8000618e:	70a2                	ld	ra,40(sp)
    80006190:	7402                	ld	s0,32(sp)
    80006192:	64e2                	ld	s1,24(sp)
    80006194:	6942                	ld	s2,16(sp)
    80006196:	69a2                	ld	s3,8(sp)
    80006198:	6a02                	ld	s4,0(sp)
    8000619a:	6145                	addi	sp,sp,48
    8000619c:	8082                	ret
    for(;;)
    8000619e:	a001                	j	8000619e <uartputc+0xb4>

00000000800061a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061a0:	1141                	addi	sp,sp,-16
    800061a2:	e422                	sd	s0,8(sp)
    800061a4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061a6:	100007b7          	lui	a5,0x10000
    800061aa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061ae:	8b85                	andi	a5,a5,1
    800061b0:	cb81                	beqz	a5,800061c0 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061b2:	100007b7          	lui	a5,0x10000
    800061b6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ba:	6422                	ld	s0,8(sp)
    800061bc:	0141                	addi	sp,sp,16
    800061be:	8082                	ret
    return -1;
    800061c0:	557d                	li	a0,-1
    800061c2:	bfe5                	j	800061ba <uartgetc+0x1a>

00000000800061c4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061c4:	1101                	addi	sp,sp,-32
    800061c6:	ec06                	sd	ra,24(sp)
    800061c8:	e822                	sd	s0,16(sp)
    800061ca:	e426                	sd	s1,8(sp)
    800061cc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061ce:	54fd                	li	s1,-1
    800061d0:	a029                	j	800061da <uartintr+0x16>
      break;
    consoleintr(c);
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	918080e7          	jalr	-1768(ra) # 80005aea <consoleintr>
    int c = uartgetc();
    800061da:	00000097          	auipc	ra,0x0
    800061de:	fc6080e7          	jalr	-58(ra) # 800061a0 <uartgetc>
    if(c == -1)
    800061e2:	fe9518e3          	bne	a0,s1,800061d2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061e6:	0001c497          	auipc	s1,0x1c
    800061ea:	de248493          	addi	s1,s1,-542 # 80021fc8 <uart_tx_lock>
    800061ee:	8526                	mv	a0,s1
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	0b4080e7          	jalr	180(ra) # 800062a4 <acquire>
  uartstart();
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	e6c080e7          	jalr	-404(ra) # 80006064 <uartstart>
  release(&uart_tx_lock);
    80006200:	8526                	mv	a0,s1
    80006202:	00000097          	auipc	ra,0x0
    80006206:	156080e7          	jalr	342(ra) # 80006358 <release>
}
    8000620a:	60e2                	ld	ra,24(sp)
    8000620c:	6442                	ld	s0,16(sp)
    8000620e:	64a2                	ld	s1,8(sp)
    80006210:	6105                	addi	sp,sp,32
    80006212:	8082                	ret

0000000080006214 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006214:	1141                	addi	sp,sp,-16
    80006216:	e422                	sd	s0,8(sp)
    80006218:	0800                	addi	s0,sp,16
  lk->name = name;
    8000621a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000621c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006220:	00053823          	sd	zero,16(a0)
}
    80006224:	6422                	ld	s0,8(sp)
    80006226:	0141                	addi	sp,sp,16
    80006228:	8082                	ret

000000008000622a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000622a:	411c                	lw	a5,0(a0)
    8000622c:	e399                	bnez	a5,80006232 <holding+0x8>
    8000622e:	4501                	li	a0,0
  return r;
}
    80006230:	8082                	ret
{
    80006232:	1101                	addi	sp,sp,-32
    80006234:	ec06                	sd	ra,24(sp)
    80006236:	e822                	sd	s0,16(sp)
    80006238:	e426                	sd	s1,8(sp)
    8000623a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000623c:	6904                	ld	s1,16(a0)
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	d02080e7          	jalr	-766(ra) # 80000f40 <mycpu>
    80006246:	40a48533          	sub	a0,s1,a0
    8000624a:	00153513          	seqz	a0,a0
}
    8000624e:	60e2                	ld	ra,24(sp)
    80006250:	6442                	ld	s0,16(sp)
    80006252:	64a2                	ld	s1,8(sp)
    80006254:	6105                	addi	sp,sp,32
    80006256:	8082                	ret

0000000080006258 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006258:	1101                	addi	sp,sp,-32
    8000625a:	ec06                	sd	ra,24(sp)
    8000625c:	e822                	sd	s0,16(sp)
    8000625e:	e426                	sd	s1,8(sp)
    80006260:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100024f3          	csrr	s1,sstatus
    80006266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000626a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	cd0080e7          	jalr	-816(ra) # 80000f40 <mycpu>
    80006278:	5d3c                	lw	a5,120(a0)
    8000627a:	cf89                	beqz	a5,80006294 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000627c:	ffffb097          	auipc	ra,0xffffb
    80006280:	cc4080e7          	jalr	-828(ra) # 80000f40 <mycpu>
    80006284:	5d3c                	lw	a5,120(a0)
    80006286:	2785                	addiw	a5,a5,1
    80006288:	dd3c                	sw	a5,120(a0)
}
    8000628a:	60e2                	ld	ra,24(sp)
    8000628c:	6442                	ld	s0,16(sp)
    8000628e:	64a2                	ld	s1,8(sp)
    80006290:	6105                	addi	sp,sp,32
    80006292:	8082                	ret
    mycpu()->intena = old;
    80006294:	ffffb097          	auipc	ra,0xffffb
    80006298:	cac080e7          	jalr	-852(ra) # 80000f40 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000629c:	8085                	srli	s1,s1,0x1
    8000629e:	8885                	andi	s1,s1,1
    800062a0:	dd64                	sw	s1,124(a0)
    800062a2:	bfe9                	j	8000627c <push_off+0x24>

00000000800062a4 <acquire>:
{
    800062a4:	1101                	addi	sp,sp,-32
    800062a6:	ec06                	sd	ra,24(sp)
    800062a8:	e822                	sd	s0,16(sp)
    800062aa:	e426                	sd	s1,8(sp)
    800062ac:	1000                	addi	s0,sp,32
    800062ae:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062b0:	00000097          	auipc	ra,0x0
    800062b4:	fa8080e7          	jalr	-88(ra) # 80006258 <push_off>
  if(holding(lk))
    800062b8:	8526                	mv	a0,s1
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	f70080e7          	jalr	-144(ra) # 8000622a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c2:	4705                	li	a4,1
  if(holding(lk))
    800062c4:	e115                	bnez	a0,800062e8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c6:	87ba                	mv	a5,a4
    800062c8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062cc:	2781                	sext.w	a5,a5
    800062ce:	ffe5                	bnez	a5,800062c6 <acquire+0x22>
  __sync_synchronize();
    800062d0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062d4:	ffffb097          	auipc	ra,0xffffb
    800062d8:	c6c080e7          	jalr	-916(ra) # 80000f40 <mycpu>
    800062dc:	e888                	sd	a0,16(s1)
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret
    panic("acquire");
    800062e8:	00002517          	auipc	a0,0x2
    800062ec:	5d050513          	addi	a0,a0,1488 # 800088b8 <digits+0x20>
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	a7c080e7          	jalr	-1412(ra) # 80005d6c <panic>

00000000800062f8 <pop_off>:

void
pop_off(void)
{
    800062f8:	1141                	addi	sp,sp,-16
    800062fa:	e406                	sd	ra,8(sp)
    800062fc:	e022                	sd	s0,0(sp)
    800062fe:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006300:	ffffb097          	auipc	ra,0xffffb
    80006304:	c40080e7          	jalr	-960(ra) # 80000f40 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006308:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000630c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000630e:	e78d                	bnez	a5,80006338 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006310:	5d3c                	lw	a5,120(a0)
    80006312:	02f05b63          	blez	a5,80006348 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006316:	37fd                	addiw	a5,a5,-1
    80006318:	0007871b          	sext.w	a4,a5
    8000631c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000631e:	eb09                	bnez	a4,80006330 <pop_off+0x38>
    80006320:	5d7c                	lw	a5,124(a0)
    80006322:	c799                	beqz	a5,80006330 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006324:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006328:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000632c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006330:	60a2                	ld	ra,8(sp)
    80006332:	6402                	ld	s0,0(sp)
    80006334:	0141                	addi	sp,sp,16
    80006336:	8082                	ret
    panic("pop_off - interruptible");
    80006338:	00002517          	auipc	a0,0x2
    8000633c:	58850513          	addi	a0,a0,1416 # 800088c0 <digits+0x28>
    80006340:	00000097          	auipc	ra,0x0
    80006344:	a2c080e7          	jalr	-1492(ra) # 80005d6c <panic>
    panic("pop_off");
    80006348:	00002517          	auipc	a0,0x2
    8000634c:	59050513          	addi	a0,a0,1424 # 800088d8 <digits+0x40>
    80006350:	00000097          	auipc	ra,0x0
    80006354:	a1c080e7          	jalr	-1508(ra) # 80005d6c <panic>

0000000080006358 <release>:
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	1000                	addi	s0,sp,32
    80006362:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006364:	00000097          	auipc	ra,0x0
    80006368:	ec6080e7          	jalr	-314(ra) # 8000622a <holding>
    8000636c:	c115                	beqz	a0,80006390 <release+0x38>
  lk->cpu = 0;
    8000636e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006372:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006376:	0f50000f          	fence	iorw,ow
    8000637a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	f7a080e7          	jalr	-134(ra) # 800062f8 <pop_off>
}
    80006386:	60e2                	ld	ra,24(sp)
    80006388:	6442                	ld	s0,16(sp)
    8000638a:	64a2                	ld	s1,8(sp)
    8000638c:	6105                	addi	sp,sp,32
    8000638e:	8082                	ret
    panic("release");
    80006390:	00002517          	auipc	a0,0x2
    80006394:	55050513          	addi	a0,a0,1360 # 800088e0 <digits+0x48>
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	9d4080e7          	jalr	-1580(ra) # 80005d6c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
