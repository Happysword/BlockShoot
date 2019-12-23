

;;;;;;;MACROS;;;;;;;;;;;

resetmainmenu MACRO

mov chatmoderecieveboolean , 0  
mov chatmodesendboolean    , 0
mov playmodesendboolean    , 0
mov playmoderecieveboolean , 0
mov VALUERECIEVED,0
mov VALUESENT,0
ENDM

RECIEVEMACRO MACRO
LOCAL RECIEVECHK

	;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JZ RECIEVECHK                                    ;Not Ready
		
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al
		

RECIEVECHK:

ENDM

SENDMACRO MACRO 
LOCAL AGAINSEND,nothingsent

	mov ah,1
	int 16h
	jz nothingsent
	MOV VALUESENT,AH
	
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
		
AGAINSEND:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSEND                               ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
		mov ah,7  ;;;;clear buffer;;;
		int 21h 

nothingsent:
ENDM 

SMALLSENDMACRO MACRO
LOCAL AGAINSEND11
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
		
AGAINSEND11:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSEND11                             ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
ENDM
SENDMACRO2 MACRO 
LOCAL AGAINSEND2,nothingsent2,somethingsent

	mov ah,1
	int 16h
	jz nothingsent2
	MOV VALUESENT,AH
	
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
		
AGAINSEND2:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSEND2                              ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
		mov ah,7  ;;;;clear buffer;;;
		int 21h 
		jmp somethingsent

nothingsent2:
call sendandrecievetime
somethingsent:
ENDM 


;DRAW A GLUE MACRO
DRAWAGLUE MACRO GLUEX,GLUEY
	LOCAL @@DRAWG,@@BACKG  ;BECAUSE WE NEED TO CALL MACROS MORE THAN ONCE MUST USE LOCAL NUMERIC LABELS ;REGULAR LABELS WONT WORK
	MOV BX,00
	ADD BX,GLUEY
	ADD BX,90   		;PUTTING IN BX GLUE MAX LENGTH
	@@DRAWG:
		MOV CX,GLUEX	;DRAWING PIXELS HORIZONTALLY
		MOV DX,GLUEY	
		MOV AL,07	    ;CHOOSING WHITE COLOR
		MOV AH,0CH
	@@BACKG:
		INT 10H
		INC CX
		ADD GLUEX,07  ;GLUE MAX WIDTH
		CMP CX,GLUEX
		PUSHF			;ADJUSTING FLAGS
		SUB GLUEX,07  
		POPF
		JNZ @@BACKG   ;TILL HERE
		
	INC GLUEY			
	CMP GLUEY,BX
	JNE @@DRAWG 		;KEEP DRAWING HORIZONTALLY
	SUB GLUEY,90  

ENDM

;DELETE A GLUE MACRO
DELETEAGLUE MACRO GLUEX, GLUEY
    LOCAL @@DRAWWG, @@BACKKG         ;BECAUSE WE NEED TO CALL MACROS MORE THAN ONCE MUST USE LOCAL NUMERIC LABELS ;REGULAR LABELS WONT WORK
	MOV BX,00
	ADD BX,GLUEY
	ADD BX,90   		;PUTTING IN BX GLUE MAX LENGTH
	@@DRAWWG:
		MOV CX,GLUEX	;DRAWING PIXELS HORIZONTALLY
		MOV DX,GLUEY	
		MOV AL,00	    ;IN BLACK COLOR
		MOV AH,0CH
	@@BACKKG:
		INT 10H
		INC CX
		ADD GLUEX,07  ;GLUE MAX WIDTH
		CMP CX,GLUEX
		PUSHF			;ADJUSTING FLAGS
		SUB GLUEX,07  
		POPF
		JNZ @@BACKKG  
		
	INC GLUEY		
	CMP GLUEY,BX
	JNE @@DRAWWG  		;KEEP DRAWING HORIZONTALLY
	SUB GLUEY,90
	       
	ENDM

	;NACRO TO DRAW ALL GLUES NEEDED WE WILL CALL IT AFTER EVERY BULLET        

DRAWGLUES MACRO
    CALL DRAWGLUE12
    CALL DRAWGLUE34
    CALL DRAWGLUE56
    CALL DRAWGLUE78
    CALL DRAWGLUE910
    CALL DRAWGLUE1112
    CALL DRAWGLUE1314
	CALL DRAWGLUE1516
    CALL DRAWGLUE1718
    CALL DRAWGLUE1920
    CALL DRAWGLUE2122
    CALL DRAWGLUE2324
 ENDM


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

GlueChecker1  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITGlueCHECKER1

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,1                        
JNZ EXITGlueCHECKER1 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME X 
JB EXITGlueCHECKER1                          
                                              
MOV BX,BLOCKYY    
sub bx,5                            
cmp word ptr [si],BX                          
JB EXITGlueCHECKER1                          
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITGlueCHECKER1

MOV word ptr [si],0
MOV word ptr [di],0
MOV BLOCKDRAWNNUMBER,2
DELETEAGLUE BLOCKXX , BLOCKYY

EXITGlueCHECKER1:
ENDM

BlockCheckermiddle1_L2  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER ;aya
local EXITBLOCKCHECKERMIDDLE121

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKERMIDDLE121 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME first X 
JB EXITBLOCKCHECKERMIDDLE121      

MOV BX,BLOCKXX  
ADD BX,BlockwidthMiddle+20               
cmp word ptr [di],BX  ;CHECK IF AT THE SAME  last X 
JG EXITBLOCKCHECKERMIDDLE121                          
                                              
MOV BX,BLOCKYY   
sub bx,5                             
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKERMIDDLE121                          
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                           
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKERMIDDLE121

MOV word ptr [si],0
MOV word ptr [di],0
mov ax,BLOCKXX
SUB ax,70
mov tempbarrierTipbullx1,ax
mov ax,BLOCKYY
sub ax,15
mov tempbarrierTipbully1,ax
call addbarbullet2

EXITBLOCKCHECKERMIDDLE121:
ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;
BlockCheckermiddle2_L2  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER ;aya 
local EXITBLOCKCHECKERMIDDLE22

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,0                        
JZ EXITBLOCKCHECKERMIDDLE22 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME first X 
JG EXITBLOCKCHECKERMIDDLE22     
               
MOV BX,BLOCKXX  
sub bx,BlockwidthMiddle+20                              
cmp word ptr [di],BX  ;CHECK IF AT THE SAME last X 
JL EXITBLOCKCHECKERMIDDLE22                          
                                              
MOV BX,BLOCKYY  
sub bx,5                              
cmp word ptr [si],BX                          
JB EXITBLOCKCHECKERMIDDLE22                         
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITBLOCKCHECKERMIDDLE22

MOV word ptr [si],0
MOV word ptr [di],0
mov ax,BLOCKXX
sub ax,23
mov tempbarrierTipbullx2,ax
mov ax,BLOCKYY
sub ax,20
mov tempbarrierTipbully2,ax

call addbarbullet1


EXITBLOCKCHECKERMIDDLE22:
ENDM
;;;;;;;;;;;;;;;;;;;;;;;

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

GlueChecker2  MACRO offsetBulletx, offsetBullety, BLOCKXX, BLOCKYY ,BLOCKDRAWNNUMBER
local EXITGlueCHECKER2

mov di,offsetBulletx						
mov si,offsetBullety                          
											
cmp BLOCKDRAWNNUMBER,1                       
JNZ EXITGlueCHECKER2 ;CHECK IF IT DOESNT EXIST
                                              
MOV BX,BLOCKXX                                
cmp word ptr [di],BX  ;CHECK IF AT THE SAME X 
JG EXITGlueCHECKER2                          
                                              
MOV BX,BLOCKYY     
sub bx,5                           
cmp word ptr [si],BX                          
JB EXITGlueCHECKER2                         
                                              
MOV BX,BLOCKYY                                
Add BX,Blockheight+5                            
CMP word ptr [si],BX                          
JA EXITGlueCHECKER2

MOV word ptr [si],0
MOV word ptr [di],0
MOV BLOCKDRAWNNUMBER,2
DELETEAGLUE BLOCKXX , BLOCKYY

EXITGlueCHECKER2:
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

DRAWBarrierTip MACRO BLOCKX,BLOCKY,BCOLOR ;aya
	LOCAL @@DRAW,@@BACK  ;BECAUSE WE NEED
	MOV BX,00
	ADD BX,BLOCKY
	ADD BX,30  ;PUTTING IN BX BLOCK MAX L
	@@DRAW:
		MOV CX,BLOCKX	;DRAWING PIXELS H
		MOV DX,BLOCKY	
		MOV AL,BCOLOR	    ;CHOOSING COL
		MOV AH,0CH
	@@BACK:
		INT 10H
		INC CX
		ADD BLOCKX,10  ;BLOCK MAX WIDTH
		CMP CX,BLOCKX
		PUSHF			;ADJUSTING FLAGS
		SUB BLOCKX,10 
		POPF
		JNZ @@BACK   ;TILL HERE
		
	INC BLOCKY			
	CMP BLOCKY,BX
	JNE @@DRAW 		;KEEP DRAWING HORIZON
	SUB BLOCKY,30   

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
;EXTRN Sound:FAR TODO
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
tempbarrierTipbullx1 dw ?;aya
tempbarrierTipbully1 dw ?
tempbarrierTipbullx2 dw ?
tempbarrierTipbully2 dw ?


Blockheight equ 90
Blockwidth  equ 40

BlocksLeftColor1  equ 11
BlocksRightColor1 equ 12
BlocksLeftColor2  equ 1
BlocksRightColor2 equ 4

;CHECK IF GLUE IS DRAWN ZERO BY DEFAULT
;IF IT'S DRAWN I MADE IT TO CHANGE TO ONE
ISGLUEDRAWN DB 0,12 DUP(0)    

;DATA FOR DRAWING GLUE
 
;GLUE FOR BLOCKS 1,2 FROM RIGHT
GLUE12X DW 88 
GLUE12Y DW 20

GLUE34X DW 88
GLUE34Y DW 115

GLUE56X DW 88
GLUE56Y DW 210

GLUE78X DW 88
GLUE78Y DW 305

GLUE910X DW 88
GLUE910Y DW 400

GLUE1112X DW 88
GLUE1112Y DW 495

GLUE1314X DW 929 
GLUE1314Y DW 20

GLUE1516X DW 929
GLUE1516Y DW 115

GLUE1718X DW 929
GLUE1718Y DW 210

GLUE1920X DW 929
GLUE1920Y DW 305

GLUE2122X DW 929
GLUE2122Y DW 400

GLUE2324X DW 929
GLUE2324Y DW 495


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

;;;;;;;;;;;;;;;;;;aya

barrierTipx11 dw 490
barrierTipy1 dw 50
barrierTipx12 dw 510

barrierTipx21 dw 490
barrierTipy2 dw 144
barrierTipx22 dw 510


barrierTipx31 dw 490
barrierTipy3 dw 238
barrierTipx32 dw 510


barrierTipx41 dw 490
barrierTipy4 dw 332
barrierTipx42 dw 510


barrierTipx51 dw 490
barrierTipy5 dw 426
barrierTipx52 dw 510


barrierTipx61 dw 490
barrierTipy6 dw 520
barrierTipx62 dw 510
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
booleanisbigger1 db 0
booleanisbigger2 db 0

frameMes2 db 'Press F2 To Start A New Game',10,'$'
frameMes1 db ' Press F1 To Enter Chat Mode',10,13,'$'
frameMes3 db 'Press ESC to Exit The Game',10,'$'
Usernamemessage db 'Please Enter your Name :','$'
Usernamemessage2 db 'Please Enter your Name Player 2 :','$'
Usernamecontinuemessage db 'Press Enter to Continue','$'
UserNameDATA db 20				;Must stay in this order
UserNameDataNumber db 0            ;Must stay in this order
UserNameDatastring db 20 dup('$')    ;Must stay in this order

UserNameDATA2 db 20				;Must stay in this order
UserNameDataNumber2 db 0            ;Must stay in this order
UserNameDatastring2 db 20 dup('$')
Usernamebarring db ' : $'
tempuserstring db 20 dup('$')

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

halfTheScreenWidth equ 512
ThescreenheightbeforeTheNotbar equ 608
screenWidth equ 1024

Level db ?
Lvl1mess db "Press 1 for level 1",'$'
Lvl2mess db "Press 2 for level 2",'$'
clearlevel db "                             ",'$'

;;;;;;;;;SERIAL MAINMENU;;;;;;;;;
GAMEMODE  db ?
PlayerNumber  db ?  
chatmoderecieveboolean db 0  
chatmodesendboolean    db 0
playmodesendboolean    db 0
playmoderecieveboolean db 0
Inviteplaysent db 'Play invite Sent','$'
Inviteplayrecieved db 'Play invite Recieved','$'
Invitechatsent db 'Chat invite Sent','$'
Invitechatrecieved db 'Chat invite Recieved','$'
SyncCHAR equ 0A6h
;;;;;;;;SERIAL CHAT MODE;;;;;;;;

VALUESENT DB ?
VALUERECIEVED DB ?
sendcursorx db 0
sendcursory db 0
recievecursorx db 0
ingamecursor db 0
recievecursory db 13
SendString db 80 dup(' '),'$'
SendStringIndex dw 0
SendString2 db 128 dup(' '),'$'
SendStringIndex2 dw 0

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clearserial proc far

beginclearserial:
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JZ clearserialend                                    ;Not Ready
		
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al
jmp beginclearserial		

clearserialend:
mov VALUERECIEVED,0
mov VALUESENT,0
ret
clearserial endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

;PROCEDURES TO DRAW A GLUE

DRAWGLUE12 PROC
	  cmp ISGLUEDRAWN+1,2
	  jz END12
      CMP TOBEDRAWNABLOCK+13,0
      JZ L1
      JNZ END12
      L1: CMP TOBEDRAWNABLOCK+14,0
      JZ L2
      JNZ END12
   L2: DRAWAGLUE GLUE12X,GLUE12Y 
       MOV ISGLUEDRAWN+1,1
  END12: 
  RET
    DRAWGLUE12 ENDP  


DRAWGLUE34 PROC
	  cmp ISGLUEDRAWN+2,2
	  jz END34
        CMP TOBEDRAWNABLOCK+15,0
      JZ L3
      JNZ END34
      L3: CMP TOBEDRAWNABLOCK+16,0
      JZ L4
      JNZ END34
    
   L4: DRAWAGLUE GLUE34X,GLUE34Y 
       MOV ISGLUEDRAWN+2,1
 END34:   RET
    DRAWGLUE34 ENDP  



DRAWGLUE56 PROC
	  cmp ISGLUEDRAWN+3,2
	  jz END56
        CMP TOBEDRAWNABLOCK+17,0
      JZ L5
      JNZ END56
      L5: CMP TOBEDRAWNABLOCK+18,0
      JZ L6
      JNZ END56
    
   L6:  DRAWAGLUE GLUE56X,GLUE56Y
   MOV ISGLUEDRAWN+3,1
   END56: RET
    DRAWGLUE56 ENDP  

                      			  
DRAWGLUE78 PROC
	  cmp ISGLUEDRAWN+4,2
	  jz END78
        CMP TOBEDRAWNABLOCK+19,0
      JZ L7
      JNZ END78
      L7: CMP TOBEDRAWNABLOCK+20,0
      JZ L8
      JNZ END78
    
   L8: DRAWAGLUE GLUE78X,GLUE78Y
   MOV ISGLUEDRAWN+4,1
   END78:  RET
    DRAWGLUE78 ENDP  

DRAWGLUE910 PROC
	  cmp ISGLUEDRAWN+5,2
	  jz END910
       CMP TOBEDRAWNABLOCK+21,0
      JZ L9
      JNZ END910
      L9: CMP TOBEDRAWNABLOCK+22,0
      JZ L10
      JNZ END910
    
   L10:DRAWAGLUE GLUE910X,GLUE910Y
   MOV ISGLUEDRAWN+5,1
  END910:  RET
    DRAWGLUE910 ENDP 


DRAWGLUE1112 PROC
	  cmp ISGLUEDRAWN+6,2
	  jz END1112
      CMP TOBEDRAWNABLOCK+23,0
      JZ L11
      JNZ END1112
      L11: CMP TOBEDRAWNABLOCK+24,0
      JZ L12
      JNZ END1112
    
   L12: DRAWAGLUE GLUE1112X,GLUE1112Y
   MOV ISGLUEDRAWN+6,1
    END1112: RET
    DRAWGLUE1112 ENDP

   
