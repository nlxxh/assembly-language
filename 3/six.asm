NAME RONG YUETONG
;��ģ��������ӳ�����SIX,M1
;��ģ��Ĺ����ǲ��Թ���6���������
;ʡ���ж��Ƿ�Ϊ�ϰ��½�Լ��жϵ�ǰ�����Ʒ�Ƿ���Ч�Ĺ���
;ͬʱ���������Թ���6ʱ���͹���2�Ĺ�ϵ����
;��ǰ�����Ʒ���ж���
INCLUDE  MYLIB.LIB
EXTRN     F2T10:FAR,CRLF:BYTE,SY:BYTE,F10T2:FAR,
GA1:BYTE,GA2:BYTE,GAN:BYTE,GOOD:BYTE,CURR:DWORD
PUBLIC SIX
.386
STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
NEWD DB 0AH,0DH,'Input New Discount:','$'      ;��ʾ�����µ��ۿ���
NEWPC DB 0AH,0DH,'Input New Prime Cost:','$'      ;��ʾ�����µĽ�����
NEWSC  DB 0AH,0DH,'Input New Sale Cost:','$'      ;��ʾ�����µ����ۼ�
NEWPN  DB 0AH,0DH,'Input New Prime Number:','$'      ;��ʾ�����µĽ�������
TO DB 0AH,0DH,'Testing Function 6 Alone,Input a Number to Define the Good You Want:',
0AH,0DH,'1:Pen',
0AH,0DH,'2:Book',
0AH,0DH,'3:Bag',
'$'      ;�������Թ���6ʱ����ǰ�����Ʒ���ж���
SYM DB '<<$'      ;�������
IN_NEWG DB 20      ;�洢�����������
                  DB 0
                  DB 20 DUP(0)  	
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
SIX  PROC FAR
     MOV ECX,CURR
     ADD ECX,0AH
     MOV BL,1      ;SY��Ϊ1
     MOV SY,BL 
     CALL F2T10       ;�����ǰ�����Ʒ���ۿ���
     ADD ECX,1
     MOV BL,0      ;SY��Ϊ0
     MOV SY,BL 
     CALL F2T10     
     MOV EDI,0
LOOP9:ADD ECX,2
             CALL F2T10        
             INC EDI
             CMP EDI,2
             JNE LOOP9      ;���ԭ������Ϣ
     MOV ECX,CURR      ;��ʼ�޸���Ϣ
     MOV BX,0      ;BX��־��ʾ�������Ϣ
     ADD ECX,0AH
     MOV BL,1      ;SY��Ϊ1
     MOV SY,BL 
     MOV BX,1     
     CALL M1      ;����M1   
     ADD ECX,1
     MOV BL,0      ;SY��Ϊ0
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
            OP NEWD      ;�����ʾ�����µ��ۿ���
       .ELSEIF BX==2
                     OP NEWPC      ;�����ʾ�����µĽ�����
       .ELSEIF BX==3
                     OP NEWSC      ;�����ʾ�����µ����ۼ� 
       .ELSEIF BX==4
                     OP NEWPN      ;�����ʾ�����µĽ�������
       .ENDIF
      CALL F2T10
      OP SYM
      IP IN_NEWG
      LEA SI,IN_NEWG
      ADD SI,2      ;SIָ���ֽڴ洢������ַ
      MOV AL,IN_NEWG+1
      MOVZX DI,AL      ;DI��Ŵ�ת��ʮ�������ֵĳ���
      .IF DI==0
            RET
      .ENDIF
      CALL F10T2      ;����ʮ�������ִ�ת���ɶ�����������AX��
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