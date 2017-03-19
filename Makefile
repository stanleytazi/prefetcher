CC ?= gcc
CFLAGS_common = --std gnu99 -O0 -Wall -Wextra
CFLAGS_sse = -msse2

EXEC = naive_transpose sse_transpose sse_pf_d1_transpose sse_pf_d2_transpose \
			 sse_pf_d4_transpose sse_pf_d8_transpose

GIT_HOOS := .git/hooks/applied

SRCS_common = main.c

all: $(GIT_HOOKS) main.c
	$(CC) $(CFLAGS) -o main main.c

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo


ifeq ($(strip $(VERF)), 1)
VERF_FLAGS = -DVERF
CFLAGS_common += -$(VERF_FLAGS)
endif


naive_transpose: $(SRCS_common) 
	$(CC) $(CFLAGS_common) \
			-DNAIVE -o $@ \
			$(SRCS_common) 

sse_transpose: $(SRCS_common)
	$(CC) $(CFLAGS_common) $(CFLAGS_sse) \
			-DSSE -o $@ \
			$(SRCS_common) 
sse_pf_d1_transpose: $(SRCS_common)
	$(CC) $(CFLAGS_common) $(CFLAGS_sse) \
			-DSSE_PF -DPFDIST=1 -o $@ \
			$(SRCS_common) 

sse_pf_d2_transpose: $(SRCS_common)
	$(CC) $(CFLAGS_common) $(CFLAGS_sse) \
			-DSSE_PF -DPFDIST=2 -o $@ \
			$(SRCS_common) 

sse_pf_d4_transpose: $(SRCS_common)
	$(CC) $(CFLAGS_common) $(CFLAGS_sse) \
			-DSSE_PF -DPFDIST=4 -o $@ \
			$(SRCS_common) 

sse_pf_d8_transpose: $(SRCS_common)
	$(CC) $(CFLAGS_common) $(CFLAGS_sse) \
			-DSSE_PF -DPFDIST=8 -o $@ \
			$(SRCS_common) 

pf-test: $(EXEC)
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./naive_transpose
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./sse_transpose
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./sse_pf_d1_transpose
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./sse_pf_d2_transpose
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./sse_pf_d4_transpose
	perf stat --repeat 100 \
			-e cpu/event=0xD0,umask=0x81/,r81d0,cpu/event=0xd1,umask=0x01/,\
cpu/event=0x24,umask=0xe1/,cpu/event=0x24,umask=0x41/,\
cpu/event=0xd1,umask=0x02/,cpu/event=0xd1,umask=0x04/,\
cpu/event=0xd1,umask=0x08/,cpu/event=0xd1,umask=0x10/,\
cpu/event=0xd1,umask=0x20/,cpu/event=0xd1,umask=0x40/,\
cpu/event=0xd1,umask=0x80/,\
cache-misses,cache-references,instructions,cycles,\
L1-dcache-loads,L1-dcache-load-misses,\
L1-dcache-stores,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores \
./sse_pf_d8_transpose

output.txt: pf-test calculate
	./calculate

#plot: output.txt
#	gnuplot scripts/runtime.gp

#calculate: calculate.c
#	$(CC) $(CFLAGS_common) $^ -o $@

clean:
	$(RM) $(EXEC) *.o perf.* \
			calculate *.txt runtime.png