DRAWGLUE1314 PROC
	  cmp ISGLUEDRAWN+7,2
	  jz END1314
      CMP TOBEDRAWNABLOCK+1,0
      JZ L13
      JNZ END1314
      L13: CMP TOBEDRAWNABLOCK+2,0
      JZ L14
      JNZ END1314
    
   L14: DRAWAGLUE GLUE1314X,GLUE1314Y 
   MOV ISGLUEDRAWN+7,1
    END1314: RET
    DRAWGLUE1314 ENDP

DRAWGLUE1516 PROC
	  cmp ISGLUEDRAWN+8,2
	  jz END1516
       CMP TOBEDRAWNABLOCK+3,0
      JZ L15
      JNZ END1516
      L15: CMP TOBEDRAWNABLOCK+4,0
      JZ L16
      JNZ END1516
    
   L16:DRAWAGLUE GLUE1516X,GLUE1516Y 
   MOV ISGLUEDRAWN+8,1
   END1516: RET
    DRAWGLUE1516 ENDP

DRAWGLUE1718 PROC
	  cmp ISGLUEDRAWN+9,2
	  jz END1718
       CMP TOBEDRAWNABLOCK+5,0
      JZ L17
      JNZ END1718
      L17: CMP TOBEDRAWNABLOCK+6,0
      JZ L18
      JNZ END1718
    
   L18: DRAWAGLUE GLUE1718X,GLUE1718Y
   MOV ISGLUEDRAWN+9,1
   END1718: RET
    DRAWGLUE1718 ENDP    

DRAWGLUE1920 PROC
	  cmp ISGLUEDRAWN+10,2
	  jz END1920
        CMP TOBEDRAWNABLOCK+7,0
      JZ L19
      JNZ END1920
      L19: CMP TOBEDRAWNABLOCK+8,0
      JZ L20
      JNZ END1920
    
   L20: DRAWAGLUE GLUE1920X,GLUE1920Y
   MOV ISGLUEDRAWN+10,1
  END1920:  RET
    DRAWGLUE1920 ENDP


DRAWGLUE2122 PROC
	  cmp ISGLUEDRAWN+11,2
	  jz END2122
        CMP TOBEDRAWNABLOCK+9,0
      JZ L21
      JNZ END2122
      L21: CMP TOBEDRAWNABLOCK+10,0
      JZ L22
      JNZ END2122
    
   L22:DRAWAGLUE GLUE2122X,GLUE2122Y
   MOV ISGLUEDRAWN+11,1
   END2122: RET
    DRAWGLUE2122 ENDP

DRAWGLUE2324 PROC
	  cmp ISGLUEDRAWN+12,2
	  jz END2324
        CMP TOBEDRAWNABLOCK+11,0
      JZ L23
      JNZ END2324
      L23: CMP TOBEDRAWNABLOCK+12,0
      JZ L24
      JNZ END2324
    
   L24:DRAWAGLUE GLUE2324X,GLUE2324Y 
   MOV ISGLUEDRAWN+12,1
    END2324: RET
    DRAWGLUE2324 ENDP


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
DRAWMIDDLEBLOCKS2 PROC FAR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cmp Middleblockboolean,0
jnz drawoddmiddle2 

tempdrawevenmiddle2:jmp drawevenmiddle2

drawoddmiddle2:
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy1,MiddleBlockcolor ;draw
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy3,MiddleBlockcolor
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy5,MiddleBlockcolor
DRAWBarrierTip  barrierTipx11,barrierTipy1,0Eh 
DRAWBarrierTip  barrierTipx12,barrierTipy1,0Eh 
DRAWBarrierTip  barrierTipx31,barrierTipy3,0Eh 
DRAWBarrierTip  barrierTipx32,barrierTipy3,0Eh 
DRAWBarrierTip  barrierTipx51,barrierTipy5,0Eh 
DRAWBarrierTip  barrierTipx52,barrierTipy5,0Eh 


DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy2,0h ;delete
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy4,0h
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy6,0h
DRAWBarrierTip  barrierTipx21,barrierTipy2,0h
DRAWBarrierTip  barrierTipx22,barrierTipy2,0h
DRAWBarrierTip  barrierTipx41,barrierTipy4,0h
DRAWBarrierTip  barrierTipx42,barrierTipy4,0h
DRAWBarrierTip  barrierTipx61,barrierTipy6,0h
DRAWBarrierTip  barrierTipx62,barrierTipy6,0h

jmp Drawmiddleexit2 

drawevenmiddle2:
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy2,MiddleBlockcolor ;draw
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy4,MiddleBlockcolor
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy6,MiddleBlockcolor
DRAWBarrierTip  barrierTipx21,barrierTipy2,0Eh
DRAWBarrierTip  barrierTipx22,barrierTipy2,0Eh
DRAWBarrierTip  barrierTipx41,barrierTipy4,0Eh
DRAWBarrierTip  barrierTipx42,barrierTipy4,0Eh
DRAWBarrierTip  barrierTipx61,barrierTipy6,0Eh
DRAWBarrierTip  barrierTipx62,barrierTipy6,0Eh

DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy1,0h ;delete
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy3,0h
DRAWABLOCKMIDDLE MiddleBlocksx1,MiddleBlocksy5,0h
DRAWBarrierTip  barrierTipx11,barrierTipy1,0h 
DRAWBarrierTip  barrierTipx12,barrierTipy1,0h 
DRAWBarrierTip  barrierTipx31,barrierTipy3,0h 
DRAWBarrierTip  barrierTipx32,barrierTipy3,0h 
DRAWBarrierTip  barrierTipx51,barrierTipy5,0h 
DRAWBarrierTip  barrierTipx52,barrierTipy5,0h 


Drawmiddleexit2:RET

DRAWMIDDLEBLOCKS2 ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BlinkMiddleandInvert proc far

		mov ah,0
		mov al,Timervalue ;if odd and even for better consistency
		mov dl,2
		DIV dl
		cmp ah,1
		jnz timeisevenmiddle
		mov Middleblockboolean,0
		mov Middleblockbooleaninverted,1
		jmp middleinvertjmp
		
timeisevenmiddle:		
		cmp ah,0
		jnz middleinvertjmp
		mov Middleblockboolean,1
		mov Middleblockbooleaninverted,0
		
middleinvertjmp: call DRAWMIDDLEBLOCKS


ret
BlinkMiddleandInvert endp


BlinkMiddleandInvert2 proc far ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
		mov ah,0
		mov al,Timervalue ;if odd and even for better consistency
		mov dl,2
		DIV dl
		cmp ah,1
		jnz timeisevenmiddle2
		mov Middleblockboolean,0
		mov Middleblockbooleaninverted,1
		jmp middleinvertjmp2
		
timeisevenmiddle2:		
		cmp ah,0
		jnz middleinvertjmp2
		mov Middleblockboolean,1
		mov Middleblockbooleaninverted,0	
		
middleinvertjmp2: call DRAWMIDDLEBLOCKS2

ret
BlinkMiddleandInvert2 endp


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
	
	cmp booleanisbigger1,1
	jz continuedrawshooter1
	CALL CLRSHOOTER2TIP
	MOV SHOOTER2BIGGER,1
	mov booleanisbigger1,1
	
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
	cmp booleanisbigger2,1
	jz continuedrawshooter2
	CALL CLRSHOOTER1TIP
	MOV SHOOTER1BIGGER,1
	mov booleanisbigger2,1
	

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
		
cmp PlayerNumber,1  ;Player 2 only recieves the time
jnz PrintingTime		
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
	mov dx,2606h
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
clearbuffer proc far

startclearbuffer:
mov ah,1
int 16h
jz clearbufferreturn
pushf
mov ah,7 
int 21h
popf
jnz startclearbuffer 

clearbufferreturn:ret
clearbuffer endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
	
	;call Sound
	
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
		
	
	;mov ah,1    ;check if player pressed space
    ;int 16h
	;jz addbulletreturn
    ;cmp al,32
	cmp PlayerNumber,1
	jnz addforplayer2
	cmp VALUESENT,39h     ;space
    jnz addbulletreturn   
	jmp ADDBULLETJUMP
	
	addforplayer2:
	cmp PlayerNumber,2  
	jnz addbulletreturn
	cmp VALUERECIEVED,39h     ;space
    jnz addbulletreturn
	
	;mov ah,7    ;clear key from buffer
	;int 21h
	
	
	
	ADDBULLETJUMP:
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
	

	cmp PlayerNumber,2
    jnz addforplayer22
	cmp VALUESENT,39h     ;X key
    jnz addbulletreturn2   
	jmp ADDBULLETJUMP2
	
	addforplayer22:
	cmp PlayerNumber,1  
	jnz addbulletreturn2
	cmp VALUERECIEVED,39h     ;X key
	jnz addbulletreturn2
	
	ADDBULLETJUMP2:
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

