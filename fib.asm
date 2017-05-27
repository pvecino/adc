## Registros a--> introducir en la pila
## Registro v --> syscall y para sacar de la pila
## Registros t --> variables fuera de la pila
## Registros s --> variables dentro de la pila
##-----------------------------
## INstrucciones practica:
## Fibonacci Recursivo
##----------------------------
	.data
msg_begin: .asciiz "Introduce un numero: "
msg_last: .asciiz "Fibonacci de "
msg_last_1: .asciiz ": "
	.text
##Registros usados:
##  $v0 syscall y valor de retorno
##  $a0 syscall
##  v1 = resultado de fibonnaci
main:

	li $v0, 4 		## syscall = 4 imprimir string
	la $a0, msg_begin
	syscall 

	li $v0, 5		## syscall = 5 pedir integer
	syscall

	move $s1, $v0		## muevo el valor introducido a s1(variable global)
	
	li $s0, 2		## pongo en s0 = 2 para fib(n-2)(varuable global)
	
	move $a0, $v0		## pongo en a0, el valor introducido.
	
	jal fib
	
	move $v1, $v0 		##muevo el resultado a v0

	li $v0, 4 		##syscall = 4 imprimir string
	la $a0, msg_last
	syscall 
	
	li $v0, 1 		##syscall = 1 imprimir integer
	move $a0, $s1		## muevo a a0 el numero inical que metí
	syscall
	
	li $v0, 4		##syscall = 4 inprimir string
	la $a0, msg_last_1
	syscall	
	
	li $v0, 1 		##syscall = 1 print integer
	move $a0, $v1		##muevo el resultado a v1 para imprimirlo
	syscall 	
	
	li $v0, 10 		##syscall = 10 exit
	syscall 
##Registros usados:
##  $v0 parametro n
##  $a0 numero inicial
##  $v1 parametor n
##  
fib:
	subu $sp, $sp, 32	##inicio marco de pila
	sw $ra, 16($sp)		## Asignar RA
	sw $fp, 12($sp)		## asignar FP
	addiu $fp, $sp, 28	## asigno SP
	
	sw $a0, 0($fp)
	
	bgt $a0, $s0, fib_recurse	## si n<2, entonces retorno a 1
	li $v0, 1			## sin hacer marco de pila
	
	b return		##Voy a cerrar pila
fib_recurse:
	lw $v1, 0($fp)		## preservo n
	subu $v0, $v1, 1	## v0 = fib(n-1)
	move $a0, $v0		## a0 = v0
	jal fib
	
	sw $v0, 20($sp)		
	lw $v1, 0($fp)		
	
	subu $v0, $v1, 2
	move $a0, $v0		 
	jal fib
	
	sw $v0, 24($sp)		
	lw $t0, -4($fp)		
	lw $t1, -8($fp)		
	add $v0, $t1, $t0	## $v0 = fib (n - 1) + fib (n - 2)
return:
	
	lw $ra, 16($sp)		## restauro RA
	lw $fp, 12($sp)		## restauro FP
	addiu $sp, $sp, 32	## restauro SP
	jr $ra			## vuelvo a línea
