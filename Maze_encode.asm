.data 
myarray: .word 9999,9999,9999,9999,9999,9999,9999,1999,9119,1999,1119,9911,9999,1199,1111,9919,9191,9199,9999,9991,1991,1119,9911,9991,9999,1199,1119,9111,1999,9111,9999,9991,9191,1991,1119,9911,1999,1999,1911,9919,1991,9919
# 9 stands for wall, 1 stands for path
mazewidth: .word 6
ycord: .word 1 #can be changed
xcord: .word 3 #can be changed

 
.text 
lw $s0, xcord
lw $s1, ycord
lw $s2, mazewidth

mul $t0,$s1,$s2
add $t1,$t0,$s0

sll $t1,$t1,2

la $t2, myarray
add $t3,$t2,$t1

lw $a0, 0($t3)
li $v0, 1
syscall   




