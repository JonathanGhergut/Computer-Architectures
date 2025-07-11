.data
listInput: .string "ADD(1) ~ ADD(2) ~ ADD(3)~ ADD(4)~ ADD(5)~ PRINT~REV~ PRINT"  
pHeadLinkedList: .word 0x100001F4
newLine: .string "\n"        
  
.text
    la s0, listInput
    lw a3, pHeadLinkedList
     
    add a0, s0, zero  
    li a4, 0    # a4 = nr of elements in the list
    li a7, 0    # a7 = nr of command in the list
    li s7, 30    # s7 = nr max of command
    
#--------------------------------------------------------------------------------------------------------------------------  
     
# ///
# CONTROL - INPUT  
# ///

controlInput:
    addi a7, a7, 1
    lb t0, 0(a0)
    
	li t1, 65		# ASCII of 'A'
	beq t0, t1, inputA

	li t1, 68		# ASCII of 'D'
	beq t0, t1, inputD
	
	li t1, 80		# ASCII of 'P'
	beq t0, t1, inputP

	li t1, 82		# ASCII of 'R'
	beq t0, t1, inputR
	
	li t1, 83		# ASCII of 'S'
	beq t0, t1, inputS
	
#--------------------------------------------------------------------------------------------------------------------------

# ///
# CHECK, IF EXISTS, ANOTHER OPERATION
# ///

checkAnotherOperation: 
    beq a7, s7, endAll
	lb t0, 0(a0)	# ASCII of next char
	li t1, 126    	# ASCII  '~'

	beq t0, t1, inputTilde
	beq t0, zero, endAll
	
	addi a0, a0, 1
	j checkAnotherOperation
	
inputTilde:	
	addi a0, a0, 1
	lb t0, 0(a0)	# ASCII of the char after '~'
	li t1, 32	# ASCII of ' '
	
	bne t0, t1, controlInput
	j inputTilde

#--------------------------------------------------------------------------------------------------------------------------  
    
# ///
# CONTROL OPERATION ADD
# ///

inputA:
	lb t0, 1(a0)
	li t1, 68		# ASCII of 'D'
	bne t0, t1, checkAnotherOperation

    lb t0, 2(a0)
    bne t0, t1, checkAnotherOperation
    
    lb t0, 3(a0)
    li t1, 40       # ASCII of 'open bracket'
    bne t0, t1, checkAnotherOperation
    
    lb a2, 4(a0)

    jal checkIfValidChar
 
    li t1, 2
    bne a1, t1, checkAnotherOperation    # a1 = OUTPUT of checkIfValidChar
    
    lb t0, 5(a0)
	li t1, 41        # ASCII of 'closed bracket'
	bne t0, t1, checkAnotherOperation
	
	addi a0, a0, 6	# address of the char after closed bracket
	
    jal verifyCorrectness
    jal add	
    j checkAnotherOperation
    
#--------------------------------------------------------------------------------------------------------------------------  

# ///
# CONTROL OPERATION DEL
# ///

inputD:
    lb t0, 1(a0)
    li t1, 69        # ASCII of 'E'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 2(a0)
    li t1, 76        # ASCII of 'L'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 3(a0)
    li t1, 40        # ASCII 'open bracket'
    bne t0, t1, checkAnotherOperation
    
    lb a2, 4(a0)

    jal checkIfValidChar
 
    li t1, 2
    bne a1, t1, checkAnotherOperation    # a1 = OUTPUT of checkIfValidChar
    
    lb t0, 5(a0)
    li t1, 41        # ASCII of 'closed bracket'
    
    addi a0, a0, 6	# address of the char after closed bracket

    jal verifyCorrectness
    jal del
    j checkAnotherOperation
      
#--------------------------------------------------------------------------------------------------------------------------  
   
# ///
# CONTROL OPERATION PRINT 
# ///

inputP:
    lb t0, 1(a0)
    li t1, 82    # ASCII of 'R'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 2(a0)
    li t1, 73    # ASCII of 'I'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 3(a0)
    li t1, 78    # ASCII of 'N'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 4(a0)
    li t1, 84    # ASCII of 'T'
    bne t0, t1, checkAnotherOperation
    
    addi a0, a0, 5
    
    jal verifyCorrectness
    
    addi sp, sp, -8
    sw a0, 0(sp)
    sw a7, 4(sp)
    
    jal print
    
    lw a7, 4(sp)
    lw a0, 0(sp)
    addi sp, sp, 8
    
    j checkAnotherOperation

