;****************** main.s ***************
; Program written by: Your names here
; Date Created: 
; Last Modified: 
; Brief description of the program: 
	
		THUMB
				
 ; ********************************************************************
 ; ********************* EQU Label Definitions ************************
 ; ********************************************************************

; Port F Data registers
GPIO_PORTF_DATA_R  	EQU 0x400253FC	; to read all bits on Port F
GPIO_PORTF_DATA_INS	EQU	0x40025044	; read input pins on Port F
GPIO_PORTF_DATA_OUT	EQU	0x40025038	; write to output pins on Port F
	
	
; *********************************************************************
; ************************* ROM CONSTANTS AREA ************************
; *********************************************************************
; Constants and code area starts at address 0x0000.0000
	AREA    MyConstants, DATA, READONLY, ALIGN=2		; Flash EEPROM
			
		 
; *********************************************************************
; ************************* RAM VARIABLES AREA ************************
; *********************************************************************
; SRAM variables area starts at address 0x2000.0000
	AREA    MyVariables, DATA, READWRITE, ALIGN=2		; SRAM

		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    |.text|, CODE, READONLY, ALIGN=2		; Flash ROM
		    
		  
	EXPORT  Start
; Port Configuration Subroutine Labels
	IMPORT	portAconfig
	IMPORT	portBconfig
	IMPORT	portCconfig
	IMPORT	portDconfig
	IMPORT	portFconfig
; SysTick Timer Subroutine Labels
	IMPORT	SysTick_Config
	IMPORT	SysTick_Wait
	IMPORT	SysTick_Wait10ms
; Test Subroutine Labels
	IMPORT	specificAim1_LEDs
	IMPORT	specificAim2_buttons
	IMPORT	specificAim3_buzzer
	IMPORT	specificAim4_motor
			  





Start

; Configure Ports
	BL		portAconfig
	BL		portBconfig
	BL		portCconfig
	BL		portDconfig
	BL		portFconfig
	NOP
; Configure SysTick Timer
	BL		SysTick_Config
	NOP

;	Test Subroutines
;	BL		specificAim1_LEDs
	BL		specificAim2_buttons
;	BL		specificAim3_buzzer
;	BL		specificAim4_motor
	NOP

; *********** START YOUR CODE FOR SPECIFIC AIM 5 HERE *****************
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

      
    ALIGN      ; make sure the end of this section is aligned
    END        ; end of file

