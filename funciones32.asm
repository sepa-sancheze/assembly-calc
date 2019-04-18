;bloque de funciones de tratamiento de cadenas para assembler
SECTION	.data
	nula	db	0Ah,0h
	vacia	db	' ',0Ah, 0h
	escSeq 	db 27,"[2J"
    escLen 	equ 4
    prin 	db 27
    goto    db 27,"[00;00H"
   	longi   equ 8
   	posyx	db 1Bh, '[01;01H', 0h
;------------------------------------------------------
;Imprime un número entero
prInt:
	push	eax
	push	ecx
	push	edx
	push	esi
	mov		ecx, 0		;llevará la cuenta de caracteres a imprimir
loopDiv:
	inc		ecx
	mov		edx, 0
	mov		esi, 10
	idiv	esi			;divide edx, esi
	add		edx, 48		;convierte el resultado en el caracter numérico
	push	edx			;introduce el caracter a la pila
	cmp		eax, 0		;verifica si aún puede dividirse
	jnz		loopDiv
printLoop:
	dec		ecx
	mov		eax, esp
	call	print
	pop		eax
	cmp		ecx, 0
	jnz		printLoop
	pop		esi
	pop		edx
	pop		ecx
	pop		eax
	ret
;-----------------------------------------------------
;Imprime número seguido de salto de línea
prIntln:
	call	prInt
	push	eax
	mov		eax, 0Ah
	push	eax
	mov		eax, esp
	call	print
	pop		eax
	pop		eax
	ret
;------------------------------------------------------
;length devuelve el tamaño de una cadena enviada en eax
length:
	push	ebx
	mov		ebx, eax
nextchar:
	cmp		byte [eax], 0
	jz		fincadena
	inc		eax
	jmp		nextchar
fincadena:
	sub		eax, ebx
	pop		ebx
	ret
;------------------------------------------------------------
;print imprime en pantalla una cadena enviada en eax
print:
	push	edx
	push	ecx
	push	ebx
	push	eax
	call	length
	mov		edx, eax
	pop		eax
	mov		ecx, eax
	mov		eax, 04h
	mov		ebx, 01h
	int		80h
	pop		ebx
	pop		ecx
	pop		edx
	ret
;-------------------------------------------------------
;println imprime cadena y un ENTER
println:
	call	print
	push	eax
	mov		eax, 0Ah
	push	eax
	mov		eax, esp
	call	print
	pop		eax
	pop		eax
	ret
;-------------------------------
;void strUpcase(String message)
;convertir una cadena a mayúsculas
strUpcase:
	push	ebx
	mov		ebx, eax
nextcharUp:
	cmp		byte [eax], 0
	je		finalUC
	cmp		byte [eax], 97
	jl		incUP
	cmp		byte [eax], 122
	jg		incUP
	sub		byte [eax], 32
incUP:
	inc		eax
	jmp		nextcharUp
finalUC:
	mov		eax, ebx
	pop		ebx
	ret
;-------------------------------
;void strLocase(String message)
;convertir una cadena en minúsculas
strLocase:
	push	ebx
	mov		ebx, eax
nextcharLo:
	cmp		byte [eax], 0
	je		finalLC
	cmp		byte [eax], 65
	jl		incLC
	cmp		byte [eax], 90
	jg		incLC
	add		byte [eax], 32
incLC:
	inc		eax
	jmp		nextcharLo
finalLC:
	mov		eax, ebx
	pop		ebx
	ret
;--------------------------------------------------------
;quit: función que finaliza el programa
quit:
	mov		ebx, 0
	mov		eax, 1
	int		80h
	ret
;------------------------------------------------------
;clear -> limpia la pantalla
clear:
   	mov 	eax,4
   	mov 	ebx,1
   	mov 	ecx, escSeq
   	mov 	edx, escLen
   	int 	80h
xy:;va a 0,0
	mov 	eax,4
   	mov 	ebx,1
   	mov 	ecx, goto
   	mov 	edx, longi
   	int 	80h
   	ret
;------------------------------------------------------
;convierte un string a int
chartoint:
	push	eax
	push	ebx
	xor		eax, eax
comparar:
	movzx	ecx, byte[edx]
	inc 	edx
	cmp 	ecx, 30h
	jb		fincomp
	cmp 	ecx, 39h
	ja		fincomp
	sub		ecx, 30h
	imul	eax, 10
	add		eax, ecx
	jmp		comparar
fincomp:
	mov 	edx, eax
	pop 	ebx
	pop 	eax
	ret
;----------------------- Función posicion x, y en pantalla
gotoxy:
	push	eax
	push	ebx
	push	ecx
	push	edx
	;----inicializa variables
	mov 	bh, ah
	mov 	bl, al
	mov 	esi, 10
	mov 	ecx, posyx
	;-----coordenada y
	xor		eax, eax
	xor		edx, edx
	mov 	al, bh
	idiv	esi
	add		eax, 48
	add		edx, 48
	mov 	byte [ecx + 2], al ; valor n1
	mov 	byte [ecx + 3], dl ; valor n2
	;----coordenada x
	xor		eax, eax
	xor		edx, edx
	mov 	al, bl
	idiv 	esi
	add		eax, 48
	add		edx, 48
	mov 	byte [ecx + 5], al ; valor n1
	mov 	byte [ecx + 6], dl ; valor n2
	;--------------
	mov 	eax, posyx
	call	print
	pop 	eax
	pop 	ebx
	pop 	ecx
	pop 	edx
	ret