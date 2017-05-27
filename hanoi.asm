#EXAMEN DICIEMBRE 2013 Y JUNIO 2014
##TORRE DE HANOI
##
##
##
	.data
	
begin: .asciiz "Introduce el numero de discos (1-8): "
msj_move: .asciiz "mover disco "
from: .asciiz" desde el palo "
until: .asciiz " hasta el palo "
space: .asciiz "\n"
	.text
	
main:
	li $v0 4		##syscall = 4 imprimir un string
	la $a0 begin
	syscall

	
	li $v0 5		## syscall = 5 recoger integer
	syscall

	move $a0, $v0 		## CONVENIO: mover de v0 a a0 lo recogido

	li $a1, 1 		## Palo de inicio
	li $a2, 2 		##Palo destino
	li $a3, 3 		##Palo comodin

	jal hanoi

	b hanoi_end
hanoi:
	bnez $a0, hanoi_recursive
	jr $ra

hanoi_recursive:
			
	subu $sp, $sp, 32	##Marco de pila
	sw $ra , 20 ($sp)
	sw $fp, 16($sp)
	addiu $fp, $sp, 28


	sw $a0, 0($fp)		## cargo en la pila a0
	sw $a1, 4($fp)		## cargo en la pila a0
	sw $a2, 8($fp)		## cargo en la pila a0
	sw $a3, 12($fp)		## cargo en la pila a0

	lw $a0, 0($fp)		## puntero vuelve a a0

#aqui es donde empieza hanoi: saco discos del 1 y los coloco en el 2 y 3
	sub $a0, $a0, 1 	##muevo un disco
	lw $a1, 4($fp) 		## del palo 1 no coloco ningun disco, solo los saco
	lw $a2, 12($fp)		##cargo lo que hay en el palo 3, en el 2
	lw $a3, 8($fp)		## cargo lo que hay en el palo 2, en el 3
	jal hanoi

#ya he terminado la primera iteracion: cierro variables
	lw $a1, 4($fp)
	lw $a2, 8($fp)
	lw $a3, 12($fp)

##empiezo a imprimir

	li $v0, 4 		##syscall = 4 imprimir string
	la $a0, msj_move 
	syscall
#recupero el numero de disco de $a0

	li $v0, 1 		##syscall = 1 imprimir integer
	lw $a0, 0($fp)
	syscall

	la $a0, from 
	li $v0, 4 		##syscall = 4 imprimir string
	syscall

# tengo que mover lo que hay en a1, depende de la funcion hanoi
	li $v0, 1 		## syscall = 1 imprimir integer
	move $a0, $a1
	syscall

	li $v0, 4 		##syscall = 4 imprimir string
	la $a0, until
	syscall
# tengo que mover lo que hay en a1, depende de la funcion hanoi

	li $v0, 1 		## syscall = 1 imprimir integer
	move $a0, $a2
	syscall


	li $v0, 4 		##syscall = 4 imprimir string
	la $a0, space
	syscall

#vuelvo a mover entre palos, saco los discos del 1 y 3 y los coloco en el 2
	lw $a0, 0($fp)
	sub $a0, $a0, 1
	lw $a1, 12($fp)		## cargo lo que hay en palo 3, en el palo 1
	lw $a2, 8($fp)		## no introduzco ningun disco en el palo 2, solo saco
	lw $a3, 4($fp)		##cargo en el palo 1, lo que hay en el palo 1
	jal hanoi

#CIERRRO PILA
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	addiu $sp, $sp, 32
	jr $ra

hanoi_end:
	li $v0,10 		##syscall = 10 cierro programa
	syscall	
