.text
	la $a1, uArray	
	addi $a1, $a0, 20	

	sort:
		beq $a0, $a1, done
		jal max
		lw $t0, uArray($a1)
		sw $t0, uArray($v0)
		sw $v1, uArray($a1)
		addi $a1, $a1, -4
	 	j sort
	done:
		addi $t0, $zero, 0 
	imprimir:
		beq $t0, 24, end
		lw $t6, uArray($t0)
		addi $t0, $t0, 4
		
		li $v0, 1
		move $a0, $t6
		syscall
		
		la $a0,coma
		li $v0,4
		syscall
		
		j imprimir
	end:
		li $v0, 10
		syscall
		
	max:
		lw $t0, uArray($a0)	
		addi $v0, $a0,0 	
		lw $v1, uArray($a0)
		addi $a0, $a0, 4	
	loop:
		lw $t3, uArray($a0)
		slt $t1, $t0, $t3 
		beq $t1, 1, swap	
	endloop:
		beq $a0, $a1, endfunct
		addi $a0, $a0, 4
		j loop
	endfunct:	
		addi $a0, $zero, 0
		jr $ra
			
	swap:
		lw $t0, uArray($a0)
		addi $v0, $zero,0
		addi $v0, $a0,0
		lw $v1, uArray($a0)
		j endloop
		
.data
	uArray: .word 3,5,8,9,6,7
	endl: .asciiz "\n"
	coma:    .asciiz ", "	






