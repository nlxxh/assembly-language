NAME RONG YUETONG
;本模块包含的子程序有F2T10
;本模块功能是将十六进制数转换成十进制ASCII码输出

INCLUDE  MYLIB.LIB
EXTRN SY:BYTE,CRLF:BYTE
PUBLIC   F2T10
.386

STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS 

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
TEMP DB 10 DUP('0')      ;输出信息使用
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
          ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
F2T10  PROC FAR     	;十六进制字(字节)转十进制输出
              PUSH BX      ;功能6调用中保护现场
             .IF SY==0
                   MOV AX,[ECX]
                  MOV BX,0AH  
              .ELSE
                        MOV AL,[ECX]
                        MOVZX AX,AL
                        MOV BL,0AH  
              .ENDIF
              MOV ESI,0           
LOOP6:.IF SY==0 
                  MOV DX,0
                  DIV BX      ;字除法，商在AX，余数在DX
                  ADD DL,30H
                  MOV TEMP[ESI],DL       
                  CMP AX,0      ;商为0，结束循环
                  JE F10
             .ELSE
                       DIV BL      ;字节除法，商在AL，余数在AH
                       ADD AH,30H
                       MOV TEMP[ESI],AH       
                       CMP AL,0      ;商为0，结束循环
                       JE F10
                       MOVZX AX,AL
             .ENDIF
             INC ESI
             JMP LOOP6 
F10: OP CRLF      ;输出换行符
F11: OP1 TEMP[ESI]
       .IF ESI==0
             POP BX      ;功能6调用中保护现场
             RET
       .ENDIF
       DEC ESI   
       JMP F11  
F2T10 ENDP
CODE   ENDS
          END  


