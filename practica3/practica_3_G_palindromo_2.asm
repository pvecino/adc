.data
str: .space 1024
pal: .asciiz  "Es palindromo"
no_pal: .asciiz "No es palindromo"

	.text
main:
	la $a0, str
        la $a1, 1024
	li $v0,8
	syscall
	move $t7,$a0
	
	move $s1,$zero
	move $s0,$zero
	
sizeof:
	lb $t2 str($s1)
	#el 10 es \n en ascii
	beq $t2,10,continue
	addi $s1,$s1,1
	
	b sizeof

continue:
	sub $s1,$s1,1
	
	lb $t1,str($s0)
	lb $t2,str($s1)
	
initialize:
	move $t3, $zero
	addi $t3,$t3,65
	
	b check_mayus
	
palindrome:
	beq $t1,32,jump_1
	beq $t1,44,jump_1
	beq $t1,46,jump_1
	beq $t2,44,jump_2
	beq $t2,46,jump_2
	beq $t2,32,jump_2
	bne $t1,$t2, end_not
	bge $s0,$s1,end_yes
	addi $s0,$s0,1
	sub $s1,$s1,1
	lb $t1,str($s0)
	lb $t2,str($s1)
	
	b initialize

check_mayus:
	beq $t3,$t1,reg_1
	beq $t3,$t2,reg_2
	beq $t3,90,palindrome
	addi $t3,$t3,1
	b check_mayus
			
reg_1:
	addi $t1,$t1,32
	b palindrome
	
reg_2:
	addi $t2,$t2,32
	b palindrome
	
jump_1:
	addi $s0,$s0,1
	lb $t1,str($s0)
	b palindrome

jump_2:
	sub $s1,$s1,1
	lb $t2,str($s1)
	b palindrome

end_not:
	la $a0,no_pal
	li $v0,4
	syscall
	
	li $v0, 10
	syscall
	
end_yes:
	la $a0,pal
	li $v0,4
	syscall
	
	li $v0, 10
	syscall