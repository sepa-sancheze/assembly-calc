;Operaciones fundamentales con entrada del usuario
extern printf, scanf
%include	'funciones32.asm'
SECTION		.data
	;opciones del menú
	msg_op1	db 		'    ----- Menú -----    ',0h
	msg_op2	db 		'1. Suma',0h
	msg_op3	db 		'2. Resta',0h
	msg_op4	db 		'3. Multiplicación',0h
	msg_op5	db 		'4. División',0h
	msg_op6	db 		'5. Módulo',0h
	msg_op7	db 		'Seleccione una opción: ',0h
	noOp	db 		'Opción incorrecta' , 0h
	pru 	db 		'Prueba ', 0h
	p 		db		'Desea realizar otra operación? (1 = si, 0 = no) ',0h
	;Caracteres para el cuadro
	e1		db		'┌', 0h
	e2 		db		'┐', 0Ah,0h
	e3 		db		'└', 0h
	e4		db		'┘', 0h
	hor		db		'────────────────────────────────────────', 0h
	ver1	db		'│                                        ', 0h
	ver2	db		'                                        │', 0Ah, 0h
	variable dd 	5h
	;Preguntas a realizar
    numero1  db 	`Ingrese el primer número: \n`, 0
    nula1 	db 	`\n`, 0
    numero2 db 	`Ingrese el segundo número: \n`, 0
    fmt     db  `%lf`, 0
    resul    db  `Resultado =  %lf`, 0
    modul	db 	"El modulo es: ",0
    resi	db 	"El residuo es: ",0

SECTION		.bss
	opcion:	resb	1
	n1:		resq 	1	;Reserva de un doble para las variables
    n2:		resq 	1
    respu:  resq 	1
    n11: 	resb 	1
    n21:	resb	1
    r1:		resb	1
