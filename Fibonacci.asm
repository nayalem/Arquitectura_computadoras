.text
.globl __start
__start :
la $a0, Fiboprt
li $v0, 4
syscall
li $v0, 5
syscall
addi $t8, $v0, 0
li $t0, 0
li $t0, 1

la $a0, Fibost1
li $v0, 4
syscall
addi $a0, $t8, 0
li $v0, 1
syscall
la $a0,Fibost2
li $v0,4
syscall 
li $a0,1
li $v0,1
syscall 
la $a0,coma
li $v0,4
syscall
      li   $t4,2
      beq  $t8,$0,fin
      bltz $t8,fin
loop: add  $t2,$t0,$t1
      addi $a0,$t2,0
      li $v0,1
      syscall
      beq $t4,$t8,fin
      la $a0,coma
      li $v0,4
      syscall
      addi $t4,$t4,1
      addi $t0,$t1,0
      addi $t1,$t2,0
      j loop
fin:
      la $a0,endl
      li $v0,4
      syscall
      li $v0,10
      syscall
# SECCION DE VARIABLES EN MEMORIA (.data)
.data
Fiboprt: .asciiz "Ingresar_n:"
Fibost1: .asciiz "La_serie_Fibonacci_de_ "
Fibost2: .asciiz " terminos_es: "
coma: .asciiz ", "
endl: .asciiz "\n"

      




