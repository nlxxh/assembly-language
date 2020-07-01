.386
STACK SEGMENT USE16 STACK
DB 100 DUP(0)
STACK ENDS

STACKBAK SEGMENT USE16 
DB 100 DUP(0)
STACKBAK ENDS

DATA SEGMENT USE16 
BNAME DB 'RONG YUETONG',0      ;�ϰ�����  
BPASS DB 6 XOR 'C'      ;���봮�ĳ���Ϊ6�����������
            DB ('T'-10H)*2  
            DB ('E'-10H)*2 
            DB ('S'-10H)*2 
            DB ('T'-10H)*2
            DB ('0'-10H)*2
            DB ('0'-10H)*2 
            DB 0      ;����   
AUTH DB 0      ;��ǰ��¼״̬��0��ʾ�˿�״̬    
GOOD DB 10 DUP(0)      ;��ǰ�����Ʒ����     
N EQU 3
M DD 10
MM DD 10
FLA DW 0      ;�ж��Ƿ�װ���жϴ������
SNAME DB 'SHOP',0      ;�������ƣ���0����               
GA1 DB 'PEN', 7 DUP(0),10      ;��Ʒ���Ƽ��ۿ�    
       DW 35 XOR 'T'
       DW 56,20,5,?      ;�Ƽ��Ȼ�δ����      
GA2 DB 'BOOK',6 DUP(0),9      ;��Ʒ���Ƽ��ۿ�       
        DW 12 XOR 'E'
        DW 30,30,5,?      ;�Ƽ��Ȼ�δ����     
GAN DB 'BAG',7 DUP(0),9
         DW 12 XOR 'S'
         DW 30,16,5,?
BUF DB 0AH,0DH,'User Name:(Boss or Customer)',
0AH,0DH,'Current Good Name:(Blank is Allowed)',
0AH,0DH,'Please Input Number 1-9:',
0AH,0DH,'1.Log in/Log in Again',
0AH,0DH,'2.Seek a Specific Good and Show Information',
0AH,0DH,'3.Place an Order',
0AH,0DH,'4.Calculate Good Recommendation Index',
0AH,0DH,'5.Rank',
0AH,0DH,'6.Correct Information',
0AH,0DH,'7.Transfer to Another Operating Environment',
0AH,0DH,'8.Show Current Code Segment Address',
0AH,0DH,'9.Exit',
0DH,0AH,
'$'      ;��ʾ������Ϣ
ERR DB 0AH,0DH,0AH,0DH,'Input Error!Try Again!','$'      ;�������ʱ����ʾ������Ϣ
ERR1 DB 0AH,0DH,0AH,0DH,'Log in Failed!Try Again!','$'      ;��½ʧ��ʱ����ʾ������Ϣ
ERR2 DB 0AH,0DH,0AH,0DH,'Good Not Found','$'      ;��ʾ��Ʒ������
ERR3 DB 0AH,0DH,0AH,0DH,'Error','$'      ;��ʾ����
BNAME1 DB 0AH,0DH,'Input Name:(Max 12 Characters)','$'      ;��ʾ��������
BPASS1 DB 0AH,0DH,'Input Password:(Max 6 characters)','$'      ;��ʾ��������
GAN1 DB 0AH,0DH,'Input Good Name:(Max 9 characters)','$'      ;��ʾ������Ʒ����
NEWD DB 0AH,0DH,'Input New Discount:','$'      ;��ʾ�����µ��ۿ���
NEWPC DB 0AH,0DH,'Input New Prime Cost:','$'      ;��ʾ�����µĽ�����
NEWSC  DB 0AH,0DH,'Input New Sale Cost:','$'      ;��ʾ�����µ����ۼ�
NEWPN  DB 0AH,0DH,'Input New Prime Number:','$'      ;��ʾ�����µĽ�������
SYM DB '<<$'      ;�������
CURR DD 0      ;�洢��ǰ�����Ʒ�ĵ�ַ
CADR DB 10 DUP(0)      ;�洢CS���������
SY DB 0       ;ȷ������ֽڻ�����
NAL DD 0
CRLF DB 0AH,0DH,'$'      ;�������
IN_NAME DB 13      ;�洢���������
                  DB 0
                  DB 13 DUP(0) 
