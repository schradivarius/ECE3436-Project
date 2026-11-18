

	THUMB
		
; ************ GPIO EQU directives *************
GPIO_PORTB_DATA_R   EQU 0x400053FC   ; GPIO Data register
LED1                EQU 0x01          ; PB0
LED2                EQU 0x02          ; PB1
LED3                EQU 0x04          ; PB2

	
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    SA1CodeArea, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  

	EXPORT	specificAim1_LEDs
	IMPORT	SysTick_Wait10ms

		
		
		
specificAim1_LEDs
; subroutine code goes here
	PUSH	{R4, LR}
	LDR	R4, =GPIO_PORTB_DATA_R  ; keep Port B data address in R4
	                                ; (R4 is preserved by SysTick_Wait10ms)

Aim1_Loop

	; ---- LED1 on for 1 s ----
	MOV	R0, #LED1
	STR	R0, [R4]
	MOV	R0, #100                ; 100 x 10 ms = 1 s
	BL	SysTick_Wait10ms

	; ---- LED1 off for 1 s ----
	MOV	R0, #0
	STR	R0, [R4]
	MOV	R0, #100
	BL	SysTick_Wait10ms

	; ---- LED2 on for 1 s ----
	MOV	R0, #LED2
	STR	R0, [R4]
	MOV	R0, #100
	BL	SysTick_Wait10ms

	; ---- LED2 off for 1 s ----
	MOV	R0, #0
	STR	R0, [R4]
	MOV	R0, #100
	BL	SysTick_Wait10ms

	; ---- LED3 on for 1 s ----
	MOV	R0, #LED3
	STR	R0, [R4]
	MOV	R0, #100
	BL	SysTick_Wait10ms

	; ---- LED3 off for 1 s ----
	MOV	R0, #0
	STR	R0, [R4]
	MOV	R0, #100
	BL	SysTick_Wait10ms

	B	Aim1_Loop               ; repeat forever (SOW requires continuous succession)


	ALIGN
	END



















	BX LR	; return from subroutine

	ALIGN
	END