global cpu_instance, init_cpu, emulate_cycle

%include "src/cpu_offsets.asm"

; instructions
extern _cls
extern _jp
extern _ld
extern _add
extern _drw
;;;;;;;;;;;;;;;

struc Cpu_struct
    .m resb 4096
    .v resb 16          ; Registers: 16 bytes
    .i resw 1           ; Index register: 2 bytes
    .dt resb 1          ; Delay timer: 1 byte
    .st resb 1          ; Sound timer: 1 byte
    .pc resw 1          ; Program counter: 2 bytes
    .sp resb 1          ; Stack pointer: 1 byte
    .s resw 16          ; Stack: 32 bytes (16 x 2-byte elements)
    .screen resb 2048   ; Screen: 8192 bytes
    .keys resb 16       ; Keys: 16 bytes
    .pause resb 1       ; Pause: 1 byte
endstruc

struc Opcode
    op: resw 1 ; opcode 2 bytes
    x: resb 1
    y: resb 1
    n: resb 1
    nn: resb 1
    nnn: resw 1
endstruc

section .data
    instructions_by_cycle dd 16
    font :
        db 0xF0, 0x90, 0x90, 0x90, 0xF0 ; 0
        db 0x20, 0x60, 0x20, 0x20, 0x70 ; 1
        db 0xF0, 0x10, 0xF0, 0x80, 0xF0 ; 2
        db 0xF0, 0x10, 0xF0, 0x10, 0xF0 ; 3
        db 0x90, 0x90, 0xF0, 0x10, 0x10 ; 4
        db 0xF0, 0x80, 0xF0, 0x10, 0xF0 ; 5
        db 0xF0, 0x80, 0xF0, 0x90, 0xF0 ; 6
        db 0xF0, 0x10, 0x20, 0x40, 0x40 ; 7
        db 0xF0, 0x90, 0xF0, 0x90, 0xF0 ; 8
        db 0xF0, 0x90, 0xF0, 0x10, 0xF0 ; 9
        db 0xF0, 0x90, 0xF0, 0x90, 0x90 ; A
        db 0xE0, 0x90, 0xE0, 0x90, 0xE0 ; B
        db 0xF0, 0x80, 0x80, 0x80, 0xF0 ; C
        db 0xE0, 0x90, 0x90, 0x90, 0xE0 ; D
        db 0xF0, 0x80, 0xF0, 0x80, 0xF0 ; E
        db 0xF0, 0x80, 0xF0, 0x80, 0x80 ; F
    current_cycle db 0
    opcode_instance:
        istruc Opcode
            at op, dw 0
            at x, db 0
            at y, db 0
            at n, db 0
            at nn, db 0
            at nnn, dw 0
        iend


section .bss 
    cpu_instance resb Cpu_struct_size

section .text

init_cpu:

    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    lea rdi, [cpu_instance + Cpu_struct_m_offset]
    mov rcx, 4096
    xor al, al
    rep stosb

    mov eax, [font]
    mov [cpu_instance + Cpu_struct_m_offset], eax

    lea rdi, [cpu_instance + Cpu_struct_v_offset]
    mov rcx, 16
    xor al, al
    rep stosb

    lea rdi, [cpu_instance + Cpu_struct_i_offset]
    mov word [rdi], 0

    lea rdi, [cpu_instance + Cpu_struct_dt_offset]
    mov byte [rdi], 0

    lea rdi, [cpu_instance + Cpu_struct_st_offset]
    mov byte [rdi], 0

    lea rdi, [cpu_instance + Cpu_struct_pc_offset]
    mov word [rdi], pc_counter_start

    lea rdi, [cpu_instance + Cpu_struct_sp_offset]
    mov byte [rdi], 0

    lea rdi, [cpu_instance + Cpu_struct_s_offset]
    mov rcx, 16
    xor ax, ax
    rep stosw

    lea rdi, [cpu_instance + Cpu_struct_screen_offset]
    mov rcx, 2048
    xor al, al
    rep stosb

    lea rdi, [cpu_instance + Cpu_struct_keys_offset]
    mov rcx, 16
    xor al, al
    rep stosb

    lea rdi, [cpu_instance + Cpu_struct_pause_offset]
    mov byte [rdi], 0

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

emulate_cycle:
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned


fetch_op:

    ; load memory
    mov rax, [cpu_instance + Cpu_struct_m_offset]
    
    ; load PC 
    movzx rcx, word [cpu_instance + Cpu_struct_pc_offset]

    ; load next 16 bits
    movzx rbx, word [rax + rcx]

    ; increment program counter
    add word [cpu_instance + Cpu_struct_pc_offset], 2
    
    ; return the current opcode into rdi
    mov rdi, rbx

decode_op:
    ; RDI: 16 bits opcode
    lea rsi, [opcode_instance]

    mov [rsi], si

    ;x
    mov rax, rdi
    and rax, 0x0F00
    shr rax, 8
    mov [rsi + 2], ah

    ;y
    mov rax, rdi
    and rax, 0x00F0
    shr rax, 4
    mov [rsi + 3], al

    ;n
    mov rax, rdi
    and rax, 0xF
    mov [rsi + 4], al

    ;nn
    mov rax, rdi
    and rax, 0xFF
    mov [rsi + 5], al

    ;nnn
    mov rax, rdi
    and rax, 0xFFF
    mov [rsi + 6], ax

    mov rdi, rsi
    
execute_op:

    movz rax, word [rdi]

    mov rsi, rax

    mov rcx, 0xF000
    and rsi, rcx


    cmp rsi, 0x0000
    je op_0x0000


op_0x0000:
    
    mov rcx, 0x000F
    and rsi, rcx

    cmp rsi, 0x0000
    jmp 
    

op 0x1000:




decrement_delay_timer:
    ; get delay timer
    movzx rax, byte [cpu_instance + Cpu_struct_dt_offset]
    ; check if delay is superior to 0
    cmp rax, 0
    ; if greater jump to next instruction
    jg decrement_sound_timer
    dec byte [cpu_instance + Cpu_struct_dt_offset]

decrement_sound_timer:
    ; get sound timer
    movzx rax, byte [cpu_instance + Cpu_struct_st_offset]
    ; check if delay is superior to 0
    cmp rax, 0
    ; if greater jump to next instruction
    jg next_cycle
    dec byte [cpu_instance + Cpu_struct_st_offset]


next_cycle:
    mov rax, [current_cycle]
    mov rcx, [emulate_cycle]
    cmp rax, rcx
    add byte [current_cycle], 1
    jl fetch_op
    mov byte [current_cycle], 0

end_cycle:
    ; end cycle, restore the stack and return
    mov rsp, rbp
    pop rbp
    ret