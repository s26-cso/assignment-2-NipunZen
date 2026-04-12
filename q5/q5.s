.section .rodata
filename:   .asciz "input.txt"
mode:       .asciz "r" # for read only 
yes_msg:    .asciz "Yes\n"
no_msg:     .asciz "No\n"

.section .text
.globl main

main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)      # left
    sd s3, 8(sp)       #right

    la a0, filename
    la a1, mode
    call fopen

    mv s0, a0         # file pointer

    li a1, 0
    li a2, 2   # ini to end of file a0
    call fseek

    mv a0, s0
    call ftell
    mv s1, a0          # pali length

    #
    li s2, 0           # left
    addi s3, s1, -1      # right

loop:
    bge s2, s3, yes

    mv a0, s0     #cursor setting
    mv a1, s2
    li a2, 0
    call fseek

    mv a0, s0    # getting char
    call fgetc
    mv t0, a0

    mv a0, s0
    mv a1, s3
    li a2, 0
    call fseek
    mv a0, s0
    call fgetc
    mv t1, a0

    bne t0, t1, no

    addi s2, s2, 1
    addi s3, s3, -1
    j loop

yes:
    la a0, yes_msg
    call printf
    j close

no:
    la a0, no_msg
    call printf

close:
    mv a0, s0
    call fclose

end_program:
    li a0, 0
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    addi sp, sp, 48
    ret

