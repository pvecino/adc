##JUNIO
## FIFO = LISTA/COLA
## Registros a--> introducir en la lista
## Registro v --> syscall y para sacar de la lista
## Registros t --> variables fuera de la lista
## Registros s --> variables dentro de la lista
## CUIDADO: en las syscall primero v0 y luego a0
##-----------------------------
## INstrucciones practica:
## Inserto numeros como FIFO hasta que inserte 
## un 0, que me pedirá un numero a borrar.
## lo borro y tengo que imprimirlo en el orden
## inverso en el que fueron agregados LIFO
##----------------------------
## s0 PRIMER NODO
## s1 ULTIMO NODO

.data
	new_line: .asciiz "\n"
	msj_inicio: .asciiz "Introduzca el primer numero (0 para borrar numero):"
	msj_next: .asciiz "Introduzca el siguente numero (0 para borrar numero):"
	msj_remove: .asciiz "Introduzca el numero a borrar:"
.text
	
main:
	li $v0,4	##syscall = 4 imprimir string
	la $a0,msj_inicio
	syscall
	
	li $v0,5	##syscall = 5 pedir integer
	syscall
	
	move $a0,$s1	##Preparo la direccion de memoria del ULTIMO
	move $a1,$v0	##Preparo el valor introducido de v0 a a1
	
	## lo uso solo una vez, la parte de arriba, solo para añadir el primer numero de la lista
	
	jal insert	##salto incondicional 1 
		
	move $s0,$v0 	##actualizo la direccion de memoria del PRIMERO de la lista (no varia)
	move $s1,$v0 	##actualizo la direccion de memoria del ULTIMO de la lista (varia)
	
next_number:		##con este pido los demas numeros

	li $v0,4	## syscall = 4 imprimir string
	la $a0,msj_next
	syscall
	
	li $v0,5	##syscall = 5 pedir integer
	syscall
	
	beqz $v0,option	##si es 0 me voy a opciones
	
	move $a0,$s1	##Preparo la direccion de memoria del ULTIMO
	move $a1,$v0	##Preparo el valor introducido de v0 a a1
	
	jal insert	## salto para guardar en lista
	
	move $s1,$v0 	#actualizo la ultima direccion de memoria del ULTIMO elemento de la lista
	
	b next_number	## sigo pidiendo numeros hasta qu introduce un 0
option:	
	
	li $v0,4	## syscall = 4 print string
	la $a0,msj_remove
	syscall
	
	li $v0,5	##syscall = 5 pedir numero
	syscall
	
	
	move $a0,$s0	##preparo la PRIMERA direccion de memoria de la lista
	move $a1,$v0	##preparo el valor a borrar en a1
	
	jal remove	
							
	move $a0,$s0  	##actualizp la PRIMERA direccion de memmoria de la lista
	
	jal print
		
exit:
	li $v0,10	##syscall = 10 cierro programa
	syscall
	
##Registros usados
## Registros IN
##  a0 = direccion de memoria del nodo
##  a1 = valor a ingresar
## Registros OUT
##  v0 = direccion de memoria del nodo creado
insert:
	
	subi $sp,$sp,32		##creo marco de lista, me voy a mover con fp
	sw $ra,0($sp)
	sw $fp,4($sp)
	addiu $fp,$sp,28
	
	sw $a0,0($fp) 		##guardoen fp la direccion de memoria del ultimo
	
	li $v0,9		##syscall = 9 allocate heap memory
	li $a0,8		##8 number of bytes to allocate
	syscall 		## v0 contains address of allocate
	
	lw $a0,0($fp) 		##restauro la lista
	sw $a1,0($v0)		##pongo en v0 el valor introducido
	sw $zero,4($v0)		##inicializo a 0 el valor donde ira la direccion de memoria

if_zero:			
	beqz $a0,endif_zero	
	sw $v0,4($a0) 		##guardo el el valor de la ULTIMA direccion de memoria
				##la unica vez que por aqui no paso es la 1º, porque a0=0
				##no hace guardar dicho valor, porque ya lo guarda s0
endif_zero:	
		
	lw $ra,0($sp)		##borro la lista, porque solo me ha 
	lw $fp,4($sp)		##interesado la direccion de memoria
	addiu $sp,$sp,32
	jr $ra			##jr se va a salto incondicional 1 
	
##Registros usados
## Registros IN
##  a0 = direccion de memoria del PRIMER elemento de la lista
##  a1 = Valor a borrar
## Registros OUT
## v0 = direccion de memoria del elemento ELIMINADO
## Punteros
##  a0 = puntero a la direccion de memoria ANTERIOR
##  t0 = puntero a la direccion de memoria SIGUIENTE
remove:
	subi $sp,$sp,32		##creo marco de lista, me voy a mover con fp
	sw $ra,0($sp)
	sw $fp,4($sp)
	addiu $fp,$sp,28
		
	lw $t0,4($a0)		##puntero apuntando a la siguente direccion de memoria
	
search:
	beqz $t0,end_search	## si t0 es 0 significa que he llegado al final de la lista
	lw $t1,0($t0) 		##guardo en t1 el valor del elemento al que corresponda la direccion guardada
				## en t0
found:	
	bne $t1,$a1,not_found	##hago la comprobacion de si el valor que he cogido de la lista es el
				##mismo que quiero borrar, SOLO SALTO SI NO SON IGUALES
	##paso por aqui porque a1 = t1
	lw $t2,4($t0)		##guardo en t2 la direccion de memoria SIGUIENTE
	sw $t2,4($a0)		
	b end_search

not_found:	
	move $a0,$t0 		##avanzo el puntero t0
	lw $t0,4($t0)		##puntero apuntando a la siguente direccion de memoria
	b search			
end_search:	
	
	move $v0,$t0 		##guardo en v0 la direccion de memoria del nodo A ELIMINAR
	
	lw $ra,0($sp)		##elimino lista
	lw $fp,4($sp)
	addiu $sp,$sp,32
	jr $ra			##vuelvo al remove de la linea 72
	
##Registros usados
## Registros IN
##  a0 = direccion de memoria del PRIMER elemento de la lista
## Punteros
##  a0 = puntero a la direccion de memoria ANTERIOR
##  t0 = puntero a la direccion de memoria SIGUIENTE	
print:
	subi $sp,$sp,32		##creo marco de lista, me voy a mover con fp
	sw $ra,0($sp)
	sw $fp,4($sp)
	addiu $fp,$sp,28
	
if:
	beqz $a0,else		##cuando a0 = 0 significa que he llegado al final de la lista
then:
	sw $a0,0($fp)		##guardo la ULTIMA direccion de memoria
	lw $a0,4($a0)		##avanzo en la lista
	
	jal print
	
	lw $a0,0($fp)		##Restauro la lista
	b endif
else:
	b end_print
endif:

	sw $a0,0($fp) 		##gurado en la fp la direccion de memoria ULTIMA
	
	li $v0,1		##syscall = 1 print integer
	lw $a0,0($a0)		##guardo el valor imprimir
	syscall
	
	li $v0,4		##syscall = 4 print string
	la $a0, new_line	
	syscall
	
	lw $a0,0($fp)		##Restauro la lista
		
end_print:	
	lw $ra,0($sp)		##cierro la lista
	lw $fp,4($sp)
	addiu $sp,$sp,32
	jr $ra			##vuelvo a la linea 172 hasta que a0 = 0 y luego voy a la linea 76
