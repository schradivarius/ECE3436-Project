	THUMB

; ** GPIO EQU directives **
GPIO_PORTC_DATA_R   EQU 0x400063FC   ; GPIO Data register
GPIO_PORTC_DIR_R    EQU 0x40006400   ; GPIO Direction register
GPIO_PORTC_AFSEL_R  EQU 0x40006420   ; GPIO Alternate Function Select
GPIO_PORTC_DEN_R    EQU 0x4000651C   ; GPIO Digital Enable
GPIO_PORTC_PUR_R    EQU 0x40006510   ; GPIO Pull-Up Select
GPIO_PORTC_AMSEL_R  EQU 0x40006528   ; GPIO Analog Mode Select
GPIO_PORTC_PCTL_R   EQU 0x4000652C   ; GPIO Port Control
SYSCTL_RCGCGPIO_R   EQU 0x400FE608   ; GPIO Run Mode Clock Gating Control

; **
; ** CODE AREA IN ROM **
; **
    AREA    PortC_Config, CODE, READONLY, ALIGN=2
    

    EXPORT    portCconfig


portCconfig

; step 1: activate clock for Port C
    LDR    R1, =SYSCTL_RCGCGPIO_R
    LDR    R0, [R1]
    ORR    R0, R0, #0x04           ; set bit 2 -> Port C clock on
    STR    R0, [R1]
    NOP
    NOP                             ; allow clock to settle

; step 2: unlock the lock register for Port C
    ; PC0-PC3 are protected pins, but we are using PC4 and PC5.
    ; The GPIOCR register is still unlocked to allow configuration
    ; of the entire port, which is a safe practice.
    LDR    R1, =0x40006520         ; GPIO_PORTC_LOCK_R
    LDR    R0, =0x4C4F434B
    STR    R0, [R1]
    LDR    R1, =0x40006524         ; GPIO_PORTC_CR_R
    LDR    R0, [R1]
    ORR    R0, R0, #0xFF           ; commit all pins
    STR    R0, [R1]

; step 3: disable analog function
    LDR    R1, =GPIO_PORTC_AMSEL_R
    LDR    R0, [R1]
    BIC    R0, R0, #0xFF
    STR    R0, [R1]
; step 4: clear bits in PCTL (all pins as GPIO, not alternate function)
    LDR    R1, =GPIO_PORTC_PCTL_R
    MOV    R0, #0
    STR    R0, [R1]

; step 5: set direction register -> PC4, PC5 = inputs
    LDR    R1, =GPIO_PORTC_DIR_R
    LDR    R0, [R1]
    BIC    R0, R0, #0x30           ; clear bits 4 and 5 -> inputs
    STR    R0, [R1]

; step 6: clear bits in alternate function register
    LDR    R1, =GPIO_PORTC_AFSEL_R
    LDR    R0, [R1]
    BIC    R0, R0, #0x30           ; AFSEL = 0 -> regular GPIO
    STR    R0, [R1]

; step 7: enable digital port
    LDR    R1, =GPIO_PORTC_DEN_R
    LDR    R0, [R1]
    ORR    R0, R0, #0x30           ; digital enable on PC4, PC5
    STR    R0, [R1]

; step 8 (Aim 2 specific): enable internal pull-up resistors on PC4, PC5
    LDR    R1, =GPIO_PORTC_PUR_R
    LDR    R0, [R1]
    ORR    R0, R0, #0x30           ; pull-up on PC4, PC5
    STR    R0, [R1]

    BX    LR


    ALIGN

    END