#--------------------------------------------------------------------------------------------------------------------------  
     
# ///
# CONTROL OPERATION REV 
# ///

inputR:
    li t1, 69    # ASCII of 'E'
    lb t0, 1(a0)
    bne t0, t1, checkAnotherOperation
    
    li t1, 86    # ASCII of 'V'
    lb t0, 2(a0)
    bne t0, t1, checkAnotherOperation
    
    addi a0, a0, 3
    
    jal verifyCorrectness
    jal rev
    j checkAnotherOperation
  
#--------------------------------------------------------------------------------------------------------------------------  
      
# ///
# CONTROL OPERATION SORT, SDX, SSX 
# ///

inputS: 
    lb t0, 1(a0)
    li t1, 79    # ASCII of 'O'
    bne t0, t1, inputS_
    
    lb t0, 2(a0)
    li t1, 82    # ASCII of 'R'
    bne t0, t1, checkAnotherOperation
    
    lb t0, 3(a0)
    li t1, 84    # ASCII of 'T'
    bne t0, t1, checkAnotherOperation
    
    addi a0, a0, 4

    jal verifyCorrectness
    jal sort
    j checkAnotherOperation
    
inputS_:    
    li t1, 68    # ASCII of 'D'
    beq t0, t1, inputS_X
    
    li t1, 83     # ASCII of 'S'
    beq t0, t1, inputS_X
    
    j checkAnotherOperation
    
inputS_X:
    li t1, 88    # ASCII of 'X'
    lb t0, 2(a0)
    bne t1, t0, checkAnotherOperation
    
    lb s2, 1(a0)        
    addi a0, a0, 3
    jal verifyCorrectness
    
    li t1, 68
    beq s2, t1, jal_SDX
    
    jal ssx
    j checkAnotherOperation
    
jal_SDX:
    jal sdx
    j checkAnotherOperation
    
  
#--------------------------------------------------------------------------------------------------------------------------  
   
# /// 
# CHECK VALIDATION OF CHAR 
# ///

checkIfValidChar:
    li t2, 32
	blt a2, t2, invalidChar 
	
	li t2, 125
	bgt a2, t2, invalidChar 
	
	li a1, 2
	j endCheck
	
invalidChar:
	li a1, 1
	
endCheck:	
	jr ra

#--------------------------------------------------------------------------------------------------------------------------  
   
# /// 
# VERIFY CORRECTNESS OF '~' BETWEEN OPERATION IN listInput
# ///
 
verifyCorrectness:
    li t0, 32        # ASCII of ' '
    li t1, 126         # ASCII of '~'
    add t2, a0, zero    
    
verifyCorrectnessControl:
    lb t3, 0(t2)        # first char after the correct sintax of operation

    beq t3, t1, isCorrect
    beq t3, t0, incrementVerifyCorrectness
    beq t3, zero, isCorrect
    
    j checkAnotherOperation
  
incrementVerifyCorrectness:
    addi t2, t2, 1
    j verifyCorrectnessControl
    
isCorrect: 
    jr ra

#--------------------------------------------------------------------------------------------------------------------------

# ///
# FIND PHAEAD OF LINKED LIST
# ///

findPHeadLinkedList:
    add a1, a3, zero
    
loop_findPHeadLinkedList:
    lw t1, 1(a1)
    bne t1, a3, checkNextPAHEAD
    
    jr ra
    
checkNextPAHEAD:
    add a1, t1, zero
    j loop_findPHeadLinkedList

#--------------------------------------------------------------------------------------------------------------------------

# ///
# ADD
# ///

add:
    addi sp, sp, -4
    sw ra, 0(sp)
  
    beq a4, zero, firstAdd    # if elements in the list = 0, firstAdd
   
    jal findPHeadLinkedList    # a1 = OUTPUT of findPHeadLinkedList 
    addi t2, a1, 10   
            
findFreeAddress:
    lb t3, 0(t2)
    beq t3, zero, foundFreeAddress
    
    addi t2, t2, 10
    j findFreeAddress

foundFreeAddress:    
    sw t2, 1(a1)        # change last element's PHAEAD
    sb a2, 0(t2)        # a2 = element to ADD (new last Element)
    sw a3, 1(t2)        # set a2's PAHEAD = linkedListPHead
    
    j endAdd
    
