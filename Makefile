OBJDIR = ./lib
BUILDDIR = ./bin

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

CPPSRC = $(call rwildcard,./,*.cpp)
CSRC = $(call rwildcard,./,*.c)
ASMSRC = $(call rwildcard,./,*.asm)
OBJS = $(patsubst %.cpp, $(OBJDIR)/%.o, $(CPPSRC))
OBJS += $(patsubst %.c, $(OBJDIR)/%.o, $(CSRC))
OBJS += $(patsubst %.asm, $(OBJDIR)/%_asm.o, $(ASMSRC))

TOOLCHAIN_BASE = /usr/local/foxos-x86_64_elf_gcc

CC = gcc
ASM = nasm
LD = ld


CPPFLAGS = -ffreestanding -fshort-wchar -mno-red-zone -Iinclude -fno-use-cxa-atexit -fno-rtti -fno-exceptions -fno-leading-underscore -fno-exceptions -fno-stack-protector -mno-sse -mno-sse2 -mno-3dnow -mno-80387
CFLAGS = -ffreestanding -fshort-wchar -mno-red-zone -Iinclude -fno-exceptions -fno-leading-underscore -fno-exceptions -fno-stack-protector -mno-sse -mno-sse2 -mno-3dnow -mno-80387
ASMFLAGS = -f elf64
LDFLAGS = -r

stdlib.o: $(OBJS)
	@mkdir -p $(BUILDDIR)
	@echo LD $^
	@$(LD) $(LDFLAGS) -o $(BUILDDIR)/$@ $^

	@echo "\n\nCompiled using asm: $(ASM), cc: $(CC), ld: $(LD)\n\n"

$(OBJDIR)/%.o: %.cpp
	@echo "CPP $^ -> $@"
	@mkdir -p $(@D)
	@$(CC) $(CPPFLAGS) -c -o $@ $^

$(OBJDIR)/%.o: %.c
	@echo "CC $^ -> $@"
	@mkdir -p $(@D)
	@$(CC) $(CFLAGS) -c -o $@ $^

$(OBJDIR)/%_asm.o: %.asm
	@echo "ASM $^ -> $@"
	@mkdir -p $(@D)
	@$(ASM) $(ASMFLAGS) -o $@ $^