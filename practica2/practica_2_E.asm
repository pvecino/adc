	.data
resultado:.asciiz "resultado: \0"  #etiqueta que guarda la direccion de memoria que hemos reservado
n1_b: .space 2
n2_b: .space 2

	.text
main:
	li $v0,5 #lectura
	syscall
	la n1_b,$v0($0)
	#sw $v0, n1_b($0)
	lw $t0, n1_b($0)
	
	li $v0,5
	syscall
	sw $v0, n2_b($0)
	lw $t1, n2_b($0)
	
	la $a0,resultado #coge la direccion de resultado y ponla en a0
	li $v0,4 #imprime de la direccion a0
	syscall
	
	add $v0,$t1,$t0
	li $v0,1
	syscall
	
	li $v0,10
	syscall
