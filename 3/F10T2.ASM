
INCLUDE MYLIB.LIB

PUBLIC   F10T2

;子程序名字:F10T2
;功能:将以si为指针的字节存储区中的
;无符号十进制数字串转换成二进制数送入AX中
;入口参数:SI :指向字节存储区的首址
;          DI  :存放待转换十进制数字的长度
;出口参数:	SI:为-1的时候表示输入有错误
;	    AX:存放转换以后的子数据
;所用寄存器:BX,ECX:保护现场
	
.386
DATA SEGMENT USE16 PARA PUBLIC 'DATA'
DATA ENDS
CODE SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME CS:CODE,DS:DATA
F10T2 PROC FAR
	PUSH BX      ;保护现场
                PUSH ECX      ;保护现场
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
OVE:	POP ECX      ;保护现场
                POP BX	    ;保护现场
	RET
ERR1:	MOV SI,-1
	JMP OVE
F10T2 ENDP
CODE ENDS
	END