        .global _start


matrix_mult:
    ! Reservar espacio en la pila para preservar registros locales
    sub   %sp, 32, %sp       ! Reservamos 32 bytes
    st    %l0, [%sp + 0]
    st    %l1, [%sp + 4]
    st    %l2, [%sp + 8]
    st    %l3, [%sp + 12]
    st    %l4, [%sp + 16]
    st    %l5, [%sp + 20]
    st    %l6, [%sp + 24]
    st    %l7, [%sp + 28]

    mov   0, %l0           ! %l0 = i = 0 (fila de A)
outer_loop:
    cmp   %l0, %i0         ! ¿i < n?
    bge   end_matrix_mult  ! Si i >= n, terminamos
    nop

    mov   0, %l1           ! %l1 = j = 0 (columna de B)
inner_j_loop:
    cmp   %l1, %i2         ! ¿j < p?
    bge   next_row_i       ! Si j >= p, siguiente fila
    nop

    mov   0, %l3           ! %l3 = sum = 0 (acumulador para C[i][j])
    mov   0, %l2           ! %l2 = k = 0 (índice para la multiplicación)
inner_k_loop:
    cmp   %l2, %i1         ! ¿k < m?
    bge   store_cell       ! Si k >= m, almacenamos sum en C[i][j]
    nop

    !---------------------------
    ! Calcular dirección de A[i][k]
    ! offset_A = (i * m + k) * 4
    !---------------------------
    mov   %l0, %l4         ! %l4 = i
    smul  %l4, %i1, %l4     ! %l4 = i * m  (m está en %i1)
    add   %l4, %l2, %l4     ! %l4 = i*m + k
    sll   %l4, 2, %l4       ! Multiplicar por 4 (4 bytes por elemento)
    add   %i3, %l4, %o0     ! Dirección de A[i][k] = base_A + offset
    ld    [%o0], %l5       ! Cargar A[i][k] en %l5

    !---------------------------
    ! Calcular dirección de B[k][j]
    ! offset_B = (k * p + j) * 4
    !---------------------------
    mov   %l2, %l4         ! %l4 = k
    smul  %l4, %i2, %l4     ! %l4 = k * p  (p está en %i2)
    add   %l4, %l1, %l4     ! %l4 = k*p + j
    sll   %l4, 2, %l4       ! Multiplicar por 4
    add   %i4, %l4, %o0     ! Dirección de B[k][j] = base_B + offset
    ld    [%o0], %l6       ! Cargar B[k][j] en %l6

    !---------------------------
    ! Multiplicar y acumular:
    ! sum += A[i][k] * B[k][j]
    !---------------------------
    smul  %l5, %l6, %l7     ! %l7 = A[i][k] * B[k][j]
    add   %l3, %l7, %l3     ! sum = sum + %l7

    add   %l2, 1, %l2       ! k++
    ba    inner_k_loop
    nop

store_cell:
    !---------------------------
    ! Calcular dirección para C[i][j]
    ! offset_C = (i * p + j) * 4
    !---------------------------
    mov   %l0, %l4         ! %l4 = i
    smul  %l4, %i2, %l4     ! %l4 = i * p  (p está en %i2)
    add   %l4, %l1, %l4     ! %l4 = i*p + j
    sll   %l4, 2, %l4       ! Multiplicar por 4
    add   %i5, %l4, %o0     ! Dirección de C[i][j] = base_C + offset
    st    %l3, [%o0]       ! Almacenar sum en C[i][j]

    add   %l1, 1, %l1       ! j++
    ba    inner_j_loop
    nop

next_row_i:
    add   %l0, 1, %l0       ! i++
    ba    outer_loop
    nop

end_matrix_mult:
    ! Restaurar registros locales
    ld    [%sp + 0], %l0
    ld    [%sp + 4], %l1
    ld    [%sp + 8], %l2
    ld    [%sp + 12], %l3
    ld    [%sp + 16], %l4
    ld    [%sp + 20], %l5
    ld    [%sp + 24], %l6
    ld    [%sp + 28], %l7
    add   %sp, 32, %sp
    retl
    nop

!-------------------------------------------------------------
! Rutina principal: _start
! Prepara datos de prueba y llama a matrix_mult.
! En este ejemplo multiplicamos dos matrices (almacenadas en orden de filas)
! A: n x m, B: m x p, C: n x p
!-------------------------------------------------------------
_start:
    ! Para este ejemplo, usaremos:
    ! n = 2 (filas de A), m = 2 (columnas de A y filas de B), p = 2 (columnas de B)
    mov   2, %i0        ! n = 2
    mov   2, %i1        ! m = 2
    mov   2, %i2        ! p = 2

    ! Establecer las direcciones de las matrices utilizando sethi/or:
    sethi   %hi(A), %i3
    or      %i3, %lo(A), %i3

    sethi   %hi(B), %i4
    or      %i4, %lo(B), %i4

    sethi   %hi(C), %i5
    or      %i5, %lo(C), %i5

    call  matrix_mult
    nop

    ! Bucle infinito para detener la ejecución
    ba    .
    nop

        .align 4

! Matriz A (2x2)
A:      .word   1, 2, 3, 4

! Matriz B (2x2)
B:      .word   5, 6, 7, 8

! Matriz C (2x2) para almacenar el resultado
C:      .word   0, 0, 0, 0
