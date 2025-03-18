.data
    prompt:     .asciiz "¿Cuántos números de la serie Fibonacci desea generar? "
    fib_msg:    .asciiz "Serie Fibonacci: "
    sum_msg:    .asciiz "\nSuma de la serie: "
    comma:      .asciiz ", "
    newline:    .asciiz "\n"

.text
.globl main

main:
    # Pedir al usuario cuántos números de la serie Fibonacci desea generar
    li $v0, 4              # Código para imprimir cadena
    la $a0, prompt         # Cargar dirección de prompt
    syscall

    # Leer la cantidad de números
    li $v0, 5              # Código para leer entero
    syscall
    move $t0, $v0          # Guardar la cantidad en $t0

    # Validar que la cantidad sea mayor que 0
    blez $t0, invalid_input # Si es menor o igual a 0, mostrar error

    # Inicializar variables para la serie Fibonacci
    li $t1, 0              # Primer número de Fibonacci (F(0) = 0)
    li $t2, 1              # Segundo número de Fibonacci (F(1) = 1)
    li $t3, 0              # Contador para el bucle
    li $t4, 0              # Suma de la serie Fibonacci

    # Mostrar el mensaje de la serie Fibonacci
    li $v0, 4              # Código para imprimir cadena
    la $a0, fib_msg        # Cargar dirección de fib_msg
    syscall

fib_loop:
    # Mostrar el número actual de la serie Fibonacci
    li $v0, 1              # Código para imprimir entero
    move $a0, $t1          # Cargar el número actual
    syscall

    # Sumar el número actual a la suma total
    add $t4, $t4, $t1      # Sumar el número actual a $t4

    # Verificar si es el último número para no imprimir una coma
    addi $t3, $t3, 1       # Incrementar el contador
    bge $t3, $t0, end_fib  # Si se alcanzó la cantidad deseada, terminar

    # Imprimir una coma y un espacio
    li $v0, 4              # Código para imprimir cadena
    la $a0, comma          # Cargar dirección de comma
    syscall

    # Calcular el siguiente número de Fibonacci
    add $t5, $t1, $t2      # $t5 = $t1 + $t2 (siguiente número)
    move $t1, $t2          # Actualizar $t1 con el valor de $t2
    move $t2, $t5          # Actualizar $t2 con el valor de $t5

    # Repetir el bucle
    j fib_loop

end_fib:
    # Mostrar la suma de la serie Fibonacci
    li $v0, 4              # Código para imprimir cadena
    la $a0, sum_msg        # Cargar dirección de sum_msg
    syscall

    li $v0, 1              # Código para imprimir entero
    move $a0, $t4          # Cargar la suma de la serie
    syscall

    # Imprimir nueva línea
    li $v0, 4              # Código para imprimir cadena
    la $a0, newline        # Cargar dirección de newline
    syscall

    # Terminar el programa
    li $v0, 10             # Código para salir
    syscall

invalid_input:
    # Mostrar mensaje de error si la entrada es inválida
    li $v0, 4              # Código para imprimir cadena
    la $a0, newline        # Cargar dirección de newline
    syscall

    li $v0, 10             # Código para salir
    syscall