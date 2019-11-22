.Model Large
.Stack 64
.Data
.code
Main proc far
	mov ax,@data
	mov ds,ax ; copy data segment
	
	mov ax, 4f02h
	mov bx, 105h
	int 10h ;graphical mode interrupt
	
	
	
	
	
	mov ah,4ch
	int 21h  ;return program to dos
	
Main endp
end main
	