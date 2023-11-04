.PHONY: all clean

all: readfile

readfile.o: readfile.asm
	yasm -f elf64 -g dwarf2 readfile.asm

readfile: readfile.o
	ld readfile.o -o readfile

clean:
	rm -f readfile readfile.o
