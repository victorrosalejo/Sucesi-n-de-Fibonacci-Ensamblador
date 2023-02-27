.data
resultado: .asciiz "El resultado es: "
numero_posicion: .word 10

.text
.globl intro 

intro:
#Inicializaci�n de registros a 0
	add $t2,$zero,$zero 
	add $t3,$zero,$zero 
	add $v0,$zero,$zero 
	add $s7,$zero,$zero 
	add $a0,$zero,$zero 
	 	
	lw $v0,numero_posicion
	move $t2, $v0     	 #Con move copios en t2 el valor de v0 
	
	

#Llamamos a la funcion fibo habiendo copiado el valor de n en a0 y v0
	move $a0,$t2 	
	move $v0,$t2
	jal fibo   	 #Llamada a la funci�n fibo
	move $t3,$v0 	 #Guardamos el resultado en t3 para que no se pierda con v0     

#Mensaje de salida con resutlado 
	la $a0,resultado   
	li $v0,4
	syscall

	move $a0,$t3  
	li $v0,1
	syscall

# Fin de programa 
	li $v0,10
	syscall

fibo:
	beqz $a0,cero  	#si a0=0 saltar� a la etiqueta cero
	beq $a0,1,uno   	#si a0=1 saltar� a la etiqueta uno

#Operamos con fibonacci en (n-1)
	sub $sp,$sp,4   	#Creamos espacio en la pila 
	sw $ra,0($sp)   	#Guardamos en la posici�n de pila la direcci�n de retorno
	sub $a0,$a0,1  	#El valor de a0 - 1
	jal fibo     	#Vuelve a ejecutar fibo 
	add $a0,$a0,1
	lw $ra,0($sp)   	#Restaurar la direcci�n de retorno de la pila
	add $sp,$sp,4
	sub $sp,$sp,4   	#Crea un nuevo espacio en pila 
	sw $v0,0($sp)

#Operamos con fibonacci en (n-2)
	sub $sp,$sp,4   	#Almacenar la direcci�n de retorno en la pila
	sw $ra,0($sp)   	#Guarda en el espacio en memoria la direcci�n de retorno
	sub $a0,$a0,2 	#El valor de a0 - 2
	jal fibo  	#Vuelve a ejecutar fibo 
	add $a0,$a0,2
	lw $ra,0($sp)   	#Restaurar la direcci�n de retorno de la pila
	add $sp,$sp,4

	lw $s6,0($sp)   	#Extrae el valor de retorno de la pila
	add $sp,$sp,4
	add $v0,$v0,$s6 	#fibo(n - 2) + fibo(n-1)
	jr $ra 		#Disminuir en la pila

cero:			#Llamada que dar� valor 0 al registro v0
	li $v0,0 
	jr $ra
uno:			#Llamada que dar� valor 1 al registro v0
	li $v0,1
	jr $ra
