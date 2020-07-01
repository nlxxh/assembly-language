.386
STACK SEGMENT USE16 STACK
DB 100 DUP(0)
STACK ENDS

STACKBAK SEGMENT USE16 
DB 100 DUP(0)
STACKBAK ENDS

DATA SEGMENT USE16 
BNAME DB 'RONG YUETONG',0      ;老板姓名  
BPASS DB 6 XOR 'C'      ;密码串的长度为6，编译成密文
            DB ('T'-10H)*2  
            DB ('E'-10H)*2 
            DB ('S'-10H)*2 
            DB ('T'-10H)*2
            DB ('0'-10H)*2
            DB ('0'-10H)*2 
            DB 0      ;密码   
AUTH DB 0      ;当前登录状态，0表示顾客状态    
GOOD DB 10 DUP(0)      ;当前浏览商品名称     
N EQU 3
M DD 10
MM DD 10
FLA DW 0      ;判断是否安装了中断处理程序
SNAME DB 'SHOP',0      ;网店名称，用0结束               
GA1 DB 'PEN', 7 DUP(0),10      ;商品名称及折扣    
       DW 35 XOR 'T'
       DW 56,20,5,?      ;推荐度还未计算      
GA2 DB 'BOOK',6 DUP(0),9      ;商品名称及折扣       
        DW 12 XOR 'E'
        DW 30,30,5,?      ;推荐度还未计算     
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
'$'      ;显示界面信息
ERR DB 0AH,0DH,0AH,0DH,'Input Error!Try Again!','$'      ;输入错误时，显示错误信息
ERR1 DB 0AH,0DH,0AH,0DH,'Log in Failed!Try Again!','$'      ;登陆失败时，显示错误信息
ERR2 DB 0AH,0DH,0AH,0DH,'Good Not Found','$'      ;显示商品不存在
ERR3 DB 0AH,0DH,0AH,0DH,'Error','$'      ;显示错误
BNAME1 DB 0AH,0DH,'Input Name:(Max 12 Characters)','$'      ;提示输入姓名
BPASS1 DB 0AH,0DH,'Input Password:(Max 6 characters)','$'      ;提示输入密码
GAN1 DB 0AH,0DH,'Input Good Name:(Max 9 characters)','$'      ;提示输入商品名称
NEWD DB 0AH,0DH,'Input New Discount:','$'      ;提示输入新的折扣率
NEWPC DB 0AH,0DH,'Input New Prime Cost:','$'      ;提示输入新的进货价
NEWSC  DB 0AH,0DH,'Input New Sale Cost:','$'      ;提示输入新的销售价
NEWPN  DB 0AH,0DH,'Input New Prime Number:','$'      ;提示输入新的进货总数
SYM DB '<<$'      ;输出符号
CURR DD 0      ;存储当前浏览商品的地址
CADR DB 10 DUP(0)      ;存储CS里面的内容
SY DB 0       ;确定输出字节还是字
NAL DD 0
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
IN_NEWG DB 20      ;存储输入的新数据
                  DB 0
                  DB 20 DUP(0)  
SIG DB 0      ;标志执行功能4，是否是通过功能3
TEMP DB 10 DUP('0')      ;功能2输出信息使用
TABLE DW F1,F2,F3,F4,F5,F6,F7,F8,F9      ;建立地址表，用于间接转移反跟踪
P1 DW PASS1      ;建立地址表      
E1 DW OVER      ;建立地址表
DATA ENDS

CODE SEGMENT USE16 
           ASSUME DS:DATA,CS:CODE,SS:STACK
      SSEG DW ?,?      ;用于保存2个堆栈段的段地址
      SECSET DB 0      ;设定秒
      OLD_INT DW ?,?      ;原INT 08H的中断矢量
      FLAG DB 0       ;0=STACK, 1=STACKBAK
OP MACRO A      ;输出信息的宏
      LEA DX,A
      MOV AH,9
      INT 21H
      ENDM
OP1 MACRO A      ;输出一个字符的宏
        MOV DL,A
        MOV AH,2
        INT 21H
        ENDM
IP   MACRO A      ;输入信息的宏
      LEA DX,A
      MOV AH,10
      INT 21H
      ENDM 
