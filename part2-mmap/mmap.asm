	global _start		; entry point

	section .text
_start:	mov	rax, 2		; `open` syscall
	mov	rdi, path	; arg1: path
	xor     rsi, rsi	; arg2: flags (0 = O_RDONLY)
        syscall

	; prepare mmap call
	mov	rdi, rax	; fd (from open) to rdi
	sub	rsp, 144	; allocate the 144 bytes (size: courteousy of Amos' little C program)
	mov	rsi, rsp	; addr of 'struct stat' (Where we allocated our buffer.)
	mov	rax, 5		; `fstat` syscall
	syscall

	; And then we can feed our file descriptor, file size, and flags to mmap. 
	; Note	that we can specify an address (but NULL is fine) and an offset 
	;	(but 0 is fine, since we want the whole file).
	mov	rsi, [rsp+48]	; again, 48 is known from the C program's output
	add	rsp, 144	; free `struct stat`
	mov	r8, rdi		; fd
	xor	rdi, rdi	; address = 0
	mov     rdx, 0x1	; protection = PROT_READ
	mov     r10, 0x2        ; flags = MAP_PRIVATE
	xor     r9, r9          ; offset = 0
	mov	rax, 9		; `mmap` syscall
	syscall

	; `rsi` contains size from mmap
        ; write takes the number of bytes to write via `rdx`
        mov	rdx, rsi	; number of bytes
        mov	rsi, rax	; address of buffer (from mmap)
	mov	rax, 1		; `write` syscall
	mov	rdi, 1		; file descriptor (stdout)
        syscall

	mov	rax, 60		; `exit`
	xor	rdi, rdi	; Make sure we exit with 0.
	syscall

	section .data
path:	db	"/etc/hosts", 0	; 0 is string termination
