	.data
str: 	.asciiz "Suma de 2 y 2 = %d\n"
array:.byte 10,11,12,13,14,15,16,17,18,19,0
	.text
main: li $v0, 10
	 syscall
