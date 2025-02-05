.global _start

dt:     .word   2
L:      .word   8

vel_array:
        .word   15
        .word   5
        .word   20
        .word   10
        .word   5
        .word   25

array_size:
        .word   3

x:      .word   5
y:      .word   -3
theta:  .word   10

pos_msg:        .ascii "Nueva posicion: ("
x_msg:          .ascii ", "
y_msg:          .ascii ")\n",0
theta_msg:      .ascii "Orientacion: ",0
newline:        .ascii "\n",0
        .align 4

_start:
        sethi   %hi(vel_array), %l0
        or      %l0, %lo(vel_array), %l0
        
        sethi   %hi(array_size), %l1
        or      %l1, %lo(array_size), %l1
        ld      [%l1], %l1
        mov     0, %l2

loop:   
        cmp     %l2, %l1
        bge     done
        nop

        ld      [%l0], %o0
        ld      [%l0+4], %o1

        add     %o0, %o1, %o2           
        srl     %o2, 1, %o4             

        sub     %o1, %o0, %o5           
        sethi   %hi(L), %o6
        or      %o6, %lo(L), %o6
        ld      [%o6], %o6
        sra     %o5, 3, %o7              

        sethi   %hi(dt), %l3
        or      %l3, %lo(dt), %l3
        ld      [%l3], %l3
        mulscc  %o7, %l3, %l4

        sethi   %hi(theta), %l5
        or      %l5, %lo(theta), %l5
        ld      [%l5], %l6
        add     %l6, %l4, %l6
        st      %l6, [%l5]

        sethi   %hi(x), %o0
        or      %o0, %lo(x), %o0
        ld      [%o0], %o1
        add     %o1, %o4, %o1
        st      %o1, [%o0]

        sethi   %hi(y), %o0
        or      %o0, %lo(y), %o0
        ld      [%o0], %o1
        sub     %o1, %o4, %o1
        st      %o1, [%o0]

        sethi   %hi(pos_msg), %o0
        or      %o0, %lo(pos_msg), %o0
        st      %o0, [%g0+IODevPrintStrz]
        
        sethi   %hi(x), %o0
        or      %o0, %lo(x), %o0
        ld      [%o0], %o1
        st      %o1, [%g0+IODevPrintInt]
        
        sethi   %hi(x_msg), %o0
        or      %o0, %lo(x_msg), %o0
        st      %o0, [%g0+IODevPrintStrz]
        
        sethi   %hi(y), %o0
        or      %o0, %lo(y), %o0
        ld      [%o0], %o1
        st      %o1, [%g0+IODevPrintInt]
        
        sethi   %hi(y_msg), %o0
        or      %o0, %lo(y_msg), %o0
        st      %o0, [%g0+IODevPrintStrz]

        sethi   %hi(theta_msg), %o0
        or      %o0, %lo(theta_msg), %o0
        st      %o0, [%g0+IODevPrintStrz]
        
        sethi   %hi(theta), %o0
        or      %o0, %lo(theta), %o0
        ld      [%o0], %o1
        st      %o1, [%g0+IODevPrintInt]
        
        sethi   %hi(newline), %o0
        or      %o0, %lo(newline), %o0
        st      %o0, [%g0+IODevPrintStrz]

        add     %l2, 1, %l2             
        add     %l0, 8, %l0             
        ba      loop
        nop

done:   
        ba      done
        nop
