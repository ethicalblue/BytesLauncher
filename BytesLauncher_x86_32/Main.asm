.686p
.model flat, stdcall
option casemap:none

ExitProcess proto stdcall :dword
VirtualProtect proto stdcall :dword,:dword,:dword,:dword
CreateFileA proto stdcall :dword, :dword, :dword, :dword, :dword, :dword, :dword
ReadFile proto stdcall :dword, :dword, :dword, :dword, :dword
CloseHandle proto stdcall :dword

.const
    GENERIC_READ equ 080000000h
    OPEN_EXISTING equ 03h

.data
    payload db 2048 dup (90h) ;change size if you need
    oldProtect dword 0
    dwReadWritten dword 0
    hFile dword 0
    szPath db "C:\\Users\\x\\Desktop\\dump1.bin", 0
.code
Main proc
    
    push 0
    push 0
    push OPEN_EXISTING
    push 0
    push 0
    push GENERIC_READ
    push offset szPath
    call CreateFileA

    mov hFile, eax

    push 0
    push offset dwReadWritten
    push sizeof payload
    push offset payload
    push eax
    call ReadFile

    push hFile
    call CloseHandle

    push offset oldProtect
    push 40h ;PAGE_EXECUTE_READWRITE
    push sizeof payload
    push offset payload
    call VirtualProtect

    mov eax, offset payload
    call eax ;execute payload bytes

    push 0
    call ExitProcess
Main endp
end