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
	
	jal sizeof

continue:
	sub $s1,$s1,1
	
	lb $t1,str($s0)
	lb $t2,str($s1)
	
palindrome:
	bne $t1,$t2, end_not
	bge $s0,$s1,end_yes
	addi $s0,$s0,1
	sub $s1,$s1,1
	
	lb $t1,str($s0)
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
