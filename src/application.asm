global run

%include "src/cpu_offsets.asm"

section .data
    delay   dd 16
    quit    dd 0
    argc_message  db "Argc", 10, 0 

section .text
; window management imports
extern init_window
extern create_window
extern create_renderer
extern create_texture
extern close_window
extern draw_on_window

extern renderer
extern texture
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; events management imports
extern handle_event
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; cpu imports
extern cpu_instance
extern init_cpu
extern load_rom_into_memory_from_stack
;;;;;;;;;;;;;;;

; application_imports
extern load_rom_from_file
;;;;;;;;;;;;;;;;;;;;;

; SDL import
extern SDL_Delay
extern SDL_SetRenderTarget
extern SDL_SetRenderDrawColor
extern SDL_RenderClear
extern SDL_RenderCopy
extern SDL_RenderPresent
extern SDL_PollEvent
;;;;;;;;;;;;;;;

; Libc import
extern printf
extern exit
;;;;;;;;;;;;;;

run:
    pop rdi
    cmp rdi, 2
    jl no_args

    pop rdi
    pop r15

    jmp init

no_args:
    jmp exit_

init:
    and rsp, -16           ; Ensure rsp is 16-byte aligned
    call init_cpu
    call load_rom_from_file
    cmp rax, -1
    je exit_
    call load_rom_into_memory_from_stack
    call init_window
    call create_window
    call create_renderer
    call create_texture

loop_0:

    call handle_event
    cmp eax, -1
    je exit_application

    lea rdi, [cpu_instance + Cpu_struct_pause_offset]
    cmp rdi, 1
    je loop_0

    mov rdi, [renderer]
    mov rsi, texture
    call SDL_SetRenderTarget

    ;;;; DRAW
    call draw_on_window

    mov rdi, [renderer]
    mov esi, 0
    call SDL_SetRenderTarget
        
    mov rdi, [renderer]
    mov esi, 0
    mov edx, 0
    mov ecx, 0
    mov r8,  255
    call SDL_SetRenderDrawColor

    mov rdi, [renderer]
    call SDL_RenderClear

    mov rdi, [renderer]
    mov rsi, texture
    mov rdx, 0
    mov rcx, 0
    call SDL_RenderCopy

    mov rdi, [renderer]
    call SDL_RenderPresent

    mov rdi, [delay]
    call SDL_Delay

    jmp loop_0

exit_application:
    call close_window
    call exit_

exit_:
    call exit
    ret