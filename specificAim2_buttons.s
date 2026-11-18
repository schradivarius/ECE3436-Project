

	THUMB
		
GPIO_PORTC_DATA_R   EQU 0x400063FC	; GPIO Data Register
	
	
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    SA2CodeArea, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  

	EXPORT	specificAim2_buttons
		
		
		
		
specificAim2_buttons
; subroutine code goes here

	LDR	R4, =GPIO_PORTC_DATA_R	; R4 = Port C data register address

Aim2_Loop
	LDR	R5, [R4]		; read PC4, PC5 button states into R5
					; (logic analyzer probes the pins directly;
					;  R5 is for debugger visibility too)
	B	Aim2_Loop		; repeat forever - "continuously display"



















	BX LR	; return from subroutine

	ALIGN
	END