.386
STACK SEGMENT USE16 STACK
STACK ENDS
DATA SEGMENT USE16
BNAME DB 'RONG YUETONG',0      ;�ϰ�����
BPASS DB 'TEST00',0      ;����
AUTH DB 0      ;��ǰ��¼״̬��0��ʾ�˿�״̬
GOOD DB 10 DUP(0)      ;��ǰ�����Ʒ����
N EQU 30
SNAME DB 'SHOP',0      ;�������ƣ���0����
GA1 DB 'PEN', 7 DUP(0),10      ;��Ʒ���Ƽ��ۿ�
DW 35,56,70,25,?      ;�Ƽ��Ȼ�δ����
GA2 DB 'BOOK',6 DUP(0),9      ;��Ʒ���Ƽ��ۿ�
DW 12,30,25,5,?      ;�Ƽ��Ȼ�δ����
GAN DB N-2 DUP( 'TempValue',0,8,15,0,20,0,30,0,2,0,0,0)      ;����2���Ѿ����嶨���˵���Ʒ��Ϣ���⣬������Ʒ��Ϣ��ʱ�ٶ�Ϊһ����
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
CURR DD 0      ;�洢��ǰ�����Ʒ�ĵ�ַ
CADR DB 10 DUP(0)      ;�洢CS���������
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
DATA ENDS
CODE SEGMENT USE16
     ASSUME CS:CODE,DS:DATA,SS:STACK
START:MOV AX,DATA
      MOV DS,AX
      LEA DX,BUF      ;���������Ϣ
      MOV AH,9
      INT 21H
      MOV AH,1      ;�û�����
      INT 21H
      CMP AL,'1'      ;���벻��0~9�����������Ϣ    
      JB LERR
      CMP AL,'9'
      JA LERR
      CMP AL,'1'
      JE F1
      CMP AL,'2'
      JE F2
      CMP AL,'3'
      JE F3
      CMP AL,'4'
      JE F4
      CMP AL,'5'
      JE F5
      CMP AL,'6'
      JE F6
      CMP AL,'7'
      JE F7
      CMP AL,'8'
      JE F8
      CMP AL,'9'
      JE F9
LERR: LEA DX,ERR      ;���������Ϣ
      MOV AH,9
      INT 21H
      JMP START      ;������ʾ���˵�����
F1: LEA DX,BNAME1      ;ѡ����1����ʾ��������
    MOV AH,9
    INT 21H
    LEA DX,IN_NAME      ;��������
    MOV AH,10
    INT 21H
    CMP IN_NAME+1,0
    JE START
    LEA DX,BPASS1      ;��ʾ��������
    MOV AH,9
    INT 21H
    LEA DX,IN_PWD      ;��������
    MOV AH,10
    INT 21H
    LEA ESI,IN_NAME      ;�û���������ֵĵ�ַ����Ĵ���ESI
    ADD ESI,2
    LEA EDI,BNAME      ;�ϰ�����ֵĵ�ַ����Ĵ���EDI
    MOV CX,0      ;ѭ���ṹ����ʼ������֤
LOOPA: MOV AL,DS:[EDI]      ;�ϰ���������ַ�Ϊ��λ����Ĵ���AL
       MOV BL,DS:[ESI]      ;�û�������������ַ�Ϊ��λ����Ĵ���BL
       CMP AL,BL      ;���бȽ�
       JNE WRONG      ;���ֲ��ԣ���ʾ������Ϣ       
       INC ESI
       INC CX
       CMP CX,0CH     ;ѭ����������
       JNE LOOPA
    LEA ESI,IN_PWD     ;�û����������ĵ�ַ����Ĵ���ESI
    ADD ESI,2
    LEA EDI,BPASS      ;��ȷ����ĵ�ַ����Ĵ���EDI
    MOV CX,0      ;ѭ���ṹ����ʼ������֤
LOOPB:  MOV AL,DS:[EDI]      ;��ȷ�������ַ�Ϊ��λ����Ĵ���AL
        MOV BL,DS:[ESI]      ;�û�������������ַ�Ϊ��λ����Ĵ���BL
        CMP AL,BL      ;���бȽ�
        JNE WRONG      ;���벻�ԣ���ʾ������Ϣ
        INC EDI
        INC ESI
        INC CX
        CMP CX,06H     ;ѭ����������
        JNE LOOPB
    MOV AL,1      ;���ֺ��������ȷ����1�͵�AUTH�����У��ص����˵�����
    MOV AUTH,AL
    JMP START
F2: LEA DX,GAN1      ;ѡ����2����ʾ������Ʒ����
    MOV AH,9
    INT 21H
    LEA DX,IN_GOOD      ;������Ʒ����
    MOV AH,10
    INT 21H
    LEA ESI,IN_GOOD      ;�û��������Ʒ���Ƶĵ�ַ����Ĵ���ESI
    ADD ESI,2
    LEA EDI,GA1      ;��һ����Ʒ��Ϣ�ĵ�ַ����Ĵ���EDI
    MOV CURR,EDI      ;CURR��ŵ�ǰ�����Ʒ�ĵ�ַ�������¶���
    MOV EDX,0      ;ѭ���ṹ��Ѱ��ƥ�����Ʒ������30����Ʒ
