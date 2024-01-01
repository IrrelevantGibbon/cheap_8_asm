global _cls, _jp, _ld, _add, _drw
%include "src/cpu_offsets.asm"

_cls:
;   rdi: cpu pointer
    lea rsi, [rdi + Cpu_struct_screen_offset]
    mov rcx, 2048
    xor al, al
    mov rdi, rsi
    rep stosb
    jmp end_instructions

_jp:
;   rdi: cpu pointer
;   rsi: nnn
    mov [rdi + Cpu_struct_pc_offset], si
    jmp end_instructions

_ret:
_call:
_se:
_se_reg:
_ld:
;   rdi: cpu pointer
;   rsi: x
;   rdx: nn
    mov [rdi + Cpu_struct_v_offset + rsi], dl 
    jmp end_instructions
_add:
;   rdi: cpu pointer
;   rsi: x 
;   rdx: nn
    add [rdi + Cpu_struct_v_offset + rsi], dl 
    jmp end_instructions
_ld_reg:
_or:
_and:
_xor:
_add_reg:
_sub:
_shr:
_subn:
_shl:
_sne_reg:
_ld_i:
;   rdi: cpu pointer
;   rsi: nnn
    mov [rdi + Cpu_struct_i_offset], si 
    jmp end_instructions
_jp_v0:
_rdn:


_drw:
;   rdi: cpu pointer
;   rsi: x
;   rdx: y
;   rcx: n
    mov byte [rdi + Cpu_struct_v_f_flags], 0
    
    mov r8, [rdi + Cpu_struct_v_offset + rsi]
    mov r9, [rdi + Cpu_struct_v_offset + rdx]

    ;outer loop counter
    mov r10, 0
    ; inner loop counter
    mov r11, 0

    outer_loop:

        cmp r10, 8
        jge end_outer_loop

        mov rsi, [rdi + Cpu_struct_m_offset + Cpu_struct_i_offset]

        inner_loop:

            cmp r11, 8
            jge end_inner_loop

            mov r13, 0x80
            mov cl, r11b
            shr r13, cl
            and rsi, r13

            cmp r11, 0
            je continue_inner_loop


            mov rax, 0
            add rax, r10
            mov rcx, 8
            mul rcx
            add rax, r8
            add rax, r11

            mov rcx, [rdi + Cpu_struct_m_offset + rax]

            cmp rcx, 1
            jne continue_inner_loop

            mov byte [rdi + Cpu_struct_v_f_flags], 1

            xor byte [rdi + Cpu_struct_m_offset + rax], 1

            continue_inner_loop:

                inc r11
                jmp inner_loop


        end_inner_loop:

            mov r11, 0
            inc r10
            jmp outer_loop

    end_outer_loop:
        jmp end_instructions

_skp:
_sknp:
_ld_reg_dt:
_ld_key:
_ld_dt:
_ld_st:
_add_i:
_ld_f:
_ld_b:
_ld_mem:
_ld_reg_mem:


end_instructions:
