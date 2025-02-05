.global _start

matrix_mult:
    sub   %sp, 32, %sp
    st    %l0, [%sp + 0]
    st    %l1, [%sp + 4]
    st    %l2, [%sp + 8]
    st    %l3, [%sp + 12]
    st    %l4, [%sp + 16]
    st    %l5, [%sp + 20]
    st    %l6, [%sp + 24]
    st    %l7, [%sp + 28]

    mov   0, %l0
outer_loop:
    cmp   %l0, %i0
    bge   end_matrix_mult
    nop

    mov   0, %l1
inner_j_loop:
    cmp   %l1, %i2
    bge   next_row_i
    nop

    mov   0, %l3
    mov   0, %l2
inner_k_loop:
    cmp   %l2, %i1
    bge   store_cell
    nop

    mov   %l0, %l4
    smul  %l4, %i1, %l4
    add   %l4, %l2, %l4
    sll   %l4, 2, %l4
    add   %i3, %l4, %o0
    ld    [%o0], %l5

    mov   %l2, %l4
    smul  %l4, %i2, %l4
    add   %l4, %l1, %l4
    sll   %l4, 2, %l4
    add   %i4, %l4, %o0
    ld    [%o0], %l6

    smul  %l5, %l6, %l7
    add   %l3, %l7, %l3

    add   %l2, 1, %l2
    ba    inner_k_loop
    nop

store_cell:
    mov   %l0, %l4
    smul  %l4, %i2, %l4
    add   %l4, %l1, %l4
    sll   %l4, 2, %l4
    add   %i5, %l4, %o0
    st    %l3, [%o0]

    add   %l1, 1, %l1
    ba    inner_j_loop
    nop

next_row_i:
    add   %l0, 1, %l0
    ba    outer_loop
    nop

end_matrix_mult:
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

_start:
    mov   2, %i0
    mov   2, %i1
    mov   2, %i2

    sethi   %hi(A), %i3
    or      %i3, %lo(A), %i3

    sethi   %hi(B), %i4
    or      %i4, %lo(B), %i4

    sethi   %hi(C), %i5
    or      %i5, %lo(C), %i5

    call  matrix_mult
    nop

    ba    .
    nop

.align 4

A:      .word   1, 2, 3, 4
B:      .word   5, 6, 7, 8
C:      .word   0, 0, 0, 0
