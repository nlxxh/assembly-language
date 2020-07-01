NAME RONG YUETONG
;本模块包含的子程序有TWO,DIS,F2T10
;本模块的功能是测试功能2

INCLUDE  MYLIB.LIB
EXTRN    GOOD:BYTE,N:ABS,GA1:BYTE,GA2:BYTE,
GAN:BYTE,CRLF:BYTE,SY:BYTE,F2T10:FAR
PUBLIC   TWO,CURR
.386
STACK SEGMENT USE16 STACK
DB 2000 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
GAN1 DB 0AH,0DH,'Input Good Name:(Max 9 characters)','$'      ;提示输入商品名称
IN_GOOD DB 10      ;存储输入的商品名称
                  DB 0
                  DB 10 DUP(0) 
CURR DD 0      ;存储当前浏览商品的地址
ERR2 DB 0AH,0DH,0AH,0DH,'Good Not Found','$'      ;显示商品不存在
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME DS:DATA,ES:DATA,CS:CODE,SS:STACK
TWO  PROC  FAR
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
TWO ENDP
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
        CALL F2T10      ;输出当前浏览商品的折扣率   
        ADD ECX,3
        MOV BL,0      ;SY置为0
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