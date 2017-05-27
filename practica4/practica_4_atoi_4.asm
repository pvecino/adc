.data
str: .space 1024
ovrload: .asciiz "desborde"
line: .asciiz "\n"
	.text

main:
	la $a0, str
        la $a1, 1024
	li $v0,8
	syscall
	
	move $a1,$zero
	
	jal atoi_recur
	
	move $a0,$v0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
str_to_int:
	mul $v0,$v0,10
	mfhi $t5
	bnez $t5,overflow
	mflo $t4
	bltz $t4, overflow
	
	mul $t0,$a1,4
	add $t0,$t0,$a0
	lw $t0,0($t0)
	
	#move $a0,$t1  # aqui te has quedado tio dale caña tu puedes yo lo se, y tu lo sabes, aunque a los demas les importe una mierda
	#li $v0,1
	#syscall
	
	#li $v0,10
	#syscall
	
	subi $t0,$t0,48
	
	add $v0,$t0,$v0
	blez $v0,overflow
	jr $ra

atoi_recur:
	
	mul $t0,$a1,4
	add $t0,$t0,$a0
	lw $t0,0($t0)
	beq $t0,10, end
	
	subu $sp, $sp, 32 
	sw $ra, 20($sp)
	sw $fp, 16($sp) #creamos el marco de pila para cada llamada a fibbonacci_re
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp)
	sw $a1, 4($fp)
	
	jal str_to_int
	
	add $a1,$a1,1
	
	jal atoi_recur
	
end:
	move $a0,$v0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
overflow:
	la $a0,ovrload
	li $v0,4
	syscall
	
	li $v0,10
	syscall

