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
	and al, dl ; maskiere das Flag Bit

	mov ah, 0
	cmp ah, al ; ist das Flag gesetzt
	je zero
	mov ah, '1'
	mov [bx+flagstatus], ah ; schreibe Flagstatus
back:
	sub cx, 1
	cmp cx, 0
	jne setloop ; setzte alle 4 Flags in flagstatus
	jmp main
	
zero:
	mov ah, '0'
	mov [bx+flagstatus], ah ; schreibe Flagstatus
	jmp back

 main:
	print new 
	print Striche
	print flags
	pop ax
	push ax
	and al, [4+flagconst]
	cmp al, 0
	jne next
	print NotSet
	jmp next3
next:
	mov bl,[flagstatus]
	mov al, '1'
	cmp al, bl
	jne next0
	print SignSet
next0:
	mov bl,[1+flagstatus]
	mov al, '1'
	cmp al, bl
	jne next1
	print ZeroSet
next1:
	mov bl,[2+flagstatus]
	mov al, '1'
	cmp al, bl
	jne next2
	print ParitySet
next2:
	mov bl,[3+flagstatus]
	mov al, '1'
	cmp al, bl
	jne next3
	print CarrySet
next3:
	print new 
	print Striche
	print helpText
	mov AH,08H ; liest Zeichen von Tastatur ohne Bildschirmecho
	int 21H 
	cmp AL, 42H ; 42 hex ist 'B'
	je Exit
	cmp AL, 41H
	je printFlags
	cmp AL, 5AH
	je checkZF
	cmp AL, 50H
	je checkPF
	cmp AL, 53H
	je checkSF
	cmp AL, 43H
	je changeCF
	jmp main
  
Exit:
	print exitmsg
	mov ah,4CH
	Int 21H



; Ausgabe der Flags binär
printFlags:
	print Striche
	print binflags
	print flagtext
	print flagstatus
	print Striche
	; springe zum start zurück
	popf
	jmp start
	
;Check, ob CF gesetzt oder nicht gesetzt
changeCF:
	popf
	cmc
	print Striche
	print CarryText
	print Striche
	jmp start

checkZF:
	; Code here
	mov bl, [1+flagstatus]
	mov al, '1'
	cmp al, bl
	JE changeZero1
	JNE changeZero0
	
checkPF:
	; Code here
	mov bx, [2+flagstatus]
	mov al, '1'
	cmp al, bl
	JE changeParity1
	JNE changeParity0
	
checkSF:
	; Code here
	mov bl,[flagstatus]
	mov al, '1'
	cmp al, bl
	JE changeSign1
	JNE changeSign0

; Veränderung des zero Flags von 1->0
changeZero1:
	; Code here
	pop ax
	and ax ,10111111b
	push ax
	popf
	print Striche
	print ZeroText
	print Striche
	jmp start
	
;Veränderung des zero Flags von 0->1
changeZero0:
	; Code here
	pop ax
	or ax, 01000000b
	push ax
	popf
	print Striche
	print ZeroText
	print Striche
	jmp start
; Veränderung des Parity Flags von 1->0
changeParity1:
	; Code here
	pop ax
	and ax, 11111011b
	push ax
	popf
	print Striche
	print ParityText
	print Striche
	jmp start
	
; Veränderung des Parity Flags von 0->1
changeParity0:
	; Code here
	pop ax
	or ax, 00000100b
	push ax
	popf
	print Striche
	print ParityText
	print Striche
	jmp start


; Veränderung des Sign Flags von 1->0
changeSign1:
	; Code here
	pop ax
	and ax, 01111111b
	push ax
	popf
	print Striche
	print SignText
	print Striche
	jmp start
	
; Veränderung des Sign Flags von 0->1
changeSign0:
	; Code here
	pop ax
	or ax, 10000000b
	push ax
	popf
	print Striche
	print SignText
	print Striche
	
	jmp start

Section .DATA
	; Das Macro chkflags schreibt den Status der Flags in diese Variable
	binflags db "Binaere Ausgabe der Flags",10,13,"$"
	flagtext db "Reihenfolge - Sign, Zero, Parity, Carry:  $"
	flagstatus db "0000",10,13,"$"
	flagconst db 10000000b, 01000000b, 0000100b, 0000001b, 11000101b
    ; Flag status strings
	flags db "Status der Flags:",10,13,"$"
    NotSet db "Momentan ist kein Flag gesetzt!",10,13,"$"
	ZeroSet db "Momentan ist das Zero Flag gesetzt",10,13,"$"
	ParitySet db "Momentan ist das Parity Flag gesetzt",10,13,"$"
	CarrySet db "Momentan ist das Carry gesetzt",10,13,"$"
	SignSet db "Momentan ist das Sign Flag gesetzt",10,13,"$"
	Striche db "_________________________________________",10,13,"$"
	new db 10,13,"$"
	
	ZeroText db 10,13,"Das Zero Flag wurde geaendert.",10,13,10,13,"$"
	CarryText db 10,13,"Das Carry Flag wurde geaendert.",10,13,10,13,"$"
	ParityText db 10,13,"Das Parity Flag wurde geaendert.",10,13,10,13,"$"
	SignText db 10,13,"Das Sign Flag wurde geaendert.",10,13,10,13,"$"

	helpText db "Hilftext:",10,13,\
				"Druecken sie A zum ausgeben der Flags in binaer",10,13,\
				"Druecken sie B zum Beenden des Programms",10,13,\
				"Druecken sie Z zum testen des Zero Flags",10,13,\
				"Druecken sie P zum testen des Parity Flags",10,13,\
				"Druecken sie C zum testen des Carry Flags",10,13,\
				"Druecken sie S zum testen des Sign Flags",10,13,\
				"$"
	exitmsg db "Programm beendet!",10,13,"$"