AddbarBullet1 proc far ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Add the Bullet to the memory location to be drawn
	
	
	Mov CX,BulletNumber
	LEA SI,Bullets1X
	LEA DI,Bullets1Y
	
		  
	
	AddbarBulletLoop:
		
		CMP word ptr [SI],0 ;CHECKING IF THERE IS A BULLET SAVED 
		JNZ NEXTbarbull
		CMP word ptr [DI],0
		JNZ NEXTbarbull
		
	    ;ADDING THE BULLET TO MEMORY
			MOV AX,tempbarrierTipbully2 ;inverted x and y
			ADD AX,54
			MOV [SI],AX
			MOV AX,tempbarrierTipbullx2 ;inverted x and y
			ADD AX,34
			MOV [DI],AX
			jmp addbarbulletreturn
			
		NEXTbarbull: 
		ADD SI,2
		ADD DI,2
		DEC CX
		cmp cx,0
		JNZ AddbarBulletLoop
		
addbarbulletreturn :ret
AddbarBullet1 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AddbarBullet2 proc far ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Add the Bullet to the memory location to be drawn
	
	
	Mov CX,BulletNumber
	LEA SI,Bullets2X
	LEA DI,Bullets2Y
	
		  
	
	AddbarBulletLoop2:
		
		CMP word ptr [SI],0 ;CHECKING IF THERE IS A BULLET SAVED 
		JNZ NEXTbarbull2
		CMP word ptr [DI],0
		JNZ NEXTbarbull2
		
	    ;ADDING THE BULLET TO MEMORY
			MOV AX,tempbarrierTipbully1 ;inverted x and y
			ADD AX,54
			MOV [SI],AX
			MOV AX,tempbarrierTipbullx1 ;inverted x and y
			ADD AX,23
			MOV [DI],AX
			jmp addbarbulletreturn2
			
		NEXTbarbull2: 
		ADD SI,2
		ADD DI,2
		DEC CX
		cmp cx,0
		JNZ AddbarBulletLoop2
		
addbarbulletreturn2 :ret
AddbarBullet2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
											 call DRAWSHOOTER2
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
										
										;check for glues
										GlueChecker1 tempbulletx, tempbullety, GLUE1314X, GLUE1314Y, ISGLUEDRAWN+7 
										GlueChecker1 tempbulletx, tempbullety, GLUE1516X, GLUE1516Y, ISGLUEDRAWN+8
										GlueChecker1 tempbulletx, tempbullety, GLUE1718X, GLUE1718Y, ISGLUEDRAWN+9
										GlueChecker1 tempbulletx, tempbullety, GLUE1920X, GLUE1920Y, ISGLUEDRAWN+10
										GlueChecker1 tempbulletx, tempbullety, GLUE2122X, GLUE2122Y, ISGLUEDRAWN+11
										GlueChecker1 tempbulletx, tempbullety, GLUE2324X, GLUE2324Y, ISGLUEDRAWN+12
										
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

BulletCollision1_L2  proc far ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si,offset Bullets1X    ;check if the bullets positions (if not zero) are collided with something  
mov di,offset Bullets1y
mov cx,11 
loopBulletcollision12:push cx
					cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz tempbeginnextcollisionchecking12  
                    cmp word ptr[di],0
                    jz tempbeginnextcollisionchecking12 
					jmp checkBullWithShooterColl12
					
					tempbeginnextcollisionchecking12:jmp beginnextcollisionchecking12
					
					checkBullWithShooterColl12:mov bx,SHOOTER2X
											 cmp word ptr[di],bx ;x position compare
					                         jbe checkbullblock112
											 mov bx,SHOOTER2Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock112
											 mov bx,SHOOTER2Y ;y lower position compare
											 add bx,Shooterlength
											 cmp SHOOTER2BIGGER,1
											 jnz nomagnify12
											 add bx,45        ;magnification difference
								nomagnify12:	 cmp word ptr[si],bx
											 jg checkbullblock112
											 mov word ptr[si],0
											 mov word ptr[di],0
											 call DRAWSHOOTER2
											 add CounterFreeze1,1
											 cmp CounterFreeze1,5
											 jnz temp1beginnextcoisionchecking
										
											 mov BooleanFreeze1,maxfreezetime;shooter2 should be freezed for 2 sec 
											 mov CounterFreeze1,0
											 jmp beginnextcollisionchecking12
											 
					temp1beginnextcoisionchecking: jmp beginnextcollisionchecking12		
											 
					
					
			        checkbullblock112:	mov tempbullety,si
										mov tempbulletx,di
										
									    ;check for blocks in the middle of the screen
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx1,MiddleBlocksy1,Middleblockboolean
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx3,MiddleBlocksy3,Middleblockboolean
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx5,MiddleBlocksy5,Middleblockboolean
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx2,MiddleBlocksy2,Middleblockbooleaninverted
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx4,MiddleBlocksy4,Middleblockbooleaninverted
										BlockCheckermiddle1_L2 tempbulletx, tempbullety, MiddleBlocksx6,MiddleBlocksy6,Middleblockbooleaninverted
										
										;check for glues
										GlueChecker1 tempbulletx, tempbullety, GLUE1314X, GLUE1314Y, ISGLUEDRAWN+7 
										GlueChecker1 tempbulletx, tempbullety, GLUE1516X, GLUE1516Y, ISGLUEDRAWN+8
										GlueChecker1 tempbulletx, tempbullety, GLUE1718X, GLUE1718Y, ISGLUEDRAWN+9
										GlueChecker1 tempbulletx, tempbullety, GLUE1920X, GLUE1920Y, ISGLUEDRAWN+10
										GlueChecker1 tempbulletx, tempbullety, GLUE2122X, GLUE2122Y, ISGLUEDRAWN+11
										GlueChecker1 tempbulletx, tempbullety, GLUE2324X, GLUE2324Y, ISGLUEDRAWN+12
										
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
										
									
										
					checkbulllimit12: cmp word ptr [di],ScreenWidth-15
									jbe beginnextcollisionchecking12
									mov word ptr[si],0
									mov word ptr[di],0
									
					
                beginnextcollisionchecking12:add si,2
										   add di,2
										   pop cx
										   dec cx  
										   cmp cx,0
				                   jnz temploopBulletcollision12
								   jz BulletCollisionreturn12
				
temploopBulletcollision12: jmp loopBulletcollision12

BulletCollisionreturn12: ret
BulletCollision1_L2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
											 call DRAWSHOOTER1
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
									 
									 ;check for glues
									 GlueChecker2 tempbulletx, tempbullety, GLUE12X  , GLUE12Y  , ISGLUEDRAWN+1
									 GlueChecker2 tempbulletx, tempbullety, GLUE34X  , GLUE34Y  , ISGLUEDRAWN+2
									 GlueChecker2 tempbulletx, tempbullety, GLUE56X  , GLUE56Y  , ISGLUEDRAWN+3
									 GlueChecker2 tempbulletx, tempbullety, GLUE78X  , GLUE78Y  , ISGLUEDRAWN+4
									 GlueChecker2 tempbulletx, tempbullety, GLUE910X , GLUE910Y , ISGLUEDRAWN+5
									 GlueChecker2 tempbulletx, tempbullety, GLUE1112X, GLUE1112Y, ISGLUEDRAWN+6
									 
									
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

BulletCollision2_L2 proc far ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;done by aya ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov si,offset Bullets2X    ;check if the bullets positions (if not zero) are collided with something  
mov di,offset Bullets2y
mov cx,11 
loopBulletcollision22:push cx
					cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz tempbeginnextcollisionchecking_22  
                    cmp word ptr[di],0
                    jz tempbeginnextcollisionchecking_22
					jmp checkBullWithShooterColl22
					
					tempbeginnextcollisionchecking_22:jmp beginnextcollisionchecking22
					
					
					checkBullWithShooterColl22:mov bx,SHOOTER1X
											 cmp word ptr[di],bx
					                         jge checkbullblock122
											 mov bx,SHOOTER1Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock122
											 mov bx,SHOOTER1Y ;y lower position compare
											 add bx,Shooterlength
											 cmp SHOOTER1BIGGER,1
											 jnz nomagnify22
											 add bx,45        ;magnification difference
							nomagnify22:		 cmp word ptr[si],bx
											 jg checkbullblock122
											 mov word ptr[si],0
											 mov word ptr[di],0
											 call DRAWSHOOTER1
											 add CounterFreeze2,1
											 cmp CounterFreeze2,5
											 jnz tempbeginnextcollisionchecking_22
										
											 mov BooleanFreeze2,maxfreezetime;shooter1 should be freezed for 5sec 
											 mov CounterFreeze2,0
											 jmp beginnextcollisionchecking22  

						

											 
			        checkbullblock122:
									 mov tempbullety,si
									 mov tempbulletx,di
									 
									 ;check for the blocks in the middle
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx1,MiddleBlocksy1,Middleblockboolean
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx3,MiddleBlocksy3,Middleblockboolean
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx5,MiddleBlocksy5,Middleblockboolean
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx2,MiddleBlocksy2,Middleblockbooleaninverted
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx4,MiddleBlocksy4,Middleblockbooleaninverted
									 BlockCheckermiddle2_L2 tempbulletx, tempbullety, MiddleBlocksx6,MiddleBlocksy6,Middleblockbooleaninverted
									 
									 ;check for glues
									 GlueChecker2 tempbulletx, tempbullety, GLUE12X  , GLUE12Y  , ISGLUEDRAWN+1
									 GlueChecker2 tempbulletx, tempbullety, GLUE34X  , GLUE34Y  , ISGLUEDRAWN+2
									 GlueChecker2 tempbulletx, tempbullety, GLUE56X  , GLUE56Y  , ISGLUEDRAWN+3
									 GlueChecker2 tempbulletx, tempbullety, GLUE78X  , GLUE78Y  , ISGLUEDRAWN+4
									 GlueChecker2 tempbulletx, tempbullety, GLUE910X , GLUE910Y , ISGLUEDRAWN+5
									 GlueChecker2 tempbulletx, tempbullety, GLUE1112X, GLUE1112Y, ISGLUEDRAWN+6
									 
									
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
									 
					checkbulllimit22:cmp word ptr [di],0 ;screen limit
									jge beginnextcollisionchecking22
									mov word ptr[si],0
									mov word ptr[di],0
									
                beginnextcollisionchecking22:add si,2
										   add di,2
										   pop cx
										   dec cx  
										   cmp cx,0
				                   jnz temploopBulletcollision22
								   jz BulletCollisionreturn22
				
temploopBulletcollision22: jmp loopBulletcollision22

BulletCollisionreturn22: ret

BulletCollision2_L2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendRECUSERNAMES proc far

lea bx,UserNameDataNumber
mov cl,0

senduserloop:

mov ch,[bx]
mov VALUESENT,ch
SMALLSENDMACRO
inc cl
inc bx
cmp cl,15
jnz senduserloop


lea bx,UserNameDataNumber2
mov cx,15
recieveuserloop:


RECIEVECHK2:
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JZ RECIEVECHK2                                    ;Not Ready
		
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al
		mov ah,VALUERECIEVED
		mov [bx],ah
		inc bx

loop recieveuserloop

lea bx,UserNameDataNumber
mov cl,0

senduserloop2:

mov ch,[bx]
mov VALUESENT,ch
SMALLSENDMACRO
inc cl
inc bx
cmp cl,15
jnz senduserloop2


ret
SendRECUSERNAMES endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MainMenu proc far

			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by callibg graphics mode
dispgameframe:
              mov cx,0             ;first section of the screen
			  mov dx,0
			  mov al,4h
			  mov ah,0ch
			  colouringscreen1Outerloop: mov cx,0
			            colouringscreen1Innerloop: int 10h
													 inc cx
													 cmp cx,halfTheScreenWidth
													 jnz colouringscreen1Innerloop
													 inc dx
													 cmp dx,ThescreenheightbeforeTheNotbar 
													 jnz colouringscreen1Outerloop
													 
													 
			  mov cx,halfTheScreenWidth             ;second section of the screen
			  mov dx,0
			  mov al,1h
			  mov ah,0ch
			  colouringscreen2Outerloop: mov cx,halfTheScreenWidth
			            colouringscreen2Innerloop: int 10h
													 inc cx
													 cmp cx,screenWidth
													 jnz colouringscreen2Innerloop
													 inc dx
													 cmp dx,ThescreenheightbeforeTheNotbar 
													 jnz colouringscreen2Outerloop									 
													 
													 
			  
			  

              mov ah,2     ;moving the cursor to the center of the screen
              mov dx,0A32h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the main page(frame)
			  mov al,0
			  mov bx,0
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
	StartAdj2:				
	CMP PlayerNumber,2
	jnz checkforplayer1
	
	CMP VALUESENT,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP) 1E
	JE UP_PRESSED
	
	CMP VALUESENT,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN) 2C
	JE DOWN_PRESSED
	
	checkforplayer1:
	CMP PlayerNumber,1
	jnz notplayer1
	
	CMP VALUERECIEVED,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED
	
	CMP VALUERECIEVED,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED
	
	notplayer1:
	JMP exitadjust1  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	UP_PRESSED:
		CMP SHOOTER2Y,30
		JL exitadjust1
		call CLEARSHOOTER2
		SUB SHOOTER2Y,Shooter2Speed  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		call DRAWSHOOTER2
		MOV BX,0
		JMP exitadjust1
	
	DOWN_PRESSED:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER2Y,460
		JGE exitadjust1
		call CLEARSHOOTER2
		ADD SHOOTER2Y,Shooter2Speed
		call DRAWSHOOTER2
		MOV BX,0
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
	StartAdj1:
	CMP PlayerNumber,1
	jnz checkforplayer2
	
	CMP VALUESENT,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED2
	
	CMP VALUESENT,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED2
	
	checkforplayer2:
	CMP PlayerNumber,2
	jnz notplayer2
	
	CMP VALUERECIEVED,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED2
	
	CMP VALUERECIEVED,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED2
	
	notplayer2:
	JMP exitadjust2  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	
	UP_PRESSED2:
		CMP SHOOTER1Y,30
		JLE exitadjust2
		CALL CLEARSHOOTER1
		SUB SHOOTER1Y,Shooter1Speed  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		MOV BX,0
		CALL DRAWSHOOTER1 
		JMP exitadjust2
	
	DOWN_PRESSED2:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER1Y,470
		JGE exitadjust2
		CALL CLEARSHOOTER1
		ADD SHOOTER1Y,Shooter1Speed
		MOV BX,0
		CALL DRAWSHOOTER1 
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

mov booleanisbigger1 , 0
mov booleanisbigger2 , 0

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


Usernamescreen2 proc far

			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by calling graphics mode
			  
			  mov ah,2     ;moving the cursor to the center of the screen
              mov dx,1832h
			  mov bx,0
              int 10h

              mov ah,9     ;displaying the enter your name message
              mov dx,offset Usernamemessage2
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
			  mov dx,offset UserNameDATA2
			  int 21h 
ret
Usernamescreen2 endp

Usernamescreenchecker proc far

startagain : Call Usernamescreen

cmp UserNameDatastring,91
jz startagain
cmp UserNameDatastring,92
jz startagain
cmp UserNameDatastring,93
jz startagain
cmp UserNameDatastring,94
jz startagain
cmp UserNameDatastring,95
jz startagain
cmp UserNameDatastring,96
jz startagain

cmp UserNameDatastring,65
jl startagain
cmp UserNameDatastring,122
jg startagain

ret
Usernamescreenchecker endp

Usernamescreenchecker2 proc far

startagain2 : Call Usernamescreen2

cmp UserNameDatastring2,91
jz startagain2
cmp UserNameDatastring2,92
jz startagain2
cmp UserNameDatastring2,93
jz startagain2
cmp UserNameDatastring2,94
jz startagain2
cmp UserNameDatastring2,95
jz startagain2
cmp UserNameDatastring2,96
jz startagain2

cmp UserNameDatastring2,65
jl startagain2
cmp UserNameDatastring2,122
jg startagain2

ret
Usernamescreenchecker2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INITIALIZESERIAL PROC 

mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it

mov dx,3f8h			    ;SET LSB BAUD RATE DIVISOR LATCH
mov al,0Ch			
out dx,al

mov dx,3f9h             ;SET MSB BAUD RATE DIVISOR LATCH
mov al,00h
out dx,al

