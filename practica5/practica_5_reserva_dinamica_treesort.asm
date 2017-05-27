	.data
msg: .asciiz "Introduzca numero:"
nodo_tree: .byte 12 # un int; y 2 direcciones de memoria --> 4+4+4=12
error: .asciiz "no queda memoria"
	.text
main:
	li $v0,5
	syscall  #Leo el numero 
	move $a0,$v0
	
	jal tree_node_create
	
	move $s0,$v0
	
in_loop:
	li $v0,5
	syscall
	
	beqz $v0, end_in
	
	move $a0,$v0
	jal tree_insert
	
	b in_loop

end_in:
	move $a0,$s0
	jal tree_print
	
	li $v0 10
	syscall
	
error_memory:
	la $a0,error
	li $v0,4
	syscall
	
	li $v0 10
	syscall

tree_node_create:
	subu $sp, $sp, 32 
	sw $ra, 20($sp)
	sw $fp, 16($sp) #creamos el marco de pila para cada llamada
	addiu $fp, $sp, 28
	
	sw $a0, 0($fp) 
	
	li $a0,12
	li $v0,9
	syscall
	
	beqz $v0,error_memory
	
	#inicializacion de valores
	lw $t0, 0($fp)		
	sw $t0,0($v0)
	sw $zero,4($v0)
	sw $zero,8($v0)
	
	addiu $sp, $sp, 32 # liberar memoria
	
	jr $ra

tree_insert:
	subu $sp, $sp, 32 
	sw $ra, 20($sp)
	sw $fp, 16($sp) #creamos el marco de pila para cada llamada
	addiu $fp, $sp, 28
	
	jal tree_node_create
	move $s1,$v0
	
	lw $t0,0($s0)

	lw $t1,0($s1)
	
	move $t2, $s0
	bge $t0,$t1,tree_insert_right
	
tree_insert_left:
	move $a1,$t2
	lw $t2,4($t2)
	bgtz $t2,tree_insert_left
	sw $s1,4($a1)
	
	lw $ra, 20($sp)
	addiu $sp, $sp, 32 # liberar memoria
	
	jr $ra

tree_insert_right:
	move $a1,$t2
	lw $t2,4($t2)
	bgtz $t2,tree_insert_left
	sw $s1,8($a1)
	
	lw $ra, 20($sp)
	addiu $sp, $sp, 32 # liberar memoria
	
	jr $ra
	
tree_print:
	beqz $a0, tree_return
	
	subu $sp, $sp, 32 
	sw $ra, 20($sp)
	sw $fp, 16($sp) #creamos el marco de pila para cada llamada
	addiu $fp, $sp, 28
	
	sw $a0,0($fp)
	
	lw $a0,0($fp)
	lw $a0,4($a0)
	jal tree_print
	lw $a0,0($fp)
	lw $a0,8($a0)
	jal tree_print
	
	lw $a0, 0($fp)
	lw $a0,0($a0)
	li $v0,1
	syscall
	
	lw $ra, 20($sp)
	lw $fp,16($sp)
	
	addiu $sp, $sp, 32
	jr $ra

tree_return:
	jr $ra
