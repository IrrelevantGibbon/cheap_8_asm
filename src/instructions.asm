%include "src/cpu_offsets.asm"

_cls:
;   rdi: cpu pointer
    lea rsi, [rdi + Cpu_struct_screen_offset]
    mov rcx, 2048
    xor al, al
    mov rdi, rsi
    rep stosb
    ret

_jp:
;   rdi: cpu pointer
;   rsi: nnn
    mov [rdi + Cpu_struct_pc_offset], si
    ret

_ret:
_call:
_se:
_se_reg:
_ld:
;   rdi: cpu pointer
;   rsi: x
;   rdx: nn
    mov [rdi + Cpu_struct_v_offset + rsi], dl 
    ret
_add:
;   rdi: cpu pointer
;   rsi: x 
;   rdx: nn
    add [rdi + Cpu_struct_v_offset + rsi], dl 
    ret
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
    ret
_jp_v0:
_rdn:
_drw:
;   rdi: cpu pointer
;   rsi: x
;   rdi: y
;   rcx: n
    ;mov byte [rdi + Cpu_struct_v_f_flags], 0
    
    ;push [rdi + Cpu_struct_v_offset + x]
    ;push [rdi + Cpu_struct_v_offset + y]


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
