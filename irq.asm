[bits 64]

[global are_interrupts_enabled]
are_interrupts_enabled:
	pushf
	pop rax
	shr rax, 9
	and eax, 1
	ret

[global enable_interrupts]
enable_interrupts:
	sti
	ret

[global disable_interrupts]
disable_interrupts:
	cli
	ret