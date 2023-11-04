.PHONY: all clean

all: mmap dump_stat_struct

mmap.o: mmap.asm
	yasm -f elf64 -g dwarf2 mmap.asm

mmap: mmap.o
	ld mmap.o -o mmap

dump_stat_struct: dump_stat_struct.c
	gcc dump_stat_struct.c -o dump_stat_struct

clean:
	rm -f mmap dump_stat_struct mmap.o
