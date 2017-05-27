# Examen AC - 2 de Diciembre de 2016
# 
# Login lab: rodribs
# Gecos: Rodrigo Bermejo Sanchez
#
# RECUERDA __NO__ APAGAR EL EQUIPO CUANDO ACABES. PUEDES LEVANTARTE E IRTE SIN MAS.
# NO MODIFIQUES ESTAS LINEAS. REALIZA EL EJERCICIO A PARTIR DE ESTA CABECERA.
#####

	.data
msg1:		.asciiz "Introduce un número ( 0  detiene la introducción de datos): "
msg2:		.asciiz "\n"
	
	.text
	li $s0 0
	
	li $v0 4
	la $a0 msg1
	syscall
	li $v0 5
	syscall
	
	move $a0 $v0
	li $a1 0
	jal create
	move $s0 $v0
	
	main_loop:
	li $v0 4
	la $a0 msg1
	syscall
	li $v0 5
	syscall
	
	beq $v0 0 end_main_loop
	move $a0 $s0
	move $a1 $v0
	jal insert_in_order
	beq $v0 0 main_loop
	move $s0 $v0
	j main_loop
	
	end_main_loop:
	move $a0 $s0
	jal print
	
	li $v0 10
	syscall
	
	create:
		subu $sp $sp 32
		sw $ra 0($sp)
		addiu $fp $sp 28
		sw $fp 4($sp)
		sw $a0 0($fp)
		sw $a1 -4($fp)
		
		li $v0 9
		li $a0 8
		syscall
		lw $a0 0($fp)
		sw $a0 0($v0)
		sw $a1 4($v0)
		
		lw $ra 0($sp)
		lw $fp 4($sp)
		addiu $sp $sp 32
		jr $ra
		
		
	insert_in_order:
		subu $sp $sp 32
		sw $ra 0($sp)
		addiu $fp $sp 28
		sw $fp 4($sp)
		sw $a0 0($fp)
		sw $a1 -4($fp)
		
		lw $t1 0($a0)
		bgt $a1 $t1 insert_first
		
		insert_loop:
		lw $t0 4($a0)
		beq $t0 0 insert
		lw $t1 0($t0)
		blt $t1 $a1 insert
		move $a0 $t0
		j insert_loop
		
		insert:
		sw $a0 0($fp)
		move $a0 $a1
		move $a1 $t0
		jal create
		lw $fp 4($sp)
		lw $a0 0($fp)
		sw $v0 4($a0)
		li $v0 0
		b return_insert
		
		insert_first:
		move $t0 $a0
		move $a0 $a1
		move $a1 $t0
		jal create
		
		return_insert:
		lw $ra 0($sp)
		lw $fp 4($sp)
		addiu $sp $sp 32
		jr $ra
		
	print:
		subu $sp $sp 32
		sw $ra 0($sp)
		addiu $fp $sp 28
		sw $fp 4($sp)
		sw $a0 0($fp)
		
		lw $t0 4($a0)
		beq $t0 0 return_print
		move $a0 $t0
		jal print
		
		return_print:
		lw $fp 4($sp)
		lw $a0 0($fp)
		li $v0 1
		lw $a0 0($a0)
		syscall
		li $v0 4
		la $a0 msg2
		syscall
		
		lw $ra 0($sp)
		lw $fp 4($sp)
		addiu $sp $sp 32
		jr $ra