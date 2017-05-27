	.data
is_zero: .asciiz "El numero es igual a cero"
non_zero: .asciiz "No es cero"
ending: .asciiz "Hemos llegado a A x B"
line_jump: .asciiz "\n"
	
index_bucle: .word 0
	.text
main:

	li $v0,5
	syscall
	move $t1,$v0
	
	li $v0,5
	syscall
	move $t2,$v0
	
	beqz $t1, equal_zero
	beqz $t2, equal_zero
	
	lw $t3,index_bucle

bucle:
	la $a0, line_jump
	li $v0,4
	syscall
	
	mult $t1, $t2
	mflo $t0
	
	mult $t1,$t3
	mflo $a0
	li $v0,1
	syscall
	
	beq $t3, $t2, end
	
	addi $t3,$t3,1
	jal bucle
	
equal_zero:
	la $a0, is_zero
	li $v0,4
	syscall

	li $v0,10
	syscall
	
end:
	la $a0, line_jump
	li $v0,4
	syscall
	
	la $a0, ending
	li $v0,4
	syscall
	
	li $v0, 10
	syscall
