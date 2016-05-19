PBC	equ	$ffe0	;Port B Control register
PCC	equ	$ffe1	;Port C Control register
PBDDR	equ	$ffe2	;Port B Data Direction Register
PCDDR	equ	$ffe3	;Port C Data Direction Register
PBD	equ	$ffe4	;Port B Data register
PCD	equ	$ffe5	;Port C Data register
HCR	equ	$ffe8	;Host Control Register
HSR	equ	$ffe9	;Host Status Register
hsr	equ	$ffe9

HRX	equ	$ffeb	;Host Receive Register
hrx	equ	$ffeb

HTX	equ	$ffeb	;Host Transmit Register
htx	equ	$ffeb

BCR	equ	$fffe	;Port A Bus Control Register

;--------------------- MACROS --------------------------
wait_receive	MACRO
		jclr	#0,x:<<HSR,*
		ENDM
wait_transmit	MACRO
		jclr	#1,x:<<HSR,*
		ENDM

start:
	org		p:0
	jmp		main
	
	org		p:$40
main:
	movec	#0,sr				; kill loop and trace
	movep	#>0,x:<<$fffe		; BCR port B bus control
	movep	#$c00,x:<<$ffff		;     interrupt priority
	movep	#>1,x:<<$ffe0		; PBC port B control
	movep	#>4,x:<<$ffe8		;     host control
	;andi	#$00,omr			; allow all interrupts?
	andi	#$fc,mr				; allow all interrupts
	movec	#%10000010,omr		; allow ext. mem access,
								; no data rom, normal expanded.
	move	#0,a0
	move	#$010,x0
loop:
	wait_transmit
	movep a0,x:<<htx
	add	x,a
	jmp loop

