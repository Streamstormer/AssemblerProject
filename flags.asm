;****************************************************************
;* program flags.asm : Flag prüfer
;****************************************************************

; Ausgabe von einem string auf dem Bildschirm
%macro print 1
	mov dx,%1
	mov ah,9
	int 21H
%endmacro

ORG 100H
Section .CODE
ORG 100H

; Der Startpunkt des Programms
start:	
  ; Anzeige der momentan aktiven Flags muss hier hin
	mov cx, 4
	pushf
setloop:
	pop ax
	push ax
	mov bx, cx ; benutzte bx als indexregister da cx nicht geht unter dos
	sub bx, 1

	mov dl, [flagconst+bx] 
	;not dl ; mach das Gegenteil daraus
	and al, dl ; maskiere das Flag Bit

	mov ah, 0
	cmp ah, al ; ist das Flag gesetzt
	je back
	jne zero
	mov ah, '1'
	mov [bx+flagstatus], ah ; schreibe Fkagstatus
back:
	loop setloop ; setzte alle 4 Flags in flagstatus
	popf
	jmp main
	
zero:
	mov ah, '0'
	mov [bx+flagstatus], ah ; schreibe Flagstatus
	jmp back

 main:
	print helpText
	pushf
	mov AH,08H ; liest Zeichen von Tastatur ohne Bildschirmecho
	int 21H 
	cmp AL, 42H ; 42 hex ist 'B'
	je Exit
	cmp AL, 41H
	je printFlags
	cmp AL, 5AH
	je testZero
	cmp AL, 50H
	je testParity
	cmp AL, 53H
	je testSign
	cmp AL, 43H
	je testCarry
  jmp main
  
Exit:
	print exitmsg
	mov ah,4CH
	Int 21H



; Ausgabe der Flags binär
printFlags:
	print flagtext
	print flagstatus
	; springe zum start zurück
	jmp start
	
;Check, ob CF gesett oder nicht gesetzt
checkCF:
mov bx,3	;integer
mov ax,'1' 	;ASCII
pushf
comp ax,[flagstatus + bx]	;flagstatus ist ASCII, deshalb ax ASCII
JE changeCarry1
changeCarry0


<<<<<<< HEAD
; Veränderung des zero Flags
testZero:
=======
; Veränderung des zero Flags von 1->0
changeZero1:
	; Code here
	jmp start
	
;Veränderung des zero Flags von 0->1
changeZero0:
>>>>>>> 3f3af95dc4c21786bc34eb8d0258afdb95eb9eec
	; Code here
	jmp start

; Veränderung des Parity Flags von 1->0
changeParity1:
	; Code here
	jmp start
	
; Veränderung des Parity Flags von 0->1
changeParity0:
	; Code here
	jmp start

; Veränderung des Carry Flags von 1->0
changeCarry1:
	; Code here
	jmp start
	
; Veränderung des Carry Flags von 0->1
changeCarry0:
	; Code here
	jmp start

; Veränderung des Sign Flags von 1->0
changeSign1:
	; Code here
	jmp start
	
; Veränderung des Sign Flags von 0->1
changeSign0:
	; Code here
	jmp start

Section .DATA
	; Das Macro chkflags schreibt den Status der Flags in diese Variable
	flagtext db "Sign, Zero, Parity, Carry:",10,13,"$"
	flagstatus db "0000",10,13,"$"
	flagconst db 100000b, 0100000b, 0000100b, 0000001b
  ; Flag status strings
  NotSeT db "Momentan ist kein Flag gesetzt!",10,13,"$"
	ZeroSet db "Momentan ist das Zero Flag gesetzt",10,13,"$"
	ParitySet db "Momentan ist das Parity Flag gesetzt",10,13,"$"
	CarrySet db "Momentan ist das Carry gesetzt",10,13,"$"
	SignSet db "Momentan ist das Sign Flag gesetzt",10,13,"$"

	helpText db "Druecken sie A zum ausgeben der Flags in binaer",10,13,\
				"Druecken sie B zum Beenden des Programms",10,13,\
				"Druecken sie Z zum testen des Zero Flags",10,13,\
				"Druecken sie P zum testen des Parity Flags",10,13,\
				"Druecken sie C zum testen des Carry Flags",10,13,\
				"Druecken sie S zum testen des Sign Flags",10,13,\
				"$"
	exitmsg db "Programm beendet!",10,13,"$"

