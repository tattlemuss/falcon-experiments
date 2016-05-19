        include    "hardware.i"

main:
	clr.l	-(a7)
	move.w	#$20,-(a7)
	trap	#1
	addq.l	#6,a7
	
	 	
	;DSP lock
	move.w    #104,-(sp)   ; Offset 0
	trap      #14          ; Call XBIOS
	addq.l    #2,sp        ; Correct stack
	tst.w	d0
	;bmi		fail			; This seems to fail in Hatari

	;Load DSP program
	move.w	#1,-(sp)  	   ; Offset 10, "ability"
	move.l	#dsp_data_size,-(sp) ; Offset  6
	pea		dsp_data        ; Offset  2
;	move.w	#110,-(sp)     ; Offset  0
	move.w	#109,-(sp)     ; Offset  0
	trap	#14            ; Call XBIOS
	lea		$C(sp),sp      ; Correct stack
	tst.w	d0
	;bmi		fail

	; Switch screen mode to truecolor
	; http://toshyp.atari.org/en/Screen_functions.html#Vsetmode
		
	; Calc screen address
	move.l	#screen,d0
	and.l	#$ffffff00,d0
	move.l	d0,-(a7)
	
	; Set screen address and res
	move.w  #VSETMODE_TRUCOLOR,-(sp)   ; Offset 12
	move.w  #3,-(sp)    ; Offset 10
	move.l  d0,-(sp)  ; Offset  6
	move.l  d0,-(sp)  ; Offset  2
	move.w  #5,-(sp)     ; Offset  0
	trap    #14          ; Call XBIOS
	lea     14(sp),sp    ; Correct stack
	move.l	(a7)+,a0	; a0 - screen base
	tst.w	d0
	bmi		fail

loop:
	lea	$ffffA206.w,a1	            ;a1 = DSP host post
        add.w   #$111,fake_src

XCOUNT  equ     256
YCOUNT  equ     128

        if     1
	move.l	a0,a2
        move.w	#YCOUNT-1,d0
.yloop:
        move.w	#XCOUNT-1,d1
.xloop:
	move.w	(a1),(a2)+
	dbf     d1,.xloop
	lea     (320*2)-(XCOUNT*2)(a2),a2
	dbf     d0,.yloop
        
        else
        
        move.w	#2,BLT_DST_INC_X.w
	move.w	#(320*2)-(XCOUNT*2)+2,BLT_DST_INC_Y.w
	move.l  a0,BLT_DST_ADDR_L.w        ;set destination

	move.w	#0,BLT_SRC_INC_X.w
	move.w	#0,BLT_SRC_INC_Y.w
	move.l  a1,BLT_SRC_ADDR_L.w        ;SRC = blitter
;	move.l  #fake_src,BLT_SRC_ADDR_L.w        ;SRC = blitter

	move.b	#BLT_HOP_SRC, BLT_HOP.w         ;halftone isn't used
	move.b	#BLT_OP_S, BLT_OP.w             ;operation = "source"
	move.w	#$ffff,BLT_ENDMASK_1.w
	move.w	#$ffff,BLT_ENDMASK_2.w
	move.w	#$ffff,BLT_ENDMASK_3.w

    	;move.b	0,BLT_MISC_1.w			; no HOG
	move.b	#BLT_MISC_1_HOG,BLT_MISC_1.w	; HOG
	
	move.w	#XCOUNT,BLT_COUNT_X.w
	move.w	#YCOUNT,BLT_COUNT_Y.w

	; Kick it
	moveq	#7,d2
        bset.b  d2,BLT_MISC_1.w

.rs     btst.b  d2,BLT_MISC_1.w
        bne.s	.rs

        endif
        
;	not.l   $ffff9800.w
        cmp.b   #$39,$fffffc02.w
	bne.s	loop

;------------------------------------------------------------------------------
fail:
	clr.w	-(a7)
	trap	#1
	
;------------------------------------------------------------------------------
	section	data
;------------------------------------------------------------------------------
	
dsp_data:	
	incbin	dsp.p56
dsp_data_end:

dsp_data_size	equ		(dsp_data_end-dsp_data)/3

            even
fake_src:   dc.w    $000

;------------------------------------------------------------------------------
	section	bss
;------------------------------------------------------------------------------
                ds.b    32000
                
                ds.b	256
screen		ds.b	320*200*2