IN_PWD DB 7     ;�洢���������
                DB 0
                DB 7 DUP(0)
IN_GOOD DB 10      ;�洢�������Ʒ����
                  DB 0
                  DB 10 DUP(0) 
IN_NEWG DB 20      ;�洢�����������
                  DB 0
                  DB 20 DUP(0)  
SIG DB 0      ;��־ִ�й���4���Ƿ���ͨ������3
TEMP DB 10 DUP('0')      ;����2�����Ϣʹ��
TABLE DW F1,F2,F3,F4,F5,F6,F7,F8,F9      ;������ַ�����ڼ��ת�Ʒ�����
P1 DW PASS1      ;������ַ��      
E1 DW OVER      ;������ַ��
DATA ENDS

CODE SEGMENT USE16 
           ASSUME DS:DATA,CS:CODE,SS:STACK
      SSEG DW ?,?      ;���ڱ���2����ջ�εĶε�ַ
      SECSET DB 0      ;�趨��
      OLD_INT DW ?,?      ;ԭINT 08H���ж�ʸ��
      FLAG DB 0       ;0=STACK, 1=STACKBAK
OP MACRO A      ;�����Ϣ�ĺ�
      LEA DX,A
      MOV AH,9
      INT 21H
      ENDM
OP1 MACRO A      ;���һ���ַ��ĺ�
        MOV DL,A
        MOV AH,2
        INT 21H
        ENDM
IP   MACRO A      ;������Ϣ�ĺ�
      LEA DX,A
      MOV AH,10
      INT 21H
      ENDM 
START:MOV AX,DATA       
            MOV DS,AX    
           OP BUF      ;���������Ϣ
           MOV AH,1      ;�û�����
           INT 21H
           .IF AL < '1'
               OP ERR
               JMP START
           .ELSEIF AL > '9'
                        OP ERR
                         JMP START 
           .ELSEIF AL == '1'
                        MOV BX,TABLE
                        CALL BX
                        JMP START
           .ELSEIF AL == '2'
                        MOV BX,TABLE+2
                        CALL BX
                        JMP START
           .ELSEIF AL == '3'
                        MOV BX,TABLE+4
                        CALL BX
                        JMP START
           .ELSEIF AL == '4'
                        MOV BX,TABLE+6
                        CALL BX
                        JMP START
           .ELSEIF AL == '5'
                        MOV BX,TABLE+8
                        CALL BX
                        JMP START
           .ELSEIF AL == '6'
                        MOV BX,TABLE+10
                        CALL BX
                        JMP START
           .ELSEIF AL == '7'
                        MOV BX,TABLE+12
                        CALL BX
                        JMP START
           .ELSEIF AL == '8'
                        MOV BX,TABLE+14
                        CALL BX
                        JMP START
           .ELSE 
                     MOV BX,TABLE+16
                     CALL BX
           .ENDIF
F1  PROC
K:   OP BNAME1      ;ѡ����1����ʾ��������
      IP IN_NAME      ;��������
      OP BPASS1      ;��ʾ��������
      IP IN_PWD      ;��������
      .IF IN_NAME+1==0
           POP CX      ;���ջ
           JMP START
      .ENDIF
      LEA ESI,IN_NAME      ;�û���������ֵĵ�ַ����Ĵ���ESI
      ADD ESI,2
      LEA EDI,BNAME      ;�ϰ�����ֵĵ�ַ����Ĵ���EDI
      MOV CX,0      ;ѭ���ṹ����ʼ������֤
LOOPA: MOV AL,DS:[EDI]      ;�ϰ���������ַ�Ϊ��λ����Ĵ���AL
             MOV BL,DS:[ESI]      ;�û�������������ַ�Ϊ��λ����Ĵ���BL
             .IF AL != BL      ;���бȽ� 
                 OP ERR1     ;��¼ʧ�ܣ����������Ϣ 
                 JMP K
             .ENDIF
             INC EDI
             INC ESI
             INC CX
             CMP CX,0CH     ;ѭ����������
             JNE LOOPA
      
      CLI      ;��ʱ�����ٿ�ʼ 
      MOV  AH,2CH 
      INT  21H
      PUSH DX   

      MOV CL,IN_PWD+1      ;�Ƚ�����Ĵ��������볤���Ƿ�һ��
      XOR CL,'C'
      SUB CL,BPASS
      MOVSX  BX,CL
      ADD BX,OFFSET P1    

      MOV AH,2CH       ;��ȡ�ڶ�������ٷ���
      INT 21H
      STI
      CMP  DX,[ESP]       ;��ʱ�Ƿ���ͬ
      POP DX
      JZ OK1        ;�����ʱ��ͬ��ͨ�����μ�ʱ������   
      JMP E1      ;�����ʱ��ͬ���˳�ϵͳ