LOOP1: MOV AL,DS:[EDI]      ;��Ʒ��Ϣ���ֽ�Ϊ��λ����Ĵ���AL
       MOV AH,DS:[ESI]      ;�û��������Ʒ�������ֽ�Ϊ��λ����Ĵ���AH
       CMP AL,0     ;����������Ʒ���Ƶ��ַ�����ѭ����������
       JE EXIST
       CMP AL,AH      ;���бȽ�
       JNE TRANS      ;�������Ʒ���ƺ͵�ǰ����Ʒ��ƥ�䣬����һ����Ʒ�����ƱȽ�
       INC EDI
       INC ESI
       JMP LOOP1
EXIST: LEA ESI,IN_GOOD      ;��Ʒ���ڣ�ѭ���ṹ����Ʒ���Ƽ�¼��GOOD�ֶ�
       ADD ESI,2
       LEA EDI,GOOD
LOOP2:  MOV AL,DS:[ESI]
        CMP AL,0DH      ;��Ʒ���Ƽ�¼��ϣ�ѭ������
        JE START
        MOV DS:[EDI],AL
        INC EDI
        INC ESI
        JMP LOOP2
F3: MOV AL,GOOD      ;ѡ����3���жϵ�ǰ�����Ʒ�Ƿ���Ч
    CMP AL,0
    JE WRONG1      ;��ǰ�����Ʒ��Ч�����������Ϣ
    MOV ECX,CURR
    ADD ECX,15
    MOV AX,DS:[ECX]      ;��ǰ�����Ʒ��Ч���ж���ʣ�������Ƿ�Ϊ0
    ADD ECX,2
    MOV BX,DS:[ECX]
    CMP AX,BX
    JE WRONG1      ;ʣ������Ϊ0�����������Ϣ
    INC BX      ;ʣ��������Ϊ0��������������1
    MOV DS:[ECX],BX
    JMP F4      ;���¼���������Ʒ���Ƽ���
F4: MOV ECX,0      ;ѡ����4��ѭ���ṹ����ÿ����Ʒ���Ƽ���
LOOP3: MOV ESI,ECX
       IMUL ESI,21
       LEA EDI,GA1[ESI]      ;EDI���ÿ����Ʒ���׵�ַ
       ADD EDI,10 
       MOV BL,[EDI]      ;BL�����Ʒ�ۿ���
       ADD EDI,1   
       MOV SI,[EDI]      ;SI�����Ʒ������
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
       IMUL EBX,2      ;EBX���2*��������
       ADD EDI,2
       MOV AX,[EDI]      ;AX�����������
       MOVZX EAX,AX
       MOV EDX,0            
       DIV EBX      ;��������/��2*�������������̴���Ĵ���EAX
       ADD EAX,ESI
       MOV BL,128
       MOVZX EBX,BL
       IMUL EAX,EBX
       ADD EDI,2
       MOV [EDI],AX      ;����õ��Ƽ����ͻ�ÿ����Ʒ��Ϣ��ָ��λ��
       INC ECX
       CMP ECX,N      ;30����Ʒ���Ƽ��ȼ�����ϣ��˳�ѭ��
       JNE LOOP3           
    JMP START  
F5: JMP START
F6: JMP START
F7: JMP START
F8: LEA AX,F8      ;ѡ����8��ȡ��ǰλ�ñ�ŵĵ�ַ
    MOV BL,0AH
    MOV ECX,0
LOOP4: DIV BL      ;�ֽڳ���������AL��������AH
       ADD AH,30H
       MOV CADR[ECX],AH
       CMP AL,0      ;��Ϊ0������ѭ��
       JE FIM
       MOVZX AX,AL
       INC ECX
       JMP LOOP4
FIM: LEA DX,CRLF      ;������з�
     MOV AH,9
     INT 21H
FIN: MOV DL,CADR[ECX]      ;�����ǰλ�ñ�ŵĵ�ַ
     MOV AH,2
     INT 21H
     CMP ECX,0
     JE START
     DEC ECX
     JMP FIN
F9: MOV AH,4CH      ;ѡ����9���˳�ϵͳ
    INT 21H
WRONG: LEA DX,ERR1      ;��¼ʧ�ܣ����������Ϣ
       MOV AH,9
       INT 21H
       JMP F1
WRONG1: LEA DX,ERR3      ;����ʧ�ܣ����������Ϣ
        MOV AH,9
        INT 21H
        JMP START
TRANS: INC EDX      ;�ҵ���һ����Ʒ
       CMP EDX,N      ;�ж��Ƿ��Ѿ����������һ����Ʒ��û�ҵ�
       JE NOEXIST
       MOV ECX,EDX
       IMUL ECX,21
       LEA EDI,GA1[ECX]      ;��һ����Ʒ��Ϣ�ĵ�ַ����Ĵ���EDI
       MOV CURR,EDI      ;CURR��ŵ�ǰ�����Ʒ�ĵ�ַ�������¶���
       LEA ESI,IN_GOOD      ;��ΪESI�����Ѿ��ı䣬���Խ��û��������Ʒ���Ƶĵ�ַ��������Ĵ���ESI
       ADD ESI,2
       JMP LOOP1
NOEXIST: LEA DX,ERR2      ;��Ʒ�����ڣ������ʾ��Ϣ
         MOV AH,9
         INT 21H
         JMP START
CODE ENDS
     END START
