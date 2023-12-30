global cpu_instance, init_cpu

%include "src/cpu_offsets.asm"

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

fetch_op:
    
decode_op:

execute_op:

decrement_timers:

emulate_cycle: