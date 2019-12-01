

;;;;;;;MACROS;;;;;;;;;;;

;Bugs TODO fix bullets bug relted to time int???

.Model Large
.Stack 64
.Data
IntroMessage db 'Press Space To Continue','$'
TimeRemaining db "Time Remaining : ",'$'
ScoreMessage db "Score : ",'$'
Bullets1X dw 10 dup(0),1
Bullets1Y dw 10 dup(0),1
Bullets2X dw 10 dup(0),1
Bullets2Y dw 10 dup(0),1
SHOOTER1X DW 100   ;X COORDINATE FOR OUTLINE STARTING POINT
SHOOTER1Y DW 250   ;Y COORDINATE FOR OUTLINE STARTING POINT
SHOOTER2X DW 900  
SHOOTER2Y DW 200


block11Y dw 100,200,300,400,500,600
block12Y dw 100,200,300,400,500,600
block11x dw 6 dup(50)
block12x dw	6 dup(10)

block21Y dw 100,200,300,400,500,600
block22Y dw 100,200,300,400,500,600
block21x dw 6 dup(950)
block22x dw	6 dup(990)

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
notbarmess db 128 dup('_'),10,'$' 
notbarmess2 db 128 dup('-'),10,'$' 
BulletNumber equ 10
ScreenWidth equ 1024
Shooterlength equ 150
.code

;---------------------------------------------------------------------------
;--------------------DRAW RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
DRAWRECTOUTLINE1 PROC  		;PROCEDURE THAT DRAWS A RECTANGLE GUIDED BY THE START POSITION OF THE SHOOTER


	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,120 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
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
	SUB SHOOTER1Y,120
	RET
	
DRAWRECTOUTLINE1 ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------

CLRRECTOUTLINE1 PROC  		;PROCEDURE THAT DRAWS A RECTANGLE GUIDED BY THE START POSITION OF THE SHOOTER


	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,120 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
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
	SUB SHOOTER1Y,120
	RET
	
CLRRECTOUTLINE1 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------
DRAWINNERRECT1 PROC 
	
	ADD SHOOTER1X,5
	ADD SHOOTER1Y,5
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
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
	SUB SHOOTER1Y,110
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
	MOV BX,00
	ADD BX,SHOOTER1Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
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
	SUB SHOOTER1Y,110
	SUB SHOOTER1X,5
	SUB SHOOTER1Y,5
	RET

CLRINNERRECT1 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
DRAWINGSHOOTER1TIP PROC
	
	ADD SHOOTER1X,30
	ADD SHOOTER1Y,40
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
	SUB SHOOTER1Y,40
	SUB SHOOTER1Y,40
	SUB SHOOTER1X,30
	RET

DRAWINGSHOOTER1TIP ENDP

;---------------------------------------------------------------------------
;-----------------------CLEAR SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
CLRSHOOTER1TIP PROC
	
	ADD SHOOTER1X,30
	ADD SHOOTER1Y,40
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
	SUB SHOOTER1Y,40
	SUB SHOOTER1Y,40
	SUB SHOOTER1X,30
	RET

CLRSHOOTER1TIP ENDP


;---------------------------------------------------------------------------
;--------------------DRAW RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
DRAWRECTOUTLINE2 PROC 

	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,120 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
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
	SUB SHOOTER2Y,120
	RET

DRAWRECTOUTLINE2 ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR RECTANGLE OUTLINE---------------------------------
;---------------------------------------------------------------------------
CLRRECTOUTLINE2 PROC 

	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,120 				;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF OUTLINE
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
	SUB SHOOTER2Y,120
	RET

CLRRECTOUTLINE2 ENDP


;---------------------------------------------------------------------------
;--------------------DRAW INNER RECTANGLE-----------------------------------
;---------------------------------------------------------------------------
DRAWINNERRECT2 PROC

	ADD SHOOTER2X,5
	ADD SHOOTER2Y,5
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
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
	SUB SHOOTER2Y,110
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
	MOV BX,00
	ADD BX,SHOOTER2Y
	ADD BX,110   		;PUTTING IN BX THE POSITION OF THE MAX HEIGHT OF INNER RECTANGLE
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
	SUB SHOOTER2Y,110
	SUB SHOOTER2X,5
	SUB SHOOTER2Y,5
	RET
CLRINNERRECT2 ENDP

;---------------------------------------------------------------------------
;--------------------DRAW SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
DRAWSHOOTER2TIP PROC

	SUB SHOOTER2X,10
	ADD SHOOTER2Y,40
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
	SUB SHOOTER2Y,40
	SUB SHOOTER2Y,40
	ADD SHOOTER2X,10
	RET
DRAWSHOOTER2TIP ENDP

;---------------------------------------------------------------------------
;--------------------CLEAR SHOOTER TIP-----------------------------------
;---------------------------------------------------------------------------
CLRSHOOTER2TIP PROC

	SUB SHOOTER2X,10
	ADD SHOOTER2Y,40
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
	SUB SHOOTER2Y,40
	SUB SHOOTER2Y,40
	ADD SHOOTER2X,10
	RET
CLRSHOOTER2TIP ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAWSHOOTER1 proc far 

	CALL DRAWRECTOUTLINE1
	CALL DRAWINNERRECT1
	CALL DRAWINGSHOOTER1TIP

ret
DRAWSHOOTER1 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DRAWSHOOTER2 proc far

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
	mov al,0
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

AddBullet1 proc far
;Add the Bullet to the memory location to be drawn
	
	;timer to add bullets every second
	mov ax,2c00h 
	int 21h   
	cmp booleantime,0
	jnz hastimecome
	mov bulletaddtimer,dh
	mov booleantime,1
	
	hastimecome:	
		cmp dh,bulletaddtimer
		jz addbulletreturn
		mov bulletaddtimer,dh
		
	
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
	mov ax,2c00h 
	int 21h   
	cmp booleantime2,0
	jnz hastimecome2
	mov bulletaddtimer2,dh
	mov booleantime2,1
	
	hastimecome2:	
		cmp dh,bulletaddtimer2
		jz addbulletreturn2
		mov bulletaddtimer2,dh
		
	
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
loopBulletcollision:cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz beginnextcollisionchecking  
                    cmp word ptr[di],0
                    jz beginnextcollisionchecking 
					
					checkBullWithShooterColl:mov bx,SHOOTER2X
											 cmp word ptr[di],bx ;x position compare
					                         jbe checkbullblock1
											 mov bx,SHOOTER2Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock1
											 mov bx,SHOOTER2Y ;y lower position compare
											 add bx,Shooterlength
											 cmp word ptr[si],bx
											 jg checkbullblock1
											 mov word ptr[si],0
											 mov word ptr[di],0
											 jmp beginnextcollisionchecking
			        checkbullblock1:mov bx,block21x								 
									cmp word ptr[di],bx
									jbe checkbullblock2
									mov word ptr[si],0
									mov word ptr[di],0
									;;delete block 
									jmp beginnextcollisionchecking
											 
					
					checkbullblock2:mov bx,block22x								 
									cmp word ptr[di],bx
									jbe checkbulllimit
									mov word ptr[si],0
									mov word ptr[di],0
									;;delete block 
									jmp beginnextcollisionchecking
					
					checkbulllimit: cmp word ptr [di],ScreenWidth
									jbe beginnextcollisionchecking
									mov word ptr[si],0
									mov word ptr[di],0
									
					
                beginnextcollisionchecking:add si,2
										   add di,2
										   dec cx  
										   cmp cx,0
				                   jnz loopBulletcollision
								  
				

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
loopBulletcollision2:cmp word ptr[si],0   ;LOOP OVER THE BULLETS AND CHECK IF THEY ARE NOT ZERO 
                    jz beginnextcollisionchecking2  
                    cmp word ptr[di],0
                    jz beginnextcollisionchecking2
					
					checkBullWithShooterColl2:mov bx,SHOOTER1X
											 cmp word ptr[di],bx
					                         jge checkbullblock12
											 mov bx,SHOOTER1Y ;y upper position compare 
											 cmp word ptr[si],bx
											 jb checkbullblock12
											 mov bx,SHOOTER1Y ;y lower position compare
											 add bx,Shooterlength
											 cmp word ptr[si],bx
											 jg checkbullblock12
											 mov word ptr[si],0
											 mov word ptr[di],0
											 jmp beginnextcollisionchecking2                      
			        checkbullblock12:mov bx,block11x								 
									cmp word ptr[di],bx
									jge checkbullblock22
									mov word ptr[si],0
									mov word ptr[di],0
									;;delete block 
									jmp beginnextcollisionchecking2
											 
					
					checkbullblock22:mov bx,block12x								 
									cmp word ptr[di],bx
									jge checkbulllimit2
									mov word ptr[si],0
									mov word ptr[di],0
									;;delete block 
									jmp beginnextcollisionchecking2
					
					checkbulllimit2: cmp word ptr [di],0 ;screen limit
									jge beginnextcollisionchecking2
									mov word ptr[si],0
									mov word ptr[di],0
									
					
                beginnextcollisionchecking2:add si,2
										   add di,2
										   dec cx  
										   cmp cx,0
				                   jnz loopBulletcollision2
								  
				

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
           mov ax,[si] 
           add ax,10 
            
           mov bx,[di] 
           add bx,20 
           
     loopoutery: mov dx,[si]
	 
           loopinnerx:push ax
                      mov al,4h
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc dx 
                      cmp dx,ax
                      jnz loopinnerx
                      
           inc cx
           cmp cx,bx
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
	  
		  mov cx,11
     begin2:push cx
	      cmp word ptr [si],0
          jz nexttoDraw2
          cmp word ptr [di],0
          jz nexttoDraw2
	       mov cx,[di] 
           mov dx,[si] 
           mov ax,[si] 
           add ax,10 
            
           mov bx,[di] 
           add bx,20 
           
     loopoutery2: mov dx,[si]
	 
           loopinnerx2:push ax
                      mov al,9h
                      mov ah,0ch
                      int 10h 
                      pop ax 
                      inc dx 
                      cmp dx,ax
                      jnz loopinnerx2
                      
           inc cx
           cmp cx,bx
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
	  
		  mov cx,11
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
	  
		  mov cx,11
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
					
					add word ptr [di],30
					
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
					
					sub word ptr [di],30
					
                beginnextanimation2:
								   add si,2
								   add di,2
								   dec cx
								   cmp cx,0
				                   jnz loopanimationbullet2
								  
				

Bulletanimatedreturn2: ret
BulletAnimation2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADJUST_POSITION1 PROC     ;PROCEDURE TO ADJUST COORDINATES OF THE SHOOTER'S 
						 ;POSITION TO BE UPDATED IN THE SUBSEQUENT FRAME
		
				;CHECKING WHETHER USER HAS PRESSED A KEY
		MOV AH,1  ;RETURNS THE CORRESPONDING KEY'S SCANCODE IN AH
		INT 16H
		jz exitadjust1
	
	CMP AH,1EH    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED
	
	CMP AH,2CH    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED
	
	JMP exitadjust1  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	
	UP_PRESSED:
		CMP SHOOTER2Y,50
		JL exitadjust1
		SUB SHOOTER2Y,50  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		MOV BX,0       
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust1
	
	DOWN_PRESSED:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER2Y,450
		JGE exitadjust1
		ADD SHOOTER2Y,50
		MOV BX,0
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust1
		
		
exitadjust1:	RET

ADJUST_POSITION1 ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADJUST_POSITION2 PROC     ;PROCEDURE TO ADJUST COORDINATES OF THE SHOOTER'S 
						 ;POSITION TO BE UPDATED IN THE SUBSEQUENT FRAME
		
				;CHECKING WHETHER USER HAS PRESSED A KEY
		MOV AH,1  ;RETURNS THE CORRESPONDING KEY'S SCANCODE IN AH
		INT 16H
		jz exitadjust2
	
	CMP AH,48H    ;CHECKING IF THE PRESSED KEY IS LETTER A (GO UP)
	JE UP_PRESSED2
	
	CMP AH,50H    ;CHECKING IF THE PRESSED KEY IS THE LETTER Z (GO DOWN)
	JE DOWN_PRESSED2
	
	JMP exitadjust2  ;KEYS OTHER THAN UP AND DOWN HAVE BEEN PRESSED WHICH MAKES NO EFFECT
	
	
	UP_PRESSED2:
		CMP SHOOTER1Y,0
		JLE exitadjust2
		SUB SHOOTER1Y,50  ;SINCE UP HAS BEEN PRESSED, WILL DECREMENT THE Y COORDINATE FOR ALL STARTING POINTS
		MOV BX,0       
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust2
	
	DOWN_PRESSED2:
						;SINCE DOWN HAS BEEN PRESSED, WILL INCREMENT THE Y COORDINATE 
		CMP SHOOTER1Y,440
		JGE exitadjust2
		ADD SHOOTER1Y,50
		MOV BX,0
		mov ah,7    ;clear key from buffer
		int 21h
		JMP exitadjust2
		
		
exitadjust2:	RET

ADJUST_POSITION2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitializeGame proc far
;Sets the memory to the Default values of beggining a new game

mov Bullets2Y   ,0
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

mov Bullets1Y   ,0
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

mov SHOOTER1X , 100   
mov SHOOTER1Y , 250   
mov SHOOTER2X , 900  
mov SHOOTER2Y , 200

mov block22Y   ,100
mov block22Y+2 ,200
mov block22Y+4 ,300
mov block22Y+6 ,400
mov block22Y+8 ,500
mov block22Y+10,600

mov block21Y   ,100
mov block21Y+2 ,200
mov block21Y+4 ,300
mov block21Y+6 ,400
mov block21Y+8 ,500
mov block21Y+10,600

mov block21x   ,950
mov block21x+2 ,950
mov block21x+4 ,950
mov block21x+6 ,950
mov block21x+8 ,950
mov block21x+10,950

mov block22x   ,990
mov block22x+2 ,990
mov block22x+4 ,990
mov block22x+6 ,990
mov block22x+8 ,990
mov block22x+10,990

mov booleantime,0
mov Timervalue,60
mov booleantime2,0

ret
InitializeGame endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;

Main proc far
	mov ax,@data
	mov ds,ax ; copy data segment
	
	mov ax, 4f02h
	mov bx, 105h
	int 10h ;graphical mode interrupt
	
	Call GameName
	
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
			  
		maingameloop:
		
				
				mov cx, 0H    ;  delay
				mov dx, 86A0H
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
				
				call StatusBar
				
				
				mov al,Timervalue
				cmp al,0
				jz tempmainmenujmp ; ***************** TO BE EDITED LATER TO SHOW SCORES ******************
				
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
	Exitmain: 
	mov ax,0003h
	int 10h ;return video mode
	
	mov ah,4ch
	int 21h  ;return program to dos
	
Main endp

end main 