[bits 64]


[global memcpy]
memcpy:
	mov rax, rdi
	mov rcx, rdx
	shr rcx, 3
	and edx, 7
	rep movsq
	mov ecx, edx
	rep movsb
	ret


[global memset]
memset:
	mov r9, rdi
	mov rcx, rdx
	shr rcx, 3
	and edx, 7
	movsx esi, sil
	mov rax, 0x0101010101010101
	imul rax, rsi
	rep stosq
	mov ecx, edx
	rep stosb
	mov rax, r9
	ret

[global memcmp]
memcmp:
	test edx, edx
	je .out_ok
	mov edx, edx
	xor eax, eax
	jmp .skip_loop
.loop:
	add rax, 1
	cmp rdx, rax
	je .out_ok
.skip_loop:
	movzx ecx, BYTE [rdi+rax]
	movzx r8d, BYTE [rsi+rax]
	cmp cl, r8b
	je .loop
	movzx eax, cl
	sub eax, r8d
	ret
.out_ok:
	xor eax, eax
	ret