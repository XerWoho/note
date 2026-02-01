ASM     = nasm
ASMFLAGS= -f elf64
LD      = ld
LDFLAGS = -no-pie

OBJS = main.o fs.o help.o exit.o clear.o write.o

notepad: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) 

%.o: %.S
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -f $(OBJS) notepad
