global run

section .data
    delay   dd 16
    quit    dd 0
    event_founded_msg db "Event founded: %d", 10, 0
    no_event_msg            db "No event", 10, 0
    bite db "bite : %d", 10, 0

section .text
; window management import
extern init_window
extern create_window
extern create_renderer
extern create_texture
extern close_window
extern draw_on_window

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

    lea rdi, [event]
    call SDL_PollEvent
    call handle_event

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

handle_event:

    ; Initialize SDL
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    cmp eax, 0
    je no_event
    jmp event_founded
    

no_event:
    mov rdi, no_event_msg
    call printf

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp   
    ret

event_founded:
    lea esi, [event]
    ;mov rdi, event_founded_msg
    ;lea esi, [event]
    ;call printf

    mov eax, [esi]
    cmp eax, 0x100
    je exit_application

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