START:MOV AX,DATA       
            MOV DS,AX    
           OP BUF      ;输出界面信息
           MOV AH,1      ;用户输入
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
K:   OP BNAME1      ;选择功能1，提示输入姓名
      IP IN_NAME      ;输入姓名
      OP BPASS1      ;提示输入密码
      IP IN_PWD      ;输入密码
      .IF IN_NAME+1==0
           POP CX      ;清空栈
           JMP START
      .ENDIF
      LEA ESI,IN_NAME      ;用户输入的名字的地址送入寄存器ESI
      ADD ESI,2
      LEA EDI,BNAME      ;老板的名字的地址送入寄存器EDI
      MOV CX,0      ;循环结构，开始姓名认证
LOOPA: MOV AL,DS:[EDI]      ;老板的名字以字符为单位送入寄存器AL
             MOV BL,DS:[ESI]      ;用户输入的名字以字符为单位送入寄存器BL
             .IF AL != BL      ;进行比较 
                 OP ERR1     ;登录失败，输出错误信息 
                 JMP K
             .ENDIF
             INC EDI
             INC ESI
             INC CX
             CMP CX,0CH     ;循环结束条件
             JNE LOOPA
      
      CLI      ;计时反跟踪开始 
      MOV  AH,2CH 
      INT  21H
      PUSH DX   

      MOV CL,IN_PWD+1      ;比较输入的串长与密码长度是否一样
      XOR CL,'C'
      SUB CL,BPASS
      MOVSX  BX,CL
      ADD BX,OFFSET P1    

      MOV AH,2CH       ;获取第二次秒与百分秒
      INT 21H
      STI
      CMP  DX,[ESP]       ;计时是否相同
      POP DX
      JZ OK1        ;如果计时相同，通过本次计时反跟踪   
      JMP E1      ;如果计时不同，退出系统

OK1: MOV  BX,[BX]
         CMP BX,0147H      ;是否是PASS1处的指令，其实是用于判断前面比较的串长是否相同
         JZ OK2
         MOV BX,K
         JMP BX

OK2: JMP   BX
         DB  'HOW TO GO'      ;定义的冗余信息，扰乱视线

PASS1: LEA ESI,IN_PWD     ;用户输入的密码的地址送入寄存器ESI
            ADD ESI,2
            LEA EDI,BPASS      ;正确密码的地址送入寄存器EDI
            INC EDI
            MOV CX,0      ;循环结构，开始密码认证      
LOOPB: MOV AL,DS:[EDI]      ;正确密码以字符为单位送入寄存器AL
             MOV BL,DS:[ESI]      ;用户输入的密码以字符为单位送入寄存器BL
             SUB BL,10H
             SAL BL,1
             .IF AL != BL      ;进行比较
                 OP ERR1      ;登录失败，输出错误信息
                 MOV BX,K
                 JMP BX
             .ENDIF
             INC EDI
             INC ESI
             INC CX
             CMP CX,06H     ;循环结束条件
             JNE LOOPB
      MOV AL,1      ;名字和密码均正确，将1送到AUTH变量中，回到主菜单界面
      MOV AUTH,AL      
      RET
F1 ENDP
OVER: MOV AH,4CH
            INT 21H
F2  PROC
      OP GAN1      ;选择功能2，提示输入商品名称
      IP IN_GOOD      ;输入商品名称
      MOV BL,IN_GOOD+1
      MOV BH,0
      MOV BYTE PTR IN_GOOD+2[BX],0
      LEA ESI,IN_GOOD      ;用户输入的商品名称的地址送入寄存器ESI
      ADD ESI,2 
      LEA EDI,GA1      ;第一个商品信息的地址送入寄存器EDI
      MOV CURR,EDI      ;CURR存放当前浏览商品的地址，用于下订单
      MOV EDX,0      ;循环结构，寻找匹配的商品，遍历N个商品   
      MOV ECX,0
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
             .IF EDX == N      ;判断是否已经遍历到最后一个商品还没找到
                  OP ERR2
                  RET   
             .ENDIF
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
              .IF AL == 0     ;商品名称记录完毕，循环结束
                   CALL DIS      ;调用显示商品信息的子程序
                   RET
              .ENDIF
              MOV DS:[EDI],AL
              INC EDI
              INC ESI
              JMP LOOP2
