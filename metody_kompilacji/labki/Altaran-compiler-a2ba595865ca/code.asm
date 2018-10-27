.data
__t0: .word 1
x: .word 2
.text
main:
l.s $f1,2.000000
l.s $f2,2
add.s $f1,$f1,$f2
s.s $f1,__t0
l.s $f1,__t0
s.s $f1,x
li $v0,1
lw $a0,x
syscall
