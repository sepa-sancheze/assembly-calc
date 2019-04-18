Calculadora en Assembler

Creación de la calculadora que realiza las operaciones básicas	

	Suma
	Resta
	Multiplicación
	División
	Módulo

Compilar y ejecutar

Para realizar dichas operaciones se ejecutan los siguientes comandos:

	nasm -f elf operaciones.asm 			;Ensamblar
	gcc -m32 -o operaciones operaciones.o 		;Compilar
	./operaciones 					;Ejecutar
