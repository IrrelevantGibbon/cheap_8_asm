global _start

section .text

; Application import
extern run
;;;;;;;;;;;;;;

_start:
    ; Initialize SDL
    jmp run