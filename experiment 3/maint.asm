NAME RONG YUETONG
;��ģ�鲻�����ӳ���
;��ģ�鹦���ǲ��Թ��ܵ�������

INCLUDE  MYLIB.LIB
EXTRN    SIX:FAR,TWO:FAR
PUBLIC   GOOD,N,GA1,GA2,GAN,CRLF,SY
.386

STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS 

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
CRLF DB 0AH,0DH,'$'      ;�������
SY DB 0       ;ȷ������ֽڻ�����
GOOD DB 10 DUP(0)      ;��ǰ�����Ʒ����    
N EQU 30	
GA1 DB 'PEN', 7 DUP(0),10      ;��Ʒ���Ƽ��ۿ�    
       DW 35,56,20,5,?      ;�Ƽ��Ȼ�δ����      
GA2 DB 'BOOK',6 DUP(0),9      ;��Ʒ���Ƽ��ۿ�       
        DW 12,30,30,5,?      ;�Ƽ��Ȼ�δ����     
        DB N-3 DUP( 'TempValue',0,8,15,0,20,0,30,0,2,0,0,0)      ;����2���Ѿ����嶨���˵���Ʒ��Ϣ���⣬������Ʒ��Ϣ��ʱ�ٶ�Ϊһ����
GAN DB 'BAG',7 DUP(0),9
         DW 12,30,16,5,? 
BUF DB 0AH,0DH,'User Name:(Boss or Customer)',
0AH,0DH,'Current Good Name:(Blank is Allowed)',
0AH,0DH,'Please Input Number 1-9:',
0AH,0DH,'2.Seek a Specific Good and Show Information',
0AH,0DH,'6.Correct Information',
0AH,0DH,'......',
0AH,0DH,'9.Exit',
0AH,0DH,'Testing Function(Only 2, 6, 9 Allowed)',
0DH,0AH,
'$'      ;��ʾ������Ϣ
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
          ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
START:MOV AX,DATA
           MOV DS,AX
           OP BUF      ;���������Ϣ
           MOV AH,1      ;�û�����
           INT 21H
        .IF AL == '2'
               CALL TWO
               JMP START
           .ELSEIF AL == '6'
                        CALL SIX
                       JMP START
            .ELSEIF AL == '9'
                        MOV AH,4CH      ;ѡ����9���˳�ϵͳ
                        INT 21H
                        JMP START        
            .ELSE
                      JMP START
            .ENDIF
CODE ENDS
          END START           


