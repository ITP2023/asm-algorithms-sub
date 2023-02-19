      AREA PROG2, CODE, READONLY 
ENTRY
SRAM_BASE EQU 0x00010200
ITEM EQU 5
N EQU 15
      LDR SP, =SRAM_BASE
      LDR R0, =DATA
      LDR R1, =SORTED
      MOV R2, #0 ;  I = 0
      MOV R3, #0 ; J = 0
      MOV R4, #4 ;  NUMBER OF LEVELS
      MOV R5, #1 ; NUMBER OF ELEMENTS IN THE NEXT LEVEL
      MOV R6, #0 ; TMP VAR FOR HOLDING THE ELEMENT OF THE ARRAY
      MOV R7, #100 ; CURRENT FOUND MIN VALUE,  = MIN()
      MOV R8, #0 ; K = 0
      MOV R9, #100 ; -> TMP PLACE FOR HOLDING THE VALUE 100
      MOV R10, #0 ; -> USED FOR STORING 2^n - 1
      MOV R11, #0 ; -> USED FOR STORING THE ADDRESS OF MINIMUM
      BL  MINIMUM ; Branch off to the minimum function
      B STOP

LOOP1

	  STRB R7, [R1, R8] ; Store the smallest value found by our minimum function in R7
	  STRB R9, [R11] ; Store the value of R9(100) in the address of the smallest value found in minimum
	  ADD R8, R8, #1 ; Increment K 
      CMP R8, #N ; Compare R8 to the number of elements
	  
	  MOV R5, #1 ; Reassign R5 to 1 for the next traversal of the tree
	  MOV R3, #0 ; Reassign R3 to 0 for the next traversal of the tree
	  MOV R2, #0 ; Reassign R2 to 0 for the next traversal of the tree
	  MOV R7, #100 ; Reassign R7 to 100 for the next traversal of the tree
	  
	  BEQ STOP ; Once K is equal to N
	  
      BL MINIMUM ; Branch to minimum to find the smallest value in the tree
 
       
MINIMUM
      LSL R5, R5, R2 ; Number of element in the next level + 1 would be 2^n which would be stored in R5
      BL LEVEL ; Branch off to each level in the binary tree
      LSL R2, R2, #1
      ADD R2, R2, #1 ; LSL and ADD to R2 increases the total number of elements for every level
      CMP R2, R4 ; Compare R2 and R4
      BLE MINIMUM ; Branches to minimum if not every level has been traversed
      BGE LOOP1 ; Once all elements have been traversed branch to loop1
LEVEL
      
      LDRB R6, [R0, R3] ; Stores the value being traversed in the level in R6
      CMP R6, R7 ; Compare R6 and R7
      MOVLT R7, R6 ; If R6 is less than R7 then store R6 to R7, to become the new minimum value
      
      ADDLT R11, R3, R0 ; If R6 is less than R7 then store the address of the value in the tree, R3 would be the index in the tree
      
      ADD R3, R3, #1 ; Increment J by 1
      SUB R10, R5, #1 ; Number of element in the level would be R10. which is 2^n - 1 so R5 - 1
      CMP R3, R10 ; Compare R3 and R10
      BLT LEVEL ; Loop until we traverse all the elements in the level
      BX LR ; 

STOP
      B STOP
      AREA PROG2, DATA, READWRITE
DATA DCB 10, 5, 30, 78, 2, 19, 11, 23, 48, 79, 1, 14, 9, 41, 31
; (10), (5, 30), (78, 2, 19, 11), (23, 48, 79, 1, 14, 9, 41, 31)

SORTED DCB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      END
