@.equ		lengthfirst,	r6
@.equ		lengthsecond,	r8
@ Code section
.section    .text

.global main
main: 
      
            bl      InitUART        	@ Initialize the UART

            ldr     r0, =names    	@ String pointer
            mov     r1, #32       	@ String's length
            bl      WriteStringUART 	@ Write the string to the UART

			ldr		r0, =command
			mov		r1, #25
			bl		WriteStringUART

            ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read.        	

checkInput:
			@Check if the value entered is three; if not, check for two
			
			cmp		r0, #3
			beq		checkforA
			b		checkforO
			
checkforA:
			ldrb	r6, =charBuffer
			ldrb	r7, [r6, #0]		@Loads the first byte - which would be the place for Letter A
			cmp		r7, #'A'
			beq		contcheckA
			b		notrecog

checkforO:
			ldrb	r6, =charBuffer
			ldrb	r7, [r6, #0]
			cmp		r7, #'O'
			beq		contcheckB
			b		notrecog
			
contcheckA:
			ldrb	r6, =charBuffer
			ldrb	r7, [r6, #1]
			cmp		r7, #'N'
			beq		finalA
			b		notrecog

contcheckB:
			ldrb	r6, =charBuffer
			ldrb	r7, [r6, #1]
			cmp		r6, #'R'
			beq		operationOR
			b		notrecog
			
finalA:
			ldrb	r6, =charBuffer
			ldrb	r7, [r6, #2]
			cmp		r7, #'D'
			beq		operationAND
			b		notrecog
			
operationOR:
			ldr     r0, =firstbinary
			mov		r1, #36
			bl		WriteStringUART
			
			ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered.
            mov		r5, #0
            mov		r4, r0
            
enterfirst:
			ldr		r0, =firstbinary
			mov		r1, #37
			bl		WriteStringUART

            ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read
					            
checkBinary:
			ldrb	r6, =charBuffer
			cmp		r5, r4
			bge		entersecond
			
continue:	
            ldrb	r7, [r6, r5]
            cmp		r7, #0
            bne		checkone
            strb	r7, [r8, r5]
            add		r5, r5, #1
            b		checkBinary
            
checkone:
			cmp		r7, #1
			bne		wrongnum
			strb	r7, [r8, r5]
			add		r5, r5, #1
			b		checkBinary
			
entersecond:
			ldr		r0, =secondbinary
			mov		r1, #38
			bl		WriteStringUART

            ldr     r0, =charBuffer     @ buffer address
            mov     r1, #64    		@ buffer size
            bl      ReadLineUART 	@ Read from the UART until a new line is encountered. 
					@ R0 = number of ASCII characters read
			mov		r9, r0			@Value of length
			mov		r10, #0			@int i=0

checkbin:
			ldrb	r11, =charBuffer		@load base address
			cmp		r10, r9
			bge		entersec
			
cont:	
            ldrb	r12, [r10, r9]
            cmp		r9, #0
            bne		check1
            strb	r11, [r8, r5]
            add		r5, r5, #1
            b		checkBinary
            
check1:
			cmp		r7, #1
			bne		wrongnum
			strb	r7, [r8, r5]
			add		r5, r5, #1
			b		checkBinary			

performOR:	

operationAND:
			
			
notrecog:
			ldr		r0, =commanderror
			mov		r1, #25
			bl		WriteStringUART
			
wrongnum:
			ldr		r0, =formaterror
			mov		r1, #20
			bl		WriteStringUART
haltLoop$:  
		b       haltLoop$

@ Data section
.section    .data

names:
.ascii 		"Elis Frroku and Shoumik Shill!\r\n"

command:
.ascii		"Please enter a command:\r\n"

firstbinary:
.ascii		"Please enter the first binary number:"

secondbinary:
.ascii		"Please enter the second binary number:"

formaterror:
.ascii		"Wrong number format!"

result:
.ascii		"The result is:"

commanderror:
.ascii		"Command not recognized!"

AND:
.ascii		"AND"

OR:
.ascii		"OR"

success:
.ascii		"success"

failure:
.ascii		"failure"

charBuffer:
.rept		64
.byte		0
.endr