OK1: MOV  BX,[BX]
         CMP BX,0147H      ;�Ƿ���PASS1����ָ���ʵ�������ж�ǰ��ȽϵĴ����Ƿ���ͬ
         JZ OK2
         MOV BX,K
         JMP BX

OK2: JMP   BX
         DB  'HOW TO GO'      ;�����������Ϣ����������

PASS1: LEA ESI,IN_PWD     ;�û����������ĵ�ַ����Ĵ���ESI
            ADD ESI,2
            LEA EDI,BPASS      ;��ȷ����ĵ�ַ����Ĵ���EDI
            INC EDI
            MOV CX,0      ;ѭ���ṹ����ʼ������֤      
LOOPB: MOV AL,DS:[EDI]      ;��ȷ�������ַ�Ϊ��λ����Ĵ���AL
             MOV BL,DS:[ESI]      ;�û�������������ַ�Ϊ��λ����Ĵ���BL
             SUB BL,10H
             SAL BL,1
             .IF AL != BL      ;���бȽ�
                 OP ERR1      ;��¼ʧ�ܣ����������Ϣ
                 MOV BX,K
                 JMP BX
             .ENDIF
             INC EDI
             INC ESI
             INC CX
             CMP CX,06H     ;ѭ����������
             JNE LOOPB
      MOV AL,1      ;���ֺ��������ȷ����1�͵�AUTH�����У��ص����˵�����
      MOV AUTH,AL      
      RET
F1 ENDP
OVER: MOV AH,4CH
            INT 21H
F2  PROC
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
F2 ENDP
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
        CALL F16T10      ;�����ǰ�����Ʒ���ۿ���   
        ADD ECX,3
        MOV BL,0      ;SY��Ϊ0
        MOV SY,BL   
        CALL F16T10     
         MOV EDI,0
LOOP8:ADD ECX,2
             CALL F16T10        
             INC EDI
             CMP EDI,3
             JNE LOOP8
        OP CRLF
        RET 
DIS ENDP
F16T10 PROC      	;ʮ��������(�ֽ�)תʮ���ƴ����
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
F16T10 ENDP      
F3  PROC
      MOV EAX,MM
      MOV M,EAX 
      ;MOV  AX, 0
      ;CALL TIMER      ;��ʾ��ʼ��ʱ  
      MOV AL,GOOD      ;ѡ����3���жϵ�ǰ�����Ʒ�Ƿ���Ч
      .IF AL == 0
           OP ERR3      ;��ǰ�����Ʒ��Ч�����������Ϣ
           POP CX
           JMP START
      .ENDIF
Q:  MOV ECX,CURR
      ADD ECX,15
      MOV AX,DS:[ECX]      ;��ǰ�����Ʒ��Ч���ж���ʣ�������Ƿ�Ϊ0
      ADD ECX,2
      MOV BX,DS:[ECX]
      .IF AX <= BX
           OP ERR3      ;��Ʒʣ������Ϊ0�����������Ϣ
           MOV DH,0
           MOV SIG,DH      ;��־��Ϊ0
           JMP START      
      .ENDIF
      INC BX      ;ʣ��������Ϊ0��������������1
      MOV DS:[ECX],BX 
      MOV DH,1
      MOV SIG,DH      ;��־��Ϊ1
      MOV BX,TABLE+6
      CALL BX      ;���¼���������Ʒ���Ƽ���     
      OP CRLF      ;������з�
      MOV  AX, 1
      ;CALL TIMER      ;��ֹ��ʱ����ʾ��ʱ���(ms)
      MOV DH,0 
      MOV SIG,DH      ;��־��Ϊ0	 
      JMP START
