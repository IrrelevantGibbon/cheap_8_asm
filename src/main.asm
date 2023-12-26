global _start

section .text

; window management import
extern init_window
extern create_window
extern close_window
extern event
;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Libc import
extern exit
;;;;;;;;;;;;;;

_start:
    ; Initialize SDL
    call init_window
    call create_window
    call close_window
    call exit
