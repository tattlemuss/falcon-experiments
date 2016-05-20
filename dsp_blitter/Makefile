SRC_PATH=.
OUT_DIR=./bin
OUT_PATH=$(OUT_DIR)/dspblit.tos

ASM_OBJS=bin/main.obj bin/dspblit.obj
#DSP_OBJ=dsp.lod

TEST_BIN= $(TEST_SRC:${SRC_PATH}/%.c=${OUT_PATH}/%)
VASM=vasmm68k_mot
VLINK=vlink
ASM56K=asm56k
CC=m68k-atari-mint-gcc
LD=m68k-atari-mint-gcc


.PHONY: all
all: dirs $(OUT_PATH)

dirs:
	mkdir -p bin

bin/%.obj: %.s
	${VASM} -quiet -Faout -m68030 -spaces $< -o $@

bin/%.obj: %.c
	${CC} -Os -g -c $< -o $@

# Generate a P56 file
bin/%.p56: %.asm
	${ASM56K} $< -p $@

${OUT_PATH}: $(ASM_OBJS) $(C_OBJS)
	${LD} -nostdlib -fno-exceptions -fno-rtti -fomit-frame-pointer $(C_OBJS) $(ASM_OBJS) -o $@

clean:
	rm -rf ${OUT_DIR}/*
	rm -f $(ASM_OBJS)

.PHONY: hatari	
hatari: all
	hatari --machine falcon --dsp emu --blitter y --tos tos404.img $(OUT_PATH)

bin/main.obj :	bin/dsp.p56

