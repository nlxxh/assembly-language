.386
STACK SEGMENT USE16 STACK
DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
BNAME DB 'RONG YUETONG',0      ;老板姓名  
BPASS DB 'TEST00',0      ;密码   
AUTH DB 0      ;当前登录状态，0表示顾客状态    
GOOD DB 10 DUP(0)      ;当前浏览商品名称     
N EQU 3000
M DD 8000
SNAME DB 'SHOP',0      ;网店名称，用0结束               
GA1 DB 'PEN', 7 DUP(0),10      ;商品名称及折扣    
       DW 35,56,18000,2500,?      ;推荐度还未计算      
GA2 DB 'BOOK',6 DUP(0),9      ;商品名称及折扣       
        DW 12,30,16000,500,?      ;推荐度还未计算     
        DB N-3 DUP( 'TempValue',0,8,15,0,20,0,30,0,2,0,0,0)      ;除了2个已经具体定义了的商品信息以外，其他商品信息暂时假定为一样的
GAN DB 'BAG',7 DUP(0),9
         DW 12,30,16000,500,?
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
'$'      ;显示界面信息
ERR DB 0AH,0DH,0AH,0DH,'Input Error!Try Again!','$'      ;输入错误时，显示错误信息
ERR1 DB 0AH,0DH,0AH,0DH,'Log in Failed!Try Again!','$'      ;登陆失败时，显示错误信息
ERR2 DB 0AH,0DH,0AH,0DH,'Good Not Found','$'      ;显示商品不存在
ERR3 DB 0AH,0DH,0AH,0DH,'Error','$'      ;显示错误
BNAME1 DB 0AH,0DH,'Input Name:(Max 12 Characters)','$'      ;提示输入姓名
BPASS1 DB 0AH,0DH,'Input Password:(Max 6 characters)','$'      ;提示输入密码
GAN1 DB 0AH,0DH,'Input Good Name:(Max 9 characters)','$'      ;提示输入商品名称
CURR DD 0      ;存储当前浏览商品的地址
CADR DB 10 DUP(0)      ;存储CS里面的内容
CRLF DB 0AH,0DH,'$'      ;输出换行
IN_NAME DB 13      ;存储输入的姓名
                DB 0
                DB 13 DUP(0) 
IN_PWD DB 7     ;存储输入的密码
              DB 0
              DB 7 DUP(0)
IN_GOOD DB 10      ;存储输入的商品名称
                DB 0
                DB 10 DUP(0) 
SIG DB 0      ;标志执行功能4，是否是通过功能3
DATA ENDS
CODE SEGMENT USE16
          ASSUME CS:CODE,DS:DATA,SS:STACK
START:MOV AX,DATA
           MOV DS,AX
           LEA DX,BUF      ;输出界面信息
           MOV AH,9
           INT 21H
           MOV AH,1      ;用户输入
           INT 21H
           CMP AL,'1'
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
LERR: LEA DX,ERR      ;输出错误信息
         MOV AH,9
         INT 21H
         JMP START      ;重新显示主菜单界面
F1: LEA DX,BNAME1      ;选择功能1，提示输入姓名
      MOV AH,9
      INT 21H
      LEA DX,IN_NAME      ;输入姓名
      MOV AH,10
      INT 21H
      CMP IN_NAME+1,0
      JE START
      LEA DX,BPASS1      ;提示输入密码
      MOV AH,9
      INT 21H
      LEA DX,IN_PWD      ;输入密码
      MOV AH,10
      INT 21H
      LEA ESI,IN_NAME      ;用户输入的名字的地址送入寄存器ESI
      ADD ESI,2
      LEA EDI,BNAME      ;老板的名字的地址送入寄存器EDI
      MOV CX,0      ;循环结构，开始姓名认证
