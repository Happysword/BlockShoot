

;;;;;;;MACROS;;;;;;;;;;;


;CHECK IF A BULLET HIT THE BLOCK FOR THE RIGTH BLOCKS
BlockChecker1  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITBLOCKCHECKER1

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKER1 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME X 
JB EXITBLOCKCHECKER1                          
                                              
MOV BX,BLOCKYY    
sub bx,5                            
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKER1                          
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKER1

MOV word ptr [si],0
MOV word ptr [di],0
inc Player1Score
DELETEABLOCK BLOCKXX,BLOCKYY
MOV BLOCKDRAWNNUMBER,0

EXITBLOCKCHECKER1:
ENDM

BlockCheckermiddle1  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITBLOCKCHECKERMIDDLE1

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKERMIDDLE1 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME first X 
JB EXITBLOCKCHECKERMIDDLE1      

MOV BX,BLOCKXX  
ADD BX,BlockwidthMiddle+20               
cmp word ptr [di],BX  ;CHECK IF AT THE SAME  last X 
JG EXITBLOCKCHECKERMIDDLE1                          
                                              
MOV BX,BLOCKYY   
sub bx,5                             
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKERMIDDLE1                          
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                           
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKERMIDDLE1

MOV word ptr [si],0
MOV word ptr [di],0

EXITBLOCKCHECKERMIDDLE1:
ENDM


;CHECK IF A BULLET HIT THE BLOCK FOR THE LEFT BLOCKS
BlockChecker2  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITBLOCKCHECKER2

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKER2 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME X 
JG EXITBLOCKCHECKER2                          
                                              
MOV BX,BLOCKYY     
sub bx,5                           
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKER2                         
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKER2

MOV word ptr [si],0
MOV word ptr [di],0
inc Player2Score
DELETEABLOCK BLOCKXX,BLOCKYY
MOV BLOCKDRAWNNUMBER,0

EXITBLOCKCHECKER2:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BlockCheckermiddle2  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITBLOCKCHECKERMIDDLE2

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKERMIDDLE2 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME first X 
JG EXITBLOCKCHECKERMIDDLE2     
               
MOV BX,BLOCKXX  
sub bx,BlockwidthMiddle+20                              
cmp word ptr [di],BX  ;CHECK IF AT THE SAME last X 
JL EXITBLOCKCHECKERMIDDLE2                          
                                              
MOV BX,BLOCKYY  
sub bx,5                              
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKERMIDDLE2                         
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKERMIDDLE2

MOV word ptr [si],0
MOV word ptr [di],0

EXITBLOCKCHECKERMIDDLE2:
ENDM


;DRAW A BLOCK MACRO
DRAWABLOCK MACRO BLOCKX,BLOCKY ,BCOLOR
	LOCAL @@DRAW,@@BACK  ;BECAUSE WE NEED TO CALL MACROS MORE THAN ONCE MUST USE LOCAL NUMERIC LABELS ;REGULAR LABELS WONT WORK
	MOV BX,00
	ADD BX,BLOCKY
	ADD BX,Blockheight  ;PUTTING IN BX BLOCK MAX LENGTH
	@@DRAW:
		MOV CX,BLOCKX	;DRAWING PIXELS HORIZONTALLY
		MOV DX,BLOCKY	
		MOV AL,BCOLOR	    ;CHOOSING COLOR
		MOV AH,0CH
	@@BACK:
		INT 10H
		INC CX
		ADD BLOCKX,Blockwidth  ;BLOCK MAX WIDTH
		CMP CX,BLOCKX
		PUSHF			;ADJUSTING FLAGS
		SUB BLOCKX,Blockwidth  
		POPF
		JNZ @@BACK   ;TILL HERE
		
	INC BLOCKY			
	CMP BLOCKY,BX
	JNE @@DRAW 		;KEEP DRAWING HORIZONTALLY
	SUB BLOCKY,Blockheight   

ENDM

;DRAW A BLOCK MACRO
DRAWABLOCKMIDDLE MACRO BLOCKX,BLOCKY ,BCOLOR
	LOCAL @@DRAW,@@BACK  ;BECAUSE WE NEED TO CALL MACROS MORE THAN ONCE MUST USE LOCAL NUMERIC LABELS ;REGULAR LABELS WONT WORK
	MOV BX,00
	ADD BX,BLOCKY
	ADD BX,Blockheight  ;PUTTING IN BX BLOCK MAX LENGTH
	@@DRAW:
		MOV CX,BLOCKX	;DRAWING PIXELS HORIZONTALLY
		MOV DX,BLOCKY	
		MOV AL,BCOLOR	    ;CHOOSING COLOR
		MOV AH,0CH
	@@BACK:
		INT 10H
		INC CX
		ADD BLOCKX,BlockwidthMiddle  ;BLOCK MAX WIDTH
		CMP CX,BLOCKX
		PUSHF			;ADJUSTING FLAGS
		SUB BLOCKX,BlockwidthMiddle  
		POPF
		JNZ @@BACK   ;TILL HERE
		
	INC BLOCKY			
	CMP BLOCKY,BX
	JNE @@DRAW 		;KEEP DRAWING HORIZONTALLY
	SUB BLOCKY,Blockheight   

ENDM

;DELETE A BLOCK MACRO
DELETEABLOCK MACRO BLOCKX, BLOCKY
    LOCAL @@DRAWW, @@BACKK         ;BECAUSE WE NEED TO CALL MACROS MORE THAN ONCE MUST USE LOCAL NUMERIC LABELS ;REGULAR LABELS WONT WORK
	MOV BX,00
	ADD BX,BLOCKY
	ADD BX,Blockheight	;PUTTING IN BX BLOCK MAX LENGTH
	@@DRAWW:
		MOV CX,BLOCKX	;DRAWING PIXELS HORIZONTALLY
		MOV DX,BLOCKY	
		MOV AL,Clearcolor	    ;Clear color
		MOV AH,0CH
	@@BACKK:
		INT 10H
		INC CX
		ADD BLOCKX,Blockwidth  ;BLOCK MAX WIDTH
		CMP CX,BLOCKX
		PUSHF			;ADJUSTING FLAGS
		SUB BLOCKX,Blockwidth  
		POPF
		JNZ @@BACKK  
		
	INC BLOCKY		
	CMP BLOCKY,BX
	JNE @@DRAWW  		;KEEP DRAWING HORIZONTALLY
	SUB BLOCKY,Blockheight
	       
	ENDM



;
;

.Model Large
.Stack 64
.Data
IntroMessage db 'Press Space To Continue','$'
TimeRemaining db "Time Remaining : ",'$'
ScoreMessage db "Score : ",'$'
player1wonmes db "Player 1 Wins !",'$'
player2wonmes db "Player 2 Wins !",'$'
itisadrawmes db "IT IS A DRAW !",'$'

Bullets1X dw 10 dup(0),1
Bullets1Y dw 10 dup(0),1
Bullets2X dw 10 dup(0),1
Bullets2Y dw 10 dup(0),1
BulletSpeed equ 20

SHOOTER1X DW 100   ;X COORDINATE FOR OUTLINE STARTING POINT
SHOOTER1Y DW 210   ;Y COORDINATE FOR OUTLINE STARTING POINT
SHOOTER2X DW 900  
SHOOTER2Y DW 410
SHOOTER2BIGGER DW 0 ;0 IF SAME SIZE 1 IF BIGGER
SHOOTER1BIGGER DW 0 ;0 IF SAME SIZE 1 IF BIGGER
Shooter1Speed equ 30     ;shooter speeds in moving
Shooter2Speed equ 30

TOBEDRAWN DB 1
TOBEDRAWNABLOCK DB 0,24 DUP(1)

tempbulletx dw ?
tempbullety dw ?
temptobedrawn db ?

Blockheight equ 90
Blockwidth  equ 40

BlocksLeftColor1  equ 11
BlocksRightColor1 equ 12
BlocksLeftColor2  equ 1
BlocksRightColor2 equ 4

;DATA FOR DRAWING Left WALLS
;Block1

BLOCK1X DW 4   ;X COORDINATE FOR BLOCK1 STARTING POINT
BLOCK1Y DW 20   ;Y COORDINATE FOR BLOCK1 STARTING POINT

;BLOCK2
BLOCK2X DW 48   
BLOCK2Y DW 20 

;BLOCK3
BLOCK3X DW 4 
BLOCK3Y DW 115 

;BLOCK4
BLOCK4X DW 48 
BLOCK4Y DW 115 

;BLOCK5
BLOCK5X DW 4  
BLOCK5Y DW 210 

;BLOCK6
BLOCK6X DW 48  
BLOCK6Y DW 210

;BLOCK7
BLOCK7X DW 4 
BLOCK7Y DW 305 

;BLOCK8
BLOCK8X DW 48
BLOCK8Y DW 305  

;BLOCK9
BLOCK9X DW 4   
BLOCK9Y DW 400

;BLOCK10
BLOCK10X DW 48    
BLOCK10Y DW 400

;BLOCK11
BLOCK11X DW 4 
BLOCK11Y DW 495  

;BLOCK12
BLOCK12X DW 48    
BLOCK12Y DW 495 


;DATA FOR DRAWING LEFT WALLS
;Block13                                 
BLOCK13X DW 936  
BLOCK13Y DW 20 


;BLOCK14
BLOCK14X DW 980   
BLOCK14Y DW 20

;BLOCK15
BLOCK15X DW 936 
BLOCK15Y DW 115

;BLOCK16
BLOCK16X DW 980
BLOCK16Y DW 115

;BLOCK17
BLOCK17X DW 936 
BLOCK17Y DW 210

;BLOCK18
BLOCK18X DW 980
BLOCK18Y DW 210

;BLOCK19
BLOCK19X DW 936 
BLOCK19Y DW 305

;BLOCK20
BLOCK20X DW 980
BLOCK20Y DW 305 

;BLOCK21
BLOCK21X DW 936 
BLOCK21Y DW 400

;BLOCK22
BLOCK22X DW 980  
BLOCK22Y DW 400

;BLOCK23
BLOCK23X DW 936 
BLOCK23Y DW 495

;BLOCK24
BLOCK24X DW 980  
BLOCK24Y DW 495

;;;;;;;;;;;;;;;;;;MIDDLE BLOCKS MEMORY

MiddleBlocksx1 dw 500 
MiddleBlocksy1 dw 24
MiddleBlocksx2 dw 500
MiddleBlocksy2 dw 118
MiddleBlocksx3 dw 500
MiddleBlocksy3 dw 212
MiddleBlocksx4 dw 500
MiddleBlocksy4 dw 306
MiddleBlocksx5 dw 500
MiddleBlocksy5 dw 400
MiddleBlocksx6 dw 500
MiddleBlocksy6 dw 494

MiddleBlockcolor db 1Fh 
BlockwidthMiddle equ 10
Middleblockboolean db 0
Middleblockbooleaninverted db 1
booleantime4 db 0
MiddleTimeValue db ?

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bulletcolorfacingleft   db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01
						db 00,00,00,00,00,00,43,43,43,43,43,43,43,43,00,00,01,01,01,01
						db 00,00,00,00,43,43,43,43,43,43,43,43,43,43,00,00,01,01,01,01
						db 00,00,01,01,43,43,43,43,43,43,43,43,43,43,43,43,01,01,01,01
						db 00,01,01,43,43,43,43,43,43,43,43,43,43,43,43,43,01,01,01,01
						db 00,01,01,43,43,43,43,43,43,43,43,43,43,43,43,43,01,01,01,01
						db 00,00,01,01,43,43,43,43,43,43,43,43,43,43,43,43,01,01,01,01
						db 00,00,00,00,43,43,43,43,43,43,43,43,43,43,00,00,01,01,01,01
						db 00,00,00,00,00,00,43,43,43,43,43,43,43,43,00,00,01,01,01,01
						db 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01
						
bulletcolorfacingright  db 04,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
                        db 04,04,04,04,00,00,43,43,43,43,43,43,43,43,00,00,00,00,00,00
                        db 04,04,04,04,00,00,43,43,43,43,43,43,43,43,43,43,00,00,00,00
                        db 04,04,04,04,43,43,43,43,43,43,43,43,43,43,43,43,04,04,00,00
                        db 04,04,04,04,43,43,43,43,43,43,43,43,43,43,43,43,43,04,04,00
                        db 04,04,04,04,43,43,43,43,43,43,43,43,43,43,43,43,43,04,04,00
                        db 04,04,04,04,43,43,43,43,43,43,43,43,43,43,43,43,04,04,00,00
                        db 04,04,04,04,00,00,43,43,43,43,43,43,43,43,43,43,00,00,00,00
                        db 04,04,04,04,00,00,43,43,43,43,43,43,43,43,00,00,00,00,00,00
                        db 04,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
bulletaddtimer db ?
booleantime db 0
bulletaddtimer2 db ?
booleantime2 db 0

Timervalue db 60
LastTickedTime db ?
booleantime3 db 0

Player1Score db 0
Player2Score db 0

frameMes1 db 'Press F1 To Enter Chat Mode',10,13,'$'
frameMes2 db 'Press F2 To Start A New Game',10,'$'
frameMes3 db 'Press ESC to Exit The Game',10,'$'
Usernamemessage db 'Please Enter your Name :','$'
Usernamecontinuemessage db 'Press Enter to Continue','$'
UserNameDATA db 20				;Must stay in this order
UserNameDataNumber db ?            ;Must stay in this order
UserNameDatastring db 20 dup('$')    ;Must stay in this order

notbarmess db 128 dup('_'),10,'$' 
notbarmess2 db 128 dup('-'),10,'$' 
BulletNumber equ 10
ScreenWidth equ 1024
Shooterlength equ 120

CounterFreeze1 db 0
BooleanFreeze1 db 0
CounterFreeze2 db 0
BooleanFreeze2 db 0
maxfreezetime equ 100

Clearcolor db 0h

.code

;procedure to clear screen
ClearALLScreen Proc far

mov cx,0
mov dx,0
mov al,Clearcolor
mov ah,0ch

ClearALLscreenouter:
				mov dx,0
		ClearALLscreeninner:
						int 10h 
						inc dx
						cmp dx,768
						jnz ClearALLscreeninner
				inc cx 
				cmp cx,1024
				jnz ClearALLscreenouter
ret				
ClearALLScreen endp


;PROCEDURE TO DRAW RIGHT WALLS
DRAWLEFTWALLS PROC
    
    DRAWABLOCK BLOCK1X,BLOCK1Y,BlocksRightColor2
    DRAWABLOCK BLOCK2X,BLOCK2Y,BlocksRightColor1
    DRAWABLOCK BLOCK3X,BLOCK3Y,BlocksRightColor2
    DRAWABLOCK BLOCK4X,BLOCK4Y,BlocksRightColor1
    DRAWABLOCK BLOCK5X,BLOCK5Y,BlocksRightColor2
    DRAWABLOCK BLOCK6X,BLOCK6Y,BlocksRightColor1
    DRAWABLOCK BLOCK7X,BLOCK7Y,BlocksRightColor2
    DRAWABLOCK BLOCK8X,BLOCK8Y,BlocksRightColor1
    DRAWABLOCK BLOCK9X,BLOCK9Y,BlocksRightColor2
    DRAWABLOCK BLOCK10X,BLOCK10Y,BlocksRightColor1
    DRAWABLOCK BLOCK11X,BLOCK11Y,BlocksRightColor2
    DRAWABLOCK BLOCK12X,BLOCK12Y,BlocksRightColor1
       
    RET
DRAWLEFTWALLS ENDP  

;PROCEDURE TO DRAW LEFT WALLS
DRAWRIGHTWALLS PROC 
    
    DRAWABLOCK BLOCK13X,BLOCK13Y,BlocksLeftColor1
    DRAWABLOCK BLOCK14X,BLOCK14Y,BlocksLeftColor2
    DRAWABLOCK BLOCK15X,BLOCK15Y,BlocksLeftColor1
    DRAWABLOCK BLOCK16X,BLOCK16Y,BlocksLeftColor2
    DRAWABLOCK BLOCK17X,BLOCK17Y,BlocksLeftColor1
    DRAWABLOCK BLOCK18X,BLOCK18Y,BlocksLeftColor2
    DRAWABLOCK BLOCK19X,BLOCK19Y,BlocksLeftColor1
    DRAWABLOCK BLOCK20X,BLOCK20Y,BlocksLeftColor2
    DRAWABLOCK BLOCK21X,BLOCK21Y,BlocksLeftColor1
    DRAWABLOCK BLOCK22X,BLOCK22Y,BlocksLeftColor2
    DRAWABLOCK BLOCK23X,BLOCK23Y,BlocksLeftColor1
    DRAWABLOCK BLOCK24X,BLOCK24Y,BlocksLeftColor2
       
    RET
DRAWRIGHTWALLS ENDP

;PROCEDURE TO DELETE RIGHT WALLS
DELETERIGHTWALLS PROC 
    
    DELETEABLOCK BLOCK1X,BLOCK1Y
    DELETEABLOCK BLOCK2X,BLOCK2Y
    DELETEABLOCK BLOCK3X,BLOCK3Y
    DELETEABLOCK BLOCK4X,BLOCK4Y
    DELETEABLOCK BLOCK5X,BLOCK5Y
    DELETEABLOCK BLOCK6X,BLOCK6Y
    DELETEABLOCK BLOCK7X,BLOCK7Y
    DELETEABLOCK BLOCK8X,BLOCK8Y
    DELETEABLOCK BLOCK9X,BLOCK9Y
    DELETEABLOCK BLOCK10X,BLOCK10Y
    DELETEABLOCK BLOCK11X,BLOCK11Y
    DELETEABLOCK BLOCK12X,BLOCK12Y
       
    RET
DELETERIGHTWALLS ENDP  

;PROCEDURE TO DELETE LEFT WALLS
DELETELEFTWALLS PROC 
    
    DELETEABLOCK BLOCK13X,BLOCK13Y
    DELETEABLOCK BLOCK14X,BLOCK14Y
    DELETEABLOCK BLOCK15X,BLOCK15Y
    DELETEABLOCK BLOCK16X,BLOCK16Y
    DELETEABLOCK BLOCK17X,BLOCK17Y
    DELETEABLOCK BLOCK18X,BLOCK18Y
    DELETEABLOCK BLOCK19X,BLOCK19Y
    DELETEABLOCK BLOCK20X,BLOCK20Y
    DELETEABLOCK BLOCK21X,BLOCK21Y
    DELETEABLOCK BLOCK22X,BLOCK22Y
    DELETEABLOCK BLOCK23X,BLOCK23Y
    DELETEABLOCK BLOCK24X,BLOCK24Y
       
    RET
