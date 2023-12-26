# Makefile for assembling ASM code

# Assembler and flags
ASM=nasm
ASMFLAGS=-f elf64

# Source and object files
SRC=$(wildcard src/*.asm)
OBJ=$(SRC:.asm=.o)

# Output binary
BIN=window

# Default target
all: $(BIN)

# Rule to build object files
%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Rule to link the binary
$(BIN): $(OBJ)
	ld -o $@ $^ -lSDL2 -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

# Clean up
clean:
	rm -f $(OBJ) $(BIN)

# Phony targets
.PHONY: all clean
