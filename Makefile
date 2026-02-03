ASM      = nasm
ASMFLAGS = -f elf64
LD       = ld

SRC_STD     = std/fs.S std/read.S std/write.S std/io.S
SRC_HELPERS = helpers/clear.S helpers/exit.S helpers/termios.S helpers/help.S helpers/delete.S
SRC_MAIN    = main.S

SRCS = $(SRC_MAIN) $(SRC_STD) $(SRC_HELPERS)

OBJS = $(SRCS:%.S=bin/obj/%.o)

BIN = bin/notepad

all: $(BIN)

$(BIN): $(OBJS)
	@mkdir -p bin
	$(LD) -o $@ $(OBJS)

bin/obj/%.o: %.S
	@mkdir -p $(dir $@)
	$(ASM) $(ASMFLAGS) $< -o $@

clean:
	rm -rf bin
