
INCLUDE MYLIB.LIB

PUBLIC   F10T2

;�ӳ�������:F10T2
;����:����siΪָ����ֽڴ洢���е�
;�޷���ʮ�������ִ�ת���ɶ�����������AX��
;��ڲ���:SI :ָ���ֽڴ洢������ַ
;          DI  :��Ŵ�ת��ʮ�������ֵĳ���
;���ڲ���:	SI:Ϊ-1��ʱ���ʾ�����д���
;	    AX:���ת���Ժ��������
;���üĴ���:BX,ECX:�����ֳ�
	
.386
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME CS:CODE,DS:DATA
F10T2 PROC FAR
	PUSH BX      ;�����ֳ�
                PUSH ECX      ;�����ֳ�
	MOV EAX,0
POS:	OR DI,DI
	JZ ERR1	
NUM:       MOV BL,[SI]	
	CMP BL,'0'
	JB ERR1
	CMP BL,'9'
	JA ERR1
	SUB BL,30H
	MOVZX EBX,BL
	IMUL EAX,10
	JO ERR1
	ADD EAX,EBX
	JO ERR1
	JS ERR1
	JC ERR1
	DEC DI
	.IF DI!=0
                     INC SI
                     JMP NUM
                 .ENDIF
	CMP EAX,7FFFH
	JA ERR1
OVE:	POP ECX      ;�����ֳ�
                POP BX	    ;�����ֳ�
	RET
ERR1:	MOV SI,-1
	JMP OVE
F10T2 ENDP
CODE ENDS
	END