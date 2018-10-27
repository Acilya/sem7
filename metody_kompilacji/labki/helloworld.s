        .data
msg:   .asciiz "Hello World"
	.extern foobar 4

        .text
        .globl main
main:   li $v0, 4       # syscall 4 (print_str)
        la $a0, msg     # argument: string
        syscall         # print the string
		
		li $v0, 1	# syscall 1 (print_int)
        la $a0, 1     # argument: 1
        syscall         # print the int
		
        lw $t1, foobar
        
        jr $ra          # retrun to caller