DELETELEFTWALLS ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAWMIDDLEBLOCKS PROC FAR

cmp Middleblockboolean,0
jnz drawoddmiddle 

tempdrawevenmiddle:jmp drawevenmiddle

drawoddmiddle:
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy1,MiddleBlockcolor ;draw
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy3,MiddleBlockcolor
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy5,MiddleBlockcolor

DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy2,0h ;delete
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy4,0h
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy6,0h

jmp Drawmiddleexit 

drawevenmiddle:
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy2,MiddleBlockcolor ;draw
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy4,MiddleBlockcolor
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy6,MiddleBlockcolor

DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy1,0h ;delete
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy3,0h
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy5,0h

Drawmiddleexit:RET

DRAWMIDDLEBLOCKS ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BlinkMiddleandInvert proc far

	mov ax,2c00h 
	int 21h   
	cmp booleantime4,0
	jnz hastimecomemiddle
	mov MiddleTimeValue,dh
	mov booleantime4,1
	
	hastimecomemiddle:	
		cmp dh,MiddleTimeValue
		jz middleinvertjmp
		
		mov MiddleTimeValue,dh  ;invert the blocks
		mov al,Middleblockboolean
		mov ah,Middleblockbooleaninverted
		
		mov Middleblockboolean,ah
		mov Middleblockbooleaninverted,al
		
middleinvertjmp: call DRAWMIDDLEBLOCKS

ret
BlinkMiddleandInvert endp



;---------------------------------------------------------------------------
;--------------------DRAW RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
DRAWRECTOUTLINE1 PROC  		;PROCEDURE THAT DRAWS A RECTANGLE GUIDED BY THE START POSITION OF THE SHOOTER


	CMP SHOOTER1BIGGER,1
	JE BIGGER 
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,120 	;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
	JMP DRAW
	BIGGER:
		MOV BX,00
		ADD BX,SHOOTER1Y
		ADD BX,160
		
	DRAW:
							;DRAWING PIXELS HORIZONTALLY
		MOV CX,SHOOTER1X	;FILLING INITIAL VALUE FOR X
		MOV DX,SHOOTER1Y	;FILLING INITIAL VALUE FOR Y
		MOV AL,07			;  ....
		MOV AH,0CH
	BACK:
		INT 10H
		INC CX
		ADD SHOOTER1X,30	;MAXIMUM WIDTH FOR OUTLINE IS 30
		CMP CX,SHOOTER1X	;DID WE REACH THE END?(HORIZONTALLY)
		PUSHF  				;KEEP COMPARE FLAG CHANGES AND USE THEM WHEN WE GET TO JUMP
		SUB SHOOTER1X,30
		POPF
		JNZ BACK        	;TILL HERE
		
	INC SHOOTER1Y			;MOVING DOWN TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX		;DID WE REACH THE END?(VERTICALLY)
	JNE DRAW 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1 
	JE BIGGER1
	SUB SHOOTER1Y,120
	JMP ENDSHOOT1
	BIGGER1:
	SUB SHOOTER1Y,160
	ENDSHOOT1:
	RET
	
DRAWRECTOUTLINE1 ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR RECTANGLE OUTLINE--------------------------------
;---------------------------------------------------------------------------

CLRRECTOUTLINE1 PROC  		;PROCEDURE THAT DRAWS A RECTANGLE GUIDED BY THE START POSITION OF THE SHOOTER

	CMP SHOOTER1BIGGER,1
	JE BIGGER2
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,120
	JMP DRAW6	;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
	BIGGER2:
	MOV BX,00 
	ADD BX,SHOOTER1Y
	ADD BX,160
	DRAW6:
							;DRAWING PIXELS HORIZONTALLY
		MOV CX,SHOOTER1X	;FILLING INITIAL VALUE FOR X
		MOV DX,SHOOTER1Y	;FILLING INITIAL VALUE FOR Y
		MOV AL,0			;  ....
		MOV AH,0CH
	BACK6:
		INT 10H
		INC CX
		ADD SHOOTER1X,30	;MAXIMUM WIDTH FOR OUTLINE IS 30
		CMP CX,SHOOTER1X	;DID WE REACH THE END?(HORIZONTALLY)
		PUSHF  				;KEEP COMPARE FLAG CHANGES AND USE THEM WHEN WE GET TO JUMP
		SUB SHOOTER1X,30
		POPF
		JNZ BACK6        	;TILL HERE
		
	INC SHOOTER1Y			;MOVING DOWN TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX		;DID WE REACH THE END?(VERTICALLY)
	JNE DRAW6 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1
	JE BIGGER3
	SUB SHOOTER1Y,120
	JMP ENDSHOOT2
	BIGGER3:
	SUB SHOOTER1Y,160
	ENDSHOOT2:
	RET
	
CLRRECTOUTLINE1 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------
DRAWINNERRECT1 PROC 
	
	ADD SHOOTER1X,5
	ADD SHOOTER1Y,5
	CMP SHOOTER1BIGGER,1
	JE BIGGER4
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
	JMP DRAW1
	BIGGER4:
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,150
	DRAW1:
		MOV CX,SHOOTER1X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER1Y	;  ....
		MOV AL,4	;  ....
		MOV AH,0CH
	BACK1:
		INT 10H
		INC CX
		ADD SHOOTER1X,20  ;TO GENERATE MAX WIDTH OF INNER RECTANGLE
		CMP CX,SHOOTER1X
		PUSHF			;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMP
		SUB SHOOTER1X,20  
		POPF
		JNZ BACK1   ;TILL HERE
		
	INC SHOOTER1Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX
	JNE DRAW1 		;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1
	JE BIGGER5
	SUB SHOOTER1Y,110
	JMP ENDSHOOT3
	BIGGER5:
	SUB SHOOTER1Y,150
	ENDSHOOT3:
	SUB SHOOTER1X,5
	SUB SHOOTER1Y,5
	RET

DRAWINNERRECT1 ENDP


;---------------------------------------------------------------------------
;--------------------CLEAR INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------

CLRINNERRECT1 PROC 
	
	ADD SHOOTER1X,5
	ADD SHOOTER1Y,5
	CMP SHOOTER1BIGGER,1
	JE BIGGER6
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
	JMP DRAW7
	BIGGER6:
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,150
	DRAW7:
		MOV CX,SHOOTER1X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER1Y	;  ....
		MOV AL,0	;  ....
		MOV AH,0CH
	BACK7:
		INT 10H
		INC CX
		ADD SHOOTER1X,20  ;TO GENERATE MAX WIDTH OF INNER RECTANGLE
		CMP CX,SHOOTER1X
		PUSHF			;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMP
		SUB SHOOTER1X,20  
		POPF
		JNZ BACK7   ;TILL HERE
		
	INC SHOOTER1Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX
	JNE DRAW7 		;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1
	JE BIGGER7
	SUB SHOOTER1Y,110
	JMP ENDSHOOT4
	BIGGER7:
	SUB SHOOTER1Y,150
	ENDSHOOT4:
	SUB SHOOTER1X,5
	SUB SHOOTER1Y,5
	RET

CLRINNERRECT1 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
DRAWINGSHOOTER1TIP PROC
	
	ADD SHOOTER1X,30
	CMP SHOOTER1BIGGER,1
	JE BIGGER8
	ADD SHOOTER1Y,40
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,40			;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF TIP
	JMP DRAW2
	BIGGER8:
	ADD SHOOTER1Y,60
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,40			;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF TIP
	
	DRAW2:
	
		MOV CX,SHOOTER1X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER1Y	;  ....
		MOV AL,4			;  ....
		MOV AH,0CH
	BACK2:
		INT 10H
		INC CX
		ADD SHOOTER1X,10    ;TO GENERATE MAX WIDTH OF TIP
		CMP CX,SHOOTER1X
		PUSHF				;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMPS
		SUB SHOOTER1X,10
		POPF
		JNZ BACK2        	;TILL HERE
		
	INC SHOOTER1Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX
	JNE DRAW2 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1
	JE BIGGER9
	SUB SHOOTER1Y,40
	JMP ENDSHOOT5
	BIGGER9:
	SUB SHOOTER1Y,60
	ENDSHOOT5:
	SUB SHOOTER1Y,40
	SUB SHOOTER1X,30
	RET

DRAWINGSHOOTER1TIP ENDP

;---------------------------------------------------------------------------
;-----------------------CLEAR SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
CLRSHOOTER1TIP PROC
	
	ADD SHOOTER1X,30
	CMP SHOOTER1BIGGER,1
	JE BIGGER10
	ADD SHOOTER1Y,40
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,40
	JMP DRAW8
	BIGGER10:
	ADD SHOOTER1Y,60
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,40			;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF TIP
	
	DRAW8:
	
		MOV CX,SHOOTER1X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER1Y	;  ....
		MOV AL,0			;  ....
		MOV AH,0CH
	BACK8:
		INT 10H
		INC CX
		ADD SHOOTER1X,10    ;TO GENERATE MAX WIDTH OF TIP
		CMP CX,SHOOTER1X
		PUSHF				;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMPS
		SUB SHOOTER1X,10
		POPF
		JNZ BACK8        	;TILL HERE
		
	INC SHOOTER1Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER1Y,BX
	JNE DRAW8 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER1BIGGER,1
	JE BIGGER11
	SUB SHOOTER1Y,40
	JMP ENDSHOOT9
	BIGGER11:
	SUB SHOOTER1Y,60
	ENDSHOOT9:
	SUB SHOOTER1Y,40
	SUB SHOOTER1X,30
	RET

