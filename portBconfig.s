	THUMB


; ************ GPIO EQU directives *************	

GPIO_PORTB_DATA_R   EQU 0x400053FC   ; GPIO Data register
GPIO_PORTB_DIR_R    EQU 0x40005400   ; GPIO Direction register
GPIO_PORTB_AFSEL_R  EQU 0x40005420   ; GPIO Alternate Function Select
GPIO_PORTB_DEN_R    EQU 0x4000551C   ; GPIO Digital Enable
GPIO_PORTB_AMSEL_R  EQU 0x40005528   ; GPIO Analog Mode Select
GPIO_PORTB_PCTL_R   EQU 0x4000552C   ; GPIO Port Control
SYSCTL_RCGCGPIO_R   EQU 0x400FE608   ; GPIO Run Mode Clock Gating Control


; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    PortB_Config, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  

	EXPORT	portBconfig
		
		
		
		
portBconfig
	
; INITIALIZATION CODE ***********************************

; step 1:  activate clock for Port
	LDR	R1, =SYSCTL_RCGCGPIO_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x02           ; set bit 1 -> Port B clock on
	STR	R0, [R1]
	NOP
	NOP                             ; allow clock to settle

; step 2: unlock the lock register for Port
	; 2a: load the key in the lock register


	; 2b: give write access to GPIOAFSEL, GPIOPUR, GPIOPDR, & GPIODEN configuration registers


; step 3: disable analog function --> analog function is disabled by default
	LDR	R1, =GPIO_PORTB_AMSEL_R
	LDR	R0, [R1]
	BIC	R0, R0, #0xFF
	STR	R0, [R1]
  
; step 4: clear bits in PCTL --> most GPIO pins are set to GPIO on reset (i.e., no alternate function)
	LDR	R1, =GPIO_PORTB_PCTL_R
	MOV	R0, #0
	STR	R0, [R1]
 
; step 5: set direction register
	LDR	R1, =GPIO_PORTB_DIR_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x07           ; bits 0, 1, 2 to output
	STR	R0, [R1]
	
; step 6: clear bits in alternate function register
	LDR	R1, =GPIO_PORTB_AFSEL_R
	LDR	R0, [R1]
	BIC	R0, R0, #0xFF           ; AFSEL = 0 -> regular GPIO
	STR	R0, [R1]
 
; step 7: enable digital port
	LDR	R1, =GPIO_PORTB_DEN_R
	LDR	R0, [R1]
	ORR	R0, R0, #0x07           ; digital enable on PB0-PB2
	STR	R0, [R1]


	
	BX	LR
	
	
	ALIGN
		
	END