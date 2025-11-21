	.file	"params.c"
	.text
	.globl	add
	.type	add, @function
add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	8(%ebp), %edx	# x
	movl	12(%ebp), %eax	# y
	addl	%edx, %eax
	movl	%eax, -4(%ebp)	# z = x + y
	movl	-4(%ebp), %eax	# eax = z
	leave
	ret
	.size	add, .-add
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	$5, -12(%ebp)	# a
	movl	$3, -8(%ebp)	# b
	pushl	-8(%ebp)		# b
	pushl	-12(%ebp)		# a
	call	add
	addl	$8, %esp
	movl	%eax, -4(%ebp)	# c = add(a, b)
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
