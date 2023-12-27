global run

section .data
    delay   dd 16
    quit    dd 0

section .text
; window management import
extern init_window
extern create_window
extern create_renderer
extern create_texture
extern close_window
extern event

extern renderer
extern texture
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SDL import
extern SDL_Delay
extern SDL_SetRenderTarget
extern SDL_SetRenderDrawColor
extern SDL_RenderClear
extern SDL_RenderCopy
extern SDL_RenderPresent
;;;;;;;;;;;;;;;

; Libc import
extern exit
;;;;;;;;;;;;;;

run:
    call init_window
    call create_window
    call create_renderer
    call create_texture
    mov r13, 0


loop_0:

    mov rdi, renderer
    mov rsi, texture
    call SDL_SetRenderTarget

    ;;;; DRAW

    mov rdi, renderer
    mov esi, 0
    call SDL_SetRenderTarget
        
    mov rdi, renderer
    mov esi, 0
    mov edx, 255
    mov ecx, 255
    mov r8,  255
    call SDL_SetRenderDrawColor

    mov rdi, renderer
    call SDL_RenderClear

    mov rdi, renderer
    mov rsi, texture
    mov rdx, 0
    mov rcx, 0
    call SDL_RenderCopy

    mov rdi, renderer
    call SDL_RenderPresent

    mov rdi, [delay]
    call SDL_Delay

    inc r13
    cmp r13, 2000000
    jl loop_0


exit_application:
    call close_window
    call exit