CLRSHOOTER1TIP ENDP


;---------------------------------------------------------------------------
;--------------------DRAW RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
DRAWRECTOUTLINE2 PROC 
	CMP SHOOTER2BIGGER,1
	JE BIGGER20
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,120
	JMP DRAW3
	BIGGER20:
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,160 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
	DRAW3:
							;DRAWING PIXELS HORIZONTALLY
		MOV CX,SHOOTER2X	;FILLING INITIAL VALUE FOR X
		MOV DX,SHOOTER2Y	;FILLING INITIAL VALUE FOR Y
		MOV AL,07			;  ....
		MOV AH,0CH
	BACK3:
		INT 10H
		INC CX
		ADD SHOOTER2X,30		;MAXIMUM WIDTH FOR OUTLINE IS 30
		CMP CX,SHOOTER2X		;DID WE REACH THE END?(HORIZONTALLY)
		PUSHF  					;KEEP COMPARE FLAG CHANGES AND USE THEM WHEN WE GET TO JUMP
		SUB SHOOTER2X,30
		POPF
		JNZ BACK3        	;TILL HERE
		
	INC SHOOTER2Y		;MOVING DOWN TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX		;DID WE REACH THE END?(VERTICALLY)
	JNE DRAW3 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER21
	SUB SHOOTER2Y,120
	JMP ENDSHOOT20
	BIGGER21:
	SUB SHOOTER2Y,160
	ENDSHOOT20:
	RET

DRAWRECTOUTLINE2 ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
CLRRECTOUTLINE2 PROC 
	CMP SHOOTER2BIGGER,1
	JE BIGGER22
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,120 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
	JMP DRAW9
	BIGGER22:
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,160
	DRAW9:
							;DRAWING PIXELS HORIZONTALLY
		MOV CX,SHOOTER2X	;FILLING INITIAL VALUE FOR X
		MOV DX,SHOOTER2Y	;FILLING INITIAL VALUE FOR Y
		MOV AL,0			;  ....
		MOV AH,0CH
	BACK9:
		INT 10H
		INC CX
		ADD SHOOTER2X,30		;MAXIMUM WIDTH FOR OUTLINE IS 30
		CMP CX,SHOOTER2X		;DID WE REACH THE END?(HORIZONTALLY)
		PUSHF  					;KEEP COMPARE FLAG CHANGES AND USE THEM WHEN WE GET TO JUMP
		SUB SHOOTER2X,30
		POPF
		JNZ BACK9        	;TILL HERE
		
	INC SHOOTER2Y		;MOVING DOWN TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX		;DID WE REACH THE END?(VERTICALLY)
	JNE DRAW9 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER23
	SUB SHOOTER2Y,120
	JMP ENDSHOOT22
	BIGGER23:
	SUB SHOOTER2Y,160
	ENDSHOOT22:
	RET

CLRRECTOUTLINE2 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------
DRAWINNERRECT2 PROC

	ADD SHOOTER2X,5
	ADD SHOOTER2Y,5
	CMP SHOOTER2BIGGER,1
	JE BIGGER24
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,110
	JMP DRAW4
	BIGGER24:
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,150   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
	DRAW4:
		MOV CX,SHOOTER2X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER2Y	;  ....
		MOV AL,1	;  ....
		MOV AH,0CH
	BACK4:
		INT 10H
		INC CX
		ADD SHOOTER2X,20  ;TO GENERATE MAX WIDTH OF INNER RECTANGLE
		CMP CX,SHOOTER2X
		PUSHF			;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMP
		SUB SHOOTER2X,20  
		POPF
		JNZ BACK4   ;TILL HERE
		
	INC SHOOTER2Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX
	JNE DRAW4 		;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER25
	SUB SHOOTER2Y,110
	JMP ENDSHOOT23
	BIGGER25:
	SUB SHOOTER2Y,150
	ENDSHOOT23:
	SUB SHOOTER2X,5
	SUB SHOOTER2Y,5
	RET
DRAWINNERRECT2 ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------
CLRINNERRECT2 PROC

	ADD SHOOTER2X,5
	ADD SHOOTER2Y,5
	CMP SHOOTER2BIGGER,1
	JE BIGGER26
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,110
	JMP DRAW10
	BIGGER26:
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,150   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
	DRAW10:
		MOV CX,SHOOTER2X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER2Y	;  ....
		MOV AL,0	;  ....
		MOV AH,0CH
	BACK10:
		INT 10H
		INC CX
		ADD SHOOTER2X,20  ;TO GENERATE MAX WIDTH OF INNER RECTANGLE
		CMP CX,SHOOTER2X
		PUSHF			;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMP
		SUB SHOOTER2X,20  
		POPF
		JNZ BACK10   ;TILL HERE
		
	INC SHOOTER2Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX
	JNE DRAW10	;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER27
	SUB SHOOTER2Y,110
	JMP ENDSHOOT27
	BIGGER27:
	SUB SHOOTER2Y,150
	ENDSHOOT27:
	SUB SHOOTER2X,5
	SUB SHOOTER2Y,5
	RET
CLRINNERRECT2 ENDP

;---------------------------------------------------------------------------
;--------------------DRAW SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
DRAWSHOOTER2TIP PROC

	SUB SHOOTER2X,10
	CMP SHOOTER2BIGGER,1
	JE BIGGER29
	ADD SHOOTER2Y,40
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,40
	JMP DRAW5
	BIGGER29:
	ADD SHOOTER2Y,60
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,40				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF TIP
	
	DRAW5:
	
		MOV CX,SHOOTER2X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER2Y	;  ....
		MOV AL,1			;  ....
		MOV AH,0CH
	BACK5:
		INT 10H
		INC CX
		ADD SHOOTER2X,10    ;TO GENERATE MAX WIDTH OF TIP
		CMP CX,SHOOTER2X
		PUSHF				;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMPS
		SUB SHOOTER2X,10
		POPF
		JNZ BACK5        	;TILL HERE
		
	INC SHOOTER2Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX
	JNE DRAW5 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER30
	SUB SHOOTER2Y,40
	JMP ENDSHOOT30
	BIGGER30:
	SUB SHOOTER2Y,60
	ENDSHOOT30:
	SUB SHOOTER2Y,40
	ADD SHOOTER2X,10
	RET
DRAWSHOOTER2TIP ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
CLRSHOOTER2TIP PROC

	SUB SHOOTER2X,10
	CMP SHOOTER2BIGGER,1
	JE BIGGER31
	ADD SHOOTER2Y,40
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,40
	JMP DRAW11
	BIGGER31:
	ADD SHOOTER2Y,60
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,40				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF TIP
	
	DRAW11:
	
		MOV CX,SHOOTER2X	;DRAWING PIXELS HORIZONTALLY
		MOV DX,SHOOTER2Y	;  ....
		MOV AL,0			;  ....
		MOV AH,0CH
	BACK11:
		INT 10H
		INC CX
		ADD SHOOTER2X,10    ;TO GENERATE MAX WIDTH OF TIP
		CMP CX,SHOOTER2X
		PUSHF				;TO MAINTAIN COMPARE FLAG CHANGES TO BE USED IN JUMPS
		SUB SHOOTER2X,10
		POPF
		JNZ BACK11       	;TILL HERE
		
	INC SHOOTER2Y			;MOVING TO THE NEXT LINE (INCREMENTING Y)
	CMP SHOOTER2Y,BX
	JNE DRAW11 				;KEEP DRAWING HORIZONTALLY THEN MOVE TO FOLLOWING LINE
	CMP SHOOTER2BIGGER,1
	JE BIGGER32
	SUB SHOOTER2Y,40
	JMP ENDSHOOT40
	BIGGER32:
	SUB SHOOTER2Y,60
	ENDSHOOT40:
	SUB SHOOTER2Y,40
	ADD SHOOTER2X,10
	RET
CLRSHOOTER2TIP ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DRAWSHOOTER1 proc far 
	
	CMP PLAYER1SCORE,6
	jz Adjustsize1 
	JMP continuedrawshooter1
Adjustsize1:
	CALL CLRSHOOTER1TIP
	MOV SHOOTER2BIGGER,1
	
	
continuedrawshooter1:	
	CALL DRAWRECTOUTLINE1
	CALL DRAWINNERRECT1
	CALL DRAWINGSHOOTER1TIP

ret
DRAWSHOOTER1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAWSHOOTER2 proc far

	
	CMP PLAYER2SCORE,6
	jz Adjustsize2
	JMP continuedrawshooter2
Adjustsize2:
	CALL CLRSHOOTER2TIP
	MOV SHOOTER1BIGGER,1
	

continuedrawshooter2:	
	CALL DRAWRECTOUTLINE2
	CALL DRAWINNERRECT2
	CALL DRAWSHOOTER2TIP
