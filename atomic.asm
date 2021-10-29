[bits 64]
%macro CF_RESULT 0
	mov rcx, 1
	mov rax, 0
	cmovnc rax, rcx
%endmacro

[global atomic_lock]
atomic_lock:
	lock bts qword [rdi], rsi
	CF_RESULT
	ret

[global atomic_unlock]
atomic_unlock:
	lock btr qword [rdi], rsi
	CF_RESULT
	ret

[global atomic_spinlock]
atomic_spinlock:
.aquire:
	lock bts qword [rdi], rsi
	jnc .exit
.spin:
	pause
	bt qword [rdi], rsi
	jc .spin
	jmp .aquire
.exit:
	ret

[global atomic_acquire_spinlock]
atomic_acquire_spinlock:
	mov rsi, 0
	call atomic_spinlock
	call atomic_lock

[global atomic_release_spinlock]
atomic_release_spinlock:
	mov rsi, 0
	call atomic_unlock