LOOPA: MOV AL,DS:[EDI]      ;老板的名字以字符为单位送入寄存器AL
             MOV BL,DS:[ESI]      ;用户输入的名字以字符为单位送入寄存器BL
             CMP AL,BL      ;进行比较
             JNE WRONG      ;名字不对，显示错误信息
             INC EDI
             INC ESI
             INC CX
             CMP CX,0CH     ;循环结束条件
             JNE LOOPA
      LEA ESI,IN_PWD     ;用户输入的密码的地址送入寄存器ESI
      ADD ESI,2
      LEA EDI,BPASS      ;正确密码的地址送入寄存器EDI
      MOV CX,0      ;循环结构，开始密码认证      
LOOPB:  MOV AL,DS:[EDI]      ;正确密码以字符为单位送入寄存器AL
             MOV BL,DS:[ESI]      ;用户输入的密码以字符为单位送入寄存器BL
             CMP AL,BL      ;进行比较
             JNE WRONG      ;密码不对，显示错误信息
             INC EDI
             INC ESI
             INC CX
             CMP CX,06H     ;循环结束条件
             JNE LOOPB
      MOV AL,1      ;名字和密码均正确，将1送到AUTH变量中，回到主菜单界面
      MOV AUTH,AL      
      JMP START
F2: LEA DX,GAN1      ;选择功能2，提示输入商品名称
      MOV AH,9
      INT 21H
      LEA DX,IN_GOOD      ;输入商品名称
      MOV AH,10
      INT 21H
      MOV BL,IN_GOOD+1
      MOV BH,0
      MOV BYTE PTR IN_GOOD+2[BX],0
      LEA ESI,IN_GOOD      ;用户输入的商品名称的地址送入寄存器ESI
      ADD ESI,2 
      LEA EDI,GA1      ;第一个商品信息的地址送入寄存器EDI
      MOV CURR,EDI      ;CURR存放当前浏览商品的地址，用于下订单
      MOV EDX,0      ;循环结构，寻找匹配的商品，遍历N个商品   
      MOV ECX,0
      MOV  AX, 0
      CALL TIMER      ;表示开始计时  
LOOP1: MOV EAX,DS:[EDI]      ;商品信息送入寄存器EAX
             MOV EBX,DS:[ESI]      ;用户输入的商品名称送入寄存器EBX
             CMP AH,0     ;遍历单个商品名称的字符串的循环结束条件
             JE EXIST
             CMP EAX,EBX      ;进行比较
             JNE TRANS      ;输入的商品名称和当前的商品不匹配，和下一个商品的名称比较
             ADD EDI,4
             ADD ESI,4
             JMP LOOP1
TRANS: INC EDX      ;找到下一个商品
             CMP EDX,N      ;判断是否已经遍历到最后一个商品还没找到
             JE NOEXIST
             ADD ECX,21
             LEA EDI,GA1[ECX]      ;下一个商品信息的地址送入寄存器EDI
             MOV CURR,EDI      ;CURR存放当前浏览商品的地址，用于下订单
             LEA ESI,IN_GOOD      ;因为ESI可能已经改变，所以将用户输入的商品名称的地址重新送入寄存器ESI
             ADD ESI,2                      
             JMP LOOP1
EXIST: LEA ESI,IN_GOOD      ;商品存在，循环结构将商品名称记录到GOOD字段
            ADD ESI,2    
            LEA EDI,GOOD
LOOP2: MOV AL,DS:[ESI]
              CMP AL,0     ;商品名称记录完毕，循环结束
              JE START
              MOV DS:[EDI],AL
              INC EDI
              INC ESI
              JMP LOOP2
