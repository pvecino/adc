##ARRAY
## Registros a--> introducir en la lista
## Registro v --> syscall y para sacar de la lista
## Registros t --> variables fuera de la lista
## Registros s --> variables dentro de la lista
## CUIDADO: en las syscall primero v0 y luego a0
##--------------------------
##INstrucciones de la practica:
##BUsqueda de un valor en un array
##el array de enteros se crea e inicializada en tiempo de compilación.
## El main debe buscar la posición de uno de los valores del array (buscarDesde) 
## y, después, debe intercambiar la posición del valor buscado por posición+1.
##después de intercambiar las posiciones, main invoca a imprimir para
## imprimir el array.
##----------------------------
## s0 contendrá el array
## t0 contará las posiciones
	.data

array: .word 1:10
msg_inicio: .asciiz "Introduzca 10 valores: "
msg_search: .asciiz "\nIntroduzca valor que quiere buscar:  "
msg_print: .asciiz "Valores array: \n"
msg_notfound: .asciiz "Tengo el numero\n"
msg_found: .asciiz " No tengo el numero\n"
stick: .asciiz "|"

	.text
main:
	la $s0 array		##cargo en el array en s0
	li $t0 0 		##contador de posicion
initialize:
	beq $t0 10 buscarDesde	##cuando llegue a 10 

	li $v0 4		##syscall = 4 imprimir sting
	la $a0 msg_inicio
	syscall 
	
	li $v0 5		## pedir numero
	syscall 
	
	move $a0 $s0 		## Puntero al inicio del array
	move $a1 $v0 		## Entero que quiero meter
	move $a2 $t0 		## Posicion del contandor del array
	
	jal insert
	
	addi $t0 $t0 1		## SUmo 1 a la posicion
	
	b initialize			## pido numeros hasta que llego a 10
##Registros usados:
##IN
## a0 = array
## a1 = valor a introducir
## a2 = posicion desde la que comienza a contar
insert:
	
	mul  $a2 $a2 4 		##avanzo a lo largo del array (4bytes*a2)
	add  $a0 $a0 $a2	##creo otra "celda" en el array en la posicion (4a2)
	sw $a1 0($a0)		##guardo el valor en la "celda"
	
	jr $ra			## retorno a la linea 46

##Registros usados:
##IN
## a0 = array
## a1 = valor a remplazar
## a2 = posicion por la que empieza a contar
## a3 = tamaño de array
##OUT
## v0 = posicion del numero
##-------------------
##intercambia el contenido de las
## posiciones “i” y “j” del array (cuya dirección se pasa como argumento).
replace:
	subu $sp $sp 32 	##Creo marco de pila
	sw $ra 0($sp)
	sw $fp 4($sp)
	addiu $fp $sp 28
	
	sw $a0 0($fp)		##guardo array en pila
	sw $a1 -4($fp)		##guardo valor a remplazar en pila
	sw $a2 -8($fp)		##guardo posicion en pila
	sw $a3 -12($fp)		##guardo tamaño del array en pila
	

	beq $a3 $a2 notfound 	## Si la posicion del array es una menos que 
				## el tamaño es que el numero no esta
	
	mul  $a2 $a2 4 		## Desplazamiento memoria
	add  $a0 $a0 $a2 	## Valor del array en ese punto

	lw $t0 0($a0)		
	beq $t0 $a1 found	##evaluo si he encontrado el numero
	
	lw $a0 0($fp)		##actualizo el array
	lw $a1 -4($fp)		##actualizo el valor
	lw $a2 -8($fp)		##actualizo la posicion 
	lw $a3 -12($fp)		##actualizo el tamaño del array
	
	addiu $a2 $a2 1		## sumo 1 a la posicion
	jal  replace
	
close2:
	lw $ra 0($sp)		##restauro la pila y retorno
	lw $fp 4($sp)
	addiu $sp $sp 32
	jr $ra
	
found:
	lw $a0 0($fp) 		## Posicion del array 
	lw $a1 -4($fp) 		## valor del numero 
	lw $a2 -8($fp) 		## Desplazamiento
	
	mul  $a2 $a2 4 		## Desplazamiento memoria
	add  $a0 $a0 $a2 	## Valor del array en ese punto
	
	lw $t0 4($a0)		## t0 = valor en la posicion a buscar
	lw $t1 0($a0)		## t1 = valor en la posicion +1
	sw $t0 0($a0)		## valor en la posicion a buscar en la posicion 
	sw $t1 4($a0)		## valor en la posicion +1, en posicion-1

	li $v0 4		##syscall = 4 print string
	la $a0 msg_notfound
	syscall 
	
	b close2	
	
notfound: 

	li $v0 4
	la $a0 msg_found	##syscall = 4 print string
	syscall 
	b close2

##Registros usados:
##IN
## a0 = array
## a1 = tamaño del array
## a2 = posicion desde la que comienza a contar
##OUT
## v0 = posicion del numero
buscarDesde:	
	li $v0 4		##syscall = 4 imprimo string
	la $a0 msg_print
	syscall 
	
	move $a0 $s0		## pongo el array en a0
	li $t0 10		## el tamaño del array ya siempre va a ser 10
	move $a1 $t0 		## meto en a1 el tamaño del array
	move $a2 $zero		## inicializo la posicion desde la que comienza a contar
	
	jal print 
	
	li $v0 4		##syscall = 4 imprimo string
	la $a0 msg_search		
	syscall 
	
	li $v0 5		## pido numero a remplazar
	syscall 
	

	move $a0 $s0 		## pongo el array en a0
	move $a1 $v0 		## Valor que queremos remplazar
	move $a2 $zero		## inicializo la posicion desde la que comienza a contar
	li $t0 10		## el tamaño del array ya siempre va a ser 10
	move $a3 $t0 		## en a3 meto el tamañao del array
	
	jal replace
	
	li $v0 4
	la $a0 msg_print		##syscall = 4 imprimir string
	syscall 
	
	move $a0 $s0		## pongo el array en a0
	li $t0 10		## el tamaño del array ya siempre va a ser 10
	move $a1 $t0 		## meto en a1 el tamaño del array
	move $a2 $zero		## inicializo la posicion desde la que comienza a contar

	jal print
exit:
	li $v0 10		##syscall = 10 cierro programa
	syscall 
	
print:
	subu $sp $sp 32 	##creo el marco de pila
	sw $ra 0($sp)
	sw $fp 4($sp)
	addiu $fp $sp 28
	
	sw $a0 0($fp)		## guardo el array
	sw $a1 -4($fp)		##guardo el tamañano del array
	sw $a2 -8($fp)		##guardo la posicion del array

	beq $a1 $a2 close 	##si la posicion del array es 
				##una menos que el tamaño es que el numero no esta
	
	mul  $a2 $a2 4 		## Desplazamiento memoria
	add  $a0 $a0 $a2 	## Valor del array en ese punto

	li $v0 1		## syscall = 1 imrpimo integer
	lw $a0 0($a0)
	syscall 
	
	li $v0 4		##syscall = 4 imprimir string
	la $a0 stick
	syscall 
				##actualizo  nuevos valores calculados
	lw $a0 0($fp)		##actualizo el array
	lw $a1 -4($fp)		##actualizo el tamaño del array
	lw $a2 -8($fp)		##actualizo la posicion del array
	
	addiu $a2 $a2 1		##avanzo una poscion en el array
	
	jal  print
		
close:
	lw $ra 0($sp)		##restauro pila y demas
	lw $fp 4($sp)
	addiu $sp $sp 32
	jr $ra