firstAdd:
    sb a2, 0(a3)        # a2 = element to ADD
    sw a3, 1(a3)        # a3 = linkedListPHead

endAdd:
    addi a4, a4, 1    # nr.elements in the list ++
    
    lw ra, 0(sp)
    addi sp, sp, 4
    
	jr ra
 
#--------------------------------------------------------------------------------------------------------------------------

# ///
# DEL
# ///

del:
    addi sp, sp, -8
    sw ra, 4(sp)
    
	beq a4, zero, endDel	# if a4 (nr.elements in the list) = 0, the list is empty, then endDel
   
    li t0, 1	
	beq a4, t0, checkASCII	 # if a4 (nr.elements in the list) = 1, check ASCII of this char
	
	add t4, a3, zero		# t4 = scroll the list 

scrollList:
	lb t1, 0(t4)             # t1 = current element
	lw t2, 1(t4)             # t2 = PAHEAD of current element
	
	beq t1, a2, delete        # a2 = element to delete

	sw t4, 0(sp)            # save the address of current element for the next loop
    beq t2, a3, endDel        # if current PAHEAD = pHeadLinkedList, no element to delete
    
	add t4, t2, zero        
	j scrollList
	
delete:
	beq t4, a3, changePheadLinkedList    # if current address = pHeadLinkedList, change pHeadLinkedList
	
	lw t3, 0(sp)        # t3 = address of previous element
	sw t2, 1(t3)         # change the previous pointer
	
	add t4, t2, zero
	addi a4, a4, -1        # nr.elements in the list --

    beq t2, a3, endDel
	j scrollList
	
changePheadLinkedList:	
    jal findPHeadLinkedList    # a1 = address of last element

	add a3, t2, zero      # new pHeadLinkedList
    add t4, t2, zero
    
	sw a3, 1(a1)            # PAHEAD last element = new pHeadLinkedList
    addi a4, a4, -1         # nr.elements in the list --
	j scrollList

checkASCII: 
	lb t3, 0(a3)
	bne t3, a2, endDel
	
	addi a4, a4, -1         # nr.elements in the list --
	
endDel:
    lw ra, 4(sp)
	addi sp, sp, 8

	jr ra

#--------------------------------------------------------------------------------------------------------------------------

# /// 
# PRINT
# ///

print:
    beq a4, zero, endPrint
    add t0, a3, zero

print_loop:
    lb a0, 0(t0)
    lw t1, 1(t0)
 
    li a7, 11
    ecall
     
    beq t1, a3, endPrint
    add t0, zero, t1
    j print_loop
    
endPrint:
    la a0, newLine
    li a7, 4
    ecall
    
    jr ra  
      
#--------------------------------------------------------------------------------------------------------------------------

# /// 
# SORT
# ///
      
sort:
    addi sp, sp, 4
    sw ra, 0(sp)
   
    add a5, a3, zero        # a5 = address to scroll the list

    li a6, 0x10000bb8        # a6 = starting address to add element and its priority
    add t3, a6, zero         # t3 = address to scroll element from a6
    li t0, 0                 # t0 = count added element from a6        

setPriority:
    beq a4, t0, sortByPriorities    
    lb a1, 0(a5)            # a1 = element's ASCII value
    lw t1, 1(a5)            # t1 = PAHEAD of a1
       
    jal checkPriority
    
    sb a1, 0(t3)        # mem element's ASCII value 
    sb a2, 1(t3)         # mem element's priority
    
    addi t3, t3, 2 
    add a5, t1, zero    
    addi t0, t0, 1        
    
    j setPriority 
   
checkPriority:  
    li t2, 48    # ASCII of '0'
    blt a1, t2, symbol
   
    li t2, 65    # ASCII of 'A'
    blt a1, t2, checkSymb1
   
    li t2, 97    # ASCII of 'a'
    blt a1, t2, checkSymb2
  
    li t2, 123
    bge a1, t2, symbol
    
noSymbol: 
    li t2, 58    # ASCII of ':'
    blt a1, t2, number
 
noNumber:
    li t2, 97    # ASCII of 'a'
    bge a1, t2, lowercase
 
noLowercase:  
    j uppercase
   
