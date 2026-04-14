.globl main

.data
fmt:         .asciz "%d "
fmt_newline: .asciz "%d\n"

.text

main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)

    addi s1, a0, 0
    addi s2, a1, 0

    addi s1, s1, -1

    slli t0, s1, 2

    mv a0, t0
    call malloc
    addi s3, a0, 0

    addi a0, t0, 0
    call malloc
    addi s4, a0, 0

    addi a0, t0, 0
    call malloc
    addi s5, a0, 0

    li s6, -1
    li s0, 0

read:
    bge s0, s1, break

    addi t1, s0, 1
    slli t2, t1, 3
    add t3, s2, t2
    ld a0, 0(t3)

    call atoi

    slli t4, s0, 2
    add t5, s3, t4
    sw a0, 0(t5)

    addi s0, s0, 1
    jal x0, read

break:
    li s0, 0

init:
    bge s0, s1, nge

    slli t0, s0, 2
    add t1, s4, t0
    li t2, -1
    sw t2, 0(t1)

    addi s0, s0, 1
    jal x0, init

nge:
    addi s0, s1, -1

loop:
    blt s0, x0, print

while_loop:
    blt s6, x0, done

    slli t0, s6, 2
    add t1, s5, t0
    lw t2, 0(t1)

    slli t3, t2, 2
    add t4, s3, t3
    lw t5, 0(t4)

    slli t6, s0, 2
    add a3, s3, t6
    lw a4, 0(a3)

    blt t5, a4, pop
    beq t5, a4, pop
    jal x0, done

pop:
    addi s6, s6, -1
    jal x0, while_loop

done:
    blt s6, x0, skip_store

    slli t0, s6, 2
    add t1, s5, t0
    lw t2, 0(t1)

    slli t3, s0, 2
    add t4, s4, t3
    sw t2, 0(t4)

skip_store:
    addi s6, s6, 1
    slli t0, s6, 2
    add t1, s5, t0
    sw s0, 0(t1)

    addi s0, s0, -1
    jal x0, loop

print:
    li s0, 0

print_loop:
    bge s0, s1, exit

    slli t0, s0, 2
    add t1, s4, t0
    lw a1, 0(t1)

    addi t2, s1, -1
    beq s0, t2, print_last

    la a0, fmt
    call printf
    j continue_loop

print_last:
    la a0, fmt_newline
    call printf

continue_loop:
    addi s0, s0, 1
    j print_loop

exit:
    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s6, 16(sp)
    addi sp, sp, 80
    ret
    
