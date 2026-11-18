;****************** main.s ***************
; Program written by: Dr. D
; Date Created: 4/8/21
; Last Modified: 4/8/21
; Brief description of the program: Code to configure the System Clock
;	
  

 ; ********************************************************************
 ; ********************* EQU Label Definitions ************************
 ; ********************************************************************

; SysTick Timer addresses
NVIC_ST_CTRL_R 		EQU 0xE000E010	; SysTick Control and Status Register (STCTRL)
NVIC_ST_RELOAD_R	EQU 0xE000E014	; SysTick Reload Value register (STRELOAD)
NVIC_ST_CURRENT_R	EQU 0xE000E018	; SysTick Current Value Register (STCURRENT)
;DELAY				EQU 400000		; 400,000 ticks = 5ms at 80MHz


	THUMB
	
		  
; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    MySysTickCode, CODE, READONLY, ALIGN=2		; Flash ROM	    

	ALIGN
		  

	EXPORT	SysTick_Config
	EXPORT	SysTick_Wait
	EXPORT	SysTick_Wait10ms

SysTick_Config
; Step 1: clear the SysTick enable bit to turn off during initialization
	LDR R1, =NVIC_ST_CTRL_R
	LDR	R0, [R1]
	BIC R0, #1
	STR R0, [R1]
	
; Step 2: reload the counter start value
	LDR R1, =NVIC_ST_RELOAD_R
	LDR R0, =0x00FFFFFF	; maximum reload value 0x00FF.FFFF = 16,777,215
	STR R0, [R1]
	
; Step 3: write to current value register to clear the counter
	LDR R1, =NVIC_ST_CURRENT_R
	LDR R0, [R1]
	ORR R0, #0x1
	STR R0, [R1]
	
; Step 4: write the desired clock mode (core clock) to the control register
	LDR R1, =NVIC_ST_CTRL_R
	LDR	R0, [R1]
	ORR R0, #0x05	; ENABLE and CLK_SRC bits set
	STR R0, [R1]
	BX 	LR
	


; **********************************************************************************************

; ******************** SysTick Wait ********************	
; Time delay using busy wait. 
; Input: R0 --> # to load into SysTick Timer
; Output: none
; Modifies: R0, R1, R3
; Function Calls: NO


SysTick_Wait
	; load counter with desired number of ticks
	LDR	R1,	=NVIC_ST_RELOAD_R	; R1 = &NVIC_ST_RELOAD_R
	
	; counter ticks N + 1 times so need to subtract 1
	SUB	R0,	#1					
	STR	R0,	[R1]
	
	; reset count bit
	LDR	R1, =NVIC_ST_CURRENT_R
	STR	R1, [R1]
	
	; get address of register that has COUNT bit
	LDR	R1,	=NVIC_ST_CTRL_R		; R1 = & NVIC_ST_CTRL_R


SysTick_Wait_loop
	LDR	R3,	[R1]
	ANDS R3, R3, #0x00010000	; COUNT bit is bit 16
	BEQ	SysTick_Wait_loop		; if COUNT == 0, the counter has not hit zero, so keep waiting
	BX	LR
	
	
	
; **************************************************************************************************
; ******************** SysTick Wait 10ms ********************	
; Time delay using busy wait. 
; Input: R0 --> # of times to wait 10 ms before returning
; Output: none
; Modifies: R0, R4
; Function Calls: YES

;DELAY10MS EQU	800000			; 800,000 ticks of 80MHz clock = 10ms
DELAY10MS EQU	160000			; 160,000 ticks of 16MHz clock = 10ms
	
SysTick_Wait10ms
	PUSH {R4, LR}				; save current value of R4 and LR
	MOVS R4, R0					; R4 = R0 = remainingWaits
	BEQ SysTick_Wait10ms_done	; R4 == 0, done
SysTick_Wait10ms_loop
	LDR R0, =DELAY10MS			; R0 = DELAY10MS
	BL SysTick_Wait				; expects R0 to hold # of ticks to time
	SUBS R4, R4, #1				; R4 = R4 -1; remaining10msWaits--
	BHI SysTick_Wait10ms_loop	; if (R4 > 0), wait another 10ms
SysTick_Wait10ms_done			
	POP {R4, LR}
	BX	LR
	
	


	ALIGN      ; make sure the end of this section is aligned
    END        ; end of file