mov dx,3fbh
mov al,00011011b        ;CONFIGURATION OF SENDING BITS 
out dx,al


RET
INITIALIZESERIAL ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SEND PROC 

;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
		
AGAIN:  In al , dx 			;Read Line Status CHECK IF EMPTY
  		test al , 00100000b
  		JZ AGAIN                               ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
		mov ah,2 
		mov dh,sendcursory
		mov dl,sendcursorx
		mov bx,0
		int 10h 
		
		;;;;;;;special characters
		cmp VALUESENT,8
		jnz enterchecksend
		cmp sendcursorx,0
		jz contsend
		dec sendcursorx
		MOV AH,2
		MOV DL,' '
		INT 21H
		jmp SENDRET
		
		
enterchecksend:
		cmp VALUESENT, 13
		jnz scrollcont
		mov sendcursorx,0
		inc sendcursory
		jmp enterjmphere1
		
scrollcont:
		inc sendcursorx   ;incrementing after printing 
enterjmphere1:
		cmp sendcursorx,79	;mov to the next line if line finished 
		jnz contsend
		mov sendcursorx,0 
		inc sendcursory
		
		
contsend:MOV AH,2
		 MOV DL,VALUESENT
		 INT 21H
		
		cmp sendcursory,11
		jnz SENDRET					;check if at the end of the 12 lines then scroll
		mov ah,6       ; function 6
		mov al,1        ; scroll by 3 line    
		mov bh,1fH       ; normal video attribute         
		mov ch,0       ; upper left Y
		mov cl,0        ; upper left X
		mov dh,11     ; lower right Y
		mov dl,79      ; lower right X 
		int 10h		
		mov sendcursory,8
		
		

SENDRET:
		mov ah,2 
		mov dh,sendcursory
		mov dl,sendcursorx
		mov bx,0
		int 10h 
RET
SEND ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RECIEVE PROC 

;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JnZ tempnoCHK                                    ;Not Ready
		jmp CHK
tempnoCHK:	
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al
		
		
		mov ah,2 
		mov dh,recievecursory
		mov dl,recievecursorx
		mov bx,0
		int 10h 
		
		
		;;;;;;;special characters
		cmp VALUERECIEVED,8
		jnz entercheckrec
		cmp recievecursorx,0
		jz contrec
		dec recievecursorx
		MOV AH,2
		MOV DL,' '
		INT 21H
		jmp CHK
		
entercheckrec:		
		cmp VALUERECIEVED, 13
		jnz scrollcont2
		mov recievecursorx,0
		inc recievecursory
		jmp enterjmphere2
scrollcont2:
		inc recievecursorx   ;incrementing after printing 
enterjmphere2:
		cmp recievecursorx,79	;mov to the next line if line finished 
		jnz contrec
		mov recievecursorx,0 
		inc recievecursory
		
		
contrec:MOV AH,2
		MOV DL,VALUERECIEVED
		INT 21H
		mov ah,2 
		mov dh,recievecursory
		mov dl,recievecursorx
		mov bx,0
		int 10h 
		
		cmp recievecursory,25
		jnz CHK					;check if at the end of the 12 lines then scroll
	
		mov ah,6       ; function 6
		mov al,1        ; scroll by 3 line    
		mov bh,4fH       ; normal video attribute         
		mov ch,14       ; upper left Y
		mov cl,0        ; upper left X
		mov dh,24     ; lower right Y
		mov dl,79      ; lower right X 
		int 10h
		mov recievecursory,24
		

CHK:RET
RECIEVE ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECIEVEINGAME proc far

;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JnZ tempnoCHK2                                    ;Not Ready
		jmp CHK2
tempnoCHK2:	
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al
		
		mov ah,2 
		mov dh,2Ch
		mov dl,ingamecursor
		mov bx,0
		int 10h 
		
		MOV AH,2
		MOV DL,VALUERECIEVED
		INT 21H
		inc ingamecursor
		cmp ingamecursor,127
		jnz CHK2
		mov ingamecursor,0

CHK2:RET
RECIEVEINGAME endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

chattingMenu proc far

   mov ah,0
   mov al,3
   int 10h

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,1fH       ; normal video attribute         
   mov ch,0       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,11     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,7H       ; normal video attribute         
   mov ch,12       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,12     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,4fH       ; normal video attribute         
   mov ch,13       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	 
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,0000h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDataString
    int 21h 
	
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	
	
    mov ah,2     ;moving the cursor to Print invitation
    mov dx,1300h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDATAString2
    int 21h 	
	
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	
   
   MOV VALUESENT,0
   MOV VALUERECIEVED,0
   
   call clearbuffer
   
   LOOPSERIAL:
		 MOV AH,1
		 INT 16H
		 jz jumphereSERIAL
		 MOV VALUESENT,AL
		 MOV AH,7
		 INT 21H
		 SENDMACRO
		 
jumphereSERIAL:CALL RECIEVE
		 
		 CMP VALUESENT,27
		 JZ EXIT
		 
		 CMP VALUERECIEVED,27
		 JZ EXIT
		
   JMP LOOPSERIAL

EXIT:ret
chattingMenu endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;
sendallstring proc far

mov cx,79
lea bx,SendString

lpsendallstring:
mov ah,byte ptr [bx]
mov VALUESENT,ah
mov dx , 3FDH		; Line Status Register
		
AGAINSENDstring:   
			  In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDstring                              ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
inc bx
loop lpsendallstring

mov cx,80
lea bx,SendString
lpsendallstring2:
mov byte ptr [bx],' '
inc bx
loop lpsendallstring2

mov SendStringIndex,0
ret
sendallstring endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;
sendallstring2 proc far

mov cx,127
lea bx,SendString2

lpsendallstring3:
mov ah,byte ptr [bx]
mov VALUESENT,ah
mov dx , 3FDH		; Line Status Register
		
AGAINSENDstring2:   
			  In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDstring2                             ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		
inc bx
loop lpsendallstring3

mov cx,128
lea bx,SendString2
lpsendallstring4:
mov byte ptr [bx],' '
inc bx
loop lpsendallstring4

mov SendStringIndex2,0
ret
sendallstring2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;
chattingMenu2 proc far

   mov ah,0
   mov al,3
   int 10h

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,1fH       ; normal video attribute         
   mov ch,0       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,11     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,7H       ; normal video attribute         
   mov ch,12       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,12     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	

   mov ah,6       ; function 6
   mov al,0        ; scroll by 1 line    
   mov bh,4fH       ; normal video attribute         
   mov ch,13       ; upper left Y
   mov cl,0        ; upper left X
   mov dh,24     ; lower right Y
   mov dl,79      ; lower right X 
   int 10h
	 
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,0000h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDataString
    int 21h 
	
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,0000h
	add dl,UserNameDataNumber
    mov bx,0
    int 10h
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	
	
    mov ah,2     ;moving the cursor to Print invitation
    mov dx,0D00h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDataString2
    int 21h 	
	
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,0D00h
	add dl,UserNameDataNumber2
    mov bx,0
    int 10h
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	 
   
   MOV VALUESENT,0
   MOV VALUERECIEVED,0
   
   call clearbuffer
   
    LOOPSERIAL2:
		 MOV AH,1
		 INT 16H
		 jz tempSERIAL2
		 cmp al,';'
		 jnz nextchecknot
		 mov ah,7
		 int 21h
		 jmp LOOPSERIAL2

tempSERIAL2: jmp jumphereSERIAL2
	
nextchecknot:
 		 cmp al,27
		 jnz nextchecknot2
		 MOV VALUESENT,AL
		 call SEND
		 mov ah,7 
		 int 21h
		 jmp jumphereSERIAL2

nextchecknot2:
		 cmp al,8
		 jnz entercheck
		 MOV AH,7
		 INT 21H
		 cmp SendStringIndex,0
		 jz nobck1
		 dec SendStringIndex
		 lea bx,SendString
		 add bx,SendStringIndex
		 mov byte ptr [bx],' '
		 
nobck1:   jmp printingsendstring
		 
		 
		 ;;;;
		 ;when enter is pressed new line is made and we inc cursor y
entercheck:
		 cmp al,13
		 jnz puttostring
		 call sendallstring
		 mov ah,7
		 int 21h
		 inc sendcursory
		 cmp sendcursory,12
		 jnz printingsendcon
		 mov ah,6       ; function 6
		 mov al,1        ; scroll by 1 line    
		 mov bh,1fH       ; normal video attribute
		 mov ch,1       ; upper left Y
		 mov cl,0        ; upper left X
		 mov dh,11     ; lower right Y
		 mov dl,79      ; lower right X 
		 int 10h
		 mov sendcursory,11
		 
