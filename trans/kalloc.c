// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
#define MAX_PAGE_NUM ((int) ((PGROUNDDOWN(PHYSTOP) - PGROUNDUP((uint64) end)) / PGSIZE))

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  int ref_counts[MAX_PAGE_NUM];
} kmem;



int get_page_num(void *pa) {
	uint64 start = PGROUNDUP((uint64) end);
	return (int) (((uint64) (pa) - start) / PGSIZE);
}

void incr_ref_count(void *pa, int count) {
	int page_num = get_page_num(pa);
	acquire(&kmem.lock);
	kmem.ref_counts[page_num] += count;
	printf("p: %p, page num: %d\n", pa, page_num);
	release(&kmem.lock);	
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  /*memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);*/
  incr_ref_count(pa, -1);

  int page_num = get_page_num(pa);
  acquire(&kem.lock);
  if (ref_counts[page_num] <= 0) {
  	memset(pa, 1, PGSIZE);
	r = (struct *run*)pa;
	r->next = kmem.freelist;
    kmem.freelist = r;
  }
  release(&kem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
	int page_num = get_page_num((void *) r);
	ref_counts[page_num] = 1;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
