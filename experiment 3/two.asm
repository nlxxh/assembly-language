NAME RONG YUETONG
;��ģ��������ӳ�����TWO,DIS,F2T10
;��ģ��Ĺ����ǲ��Թ���2

INCLUDE  MYLIB.LIB
EXTRN    GOOD:BYTE,N:ABS,GA1:BYTE,GA2:BYTE,
GAN:BYTE,CRLF:BYTE,SY:BYTE,F2T10:FAR
PUBLIC   TWO,CURR
.386
STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
GAN1 DB 0AH,0DH,'Input Good Name:(Max 9 characters)','$'      ;��ʾ������Ʒ����
IN_GOOD DB 10      ;�洢�������Ʒ����
                  DB 0
                  DB 10 DUP(0) 
CURR DD 0      ;�洢��ǰ�����Ʒ�ĵ�ַ
ERR2 DB 0AH,0DH,0AH,0DH,'Good Not Found','$'      ;��ʾ��Ʒ������
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
TWO  PROC  FAR
      OP GAN1      ;ѡ����2����ʾ������Ʒ����
      IP IN_GOOD      ;������Ʒ����
      MOV BL,IN_GOOD+1
      MOV BH,0
      MOV BYTE PTR IN_GOOD+2[BX],0
      LEA ESI,IN_GOOD      ;�û��������Ʒ���Ƶĵ�ַ����Ĵ���ESI
      ADD ESI,2 
      LEA EDI,GA1      ;��һ����Ʒ��Ϣ�ĵ�ַ����Ĵ���EDI
      MOV CURR,EDI      ;CURR��ŵ�ǰ�����Ʒ�ĵ�ַ�������¶���
      MOV EDX,0      ;ѭ���ṹ��Ѱ��ƥ�����Ʒ������N����Ʒ   
      MOV ECX,0
LOOP1: MOV EAX,DS:[EDI]      ;��Ʒ��Ϣ����Ĵ���EAX
             MOV EBX,DS:[ESI]      ;�û��������Ʒ��������Ĵ���EBX
             CMP AH,0     ;����������Ʒ���Ƶ��ַ�����ѭ����������
             JE EXIST
             CMP EAX,EBX      ;���бȽ�
             JNE TRANS      ;�������Ʒ���ƺ͵�ǰ����Ʒ��ƥ�䣬����һ����Ʒ�����ƱȽ�
             ADD EDI,4
             ADD ESI,4
             JMP LOOP1
TRANS: INC EDX      ;�ҵ���һ����Ʒ
             .IF EDX == N      ;�ж��Ƿ��Ѿ����������һ����Ʒ��û�ҵ�
                  OP ERR2
                  RET   
             .ENDIF
             ADD ECX,21
             LEA EDI,GA1[ECX]      ;��һ����Ʒ��Ϣ�ĵ�ַ����Ĵ���EDI
             MOV CURR,EDI      ;CURR��ŵ�ǰ�����Ʒ�ĵ�ַ�������¶���
             LEA ESI,IN_GOOD      ;��ΪESI�����Ѿ��ı䣬���Խ��û��������Ʒ���Ƶĵ�ַ��������Ĵ���ESI
             ADD ESI,2                      
             JMP LOOP1
EXIST: LEA ESI,IN_GOOD      ;��Ʒ���ڣ�ѭ���ṹ����Ʒ���Ƽ�¼��GOOD�ֶ�
            ADD ESI,2    
            LEA EDI,GOOD
LOOP2: MOV AL,DS:[ESI]
              .IF AL == 0     ;��Ʒ���Ƽ�¼��ϣ�ѭ������
                   CALL DIS      ;������ʾ��Ʒ��Ϣ���ӳ���
                   RET
              .ENDIF
              MOV DS:[EDI],AL
              INC EDI
              INC ESI
              JMP LOOP2
TWO ENDP
DIS PROC      ;��ʾ��Ʒ��Ϣ
       MOV ECX,CURR      ;ECXΪ��ǰ�����Ʒ���׵�ַ
       OP CRLF
LOOP5: OP1 [ECX]      ;�����ǰ�����Ʒ������
              INC ECX
              MOV DL,[ECX]
              CMP DL,0
              JNE LOOP5
        MOV ECX,CURR
        ADD ECX,0AH
        MOV BL,1      ;SY��Ϊ1
        MOV SY,BL   
        CALL F2T10      ;�����ǰ�����Ʒ���ۿ���   
        ADD ECX,3
        MOV BL,0      ;SY��Ϊ0
        MOV SY,BL   
        CALL F2T10     
         MOV EDI,0
LOOP8:ADD ECX,2
             CALL F2T10        
             INC EDI
             CMP EDI,3
             JNE LOOP8
        OP CRLF
        RET 
DIS ENDP
CODE    ENDS
        END       