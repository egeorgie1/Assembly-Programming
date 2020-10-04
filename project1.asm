JUMPS
masm
model small
.data
handle  dw  0 
filename     db 'MY.txt',0
point_fname dd  filename

string  db  200 dup (" ")
point_buffer dd string

errorMes db  0ah,0dh,'Not allowed any more! ','$'
mes    db   0ah,0dh,'Type 1 to crypt, type 2 to decrypt! ','$'
mes1   db   0ah,0dh,'Crypted one time: ','$'
mes2   db   0ah,0dh,'Crypted two times: ','$'
mes3   db   0ah,0dh,'Crypted 3 times: ','$'
mes4   db   0ah,0dh,'Decrypted: ','$'

count  db   0
divisor db  2

.stack  256
.code
main:
;open
mov ax,@data 
mov ds,ax 
mov al,0 
lds dx,point_fname 
mov ah,3dh 
int 21h
jc  exit 
mov [handle],ax
;read
mov bx,[handle]
mov cx,200
lds dx,point_buffer
mov ah,3fh 
int 21h
jc  exit
mov bp,ax 
nop
;close
mov ah,3eh 
int 21h
jc  exit
nop
;Now crypt and decrypt
jmp ask
crypt1: 
;test
cmp count,0
jg  crypt2

xor ax,ax   
mov cx,bp   
mov si,0    
go1:
cmp string[si],32      
je skipCr
mov al,string[si]
div divisor
cmp ah,0
jne odd
dec string[si]
jmp skipCr
odd:
inc string[si]
skipCr:   
inc si  
loop    go1 
inc count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes1
int 21h
jmp show

crypt2: 
;test
cmp count,1
jg  crypt3

xor ax,ax 
mov cx,bp   
mov si,0    
go2:        
sub string[si],158
neg string[si] 
inc si  
loop    go2 
inc count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes2
int 21h
jmp show

crypt3: 
;test
cmp count,2
jg  notAllowed

xor ax,ax 
mov cx,bp   
mov si,0    
go3: 
cmp string[si],97 
je skip    
xor string[si],30
skip:
inc si  
loop    go3 
inc count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes3
int 21h
jmp show

decrypt3: 
;test
cmp count,3
jl  decrypt2

xor ax,ax 
mov cx,bp   
mov si,0    
goDecr3: 
cmp string[si],97 
je skip1    
xor string[si],30
skip1:
inc si  
loop    goDecr3 
dec count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes4
int 21h
jmp show

decrypt2:   
;test
cmp count,2
jl  decrypt1

xor ax,ax   
mov cx,bp   
mov si,0    
goDecr2:        
sub string[si],158
neg string[si] 
inc si  
loop    goDecr2 
dec count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes4
int 21h
jmp show


decrypt1:   
;test
cmp count,1
jl  notAllowed

xor ax,ax   
mov cx,bp   
mov si,0    
goDecr1:        
cmp string[si],32      
je skipDecr
mov al,string[si]
div divisor
cmp ah,0
jne odd1
dec string[si]
jmp skipDecr
odd1:
inc string[si]
skipDecr:  
inc si  
loop    goDecr1 
dec count
;print on the screen
mov cx,bp
mov si,0
mov ah,09h
lea dx,mes4
int 21h
;jmp show

show:
mov ah,02h  
mov dl,string[si]
int 21h
inc si
loop    show

ask:
mov ah,09h
lea dx,mes
int 21h

mov ah, 01h 
int 21h

cmp al, 31h
je  crypt1
cmp al, 32h
je decrypt3

notAllowed:
mov ah,09h
lea dx,errorMes
int 21h
;jmp exit
exit: 
mov ax,4c00h 
int 21h 
end main