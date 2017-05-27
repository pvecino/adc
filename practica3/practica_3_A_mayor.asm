	.data
big_1: .asciiz "El primero es mas grande\n"
big_2: .asciiz "El segundo es mas grande\n"

	.text
main:
	li $v0,5
	syscall
	move $t1,$v0
	
	li $v0,5
	syscall
	move $t2,$v0
	
	bgt $t1,$t2, First_bigger
	
	la $a0, big_2
 	li $v0, 4
	syscall 
	
	li $v0,10
	syscall
	
First_bigger:
	la $a0, big_1
 	li $v0, 4
	syscall 
	
	li $v0,10
	syscall
	
	
	