ret
DRAWSHOOTER2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CLEARSHOOTER1 proc far 			;DRAWS OVER EVERYTHING IN BLACK == CLEARING

	CALL CLRRECTOUTLINE1
	CALL CLRINNERRECT1
	CALL CLRSHOOTER1TIP
ret
CLEARSHOOTER1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CLEARSHOOTER2 proc far				;DRAWS OVER EVERYTHING IN BLACK == CLEARING

	CALL CLRRECTOUTLINE2
	CALL CLRINNERRECT2
	CALL CLRSHOOTER2TIP
ret
CLEARSHOOTER2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TimerPrint proc far
		  
		mov ax,2c00h   ;checking the time the game started
		int 21h   
		cmp booleantime3,0
		jnz timeaddition
		mov LastTickedTime,dh
		mov booleantime3,1
		
		timeaddition:    ;check if a second passed and add to the timer
		cmp LastTickedTime,dh
		jz PrintingTime
		mov LastTickedTime,dh
		dec Timervalue
		  
PrintingTime:	 
		  mov ah,2   ;move cursor
		  mov dx,2635h
		  mov bx,0
		  int 10h
		  
		  mov ah,9
		  lea dx,TimeRemaining
		  int 21h
		  
		  mov al,Timervalue
		  mov ah,0
		  mov dl,10
		  div dl 
		  mov cl,al 
		  mov ch,ah ;dividing numbers;
		  
		  
		  mov dl,cl ;printing clock
		  add dl,'0'
		  mov ah,2
		  int 21h
		  
		  mov dl,ch ;printing clock
		  add dl,'0'
		  mov ah,2
		  int 21h
		 
ret
TimerPrint endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;

StatusBar proc far

	mov ah,2     ;moving the cursor 
    mov dx,2500h
	mov bx,0
    int 10h
	
	mov ah,9
	lea dx,notbarmess ;print the upper bound
	int 21h
	
	mov ah,2   ;move cursor
	mov dx,2605h
	mov bx,0
	int 10h
	mov ah,9
	lea dx,ScoreMessage
	int 21h
	mov al,Player1Score
	mov ah,0
	mov dl,10
	div dl 
	mov cl,al 
	mov ch,ah ;dividing numbers
	mov dl,cl ;printing scoreplayer1
	add dl,'0'
	mov ah,2
	int 21h
	mov dl,ch ;printing scoreplayer1
	add dl,'0'
	mov ah,2
	int 21h
		 
	mov ah,2     ;frozen status print for the left shooter
	mov dx,2625h
	mov bx,0
	int 10h
	mov ah,9
	mov bh,0
	mov al,' '
	mov cx,1
	mov bl,04h
	cmp BooleanFreeze2,0
	jz nofr
	mov al,'F'
nofr:int 10h

	mov ah,2     ;frozen status print for the right shooter
	mov dx,2655h
	mov bx,0
	int 10h
	mov ah,9
	mov bh,0
	mov al,' '
	mov cx,1
	mov bl,01h
	cmp BooleanFreeze1,0
	jz nofr2
	mov al,'F'
nofr2:int 10h
		
		 
	mov ah,2   ;move cursor
	mov dx,2670h
	mov bx,0
	int 10h
	mov ah,9
	lea dx,ScoreMessage
	int 21h
	mov al,Player2Score
	mov ah,0
	mov dl,10
	div dl 
	mov cl,al 
	mov ch,ah ;dividing numbers;
	mov dl,cl ;printing scoreplayer2
	add dl,'0'
	mov ah,2
	int 21h
	mov dl,ch ;printing scoreplayer2
	add dl,'0'
	mov ah,2
	int 21h
	
	call TimerPrint
	
	mov ah,2     ;moving the cursor 
    mov dx,2700h
	mov bx,0
    int 10h
	
	
	mov ah,9 ;print the lower bound
	lea dx,notbarmess2
	int 21h
	

ret
StatusBar endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GameName proc far

	call ClearALLScreen 
	
	mov cx,223
	mov dx,140
	mov al,9
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels
	
	verticalup:
		mov di,201 ;length of line
		verticalupinside:	
					push cx
					int 10h
					add cx,80
					int 10h
					add cx,40
					int 10h
					add cx,120
					int 10h
					add cx,80
					int 10h
					add cx,40
					int 10h
					add cx,120
					int 10h
					pop cx
					inc dx
					dec di
					jnz verticalupinside
		inc cx
		mov dx,140
		dec si
		jnz verticalup
	
	
	mov cx,223
	mov dx,140
	mov al,9
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels
	horizontalup:
		mov di,101;width of line 
		horizontalupinside:
					push cx 
					push dx
					int 10h
					add dx,80
					int 10h
					add dx,100
					int 10h
					add cx,120
					int 10h
					add cx,120
					int 10h
					sub dx,180
					int 10h
					add cx,120
					int 10h
					add dx,180
					int 10h
					add cx,120
					sub dx,80
					int 10h
					pop dx
					pop cx
					inc cx
					dec di
					jnz horizontalupinside
		mov cx,223
		inc dx
		dec si
		jnz horizontalup
		
	mov cx,244
	mov dx,226
	mov al,Clearcolor
	mov si,8
	Bloop:
		mov di,81
		Bloopinside:
					int 10h
					inc cx
					dec di
					jnz Bloopinside
		mov cx,243
		inc dx
		dec si
		jnz Bloop
		
		
					
	mov cx,783
	mov dx,140
	mov al,9
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels	 
	kloop:
		mov di,101
		kloopinside:
					push cx 
					push dx
					int 10h
					sub cx,10
					add dx,100
					int 10h
					pop dx
					pop cx
					inc dx
					dec di
					jnz kloopinside
		mov dx,140
		inc cx
		dec si
		jnz kloop
		
		
		
	mov cx,223
	mov dx,390
	mov al,4
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels
	
	verticaldown:
		mov di,201 ;length of line
		verticaldowninside:	
					push cx
					add cx,120
					int 10h
					add cx,80
					int 10h
					add cx,40
					int 10h
					add cx,80
					int 10h
					add cx,40
					int 10h
					add cx,80
					int 10h
					add cx,80
					int 10h
					pop cx
					inc dx
					dec di
					jnz verticaldowninside
		inc cx
		mov dx,390
		dec si
		jnz verticaldown	
		
		
	mov cx,223
	mov dx,390
	mov al,4
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels
	horizontaldown:
		mov di,101;width of line 
		horizontaldowninside:
					push cx 
					push dx
					int 10h
					add dx,80
					int 10h
					add dx,100
					int 10h
					add cx,120
					sub dx,100
					int 10h
					add cx,120
					sub dx,80
					int 10h
					add dx,180
					int 10h
					add cx,120
					int 10h
					sub dx,180
					int 10h
					add cx,120
					int 10h
					pop dx
					pop cx
					inc cx
					dec di
					jnz horizontaldowninside
		mov cx,223
		inc dx
		dec si
		jnz horizontaldown


	mov cx,223
	mov dx,390
	mov al,4
	mov ah,0ch;parameters of draw pixel interrupt
	mov si,21 ;thickness of line in pixels	

	Sloop:
		mov di,101
		Sloopinside:
					push cx 
					push dx
					int 10h
					add cx,80
					add dx,100
					int 10h
					pop dx
					pop cx
					inc dx
					dec di
					jnz Sloopinside
		mov dx,390
		inc cx
		dec si
		jnz Sloop
		
	mov ah,2   ;move cursor
	mov dx,2935h
	mov bx,0
	int 10h
	
	mov ah,9
	lea dx,IntroMessage
	int 21h
		
	;wait for key to exit
WaitforSpace:	
				mov ah,07;clear key from buffer
				int 21h
				cmp al,32
				jnz WaitforSpace
				
	;clear screen
ExitIntro:	mov ax, 4f02h
			mov bx, 105h
			int 10h

	ret
GameName endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScoreScreen proc far

	mov ax, 4f02h
	mov bx, 105h
	int 10h ;clear by calling graphics mode
			  
	call StatusBar
	
	mov bl,Player1Score
	mov cl,Player2Score
	
	cmp bl,cl
	ja player1won
	jb player2won
	jz itisadraw
	
	
	player1won: mov ah,2   ;move cursor
				mov dx,0E37h
				mov bx,0
				int 10h
				
				mov ah,9
				lea dx,player1wonmes
				int 21h
				jmp printingpressspace
				
	player2won: mov ah,2   ;move cursor
				mov dx,0E37h
				mov bx,0
				int 10h
				
				mov ah,9
				lea dx,player2wonmes
				int 21h
				jmp printingpressspace
	
	
	itisadraw:  mov ah,2   ;move cursor
				mov dx,0E37h
				mov bx,0
				int 10h
				
				mov ah,9
				lea dx,itisadrawmes
				int 21h
				jmp printingpressspace
	
	
printingpressspace:	mov ah,2   ;move cursor
					mov dx,1A34h
					mov bx,0
					int 10h
	
	mov ah,9
	lea dx,IntroMessage
	int 21h
	
	
	;wait for key to exit
WaitforSpace2:	
				mov ah,07;clear key from buffer
				int 21h
				cmp al,32
				jnz WaitforSpace2
				
	
