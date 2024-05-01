.data
    result:     .space 8          # Espacio para almacenar el resultado de 64 bits

.text
    main:
        # Inicializamos los registros
        li $v0, 0        # $v0 = 0
        li $v1, 0        # $v1 = 0

        # Cargamos los valores de entrada en los registros $t0 y $t1 desde las direcciones de memoria
        lw $t0, 0x00400000   # Cargamos el valor de M desde la dirección 0x00400000 en $t0
        lw $t1, 0x00400004   # Cargamos el valor de Q desde la dirección 0x00400004 en $t1

        # Inicializamos los registros de Booth
        li $t2, 32       # Inicializamos el contador en 32
        li $t3, 0        # Inicializamos el registro de extensión en 0
        li $t4, 0        # Inicializamos el registro de Booth en 0

    loop:
        # Obtener el último bit de Q y el bit menos significativo de Booth
        andi $t5, $t1, 1  # $t5 = Q & 1
        andi $t6, $t4, 1  # $t6 = Booth & 1

        # Verificar los valores de los bits
        beq $t5, $t6, no_subtract
        beq $t5, 1, subtract

    no_subtract:
        # Sumar M a los registros $v0 y $v1
        add $v0, $v0, $t0
        addu $v1, $v1, $t1

        # Corrimiento aritmético a la derecha de $t1 y $t4
        sra $t1, $t1, 1
        sra $t4, $t4, 1
        j shift_done

    subtract:
        # Restar M de los registros $v0 y $v1
        sub $v0, $v0, $t0
        subu $v1, $v1, $t1

        # Corrimiento aritmético a la derecha de $t1 y $t4
        sra $t1, $t1, 1
        sra $t4, $t4, 1
        j shift_done

    shift_done:
        # Corrimiento aritmético a la derecha de $t4
        sra $t4, $t4, 1

        # Decrementar el contador
        subi $t2, $t2, 1

        # Verificar si hemos terminado
        beqz $t2, done
        j loop

    done:
        # Guardar el resultado en la dirección de memoria "result"
        sw $v0, result
        sw $v1, result + 4

        # Terminar el programa
        li $v0, 10
        syscall
