global load_rom_from_file

section .bss
    fd resq 1                       ; File descriptor

section .text


load_rom_from_file:

    ; rdi is a pointer to a string
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer
    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

open_file:

    mov rax, 2              ; syscall number for open
    mov rdi, r15             
    mov rsi, 0             ; Read only Flag
    syscall

    cmp rax, -1
    je error

    mov [fd], rax

read_file_content:
    ; Read from the file

    sub rsp, 500

    mov rax, 0                      ; syscall number for read
    mov rdi, [fd]                   ; first argument: file descriptor
    mov rsi, rsp                 ; second argument: buffer
    mov rdx, 500                   ; third argument: number of bytes to read
    syscall
    push rax                ; store number of bytes read

    ; Check for end of file or error
    cmp rax, 0                      ; 0 indicates end of file
    je close_file
    cmp rax, -1                     ; -1 indicates an error
    je error


close_file:
    ; Close the file
    mov rax, 3                      ; syscall number for close
    mov rdi, [fd]                   ; first argument: file descriptor
    syscall
    ret                    ; Return from function

error:
    mov rax, -1
    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function