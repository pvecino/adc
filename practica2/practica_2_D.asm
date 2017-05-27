	.data
resultado:.asciiz "resultado: \0"  #etiqueta que guarda la direccion de memoria que hemos reservado
n1_b: .byte 2
n2_b: .byte 3

n1_h: .half 3
n2_h: .half 4

n1_w: .word 5
n2_w: .word 6

	.text
main:
	la $a0,resultado #coge la direccion de resultado y ponla en a0
	li $v0,4 #imprime de la direccion a0
	
	lb $t1,n1_b
	lb $t2,n2_b
	add $a0,$t1,$t2
	
	li $v0,1 #imprime por defecto en #a0
	syscall
	
	lh $t1,n1_h
	lh $t2,n2_h
	add $a0,$t1,$t2
	
	li $v0,1 #imprime por defecto en #a0
	syscall
	
	lh $t1,n1_w
	lh $t2,n2_w
	add $a0,$t1,$t2
	
	li $v0,1 #imprime por defecto en #a0
	syscall
	
	li $v0,10
	syscall