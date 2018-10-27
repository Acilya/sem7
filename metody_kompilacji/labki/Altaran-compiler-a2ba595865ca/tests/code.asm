.data
__t0: .word 0
__t1: .float 0
__t2: .word 0
__t3: .float 0
__t4: .float 0
__t5: .float 0
arr: .space 80
i: .word 0
x: .float 0
__f1: .float 2.500000
__f0: .float 1.500000
__s0: .asciiz " "
.text
main:
#zjebane_cus
l.s $f1,__f0
la $t6,arr
li $t2,0
mul $t2,$t2,8
add $t6,$t6,$t2
s.s $f1,0($t6)
#zjebane_cus
l.s $f1,__f1
la $t6,arr
li $t2,1
mul $t2,$t2,8
add $t6,$t6,$t2
s.s $f1,0($t6)
li $t1, 2
sw $t1, i
b start1
start0:
lw $t1,i
li $t2,1
add $t1,$t1,$t2
sw $t1,i
start1:
li $t1,10
lw $t2,i
bge $t2,$t1,label0
li $t1,1
lw $t2,i
sub $t1,$t2,$t1
sw $t1,__t0
la $t6,arr
lw $t2,__t0
mul $t2,$t2,8
add $t6,$t6,$t2
l.s $f1,0($t6)
s.s $f1,__t1
li $t1,2
lw $t2,i
sub $t1,$t2,$t1
sw $t1,__t2
la $t6,arr
lw $t2,__t2
mul $t2,$t2,8
add $t6,$t6,$t2
l.s $f1,0($t6)
s.s $f1,__t3
lwc1 $f1,__t3
lwc1 $f2,__t1
add.s $f1,$f1,$f2
s.s $f1,__t4
#zjebane_cus
l.s $f1,__t4
la $t6,arr
lw $t2,i
mul $t2,$t2,8
add $t6,$t6,$t2
s.s $f1,0($t6)
b start0
label0:
li $t1, 0
sw $t1, i
b start3
start2:
lw $t1,i
li $t2,1
add $t1,$t1,$t2
sw $t1,i
start3:
li $t1,10
lw $t2,i
bge $t2,$t1,label1
la $t6,arr
lw $t2,i
mul $t2,$t2,8
add $t6,$t6,$t2
l.s $f1,0($t6)
s.s $f1,__t5
l.s $f1,__t5
s.s $f1,x
l.s $f12,x
li $v0,2
syscall
li $v0,4
la $a0,__s0
syscall
b start2
label1:
