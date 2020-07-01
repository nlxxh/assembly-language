NAME RONG YUETONG
;本模块包含的子程序有SIX,M1
;本模块的功能是测试功能6，简单起见，
;省略判断是否为老板登陆以及判断当前浏览商品是否有效的过程
;同时，单独测试功能6时，和功能2的关系忽略
;当前浏览商品自行定义
INCLUDE  MYLIB.LIB
EXTRN     F2T10:FAR,CRLF:BYTE,SY:BYTE,F10T2:FAR,
GA1:BYTE,GA2:BYTE,GAN:BYTE,GOOD:BYTE,CURR:DWORD
PUBLIC SIX
.386
STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
NEWD DB 0AH,0DH,'Input New Discount:','$'      ;提示输入新的折扣率
NEWPC DB 0AH,0DH,'Input New Prime Cost:','$'      ;提示输入新的进货价
NEWSC  DB 0AH,0DH,'Input New Sale Cost:','$'      ;提示输入新的销售价
NEWPN  DB 0AH,0DH,'Input New Prime Number:','$'      ;提示输入新的进货总数
TO DB 0AH,0DH,'Testing Function 6 Alone,Input a Number to Define the Good You Want:',
0AH,0DH,'1:Pen',
0AH,0DH,'2:Book',
0AH,0DH,'3:Bag',
'$'      ;单独测试功能6时，当前浏览商品自行定义
SYM DB '<<$'      ;输出符号
IN_NEWG DB 20      ;存储输入的新数据
                  DB 0
                  DB 20 DUP(0)  	
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
SIX  PROC FAR
     MOV ECX,CURR
     ADD ECX,0AH
     MOV BL,1      ;SY置为1
     MOV SY,BL 
     CALL F2T10       ;输出当前浏览商品的折扣率
     ADD ECX,1
     MOV BL,0      ;SY置为0
     MOV SY,BL 
     CALL F2T10     
     MOV EDI,0
LOOP9:ADD ECX,2
             CALL F2T10        
             INC EDI
             CMP EDI,2
             JNE LOOP9      ;输出原来的信息
     MOV ECX,CURR      ;开始修改信息
     MOV BX,0      ;BX标志提示输入的信息
     ADD ECX,0AH
     MOV BL,1      ;SY置为1
     MOV SY,BL 
     MOV BX,1     
     CALL M1      ;调用M1   
     ADD ECX,1
     MOV BL,0      ;SY置为0
     MOV SY,BL
     MOV BX,2
     CALL M1
     ADD ECX,2
     MOV BX,3
     CALL M1       
     ADD ECX,2
     MOV BX,4
     CALL M1                 
     RET 
SIX ENDP 
M1 PROC
       .IF BX==1
            OP NEWD      ;输出提示输入新的折扣率
       .ELSEIF BX==2
                     OP NEWPC      ;输出提示输入新的进货价
       .ELSEIF BX==3
                     OP NEWSC      ;输出提示输入新的销售价 
       .ELSEIF BX==4
                     OP NEWPN      ;输出提示输入新的进货总数
       .ENDIF
      CALL F2T10
      OP SYM
      IP IN_NEWG
      LEA SI,IN_NEWG
      ADD SI,2      ;SI指向字节存储区的首址
      MOV AL,IN_NEWG+1
      MOVZX DI,AL      ;DI存放待转换十进制数字的长度
      .IF DI==0
            RET
      .ENDIF
      CALL F10T2      ;符号十进制数字串转换成二进制数送入AX中
      .IF SI==-1
            JMP M1
      .ENDIF
      .IF SY==1
           MOV [ECX],AL
      .ELSEIF SY==0
                    MOV [ECX],AX 
      .ENDIF      
      RET
M1 ENDP
CODE    ENDS
        END 