F3 ENDP
F4  PROC
      MOV NAL,0
      MOV ECX,0      ;ѡ����4��ѭ���ṹ����ÿ����Ʒ���Ƽ���
      MOV EDI,0
      LEA EDI,GA1[EDI]      ;EDI��ŵ�һ����Ʒ���׵�ַ
LOOP3: ADD EDI,10 
              MOV BL,[EDI]      ;BL�����Ʒ�ۿ���
              ADD EDI,1   
              MOV SI,[EDI]      ;SI�����Ʒ������
              MOV EAX,NAL  
              MOVZX DX,IN_PWD+2[EAX] 
              XOR SI,DX      ;��Ʒ�����۽���
              ADD EDI,2
              MOV AX,[EDI]      ;AX�����Ʒ���ۼ�
              MOVZX EAX,AX
              IMUL EAX,BL
              MOV EDX,0
              MOV EBX,0AH
              DIV EBX
              MOV EBX,EAX      ;EBX���ʵ�����ۼ۸�
              MOVZX EAX,SI
              MOV EDX,0
              DIV EBX
              MOV ESI,EAX      ;ESI��Ž�����/ʵ�����ۼ۵���
              ADD EDI,2
              MOV BX,[EDI]      ;BX��Ž�������
              MOVZX EBX,BX
              SAL EBX,1      ;EBX���2*��������
              ADD EDI,2
              MOV AX,[EDI]      ;AX�����������
              MOVZX EAX,AX
              MOV EDX,0            
              DIV EBX      ;��������/��2*�������������̴���Ĵ���EAX
              ADD EAX,ESI
              SAL EAX,7
              ADD EDI,2
              MOV [EDI],AX      ;����õ��Ƽ����ͻ�ÿ����Ʒ��Ϣ��ָ��λ��
              INC ECX
              ADD EDI,2      ;��ʱEDI�����һ����Ʒ���׵�ַ
              MOV EAX,NAL
              INC EAX
              MOV NAL,EAX      ;����һ����Ʒ�����۽�����׼��
              CMP ECX,N      ;N����Ʒ���Ƽ��ȼ�����ϣ��˳�ѭ��
              JNE LOOP3  
     .IF SIG==0
           RET     ;���������˵����õĹ���4����ֱ�ӷ������˵� 
     .ENDIF    
      MOV EAX,M
      DEC EAX
      .IF EAX==0
           RET
      .ENDIF
      MOV M,EAX                           
      JMP Q
F4 ENDP
F5 PROC
F5 ENDP
F6 PROC
     MOV AL,AUTH      
     CMP AL,1      ;���ϰ��½���������˵�
     JNE START
     MOV AL,GOOD      ; ��ǰ�����Ʒ��Ч���������˵�
     CMP AL,0
     JE START
     MOV ECX,CURR
     ADD ECX,0AH
     MOV BL,1      ;SY��Ϊ1
     MOV SY,BL 
     CALL F16T10       ;�����ǰ�����Ʒ���ۿ���
     ADD ECX,1
     MOV BL,0      ;SY��Ϊ0
     MOV SY,BL 
     CALL F16T10     
     MOV EDI,0
LOOP9:ADD ECX,2
             CALL F16T10        
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
F6 ENDP 
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
      CALL F16T10
      OP SYM
      IP IN_NEWG
      LEA SI,IN_NEWG
      ADD SI,2      ;SIָ���ֽڴ洢������ַ
      MOV AL,IN_NEWG+1
      MOVZX DI,AL      ;DI��Ŵ�ת��ʮ�������ֵĳ���
      .IF DI==0
            RET
      .ENDIF
      CALL F10T2      ;ʮ�������ִ�ת���ɶ�����������AX��
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
F7 PROC
     MOV AX,1
     MOV FLA,AX      ;�Ѱ�װ�жϴ������
     MOV AX,STACK      ;����������ջ�εĶε�ַ
     MOV CS:SSEG,AX
     MOV AX,STACKBAK
     MOV CS:SSEG+2,AX
     MOV AX,3508H      ;��ȡԭ08H���ж�ʸ��
     INT 21H
     MOV CS:OLD_INT,BX      ;����ԭ�����ж�ʸ��
     MOV CS:OLD_INT+2,ES
     PUSH CS
     POP DS
     MOV DX,OFFSET NEW08H
     MOV AX,2508H      ;�����µ�08H�ж�ʸ��
     INT 21H
     MOV DX, CS:OLD_INT
     MOV DS, CS:OLD_INT+2
     MOV AX, 2508H
     INT 21H
     RET
