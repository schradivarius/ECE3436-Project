	THUMB


; ************ GPIO EQU directives *************	
GPIO_PORTC_DATA_R   EQU 0x400063FC   ; GPIO Data register
GPIO_PORTC_DIR_R    EQU 0x40006400   ; GPIO Direction register
GPIO_PORTC_AFSEL_R  EQU 0x40006420   ; GPIO Alternate Function Select
GPIO_PORTC_DEN_R    EQU 0x4000651C   ; GPIO Digital Enable
GPIO_PORTC_PUR_R    EQU 0x40006510   ; GPIO Pull-Up Select
GPIO_PORTC_AMSEL_R  EQU 0x40006528   ; GPIO Analog Mode Select
GPIO_PORTC_PCTL_R   EQU 0x4000652C   ; GPIO Port Control
SYSCTL_RCGCGPIO_R   EQU 0x400FE608   ; GPIO Run Mode Clock Gating Control



; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    PortC_Config, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  

	EXPORT	portCconfig
		
		
		
		
portCconfig
	
; INITIALIZATION CODE ***********************************

; step 1:  activate clock for Port
	LDR	R1, =SYSCTL_RCGCGPIO_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x04           ; set bit 2 -> Port C clock on
	STR	R0, [R1]
	NOP
	NOP                             ; allow clock to settle

; step 2: unlock the lock register for Port
	; 2a: load the key in the lock register


	; 2b: give write access to GPIOAFSEL, GPIOPUR, GPIOPDR, & GPIODEN configuration registers


; step 3: disable analog function --> analog function is disabled by default
	LDR	R1, =GPIO_PORTC_AMSEL_R
	LDR	R0, [R1]
	BIC	R0, R0, #0x30			; clear AMSEL for PC4, PC5 only
	STR	R0, [R1]
  
; step 4: clear bits in PCTL --> most GPIO pins are set to GPIO on reset (i.e., no alternate function)
	LDR	R1, =GPIO_PORTC_PCTL_R
	LDR	R0, [R1]
	BIC	R0, R0, #0x00FF0000		; clear PCTL bits 16-23 (PC4, PC5) ONLY
						; (bits 0-15 = PC0-PC3 = JTAG, must NOT be touched)
	STR	R0, [R1]

 
; step 5: set direction register
	LDR	R1, =GPIO_PORTC_DIR_R
	LDR	R0, [R1]
	BIC	R0, R0, #0x30           ; clear bits 4 and 5 -> inputs
	STR	R0, [R1]
	
; step 6: clear bits in alternate function register
	LDR	R1, =GPIO_PORTC_AFSEL_R
	LDR	R0, [R1]
	BIC	R0, R0, #0x30           ; AFSEL = 0 -> regular GPIO
	STR	R0, [R1]
 
; step 7: enable digital port
	LDR	R1, =GPIO_PORTC_DEN_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x30           ; digital enable on PC4, PC5
	STR	R0, [R1]
	LDR	R1, =GPIO_PORTC_PUR_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x30           ; pull-up on PC4, PC5
	STR	R0, [R1]
	
	BX	LR
	
	
	ALIGN
		
	END