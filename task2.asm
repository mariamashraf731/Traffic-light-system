$NOMOD51	 ;to suppress the pre-defined addresses by keil
$include (C8051F020.INC)		; to declare the device peripherals	with it's addresses
ORG 0H					   ; to start writing the code from the base 0


;diable the watch dog
MOV WDTCN,#11011110B ;0DEH
MOV WDTCN,#10101101B ;0ADH

; config of clock`
MOV OSCICN , #14H ; 2MH clock
;config cross bar
MOV XBR0 , #00H
MOV XBR1 , #00H
MOV XBR2 , #040H  ; Cross bar enabled , weak Pull-up enabled 

R_LED BIT P0.5
G_LED BIT P0.6


SETB R_LED
CLR G_LED
MOV P74OUT, #00h

MOV R1, #00H                         ;Digit1 num
MOV R2, #02H                         ;Digit2 num
MOV DPTR, #400H 

INIT: 
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R2
	MOVC A, @A+DPTR
	MOV P2, A

MOV A, P5
ANL A, #08H
CJNE A, #08H, START

MOV A, P5
ANL A, #04H
CJNE A, #04H, INCREMENT

MOV A, P5
ANL A, #02H
CJNE A, #02H, DECREAMENT
SJMP INIT 

INCREMENT:
	CJNE R2 , #09H,INC2
	SJMP INIT
	INC2:
	      CJNE R1, #09H, INC1
	      MOV R1,#00H
	      INC R2
	      ACALL DELAY
	      SJMP INIT
	INC1:
	      INC R1
	      ACALL DELAY
	      SJMP INIT
	
DECREAMENT:
	 CJNE R1 , #00H,DEC_1
	 CJNE R2,#00H, DEC_2
	SJMP INIT
	DEC_1:
	      DEC R1
	      ACALL DELAY
	      SJMP INIT
	DEC_2:
	      MOV R1, #09H
	      DEC R2
	      ACALL DELAY
	      SJMP INIT

START:
	MOV 60H,R1
	MOV 50H,R2
	
	
	JNB P0.2,A0
	JNB P0.3,A1
	JNB P0.4,A2
	L:
	MOV DPTR,#20FH
	MOVC A,@A+DPTR
	MOV 61H,A
	MOV DPTR,#200H
	SJMP MAIN
	
A0:MOV A ,#00H
SJMP L
A1:MOV A ,#01H
SJMP L
A2:MOV A ,#02H
SJMP L

MAIN: 
	ACALL DELAY1
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P1, A
	MOV A, R2 
	MOVC A, @A+DPTR
	MOV P2, A
	
DEC1:
	CJNE R1,#00H,DC1
	MOV R1,#09H
	SJMP DEC2
	DC1:DEC R1
	SJMP MAIN

DEC2:
	CJNE R2,#00H,DC2
	SJMP FINISH
	DC2:DEC R2
	SJMP MAIN
	
FINISH:
	CPL R_LED
	CPL G_LED
	MOV R1,60H
	MOV R2,50H
	SJMP START
		 
	

ORG 400H 
DB   40H,79H,24H,30H,19H,12H,02H,78H,00H,10H
	
ORG 20FH
DB 05H, 0AH, 014H 

	
DELAY:
	MOV R3,#02H
	UP2:MOV R4,#0FFH 
	UP1: MOV R5, #0FFH 
	HERE: DJNZ R5, HERE 
		DJNZ R4, UP1 
		DJNZ R3, UP2 
	RET
	
DELAY1:
	
	MOV R3, 61H
	UP22:MOV R4,#00H 
	UP11: MOV R5, #0C8H
	HERE1: DJNZ R5, HERE1 
		DJNZ R4, UP11 
		DJNZ R3, UP22 
	RET
	

END