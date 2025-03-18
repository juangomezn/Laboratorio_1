.data
    prompt1:    .asciiz "¿Cuántos números desea comparar? (3-5): "
    prompt2:    .asciiz "Ingrese un número: "
    result:     .asciiz "El número mayor es: "
    error_msg:  .asciiz "Error: Debe ingresar entre 3 y 5 números.\n"
    newline:    .asciiz "\n"
    .align 2                # Alinear el siguiente dato en un límite de palabra (múltiplo de 4)
    numbers:    .space 20   # Espacio para almacenar hasta 5 números (4 bytes cada uno)

.text
.globl main

main:
    # Pedir al usuario cuántos números desea comparar
    li $v0, 4              # Código para imprimir cadena
    la $a0, prompt1        # Cargar dirección de prompt1
    syscall

    # Leer la cantidad de números
    li $v0, 5              # Código para leer entero
    syscall
    move $t0, $v0          # Guardar la cantidad en $t0

    # Validar que la cantidad esté entre 3 y 5
    li $t1, 3
    li $t2, 5
    blt $t0, $t1, error    # Si es menor que 3, mostrar error
    bgt $t0, $t2, error    # Si es mayor que 5, mostrar error

    # Inicializar variables
    la $t3, numbers        # Cargar dirección del arreglo numbers
    li $t4, 0              # Contador para el bucle
    li $t5, -2147483648    # Inicializar el mayor con el valor mínimo posible (32 bits)

input_loop:
    # Pedir al usuario que ingrese un número
    li $v0, 4              # Código para imprimir cadena
    la $a0, prompt2        # Cargar dirección de prompt2
    syscall

    # Leer el número ingresado
    li $v0, 5              # Código para leer entero
    syscall
    sw $v0, 0($t3)         # Guardar el número en el arreglo

    # Comparar con el mayor actual
    lw $t6, 0($t3)         # Cargar el número recién ingresado
    bgt $t6, $t5, update_max # Si es mayor, actualizar el mayor
    j continue

update_max:
    move $t5, $t6          # Actualizar el mayor

continue:
    addi $t3, $t3, 4       # Mover al siguiente espacio en el arreglo
    addi $t4, $t4, 1       # Incrementar el contador
    blt $t4, $t0, input_loop # Repetir si no se han ingresado todos los números

    # Mostrar el resultado
    li $v0, 4              # Código para imprimir cadena
    la $a0, result         # Cargar dirección de result
    syscall

    li $v0, 1              # Código para imprimir entero
    move $a0, $t5          # Cargar el número mayor
    syscall

    li $v0, 4              # Código para imprimir cadena
    la $a0, newline        # Imprimir nueva línea
    syscall

    # Terminar el programa
    li $v0, 10             # Código para salir
    syscall

error:
    # Mostrar mensaje de error
    li $v0, 4              # Código para imprimir cadena
    la $a0, error_msg      # Cargar dirección de error_msg
    syscall

    # Terminar el programa
    li $v0, 10             # Código para salir
    syscall