SECTION		.text
	extern 	printf
	global main
		main:	
		call	clear		;limpia la pantalla
		call 	recuadro	;genera el recuadro
		mov		ah, 8d
		mov		al, 30d
		call	gotoxy		;va a la posición en pantalla
		mov		eax, msg_op1;muestra el primer mensaje	
		call	println		;Escribe el primer mensaje
		mov		ah, 9d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op2
		call 	println
		mov		ah, 10d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op3
		call 	println
		mov		ah, 11d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op4
		call 	println
		mov		ah, 12d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op5
		call 	println
		mov		ah, 13d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op6
		call 	print
		mov		ah, 14d
		mov		al, 30d
		call	gotoxy
		mov		eax, msg_op7
		call 	print
		mov		ah, 15d
		mov		al, 39d
		call	gotoxy
		;Pide los datos al usuario
		mov		eax, 3		;Invoca el SYS_READ (Kernel opcode 3)
		mov		ebx, 0		;Escribe al archivo STDIN
		mov		ecx, opcion
		mov		edx, 8
		int 	80H
		mov		ecx, opcion
		mov		edx, opcion
		call	chartoint	;convierte la entrada a int para poderda evaluar
		mov		ecx, edx
		call 	readOption	;llamada a la lectura de la opción
		call	quit
	;------------------------------------------------------
	recuadro:
		call	clear
		call 	xy
		mov 	eax, e1
		call	print
		mov 	eax, hor
		call 	print
		mov 	eax, hor
		call 	print
		mov 	eax, e2
		call	print
		mov 	ecx, 24d
		etiqueta:;ciclo para hacer los lados del recuadro
			mov 	[variable], ecx
			mov 	eax, ver1
			call	print
			mov 	eax, ver2
			call	print
			mov 	ecx, [variable]
            loop 	etiqueta
        mov 	eax, e3
		call	print
		mov 	eax, hor
		call 	print
		mov 	eax, hor
		call 	print
		mov 	eax, e4
		call	print
		ret
	repeat:;pide la confirmación si desea seguir en el programa o no
		mov		ah, 17d
		mov		al, 16d
		call	gotoxy
		mov 	eax, p
		call 	print
		mov		eax, 3		;Invoca el SYS_READ (Kernel opcode 3)
		mov		ebx, 0		;Escribe al archivo STDIN
		mov		ecx, opcion
		mov		edx, 8
		int 	80H
		mov		ecx, opcion
		mov		edx, opcion
		call	chartoint	;convierte a entero la opcion ingresada
		mov		ecx, edx
		mov		eax, ecx
		mov		ebx, 1d
		cmp		eax, ebx
		je		main		;si el número es 1 regresa al main
		ret
	readOption:						;lee la opción que está en ecx
		mov		eax, ecx			;comprobaciones para saltar al 
		mov		ebx, 1d 			;método correcto.
		cmp		eax, ebx
		je		suma
		mov		ebx, 2d
		cmp		eax, ebx
		je		resta
		mov		ebx, 3d
		cmp		eax, ebx
		je		multiplicacion
		mov		ebx, 4d
		cmp		eax, ebx
		je		divisionR
		mov		ebx, 5d
		cmp		eax, ebx
		je		modulo
		mov		ah, 16d
		mov		al, 31d
		call	gotoxy
		mov 	eax, noOp 			;mover cadena de error
		call	println
		call 	repeat
		ret
	;suma de flotantes
	suma:
		call 	recuadro			;Crea el recuadro
		push 	ebp
		mov 	ebp, esp
		;lectura primer número
		mov		ah, 9d		
		mov		al, 30d
		call	gotoxy				;Llama a gotoxy
		push 	numero1				;Le pasa la cadena a mostrar
	    call 	printf				;usa la función 
		mov		ah, 10d
		mov		al, 40d
		call	gotoxy
	    push 	n1
	    push 	fmt
	    call 	scanf
	    ;lectura segundo número
	    mov		ah, 11d
		mov		al, 30d
		call	gotoxy
		push 	numero2 			;
	    call 	printf 				;llamada a la función
		mov		ah, 12d
		mov		al, 40d
		call	gotoxy
	    push 	n2
	    push 	fmt
	    call 	scanf

	    fld 	qword 	[n1]
	    fadd 	qword 	[n2] 		;suma los dos primeros números del vector
	    fstp 	qword 	[respu]

		mov		ah, 13d
		mov		al, 32d
		call	gotoxy

	    push 	dword 	[respu + 4]	;convierte el número a double
	    push 	dword 	[respu + 0]
	    push 	resul 				;Pasa el formato del resultado
	    call 	printf 				;Llama a la función con el formato 
	    ;Llamar a printf solo para que muestre la cadena
	    push 	nula1 				;Le pasa la cadena a mostrar
	    call 	printf				;usa la función 
	    mov 	esp, ebp
	    pop 	ebp
	    call 	repeat
	    ret
	resta:
		call 	recuadro
		push 	ebp
		mov 	ebp, esp
		;lectura primer número
		mov		ah, 9d
		mov		al, 30d
		call	gotoxy
		push 	numero1
	    call 	printf
		mov		ah, 10d
		mov		al, 40d
		call	gotoxy
	    push 	n1
	    push 	fmt
	    call 	scanf
	    ;lectura segundo número
	    mov		ah, 11d
		mov		al, 30d
		call	gotoxy
		push 	numero2
	    call 	printf
		mov		ah, 12d
		mov		al, 40d
		call	gotoxy
	    push 	n2
	    push 	fmt
	    call 	scanf
	    fld 	qword 	[n1]
	    fsub 	qword 	[n2]
	    fstp 	qword 	[respu]

	    mov		ah, 13d
		mov		al, 32d
		call	gotoxy

	    push 	dword 	[respu + 4]
	    push 	dword 	[respu + 0]
	    push 	resul
	    call 	printf
	    ;Llamar a printf solo para que muestre la cadena
	    push 	nula1 				;Le pasa la cadena a mostrar
	    call 	printf				;usa la función 
	    mov 	esp, ebp
	    pop 	ebp
	    call 	repeat
	    ret
	multiplicacion:
		call 	recuadro
		push 	ebp
		mov 	ebp, esp
		;lectura primer número
		mov		ah, 9d
		mov		al, 30d
		call	gotoxy
		push 	numero1
	    call 	printf
		mov		ah, 10d
		mov		al, 40d
		call	gotoxy
	    push 	n1
	    push 	fmt
	    call 	scanf
	    ;lectura segundo número
	    mov		ah, 11d
		mov		al, 30d
		call	gotoxy
		push 	numero2
	    call 	printf
		mov		ah, 12d
		mov		al, 40d
		call	gotoxy
	    push 	n2
	    push 	fmt
	    call 	scanf

	    fld 	qword 	[n1]
	    fmul 	qword 	[n2]
	    fstp 	qword 	[respu]

	    mov		ah, 13d
		mov		al, 32d
		call	gotoxy

	    push 	dword 	[respu + 4]
	    push 	dword 	[respu + 0]
	    push 	resul
	    call 	printf
	    ;Llamar a printf solo para que muestre la cadena
	    push 	nula1 				;Le pasa la cadena a mostrar
	    call 	printf				;usa la función 
	    mov 	esp, ebp
	    pop 	ebp
	    call 	repeat
	    ret
	divisionR:
		call 	recuadro
		push 	ebp
		mov 	ebp, esp
		;lectura primer número
		mov		ah, 9d
		mov		al, 30d
		call	gotoxy
		push 	numero1
	    call 	printf
		mov		ah, 10d
		mov		al, 40d
		call	gotoxy
	    push 	n1
	    push 	fmt
	    call 	scanf
	    ;lectura segundo número
	    mov		ah, 11d
		mov		al, 30d
		call	gotoxy
		push 	numero2
	    call 	printf
		mov		ah, 12d
		mov		al, 40d
		call	gotoxy
	    push 	n2
	    push 	fmt
	    call 	scanf

	    fld 	qword 	[n1]
	    fdiv 	qword 	[n2]
	    fstp 	qword 	[respu]

	    mov		ah, 13d
		mov		al, 32d
		call	gotoxy

	    push 	dword 	[respu + 4]
	    push 	dword 	[respu + 0]
	    push 	resul
	    call 	printf
	    ;Llamar a printf solo para que muestre la cadena
	    push 	nula1 				;Le pasa la cadena a mostrar
	    call 	printf				;usa la función 
	    mov 	esp, ebp
	    pop 	ebp
	    call 	repeat
	    ret
	modulo:
		call 	clear
		call 	recuadro
		mov 	ah, 9d
		mov 	al, 30d
		call 	gotoxy
		mov 	eax, numero1
		call	print

		mov 	ah, 10d
		mov 	al, 39d
		call 	gotoxy
		mov		eax, 3		;Invoca el SYS_READ (Kernel opcode 3)
		mov		ebx, 0		;Escribe al archivo STDIN
		mov		ecx, n11
		mov		edx, 8
		int 	80H
		mov		ecx, n11
		mov		edx, n11
		call	chartoint
		mov		eax, edx
		push	eax

		mov 	ah, 11d
		mov 	al, 30d
		call 	gotoxy
		mov 	eax, numero2
		call	print

		mov 	ah, 12d
		mov 	al, 39d
		call 	gotoxy

		mov		eax, 3		;Invoca el SYS_READ (Kernel opcode 3)
		mov		ebx, 0		;Escribe al archivo STDIN
		mov		ecx, n21
		mov		edx, 8
		int 	80H
		mov		ecx, n21
		mov		edx, n21
		call	chartoint
		mov 	eax, edx
		mov 	ebx, eax
		mov 	ecx, 0000
		mov 	edx, 0000
		pop		eax
		idiv	ebx
		push 	edx
		mov 	ecx, edx
		push 	eax

		mov 	ah, 14d
		mov 	al, 30d
		call 	gotoxy
		mov 	eax, modul
		call 	print
		pop 	eax
		call 	prInt
		;pop 	edx
		mov 	ah, 15d
		mov 	al, 30d
		call 	gotoxy
		mov 	eax, resi
		call 	print
		pop 	edx
		mov 	eax, edx
		call 	prInt
		call	gotoxy
		call 	repeat
		ret