F2 ENDP
DIS PROC      ;显示商品信息
       MOV ECX,CURR      ;ECX为当前浏览商品的首地址
       OP CRLF
LOOP5: OP1 [ECX]      ;输出当前浏览商品的名称
              INC ECX
              MOV DL,[ECX]
              CMP DL,0
              JNE LOOP5
        MOV ECX,CURR
        ADD ECX,0AH
        MOV BL,1      ;SY置为1
        MOV SY,BL   
        CALL F16T10      ;输出当前浏览商品的折扣率   
        ADD ECX,3
        MOV BL,0      ;SY置为0
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
F16T10 PROC      	;十六进制字(字节)转十进制串输出
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
F16T10 ENDP      
F3  PROC
      MOV EAX,MM
      MOV M,EAX 
      ;MOV  AX, 0
      ;CALL TIMER      ;表示开始计时  
      MOV AL,GOOD      ;选择功能3，判断当前浏览商品是否有效
      .IF AL == 0
           OP ERR3      ;当前浏览商品无效，输出错误信息
           POP CX
           JMP START
      .ENDIF
Q:  MOV ECX,CURR
      ADD ECX,15
      MOV AX,DS:[ECX]      ;当前浏览商品有效，判断其剩余数量是否为0
      ADD ECX,2
      MOV BX,DS:[ECX]
      .IF AX <= BX
           OP ERR3      ;商品剩余数量为0，输出错误信息
           MOV DH,0
           MOV SIG,DH      ;标志置为0
           JMP START      
      .ENDIF
      INC BX      ;剩余数量不为0，将已售数量加1
      MOV DS:[ECX],BX 
      MOV DH,1
      MOV SIG,DH      ;标志置为1
      MOV BX,TABLE+6
      CALL BX      ;重新计算所有商品的推荐度     
      OP CRLF      ;输出换行符
      MOV  AX, 1
      ;CALL TIMER      ;终止计时并显示计时结果(ms)
      MOV DH,0 
      MOV SIG,DH      ;标志置为0	 
      JMP START
F3 ENDP
F4  PROC
      MOV NAL,0
      MOV ECX,0      ;选择功能4，循环结构计算每个商品的推荐度
      MOV EDI,0
      LEA EDI,GA1[EDI]      ;EDI存放第一个商品的首地址
LOOP3: ADD EDI,10 
              MOV BL,[EDI]      ;BL存放商品折扣率
              ADD EDI,1   
              MOV SI,[EDI]      ;SI存放商品进货价
              MOV EAX,NAL  
              MOVZX DX,IN_PWD+2[EAX] 
              XOR SI,DX      ;商品进货价解密
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
              MOV EAX,NAL
              INC EAX
              MOV NAL,EAX      ;给下一个商品进货价解密做准备
              CMP ECX,N      ;N个商品的推荐度计算完毕，退出循环
              JNE LOOP3  
     .IF SIG==0
           RET     ;代表由主菜单调用的功能4，则直接返回主菜单 
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
     CMP AL,1      ;非老板登陆，返回主菜单
     JNE START
     MOV AL,GOOD      ; 当前浏览商品无效，返回主菜单
     CMP AL,0
     JE START
     MOV ECX,CURR
     ADD ECX,0AH
     MOV BL,1      ;SY置为1
     MOV SY,BL 
     CALL F16T10       ;输出当前浏览商品的折扣率
     ADD ECX,1
     MOV BL,0      ;SY置为0
     MOV SY,BL 
     CALL F16T10     
     MOV EDI,0
