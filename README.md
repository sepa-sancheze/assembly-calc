<h1>Calculadora en Assembler</h1>

Creación de la calculadora que realiza las operaciones básicas	

	Suma
	Resta
	Multiplicación
	División
	Módulo

<h2>Compilar y ejecutar</h2>

Para realizar dichas operaciones se ejecutan los siguientes comandos:

	nasm -f elf operaciones.asm 			;Ensamblar
	gcc -m32 -o operaciones operaciones.o 		;Compilar
	./operaciones 					;Ejecutar
