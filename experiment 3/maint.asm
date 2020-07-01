NAME RONG YUETONG
;本模块不包含子程序
;本模块功能是测试功能的主程序

INCLUDE  MYLIB.LIB
EXTRN    SIX:FAR,TWO:FAR
PUBLIC   GOOD,N,GA1,GA2,GAN,CRLF,SY
.386

STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS 

DATA SEGMENT USE16 PARA PUBLIC 'DATA'
CRLF DB 0AH,0DH,'$'      ;输出换行
SY DB 0       ;确定输出字节还是字
GOOD DB 10 DUP(0)      ;当前浏览商品名称    
N EQU 30	
GA1 DB 'PEN', 7 DUP(0),10      ;商品名称及折扣    
       DW 35,56,20,5,?      ;推荐度还未计算      
GA2 DB 'BOOK',6 DUP(0),9      ;商品名称及折扣       
        DW 12,30,30,5,?      ;推荐度还未计算     
        DB N-3 DUP( 'TempValue',0,8,15,0,20,0,30,0,2,0,0,0)      ;除了2个已经具体定义了的商品信息以外，其他商品信息暂时假定为一样的
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
'$'      ;显示界面信息
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
          ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
START:MOV AX,DATA
           MOV DS,AX
           OP BUF      ;输出界面信息
           MOV AH,1      ;用户输入
           INT 21H
        .IF AL == '2'
               CALL TWO
               JMP START
           .ELSEIF AL == '6'
                        CALL SIX
                       JMP START
            .ELSEIF AL == '9'
                        MOV AH,4CH      ;选择功能9，退出系统
                        INT 21H
                        JMP START        
            .ELSE
                      JMP START
            .ENDIF
CODE ENDS
          END START           