LOOP9:ADD ECX,2
             CALL F16T10        
             INC EDI
             CMP EDI,2
             JNE LOOP9      ;输出原来的信息
     MOV ECX,CURR      ;开始修改信息
     MOV BX,0      ;BX标志提示输入的信息
     ADD ECX,0AH
     MOV BL,1      ;SY置为1
     MOV SY,BL 
     MOV BX,1     
     CALL M1      ;调用M1 
     ADD ECX,1
     MOV BL,0      ;SY置为0
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
            OP NEWD      ;输出提示输入新的折扣率
       .ELSEIF BX==2
                     OP NEWPC      ;输出提示输入新的进货价
       .ELSEIF BX==3
                     OP NEWSC      ;输出提示输入新的销售价 
       .ELSEIF BX==4
                     OP NEWPN      ;输出提示输入新的进货总数
       .ENDIF
      CALL F16T10
      OP SYM
      IP IN_NEWG
      LEA SI,IN_NEWG
      ADD SI,2      ;SI指向字节存储区的首址
      MOV AL,IN_NEWG+1
      MOVZX DI,AL      ;DI存放待转换十进制数字的长度
      .IF DI==0
            RET
      .ENDIF
      CALL F10T2      ;十进制数字串转换成二进制数送入AX中
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
     MOV FLA,AX      ;已安装中断处理程序
     MOV AX,STACK      ;保存两个堆栈段的段地址
     MOV CS:SSEG,AX
     MOV AX,STACKBAK
     MOV CS:SSEG+2,AX
     MOV AX,3508H      ;获取原08H的中断矢量
     INT 21H
     MOV CS:OLD_INT,BX      ;保存原来的中断矢量
     MOV CS:OLD_INT+2,ES
     PUSH CS
     POP DS
     MOV DX,OFFSET NEW08H
     MOV AX,2508H      ;设置新的08H中断矢量
     INT 21H
     MOV DX, CS:OLD_INT
     MOV DS, CS:OLD_INT+2
     MOV AX, 2508H
     INT 21H
     RET
F7 ENDP
NEW08H	PROC FAR
	PUSHF      ;执行原08H的中断矢量会返回EFLAGS 
	CALL DWORD PTR CS:OLD_INT
	PUSH AX      ;保护现场
	MOV AL, 0      ;获取秒
	OUT 70H, AL
	JMP $+2      ;保证端口操作的可靠性
	IN AL, 71H   
	CMP AL, CS:SECSET
	JZ L1
L0:	POP AX
	IRET
L1:	PUSH DS      ;保护现场
	PUSH ES
	PUSH BX
	CMP FLAG, 0
	JNZ L2
	MOV FLAG, 1      ;STACK转到STACKBAK
	MOV DS, SSEG
	MOV ES, SSEG+2
	JMP	L3
L2:	MOV	FLAG, 0       ;STACKBAK转到STACK
	MOV	DS, SSEG+2
	MOV	ES, SSEG
L3:	MOV	BX, 0
L4:	MOV	AL, DS:[BX]      ;把DS段的内容复制给ES段
	MOV	ES:[BX], AL
	INC	BX
	CMP	BX, 100
	JB	L4
	MOV	AX, ES
	MOV	SS, AX      ;更新堆栈段SS
	POP	BX
	POP	ES
	POP	DS
	JMP	L0      ;返回
NEW08H	ENDP
F8 PROC      ;显示当前堆栈段的内容
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
LOOP4: DIV BL      ;字节除法，商在AL，余数在AH
            .IF AH>=10
                 ADD AH,7
            .ENDIF
            ADD AH,30H
            MOV CADR[ECX],AH       
            CMP AL,0      ;商为0，结束循环
            JE FIM
            MOVZX AX,AL
            INC ECX
            JMP LOOP4 
FIM: OP1 ' '      ;输出换行符
FIN: MOV DL,CADR[ECX]      ;输出当前SS段的内容
       MOV AH,2
       INT 21H
       .IF ECX==0
            RET
       .ENDIF
       DEC ECX   
       JMP FIN   
F12 ENDP
F9 PROC
     .IF FLA==1      ;恢复中断矢量表
           MOV DX, CS:OLD_INT
           MOV DS, CS:OLD_INT+2
           MOV AX, 2508H
           INT 21H
     .ENDIF
     MOV AH,4CH      ;选择功能9，退出系统
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
	PUSH BX      ;保护现场
                PUSH ECX      ;保护现场
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
OVE:	POP ECX      ;保护现场
                POP BX	    ;保护现场
	RET
ER:	MOV SI,-1
	JMP OVE
F10T2 ENDP
CODE ENDS
          END START           
