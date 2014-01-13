;****************************************************************
;* program flags.asm : Flag prüfer
;****************************************************************

; Ausgabe von einem string auf dem Bildschirm
%macro print 1
	mov dx,%1
	mov ah,9
	int 21H
%endmacro

; prüfen der Flags und schreiben in flagStatus
%macro chkflags 0
	; code here
%endmacro

ORG 100H
Section .CODE
ORG 100H

; Der Startpunkt des Programms
start:	
  ; Anzeige der momentan aktiven Flags muss hier hin 
	print helpText
	mov AH,08H ; liest Zeichen von Tastatur ohne Bildschirmecho
	int 21H 

	cmp AL, 42H ; 42 hex ist 'B'
	je Exit
  ; example
	jmp printFlags
  ; hier müssen noch die anderen Tasten abgefragt werden
  jmp start
	
Exit:
	print exitmsg
	mov ah,4CH
	Int 21H

; Ausgabe der Flags binär
printFlags:
	; example
	print flagstatus
	; springe zum start zurück
	jmp start

; Veränderung des zero Flags
testZerro:
	; Code here
	jmp start

; Veränderung des Parity Flags
testParity:
	; Code here
	jmp start

; Veränderung des Carry Flags
testCarry:
	; Code here
	jmp start

; Veränderung des Sign Flags
testSign:
	; Code here
	jmp start

Section .DATA
	; Das Macro chkflags schreibt den Status der Flags in diese Variable
	flagstatus db 0,0,0,0,"$"
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
	exitmsg db "Programm beendet!",10,13,"$"T