printingsendcon:
		 jmp printingsendstring
		 
puttostring:		 
		 MOV AH,7
		 INT 21H
		 cmp al,';'
		 jz LOOPSERIAL2
		 
		 lea bx,SendString
		 add bx,SendStringIndex
		 mov [bx],al
		 cmp SendStringIndex, 79
		 jz printingsendstring
		 inc SendStringIndex
		 
		 ;;;;;print the string in the line of the cursor
printingsendstring:	
		
		mov ah,2 
		mov dh,sendcursory
		mov dl,0
		mov bx,0
		int 10h 
		 
		mov ah,9
		lea dx,SendString
		int 21h
		 
jumphereSERIAL2:CALL RECIEVE
		 
		 CMP VALUESENT,27
		 JZ EXIT2
		 
		 CMP VALUERECIEVED,27
		 JZ EXIT2
		
   JMP LOOPSERIAL2

EXIT2:
ret
chattingMenu2 endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mainmenuserialcom proc far
;; Sends and recieves the request from the players, it has one loop that sends and recieves and checks to set booleans and types to the notification bar
;;create two booleans for each player for each mode that totals 4 if he sends type the invitation is sent
;;add another boolean to check who pressed first
;;if he recieves type is recieved, if the two booleans of a type are true break the loop and go to that mode for each

Mainmenuserialloop:
	
	
	SENDMACRO
	RECIEVEMACRO
	
	cmp VALUESENT,1 ;ESC
	jz tempGAMEMODEEXIT
	recexitcheck:
	cmp VALUERECIEVED,1
	jz tempGAMEMODEEXIT
	jmp Otherchecks

tempGAMEMODEEXIT :jmp GAMEMODEEXIT
;send if f2 write and change boolean 
;send if f1 write and change boolean
;recieve if f2 write and change boolean
;recieve if f1 write and change boolean
Otherchecks:
cmp VALUESENT,3bh
jnz chatmodesendcheck
mov chatmodesendboolean,1
mov ah,2     ;moving the cursor to Print invitation
mov dx,2802h
mov bx,0
int 10h
mov ah,9     ;print invitation
mov dx,offset Invitechatsent
int 21h

chatmodesendcheck:

cmp VALUERECIEVED,3bh
jnz chatmoderecievecheck
mov chatmoderecieveboolean,1
mov ah,2     ;moving the cursor to Print invitation
mov dx,2A02h
mov bx,0
int 10h
mov ah,9     ;print invitation
mov dx,offset Invitechatrecieved
int 21h

chatmoderecievecheck:

cmp VALUESENT,3Ch
jnz playmodesendcheck
mov playmodesendboolean,1
cmp playmoderecieveboolean,1     ; 
jnz heisnotplayer1               ;
mov PlayerNumber,2               ;if recieve is 1 that means he is player 2
jmp playmoderecievecheck
heisnotplayer1:                  ;
mov ah,2     ;moving the cursor to Print invitation
mov dx,2802h
mov bx,0
int 10h
mov ah,9     ;print invitation
mov dx,offset Inviteplaysent
int 21h

playmodesendcheck:

cmp VALUERECIEVED,3Ch															
jnz playmoderecievecheck
mov playmoderecieveboolean,1
cmp playmodesendboolean,1        ; 
jnz heisnotplayer2               ;
mov PlayerNumber,1               ;if send is 1 that means he is player 1
heisnotplayer2:                  ;
mov ah,2     ;moving the cursor to Print invitation
mov dx,2A02h
mov bx,0
int 10h
mov ah,9     ;print invitation
mov dx,offset Inviteplayrecieved
int 21h

playmoderecievecheck:

;check the booleans and put the mode into the memory	
cmp chatmodesendboolean,1
jnz checkplaymode
cmp chatmoderecieveboolean,1
jnz checkplaymode
jmp chatmodesetter


checkplaymode:
cmp playmodesendboolean,1
jnz continuecheckserial												
cmp playmoderecieveboolean,1																								
jnz continuecheckserial												
jmp playmodesetter 

continuecheckserial:
jmp Mainmenuserialloop

;;;;;;Become player 1 and go to chat mode
chatmodesetter:
mov GAMEMODE,1
ret

;;;;;;Become player 1 and go to play mode 
playmodesetter:
mov GAMEMODE,2
ret

;;;;;;GAMEMODE 3 exit the game 
GAMEMODEEXIT:
mov GAMEMODE,3
ret
Mainmenuserialcom endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Synchronize proc far

cmp PlayerNumber,1
jnz Iamplayer2

;send a character
		MOV VALUESENT,SyncCHAR   ;Character to check if we begin frame 
		mov dx , 3FDH		
AGAINSENDSYNCP1:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDSYNCP1                               ;Not empty
	
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		mov VALUESENT,0

;loop untill the character is recieved
RecieveSyncloop1:
RECIEVEMACRO
cmp VALUERECIEVED,SyncCHAR
jz exitsyncp1
jmp RecieveSyncloop1

exitsyncp1: mov VALUERECIEVED,0
			ret

Iamplayer2:
;loop until a character is recieved 
RecieveSyncloop2:
RECIEVEMACRO
cmp VALUERECIEVED,SyncCHAR
jz exitsyncp2
jmp RecieveSyncloop2

exitsyncp2:mov VALUERECIEVED,0
;send it back
		MOV VALUESENT,SyncCHAR   ;Character to check if we begin frame 
		mov dx , 3FDH		
AGAINSENDSYNCP2:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDSYNCP2                               ;Not empty
	
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
mov VALUESENT,0
ret
Synchronize endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;

Chooselevel proc far

cmp PlayerNumber,1
jz continuelevel
jmp Waitforlevel

continuelevel:
	mov ah,2     ;moving the cursor to the center of the screen
    mov dx,1332h
    mov bx,0
    int 10h
    mov ah,9     ;displaying 
    mov al,0
    mov bx,0
    mov dx,offset Lvl1mess
    int 21h
  
    mov ah,2     ;moving the cursor to the center of the screen
    mov dx,1832h
    mov bx,0
    int 10h
    mov ah,9     ;displaying 
    mov al,0
    mov bx,0
    mov dx,offset Lvl2mess
    int 21h
  
not1or2:
    mov ah,0
	int 16h
	cmp Ah,2
	jnz startsendlevel
	cmp ah,3
	jnz startsendlevel
	jmp not1or2
	
	
startsendlevel:	MOV VALUESENT,AH
	
	mov dx , 3FDH		
AGAINSENDlevel:   
			  In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDlevel                           ;Not empty
	
  		mov dx , 3F8H		; Transmit data register
  		mov al,VALUESENT
  		out dx , al
		

;since scan code is 1 more than actual numbers
mov ah,VALUESENT
dec ah
mov Level,ah

    mov ah,2     ;moving the cursor to the center of the screen
    mov dx,1332h
    mov bx,0
    int 10h
    mov ah,9     ;displaying 
    mov al,0
    mov bx,0
    mov dx,offset clearlevel
    int 21h
  
    mov ah,2     ;moving the cursor to the center of the screen
    mov dx,1832h
    mov bx,0
    int 10h
    mov ah,9     ;displaying 
    mov al,0
    mov bx,0
    mov dx,offset clearlevel
    int 21h

ret

Waitforlevel:

mov dx , 3FDH		; Line Status Register
		
		in al , dx 
  		test al , 1
  		JZ Waitforlevel                                    ;Not Ready
		
 ;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUERECIEVED , al


;since scan code is 1 more than actual numbers
mov ah,VALUERECIEVED
dec ah
mov Level,ah

exitlevelselect:
ret
Chooselevel endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;
sendandrecievetime proc far

cmp PlayerNumber,1
jnz endtimesendandrecieve 

mov bl,Timervalue ;to not be mistaken for another character
add bl,170
	
;Check that Transmitter Holding Register is Empty
		mov dx , 3FDH		; Line Status Register
		
AGAINSENDtime:    In al , dx 			;Read Line Status CHECK IF EMPTY
			  test al , 00100000b
			  JZ AGAINSENDtime                              ;Not empty
	
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov al,bl
  		out dx , al



endtimesendandrecieve:
ret
sendandrecievetime endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ingamechat proc far


