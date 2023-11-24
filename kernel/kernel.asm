
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0a3050ef          	jal	ra,800058b8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <get_page_num>:
  int ref_counts[MAX_PAGE_NUM];
} kmem;



int get_page_num(void *pa) {
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
	uint64 start = PGROUNDUP(KERNBASE);
	return (int) (((uint64) (pa) - start) / PGSIZE);
    80000022:	800007b7          	lui	a5,0x80000
    80000026:	953e                	add	a0,a0,a5
    80000028:	8131                	srli	a0,a0,0xc
}
    8000002a:	2501                	sext.w	a0,a0
    8000002c:	6422                	ld	s0,8(sp)
    8000002e:	0141                	addi	sp,sp,16
    80000030:	8082                	ret

0000000080000032 <incr_ref_count>:

int incr_ref_count(void *pa, int count) {
    80000032:	1101                	addi	sp,sp,-32
    80000034:	ec06                	sd	ra,24(sp)
    80000036:	e822                	sd	s0,16(sp)
    80000038:	e426                	sd	s1,8(sp)
    8000003a:	e04a                	sd	s2,0(sp)
    8000003c:	1000                	addi	s0,sp,32
    8000003e:	892e                	mv	s2,a1
	return (int) (((uint64) (pa) - start) / PGSIZE);
    80000040:	800007b7          	lui	a5,0x80000
    80000044:	00f504b3          	add	s1,a0,a5
    80000048:	80b1                	srli	s1,s1,0xc
    8000004a:	2481                	sext.w	s1,s1
	int page_num = get_page_num(pa);
	acquire(&kmem.lock);
    8000004c:	00009517          	auipc	a0,0x9
    80000050:	89450513          	addi	a0,a0,-1900 # 800088e0 <kmem>
    80000054:	00006097          	auipc	ra,0x6
    80000058:	2a0080e7          	jalr	672(ra) # 800062f4 <acquire>
	kmem.ref_counts[page_num] += count;
    8000005c:	00009517          	auipc	a0,0x9
    80000060:	88450513          	addi	a0,a0,-1916 # 800088e0 <kmem>
    80000064:	00848793          	addi	a5,s1,8
    80000068:	078a                	slli	a5,a5,0x2
    8000006a:	97aa                	add	a5,a5,a0
    8000006c:	4398                	lw	a4,0(a5)
    8000006e:	012705bb          	addw	a1,a4,s2
    80000072:	0005849b          	sext.w	s1,a1
    80000076:	c38c                	sw	a1,0(a5)
	int now_count = kmem.ref_counts[page_num];
	//printf("p: %p, page num: %d\n", pa, page_num);
	release(&kmem.lock);
    80000078:	00006097          	auipc	ra,0x6
    8000007c:	330080e7          	jalr	816(ra) # 800063a8 <release>
	return now_count;
}
    80000080:	8526                	mv	a0,s1
    80000082:	60e2                	ld	ra,24(sp)
    80000084:	6442                	ld	s0,16(sp)
    80000086:	64a2                	ld	s1,8(sp)
    80000088:	6902                	ld	s2,0(sp)
    8000008a:	6105                	addi	sp,sp,32
    8000008c:	8082                	ret

000000008000008e <get_ref_count>:

int get_ref_count(void *pa) {
    8000008e:	1101                	addi	sp,sp,-32
    80000090:	ec06                	sd	ra,24(sp)
    80000092:	e822                	sd	s0,16(sp)
    80000094:	e426                	sd	s1,8(sp)
    80000096:	1000                	addi	s0,sp,32
    80000098:	84aa                	mv	s1,a0
	int page_num = get_page_num(pa);
	int now_count = 0;
	acquire(&kmem.lock);
    8000009a:	00009517          	auipc	a0,0x9
    8000009e:	84650513          	addi	a0,a0,-1978 # 800088e0 <kmem>
    800000a2:	00006097          	auipc	ra,0x6
    800000a6:	252080e7          	jalr	594(ra) # 800062f4 <acquire>
	now_count = kmem.ref_counts[page_num];
    800000aa:	00009517          	auipc	a0,0x9
    800000ae:	83650513          	addi	a0,a0,-1994 # 800088e0 <kmem>
	return (int) (((uint64) (pa) - start) / PGSIZE);
    800000b2:	800007b7          	lui	a5,0x80000
    800000b6:	97a6                	add	a5,a5,s1
    800000b8:	83b1                	srli	a5,a5,0xc
	now_count = kmem.ref_counts[page_num];
    800000ba:	2781                	sext.w	a5,a5
    800000bc:	07a1                	addi	a5,a5,8 # ffffffff80000008 <end+0xfffffffefffbe2b8>
    800000be:	078a                	slli	a5,a5,0x2
    800000c0:	97aa                	add	a5,a5,a0
    800000c2:	4384                	lw	s1,0(a5)
	release(&kmem.lock);
    800000c4:	00006097          	auipc	ra,0x6
    800000c8:	2e4080e7          	jalr	740(ra) # 800063a8 <release>
	return now_count;
}
    800000cc:	8526                	mv	a0,s1
    800000ce:	60e2                	ld	ra,24(sp)
    800000d0:	6442                	ld	s0,16(sp)
    800000d2:	64a2                	ld	s1,8(sp)
    800000d4:	6105                	addi	sp,sp,32
    800000d6:	8082                	ret

00000000800000d8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000d8:	1101                	addi	sp,sp,-32
    800000da:	ec06                	sd	ra,24(sp)
    800000dc:	e822                	sd	s0,16(sp)
    800000de:	e426                	sd	s1,8(sp)
    800000e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000e2:	03451793          	slli	a5,a0,0x34
    800000e6:	eb85                	bnez	a5,80000116 <kfree+0x3e>
    800000e8:	84aa                	mv	s1,a0
    800000ea:	00042797          	auipc	a5,0x42
    800000ee:	c6678793          	addi	a5,a5,-922 # 80041d50 <end>
    800000f2:	02f56263          	bltu	a0,a5,80000116 <kfree+0x3e>
    800000f6:	47c5                	li	a5,17
    800000f8:	07ee                	slli	a5,a5,0x1b
    800000fa:	00f57e63          	bgeu	a0,a5,80000116 <kfree+0x3e>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);*/
  int now_count = incr_ref_count(pa, -1);
    800000fe:	55fd                	li	a1,-1
    80000100:	00000097          	auipc	ra,0x0
    80000104:	f32080e7          	jalr	-206(ra) # 80000032 <incr_ref_count>
  if(now_count <= 0) {
    80000108:	00a05f63          	blez	a0,80000126 <kfree+0x4e>
	acquire(&kmem.lock);
	r->next = kmem.freelist;
	kmem.freelist = r;
	release(&kmem.lock);
  }
}
    8000010c:	60e2                	ld	ra,24(sp)
    8000010e:	6442                	ld	s0,16(sp)
    80000110:	64a2                	ld	s1,8(sp)
    80000112:	6105                	addi	sp,sp,32
    80000114:	8082                	ret
    panic("kfree");
    80000116:	00008517          	auipc	a0,0x8
    8000011a:	efa50513          	addi	a0,a0,-262 # 80008010 <etext+0x10>
    8000011e:	00006097          	auipc	ra,0x6
    80000122:	c4e080e7          	jalr	-946(ra) # 80005d6c <panic>
  	memset(pa, 1, PGSIZE);
    80000126:	6605                	lui	a2,0x1
    80000128:	4585                	li	a1,1
    8000012a:	8526                	mv	a0,s1
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	144080e7          	jalr	324(ra) # 80000270 <memset>
	acquire(&kmem.lock);
    80000134:	00008517          	auipc	a0,0x8
    80000138:	7ac50513          	addi	a0,a0,1964 # 800088e0 <kmem>
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	1b8080e7          	jalr	440(ra) # 800062f4 <acquire>
	r->next = kmem.freelist;
    80000144:	00008517          	auipc	a0,0x8
    80000148:	79c50513          	addi	a0,a0,1948 # 800088e0 <kmem>
    8000014c:	6d1c                	ld	a5,24(a0)
    8000014e:	e09c                	sd	a5,0(s1)
	kmem.freelist = r;
    80000150:	ed04                	sd	s1,24(a0)
	release(&kmem.lock);
    80000152:	00006097          	auipc	ra,0x6
    80000156:	256080e7          	jalr	598(ra) # 800063a8 <release>
}
    8000015a:	bf4d                	j	8000010c <kfree+0x34>

000000008000015c <freerange>:
{
    8000015c:	7179                	addi	sp,sp,-48
    8000015e:	f406                	sd	ra,40(sp)
    80000160:	f022                	sd	s0,32(sp)
    80000162:	ec26                	sd	s1,24(sp)
    80000164:	e84a                	sd	s2,16(sp)
    80000166:	e44e                	sd	s3,8(sp)
    80000168:	e052                	sd	s4,0(sp)
    8000016a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000016c:	6785                	lui	a5,0x1
    8000016e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000172:	00e504b3          	add	s1,a0,a4
    80000176:	777d                	lui	a4,0xfffff
    80000178:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000017a:	94be                	add	s1,s1,a5
    8000017c:	0095ee63          	bltu	a1,s1,80000198 <freerange+0x3c>
    80000180:	892e                	mv	s2,a1
    kfree(p);
    80000182:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000184:	6985                	lui	s3,0x1
    kfree(p);
    80000186:	01448533          	add	a0,s1,s4
    8000018a:	00000097          	auipc	ra,0x0
    8000018e:	f4e080e7          	jalr	-178(ra) # 800000d8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000192:	94ce                	add	s1,s1,s3
    80000194:	fe9979e3          	bgeu	s2,s1,80000186 <freerange+0x2a>
}
    80000198:	70a2                	ld	ra,40(sp)
    8000019a:	7402                	ld	s0,32(sp)
    8000019c:	64e2                	ld	s1,24(sp)
    8000019e:	6942                	ld	s2,16(sp)
    800001a0:	69a2                	ld	s3,8(sp)
    800001a2:	6a02                	ld	s4,0(sp)
    800001a4:	6145                	addi	sp,sp,48
    800001a6:	8082                	ret

00000000800001a8 <kinit>:
{
    800001a8:	1141                	addi	sp,sp,-16
    800001aa:	e406                	sd	ra,8(sp)
    800001ac:	e022                	sd	s0,0(sp)
    800001ae:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001b0:	00008597          	auipc	a1,0x8
    800001b4:	e6858593          	addi	a1,a1,-408 # 80008018 <etext+0x18>
    800001b8:	00008517          	auipc	a0,0x8
    800001bc:	72850513          	addi	a0,a0,1832 # 800088e0 <kmem>
    800001c0:	00006097          	auipc	ra,0x6
    800001c4:	0a4080e7          	jalr	164(ra) # 80006264 <initlock>
  freerange(end, (void*)PHYSTOP);
    800001c8:	45c5                	li	a1,17
    800001ca:	05ee                	slli	a1,a1,0x1b
    800001cc:	00042517          	auipc	a0,0x42
    800001d0:	b8450513          	addi	a0,a0,-1148 # 80041d50 <end>
    800001d4:	00000097          	auipc	ra,0x0
    800001d8:	f88080e7          	jalr	-120(ra) # 8000015c <freerange>
  memset(kmem.ref_counts, 0, MAX_PAGE_NUM);
    800001dc:	6621                	lui	a2,0x8
    800001de:	4581                	li	a1,0
    800001e0:	00008517          	auipc	a0,0x8
    800001e4:	72050513          	addi	a0,a0,1824 # 80008900 <kmem+0x20>
    800001e8:	00000097          	auipc	ra,0x0
    800001ec:	088080e7          	jalr	136(ra) # 80000270 <memset>
}
    800001f0:	60a2                	ld	ra,8(sp)
    800001f2:	6402                	ld	s0,0(sp)
    800001f4:	0141                	addi	sp,sp,16
    800001f6:	8082                	ret

00000000800001f8 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001f8:	1101                	addi	sp,sp,-32
    800001fa:	ec06                	sd	ra,24(sp)
    800001fc:	e822                	sd	s0,16(sp)
    800001fe:	e426                	sd	s1,8(sp)
    80000200:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000202:	00008517          	auipc	a0,0x8
    80000206:	6de50513          	addi	a0,a0,1758 # 800088e0 <kmem>
    8000020a:	00006097          	auipc	ra,0x6
    8000020e:	0ea080e7          	jalr	234(ra) # 800062f4 <acquire>
  r = kmem.freelist;
    80000212:	00008497          	auipc	s1,0x8
    80000216:	6e64b483          	ld	s1,1766(s1) # 800088f8 <kmem+0x18>
  if(r) {
    8000021a:	c0b1                	beqz	s1,8000025e <kalloc+0x66>
    kmem.freelist = r->next;
    8000021c:	609c                	ld	a5,0(s1)
    8000021e:	00008517          	auipc	a0,0x8
    80000222:	6c250513          	addi	a0,a0,1730 # 800088e0 <kmem>
    80000226:	ed1c                	sd	a5,24(a0)
	return (int) (((uint64) (pa) - start) / PGSIZE);
    80000228:	800007b7          	lui	a5,0x80000
    8000022c:	97a6                	add	a5,a5,s1
    8000022e:	83b1                	srli	a5,a5,0xc
	int page_num = get_page_num((void *) r);
	kmem.ref_counts[page_num] = 1;
    80000230:	2781                	sext.w	a5,a5
    80000232:	07a1                	addi	a5,a5,8 # ffffffff80000008 <end+0xfffffffefffbe2b8>
    80000234:	078a                	slli	a5,a5,0x2
    80000236:	97aa                	add	a5,a5,a0
    80000238:	4705                	li	a4,1
    8000023a:	c398                	sw	a4,0(a5)
  }
  release(&kmem.lock);
    8000023c:	00006097          	auipc	ra,0x6
    80000240:	16c080e7          	jalr	364(ra) # 800063a8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000244:	6605                	lui	a2,0x1
    80000246:	4595                	li	a1,5
    80000248:	8526                	mv	a0,s1
    8000024a:	00000097          	auipc	ra,0x0
    8000024e:	026080e7          	jalr	38(ra) # 80000270 <memset>
  return (void*)r;
}
    80000252:	8526                	mv	a0,s1
    80000254:	60e2                	ld	ra,24(sp)
    80000256:	6442                	ld	s0,16(sp)
    80000258:	64a2                	ld	s1,8(sp)
    8000025a:	6105                	addi	sp,sp,32
    8000025c:	8082                	ret
  release(&kmem.lock);
    8000025e:	00008517          	auipc	a0,0x8
    80000262:	68250513          	addi	a0,a0,1666 # 800088e0 <kmem>
    80000266:	00006097          	auipc	ra,0x6
    8000026a:	142080e7          	jalr	322(ra) # 800063a8 <release>
  if(r)
    8000026e:	b7d5                	j	80000252 <kalloc+0x5a>

0000000080000270 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000270:	1141                	addi	sp,sp,-16
    80000272:	e422                	sd	s0,8(sp)
    80000274:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000276:	ca19                	beqz	a2,8000028c <memset+0x1c>
    80000278:	87aa                	mv	a5,a0
    8000027a:	1602                	slli	a2,a2,0x20
    8000027c:	9201                	srli	a2,a2,0x20
    8000027e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000282:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000286:	0785                	addi	a5,a5,1
    80000288:	fee79de3          	bne	a5,a4,80000282 <memset+0x12>
  }
  return dst;
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000298:	ca05                	beqz	a2,800002c8 <memcmp+0x36>
    8000029a:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000029e:	1682                	slli	a3,a3,0x20
    800002a0:	9281                	srli	a3,a3,0x20
    800002a2:	0685                	addi	a3,a3,1
    800002a4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002a6:	00054783          	lbu	a5,0(a0)
    800002aa:	0005c703          	lbu	a4,0(a1)
    800002ae:	00e79863          	bne	a5,a4,800002be <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002b6:	fed518e3          	bne	a0,a3,800002a6 <memcmp+0x14>
  }

  return 0;
    800002ba:	4501                	li	a0,0
    800002bc:	a019                	j	800002c2 <memcmp+0x30>
      return *s1 - *s2;
    800002be:	40e7853b          	subw	a0,a5,a4
}
    800002c2:	6422                	ld	s0,8(sp)
    800002c4:	0141                	addi	sp,sp,16
    800002c6:	8082                	ret
  return 0;
    800002c8:	4501                	li	a0,0
    800002ca:	bfe5                	j	800002c2 <memcmp+0x30>

00000000800002cc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002cc:	1141                	addi	sp,sp,-16
    800002ce:	e422                	sd	s0,8(sp)
    800002d0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002d2:	c205                	beqz	a2,800002f2 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002d4:	02a5e263          	bltu	a1,a0,800002f8 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002d8:	1602                	slli	a2,a2,0x20
    800002da:	9201                	srli	a2,a2,0x20
    800002dc:	00c587b3          	add	a5,a1,a2
{
    800002e0:	872a                	mv	a4,a0
      *d++ = *s++;
    800002e2:	0585                	addi	a1,a1,1
    800002e4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffbd2b1>
    800002e6:	fff5c683          	lbu	a3,-1(a1)
    800002ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002ee:	fef59ae3          	bne	a1,a5,800002e2 <memmove+0x16>

  return dst;
}
    800002f2:	6422                	ld	s0,8(sp)
    800002f4:	0141                	addi	sp,sp,16
    800002f6:	8082                	ret
  if(s < d && s + n > d){
    800002f8:	02061693          	slli	a3,a2,0x20
    800002fc:	9281                	srli	a3,a3,0x20
    800002fe:	00d58733          	add	a4,a1,a3
    80000302:	fce57be3          	bgeu	a0,a4,800002d8 <memmove+0xc>
    d += n;
    80000306:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000308:	fff6079b          	addiw	a5,a2,-1
    8000030c:	1782                	slli	a5,a5,0x20
    8000030e:	9381                	srli	a5,a5,0x20
    80000310:	fff7c793          	not	a5,a5
    80000314:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000316:	177d                	addi	a4,a4,-1
    80000318:	16fd                	addi	a3,a3,-1
    8000031a:	00074603          	lbu	a2,0(a4)
    8000031e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000322:	fee79ae3          	bne	a5,a4,80000316 <memmove+0x4a>
    80000326:	b7f1                	j	800002f2 <memmove+0x26>

0000000080000328 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000328:	1141                	addi	sp,sp,-16
    8000032a:	e406                	sd	ra,8(sp)
    8000032c:	e022                	sd	s0,0(sp)
    8000032e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000330:	00000097          	auipc	ra,0x0
    80000334:	f9c080e7          	jalr	-100(ra) # 800002cc <memmove>
}
    80000338:	60a2                	ld	ra,8(sp)
    8000033a:	6402                	ld	s0,0(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret

0000000080000340 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000340:	1141                	addi	sp,sp,-16
    80000342:	e422                	sd	s0,8(sp)
    80000344:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000346:	ce11                	beqz	a2,80000362 <strncmp+0x22>
    80000348:	00054783          	lbu	a5,0(a0)
    8000034c:	cf89                	beqz	a5,80000366 <strncmp+0x26>
    8000034e:	0005c703          	lbu	a4,0(a1)
    80000352:	00f71a63          	bne	a4,a5,80000366 <strncmp+0x26>
    n--, p++, q++;
    80000356:	367d                	addiw	a2,a2,-1
    80000358:	0505                	addi	a0,a0,1
    8000035a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000035c:	f675                	bnez	a2,80000348 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000035e:	4501                	li	a0,0
    80000360:	a809                	j	80000372 <strncmp+0x32>
    80000362:	4501                	li	a0,0
    80000364:	a039                	j	80000372 <strncmp+0x32>
  if(n == 0)
    80000366:	ca09                	beqz	a2,80000378 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000368:	00054503          	lbu	a0,0(a0)
    8000036c:	0005c783          	lbu	a5,0(a1)
    80000370:	9d1d                	subw	a0,a0,a5
}
    80000372:	6422                	ld	s0,8(sp)
    80000374:	0141                	addi	sp,sp,16
    80000376:	8082                	ret
    return 0;
    80000378:	4501                	li	a0,0
    8000037a:	bfe5                	j	80000372 <strncmp+0x32>

000000008000037c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000037c:	1141                	addi	sp,sp,-16
    8000037e:	e422                	sd	s0,8(sp)
    80000380:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000382:	872a                	mv	a4,a0
    80000384:	8832                	mv	a6,a2
    80000386:	367d                	addiw	a2,a2,-1
    80000388:	01005963          	blez	a6,8000039a <strncpy+0x1e>
    8000038c:	0705                	addi	a4,a4,1
    8000038e:	0005c783          	lbu	a5,0(a1)
    80000392:	fef70fa3          	sb	a5,-1(a4)
    80000396:	0585                	addi	a1,a1,1
    80000398:	f7f5                	bnez	a5,80000384 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000039a:	86ba                	mv	a3,a4
    8000039c:	00c05c63          	blez	a2,800003b4 <strncpy+0x38>
    *s++ = 0;
    800003a0:	0685                	addi	a3,a3,1
    800003a2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003a6:	40d707bb          	subw	a5,a4,a3
    800003aa:	37fd                	addiw	a5,a5,-1
    800003ac:	010787bb          	addw	a5,a5,a6
    800003b0:	fef048e3          	bgtz	a5,800003a0 <strncpy+0x24>
  return os;
}
    800003b4:	6422                	ld	s0,8(sp)
    800003b6:	0141                	addi	sp,sp,16
    800003b8:	8082                	ret

00000000800003ba <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003ba:	1141                	addi	sp,sp,-16
    800003bc:	e422                	sd	s0,8(sp)
    800003be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003c0:	02c05363          	blez	a2,800003e6 <safestrcpy+0x2c>
    800003c4:	fff6069b          	addiw	a3,a2,-1
    800003c8:	1682                	slli	a3,a3,0x20
    800003ca:	9281                	srli	a3,a3,0x20
    800003cc:	96ae                	add	a3,a3,a1
    800003ce:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003d0:	00d58963          	beq	a1,a3,800003e2 <safestrcpy+0x28>
    800003d4:	0585                	addi	a1,a1,1
    800003d6:	0785                	addi	a5,a5,1
    800003d8:	fff5c703          	lbu	a4,-1(a1)
    800003dc:	fee78fa3          	sb	a4,-1(a5)
    800003e0:	fb65                	bnez	a4,800003d0 <safestrcpy+0x16>
    ;
  *s = 0;
    800003e2:	00078023          	sb	zero,0(a5)
  return os;
}
    800003e6:	6422                	ld	s0,8(sp)
    800003e8:	0141                	addi	sp,sp,16
    800003ea:	8082                	ret

00000000800003ec <strlen>:

int
strlen(const char *s)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e422                	sd	s0,8(sp)
    800003f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003f2:	00054783          	lbu	a5,0(a0)
    800003f6:	cf91                	beqz	a5,80000412 <strlen+0x26>
    800003f8:	0505                	addi	a0,a0,1
    800003fa:	87aa                	mv	a5,a0
    800003fc:	4685                	li	a3,1
    800003fe:	9e89                	subw	a3,a3,a0
    80000400:	00f6853b          	addw	a0,a3,a5
    80000404:	0785                	addi	a5,a5,1
    80000406:	fff7c703          	lbu	a4,-1(a5)
    8000040a:	fb7d                	bnez	a4,80000400 <strlen+0x14>
    ;
  return n;
}
    8000040c:	6422                	ld	s0,8(sp)
    8000040e:	0141                	addi	sp,sp,16
    80000410:	8082                	ret
  for(n = 0; s[n]; n++)
    80000412:	4501                	li	a0,0
    80000414:	bfe5                	j	8000040c <strlen+0x20>

0000000080000416 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000416:	1141                	addi	sp,sp,-16
    80000418:	e406                	sd	ra,8(sp)
    8000041a:	e022                	sd	s0,0(sp)
    8000041c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	ae4080e7          	jalr	-1308(ra) # 80000f02 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000426:	00008717          	auipc	a4,0x8
    8000042a:	48a70713          	addi	a4,a4,1162 # 800088b0 <started>
  if(cpuid() == 0){
    8000042e:	c139                	beqz	a0,80000474 <main+0x5e>
    while(started == 0)
    80000430:	431c                	lw	a5,0(a4)
    80000432:	2781                	sext.w	a5,a5
    80000434:	dff5                	beqz	a5,80000430 <main+0x1a>
      ;
    __sync_synchronize();
    80000436:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000043a:	00001097          	auipc	ra,0x1
    8000043e:	ac8080e7          	jalr	-1336(ra) # 80000f02 <cpuid>
    80000442:	85aa                	mv	a1,a0
    80000444:	00008517          	auipc	a0,0x8
    80000448:	bf450513          	addi	a0,a0,-1036 # 80008038 <etext+0x38>
    8000044c:	00006097          	auipc	ra,0x6
    80000450:	96a080e7          	jalr	-1686(ra) # 80005db6 <printf>
    kvminithart();    // turn on paging
    80000454:	00000097          	auipc	ra,0x0
    80000458:	0d8080e7          	jalr	216(ra) # 8000052c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000045c:	00001097          	auipc	ra,0x1
    80000460:	770080e7          	jalr	1904(ra) # 80001bcc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000464:	00005097          	auipc	ra,0x5
    80000468:	e0c080e7          	jalr	-500(ra) # 80005270 <plicinithart>
  }

  scheduler();        
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	fb8080e7          	jalr	-72(ra) # 80001424 <scheduler>
    consoleinit();
    80000474:	00006097          	auipc	ra,0x6
    80000478:	808080e7          	jalr	-2040(ra) # 80005c7c <consoleinit>
    printfinit();
    8000047c:	00006097          	auipc	ra,0x6
    80000480:	b1a080e7          	jalr	-1254(ra) # 80005f96 <printfinit>
    printf("\n");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bc450513          	addi	a0,a0,-1084 # 80008048 <etext+0x48>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	92a080e7          	jalr	-1750(ra) # 80005db6 <printf>
    printf("xv6 kernel is booting\n");
    80000494:	00008517          	auipc	a0,0x8
    80000498:	b8c50513          	addi	a0,a0,-1140 # 80008020 <etext+0x20>
    8000049c:	00006097          	auipc	ra,0x6
    800004a0:	91a080e7          	jalr	-1766(ra) # 80005db6 <printf>
    printf("\n");
    800004a4:	00008517          	auipc	a0,0x8
    800004a8:	ba450513          	addi	a0,a0,-1116 # 80008048 <etext+0x48>
    800004ac:	00006097          	auipc	ra,0x6
    800004b0:	90a080e7          	jalr	-1782(ra) # 80005db6 <printf>
    kinit();         // physical page allocator
    800004b4:	00000097          	auipc	ra,0x0
    800004b8:	cf4080e7          	jalr	-780(ra) # 800001a8 <kinit>
    kvminit();       // create kernel page table
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	310080e7          	jalr	784(ra) # 800007cc <kvminit>
    kvminithart();   // turn on paging
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	068080e7          	jalr	104(ra) # 8000052c <kvminithart>
    procinit();      // process table
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	982080e7          	jalr	-1662(ra) # 80000e4e <procinit>
    trapinit();      // trap vectors
    800004d4:	00001097          	auipc	ra,0x1
    800004d8:	6d0080e7          	jalr	1744(ra) # 80001ba4 <trapinit>
    trapinithart();  // install kernel trap vector
    800004dc:	00001097          	auipc	ra,0x1
    800004e0:	6f0080e7          	jalr	1776(ra) # 80001bcc <trapinithart>
    plicinit();      // set up interrupt controller
    800004e4:	00005097          	auipc	ra,0x5
    800004e8:	d76080e7          	jalr	-650(ra) # 8000525a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004ec:	00005097          	auipc	ra,0x5
    800004f0:	d84080e7          	jalr	-636(ra) # 80005270 <plicinithart>
    binit();         // buffer cache
    800004f4:	00002097          	auipc	ra,0x2
    800004f8:	f1e080e7          	jalr	-226(ra) # 80002412 <binit>
    iinit();         // inode table
    800004fc:	00002097          	auipc	ra,0x2
    80000500:	5be080e7          	jalr	1470(ra) # 80002aba <iinit>
    fileinit();      // file table
    80000504:	00003097          	auipc	ra,0x3
    80000508:	564080e7          	jalr	1380(ra) # 80003a68 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000050c:	00005097          	auipc	ra,0x5
    80000510:	e6c080e7          	jalr	-404(ra) # 80005378 <virtio_disk_init>
    userinit();      // first user process
    80000514:	00001097          	auipc	ra,0x1
    80000518:	cf2080e7          	jalr	-782(ra) # 80001206 <userinit>
    __sync_synchronize();
    8000051c:	0ff0000f          	fence
    started = 1;
    80000520:	4785                	li	a5,1
    80000522:	00008717          	auipc	a4,0x8
    80000526:	38f72723          	sw	a5,910(a4) # 800088b0 <started>
    8000052a:	b789                	j	8000046c <main+0x56>

000000008000052c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000052c:	1141                	addi	sp,sp,-16
    8000052e:	e422                	sd	s0,8(sp)
    80000530:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000532:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000536:	00008797          	auipc	a5,0x8
    8000053a:	3827b783          	ld	a5,898(a5) # 800088b8 <kernel_pagetable>
    8000053e:	83b1                	srli	a5,a5,0xc
    80000540:	577d                	li	a4,-1
    80000542:	177e                	slli	a4,a4,0x3f
    80000544:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000546:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000054a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000054e:	6422                	ld	s0,8(sp)
    80000550:	0141                	addi	sp,sp,16
    80000552:	8082                	ret

0000000080000554 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000554:	7139                	addi	sp,sp,-64
    80000556:	fc06                	sd	ra,56(sp)
    80000558:	f822                	sd	s0,48(sp)
    8000055a:	f426                	sd	s1,40(sp)
    8000055c:	f04a                	sd	s2,32(sp)
    8000055e:	ec4e                	sd	s3,24(sp)
    80000560:	e852                	sd	s4,16(sp)
    80000562:	e456                	sd	s5,8(sp)
    80000564:	e05a                	sd	s6,0(sp)
    80000566:	0080                	addi	s0,sp,64
    80000568:	84aa                	mv	s1,a0
    8000056a:	89ae                	mv	s3,a1
    8000056c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000056e:	57fd                	li	a5,-1
    80000570:	83e9                	srli	a5,a5,0x1a
    80000572:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000574:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000576:	04b7f263          	bgeu	a5,a1,800005ba <walk+0x66>
    panic("walk");
    8000057a:	00008517          	auipc	a0,0x8
    8000057e:	ad650513          	addi	a0,a0,-1322 # 80008050 <etext+0x50>
    80000582:	00005097          	auipc	ra,0x5
    80000586:	7ea080e7          	jalr	2026(ra) # 80005d6c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000058a:	060a8663          	beqz	s5,800005f6 <walk+0xa2>
    8000058e:	00000097          	auipc	ra,0x0
    80000592:	c6a080e7          	jalr	-918(ra) # 800001f8 <kalloc>
    80000596:	84aa                	mv	s1,a0
    80000598:	c529                	beqz	a0,800005e2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000059a:	6605                	lui	a2,0x1
    8000059c:	4581                	li	a1,0
    8000059e:	00000097          	auipc	ra,0x0
    800005a2:	cd2080e7          	jalr	-814(ra) # 80000270 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005a6:	00c4d793          	srli	a5,s1,0xc
    800005aa:	07aa                	slli	a5,a5,0xa
    800005ac:	0017e793          	ori	a5,a5,1
    800005b0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005b4:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffbd2a7>
    800005b6:	036a0063          	beq	s4,s6,800005d6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ba:	0149d933          	srl	s2,s3,s4
    800005be:	1ff97913          	andi	s2,s2,511
    800005c2:	090e                	slli	s2,s2,0x3
    800005c4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005c6:	00093483          	ld	s1,0(s2)
    800005ca:	0014f793          	andi	a5,s1,1
    800005ce:	dfd5                	beqz	a5,8000058a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005d0:	80a9                	srli	s1,s1,0xa
    800005d2:	04b2                	slli	s1,s1,0xc
    800005d4:	b7c5                	j	800005b4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005d6:	00c9d513          	srli	a0,s3,0xc
    800005da:	1ff57513          	andi	a0,a0,511
    800005de:	050e                	slli	a0,a0,0x3
    800005e0:	9526                	add	a0,a0,s1
}
    800005e2:	70e2                	ld	ra,56(sp)
    800005e4:	7442                	ld	s0,48(sp)
    800005e6:	74a2                	ld	s1,40(sp)
    800005e8:	7902                	ld	s2,32(sp)
    800005ea:	69e2                	ld	s3,24(sp)
    800005ec:	6a42                	ld	s4,16(sp)
    800005ee:	6aa2                	ld	s5,8(sp)
    800005f0:	6b02                	ld	s6,0(sp)
    800005f2:	6121                	addi	sp,sp,64
    800005f4:	8082                	ret
        return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	b7ed                	j	800005e2 <walk+0x8e>

00000000800005fa <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005fa:	57fd                	li	a5,-1
    800005fc:	83e9                	srli	a5,a5,0x1a
    800005fe:	00b7f463          	bgeu	a5,a1,80000606 <walkaddr+0xc>
    return 0;
    80000602:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000604:	8082                	ret
{
    80000606:	1141                	addi	sp,sp,-16
    80000608:	e406                	sd	ra,8(sp)
    8000060a:	e022                	sd	s0,0(sp)
    8000060c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000060e:	4601                	li	a2,0
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f44080e7          	jalr	-188(ra) # 80000554 <walk>
  if(pte == 0)
    80000618:	c105                	beqz	a0,80000638 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000061a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000061c:	0117f693          	andi	a3,a5,17
    80000620:	4745                	li	a4,17
    return 0;
    80000622:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000624:	00e68663          	beq	a3,a4,80000630 <walkaddr+0x36>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
  pa = PTE2PA(*pte);
    80000630:	83a9                	srli	a5,a5,0xa
    80000632:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000636:	bfcd                	j	80000628 <walkaddr+0x2e>
    return 0;
    80000638:	4501                	li	a0,0
    8000063a:	b7fd                	j	80000628 <walkaddr+0x2e>

000000008000063c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000063c:	715d                	addi	sp,sp,-80
    8000063e:	e486                	sd	ra,72(sp)
    80000640:	e0a2                	sd	s0,64(sp)
    80000642:	fc26                	sd	s1,56(sp)
    80000644:	f84a                	sd	s2,48(sp)
    80000646:	f44e                	sd	s3,40(sp)
    80000648:	f052                	sd	s4,32(sp)
    8000064a:	ec56                	sd	s5,24(sp)
    8000064c:	e85a                	sd	s6,16(sp)
    8000064e:	e45e                	sd	s7,8(sp)
    80000650:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000652:	c621                	beqz	a2,8000069a <mappages+0x5e>
    80000654:	8aaa                	mv	s5,a0
    80000656:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000658:	777d                	lui	a4,0xfffff
    8000065a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000065e:	fff58993          	addi	s3,a1,-1
    80000662:	99b2                	add	s3,s3,a2
    80000664:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000668:	893e                	mv	s2,a5
    8000066a:	40f68a33          	sub	s4,a3,a5
    /*if(*pte & PTE_V)
      panic("mappages: remap");*/
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000066e:	6b85                	lui	s7,0x1
    80000670:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000674:	4605                	li	a2,1
    80000676:	85ca                	mv	a1,s2
    80000678:	8556                	mv	a0,s5
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	eda080e7          	jalr	-294(ra) # 80000554 <walk>
    80000682:	c505                	beqz	a0,800006aa <mappages+0x6e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000684:	80b1                	srli	s1,s1,0xc
    80000686:	04aa                	slli	s1,s1,0xa
    80000688:	0164e4b3          	or	s1,s1,s6
    8000068c:	0014e493          	ori	s1,s1,1
    80000690:	e104                	sd	s1,0(a0)
    if(a == last)
    80000692:	03390863          	beq	s2,s3,800006c2 <mappages+0x86>
    a += PGSIZE;
    80000696:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000698:	bfe1                	j	80000670 <mappages+0x34>
    panic("mappages: size");
    8000069a:	00008517          	auipc	a0,0x8
    8000069e:	9be50513          	addi	a0,a0,-1602 # 80008058 <etext+0x58>
    800006a2:	00005097          	auipc	ra,0x5
    800006a6:	6ca080e7          	jalr	1738(ra) # 80005d6c <panic>
      return -1;
    800006aa:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ac:	60a6                	ld	ra,72(sp)
    800006ae:	6406                	ld	s0,64(sp)
    800006b0:	74e2                	ld	s1,56(sp)
    800006b2:	7942                	ld	s2,48(sp)
    800006b4:	79a2                	ld	s3,40(sp)
    800006b6:	7a02                	ld	s4,32(sp)
    800006b8:	6ae2                	ld	s5,24(sp)
    800006ba:	6b42                	ld	s6,16(sp)
    800006bc:	6ba2                	ld	s7,8(sp)
    800006be:	6161                	addi	sp,sp,80
    800006c0:	8082                	ret
  return 0;
    800006c2:	4501                	li	a0,0
    800006c4:	b7e5                	j	800006ac <mappages+0x70>

00000000800006c6 <kvmmap>:
{
    800006c6:	1141                	addi	sp,sp,-16
    800006c8:	e406                	sd	ra,8(sp)
    800006ca:	e022                	sd	s0,0(sp)
    800006cc:	0800                	addi	s0,sp,16
    800006ce:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006d0:	86b2                	mv	a3,a2
    800006d2:	863e                	mv	a2,a5
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f68080e7          	jalr	-152(ra) # 8000063c <mappages>
    800006dc:	e509                	bnez	a0,800006e6 <kvmmap+0x20>
}
    800006de:	60a2                	ld	ra,8(sp)
    800006e0:	6402                	ld	s0,0(sp)
    800006e2:	0141                	addi	sp,sp,16
    800006e4:	8082                	ret
    panic("kvmmap");
    800006e6:	00008517          	auipc	a0,0x8
    800006ea:	98250513          	addi	a0,a0,-1662 # 80008068 <etext+0x68>
    800006ee:	00005097          	auipc	ra,0x5
    800006f2:	67e080e7          	jalr	1662(ra) # 80005d6c <panic>

00000000800006f6 <kvmmake>:
{
    800006f6:	1101                	addi	sp,sp,-32
    800006f8:	ec06                	sd	ra,24(sp)
    800006fa:	e822                	sd	s0,16(sp)
    800006fc:	e426                	sd	s1,8(sp)
    800006fe:	e04a                	sd	s2,0(sp)
    80000700:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000702:	00000097          	auipc	ra,0x0
    80000706:	af6080e7          	jalr	-1290(ra) # 800001f8 <kalloc>
    8000070a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000070c:	6605                	lui	a2,0x1
    8000070e:	4581                	li	a1,0
    80000710:	00000097          	auipc	ra,0x0
    80000714:	b60080e7          	jalr	-1184(ra) # 80000270 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000718:	4719                	li	a4,6
    8000071a:	6685                	lui	a3,0x1
    8000071c:	10000637          	lui	a2,0x10000
    80000720:	100005b7          	lui	a1,0x10000
    80000724:	8526                	mv	a0,s1
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	fa0080e7          	jalr	-96(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000072e:	4719                	li	a4,6
    80000730:	6685                	lui	a3,0x1
    80000732:	10001637          	lui	a2,0x10001
    80000736:	100015b7          	lui	a1,0x10001
    8000073a:	8526                	mv	a0,s1
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	f8a080e7          	jalr	-118(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000744:	4719                	li	a4,6
    80000746:	004006b7          	lui	a3,0x400
    8000074a:	0c000637          	lui	a2,0xc000
    8000074e:	0c0005b7          	lui	a1,0xc000
    80000752:	8526                	mv	a0,s1
    80000754:	00000097          	auipc	ra,0x0
    80000758:	f72080e7          	jalr	-142(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000075c:	00008917          	auipc	s2,0x8
    80000760:	8a490913          	addi	s2,s2,-1884 # 80008000 <etext>
    80000764:	4729                	li	a4,10
    80000766:	80008697          	auipc	a3,0x80008
    8000076a:	89a68693          	addi	a3,a3,-1894 # 8000 <_entry-0x7fff8000>
    8000076e:	4605                	li	a2,1
    80000770:	067e                	slli	a2,a2,0x1f
    80000772:	85b2                	mv	a1,a2
    80000774:	8526                	mv	a0,s1
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	f50080e7          	jalr	-176(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000077e:	4719                	li	a4,6
    80000780:	46c5                	li	a3,17
    80000782:	06ee                	slli	a3,a3,0x1b
    80000784:	412686b3          	sub	a3,a3,s2
    80000788:	864a                	mv	a2,s2
    8000078a:	85ca                	mv	a1,s2
    8000078c:	8526                	mv	a0,s1
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	f38080e7          	jalr	-200(ra) # 800006c6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000796:	4729                	li	a4,10
    80000798:	6685                	lui	a3,0x1
    8000079a:	00007617          	auipc	a2,0x7
    8000079e:	86660613          	addi	a2,a2,-1946 # 80007000 <_trampoline>
    800007a2:	040005b7          	lui	a1,0x4000
    800007a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007a8:	05b2                	slli	a1,a1,0xc
    800007aa:	8526                	mv	a0,s1
    800007ac:	00000097          	auipc	ra,0x0
    800007b0:	f1a080e7          	jalr	-230(ra) # 800006c6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	602080e7          	jalr	1538(ra) # 80000db8 <proc_mapstacks>
}
    800007be:	8526                	mv	a0,s1
    800007c0:	60e2                	ld	ra,24(sp)
    800007c2:	6442                	ld	s0,16(sp)
    800007c4:	64a2                	ld	s1,8(sp)
    800007c6:	6902                	ld	s2,0(sp)
    800007c8:	6105                	addi	sp,sp,32
    800007ca:	8082                	ret

00000000800007cc <kvminit>:
{
    800007cc:	1141                	addi	sp,sp,-16
    800007ce:	e406                	sd	ra,8(sp)
    800007d0:	e022                	sd	s0,0(sp)
    800007d2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	f22080e7          	jalr	-222(ra) # 800006f6 <kvmmake>
    800007dc:	00008797          	auipc	a5,0x8
    800007e0:	0ca7be23          	sd	a0,220(a5) # 800088b8 <kernel_pagetable>
}
    800007e4:	60a2                	ld	ra,8(sp)
    800007e6:	6402                	ld	s0,0(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret

00000000800007ec <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007ec:	715d                	addi	sp,sp,-80
    800007ee:	e486                	sd	ra,72(sp)
    800007f0:	e0a2                	sd	s0,64(sp)
    800007f2:	fc26                	sd	s1,56(sp)
    800007f4:	f84a                	sd	s2,48(sp)
    800007f6:	f44e                	sd	s3,40(sp)
    800007f8:	f052                	sd	s4,32(sp)
    800007fa:	ec56                	sd	s5,24(sp)
    800007fc:	e85a                	sd	s6,16(sp)
    800007fe:	e45e                	sd	s7,8(sp)
    80000800:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000802:	03459793          	slli	a5,a1,0x34
    80000806:	e795                	bnez	a5,80000832 <uvmunmap+0x46>
    80000808:	8a2a                	mv	s4,a0
    8000080a:	892e                	mv	s2,a1
    8000080c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000080e:	0632                	slli	a2,a2,0xc
    80000810:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000814:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000816:	6b05                	lui	s6,0x1
    80000818:	0735e263          	bltu	a1,s3,8000087c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000081c:	60a6                	ld	ra,72(sp)
    8000081e:	6406                	ld	s0,64(sp)
    80000820:	74e2                	ld	s1,56(sp)
    80000822:	7942                	ld	s2,48(sp)
    80000824:	79a2                	ld	s3,40(sp)
    80000826:	7a02                	ld	s4,32(sp)
    80000828:	6ae2                	ld	s5,24(sp)
    8000082a:	6b42                	ld	s6,16(sp)
    8000082c:	6ba2                	ld	s7,8(sp)
    8000082e:	6161                	addi	sp,sp,80
    80000830:	8082                	ret
    panic("uvmunmap: not aligned");
    80000832:	00008517          	auipc	a0,0x8
    80000836:	83e50513          	addi	a0,a0,-1986 # 80008070 <etext+0x70>
    8000083a:	00005097          	auipc	ra,0x5
    8000083e:	532080e7          	jalr	1330(ra) # 80005d6c <panic>
      panic("uvmunmap: walk");
    80000842:	00008517          	auipc	a0,0x8
    80000846:	84650513          	addi	a0,a0,-1978 # 80008088 <etext+0x88>
    8000084a:	00005097          	auipc	ra,0x5
    8000084e:	522080e7          	jalr	1314(ra) # 80005d6c <panic>
      panic("uvmunmap: not mapped");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	84650513          	addi	a0,a0,-1978 # 80008098 <etext+0x98>
    8000085a:	00005097          	auipc	ra,0x5
    8000085e:	512080e7          	jalr	1298(ra) # 80005d6c <panic>
      panic("uvmunmap: not a leaf");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	84e50513          	addi	a0,a0,-1970 # 800080b0 <etext+0xb0>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	502080e7          	jalr	1282(ra) # 80005d6c <panic>
    *pte = 0;
    80000872:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000876:	995a                	add	s2,s2,s6
    80000878:	fb3972e3          	bgeu	s2,s3,8000081c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000087c:	4601                	li	a2,0
    8000087e:	85ca                	mv	a1,s2
    80000880:	8552                	mv	a0,s4
    80000882:	00000097          	auipc	ra,0x0
    80000886:	cd2080e7          	jalr	-814(ra) # 80000554 <walk>
    8000088a:	84aa                	mv	s1,a0
    8000088c:	d95d                	beqz	a0,80000842 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000088e:	6108                	ld	a0,0(a0)
    80000890:	00157793          	andi	a5,a0,1
    80000894:	dfdd                	beqz	a5,80000852 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000896:	3ff57793          	andi	a5,a0,1023
    8000089a:	fd7784e3          	beq	a5,s7,80000862 <uvmunmap+0x76>
    if(do_free){
    8000089e:	fc0a8ae3          	beqz	s5,80000872 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008a2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008a4:	0532                	slli	a0,a0,0xc
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	832080e7          	jalr	-1998(ra) # 800000d8 <kfree>
    800008ae:	b7d1                	j	80000872 <uvmunmap+0x86>

00000000800008b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008b0:	1101                	addi	sp,sp,-32
    800008b2:	ec06                	sd	ra,24(sp)
    800008b4:	e822                	sd	s0,16(sp)
    800008b6:	e426                	sd	s1,8(sp)
    800008b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008ba:	00000097          	auipc	ra,0x0
    800008be:	93e080e7          	jalr	-1730(ra) # 800001f8 <kalloc>
    800008c2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008c4:	c519                	beqz	a0,800008d2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008c6:	6605                	lui	a2,0x1
    800008c8:	4581                	li	a1,0
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	9a6080e7          	jalr	-1626(ra) # 80000270 <memset>
  return pagetable;
}
    800008d2:	8526                	mv	a0,s1
    800008d4:	60e2                	ld	ra,24(sp)
    800008d6:	6442                	ld	s0,16(sp)
    800008d8:	64a2                	ld	s1,8(sp)
    800008da:	6105                	addi	sp,sp,32
    800008dc:	8082                	ret

00000000800008de <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800008de:	7179                	addi	sp,sp,-48
    800008e0:	f406                	sd	ra,40(sp)
    800008e2:	f022                	sd	s0,32(sp)
    800008e4:	ec26                	sd	s1,24(sp)
    800008e6:	e84a                	sd	s2,16(sp)
    800008e8:	e44e                	sd	s3,8(sp)
    800008ea:	e052                	sd	s4,0(sp)
    800008ec:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008ee:	6785                	lui	a5,0x1
    800008f0:	04f67863          	bgeu	a2,a5,80000940 <uvmfirst+0x62>
    800008f4:	8a2a                	mv	s4,a0
    800008f6:	89ae                	mv	s3,a1
    800008f8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	8fe080e7          	jalr	-1794(ra) # 800001f8 <kalloc>
    80000902:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000904:	6605                	lui	a2,0x1
    80000906:	4581                	li	a1,0
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	968080e7          	jalr	-1688(ra) # 80000270 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000910:	4779                	li	a4,30
    80000912:	86ca                	mv	a3,s2
    80000914:	6605                	lui	a2,0x1
    80000916:	4581                	li	a1,0
    80000918:	8552                	mv	a0,s4
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	d22080e7          	jalr	-734(ra) # 8000063c <mappages>
  memmove(mem, src, sz);
    80000922:	8626                	mv	a2,s1
    80000924:	85ce                	mv	a1,s3
    80000926:	854a                	mv	a0,s2
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	9a4080e7          	jalr	-1628(ra) # 800002cc <memmove>
}
    80000930:	70a2                	ld	ra,40(sp)
    80000932:	7402                	ld	s0,32(sp)
    80000934:	64e2                	ld	s1,24(sp)
    80000936:	6942                	ld	s2,16(sp)
    80000938:	69a2                	ld	s3,8(sp)
    8000093a:	6a02                	ld	s4,0(sp)
    8000093c:	6145                	addi	sp,sp,48
    8000093e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000940:	00007517          	auipc	a0,0x7
    80000944:	78850513          	addi	a0,a0,1928 # 800080c8 <etext+0xc8>
    80000948:	00005097          	auipc	ra,0x5
    8000094c:	424080e7          	jalr	1060(ra) # 80005d6c <panic>

0000000080000950 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000950:	1101                	addi	sp,sp,-32
    80000952:	ec06                	sd	ra,24(sp)
    80000954:	e822                	sd	s0,16(sp)
    80000956:	e426                	sd	s1,8(sp)
    80000958:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000095a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000095c:	00b67d63          	bgeu	a2,a1,80000976 <uvmdealloc+0x26>
    80000960:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000962:	6785                	lui	a5,0x1
    80000964:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000966:	00f60733          	add	a4,a2,a5
    8000096a:	76fd                	lui	a3,0xfffff
    8000096c:	8f75                	and	a4,a4,a3
    8000096e:	97ae                	add	a5,a5,a1
    80000970:	8ff5                	and	a5,a5,a3
    80000972:	00f76863          	bltu	a4,a5,80000982 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000976:	8526                	mv	a0,s1
    80000978:	60e2                	ld	ra,24(sp)
    8000097a:	6442                	ld	s0,16(sp)
    8000097c:	64a2                	ld	s1,8(sp)
    8000097e:	6105                	addi	sp,sp,32
    80000980:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000982:	8f99                	sub	a5,a5,a4
    80000984:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000986:	4685                	li	a3,1
    80000988:	0007861b          	sext.w	a2,a5
    8000098c:	85ba                	mv	a1,a4
    8000098e:	00000097          	auipc	ra,0x0
    80000992:	e5e080e7          	jalr	-418(ra) # 800007ec <uvmunmap>
    80000996:	b7c5                	j	80000976 <uvmdealloc+0x26>

0000000080000998 <uvmalloc>:
  if(newsz < oldsz)
    80000998:	0ab66563          	bltu	a2,a1,80000a42 <uvmalloc+0xaa>
{
    8000099c:	7139                	addi	sp,sp,-64
    8000099e:	fc06                	sd	ra,56(sp)
    800009a0:	f822                	sd	s0,48(sp)
    800009a2:	f426                	sd	s1,40(sp)
    800009a4:	f04a                	sd	s2,32(sp)
    800009a6:	ec4e                	sd	s3,24(sp)
    800009a8:	e852                	sd	s4,16(sp)
    800009aa:	e456                	sd	s5,8(sp)
    800009ac:	e05a                	sd	s6,0(sp)
    800009ae:	0080                	addi	s0,sp,64
    800009b0:	8aaa                	mv	s5,a0
    800009b2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009b4:	6785                	lui	a5,0x1
    800009b6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009b8:	95be                	add	a1,a1,a5
    800009ba:	77fd                	lui	a5,0xfffff
    800009bc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009c0:	08c9f363          	bgeu	s3,a2,80000a46 <uvmalloc+0xae>
    800009c4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009c6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	82e080e7          	jalr	-2002(ra) # 800001f8 <kalloc>
    800009d2:	84aa                	mv	s1,a0
    if(mem == 0){
    800009d4:	c51d                	beqz	a0,80000a02 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800009d6:	6605                	lui	a2,0x1
    800009d8:	4581                	li	a1,0
    800009da:	00000097          	auipc	ra,0x0
    800009de:	896080e7          	jalr	-1898(ra) # 80000270 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800009e2:	875a                	mv	a4,s6
    800009e4:	86a6                	mv	a3,s1
    800009e6:	6605                	lui	a2,0x1
    800009e8:	85ca                	mv	a1,s2
    800009ea:	8556                	mv	a0,s5
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	c50080e7          	jalr	-944(ra) # 8000063c <mappages>
    800009f4:	e90d                	bnez	a0,80000a26 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009f6:	6785                	lui	a5,0x1
    800009f8:	993e                	add	s2,s2,a5
    800009fa:	fd4968e3          	bltu	s2,s4,800009ca <uvmalloc+0x32>
  return newsz;
    800009fe:	8552                	mv	a0,s4
    80000a00:	a809                	j	80000a12 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000a02:	864e                	mv	a2,s3
    80000a04:	85ca                	mv	a1,s2
    80000a06:	8556                	mv	a0,s5
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	f48080e7          	jalr	-184(ra) # 80000950 <uvmdealloc>
      return 0;
    80000a10:	4501                	li	a0,0
}
    80000a12:	70e2                	ld	ra,56(sp)
    80000a14:	7442                	ld	s0,48(sp)
    80000a16:	74a2                	ld	s1,40(sp)
    80000a18:	7902                	ld	s2,32(sp)
    80000a1a:	69e2                	ld	s3,24(sp)
    80000a1c:	6a42                	ld	s4,16(sp)
    80000a1e:	6aa2                	ld	s5,8(sp)
    80000a20:	6b02                	ld	s6,0(sp)
    80000a22:	6121                	addi	sp,sp,64
    80000a24:	8082                	ret
      kfree(mem);
    80000a26:	8526                	mv	a0,s1
    80000a28:	fffff097          	auipc	ra,0xfffff
    80000a2c:	6b0080e7          	jalr	1712(ra) # 800000d8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a30:	864e                	mv	a2,s3
    80000a32:	85ca                	mv	a1,s2
    80000a34:	8556                	mv	a0,s5
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	f1a080e7          	jalr	-230(ra) # 80000950 <uvmdealloc>
      return 0;
    80000a3e:	4501                	li	a0,0
    80000a40:	bfc9                	j	80000a12 <uvmalloc+0x7a>
    return oldsz;
    80000a42:	852e                	mv	a0,a1
}
    80000a44:	8082                	ret
  return newsz;
    80000a46:	8532                	mv	a0,a2
    80000a48:	b7e9                	j	80000a12 <uvmalloc+0x7a>

0000000080000a4a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a4a:	7179                	addi	sp,sp,-48
    80000a4c:	f406                	sd	ra,40(sp)
    80000a4e:	f022                	sd	s0,32(sp)
    80000a50:	ec26                	sd	s1,24(sp)
    80000a52:	e84a                	sd	s2,16(sp)
    80000a54:	e44e                	sd	s3,8(sp)
    80000a56:	e052                	sd	s4,0(sp)
    80000a58:	1800                	addi	s0,sp,48
    80000a5a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	6905                	lui	s2,0x1
    80000a60:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a62:	4985                	li	s3,1
    80000a64:	a829                	j	80000a7e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a66:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a68:	00c79513          	slli	a0,a5,0xc
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	fde080e7          	jalr	-34(ra) # 80000a4a <freewalk>
      pagetable[i] = 0;
    80000a74:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a78:	04a1                	addi	s1,s1,8
    80000a7a:	03248163          	beq	s1,s2,80000a9c <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a7e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a80:	00f7f713          	andi	a4,a5,15
    80000a84:	ff3701e3          	beq	a4,s3,80000a66 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a88:	8b85                	andi	a5,a5,1
    80000a8a:	d7fd                	beqz	a5,80000a78 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	65c50513          	addi	a0,a0,1628 # 800080e8 <etext+0xe8>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	2d8080e7          	jalr	728(ra) # 80005d6c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a9c:	8552                	mv	a0,s4
    80000a9e:	fffff097          	auipc	ra,0xfffff
    80000aa2:	63a080e7          	jalr	1594(ra) # 800000d8 <kfree>
}
    80000aa6:	70a2                	ld	ra,40(sp)
    80000aa8:	7402                	ld	s0,32(sp)
    80000aaa:	64e2                	ld	s1,24(sp)
    80000aac:	6942                	ld	s2,16(sp)
    80000aae:	69a2                	ld	s3,8(sp)
    80000ab0:	6a02                	ld	s4,0(sp)
    80000ab2:	6145                	addi	sp,sp,48
    80000ab4:	8082                	ret

0000000080000ab6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ab6:	1101                	addi	sp,sp,-32
    80000ab8:	ec06                	sd	ra,24(sp)
    80000aba:	e822                	sd	s0,16(sp)
    80000abc:	e426                	sd	s1,8(sp)
    80000abe:	1000                	addi	s0,sp,32
    80000ac0:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ac2:	e999                	bnez	a1,80000ad8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ac4:	8526                	mv	a0,s1
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f84080e7          	jalr	-124(ra) # 80000a4a <freewalk>
}
    80000ace:	60e2                	ld	ra,24(sp)
    80000ad0:	6442                	ld	s0,16(sp)
    80000ad2:	64a2                	ld	s1,8(sp)
    80000ad4:	6105                	addi	sp,sp,32
    80000ad6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ad8:	6785                	lui	a5,0x1
    80000ada:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000adc:	95be                	add	a1,a1,a5
    80000ade:	4685                	li	a3,1
    80000ae0:	00c5d613          	srli	a2,a1,0xc
    80000ae4:	4581                	li	a1,0
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	d06080e7          	jalr	-762(ra) # 800007ec <uvmunmap>
    80000aee:	bfd9                	j	80000ac4 <uvmfree+0xe>

0000000080000af0 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000af0:	7139                	addi	sp,sp,-64
    80000af2:	fc06                	sd	ra,56(sp)
    80000af4:	f822                	sd	s0,48(sp)
    80000af6:	f426                	sd	s1,40(sp)
    80000af8:	f04a                	sd	s2,32(sp)
    80000afa:	ec4e                	sd	s3,24(sp)
    80000afc:	e852                	sd	s4,16(sp)
    80000afe:	e456                	sd	s5,8(sp)
    80000b00:	e05a                	sd	s6,0(sp)
    80000b02:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  //char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b04:	ca55                	beqz	a2,80000bb8 <uvmcopy+0xc8>
    80000b06:	8b2a                	mv	s6,a0
    80000b08:	8aae                	mv	s5,a1
    80000b0a:	8a32                	mv	s4,a2
    80000b0c:	4481                	li	s1,0
    80000b0e:	a881                	j	80000b5e <uvmcopy+0x6e>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000b10:	00007517          	auipc	a0,0x7
    80000b14:	5e850513          	addi	a0,a0,1512 # 800080f8 <etext+0xf8>
    80000b18:	00005097          	auipc	ra,0x5
    80000b1c:	254080e7          	jalr	596(ra) # 80005d6c <panic>
    if((*pte & PTE_V) == 0)
      panic("uvmcopy: page not present");
    80000b20:	00007517          	auipc	a0,0x7
    80000b24:	5f850513          	addi	a0,a0,1528 # 80008118 <etext+0x118>
    80000b28:	00005097          	auipc	ra,0x5
    80000b2c:	244080e7          	jalr	580(ra) # 80005d6c <panic>
    pa = PTE2PA(*pte);
	if (*pte & PTE_W) {
		*pte = ((*pte) & (~PTE_W)) | PTE_COW;
	}
    flags = PTE_FLAGS(*pte);
    80000b30:	6118                	ld	a4,0(a0)
    /*if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);*/
    //if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000b32:	3ff77713          	andi	a4,a4,1023
    80000b36:	86ca                	mv	a3,s2
    80000b38:	6605                	lui	a2,0x1
    80000b3a:	85a6                	mv	a1,s1
    80000b3c:	8556                	mv	a0,s5
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	afe080e7          	jalr	-1282(ra) # 8000063c <mappages>
    80000b46:	89aa                	mv	s3,a0
    80000b48:	e139                	bnez	a0,80000b8e <uvmcopy+0x9e>
      //kfree(mem);
      goto err;
    }
	incr_ref_count((void *)pa, 1);
    80000b4a:	4585                	li	a1,1
    80000b4c:	854a                	mv	a0,s2
    80000b4e:	fffff097          	auipc	ra,0xfffff
    80000b52:	4e4080e7          	jalr	1252(ra) # 80000032 <incr_ref_count>
  for(i = 0; i < sz; i += PGSIZE){
    80000b56:	6785                	lui	a5,0x1
    80000b58:	94be                	add	s1,s1,a5
    80000b5a:	0544f463          	bgeu	s1,s4,80000ba2 <uvmcopy+0xb2>
    if((pte = walk(old, i, 0)) == 0)
    80000b5e:	4601                	li	a2,0
    80000b60:	85a6                	mv	a1,s1
    80000b62:	855a                	mv	a0,s6
    80000b64:	00000097          	auipc	ra,0x0
    80000b68:	9f0080e7          	jalr	-1552(ra) # 80000554 <walk>
    80000b6c:	d155                	beqz	a0,80000b10 <uvmcopy+0x20>
    if((*pte & PTE_V) == 0)
    80000b6e:	611c                	ld	a5,0(a0)
    80000b70:	0017f713          	andi	a4,a5,1
    80000b74:	d755                	beqz	a4,80000b20 <uvmcopy+0x30>
    pa = PTE2PA(*pte);
    80000b76:	00a7d913          	srli	s2,a5,0xa
    80000b7a:	0932                	slli	s2,s2,0xc
	if (*pte & PTE_W) {
    80000b7c:	0047f713          	andi	a4,a5,4
    80000b80:	db45                	beqz	a4,80000b30 <uvmcopy+0x40>
		*pte = ((*pte) & (~PTE_W)) | PTE_COW;
    80000b82:	efb7f793          	andi	a5,a5,-261
    80000b86:	1007e793          	ori	a5,a5,256
    80000b8a:	e11c                	sd	a5,0(a0)
    80000b8c:	b755                	j	80000b30 <uvmcopy+0x40>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b8e:	4685                	li	a3,1
    80000b90:	00c4d613          	srli	a2,s1,0xc
    80000b94:	4581                	li	a1,0
    80000b96:	8556                	mv	a0,s5
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	c54080e7          	jalr	-940(ra) # 800007ec <uvmunmap>
  return -1;
    80000ba0:	59fd                	li	s3,-1
}
    80000ba2:	854e                	mv	a0,s3
    80000ba4:	70e2                	ld	ra,56(sp)
    80000ba6:	7442                	ld	s0,48(sp)
    80000ba8:	74a2                	ld	s1,40(sp)
    80000baa:	7902                	ld	s2,32(sp)
    80000bac:	69e2                	ld	s3,24(sp)
    80000bae:	6a42                	ld	s4,16(sp)
    80000bb0:	6aa2                	ld	s5,8(sp)
    80000bb2:	6b02                	ld	s6,0(sp)
    80000bb4:	6121                	addi	sp,sp,64
    80000bb6:	8082                	ret
  return 0;
    80000bb8:	4981                	li	s3,0
    80000bba:	b7e5                	j	80000ba2 <uvmcopy+0xb2>

0000000080000bbc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bbc:	1141                	addi	sp,sp,-16
    80000bbe:	e406                	sd	ra,8(sp)
    80000bc0:	e022                	sd	s0,0(sp)
    80000bc2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bc4:	4601                	li	a2,0
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	98e080e7          	jalr	-1650(ra) # 80000554 <walk>
  if(pte == 0)
    80000bce:	c901                	beqz	a0,80000bde <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bd0:	611c                	ld	a5,0(a0)
    80000bd2:	9bbd                	andi	a5,a5,-17
    80000bd4:	e11c                	sd	a5,0(a0)
}
    80000bd6:	60a2                	ld	ra,8(sp)
    80000bd8:	6402                	ld	s0,0(sp)
    80000bda:	0141                	addi	sp,sp,16
    80000bdc:	8082                	ret
    panic("uvmclear");
    80000bde:	00007517          	auipc	a0,0x7
    80000be2:	55a50513          	addi	a0,a0,1370 # 80008138 <etext+0x138>
    80000be6:	00005097          	auipc	ra,0x5
    80000bea:	186080e7          	jalr	390(ra) # 80005d6c <panic>

0000000080000bee <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	c6bd                	beqz	a3,80000c5c <copyout+0x6e>
{
    80000bf0:	715d                	addi	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	addi	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8c2e                	mv	s8,a1
    80000c0c:	8a32                	mv	s4,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a015                	j	80000c38 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c16:	9562                	add	a0,a0,s8
    80000c18:	0004861b          	sext.w	a2,s1
    80000c1c:	85d2                	mv	a1,s4
    80000c1e:	41250533          	sub	a0,a0,s2
    80000c22:	fffff097          	auipc	ra,0xfffff
    80000c26:	6aa080e7          	jalr	1706(ra) # 800002cc <memmove>

    len -= n;
    80000c2a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c2e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c34:	02098263          	beqz	s3,80000c58 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3c:	85ca                	mv	a1,s2
    80000c3e:	855a                	mv	a0,s6
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	9ba080e7          	jalr	-1606(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000c48:	cd01                	beqz	a0,80000c60 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c4a:	418904b3          	sub	s1,s2,s8
    80000c4e:	94d6                	add	s1,s1,s5
    80000c50:	fc99f3e3          	bgeu	s3,s1,80000c16 <copyout+0x28>
    80000c54:	84ce                	mv	s1,s3
    80000c56:	b7c1                	j	80000c16 <copyout+0x28>
  }
  return 0;
    80000c58:	4501                	li	a0,0
    80000c5a:	a021                	j	80000c62 <copyout+0x74>
    80000c5c:	4501                	li	a0,0
}
    80000c5e:	8082                	ret
      return -1;
    80000c60:	557d                	li	a0,-1
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6c02                	ld	s8,0(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret

0000000080000c7a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c7a:	caa5                	beqz	a3,80000cea <copyin+0x70>
{
    80000c7c:	715d                	addi	sp,sp,-80
    80000c7e:	e486                	sd	ra,72(sp)
    80000c80:	e0a2                	sd	s0,64(sp)
    80000c82:	fc26                	sd	s1,56(sp)
    80000c84:	f84a                	sd	s2,48(sp)
    80000c86:	f44e                	sd	s3,40(sp)
    80000c88:	f052                	sd	s4,32(sp)
    80000c8a:	ec56                	sd	s5,24(sp)
    80000c8c:	e85a                	sd	s6,16(sp)
    80000c8e:	e45e                	sd	s7,8(sp)
    80000c90:	e062                	sd	s8,0(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8b2a                	mv	s6,a0
    80000c96:	8a2e                	mv	s4,a1
    80000c98:	8c32                	mv	s8,a2
    80000c9a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6a85                	lui	s5,0x1
    80000ca0:	a01d                	j	80000cc6 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ca2:	018505b3          	add	a1,a0,s8
    80000ca6:	0004861b          	sext.w	a2,s1
    80000caa:	412585b3          	sub	a1,a1,s2
    80000cae:	8552                	mv	a0,s4
    80000cb0:	fffff097          	auipc	ra,0xfffff
    80000cb4:	61c080e7          	jalr	1564(ra) # 800002cc <memmove>

    len -= n;
    80000cb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cc2:	02098263          	beqz	s3,80000ce6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cca:	85ca                	mv	a1,s2
    80000ccc:	855a                	mv	a0,s6
    80000cce:	00000097          	auipc	ra,0x0
    80000cd2:	92c080e7          	jalr	-1748(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000cd6:	cd01                	beqz	a0,80000cee <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000cd8:	418904b3          	sub	s1,s2,s8
    80000cdc:	94d6                	add	s1,s1,s5
    80000cde:	fc99f2e3          	bgeu	s3,s1,80000ca2 <copyin+0x28>
    80000ce2:	84ce                	mv	s1,s3
    80000ce4:	bf7d                	j	80000ca2 <copyin+0x28>
  }
  return 0;
    80000ce6:	4501                	li	a0,0
    80000ce8:	a021                	j	80000cf0 <copyin+0x76>
    80000cea:	4501                	li	a0,0
}
    80000cec:	8082                	ret
      return -1;
    80000cee:	557d                	li	a0,-1
}
    80000cf0:	60a6                	ld	ra,72(sp)
    80000cf2:	6406                	ld	s0,64(sp)
    80000cf4:	74e2                	ld	s1,56(sp)
    80000cf6:	7942                	ld	s2,48(sp)
    80000cf8:	79a2                	ld	s3,40(sp)
    80000cfa:	7a02                	ld	s4,32(sp)
    80000cfc:	6ae2                	ld	s5,24(sp)
    80000cfe:	6b42                	ld	s6,16(sp)
    80000d00:	6ba2                	ld	s7,8(sp)
    80000d02:	6c02                	ld	s8,0(sp)
    80000d04:	6161                	addi	sp,sp,80
    80000d06:	8082                	ret

0000000080000d08 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d08:	c2dd                	beqz	a3,80000dae <copyinstr+0xa6>
{
    80000d0a:	715d                	addi	sp,sp,-80
    80000d0c:	e486                	sd	ra,72(sp)
    80000d0e:	e0a2                	sd	s0,64(sp)
    80000d10:	fc26                	sd	s1,56(sp)
    80000d12:	f84a                	sd	s2,48(sp)
    80000d14:	f44e                	sd	s3,40(sp)
    80000d16:	f052                	sd	s4,32(sp)
    80000d18:	ec56                	sd	s5,24(sp)
    80000d1a:	e85a                	sd	s6,16(sp)
    80000d1c:	e45e                	sd	s7,8(sp)
    80000d1e:	0880                	addi	s0,sp,80
    80000d20:	8a2a                	mv	s4,a0
    80000d22:	8b2e                	mv	s6,a1
    80000d24:	8bb2                	mv	s7,a2
    80000d26:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d2a:	6985                	lui	s3,0x1
    80000d2c:	a02d                	j	80000d56 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d34:	37fd                	addiw	a5,a5,-1
    80000d36:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d3a:	60a6                	ld	ra,72(sp)
    80000d3c:	6406                	ld	s0,64(sp)
    80000d3e:	74e2                	ld	s1,56(sp)
    80000d40:	7942                	ld	s2,48(sp)
    80000d42:	79a2                	ld	s3,40(sp)
    80000d44:	7a02                	ld	s4,32(sp)
    80000d46:	6ae2                	ld	s5,24(sp)
    80000d48:	6b42                	ld	s6,16(sp)
    80000d4a:	6ba2                	ld	s7,8(sp)
    80000d4c:	6161                	addi	sp,sp,80
    80000d4e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d50:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d54:	c8a9                	beqz	s1,80000da6 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d56:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d5a:	85ca                	mv	a1,s2
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	89c080e7          	jalr	-1892(ra) # 800005fa <walkaddr>
    if(pa0 == 0)
    80000d66:	c131                	beqz	a0,80000daa <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d68:	417906b3          	sub	a3,s2,s7
    80000d6c:	96ce                	add	a3,a3,s3
    80000d6e:	00d4f363          	bgeu	s1,a3,80000d74 <copyinstr+0x6c>
    80000d72:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d74:	955e                	add	a0,a0,s7
    80000d76:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d7a:	daf9                	beqz	a3,80000d50 <copyinstr+0x48>
    80000d7c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d7e:	41650633          	sub	a2,a0,s6
    80000d82:	fff48593          	addi	a1,s1,-1
    80000d86:	95da                	add	a1,a1,s6
    while(n > 0){
    80000d88:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000d8a:	00f60733          	add	a4,a2,a5
    80000d8e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffbd2b0>
    80000d92:	df51                	beqz	a4,80000d2e <copyinstr+0x26>
        *dst = *p;
    80000d94:	00e78023          	sb	a4,0(a5)
      --max;
    80000d98:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d9c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d9e:	fed796e3          	bne	a5,a3,80000d8a <copyinstr+0x82>
      dst++;
    80000da2:	8b3e                	mv	s6,a5
    80000da4:	b775                	j	80000d50 <copyinstr+0x48>
    80000da6:	4781                	li	a5,0
    80000da8:	b771                	j	80000d34 <copyinstr+0x2c>
      return -1;
    80000daa:	557d                	li	a0,-1
    80000dac:	b779                	j	80000d3a <copyinstr+0x32>
  int got_null = 0;
    80000dae:	4781                	li	a5,0
  if(got_null){
    80000db0:	37fd                	addiw	a5,a5,-1
    80000db2:	0007851b          	sext.w	a0,a5
}
    80000db6:	8082                	ret

0000000080000db8 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000db8:	7139                	addi	sp,sp,-64
    80000dba:	fc06                	sd	ra,56(sp)
    80000dbc:	f822                	sd	s0,48(sp)
    80000dbe:	f426                	sd	s1,40(sp)
    80000dc0:	f04a                	sd	s2,32(sp)
    80000dc2:	ec4e                	sd	s3,24(sp)
    80000dc4:	e852                	sd	s4,16(sp)
    80000dc6:	e456                	sd	s5,8(sp)
    80000dc8:	e05a                	sd	s6,0(sp)
    80000dca:	0080                	addi	s0,sp,64
    80000dcc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	00028497          	auipc	s1,0x28
    80000dd2:	f6248493          	addi	s1,s1,-158 # 80028d30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dd6:	8b26                	mv	s6,s1
    80000dd8:	00007a97          	auipc	s5,0x7
    80000ddc:	228a8a93          	addi	s5,s5,552 # 80008000 <etext>
    80000de0:	04000937          	lui	s2,0x4000
    80000de4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000de6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de8:	0002ea17          	auipc	s4,0x2e
    80000dec:	948a0a13          	addi	s4,s4,-1720 # 8002e730 <tickslock>
    char *pa = kalloc();
    80000df0:	fffff097          	auipc	ra,0xfffff
    80000df4:	408080e7          	jalr	1032(ra) # 800001f8 <kalloc>
    80000df8:	862a                	mv	a2,a0
    if(pa == 0)
    80000dfa:	c131                	beqz	a0,80000e3e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000dfc:	416485b3          	sub	a1,s1,s6
    80000e00:	858d                	srai	a1,a1,0x3
    80000e02:	000ab783          	ld	a5,0(s5)
    80000e06:	02f585b3          	mul	a1,a1,a5
    80000e0a:	2585                	addiw	a1,a1,1
    80000e0c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e10:	4719                	li	a4,6
    80000e12:	6685                	lui	a3,0x1
    80000e14:	40b905b3          	sub	a1,s2,a1
    80000e18:	854e                	mv	a0,s3
    80000e1a:	00000097          	auipc	ra,0x0
    80000e1e:	8ac080e7          	jalr	-1876(ra) # 800006c6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e22:	16848493          	addi	s1,s1,360
    80000e26:	fd4495e3          	bne	s1,s4,80000df0 <proc_mapstacks+0x38>
  }
}
    80000e2a:	70e2                	ld	ra,56(sp)
    80000e2c:	7442                	ld	s0,48(sp)
    80000e2e:	74a2                	ld	s1,40(sp)
    80000e30:	7902                	ld	s2,32(sp)
    80000e32:	69e2                	ld	s3,24(sp)
    80000e34:	6a42                	ld	s4,16(sp)
    80000e36:	6aa2                	ld	s5,8(sp)
    80000e38:	6b02                	ld	s6,0(sp)
    80000e3a:	6121                	addi	sp,sp,64
    80000e3c:	8082                	ret
      panic("kalloc");
    80000e3e:	00007517          	auipc	a0,0x7
    80000e42:	30a50513          	addi	a0,a0,778 # 80008148 <etext+0x148>
    80000e46:	00005097          	auipc	ra,0x5
    80000e4a:	f26080e7          	jalr	-218(ra) # 80005d6c <panic>

0000000080000e4e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e4e:	7139                	addi	sp,sp,-64
    80000e50:	fc06                	sd	ra,56(sp)
    80000e52:	f822                	sd	s0,48(sp)
    80000e54:	f426                	sd	s1,40(sp)
    80000e56:	f04a                	sd	s2,32(sp)
    80000e58:	ec4e                	sd	s3,24(sp)
    80000e5a:	e852                	sd	s4,16(sp)
    80000e5c:	e456                	sd	s5,8(sp)
    80000e5e:	e05a                	sd	s6,0(sp)
    80000e60:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e62:	00007597          	auipc	a1,0x7
    80000e66:	2ee58593          	addi	a1,a1,750 # 80008150 <etext+0x150>
    80000e6a:	00028517          	auipc	a0,0x28
    80000e6e:	a9650513          	addi	a0,a0,-1386 # 80028900 <pid_lock>
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	3f2080e7          	jalr	1010(ra) # 80006264 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e7a:	00007597          	auipc	a1,0x7
    80000e7e:	2de58593          	addi	a1,a1,734 # 80008158 <etext+0x158>
    80000e82:	00028517          	auipc	a0,0x28
    80000e86:	a9650513          	addi	a0,a0,-1386 # 80028918 <wait_lock>
    80000e8a:	00005097          	auipc	ra,0x5
    80000e8e:	3da080e7          	jalr	986(ra) # 80006264 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e92:	00028497          	auipc	s1,0x28
    80000e96:	e9e48493          	addi	s1,s1,-354 # 80028d30 <proc>
      initlock(&p->lock, "proc");
    80000e9a:	00007b17          	auipc	s6,0x7
    80000e9e:	2ceb0b13          	addi	s6,s6,718 # 80008168 <etext+0x168>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ea2:	8aa6                	mv	s5,s1
    80000ea4:	00007a17          	auipc	s4,0x7
    80000ea8:	15ca0a13          	addi	s4,s4,348 # 80008000 <etext>
    80000eac:	04000937          	lui	s2,0x4000
    80000eb0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000eb2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb4:	0002e997          	auipc	s3,0x2e
    80000eb8:	87c98993          	addi	s3,s3,-1924 # 8002e730 <tickslock>
      initlock(&p->lock, "proc");
    80000ebc:	85da                	mv	a1,s6
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	3a4080e7          	jalr	932(ra) # 80006264 <initlock>
      p->state = UNUSED;
    80000ec8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ecc:	415487b3          	sub	a5,s1,s5
    80000ed0:	878d                	srai	a5,a5,0x3
    80000ed2:	000a3703          	ld	a4,0(s4)
    80000ed6:	02e787b3          	mul	a5,a5,a4
    80000eda:	2785                	addiw	a5,a5,1
    80000edc:	00d7979b          	slliw	a5,a5,0xd
    80000ee0:	40f907b3          	sub	a5,s2,a5
    80000ee4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee6:	16848493          	addi	s1,s1,360
    80000eea:	fd3499e3          	bne	s1,s3,80000ebc <procinit+0x6e>
  }
}
    80000eee:	70e2                	ld	ra,56(sp)
    80000ef0:	7442                	ld	s0,48(sp)
    80000ef2:	74a2                	ld	s1,40(sp)
    80000ef4:	7902                	ld	s2,32(sp)
    80000ef6:	69e2                	ld	s3,24(sp)
    80000ef8:	6a42                	ld	s4,16(sp)
    80000efa:	6aa2                	ld	s5,8(sp)
    80000efc:	6b02                	ld	s6,0(sp)
    80000efe:	6121                	addi	sp,sp,64
    80000f00:	8082                	ret

0000000080000f02 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f02:	1141                	addi	sp,sp,-16
    80000f04:	e422                	sd	s0,8(sp)
    80000f06:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f08:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f0a:	2501                	sext.w	a0,a0
    80000f0c:	6422                	ld	s0,8(sp)
    80000f0e:	0141                	addi	sp,sp,16
    80000f10:	8082                	ret

0000000080000f12 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
    80000f18:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f1a:	2781                	sext.w	a5,a5
    80000f1c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f1e:	00028517          	auipc	a0,0x28
    80000f22:	a1250513          	addi	a0,a0,-1518 # 80028930 <cpus>
    80000f26:	953e                	add	a0,a0,a5
    80000f28:	6422                	ld	s0,8(sp)
    80000f2a:	0141                	addi	sp,sp,16
    80000f2c:	8082                	ret

0000000080000f2e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f2e:	1101                	addi	sp,sp,-32
    80000f30:	ec06                	sd	ra,24(sp)
    80000f32:	e822                	sd	s0,16(sp)
    80000f34:	e426                	sd	s1,8(sp)
    80000f36:	1000                	addi	s0,sp,32
  push_off();
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	370080e7          	jalr	880(ra) # 800062a8 <push_off>
    80000f40:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f42:	2781                	sext.w	a5,a5
    80000f44:	079e                	slli	a5,a5,0x7
    80000f46:	00028717          	auipc	a4,0x28
    80000f4a:	9ba70713          	addi	a4,a4,-1606 # 80028900 <pid_lock>
    80000f4e:	97ba                	add	a5,a5,a4
    80000f50:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	3f6080e7          	jalr	1014(ra) # 80006348 <pop_off>
  return p;
}
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6105                	addi	sp,sp,32
    80000f64:	8082                	ret

0000000080000f66 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f66:	1141                	addi	sp,sp,-16
    80000f68:	e406                	sd	ra,8(sp)
    80000f6a:	e022                	sd	s0,0(sp)
    80000f6c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	fc0080e7          	jalr	-64(ra) # 80000f2e <myproc>
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	432080e7          	jalr	1074(ra) # 800063a8 <release>

  if (first) {
    80000f7e:	00008797          	auipc	a5,0x8
    80000f82:	8c27a783          	lw	a5,-1854(a5) # 80008840 <first.1>
    80000f86:	eb89                	bnez	a5,80000f98 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	d30080e7          	jalr	-720(ra) # 80001cb8 <usertrapret>
}
    80000f90:	60a2                	ld	ra,8(sp)
    80000f92:	6402                	ld	s0,0(sp)
    80000f94:	0141                	addi	sp,sp,16
    80000f96:	8082                	ret
    first = 0;
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	8a07a423          	sw	zero,-1880(a5) # 80008840 <first.1>
    fsinit(ROOTDEV);
    80000fa0:	4505                	li	a0,1
    80000fa2:	00002097          	auipc	ra,0x2
    80000fa6:	a98080e7          	jalr	-1384(ra) # 80002a3a <fsinit>
    80000faa:	bff9                	j	80000f88 <forkret+0x22>

0000000080000fac <allocpid>:
{
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	e426                	sd	s1,8(sp)
    80000fb4:	e04a                	sd	s2,0(sp)
    80000fb6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fb8:	00028917          	auipc	s2,0x28
    80000fbc:	94890913          	addi	s2,s2,-1720 # 80028900 <pid_lock>
    80000fc0:	854a                	mv	a0,s2
    80000fc2:	00005097          	auipc	ra,0x5
    80000fc6:	332080e7          	jalr	818(ra) # 800062f4 <acquire>
  pid = nextpid;
    80000fca:	00008797          	auipc	a5,0x8
    80000fce:	87a78793          	addi	a5,a5,-1926 # 80008844 <nextpid>
    80000fd2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fd4:	0014871b          	addiw	a4,s1,1
    80000fd8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fda:	854a                	mv	a0,s2
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	3cc080e7          	jalr	972(ra) # 800063a8 <release>
}
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	60e2                	ld	ra,24(sp)
    80000fe8:	6442                	ld	s0,16(sp)
    80000fea:	64a2                	ld	s1,8(sp)
    80000fec:	6902                	ld	s2,0(sp)
    80000fee:	6105                	addi	sp,sp,32
    80000ff0:	8082                	ret

0000000080000ff2 <proc_pagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001000:	00000097          	auipc	ra,0x0
    80001004:	8b0080e7          	jalr	-1872(ra) # 800008b0 <uvmcreate>
    80001008:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000100a:	c121                	beqz	a0,8000104a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000100c:	4729                	li	a4,10
    8000100e:	00006697          	auipc	a3,0x6
    80001012:	ff268693          	addi	a3,a3,-14 # 80007000 <_trampoline>
    80001016:	6605                	lui	a2,0x1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	61c080e7          	jalr	1564(ra) # 8000063c <mappages>
    80001028:	02054863          	bltz	a0,80001058 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000102c:	4719                	li	a4,6
    8000102e:	05893683          	ld	a3,88(s2)
    80001032:	6605                	lui	a2,0x1
    80001034:	020005b7          	lui	a1,0x2000
    80001038:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000103a:	05b6                	slli	a1,a1,0xd
    8000103c:	8526                	mv	a0,s1
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	5fe080e7          	jalr	1534(ra) # 8000063c <mappages>
    80001046:	02054163          	bltz	a0,80001068 <proc_pagetable+0x76>
}
    8000104a:	8526                	mv	a0,s1
    8000104c:	60e2                	ld	ra,24(sp)
    8000104e:	6442                	ld	s0,16(sp)
    80001050:	64a2                	ld	s1,8(sp)
    80001052:	6902                	ld	s2,0(sp)
    80001054:	6105                	addi	sp,sp,32
    80001056:	8082                	ret
    uvmfree(pagetable, 0);
    80001058:	4581                	li	a1,0
    8000105a:	8526                	mv	a0,s1
    8000105c:	00000097          	auipc	ra,0x0
    80001060:	a5a080e7          	jalr	-1446(ra) # 80000ab6 <uvmfree>
    return 0;
    80001064:	4481                	li	s1,0
    80001066:	b7d5                	j	8000104a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001068:	4681                	li	a3,0
    8000106a:	4605                	li	a2,1
    8000106c:	040005b7          	lui	a1,0x4000
    80001070:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001072:	05b2                	slli	a1,a1,0xc
    80001074:	8526                	mv	a0,s1
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	776080e7          	jalr	1910(ra) # 800007ec <uvmunmap>
    uvmfree(pagetable, 0);
    8000107e:	4581                	li	a1,0
    80001080:	8526                	mv	a0,s1
    80001082:	00000097          	auipc	ra,0x0
    80001086:	a34080e7          	jalr	-1484(ra) # 80000ab6 <uvmfree>
    return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	bf7d                	j	8000104a <proc_pagetable+0x58>

000000008000108e <proc_freepagetable>:
{
    8000108e:	1101                	addi	sp,sp,-32
    80001090:	ec06                	sd	ra,24(sp)
    80001092:	e822                	sd	s0,16(sp)
    80001094:	e426                	sd	s1,8(sp)
    80001096:	e04a                	sd	s2,0(sp)
    80001098:	1000                	addi	s0,sp,32
    8000109a:	84aa                	mv	s1,a0
    8000109c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109e:	4681                	li	a3,0
    800010a0:	4605                	li	a2,1
    800010a2:	040005b7          	lui	a1,0x4000
    800010a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010a8:	05b2                	slli	a1,a1,0xc
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	742080e7          	jalr	1858(ra) # 800007ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010b2:	4681                	li	a3,0
    800010b4:	4605                	li	a2,1
    800010b6:	020005b7          	lui	a1,0x2000
    800010ba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010bc:	05b6                	slli	a1,a1,0xd
    800010be:	8526                	mv	a0,s1
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	72c080e7          	jalr	1836(ra) # 800007ec <uvmunmap>
  uvmfree(pagetable, sz);
    800010c8:	85ca                	mv	a1,s2
    800010ca:	8526                	mv	a0,s1
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	9ea080e7          	jalr	-1558(ra) # 80000ab6 <uvmfree>
}
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6902                	ld	s2,0(sp)
    800010dc:	6105                	addi	sp,sp,32
    800010de:	8082                	ret

00000000800010e0 <freeproc>:
{
    800010e0:	1101                	addi	sp,sp,-32
    800010e2:	ec06                	sd	ra,24(sp)
    800010e4:	e822                	sd	s0,16(sp)
    800010e6:	e426                	sd	s1,8(sp)
    800010e8:	1000                	addi	s0,sp,32
    800010ea:	84aa                	mv	s1,a0
  if(p->trapframe)
    800010ec:	6d28                	ld	a0,88(a0)
    800010ee:	c509                	beqz	a0,800010f8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800010f0:	fffff097          	auipc	ra,0xfffff
    800010f4:	fe8080e7          	jalr	-24(ra) # 800000d8 <kfree>
  p->trapframe = 0;
    800010f8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800010fc:	68a8                	ld	a0,80(s1)
    800010fe:	c511                	beqz	a0,8000110a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001100:	64ac                	ld	a1,72(s1)
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f8c080e7          	jalr	-116(ra) # 8000108e <proc_freepagetable>
  p->pagetable = 0;
    8000110a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000110e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001112:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001116:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000111a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000111e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001122:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001126:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000112a:	0004ac23          	sw	zero,24(s1)
}
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6105                	addi	sp,sp,32
    80001136:	8082                	ret

0000000080001138 <allocproc>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	e04a                	sd	s2,0(sp)
    80001142:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001144:	00028497          	auipc	s1,0x28
    80001148:	bec48493          	addi	s1,s1,-1044 # 80028d30 <proc>
    8000114c:	0002d917          	auipc	s2,0x2d
    80001150:	5e490913          	addi	s2,s2,1508 # 8002e730 <tickslock>
    acquire(&p->lock);
    80001154:	8526                	mv	a0,s1
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	19e080e7          	jalr	414(ra) # 800062f4 <acquire>
    if(p->state == UNUSED) {
    8000115e:	4c9c                	lw	a5,24(s1)
    80001160:	cf81                	beqz	a5,80001178 <allocproc+0x40>
      release(&p->lock);
    80001162:	8526                	mv	a0,s1
    80001164:	00005097          	auipc	ra,0x5
    80001168:	244080e7          	jalr	580(ra) # 800063a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116c:	16848493          	addi	s1,s1,360
    80001170:	ff2492e3          	bne	s1,s2,80001154 <allocproc+0x1c>
  return 0;
    80001174:	4481                	li	s1,0
    80001176:	a889                	j	800011c8 <allocproc+0x90>
  p->pid = allocpid();
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	e34080e7          	jalr	-460(ra) # 80000fac <allocpid>
    80001180:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001182:	4785                	li	a5,1
    80001184:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001186:	fffff097          	auipc	ra,0xfffff
    8000118a:	072080e7          	jalr	114(ra) # 800001f8 <kalloc>
    8000118e:	892a                	mv	s2,a0
    80001190:	eca8                	sd	a0,88(s1)
    80001192:	c131                	beqz	a0,800011d6 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	e5c080e7          	jalr	-420(ra) # 80000ff2 <proc_pagetable>
    8000119e:	892a                	mv	s2,a0
    800011a0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011a2:	c531                	beqz	a0,800011ee <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011a4:	07000613          	li	a2,112
    800011a8:	4581                	li	a1,0
    800011aa:	06048513          	addi	a0,s1,96
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	0c2080e7          	jalr	194(ra) # 80000270 <memset>
  p->context.ra = (uint64)forkret;
    800011b6:	00000797          	auipc	a5,0x0
    800011ba:	db078793          	addi	a5,a5,-592 # 80000f66 <forkret>
    800011be:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011c0:	60bc                	ld	a5,64(s1)
    800011c2:	6705                	lui	a4,0x1
    800011c4:	97ba                	add	a5,a5,a4
    800011c6:	f4bc                	sd	a5,104(s1)
}
    800011c8:	8526                	mv	a0,s1
    800011ca:	60e2                	ld	ra,24(sp)
    800011cc:	6442                	ld	s0,16(sp)
    800011ce:	64a2                	ld	s1,8(sp)
    800011d0:	6902                	ld	s2,0(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret
    freeproc(p);
    800011d6:	8526                	mv	a0,s1
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	f08080e7          	jalr	-248(ra) # 800010e0 <freeproc>
    release(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00005097          	auipc	ra,0x5
    800011e6:	1c6080e7          	jalr	454(ra) # 800063a8 <release>
    return 0;
    800011ea:	84ca                	mv	s1,s2
    800011ec:	bff1                	j	800011c8 <allocproc+0x90>
    freeproc(p);
    800011ee:	8526                	mv	a0,s1
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	ef0080e7          	jalr	-272(ra) # 800010e0 <freeproc>
    release(&p->lock);
    800011f8:	8526                	mv	a0,s1
    800011fa:	00005097          	auipc	ra,0x5
    800011fe:	1ae080e7          	jalr	430(ra) # 800063a8 <release>
    return 0;
    80001202:	84ca                	mv	s1,s2
    80001204:	b7d1                	j	800011c8 <allocproc+0x90>

0000000080001206 <userinit>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f28080e7          	jalr	-216(ra) # 80001138 <allocproc>
    80001218:	84aa                	mv	s1,a0
  initproc = p;
    8000121a:	00007797          	auipc	a5,0x7
    8000121e:	6aa7b323          	sd	a0,1702(a5) # 800088c0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001222:	03400613          	li	a2,52
    80001226:	00007597          	auipc	a1,0x7
    8000122a:	62a58593          	addi	a1,a1,1578 # 80008850 <initcode>
    8000122e:	6928                	ld	a0,80(a0)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	6ae080e7          	jalr	1710(ra) # 800008de <uvmfirst>
  p->sz = PGSIZE;
    80001238:	6785                	lui	a5,0x1
    8000123a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000123c:	6cb8                	ld	a4,88(s1)
    8000123e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001242:	6cb8                	ld	a4,88(s1)
    80001244:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001246:	4641                	li	a2,16
    80001248:	00007597          	auipc	a1,0x7
    8000124c:	f2858593          	addi	a1,a1,-216 # 80008170 <etext+0x170>
    80001250:	15848513          	addi	a0,s1,344
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	166080e7          	jalr	358(ra) # 800003ba <safestrcpy>
  p->cwd = namei("/");
    8000125c:	00007517          	auipc	a0,0x7
    80001260:	f2450513          	addi	a0,a0,-220 # 80008180 <etext+0x180>
    80001264:	00002097          	auipc	ra,0x2
    80001268:	200080e7          	jalr	512(ra) # 80003464 <namei>
    8000126c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001270:	478d                	li	a5,3
    80001272:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001274:	8526                	mv	a0,s1
    80001276:	00005097          	auipc	ra,0x5
    8000127a:	132080e7          	jalr	306(ra) # 800063a8 <release>
}
    8000127e:	60e2                	ld	ra,24(sp)
    80001280:	6442                	ld	s0,16(sp)
    80001282:	64a2                	ld	s1,8(sp)
    80001284:	6105                	addi	sp,sp,32
    80001286:	8082                	ret

0000000080001288 <growproc>:
{
    80001288:	1101                	addi	sp,sp,-32
    8000128a:	ec06                	sd	ra,24(sp)
    8000128c:	e822                	sd	s0,16(sp)
    8000128e:	e426                	sd	s1,8(sp)
    80001290:	e04a                	sd	s2,0(sp)
    80001292:	1000                	addi	s0,sp,32
    80001294:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	c98080e7          	jalr	-872(ra) # 80000f2e <myproc>
    8000129e:	84aa                	mv	s1,a0
  sz = p->sz;
    800012a0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800012a2:	01204c63          	bgtz	s2,800012ba <growproc+0x32>
  } else if(n < 0){
    800012a6:	02094663          	bltz	s2,800012d2 <growproc+0x4a>
  p->sz = sz;
    800012aa:	e4ac                	sd	a1,72(s1)
  return 0;
    800012ac:	4501                	li	a0,0
}
    800012ae:	60e2                	ld	ra,24(sp)
    800012b0:	6442                	ld	s0,16(sp)
    800012b2:	64a2                	ld	s1,8(sp)
    800012b4:	6902                	ld	s2,0(sp)
    800012b6:	6105                	addi	sp,sp,32
    800012b8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800012ba:	4691                	li	a3,4
    800012bc:	00b90633          	add	a2,s2,a1
    800012c0:	6928                	ld	a0,80(a0)
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	6d6080e7          	jalr	1750(ra) # 80000998 <uvmalloc>
    800012ca:	85aa                	mv	a1,a0
    800012cc:	fd79                	bnez	a0,800012aa <growproc+0x22>
      return -1;
    800012ce:	557d                	li	a0,-1
    800012d0:	bff9                	j	800012ae <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012d2:	00b90633          	add	a2,s2,a1
    800012d6:	6928                	ld	a0,80(a0)
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	678080e7          	jalr	1656(ra) # 80000950 <uvmdealloc>
    800012e0:	85aa                	mv	a1,a0
    800012e2:	b7e1                	j	800012aa <growproc+0x22>

00000000800012e4 <fork>:
{
    800012e4:	7139                	addi	sp,sp,-64
    800012e6:	fc06                	sd	ra,56(sp)
    800012e8:	f822                	sd	s0,48(sp)
    800012ea:	f426                	sd	s1,40(sp)
    800012ec:	f04a                	sd	s2,32(sp)
    800012ee:	ec4e                	sd	s3,24(sp)
    800012f0:	e852                	sd	s4,16(sp)
    800012f2:	e456                	sd	s5,8(sp)
    800012f4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	c38080e7          	jalr	-968(ra) # 80000f2e <myproc>
    800012fe:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001300:	00000097          	auipc	ra,0x0
    80001304:	e38080e7          	jalr	-456(ra) # 80001138 <allocproc>
    80001308:	10050c63          	beqz	a0,80001420 <fork+0x13c>
    8000130c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000130e:	048ab603          	ld	a2,72(s5)
    80001312:	692c                	ld	a1,80(a0)
    80001314:	050ab503          	ld	a0,80(s5)
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	7d8080e7          	jalr	2008(ra) # 80000af0 <uvmcopy>
    80001320:	04054863          	bltz	a0,80001370 <fork+0x8c>
  np->sz = p->sz;
    80001324:	048ab783          	ld	a5,72(s5)
    80001328:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000132c:	058ab683          	ld	a3,88(s5)
    80001330:	87b6                	mv	a5,a3
    80001332:	058a3703          	ld	a4,88(s4)
    80001336:	12068693          	addi	a3,a3,288
    8000133a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000133e:	6788                	ld	a0,8(a5)
    80001340:	6b8c                	ld	a1,16(a5)
    80001342:	6f90                	ld	a2,24(a5)
    80001344:	01073023          	sd	a6,0(a4)
    80001348:	e708                	sd	a0,8(a4)
    8000134a:	eb0c                	sd	a1,16(a4)
    8000134c:	ef10                	sd	a2,24(a4)
    8000134e:	02078793          	addi	a5,a5,32
    80001352:	02070713          	addi	a4,a4,32
    80001356:	fed792e3          	bne	a5,a3,8000133a <fork+0x56>
  np->trapframe->a0 = 0;
    8000135a:	058a3783          	ld	a5,88(s4)
    8000135e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001362:	0d0a8493          	addi	s1,s5,208
    80001366:	0d0a0913          	addi	s2,s4,208
    8000136a:	150a8993          	addi	s3,s5,336
    8000136e:	a00d                	j	80001390 <fork+0xac>
    freeproc(np);
    80001370:	8552                	mv	a0,s4
    80001372:	00000097          	auipc	ra,0x0
    80001376:	d6e080e7          	jalr	-658(ra) # 800010e0 <freeproc>
    release(&np->lock);
    8000137a:	8552                	mv	a0,s4
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	02c080e7          	jalr	44(ra) # 800063a8 <release>
    return -1;
    80001384:	597d                	li	s2,-1
    80001386:	a059                	j	8000140c <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001388:	04a1                	addi	s1,s1,8
    8000138a:	0921                	addi	s2,s2,8
    8000138c:	01348b63          	beq	s1,s3,800013a2 <fork+0xbe>
    if(p->ofile[i])
    80001390:	6088                	ld	a0,0(s1)
    80001392:	d97d                	beqz	a0,80001388 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001394:	00002097          	auipc	ra,0x2
    80001398:	766080e7          	jalr	1894(ra) # 80003afa <filedup>
    8000139c:	00a93023          	sd	a0,0(s2)
    800013a0:	b7e5                	j	80001388 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800013a2:	150ab503          	ld	a0,336(s5)
    800013a6:	00002097          	auipc	ra,0x2
    800013aa:	8d4080e7          	jalr	-1836(ra) # 80002c7a <idup>
    800013ae:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013b2:	4641                	li	a2,16
    800013b4:	158a8593          	addi	a1,s5,344
    800013b8:	158a0513          	addi	a0,s4,344
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	ffe080e7          	jalr	-2(ra) # 800003ba <safestrcpy>
  pid = np->pid;
    800013c4:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013c8:	8552                	mv	a0,s4
    800013ca:	00005097          	auipc	ra,0x5
    800013ce:	fde080e7          	jalr	-34(ra) # 800063a8 <release>
  acquire(&wait_lock);
    800013d2:	00027497          	auipc	s1,0x27
    800013d6:	54648493          	addi	s1,s1,1350 # 80028918 <wait_lock>
    800013da:	8526                	mv	a0,s1
    800013dc:	00005097          	auipc	ra,0x5
    800013e0:	f18080e7          	jalr	-232(ra) # 800062f4 <acquire>
  np->parent = p;
    800013e4:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	fbe080e7          	jalr	-66(ra) # 800063a8 <release>
  acquire(&np->lock);
    800013f2:	8552                	mv	a0,s4
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	f00080e7          	jalr	-256(ra) # 800062f4 <acquire>
  np->state = RUNNABLE;
    800013fc:	478d                	li	a5,3
    800013fe:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001402:	8552                	mv	a0,s4
    80001404:	00005097          	auipc	ra,0x5
    80001408:	fa4080e7          	jalr	-92(ra) # 800063a8 <release>
}
    8000140c:	854a                	mv	a0,s2
    8000140e:	70e2                	ld	ra,56(sp)
    80001410:	7442                	ld	s0,48(sp)
    80001412:	74a2                	ld	s1,40(sp)
    80001414:	7902                	ld	s2,32(sp)
    80001416:	69e2                	ld	s3,24(sp)
    80001418:	6a42                	ld	s4,16(sp)
    8000141a:	6aa2                	ld	s5,8(sp)
    8000141c:	6121                	addi	sp,sp,64
    8000141e:	8082                	ret
    return -1;
    80001420:	597d                	li	s2,-1
    80001422:	b7ed                	j	8000140c <fork+0x128>

0000000080001424 <scheduler>:
{
    80001424:	7139                	addi	sp,sp,-64
    80001426:	fc06                	sd	ra,56(sp)
    80001428:	f822                	sd	s0,48(sp)
    8000142a:	f426                	sd	s1,40(sp)
    8000142c:	f04a                	sd	s2,32(sp)
    8000142e:	ec4e                	sd	s3,24(sp)
    80001430:	e852                	sd	s4,16(sp)
    80001432:	e456                	sd	s5,8(sp)
    80001434:	e05a                	sd	s6,0(sp)
    80001436:	0080                	addi	s0,sp,64
    80001438:	8792                	mv	a5,tp
  int id = r_tp();
    8000143a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000143c:	00779a93          	slli	s5,a5,0x7
    80001440:	00027717          	auipc	a4,0x27
    80001444:	4c070713          	addi	a4,a4,1216 # 80028900 <pid_lock>
    80001448:	9756                	add	a4,a4,s5
    8000144a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000144e:	00027717          	auipc	a4,0x27
    80001452:	4ea70713          	addi	a4,a4,1258 # 80028938 <cpus+0x8>
    80001456:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001458:	498d                	li	s3,3
        p->state = RUNNING;
    8000145a:	4b11                	li	s6,4
        c->proc = p;
    8000145c:	079e                	slli	a5,a5,0x7
    8000145e:	00027a17          	auipc	s4,0x27
    80001462:	4a2a0a13          	addi	s4,s4,1186 # 80028900 <pid_lock>
    80001466:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001468:	0002d917          	auipc	s2,0x2d
    8000146c:	2c890913          	addi	s2,s2,712 # 8002e730 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001470:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001474:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001478:	10079073          	csrw	sstatus,a5
    8000147c:	00028497          	auipc	s1,0x28
    80001480:	8b448493          	addi	s1,s1,-1868 # 80028d30 <proc>
    80001484:	a811                	j	80001498 <scheduler+0x74>
      release(&p->lock);
    80001486:	8526                	mv	a0,s1
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	f20080e7          	jalr	-224(ra) # 800063a8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001490:	16848493          	addi	s1,s1,360
    80001494:	fd248ee3          	beq	s1,s2,80001470 <scheduler+0x4c>
      acquire(&p->lock);
    80001498:	8526                	mv	a0,s1
    8000149a:	00005097          	auipc	ra,0x5
    8000149e:	e5a080e7          	jalr	-422(ra) # 800062f4 <acquire>
      if(p->state == RUNNABLE) {
    800014a2:	4c9c                	lw	a5,24(s1)
    800014a4:	ff3791e3          	bne	a5,s3,80001486 <scheduler+0x62>
        p->state = RUNNING;
    800014a8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800014ac:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014b0:	06048593          	addi	a1,s1,96
    800014b4:	8556                	mv	a0,s5
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	684080e7          	jalr	1668(ra) # 80001b3a <swtch>
        c->proc = 0;
    800014be:	020a3823          	sd	zero,48(s4)
    800014c2:	b7d1                	j	80001486 <scheduler+0x62>

00000000800014c4 <sched>:
{
    800014c4:	7179                	addi	sp,sp,-48
    800014c6:	f406                	sd	ra,40(sp)
    800014c8:	f022                	sd	s0,32(sp)
    800014ca:	ec26                	sd	s1,24(sp)
    800014cc:	e84a                	sd	s2,16(sp)
    800014ce:	e44e                	sd	s3,8(sp)
    800014d0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	a5c080e7          	jalr	-1444(ra) # 80000f2e <myproc>
    800014da:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	d9e080e7          	jalr	-610(ra) # 8000627a <holding>
    800014e4:	c93d                	beqz	a0,8000155a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014e6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014e8:	2781                	sext.w	a5,a5
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	00027717          	auipc	a4,0x27
    800014f0:	41470713          	addi	a4,a4,1044 # 80028900 <pid_lock>
    800014f4:	97ba                	add	a5,a5,a4
    800014f6:	0a87a703          	lw	a4,168(a5)
    800014fa:	4785                	li	a5,1
    800014fc:	06f71763          	bne	a4,a5,8000156a <sched+0xa6>
  if(p->state == RUNNING)
    80001500:	4c98                	lw	a4,24(s1)
    80001502:	4791                	li	a5,4
    80001504:	06f70b63          	beq	a4,a5,8000157a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001508:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000150c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000150e:	efb5                	bnez	a5,8000158a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001510:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001512:	00027917          	auipc	s2,0x27
    80001516:	3ee90913          	addi	s2,s2,1006 # 80028900 <pid_lock>
    8000151a:	2781                	sext.w	a5,a5
    8000151c:	079e                	slli	a5,a5,0x7
    8000151e:	97ca                	add	a5,a5,s2
    80001520:	0ac7a983          	lw	s3,172(a5)
    80001524:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001526:	2781                	sext.w	a5,a5
    80001528:	079e                	slli	a5,a5,0x7
    8000152a:	00027597          	auipc	a1,0x27
    8000152e:	40e58593          	addi	a1,a1,1038 # 80028938 <cpus+0x8>
    80001532:	95be                	add	a1,a1,a5
    80001534:	06048513          	addi	a0,s1,96
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	602080e7          	jalr	1538(ra) # 80001b3a <swtch>
    80001540:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001542:	2781                	sext.w	a5,a5
    80001544:	079e                	slli	a5,a5,0x7
    80001546:	993e                	add	s2,s2,a5
    80001548:	0b392623          	sw	s3,172(s2)
}
    8000154c:	70a2                	ld	ra,40(sp)
    8000154e:	7402                	ld	s0,32(sp)
    80001550:	64e2                	ld	s1,24(sp)
    80001552:	6942                	ld	s2,16(sp)
    80001554:	69a2                	ld	s3,8(sp)
    80001556:	6145                	addi	sp,sp,48
    80001558:	8082                	ret
    panic("sched p->lock");
    8000155a:	00007517          	auipc	a0,0x7
    8000155e:	c2e50513          	addi	a0,a0,-978 # 80008188 <etext+0x188>
    80001562:	00005097          	auipc	ra,0x5
    80001566:	80a080e7          	jalr	-2038(ra) # 80005d6c <panic>
    panic("sched locks");
    8000156a:	00007517          	auipc	a0,0x7
    8000156e:	c2e50513          	addi	a0,a0,-978 # 80008198 <etext+0x198>
    80001572:	00004097          	auipc	ra,0x4
    80001576:	7fa080e7          	jalr	2042(ra) # 80005d6c <panic>
    panic("sched running");
    8000157a:	00007517          	auipc	a0,0x7
    8000157e:	c2e50513          	addi	a0,a0,-978 # 800081a8 <etext+0x1a8>
    80001582:	00004097          	auipc	ra,0x4
    80001586:	7ea080e7          	jalr	2026(ra) # 80005d6c <panic>
    panic("sched interruptible");
    8000158a:	00007517          	auipc	a0,0x7
    8000158e:	c2e50513          	addi	a0,a0,-978 # 800081b8 <etext+0x1b8>
    80001592:	00004097          	auipc	ra,0x4
    80001596:	7da080e7          	jalr	2010(ra) # 80005d6c <panic>

000000008000159a <yield>:
{
    8000159a:	1101                	addi	sp,sp,-32
    8000159c:	ec06                	sd	ra,24(sp)
    8000159e:	e822                	sd	s0,16(sp)
    800015a0:	e426                	sd	s1,8(sp)
    800015a2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	98a080e7          	jalr	-1654(ra) # 80000f2e <myproc>
    800015ac:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	d46080e7          	jalr	-698(ra) # 800062f4 <acquire>
  p->state = RUNNABLE;
    800015b6:	478d                	li	a5,3
    800015b8:	cc9c                	sw	a5,24(s1)
  sched();
    800015ba:	00000097          	auipc	ra,0x0
    800015be:	f0a080e7          	jalr	-246(ra) # 800014c4 <sched>
  release(&p->lock);
    800015c2:	8526                	mv	a0,s1
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	de4080e7          	jalr	-540(ra) # 800063a8 <release>
}
    800015cc:	60e2                	ld	ra,24(sp)
    800015ce:	6442                	ld	s0,16(sp)
    800015d0:	64a2                	ld	s1,8(sp)
    800015d2:	6105                	addi	sp,sp,32
    800015d4:	8082                	ret

00000000800015d6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015d6:	7179                	addi	sp,sp,-48
    800015d8:	f406                	sd	ra,40(sp)
    800015da:	f022                	sd	s0,32(sp)
    800015dc:	ec26                	sd	s1,24(sp)
    800015de:	e84a                	sd	s2,16(sp)
    800015e0:	e44e                	sd	s3,8(sp)
    800015e2:	1800                	addi	s0,sp,48
    800015e4:	89aa                	mv	s3,a0
    800015e6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	946080e7          	jalr	-1722(ra) # 80000f2e <myproc>
    800015f0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	d02080e7          	jalr	-766(ra) # 800062f4 <acquire>
  release(lk);
    800015fa:	854a                	mv	a0,s2
    800015fc:	00005097          	auipc	ra,0x5
    80001600:	dac080e7          	jalr	-596(ra) # 800063a8 <release>

  // Go to sleep.
  p->chan = chan;
    80001604:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001608:	4789                	li	a5,2
    8000160a:	cc9c                	sw	a5,24(s1)

  sched();
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	eb8080e7          	jalr	-328(ra) # 800014c4 <sched>

  // Tidy up.
  p->chan = 0;
    80001614:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	d8e080e7          	jalr	-626(ra) # 800063a8 <release>
  acquire(lk);
    80001622:	854a                	mv	a0,s2
    80001624:	00005097          	auipc	ra,0x5
    80001628:	cd0080e7          	jalr	-816(ra) # 800062f4 <acquire>
}
    8000162c:	70a2                	ld	ra,40(sp)
    8000162e:	7402                	ld	s0,32(sp)
    80001630:	64e2                	ld	s1,24(sp)
    80001632:	6942                	ld	s2,16(sp)
    80001634:	69a2                	ld	s3,8(sp)
    80001636:	6145                	addi	sp,sp,48
    80001638:	8082                	ret

000000008000163a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000163a:	7139                	addi	sp,sp,-64
    8000163c:	fc06                	sd	ra,56(sp)
    8000163e:	f822                	sd	s0,48(sp)
    80001640:	f426                	sd	s1,40(sp)
    80001642:	f04a                	sd	s2,32(sp)
    80001644:	ec4e                	sd	s3,24(sp)
    80001646:	e852                	sd	s4,16(sp)
    80001648:	e456                	sd	s5,8(sp)
    8000164a:	0080                	addi	s0,sp,64
    8000164c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000164e:	00027497          	auipc	s1,0x27
    80001652:	6e248493          	addi	s1,s1,1762 # 80028d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001656:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001658:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000165a:	0002d917          	auipc	s2,0x2d
    8000165e:	0d690913          	addi	s2,s2,214 # 8002e730 <tickslock>
    80001662:	a811                	j	80001676 <wakeup+0x3c>
      }
      release(&p->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	d42080e7          	jalr	-702(ra) # 800063a8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000166e:	16848493          	addi	s1,s1,360
    80001672:	03248663          	beq	s1,s2,8000169e <wakeup+0x64>
    if(p != myproc()){
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	8b8080e7          	jalr	-1864(ra) # 80000f2e <myproc>
    8000167e:	fea488e3          	beq	s1,a0,8000166e <wakeup+0x34>
      acquire(&p->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	c70080e7          	jalr	-912(ra) # 800062f4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	fd379be3          	bne	a5,s3,80001664 <wakeup+0x2a>
    80001692:	709c                	ld	a5,32(s1)
    80001694:	fd4798e3          	bne	a5,s4,80001664 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001698:	0154ac23          	sw	s5,24(s1)
    8000169c:	b7e1                	j	80001664 <wakeup+0x2a>
    }
  }
}
    8000169e:	70e2                	ld	ra,56(sp)
    800016a0:	7442                	ld	s0,48(sp)
    800016a2:	74a2                	ld	s1,40(sp)
    800016a4:	7902                	ld	s2,32(sp)
    800016a6:	69e2                	ld	s3,24(sp)
    800016a8:	6a42                	ld	s4,16(sp)
    800016aa:	6aa2                	ld	s5,8(sp)
    800016ac:	6121                	addi	sp,sp,64
    800016ae:	8082                	ret

00000000800016b0 <reparent>:
{
    800016b0:	7179                	addi	sp,sp,-48
    800016b2:	f406                	sd	ra,40(sp)
    800016b4:	f022                	sd	s0,32(sp)
    800016b6:	ec26                	sd	s1,24(sp)
    800016b8:	e84a                	sd	s2,16(sp)
    800016ba:	e44e                	sd	s3,8(sp)
    800016bc:	e052                	sd	s4,0(sp)
    800016be:	1800                	addi	s0,sp,48
    800016c0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c2:	00027497          	auipc	s1,0x27
    800016c6:	66e48493          	addi	s1,s1,1646 # 80028d30 <proc>
      pp->parent = initproc;
    800016ca:	00007a17          	auipc	s4,0x7
    800016ce:	1f6a0a13          	addi	s4,s4,502 # 800088c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016d2:	0002d997          	auipc	s3,0x2d
    800016d6:	05e98993          	addi	s3,s3,94 # 8002e730 <tickslock>
    800016da:	a029                	j	800016e4 <reparent+0x34>
    800016dc:	16848493          	addi	s1,s1,360
    800016e0:	01348d63          	beq	s1,s3,800016fa <reparent+0x4a>
    if(pp->parent == p){
    800016e4:	7c9c                	ld	a5,56(s1)
    800016e6:	ff279be3          	bne	a5,s2,800016dc <reparent+0x2c>
      pp->parent = initproc;
    800016ea:	000a3503          	ld	a0,0(s4)
    800016ee:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	f4a080e7          	jalr	-182(ra) # 8000163a <wakeup>
    800016f8:	b7d5                	j	800016dc <reparent+0x2c>
}
    800016fa:	70a2                	ld	ra,40(sp)
    800016fc:	7402                	ld	s0,32(sp)
    800016fe:	64e2                	ld	s1,24(sp)
    80001700:	6942                	ld	s2,16(sp)
    80001702:	69a2                	ld	s3,8(sp)
    80001704:	6a02                	ld	s4,0(sp)
    80001706:	6145                	addi	sp,sp,48
    80001708:	8082                	ret

000000008000170a <exit>:
{
    8000170a:	7179                	addi	sp,sp,-48
    8000170c:	f406                	sd	ra,40(sp)
    8000170e:	f022                	sd	s0,32(sp)
    80001710:	ec26                	sd	s1,24(sp)
    80001712:	e84a                	sd	s2,16(sp)
    80001714:	e44e                	sd	s3,8(sp)
    80001716:	e052                	sd	s4,0(sp)
    80001718:	1800                	addi	s0,sp,48
    8000171a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	812080e7          	jalr	-2030(ra) # 80000f2e <myproc>
    80001724:	89aa                	mv	s3,a0
  if(p == initproc)
    80001726:	00007797          	auipc	a5,0x7
    8000172a:	19a7b783          	ld	a5,410(a5) # 800088c0 <initproc>
    8000172e:	0d050493          	addi	s1,a0,208
    80001732:	15050913          	addi	s2,a0,336
    80001736:	02a79363          	bne	a5,a0,8000175c <exit+0x52>
    panic("init exiting");
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	a9650513          	addi	a0,a0,-1386 # 800081d0 <etext+0x1d0>
    80001742:	00004097          	auipc	ra,0x4
    80001746:	62a080e7          	jalr	1578(ra) # 80005d6c <panic>
      fileclose(f);
    8000174a:	00002097          	auipc	ra,0x2
    8000174e:	402080e7          	jalr	1026(ra) # 80003b4c <fileclose>
      p->ofile[fd] = 0;
    80001752:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001756:	04a1                	addi	s1,s1,8
    80001758:	01248563          	beq	s1,s2,80001762 <exit+0x58>
    if(p->ofile[fd]){
    8000175c:	6088                	ld	a0,0(s1)
    8000175e:	f575                	bnez	a0,8000174a <exit+0x40>
    80001760:	bfdd                	j	80001756 <exit+0x4c>
  begin_op();
    80001762:	00002097          	auipc	ra,0x2
    80001766:	f22080e7          	jalr	-222(ra) # 80003684 <begin_op>
  iput(p->cwd);
    8000176a:	1509b503          	ld	a0,336(s3)
    8000176e:	00001097          	auipc	ra,0x1
    80001772:	704080e7          	jalr	1796(ra) # 80002e72 <iput>
  end_op();
    80001776:	00002097          	auipc	ra,0x2
    8000177a:	f8c080e7          	jalr	-116(ra) # 80003702 <end_op>
  p->cwd = 0;
    8000177e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001782:	00027497          	auipc	s1,0x27
    80001786:	19648493          	addi	s1,s1,406 # 80028918 <wait_lock>
    8000178a:	8526                	mv	a0,s1
    8000178c:	00005097          	auipc	ra,0x5
    80001790:	b68080e7          	jalr	-1176(ra) # 800062f4 <acquire>
  reparent(p);
    80001794:	854e                	mv	a0,s3
    80001796:	00000097          	auipc	ra,0x0
    8000179a:	f1a080e7          	jalr	-230(ra) # 800016b0 <reparent>
  wakeup(p->parent);
    8000179e:	0389b503          	ld	a0,56(s3)
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	e98080e7          	jalr	-360(ra) # 8000163a <wakeup>
  acquire(&p->lock);
    800017aa:	854e                	mv	a0,s3
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	b48080e7          	jalr	-1208(ra) # 800062f4 <acquire>
  p->xstate = status;
    800017b4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017b8:	4795                	li	a5,5
    800017ba:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	be8080e7          	jalr	-1048(ra) # 800063a8 <release>
  sched();
    800017c8:	00000097          	auipc	ra,0x0
    800017cc:	cfc080e7          	jalr	-772(ra) # 800014c4 <sched>
  panic("zombie exit");
    800017d0:	00007517          	auipc	a0,0x7
    800017d4:	a1050513          	addi	a0,a0,-1520 # 800081e0 <etext+0x1e0>
    800017d8:	00004097          	auipc	ra,0x4
    800017dc:	594080e7          	jalr	1428(ra) # 80005d6c <panic>

00000000800017e0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800017e0:	7179                	addi	sp,sp,-48
    800017e2:	f406                	sd	ra,40(sp)
    800017e4:	f022                	sd	s0,32(sp)
    800017e6:	ec26                	sd	s1,24(sp)
    800017e8:	e84a                	sd	s2,16(sp)
    800017ea:	e44e                	sd	s3,8(sp)
    800017ec:	1800                	addi	s0,sp,48
    800017ee:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017f0:	00027497          	auipc	s1,0x27
    800017f4:	54048493          	addi	s1,s1,1344 # 80028d30 <proc>
    800017f8:	0002d997          	auipc	s3,0x2d
    800017fc:	f3898993          	addi	s3,s3,-200 # 8002e730 <tickslock>
    acquire(&p->lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	af2080e7          	jalr	-1294(ra) # 800062f4 <acquire>
    if(p->pid == pid){
    8000180a:	589c                	lw	a5,48(s1)
    8000180c:	01278d63          	beq	a5,s2,80001826 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	b96080e7          	jalr	-1130(ra) # 800063a8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000181a:	16848493          	addi	s1,s1,360
    8000181e:	ff3491e3          	bne	s1,s3,80001800 <kill+0x20>
  }
  return -1;
    80001822:	557d                	li	a0,-1
    80001824:	a829                	j	8000183e <kill+0x5e>
      p->killed = 1;
    80001826:	4785                	li	a5,1
    80001828:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000182a:	4c98                	lw	a4,24(s1)
    8000182c:	4789                	li	a5,2
    8000182e:	00f70f63          	beq	a4,a5,8000184c <kill+0x6c>
      release(&p->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	b74080e7          	jalr	-1164(ra) # 800063a8 <release>
      return 0;
    8000183c:	4501                	li	a0,0
}
    8000183e:	70a2                	ld	ra,40(sp)
    80001840:	7402                	ld	s0,32(sp)
    80001842:	64e2                	ld	s1,24(sp)
    80001844:	6942                	ld	s2,16(sp)
    80001846:	69a2                	ld	s3,8(sp)
    80001848:	6145                	addi	sp,sp,48
    8000184a:	8082                	ret
        p->state = RUNNABLE;
    8000184c:	478d                	li	a5,3
    8000184e:	cc9c                	sw	a5,24(s1)
    80001850:	b7cd                	j	80001832 <kill+0x52>

0000000080001852 <setkilled>:

void
setkilled(struct proc *p)
{
    80001852:	1101                	addi	sp,sp,-32
    80001854:	ec06                	sd	ra,24(sp)
    80001856:	e822                	sd	s0,16(sp)
    80001858:	e426                	sd	s1,8(sp)
    8000185a:	1000                	addi	s0,sp,32
    8000185c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000185e:	00005097          	auipc	ra,0x5
    80001862:	a96080e7          	jalr	-1386(ra) # 800062f4 <acquire>
  p->killed = 1;
    80001866:	4785                	li	a5,1
    80001868:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	b3c080e7          	jalr	-1220(ra) # 800063a8 <release>
}
    80001874:	60e2                	ld	ra,24(sp)
    80001876:	6442                	ld	s0,16(sp)
    80001878:	64a2                	ld	s1,8(sp)
    8000187a:	6105                	addi	sp,sp,32
    8000187c:	8082                	ret

000000008000187e <killed>:

int
killed(struct proc *p)
{
    8000187e:	1101                	addi	sp,sp,-32
    80001880:	ec06                	sd	ra,24(sp)
    80001882:	e822                	sd	s0,16(sp)
    80001884:	e426                	sd	s1,8(sp)
    80001886:	e04a                	sd	s2,0(sp)
    80001888:	1000                	addi	s0,sp,32
    8000188a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	a68080e7          	jalr	-1432(ra) # 800062f4 <acquire>
  k = p->killed;
    80001894:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	b0e080e7          	jalr	-1266(ra) # 800063a8 <release>
  return k;
}
    800018a2:	854a                	mv	a0,s2
    800018a4:	60e2                	ld	ra,24(sp)
    800018a6:	6442                	ld	s0,16(sp)
    800018a8:	64a2                	ld	s1,8(sp)
    800018aa:	6902                	ld	s2,0(sp)
    800018ac:	6105                	addi	sp,sp,32
    800018ae:	8082                	ret

00000000800018b0 <wait>:
{
    800018b0:	715d                	addi	sp,sp,-80
    800018b2:	e486                	sd	ra,72(sp)
    800018b4:	e0a2                	sd	s0,64(sp)
    800018b6:	fc26                	sd	s1,56(sp)
    800018b8:	f84a                	sd	s2,48(sp)
    800018ba:	f44e                	sd	s3,40(sp)
    800018bc:	f052                	sd	s4,32(sp)
    800018be:	ec56                	sd	s5,24(sp)
    800018c0:	e85a                	sd	s6,16(sp)
    800018c2:	e45e                	sd	s7,8(sp)
    800018c4:	e062                	sd	s8,0(sp)
    800018c6:	0880                	addi	s0,sp,80
    800018c8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800018ca:	fffff097          	auipc	ra,0xfffff
    800018ce:	664080e7          	jalr	1636(ra) # 80000f2e <myproc>
    800018d2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018d4:	00027517          	auipc	a0,0x27
    800018d8:	04450513          	addi	a0,a0,68 # 80028918 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	a18080e7          	jalr	-1512(ra) # 800062f4 <acquire>
    havekids = 0;
    800018e4:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800018e6:	4a15                	li	s4,5
        havekids = 1;
    800018e8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ea:	0002d997          	auipc	s3,0x2d
    800018ee:	e4698993          	addi	s3,s3,-442 # 8002e730 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018f2:	00027c17          	auipc	s8,0x27
    800018f6:	026c0c13          	addi	s8,s8,38 # 80028918 <wait_lock>
    havekids = 0;
    800018fa:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018fc:	00027497          	auipc	s1,0x27
    80001900:	43448493          	addi	s1,s1,1076 # 80028d30 <proc>
    80001904:	a0bd                	j	80001972 <wait+0xc2>
          pid = pp->pid;
    80001906:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000190a:	000b0e63          	beqz	s6,80001926 <wait+0x76>
    8000190e:	4691                	li	a3,4
    80001910:	02c48613          	addi	a2,s1,44
    80001914:	85da                	mv	a1,s6
    80001916:	05093503          	ld	a0,80(s2)
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	2d4080e7          	jalr	724(ra) # 80000bee <copyout>
    80001922:	02054563          	bltz	a0,8000194c <wait+0x9c>
          freeproc(pp);
    80001926:	8526                	mv	a0,s1
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	7b8080e7          	jalr	1976(ra) # 800010e0 <freeproc>
          release(&pp->lock);
    80001930:	8526                	mv	a0,s1
    80001932:	00005097          	auipc	ra,0x5
    80001936:	a76080e7          	jalr	-1418(ra) # 800063a8 <release>
          release(&wait_lock);
    8000193a:	00027517          	auipc	a0,0x27
    8000193e:	fde50513          	addi	a0,a0,-34 # 80028918 <wait_lock>
    80001942:	00005097          	auipc	ra,0x5
    80001946:	a66080e7          	jalr	-1434(ra) # 800063a8 <release>
          return pid;
    8000194a:	a0b5                	j	800019b6 <wait+0x106>
            release(&pp->lock);
    8000194c:	8526                	mv	a0,s1
    8000194e:	00005097          	auipc	ra,0x5
    80001952:	a5a080e7          	jalr	-1446(ra) # 800063a8 <release>
            release(&wait_lock);
    80001956:	00027517          	auipc	a0,0x27
    8000195a:	fc250513          	addi	a0,a0,-62 # 80028918 <wait_lock>
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	a4a080e7          	jalr	-1462(ra) # 800063a8 <release>
            return -1;
    80001966:	59fd                	li	s3,-1
    80001968:	a0b9                	j	800019b6 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000196a:	16848493          	addi	s1,s1,360
    8000196e:	03348463          	beq	s1,s3,80001996 <wait+0xe6>
      if(pp->parent == p){
    80001972:	7c9c                	ld	a5,56(s1)
    80001974:	ff279be3          	bne	a5,s2,8000196a <wait+0xba>
        acquire(&pp->lock);
    80001978:	8526                	mv	a0,s1
    8000197a:	00005097          	auipc	ra,0x5
    8000197e:	97a080e7          	jalr	-1670(ra) # 800062f4 <acquire>
        if(pp->state == ZOMBIE){
    80001982:	4c9c                	lw	a5,24(s1)
    80001984:	f94781e3          	beq	a5,s4,80001906 <wait+0x56>
        release(&pp->lock);
    80001988:	8526                	mv	a0,s1
    8000198a:	00005097          	auipc	ra,0x5
    8000198e:	a1e080e7          	jalr	-1506(ra) # 800063a8 <release>
        havekids = 1;
    80001992:	8756                	mv	a4,s5
    80001994:	bfd9                	j	8000196a <wait+0xba>
    if(!havekids || killed(p)){
    80001996:	c719                	beqz	a4,800019a4 <wait+0xf4>
    80001998:	854a                	mv	a0,s2
    8000199a:	00000097          	auipc	ra,0x0
    8000199e:	ee4080e7          	jalr	-284(ra) # 8000187e <killed>
    800019a2:	c51d                	beqz	a0,800019d0 <wait+0x120>
      release(&wait_lock);
    800019a4:	00027517          	auipc	a0,0x27
    800019a8:	f7450513          	addi	a0,a0,-140 # 80028918 <wait_lock>
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	9fc080e7          	jalr	-1540(ra) # 800063a8 <release>
      return -1;
    800019b4:	59fd                	li	s3,-1
}
    800019b6:	854e                	mv	a0,s3
    800019b8:	60a6                	ld	ra,72(sp)
    800019ba:	6406                	ld	s0,64(sp)
    800019bc:	74e2                	ld	s1,56(sp)
    800019be:	7942                	ld	s2,48(sp)
    800019c0:	79a2                	ld	s3,40(sp)
    800019c2:	7a02                	ld	s4,32(sp)
    800019c4:	6ae2                	ld	s5,24(sp)
    800019c6:	6b42                	ld	s6,16(sp)
    800019c8:	6ba2                	ld	s7,8(sp)
    800019ca:	6c02                	ld	s8,0(sp)
    800019cc:	6161                	addi	sp,sp,80
    800019ce:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019d0:	85e2                	mv	a1,s8
    800019d2:	854a                	mv	a0,s2
    800019d4:	00000097          	auipc	ra,0x0
    800019d8:	c02080e7          	jalr	-1022(ra) # 800015d6 <sleep>
    havekids = 0;
    800019dc:	bf39                	j	800018fa <wait+0x4a>

00000000800019de <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019de:	7179                	addi	sp,sp,-48
    800019e0:	f406                	sd	ra,40(sp)
    800019e2:	f022                	sd	s0,32(sp)
    800019e4:	ec26                	sd	s1,24(sp)
    800019e6:	e84a                	sd	s2,16(sp)
    800019e8:	e44e                	sd	s3,8(sp)
    800019ea:	e052                	sd	s4,0(sp)
    800019ec:	1800                	addi	s0,sp,48
    800019ee:	84aa                	mv	s1,a0
    800019f0:	892e                	mv	s2,a1
    800019f2:	89b2                	mv	s3,a2
    800019f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	538080e7          	jalr	1336(ra) # 80000f2e <myproc>
  if(user_dst){
    800019fe:	c08d                	beqz	s1,80001a20 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a00:	86d2                	mv	a3,s4
    80001a02:	864e                	mv	a2,s3
    80001a04:	85ca                	mv	a1,s2
    80001a06:	6928                	ld	a0,80(a0)
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	1e6080e7          	jalr	486(ra) # 80000bee <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a10:	70a2                	ld	ra,40(sp)
    80001a12:	7402                	ld	s0,32(sp)
    80001a14:	64e2                	ld	s1,24(sp)
    80001a16:	6942                	ld	s2,16(sp)
    80001a18:	69a2                	ld	s3,8(sp)
    80001a1a:	6a02                	ld	s4,0(sp)
    80001a1c:	6145                	addi	sp,sp,48
    80001a1e:	8082                	ret
    memmove((char *)dst, src, len);
    80001a20:	000a061b          	sext.w	a2,s4
    80001a24:	85ce                	mv	a1,s3
    80001a26:	854a                	mv	a0,s2
    80001a28:	fffff097          	auipc	ra,0xfffff
    80001a2c:	8a4080e7          	jalr	-1884(ra) # 800002cc <memmove>
    return 0;
    80001a30:	8526                	mv	a0,s1
    80001a32:	bff9                	j	80001a10 <either_copyout+0x32>

0000000080001a34 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a34:	7179                	addi	sp,sp,-48
    80001a36:	f406                	sd	ra,40(sp)
    80001a38:	f022                	sd	s0,32(sp)
    80001a3a:	ec26                	sd	s1,24(sp)
    80001a3c:	e84a                	sd	s2,16(sp)
    80001a3e:	e44e                	sd	s3,8(sp)
    80001a40:	e052                	sd	s4,0(sp)
    80001a42:	1800                	addi	s0,sp,48
    80001a44:	892a                	mv	s2,a0
    80001a46:	84ae                	mv	s1,a1
    80001a48:	89b2                	mv	s3,a2
    80001a4a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	4e2080e7          	jalr	1250(ra) # 80000f2e <myproc>
  if(user_src){
    80001a54:	c08d                	beqz	s1,80001a76 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a56:	86d2                	mv	a3,s4
    80001a58:	864e                	mv	a2,s3
    80001a5a:	85ca                	mv	a1,s2
    80001a5c:	6928                	ld	a0,80(a0)
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	21c080e7          	jalr	540(ra) # 80000c7a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a66:	70a2                	ld	ra,40(sp)
    80001a68:	7402                	ld	s0,32(sp)
    80001a6a:	64e2                	ld	s1,24(sp)
    80001a6c:	6942                	ld	s2,16(sp)
    80001a6e:	69a2                	ld	s3,8(sp)
    80001a70:	6a02                	ld	s4,0(sp)
    80001a72:	6145                	addi	sp,sp,48
    80001a74:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a76:	000a061b          	sext.w	a2,s4
    80001a7a:	85ce                	mv	a1,s3
    80001a7c:	854a                	mv	a0,s2
    80001a7e:	fffff097          	auipc	ra,0xfffff
    80001a82:	84e080e7          	jalr	-1970(ra) # 800002cc <memmove>
    return 0;
    80001a86:	8526                	mv	a0,s1
    80001a88:	bff9                	j	80001a66 <either_copyin+0x32>

0000000080001a8a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a8a:	715d                	addi	sp,sp,-80
    80001a8c:	e486                	sd	ra,72(sp)
    80001a8e:	e0a2                	sd	s0,64(sp)
    80001a90:	fc26                	sd	s1,56(sp)
    80001a92:	f84a                	sd	s2,48(sp)
    80001a94:	f44e                	sd	s3,40(sp)
    80001a96:	f052                	sd	s4,32(sp)
    80001a98:	ec56                	sd	s5,24(sp)
    80001a9a:	e85a                	sd	s6,16(sp)
    80001a9c:	e45e                	sd	s7,8(sp)
    80001a9e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aa0:	00006517          	auipc	a0,0x6
    80001aa4:	5a850513          	addi	a0,a0,1448 # 80008048 <etext+0x48>
    80001aa8:	00004097          	auipc	ra,0x4
    80001aac:	30e080e7          	jalr	782(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ab0:	00027497          	auipc	s1,0x27
    80001ab4:	3d848493          	addi	s1,s1,984 # 80028e88 <proc+0x158>
    80001ab8:	0002d917          	auipc	s2,0x2d
    80001abc:	dd090913          	addi	s2,s2,-560 # 8002e888 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ac2:	00006997          	auipc	s3,0x6
    80001ac6:	72e98993          	addi	s3,s3,1838 # 800081f0 <etext+0x1f0>
    printf("%d %s %s", p->pid, state, p->name);
    80001aca:	00006a97          	auipc	s5,0x6
    80001ace:	72ea8a93          	addi	s5,s5,1838 # 800081f8 <etext+0x1f8>
    printf("\n");
    80001ad2:	00006a17          	auipc	s4,0x6
    80001ad6:	576a0a13          	addi	s4,s4,1398 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ada:	00006b97          	auipc	s7,0x6
    80001ade:	75eb8b93          	addi	s7,s7,1886 # 80008238 <states.0>
    80001ae2:	a00d                	j	80001b04 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ae4:	ed86a583          	lw	a1,-296(a3)
    80001ae8:	8556                	mv	a0,s5
    80001aea:	00004097          	auipc	ra,0x4
    80001aee:	2cc080e7          	jalr	716(ra) # 80005db6 <printf>
    printf("\n");
    80001af2:	8552                	mv	a0,s4
    80001af4:	00004097          	auipc	ra,0x4
    80001af8:	2c2080e7          	jalr	706(ra) # 80005db6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001afc:	16848493          	addi	s1,s1,360
    80001b00:	03248263          	beq	s1,s2,80001b24 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b04:	86a6                	mv	a3,s1
    80001b06:	ec04a783          	lw	a5,-320(s1)
    80001b0a:	dbed                	beqz	a5,80001afc <procdump+0x72>
      state = "???";
    80001b0c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b0e:	fcfb6be3          	bltu	s6,a5,80001ae4 <procdump+0x5a>
    80001b12:	02079713          	slli	a4,a5,0x20
    80001b16:	01d75793          	srli	a5,a4,0x1d
    80001b1a:	97de                	add	a5,a5,s7
    80001b1c:	6390                	ld	a2,0(a5)
    80001b1e:	f279                	bnez	a2,80001ae4 <procdump+0x5a>
      state = "???";
    80001b20:	864e                	mv	a2,s3
    80001b22:	b7c9                	j	80001ae4 <procdump+0x5a>
  }
}
    80001b24:	60a6                	ld	ra,72(sp)
    80001b26:	6406                	ld	s0,64(sp)
    80001b28:	74e2                	ld	s1,56(sp)
    80001b2a:	7942                	ld	s2,48(sp)
    80001b2c:	79a2                	ld	s3,40(sp)
    80001b2e:	7a02                	ld	s4,32(sp)
    80001b30:	6ae2                	ld	s5,24(sp)
    80001b32:	6b42                	ld	s6,16(sp)
    80001b34:	6ba2                	ld	s7,8(sp)
    80001b36:	6161                	addi	sp,sp,80
    80001b38:	8082                	ret

0000000080001b3a <swtch>:
    80001b3a:	00153023          	sd	ra,0(a0)
    80001b3e:	00253423          	sd	sp,8(a0)
    80001b42:	e900                	sd	s0,16(a0)
    80001b44:	ed04                	sd	s1,24(a0)
    80001b46:	03253023          	sd	s2,32(a0)
    80001b4a:	03353423          	sd	s3,40(a0)
    80001b4e:	03453823          	sd	s4,48(a0)
    80001b52:	03553c23          	sd	s5,56(a0)
    80001b56:	05653023          	sd	s6,64(a0)
    80001b5a:	05753423          	sd	s7,72(a0)
    80001b5e:	05853823          	sd	s8,80(a0)
    80001b62:	05953c23          	sd	s9,88(a0)
    80001b66:	07a53023          	sd	s10,96(a0)
    80001b6a:	07b53423          	sd	s11,104(a0)
    80001b6e:	0005b083          	ld	ra,0(a1)
    80001b72:	0085b103          	ld	sp,8(a1)
    80001b76:	6980                	ld	s0,16(a1)
    80001b78:	6d84                	ld	s1,24(a1)
    80001b7a:	0205b903          	ld	s2,32(a1)
    80001b7e:	0285b983          	ld	s3,40(a1)
    80001b82:	0305ba03          	ld	s4,48(a1)
    80001b86:	0385ba83          	ld	s5,56(a1)
    80001b8a:	0405bb03          	ld	s6,64(a1)
    80001b8e:	0485bb83          	ld	s7,72(a1)
    80001b92:	0505bc03          	ld	s8,80(a1)
    80001b96:	0585bc83          	ld	s9,88(a1)
    80001b9a:	0605bd03          	ld	s10,96(a1)
    80001b9e:	0685bd83          	ld	s11,104(a1)
    80001ba2:	8082                	ret

0000000080001ba4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ba4:	1141                	addi	sp,sp,-16
    80001ba6:	e406                	sd	ra,8(sp)
    80001ba8:	e022                	sd	s0,0(sp)
    80001baa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bac:	00006597          	auipc	a1,0x6
    80001bb0:	6bc58593          	addi	a1,a1,1724 # 80008268 <states.0+0x30>
    80001bb4:	0002d517          	auipc	a0,0x2d
    80001bb8:	b7c50513          	addi	a0,a0,-1156 # 8002e730 <tickslock>
    80001bbc:	00004097          	auipc	ra,0x4
    80001bc0:	6a8080e7          	jalr	1704(ra) # 80006264 <initlock>
}
    80001bc4:	60a2                	ld	ra,8(sp)
    80001bc6:	6402                	ld	s0,0(sp)
    80001bc8:	0141                	addi	sp,sp,16
    80001bca:	8082                	ret

0000000080001bcc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bcc:	1141                	addi	sp,sp,-16
    80001bce:	e422                	sd	s0,8(sp)
    80001bd0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd2:	00003797          	auipc	a5,0x3
    80001bd6:	5ce78793          	addi	a5,a5,1486 # 800051a0 <kernelvec>
    80001bda:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bde:	6422                	ld	s0,8(sp)
    80001be0:	0141                	addi	sp,sp,16
    80001be2:	8082                	ret

0000000080001be4 <cowcopy>:

int cowcopy(uint64 va) {
    80001be4:	7139                	addi	sp,sp,-64
    80001be6:	fc06                	sd	ra,56(sp)
    80001be8:	f822                	sd	s0,48(sp)
    80001bea:	f426                	sd	s1,40(sp)
    80001bec:	f04a                	sd	s2,32(sp)
    80001bee:	ec4e                	sd	s3,24(sp)
    80001bf0:	e852                	sd	s4,16(sp)
    80001bf2:	e456                	sd	s5,8(sp)
    80001bf4:	e05a                	sd	s6,0(sp)
    80001bf6:	0080                	addi	s0,sp,64
    80001bf8:	8aaa                	mv	s5,a0
	struct proc *p = myproc();
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	334080e7          	jalr	820(ra) # 80000f2e <myproc>
    80001c02:	8a2a                	mv	s4,a0
	pte_t *pte = walk(p->pagetable, va, 0);
    80001c04:	4601                	li	a2,0
    80001c06:	85d6                	mv	a1,s5
    80001c08:	6928                	ld	a0,80(a0)
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	94a080e7          	jalr	-1718(ra) # 80000554 <walk>
	uint64 pa = PTE2PA(*pte);
    80001c12:	611c                	ld	a5,0(a0)
    80001c14:	00a7d913          	srli	s2,a5,0xa
    80001c18:	0932                	slli	s2,s2,0xc
	if(pa == 0) {
    80001c1a:	08090963          	beqz	s2,80001cac <cowcopy+0xc8>
    80001c1e:	84aa                	mv	s1,a0
		return -1;
	}
	if((*pte & PTE_COW) == 0) {
    80001c20:	1007f793          	andi	a5,a5,256
    80001c24:	c7d1                	beqz	a5,80001cb0 <cowcopy+0xcc>
		return -1;
	}

	char *mem = kalloc();
    80001c26:	ffffe097          	auipc	ra,0xffffe
    80001c2a:	5d2080e7          	jalr	1490(ra) # 800001f8 <kalloc>
    80001c2e:	89aa                	mv	s3,a0
	if (mem == 0) {
    80001c30:	c151                	beqz	a0,80001cb4 <cowcopy+0xd0>
		return -1;
	}

	*pte = ((*pte) & (~PTE_COW)) | PTE_W;
    80001c32:	609c                	ld	a5,0(s1)
    80001c34:	efb7f793          	andi	a5,a5,-261
    80001c38:	0047e793          	ori	a5,a5,4
    80001c3c:	e09c                	sd	a5,0(s1)
	if (get_ref_count((void *)pa) > 1) {
    80001c3e:	854a                	mv	a0,s2
    80001c40:	ffffe097          	auipc	ra,0xffffe
    80001c44:	44e080e7          	jalr	1102(ra) # 8000008e <get_ref_count>
    80001c48:	4785                	li	a5,1
			kfree(mem);
			return -1;
		}
		incr_ref_count((void *)pa, -1);
	}
	return 0;
    80001c4a:	4b01                	li	s6,0
	if (get_ref_count((void *)pa) > 1) {
    80001c4c:	00a7cd63          	blt	a5,a0,80001c66 <cowcopy+0x82>
}
    80001c50:	855a                	mv	a0,s6
    80001c52:	70e2                	ld	ra,56(sp)
    80001c54:	7442                	ld	s0,48(sp)
    80001c56:	74a2                	ld	s1,40(sp)
    80001c58:	7902                	ld	s2,32(sp)
    80001c5a:	69e2                	ld	s3,24(sp)
    80001c5c:	6a42                	ld	s4,16(sp)
    80001c5e:	6aa2                	ld	s5,8(sp)
    80001c60:	6b02                	ld	s6,0(sp)
    80001c62:	6121                	addi	sp,sp,64
    80001c64:	8082                	ret
		memmove(mem, (char*) pa, PGSIZE);
    80001c66:	6605                	lui	a2,0x1
    80001c68:	85ca                	mv	a1,s2
    80001c6a:	854e                	mv	a0,s3
    80001c6c:	ffffe097          	auipc	ra,0xffffe
    80001c70:	660080e7          	jalr	1632(ra) # 800002cc <memmove>
		uint flags = PTE_FLAGS(*pte);
    80001c74:	6098                	ld	a4,0(s1)
		if(mappages(p->pagetable, va, PGSIZE, (uint64) mem, flags) != 0) {
    80001c76:	3ff77713          	andi	a4,a4,1023
    80001c7a:	86ce                	mv	a3,s3
    80001c7c:	6605                	lui	a2,0x1
    80001c7e:	85d6                	mv	a1,s5
    80001c80:	050a3503          	ld	a0,80(s4)
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	9b8080e7          	jalr	-1608(ra) # 8000063c <mappages>
    80001c8c:	8b2a                	mv	s6,a0
    80001c8e:	e901                	bnez	a0,80001c9e <cowcopy+0xba>
		incr_ref_count((void *)pa, -1);
    80001c90:	55fd                	li	a1,-1
    80001c92:	854a                	mv	a0,s2
    80001c94:	ffffe097          	auipc	ra,0xffffe
    80001c98:	39e080e7          	jalr	926(ra) # 80000032 <incr_ref_count>
    80001c9c:	bf55                	j	80001c50 <cowcopy+0x6c>
			kfree(mem);
    80001c9e:	854e                	mv	a0,s3
    80001ca0:	ffffe097          	auipc	ra,0xffffe
    80001ca4:	438080e7          	jalr	1080(ra) # 800000d8 <kfree>
			return -1;
    80001ca8:	5b7d                	li	s6,-1
    80001caa:	b75d                	j	80001c50 <cowcopy+0x6c>
		return -1;
    80001cac:	5b7d                	li	s6,-1
    80001cae:	b74d                	j	80001c50 <cowcopy+0x6c>
		return -1;
    80001cb0:	5b7d                	li	s6,-1
    80001cb2:	bf79                	j	80001c50 <cowcopy+0x6c>
		return -1;
    80001cb4:	5b7d                	li	s6,-1
    80001cb6:	bf69                	j	80001c50 <cowcopy+0x6c>

0000000080001cb8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cb8:	1141                	addi	sp,sp,-16
    80001cba:	e406                	sd	ra,8(sp)
    80001cbc:	e022                	sd	s0,0(sp)
    80001cbe:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	26e080e7          	jalr	622(ra) # 80000f2e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ccc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cce:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cd2:	00005697          	auipc	a3,0x5
    80001cd6:	32e68693          	addi	a3,a3,814 # 80007000 <_trampoline>
    80001cda:	00005717          	auipc	a4,0x5
    80001cde:	32670713          	addi	a4,a4,806 # 80007000 <_trampoline>
    80001ce2:	8f15                	sub	a4,a4,a3
    80001ce4:	040007b7          	lui	a5,0x4000
    80001ce8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cea:	07b2                	slli	a5,a5,0xc
    80001cec:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cee:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cf4:	18002673          	csrr	a2,satp
    80001cf8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cfa:	6d30                	ld	a2,88(a0)
    80001cfc:	6138                	ld	a4,64(a0)
    80001cfe:	6585                	lui	a1,0x1
    80001d00:	972e                	add	a4,a4,a1
    80001d02:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d04:	6d38                	ld	a4,88(a0)
    80001d06:	00000617          	auipc	a2,0x0
    80001d0a:	13060613          	addi	a2,a2,304 # 80001e36 <usertrap>
    80001d0e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d10:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d12:	8612                	mv	a2,tp
    80001d14:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d16:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d1a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d1e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d22:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d26:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d28:	6f18                	ld	a4,24(a4)
    80001d2a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d2e:	6928                	ld	a0,80(a0)
    80001d30:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d32:	00005717          	auipc	a4,0x5
    80001d36:	36a70713          	addi	a4,a4,874 # 8000709c <userret>
    80001d3a:	8f15                	sub	a4,a4,a3
    80001d3c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d3e:	577d                	li	a4,-1
    80001d40:	177e                	slli	a4,a4,0x3f
    80001d42:	8d59                	or	a0,a0,a4
    80001d44:	9782                	jalr	a5
}
    80001d46:	60a2                	ld	ra,8(sp)
    80001d48:	6402                	ld	s0,0(sp)
    80001d4a:	0141                	addi	sp,sp,16
    80001d4c:	8082                	ret

0000000080001d4e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d58:	0002d497          	auipc	s1,0x2d
    80001d5c:	9d848493          	addi	s1,s1,-1576 # 8002e730 <tickslock>
    80001d60:	8526                	mv	a0,s1
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	592080e7          	jalr	1426(ra) # 800062f4 <acquire>
  ticks++;
    80001d6a:	00007517          	auipc	a0,0x7
    80001d6e:	b5e50513          	addi	a0,a0,-1186 # 800088c8 <ticks>
    80001d72:	411c                	lw	a5,0(a0)
    80001d74:	2785                	addiw	a5,a5,1
    80001d76:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	8c2080e7          	jalr	-1854(ra) # 8000163a <wakeup>
  release(&tickslock);
    80001d80:	8526                	mv	a0,s1
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	626080e7          	jalr	1574(ra) # 800063a8 <release>
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6105                	addi	sp,sp,32
    80001d92:	8082                	ret

0000000080001d94 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d94:	1101                	addi	sp,sp,-32
    80001d96:	ec06                	sd	ra,24(sp)
    80001d98:	e822                	sd	s0,16(sp)
    80001d9a:	e426                	sd	s1,8(sp)
    80001d9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001da2:	00074d63          	bltz	a4,80001dbc <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001da6:	57fd                	li	a5,-1
    80001da8:	17fe                	slli	a5,a5,0x3f
    80001daa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dae:	06f70363          	beq	a4,a5,80001e14 <devintr+0x80>
  }
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret
     (scause & 0xff) == 9){
    80001dbc:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001dc0:	46a5                	li	a3,9
    80001dc2:	fed792e3          	bne	a5,a3,80001da6 <devintr+0x12>
    int irq = plic_claim();
    80001dc6:	00003097          	auipc	ra,0x3
    80001dca:	4e2080e7          	jalr	1250(ra) # 800052a8 <plic_claim>
    80001dce:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dd0:	47a9                	li	a5,10
    80001dd2:	02f50763          	beq	a0,a5,80001e00 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dd6:	4785                	li	a5,1
    80001dd8:	02f50963          	beq	a0,a5,80001e0a <devintr+0x76>
    return 1;
    80001ddc:	4505                	li	a0,1
    } else if(irq){
    80001dde:	d8f1                	beqz	s1,80001db2 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001de0:	85a6                	mv	a1,s1
    80001de2:	00006517          	auipc	a0,0x6
    80001de6:	48e50513          	addi	a0,a0,1166 # 80008270 <states.0+0x38>
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	fcc080e7          	jalr	-52(ra) # 80005db6 <printf>
      plic_complete(irq);
    80001df2:	8526                	mv	a0,s1
    80001df4:	00003097          	auipc	ra,0x3
    80001df8:	4d8080e7          	jalr	1240(ra) # 800052cc <plic_complete>
    return 1;
    80001dfc:	4505                	li	a0,1
    80001dfe:	bf55                	j	80001db2 <devintr+0x1e>
      uartintr();
    80001e00:	00004097          	auipc	ra,0x4
    80001e04:	414080e7          	jalr	1044(ra) # 80006214 <uartintr>
    80001e08:	b7ed                	j	80001df2 <devintr+0x5e>
      virtio_disk_intr();
    80001e0a:	00004097          	auipc	ra,0x4
    80001e0e:	98a080e7          	jalr	-1654(ra) # 80005794 <virtio_disk_intr>
    80001e12:	b7c5                	j	80001df2 <devintr+0x5e>
    if(cpuid() == 0){
    80001e14:	fffff097          	auipc	ra,0xfffff
    80001e18:	0ee080e7          	jalr	238(ra) # 80000f02 <cpuid>
    80001e1c:	c901                	beqz	a0,80001e2c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e1e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e22:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e24:	14479073          	csrw	sip,a5
    return 2;
    80001e28:	4509                	li	a0,2
    80001e2a:	b761                	j	80001db2 <devintr+0x1e>
      clockintr();
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	f22080e7          	jalr	-222(ra) # 80001d4e <clockintr>
    80001e34:	b7ed                	j	80001e1e <devintr+0x8a>

0000000080001e36 <usertrap>:
{
    80001e36:	1101                	addi	sp,sp,-32
    80001e38:	ec06                	sd	ra,24(sp)
    80001e3a:	e822                	sd	s0,16(sp)
    80001e3c:	e426                	sd	s1,8(sp)
    80001e3e:	e04a                	sd	s2,0(sp)
    80001e40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e42:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e46:	1007f793          	andi	a5,a5,256
    80001e4a:	e7b9                	bnez	a5,80001e98 <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e4c:	00003797          	auipc	a5,0x3
    80001e50:	35478793          	addi	a5,a5,852 # 800051a0 <kernelvec>
    80001e54:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	0d6080e7          	jalr	214(ra) # 80000f2e <myproc>
    80001e60:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e62:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e64:	14102773          	csrr	a4,sepc
    80001e68:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e6e:	47a1                	li	a5,8
    80001e70:	02f70c63          	beq	a4,a5,80001ea8 <usertrap+0x72>
    80001e74:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15) {
    80001e78:	47bd                	li	a5,15
    80001e7a:	08f70063          	beq	a4,a5,80001efa <usertrap+0xc4>
  } else if((which_dev = devintr()) != 0){
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	f16080e7          	jalr	-234(ra) # 80001d94 <devintr>
    80001e86:	892a                	mv	s2,a0
    80001e88:	c541                	beqz	a0,80001f10 <usertrap+0xda>
  if(killed(p))
    80001e8a:	8526                	mv	a0,s1
    80001e8c:	00000097          	auipc	ra,0x0
    80001e90:	9f2080e7          	jalr	-1550(ra) # 8000187e <killed>
    80001e94:	c169                	beqz	a0,80001f56 <usertrap+0x120>
    80001e96:	a85d                	j	80001f4c <usertrap+0x116>
    panic("usertrap: not from user mode");
    80001e98:	00006517          	auipc	a0,0x6
    80001e9c:	3f850513          	addi	a0,a0,1016 # 80008290 <states.0+0x58>
    80001ea0:	00004097          	auipc	ra,0x4
    80001ea4:	ecc080e7          	jalr	-308(ra) # 80005d6c <panic>
    if(killed(p))
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	9d6080e7          	jalr	-1578(ra) # 8000187e <killed>
    80001eb0:	ed1d                	bnez	a0,80001eee <usertrap+0xb8>
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
    80001eca:	2ea080e7          	jalr	746(ra) # 800021b0 <syscall>
  if(killed(p))
    80001ece:	8526                	mv	a0,s1
    80001ed0:	00000097          	auipc	ra,0x0
    80001ed4:	9ae080e7          	jalr	-1618(ra) # 8000187e <killed>
    80001ed8:	e92d                	bnez	a0,80001f4a <usertrap+0x114>
  usertrapret();
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	dde080e7          	jalr	-546(ra) # 80001cb8 <usertrapret>
}
    80001ee2:	60e2                	ld	ra,24(sp)
    80001ee4:	6442                	ld	s0,16(sp)
    80001ee6:	64a2                	ld	s1,8(sp)
    80001ee8:	6902                	ld	s2,0(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret
      exit(-1);
    80001eee:	557d                	li	a0,-1
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	81a080e7          	jalr	-2022(ra) # 8000170a <exit>
    80001ef8:	bf6d                	j	80001eb2 <usertrap+0x7c>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efa:	14302573          	csrr	a0,stval
	if(cowcopy(va) < 0) {
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	ce6080e7          	jalr	-794(ra) # 80001be4 <cowcopy>
    80001f06:	fc0554e3          	bgez	a0,80001ece <usertrap+0x98>
		p->killed = 1;
    80001f0a:	4785                	li	a5,1
    80001f0c:	d49c                	sw	a5,40(s1)
    80001f0e:	b7c1                	j	80001ece <usertrap+0x98>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f10:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f14:	5890                	lw	a2,48(s1)
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	39a50513          	addi	a0,a0,922 # 800082b0 <states.0+0x78>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	e98080e7          	jalr	-360(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f26:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f2a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	3b250513          	addi	a0,a0,946 # 800082e0 <states.0+0xa8>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	e80080e7          	jalr	-384(ra) # 80005db6 <printf>
    setkilled(p);
    80001f3e:	8526                	mv	a0,s1
    80001f40:	00000097          	auipc	ra,0x0
    80001f44:	912080e7          	jalr	-1774(ra) # 80001852 <setkilled>
    80001f48:	b759                	j	80001ece <usertrap+0x98>
  if(killed(p))
    80001f4a:	4901                	li	s2,0
    exit(-1);
    80001f4c:	557d                	li	a0,-1
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	7bc080e7          	jalr	1980(ra) # 8000170a <exit>
  if(which_dev == 2)
    80001f56:	4789                	li	a5,2
    80001f58:	f8f911e3          	bne	s2,a5,80001eda <usertrap+0xa4>
    yield();
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	63e080e7          	jalr	1598(ra) # 8000159a <yield>
    80001f64:	bf9d                	j	80001eda <usertrap+0xa4>

0000000080001f66 <kerneltrap>:
{
    80001f66:	7179                	addi	sp,sp,-48
    80001f68:	f406                	sd	ra,40(sp)
    80001f6a:	f022                	sd	s0,32(sp)
    80001f6c:	ec26                	sd	s1,24(sp)
    80001f6e:	e84a                	sd	s2,16(sp)
    80001f70:	e44e                	sd	s3,8(sp)
    80001f72:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f74:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f78:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f7c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f80:	1004f793          	andi	a5,s1,256
    80001f84:	cb85                	beqz	a5,80001fb4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f8a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f8c:	ef85                	bnez	a5,80001fc4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	e06080e7          	jalr	-506(ra) # 80001d94 <devintr>
    80001f96:	cd1d                	beqz	a0,80001fd4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f98:	4789                	li	a5,2
    80001f9a:	06f50a63          	beq	a0,a5,8000200e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f9e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa2:	10049073          	csrw	sstatus,s1
}
    80001fa6:	70a2                	ld	ra,40(sp)
    80001fa8:	7402                	ld	s0,32(sp)
    80001faa:	64e2                	ld	s1,24(sp)
    80001fac:	6942                	ld	s2,16(sp)
    80001fae:	69a2                	ld	s3,8(sp)
    80001fb0:	6145                	addi	sp,sp,48
    80001fb2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	34c50513          	addi	a0,a0,844 # 80008300 <states.0+0xc8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	db0080e7          	jalr	-592(ra) # 80005d6c <panic>
    panic("kerneltrap: interrupts enabled");
    80001fc4:	00006517          	auipc	a0,0x6
    80001fc8:	36450513          	addi	a0,a0,868 # 80008328 <states.0+0xf0>
    80001fcc:	00004097          	auipc	ra,0x4
    80001fd0:	da0080e7          	jalr	-608(ra) # 80005d6c <panic>
    printf("scause %p\n", scause);
    80001fd4:	85ce                	mv	a1,s3
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	37250513          	addi	a0,a0,882 # 80008348 <states.0+0x110>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	dd8080e7          	jalr	-552(ra) # 80005db6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fe6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fea:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fee:	00006517          	auipc	a0,0x6
    80001ff2:	36a50513          	addi	a0,a0,874 # 80008358 <states.0+0x120>
    80001ff6:	00004097          	auipc	ra,0x4
    80001ffa:	dc0080e7          	jalr	-576(ra) # 80005db6 <printf>
    panic("kerneltrap");
    80001ffe:	00006517          	auipc	a0,0x6
    80002002:	37250513          	addi	a0,a0,882 # 80008370 <states.0+0x138>
    80002006:	00004097          	auipc	ra,0x4
    8000200a:	d66080e7          	jalr	-666(ra) # 80005d6c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	f20080e7          	jalr	-224(ra) # 80000f2e <myproc>
    80002016:	d541                	beqz	a0,80001f9e <kerneltrap+0x38>
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	f16080e7          	jalr	-234(ra) # 80000f2e <myproc>
    80002020:	4d18                	lw	a4,24(a0)
    80002022:	4791                	li	a5,4
    80002024:	f6f71de3          	bne	a4,a5,80001f9e <kerneltrap+0x38>
    yield();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	572080e7          	jalr	1394(ra) # 8000159a <yield>
    80002030:	b7bd                	j	80001f9e <kerneltrap+0x38>

0000000080002032 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002032:	1101                	addi	sp,sp,-32
    80002034:	ec06                	sd	ra,24(sp)
    80002036:	e822                	sd	s0,16(sp)
    80002038:	e426                	sd	s1,8(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000203e:	fffff097          	auipc	ra,0xfffff
    80002042:	ef0080e7          	jalr	-272(ra) # 80000f2e <myproc>
  switch (n) {
    80002046:	4795                	li	a5,5
    80002048:	0497e163          	bltu	a5,s1,8000208a <argraw+0x58>
    8000204c:	048a                	slli	s1,s1,0x2
    8000204e:	00006717          	auipc	a4,0x6
    80002052:	35a70713          	addi	a4,a4,858 # 800083a8 <states.0+0x170>
    80002056:	94ba                	add	s1,s1,a4
    80002058:	409c                	lw	a5,0(s1)
    8000205a:	97ba                	add	a5,a5,a4
    8000205c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000205e:	6d3c                	ld	a5,88(a0)
    80002060:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002062:	60e2                	ld	ra,24(sp)
    80002064:	6442                	ld	s0,16(sp)
    80002066:	64a2                	ld	s1,8(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret
    return p->trapframe->a1;
    8000206c:	6d3c                	ld	a5,88(a0)
    8000206e:	7fa8                	ld	a0,120(a5)
    80002070:	bfcd                	j	80002062 <argraw+0x30>
    return p->trapframe->a2;
    80002072:	6d3c                	ld	a5,88(a0)
    80002074:	63c8                	ld	a0,128(a5)
    80002076:	b7f5                	j	80002062 <argraw+0x30>
    return p->trapframe->a3;
    80002078:	6d3c                	ld	a5,88(a0)
    8000207a:	67c8                	ld	a0,136(a5)
    8000207c:	b7dd                	j	80002062 <argraw+0x30>
    return p->trapframe->a4;
    8000207e:	6d3c                	ld	a5,88(a0)
    80002080:	6bc8                	ld	a0,144(a5)
    80002082:	b7c5                	j	80002062 <argraw+0x30>
    return p->trapframe->a5;
    80002084:	6d3c                	ld	a5,88(a0)
    80002086:	6fc8                	ld	a0,152(a5)
    80002088:	bfe9                	j	80002062 <argraw+0x30>
  panic("argraw");
    8000208a:	00006517          	auipc	a0,0x6
    8000208e:	2f650513          	addi	a0,a0,758 # 80008380 <states.0+0x148>
    80002092:	00004097          	auipc	ra,0x4
    80002096:	cda080e7          	jalr	-806(ra) # 80005d6c <panic>

000000008000209a <fetchaddr>:
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	e426                	sd	s1,8(sp)
    800020a2:	e04a                	sd	s2,0(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84aa                	mv	s1,a0
    800020a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020aa:	fffff097          	auipc	ra,0xfffff
    800020ae:	e84080e7          	jalr	-380(ra) # 80000f2e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800020b2:	653c                	ld	a5,72(a0)
    800020b4:	02f4f863          	bgeu	s1,a5,800020e4 <fetchaddr+0x4a>
    800020b8:	00848713          	addi	a4,s1,8
    800020bc:	02e7e663          	bltu	a5,a4,800020e8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020c0:	46a1                	li	a3,8
    800020c2:	8626                	mv	a2,s1
    800020c4:	85ca                	mv	a1,s2
    800020c6:	6928                	ld	a0,80(a0)
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	bb2080e7          	jalr	-1102(ra) # 80000c7a <copyin>
    800020d0:	00a03533          	snez	a0,a0
    800020d4:	40a00533          	neg	a0,a0
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6902                	ld	s2,0(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret
    return -1;
    800020e4:	557d                	li	a0,-1
    800020e6:	bfcd                	j	800020d8 <fetchaddr+0x3e>
    800020e8:	557d                	li	a0,-1
    800020ea:	b7fd                	j	800020d8 <fetchaddr+0x3e>

00000000800020ec <fetchstr>:
{
    800020ec:	7179                	addi	sp,sp,-48
    800020ee:	f406                	sd	ra,40(sp)
    800020f0:	f022                	sd	s0,32(sp)
    800020f2:	ec26                	sd	s1,24(sp)
    800020f4:	e84a                	sd	s2,16(sp)
    800020f6:	e44e                	sd	s3,8(sp)
    800020f8:	1800                	addi	s0,sp,48
    800020fa:	892a                	mv	s2,a0
    800020fc:	84ae                	mv	s1,a1
    800020fe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	e2e080e7          	jalr	-466(ra) # 80000f2e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002108:	86ce                	mv	a3,s3
    8000210a:	864a                	mv	a2,s2
    8000210c:	85a6                	mv	a1,s1
    8000210e:	6928                	ld	a0,80(a0)
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	bf8080e7          	jalr	-1032(ra) # 80000d08 <copyinstr>
    80002118:	00054e63          	bltz	a0,80002134 <fetchstr+0x48>
  return strlen(buf);
    8000211c:	8526                	mv	a0,s1
    8000211e:	ffffe097          	auipc	ra,0xffffe
    80002122:	2ce080e7          	jalr	718(ra) # 800003ec <strlen>
}
    80002126:	70a2                	ld	ra,40(sp)
    80002128:	7402                	ld	s0,32(sp)
    8000212a:	64e2                	ld	s1,24(sp)
    8000212c:	6942                	ld	s2,16(sp)
    8000212e:	69a2                	ld	s3,8(sp)
    80002130:	6145                	addi	sp,sp,48
    80002132:	8082                	ret
    return -1;
    80002134:	557d                	li	a0,-1
    80002136:	bfc5                	j	80002126 <fetchstr+0x3a>

0000000080002138 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	1000                	addi	s0,sp,32
    80002142:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002144:	00000097          	auipc	ra,0x0
    80002148:	eee080e7          	jalr	-274(ra) # 80002032 <argraw>
    8000214c:	c088                	sw	a0,0(s1)
}
    8000214e:	60e2                	ld	ra,24(sp)
    80002150:	6442                	ld	s0,16(sp)
    80002152:	64a2                	ld	s1,8(sp)
    80002154:	6105                	addi	sp,sp,32
    80002156:	8082                	ret

0000000080002158 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	e426                	sd	s1,8(sp)
    80002160:	1000                	addi	s0,sp,32
    80002162:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002164:	00000097          	auipc	ra,0x0
    80002168:	ece080e7          	jalr	-306(ra) # 80002032 <argraw>
    8000216c:	e088                	sd	a0,0(s1)
}
    8000216e:	60e2                	ld	ra,24(sp)
    80002170:	6442                	ld	s0,16(sp)
    80002172:	64a2                	ld	s1,8(sp)
    80002174:	6105                	addi	sp,sp,32
    80002176:	8082                	ret

0000000080002178 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002178:	7179                	addi	sp,sp,-48
    8000217a:	f406                	sd	ra,40(sp)
    8000217c:	f022                	sd	s0,32(sp)
    8000217e:	ec26                	sd	s1,24(sp)
    80002180:	e84a                	sd	s2,16(sp)
    80002182:	1800                	addi	s0,sp,48
    80002184:	84ae                	mv	s1,a1
    80002186:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002188:	fd840593          	addi	a1,s0,-40
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	fcc080e7          	jalr	-52(ra) # 80002158 <argaddr>
  return fetchstr(addr, buf, max);
    80002194:	864a                	mv	a2,s2
    80002196:	85a6                	mv	a1,s1
    80002198:	fd843503          	ld	a0,-40(s0)
    8000219c:	00000097          	auipc	ra,0x0
    800021a0:	f50080e7          	jalr	-176(ra) # 800020ec <fetchstr>
}
    800021a4:	70a2                	ld	ra,40(sp)
    800021a6:	7402                	ld	s0,32(sp)
    800021a8:	64e2                	ld	s1,24(sp)
    800021aa:	6942                	ld	s2,16(sp)
    800021ac:	6145                	addi	sp,sp,48
    800021ae:	8082                	ret

00000000800021b0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021b0:	1101                	addi	sp,sp,-32
    800021b2:	ec06                	sd	ra,24(sp)
    800021b4:	e822                	sd	s0,16(sp)
    800021b6:	e426                	sd	s1,8(sp)
    800021b8:	e04a                	sd	s2,0(sp)
    800021ba:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	d72080e7          	jalr	-654(ra) # 80000f2e <myproc>
    800021c4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021c6:	05853903          	ld	s2,88(a0)
    800021ca:	0a893783          	ld	a5,168(s2)
    800021ce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021d2:	37fd                	addiw	a5,a5,-1
    800021d4:	4751                	li	a4,20
    800021d6:	00f76f63          	bltu	a4,a5,800021f4 <syscall+0x44>
    800021da:	00369713          	slli	a4,a3,0x3
    800021de:	00006797          	auipc	a5,0x6
    800021e2:	1e278793          	addi	a5,a5,482 # 800083c0 <syscalls>
    800021e6:	97ba                	add	a5,a5,a4
    800021e8:	639c                	ld	a5,0(a5)
    800021ea:	c789                	beqz	a5,800021f4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021ec:	9782                	jalr	a5
    800021ee:	06a93823          	sd	a0,112(s2)
    800021f2:	a839                	j	80002210 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021f4:	15848613          	addi	a2,s1,344
    800021f8:	588c                	lw	a1,48(s1)
    800021fa:	00006517          	auipc	a0,0x6
    800021fe:	18e50513          	addi	a0,a0,398 # 80008388 <states.0+0x150>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	bb4080e7          	jalr	-1100(ra) # 80005db6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000220a:	6cbc                	ld	a5,88(s1)
    8000220c:	577d                	li	a4,-1
    8000220e:	fbb8                	sd	a4,112(a5)
  }
}
    80002210:	60e2                	ld	ra,24(sp)
    80002212:	6442                	ld	s0,16(sp)
    80002214:	64a2                	ld	s1,8(sp)
    80002216:	6902                	ld	s2,0(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002224:	fec40593          	addi	a1,s0,-20
    80002228:	4501                	li	a0,0
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	f0e080e7          	jalr	-242(ra) # 80002138 <argint>
  exit(n);
    80002232:	fec42503          	lw	a0,-20(s0)
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	4d4080e7          	jalr	1236(ra) # 8000170a <exit>
  return 0;  // not reached
}
    8000223e:	4501                	li	a0,0
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002248:	1141                	addi	sp,sp,-16
    8000224a:	e406                	sd	ra,8(sp)
    8000224c:	e022                	sd	s0,0(sp)
    8000224e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002250:	fffff097          	auipc	ra,0xfffff
    80002254:	cde080e7          	jalr	-802(ra) # 80000f2e <myproc>
}
    80002258:	5908                	lw	a0,48(a0)
    8000225a:	60a2                	ld	ra,8(sp)
    8000225c:	6402                	ld	s0,0(sp)
    8000225e:	0141                	addi	sp,sp,16
    80002260:	8082                	ret

0000000080002262 <sys_fork>:

uint64
sys_fork(void)
{
    80002262:	1141                	addi	sp,sp,-16
    80002264:	e406                	sd	ra,8(sp)
    80002266:	e022                	sd	s0,0(sp)
    80002268:	0800                	addi	s0,sp,16
  return fork();
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	07a080e7          	jalr	122(ra) # 800012e4 <fork>
}
    80002272:	60a2                	ld	ra,8(sp)
    80002274:	6402                	ld	s0,0(sp)
    80002276:	0141                	addi	sp,sp,16
    80002278:	8082                	ret

000000008000227a <sys_wait>:

uint64
sys_wait(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002282:	fe840593          	addi	a1,s0,-24
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	ed0080e7          	jalr	-304(ra) # 80002158 <argaddr>
  return wait(p);
    80002290:	fe843503          	ld	a0,-24(s0)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	61c080e7          	jalr	1564(ra) # 800018b0 <wait>
}
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	6105                	addi	sp,sp,32
    800022a2:	8082                	ret

00000000800022a4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022a4:	7179                	addi	sp,sp,-48
    800022a6:	f406                	sd	ra,40(sp)
    800022a8:	f022                	sd	s0,32(sp)
    800022aa:	ec26                	sd	s1,24(sp)
    800022ac:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800022ae:	fdc40593          	addi	a1,s0,-36
    800022b2:	4501                	li	a0,0
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	e84080e7          	jalr	-380(ra) # 80002138 <argint>
  addr = myproc()->sz;
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	c72080e7          	jalr	-910(ra) # 80000f2e <myproc>
    800022c4:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800022c6:	fdc42503          	lw	a0,-36(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	fbe080e7          	jalr	-66(ra) # 80001288 <growproc>
    800022d2:	00054863          	bltz	a0,800022e2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800022d6:	8526                	mv	a0,s1
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
    return -1;
    800022e2:	54fd                	li	s1,-1
    800022e4:	bfcd                	j	800022d6 <sys_sbrk+0x32>

00000000800022e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022e6:	7139                	addi	sp,sp,-64
    800022e8:	fc06                	sd	ra,56(sp)
    800022ea:	f822                	sd	s0,48(sp)
    800022ec:	f426                	sd	s1,40(sp)
    800022ee:	f04a                	sd	s2,32(sp)
    800022f0:	ec4e                	sd	s3,24(sp)
    800022f2:	0080                	addi	s0,sp,64
	backtrace();
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	cd4080e7          	jalr	-812(ra) # 80005fc8 <backtrace>
  int n;
  uint ticks0;

  argint(0, &n);
    800022fc:	fcc40593          	addi	a1,s0,-52
    80002300:	4501                	li	a0,0
    80002302:	00000097          	auipc	ra,0x0
    80002306:	e36080e7          	jalr	-458(ra) # 80002138 <argint>
  if(n < 0)
    8000230a:	fcc42783          	lw	a5,-52(s0)
    8000230e:	0607cf63          	bltz	a5,8000238c <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    80002312:	0002c517          	auipc	a0,0x2c
    80002316:	41e50513          	addi	a0,a0,1054 # 8002e730 <tickslock>
    8000231a:	00004097          	auipc	ra,0x4
    8000231e:	fda080e7          	jalr	-38(ra) # 800062f4 <acquire>
  ticks0 = ticks;
    80002322:	00006917          	auipc	s2,0x6
    80002326:	5a692903          	lw	s2,1446(s2) # 800088c8 <ticks>
  while(ticks - ticks0 < n){
    8000232a:	fcc42783          	lw	a5,-52(s0)
    8000232e:	cf9d                	beqz	a5,8000236c <sys_sleep+0x86>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002330:	0002c997          	auipc	s3,0x2c
    80002334:	40098993          	addi	s3,s3,1024 # 8002e730 <tickslock>
    80002338:	00006497          	auipc	s1,0x6
    8000233c:	59048493          	addi	s1,s1,1424 # 800088c8 <ticks>
    if(killed(myproc())){
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	bee080e7          	jalr	-1042(ra) # 80000f2e <myproc>
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	536080e7          	jalr	1334(ra) # 8000187e <killed>
    80002350:	e129                	bnez	a0,80002392 <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    80002352:	85ce                	mv	a1,s3
    80002354:	8526                	mv	a0,s1
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	280080e7          	jalr	640(ra) # 800015d6 <sleep>
  while(ticks - ticks0 < n){
    8000235e:	409c                	lw	a5,0(s1)
    80002360:	412787bb          	subw	a5,a5,s2
    80002364:	fcc42703          	lw	a4,-52(s0)
    80002368:	fce7ece3          	bltu	a5,a4,80002340 <sys_sleep+0x5a>
  }
  release(&tickslock);
    8000236c:	0002c517          	auipc	a0,0x2c
    80002370:	3c450513          	addi	a0,a0,964 # 8002e730 <tickslock>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	034080e7          	jalr	52(ra) # 800063a8 <release>
  return 0;
    8000237c:	4501                	li	a0,0
}
    8000237e:	70e2                	ld	ra,56(sp)
    80002380:	7442                	ld	s0,48(sp)
    80002382:	74a2                	ld	s1,40(sp)
    80002384:	7902                	ld	s2,32(sp)
    80002386:	69e2                	ld	s3,24(sp)
    80002388:	6121                	addi	sp,sp,64
    8000238a:	8082                	ret
    n = 0;
    8000238c:	fc042623          	sw	zero,-52(s0)
    80002390:	b749                	j	80002312 <sys_sleep+0x2c>
      release(&tickslock);
    80002392:	0002c517          	auipc	a0,0x2c
    80002396:	39e50513          	addi	a0,a0,926 # 8002e730 <tickslock>
    8000239a:	00004097          	auipc	ra,0x4
    8000239e:	00e080e7          	jalr	14(ra) # 800063a8 <release>
      return -1;
    800023a2:	557d                	li	a0,-1
    800023a4:	bfe9                	j	8000237e <sys_sleep+0x98>

00000000800023a6 <sys_kill>:

uint64
sys_kill(void)
{
    800023a6:	1101                	addi	sp,sp,-32
    800023a8:	ec06                	sd	ra,24(sp)
    800023aa:	e822                	sd	s0,16(sp)
    800023ac:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800023ae:	fec40593          	addi	a1,s0,-20
    800023b2:	4501                	li	a0,0
    800023b4:	00000097          	auipc	ra,0x0
    800023b8:	d84080e7          	jalr	-636(ra) # 80002138 <argint>
  return kill(pid);
    800023bc:	fec42503          	lw	a0,-20(s0)
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	420080e7          	jalr	1056(ra) # 800017e0 <kill>
}
    800023c8:	60e2                	ld	ra,24(sp)
    800023ca:	6442                	ld	s0,16(sp)
    800023cc:	6105                	addi	sp,sp,32
    800023ce:	8082                	ret

00000000800023d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023d0:	1101                	addi	sp,sp,-32
    800023d2:	ec06                	sd	ra,24(sp)
    800023d4:	e822                	sd	s0,16(sp)
    800023d6:	e426                	sd	s1,8(sp)
    800023d8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023da:	0002c517          	auipc	a0,0x2c
    800023de:	35650513          	addi	a0,a0,854 # 8002e730 <tickslock>
    800023e2:	00004097          	auipc	ra,0x4
    800023e6:	f12080e7          	jalr	-238(ra) # 800062f4 <acquire>
  xticks = ticks;
    800023ea:	00006497          	auipc	s1,0x6
    800023ee:	4de4a483          	lw	s1,1246(s1) # 800088c8 <ticks>
  release(&tickslock);
    800023f2:	0002c517          	auipc	a0,0x2c
    800023f6:	33e50513          	addi	a0,a0,830 # 8002e730 <tickslock>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	fae080e7          	jalr	-82(ra) # 800063a8 <release>
  return xticks;
}
    80002402:	02049513          	slli	a0,s1,0x20
    80002406:	9101                	srli	a0,a0,0x20
    80002408:	60e2                	ld	ra,24(sp)
    8000240a:	6442                	ld	s0,16(sp)
    8000240c:	64a2                	ld	s1,8(sp)
    8000240e:	6105                	addi	sp,sp,32
    80002410:	8082                	ret

0000000080002412 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002412:	7179                	addi	sp,sp,-48
    80002414:	f406                	sd	ra,40(sp)
    80002416:	f022                	sd	s0,32(sp)
    80002418:	ec26                	sd	s1,24(sp)
    8000241a:	e84a                	sd	s2,16(sp)
    8000241c:	e44e                	sd	s3,8(sp)
    8000241e:	e052                	sd	s4,0(sp)
    80002420:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002422:	00006597          	auipc	a1,0x6
    80002426:	04e58593          	addi	a1,a1,78 # 80008470 <syscalls+0xb0>
    8000242a:	0002c517          	auipc	a0,0x2c
    8000242e:	31e50513          	addi	a0,a0,798 # 8002e748 <bcache>
    80002432:	00004097          	auipc	ra,0x4
    80002436:	e32080e7          	jalr	-462(ra) # 80006264 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000243a:	00034797          	auipc	a5,0x34
    8000243e:	30e78793          	addi	a5,a5,782 # 80036748 <bcache+0x8000>
    80002442:	00034717          	auipc	a4,0x34
    80002446:	56e70713          	addi	a4,a4,1390 # 800369b0 <bcache+0x8268>
    8000244a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000244e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002452:	0002c497          	auipc	s1,0x2c
    80002456:	30e48493          	addi	s1,s1,782 # 8002e760 <bcache+0x18>
    b->next = bcache.head.next;
    8000245a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000245c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000245e:	00006a17          	auipc	s4,0x6
    80002462:	01aa0a13          	addi	s4,s4,26 # 80008478 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002466:	2b893783          	ld	a5,696(s2)
    8000246a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000246c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002470:	85d2                	mv	a1,s4
    80002472:	01048513          	addi	a0,s1,16
    80002476:	00001097          	auipc	ra,0x1
    8000247a:	4c8080e7          	jalr	1224(ra) # 8000393e <initsleeplock>
    bcache.head.next->prev = b;
    8000247e:	2b893783          	ld	a5,696(s2)
    80002482:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002484:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002488:	45848493          	addi	s1,s1,1112
    8000248c:	fd349de3          	bne	s1,s3,80002466 <binit+0x54>
  }
}
    80002490:	70a2                	ld	ra,40(sp)
    80002492:	7402                	ld	s0,32(sp)
    80002494:	64e2                	ld	s1,24(sp)
    80002496:	6942                	ld	s2,16(sp)
    80002498:	69a2                	ld	s3,8(sp)
    8000249a:	6a02                	ld	s4,0(sp)
    8000249c:	6145                	addi	sp,sp,48
    8000249e:	8082                	ret

00000000800024a0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024a0:	7179                	addi	sp,sp,-48
    800024a2:	f406                	sd	ra,40(sp)
    800024a4:	f022                	sd	s0,32(sp)
    800024a6:	ec26                	sd	s1,24(sp)
    800024a8:	e84a                	sd	s2,16(sp)
    800024aa:	e44e                	sd	s3,8(sp)
    800024ac:	1800                	addi	s0,sp,48
    800024ae:	892a                	mv	s2,a0
    800024b0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800024b2:	0002c517          	auipc	a0,0x2c
    800024b6:	29650513          	addi	a0,a0,662 # 8002e748 <bcache>
    800024ba:	00004097          	auipc	ra,0x4
    800024be:	e3a080e7          	jalr	-454(ra) # 800062f4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024c2:	00034497          	auipc	s1,0x34
    800024c6:	53e4b483          	ld	s1,1342(s1) # 80036a00 <bcache+0x82b8>
    800024ca:	00034797          	auipc	a5,0x34
    800024ce:	4e678793          	addi	a5,a5,1254 # 800369b0 <bcache+0x8268>
    800024d2:	02f48f63          	beq	s1,a5,80002510 <bread+0x70>
    800024d6:	873e                	mv	a4,a5
    800024d8:	a021                	j	800024e0 <bread+0x40>
    800024da:	68a4                	ld	s1,80(s1)
    800024dc:	02e48a63          	beq	s1,a4,80002510 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024e0:	449c                	lw	a5,8(s1)
    800024e2:	ff279ce3          	bne	a5,s2,800024da <bread+0x3a>
    800024e6:	44dc                	lw	a5,12(s1)
    800024e8:	ff3799e3          	bne	a5,s3,800024da <bread+0x3a>
      b->refcnt++;
    800024ec:	40bc                	lw	a5,64(s1)
    800024ee:	2785                	addiw	a5,a5,1
    800024f0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024f2:	0002c517          	auipc	a0,0x2c
    800024f6:	25650513          	addi	a0,a0,598 # 8002e748 <bcache>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	eae080e7          	jalr	-338(ra) # 800063a8 <release>
      acquiresleep(&b->lock);
    80002502:	01048513          	addi	a0,s1,16
    80002506:	00001097          	auipc	ra,0x1
    8000250a:	472080e7          	jalr	1138(ra) # 80003978 <acquiresleep>
      return b;
    8000250e:	a8b9                	j	8000256c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002510:	00034497          	auipc	s1,0x34
    80002514:	4e84b483          	ld	s1,1256(s1) # 800369f8 <bcache+0x82b0>
    80002518:	00034797          	auipc	a5,0x34
    8000251c:	49878793          	addi	a5,a5,1176 # 800369b0 <bcache+0x8268>
    80002520:	00f48863          	beq	s1,a5,80002530 <bread+0x90>
    80002524:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002526:	40bc                	lw	a5,64(s1)
    80002528:	cf81                	beqz	a5,80002540 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000252a:	64a4                	ld	s1,72(s1)
    8000252c:	fee49de3          	bne	s1,a4,80002526 <bread+0x86>
  panic("bget: no buffers");
    80002530:	00006517          	auipc	a0,0x6
    80002534:	f5050513          	addi	a0,a0,-176 # 80008480 <syscalls+0xc0>
    80002538:	00004097          	auipc	ra,0x4
    8000253c:	834080e7          	jalr	-1996(ra) # 80005d6c <panic>
      b->dev = dev;
    80002540:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002544:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002548:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000254c:	4785                	li	a5,1
    8000254e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002550:	0002c517          	auipc	a0,0x2c
    80002554:	1f850513          	addi	a0,a0,504 # 8002e748 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	e50080e7          	jalr	-432(ra) # 800063a8 <release>
      acquiresleep(&b->lock);
    80002560:	01048513          	addi	a0,s1,16
    80002564:	00001097          	auipc	ra,0x1
    80002568:	414080e7          	jalr	1044(ra) # 80003978 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000256c:	409c                	lw	a5,0(s1)
    8000256e:	cb89                	beqz	a5,80002580 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002570:	8526                	mv	a0,s1
    80002572:	70a2                	ld	ra,40(sp)
    80002574:	7402                	ld	s0,32(sp)
    80002576:	64e2                	ld	s1,24(sp)
    80002578:	6942                	ld	s2,16(sp)
    8000257a:	69a2                	ld	s3,8(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002580:	4581                	li	a1,0
    80002582:	8526                	mv	a0,s1
    80002584:	00003097          	auipc	ra,0x3
    80002588:	fde080e7          	jalr	-34(ra) # 80005562 <virtio_disk_rw>
    b->valid = 1;
    8000258c:	4785                	li	a5,1
    8000258e:	c09c                	sw	a5,0(s1)
  return b;
    80002590:	b7c5                	j	80002570 <bread+0xd0>

0000000080002592 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002592:	1101                	addi	sp,sp,-32
    80002594:	ec06                	sd	ra,24(sp)
    80002596:	e822                	sd	s0,16(sp)
    80002598:	e426                	sd	s1,8(sp)
    8000259a:	1000                	addi	s0,sp,32
    8000259c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000259e:	0541                	addi	a0,a0,16
    800025a0:	00001097          	auipc	ra,0x1
    800025a4:	472080e7          	jalr	1138(ra) # 80003a12 <holdingsleep>
    800025a8:	cd01                	beqz	a0,800025c0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025aa:	4585                	li	a1,1
    800025ac:	8526                	mv	a0,s1
    800025ae:	00003097          	auipc	ra,0x3
    800025b2:	fb4080e7          	jalr	-76(ra) # 80005562 <virtio_disk_rw>
}
    800025b6:	60e2                	ld	ra,24(sp)
    800025b8:	6442                	ld	s0,16(sp)
    800025ba:	64a2                	ld	s1,8(sp)
    800025bc:	6105                	addi	sp,sp,32
    800025be:	8082                	ret
    panic("bwrite");
    800025c0:	00006517          	auipc	a0,0x6
    800025c4:	ed850513          	addi	a0,a0,-296 # 80008498 <syscalls+0xd8>
    800025c8:	00003097          	auipc	ra,0x3
    800025cc:	7a4080e7          	jalr	1956(ra) # 80005d6c <panic>

00000000800025d0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025d0:	1101                	addi	sp,sp,-32
    800025d2:	ec06                	sd	ra,24(sp)
    800025d4:	e822                	sd	s0,16(sp)
    800025d6:	e426                	sd	s1,8(sp)
    800025d8:	e04a                	sd	s2,0(sp)
    800025da:	1000                	addi	s0,sp,32
    800025dc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025de:	01050913          	addi	s2,a0,16
    800025e2:	854a                	mv	a0,s2
    800025e4:	00001097          	auipc	ra,0x1
    800025e8:	42e080e7          	jalr	1070(ra) # 80003a12 <holdingsleep>
    800025ec:	c92d                	beqz	a0,8000265e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025ee:	854a                	mv	a0,s2
    800025f0:	00001097          	auipc	ra,0x1
    800025f4:	3de080e7          	jalr	990(ra) # 800039ce <releasesleep>

  acquire(&bcache.lock);
    800025f8:	0002c517          	auipc	a0,0x2c
    800025fc:	15050513          	addi	a0,a0,336 # 8002e748 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	cf4080e7          	jalr	-780(ra) # 800062f4 <acquire>
  b->refcnt--;
    80002608:	40bc                	lw	a5,64(s1)
    8000260a:	37fd                	addiw	a5,a5,-1
    8000260c:	0007871b          	sext.w	a4,a5
    80002610:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002612:	eb05                	bnez	a4,80002642 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002614:	68bc                	ld	a5,80(s1)
    80002616:	64b8                	ld	a4,72(s1)
    80002618:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000261a:	64bc                	ld	a5,72(s1)
    8000261c:	68b8                	ld	a4,80(s1)
    8000261e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002620:	00034797          	auipc	a5,0x34
    80002624:	12878793          	addi	a5,a5,296 # 80036748 <bcache+0x8000>
    80002628:	2b87b703          	ld	a4,696(a5)
    8000262c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000262e:	00034717          	auipc	a4,0x34
    80002632:	38270713          	addi	a4,a4,898 # 800369b0 <bcache+0x8268>
    80002636:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002638:	2b87b703          	ld	a4,696(a5)
    8000263c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000263e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002642:	0002c517          	auipc	a0,0x2c
    80002646:	10650513          	addi	a0,a0,262 # 8002e748 <bcache>
    8000264a:	00004097          	auipc	ra,0x4
    8000264e:	d5e080e7          	jalr	-674(ra) # 800063a8 <release>
}
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6902                	ld	s2,0(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret
    panic("brelse");
    8000265e:	00006517          	auipc	a0,0x6
    80002662:	e4250513          	addi	a0,a0,-446 # 800084a0 <syscalls+0xe0>
    80002666:	00003097          	auipc	ra,0x3
    8000266a:	706080e7          	jalr	1798(ra) # 80005d6c <panic>

000000008000266e <bpin>:

void
bpin(struct buf *b) {
    8000266e:	1101                	addi	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	1000                	addi	s0,sp,32
    80002678:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000267a:	0002c517          	auipc	a0,0x2c
    8000267e:	0ce50513          	addi	a0,a0,206 # 8002e748 <bcache>
    80002682:	00004097          	auipc	ra,0x4
    80002686:	c72080e7          	jalr	-910(ra) # 800062f4 <acquire>
  b->refcnt++;
    8000268a:	40bc                	lw	a5,64(s1)
    8000268c:	2785                	addiw	a5,a5,1
    8000268e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002690:	0002c517          	auipc	a0,0x2c
    80002694:	0b850513          	addi	a0,a0,184 # 8002e748 <bcache>
    80002698:	00004097          	auipc	ra,0x4
    8000269c:	d10080e7          	jalr	-752(ra) # 800063a8 <release>
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	64a2                	ld	s1,8(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret

00000000800026aa <bunpin>:

void
bunpin(struct buf *b) {
    800026aa:	1101                	addi	sp,sp,-32
    800026ac:	ec06                	sd	ra,24(sp)
    800026ae:	e822                	sd	s0,16(sp)
    800026b0:	e426                	sd	s1,8(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026b6:	0002c517          	auipc	a0,0x2c
    800026ba:	09250513          	addi	a0,a0,146 # 8002e748 <bcache>
    800026be:	00004097          	auipc	ra,0x4
    800026c2:	c36080e7          	jalr	-970(ra) # 800062f4 <acquire>
  b->refcnt--;
    800026c6:	40bc                	lw	a5,64(s1)
    800026c8:	37fd                	addiw	a5,a5,-1
    800026ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026cc:	0002c517          	auipc	a0,0x2c
    800026d0:	07c50513          	addi	a0,a0,124 # 8002e748 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	cd4080e7          	jalr	-812(ra) # 800063a8 <release>
}
    800026dc:	60e2                	ld	ra,24(sp)
    800026de:	6442                	ld	s0,16(sp)
    800026e0:	64a2                	ld	s1,8(sp)
    800026e2:	6105                	addi	sp,sp,32
    800026e4:	8082                	ret

00000000800026e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026e6:	1101                	addi	sp,sp,-32
    800026e8:	ec06                	sd	ra,24(sp)
    800026ea:	e822                	sd	s0,16(sp)
    800026ec:	e426                	sd	s1,8(sp)
    800026ee:	e04a                	sd	s2,0(sp)
    800026f0:	1000                	addi	s0,sp,32
    800026f2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026f4:	00d5d59b          	srliw	a1,a1,0xd
    800026f8:	00034797          	auipc	a5,0x34
    800026fc:	72c7a783          	lw	a5,1836(a5) # 80036e24 <sb+0x1c>
    80002700:	9dbd                	addw	a1,a1,a5
    80002702:	00000097          	auipc	ra,0x0
    80002706:	d9e080e7          	jalr	-610(ra) # 800024a0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000270a:	0074f713          	andi	a4,s1,7
    8000270e:	4785                	li	a5,1
    80002710:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002714:	14ce                	slli	s1,s1,0x33
    80002716:	90d9                	srli	s1,s1,0x36
    80002718:	00950733          	add	a4,a0,s1
    8000271c:	05874703          	lbu	a4,88(a4)
    80002720:	00e7f6b3          	and	a3,a5,a4
    80002724:	c69d                	beqz	a3,80002752 <bfree+0x6c>
    80002726:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002728:	94aa                	add	s1,s1,a0
    8000272a:	fff7c793          	not	a5,a5
    8000272e:	8f7d                	and	a4,a4,a5
    80002730:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002734:	00001097          	auipc	ra,0x1
    80002738:	126080e7          	jalr	294(ra) # 8000385a <log_write>
  brelse(bp);
    8000273c:	854a                	mv	a0,s2
    8000273e:	00000097          	auipc	ra,0x0
    80002742:	e92080e7          	jalr	-366(ra) # 800025d0 <brelse>
}
    80002746:	60e2                	ld	ra,24(sp)
    80002748:	6442                	ld	s0,16(sp)
    8000274a:	64a2                	ld	s1,8(sp)
    8000274c:	6902                	ld	s2,0(sp)
    8000274e:	6105                	addi	sp,sp,32
    80002750:	8082                	ret
    panic("freeing free block");
    80002752:	00006517          	auipc	a0,0x6
    80002756:	d5650513          	addi	a0,a0,-682 # 800084a8 <syscalls+0xe8>
    8000275a:	00003097          	auipc	ra,0x3
    8000275e:	612080e7          	jalr	1554(ra) # 80005d6c <panic>

0000000080002762 <balloc>:
{
    80002762:	711d                	addi	sp,sp,-96
    80002764:	ec86                	sd	ra,88(sp)
    80002766:	e8a2                	sd	s0,80(sp)
    80002768:	e4a6                	sd	s1,72(sp)
    8000276a:	e0ca                	sd	s2,64(sp)
    8000276c:	fc4e                	sd	s3,56(sp)
    8000276e:	f852                	sd	s4,48(sp)
    80002770:	f456                	sd	s5,40(sp)
    80002772:	f05a                	sd	s6,32(sp)
    80002774:	ec5e                	sd	s7,24(sp)
    80002776:	e862                	sd	s8,16(sp)
    80002778:	e466                	sd	s9,8(sp)
    8000277a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000277c:	00034797          	auipc	a5,0x34
    80002780:	6907a783          	lw	a5,1680(a5) # 80036e0c <sb+0x4>
    80002784:	cff5                	beqz	a5,80002880 <balloc+0x11e>
    80002786:	8baa                	mv	s7,a0
    80002788:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000278a:	00034b17          	auipc	s6,0x34
    8000278e:	67eb0b13          	addi	s6,s6,1662 # 80036e08 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002792:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002794:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002796:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002798:	6c89                	lui	s9,0x2
    8000279a:	a061                	j	80002822 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000279c:	97ca                	add	a5,a5,s2
    8000279e:	8e55                	or	a2,a2,a3
    800027a0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027a4:	854a                	mv	a0,s2
    800027a6:	00001097          	auipc	ra,0x1
    800027aa:	0b4080e7          	jalr	180(ra) # 8000385a <log_write>
        brelse(bp);
    800027ae:	854a                	mv	a0,s2
    800027b0:	00000097          	auipc	ra,0x0
    800027b4:	e20080e7          	jalr	-480(ra) # 800025d0 <brelse>
  bp = bread(dev, bno);
    800027b8:	85a6                	mv	a1,s1
    800027ba:	855e                	mv	a0,s7
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	ce4080e7          	jalr	-796(ra) # 800024a0 <bread>
    800027c4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027c6:	40000613          	li	a2,1024
    800027ca:	4581                	li	a1,0
    800027cc:	05850513          	addi	a0,a0,88
    800027d0:	ffffe097          	auipc	ra,0xffffe
    800027d4:	aa0080e7          	jalr	-1376(ra) # 80000270 <memset>
  log_write(bp);
    800027d8:	854a                	mv	a0,s2
    800027da:	00001097          	auipc	ra,0x1
    800027de:	080080e7          	jalr	128(ra) # 8000385a <log_write>
  brelse(bp);
    800027e2:	854a                	mv	a0,s2
    800027e4:	00000097          	auipc	ra,0x0
    800027e8:	dec080e7          	jalr	-532(ra) # 800025d0 <brelse>
}
    800027ec:	8526                	mv	a0,s1
    800027ee:	60e6                	ld	ra,88(sp)
    800027f0:	6446                	ld	s0,80(sp)
    800027f2:	64a6                	ld	s1,72(sp)
    800027f4:	6906                	ld	s2,64(sp)
    800027f6:	79e2                	ld	s3,56(sp)
    800027f8:	7a42                	ld	s4,48(sp)
    800027fa:	7aa2                	ld	s5,40(sp)
    800027fc:	7b02                	ld	s6,32(sp)
    800027fe:	6be2                	ld	s7,24(sp)
    80002800:	6c42                	ld	s8,16(sp)
    80002802:	6ca2                	ld	s9,8(sp)
    80002804:	6125                	addi	sp,sp,96
    80002806:	8082                	ret
    brelse(bp);
    80002808:	854a                	mv	a0,s2
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	dc6080e7          	jalr	-570(ra) # 800025d0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002812:	015c87bb          	addw	a5,s9,s5
    80002816:	00078a9b          	sext.w	s5,a5
    8000281a:	004b2703          	lw	a4,4(s6)
    8000281e:	06eaf163          	bgeu	s5,a4,80002880 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002822:	41fad79b          	sraiw	a5,s5,0x1f
    80002826:	0137d79b          	srliw	a5,a5,0x13
    8000282a:	015787bb          	addw	a5,a5,s5
    8000282e:	40d7d79b          	sraiw	a5,a5,0xd
    80002832:	01cb2583          	lw	a1,28(s6)
    80002836:	9dbd                	addw	a1,a1,a5
    80002838:	855e                	mv	a0,s7
    8000283a:	00000097          	auipc	ra,0x0
    8000283e:	c66080e7          	jalr	-922(ra) # 800024a0 <bread>
    80002842:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002844:	004b2503          	lw	a0,4(s6)
    80002848:	000a849b          	sext.w	s1,s5
    8000284c:	8762                	mv	a4,s8
    8000284e:	faa4fde3          	bgeu	s1,a0,80002808 <balloc+0xa6>
      m = 1 << (bi % 8);
    80002852:	00777693          	andi	a3,a4,7
    80002856:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000285a:	41f7579b          	sraiw	a5,a4,0x1f
    8000285e:	01d7d79b          	srliw	a5,a5,0x1d
    80002862:	9fb9                	addw	a5,a5,a4
    80002864:	4037d79b          	sraiw	a5,a5,0x3
    80002868:	00f90633          	add	a2,s2,a5
    8000286c:	05864603          	lbu	a2,88(a2)
    80002870:	00c6f5b3          	and	a1,a3,a2
    80002874:	d585                	beqz	a1,8000279c <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002876:	2705                	addiw	a4,a4,1
    80002878:	2485                	addiw	s1,s1,1
    8000287a:	fd471ae3          	bne	a4,s4,8000284e <balloc+0xec>
    8000287e:	b769                	j	80002808 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002880:	00006517          	auipc	a0,0x6
    80002884:	c4050513          	addi	a0,a0,-960 # 800084c0 <syscalls+0x100>
    80002888:	00003097          	auipc	ra,0x3
    8000288c:	52e080e7          	jalr	1326(ra) # 80005db6 <printf>
  return 0;
    80002890:	4481                	li	s1,0
    80002892:	bfa9                	j	800027ec <balloc+0x8a>

0000000080002894 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002894:	7179                	addi	sp,sp,-48
    80002896:	f406                	sd	ra,40(sp)
    80002898:	f022                	sd	s0,32(sp)
    8000289a:	ec26                	sd	s1,24(sp)
    8000289c:	e84a                	sd	s2,16(sp)
    8000289e:	e44e                	sd	s3,8(sp)
    800028a0:	e052                	sd	s4,0(sp)
    800028a2:	1800                	addi	s0,sp,48
    800028a4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028a6:	47ad                	li	a5,11
    800028a8:	02b7e863          	bltu	a5,a1,800028d8 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    800028ac:	02059793          	slli	a5,a1,0x20
    800028b0:	01e7d593          	srli	a1,a5,0x1e
    800028b4:	00b504b3          	add	s1,a0,a1
    800028b8:	0504a903          	lw	s2,80(s1)
    800028bc:	06091e63          	bnez	s2,80002938 <bmap+0xa4>
      addr = balloc(ip->dev);
    800028c0:	4108                	lw	a0,0(a0)
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	ea0080e7          	jalr	-352(ra) # 80002762 <balloc>
    800028ca:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028ce:	06090563          	beqz	s2,80002938 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    800028d2:	0524a823          	sw	s2,80(s1)
    800028d6:	a08d                	j	80002938 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028d8:	ff45849b          	addiw	s1,a1,-12
    800028dc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028e0:	0ff00793          	li	a5,255
    800028e4:	08e7e563          	bltu	a5,a4,8000296e <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028e8:	08052903          	lw	s2,128(a0)
    800028ec:	00091d63          	bnez	s2,80002906 <bmap+0x72>
      addr = balloc(ip->dev);
    800028f0:	4108                	lw	a0,0(a0)
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	e70080e7          	jalr	-400(ra) # 80002762 <balloc>
    800028fa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028fe:	02090d63          	beqz	s2,80002938 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002902:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002906:	85ca                	mv	a1,s2
    80002908:	0009a503          	lw	a0,0(s3)
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	b94080e7          	jalr	-1132(ra) # 800024a0 <bread>
    80002914:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002916:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000291a:	02049713          	slli	a4,s1,0x20
    8000291e:	01e75593          	srli	a1,a4,0x1e
    80002922:	00b784b3          	add	s1,a5,a1
    80002926:	0004a903          	lw	s2,0(s1)
    8000292a:	02090063          	beqz	s2,8000294a <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000292e:	8552                	mv	a0,s4
    80002930:	00000097          	auipc	ra,0x0
    80002934:	ca0080e7          	jalr	-864(ra) # 800025d0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002938:	854a                	mv	a0,s2
    8000293a:	70a2                	ld	ra,40(sp)
    8000293c:	7402                	ld	s0,32(sp)
    8000293e:	64e2                	ld	s1,24(sp)
    80002940:	6942                	ld	s2,16(sp)
    80002942:	69a2                	ld	s3,8(sp)
    80002944:	6a02                	ld	s4,0(sp)
    80002946:	6145                	addi	sp,sp,48
    80002948:	8082                	ret
      addr = balloc(ip->dev);
    8000294a:	0009a503          	lw	a0,0(s3)
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	e14080e7          	jalr	-492(ra) # 80002762 <balloc>
    80002956:	0005091b          	sext.w	s2,a0
      if(addr){
    8000295a:	fc090ae3          	beqz	s2,8000292e <bmap+0x9a>
        a[bn] = addr;
    8000295e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002962:	8552                	mv	a0,s4
    80002964:	00001097          	auipc	ra,0x1
    80002968:	ef6080e7          	jalr	-266(ra) # 8000385a <log_write>
    8000296c:	b7c9                	j	8000292e <bmap+0x9a>
  panic("bmap: out of range");
    8000296e:	00006517          	auipc	a0,0x6
    80002972:	b6a50513          	addi	a0,a0,-1174 # 800084d8 <syscalls+0x118>
    80002976:	00003097          	auipc	ra,0x3
    8000297a:	3f6080e7          	jalr	1014(ra) # 80005d6c <panic>

000000008000297e <iget>:
{
    8000297e:	7179                	addi	sp,sp,-48
    80002980:	f406                	sd	ra,40(sp)
    80002982:	f022                	sd	s0,32(sp)
    80002984:	ec26                	sd	s1,24(sp)
    80002986:	e84a                	sd	s2,16(sp)
    80002988:	e44e                	sd	s3,8(sp)
    8000298a:	e052                	sd	s4,0(sp)
    8000298c:	1800                	addi	s0,sp,48
    8000298e:	89aa                	mv	s3,a0
    80002990:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002992:	00034517          	auipc	a0,0x34
    80002996:	49650513          	addi	a0,a0,1174 # 80036e28 <itable>
    8000299a:	00004097          	auipc	ra,0x4
    8000299e:	95a080e7          	jalr	-1702(ra) # 800062f4 <acquire>
  empty = 0;
    800029a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029a4:	00034497          	auipc	s1,0x34
    800029a8:	49c48493          	addi	s1,s1,1180 # 80036e40 <itable+0x18>
    800029ac:	00036697          	auipc	a3,0x36
    800029b0:	f2468693          	addi	a3,a3,-220 # 800388d0 <log>
    800029b4:	a039                	j	800029c2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b6:	02090b63          	beqz	s2,800029ec <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029ba:	08848493          	addi	s1,s1,136
    800029be:	02d48a63          	beq	s1,a3,800029f2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029c2:	449c                	lw	a5,8(s1)
    800029c4:	fef059e3          	blez	a5,800029b6 <iget+0x38>
    800029c8:	4098                	lw	a4,0(s1)
    800029ca:	ff3716e3          	bne	a4,s3,800029b6 <iget+0x38>
    800029ce:	40d8                	lw	a4,4(s1)
    800029d0:	ff4713e3          	bne	a4,s4,800029b6 <iget+0x38>
      ip->ref++;
    800029d4:	2785                	addiw	a5,a5,1
    800029d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029d8:	00034517          	auipc	a0,0x34
    800029dc:	45050513          	addi	a0,a0,1104 # 80036e28 <itable>
    800029e0:	00004097          	auipc	ra,0x4
    800029e4:	9c8080e7          	jalr	-1592(ra) # 800063a8 <release>
      return ip;
    800029e8:	8926                	mv	s2,s1
    800029ea:	a03d                	j	80002a18 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029ec:	f7f9                	bnez	a5,800029ba <iget+0x3c>
    800029ee:	8926                	mv	s2,s1
    800029f0:	b7e9                	j	800029ba <iget+0x3c>
  if(empty == 0)
    800029f2:	02090c63          	beqz	s2,80002a2a <iget+0xac>
  ip->dev = dev;
    800029f6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029fa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029fe:	4785                	li	a5,1
    80002a00:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a04:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a08:	00034517          	auipc	a0,0x34
    80002a0c:	42050513          	addi	a0,a0,1056 # 80036e28 <itable>
    80002a10:	00004097          	auipc	ra,0x4
    80002a14:	998080e7          	jalr	-1640(ra) # 800063a8 <release>
}
    80002a18:	854a                	mv	a0,s2
    80002a1a:	70a2                	ld	ra,40(sp)
    80002a1c:	7402                	ld	s0,32(sp)
    80002a1e:	64e2                	ld	s1,24(sp)
    80002a20:	6942                	ld	s2,16(sp)
    80002a22:	69a2                	ld	s3,8(sp)
    80002a24:	6a02                	ld	s4,0(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret
    panic("iget: no inodes");
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	ac650513          	addi	a0,a0,-1338 # 800084f0 <syscalls+0x130>
    80002a32:	00003097          	auipc	ra,0x3
    80002a36:	33a080e7          	jalr	826(ra) # 80005d6c <panic>

0000000080002a3a <fsinit>:
fsinit(int dev) {
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	e84a                	sd	s2,16(sp)
    80002a44:	e44e                	sd	s3,8(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a4a:	4585                	li	a1,1
    80002a4c:	00000097          	auipc	ra,0x0
    80002a50:	a54080e7          	jalr	-1452(ra) # 800024a0 <bread>
    80002a54:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a56:	00034997          	auipc	s3,0x34
    80002a5a:	3b298993          	addi	s3,s3,946 # 80036e08 <sb>
    80002a5e:	02000613          	li	a2,32
    80002a62:	05850593          	addi	a1,a0,88
    80002a66:	854e                	mv	a0,s3
    80002a68:	ffffe097          	auipc	ra,0xffffe
    80002a6c:	864080e7          	jalr	-1948(ra) # 800002cc <memmove>
  brelse(bp);
    80002a70:	8526                	mv	a0,s1
    80002a72:	00000097          	auipc	ra,0x0
    80002a76:	b5e080e7          	jalr	-1186(ra) # 800025d0 <brelse>
  if(sb.magic != FSMAGIC)
    80002a7a:	0009a703          	lw	a4,0(s3)
    80002a7e:	102037b7          	lui	a5,0x10203
    80002a82:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a86:	02f71263          	bne	a4,a5,80002aaa <fsinit+0x70>
  initlog(dev, &sb);
    80002a8a:	00034597          	auipc	a1,0x34
    80002a8e:	37e58593          	addi	a1,a1,894 # 80036e08 <sb>
    80002a92:	854a                	mv	a0,s2
    80002a94:	00001097          	auipc	ra,0x1
    80002a98:	b4a080e7          	jalr	-1206(ra) # 800035de <initlog>
}
    80002a9c:	70a2                	ld	ra,40(sp)
    80002a9e:	7402                	ld	s0,32(sp)
    80002aa0:	64e2                	ld	s1,24(sp)
    80002aa2:	6942                	ld	s2,16(sp)
    80002aa4:	69a2                	ld	s3,8(sp)
    80002aa6:	6145                	addi	sp,sp,48
    80002aa8:	8082                	ret
    panic("invalid file system");
    80002aaa:	00006517          	auipc	a0,0x6
    80002aae:	a5650513          	addi	a0,a0,-1450 # 80008500 <syscalls+0x140>
    80002ab2:	00003097          	auipc	ra,0x3
    80002ab6:	2ba080e7          	jalr	698(ra) # 80005d6c <panic>

0000000080002aba <iinit>:
{
    80002aba:	7179                	addi	sp,sp,-48
    80002abc:	f406                	sd	ra,40(sp)
    80002abe:	f022                	sd	s0,32(sp)
    80002ac0:	ec26                	sd	s1,24(sp)
    80002ac2:	e84a                	sd	s2,16(sp)
    80002ac4:	e44e                	sd	s3,8(sp)
    80002ac6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ac8:	00006597          	auipc	a1,0x6
    80002acc:	a5058593          	addi	a1,a1,-1456 # 80008518 <syscalls+0x158>
    80002ad0:	00034517          	auipc	a0,0x34
    80002ad4:	35850513          	addi	a0,a0,856 # 80036e28 <itable>
    80002ad8:	00003097          	auipc	ra,0x3
    80002adc:	78c080e7          	jalr	1932(ra) # 80006264 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ae0:	00034497          	auipc	s1,0x34
    80002ae4:	37048493          	addi	s1,s1,880 # 80036e50 <itable+0x28>
    80002ae8:	00036997          	auipc	s3,0x36
    80002aec:	df898993          	addi	s3,s3,-520 # 800388e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002af0:	00006917          	auipc	s2,0x6
    80002af4:	a3090913          	addi	s2,s2,-1488 # 80008520 <syscalls+0x160>
    80002af8:	85ca                	mv	a1,s2
    80002afa:	8526                	mv	a0,s1
    80002afc:	00001097          	auipc	ra,0x1
    80002b00:	e42080e7          	jalr	-446(ra) # 8000393e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b04:	08848493          	addi	s1,s1,136
    80002b08:	ff3498e3          	bne	s1,s3,80002af8 <iinit+0x3e>
}
    80002b0c:	70a2                	ld	ra,40(sp)
    80002b0e:	7402                	ld	s0,32(sp)
    80002b10:	64e2                	ld	s1,24(sp)
    80002b12:	6942                	ld	s2,16(sp)
    80002b14:	69a2                	ld	s3,8(sp)
    80002b16:	6145                	addi	sp,sp,48
    80002b18:	8082                	ret

0000000080002b1a <ialloc>:
{
    80002b1a:	715d                	addi	sp,sp,-80
    80002b1c:	e486                	sd	ra,72(sp)
    80002b1e:	e0a2                	sd	s0,64(sp)
    80002b20:	fc26                	sd	s1,56(sp)
    80002b22:	f84a                	sd	s2,48(sp)
    80002b24:	f44e                	sd	s3,40(sp)
    80002b26:	f052                	sd	s4,32(sp)
    80002b28:	ec56                	sd	s5,24(sp)
    80002b2a:	e85a                	sd	s6,16(sp)
    80002b2c:	e45e                	sd	s7,8(sp)
    80002b2e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b30:	00034717          	auipc	a4,0x34
    80002b34:	2e472703          	lw	a4,740(a4) # 80036e14 <sb+0xc>
    80002b38:	4785                	li	a5,1
    80002b3a:	04e7fa63          	bgeu	a5,a4,80002b8e <ialloc+0x74>
    80002b3e:	8aaa                	mv	s5,a0
    80002b40:	8bae                	mv	s7,a1
    80002b42:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b44:	00034a17          	auipc	s4,0x34
    80002b48:	2c4a0a13          	addi	s4,s4,708 # 80036e08 <sb>
    80002b4c:	00048b1b          	sext.w	s6,s1
    80002b50:	0044d593          	srli	a1,s1,0x4
    80002b54:	018a2783          	lw	a5,24(s4)
    80002b58:	9dbd                	addw	a1,a1,a5
    80002b5a:	8556                	mv	a0,s5
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	944080e7          	jalr	-1724(ra) # 800024a0 <bread>
    80002b64:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b66:	05850993          	addi	s3,a0,88
    80002b6a:	00f4f793          	andi	a5,s1,15
    80002b6e:	079a                	slli	a5,a5,0x6
    80002b70:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b72:	00099783          	lh	a5,0(s3)
    80002b76:	c3a1                	beqz	a5,80002bb6 <ialloc+0x9c>
    brelse(bp);
    80002b78:	00000097          	auipc	ra,0x0
    80002b7c:	a58080e7          	jalr	-1448(ra) # 800025d0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b80:	0485                	addi	s1,s1,1
    80002b82:	00ca2703          	lw	a4,12(s4)
    80002b86:	0004879b          	sext.w	a5,s1
    80002b8a:	fce7e1e3          	bltu	a5,a4,80002b4c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b8e:	00006517          	auipc	a0,0x6
    80002b92:	99a50513          	addi	a0,a0,-1638 # 80008528 <syscalls+0x168>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	220080e7          	jalr	544(ra) # 80005db6 <printf>
  return 0;
    80002b9e:	4501                	li	a0,0
}
    80002ba0:	60a6                	ld	ra,72(sp)
    80002ba2:	6406                	ld	s0,64(sp)
    80002ba4:	74e2                	ld	s1,56(sp)
    80002ba6:	7942                	ld	s2,48(sp)
    80002ba8:	79a2                	ld	s3,40(sp)
    80002baa:	7a02                	ld	s4,32(sp)
    80002bac:	6ae2                	ld	s5,24(sp)
    80002bae:	6b42                	ld	s6,16(sp)
    80002bb0:	6ba2                	ld	s7,8(sp)
    80002bb2:	6161                	addi	sp,sp,80
    80002bb4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002bb6:	04000613          	li	a2,64
    80002bba:	4581                	li	a1,0
    80002bbc:	854e                	mv	a0,s3
    80002bbe:	ffffd097          	auipc	ra,0xffffd
    80002bc2:	6b2080e7          	jalr	1714(ra) # 80000270 <memset>
      dip->type = type;
    80002bc6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	c8e080e7          	jalr	-882(ra) # 8000385a <log_write>
      brelse(bp);
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	9fa080e7          	jalr	-1542(ra) # 800025d0 <brelse>
      return iget(dev, inum);
    80002bde:	85da                	mv	a1,s6
    80002be0:	8556                	mv	a0,s5
    80002be2:	00000097          	auipc	ra,0x0
    80002be6:	d9c080e7          	jalr	-612(ra) # 8000297e <iget>
    80002bea:	bf5d                	j	80002ba0 <ialloc+0x86>

0000000080002bec <iupdate>:
{
    80002bec:	1101                	addi	sp,sp,-32
    80002bee:	ec06                	sd	ra,24(sp)
    80002bf0:	e822                	sd	s0,16(sp)
    80002bf2:	e426                	sd	s1,8(sp)
    80002bf4:	e04a                	sd	s2,0(sp)
    80002bf6:	1000                	addi	s0,sp,32
    80002bf8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bfa:	415c                	lw	a5,4(a0)
    80002bfc:	0047d79b          	srliw	a5,a5,0x4
    80002c00:	00034597          	auipc	a1,0x34
    80002c04:	2205a583          	lw	a1,544(a1) # 80036e20 <sb+0x18>
    80002c08:	9dbd                	addw	a1,a1,a5
    80002c0a:	4108                	lw	a0,0(a0)
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	894080e7          	jalr	-1900(ra) # 800024a0 <bread>
    80002c14:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c16:	05850793          	addi	a5,a0,88
    80002c1a:	40d8                	lw	a4,4(s1)
    80002c1c:	8b3d                	andi	a4,a4,15
    80002c1e:	071a                	slli	a4,a4,0x6
    80002c20:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c22:	04449703          	lh	a4,68(s1)
    80002c26:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c2a:	04649703          	lh	a4,70(s1)
    80002c2e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c32:	04849703          	lh	a4,72(s1)
    80002c36:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c3a:	04a49703          	lh	a4,74(s1)
    80002c3e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c42:	44f8                	lw	a4,76(s1)
    80002c44:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c46:	03400613          	li	a2,52
    80002c4a:	05048593          	addi	a1,s1,80
    80002c4e:	00c78513          	addi	a0,a5,12
    80002c52:	ffffd097          	auipc	ra,0xffffd
    80002c56:	67a080e7          	jalr	1658(ra) # 800002cc <memmove>
  log_write(bp);
    80002c5a:	854a                	mv	a0,s2
    80002c5c:	00001097          	auipc	ra,0x1
    80002c60:	bfe080e7          	jalr	-1026(ra) # 8000385a <log_write>
  brelse(bp);
    80002c64:	854a                	mv	a0,s2
    80002c66:	00000097          	auipc	ra,0x0
    80002c6a:	96a080e7          	jalr	-1686(ra) # 800025d0 <brelse>
}
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	64a2                	ld	s1,8(sp)
    80002c74:	6902                	ld	s2,0(sp)
    80002c76:	6105                	addi	sp,sp,32
    80002c78:	8082                	ret

0000000080002c7a <idup>:
{
    80002c7a:	1101                	addi	sp,sp,-32
    80002c7c:	ec06                	sd	ra,24(sp)
    80002c7e:	e822                	sd	s0,16(sp)
    80002c80:	e426                	sd	s1,8(sp)
    80002c82:	1000                	addi	s0,sp,32
    80002c84:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c86:	00034517          	auipc	a0,0x34
    80002c8a:	1a250513          	addi	a0,a0,418 # 80036e28 <itable>
    80002c8e:	00003097          	auipc	ra,0x3
    80002c92:	666080e7          	jalr	1638(ra) # 800062f4 <acquire>
  ip->ref++;
    80002c96:	449c                	lw	a5,8(s1)
    80002c98:	2785                	addiw	a5,a5,1
    80002c9a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c9c:	00034517          	auipc	a0,0x34
    80002ca0:	18c50513          	addi	a0,a0,396 # 80036e28 <itable>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	704080e7          	jalr	1796(ra) # 800063a8 <release>
}
    80002cac:	8526                	mv	a0,s1
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6105                	addi	sp,sp,32
    80002cb6:	8082                	ret

0000000080002cb8 <ilock>:
{
    80002cb8:	1101                	addi	sp,sp,-32
    80002cba:	ec06                	sd	ra,24(sp)
    80002cbc:	e822                	sd	s0,16(sp)
    80002cbe:	e426                	sd	s1,8(sp)
    80002cc0:	e04a                	sd	s2,0(sp)
    80002cc2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cc4:	c115                	beqz	a0,80002ce8 <ilock+0x30>
    80002cc6:	84aa                	mv	s1,a0
    80002cc8:	451c                	lw	a5,8(a0)
    80002cca:	00f05f63          	blez	a5,80002ce8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cce:	0541                	addi	a0,a0,16
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	ca8080e7          	jalr	-856(ra) # 80003978 <acquiresleep>
  if(ip->valid == 0){
    80002cd8:	40bc                	lw	a5,64(s1)
    80002cda:	cf99                	beqz	a5,80002cf8 <ilock+0x40>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	64a2                	ld	s1,8(sp)
    80002ce2:	6902                	ld	s2,0(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret
    panic("ilock");
    80002ce8:	00006517          	auipc	a0,0x6
    80002cec:	85850513          	addi	a0,a0,-1960 # 80008540 <syscalls+0x180>
    80002cf0:	00003097          	auipc	ra,0x3
    80002cf4:	07c080e7          	jalr	124(ra) # 80005d6c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cf8:	40dc                	lw	a5,4(s1)
    80002cfa:	0047d79b          	srliw	a5,a5,0x4
    80002cfe:	00034597          	auipc	a1,0x34
    80002d02:	1225a583          	lw	a1,290(a1) # 80036e20 <sb+0x18>
    80002d06:	9dbd                	addw	a1,a1,a5
    80002d08:	4088                	lw	a0,0(s1)
    80002d0a:	fffff097          	auipc	ra,0xfffff
    80002d0e:	796080e7          	jalr	1942(ra) # 800024a0 <bread>
    80002d12:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d14:	05850593          	addi	a1,a0,88
    80002d18:	40dc                	lw	a5,4(s1)
    80002d1a:	8bbd                	andi	a5,a5,15
    80002d1c:	079a                	slli	a5,a5,0x6
    80002d1e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d20:	00059783          	lh	a5,0(a1)
    80002d24:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d28:	00259783          	lh	a5,2(a1)
    80002d2c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d30:	00459783          	lh	a5,4(a1)
    80002d34:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d38:	00659783          	lh	a5,6(a1)
    80002d3c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d40:	459c                	lw	a5,8(a1)
    80002d42:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d44:	03400613          	li	a2,52
    80002d48:	05b1                	addi	a1,a1,12
    80002d4a:	05048513          	addi	a0,s1,80
    80002d4e:	ffffd097          	auipc	ra,0xffffd
    80002d52:	57e080e7          	jalr	1406(ra) # 800002cc <memmove>
    brelse(bp);
    80002d56:	854a                	mv	a0,s2
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	878080e7          	jalr	-1928(ra) # 800025d0 <brelse>
    ip->valid = 1;
    80002d60:	4785                	li	a5,1
    80002d62:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d64:	04449783          	lh	a5,68(s1)
    80002d68:	fbb5                	bnez	a5,80002cdc <ilock+0x24>
      panic("ilock: no type");
    80002d6a:	00005517          	auipc	a0,0x5
    80002d6e:	7de50513          	addi	a0,a0,2014 # 80008548 <syscalls+0x188>
    80002d72:	00003097          	auipc	ra,0x3
    80002d76:	ffa080e7          	jalr	-6(ra) # 80005d6c <panic>

0000000080002d7a <iunlock>:
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	e04a                	sd	s2,0(sp)
    80002d84:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d86:	c905                	beqz	a0,80002db6 <iunlock+0x3c>
    80002d88:	84aa                	mv	s1,a0
    80002d8a:	01050913          	addi	s2,a0,16
    80002d8e:	854a                	mv	a0,s2
    80002d90:	00001097          	auipc	ra,0x1
    80002d94:	c82080e7          	jalr	-894(ra) # 80003a12 <holdingsleep>
    80002d98:	cd19                	beqz	a0,80002db6 <iunlock+0x3c>
    80002d9a:	449c                	lw	a5,8(s1)
    80002d9c:	00f05d63          	blez	a5,80002db6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002da0:	854a                	mv	a0,s2
    80002da2:	00001097          	auipc	ra,0x1
    80002da6:	c2c080e7          	jalr	-980(ra) # 800039ce <releasesleep>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	64a2                	ld	s1,8(sp)
    80002db0:	6902                	ld	s2,0(sp)
    80002db2:	6105                	addi	sp,sp,32
    80002db4:	8082                	ret
    panic("iunlock");
    80002db6:	00005517          	auipc	a0,0x5
    80002dba:	7a250513          	addi	a0,a0,1954 # 80008558 <syscalls+0x198>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	fae080e7          	jalr	-82(ra) # 80005d6c <panic>

0000000080002dc6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dc6:	7179                	addi	sp,sp,-48
    80002dc8:	f406                	sd	ra,40(sp)
    80002dca:	f022                	sd	s0,32(sp)
    80002dcc:	ec26                	sd	s1,24(sp)
    80002dce:	e84a                	sd	s2,16(sp)
    80002dd0:	e44e                	sd	s3,8(sp)
    80002dd2:	e052                	sd	s4,0(sp)
    80002dd4:	1800                	addi	s0,sp,48
    80002dd6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dd8:	05050493          	addi	s1,a0,80
    80002ddc:	08050913          	addi	s2,a0,128
    80002de0:	a021                	j	80002de8 <itrunc+0x22>
    80002de2:	0491                	addi	s1,s1,4
    80002de4:	01248d63          	beq	s1,s2,80002dfe <itrunc+0x38>
    if(ip->addrs[i]){
    80002de8:	408c                	lw	a1,0(s1)
    80002dea:	dde5                	beqz	a1,80002de2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dec:	0009a503          	lw	a0,0(s3)
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	8f6080e7          	jalr	-1802(ra) # 800026e6 <bfree>
      ip->addrs[i] = 0;
    80002df8:	0004a023          	sw	zero,0(s1)
    80002dfc:	b7dd                	j	80002de2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dfe:	0809a583          	lw	a1,128(s3)
    80002e02:	e185                	bnez	a1,80002e22 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e04:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e08:	854e                	mv	a0,s3
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	de2080e7          	jalr	-542(ra) # 80002bec <iupdate>
}
    80002e12:	70a2                	ld	ra,40(sp)
    80002e14:	7402                	ld	s0,32(sp)
    80002e16:	64e2                	ld	s1,24(sp)
    80002e18:	6942                	ld	s2,16(sp)
    80002e1a:	69a2                	ld	s3,8(sp)
    80002e1c:	6a02                	ld	s4,0(sp)
    80002e1e:	6145                	addi	sp,sp,48
    80002e20:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e22:	0009a503          	lw	a0,0(s3)
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	67a080e7          	jalr	1658(ra) # 800024a0 <bread>
    80002e2e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e30:	05850493          	addi	s1,a0,88
    80002e34:	45850913          	addi	s2,a0,1112
    80002e38:	a021                	j	80002e40 <itrunc+0x7a>
    80002e3a:	0491                	addi	s1,s1,4
    80002e3c:	01248b63          	beq	s1,s2,80002e52 <itrunc+0x8c>
      if(a[j])
    80002e40:	408c                	lw	a1,0(s1)
    80002e42:	dde5                	beqz	a1,80002e3a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e44:	0009a503          	lw	a0,0(s3)
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	89e080e7          	jalr	-1890(ra) # 800026e6 <bfree>
    80002e50:	b7ed                	j	80002e3a <itrunc+0x74>
    brelse(bp);
    80002e52:	8552                	mv	a0,s4
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	77c080e7          	jalr	1916(ra) # 800025d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e5c:	0809a583          	lw	a1,128(s3)
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	882080e7          	jalr	-1918(ra) # 800026e6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e6c:	0809a023          	sw	zero,128(s3)
    80002e70:	bf51                	j	80002e04 <itrunc+0x3e>

0000000080002e72 <iput>:
{
    80002e72:	1101                	addi	sp,sp,-32
    80002e74:	ec06                	sd	ra,24(sp)
    80002e76:	e822                	sd	s0,16(sp)
    80002e78:	e426                	sd	s1,8(sp)
    80002e7a:	e04a                	sd	s2,0(sp)
    80002e7c:	1000                	addi	s0,sp,32
    80002e7e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e80:	00034517          	auipc	a0,0x34
    80002e84:	fa850513          	addi	a0,a0,-88 # 80036e28 <itable>
    80002e88:	00003097          	auipc	ra,0x3
    80002e8c:	46c080e7          	jalr	1132(ra) # 800062f4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e90:	4498                	lw	a4,8(s1)
    80002e92:	4785                	li	a5,1
    80002e94:	02f70363          	beq	a4,a5,80002eba <iput+0x48>
  ip->ref--;
    80002e98:	449c                	lw	a5,8(s1)
    80002e9a:	37fd                	addiw	a5,a5,-1
    80002e9c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e9e:	00034517          	auipc	a0,0x34
    80002ea2:	f8a50513          	addi	a0,a0,-118 # 80036e28 <itable>
    80002ea6:	00003097          	auipc	ra,0x3
    80002eaa:	502080e7          	jalr	1282(ra) # 800063a8 <release>
}
    80002eae:	60e2                	ld	ra,24(sp)
    80002eb0:	6442                	ld	s0,16(sp)
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	6902                	ld	s2,0(sp)
    80002eb6:	6105                	addi	sp,sp,32
    80002eb8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eba:	40bc                	lw	a5,64(s1)
    80002ebc:	dff1                	beqz	a5,80002e98 <iput+0x26>
    80002ebe:	04a49783          	lh	a5,74(s1)
    80002ec2:	fbf9                	bnez	a5,80002e98 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ec4:	01048913          	addi	s2,s1,16
    80002ec8:	854a                	mv	a0,s2
    80002eca:	00001097          	auipc	ra,0x1
    80002ece:	aae080e7          	jalr	-1362(ra) # 80003978 <acquiresleep>
    release(&itable.lock);
    80002ed2:	00034517          	auipc	a0,0x34
    80002ed6:	f5650513          	addi	a0,a0,-170 # 80036e28 <itable>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	4ce080e7          	jalr	1230(ra) # 800063a8 <release>
    itrunc(ip);
    80002ee2:	8526                	mv	a0,s1
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	ee2080e7          	jalr	-286(ra) # 80002dc6 <itrunc>
    ip->type = 0;
    80002eec:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ef0:	8526                	mv	a0,s1
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	cfa080e7          	jalr	-774(ra) # 80002bec <iupdate>
    ip->valid = 0;
    80002efa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002efe:	854a                	mv	a0,s2
    80002f00:	00001097          	auipc	ra,0x1
    80002f04:	ace080e7          	jalr	-1330(ra) # 800039ce <releasesleep>
    acquire(&itable.lock);
    80002f08:	00034517          	auipc	a0,0x34
    80002f0c:	f2050513          	addi	a0,a0,-224 # 80036e28 <itable>
    80002f10:	00003097          	auipc	ra,0x3
    80002f14:	3e4080e7          	jalr	996(ra) # 800062f4 <acquire>
    80002f18:	b741                	j	80002e98 <iput+0x26>

0000000080002f1a <iunlockput>:
{
    80002f1a:	1101                	addi	sp,sp,-32
    80002f1c:	ec06                	sd	ra,24(sp)
    80002f1e:	e822                	sd	s0,16(sp)
    80002f20:	e426                	sd	s1,8(sp)
    80002f22:	1000                	addi	s0,sp,32
    80002f24:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	e54080e7          	jalr	-428(ra) # 80002d7a <iunlock>
  iput(ip);
    80002f2e:	8526                	mv	a0,s1
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	f42080e7          	jalr	-190(ra) # 80002e72 <iput>
}
    80002f38:	60e2                	ld	ra,24(sp)
    80002f3a:	6442                	ld	s0,16(sp)
    80002f3c:	64a2                	ld	s1,8(sp)
    80002f3e:	6105                	addi	sp,sp,32
    80002f40:	8082                	ret

0000000080002f42 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f42:	1141                	addi	sp,sp,-16
    80002f44:	e422                	sd	s0,8(sp)
    80002f46:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f48:	411c                	lw	a5,0(a0)
    80002f4a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f4c:	415c                	lw	a5,4(a0)
    80002f4e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f50:	04451783          	lh	a5,68(a0)
    80002f54:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f58:	04a51783          	lh	a5,74(a0)
    80002f5c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f60:	04c56783          	lwu	a5,76(a0)
    80002f64:	e99c                	sd	a5,16(a1)
}
    80002f66:	6422                	ld	s0,8(sp)
    80002f68:	0141                	addi	sp,sp,16
    80002f6a:	8082                	ret

0000000080002f6c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f6c:	457c                	lw	a5,76(a0)
    80002f6e:	0ed7e963          	bltu	a5,a3,80003060 <readi+0xf4>
{
    80002f72:	7159                	addi	sp,sp,-112
    80002f74:	f486                	sd	ra,104(sp)
    80002f76:	f0a2                	sd	s0,96(sp)
    80002f78:	eca6                	sd	s1,88(sp)
    80002f7a:	e8ca                	sd	s2,80(sp)
    80002f7c:	e4ce                	sd	s3,72(sp)
    80002f7e:	e0d2                	sd	s4,64(sp)
    80002f80:	fc56                	sd	s5,56(sp)
    80002f82:	f85a                	sd	s6,48(sp)
    80002f84:	f45e                	sd	s7,40(sp)
    80002f86:	f062                	sd	s8,32(sp)
    80002f88:	ec66                	sd	s9,24(sp)
    80002f8a:	e86a                	sd	s10,16(sp)
    80002f8c:	e46e                	sd	s11,8(sp)
    80002f8e:	1880                	addi	s0,sp,112
    80002f90:	8b2a                	mv	s6,a0
    80002f92:	8bae                	mv	s7,a1
    80002f94:	8a32                	mv	s4,a2
    80002f96:	84b6                	mv	s1,a3
    80002f98:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f9a:	9f35                	addw	a4,a4,a3
    return 0;
    80002f9c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f9e:	0ad76063          	bltu	a4,a3,8000303e <readi+0xd2>
  if(off + n > ip->size)
    80002fa2:	00e7f463          	bgeu	a5,a4,80002faa <readi+0x3e>
    n = ip->size - off;
    80002fa6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002faa:	0a0a8963          	beqz	s5,8000305c <readi+0xf0>
    80002fae:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fb0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fb4:	5c7d                	li	s8,-1
    80002fb6:	a82d                	j	80002ff0 <readi+0x84>
    80002fb8:	020d1d93          	slli	s11,s10,0x20
    80002fbc:	020ddd93          	srli	s11,s11,0x20
    80002fc0:	05890613          	addi	a2,s2,88
    80002fc4:	86ee                	mv	a3,s11
    80002fc6:	963a                	add	a2,a2,a4
    80002fc8:	85d2                	mv	a1,s4
    80002fca:	855e                	mv	a0,s7
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	a12080e7          	jalr	-1518(ra) # 800019de <either_copyout>
    80002fd4:	05850d63          	beq	a0,s8,8000302e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fd8:	854a                	mv	a0,s2
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	5f6080e7          	jalr	1526(ra) # 800025d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe2:	013d09bb          	addw	s3,s10,s3
    80002fe6:	009d04bb          	addw	s1,s10,s1
    80002fea:	9a6e                	add	s4,s4,s11
    80002fec:	0559f763          	bgeu	s3,s5,8000303a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002ff0:	00a4d59b          	srliw	a1,s1,0xa
    80002ff4:	855a                	mv	a0,s6
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	89e080e7          	jalr	-1890(ra) # 80002894 <bmap>
    80002ffe:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003002:	cd85                	beqz	a1,8000303a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003004:	000b2503          	lw	a0,0(s6)
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	498080e7          	jalr	1176(ra) # 800024a0 <bread>
    80003010:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003012:	3ff4f713          	andi	a4,s1,1023
    80003016:	40ec87bb          	subw	a5,s9,a4
    8000301a:	413a86bb          	subw	a3,s5,s3
    8000301e:	8d3e                	mv	s10,a5
    80003020:	2781                	sext.w	a5,a5
    80003022:	0006861b          	sext.w	a2,a3
    80003026:	f8f679e3          	bgeu	a2,a5,80002fb8 <readi+0x4c>
    8000302a:	8d36                	mv	s10,a3
    8000302c:	b771                	j	80002fb8 <readi+0x4c>
      brelse(bp);
    8000302e:	854a                	mv	a0,s2
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	5a0080e7          	jalr	1440(ra) # 800025d0 <brelse>
      tot = -1;
    80003038:	59fd                	li	s3,-1
  }
  return tot;
    8000303a:	0009851b          	sext.w	a0,s3
}
    8000303e:	70a6                	ld	ra,104(sp)
    80003040:	7406                	ld	s0,96(sp)
    80003042:	64e6                	ld	s1,88(sp)
    80003044:	6946                	ld	s2,80(sp)
    80003046:	69a6                	ld	s3,72(sp)
    80003048:	6a06                	ld	s4,64(sp)
    8000304a:	7ae2                	ld	s5,56(sp)
    8000304c:	7b42                	ld	s6,48(sp)
    8000304e:	7ba2                	ld	s7,40(sp)
    80003050:	7c02                	ld	s8,32(sp)
    80003052:	6ce2                	ld	s9,24(sp)
    80003054:	6d42                	ld	s10,16(sp)
    80003056:	6da2                	ld	s11,8(sp)
    80003058:	6165                	addi	sp,sp,112
    8000305a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000305c:	89d6                	mv	s3,s5
    8000305e:	bff1                	j	8000303a <readi+0xce>
    return 0;
    80003060:	4501                	li	a0,0
}
    80003062:	8082                	ret

0000000080003064 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003064:	457c                	lw	a5,76(a0)
    80003066:	10d7e863          	bltu	a5,a3,80003176 <writei+0x112>
{
    8000306a:	7159                	addi	sp,sp,-112
    8000306c:	f486                	sd	ra,104(sp)
    8000306e:	f0a2                	sd	s0,96(sp)
    80003070:	eca6                	sd	s1,88(sp)
    80003072:	e8ca                	sd	s2,80(sp)
    80003074:	e4ce                	sd	s3,72(sp)
    80003076:	e0d2                	sd	s4,64(sp)
    80003078:	fc56                	sd	s5,56(sp)
    8000307a:	f85a                	sd	s6,48(sp)
    8000307c:	f45e                	sd	s7,40(sp)
    8000307e:	f062                	sd	s8,32(sp)
    80003080:	ec66                	sd	s9,24(sp)
    80003082:	e86a                	sd	s10,16(sp)
    80003084:	e46e                	sd	s11,8(sp)
    80003086:	1880                	addi	s0,sp,112
    80003088:	8aaa                	mv	s5,a0
    8000308a:	8bae                	mv	s7,a1
    8000308c:	8a32                	mv	s4,a2
    8000308e:	8936                	mv	s2,a3
    80003090:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003092:	00e687bb          	addw	a5,a3,a4
    80003096:	0ed7e263          	bltu	a5,a3,8000317a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000309a:	00043737          	lui	a4,0x43
    8000309e:	0ef76063          	bltu	a4,a5,8000317e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a2:	0c0b0863          	beqz	s6,80003172 <writei+0x10e>
    800030a6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030ac:	5c7d                	li	s8,-1
    800030ae:	a091                	j	800030f2 <writei+0x8e>
    800030b0:	020d1d93          	slli	s11,s10,0x20
    800030b4:	020ddd93          	srli	s11,s11,0x20
    800030b8:	05848513          	addi	a0,s1,88
    800030bc:	86ee                	mv	a3,s11
    800030be:	8652                	mv	a2,s4
    800030c0:	85de                	mv	a1,s7
    800030c2:	953a                	add	a0,a0,a4
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	970080e7          	jalr	-1680(ra) # 80001a34 <either_copyin>
    800030cc:	07850263          	beq	a0,s8,80003130 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030d0:	8526                	mv	a0,s1
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	788080e7          	jalr	1928(ra) # 8000385a <log_write>
    brelse(bp);
    800030da:	8526                	mv	a0,s1
    800030dc:	fffff097          	auipc	ra,0xfffff
    800030e0:	4f4080e7          	jalr	1268(ra) # 800025d0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030e4:	013d09bb          	addw	s3,s10,s3
    800030e8:	012d093b          	addw	s2,s10,s2
    800030ec:	9a6e                	add	s4,s4,s11
    800030ee:	0569f663          	bgeu	s3,s6,8000313a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030f2:	00a9559b          	srliw	a1,s2,0xa
    800030f6:	8556                	mv	a0,s5
    800030f8:	fffff097          	auipc	ra,0xfffff
    800030fc:	79c080e7          	jalr	1948(ra) # 80002894 <bmap>
    80003100:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003104:	c99d                	beqz	a1,8000313a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003106:	000aa503          	lw	a0,0(s5)
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	396080e7          	jalr	918(ra) # 800024a0 <bread>
    80003112:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003114:	3ff97713          	andi	a4,s2,1023
    80003118:	40ec87bb          	subw	a5,s9,a4
    8000311c:	413b06bb          	subw	a3,s6,s3
    80003120:	8d3e                	mv	s10,a5
    80003122:	2781                	sext.w	a5,a5
    80003124:	0006861b          	sext.w	a2,a3
    80003128:	f8f674e3          	bgeu	a2,a5,800030b0 <writei+0x4c>
    8000312c:	8d36                	mv	s10,a3
    8000312e:	b749                	j	800030b0 <writei+0x4c>
      brelse(bp);
    80003130:	8526                	mv	a0,s1
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	49e080e7          	jalr	1182(ra) # 800025d0 <brelse>
  }

  if(off > ip->size)
    8000313a:	04caa783          	lw	a5,76(s5)
    8000313e:	0127f463          	bgeu	a5,s2,80003146 <writei+0xe2>
    ip->size = off;
    80003142:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003146:	8556                	mv	a0,s5
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	aa4080e7          	jalr	-1372(ra) # 80002bec <iupdate>

  return tot;
    80003150:	0009851b          	sext.w	a0,s3
}
    80003154:	70a6                	ld	ra,104(sp)
    80003156:	7406                	ld	s0,96(sp)
    80003158:	64e6                	ld	s1,88(sp)
    8000315a:	6946                	ld	s2,80(sp)
    8000315c:	69a6                	ld	s3,72(sp)
    8000315e:	6a06                	ld	s4,64(sp)
    80003160:	7ae2                	ld	s5,56(sp)
    80003162:	7b42                	ld	s6,48(sp)
    80003164:	7ba2                	ld	s7,40(sp)
    80003166:	7c02                	ld	s8,32(sp)
    80003168:	6ce2                	ld	s9,24(sp)
    8000316a:	6d42                	ld	s10,16(sp)
    8000316c:	6da2                	ld	s11,8(sp)
    8000316e:	6165                	addi	sp,sp,112
    80003170:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003172:	89da                	mv	s3,s6
    80003174:	bfc9                	j	80003146 <writei+0xe2>
    return -1;
    80003176:	557d                	li	a0,-1
}
    80003178:	8082                	ret
    return -1;
    8000317a:	557d                	li	a0,-1
    8000317c:	bfe1                	j	80003154 <writei+0xf0>
    return -1;
    8000317e:	557d                	li	a0,-1
    80003180:	bfd1                	j	80003154 <writei+0xf0>

0000000080003182 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003182:	1141                	addi	sp,sp,-16
    80003184:	e406                	sd	ra,8(sp)
    80003186:	e022                	sd	s0,0(sp)
    80003188:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000318a:	4639                	li	a2,14
    8000318c:	ffffd097          	auipc	ra,0xffffd
    80003190:	1b4080e7          	jalr	436(ra) # 80000340 <strncmp>
}
    80003194:	60a2                	ld	ra,8(sp)
    80003196:	6402                	ld	s0,0(sp)
    80003198:	0141                	addi	sp,sp,16
    8000319a:	8082                	ret

000000008000319c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000319c:	7139                	addi	sp,sp,-64
    8000319e:	fc06                	sd	ra,56(sp)
    800031a0:	f822                	sd	s0,48(sp)
    800031a2:	f426                	sd	s1,40(sp)
    800031a4:	f04a                	sd	s2,32(sp)
    800031a6:	ec4e                	sd	s3,24(sp)
    800031a8:	e852                	sd	s4,16(sp)
    800031aa:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031ac:	04451703          	lh	a4,68(a0)
    800031b0:	4785                	li	a5,1
    800031b2:	00f71a63          	bne	a4,a5,800031c6 <dirlookup+0x2a>
    800031b6:	892a                	mv	s2,a0
    800031b8:	89ae                	mv	s3,a1
    800031ba:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031bc:	457c                	lw	a5,76(a0)
    800031be:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031c0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c2:	e79d                	bnez	a5,800031f0 <dirlookup+0x54>
    800031c4:	a8a5                	j	8000323c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031c6:	00005517          	auipc	a0,0x5
    800031ca:	39a50513          	addi	a0,a0,922 # 80008560 <syscalls+0x1a0>
    800031ce:	00003097          	auipc	ra,0x3
    800031d2:	b9e080e7          	jalr	-1122(ra) # 80005d6c <panic>
      panic("dirlookup read");
    800031d6:	00005517          	auipc	a0,0x5
    800031da:	3a250513          	addi	a0,a0,930 # 80008578 <syscalls+0x1b8>
    800031de:	00003097          	auipc	ra,0x3
    800031e2:	b8e080e7          	jalr	-1138(ra) # 80005d6c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e6:	24c1                	addiw	s1,s1,16
    800031e8:	04c92783          	lw	a5,76(s2)
    800031ec:	04f4f763          	bgeu	s1,a5,8000323a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f0:	4741                	li	a4,16
    800031f2:	86a6                	mv	a3,s1
    800031f4:	fc040613          	addi	a2,s0,-64
    800031f8:	4581                	li	a1,0
    800031fa:	854a                	mv	a0,s2
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	d70080e7          	jalr	-656(ra) # 80002f6c <readi>
    80003204:	47c1                	li	a5,16
    80003206:	fcf518e3          	bne	a0,a5,800031d6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000320a:	fc045783          	lhu	a5,-64(s0)
    8000320e:	dfe1                	beqz	a5,800031e6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003210:	fc240593          	addi	a1,s0,-62
    80003214:	854e                	mv	a0,s3
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	f6c080e7          	jalr	-148(ra) # 80003182 <namecmp>
    8000321e:	f561                	bnez	a0,800031e6 <dirlookup+0x4a>
      if(poff)
    80003220:	000a0463          	beqz	s4,80003228 <dirlookup+0x8c>
        *poff = off;
    80003224:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003228:	fc045583          	lhu	a1,-64(s0)
    8000322c:	00092503          	lw	a0,0(s2)
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	74e080e7          	jalr	1870(ra) # 8000297e <iget>
    80003238:	a011                	j	8000323c <dirlookup+0xa0>
  return 0;
    8000323a:	4501                	li	a0,0
}
    8000323c:	70e2                	ld	ra,56(sp)
    8000323e:	7442                	ld	s0,48(sp)
    80003240:	74a2                	ld	s1,40(sp)
    80003242:	7902                	ld	s2,32(sp)
    80003244:	69e2                	ld	s3,24(sp)
    80003246:	6a42                	ld	s4,16(sp)
    80003248:	6121                	addi	sp,sp,64
    8000324a:	8082                	ret

000000008000324c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000324c:	711d                	addi	sp,sp,-96
    8000324e:	ec86                	sd	ra,88(sp)
    80003250:	e8a2                	sd	s0,80(sp)
    80003252:	e4a6                	sd	s1,72(sp)
    80003254:	e0ca                	sd	s2,64(sp)
    80003256:	fc4e                	sd	s3,56(sp)
    80003258:	f852                	sd	s4,48(sp)
    8000325a:	f456                	sd	s5,40(sp)
    8000325c:	f05a                	sd	s6,32(sp)
    8000325e:	ec5e                	sd	s7,24(sp)
    80003260:	e862                	sd	s8,16(sp)
    80003262:	e466                	sd	s9,8(sp)
    80003264:	e06a                	sd	s10,0(sp)
    80003266:	1080                	addi	s0,sp,96
    80003268:	84aa                	mv	s1,a0
    8000326a:	8b2e                	mv	s6,a1
    8000326c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000326e:	00054703          	lbu	a4,0(a0)
    80003272:	02f00793          	li	a5,47
    80003276:	02f70363          	beq	a4,a5,8000329c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000327a:	ffffe097          	auipc	ra,0xffffe
    8000327e:	cb4080e7          	jalr	-844(ra) # 80000f2e <myproc>
    80003282:	15053503          	ld	a0,336(a0)
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	9f4080e7          	jalr	-1548(ra) # 80002c7a <idup>
    8000328e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003290:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003294:	4cb5                	li	s9,13
  len = path - s;
    80003296:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003298:	4c05                	li	s8,1
    8000329a:	a87d                	j	80003358 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000329c:	4585                	li	a1,1
    8000329e:	4505                	li	a0,1
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	6de080e7          	jalr	1758(ra) # 8000297e <iget>
    800032a8:	8a2a                	mv	s4,a0
    800032aa:	b7dd                	j	80003290 <namex+0x44>
      iunlockput(ip);
    800032ac:	8552                	mv	a0,s4
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	c6c080e7          	jalr	-916(ra) # 80002f1a <iunlockput>
      return 0;
    800032b6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032b8:	8552                	mv	a0,s4
    800032ba:	60e6                	ld	ra,88(sp)
    800032bc:	6446                	ld	s0,80(sp)
    800032be:	64a6                	ld	s1,72(sp)
    800032c0:	6906                	ld	s2,64(sp)
    800032c2:	79e2                	ld	s3,56(sp)
    800032c4:	7a42                	ld	s4,48(sp)
    800032c6:	7aa2                	ld	s5,40(sp)
    800032c8:	7b02                	ld	s6,32(sp)
    800032ca:	6be2                	ld	s7,24(sp)
    800032cc:	6c42                	ld	s8,16(sp)
    800032ce:	6ca2                	ld	s9,8(sp)
    800032d0:	6d02                	ld	s10,0(sp)
    800032d2:	6125                	addi	sp,sp,96
    800032d4:	8082                	ret
      iunlock(ip);
    800032d6:	8552                	mv	a0,s4
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	aa2080e7          	jalr	-1374(ra) # 80002d7a <iunlock>
      return ip;
    800032e0:	bfe1                	j	800032b8 <namex+0x6c>
      iunlockput(ip);
    800032e2:	8552                	mv	a0,s4
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	c36080e7          	jalr	-970(ra) # 80002f1a <iunlockput>
      return 0;
    800032ec:	8a4e                	mv	s4,s3
    800032ee:	b7e9                	j	800032b8 <namex+0x6c>
  len = path - s;
    800032f0:	40998633          	sub	a2,s3,s1
    800032f4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032f8:	09acd863          	bge	s9,s10,80003388 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032fc:	4639                	li	a2,14
    800032fe:	85a6                	mv	a1,s1
    80003300:	8556                	mv	a0,s5
    80003302:	ffffd097          	auipc	ra,0xffffd
    80003306:	fca080e7          	jalr	-54(ra) # 800002cc <memmove>
    8000330a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000330c:	0004c783          	lbu	a5,0(s1)
    80003310:	01279763          	bne	a5,s2,8000331e <namex+0xd2>
    path++;
    80003314:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003316:	0004c783          	lbu	a5,0(s1)
    8000331a:	ff278de3          	beq	a5,s2,80003314 <namex+0xc8>
    ilock(ip);
    8000331e:	8552                	mv	a0,s4
    80003320:	00000097          	auipc	ra,0x0
    80003324:	998080e7          	jalr	-1640(ra) # 80002cb8 <ilock>
    if(ip->type != T_DIR){
    80003328:	044a1783          	lh	a5,68(s4)
    8000332c:	f98790e3          	bne	a5,s8,800032ac <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003330:	000b0563          	beqz	s6,8000333a <namex+0xee>
    80003334:	0004c783          	lbu	a5,0(s1)
    80003338:	dfd9                	beqz	a5,800032d6 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000333a:	865e                	mv	a2,s7
    8000333c:	85d6                	mv	a1,s5
    8000333e:	8552                	mv	a0,s4
    80003340:	00000097          	auipc	ra,0x0
    80003344:	e5c080e7          	jalr	-420(ra) # 8000319c <dirlookup>
    80003348:	89aa                	mv	s3,a0
    8000334a:	dd41                	beqz	a0,800032e2 <namex+0x96>
    iunlockput(ip);
    8000334c:	8552                	mv	a0,s4
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	bcc080e7          	jalr	-1076(ra) # 80002f1a <iunlockput>
    ip = next;
    80003356:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003358:	0004c783          	lbu	a5,0(s1)
    8000335c:	01279763          	bne	a5,s2,8000336a <namex+0x11e>
    path++;
    80003360:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003362:	0004c783          	lbu	a5,0(s1)
    80003366:	ff278de3          	beq	a5,s2,80003360 <namex+0x114>
  if(*path == 0)
    8000336a:	cb9d                	beqz	a5,800033a0 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000336c:	0004c783          	lbu	a5,0(s1)
    80003370:	89a6                	mv	s3,s1
  len = path - s;
    80003372:	8d5e                	mv	s10,s7
    80003374:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003376:	01278963          	beq	a5,s2,80003388 <namex+0x13c>
    8000337a:	dbbd                	beqz	a5,800032f0 <namex+0xa4>
    path++;
    8000337c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000337e:	0009c783          	lbu	a5,0(s3)
    80003382:	ff279ce3          	bne	a5,s2,8000337a <namex+0x12e>
    80003386:	b7ad                	j	800032f0 <namex+0xa4>
    memmove(name, s, len);
    80003388:	2601                	sext.w	a2,a2
    8000338a:	85a6                	mv	a1,s1
    8000338c:	8556                	mv	a0,s5
    8000338e:	ffffd097          	auipc	ra,0xffffd
    80003392:	f3e080e7          	jalr	-194(ra) # 800002cc <memmove>
    name[len] = 0;
    80003396:	9d56                	add	s10,s10,s5
    80003398:	000d0023          	sb	zero,0(s10)
    8000339c:	84ce                	mv	s1,s3
    8000339e:	b7bd                	j	8000330c <namex+0xc0>
  if(nameiparent){
    800033a0:	f00b0ce3          	beqz	s6,800032b8 <namex+0x6c>
    iput(ip);
    800033a4:	8552                	mv	a0,s4
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	acc080e7          	jalr	-1332(ra) # 80002e72 <iput>
    return 0;
    800033ae:	4a01                	li	s4,0
    800033b0:	b721                	j	800032b8 <namex+0x6c>

00000000800033b2 <dirlink>:
{
    800033b2:	7139                	addi	sp,sp,-64
    800033b4:	fc06                	sd	ra,56(sp)
    800033b6:	f822                	sd	s0,48(sp)
    800033b8:	f426                	sd	s1,40(sp)
    800033ba:	f04a                	sd	s2,32(sp)
    800033bc:	ec4e                	sd	s3,24(sp)
    800033be:	e852                	sd	s4,16(sp)
    800033c0:	0080                	addi	s0,sp,64
    800033c2:	892a                	mv	s2,a0
    800033c4:	8a2e                	mv	s4,a1
    800033c6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033c8:	4601                	li	a2,0
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	dd2080e7          	jalr	-558(ra) # 8000319c <dirlookup>
    800033d2:	e93d                	bnez	a0,80003448 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d4:	04c92483          	lw	s1,76(s2)
    800033d8:	c49d                	beqz	s1,80003406 <dirlink+0x54>
    800033da:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033dc:	4741                	li	a4,16
    800033de:	86a6                	mv	a3,s1
    800033e0:	fc040613          	addi	a2,s0,-64
    800033e4:	4581                	li	a1,0
    800033e6:	854a                	mv	a0,s2
    800033e8:	00000097          	auipc	ra,0x0
    800033ec:	b84080e7          	jalr	-1148(ra) # 80002f6c <readi>
    800033f0:	47c1                	li	a5,16
    800033f2:	06f51163          	bne	a0,a5,80003454 <dirlink+0xa2>
    if(de.inum == 0)
    800033f6:	fc045783          	lhu	a5,-64(s0)
    800033fa:	c791                	beqz	a5,80003406 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033fc:	24c1                	addiw	s1,s1,16
    800033fe:	04c92783          	lw	a5,76(s2)
    80003402:	fcf4ede3          	bltu	s1,a5,800033dc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003406:	4639                	li	a2,14
    80003408:	85d2                	mv	a1,s4
    8000340a:	fc240513          	addi	a0,s0,-62
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	f6e080e7          	jalr	-146(ra) # 8000037c <strncpy>
  de.inum = inum;
    80003416:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000341a:	4741                	li	a4,16
    8000341c:	86a6                	mv	a3,s1
    8000341e:	fc040613          	addi	a2,s0,-64
    80003422:	4581                	li	a1,0
    80003424:	854a                	mv	a0,s2
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	c3e080e7          	jalr	-962(ra) # 80003064 <writei>
    8000342e:	1541                	addi	a0,a0,-16
    80003430:	00a03533          	snez	a0,a0
    80003434:	40a00533          	neg	a0,a0
}
    80003438:	70e2                	ld	ra,56(sp)
    8000343a:	7442                	ld	s0,48(sp)
    8000343c:	74a2                	ld	s1,40(sp)
    8000343e:	7902                	ld	s2,32(sp)
    80003440:	69e2                	ld	s3,24(sp)
    80003442:	6a42                	ld	s4,16(sp)
    80003444:	6121                	addi	sp,sp,64
    80003446:	8082                	ret
    iput(ip);
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	a2a080e7          	jalr	-1494(ra) # 80002e72 <iput>
    return -1;
    80003450:	557d                	li	a0,-1
    80003452:	b7dd                	j	80003438 <dirlink+0x86>
      panic("dirlink read");
    80003454:	00005517          	auipc	a0,0x5
    80003458:	13450513          	addi	a0,a0,308 # 80008588 <syscalls+0x1c8>
    8000345c:	00003097          	auipc	ra,0x3
    80003460:	910080e7          	jalr	-1776(ra) # 80005d6c <panic>

0000000080003464 <namei>:

struct inode*
namei(char *path)
{
    80003464:	1101                	addi	sp,sp,-32
    80003466:	ec06                	sd	ra,24(sp)
    80003468:	e822                	sd	s0,16(sp)
    8000346a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000346c:	fe040613          	addi	a2,s0,-32
    80003470:	4581                	li	a1,0
    80003472:	00000097          	auipc	ra,0x0
    80003476:	dda080e7          	jalr	-550(ra) # 8000324c <namex>
}
    8000347a:	60e2                	ld	ra,24(sp)
    8000347c:	6442                	ld	s0,16(sp)
    8000347e:	6105                	addi	sp,sp,32
    80003480:	8082                	ret

0000000080003482 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003482:	1141                	addi	sp,sp,-16
    80003484:	e406                	sd	ra,8(sp)
    80003486:	e022                	sd	s0,0(sp)
    80003488:	0800                	addi	s0,sp,16
    8000348a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000348c:	4585                	li	a1,1
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	dbe080e7          	jalr	-578(ra) # 8000324c <namex>
}
    80003496:	60a2                	ld	ra,8(sp)
    80003498:	6402                	ld	s0,0(sp)
    8000349a:	0141                	addi	sp,sp,16
    8000349c:	8082                	ret

000000008000349e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000349e:	1101                	addi	sp,sp,-32
    800034a0:	ec06                	sd	ra,24(sp)
    800034a2:	e822                	sd	s0,16(sp)
    800034a4:	e426                	sd	s1,8(sp)
    800034a6:	e04a                	sd	s2,0(sp)
    800034a8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034aa:	00035917          	auipc	s2,0x35
    800034ae:	42690913          	addi	s2,s2,1062 # 800388d0 <log>
    800034b2:	01892583          	lw	a1,24(s2)
    800034b6:	02892503          	lw	a0,40(s2)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	fe6080e7          	jalr	-26(ra) # 800024a0 <bread>
    800034c2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034c4:	02c92683          	lw	a3,44(s2)
    800034c8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034ca:	02d05863          	blez	a3,800034fa <write_head+0x5c>
    800034ce:	00035797          	auipc	a5,0x35
    800034d2:	43278793          	addi	a5,a5,1074 # 80038900 <log+0x30>
    800034d6:	05c50713          	addi	a4,a0,92
    800034da:	36fd                	addiw	a3,a3,-1
    800034dc:	02069613          	slli	a2,a3,0x20
    800034e0:	01e65693          	srli	a3,a2,0x1e
    800034e4:	00035617          	auipc	a2,0x35
    800034e8:	42060613          	addi	a2,a2,1056 # 80038904 <log+0x34>
    800034ec:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034ee:	4390                	lw	a2,0(a5)
    800034f0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034f2:	0791                	addi	a5,a5,4
    800034f4:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800034f6:	fed79ce3          	bne	a5,a3,800034ee <write_head+0x50>
  }
  bwrite(buf);
    800034fa:	8526                	mv	a0,s1
    800034fc:	fffff097          	auipc	ra,0xfffff
    80003500:	096080e7          	jalr	150(ra) # 80002592 <bwrite>
  brelse(buf);
    80003504:	8526                	mv	a0,s1
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	0ca080e7          	jalr	202(ra) # 800025d0 <brelse>
}
    8000350e:	60e2                	ld	ra,24(sp)
    80003510:	6442                	ld	s0,16(sp)
    80003512:	64a2                	ld	s1,8(sp)
    80003514:	6902                	ld	s2,0(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret

000000008000351a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000351a:	00035797          	auipc	a5,0x35
    8000351e:	3e27a783          	lw	a5,994(a5) # 800388fc <log+0x2c>
    80003522:	0af05d63          	blez	a5,800035dc <install_trans+0xc2>
{
    80003526:	7139                	addi	sp,sp,-64
    80003528:	fc06                	sd	ra,56(sp)
    8000352a:	f822                	sd	s0,48(sp)
    8000352c:	f426                	sd	s1,40(sp)
    8000352e:	f04a                	sd	s2,32(sp)
    80003530:	ec4e                	sd	s3,24(sp)
    80003532:	e852                	sd	s4,16(sp)
    80003534:	e456                	sd	s5,8(sp)
    80003536:	e05a                	sd	s6,0(sp)
    80003538:	0080                	addi	s0,sp,64
    8000353a:	8b2a                	mv	s6,a0
    8000353c:	00035a97          	auipc	s5,0x35
    80003540:	3c4a8a93          	addi	s5,s5,964 # 80038900 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003544:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003546:	00035997          	auipc	s3,0x35
    8000354a:	38a98993          	addi	s3,s3,906 # 800388d0 <log>
    8000354e:	a00d                	j	80003570 <install_trans+0x56>
    brelse(lbuf);
    80003550:	854a                	mv	a0,s2
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	07e080e7          	jalr	126(ra) # 800025d0 <brelse>
    brelse(dbuf);
    8000355a:	8526                	mv	a0,s1
    8000355c:	fffff097          	auipc	ra,0xfffff
    80003560:	074080e7          	jalr	116(ra) # 800025d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003564:	2a05                	addiw	s4,s4,1
    80003566:	0a91                	addi	s5,s5,4
    80003568:	02c9a783          	lw	a5,44(s3)
    8000356c:	04fa5e63          	bge	s4,a5,800035c8 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003570:	0189a583          	lw	a1,24(s3)
    80003574:	014585bb          	addw	a1,a1,s4
    80003578:	2585                	addiw	a1,a1,1
    8000357a:	0289a503          	lw	a0,40(s3)
    8000357e:	fffff097          	auipc	ra,0xfffff
    80003582:	f22080e7          	jalr	-222(ra) # 800024a0 <bread>
    80003586:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003588:	000aa583          	lw	a1,0(s5)
    8000358c:	0289a503          	lw	a0,40(s3)
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	f10080e7          	jalr	-240(ra) # 800024a0 <bread>
    80003598:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000359a:	40000613          	li	a2,1024
    8000359e:	05890593          	addi	a1,s2,88
    800035a2:	05850513          	addi	a0,a0,88
    800035a6:	ffffd097          	auipc	ra,0xffffd
    800035aa:	d26080e7          	jalr	-730(ra) # 800002cc <memmove>
    bwrite(dbuf);  // write dst to disk
    800035ae:	8526                	mv	a0,s1
    800035b0:	fffff097          	auipc	ra,0xfffff
    800035b4:	fe2080e7          	jalr	-30(ra) # 80002592 <bwrite>
    if(recovering == 0)
    800035b8:	f80b1ce3          	bnez	s6,80003550 <install_trans+0x36>
      bunpin(dbuf);
    800035bc:	8526                	mv	a0,s1
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	0ec080e7          	jalr	236(ra) # 800026aa <bunpin>
    800035c6:	b769                	j	80003550 <install_trans+0x36>
}
    800035c8:	70e2                	ld	ra,56(sp)
    800035ca:	7442                	ld	s0,48(sp)
    800035cc:	74a2                	ld	s1,40(sp)
    800035ce:	7902                	ld	s2,32(sp)
    800035d0:	69e2                	ld	s3,24(sp)
    800035d2:	6a42                	ld	s4,16(sp)
    800035d4:	6aa2                	ld	s5,8(sp)
    800035d6:	6b02                	ld	s6,0(sp)
    800035d8:	6121                	addi	sp,sp,64
    800035da:	8082                	ret
    800035dc:	8082                	ret

00000000800035de <initlog>:
{
    800035de:	7179                	addi	sp,sp,-48
    800035e0:	f406                	sd	ra,40(sp)
    800035e2:	f022                	sd	s0,32(sp)
    800035e4:	ec26                	sd	s1,24(sp)
    800035e6:	e84a                	sd	s2,16(sp)
    800035e8:	e44e                	sd	s3,8(sp)
    800035ea:	1800                	addi	s0,sp,48
    800035ec:	892a                	mv	s2,a0
    800035ee:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035f0:	00035497          	auipc	s1,0x35
    800035f4:	2e048493          	addi	s1,s1,736 # 800388d0 <log>
    800035f8:	00005597          	auipc	a1,0x5
    800035fc:	fa058593          	addi	a1,a1,-96 # 80008598 <syscalls+0x1d8>
    80003600:	8526                	mv	a0,s1
    80003602:	00003097          	auipc	ra,0x3
    80003606:	c62080e7          	jalr	-926(ra) # 80006264 <initlock>
  log.start = sb->logstart;
    8000360a:	0149a583          	lw	a1,20(s3)
    8000360e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003610:	0109a783          	lw	a5,16(s3)
    80003614:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003616:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000361a:	854a                	mv	a0,s2
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	e84080e7          	jalr	-380(ra) # 800024a0 <bread>
  log.lh.n = lh->n;
    80003624:	4d34                	lw	a3,88(a0)
    80003626:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003628:	02d05663          	blez	a3,80003654 <initlog+0x76>
    8000362c:	05c50793          	addi	a5,a0,92
    80003630:	00035717          	auipc	a4,0x35
    80003634:	2d070713          	addi	a4,a4,720 # 80038900 <log+0x30>
    80003638:	36fd                	addiw	a3,a3,-1
    8000363a:	02069613          	slli	a2,a3,0x20
    8000363e:	01e65693          	srli	a3,a2,0x1e
    80003642:	06050613          	addi	a2,a0,96
    80003646:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003648:	4390                	lw	a2,0(a5)
    8000364a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000364c:	0791                	addi	a5,a5,4
    8000364e:	0711                	addi	a4,a4,4
    80003650:	fed79ce3          	bne	a5,a3,80003648 <initlog+0x6a>
  brelse(buf);
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	f7c080e7          	jalr	-132(ra) # 800025d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000365c:	4505                	li	a0,1
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	ebc080e7          	jalr	-324(ra) # 8000351a <install_trans>
  log.lh.n = 0;
    80003666:	00035797          	auipc	a5,0x35
    8000366a:	2807ab23          	sw	zero,662(a5) # 800388fc <log+0x2c>
  write_head(); // clear the log
    8000366e:	00000097          	auipc	ra,0x0
    80003672:	e30080e7          	jalr	-464(ra) # 8000349e <write_head>
}
    80003676:	70a2                	ld	ra,40(sp)
    80003678:	7402                	ld	s0,32(sp)
    8000367a:	64e2                	ld	s1,24(sp)
    8000367c:	6942                	ld	s2,16(sp)
    8000367e:	69a2                	ld	s3,8(sp)
    80003680:	6145                	addi	sp,sp,48
    80003682:	8082                	ret

0000000080003684 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003690:	00035517          	auipc	a0,0x35
    80003694:	24050513          	addi	a0,a0,576 # 800388d0 <log>
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	c5c080e7          	jalr	-932(ra) # 800062f4 <acquire>
  while(1){
    if(log.committing){
    800036a0:	00035497          	auipc	s1,0x35
    800036a4:	23048493          	addi	s1,s1,560 # 800388d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a8:	4979                	li	s2,30
    800036aa:	a039                	j	800036b8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036ac:	85a6                	mv	a1,s1
    800036ae:	8526                	mv	a0,s1
    800036b0:	ffffe097          	auipc	ra,0xffffe
    800036b4:	f26080e7          	jalr	-218(ra) # 800015d6 <sleep>
    if(log.committing){
    800036b8:	50dc                	lw	a5,36(s1)
    800036ba:	fbed                	bnez	a5,800036ac <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036bc:	5098                	lw	a4,32(s1)
    800036be:	2705                	addiw	a4,a4,1
    800036c0:	0007069b          	sext.w	a3,a4
    800036c4:	0027179b          	slliw	a5,a4,0x2
    800036c8:	9fb9                	addw	a5,a5,a4
    800036ca:	0017979b          	slliw	a5,a5,0x1
    800036ce:	54d8                	lw	a4,44(s1)
    800036d0:	9fb9                	addw	a5,a5,a4
    800036d2:	00f95963          	bge	s2,a5,800036e4 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036d6:	85a6                	mv	a1,s1
    800036d8:	8526                	mv	a0,s1
    800036da:	ffffe097          	auipc	ra,0xffffe
    800036de:	efc080e7          	jalr	-260(ra) # 800015d6 <sleep>
    800036e2:	bfd9                	j	800036b8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036e4:	00035517          	auipc	a0,0x35
    800036e8:	1ec50513          	addi	a0,a0,492 # 800388d0 <log>
    800036ec:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	cba080e7          	jalr	-838(ra) # 800063a8 <release>
      break;
    }
  }
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6902                	ld	s2,0(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret

0000000080003702 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003702:	7139                	addi	sp,sp,-64
    80003704:	fc06                	sd	ra,56(sp)
    80003706:	f822                	sd	s0,48(sp)
    80003708:	f426                	sd	s1,40(sp)
    8000370a:	f04a                	sd	s2,32(sp)
    8000370c:	ec4e                	sd	s3,24(sp)
    8000370e:	e852                	sd	s4,16(sp)
    80003710:	e456                	sd	s5,8(sp)
    80003712:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003714:	00035497          	auipc	s1,0x35
    80003718:	1bc48493          	addi	s1,s1,444 # 800388d0 <log>
    8000371c:	8526                	mv	a0,s1
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	bd6080e7          	jalr	-1066(ra) # 800062f4 <acquire>
  log.outstanding -= 1;
    80003726:	509c                	lw	a5,32(s1)
    80003728:	37fd                	addiw	a5,a5,-1
    8000372a:	0007891b          	sext.w	s2,a5
    8000372e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003730:	50dc                	lw	a5,36(s1)
    80003732:	e7b9                	bnez	a5,80003780 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003734:	04091e63          	bnez	s2,80003790 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003738:	00035497          	auipc	s1,0x35
    8000373c:	19848493          	addi	s1,s1,408 # 800388d0 <log>
    80003740:	4785                	li	a5,1
    80003742:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003744:	8526                	mv	a0,s1
    80003746:	00003097          	auipc	ra,0x3
    8000374a:	c62080e7          	jalr	-926(ra) # 800063a8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000374e:	54dc                	lw	a5,44(s1)
    80003750:	06f04763          	bgtz	a5,800037be <end_op+0xbc>
    acquire(&log.lock);
    80003754:	00035497          	auipc	s1,0x35
    80003758:	17c48493          	addi	s1,s1,380 # 800388d0 <log>
    8000375c:	8526                	mv	a0,s1
    8000375e:	00003097          	auipc	ra,0x3
    80003762:	b96080e7          	jalr	-1130(ra) # 800062f4 <acquire>
    log.committing = 0;
    80003766:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000376a:	8526                	mv	a0,s1
    8000376c:	ffffe097          	auipc	ra,0xffffe
    80003770:	ece080e7          	jalr	-306(ra) # 8000163a <wakeup>
    release(&log.lock);
    80003774:	8526                	mv	a0,s1
    80003776:	00003097          	auipc	ra,0x3
    8000377a:	c32080e7          	jalr	-974(ra) # 800063a8 <release>
}
    8000377e:	a03d                	j	800037ac <end_op+0xaa>
    panic("log.committing");
    80003780:	00005517          	auipc	a0,0x5
    80003784:	e2050513          	addi	a0,a0,-480 # 800085a0 <syscalls+0x1e0>
    80003788:	00002097          	auipc	ra,0x2
    8000378c:	5e4080e7          	jalr	1508(ra) # 80005d6c <panic>
    wakeup(&log);
    80003790:	00035497          	auipc	s1,0x35
    80003794:	14048493          	addi	s1,s1,320 # 800388d0 <log>
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	ea0080e7          	jalr	-352(ra) # 8000163a <wakeup>
  release(&log.lock);
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	c04080e7          	jalr	-1020(ra) # 800063a8 <release>
}
    800037ac:	70e2                	ld	ra,56(sp)
    800037ae:	7442                	ld	s0,48(sp)
    800037b0:	74a2                	ld	s1,40(sp)
    800037b2:	7902                	ld	s2,32(sp)
    800037b4:	69e2                	ld	s3,24(sp)
    800037b6:	6a42                	ld	s4,16(sp)
    800037b8:	6aa2                	ld	s5,8(sp)
    800037ba:	6121                	addi	sp,sp,64
    800037bc:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800037be:	00035a97          	auipc	s5,0x35
    800037c2:	142a8a93          	addi	s5,s5,322 # 80038900 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037c6:	00035a17          	auipc	s4,0x35
    800037ca:	10aa0a13          	addi	s4,s4,266 # 800388d0 <log>
    800037ce:	018a2583          	lw	a1,24(s4)
    800037d2:	012585bb          	addw	a1,a1,s2
    800037d6:	2585                	addiw	a1,a1,1
    800037d8:	028a2503          	lw	a0,40(s4)
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	cc4080e7          	jalr	-828(ra) # 800024a0 <bread>
    800037e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037e6:	000aa583          	lw	a1,0(s5)
    800037ea:	028a2503          	lw	a0,40(s4)
    800037ee:	fffff097          	auipc	ra,0xfffff
    800037f2:	cb2080e7          	jalr	-846(ra) # 800024a0 <bread>
    800037f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037f8:	40000613          	li	a2,1024
    800037fc:	05850593          	addi	a1,a0,88
    80003800:	05848513          	addi	a0,s1,88
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	ac8080e7          	jalr	-1336(ra) # 800002cc <memmove>
    bwrite(to);  // write the log
    8000380c:	8526                	mv	a0,s1
    8000380e:	fffff097          	auipc	ra,0xfffff
    80003812:	d84080e7          	jalr	-636(ra) # 80002592 <bwrite>
    brelse(from);
    80003816:	854e                	mv	a0,s3
    80003818:	fffff097          	auipc	ra,0xfffff
    8000381c:	db8080e7          	jalr	-584(ra) # 800025d0 <brelse>
    brelse(to);
    80003820:	8526                	mv	a0,s1
    80003822:	fffff097          	auipc	ra,0xfffff
    80003826:	dae080e7          	jalr	-594(ra) # 800025d0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000382a:	2905                	addiw	s2,s2,1
    8000382c:	0a91                	addi	s5,s5,4
    8000382e:	02ca2783          	lw	a5,44(s4)
    80003832:	f8f94ee3          	blt	s2,a5,800037ce <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	c68080e7          	jalr	-920(ra) # 8000349e <write_head>
    install_trans(0); // Now install writes to home locations
    8000383e:	4501                	li	a0,0
    80003840:	00000097          	auipc	ra,0x0
    80003844:	cda080e7          	jalr	-806(ra) # 8000351a <install_trans>
    log.lh.n = 0;
    80003848:	00035797          	auipc	a5,0x35
    8000384c:	0a07aa23          	sw	zero,180(a5) # 800388fc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003850:	00000097          	auipc	ra,0x0
    80003854:	c4e080e7          	jalr	-946(ra) # 8000349e <write_head>
    80003858:	bdf5                	j	80003754 <end_op+0x52>

000000008000385a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000385a:	1101                	addi	sp,sp,-32
    8000385c:	ec06                	sd	ra,24(sp)
    8000385e:	e822                	sd	s0,16(sp)
    80003860:	e426                	sd	s1,8(sp)
    80003862:	e04a                	sd	s2,0(sp)
    80003864:	1000                	addi	s0,sp,32
    80003866:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003868:	00035917          	auipc	s2,0x35
    8000386c:	06890913          	addi	s2,s2,104 # 800388d0 <log>
    80003870:	854a                	mv	a0,s2
    80003872:	00003097          	auipc	ra,0x3
    80003876:	a82080e7          	jalr	-1406(ra) # 800062f4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000387a:	02c92603          	lw	a2,44(s2)
    8000387e:	47f5                	li	a5,29
    80003880:	06c7c563          	blt	a5,a2,800038ea <log_write+0x90>
    80003884:	00035797          	auipc	a5,0x35
    80003888:	0687a783          	lw	a5,104(a5) # 800388ec <log+0x1c>
    8000388c:	37fd                	addiw	a5,a5,-1
    8000388e:	04f65e63          	bge	a2,a5,800038ea <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003892:	00035797          	auipc	a5,0x35
    80003896:	05e7a783          	lw	a5,94(a5) # 800388f0 <log+0x20>
    8000389a:	06f05063          	blez	a5,800038fa <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000389e:	4781                	li	a5,0
    800038a0:	06c05563          	blez	a2,8000390a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038a4:	44cc                	lw	a1,12(s1)
    800038a6:	00035717          	auipc	a4,0x35
    800038aa:	05a70713          	addi	a4,a4,90 # 80038900 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038ae:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038b0:	4314                	lw	a3,0(a4)
    800038b2:	04b68c63          	beq	a3,a1,8000390a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038b6:	2785                	addiw	a5,a5,1
    800038b8:	0711                	addi	a4,a4,4
    800038ba:	fef61be3          	bne	a2,a5,800038b0 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038be:	0621                	addi	a2,a2,8
    800038c0:	060a                	slli	a2,a2,0x2
    800038c2:	00035797          	auipc	a5,0x35
    800038c6:	00e78793          	addi	a5,a5,14 # 800388d0 <log>
    800038ca:	97b2                	add	a5,a5,a2
    800038cc:	44d8                	lw	a4,12(s1)
    800038ce:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038d0:	8526                	mv	a0,s1
    800038d2:	fffff097          	auipc	ra,0xfffff
    800038d6:	d9c080e7          	jalr	-612(ra) # 8000266e <bpin>
    log.lh.n++;
    800038da:	00035717          	auipc	a4,0x35
    800038de:	ff670713          	addi	a4,a4,-10 # 800388d0 <log>
    800038e2:	575c                	lw	a5,44(a4)
    800038e4:	2785                	addiw	a5,a5,1
    800038e6:	d75c                	sw	a5,44(a4)
    800038e8:	a82d                	j	80003922 <log_write+0xc8>
    panic("too big a transaction");
    800038ea:	00005517          	auipc	a0,0x5
    800038ee:	cc650513          	addi	a0,a0,-826 # 800085b0 <syscalls+0x1f0>
    800038f2:	00002097          	auipc	ra,0x2
    800038f6:	47a080e7          	jalr	1146(ra) # 80005d6c <panic>
    panic("log_write outside of trans");
    800038fa:	00005517          	auipc	a0,0x5
    800038fe:	cce50513          	addi	a0,a0,-818 # 800085c8 <syscalls+0x208>
    80003902:	00002097          	auipc	ra,0x2
    80003906:	46a080e7          	jalr	1130(ra) # 80005d6c <panic>
  log.lh.block[i] = b->blockno;
    8000390a:	00878693          	addi	a3,a5,8
    8000390e:	068a                	slli	a3,a3,0x2
    80003910:	00035717          	auipc	a4,0x35
    80003914:	fc070713          	addi	a4,a4,-64 # 800388d0 <log>
    80003918:	9736                	add	a4,a4,a3
    8000391a:	44d4                	lw	a3,12(s1)
    8000391c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000391e:	faf609e3          	beq	a2,a5,800038d0 <log_write+0x76>
  }
  release(&log.lock);
    80003922:	00035517          	auipc	a0,0x35
    80003926:	fae50513          	addi	a0,a0,-82 # 800388d0 <log>
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	a7e080e7          	jalr	-1410(ra) # 800063a8 <release>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret

000000008000393e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000393e:	1101                	addi	sp,sp,-32
    80003940:	ec06                	sd	ra,24(sp)
    80003942:	e822                	sd	s0,16(sp)
    80003944:	e426                	sd	s1,8(sp)
    80003946:	e04a                	sd	s2,0(sp)
    80003948:	1000                	addi	s0,sp,32
    8000394a:	84aa                	mv	s1,a0
    8000394c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000394e:	00005597          	auipc	a1,0x5
    80003952:	c9a58593          	addi	a1,a1,-870 # 800085e8 <syscalls+0x228>
    80003956:	0521                	addi	a0,a0,8
    80003958:	00003097          	auipc	ra,0x3
    8000395c:	90c080e7          	jalr	-1780(ra) # 80006264 <initlock>
  lk->name = name;
    80003960:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003964:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003968:	0204a423          	sw	zero,40(s1)
}
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6902                	ld	s2,0(sp)
    80003974:	6105                	addi	sp,sp,32
    80003976:	8082                	ret

0000000080003978 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003978:	1101                	addi	sp,sp,-32
    8000397a:	ec06                	sd	ra,24(sp)
    8000397c:	e822                	sd	s0,16(sp)
    8000397e:	e426                	sd	s1,8(sp)
    80003980:	e04a                	sd	s2,0(sp)
    80003982:	1000                	addi	s0,sp,32
    80003984:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003986:	00850913          	addi	s2,a0,8
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	968080e7          	jalr	-1688(ra) # 800062f4 <acquire>
  while (lk->locked) {
    80003994:	409c                	lw	a5,0(s1)
    80003996:	cb89                	beqz	a5,800039a8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003998:	85ca                	mv	a1,s2
    8000399a:	8526                	mv	a0,s1
    8000399c:	ffffe097          	auipc	ra,0xffffe
    800039a0:	c3a080e7          	jalr	-966(ra) # 800015d6 <sleep>
  while (lk->locked) {
    800039a4:	409c                	lw	a5,0(s1)
    800039a6:	fbed                	bnez	a5,80003998 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039a8:	4785                	li	a5,1
    800039aa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	582080e7          	jalr	1410(ra) # 80000f2e <myproc>
    800039b4:	591c                	lw	a5,48(a0)
    800039b6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039b8:	854a                	mv	a0,s2
    800039ba:	00003097          	auipc	ra,0x3
    800039be:	9ee080e7          	jalr	-1554(ra) # 800063a8 <release>
}
    800039c2:	60e2                	ld	ra,24(sp)
    800039c4:	6442                	ld	s0,16(sp)
    800039c6:	64a2                	ld	s1,8(sp)
    800039c8:	6902                	ld	s2,0(sp)
    800039ca:	6105                	addi	sp,sp,32
    800039cc:	8082                	ret

00000000800039ce <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039ce:	1101                	addi	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	e04a                	sd	s2,0(sp)
    800039d8:	1000                	addi	s0,sp,32
    800039da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039dc:	00850913          	addi	s2,a0,8
    800039e0:	854a                	mv	a0,s2
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	912080e7          	jalr	-1774(ra) # 800062f4 <acquire>
  lk->locked = 0;
    800039ea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ee:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039f2:	8526                	mv	a0,s1
    800039f4:	ffffe097          	auipc	ra,0xffffe
    800039f8:	c46080e7          	jalr	-954(ra) # 8000163a <wakeup>
  release(&lk->lk);
    800039fc:	854a                	mv	a0,s2
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	9aa080e7          	jalr	-1622(ra) # 800063a8 <release>
}
    80003a06:	60e2                	ld	ra,24(sp)
    80003a08:	6442                	ld	s0,16(sp)
    80003a0a:	64a2                	ld	s1,8(sp)
    80003a0c:	6902                	ld	s2,0(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a12:	7179                	addi	sp,sp,-48
    80003a14:	f406                	sd	ra,40(sp)
    80003a16:	f022                	sd	s0,32(sp)
    80003a18:	ec26                	sd	s1,24(sp)
    80003a1a:	e84a                	sd	s2,16(sp)
    80003a1c:	e44e                	sd	s3,8(sp)
    80003a1e:	1800                	addi	s0,sp,48
    80003a20:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a22:	00850913          	addi	s2,a0,8
    80003a26:	854a                	mv	a0,s2
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	8cc080e7          	jalr	-1844(ra) # 800062f4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a30:	409c                	lw	a5,0(s1)
    80003a32:	ef99                	bnez	a5,80003a50 <holdingsleep+0x3e>
    80003a34:	4481                	li	s1,0
  release(&lk->lk);
    80003a36:	854a                	mv	a0,s2
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	970080e7          	jalr	-1680(ra) # 800063a8 <release>
  return r;
}
    80003a40:	8526                	mv	a0,s1
    80003a42:	70a2                	ld	ra,40(sp)
    80003a44:	7402                	ld	s0,32(sp)
    80003a46:	64e2                	ld	s1,24(sp)
    80003a48:	6942                	ld	s2,16(sp)
    80003a4a:	69a2                	ld	s3,8(sp)
    80003a4c:	6145                	addi	sp,sp,48
    80003a4e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a50:	0284a983          	lw	s3,40(s1)
    80003a54:	ffffd097          	auipc	ra,0xffffd
    80003a58:	4da080e7          	jalr	1242(ra) # 80000f2e <myproc>
    80003a5c:	5904                	lw	s1,48(a0)
    80003a5e:	413484b3          	sub	s1,s1,s3
    80003a62:	0014b493          	seqz	s1,s1
    80003a66:	bfc1                	j	80003a36 <holdingsleep+0x24>

0000000080003a68 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a68:	1141                	addi	sp,sp,-16
    80003a6a:	e406                	sd	ra,8(sp)
    80003a6c:	e022                	sd	s0,0(sp)
    80003a6e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a70:	00005597          	auipc	a1,0x5
    80003a74:	b8858593          	addi	a1,a1,-1144 # 800085f8 <syscalls+0x238>
    80003a78:	00035517          	auipc	a0,0x35
    80003a7c:	fa050513          	addi	a0,a0,-96 # 80038a18 <ftable>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	7e4080e7          	jalr	2020(ra) # 80006264 <initlock>
}
    80003a88:	60a2                	ld	ra,8(sp)
    80003a8a:	6402                	ld	s0,0(sp)
    80003a8c:	0141                	addi	sp,sp,16
    80003a8e:	8082                	ret

0000000080003a90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a90:	1101                	addi	sp,sp,-32
    80003a92:	ec06                	sd	ra,24(sp)
    80003a94:	e822                	sd	s0,16(sp)
    80003a96:	e426                	sd	s1,8(sp)
    80003a98:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a9a:	00035517          	auipc	a0,0x35
    80003a9e:	f7e50513          	addi	a0,a0,-130 # 80038a18 <ftable>
    80003aa2:	00003097          	auipc	ra,0x3
    80003aa6:	852080e7          	jalr	-1966(ra) # 800062f4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aaa:	00035497          	auipc	s1,0x35
    80003aae:	f8648493          	addi	s1,s1,-122 # 80038a30 <ftable+0x18>
    80003ab2:	00036717          	auipc	a4,0x36
    80003ab6:	f1e70713          	addi	a4,a4,-226 # 800399d0 <disk>
    if(f->ref == 0){
    80003aba:	40dc                	lw	a5,4(s1)
    80003abc:	cf99                	beqz	a5,80003ada <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003abe:	02848493          	addi	s1,s1,40
    80003ac2:	fee49ce3          	bne	s1,a4,80003aba <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ac6:	00035517          	auipc	a0,0x35
    80003aca:	f5250513          	addi	a0,a0,-174 # 80038a18 <ftable>
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	8da080e7          	jalr	-1830(ra) # 800063a8 <release>
  return 0;
    80003ad6:	4481                	li	s1,0
    80003ad8:	a819                	j	80003aee <filealloc+0x5e>
      f->ref = 1;
    80003ada:	4785                	li	a5,1
    80003adc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ade:	00035517          	auipc	a0,0x35
    80003ae2:	f3a50513          	addi	a0,a0,-198 # 80038a18 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	8c2080e7          	jalr	-1854(ra) # 800063a8 <release>
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret

0000000080003afa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003afa:	1101                	addi	sp,sp,-32
    80003afc:	ec06                	sd	ra,24(sp)
    80003afe:	e822                	sd	s0,16(sp)
    80003b00:	e426                	sd	s1,8(sp)
    80003b02:	1000                	addi	s0,sp,32
    80003b04:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b06:	00035517          	auipc	a0,0x35
    80003b0a:	f1250513          	addi	a0,a0,-238 # 80038a18 <ftable>
    80003b0e:	00002097          	auipc	ra,0x2
    80003b12:	7e6080e7          	jalr	2022(ra) # 800062f4 <acquire>
  if(f->ref < 1)
    80003b16:	40dc                	lw	a5,4(s1)
    80003b18:	02f05263          	blez	a5,80003b3c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b1c:	2785                	addiw	a5,a5,1
    80003b1e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b20:	00035517          	auipc	a0,0x35
    80003b24:	ef850513          	addi	a0,a0,-264 # 80038a18 <ftable>
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	880080e7          	jalr	-1920(ra) # 800063a8 <release>
  return f;
}
    80003b30:	8526                	mv	a0,s1
    80003b32:	60e2                	ld	ra,24(sp)
    80003b34:	6442                	ld	s0,16(sp)
    80003b36:	64a2                	ld	s1,8(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret
    panic("filedup");
    80003b3c:	00005517          	auipc	a0,0x5
    80003b40:	ac450513          	addi	a0,a0,-1340 # 80008600 <syscalls+0x240>
    80003b44:	00002097          	auipc	ra,0x2
    80003b48:	228080e7          	jalr	552(ra) # 80005d6c <panic>

0000000080003b4c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b4c:	7139                	addi	sp,sp,-64
    80003b4e:	fc06                	sd	ra,56(sp)
    80003b50:	f822                	sd	s0,48(sp)
    80003b52:	f426                	sd	s1,40(sp)
    80003b54:	f04a                	sd	s2,32(sp)
    80003b56:	ec4e                	sd	s3,24(sp)
    80003b58:	e852                	sd	s4,16(sp)
    80003b5a:	e456                	sd	s5,8(sp)
    80003b5c:	0080                	addi	s0,sp,64
    80003b5e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b60:	00035517          	auipc	a0,0x35
    80003b64:	eb850513          	addi	a0,a0,-328 # 80038a18 <ftable>
    80003b68:	00002097          	auipc	ra,0x2
    80003b6c:	78c080e7          	jalr	1932(ra) # 800062f4 <acquire>
  if(f->ref < 1)
    80003b70:	40dc                	lw	a5,4(s1)
    80003b72:	06f05163          	blez	a5,80003bd4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b76:	37fd                	addiw	a5,a5,-1
    80003b78:	0007871b          	sext.w	a4,a5
    80003b7c:	c0dc                	sw	a5,4(s1)
    80003b7e:	06e04363          	bgtz	a4,80003be4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b82:	0004a903          	lw	s2,0(s1)
    80003b86:	0094ca83          	lbu	s5,9(s1)
    80003b8a:	0104ba03          	ld	s4,16(s1)
    80003b8e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b92:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b96:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b9a:	00035517          	auipc	a0,0x35
    80003b9e:	e7e50513          	addi	a0,a0,-386 # 80038a18 <ftable>
    80003ba2:	00003097          	auipc	ra,0x3
    80003ba6:	806080e7          	jalr	-2042(ra) # 800063a8 <release>

  if(ff.type == FD_PIPE){
    80003baa:	4785                	li	a5,1
    80003bac:	04f90d63          	beq	s2,a5,80003c06 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bb0:	3979                	addiw	s2,s2,-2
    80003bb2:	4785                	li	a5,1
    80003bb4:	0527e063          	bltu	a5,s2,80003bf4 <fileclose+0xa8>
    begin_op();
    80003bb8:	00000097          	auipc	ra,0x0
    80003bbc:	acc080e7          	jalr	-1332(ra) # 80003684 <begin_op>
    iput(ff.ip);
    80003bc0:	854e                	mv	a0,s3
    80003bc2:	fffff097          	auipc	ra,0xfffff
    80003bc6:	2b0080e7          	jalr	688(ra) # 80002e72 <iput>
    end_op();
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	b38080e7          	jalr	-1224(ra) # 80003702 <end_op>
    80003bd2:	a00d                	j	80003bf4 <fileclose+0xa8>
    panic("fileclose");
    80003bd4:	00005517          	auipc	a0,0x5
    80003bd8:	a3450513          	addi	a0,a0,-1484 # 80008608 <syscalls+0x248>
    80003bdc:	00002097          	auipc	ra,0x2
    80003be0:	190080e7          	jalr	400(ra) # 80005d6c <panic>
    release(&ftable.lock);
    80003be4:	00035517          	auipc	a0,0x35
    80003be8:	e3450513          	addi	a0,a0,-460 # 80038a18 <ftable>
    80003bec:	00002097          	auipc	ra,0x2
    80003bf0:	7bc080e7          	jalr	1980(ra) # 800063a8 <release>
  }
}
    80003bf4:	70e2                	ld	ra,56(sp)
    80003bf6:	7442                	ld	s0,48(sp)
    80003bf8:	74a2                	ld	s1,40(sp)
    80003bfa:	7902                	ld	s2,32(sp)
    80003bfc:	69e2                	ld	s3,24(sp)
    80003bfe:	6a42                	ld	s4,16(sp)
    80003c00:	6aa2                	ld	s5,8(sp)
    80003c02:	6121                	addi	sp,sp,64
    80003c04:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c06:	85d6                	mv	a1,s5
    80003c08:	8552                	mv	a0,s4
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	34c080e7          	jalr	844(ra) # 80003f56 <pipeclose>
    80003c12:	b7cd                	j	80003bf4 <fileclose+0xa8>

0000000080003c14 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c14:	715d                	addi	sp,sp,-80
    80003c16:	e486                	sd	ra,72(sp)
    80003c18:	e0a2                	sd	s0,64(sp)
    80003c1a:	fc26                	sd	s1,56(sp)
    80003c1c:	f84a                	sd	s2,48(sp)
    80003c1e:	f44e                	sd	s3,40(sp)
    80003c20:	0880                	addi	s0,sp,80
    80003c22:	84aa                	mv	s1,a0
    80003c24:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c26:	ffffd097          	auipc	ra,0xffffd
    80003c2a:	308080e7          	jalr	776(ra) # 80000f2e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c2e:	409c                	lw	a5,0(s1)
    80003c30:	37f9                	addiw	a5,a5,-2
    80003c32:	4705                	li	a4,1
    80003c34:	04f76763          	bltu	a4,a5,80003c82 <filestat+0x6e>
    80003c38:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c3a:	6c88                	ld	a0,24(s1)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	07c080e7          	jalr	124(ra) # 80002cb8 <ilock>
    stati(f->ip, &st);
    80003c44:	fb840593          	addi	a1,s0,-72
    80003c48:	6c88                	ld	a0,24(s1)
    80003c4a:	fffff097          	auipc	ra,0xfffff
    80003c4e:	2f8080e7          	jalr	760(ra) # 80002f42 <stati>
    iunlock(f->ip);
    80003c52:	6c88                	ld	a0,24(s1)
    80003c54:	fffff097          	auipc	ra,0xfffff
    80003c58:	126080e7          	jalr	294(ra) # 80002d7a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c5c:	46e1                	li	a3,24
    80003c5e:	fb840613          	addi	a2,s0,-72
    80003c62:	85ce                	mv	a1,s3
    80003c64:	05093503          	ld	a0,80(s2)
    80003c68:	ffffd097          	auipc	ra,0xffffd
    80003c6c:	f86080e7          	jalr	-122(ra) # 80000bee <copyout>
    80003c70:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c74:	60a6                	ld	ra,72(sp)
    80003c76:	6406                	ld	s0,64(sp)
    80003c78:	74e2                	ld	s1,56(sp)
    80003c7a:	7942                	ld	s2,48(sp)
    80003c7c:	79a2                	ld	s3,40(sp)
    80003c7e:	6161                	addi	sp,sp,80
    80003c80:	8082                	ret
  return -1;
    80003c82:	557d                	li	a0,-1
    80003c84:	bfc5                	j	80003c74 <filestat+0x60>

0000000080003c86 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c86:	7179                	addi	sp,sp,-48
    80003c88:	f406                	sd	ra,40(sp)
    80003c8a:	f022                	sd	s0,32(sp)
    80003c8c:	ec26                	sd	s1,24(sp)
    80003c8e:	e84a                	sd	s2,16(sp)
    80003c90:	e44e                	sd	s3,8(sp)
    80003c92:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c94:	00854783          	lbu	a5,8(a0)
    80003c98:	c3d5                	beqz	a5,80003d3c <fileread+0xb6>
    80003c9a:	84aa                	mv	s1,a0
    80003c9c:	89ae                	mv	s3,a1
    80003c9e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca0:	411c                	lw	a5,0(a0)
    80003ca2:	4705                	li	a4,1
    80003ca4:	04e78963          	beq	a5,a4,80003cf6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca8:	470d                	li	a4,3
    80003caa:	04e78d63          	beq	a5,a4,80003d04 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cae:	4709                	li	a4,2
    80003cb0:	06e79e63          	bne	a5,a4,80003d2c <fileread+0xa6>
    ilock(f->ip);
    80003cb4:	6d08                	ld	a0,24(a0)
    80003cb6:	fffff097          	auipc	ra,0xfffff
    80003cba:	002080e7          	jalr	2(ra) # 80002cb8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cbe:	874a                	mv	a4,s2
    80003cc0:	5094                	lw	a3,32(s1)
    80003cc2:	864e                	mv	a2,s3
    80003cc4:	4585                	li	a1,1
    80003cc6:	6c88                	ld	a0,24(s1)
    80003cc8:	fffff097          	auipc	ra,0xfffff
    80003ccc:	2a4080e7          	jalr	676(ra) # 80002f6c <readi>
    80003cd0:	892a                	mv	s2,a0
    80003cd2:	00a05563          	blez	a0,80003cdc <fileread+0x56>
      f->off += r;
    80003cd6:	509c                	lw	a5,32(s1)
    80003cd8:	9fa9                	addw	a5,a5,a0
    80003cda:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cdc:	6c88                	ld	a0,24(s1)
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	09c080e7          	jalr	156(ra) # 80002d7a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ce6:	854a                	mv	a0,s2
    80003ce8:	70a2                	ld	ra,40(sp)
    80003cea:	7402                	ld	s0,32(sp)
    80003cec:	64e2                	ld	s1,24(sp)
    80003cee:	6942                	ld	s2,16(sp)
    80003cf0:	69a2                	ld	s3,8(sp)
    80003cf2:	6145                	addi	sp,sp,48
    80003cf4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cf6:	6908                	ld	a0,16(a0)
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	3c6080e7          	jalr	966(ra) # 800040be <piperead>
    80003d00:	892a                	mv	s2,a0
    80003d02:	b7d5                	j	80003ce6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d04:	02451783          	lh	a5,36(a0)
    80003d08:	03079693          	slli	a3,a5,0x30
    80003d0c:	92c1                	srli	a3,a3,0x30
    80003d0e:	4725                	li	a4,9
    80003d10:	02d76863          	bltu	a4,a3,80003d40 <fileread+0xba>
    80003d14:	0792                	slli	a5,a5,0x4
    80003d16:	00035717          	auipc	a4,0x35
    80003d1a:	c6270713          	addi	a4,a4,-926 # 80038978 <devsw>
    80003d1e:	97ba                	add	a5,a5,a4
    80003d20:	639c                	ld	a5,0(a5)
    80003d22:	c38d                	beqz	a5,80003d44 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d24:	4505                	li	a0,1
    80003d26:	9782                	jalr	a5
    80003d28:	892a                	mv	s2,a0
    80003d2a:	bf75                	j	80003ce6 <fileread+0x60>
    panic("fileread");
    80003d2c:	00005517          	auipc	a0,0x5
    80003d30:	8ec50513          	addi	a0,a0,-1812 # 80008618 <syscalls+0x258>
    80003d34:	00002097          	auipc	ra,0x2
    80003d38:	038080e7          	jalr	56(ra) # 80005d6c <panic>
    return -1;
    80003d3c:	597d                	li	s2,-1
    80003d3e:	b765                	j	80003ce6 <fileread+0x60>
      return -1;
    80003d40:	597d                	li	s2,-1
    80003d42:	b755                	j	80003ce6 <fileread+0x60>
    80003d44:	597d                	li	s2,-1
    80003d46:	b745                	j	80003ce6 <fileread+0x60>

0000000080003d48 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d48:	715d                	addi	sp,sp,-80
    80003d4a:	e486                	sd	ra,72(sp)
    80003d4c:	e0a2                	sd	s0,64(sp)
    80003d4e:	fc26                	sd	s1,56(sp)
    80003d50:	f84a                	sd	s2,48(sp)
    80003d52:	f44e                	sd	s3,40(sp)
    80003d54:	f052                	sd	s4,32(sp)
    80003d56:	ec56                	sd	s5,24(sp)
    80003d58:	e85a                	sd	s6,16(sp)
    80003d5a:	e45e                	sd	s7,8(sp)
    80003d5c:	e062                	sd	s8,0(sp)
    80003d5e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d60:	00954783          	lbu	a5,9(a0)
    80003d64:	10078663          	beqz	a5,80003e70 <filewrite+0x128>
    80003d68:	892a                	mv	s2,a0
    80003d6a:	8b2e                	mv	s6,a1
    80003d6c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d6e:	411c                	lw	a5,0(a0)
    80003d70:	4705                	li	a4,1
    80003d72:	02e78263          	beq	a5,a4,80003d96 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d76:	470d                	li	a4,3
    80003d78:	02e78663          	beq	a5,a4,80003da4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d7c:	4709                	li	a4,2
    80003d7e:	0ee79163          	bne	a5,a4,80003e60 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d82:	0ac05d63          	blez	a2,80003e3c <filewrite+0xf4>
    int i = 0;
    80003d86:	4981                	li	s3,0
    80003d88:	6b85                	lui	s7,0x1
    80003d8a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d8e:	6c05                	lui	s8,0x1
    80003d90:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d94:	a861                	j	80003e2c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d96:	6908                	ld	a0,16(a0)
    80003d98:	00000097          	auipc	ra,0x0
    80003d9c:	22e080e7          	jalr	558(ra) # 80003fc6 <pipewrite>
    80003da0:	8a2a                	mv	s4,a0
    80003da2:	a045                	j	80003e42 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003da4:	02451783          	lh	a5,36(a0)
    80003da8:	03079693          	slli	a3,a5,0x30
    80003dac:	92c1                	srli	a3,a3,0x30
    80003dae:	4725                	li	a4,9
    80003db0:	0cd76263          	bltu	a4,a3,80003e74 <filewrite+0x12c>
    80003db4:	0792                	slli	a5,a5,0x4
    80003db6:	00035717          	auipc	a4,0x35
    80003dba:	bc270713          	addi	a4,a4,-1086 # 80038978 <devsw>
    80003dbe:	97ba                	add	a5,a5,a4
    80003dc0:	679c                	ld	a5,8(a5)
    80003dc2:	cbdd                	beqz	a5,80003e78 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dc4:	4505                	li	a0,1
    80003dc6:	9782                	jalr	a5
    80003dc8:	8a2a                	mv	s4,a0
    80003dca:	a8a5                	j	80003e42 <filewrite+0xfa>
    80003dcc:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	8b4080e7          	jalr	-1868(ra) # 80003684 <begin_op>
      ilock(f->ip);
    80003dd8:	01893503          	ld	a0,24(s2)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	edc080e7          	jalr	-292(ra) # 80002cb8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003de4:	8756                	mv	a4,s5
    80003de6:	02092683          	lw	a3,32(s2)
    80003dea:	01698633          	add	a2,s3,s6
    80003dee:	4585                	li	a1,1
    80003df0:	01893503          	ld	a0,24(s2)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	270080e7          	jalr	624(ra) # 80003064 <writei>
    80003dfc:	84aa                	mv	s1,a0
    80003dfe:	00a05763          	blez	a0,80003e0c <filewrite+0xc4>
        f->off += r;
    80003e02:	02092783          	lw	a5,32(s2)
    80003e06:	9fa9                	addw	a5,a5,a0
    80003e08:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e0c:	01893503          	ld	a0,24(s2)
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	f6a080e7          	jalr	-150(ra) # 80002d7a <iunlock>
      end_op();
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	8ea080e7          	jalr	-1814(ra) # 80003702 <end_op>

      if(r != n1){
    80003e20:	009a9f63          	bne	s5,s1,80003e3e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e24:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e28:	0149db63          	bge	s3,s4,80003e3e <filewrite+0xf6>
      int n1 = n - i;
    80003e2c:	413a04bb          	subw	s1,s4,s3
    80003e30:	0004879b          	sext.w	a5,s1
    80003e34:	f8fbdce3          	bge	s7,a5,80003dcc <filewrite+0x84>
    80003e38:	84e2                	mv	s1,s8
    80003e3a:	bf49                	j	80003dcc <filewrite+0x84>
    int i = 0;
    80003e3c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e3e:	013a1f63          	bne	s4,s3,80003e5c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e42:	8552                	mv	a0,s4
    80003e44:	60a6                	ld	ra,72(sp)
    80003e46:	6406                	ld	s0,64(sp)
    80003e48:	74e2                	ld	s1,56(sp)
    80003e4a:	7942                	ld	s2,48(sp)
    80003e4c:	79a2                	ld	s3,40(sp)
    80003e4e:	7a02                	ld	s4,32(sp)
    80003e50:	6ae2                	ld	s5,24(sp)
    80003e52:	6b42                	ld	s6,16(sp)
    80003e54:	6ba2                	ld	s7,8(sp)
    80003e56:	6c02                	ld	s8,0(sp)
    80003e58:	6161                	addi	sp,sp,80
    80003e5a:	8082                	ret
    ret = (i == n ? n : -1);
    80003e5c:	5a7d                	li	s4,-1
    80003e5e:	b7d5                	j	80003e42 <filewrite+0xfa>
    panic("filewrite");
    80003e60:	00004517          	auipc	a0,0x4
    80003e64:	7c850513          	addi	a0,a0,1992 # 80008628 <syscalls+0x268>
    80003e68:	00002097          	auipc	ra,0x2
    80003e6c:	f04080e7          	jalr	-252(ra) # 80005d6c <panic>
    return -1;
    80003e70:	5a7d                	li	s4,-1
    80003e72:	bfc1                	j	80003e42 <filewrite+0xfa>
      return -1;
    80003e74:	5a7d                	li	s4,-1
    80003e76:	b7f1                	j	80003e42 <filewrite+0xfa>
    80003e78:	5a7d                	li	s4,-1
    80003e7a:	b7e1                	j	80003e42 <filewrite+0xfa>

0000000080003e7c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e7c:	7179                	addi	sp,sp,-48
    80003e7e:	f406                	sd	ra,40(sp)
    80003e80:	f022                	sd	s0,32(sp)
    80003e82:	ec26                	sd	s1,24(sp)
    80003e84:	e84a                	sd	s2,16(sp)
    80003e86:	e44e                	sd	s3,8(sp)
    80003e88:	e052                	sd	s4,0(sp)
    80003e8a:	1800                	addi	s0,sp,48
    80003e8c:	84aa                	mv	s1,a0
    80003e8e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e90:	0005b023          	sd	zero,0(a1)
    80003e94:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e98:	00000097          	auipc	ra,0x0
    80003e9c:	bf8080e7          	jalr	-1032(ra) # 80003a90 <filealloc>
    80003ea0:	e088                	sd	a0,0(s1)
    80003ea2:	c551                	beqz	a0,80003f2e <pipealloc+0xb2>
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	bec080e7          	jalr	-1044(ra) # 80003a90 <filealloc>
    80003eac:	00aa3023          	sd	a0,0(s4)
    80003eb0:	c92d                	beqz	a0,80003f22 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003eb2:	ffffc097          	auipc	ra,0xffffc
    80003eb6:	346080e7          	jalr	838(ra) # 800001f8 <kalloc>
    80003eba:	892a                	mv	s2,a0
    80003ebc:	c125                	beqz	a0,80003f1c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ebe:	4985                	li	s3,1
    80003ec0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ec4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ec8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ecc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ed0:	00004597          	auipc	a1,0x4
    80003ed4:	76858593          	addi	a1,a1,1896 # 80008638 <syscalls+0x278>
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	38c080e7          	jalr	908(ra) # 80006264 <initlock>
  (*f0)->type = FD_PIPE;
    80003ee0:	609c                	ld	a5,0(s1)
    80003ee2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ee6:	609c                	ld	a5,0(s1)
    80003ee8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eec:	609c                	ld	a5,0(s1)
    80003eee:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ef2:	609c                	ld	a5,0(s1)
    80003ef4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ef8:	000a3783          	ld	a5,0(s4)
    80003efc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f00:	000a3783          	ld	a5,0(s4)
    80003f04:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f08:	000a3783          	ld	a5,0(s4)
    80003f0c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f10:	000a3783          	ld	a5,0(s4)
    80003f14:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f18:	4501                	li	a0,0
    80003f1a:	a025                	j	80003f42 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f1c:	6088                	ld	a0,0(s1)
    80003f1e:	e501                	bnez	a0,80003f26 <pipealloc+0xaa>
    80003f20:	a039                	j	80003f2e <pipealloc+0xb2>
    80003f22:	6088                	ld	a0,0(s1)
    80003f24:	c51d                	beqz	a0,80003f52 <pipealloc+0xd6>
    fileclose(*f0);
    80003f26:	00000097          	auipc	ra,0x0
    80003f2a:	c26080e7          	jalr	-986(ra) # 80003b4c <fileclose>
  if(*f1)
    80003f2e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f32:	557d                	li	a0,-1
  if(*f1)
    80003f34:	c799                	beqz	a5,80003f42 <pipealloc+0xc6>
    fileclose(*f1);
    80003f36:	853e                	mv	a0,a5
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	c14080e7          	jalr	-1004(ra) # 80003b4c <fileclose>
  return -1;
    80003f40:	557d                	li	a0,-1
}
    80003f42:	70a2                	ld	ra,40(sp)
    80003f44:	7402                	ld	s0,32(sp)
    80003f46:	64e2                	ld	s1,24(sp)
    80003f48:	6942                	ld	s2,16(sp)
    80003f4a:	69a2                	ld	s3,8(sp)
    80003f4c:	6a02                	ld	s4,0(sp)
    80003f4e:	6145                	addi	sp,sp,48
    80003f50:	8082                	ret
  return -1;
    80003f52:	557d                	li	a0,-1
    80003f54:	b7fd                	j	80003f42 <pipealloc+0xc6>

0000000080003f56 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f56:	1101                	addi	sp,sp,-32
    80003f58:	ec06                	sd	ra,24(sp)
    80003f5a:	e822                	sd	s0,16(sp)
    80003f5c:	e426                	sd	s1,8(sp)
    80003f5e:	e04a                	sd	s2,0(sp)
    80003f60:	1000                	addi	s0,sp,32
    80003f62:	84aa                	mv	s1,a0
    80003f64:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f66:	00002097          	auipc	ra,0x2
    80003f6a:	38e080e7          	jalr	910(ra) # 800062f4 <acquire>
  if(writable){
    80003f6e:	02090d63          	beqz	s2,80003fa8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f72:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f76:	21848513          	addi	a0,s1,536
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	6c0080e7          	jalr	1728(ra) # 8000163a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f82:	2204b783          	ld	a5,544(s1)
    80003f86:	eb95                	bnez	a5,80003fba <pipeclose+0x64>
    release(&pi->lock);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	41e080e7          	jalr	1054(ra) # 800063a8 <release>
    kfree((char*)pi);
    80003f92:	8526                	mv	a0,s1
    80003f94:	ffffc097          	auipc	ra,0xffffc
    80003f98:	144080e7          	jalr	324(ra) # 800000d8 <kfree>
  } else
    release(&pi->lock);
}
    80003f9c:	60e2                	ld	ra,24(sp)
    80003f9e:	6442                	ld	s0,16(sp)
    80003fa0:	64a2                	ld	s1,8(sp)
    80003fa2:	6902                	ld	s2,0(sp)
    80003fa4:	6105                	addi	sp,sp,32
    80003fa6:	8082                	ret
    pi->readopen = 0;
    80003fa8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fac:	21c48513          	addi	a0,s1,540
    80003fb0:	ffffd097          	auipc	ra,0xffffd
    80003fb4:	68a080e7          	jalr	1674(ra) # 8000163a <wakeup>
    80003fb8:	b7e9                	j	80003f82 <pipeclose+0x2c>
    release(&pi->lock);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	00002097          	auipc	ra,0x2
    80003fc0:	3ec080e7          	jalr	1004(ra) # 800063a8 <release>
}
    80003fc4:	bfe1                	j	80003f9c <pipeclose+0x46>

0000000080003fc6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fc6:	711d                	addi	sp,sp,-96
    80003fc8:	ec86                	sd	ra,88(sp)
    80003fca:	e8a2                	sd	s0,80(sp)
    80003fcc:	e4a6                	sd	s1,72(sp)
    80003fce:	e0ca                	sd	s2,64(sp)
    80003fd0:	fc4e                	sd	s3,56(sp)
    80003fd2:	f852                	sd	s4,48(sp)
    80003fd4:	f456                	sd	s5,40(sp)
    80003fd6:	f05a                	sd	s6,32(sp)
    80003fd8:	ec5e                	sd	s7,24(sp)
    80003fda:	e862                	sd	s8,16(sp)
    80003fdc:	1080                	addi	s0,sp,96
    80003fde:	84aa                	mv	s1,a0
    80003fe0:	8aae                	mv	s5,a1
    80003fe2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	f4a080e7          	jalr	-182(ra) # 80000f2e <myproc>
    80003fec:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	304080e7          	jalr	772(ra) # 800062f4 <acquire>
  while(i < n){
    80003ff8:	0b405663          	blez	s4,800040a4 <pipewrite+0xde>
  int i = 0;
    80003ffc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ffe:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004000:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004004:	21c48b93          	addi	s7,s1,540
    80004008:	a089                	j	8000404a <pipewrite+0x84>
      release(&pi->lock);
    8000400a:	8526                	mv	a0,s1
    8000400c:	00002097          	auipc	ra,0x2
    80004010:	39c080e7          	jalr	924(ra) # 800063a8 <release>
      return -1;
    80004014:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004016:	854a                	mv	a0,s2
    80004018:	60e6                	ld	ra,88(sp)
    8000401a:	6446                	ld	s0,80(sp)
    8000401c:	64a6                	ld	s1,72(sp)
    8000401e:	6906                	ld	s2,64(sp)
    80004020:	79e2                	ld	s3,56(sp)
    80004022:	7a42                	ld	s4,48(sp)
    80004024:	7aa2                	ld	s5,40(sp)
    80004026:	7b02                	ld	s6,32(sp)
    80004028:	6be2                	ld	s7,24(sp)
    8000402a:	6c42                	ld	s8,16(sp)
    8000402c:	6125                	addi	sp,sp,96
    8000402e:	8082                	ret
      wakeup(&pi->nread);
    80004030:	8562                	mv	a0,s8
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	608080e7          	jalr	1544(ra) # 8000163a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000403a:	85a6                	mv	a1,s1
    8000403c:	855e                	mv	a0,s7
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	598080e7          	jalr	1432(ra) # 800015d6 <sleep>
  while(i < n){
    80004046:	07495063          	bge	s2,s4,800040a6 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    8000404a:	2204a783          	lw	a5,544(s1)
    8000404e:	dfd5                	beqz	a5,8000400a <pipewrite+0x44>
    80004050:	854e                	mv	a0,s3
    80004052:	ffffe097          	auipc	ra,0xffffe
    80004056:	82c080e7          	jalr	-2004(ra) # 8000187e <killed>
    8000405a:	f945                	bnez	a0,8000400a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000405c:	2184a783          	lw	a5,536(s1)
    80004060:	21c4a703          	lw	a4,540(s1)
    80004064:	2007879b          	addiw	a5,a5,512
    80004068:	fcf704e3          	beq	a4,a5,80004030 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000406c:	4685                	li	a3,1
    8000406e:	01590633          	add	a2,s2,s5
    80004072:	faf40593          	addi	a1,s0,-81
    80004076:	0509b503          	ld	a0,80(s3)
    8000407a:	ffffd097          	auipc	ra,0xffffd
    8000407e:	c00080e7          	jalr	-1024(ra) # 80000c7a <copyin>
    80004082:	03650263          	beq	a0,s6,800040a6 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004086:	21c4a783          	lw	a5,540(s1)
    8000408a:	0017871b          	addiw	a4,a5,1
    8000408e:	20e4ae23          	sw	a4,540(s1)
    80004092:	1ff7f793          	andi	a5,a5,511
    80004096:	97a6                	add	a5,a5,s1
    80004098:	faf44703          	lbu	a4,-81(s0)
    8000409c:	00e78c23          	sb	a4,24(a5)
      i++;
    800040a0:	2905                	addiw	s2,s2,1
    800040a2:	b755                	j	80004046 <pipewrite+0x80>
  int i = 0;
    800040a4:	4901                	li	s2,0
  wakeup(&pi->nread);
    800040a6:	21848513          	addi	a0,s1,536
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	590080e7          	jalr	1424(ra) # 8000163a <wakeup>
  release(&pi->lock);
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	2f4080e7          	jalr	756(ra) # 800063a8 <release>
  return i;
    800040bc:	bfa9                	j	80004016 <pipewrite+0x50>

00000000800040be <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040be:	715d                	addi	sp,sp,-80
    800040c0:	e486                	sd	ra,72(sp)
    800040c2:	e0a2                	sd	s0,64(sp)
    800040c4:	fc26                	sd	s1,56(sp)
    800040c6:	f84a                	sd	s2,48(sp)
    800040c8:	f44e                	sd	s3,40(sp)
    800040ca:	f052                	sd	s4,32(sp)
    800040cc:	ec56                	sd	s5,24(sp)
    800040ce:	e85a                	sd	s6,16(sp)
    800040d0:	0880                	addi	s0,sp,80
    800040d2:	84aa                	mv	s1,a0
    800040d4:	892e                	mv	s2,a1
    800040d6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	e56080e7          	jalr	-426(ra) # 80000f2e <myproc>
    800040e0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040e2:	8526                	mv	a0,s1
    800040e4:	00002097          	auipc	ra,0x2
    800040e8:	210080e7          	jalr	528(ra) # 800062f4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ec:	2184a703          	lw	a4,536(s1)
    800040f0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f8:	02f71763          	bne	a4,a5,80004126 <piperead+0x68>
    800040fc:	2244a783          	lw	a5,548(s1)
    80004100:	c39d                	beqz	a5,80004126 <piperead+0x68>
    if(killed(pr)){
    80004102:	8552                	mv	a0,s4
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	77a080e7          	jalr	1914(ra) # 8000187e <killed>
    8000410c:	e949                	bnez	a0,8000419e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000410e:	85a6                	mv	a1,s1
    80004110:	854e                	mv	a0,s3
    80004112:	ffffd097          	auipc	ra,0xffffd
    80004116:	4c4080e7          	jalr	1220(ra) # 800015d6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000411a:	2184a703          	lw	a4,536(s1)
    8000411e:	21c4a783          	lw	a5,540(s1)
    80004122:	fcf70de3          	beq	a4,a5,800040fc <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004126:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004128:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000412a:	05505463          	blez	s5,80004172 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000412e:	2184a783          	lw	a5,536(s1)
    80004132:	21c4a703          	lw	a4,540(s1)
    80004136:	02f70e63          	beq	a4,a5,80004172 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000413a:	0017871b          	addiw	a4,a5,1
    8000413e:	20e4ac23          	sw	a4,536(s1)
    80004142:	1ff7f793          	andi	a5,a5,511
    80004146:	97a6                	add	a5,a5,s1
    80004148:	0187c783          	lbu	a5,24(a5)
    8000414c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004150:	4685                	li	a3,1
    80004152:	fbf40613          	addi	a2,s0,-65
    80004156:	85ca                	mv	a1,s2
    80004158:	050a3503          	ld	a0,80(s4)
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	a92080e7          	jalr	-1390(ra) # 80000bee <copyout>
    80004164:	01650763          	beq	a0,s6,80004172 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004168:	2985                	addiw	s3,s3,1
    8000416a:	0905                	addi	s2,s2,1
    8000416c:	fd3a91e3          	bne	s5,s3,8000412e <piperead+0x70>
    80004170:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004172:	21c48513          	addi	a0,s1,540
    80004176:	ffffd097          	auipc	ra,0xffffd
    8000417a:	4c4080e7          	jalr	1220(ra) # 8000163a <wakeup>
  release(&pi->lock);
    8000417e:	8526                	mv	a0,s1
    80004180:	00002097          	auipc	ra,0x2
    80004184:	228080e7          	jalr	552(ra) # 800063a8 <release>
  return i;
}
    80004188:	854e                	mv	a0,s3
    8000418a:	60a6                	ld	ra,72(sp)
    8000418c:	6406                	ld	s0,64(sp)
    8000418e:	74e2                	ld	s1,56(sp)
    80004190:	7942                	ld	s2,48(sp)
    80004192:	79a2                	ld	s3,40(sp)
    80004194:	7a02                	ld	s4,32(sp)
    80004196:	6ae2                	ld	s5,24(sp)
    80004198:	6b42                	ld	s6,16(sp)
    8000419a:	6161                	addi	sp,sp,80
    8000419c:	8082                	ret
      release(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	208080e7          	jalr	520(ra) # 800063a8 <release>
      return -1;
    800041a8:	59fd                	li	s3,-1
    800041aa:	bff9                	j	80004188 <piperead+0xca>

00000000800041ac <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041ac:	1141                	addi	sp,sp,-16
    800041ae:	e422                	sd	s0,8(sp)
    800041b0:	0800                	addi	s0,sp,16
    800041b2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041b4:	8905                	andi	a0,a0,1
    800041b6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041b8:	8b89                	andi	a5,a5,2
    800041ba:	c399                	beqz	a5,800041c0 <flags2perm+0x14>
      perm |= PTE_W;
    800041bc:	00456513          	ori	a0,a0,4
    return perm;
}
    800041c0:	6422                	ld	s0,8(sp)
    800041c2:	0141                	addi	sp,sp,16
    800041c4:	8082                	ret

00000000800041c6 <exec>:

int
exec(char *path, char **argv)
{
    800041c6:	de010113          	addi	sp,sp,-544
    800041ca:	20113c23          	sd	ra,536(sp)
    800041ce:	20813823          	sd	s0,528(sp)
    800041d2:	20913423          	sd	s1,520(sp)
    800041d6:	21213023          	sd	s2,512(sp)
    800041da:	ffce                	sd	s3,504(sp)
    800041dc:	fbd2                	sd	s4,496(sp)
    800041de:	f7d6                	sd	s5,488(sp)
    800041e0:	f3da                	sd	s6,480(sp)
    800041e2:	efde                	sd	s7,472(sp)
    800041e4:	ebe2                	sd	s8,464(sp)
    800041e6:	e7e6                	sd	s9,456(sp)
    800041e8:	e3ea                	sd	s10,448(sp)
    800041ea:	ff6e                	sd	s11,440(sp)
    800041ec:	1400                	addi	s0,sp,544
    800041ee:	892a                	mv	s2,a0
    800041f0:	dea43423          	sd	a0,-536(s0)
    800041f4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041f8:	ffffd097          	auipc	ra,0xffffd
    800041fc:	d36080e7          	jalr	-714(ra) # 80000f2e <myproc>
    80004200:	84aa                	mv	s1,a0

  begin_op();
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	482080e7          	jalr	1154(ra) # 80003684 <begin_op>

  if((ip = namei(path)) == 0){
    8000420a:	854a                	mv	a0,s2
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	258080e7          	jalr	600(ra) # 80003464 <namei>
    80004214:	c93d                	beqz	a0,8000428a <exec+0xc4>
    80004216:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	aa0080e7          	jalr	-1376(ra) # 80002cb8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004220:	04000713          	li	a4,64
    80004224:	4681                	li	a3,0
    80004226:	e5040613          	addi	a2,s0,-432
    8000422a:	4581                	li	a1,0
    8000422c:	8556                	mv	a0,s5
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	d3e080e7          	jalr	-706(ra) # 80002f6c <readi>
    80004236:	04000793          	li	a5,64
    8000423a:	00f51a63          	bne	a0,a5,8000424e <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000423e:	e5042703          	lw	a4,-432(s0)
    80004242:	464c47b7          	lui	a5,0x464c4
    80004246:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000424a:	04f70663          	beq	a4,a5,80004296 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000424e:	8556                	mv	a0,s5
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	cca080e7          	jalr	-822(ra) # 80002f1a <iunlockput>
    end_op();
    80004258:	fffff097          	auipc	ra,0xfffff
    8000425c:	4aa080e7          	jalr	1194(ra) # 80003702 <end_op>
  }
  return -1;
    80004260:	557d                	li	a0,-1
}
    80004262:	21813083          	ld	ra,536(sp)
    80004266:	21013403          	ld	s0,528(sp)
    8000426a:	20813483          	ld	s1,520(sp)
    8000426e:	20013903          	ld	s2,512(sp)
    80004272:	79fe                	ld	s3,504(sp)
    80004274:	7a5e                	ld	s4,496(sp)
    80004276:	7abe                	ld	s5,488(sp)
    80004278:	7b1e                	ld	s6,480(sp)
    8000427a:	6bfe                	ld	s7,472(sp)
    8000427c:	6c5e                	ld	s8,464(sp)
    8000427e:	6cbe                	ld	s9,456(sp)
    80004280:	6d1e                	ld	s10,448(sp)
    80004282:	7dfa                	ld	s11,440(sp)
    80004284:	22010113          	addi	sp,sp,544
    80004288:	8082                	ret
    end_op();
    8000428a:	fffff097          	auipc	ra,0xfffff
    8000428e:	478080e7          	jalr	1144(ra) # 80003702 <end_op>
    return -1;
    80004292:	557d                	li	a0,-1
    80004294:	b7f9                	j	80004262 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004296:	8526                	mv	a0,s1
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	d5a080e7          	jalr	-678(ra) # 80000ff2 <proc_pagetable>
    800042a0:	8b2a                	mv	s6,a0
    800042a2:	d555                	beqz	a0,8000424e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a4:	e7042783          	lw	a5,-400(s0)
    800042a8:	e8845703          	lhu	a4,-376(s0)
    800042ac:	c735                	beqz	a4,80004318 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ae:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b0:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    800042b4:	6a05                	lui	s4,0x1
    800042b6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042ba:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042be:	6d85                	lui	s11,0x1
    800042c0:	7d7d                	lui	s10,0xfffff
    800042c2:	ac3d                	j	80004500 <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042c4:	00004517          	auipc	a0,0x4
    800042c8:	37c50513          	addi	a0,a0,892 # 80008640 <syscalls+0x280>
    800042cc:	00002097          	auipc	ra,0x2
    800042d0:	aa0080e7          	jalr	-1376(ra) # 80005d6c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042d4:	874a                	mv	a4,s2
    800042d6:	009c86bb          	addw	a3,s9,s1
    800042da:	4581                	li	a1,0
    800042dc:	8556                	mv	a0,s5
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	c8e080e7          	jalr	-882(ra) # 80002f6c <readi>
    800042e6:	2501                	sext.w	a0,a0
    800042e8:	1aa91963          	bne	s2,a0,8000449a <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800042ec:	009d84bb          	addw	s1,s11,s1
    800042f0:	013d09bb          	addw	s3,s10,s3
    800042f4:	1f74f663          	bgeu	s1,s7,800044e0 <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800042f8:	02049593          	slli	a1,s1,0x20
    800042fc:	9181                	srli	a1,a1,0x20
    800042fe:	95e2                	add	a1,a1,s8
    80004300:	855a                	mv	a0,s6
    80004302:	ffffc097          	auipc	ra,0xffffc
    80004306:	2f8080e7          	jalr	760(ra) # 800005fa <walkaddr>
    8000430a:	862a                	mv	a2,a0
    if(pa == 0)
    8000430c:	dd45                	beqz	a0,800042c4 <exec+0xfe>
      n = PGSIZE;
    8000430e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004310:	fd49f2e3          	bgeu	s3,s4,800042d4 <exec+0x10e>
      n = sz - i;
    80004314:	894e                	mv	s2,s3
    80004316:	bf7d                	j	800042d4 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004318:	4901                	li	s2,0
  iunlockput(ip);
    8000431a:	8556                	mv	a0,s5
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	bfe080e7          	jalr	-1026(ra) # 80002f1a <iunlockput>
  end_op();
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	3de080e7          	jalr	990(ra) # 80003702 <end_op>
  p = myproc();
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	c02080e7          	jalr	-1022(ra) # 80000f2e <myproc>
    80004334:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004336:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000433a:	6785                	lui	a5,0x1
    8000433c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000433e:	97ca                	add	a5,a5,s2
    80004340:	777d                	lui	a4,0xfffff
    80004342:	8ff9                	and	a5,a5,a4
    80004344:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004348:	4691                	li	a3,4
    8000434a:	6609                	lui	a2,0x2
    8000434c:	963e                	add	a2,a2,a5
    8000434e:	85be                	mv	a1,a5
    80004350:	855a                	mv	a0,s6
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	646080e7          	jalr	1606(ra) # 80000998 <uvmalloc>
    8000435a:	8c2a                	mv	s8,a0
  ip = 0;
    8000435c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000435e:	12050e63          	beqz	a0,8000449a <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004362:	75f9                	lui	a1,0xffffe
    80004364:	95aa                	add	a1,a1,a0
    80004366:	855a                	mv	a0,s6
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	854080e7          	jalr	-1964(ra) # 80000bbc <uvmclear>
  stackbase = sp - PGSIZE;
    80004370:	7afd                	lui	s5,0xfffff
    80004372:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004374:	df043783          	ld	a5,-528(s0)
    80004378:	6388                	ld	a0,0(a5)
    8000437a:	c925                	beqz	a0,800043ea <exec+0x224>
    8000437c:	e9040993          	addi	s3,s0,-368
    80004380:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004384:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004386:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	064080e7          	jalr	100(ra) # 800003ec <strlen>
    80004390:	0015079b          	addiw	a5,a0,1
    80004394:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004398:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000439c:	13596663          	bltu	s2,s5,800044c8 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043a0:	df043d83          	ld	s11,-528(s0)
    800043a4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043a8:	8552                	mv	a0,s4
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	042080e7          	jalr	66(ra) # 800003ec <strlen>
    800043b2:	0015069b          	addiw	a3,a0,1
    800043b6:	8652                	mv	a2,s4
    800043b8:	85ca                	mv	a1,s2
    800043ba:	855a                	mv	a0,s6
    800043bc:	ffffd097          	auipc	ra,0xffffd
    800043c0:	832080e7          	jalr	-1998(ra) # 80000bee <copyout>
    800043c4:	10054663          	bltz	a0,800044d0 <exec+0x30a>
    ustack[argc] = sp;
    800043c8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043cc:	0485                	addi	s1,s1,1
    800043ce:	008d8793          	addi	a5,s11,8
    800043d2:	def43823          	sd	a5,-528(s0)
    800043d6:	008db503          	ld	a0,8(s11)
    800043da:	c911                	beqz	a0,800043ee <exec+0x228>
    if(argc >= MAXARG)
    800043dc:	09a1                	addi	s3,s3,8
    800043de:	fb3c95e3          	bne	s9,s3,80004388 <exec+0x1c2>
  sz = sz1;
    800043e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e6:	4a81                	li	s5,0
    800043e8:	a84d                	j	8000449a <exec+0x2d4>
  sp = sz;
    800043ea:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043ec:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ee:	00349793          	slli	a5,s1,0x3
    800043f2:	f9078793          	addi	a5,a5,-112
    800043f6:	97a2                	add	a5,a5,s0
    800043f8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043fc:	00148693          	addi	a3,s1,1
    80004400:	068e                	slli	a3,a3,0x3
    80004402:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004406:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000440a:	01597663          	bgeu	s2,s5,80004416 <exec+0x250>
  sz = sz1;
    8000440e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004412:	4a81                	li	s5,0
    80004414:	a059                	j	8000449a <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004416:	e9040613          	addi	a2,s0,-368
    8000441a:	85ca                	mv	a1,s2
    8000441c:	855a                	mv	a0,s6
    8000441e:	ffffc097          	auipc	ra,0xffffc
    80004422:	7d0080e7          	jalr	2000(ra) # 80000bee <copyout>
    80004426:	0a054963          	bltz	a0,800044d8 <exec+0x312>
  p->trapframe->a1 = sp;
    8000442a:	058bb783          	ld	a5,88(s7)
    8000442e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004432:	de843783          	ld	a5,-536(s0)
    80004436:	0007c703          	lbu	a4,0(a5)
    8000443a:	cf11                	beqz	a4,80004456 <exec+0x290>
    8000443c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443e:	02f00693          	li	a3,47
    80004442:	a039                	j	80004450 <exec+0x28a>
      last = s+1;
    80004444:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004448:	0785                	addi	a5,a5,1
    8000444a:	fff7c703          	lbu	a4,-1(a5)
    8000444e:	c701                	beqz	a4,80004456 <exec+0x290>
    if(*s == '/')
    80004450:	fed71ce3          	bne	a4,a3,80004448 <exec+0x282>
    80004454:	bfc5                	j	80004444 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004456:	4641                	li	a2,16
    80004458:	de843583          	ld	a1,-536(s0)
    8000445c:	158b8513          	addi	a0,s7,344
    80004460:	ffffc097          	auipc	ra,0xffffc
    80004464:	f5a080e7          	jalr	-166(ra) # 800003ba <safestrcpy>
  oldpagetable = p->pagetable;
    80004468:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000446c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004470:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004474:	058bb783          	ld	a5,88(s7)
    80004478:	e6843703          	ld	a4,-408(s0)
    8000447c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447e:	058bb783          	ld	a5,88(s7)
    80004482:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004486:	85ea                	mv	a1,s10
    80004488:	ffffd097          	auipc	ra,0xffffd
    8000448c:	c06080e7          	jalr	-1018(ra) # 8000108e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004490:	0004851b          	sext.w	a0,s1
    80004494:	b3f9                	j	80004262 <exec+0x9c>
    80004496:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000449a:	df843583          	ld	a1,-520(s0)
    8000449e:	855a                	mv	a0,s6
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	bee080e7          	jalr	-1042(ra) # 8000108e <proc_freepagetable>
  if(ip){
    800044a8:	da0a93e3          	bnez	s5,8000424e <exec+0x88>
  return -1;
    800044ac:	557d                	li	a0,-1
    800044ae:	bb55                	j	80004262 <exec+0x9c>
    800044b0:	df243c23          	sd	s2,-520(s0)
    800044b4:	b7dd                	j	8000449a <exec+0x2d4>
    800044b6:	df243c23          	sd	s2,-520(s0)
    800044ba:	b7c5                	j	8000449a <exec+0x2d4>
    800044bc:	df243c23          	sd	s2,-520(s0)
    800044c0:	bfe9                	j	8000449a <exec+0x2d4>
    800044c2:	df243c23          	sd	s2,-520(s0)
    800044c6:	bfd1                	j	8000449a <exec+0x2d4>
  sz = sz1;
    800044c8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044cc:	4a81                	li	s5,0
    800044ce:	b7f1                	j	8000449a <exec+0x2d4>
  sz = sz1;
    800044d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044d4:	4a81                	li	s5,0
    800044d6:	b7d1                	j	8000449a <exec+0x2d4>
  sz = sz1;
    800044d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044dc:	4a81                	li	s5,0
    800044de:	bf75                	j	8000449a <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044e0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044e4:	e0843783          	ld	a5,-504(s0)
    800044e8:	0017869b          	addiw	a3,a5,1
    800044ec:	e0d43423          	sd	a3,-504(s0)
    800044f0:	e0043783          	ld	a5,-512(s0)
    800044f4:	0387879b          	addiw	a5,a5,56
    800044f8:	e8845703          	lhu	a4,-376(s0)
    800044fc:	e0e6dfe3          	bge	a3,a4,8000431a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004500:	2781                	sext.w	a5,a5
    80004502:	e0f43023          	sd	a5,-512(s0)
    80004506:	03800713          	li	a4,56
    8000450a:	86be                	mv	a3,a5
    8000450c:	e1840613          	addi	a2,s0,-488
    80004510:	4581                	li	a1,0
    80004512:	8556                	mv	a0,s5
    80004514:	fffff097          	auipc	ra,0xfffff
    80004518:	a58080e7          	jalr	-1448(ra) # 80002f6c <readi>
    8000451c:	03800793          	li	a5,56
    80004520:	f6f51be3          	bne	a0,a5,80004496 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    80004524:	e1842783          	lw	a5,-488(s0)
    80004528:	4705                	li	a4,1
    8000452a:	fae79de3          	bne	a5,a4,800044e4 <exec+0x31e>
    if(ph.memsz < ph.filesz)
    8000452e:	e4043483          	ld	s1,-448(s0)
    80004532:	e3843783          	ld	a5,-456(s0)
    80004536:	f6f4ede3          	bltu	s1,a5,800044b0 <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000453a:	e2843783          	ld	a5,-472(s0)
    8000453e:	94be                	add	s1,s1,a5
    80004540:	f6f4ebe3          	bltu	s1,a5,800044b6 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    80004544:	de043703          	ld	a4,-544(s0)
    80004548:	8ff9                	and	a5,a5,a4
    8000454a:	fbad                	bnez	a5,800044bc <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000454c:	e1c42503          	lw	a0,-484(s0)
    80004550:	00000097          	auipc	ra,0x0
    80004554:	c5c080e7          	jalr	-932(ra) # 800041ac <flags2perm>
    80004558:	86aa                	mv	a3,a0
    8000455a:	8626                	mv	a2,s1
    8000455c:	85ca                	mv	a1,s2
    8000455e:	855a                	mv	a0,s6
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	438080e7          	jalr	1080(ra) # 80000998 <uvmalloc>
    80004568:	dea43c23          	sd	a0,-520(s0)
    8000456c:	d939                	beqz	a0,800044c2 <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000456e:	e2843c03          	ld	s8,-472(s0)
    80004572:	e2042c83          	lw	s9,-480(s0)
    80004576:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000457a:	f60b83e3          	beqz	s7,800044e0 <exec+0x31a>
    8000457e:	89de                	mv	s3,s7
    80004580:	4481                	li	s1,0
    80004582:	bb9d                	j	800042f8 <exec+0x132>

0000000080004584 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004584:	7179                	addi	sp,sp,-48
    80004586:	f406                	sd	ra,40(sp)
    80004588:	f022                	sd	s0,32(sp)
    8000458a:	ec26                	sd	s1,24(sp)
    8000458c:	e84a                	sd	s2,16(sp)
    8000458e:	1800                	addi	s0,sp,48
    80004590:	892e                	mv	s2,a1
    80004592:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004594:	fdc40593          	addi	a1,s0,-36
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	ba0080e7          	jalr	-1120(ra) # 80002138 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045a0:	fdc42703          	lw	a4,-36(s0)
    800045a4:	47bd                	li	a5,15
    800045a6:	02e7eb63          	bltu	a5,a4,800045dc <argfd+0x58>
    800045aa:	ffffd097          	auipc	ra,0xffffd
    800045ae:	984080e7          	jalr	-1660(ra) # 80000f2e <myproc>
    800045b2:	fdc42703          	lw	a4,-36(s0)
    800045b6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffbd2ca>
    800045ba:	078e                	slli	a5,a5,0x3
    800045bc:	953e                	add	a0,a0,a5
    800045be:	611c                	ld	a5,0(a0)
    800045c0:	c385                	beqz	a5,800045e0 <argfd+0x5c>
    return -1;
  if(pfd)
    800045c2:	00090463          	beqz	s2,800045ca <argfd+0x46>
    *pfd = fd;
    800045c6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045ca:	4501                	li	a0,0
  if(pf)
    800045cc:	c091                	beqz	s1,800045d0 <argfd+0x4c>
    *pf = f;
    800045ce:	e09c                	sd	a5,0(s1)
}
    800045d0:	70a2                	ld	ra,40(sp)
    800045d2:	7402                	ld	s0,32(sp)
    800045d4:	64e2                	ld	s1,24(sp)
    800045d6:	6942                	ld	s2,16(sp)
    800045d8:	6145                	addi	sp,sp,48
    800045da:	8082                	ret
    return -1;
    800045dc:	557d                	li	a0,-1
    800045de:	bfcd                	j	800045d0 <argfd+0x4c>
    800045e0:	557d                	li	a0,-1
    800045e2:	b7fd                	j	800045d0 <argfd+0x4c>

00000000800045e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045e4:	1101                	addi	sp,sp,-32
    800045e6:	ec06                	sd	ra,24(sp)
    800045e8:	e822                	sd	s0,16(sp)
    800045ea:	e426                	sd	s1,8(sp)
    800045ec:	1000                	addi	s0,sp,32
    800045ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045f0:	ffffd097          	auipc	ra,0xffffd
    800045f4:	93e080e7          	jalr	-1730(ra) # 80000f2e <myproc>
    800045f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045fa:	0d050793          	addi	a5,a0,208
    800045fe:	4501                	li	a0,0
    80004600:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004602:	6398                	ld	a4,0(a5)
    80004604:	cb19                	beqz	a4,8000461a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004606:	2505                	addiw	a0,a0,1
    80004608:	07a1                	addi	a5,a5,8
    8000460a:	fed51ce3          	bne	a0,a3,80004602 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000460e:	557d                	li	a0,-1
}
    80004610:	60e2                	ld	ra,24(sp)
    80004612:	6442                	ld	s0,16(sp)
    80004614:	64a2                	ld	s1,8(sp)
    80004616:	6105                	addi	sp,sp,32
    80004618:	8082                	ret
      p->ofile[fd] = f;
    8000461a:	01a50793          	addi	a5,a0,26
    8000461e:	078e                	slli	a5,a5,0x3
    80004620:	963e                	add	a2,a2,a5
    80004622:	e204                	sd	s1,0(a2)
      return fd;
    80004624:	b7f5                	j	80004610 <fdalloc+0x2c>

0000000080004626 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004626:	715d                	addi	sp,sp,-80
    80004628:	e486                	sd	ra,72(sp)
    8000462a:	e0a2                	sd	s0,64(sp)
    8000462c:	fc26                	sd	s1,56(sp)
    8000462e:	f84a                	sd	s2,48(sp)
    80004630:	f44e                	sd	s3,40(sp)
    80004632:	f052                	sd	s4,32(sp)
    80004634:	ec56                	sd	s5,24(sp)
    80004636:	e85a                	sd	s6,16(sp)
    80004638:	0880                	addi	s0,sp,80
    8000463a:	8b2e                	mv	s6,a1
    8000463c:	89b2                	mv	s3,a2
    8000463e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004640:	fb040593          	addi	a1,s0,-80
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	e3e080e7          	jalr	-450(ra) # 80003482 <nameiparent>
    8000464c:	84aa                	mv	s1,a0
    8000464e:	14050f63          	beqz	a0,800047ac <create+0x186>
    return 0;

  ilock(dp);
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	666080e7          	jalr	1638(ra) # 80002cb8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000465a:	4601                	li	a2,0
    8000465c:	fb040593          	addi	a1,s0,-80
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	b3a080e7          	jalr	-1222(ra) # 8000319c <dirlookup>
    8000466a:	8aaa                	mv	s5,a0
    8000466c:	c931                	beqz	a0,800046c0 <create+0x9a>
    iunlockput(dp);
    8000466e:	8526                	mv	a0,s1
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	8aa080e7          	jalr	-1878(ra) # 80002f1a <iunlockput>
    ilock(ip);
    80004678:	8556                	mv	a0,s5
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	63e080e7          	jalr	1598(ra) # 80002cb8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004682:	000b059b          	sext.w	a1,s6
    80004686:	4789                	li	a5,2
    80004688:	02f59563          	bne	a1,a5,800046b2 <create+0x8c>
    8000468c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffbd2f4>
    80004690:	37f9                	addiw	a5,a5,-2
    80004692:	17c2                	slli	a5,a5,0x30
    80004694:	93c1                	srli	a5,a5,0x30
    80004696:	4705                	li	a4,1
    80004698:	00f76d63          	bltu	a4,a5,800046b2 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000469c:	8556                	mv	a0,s5
    8000469e:	60a6                	ld	ra,72(sp)
    800046a0:	6406                	ld	s0,64(sp)
    800046a2:	74e2                	ld	s1,56(sp)
    800046a4:	7942                	ld	s2,48(sp)
    800046a6:	79a2                	ld	s3,40(sp)
    800046a8:	7a02                	ld	s4,32(sp)
    800046aa:	6ae2                	ld	s5,24(sp)
    800046ac:	6b42                	ld	s6,16(sp)
    800046ae:	6161                	addi	sp,sp,80
    800046b0:	8082                	ret
    iunlockput(ip);
    800046b2:	8556                	mv	a0,s5
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	866080e7          	jalr	-1946(ra) # 80002f1a <iunlockput>
    return 0;
    800046bc:	4a81                	li	s5,0
    800046be:	bff9                	j	8000469c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800046c0:	85da                	mv	a1,s6
    800046c2:	4088                	lw	a0,0(s1)
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	456080e7          	jalr	1110(ra) # 80002b1a <ialloc>
    800046cc:	8a2a                	mv	s4,a0
    800046ce:	c539                	beqz	a0,8000471c <create+0xf6>
  ilock(ip);
    800046d0:	ffffe097          	auipc	ra,0xffffe
    800046d4:	5e8080e7          	jalr	1512(ra) # 80002cb8 <ilock>
  ip->major = major;
    800046d8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046dc:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046e0:	4905                	li	s2,1
    800046e2:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046e6:	8552                	mv	a0,s4
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	504080e7          	jalr	1284(ra) # 80002bec <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046f0:	000b059b          	sext.w	a1,s6
    800046f4:	03258b63          	beq	a1,s2,8000472a <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f8:	004a2603          	lw	a2,4(s4)
    800046fc:	fb040593          	addi	a1,s0,-80
    80004700:	8526                	mv	a0,s1
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	cb0080e7          	jalr	-848(ra) # 800033b2 <dirlink>
    8000470a:	06054f63          	bltz	a0,80004788 <create+0x162>
  iunlockput(dp);
    8000470e:	8526                	mv	a0,s1
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	80a080e7          	jalr	-2038(ra) # 80002f1a <iunlockput>
  return ip;
    80004718:	8ad2                	mv	s5,s4
    8000471a:	b749                	j	8000469c <create+0x76>
    iunlockput(dp);
    8000471c:	8526                	mv	a0,s1
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	7fc080e7          	jalr	2044(ra) # 80002f1a <iunlockput>
    return 0;
    80004726:	8ad2                	mv	s5,s4
    80004728:	bf95                	j	8000469c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000472a:	004a2603          	lw	a2,4(s4)
    8000472e:	00004597          	auipc	a1,0x4
    80004732:	f3258593          	addi	a1,a1,-206 # 80008660 <syscalls+0x2a0>
    80004736:	8552                	mv	a0,s4
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	c7a080e7          	jalr	-902(ra) # 800033b2 <dirlink>
    80004740:	04054463          	bltz	a0,80004788 <create+0x162>
    80004744:	40d0                	lw	a2,4(s1)
    80004746:	00004597          	auipc	a1,0x4
    8000474a:	f2258593          	addi	a1,a1,-222 # 80008668 <syscalls+0x2a8>
    8000474e:	8552                	mv	a0,s4
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	c62080e7          	jalr	-926(ra) # 800033b2 <dirlink>
    80004758:	02054863          	bltz	a0,80004788 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    8000475c:	004a2603          	lw	a2,4(s4)
    80004760:	fb040593          	addi	a1,s0,-80
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	c4c080e7          	jalr	-948(ra) # 800033b2 <dirlink>
    8000476e:	00054d63          	bltz	a0,80004788 <create+0x162>
    dp->nlink++;  // for ".."
    80004772:	04a4d783          	lhu	a5,74(s1)
    80004776:	2785                	addiw	a5,a5,1
    80004778:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000477c:	8526                	mv	a0,s1
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	46e080e7          	jalr	1134(ra) # 80002bec <iupdate>
    80004786:	b761                	j	8000470e <create+0xe8>
  ip->nlink = 0;
    80004788:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000478c:	8552                	mv	a0,s4
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	45e080e7          	jalr	1118(ra) # 80002bec <iupdate>
  iunlockput(ip);
    80004796:	8552                	mv	a0,s4
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	782080e7          	jalr	1922(ra) # 80002f1a <iunlockput>
  iunlockput(dp);
    800047a0:	8526                	mv	a0,s1
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	778080e7          	jalr	1912(ra) # 80002f1a <iunlockput>
  return 0;
    800047aa:	bdcd                	j	8000469c <create+0x76>
    return 0;
    800047ac:	8aaa                	mv	s5,a0
    800047ae:	b5fd                	j	8000469c <create+0x76>

00000000800047b0 <sys_dup>:
{
    800047b0:	7179                	addi	sp,sp,-48
    800047b2:	f406                	sd	ra,40(sp)
    800047b4:	f022                	sd	s0,32(sp)
    800047b6:	ec26                	sd	s1,24(sp)
    800047b8:	e84a                	sd	s2,16(sp)
    800047ba:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047bc:	fd840613          	addi	a2,s0,-40
    800047c0:	4581                	li	a1,0
    800047c2:	4501                	li	a0,0
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	dc0080e7          	jalr	-576(ra) # 80004584 <argfd>
    return -1;
    800047cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ce:	02054363          	bltz	a0,800047f4 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047d2:	fd843903          	ld	s2,-40(s0)
    800047d6:	854a                	mv	a0,s2
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	e0c080e7          	jalr	-500(ra) # 800045e4 <fdalloc>
    800047e0:	84aa                	mv	s1,a0
    return -1;
    800047e2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047e4:	00054863          	bltz	a0,800047f4 <sys_dup+0x44>
  filedup(f);
    800047e8:	854a                	mv	a0,s2
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	310080e7          	jalr	784(ra) # 80003afa <filedup>
  return fd;
    800047f2:	87a6                	mv	a5,s1
}
    800047f4:	853e                	mv	a0,a5
    800047f6:	70a2                	ld	ra,40(sp)
    800047f8:	7402                	ld	s0,32(sp)
    800047fa:	64e2                	ld	s1,24(sp)
    800047fc:	6942                	ld	s2,16(sp)
    800047fe:	6145                	addi	sp,sp,48
    80004800:	8082                	ret

0000000080004802 <sys_read>:
{
    80004802:	7179                	addi	sp,sp,-48
    80004804:	f406                	sd	ra,40(sp)
    80004806:	f022                	sd	s0,32(sp)
    80004808:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000480a:	fd840593          	addi	a1,s0,-40
    8000480e:	4505                	li	a0,1
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	948080e7          	jalr	-1720(ra) # 80002158 <argaddr>
  argint(2, &n);
    80004818:	fe440593          	addi	a1,s0,-28
    8000481c:	4509                	li	a0,2
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	91a080e7          	jalr	-1766(ra) # 80002138 <argint>
  if(argfd(0, 0, &f) < 0)
    80004826:	fe840613          	addi	a2,s0,-24
    8000482a:	4581                	li	a1,0
    8000482c:	4501                	li	a0,0
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	d56080e7          	jalr	-682(ra) # 80004584 <argfd>
    80004836:	87aa                	mv	a5,a0
    return -1;
    80004838:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000483a:	0007cc63          	bltz	a5,80004852 <sys_read+0x50>
  return fileread(f, p, n);
    8000483e:	fe442603          	lw	a2,-28(s0)
    80004842:	fd843583          	ld	a1,-40(s0)
    80004846:	fe843503          	ld	a0,-24(s0)
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	43c080e7          	jalr	1084(ra) # 80003c86 <fileread>
}
    80004852:	70a2                	ld	ra,40(sp)
    80004854:	7402                	ld	s0,32(sp)
    80004856:	6145                	addi	sp,sp,48
    80004858:	8082                	ret

000000008000485a <sys_write>:
{
    8000485a:	7179                	addi	sp,sp,-48
    8000485c:	f406                	sd	ra,40(sp)
    8000485e:	f022                	sd	s0,32(sp)
    80004860:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004862:	fd840593          	addi	a1,s0,-40
    80004866:	4505                	li	a0,1
    80004868:	ffffe097          	auipc	ra,0xffffe
    8000486c:	8f0080e7          	jalr	-1808(ra) # 80002158 <argaddr>
  argint(2, &n);
    80004870:	fe440593          	addi	a1,s0,-28
    80004874:	4509                	li	a0,2
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	8c2080e7          	jalr	-1854(ra) # 80002138 <argint>
  if(argfd(0, 0, &f) < 0)
    8000487e:	fe840613          	addi	a2,s0,-24
    80004882:	4581                	li	a1,0
    80004884:	4501                	li	a0,0
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	cfe080e7          	jalr	-770(ra) # 80004584 <argfd>
    8000488e:	87aa                	mv	a5,a0
    return -1;
    80004890:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004892:	0007cc63          	bltz	a5,800048aa <sys_write+0x50>
  return filewrite(f, p, n);
    80004896:	fe442603          	lw	a2,-28(s0)
    8000489a:	fd843583          	ld	a1,-40(s0)
    8000489e:	fe843503          	ld	a0,-24(s0)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	4a6080e7          	jalr	1190(ra) # 80003d48 <filewrite>
}
    800048aa:	70a2                	ld	ra,40(sp)
    800048ac:	7402                	ld	s0,32(sp)
    800048ae:	6145                	addi	sp,sp,48
    800048b0:	8082                	ret

00000000800048b2 <sys_close>:
{
    800048b2:	1101                	addi	sp,sp,-32
    800048b4:	ec06                	sd	ra,24(sp)
    800048b6:	e822                	sd	s0,16(sp)
    800048b8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ba:	fe040613          	addi	a2,s0,-32
    800048be:	fec40593          	addi	a1,s0,-20
    800048c2:	4501                	li	a0,0
    800048c4:	00000097          	auipc	ra,0x0
    800048c8:	cc0080e7          	jalr	-832(ra) # 80004584 <argfd>
    return -1;
    800048cc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048ce:	02054463          	bltz	a0,800048f6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048d2:	ffffc097          	auipc	ra,0xffffc
    800048d6:	65c080e7          	jalr	1628(ra) # 80000f2e <myproc>
    800048da:	fec42783          	lw	a5,-20(s0)
    800048de:	07e9                	addi	a5,a5,26
    800048e0:	078e                	slli	a5,a5,0x3
    800048e2:	953e                	add	a0,a0,a5
    800048e4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048e8:	fe043503          	ld	a0,-32(s0)
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	260080e7          	jalr	608(ra) # 80003b4c <fileclose>
  return 0;
    800048f4:	4781                	li	a5,0
}
    800048f6:	853e                	mv	a0,a5
    800048f8:	60e2                	ld	ra,24(sp)
    800048fa:	6442                	ld	s0,16(sp)
    800048fc:	6105                	addi	sp,sp,32
    800048fe:	8082                	ret

0000000080004900 <sys_fstat>:
{
    80004900:	1101                	addi	sp,sp,-32
    80004902:	ec06                	sd	ra,24(sp)
    80004904:	e822                	sd	s0,16(sp)
    80004906:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004908:	fe040593          	addi	a1,s0,-32
    8000490c:	4505                	li	a0,1
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	84a080e7          	jalr	-1974(ra) # 80002158 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004916:	fe840613          	addi	a2,s0,-24
    8000491a:	4581                	li	a1,0
    8000491c:	4501                	li	a0,0
    8000491e:	00000097          	auipc	ra,0x0
    80004922:	c66080e7          	jalr	-922(ra) # 80004584 <argfd>
    80004926:	87aa                	mv	a5,a0
    return -1;
    80004928:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000492a:	0007ca63          	bltz	a5,8000493e <sys_fstat+0x3e>
  return filestat(f, st);
    8000492e:	fe043583          	ld	a1,-32(s0)
    80004932:	fe843503          	ld	a0,-24(s0)
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	2de080e7          	jalr	734(ra) # 80003c14 <filestat>
}
    8000493e:	60e2                	ld	ra,24(sp)
    80004940:	6442                	ld	s0,16(sp)
    80004942:	6105                	addi	sp,sp,32
    80004944:	8082                	ret

0000000080004946 <sys_link>:
{
    80004946:	7169                	addi	sp,sp,-304
    80004948:	f606                	sd	ra,296(sp)
    8000494a:	f222                	sd	s0,288(sp)
    8000494c:	ee26                	sd	s1,280(sp)
    8000494e:	ea4a                	sd	s2,272(sp)
    80004950:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004952:	08000613          	li	a2,128
    80004956:	ed040593          	addi	a1,s0,-304
    8000495a:	4501                	li	a0,0
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	81c080e7          	jalr	-2020(ra) # 80002178 <argstr>
    return -1;
    80004964:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004966:	10054e63          	bltz	a0,80004a82 <sys_link+0x13c>
    8000496a:	08000613          	li	a2,128
    8000496e:	f5040593          	addi	a1,s0,-176
    80004972:	4505                	li	a0,1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	804080e7          	jalr	-2044(ra) # 80002178 <argstr>
    return -1;
    8000497c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000497e:	10054263          	bltz	a0,80004a82 <sys_link+0x13c>
  begin_op();
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	d02080e7          	jalr	-766(ra) # 80003684 <begin_op>
  if((ip = namei(old)) == 0){
    8000498a:	ed040513          	addi	a0,s0,-304
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	ad6080e7          	jalr	-1322(ra) # 80003464 <namei>
    80004996:	84aa                	mv	s1,a0
    80004998:	c551                	beqz	a0,80004a24 <sys_link+0xde>
  ilock(ip);
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	31e080e7          	jalr	798(ra) # 80002cb8 <ilock>
  if(ip->type == T_DIR){
    800049a2:	04449703          	lh	a4,68(s1)
    800049a6:	4785                	li	a5,1
    800049a8:	08f70463          	beq	a4,a5,80004a30 <sys_link+0xea>
  ip->nlink++;
    800049ac:	04a4d783          	lhu	a5,74(s1)
    800049b0:	2785                	addiw	a5,a5,1
    800049b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049b6:	8526                	mv	a0,s1
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	234080e7          	jalr	564(ra) # 80002bec <iupdate>
  iunlock(ip);
    800049c0:	8526                	mv	a0,s1
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	3b8080e7          	jalr	952(ra) # 80002d7a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049ca:	fd040593          	addi	a1,s0,-48
    800049ce:	f5040513          	addi	a0,s0,-176
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	ab0080e7          	jalr	-1360(ra) # 80003482 <nameiparent>
    800049da:	892a                	mv	s2,a0
    800049dc:	c935                	beqz	a0,80004a50 <sys_link+0x10a>
  ilock(dp);
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	2da080e7          	jalr	730(ra) # 80002cb8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049e6:	00092703          	lw	a4,0(s2)
    800049ea:	409c                	lw	a5,0(s1)
    800049ec:	04f71d63          	bne	a4,a5,80004a46 <sys_link+0x100>
    800049f0:	40d0                	lw	a2,4(s1)
    800049f2:	fd040593          	addi	a1,s0,-48
    800049f6:	854a                	mv	a0,s2
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	9ba080e7          	jalr	-1606(ra) # 800033b2 <dirlink>
    80004a00:	04054363          	bltz	a0,80004a46 <sys_link+0x100>
  iunlockput(dp);
    80004a04:	854a                	mv	a0,s2
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	514080e7          	jalr	1300(ra) # 80002f1a <iunlockput>
  iput(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	462080e7          	jalr	1122(ra) # 80002e72 <iput>
  end_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	cea080e7          	jalr	-790(ra) # 80003702 <end_op>
  return 0;
    80004a20:	4781                	li	a5,0
    80004a22:	a085                	j	80004a82 <sys_link+0x13c>
    end_op();
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	cde080e7          	jalr	-802(ra) # 80003702 <end_op>
    return -1;
    80004a2c:	57fd                	li	a5,-1
    80004a2e:	a891                	j	80004a82 <sys_link+0x13c>
    iunlockput(ip);
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	4e8080e7          	jalr	1256(ra) # 80002f1a <iunlockput>
    end_op();
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	cc8080e7          	jalr	-824(ra) # 80003702 <end_op>
    return -1;
    80004a42:	57fd                	li	a5,-1
    80004a44:	a83d                	j	80004a82 <sys_link+0x13c>
    iunlockput(dp);
    80004a46:	854a                	mv	a0,s2
    80004a48:	ffffe097          	auipc	ra,0xffffe
    80004a4c:	4d2080e7          	jalr	1234(ra) # 80002f1a <iunlockput>
  ilock(ip);
    80004a50:	8526                	mv	a0,s1
    80004a52:	ffffe097          	auipc	ra,0xffffe
    80004a56:	266080e7          	jalr	614(ra) # 80002cb8 <ilock>
  ip->nlink--;
    80004a5a:	04a4d783          	lhu	a5,74(s1)
    80004a5e:	37fd                	addiw	a5,a5,-1
    80004a60:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	186080e7          	jalr	390(ra) # 80002bec <iupdate>
  iunlockput(ip);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	4aa080e7          	jalr	1194(ra) # 80002f1a <iunlockput>
  end_op();
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	c8a080e7          	jalr	-886(ra) # 80003702 <end_op>
  return -1;
    80004a80:	57fd                	li	a5,-1
}
    80004a82:	853e                	mv	a0,a5
    80004a84:	70b2                	ld	ra,296(sp)
    80004a86:	7412                	ld	s0,288(sp)
    80004a88:	64f2                	ld	s1,280(sp)
    80004a8a:	6952                	ld	s2,272(sp)
    80004a8c:	6155                	addi	sp,sp,304
    80004a8e:	8082                	ret

0000000080004a90 <sys_unlink>:
{
    80004a90:	7151                	addi	sp,sp,-240
    80004a92:	f586                	sd	ra,232(sp)
    80004a94:	f1a2                	sd	s0,224(sp)
    80004a96:	eda6                	sd	s1,216(sp)
    80004a98:	e9ca                	sd	s2,208(sp)
    80004a9a:	e5ce                	sd	s3,200(sp)
    80004a9c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a9e:	08000613          	li	a2,128
    80004aa2:	f3040593          	addi	a1,s0,-208
    80004aa6:	4501                	li	a0,0
    80004aa8:	ffffd097          	auipc	ra,0xffffd
    80004aac:	6d0080e7          	jalr	1744(ra) # 80002178 <argstr>
    80004ab0:	18054163          	bltz	a0,80004c32 <sys_unlink+0x1a2>
  begin_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	bd0080e7          	jalr	-1072(ra) # 80003684 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004abc:	fb040593          	addi	a1,s0,-80
    80004ac0:	f3040513          	addi	a0,s0,-208
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	9be080e7          	jalr	-1602(ra) # 80003482 <nameiparent>
    80004acc:	84aa                	mv	s1,a0
    80004ace:	c979                	beqz	a0,80004ba4 <sys_unlink+0x114>
  ilock(dp);
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	1e8080e7          	jalr	488(ra) # 80002cb8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad8:	00004597          	auipc	a1,0x4
    80004adc:	b8858593          	addi	a1,a1,-1144 # 80008660 <syscalls+0x2a0>
    80004ae0:	fb040513          	addi	a0,s0,-80
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	69e080e7          	jalr	1694(ra) # 80003182 <namecmp>
    80004aec:	14050a63          	beqz	a0,80004c40 <sys_unlink+0x1b0>
    80004af0:	00004597          	auipc	a1,0x4
    80004af4:	b7858593          	addi	a1,a1,-1160 # 80008668 <syscalls+0x2a8>
    80004af8:	fb040513          	addi	a0,s0,-80
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	686080e7          	jalr	1670(ra) # 80003182 <namecmp>
    80004b04:	12050e63          	beqz	a0,80004c40 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b08:	f2c40613          	addi	a2,s0,-212
    80004b0c:	fb040593          	addi	a1,s0,-80
    80004b10:	8526                	mv	a0,s1
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	68a080e7          	jalr	1674(ra) # 8000319c <dirlookup>
    80004b1a:	892a                	mv	s2,a0
    80004b1c:	12050263          	beqz	a0,80004c40 <sys_unlink+0x1b0>
  ilock(ip);
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	198080e7          	jalr	408(ra) # 80002cb8 <ilock>
  if(ip->nlink < 1)
    80004b28:	04a91783          	lh	a5,74(s2)
    80004b2c:	08f05263          	blez	a5,80004bb0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b30:	04491703          	lh	a4,68(s2)
    80004b34:	4785                	li	a5,1
    80004b36:	08f70563          	beq	a4,a5,80004bc0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b3a:	4641                	li	a2,16
    80004b3c:	4581                	li	a1,0
    80004b3e:	fc040513          	addi	a0,s0,-64
    80004b42:	ffffb097          	auipc	ra,0xffffb
    80004b46:	72e080e7          	jalr	1838(ra) # 80000270 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b4a:	4741                	li	a4,16
    80004b4c:	f2c42683          	lw	a3,-212(s0)
    80004b50:	fc040613          	addi	a2,s0,-64
    80004b54:	4581                	li	a1,0
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	50c080e7          	jalr	1292(ra) # 80003064 <writei>
    80004b60:	47c1                	li	a5,16
    80004b62:	0af51563          	bne	a0,a5,80004c0c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b66:	04491703          	lh	a4,68(s2)
    80004b6a:	4785                	li	a5,1
    80004b6c:	0af70863          	beq	a4,a5,80004c1c <sys_unlink+0x18c>
  iunlockput(dp);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	3a8080e7          	jalr	936(ra) # 80002f1a <iunlockput>
  ip->nlink--;
    80004b7a:	04a95783          	lhu	a5,74(s2)
    80004b7e:	37fd                	addiw	a5,a5,-1
    80004b80:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	066080e7          	jalr	102(ra) # 80002bec <iupdate>
  iunlockput(ip);
    80004b8e:	854a                	mv	a0,s2
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	38a080e7          	jalr	906(ra) # 80002f1a <iunlockput>
  end_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	b6a080e7          	jalr	-1174(ra) # 80003702 <end_op>
  return 0;
    80004ba0:	4501                	li	a0,0
    80004ba2:	a84d                	j	80004c54 <sys_unlink+0x1c4>
    end_op();
    80004ba4:	fffff097          	auipc	ra,0xfffff
    80004ba8:	b5e080e7          	jalr	-1186(ra) # 80003702 <end_op>
    return -1;
    80004bac:	557d                	li	a0,-1
    80004bae:	a05d                	j	80004c54 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	ac050513          	addi	a0,a0,-1344 # 80008670 <syscalls+0x2b0>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	1b4080e7          	jalr	436(ra) # 80005d6c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bc0:	04c92703          	lw	a4,76(s2)
    80004bc4:	02000793          	li	a5,32
    80004bc8:	f6e7f9e3          	bgeu	a5,a4,80004b3a <sys_unlink+0xaa>
    80004bcc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bd0:	4741                	li	a4,16
    80004bd2:	86ce                	mv	a3,s3
    80004bd4:	f1840613          	addi	a2,s0,-232
    80004bd8:	4581                	li	a1,0
    80004bda:	854a                	mv	a0,s2
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	390080e7          	jalr	912(ra) # 80002f6c <readi>
    80004be4:	47c1                	li	a5,16
    80004be6:	00f51b63          	bne	a0,a5,80004bfc <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bea:	f1845783          	lhu	a5,-232(s0)
    80004bee:	e7a1                	bnez	a5,80004c36 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bf0:	29c1                	addiw	s3,s3,16
    80004bf2:	04c92783          	lw	a5,76(s2)
    80004bf6:	fcf9ede3          	bltu	s3,a5,80004bd0 <sys_unlink+0x140>
    80004bfa:	b781                	j	80004b3a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bfc:	00004517          	auipc	a0,0x4
    80004c00:	a8c50513          	addi	a0,a0,-1396 # 80008688 <syscalls+0x2c8>
    80004c04:	00001097          	auipc	ra,0x1
    80004c08:	168080e7          	jalr	360(ra) # 80005d6c <panic>
    panic("unlink: writei");
    80004c0c:	00004517          	auipc	a0,0x4
    80004c10:	a9450513          	addi	a0,a0,-1388 # 800086a0 <syscalls+0x2e0>
    80004c14:	00001097          	auipc	ra,0x1
    80004c18:	158080e7          	jalr	344(ra) # 80005d6c <panic>
    dp->nlink--;
    80004c1c:	04a4d783          	lhu	a5,74(s1)
    80004c20:	37fd                	addiw	a5,a5,-1
    80004c22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	fc4080e7          	jalr	-60(ra) # 80002bec <iupdate>
    80004c30:	b781                	j	80004b70 <sys_unlink+0xe0>
    return -1;
    80004c32:	557d                	li	a0,-1
    80004c34:	a005                	j	80004c54 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	2e2080e7          	jalr	738(ra) # 80002f1a <iunlockput>
  iunlockput(dp);
    80004c40:	8526                	mv	a0,s1
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	2d8080e7          	jalr	728(ra) # 80002f1a <iunlockput>
  end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	ab8080e7          	jalr	-1352(ra) # 80003702 <end_op>
  return -1;
    80004c52:	557d                	li	a0,-1
}
    80004c54:	70ae                	ld	ra,232(sp)
    80004c56:	740e                	ld	s0,224(sp)
    80004c58:	64ee                	ld	s1,216(sp)
    80004c5a:	694e                	ld	s2,208(sp)
    80004c5c:	69ae                	ld	s3,200(sp)
    80004c5e:	616d                	addi	sp,sp,240
    80004c60:	8082                	ret

0000000080004c62 <sys_open>:

uint64
sys_open(void)
{
    80004c62:	7131                	addi	sp,sp,-192
    80004c64:	fd06                	sd	ra,184(sp)
    80004c66:	f922                	sd	s0,176(sp)
    80004c68:	f526                	sd	s1,168(sp)
    80004c6a:	f14a                	sd	s2,160(sp)
    80004c6c:	ed4e                	sd	s3,152(sp)
    80004c6e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c70:	f4c40593          	addi	a1,s0,-180
    80004c74:	4505                	li	a0,1
    80004c76:	ffffd097          	auipc	ra,0xffffd
    80004c7a:	4c2080e7          	jalr	1218(ra) # 80002138 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c7e:	08000613          	li	a2,128
    80004c82:	f5040593          	addi	a1,s0,-176
    80004c86:	4501                	li	a0,0
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	4f0080e7          	jalr	1264(ra) # 80002178 <argstr>
    80004c90:	87aa                	mv	a5,a0
    return -1;
    80004c92:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c94:	0a07c963          	bltz	a5,80004d46 <sys_open+0xe4>

  begin_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	9ec080e7          	jalr	-1556(ra) # 80003684 <begin_op>

  if(omode & O_CREATE){
    80004ca0:	f4c42783          	lw	a5,-180(s0)
    80004ca4:	2007f793          	andi	a5,a5,512
    80004ca8:	cfc5                	beqz	a5,80004d60 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004caa:	4681                	li	a3,0
    80004cac:	4601                	li	a2,0
    80004cae:	4589                	li	a1,2
    80004cb0:	f5040513          	addi	a0,s0,-176
    80004cb4:	00000097          	auipc	ra,0x0
    80004cb8:	972080e7          	jalr	-1678(ra) # 80004626 <create>
    80004cbc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004cbe:	c959                	beqz	a0,80004d54 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cc0:	04449703          	lh	a4,68(s1)
    80004cc4:	478d                	li	a5,3
    80004cc6:	00f71763          	bne	a4,a5,80004cd4 <sys_open+0x72>
    80004cca:	0464d703          	lhu	a4,70(s1)
    80004cce:	47a5                	li	a5,9
    80004cd0:	0ce7ed63          	bltu	a5,a4,80004daa <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	dbc080e7          	jalr	-580(ra) # 80003a90 <filealloc>
    80004cdc:	89aa                	mv	s3,a0
    80004cde:	10050363          	beqz	a0,80004de4 <sys_open+0x182>
    80004ce2:	00000097          	auipc	ra,0x0
    80004ce6:	902080e7          	jalr	-1790(ra) # 800045e4 <fdalloc>
    80004cea:	892a                	mv	s2,a0
    80004cec:	0e054763          	bltz	a0,80004dda <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cf0:	04449703          	lh	a4,68(s1)
    80004cf4:	478d                	li	a5,3
    80004cf6:	0cf70563          	beq	a4,a5,80004dc0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cfa:	4789                	li	a5,2
    80004cfc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d00:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d04:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d08:	f4c42783          	lw	a5,-180(s0)
    80004d0c:	0017c713          	xori	a4,a5,1
    80004d10:	8b05                	andi	a4,a4,1
    80004d12:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d16:	0037f713          	andi	a4,a5,3
    80004d1a:	00e03733          	snez	a4,a4
    80004d1e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d22:	4007f793          	andi	a5,a5,1024
    80004d26:	c791                	beqz	a5,80004d32 <sys_open+0xd0>
    80004d28:	04449703          	lh	a4,68(s1)
    80004d2c:	4789                	li	a5,2
    80004d2e:	0af70063          	beq	a4,a5,80004dce <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	046080e7          	jalr	70(ra) # 80002d7a <iunlock>
  end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	9c6080e7          	jalr	-1594(ra) # 80003702 <end_op>

  return fd;
    80004d44:	854a                	mv	a0,s2
}
    80004d46:	70ea                	ld	ra,184(sp)
    80004d48:	744a                	ld	s0,176(sp)
    80004d4a:	74aa                	ld	s1,168(sp)
    80004d4c:	790a                	ld	s2,160(sp)
    80004d4e:	69ea                	ld	s3,152(sp)
    80004d50:	6129                	addi	sp,sp,192
    80004d52:	8082                	ret
      end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	9ae080e7          	jalr	-1618(ra) # 80003702 <end_op>
      return -1;
    80004d5c:	557d                	li	a0,-1
    80004d5e:	b7e5                	j	80004d46 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d60:	f5040513          	addi	a0,s0,-176
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	700080e7          	jalr	1792(ra) # 80003464 <namei>
    80004d6c:	84aa                	mv	s1,a0
    80004d6e:	c905                	beqz	a0,80004d9e <sys_open+0x13c>
    ilock(ip);
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	f48080e7          	jalr	-184(ra) # 80002cb8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d78:	04449703          	lh	a4,68(s1)
    80004d7c:	4785                	li	a5,1
    80004d7e:	f4f711e3          	bne	a4,a5,80004cc0 <sys_open+0x5e>
    80004d82:	f4c42783          	lw	a5,-180(s0)
    80004d86:	d7b9                	beqz	a5,80004cd4 <sys_open+0x72>
      iunlockput(ip);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	190080e7          	jalr	400(ra) # 80002f1a <iunlockput>
      end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	970080e7          	jalr	-1680(ra) # 80003702 <end_op>
      return -1;
    80004d9a:	557d                	li	a0,-1
    80004d9c:	b76d                	j	80004d46 <sys_open+0xe4>
      end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	964080e7          	jalr	-1692(ra) # 80003702 <end_op>
      return -1;
    80004da6:	557d                	li	a0,-1
    80004da8:	bf79                	j	80004d46 <sys_open+0xe4>
    iunlockput(ip);
    80004daa:	8526                	mv	a0,s1
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	16e080e7          	jalr	366(ra) # 80002f1a <iunlockput>
    end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	94e080e7          	jalr	-1714(ra) # 80003702 <end_op>
    return -1;
    80004dbc:	557d                	li	a0,-1
    80004dbe:	b761                	j	80004d46 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dc0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dc4:	04649783          	lh	a5,70(s1)
    80004dc8:	02f99223          	sh	a5,36(s3)
    80004dcc:	bf25                	j	80004d04 <sys_open+0xa2>
    itrunc(ip);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	ff6080e7          	jalr	-10(ra) # 80002dc6 <itrunc>
    80004dd8:	bfa9                	j	80004d32 <sys_open+0xd0>
      fileclose(f);
    80004dda:	854e                	mv	a0,s3
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	d70080e7          	jalr	-656(ra) # 80003b4c <fileclose>
    iunlockput(ip);
    80004de4:	8526                	mv	a0,s1
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	134080e7          	jalr	308(ra) # 80002f1a <iunlockput>
    end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	914080e7          	jalr	-1772(ra) # 80003702 <end_op>
    return -1;
    80004df6:	557d                	li	a0,-1
    80004df8:	b7b9                	j	80004d46 <sys_open+0xe4>

0000000080004dfa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dfa:	7175                	addi	sp,sp,-144
    80004dfc:	e506                	sd	ra,136(sp)
    80004dfe:	e122                	sd	s0,128(sp)
    80004e00:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	882080e7          	jalr	-1918(ra) # 80003684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e0a:	08000613          	li	a2,128
    80004e0e:	f7040593          	addi	a1,s0,-144
    80004e12:	4501                	li	a0,0
    80004e14:	ffffd097          	auipc	ra,0xffffd
    80004e18:	364080e7          	jalr	868(ra) # 80002178 <argstr>
    80004e1c:	02054963          	bltz	a0,80004e4e <sys_mkdir+0x54>
    80004e20:	4681                	li	a3,0
    80004e22:	4601                	li	a2,0
    80004e24:	4585                	li	a1,1
    80004e26:	f7040513          	addi	a0,s0,-144
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	7fc080e7          	jalr	2044(ra) # 80004626 <create>
    80004e32:	cd11                	beqz	a0,80004e4e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	0e6080e7          	jalr	230(ra) # 80002f1a <iunlockput>
  end_op();
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	8c6080e7          	jalr	-1850(ra) # 80003702 <end_op>
  return 0;
    80004e44:	4501                	li	a0,0
}
    80004e46:	60aa                	ld	ra,136(sp)
    80004e48:	640a                	ld	s0,128(sp)
    80004e4a:	6149                	addi	sp,sp,144
    80004e4c:	8082                	ret
    end_op();
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	8b4080e7          	jalr	-1868(ra) # 80003702 <end_op>
    return -1;
    80004e56:	557d                	li	a0,-1
    80004e58:	b7fd                	j	80004e46 <sys_mkdir+0x4c>

0000000080004e5a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e5a:	7135                	addi	sp,sp,-160
    80004e5c:	ed06                	sd	ra,152(sp)
    80004e5e:	e922                	sd	s0,144(sp)
    80004e60:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	822080e7          	jalr	-2014(ra) # 80003684 <begin_op>
  argint(1, &major);
    80004e6a:	f6c40593          	addi	a1,s0,-148
    80004e6e:	4505                	li	a0,1
    80004e70:	ffffd097          	auipc	ra,0xffffd
    80004e74:	2c8080e7          	jalr	712(ra) # 80002138 <argint>
  argint(2, &minor);
    80004e78:	f6840593          	addi	a1,s0,-152
    80004e7c:	4509                	li	a0,2
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	2ba080e7          	jalr	698(ra) # 80002138 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e86:	08000613          	li	a2,128
    80004e8a:	f7040593          	addi	a1,s0,-144
    80004e8e:	4501                	li	a0,0
    80004e90:	ffffd097          	auipc	ra,0xffffd
    80004e94:	2e8080e7          	jalr	744(ra) # 80002178 <argstr>
    80004e98:	02054b63          	bltz	a0,80004ece <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e9c:	f6841683          	lh	a3,-152(s0)
    80004ea0:	f6c41603          	lh	a2,-148(s0)
    80004ea4:	458d                	li	a1,3
    80004ea6:	f7040513          	addi	a0,s0,-144
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	77c080e7          	jalr	1916(ra) # 80004626 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb2:	cd11                	beqz	a0,80004ece <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb4:	ffffe097          	auipc	ra,0xffffe
    80004eb8:	066080e7          	jalr	102(ra) # 80002f1a <iunlockput>
  end_op();
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	846080e7          	jalr	-1978(ra) # 80003702 <end_op>
  return 0;
    80004ec4:	4501                	li	a0,0
}
    80004ec6:	60ea                	ld	ra,152(sp)
    80004ec8:	644a                	ld	s0,144(sp)
    80004eca:	610d                	addi	sp,sp,160
    80004ecc:	8082                	ret
    end_op();
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	834080e7          	jalr	-1996(ra) # 80003702 <end_op>
    return -1;
    80004ed6:	557d                	li	a0,-1
    80004ed8:	b7fd                	j	80004ec6 <sys_mknod+0x6c>

0000000080004eda <sys_chdir>:

uint64
sys_chdir(void)
{
    80004eda:	7135                	addi	sp,sp,-160
    80004edc:	ed06                	sd	ra,152(sp)
    80004ede:	e922                	sd	s0,144(sp)
    80004ee0:	e526                	sd	s1,136(sp)
    80004ee2:	e14a                	sd	s2,128(sp)
    80004ee4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ee6:	ffffc097          	auipc	ra,0xffffc
    80004eea:	048080e7          	jalr	72(ra) # 80000f2e <myproc>
    80004eee:	892a                	mv	s2,a0
  
  begin_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	794080e7          	jalr	1940(ra) # 80003684 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ef8:	08000613          	li	a2,128
    80004efc:	f6040593          	addi	a1,s0,-160
    80004f00:	4501                	li	a0,0
    80004f02:	ffffd097          	auipc	ra,0xffffd
    80004f06:	276080e7          	jalr	630(ra) # 80002178 <argstr>
    80004f0a:	04054b63          	bltz	a0,80004f60 <sys_chdir+0x86>
    80004f0e:	f6040513          	addi	a0,s0,-160
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	552080e7          	jalr	1362(ra) # 80003464 <namei>
    80004f1a:	84aa                	mv	s1,a0
    80004f1c:	c131                	beqz	a0,80004f60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	d9a080e7          	jalr	-614(ra) # 80002cb8 <ilock>
  if(ip->type != T_DIR){
    80004f26:	04449703          	lh	a4,68(s1)
    80004f2a:	4785                	li	a5,1
    80004f2c:	04f71063          	bne	a4,a5,80004f6c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f30:	8526                	mv	a0,s1
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	e48080e7          	jalr	-440(ra) # 80002d7a <iunlock>
  iput(p->cwd);
    80004f3a:	15093503          	ld	a0,336(s2)
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	f34080e7          	jalr	-204(ra) # 80002e72 <iput>
  end_op();
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	7bc080e7          	jalr	1980(ra) # 80003702 <end_op>
  p->cwd = ip;
    80004f4e:	14993823          	sd	s1,336(s2)
  return 0;
    80004f52:	4501                	li	a0,0
}
    80004f54:	60ea                	ld	ra,152(sp)
    80004f56:	644a                	ld	s0,144(sp)
    80004f58:	64aa                	ld	s1,136(sp)
    80004f5a:	690a                	ld	s2,128(sp)
    80004f5c:	610d                	addi	sp,sp,160
    80004f5e:	8082                	ret
    end_op();
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	7a2080e7          	jalr	1954(ra) # 80003702 <end_op>
    return -1;
    80004f68:	557d                	li	a0,-1
    80004f6a:	b7ed                	j	80004f54 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f6c:	8526                	mv	a0,s1
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	fac080e7          	jalr	-84(ra) # 80002f1a <iunlockput>
    end_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	78c080e7          	jalr	1932(ra) # 80003702 <end_op>
    return -1;
    80004f7e:	557d                	li	a0,-1
    80004f80:	bfd1                	j	80004f54 <sys_chdir+0x7a>

0000000080004f82 <sys_exec>:

uint64
sys_exec(void)
{
    80004f82:	7145                	addi	sp,sp,-464
    80004f84:	e786                	sd	ra,456(sp)
    80004f86:	e3a2                	sd	s0,448(sp)
    80004f88:	ff26                	sd	s1,440(sp)
    80004f8a:	fb4a                	sd	s2,432(sp)
    80004f8c:	f74e                	sd	s3,424(sp)
    80004f8e:	f352                	sd	s4,416(sp)
    80004f90:	ef56                	sd	s5,408(sp)
    80004f92:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f94:	e3840593          	addi	a1,s0,-456
    80004f98:	4505                	li	a0,1
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	1be080e7          	jalr	446(ra) # 80002158 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004fa2:	08000613          	li	a2,128
    80004fa6:	f4040593          	addi	a1,s0,-192
    80004faa:	4501                	li	a0,0
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	1cc080e7          	jalr	460(ra) # 80002178 <argstr>
    80004fb4:	87aa                	mv	a5,a0
    return -1;
    80004fb6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004fb8:	0c07c363          	bltz	a5,8000507e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004fbc:	10000613          	li	a2,256
    80004fc0:	4581                	li	a1,0
    80004fc2:	e4040513          	addi	a0,s0,-448
    80004fc6:	ffffb097          	auipc	ra,0xffffb
    80004fca:	2aa080e7          	jalr	682(ra) # 80000270 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fce:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fd2:	89a6                	mv	s3,s1
    80004fd4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fd6:	02000a13          	li	s4,32
    80004fda:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fde:	00391513          	slli	a0,s2,0x3
    80004fe2:	e3040593          	addi	a1,s0,-464
    80004fe6:	e3843783          	ld	a5,-456(s0)
    80004fea:	953e                	add	a0,a0,a5
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	0ae080e7          	jalr	174(ra) # 8000209a <fetchaddr>
    80004ff4:	02054a63          	bltz	a0,80005028 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004ff8:	e3043783          	ld	a5,-464(s0)
    80004ffc:	c3b9                	beqz	a5,80005042 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ffe:	ffffb097          	auipc	ra,0xffffb
    80005002:	1fa080e7          	jalr	506(ra) # 800001f8 <kalloc>
    80005006:	85aa                	mv	a1,a0
    80005008:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000500c:	cd11                	beqz	a0,80005028 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000500e:	6605                	lui	a2,0x1
    80005010:	e3043503          	ld	a0,-464(s0)
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	0d8080e7          	jalr	216(ra) # 800020ec <fetchstr>
    8000501c:	00054663          	bltz	a0,80005028 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005020:	0905                	addi	s2,s2,1
    80005022:	09a1                	addi	s3,s3,8
    80005024:	fb491be3          	bne	s2,s4,80004fda <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005028:	f4040913          	addi	s2,s0,-192
    8000502c:	6088                	ld	a0,0(s1)
    8000502e:	c539                	beqz	a0,8000507c <sys_exec+0xfa>
    kfree(argv[i]);
    80005030:	ffffb097          	auipc	ra,0xffffb
    80005034:	0a8080e7          	jalr	168(ra) # 800000d8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005038:	04a1                	addi	s1,s1,8
    8000503a:	ff2499e3          	bne	s1,s2,8000502c <sys_exec+0xaa>
  return -1;
    8000503e:	557d                	li	a0,-1
    80005040:	a83d                	j	8000507e <sys_exec+0xfc>
      argv[i] = 0;
    80005042:	0a8e                	slli	s5,s5,0x3
    80005044:	fc0a8793          	addi	a5,s5,-64
    80005048:	00878ab3          	add	s5,a5,s0
    8000504c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005050:	e4040593          	addi	a1,s0,-448
    80005054:	f4040513          	addi	a0,s0,-192
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	16e080e7          	jalr	366(ra) # 800041c6 <exec>
    80005060:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005062:	f4040993          	addi	s3,s0,-192
    80005066:	6088                	ld	a0,0(s1)
    80005068:	c901                	beqz	a0,80005078 <sys_exec+0xf6>
    kfree(argv[i]);
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	06e080e7          	jalr	110(ra) # 800000d8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005072:	04a1                	addi	s1,s1,8
    80005074:	ff3499e3          	bne	s1,s3,80005066 <sys_exec+0xe4>
  return ret;
    80005078:	854a                	mv	a0,s2
    8000507a:	a011                	j	8000507e <sys_exec+0xfc>
  return -1;
    8000507c:	557d                	li	a0,-1
}
    8000507e:	60be                	ld	ra,456(sp)
    80005080:	641e                	ld	s0,448(sp)
    80005082:	74fa                	ld	s1,440(sp)
    80005084:	795a                	ld	s2,432(sp)
    80005086:	79ba                	ld	s3,424(sp)
    80005088:	7a1a                	ld	s4,416(sp)
    8000508a:	6afa                	ld	s5,408(sp)
    8000508c:	6179                	addi	sp,sp,464
    8000508e:	8082                	ret

0000000080005090 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005090:	7139                	addi	sp,sp,-64
    80005092:	fc06                	sd	ra,56(sp)
    80005094:	f822                	sd	s0,48(sp)
    80005096:	f426                	sd	s1,40(sp)
    80005098:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000509a:	ffffc097          	auipc	ra,0xffffc
    8000509e:	e94080e7          	jalr	-364(ra) # 80000f2e <myproc>
    800050a2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800050a4:	fd840593          	addi	a1,s0,-40
    800050a8:	4501                	li	a0,0
    800050aa:	ffffd097          	auipc	ra,0xffffd
    800050ae:	0ae080e7          	jalr	174(ra) # 80002158 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800050b2:	fc840593          	addi	a1,s0,-56
    800050b6:	fd040513          	addi	a0,s0,-48
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	dc2080e7          	jalr	-574(ra) # 80003e7c <pipealloc>
    return -1;
    800050c2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050c4:	0c054463          	bltz	a0,8000518c <sys_pipe+0xfc>
  fd0 = -1;
    800050c8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050cc:	fd043503          	ld	a0,-48(s0)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	514080e7          	jalr	1300(ra) # 800045e4 <fdalloc>
    800050d8:	fca42223          	sw	a0,-60(s0)
    800050dc:	08054b63          	bltz	a0,80005172 <sys_pipe+0xe2>
    800050e0:	fc843503          	ld	a0,-56(s0)
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	500080e7          	jalr	1280(ra) # 800045e4 <fdalloc>
    800050ec:	fca42023          	sw	a0,-64(s0)
    800050f0:	06054863          	bltz	a0,80005160 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050f4:	4691                	li	a3,4
    800050f6:	fc440613          	addi	a2,s0,-60
    800050fa:	fd843583          	ld	a1,-40(s0)
    800050fe:	68a8                	ld	a0,80(s1)
    80005100:	ffffc097          	auipc	ra,0xffffc
    80005104:	aee080e7          	jalr	-1298(ra) # 80000bee <copyout>
    80005108:	02054063          	bltz	a0,80005128 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000510c:	4691                	li	a3,4
    8000510e:	fc040613          	addi	a2,s0,-64
    80005112:	fd843583          	ld	a1,-40(s0)
    80005116:	0591                	addi	a1,a1,4
    80005118:	68a8                	ld	a0,80(s1)
    8000511a:	ffffc097          	auipc	ra,0xffffc
    8000511e:	ad4080e7          	jalr	-1324(ra) # 80000bee <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005122:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005124:	06055463          	bgez	a0,8000518c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005128:	fc442783          	lw	a5,-60(s0)
    8000512c:	07e9                	addi	a5,a5,26
    8000512e:	078e                	slli	a5,a5,0x3
    80005130:	97a6                	add	a5,a5,s1
    80005132:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005136:	fc042783          	lw	a5,-64(s0)
    8000513a:	07e9                	addi	a5,a5,26
    8000513c:	078e                	slli	a5,a5,0x3
    8000513e:	94be                	add	s1,s1,a5
    80005140:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005144:	fd043503          	ld	a0,-48(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	a04080e7          	jalr	-1532(ra) # 80003b4c <fileclose>
    fileclose(wf);
    80005150:	fc843503          	ld	a0,-56(s0)
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	9f8080e7          	jalr	-1544(ra) # 80003b4c <fileclose>
    return -1;
    8000515c:	57fd                	li	a5,-1
    8000515e:	a03d                	j	8000518c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005160:	fc442783          	lw	a5,-60(s0)
    80005164:	0007c763          	bltz	a5,80005172 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005168:	07e9                	addi	a5,a5,26
    8000516a:	078e                	slli	a5,a5,0x3
    8000516c:	97a6                	add	a5,a5,s1
    8000516e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005172:	fd043503          	ld	a0,-48(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	9d6080e7          	jalr	-1578(ra) # 80003b4c <fileclose>
    fileclose(wf);
    8000517e:	fc843503          	ld	a0,-56(s0)
    80005182:	fffff097          	auipc	ra,0xfffff
    80005186:	9ca080e7          	jalr	-1590(ra) # 80003b4c <fileclose>
    return -1;
    8000518a:	57fd                	li	a5,-1
}
    8000518c:	853e                	mv	a0,a5
    8000518e:	70e2                	ld	ra,56(sp)
    80005190:	7442                	ld	s0,48(sp)
    80005192:	74a2                	ld	s1,40(sp)
    80005194:	6121                	addi	sp,sp,64
    80005196:	8082                	ret
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
    800051e0:	d87fc0ef          	jal	ra,80001f66 <kerneltrap>
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
    8000527c:	c8a080e7          	jalr	-886(ra) # 80000f02 <cpuid>
  
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
    800052b4:	c52080e7          	jalr	-942(ra) # 80000f02 <cpuid>
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
    800052dc:	c2a080e7          	jalr	-982(ra) # 80000f02 <cpuid>
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
    80005304:	00034797          	auipc	a5,0x34
    80005308:	6cc78793          	addi	a5,a5,1740 # 800399d0 <disk>
    8000530c:	97aa                	add	a5,a5,a0
    8000530e:	0187c783          	lbu	a5,24(a5)
    80005312:	ebb9                	bnez	a5,80005368 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005314:	00451693          	slli	a3,a0,0x4
    80005318:	00034797          	auipc	a5,0x34
    8000531c:	6b878793          	addi	a5,a5,1720 # 800399d0 <disk>
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
    80005340:	00034517          	auipc	a0,0x34
    80005344:	6a850513          	addi	a0,a0,1704 # 800399e8 <disk+0x18>
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	2f2080e7          	jalr	754(ra) # 8000163a <wakeup>
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret
    panic("free_desc 1");
    80005358:	00003517          	auipc	a0,0x3
    8000535c:	35850513          	addi	a0,a0,856 # 800086b0 <syscalls+0x2f0>
    80005360:	00001097          	auipc	ra,0x1
    80005364:	a0c080e7          	jalr	-1524(ra) # 80005d6c <panic>
    panic("free_desc 2");
    80005368:	00003517          	auipc	a0,0x3
    8000536c:	35850513          	addi	a0,a0,856 # 800086c0 <syscalls+0x300>
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
    80005388:	34c58593          	addi	a1,a1,844 # 800086d0 <syscalls+0x310>
    8000538c:	00034517          	auipc	a0,0x34
    80005390:	76c50513          	addi	a0,a0,1900 # 80039af8 <disk+0x128>
    80005394:	00001097          	auipc	ra,0x1
    80005398:	ed0080e7          	jalr	-304(ra) # 80006264 <initlock>
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
    800053f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fbca0f>
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
    80005432:	dca080e7          	jalr	-566(ra) # 800001f8 <kalloc>
    80005436:	00034497          	auipc	s1,0x34
    8000543a:	59a48493          	addi	s1,s1,1434 # 800399d0 <disk>
    8000543e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005440:	ffffb097          	auipc	ra,0xffffb
    80005444:	db8080e7          	jalr	-584(ra) # 800001f8 <kalloc>
    80005448:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000544a:	ffffb097          	auipc	ra,0xffffb
    8000544e:	dae080e7          	jalr	-594(ra) # 800001f8 <kalloc>
    80005452:	87aa                	mv	a5,a0
    80005454:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005456:	6088                	ld	a0,0(s1)
    80005458:	cd6d                	beqz	a0,80005552 <virtio_disk_init+0x1da>
    8000545a:	00034717          	auipc	a4,0x34
    8000545e:	57e73703          	ld	a4,1406(a4) # 800399d8 <disk+0x8>
    80005462:	cb65                	beqz	a4,80005552 <virtio_disk_init+0x1da>
    80005464:	c7fd                	beqz	a5,80005552 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005466:	6605                	lui	a2,0x1
    80005468:	4581                	li	a1,0
    8000546a:	ffffb097          	auipc	ra,0xffffb
    8000546e:	e06080e7          	jalr	-506(ra) # 80000270 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005472:	00034497          	auipc	s1,0x34
    80005476:	55e48493          	addi	s1,s1,1374 # 800399d0 <disk>
    8000547a:	6605                	lui	a2,0x1
    8000547c:	4581                	li	a1,0
    8000547e:	6488                	ld	a0,8(s1)
    80005480:	ffffb097          	auipc	ra,0xffffb
    80005484:	df0080e7          	jalr	-528(ra) # 80000270 <memset>
  memset(disk.used, 0, PGSIZE);
    80005488:	6605                	lui	a2,0x1
    8000548a:	4581                	li	a1,0
    8000548c:	6888                	ld	a0,16(s1)
    8000548e:	ffffb097          	auipc	ra,0xffffb
    80005492:	de2080e7          	jalr	-542(ra) # 80000270 <memset>
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
    80005506:	1de50513          	addi	a0,a0,478 # 800086e0 <syscalls+0x320>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	862080e7          	jalr	-1950(ra) # 80005d6c <panic>
    panic("virtio disk FEATURES_OK unset");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	1ee50513          	addi	a0,a0,494 # 80008700 <syscalls+0x340>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	852080e7          	jalr	-1966(ra) # 80005d6c <panic>
    panic("virtio disk should not be ready");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	1fe50513          	addi	a0,a0,510 # 80008720 <syscalls+0x360>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	842080e7          	jalr	-1982(ra) # 80005d6c <panic>
    panic("virtio disk has no queue 0");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	20e50513          	addi	a0,a0,526 # 80008740 <syscalls+0x380>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	832080e7          	jalr	-1998(ra) # 80005d6c <panic>
    panic("virtio disk max queue too short");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	21e50513          	addi	a0,a0,542 # 80008760 <syscalls+0x3a0>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	822080e7          	jalr	-2014(ra) # 80005d6c <panic>
    panic("virtio disk kalloc");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	22e50513          	addi	a0,a0,558 # 80008780 <syscalls+0x3c0>
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
    80005592:	00034517          	auipc	a0,0x34
    80005596:	56650513          	addi	a0,a0,1382 # 80039af8 <disk+0x128>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	d5a080e7          	jalr	-678(ra) # 800062f4 <acquire>
  for(int i = 0; i < 3; i++){
    800055a2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055a6:	00034b97          	auipc	s7,0x34
    800055aa:	42ab8b93          	addi	s7,s7,1066 # 800399d0 <disk>
  for(int i = 0; i < 3; i++){
    800055ae:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b0:	00034c97          	auipc	s9,0x34
    800055b4:	548c8c93          	addi	s9,s9,1352 # 80039af8 <disk+0x128>
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
    800055d2:	00034717          	auipc	a4,0x34
    800055d6:	3fe70713          	addi	a4,a4,1022 # 800399d0 <disk>
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
    8000560a:	00034517          	auipc	a0,0x34
    8000560e:	3de50513          	addi	a0,a0,990 # 800399e8 <disk+0x18>
    80005612:	ffffc097          	auipc	ra,0xffffc
    80005616:	fc4080e7          	jalr	-60(ra) # 800015d6 <sleep>
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
    8000562e:	00034797          	auipc	a5,0x34
    80005632:	3a278793          	addi	a5,a5,930 # 800399d0 <disk>
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
    80005704:	00034917          	auipc	s2,0x34
    80005708:	3f490913          	addi	s2,s2,1012 # 80039af8 <disk+0x128>
  while(b->disk == 1) {
    8000570c:	4485                	li	s1,1
    8000570e:	00b79c63          	bne	a5,a1,80005726 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005712:	85ca                	mv	a1,s2
    80005714:	8556                	mv	a0,s5
    80005716:	ffffc097          	auipc	ra,0xffffc
    8000571a:	ec0080e7          	jalr	-320(ra) # 800015d6 <sleep>
  while(b->disk == 1) {
    8000571e:	004aa783          	lw	a5,4(s5)
    80005722:	fe9788e3          	beq	a5,s1,80005712 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005726:	f8042903          	lw	s2,-128(s0)
    8000572a:	00290713          	addi	a4,s2,2
    8000572e:	0712                	slli	a4,a4,0x4
    80005730:	00034797          	auipc	a5,0x34
    80005734:	2a078793          	addi	a5,a5,672 # 800399d0 <disk>
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000573e:	00034997          	auipc	s3,0x34
    80005742:	29298993          	addi	s3,s3,658 # 800399d0 <disk>
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
    80005766:	00034517          	auipc	a0,0x34
    8000576a:	39250513          	addi	a0,a0,914 # 80039af8 <disk+0x128>
    8000576e:	00001097          	auipc	ra,0x1
    80005772:	c3a080e7          	jalr	-966(ra) # 800063a8 <release>
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
    8000579e:	00034497          	auipc	s1,0x34
    800057a2:	23248493          	addi	s1,s1,562 # 800399d0 <disk>
    800057a6:	00034517          	auipc	a0,0x34
    800057aa:	35250513          	addi	a0,a0,850 # 80039af8 <disk+0x128>
    800057ae:	00001097          	auipc	ra,0x1
    800057b2:	b46080e7          	jalr	-1210(ra) # 800062f4 <acquire>
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
    80005802:	e3c080e7          	jalr	-452(ra) # 8000163a <wakeup>

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
    8000581e:	00034517          	auipc	a0,0x34
    80005822:	2da50513          	addi	a0,a0,730 # 80039af8 <disk+0x128>
    80005826:	00001097          	auipc	ra,0x1
    8000582a:	b82080e7          	jalr	-1150(ra) # 800063a8 <release>
}
    8000582e:	60e2                	ld	ra,24(sp)
    80005830:	6442                	ld	s0,16(sp)
    80005832:	64a2                	ld	s1,8(sp)
    80005834:	6105                	addi	sp,sp,32
    80005836:	8082                	ret
      panic("virtio_disk_intr status");
    80005838:	00003517          	auipc	a0,0x3
    8000583c:	f6050513          	addi	a0,a0,-160 # 80008798 <syscalls+0x3d8>
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
    8000587c:	00034717          	auipc	a4,0x34
    80005880:	29470713          	addi	a4,a4,660 # 80039b10 <timer_scratch>
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
    800058c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbcaaf>
    800058ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058cc:	6705                	lui	a4,0x1
    800058ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058d8:	ffffb797          	auipc	a5,0xffffb
    800058dc:	b3e78793          	addi	a5,a5,-1218 # 80000416 <main>
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
    8000595a:	0de080e7          	jalr	222(ra) # 80001a34 <either_copyin>
    8000595e:	01550d63          	beq	a0,s5,80005978 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005962:	fbf44503          	lbu	a0,-65(s0)
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	7d4080e7          	jalr	2004(ra) # 8000613a <uartputc>
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
    800059b6:	0003c517          	auipc	a0,0x3c
    800059ba:	29a50513          	addi	a0,a0,666 # 80041c50 <cons>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	936080e7          	jalr	-1738(ra) # 800062f4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059c6:	0003c497          	auipc	s1,0x3c
    800059ca:	28a48493          	addi	s1,s1,650 # 80041c50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ce:	0003c917          	auipc	s2,0x3c
    800059d2:	31a90913          	addi	s2,s2,794 # 80041ce8 <cons+0x98>
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
    800059f0:	542080e7          	jalr	1346(ra) # 80000f2e <myproc>
    800059f4:	ffffc097          	auipc	ra,0xffffc
    800059f8:	e8a080e7          	jalr	-374(ra) # 8000187e <killed>
    800059fc:	e535                	bnez	a0,80005a68 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059fe:	85a6                	mv	a1,s1
    80005a00:	854a                	mv	a0,s2
    80005a02:	ffffc097          	auipc	ra,0xffffc
    80005a06:	bd4080e7          	jalr	-1068(ra) # 800015d6 <sleep>
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
    80005a42:	fa0080e7          	jalr	-96(ra) # 800019de <either_copyout>
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
    80005a52:	0003c517          	auipc	a0,0x3c
    80005a56:	1fe50513          	addi	a0,a0,510 # 80041c50 <cons>
    80005a5a:	00001097          	auipc	ra,0x1
    80005a5e:	94e080e7          	jalr	-1714(ra) # 800063a8 <release>

  return target - n;
    80005a62:	413b053b          	subw	a0,s6,s3
    80005a66:	a811                	j	80005a7a <consoleread+0xea>
        release(&cons.lock);
    80005a68:	0003c517          	auipc	a0,0x3c
    80005a6c:	1e850513          	addi	a0,a0,488 # 80041c50 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	938080e7          	jalr	-1736(ra) # 800063a8 <release>
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
    80005a9e:	0003c717          	auipc	a4,0x3c
    80005aa2:	24f72523          	sw	a5,586(a4) # 80041ce8 <cons+0x98>
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
    80005abc:	5b0080e7          	jalr	1456(ra) # 80006068 <uartputc_sync>
}
    80005ac0:	60a2                	ld	ra,8(sp)
    80005ac2:	6402                	ld	s0,0(sp)
    80005ac4:	0141                	addi	sp,sp,16
    80005ac6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ac8:	4521                	li	a0,8
    80005aca:	00000097          	auipc	ra,0x0
    80005ace:	59e080e7          	jalr	1438(ra) # 80006068 <uartputc_sync>
    80005ad2:	02000513          	li	a0,32
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	592080e7          	jalr	1426(ra) # 80006068 <uartputc_sync>
    80005ade:	4521                	li	a0,8
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	588080e7          	jalr	1416(ra) # 80006068 <uartputc_sync>
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
    80005af8:	0003c517          	auipc	a0,0x3c
    80005afc:	15850513          	addi	a0,a0,344 # 80041c50 <cons>
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	7f4080e7          	jalr	2036(ra) # 800062f4 <acquire>

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
    80005b22:	f6c080e7          	jalr	-148(ra) # 80001a8a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b26:	0003c517          	auipc	a0,0x3c
    80005b2a:	12a50513          	addi	a0,a0,298 # 80041c50 <cons>
    80005b2e:	00001097          	auipc	ra,0x1
    80005b32:	87a080e7          	jalr	-1926(ra) # 800063a8 <release>
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
    80005b4a:	0003c717          	auipc	a4,0x3c
    80005b4e:	10670713          	addi	a4,a4,262 # 80041c50 <cons>
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
    80005b74:	0003c797          	auipc	a5,0x3c
    80005b78:	0dc78793          	addi	a5,a5,220 # 80041c50 <cons>
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
    80005ba2:	0003c797          	auipc	a5,0x3c
    80005ba6:	1467a783          	lw	a5,326(a5) # 80041ce8 <cons+0x98>
    80005baa:	9f1d                	subw	a4,a4,a5
    80005bac:	08000793          	li	a5,128
    80005bb0:	f6f71be3          	bne	a4,a5,80005b26 <consoleintr+0x3c>
    80005bb4:	a07d                	j	80005c62 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bb6:	0003c717          	auipc	a4,0x3c
    80005bba:	09a70713          	addi	a4,a4,154 # 80041c50 <cons>
    80005bbe:	0a072783          	lw	a5,160(a4)
    80005bc2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bc6:	0003c497          	auipc	s1,0x3c
    80005bca:	08a48493          	addi	s1,s1,138 # 80041c50 <cons>
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
    80005c02:	0003c717          	auipc	a4,0x3c
    80005c06:	04e70713          	addi	a4,a4,78 # 80041c50 <cons>
    80005c0a:	0a072783          	lw	a5,160(a4)
    80005c0e:	09c72703          	lw	a4,156(a4)
    80005c12:	f0f70ae3          	beq	a4,a5,80005b26 <consoleintr+0x3c>
      cons.e--;
    80005c16:	37fd                	addiw	a5,a5,-1
    80005c18:	0003c717          	auipc	a4,0x3c
    80005c1c:	0cf72c23          	sw	a5,216(a4) # 80041cf0 <cons+0xa0>
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
    80005c3e:	0003c797          	auipc	a5,0x3c
    80005c42:	01278793          	addi	a5,a5,18 # 80041c50 <cons>
    80005c46:	0a07a703          	lw	a4,160(a5)
    80005c4a:	0017069b          	addiw	a3,a4,1
    80005c4e:	0006861b          	sext.w	a2,a3
    80005c52:	0ad7a023          	sw	a3,160(a5)
    80005c56:	07f77713          	andi	a4,a4,127
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	4729                	li	a4,10
    80005c5e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c62:	0003c797          	auipc	a5,0x3c
    80005c66:	08c7a523          	sw	a2,138(a5) # 80041cec <cons+0x9c>
        wakeup(&cons.r);
    80005c6a:	0003c517          	auipc	a0,0x3c
    80005c6e:	07e50513          	addi	a0,a0,126 # 80041ce8 <cons+0x98>
    80005c72:	ffffc097          	auipc	ra,0xffffc
    80005c76:	9c8080e7          	jalr	-1592(ra) # 8000163a <wakeup>
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
    80005c88:	b2c58593          	addi	a1,a1,-1236 # 800087b0 <syscalls+0x3f0>
    80005c8c:	0003c517          	auipc	a0,0x3c
    80005c90:	fc450513          	addi	a0,a0,-60 # 80041c50 <cons>
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	5d0080e7          	jalr	1488(ra) # 80006264 <initlock>

  uartinit();
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	37c080e7          	jalr	892(ra) # 80006018 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ca4:	00033797          	auipc	a5,0x33
    80005ca8:	cd478793          	addi	a5,a5,-812 # 80038978 <devsw>
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
    80005cea:	b0260613          	addi	a2,a2,-1278 # 800087e8 <digits>
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
    80005d78:	0003c797          	auipc	a5,0x3c
    80005d7c:	f807ac23          	sw	zero,-104(a5) # 80041d10 <pr+0x18>
  printf("panic: ");
    80005d80:	00003517          	auipc	a0,0x3
    80005d84:	a3850513          	addi	a0,a0,-1480 # 800087b8 <syscalls+0x3f8>
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
    80005db0:	b2f72023          	sw	a5,-1248(a4) # 800088cc <panicked>
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
    80005de8:	0003cd97          	auipc	s11,0x3c
    80005dec:	f28dad83          	lw	s11,-216(s11) # 80041d10 <pr+0x18>
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
    80005e18:	9d4b0b13          	addi	s6,s6,-1580 # 800087e8 <digits>
    switch(c){
    80005e1c:	07300c93          	li	s9,115
    80005e20:	06400c13          	li	s8,100
    80005e24:	a82d                	j	80005e5e <printf+0xa8>
    acquire(&pr.lock);
    80005e26:	0003c517          	auipc	a0,0x3c
    80005e2a:	ed250513          	addi	a0,a0,-302 # 80041cf8 <pr>
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	4c6080e7          	jalr	1222(ra) # 800062f4 <acquire>
    80005e36:	bf7d                	j	80005df4 <printf+0x3e>
    panic("null fmt");
    80005e38:	00003517          	auipc	a0,0x3
    80005e3c:	99050513          	addi	a0,a0,-1648 # 800087c8 <syscalls+0x408>
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
    80005f36:	88e48493          	addi	s1,s1,-1906 # 800087c0 <syscalls+0x400>
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
    80005f84:	0003c517          	auipc	a0,0x3c
    80005f88:	d7450513          	addi	a0,a0,-652 # 80041cf8 <pr>
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	41c080e7          	jalr	1052(ra) # 800063a8 <release>
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
    80005fa0:	0003c497          	auipc	s1,0x3c
    80005fa4:	d5848493          	addi	s1,s1,-680 # 80041cf8 <pr>
    80005fa8:	00003597          	auipc	a1,0x3
    80005fac:	83058593          	addi	a1,a1,-2000 # 800087d8 <syscalls+0x418>
    80005fb0:	8526                	mv	a0,s1
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	2b2080e7          	jalr	690(ra) # 80006264 <initlock>
  pr.locking = 1;
    80005fba:	4785                	li	a5,1
    80005fbc:	cc9c                	sw	a5,24(s1)
}
    80005fbe:	60e2                	ld	ra,24(sp)
    80005fc0:	6442                	ld	s0,16(sp)
    80005fc2:	64a2                	ld	s1,8(sp)
    80005fc4:	6105                	addi	sp,sp,32
    80005fc6:	8082                	ret

0000000080005fc8 <backtrace>:

void backtrace(void) {
    80005fc8:	7179                	addi	sp,sp,-48
    80005fca:	f406                	sd	ra,40(sp)
    80005fcc:	f022                	sd	s0,32(sp)
    80005fce:	ec26                	sd	s1,24(sp)
    80005fd0:	e84a                	sd	s2,16(sp)
    80005fd2:	e44e                	sd	s3,8(sp)
    80005fd4:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r" (x) );
    80005fd6:	84a2                	mv	s1,s0
	uint64 fp = r_fp();
	uint64 upbound = PGROUNDUP(fp);
    80005fd8:	6905                	lui	s2,0x1
    80005fda:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005fdc:	9926                	add	s2,s2,s1
    80005fde:	77fd                	lui	a5,0xfffff
    80005fe0:	00f97933          	and	s2,s2,a5
	while (fp && fp < upbound) {
    80005fe4:	c09d                	beqz	s1,8000600a <backtrace+0x42>
    80005fe6:	0324f263          	bgeu	s1,s2,8000600a <backtrace+0x42>
		printf("%p\n", *((uint64 *)(fp - 8)));
    80005fea:	00002997          	auipc	s3,0x2
    80005fee:	7f698993          	addi	s3,s3,2038 # 800087e0 <syscalls+0x420>
    80005ff2:	ff84b583          	ld	a1,-8(s1)
    80005ff6:	854e                	mv	a0,s3
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	dbe080e7          	jalr	-578(ra) # 80005db6 <printf>
		uint64 prev_fp = *((uint64 *) (fp - 2 * 8));
    80006000:	ff04b483          	ld	s1,-16(s1)
	while (fp && fp < upbound) {
    80006004:	c099                	beqz	s1,8000600a <backtrace+0x42>
    80006006:	ff24e6e3          	bltu	s1,s2,80005ff2 <backtrace+0x2a>
		fp = prev_fp;
	}
}
    8000600a:	70a2                	ld	ra,40(sp)
    8000600c:	7402                	ld	s0,32(sp)
    8000600e:	64e2                	ld	s1,24(sp)
    80006010:	6942                	ld	s2,16(sp)
    80006012:	69a2                	ld	s3,8(sp)
    80006014:	6145                	addi	sp,sp,48
    80006016:	8082                	ret

0000000080006018 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006018:	1141                	addi	sp,sp,-16
    8000601a:	e406                	sd	ra,8(sp)
    8000601c:	e022                	sd	s0,0(sp)
    8000601e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006020:	100007b7          	lui	a5,0x10000
    80006024:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006028:	f8000713          	li	a4,-128
    8000602c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006030:	470d                	li	a4,3
    80006032:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006036:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000603e:	469d                	li	a3,7
    80006040:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006044:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006048:	00002597          	auipc	a1,0x2
    8000604c:	7b858593          	addi	a1,a1,1976 # 80008800 <digits+0x18>
    80006050:	0003c517          	auipc	a0,0x3c
    80006054:	cc850513          	addi	a0,a0,-824 # 80041d18 <uart_tx_lock>
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	20c080e7          	jalr	524(ra) # 80006264 <initlock>
}
    80006060:	60a2                	ld	ra,8(sp)
    80006062:	6402                	ld	s0,0(sp)
    80006064:	0141                	addi	sp,sp,16
    80006066:	8082                	ret

0000000080006068 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006068:	1101                	addi	sp,sp,-32
    8000606a:	ec06                	sd	ra,24(sp)
    8000606c:	e822                	sd	s0,16(sp)
    8000606e:	e426                	sd	s1,8(sp)
    80006070:	1000                	addi	s0,sp,32
    80006072:	84aa                	mv	s1,a0
  push_off();
    80006074:	00000097          	auipc	ra,0x0
    80006078:	234080e7          	jalr	564(ra) # 800062a8 <push_off>

  if(panicked){
    8000607c:	00003797          	auipc	a5,0x3
    80006080:	8507a783          	lw	a5,-1968(a5) # 800088cc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006084:	10000737          	lui	a4,0x10000
  if(panicked){
    80006088:	c391                	beqz	a5,8000608c <uartputc_sync+0x24>
    for(;;)
    8000608a:	a001                	j	8000608a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000608c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006090:	0207f793          	andi	a5,a5,32
    80006094:	dfe5                	beqz	a5,8000608c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006096:	0ff4f513          	zext.b	a0,s1
    8000609a:	100007b7          	lui	a5,0x10000
    8000609e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	2a6080e7          	jalr	678(ra) # 80006348 <pop_off>
}
    800060aa:	60e2                	ld	ra,24(sp)
    800060ac:	6442                	ld	s0,16(sp)
    800060ae:	64a2                	ld	s1,8(sp)
    800060b0:	6105                	addi	sp,sp,32
    800060b2:	8082                	ret

00000000800060b4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060b4:	00003797          	auipc	a5,0x3
    800060b8:	81c7b783          	ld	a5,-2020(a5) # 800088d0 <uart_tx_r>
    800060bc:	00003717          	auipc	a4,0x3
    800060c0:	81c73703          	ld	a4,-2020(a4) # 800088d8 <uart_tx_w>
    800060c4:	06f70a63          	beq	a4,a5,80006138 <uartstart+0x84>
{
    800060c8:	7139                	addi	sp,sp,-64
    800060ca:	fc06                	sd	ra,56(sp)
    800060cc:	f822                	sd	s0,48(sp)
    800060ce:	f426                	sd	s1,40(sp)
    800060d0:	f04a                	sd	s2,32(sp)
    800060d2:	ec4e                	sd	s3,24(sp)
    800060d4:	e852                	sd	s4,16(sp)
    800060d6:	e456                	sd	s5,8(sp)
    800060d8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060da:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060de:	0003ca17          	auipc	s4,0x3c
    800060e2:	c3aa0a13          	addi	s4,s4,-966 # 80041d18 <uart_tx_lock>
    uart_tx_r += 1;
    800060e6:	00002497          	auipc	s1,0x2
    800060ea:	7ea48493          	addi	s1,s1,2026 # 800088d0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060ee:	00002997          	auipc	s3,0x2
    800060f2:	7ea98993          	addi	s3,s3,2026 # 800088d8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f6:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060fa:	02077713          	andi	a4,a4,32
    800060fe:	c705                	beqz	a4,80006126 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006100:	01f7f713          	andi	a4,a5,31
    80006104:	9752                	add	a4,a4,s4
    80006106:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000610a:	0785                	addi	a5,a5,1
    8000610c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000610e:	8526                	mv	a0,s1
    80006110:	ffffb097          	auipc	ra,0xffffb
    80006114:	52a080e7          	jalr	1322(ra) # 8000163a <wakeup>
    
    WriteReg(THR, c);
    80006118:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000611c:	609c                	ld	a5,0(s1)
    8000611e:	0009b703          	ld	a4,0(s3)
    80006122:	fcf71ae3          	bne	a4,a5,800060f6 <uartstart+0x42>
  }
}
    80006126:	70e2                	ld	ra,56(sp)
    80006128:	7442                	ld	s0,48(sp)
    8000612a:	74a2                	ld	s1,40(sp)
    8000612c:	7902                	ld	s2,32(sp)
    8000612e:	69e2                	ld	s3,24(sp)
    80006130:	6a42                	ld	s4,16(sp)
    80006132:	6aa2                	ld	s5,8(sp)
    80006134:	6121                	addi	sp,sp,64
    80006136:	8082                	ret
    80006138:	8082                	ret

000000008000613a <uartputc>:
{
    8000613a:	7179                	addi	sp,sp,-48
    8000613c:	f406                	sd	ra,40(sp)
    8000613e:	f022                	sd	s0,32(sp)
    80006140:	ec26                	sd	s1,24(sp)
    80006142:	e84a                	sd	s2,16(sp)
    80006144:	e44e                	sd	s3,8(sp)
    80006146:	e052                	sd	s4,0(sp)
    80006148:	1800                	addi	s0,sp,48
    8000614a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000614c:	0003c517          	auipc	a0,0x3c
    80006150:	bcc50513          	addi	a0,a0,-1076 # 80041d18 <uart_tx_lock>
    80006154:	00000097          	auipc	ra,0x0
    80006158:	1a0080e7          	jalr	416(ra) # 800062f4 <acquire>
  if(panicked){
    8000615c:	00002797          	auipc	a5,0x2
    80006160:	7707a783          	lw	a5,1904(a5) # 800088cc <panicked>
    80006164:	e7c9                	bnez	a5,800061ee <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006166:	00002717          	auipc	a4,0x2
    8000616a:	77273703          	ld	a4,1906(a4) # 800088d8 <uart_tx_w>
    8000616e:	00002797          	auipc	a5,0x2
    80006172:	7627b783          	ld	a5,1890(a5) # 800088d0 <uart_tx_r>
    80006176:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000617a:	0003c997          	auipc	s3,0x3c
    8000617e:	b9e98993          	addi	s3,s3,-1122 # 80041d18 <uart_tx_lock>
    80006182:	00002497          	auipc	s1,0x2
    80006186:	74e48493          	addi	s1,s1,1870 # 800088d0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000618a:	00002917          	auipc	s2,0x2
    8000618e:	74e90913          	addi	s2,s2,1870 # 800088d8 <uart_tx_w>
    80006192:	00e79f63          	bne	a5,a4,800061b0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006196:	85ce                	mv	a1,s3
    80006198:	8526                	mv	a0,s1
    8000619a:	ffffb097          	auipc	ra,0xffffb
    8000619e:	43c080e7          	jalr	1084(ra) # 800015d6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a2:	00093703          	ld	a4,0(s2)
    800061a6:	609c                	ld	a5,0(s1)
    800061a8:	02078793          	addi	a5,a5,32
    800061ac:	fee785e3          	beq	a5,a4,80006196 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061b0:	0003c497          	auipc	s1,0x3c
    800061b4:	b6848493          	addi	s1,s1,-1176 # 80041d18 <uart_tx_lock>
    800061b8:	01f77793          	andi	a5,a4,31
    800061bc:	97a6                	add	a5,a5,s1
    800061be:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800061c2:	0705                	addi	a4,a4,1
    800061c4:	00002797          	auipc	a5,0x2
    800061c8:	70e7ba23          	sd	a4,1812(a5) # 800088d8 <uart_tx_w>
  uartstart();
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	ee8080e7          	jalr	-280(ra) # 800060b4 <uartstart>
  release(&uart_tx_lock);
    800061d4:	8526                	mv	a0,s1
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	1d2080e7          	jalr	466(ra) # 800063a8 <release>
}
    800061de:	70a2                	ld	ra,40(sp)
    800061e0:	7402                	ld	s0,32(sp)
    800061e2:	64e2                	ld	s1,24(sp)
    800061e4:	6942                	ld	s2,16(sp)
    800061e6:	69a2                	ld	s3,8(sp)
    800061e8:	6a02                	ld	s4,0(sp)
    800061ea:	6145                	addi	sp,sp,48
    800061ec:	8082                	ret
    for(;;)
    800061ee:	a001                	j	800061ee <uartputc+0xb4>

00000000800061f0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061f0:	1141                	addi	sp,sp,-16
    800061f2:	e422                	sd	s0,8(sp)
    800061f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061f6:	100007b7          	lui	a5,0x10000
    800061fa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061fe:	8b85                	andi	a5,a5,1
    80006200:	cb81                	beqz	a5,80006210 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006202:	100007b7          	lui	a5,0x10000
    80006206:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000620a:	6422                	ld	s0,8(sp)
    8000620c:	0141                	addi	sp,sp,16
    8000620e:	8082                	ret
    return -1;
    80006210:	557d                	li	a0,-1
    80006212:	bfe5                	j	8000620a <uartgetc+0x1a>

0000000080006214 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006214:	1101                	addi	sp,sp,-32
    80006216:	ec06                	sd	ra,24(sp)
    80006218:	e822                	sd	s0,16(sp)
    8000621a:	e426                	sd	s1,8(sp)
    8000621c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000621e:	54fd                	li	s1,-1
    80006220:	a029                	j	8000622a <uartintr+0x16>
      break;
    consoleintr(c);
    80006222:	00000097          	auipc	ra,0x0
    80006226:	8c8080e7          	jalr	-1848(ra) # 80005aea <consoleintr>
    int c = uartgetc();
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	fc6080e7          	jalr	-58(ra) # 800061f0 <uartgetc>
    if(c == -1)
    80006232:	fe9518e3          	bne	a0,s1,80006222 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006236:	0003c497          	auipc	s1,0x3c
    8000623a:	ae248493          	addi	s1,s1,-1310 # 80041d18 <uart_tx_lock>
    8000623e:	8526                	mv	a0,s1
    80006240:	00000097          	auipc	ra,0x0
    80006244:	0b4080e7          	jalr	180(ra) # 800062f4 <acquire>
  uartstart();
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	e6c080e7          	jalr	-404(ra) # 800060b4 <uartstart>
  release(&uart_tx_lock);
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	156080e7          	jalr	342(ra) # 800063a8 <release>
}
    8000625a:	60e2                	ld	ra,24(sp)
    8000625c:	6442                	ld	s0,16(sp)
    8000625e:	64a2                	ld	s1,8(sp)
    80006260:	6105                	addi	sp,sp,32
    80006262:	8082                	ret

0000000080006264 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006264:	1141                	addi	sp,sp,-16
    80006266:	e422                	sd	s0,8(sp)
    80006268:	0800                	addi	s0,sp,16
  lk->name = name;
    8000626a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000626c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006270:	00053823          	sd	zero,16(a0)
}
    80006274:	6422                	ld	s0,8(sp)
    80006276:	0141                	addi	sp,sp,16
    80006278:	8082                	ret

000000008000627a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000627a:	411c                	lw	a5,0(a0)
    8000627c:	e399                	bnez	a5,80006282 <holding+0x8>
    8000627e:	4501                	li	a0,0
  return r;
}
    80006280:	8082                	ret
{
    80006282:	1101                	addi	sp,sp,-32
    80006284:	ec06                	sd	ra,24(sp)
    80006286:	e822                	sd	s0,16(sp)
    80006288:	e426                	sd	s1,8(sp)
    8000628a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000628c:	6904                	ld	s1,16(a0)
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	c84080e7          	jalr	-892(ra) # 80000f12 <mycpu>
    80006296:	40a48533          	sub	a0,s1,a0
    8000629a:	00153513          	seqz	a0,a0
}
    8000629e:	60e2                	ld	ra,24(sp)
    800062a0:	6442                	ld	s0,16(sp)
    800062a2:	64a2                	ld	s1,8(sp)
    800062a4:	6105                	addi	sp,sp,32
    800062a6:	8082                	ret

00000000800062a8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062a8:	1101                	addi	sp,sp,-32
    800062aa:	ec06                	sd	ra,24(sp)
    800062ac:	e822                	sd	s0,16(sp)
    800062ae:	e426                	sd	s1,8(sp)
    800062b0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062b2:	100024f3          	csrr	s1,sstatus
    800062b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062ba:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062bc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062c0:	ffffb097          	auipc	ra,0xffffb
    800062c4:	c52080e7          	jalr	-942(ra) # 80000f12 <mycpu>
    800062c8:	5d3c                	lw	a5,120(a0)
    800062ca:	cf89                	beqz	a5,800062e4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062cc:	ffffb097          	auipc	ra,0xffffb
    800062d0:	c46080e7          	jalr	-954(ra) # 80000f12 <mycpu>
    800062d4:	5d3c                	lw	a5,120(a0)
    800062d6:	2785                	addiw	a5,a5,1
    800062d8:	dd3c                	sw	a5,120(a0)
}
    800062da:	60e2                	ld	ra,24(sp)
    800062dc:	6442                	ld	s0,16(sp)
    800062de:	64a2                	ld	s1,8(sp)
    800062e0:	6105                	addi	sp,sp,32
    800062e2:	8082                	ret
    mycpu()->intena = old;
    800062e4:	ffffb097          	auipc	ra,0xffffb
    800062e8:	c2e080e7          	jalr	-978(ra) # 80000f12 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062ec:	8085                	srli	s1,s1,0x1
    800062ee:	8885                	andi	s1,s1,1
    800062f0:	dd64                	sw	s1,124(a0)
    800062f2:	bfe9                	j	800062cc <push_off+0x24>

00000000800062f4 <acquire>:
{
    800062f4:	1101                	addi	sp,sp,-32
    800062f6:	ec06                	sd	ra,24(sp)
    800062f8:	e822                	sd	s0,16(sp)
    800062fa:	e426                	sd	s1,8(sp)
    800062fc:	1000                	addi	s0,sp,32
    800062fe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006300:	00000097          	auipc	ra,0x0
    80006304:	fa8080e7          	jalr	-88(ra) # 800062a8 <push_off>
  if(holding(lk))
    80006308:	8526                	mv	a0,s1
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	f70080e7          	jalr	-144(ra) # 8000627a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006312:	4705                	li	a4,1
  if(holding(lk))
    80006314:	e115                	bnez	a0,80006338 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006316:	87ba                	mv	a5,a4
    80006318:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000631c:	2781                	sext.w	a5,a5
    8000631e:	ffe5                	bnez	a5,80006316 <acquire+0x22>
  __sync_synchronize();
    80006320:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006324:	ffffb097          	auipc	ra,0xffffb
    80006328:	bee080e7          	jalr	-1042(ra) # 80000f12 <mycpu>
    8000632c:	e888                	sd	a0,16(s1)
}
    8000632e:	60e2                	ld	ra,24(sp)
    80006330:	6442                	ld	s0,16(sp)
    80006332:	64a2                	ld	s1,8(sp)
    80006334:	6105                	addi	sp,sp,32
    80006336:	8082                	ret
    panic("acquire");
    80006338:	00002517          	auipc	a0,0x2
    8000633c:	4d050513          	addi	a0,a0,1232 # 80008808 <digits+0x20>
    80006340:	00000097          	auipc	ra,0x0
    80006344:	a2c080e7          	jalr	-1492(ra) # 80005d6c <panic>

0000000080006348 <pop_off>:

void
pop_off(void)
{
    80006348:	1141                	addi	sp,sp,-16
    8000634a:	e406                	sd	ra,8(sp)
    8000634c:	e022                	sd	s0,0(sp)
    8000634e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	bc2080e7          	jalr	-1086(ra) # 80000f12 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006358:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000635c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000635e:	e78d                	bnez	a5,80006388 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006360:	5d3c                	lw	a5,120(a0)
    80006362:	02f05b63          	blez	a5,80006398 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006366:	37fd                	addiw	a5,a5,-1
    80006368:	0007871b          	sext.w	a4,a5
    8000636c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000636e:	eb09                	bnez	a4,80006380 <pop_off+0x38>
    80006370:	5d7c                	lw	a5,124(a0)
    80006372:	c799                	beqz	a5,80006380 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006374:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006378:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000637c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006380:	60a2                	ld	ra,8(sp)
    80006382:	6402                	ld	s0,0(sp)
    80006384:	0141                	addi	sp,sp,16
    80006386:	8082                	ret
    panic("pop_off - interruptible");
    80006388:	00002517          	auipc	a0,0x2
    8000638c:	48850513          	addi	a0,a0,1160 # 80008810 <digits+0x28>
    80006390:	00000097          	auipc	ra,0x0
    80006394:	9dc080e7          	jalr	-1572(ra) # 80005d6c <panic>
    panic("pop_off");
    80006398:	00002517          	auipc	a0,0x2
    8000639c:	49050513          	addi	a0,a0,1168 # 80008828 <digits+0x40>
    800063a0:	00000097          	auipc	ra,0x0
    800063a4:	9cc080e7          	jalr	-1588(ra) # 80005d6c <panic>

00000000800063a8 <release>:
{
    800063a8:	1101                	addi	sp,sp,-32
    800063aa:	ec06                	sd	ra,24(sp)
    800063ac:	e822                	sd	s0,16(sp)
    800063ae:	e426                	sd	s1,8(sp)
    800063b0:	1000                	addi	s0,sp,32
    800063b2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	ec6080e7          	jalr	-314(ra) # 8000627a <holding>
    800063bc:	c115                	beqz	a0,800063e0 <release+0x38>
  lk->cpu = 0;
    800063be:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063c2:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063c6:	0f50000f          	fence	iorw,ow
    800063ca:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ce:	00000097          	auipc	ra,0x0
    800063d2:	f7a080e7          	jalr	-134(ra) # 80006348 <pop_off>
}
    800063d6:	60e2                	ld	ra,24(sp)
    800063d8:	6442                	ld	s0,16(sp)
    800063da:	64a2                	ld	s1,8(sp)
    800063dc:	6105                	addi	sp,sp,32
    800063de:	8082                	ret
    panic("release");
    800063e0:	00002517          	auipc	a0,0x2
    800063e4:	45050513          	addi	a0,a0,1104 # 80008830 <digits+0x48>
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	984080e7          	jalr	-1660(ra) # 80005d6c <panic>
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
