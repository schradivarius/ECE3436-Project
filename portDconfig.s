	THUMB


; ************ GPIO EQU directives *************	




; *********************************************************************
; *************************** CODE AREA IN ROM ************************
; *********************************************************************
	AREA    PortD_Config, CODE, READONLY, ALIGN=2		; Flash ROM
		  
		  

	EXPORT	portDconfig
		
		
		
		
portDconfig
	
; INITIALIZATION CODE ***********************************

; step 1:  activate clock for Port


; step 2: unlock the lock register for Port
	; 2a: load the key in the lock register


	; 2b: give write access to GPIOAFSEL, GPIOPUR, GPIOPDR, & GPIODEN configuration registers


; step 3: disable analog function --> analog function is disabled by default

  
; step 4: clear bits in PCTL --> most GPIO pins are set to GPIO on reset (i.e., no alternate function)

 
; step 5: set direction register

	
; step 6: clear bits in alternate function register

 
; step 7: enable digital port

	
	BX	LR
	
	
	ALIGN
		
	END