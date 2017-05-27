	.data


	.text
main:
	li $v0,5 #lectura
	syscall
	move $t1,$v0 #mover lo que haya en $v0 a $t1
	
	li $v0,5
	syscall
	move $t2,$v0
	
	add $a0,$t1,$t2 #alojamos en $a0 porque es el que por defecto se uso para imprimir integer y lo queremos imprimir
	li $v0,1
	syscall
	
	li $v0,10
	syscall

