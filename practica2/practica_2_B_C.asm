	.data
resultado:.asciiz "resultado: "  #etiqueta que guarda la direccion de memoria que hemos reservado
	
	.text
main:
	li $v0,5 #lectura
	syscall
	move $t1,$v0 #mover lo que haya en $v0 a $t1
	
	li $v0,5
	syscall
	move $t2,$v0
	
	la $a0,resultado #coge la direccion de resultado y ponla en a0
	li $v0,4 #imprime de la direccion a0
	syscall
	
	add $a0,$t1,$t2 #alojamos en $a0 porque es el que por defecto se uso para imprimir integer y lo queremos imprimir
	li $v0,1 #imprime por defecto en #a0
	syscall
	
	li $v0,10
	syscall