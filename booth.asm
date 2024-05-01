# Algoritmo de Booth en MIPS para multiplicar enteros de 32 bits

    .data
M:  .word 0
Q:  .word 0
A:  .word 0
Qneg1:  .word 0

    .text
    .globl main

main:
    # Cargar los valores M y Q desde la memoria
    lw $t0, M     # M
    lw $t1, Q     # Q
    
    # Inicializar A y Q-1
    li $t2, 0          # A
    li $t3, 0          # Q-1
    
    # Iniciar el bucle para multiplicar
loop:
    # Verificar si Q[0]Q-1 es igual a 01
    and $t4, $t1, $t3
    li $t5, 1
    sub $t4, $t4, $t5
    
    # Si es 01, sumar M a A
    beq $t4, $zero, add_M_to_A
    
    # Verificar si Q[0]Q-1 es igual a 10
    li $t4, -2
    and $t4, $t1, $t4
    li $t5, 2
    sub $t4, $t4, $t5
    
    # Si es 10, restar M de A
    beq $t4, $zero, sub_M_from_A
    
    # Corrimiento aritmético a la derecha de A y Q
    sra $t0, $t0, 1    # Corrimiento aritmético de M
    sra $t1, $t1, 1    # Corrimiento aritmético de Q
    sra $t3, $t1, 31   # Obtener el bit más significativo de Q
    j loop             # Volver al bucle
    
add_M_to_A:
    add $t2, $t2, $t0  # Sumar M a A
    j shift_and_loop   # Saltar al corrimiento y continuar el bucle
    
sub_M_from_A:
    sub $t2, $t2, $t0  # Restar M de A

shift_and_loop:
    sll $t2, $t2, 1    # Corrimiento a la izquierda de A
    sll $t1, $t1, 1    # Corrimiento a la izquierda de Q
    sll $t3, $t3, 1    # Corrimiento a la izquierda de Q-1
    j loop             # Volver al bucle
