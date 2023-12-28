global cpu_instance

%define Cpu_struct_m_offset 0
%define Cpu_struct_v_offset (Cpu_struct_m_offset + 4096)
%define Cpu_struct_i_offset (Cpu_struct_v_offset + 16)
%define Cpu_struct_dt_offset (Cpu_struct_i_offset + 2)
%define Cpu_struct_st_offset (Cpu_struct_dt_offset + 1)
%define Cpu_struct_pc_offset (Cpu_struct_st_offset + 1)
%define Cpu_struct_sp_offset (Cpu_struct_pc_offset + 2)
%define Cpu_struct_s_offset (Cpu_struct_sp_offset + 1)
%define Cpu_struct_screen_offset (Cpu_struct_s_offset + 32)
%define Cpu_struct_keys_offset (Cpu_struct_screen_offset + 8192)
%define Cpu_struct_should_exit_offset (Cpu_struct_keys_offset + 16)
%define Cpu_struct_pause_offset (Cpu_struct_should_exit_offset + 1)


struc Cpu_struct
    .m resb 4096
    .v resb 16          ; Registers: 16 bytes
    .i resw 1           ; Index register: 2 bytes
    .dt resb 1          ; Delay timer: 1 byte
    .st resb 1          ; Sound timer: 1 byte
    .pc resw 1          ; Program counter: 2 bytes
    .sp resb 1          ; Stack pointer: 1 byte
    .s resw 16          ; Stack: 32 bytes (16 x 2-byte elements)
    .screen resb 8192   ; Screen: 8192 bytes
    .keys resb 16       ; Keys: 16 bytes
    .should_exit resb 1 ; Should Exit: 1 byte
    .pause resb 1       ; Pause: 1 byte
endstruc

section .data
    emulate_cycle dd 16

section .bss 
    cpu_instance resb Cpu_struct_size

section .text

init_cpu:
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

    lea rdi, [cpu_instance + Cpu_struct_st_offset]


    lea rdi, [cpu_instance + Cpu_struct_pc_offset]

    lea rdi, [cpu_instance + Cpu_struct_sp_offset]

    lea rdi, [cpu_instance + Cpu_struct_s_offset]

    lea rdi, [cpu_instance + Cpu_struct_screen_offset]

    lea rdi, [cpu_instance + Cpu_struct_keys_offset]

    lea rdi, [cpu_instance + Cpu_struct_should_exit_offset]

    lea rdi, [cpu_instance + Cpu_struct_pause_offset]





    




