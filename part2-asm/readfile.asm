	global _start		; entry point

	section .text		; instructions
_start:	mov	rax, 2		; `open` syscall
	mov	rdi, path	; arg1: path
	xor     rsi, rsi	; arg2: flags (0 = O_RDONLY)
        syscall

	push	rax		; fd to stack
	sub	rsp, 16		; stack pointer-16: allocate 16 bytes for buffer

read_buffer:
	xor	rax, rax	; `read` syscall
	mov	rdi, [rsp+16]
	mov	rsi, rsp	; buffer address
	mov	rdx, 16		; bufsize
	syscall

	test	rax, rax	; termination EOF?
	jz	exit

	; `rax` contains the number of bytes read
        ; write takes the number of bytes to write via `rdx`
        mov	rdx, rax	; number of bytes
        mov	rax, 1		; `write` syscall
        mov	rdi, 1		; file descriptor (stdout)
        mov	rsi, rsp	; address of buffer
        syscall

	jmp	read_buffer	; loop

exit:
	mov	rax, 60		; `exit`
	xor	rdi, rdi	; Make sure we exit with 0.
	syscall

	section .data
path:	db	"/etc/hosts", 0	; 0 is string termination
