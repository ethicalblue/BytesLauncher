extrn ExitProcess : proc
extrn VirtualProtect : proc
extrn CreateFileA : proc
extrn ReadFile : proc
extrn CloseHandle : proc

.const
GENERIC_READ equ 080000000h
OPEN_EXISTING equ 03h
PAGE_EXECUTE_READWRITE equ 40h

.data
payload db 2048 dup (90h) ;change size if you need
oldProtect dword 0
dwReadWritten dword 0
hFile dword 0
szPath db "C:\Users\x\Desktop\dump1.bin", 0

.code
Main proc
    sub rsp, 40h
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 20h], OPEN_EXISTING
    xor r9, r9
    xor r8, r8
    mov rdx, GENERIC_READ
    mov rcx, offset szPath
    call CreateFileA

    mov hFile, eax

    mov qword ptr [rsp + 20h], 0
    mov r9, offset dwReadWritten
    mov r8, sizeof payload
    mov rdx, offset payload
    mov ecx, hFile
    call ReadFile

    mov ecx, hFile
    call CloseHandle

    mov r10, sizeof payload
    sub rsp, 28h
    mov r9, offset oldProtect
    mov r8, PAGE_EXECUTE_READWRITE
    mov rdx, r10
    mov rcx, offset payload
    call VirtualProtect

    mov rax, offset payload
    call rax

    xor rcx, rcx
    call ExitProcess
Main endp
end