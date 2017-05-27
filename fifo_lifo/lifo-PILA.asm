##DIciembre 2015
## LIFO  = LISTA
## Registros a--> introducir en la pila
## Registro v --> syscall y para sacar de la pila
## Registros t --> variables fuera de la pila
## Registros s --> variables dentro de la pila
##CUIDADO!!!!-->poner primero v0 despues a0 en las syscall
##-----------------------------
## INstrucciones practica:
## Inserto numeros como LIFO, hasta que inserte 
## un 0, que me pedirá un numero a borrar.
## lo borro y tengo que imprimirlo en el orden
## inverso en el que fueron agregados LIFO
##----------------------------
## s0 cima de la pila// direccion de memoria del ULTIMO 

.data
	new_line: .asciiz "\n"
	msj_inicio: .asciiz "Introduzca un numero (0 para borrar numero):"
	msj_remove: .asciiz "Introduzca el numero a borrar:"
.text
main:	
	li $s0, 0 	##inicializo el el registro que voy a usar 
			##sera la direccion de memoria del ULTIMO 

##Registros usados
## Registros IN
##  a0 = direccion del ULTIMO nodo
##  a1 = valor a introducir en la pila
## Registros OUT
##  v0 = direccion de memoria del nodo creado
push_loop:
	li $v0 4		## syscall = 4 imprimir string
	la $a0 msj_inicio 
	syscall
	
	li $v0 5		## syscall = 5 pedir numero
	syscall
	
	beq $v0 0 end_loop	## si inserto un 0 paso a remove
	
	move $a0 $s0		##Preparo a0 con la direccion ULTIMA de memoria
	move $a1 $v0		##Preparo a1 con el valor introducido por teclado
	
	jal push
	
	move $s0 $v0 		##Actualizo dir. memoria ULTIMA
	
	b push_loop		##Pido N numeros como sea posible
end_loop:
	
	li $v0 4
	la $a0 msj_remove	## syscall = 4 imprimir un string
	syscall
	
	li $v0 5		## pedir un numero
	syscall
	
	move $a0 $s0		##Preparo a0 con la ULTIMA direccion de memoria
	move $a1 $v0		##Preparo a1 con el valor a borrar
	
	jal remove 
	
	move $a0 $s0		## Actualizo la ULTIMA direccion de memoria

	jal print
	
exit:
	li $v0 10		##syscall = 10 cierro programa
	syscall
		
push:
	subu $sp $sp 32		## marco de pila...me muevo con fp
	addiu $fp $sp 28
	sw $fp 4($sp)
	sw $ra 0($sp)

	sw $a0 0($fp)		##guardo la dir. de memoria del ULTIMO en 0 fp
	sw $a1 -4($fp) 		## gurado el valor a introducir en -4fp
	
body_push:
	li $v0,9		##syscall = 9 allocate heap memory
	li $a0,8		##8 number of bytes to allocate
	syscall 		## v0 contains address of allocate
	
	lw $t0 0($fp)		##empiezo a sacar los valores del marco de pila
	sw $t0 4($v0)		
	sw $a1 0($v0) 		##Creo el nuevo nodo con los parámetros que me han pasado.
	
return_push:
	lw $fp 4($sp)		##Recupero el contexto de la pila vuelvo a la linea 45
	lw $ra 0($sp)
	addiu $sp $sp 32
	jr $ra 
##Registros usados
## Registros IN
##  a0 = direccion de memoria del ULTIMO elemento de la pila
##  a1 = Valor a borrar
## Registros OUT
## v0 = direccion de memoria del elemento ELIMINADO
remove:
	subu $sp $sp 32		##Creo mi marco de pila, me muevo con fp
	addiu $fp $sp 28
	sw $fp 4($sp)
	sw $ra 0($sp)
	
	sw $a0 0($fp)		##Guardo mi contexto en la pila
	sw $a1 -4($fp) 
		
	move $t0 $a0		
	
	li $v0 0		##Inicializo v0
loop_remove:
	lw $t2 4($t0)		##cargo la siguiente direccion de memoria
	beq $t2 0 return_remove	##Evaluo si he legado al final de la pila
	
	lw $t3 0($t2) 		##Avanzo al siguiente nodo
		
	beq $t3 $a1 delete_remove
	
	move $t0 $t2
	b loop_remove 		##Evaluo si es el nodo que tengo que borrar
		
delete_remove:
	move $v0 $t2		##Borro el nodo y devuelvo su direccion de momeria
	lw $t2 4($t2)
	sw $t2 4($t0)
		
return_remove:
	lw $fp 4($sp)		##Recupero el contexto de la pila y retorno linea 62
	lw $ra 0($sp)
	addiu $sp $sp 32
	jr $ra 
		
##Registros usados
## Registros IN
##  a0 = direccion de memoria del ULTIMO elemento de la pila
## Punteros
##  a0 = puntero a la direccion de memoria ANTERIOR
##  t0 = puntero a la direccion de memoria SIGUIENTE		
print:
	subu $sp $sp 32		##Creo mi marco de pila, me muevo con fp
	addiu $fp $sp 28
	sw $fp 4($sp)
	sw $ra 0($sp)
	
	sw $a0 0($fp) 		## guardo la direccion de memoria del ULTIMO nodo en fp
		
	lw $a0 4($a0)		##avanzo a la siguiente direccion de memoria
	
	beq $a0 0 write		##evaluo si he llegado al final de la pila
	jal print
	

		
write:
	lw $fp 4($sp)		
	
	lw $a0 0($fp)		##recupero valor a imprimir
	lw $a0 0($a0)
	
	li $v0 1 		## syscall = 1 imprimir numero
	syscall
	
	li $v0 4
	la $a0 new_line		##syscall = 4 imprimo string
	syscall
	
return_print:
	lw $fp 4($sp)		##Recupero el contexto de la pila y retorno linea 153 y luego 66
	lw $ra 0($sp)
	addiu $sp $sp 32
	jr $ra
