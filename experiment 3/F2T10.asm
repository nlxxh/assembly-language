NAME RONG YUETONG
;��ģ��������ӳ�����F2T10
;��ģ�鹦���ǽ�ʮ��������ת����ʮ����ASCII�����

INCLUDE  MYLIB.LIB
EXTRN SY:BYTE,CRLF:BYTE
PUBLIC   F2T10
.386

STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS 

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
TEMP DB 10 DUP('0')      ;�����Ϣʹ��
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
          ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
F2T10  PROC FAR     	;ʮ��������(�ֽ�)תʮ�������
              PUSH BX      ;����6�����б����ֳ�
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
                  DIV BX      ;�ֳ���������AX��������DX
                  ADD DL,30H
                  MOV TEMP[ESI],DL       
                  CMP AX,0      ;��Ϊ0������ѭ��
                  JE F10
             .ELSE
                       DIV BL      ;�ֽڳ���������AL��������AH
                       ADD AH,30H
                       MOV TEMP[ESI],AH       
                       CMP AL,0      ;��Ϊ0������ѭ��
                       JE F10
                       MOVZX AX,AL
             .ENDIF
             INC ESI
             JMP LOOP6 
F10: OP CRLF      ;������з�
F11: OP1 TEMP[ESI]
       .IF ESI==0
             POP BX      ;����6�����б����ֳ�
             RET
       .ENDIF
       DEC ESI   
       JMP F11  
F2T10 ENDP
CODE   ENDS
          END  


