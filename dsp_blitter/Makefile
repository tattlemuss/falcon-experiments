SRC_PATH=.
OUT_DIR=./bin
OUT_PATH=$(OUT_DIR)/dspblit.tos

ASM_OBJS=bin/main.obj
#DSP_OBJ=dsp.lod

TEST_BIN= $(TEST_SRC:${SRC_PATH}/%.c=${OUT_PATH}/%)
VASM=vasmm68k_mot
VLINK=vlink
ASM56K=asm56k

.PHONY: all
all: dirs $(OUT_PATH)

dirs:
	mkdir -p bin

bin/%.obj: %.s
	${VASM} -Felf -m68030 -spaces $< -o $@

# Generate a P56 file
%.p56: %.asm
	${ASM56K} $< -p $@

${OUT_PATH}: $(ASM_OBJS) $(DSP_OBJ)
	${VLINK} $(ASM_OBJS) -b ataritos -o $@

clean:
	rm -rf ${OUT_DIR}/*
	rm -f $(ASM_OBJS)

.PHONY: hatari	
hatari: all
	hatari --machine falcon --dsp emu --blitter y --tos tos404.img $(OUT_PATH)

main.obj :	dsp.p56

