.text

.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    addi s0 , a0,  0 
    li a0 , 24  
    call malloc 

    sw s0 , 0(a0)
    sd x0 , 8(a0)     # left
    sd x0 , 16(a0)    # right 

    ld ra, 8(sp)
    ld s0 , 0(sp)
    addi sp, sp, 16
    ret


insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd a0, 16(sp)   # save root
    sw a1, 8(sp)    # save val


    beq a0 , x0 , base     # root == NULL 

    lw t0 , 0(a0)
    bge a1 , t0 , right     # val >= root->val then go right 

    ld a0 , 8(a0)  
    lw a1 , 8(sp)      
    call insert        
    
    ld t0 , 16(sp)
    sd a0 , 8(t0)

    addi a0, t0 , 0 
    jal x0, end 

right : 

    ld a0 , 16(a0)
    lw a1 , 8(sp)
    call insert 

    ld t0 , 16(sp)
    sd a0 , 16(t0)
    addi a0 , t0 , 0 
    jal x0, end 

base:

    addi a0 , a1 , 0      #  a0 = val now 
    call make_node         # now a0 will have new node pointer
    jal x0 , end 

  
end : 
    ld ra, 24(sp)
    addi sp, sp, 32
    ret


get:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd a0, 16(sp)
    sd a1, 8(sp)

    
    beq a0 , x0 , condition 
    lw t0 , 0(a0)
    beq t0 , a1 , condition 

    bge a1 , t0 , other          # val > root->val so go right 

    ld a0 , 8(a0)
    lw a1 , 8(sp)
    call get  

    jal x0 , returner 


other : # other means right 

    ld a0 , 16(a0) 
    lw a1 , 8(sp)
    call get 
    jal x0 , returner 

condition : 

    jal x0 , returner 


returner : 
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

getAtMost:
    addi sp, sp, -32
    sd ra, 24(sp)
    sw a0, 16(sp)   # val
    sd a1, 8(sp)    # root

    beq a1 , x0 , NULL     
    lw t0 , 0(a1)  # t0 is root->val
    beq a0 , t0 , found 

    blt a0 , t0 , L  

    addi t1 , t0 , 0 

    ld t2, 16(a1) 
    addi a1 , t2 , 0 
    lw a0 , 16(sp)

    call getAtMost 

    bge t1 , a0 , candi 
    jal x0 , BACK



candi : 
    addi a0 , t1,  0 
    jal x0 , BACK

L:
    ld t2, 8(a1) 
    addi a1 , t2 , 0 
    lw a0 , 16(sp)

    call getAtMost
    jal x0 , BACK 


found : 
    lw a0 , 16(sp)
    jal x0 , BACK 


NULL : 
    li a0 , -1 
    

BACK : 
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