ret
ScoreScreen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddBullet1 proc far
;Add the Bullet to the memory location to be drawn
	
	;timer to add bullets every second
	; mov ax,2c00h 
	; int 21h   
	; cmp booleantime,0
	; jnz hastimecome
	; mov bulletaddtimer,dh
	; mov booleantime,1
	
	; hastimecome:	
		; cmp dh,bulletaddtimer
		; jz addbulletreturn
		; mov bulletaddtimer,dh
		
	
	mov ah,1    ;check if player pressed space
    int 16h
	jz addbulletreturn
    cmp al,32
    jnz addbulletreturn
	mov ah,7    ;clear key from buffer
	int 21h
	
	
	Mov CX,BulletNumber
	LEA SI,Bullets1X
	LEA DI,Bullets1Y
	
		  
	
	AddBulletLoop:
		
		CMP word ptr [SI],0 ;CHECKING IF THERE IS A BULLET SAVED 
		JNZ NEXT
		CMP word ptr [DI],0
		JNZ NEXT
		
		ADDING: ;ADDING THE BULLET TO MEMORY
			MOV AX,SHOOTER1Y ;inverted x and y
			ADD AX,54
			MOV [SI],AX
			MOV AX,SHOOTER1X ;inverted x and y
			ADD AX,34
			MOV [DI],AX
			jmp addbulletreturn
			
		NEXT: 
		ADD SI,2
		ADD DI,2
		DEC CX
		JNZ AddBulletLoop
		
addbulletreturn :ret
AddBullet1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


AddBullet2 proc far
;Add the Bullet to the memory location to be drawn
	
	;timer to add bullets every second
	;mov ax,2c00h 
	;int 21h   
	;cmp booleantime2,0
	;jnz hastimecome2
	;mov bulletaddtimer2,dh
	;mov booleantime2,1
	;
	;hastimecome2:	
	;	cmp dh,bulletaddtimer2
	;	jz addbulletreturn2
	;	mov bulletaddtimer2,dh
	

	mov ah,1    ;check if player pressed space
    int 16h
	jz addbulletreturn2
    cmp al,120 ;x key for shooting
    jnz addbulletreturn2
	mov ah,7    ;clear key from buffer
	int 21h
	
	
	Mov CX,BulletNumber
	LEA SI,Bullets2X
	LEA DI,Bullets2Y
	
		  
	
	AddBulletLoop2:
		
		CMP word ptr [SI],0 ;CHECKING IF THERE IS A BULLET SAVED 
		JNZ NEXT2
		CMP word ptr [DI],0
		JNZ NEXT2
		
		ADDING2: ;ADDING THE BULLET TO MEMORY
			MOV AX,SHOOTER2Y ;inverted x and y
			ADD AX,54
			MOV [SI],AX
			MOV AX,SHOOTER2X ;inverted x and y
			SUB AX,23
			MOV [DI],AX
			jmp addbulletreturn2
			
		NEXT2: 
		ADD SI,2
		ADD DI,2
		DEC CX
		JNZ AddBulletLoop2
		
addbulletreturn2 :ret
AddBullet2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


BulletCollision1 proc far
mov si,offset Bullets1X    ;check if the bullets positions (if not zero) are collided with something  
mov di,offset Bullets1y
mov cx,11 
loopBulletcollision:push cx
					cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz tempbeginnextcollisionchecking  
                    cmp word ptr[di],0
                    jz tempbeginnextcollisionchecking 
					jmp checkBullWithShooterColl
					
					tempbeginnextcollisionchecking:jmp beginnextcollisionchecking
					
					checkBullWithShooterColl:mov bx,SHOOTER2X
											 cmp word ptr[di],bx ;x position compare
					                         jbe checkbullblock1
											 mov bx,SHOOTER2Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock1
											 mov bx,SHOOTER2Y ;y lower position compare
											 add bx,Shooterlength
											 cmp SHOOTER2BIGGER,1
											 jnz nomagnify
											 add bx,45        ;magnification difference
								nomagnify:	 cmp word ptr[si],bx
											 jg checkbullblock1
											 mov word ptr[si],0
											 mov word ptr[di],0
											 add CounterFreeze1,1
											 cmp CounterFreeze1,5
											 jnz temp1beginnextcollisionchecking
										
											 mov BooleanFreeze1,maxfreezetime;shooter2 should be freezed for 2 sec 
											 mov CounterFreeze1,0
											 jmp beginnextcollisionchecking
											 
					temp1beginnextcollisionchecking: jmp beginnextcollisionchecking		
											 
					
					
			        checkbullblock1:	mov tempbullety,si
										mov tempbulletx,di
										
									    ;check for blocks in the middle of the screen
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx1,MiddleBlocksy1,Middleblockboolean
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx3,MiddleBlocksy3,Middleblockboolean
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx5,MiddleBlocksy5,Middleblockboolean
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx2,MiddleBlocksy2,Middleblockbooleaninverted
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx4,MiddleBlocksy4,Middleblockbooleaninverted
										BlockCheckermiddle1 tempbulletx, tempbullety, MiddleBlocksx6,MiddleBlocksy6,Middleblockbooleaninverted
										
										
										;check for the blocks that add score
										BlockChecker1 tempbulletx, tempbullety, BLOCK13X,BLOCK13Y,TOBEDRAWNABLOCK+13
										BlockChecker1 tempbulletx, tempbullety, BLOCK14X,BLOCK14Y,TOBEDRAWNABLOCK+14
										BlockChecker1 tempbulletx, tempbullety, BLOCK15X,BLOCK15Y,TOBEDRAWNABLOCK+15
										BlockChecker1 tempbulletx, tempbullety, BLOCK16X,BLOCK16Y,TOBEDRAWNABLOCK+16
										BlockChecker1 tempbulletx, tempbullety, BLOCK17X,BLOCK17Y,TOBEDRAWNABLOCK+17
										BlockChecker1 tempbulletx, tempbullety, BLOCK18X,BLOCK18Y,TOBEDRAWNABLOCK+18
										BlockChecker1 tempbulletx, tempbullety, BLOCK19X,BLOCK19Y,TOBEDRAWNABLOCK+19
										BlockChecker1 tempbulletx, tempbullety, BLOCK20X,BLOCK20Y,TOBEDRAWNABLOCK+20
										BlockChecker1 tempbulletx, tempbullety, BLOCK21X,BLOCK21Y,TOBEDRAWNABLOCK+21
										BlockChecker1 tempbulletx, tempbullety, BLOCK22X,BLOCK22Y,TOBEDRAWNABLOCK+22
										BlockChecker1 tempbulletx, tempbullety, BLOCK23X,BLOCK23Y,TOBEDRAWNABLOCK+23
										BlockChecker1 tempbulletx, tempbullety, BLOCK24X,BLOCK24Y,TOBEDRAWNABLOCK+24
										
									
										
					checkbulllimit: cmp word ptr [di],ScreenWidth-15
									jbe beginnextcollisionchecking
									mov word ptr[si],0
									mov word ptr[di],0
									
					
                beginnextcollisionchecking:add si,2
										   add di,2
										   pop cx
										   dec cx  
										   cmp cx,0
				                   jnz temploopBulletcollision
								   jz BulletCollisionreturn
				
temploopBulletcollision: jmp loopBulletcollision

BulletCollisionreturn: ret

					
 
;IF THEY ARE NOT CHECK IF THEY COLLIDE WITH THE SHOOTER 
;THEN CHECK IF THEY COLLIDE WITH THE BLOCKS IF THEY ARE AT THE X OF THE FIRST BLOCKS
;IF IT COLLIDED RESET BULLET AND DELETE BLOCK 
;THEN CHECK FOR THE NEXT BLOCKS 
;SAME AS ABOVE 
;THEN CHECK IF IT IS AT THE END
;IF THEY COLLIDED RESET THE BULLET 

BulletCollision1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BulletCollision2 proc far
mov si,offset Bullets2X    ;check if the bullets positions (if not zero) are collided with something  
mov di,offset Bullets2y
mov cx,11 
loopBulletcollision2:push cx
					cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz tempbeginnextcollisionchecking2  
                    cmp word ptr[di],0
                    jz tempbeginnextcollisionchecking2
					jmp checkBullWithShooterColl2
					
					tempbeginnextcollisionchecking2:jmp beginnextcollisionchecking2
					
					
					checkBullWithShooterColl2:mov bx,SHOOTER1X
											 cmp word ptr[di],bx
					                         jge checkbullblock12
											 mov bx,SHOOTER1Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock12
											 mov bx,SHOOTER1Y ;y lower position compare
											 add bx,Shooterlength
											 cmp SHOOTER1BIGGER,1
											 jnz nomagnify2
											 add bx,45        ;magnification difference
							nomagnify2:		 cmp word ptr[si],bx
											 jg checkbullblock12
											 mov word ptr[si],0
											 mov word ptr[di],0
											 add CounterFreeze2,1
											 cmp CounterFreeze2,5
											 jnz temp2beginnextcollisionchecking2
										
											 mov BooleanFreeze2,maxfreezetime;shooter1 should be freezed for 5sec 
											 mov CounterFreeze2,0
											 jmp beginnextcollisionchecking2  

					temp2beginnextcollisionchecking2: jmp beginnextcollisionchecking2	

											 
			        checkbullblock12:
									 mov tempbullety,si
									 mov tempbulletx,di
									 
									 ;check for the blocks in the middle
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx1,MiddleBlocksy1,Middleblockboolean
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx3,MiddleBlocksy3,Middleblockboolean
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx5,MiddleBlocksy5,Middleblockboolean
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx2,MiddleBlocksy2,Middleblockbooleaninverted
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx4,MiddleBlocksy4,Middleblockbooleaninverted
									 BlockCheckermiddle2 tempbulletx, tempbullety, MiddleBlocksx6,MiddleBlocksy6,Middleblockbooleaninverted
									 
									
									;check for the blocks that add score
									 BlockChecker2 tempbulletx, tempbullety, BLOCK1X ,BLOCK1Y ,TOBEDRAWNABLOCK+1
									 BlockChecker2 tempbulletx, tempbullety, BLOCK2X ,BLOCK2Y ,TOBEDRAWNABLOCK+2
									 BlockChecker2 tempbulletx, tempbullety, BLOCK3X ,BLOCK3Y ,TOBEDRAWNABLOCK+3
									 BlockChecker2 tempbulletx, tempbullety, BLOCK4X ,BLOCK4Y ,TOBEDRAWNABLOCK+4
									 BlockChecker2 tempbulletx, tempbullety, BLOCK5X ,BLOCK5Y ,TOBEDRAWNABLOCK+5
									 BlockChecker2 tempbulletx, tempbullety, BLOCK6X ,BLOCK6Y ,TOBEDRAWNABLOCK+6
									 BlockChecker2 tempbulletx, tempbullety, BLOCK7X ,BLOCK7Y ,TOBEDRAWNABLOCK+7
									 BlockChecker2 tempbulletx, tempbullety, BLOCK8X ,BLOCK8Y ,TOBEDRAWNABLOCK+8
									 BlockChecker2 tempbulletx, tempbullety, BLOCK9X ,BLOCK9Y ,TOBEDRAWNABLOCK+9
									 BlockChecker2 tempbulletx, tempbullety, BLOCK10X,BLOCK10Y,TOBEDRAWNABLOCK+10
									 BlockChecker2 tempbulletx, tempbullety, BLOCK11X,BLOCK11Y,TOBEDRAWNABLOCK+11
									 BlockChecker2 tempbulletx, tempbullety, BLOCK12X,BLOCK12Y,TOBEDRAWNABLOCK+12
									 
					checkbulllimit2:cmp word ptr [di],0 ;screen limit
									jge beginnextcollisionchecking2
									mov word ptr[si],0
									mov word ptr[di],0
									
                beginnextcollisionchecking2:add si,2
										   add di,2
										   pop cx
										   dec cx  
										   cmp cx,0
				                   jnz temploopBulletcollision2
								   jz BulletCollisionreturn2
				
temploopBulletcollision2: jmp loopBulletcollision2

BulletCollisionreturn2: ret

					
 
;IF THEY ARE NOT CHECK IF THEY COLLIDE WITH THE SHOOTER 
;THEN CHECK IF THEY COLLIDE WITH THE BLOCKS IF THEY ARE AT THE X OF THE FIRST BLOCKS
;IF IT COLLIDED RESET BULLET AND DELETE BLOCK 
;THEN CHECK FOR THE NEXT BLOCKS 
;SAME AS ABOVE 
;THEN CHECK IF IT IS AT THE END
;IF THEY COLLIDED RESET THE BULLET 

BulletCollision2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MainMenu proc far

			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by callibg graphics mode
dispgameframe:mov ah,2     ;moving the cursor to the center of the screen
              mov dx,0A32h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the main page(frame)
              mov dx,offset frameMes1
              int 21h

              mov ah,2     ;moving the cursor to the center of the screen
              mov dx,1032h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the main page(frame)
              mov dx,offset frameMes2
              int 21h

              mov ah,2     ;moving the cursor to the center of the screen
              mov dx,1632h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the main page(frame)
              mov dx,offset frameMes3
			  mov bx,0
              int 21h

notificationBar:mov ah,2     ;moving the cursor to the below the frame messages to create the notificationbar
                mov dx,2500h
				mov bx,0
                int 10h

                mov ah,9     ;displaying the main page(frame)
                mov dx,offset notbarmess
                int 21h
				
				mov ah,2     ;moving the cursor to Print Username
                mov dx,2602h
				mov bx,0
                int 10h

                mov ah,9     ;print Username
                mov dx,offset UserNameDatastring
                int 21h
				

ret
MainMenu endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawbullet1 proc far 

     mov si,offset Bullets1X
     mov di,offset Bullets1Y
	  
		  mov cx,10
     begin:push cx
	      cmp word ptr [si],0
          jz nexttoDraw
          cmp word ptr [di],0
          jz nexttoDraw
	       mov cx,[di] 
           mov dx,[si] 
		   
		   lea bx,bulletcolorfacingright
		   
		   mov al,10
		   mov ah,20
		   
     loopoutery: mov cx,[di]
				 mov ah,20
           loopinnerx:push ax
                      mov al,[bx]
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc cx 
					  inc bx
					  dec ah
                      cmp ah,0
                      jnz loopinnerx
                      
           inc dx
		   dec al
           cmp al,0
           jnz loopoutery
           
          
  nexttoDraw:   add si,2
                add di,2
				pop cx
				dec cx
				cmp cx,0
				jnz begin
          
DrawReturn:   ret   
drawbullet1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawbullet2 proc far 

     mov si,offset Bullets2X
     mov di,offset Bullets2Y
	  
		  mov cx,10
     begin2:push cx
	      cmp word ptr [si],0
          jz nexttoDraw2
          cmp word ptr [di],0
          jz nexttoDraw2
	       mov cx,[di] 
           mov dx,[si] 
           
		   lea bx,bulletcolorfacingleft
		   
		   mov al,10
		   mov ah,20
		   
		   
     loopoutery2: mov cx,[di]
				  mov ah,20
           loopinnerx2:push ax
                      mov al,[bx]
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc cx
					  inc bx
					  dec ah
                      cmp ah,0
                      jnz loopinnerx2
                      
           inc dx
		   dec al
           cmp al,0
           jnz loopoutery2
           
          
  nexttoDraw2:  add si,2
                add di,2
				pop cx
				dec cx
				cmp cx,0
				jnz begin2
          
DrawReturn2:   ret   
drawbullet2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BulletClear1 proc far 

     mov si,offset Bullets1X
     mov di,offset Bullets1Y
	  
		  mov cx,10
     beginClearing:push cx
	      cmp word ptr [si],0
          jz nexttoClear
          cmp word ptr [di],0
          jz nexttoClear
	       mov cx,[di] 
           mov dx,[si] 
           mov ax,[si] 
           add ax,10 
            
           mov bx,[di] 
           add bx,20 
           
     loopouterClearingy: mov dx,[si]
	 
           loopinnerClearingx:push ax
                      mov al,0h
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc dx 
                      cmp dx,ax
                      jnz loopinnerClearingx
                      
           inc cx
           cmp cx,bx
           jnz loopouterClearingy
           
          
  nexttoClear:   add si,2
                add di,2
				pop cx
				dec cx
				cmp cx,0
				jnz beginClearing
ret				
BulletClear1 endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BulletClear2 proc far 

     mov si,offset Bullets2X
     mov di,offset Bullets2Y
	  
		  mov cx,10
     beginClearing2:push cx
	      cmp word ptr [si],0
          jz nexttoClear2
          cmp word ptr [di],0
          jz nexttoClear2
	       mov cx,[di] 
           mov dx,[si] 
           mov ax,[si] 
           add ax,10 
            
           mov bx,[di] 
           add bx,20 
           
     loopouterClearingy2: mov dx,[si]
	 
           loopinnerClearingx2:push ax
                      mov al,0h
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc dx 
                      cmp dx,ax
                      jnz loopinnerClearingx2
                      
           inc cx
           cmp cx,bx
           jnz loopouterClearingy2
           
          
  nexttoClear2:   add si,2
                add di,2
				pop cx
				dec cx
				cmp cx,0
				jnz beginClearing2
ret				
BulletClear2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BulletAnimation1 proc far
					mov si,offset Bullets1X
					mov di,offset Bullets1Y
					mov cx,10
loopanimationbullet:cmp word ptr [si],0
                    jz beginnextanimation
					cmp word ptr [di],0
					jz beginnextanimation
					
					add word ptr [di],BulletSpeed
					
                beginnextanimation:add si,2
								   add di,2
								   dec cx
								   cmp cx,0
				                   jnz loopanimationbullet
								  
				

Bulletanimatedreturn: ret
BulletAnimation1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BulletAnimation2 proc far
					mov si,offset Bullets2X
					mov di,offset Bullets2Y
					mov cx,11
loopanimationbullet2:cmp word ptr [si],0
                    jz beginnextanimation2
					cmp word ptr [di],0
					jz beginnextanimation2
					
					sub word ptr [di],BulletSpeed
					
                beginnextanimation2:
								   add si,2
								   add di,2
								   dec cx
								   cmp cx,0
				                   jnz loopanimationbullet2
								  
				