F7 ENDP
NEW08H	PROC FAR
	PUSHF      ;ִ��ԭ08H���ж�ʸ���᷵��EFLAGS 
	CALL DWORD PTR CS:OLD_INT
	PUSH AX      ;�����ֳ�
	MOV AL, 0      ;��ȡ��
	OUT 70H, AL
	JMP $+2      ;��֤�˿ڲ����Ŀɿ���
	IN AL, 71H   
	CMP AL, CS:SECSET
	JZ L1
L0:	POP AX
	IRET
L1:	PUSH DS      ;�����ֳ�
	PUSH ES
	PUSH BX
	CMP FLAG, 0
	JNZ L2
	MOV FLAG, 1      ;STACKת��STACKBAK
	MOV DS, SSEG
	MOV ES, SSEG+2
	JMP	L3
L2:	MOV	FLAG, 0       ;STACKBAKת��STACK
	MOV	DS, SSEG+2
	MOV	ES, SSEG
L3:	MOV	BX, 0
L4:	MOV	AL, DS:[BX]      ;��DS�ε����ݸ��Ƹ�ES��
	MOV	ES:[BX], AL
	INC	BX
	CMP	BX, 100
	JB	L4
	MOV	AX, ES
	MOV	SS, AX      ;���¶�ջ��SS
	POP	BX
	POP	ES
	POP	DS
	JMP	L0      ;����
NEW08H	ENDP
F8 PROC      ;��ʾ��ǰ��ջ�ε�����
      OP CRLF
      MOV	AH, -1
NEXT:MOV AL, CS:FLAG
          CMP AL, AH
          JZ	NEXT
          MOV AX, SS
          CALL F12
          MOV AH, CS:FLAG
          JMP NEXT	
F8 ENDP
F12 PROC 
      MOV BL,16      
      MOV ECX,0
LOOP4: DIV BL      ;�ֽڳ���������AL��������AH
            .IF AH>=10
                 ADD AH,7
            .ENDIF
            ADD AH,30H
            MOV CADR[ECX],AH       
            CMP AL,0      ;��Ϊ0������ѭ��
            JE FIM
            MOVZX AX,AL
            INC ECX
            JMP LOOP4 
FIM: OP1 ' '      ;������з�
FIN: MOV DL,CADR[ECX]      ;�����ǰSS�ε�����
       MOV AH,2
       INT 21H
       .IF ECX==0
            RET
       .ENDIF
       DEC ECX   
       JMP FIN   
F12 ENDP
F9 PROC
     .IF FLA==1      ;�ָ��ж�ʸ����
           MOV DX, CS:OLD_INT
           MOV DS, CS:OLD_INT+2
           MOV AX, 2508H
           INT 21H
     .ENDIF
     MOV AH,4CH      ;ѡ����9���˳�ϵͳ
     INT 21H
F9 ENDP
TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP

F10T2 PROC FAR
	PUSH BX      ;�����ֳ�
                PUSH ECX      ;�����ֳ�
	MOV EAX,0
POS:	OR DI,DI
	JZ ER	
NUM:       MOV BL,[SI]	
	CMP BL,'0'
	JB ER
	CMP BL,'9'
	JA ER
	SUB BL,30H
	MOVZX EBX,BL
	IMUL EAX,10
	JO ER
	ADD EAX,EBX
	JO ER
	JS ER
	JC ER
	DEC DI
	.IF DI!=0
                     INC SI
                     JMP NUM
                 .ENDIF
	CMP EAX,7FFFH
	JA ER
OVE:	POP ECX      ;�����ֳ�
                POP BX	    ;�����ֳ�
	RET
ER:	MOV SI,-1
	JMP OVE
F10T2 ENDP
CODE ENDS
          END START           
