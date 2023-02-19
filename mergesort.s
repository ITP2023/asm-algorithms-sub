	AREA PROG, CODE, READONLY

ENTRY
N EQU 10 ; NUMBER OF ELEMENTS
SRAM_BASE EQU 0X1000200      ;intial stack address pointer
	LDRB SP, =SRAM_BASE       ;set the stack pointer to the value
	ADR R0, DATA             ; load the list
	MOV R1, #0               ; left
	MOV R2, #N               ; store total number of elements in R2
	MOV R12, #0 	         ; used for storing result of mod
	BL MERGESORT

	B STOP


MERGE
	PUSH {R1-R8, LR}                ; 
    MOV R5, R2                      ; set the indexes i and j for indexing left and right sub arrays respectively
ONE                                 ; begin to loop for the first time
    LDRB R6, [R0, R1]         ; load the element from the left section of the array
    LDRB R7, [R0, R5]      	; load element from the right section of the array
    CMP R6, R7
    BLE REPEATNORMALLY                        
    STRB R7, [R0, R1]         ; swap values
    ADD R8, R5, #1
    CMP R8, R3                       ; IF R8 > R3, that means we have reached the end of our second section of our array
    STRGT R6, [R0, R5, LSL #2]
    BGT REPEATNORMALLY               ; continue to repeat the loop normally
TWO                                 ; loop insert element 
    SUB R4, R8, #1
    LDRB R7, [R0, R8]          ; load value from right section
    CMP R6, R7                       ; value < then 
    STRLT R6, [R0, R4, LSL#2]       ; swap
    BLT REPEATNORMALLY
    STRB R7, [R0, R4]          ; get element form right section
    ADD R8, #1
    CMP R8, R3                       ; has the right section traversal reached it's end
    BLE TWO                          ; if yes then no loop
    SUB R8, #1
    STRB R6, [R0, R8]           ; store value from left to right section
REPEATNORMALLY
    ADD R1, #1
    CMP R1, R2                     
    BLT ONE

RETURNMERGE
	POP {R1-R8, PC}
	

MERGESORT
	PUSH {R3-R7, LR}
	CMP R2, #2              ; compare n with 2
	BLT RETURNIFSIZE1
	LSR R4, R2, #1          ; M = N/2
	AND R12, R2, #1         ; check if r2 is divisible by 2
	CMP R12, #0
	ADDNE R4, #1            ; IF R2 % 2 != 0: R4 = R4 + 1
	
	MOV R5, R1              ; save the number of elements
    MOV R6, R2              ; 
    MOV R7, R4              ; store number of elements of each sub array
    MOV R2, R4
    BL MERGESORT
	
    MOV R1, R7              ; restore number of element in each subarray
    MOV R2, R6              ; restore number of elements
    SUB R2, R1
    MOV R3, R5              ; restore first element
    ADD R1, R3              ; mid + 1
    BL MERGESORT 	        ; sort left section
	
    MOV R1, R5              ; gte numbe rof elements
    MOV R2, R7              ; restore number of elements of each sub array
    ADD R2, R1
    MOV R3, R6              ; move the nunber of elements of merged array into R3
    ADD R3, R1               
    SUB R3, #1              ; get the ast index
    BL MERGE
	
RETURNIFSIZE1
	POP {R3-R7, PC}
	

STOP 

	B STOP
	AREA PROG, DATA, READWRITE
DATA DCB 8, 29, 50, 81, 4, 23, 24, 30, 1, 7

	END