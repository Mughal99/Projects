# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	flap: .asciiz "Press F to flap: "  
.text

ClearRegisters:

	li $v0, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0	
	lw $t0, displayAddress
	
	li $t8, 0
	
	li $v0, 4
	la $a0, flap
	syscall
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	li $t3, 0x62d9fc	# $t3 stores the blue colour code
	li $t7, 0xf576e8	# t7 stores the pink color
	li $t6, 0x0dba24	# t7 stores the green color
	
	sw $t1, 0($t0)	 # paint the first (top-left) unit red. 
	# addi $t0, $t0, 4
	# sw $t2, 0($t0)
	# addi $t0, $t0, 124
	# sw $t3, 0($t0)
	
	# li $v0, 10
	# syscall
	
	sw $t2, 4($t0)	 # paint the second unit on the first row green. Why $t0+4?
	sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128?
	
	
	# paint the whole screen 
	li $t4, 1095
	sw $t3, 0($t0)
	lw $t0, displayAddress	# $t0 stores the base address for display
	WHILE_sky:
		beqz $t4, DONE_sky   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 4
		sw $t3, 0($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_sky
	DONE_sky:
	
	
	# obstacles
	lw $t0, displayAddress
	sw $t6, 64($t0)
	sw $t6, 68($t0)
	sw $t6, 72($t0)
	sw $t6, 76($t0)
	
	li $t4, 31
	WHILE_OBSTACLE1:
		beqz $t4, DONE_OBSTACLE1   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 128
		sw $t6, 64($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_OBSTACLE1
	DONE_OBSTACLE1:

	li $t4, 31
	lw $t0, displayAddress
	WHILE_OBSTACLE2:
		beqz $t4, DONE_OBSTACLE2   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 128
		sw $t6, 68($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_OBSTACLE2
	DONE_OBSTACLE2:
	
	li $t4, 31
	lw $t0, displayAddress
	WHILE_OBSTACLE3:
		beqz $t4, DONE_OBSTACLE3   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 128
		sw $t6, 72($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_OBSTACLE3
	DONE_OBSTACLE3:
	
	li $t4, 31
	lw $t0, displayAddress
	WHILE_OBSTACLE4:
		beqz $t4, DONE_OBSTACLE4   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 128
		sw $t6, 76($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_OBSTACLE4
	DONE_OBSTACLE4:		
	
	lw $t0, displayAddress
	sw $t3, 1472($t0)
	sw $t3, 1476($t0)
	sw $t3, 1480($t0)
	sw $t3, 1484($t0)	
	
	sw $t3, 1600($t0)
	sw $t3, 1604($t0)
	sw $t3, 1608($t0)
	sw $t3, 1612($t0)
	
	sw $t3, 1728($t0)
	sw $t3, 1732($t0)
	sw $t3, 1736($t0)
	sw $t3, 1740($t0)
	
	sw $t3, 1856($t0)
	sw $t3, 1860($t0)
	sw $t3, 1864($t0)
	sw $t3, 1868($t0)
	
	sw $t3, 1984($t0)
	sw $t3, 1988($t0)
	sw $t3, 1992($t0)
	sw $t3, 1996($t0)	
	
	sw $t3, 2112($t0)
	sw $t3, 2116($t0)
	sw $t3, 2120($t0)
	sw $t3, 2124($t0)
	
	# bird
	
	IF:
		bne $t9, 102, ELSE
	THEN:
		sw $t7, 1928($t0)
		sw $t7, 2056($t0)
		sw $t7, 2184($t0)
		sw $t7, 2060($t0)
		sw $t7, 1936($t0)
		sw $t7, 2064($t0)
		sw $t7, 2192($t0)
		sw $t7, 2068($t0)
		
	ELSE:
	
		
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
	
