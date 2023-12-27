global handle_event

section .data
    keyup_events_msg db "Keyup Event", 10, 0
    keydown_events_msg db "Keydown Event", 10, 0
    event_founded_msg db "Event founded: %d", 10, 0
    no_event_msg            db "No event", 10, 0

section .bss
    event       resb 256  ; SDL_Event is quite large

section .text

; SDL2
extern SDL_PollEvent
;;;;;;;;;;;;;;;;;;;

; LibC
extern printf
;;;;;;;;;;

handle_event:
    ; Initialize SDL
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    lea rdi, [event]
    call SDL_PollEvent

    cmp eax, 0
    je no_event
    jmp event_founded
    
no_event:
    ;mov rdi, no_event_msg
    ;call printf
    jmp end_event_call

event_founded:
    lea esi, [event] ; Load
    mov eax, [esi]

    cmp eax, 0x100 ; Check if event.type is SDL_QUIT
    je exit_app

    cmp eax, 0x300 ; Check if event.type is SDL_KEYDOWN
    je keydown_events

    cmp eax, 0x301  ; Check if event.type is SDL_KEYUP
    je keyup_events

    jmp end_event_call ; if event not keydown, keyup or exit just close

keyup_events:
    mov rdi, keyup_events_msg
    call printf
    jmp end_event_call
    
keydown_events:
    mov rdi, keydown_events_msg
    call printf
    jmp end_event_call

exit_app:
    mov eax, -1
    jmp end_event_call

end_event_call:
    mov rsp, rbp           ; Restore original stack pointer
    pop rbp   
    ret