;Pause for chat
cmp VALUESENT,3FH  ;F5
jz startgamechat
CMP VALUERECIEVED,3FH
jz startgamechat
jmp ingamechatret

startgamechat:
    mov ah,2     ;moving the cursor to Print invitation
    mov dx,2800h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDataString
    int 21h 
	
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,2800h
	add dl,UserNameDataNumber
    mov bx,0
    int 10h
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	
	
    mov ah,2     ;moving the cursor to Print invitation
    mov dx,2B00h
    mov bx,0
    int 10h
    mov ah,9     ;print invitation
    mov dx,offset UserNameDataString2
    int 21h 	
	
	mov ah,2     ;moving the cursor to Print invitation
    mov dx,2B00h
	add dl,UserNameDataNumber2
    mov bx,0
    int 10h
	mov ah,9
	mov dx,offset Usernamebarring
	int 21h
	 
   
   MOV VALUESENT,0
   MOV VALUERECIEVED,0


ingamechatloop:
		 MOV AH,1
		 INT 16H
		 jz gamecompletecheck
		 

checkifcontgame:
 		 cmp al,27  ;ESCAPE Pressed
		 jnz bckspacecheck
		 MOV VALUESENT,AL
		 SMALLSENDMACRO
		 mov ah,7 
		 int 21h
		 jmp gamecompletecheck
		 
		 
bckspacecheck:
		 cmp al,8
		 jnz checkifenterpress
		 MOV AH,7
		 INT 21H
		 cmp SendStringIndex2,0
		 jz nobck2
		 dec SendStringIndex2
		 lea bx,SendString2
		 add bx,SendStringIndex2
		 mov byte ptr [bx],' '
		 
nobck2:   jmp printingsendstring2
		 
checkifenterpress:
		 cmp al,13
		 jnz puttostring2
		 call sendallstring2 
		 mov ah,7
		 int 21h
		 jmp gamecompletecheck


puttostring2:		 
		 MOV AH,7
		 INT 21H
		 lea bx,SendString2
		 add bx,SendStringIndex2
		 mov [bx],al
		 cmp SendStringIndex2, 127
		 jz printingsendstring2
		 inc SendStringIndex2
		 
		 ;;;;;print the string in the line of the cursor
printingsendstring2:	
		
		mov ah,2 
		mov dh,29h
		mov dl,0
		mov bx,0
		int 10h 
		 
		mov ah,9
		lea dx,SendString2
		int 21h


gamecompletecheck: call RECIEVEINGAME ;TODO edit for in game

cmp VALUESENT,27 ;ESC
jz ingamechatret
CMP VALUERECIEVED,27
jz ingamechatret
jmp ingamechatloop

ingamechatret:
ret
ingamechat endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;
checksecondusername proc far

lea bx,UserNameDataString2 
lea si,tempuserstring  
mov UserNameDataNumber2,0

mov cx,20
stringloop1: 

cmp byte ptr [bx],91
jz acharacter
cmp byte ptr  [bx],92
jz acharacter
cmp byte ptr [bx],93
jz acharacter
cmp byte ptr [bx],94
jz acharacter
cmp byte ptr [bx],95
jz acharacter
cmp byte ptr [bx],96
jz acharacter

cmp byte ptr [bx],65
jl acharacter
cmp byte ptr [bx],122
jg acharacter  
            

mov ah,[bx]
mov [si],ah
inc si   
inc UserNameDataNumber2

acharacter:
inc bx

loop stringloop1

   
mov ch,0    
mov cl,UserNameDataNumber2    

mov ax,ds
mov es,ax

lea si,tempuserstring
lea di,UserNameDataString2

rep  movsb
       
mov al,'$'
STOSB

ret
checksecondusername endp
;;;;;;;;;;;;;;;;;;;;;;;;;;
Main proc far
	mov ax,@data
	mov ds,ax ; copy data segment
	
	mov ax, 4f02h
	mov bx, 105h
	int 10h ;graphical mode interrupt
	
	Call GameName
	CALL INITIALIZESERIAL
   
rightusername:  Call Usernamescreenchecker  ;user name screen 
				call SendRECUSERNAMES
				call checksecondusername
	
Mainmenujump:	
				mov GAMEMODE,0
				CALL MainMenu
				CALL Mainmenuserialcom ; send and recieve between players
				resetmainmenu		   ;reset booleans
				
				cmp GAMEMODE,1
	            jz chattingmode
				cmp GAMEMODE,2
				jz playingmode
				cmp GAMEMODE,3
				jz tempexitmain
 
      
chattingmode:MOV sendcursorx   ,0
             MOV sendcursory   ,1
             MOV recievecursorx,0
             MOV recievecursory,14
			 call chattingMenu2 ;/////////////if f1 is pressed  										   
             mov VALUESENT,0
			 mov VALUERECIEVED,0
             jz Mainmenujump 




tempexitmain: jmp  Exitmain  ;becaus jumps are too big
tempjump2:

playingmode:  ;/////////////if f2 is pressed 

			
			  mov ax, 4f02h
			  mov bx, 105h
			  int 10h ;clear by calling graphics mode
			  
			  call InitializeGame ;set default values of memory
			  
			  CALL DRAWRIGHTWALLS ;draw blocks
			  CALL DRAWLEFTWALLS  
			  call DRAWSHOOTER1
			  call DRAWSHOOTER2
			  ;Chooselevel
			  call Chooselevel
		maingameloop:
				
				mov cx, 0H    ;  delay
				mov dx, 8235h
				mov ah, 86H
				int 15H
				
				push si
                push di
				
				
				RECIEVEMACRO   ;;SERIAL SEND AND RECIEVE
				SENDMACRO2
				
				mov ingamecursor,0
				call ingamechat ;;;Not finished
				
				;Shooter Functions
				call ADJUST_POSITION1
				call ADJUST_POSITION2				
				
				
				call AddBullet1 ;Bullet functions
				call BulletClear1
				call BulletAnimation1
				cmp Level,1
				jnz notlevel11
                call BulletCollision1
				notlevel11:
				cmp Level,2
				jnz notlevel21
				call BulletCollision1_L2
				notlevel21:
				call drawbullet1
				
				call AddBullet2 ;Bullet functions
				call BulletClear2
				call BulletAnimation2
				cmp Level,1
				jnz notlevel12
                call BulletCollision2
				notlevel12:
				cmp Level,2
				jnz notlevel22
                call BulletCollision2_L2
				notlevel22:
				call drawbullet2
				
				
				;send and recieve time
				cmp PlayerNumber,2
				jnz completestatusbar
				mov bl,VALUERECIEVED
				cmp bl,169
				jb completestatusbar
				sub bl,170
				mov Timervalue,bl
				
completestatusbar:				
				call StatusBar
				
				
				cmp Level,1
				jnz notlevel13
				call BlinkMiddleandInvert ;inverts the middle blocks every second as well as draw them 
				notlevel13:
				cmp Level,2
				jnz notlevel23
				call BlinkMiddleandInvert2
				notlevel23:
				DRAWGLUES                 ;draws the glue blocker
				
				
				
				mov al,Timervalue
				cmp al,0
				jz ScoreScreenjmp ; ***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
				cmp Player1Score,12
				jz ScoreScreenjmp ;***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
				cmp Player2Score,12
				jz ScoreScreenjmp ;***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
                pop di
                pop si
			
			cmp VALUESENT,1		;if escape is pressed
			mov VALUESENT,0
            jz ScoreScreenjmp   ;if escape is pressed
								;if escape is pressed
			cmp VALUERECIEVED,1 ;if escape is pressed
            mov VALUERECIEVED,0
			jz ScoreScreenjmp   ;if escape is pressed
			
			mov VALUESENT,0
			mov VALUERECIEVED,0
			
			
			;clearbuffer
			call clearbuffer
				
     cont:  jmp maingameloop              
	
	tempmainmenujmp:call clearbuffer
					cmp PlayerNumber,1
					jnz player2cont
					Mov VALUESENT,1
					SMALLSENDMACRO
					
					player2cont:
					mov VALUESENT,0
					mov VALUERECIEVED,0
					jmp Mainmenujump
	
	ScoreScreenjmp: call sendandrecievetime
					call ScoreScreen
					call clearbuffer
					jmp Mainmenujump
	
	Exitmain: 
	mov ax,0003h
	int 10h ;return video mode
	
	mov ah,4ch
	int 21h  ;return program to dos
	
Main endp

end main 
;;TODO ADD SOUND WHEN FINISH