F3: PUSH M
FF: MOV DH,0
      MOV SIG,DH      ;标志置为0
      MOV AL,GOOD      ;选择功能3，判断当前浏览商品是否有效
      CMP AL,0
      JE WRONG1      ;当前浏览商品无效，输出错误信息
      MOV ECX,CURR
      ADD ECX,15
      MOV AX,DS:[ECX]      ;当前浏览商品有效，判断其剩余数量是否为0
      ADD ECX,2
      MOV BX,DS:[ECX]
      CMP AX,BX
      JE WRONG1      ;剩余数量为0，输出错误信息
      INC BX      ;剩余数量不为0，将已售数量加1
      MOV DS:[ECX],BX 
      MOV DH,1
      MOV SIG,DH      ;标志置为1
      JMP F4      ;重新计算所有商品的推荐度     
FI: LEA DX,CRLF      ;输出换行符
     MOV AH,9
     INT 21H
     MOV  AX, 1
     CALL TIMER      ;终止计时并显示计时结果(ms)
     MOV DH,0 
     MOV SIG,DH      ;标志置为0	 
     JMP START
F4: MOV ECX,0      ;选择功能4，循环结构计算每个商品的推荐度
      MOV EDI,0
      LEA EDI,GA1[EDI]      ;EDI存放第一个商品的首地址
LOOP3: ADD EDI,10 
              MOV BL,[EDI]      ;BL存放商品折扣率
              ADD EDI,1   
              MOV SI,[EDI]      ;SI存放商品进货价
              ADD EDI,2
              MOV AX,[EDI]      ;AX存放商品销售价
              MOVZX EAX,AX
              IMUL EAX,BL
              MOV EDX,0
              MOV EBX,0AH
              DIV EBX
              MOV EBX,EAX      ;EBX存放实际销售价格
              MOVZX EAX,SI
              MOV EDX,0
              DIV EBX
              MOV ESI,EAX      ;ESI存放进货价/实际销售价的商
              ADD EDI,2
              MOV BX,[EDI]      ;BX存放进货总数
              MOVZX EBX,BX
              SAL EBX,1      ;EBX存放2*进货总数
              ADD EDI,2
              MOV AX,[EDI]      ;AX存放已售数量
              MOVZX EAX,AX
              MOV EDX,0            
              DIV EBX      ;已售数量/（2*进货数量）的商存入寄存器EAX
              ADD EAX,ESI
              SAL EAX,7
              ADD EDI,2
              MOV [EDI],AX      ;计算好的推荐度送回每个商品信息的指定位置
              INC ECX
              ADD EDI,2      ;此时EDI存放下一个商品的首地址
              CMP ECX,N      ;N个商品的推荐度计算完毕，退出循环
              JNE LOOP3  
     CMP SIG,0
     JE START      ;代表由主菜单调用的功能4，则直接返回主菜单
     POP EAX
     DEC EAX
     CMP EAX,0
     JE FI
     PUSH EAX                           
     JMP FF
F5: JMP START
F6: JMP START 
F7: JMP START 
F8: LEA AX,F8      ;选择功能8，取当前位置标号的地址
      MOV BL,0AH      
      MOV ECX,0
LOOP4: DIV BL      ;字节除法，商在AL，余数在AH
            ADD AH,30H
            MOV CADR[ECX],AH       
            CMP AL,0      ;商为0，结束循环
            JE FIM
            MOVZX AX,AL
            INC ECX
            JMP LOOP4 
FIM: LEA DX,CRLF      ;输出换行符
       MOV AH,9
       INT 21H
FIN: MOV DL,CADR[ECX]      ;输出当前位置标号的地址
       MOV AH,2
       INT 21H
       CMP ECX,0
       JE START
       DEC ECX   
       JMP FIN        
F9: MOV AH,4CH      ;选择功能9，退出系统
     INT 21H
WRONG: LEA DX,ERR1      ;登录失败，输出错误信息
              MOV AH,9
              INT 21H
              JMP F1
WRONG1: LEA DX,ERR3      ;操作失败，输出错误信息
                MOV AH,9
                INT 21H
                JMP START
NOEXIST: LEA DX,ERR2      ;商品不存在，输出提示信息
               MOV AH,9
               INT 21H
               JMP START
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
CODE ENDS
          END START           
