global run

section .data
    delay   dd 16
    quit    dd 0

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
    call init_window
    call create_window
    call create_renderer
    call create_texture

loop_0:

    call handle_event
    cmp eax, -1
    je exit_application

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
    call exit
    ret