	THUMB

GPIO_PORTC_DATA_R   EQU 0x400063FC   ; GPIO Data register

; **
; ** CODE AREA IN ROM **
; **
    AREA    SA2CodeArea, CODE, READONLY, ALIGN=2

    EXPORT    specificAim2_buttons


specificAim2_buttons
    LDR    R4, =GPIO_PORTC_DATA_R  ; R4 = &GPIO_PORTC_DATA_R
    MOV    R5, #0                  ; R5 will hold the "shadow" state

Aim2_Loop
    ; read the current state of Port C data register
    LDR    R6, [R4]
    AND    R6, R6, #0x30           ; mask for PC5 and PC4 bits

    ; if the state has changed, update the shadow register
    CMP    R6, R5
    BEQ    Aim2_Loop               ; if same, no change -> keep looping
    MOV    R5, R6                  ; update shadow state

    ; optional: mirror the input state to an output port for easy observation
    ; for example, you could write R5 to Port B data register here

    B    Aim2_Loop               ; repeat forever


    ALIGN
    END