checkSymb1:
    li t2, 58    # ASCII of ':'
    bge a1, t2, symbol
    
    j noSymbol
    
checkSymb2:
    li t2, 91    # ASCII of 'open square bracket'
    bge a1, t2, symbol    
    
    j noSymbol
         
symbol:
    li a2, 1
    jr ra

number:
    li a2, 2
    jr ra
    
lowercase:
    li a2, 3
    jr ra
    
uppercase:
    li a2, 4      
    jr ra
           
sortByPriorities:
    add t0, a6, zero        # t0 = address to scroll element from a6
    li t1, 1    # t1 = cont 
        
sorting:
    beq t1, a4, insertInList    
    lb a1, 0(t0)    # a1 = element's ASCII value
    lb a2, 1(t0)    # a2 = element's priority
    
    jal compareByPriorities
    
    sb a1, 0(t0)    
    sb a2, 1(t0)
    
    addi t0, t0, 2
    addi t1, t1, 1
    j sorting
    
compareByPriorities:
    addi t2, t0, 2

loop_compareByPr:    
    lb t3, 0(t2)    # t3 = compared element's ASCII value
    lb t4, 1(t2)    # t4 = compared element's priority
    
    beq t3, zero, endLoop_compareByPr    
    blt t4, a2, changeElement    # if priority of t3 < priority of a1, change element
    beq t4, a2, checkElementASCII     # if priority of t3 = priority of a1, check ASCII 
    
continueLoop_compareByPr:
    addi t2, t2, 2
    j loop_compareByPr
    
changeElement:
    sb a1, 0(t2)
    sb a2, 1(t2)
    
    sb t3, 0(t0)
    sb t4, 1(t0)
    
    add a1, t3, zero
    add a2, t4, zero
    
    j continueLoop_compareByPr
    
checkElementASCII:
    blt t3, a1, changeElement
    j continueLoop_compareByPr
    
endLoop_compareByPr:
    jr ra
    
insertInList: 
    add t0, a6, zero    # t0 = address of sorted elements and their priority
    add a5, a3, zero    # a5 = address of linkedList
    li t2, 0            # t2 = cont
    
loop_insertInList:
    beq t2, a4, endSort

    lb t1, 0(t0)
    sb t1, 0(a5)
    
    addi t0, t0, 2
    addi t2, t2, 1
    lw a5, 1(a5)
    
    j loop_insertInList
   
endSort:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra 

#--------------------------------------------------------------------------------------------------------------------------

# /// 
# SDX
# ///
 
sdx:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    jal findPHeadLinkedList   
  
    add a3, a1, zero
   
    lw ra, 0(sp)
    addi sp, sp, 4
    
    jr ra
        
#--------------------------------------------------------------------------------------------------------------------------

# /// 
# SSX
# ///
 
ssx:
    lw t0, 1(a3)
    add a3, t0, zero
   
    jr ra    
    
#--------------------------------------------------------------------------------------------------------------------------

# /// 
# REV
# ///
 
rev:
    add t0, sp, zero    # t0 = move in the stack byte by byte
    sub sp, sp, a4    # create in the stack a number equals to a4 new location
    
    li t1, 0        # nr of elements add in the stack
    add t2, a3, zero    # t2 = starting address of listInput
    
addInStack:
    beq t1, a4, completeRev
    lb t3, 0(t2)
    lw t4, 1(t2)     # PAHEAD to the next element
    
    sb t3, 0(t0)    # mem element in the stack
    
    add t2, t4, zero    # t2 = next element's address
    addi t0, t0, -1    # new location in the stack
    addi t1, t1, 1    # nr. elements add in the stack ++
    
    j addInStack
    
completeRev:
    add t1, a3, zero
    addi t0, t0, 1        # the line 659 of program decrement one more
    
    li t2, 0    # t2 = nr. elements reversed
    
loopRev:
    beq t2, a4, endRev
    lw t3, 1(t1)
    
    lb t4, 0(t0)        # element in the stack
    sb t4, 0(t1)        # saved in the list
    
    add t1, t3, zero    
    addi t0, t0, 1    
    addi t2, t2, 1    # nr.elements reversed ++

    j loopRev
    
endRev:
    add sp, sp, a4        # restore sp
    
    jr ra
           
#--------------------------------------------------------------------------------------------------------------------------

endAll:
    li a7, 10
    ecall