Bulletanimatedreturn2: ret
BulletAnimation2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADJUST_POSITION2 PROC     ;PROCEDURE TO ADJUST COORDINATES OF THE SHOOTER'S 
						 ;POSITION TO BE UPDATED IN THE SUBSEQUENT FRAME
						 
		cmp BooleanFreeze1,0 ;checking if  shooter1 is freezed
        jz StartAdj2	
        dec BooleanFreeze1
		jmp exitadjust1	
		
				;CHECKING WHETHER USER HAS PRESSED A KEY
	StartAdj2:	MOV AH,1  ;RETURNS THE CORRESPONDING KEY'S SCANCODE IN AH
		INT 16H
		jz exitadjust1
	
	CMP AH,1EH    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED
	
	CMP AH,2CH    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED
	
	JMP exitadjust1  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	
	UP_PRESSED:
		CMP SHOOTER2Y,30
		JL exitadjust1
		SUB SHOOTER2Y,Shooter2Speed  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		MOV BX,0       
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust1
	
	DOWN_PRESSED:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER2Y,460
		JGE exitadjust1
		ADD SHOOTER2Y,Shooter2Speed
		MOV BX,0
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust1
		
		
exitadjust1:	RET

ADJUST_POSITION2 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADJUST_POSITION1 PROC     ;PROCEDURE TO ADJUST COORDINATES OF THE SHOOTER'S 
						 ;POSITION TO BE UPDATED IN THE SUBSEQUENT FRAME
						 
	cmp BooleanFreeze2,0 ;checking if  shooter1 is freezed
    jz StartAdj1	
    dec BooleanFreeze2
	jmp exitadjust2
		  
				;CHECKING WHETHER USER HAS PRESSED A KEY
	StartAdj1:	MOV AH,1  ;RETURNS THE CORRESPONDING KEY'S SCANCODE IN AH
		INT 16H
		jz exitadjust2
	
	CMP AH,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED2
	
	CMP AH,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED2
	
	JMP exitadjust2  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	
	UP_PRESSED2:
		CMP SHOOTER1Y,30
		JLE exitadjust2
		SUB SHOOTER1Y,Shooter1Speed  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		MOV BX,0       
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust2
	
	DOWN_PRESSED2:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER1Y,470
		JGE exitadjust2
		ADD SHOOTER1Y,Shooter1Speed
		MOV BX,0
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust2
		
		
exitadjust2:	RET

ADJUST_POSITION1 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeGame proc far
;Sets the memory to the Default values of beggining a new game

mov Bullets2Y   ,0 ;Player 2 Bullets Init
mov Bullets2Y+2 ,0
mov Bullets2Y+4 ,0
mov Bullets2Y+6 ,0
mov Bullets2Y+8 ,0
mov Bullets2Y+10,0
mov Bullets2Y+12,0
mov Bullets2Y+14,0
mov Bullets2Y+16,0
mov Bullets2Y+18,0
		   
mov Bullets2X   ,0
mov Bullets2X+2 ,0
mov Bullets2X+4 ,0
mov Bullets2X+6 ,0
mov Bullets2X+8 ,0
mov Bullets2X+10,0
mov Bullets2X+12,0
mov Bullets2X+14,0
mov Bullets2X+16,0
mov Bullets2X+18,0

mov Bullets1Y   ,0 ;Player 1 Bullet Init
mov Bullets1Y+2 ,0
mov Bullets1Y+4 ,0
mov Bullets1Y+6 ,0
mov Bullets1Y+8 ,0
mov Bullets1Y+10,0
mov Bullets1Y+12,0
mov Bullets1Y+14,0
mov Bullets1Y+16,0
mov Bullets1Y+18,0

mov Bullets1X   ,0
mov Bullets1X+2 ,0
mov Bullets1X+4 ,0
mov Bullets1X+6 ,0
mov Bullets1X+8 ,0
mov Bullets1X+10,0
mov Bullets1X+12,0
mov Bullets1X+14,0
mov Bullets1X+16,0
mov Bullets1X+18,0


mov SHOOTER1X , 100  ;Shooter Init
mov SHOOTER1Y , 200   
mov SHOOTER2X , 900  
mov SHOOTER2Y , 430
mov SHOOTER2BIGGER,0
mov SHOOTER1BIGGER,0

mov booleantime,0  ;Timer Init
mov Timervalue,60
mov booleantime2,0

MOV TOBEDRAWNABLOCK+1,1 
MOV TOBEDRAWNABLOCK+2,1 
MOV TOBEDRAWNABLOCK+3,1 
MOV TOBEDRAWNABLOCK+4,1 
MOV TOBEDRAWNABLOCK+5,1 
MOV TOBEDRAWNABLOCK+6,1 
MOV TOBEDRAWNABLOCK+7,1 
MOV TOBEDRAWNABLOCK+8,1 
MOV TOBEDRAWNABLOCK+9,1 
MOV TOBEDRAWNABLOCK+10,1 
MOV TOBEDRAWNABLOCK+11,1 
MOV TOBEDRAWNABLOCK+12,1 
MOV TOBEDRAWNABLOCK+13,1 
MOV TOBEDRAWNABLOCK+14,1 
MOV TOBEDRAWNABLOCK+15,1 
MOV TOBEDRAWNABLOCK+16,1 
MOV TOBEDRAWNABLOCK+17,1 
MOV TOBEDRAWNABLOCK+18,1 
MOV TOBEDRAWNABLOCK+19,1
MOV TOBEDRAWNABLOCK+20,1 
MOV TOBEDRAWNABLOCK+21,1 
MOV TOBEDRAWNABLOCK+22,1 
MOV TOBEDRAWNABLOCK+23,1
MOV TOBEDRAWNABLOCK+24,1    

MOV booleantime3 , 0

MOV CounterFreeze1 , 0
MOV BooleanFreeze1 , 0
MOV CounterFreeze2 , 0
MOV BooleanFreeze2 , 0

mov Player1Score,0
mov Player2Score,0

mov CounterFreeze1,0
mov BooleanFreeze1,0
mov CounterFreeze2,0
mov BooleanFreeze2,0

ret
InitializeGame endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;

Usernamescreen proc far

			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by calling graphics mode
			  
			  mov ah,2     ;moving the cursor to the center of the screen
              mov dx,1832h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the enter your name message
              mov dx,offset Usernamemessage
              int 21h
				
				
			  mov ah,2     ;moving the cursor down the screen
              mov dx,2032h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the press enter to continue
              mov dx,offset Usernamecontinuemessage
              int 21h
			  
			  
			  mov ah,2     ;moving the cursor up the screen
              mov dx,1A39H
			  mov bx,0
              int 10h
			  
						   ;Reading the Username
			  mov bx,0
			  mov ah,0AH 
			  mov dx,offset UserNameDATA 
			  int 21h 
ret
Usernamescreen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main proc far
	mov ax,@data
	mov ds,ax ; copy data segment
	
	mov ax, 4f02h
	mov bx, 105h
	int 10h ;graphical mode interrupt
	
	Call GameName
	
	Call Usernamescreen  ;user name screen 
	
Mainmenujump:	CALL MainMenu
				
	                
WaitingForKeyPressed:mov ah,0
                     int 16h
                     cmp al,1bh
                     jz tempexitmain
                     cmp ah,3Bh
                     jz chattingmode  
                     cmp ah,3Ch
                     jz playingmode
                     jmp WaitingForKeyPressed
					 
      
chattingmode: ;/////////////if f1 is pressed
              




tempexitmain: jmp  Exitmain  ;becaus jumps are too big
tempjump2:

playingmode:  ;/////////////if f2 is pressed 

			
			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by calling graphics mode
			  
			  call InitializeGame ;set default values of memory
			  
			  CALL DRAWRIGHTWALLS ;draw blocks
			  CALL DRAWLEFTWALLS  
				
		maingameloop:
		
				
				mov cx, 0H    ;  delay
				mov dx, 8235h
				mov ah, 86H
				int 15H
				
				push si
                push di
				
				
				call CLEARSHOOTER1  ;Shooter Functions
				call CLEARSHOOTER2
				call ADJUST_POSITION1
				call ADJUST_POSITION2				
				call DRAWSHOOTER1
				call DRAWSHOOTER2
				
				call AddBullet1 ;Bullet functions
				call BulletClear1
				call BulletAnimation1
                call BulletCollision1
				call drawbullet1
				
				call AddBullet2 ;Bullet functions
				call BulletClear2
				call BulletAnimation2
                call BulletCollision2
				call drawbullet2
				
				call BlinkMiddleandInvert ;inverts the middle blocks every second as well as draw them 
				
				call StatusBar
				
				
				mov al,Timervalue
				cmp al,0
				jz ScoreScreenjmp ; ***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
				cmp Player1Score,12
				jz ScoreScreenjmp ;***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
				cmp Player2Score,12
				jz ScoreScreenjmp ;***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
                pop di
                pop si
			
			mov ah,1    ;check if player pressed exit
            int 16h
			jz cont
            mov ah,7    ;clear key from buffer
			int 21h
			cmp al,1bh
            jz tempmainmenujmp
			
					 
     cont:  jmp maingameloop              
	
	tempmainmenujmp:jmp Mainmenujump
	
	ScoreScreenjmp: call ScoreScreen
					jmp Mainmenujump
	
	Exitmain: 
	mov ax,0003h
	int 10h ;return video mode
	
	mov ah,4ch
	int 21h  ;return program to dos
	
Main endp

end main 