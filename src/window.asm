global event, window, renderer, texture
global init_window, create_window, create_renderer, create_texture, draw_on_window, close_window

struc Rect
    x: resd 1
    y: resd 1
    w: resd 1
    h: resd 1
endstruc


section .data
    window_title     db 'SDL Window', 0
    window_width     dd 640
    window_height    dd 480

    screen_rect:
        istruc Rect
            at x, dd 0; x
            at y, dd 0; y
            at w, dd 640; width
            at h, dd 480; height
        iend

    pixel_rect:
        istruc Rect
            at x, dd 0; x
            at y, dd 0; y
            at w, dd 1; width
            at h, dd 1; height
        iend


    init_msg            db "SDL_Init Worked", 10, 0
    init_err_msg        db "SDL_Init Error: %s", 10, 0

    window_msg          db "SDL_CreateWindow Worked", 10, 0
    window_msg_err      db "SDL_CreateWindow Error: %s", 10, 0

    create_renderer_msg     db "SDL_CreateRenderer Worked", 10, 0
    create_renderer_err db "SDL_CreateRenderer Error: %s", 10, 0 

    create_texture_msg db "SDL_CreateTexture Worked", 10, 0
    create_texture_err db "SDL_CreateTexture Error: %s", 10, 0


    texture_destroyed_msg db "SDL_DestroyTexture Worked", 10, 0
    window_destroyed_msg    db "SDL_DestroyWindow Worked", 10, 0
    renderer_destroyed_msg db "SDL_DestroyRenderer Worked", 10, 0
    sql_quit_msg        db "SDL_QUIT Worked", 10, 0


section .bss
    window      resq 1
    renderer    resq 1
    texture     resq 1
    event       resb 256  ; SDL_Event is quite large

section .text
; Settings import
extern window_w
extern window_h
extern window_n
extern surface_w
extern surface_h
;;;;;;;;;;;;;;;;;;

; SDL Import
extern SDL_Init
extern SDL_GetError
extern SDL_CreateWindow 
extern SDL_CreateRenderer
extern SDL_CreateTexture
extern SDL_PollEvent
extern SDL_DestroyWindow
extern SDL_DestroyRenderer
extern SDL_DestroyTexture
extern SDL_RenderFillRect
extern SDL_SetRenderDrawColor
extern SDL_Quit
;;;;;;;;;;;;;;;;;;;;;;;;;


; LibC import
extern printf
extern exit
;;;;;;;;;;;;;

init_window:
    ; Initialize SDL
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    mov edi, 0x00000020    ; SDL_INIT_VIDEO flag
    call SDL_Init          ; Call SDL_Init
    ; Check return value here for errors (eax will contain the return value)

    cmp eax, 0             ; Check if SDL_Init returned a non-zero error code
    jg init_window_error         ; If no error, skip error handling

    mov rdi, init_msg      ; mov message into register rdi
    call printf            ; call printf

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

init_window_error:
    call SDL_GetError      ; get sdl error string
    mov rsi, rax           ; move return value of sdl_error to rsi
    mov rdi, init_err_msg  ; move string to rdi
    call printf            ; call printf
    call exit              ; exit the application

create_window:
    ; Create SDL WINDOW
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    lea     rdi, [window_title]
    mov     esi, 100 ; x position
    mov     edx, 100 ; y position
    mov     ecx, [window_width]
    mov     r8, [window_height]
    mov     r9, 0
    call    SDL_CreateWindow

    cmp rax, 0  ; Check if therer is no error for creation of the window
    je create_window_error ; if error jump to print error else continue

    mov     [window], rax

    mov rdi, window_msg      ; mov message into register rdi
    call printf            ; call printf

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

create_window_error:
    call SDL_GetError      ; get sdl error string
    mov rsi, rax           ; move return value of sdl_error to rsi
    mov rdi, window_msg_err  ; move string to rdi
    call printf            ; call printf
    call exit              ; exit the application

create_renderer:
    ; Create Renderer
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer
    

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    mov rdi, [window]
    mov esi, -1
    mov edx, 2
    call SDL_CreateRenderer

    cmp rax, 0
    je create_renderer_error

    mov [renderer], rax

    mov rdi, create_renderer_msg  ; mov message into register rdi
    call printf            ; call printf

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

create_renderer_error:
    call SDL_GetError      ; get sdl error string
    mov rsi, rax           ; move return value of sdl_error to rsi
    mov rdi, create_renderer_err  ; move string to rdi
    call printf            ; call printf
    call exit              ; exit the application

create_texture:
    ; Create texture
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    mov rdi, [renderer]
    mov esi, 0
    mov edx, 2
    mov ecx, [surface_w]
    mov r8,  [surface_h]
    call SDL_CreateTexture

    cmp eax, 0
    je create_texture_error

    mov [texture], rax

    mov rdi, create_texture_msg
    call printf

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret                    ; Return from function

create_texture_error:
    call SDL_GetError      ; get sdl error string
    mov rsi, rax           ; move return value of sdl_error to rsi
    mov rdi, create_texture_err  ; move string to rdi
    call printf            ; call printf
    call exit              ; exit the application


draw_on_window:
    ;  DRAW
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned


    mov rdi, [renderer]
    mov esi, 0
    mov edx, 0
    mov ecx, 0
    mov r8,  255
    call SDL_SetRenderDrawColor

    mov rdi, [renderer]
    mov esi, [screen_rect]
    call SDL_RenderFillRect

    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret

close_window:
    ; Close SDL window
    push rbp               ; Save base pointer
    mov rbp, rsp           ; Set base pointer to current stack pointer

    ; Align the stack to 16 bytes
    and rsp, -16           ; Ensure rsp is 16-byte aligned

    mov rdi, texture
    call SDL_DestroyTexture

    mov rdi, texture_destroyed_msg
    call printf

    mov rdi, renderer
    call SDL_DestroyRenderer

    mov rdi, renderer_destroyed_msg
    call printf

    mov     rdi, [window]
    call    SDL_DestroyWindow

    mov rdi, window_destroyed_msg
    call printf

    call    SDL_Quit

    mov rdi, sql_quit_msg
    call printf
    
    mov rsp, rbp           ; Restore original stack pointer
    pop rbp                ; Restore original base pointer
    ret

print_error:
    call SDL_GetError      ; get sdl error string
    mov rsi, rax           ; move return value of sdl_error to rsi
    call printf            ; call printf
    call exit              ; exit the application