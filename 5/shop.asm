.386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD


include      menuID.INC

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

good	     struct
	     goodname   db  10 dup(0)
	     discount  db  0
	     primecost  db  0
	     salecost  db  0
	     primenumber  db  0
	     salenumber  db  0
                     recommendation  db  4 dup(0)  
good      ends

good2	     struct
	     goodname   db  10 dup(0)
	     discount  db   2 dup(0)
	     primecost  db  2 dup(0)
	     salecost  db  2 dup(0)
	     primenumber  db  2 dup(0)
	     salenumber  db  2 dup(0)
                     recommendation  db  4 dup(0)  
good2      ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'I am CSIE1801 Rong YueTong',0
hInstance    dd       0
CommandLine  dd       0
buf	     good  <'  PEN',4,5,8,50,40,'0000'>
	     good  <' BOOK',10,35,56,20,10,'0000'>
	     good  <'  BAG',5,30,30,20,10,'0000'>
	     good  <' NOTE',1,30,50,30,10,'0000'>
	     good  <'APPLE',2,20,30,20,15,'0000'>
buf1	     good2  <,,,,,,'0000'>
	     good2  <,,,,,,'0000'>
	     good2  <,,,,,,'0000'>
	     good2  <,,,,,,'0000'>
	     good2  <,,,,,,'0000'>
buf2	     good2  <'  PEN','04','05','08','50','40','0000'>
	     good2  <' BOOK','10','35','56','20','10','0000'>
	     good2  <'  BAG','05','30','30','20','10','0000'>
	     good2  <' NOTE','01','30','50','30','10','0000'>
	     good2  <'APPLE','02','20','30','20','15','0000'>
msg_goodname    db       'goodname',0
msg_discount    db       'discount',0
msg_primecost     db       'prime cost',0
msg_salecost    db       'sale cost',0
msg_primenumber    db       'prime number',0
msg_salenumber      db       'sale number',0
msg_recommendation    db       'recommendation',0   
TEMP db 4 dup('0')
RECO   dd  5 dup(0)
KEY   db   5 dup(0)
menuItem     db       0  ;当前菜单状态


.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain       PROC   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
                              invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                                   WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                                   CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                                   hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
                     cmp    EAX,0
                     je     ExitLoop
                     INVOKE TranslateMessage,addr msg
                     INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:      mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
                     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF      
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_ACTION_RECOMMENDATION
		    CALL Recommend
                                    mov menuItem, 1
	                    invoke InvalidateRect,hWnd,0,1     ;擦除整个客户区
		    invoke UpdateWindow, hWnd	      
	    .ELSEIF wParam == IDM_ACTION_LISTSORT
		    .IF menuItem == 1 
                                          CALL SORT
		    .ENDIF
                                    mov menuItem, 1
	                    invoke InvalidateRect,hWnd,0,1     ;擦除整个客户区
		    invoke UpdateWindow, hWnd	 
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1 
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps      
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp


Display      proc    hdc:HDC
             XX     equ  10
             YY     equ  10
             XX_GAP   equ   100
             YY_GAP   equ   30
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_goodname,8
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_discount,8
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_primecost,10
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_salecost,9
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_primenumber,12
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_salenumber,11
             invoke TextOut,hdc,XX+6*XX_GAP,YY+0*YY_GAP,offset msg_recommendation,14
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].goodname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].discount,2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].primecost,2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].salecost,2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].primenumber,2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].salenumber,2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+1*YY_GAP,offset buf2[0*24].recommendation,4
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].goodname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].discount,2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].primecost,2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].salecost,2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].primenumber,2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].salenumber,2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+2*YY_GAP,offset buf2[1*24].recommendation,4
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].goodname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].discount,2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].primecost,2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].salecost,2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].primenumber,2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].salenumber,2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+3*YY_GAP,offset buf2[2*24].recommendation,4
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].goodname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].discount,2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].primecost,2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].salecost,2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].primenumber,2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].salenumber,2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+4*YY_GAP,offset buf2[3*24].recommendation,4
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].goodname,5
             invoke TextOut,hdc,XX+1*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].discount,2
             invoke TextOut,hdc,XX+2*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].primecost,2
             invoke TextOut,hdc,XX+3*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].salecost,2
             invoke TextOut,hdc,XX+4*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].primenumber,2
             invoke TextOut,hdc,XX+5*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].salenumber,2
             invoke TextOut,hdc,XX+6*XX_GAP,YY+5*YY_GAP,offset buf2[4*24].recommendation,4
             ;;
             ret
Display      endp
   

Recommend     PROC     
      MOV ESI,0     
      MOV EDI,0
LOOP3: ADD EDI,10 
              MOV BL,buf[EDI]      ;BL存放商品折扣率
              MOVZX BX,BL
              INC EDI   
              MOV CL,buf[EDI]      ;CL存放商品进货价
              INC EDI 
              MOV AL,buf[EDI]      ;AL存放商品销售价
              MOVZX AX,AL
              IMUL AX,BX
              MOV BL,0AH
              DIV BL
              MOV BL,AL      ;BL存放实际销售价格
              MOVZX AX,CL
              DIV BL
              MOV DL,AL      ;DL存放进货价/实际销售价的商
              INC EDI
              MOV BL,buf[EDI]      ;BL存放进货总数
              SAL BL,1      ;BL存放2*进货总数
              INC EDI
              MOV AL,buf[EDI]       ;AL存放已售数量
              MOVZX AX,AL            
              DIV BL      ;已售数量/（2*进货数量）的商存入寄存器AL
              ADD AL,DL
              MOVZX EAX,AL
              SAL EAX,7      ;计算好的推荐度存在EAX中
              MOV RECO[ESI*4],EAX      ;推荐度送到RECO，为了比较大小
              CALL F16T10    
              MOV EAX,DWORD PTR TEMP       ;TEMP是出口参数
              INC EDI
              MOV EBX,ESI
              IMUL EBX,24
              MOV DWORD PTR buf2[EBX].recommendation,EAX       ;计算好的推荐度送回每个商品信息的指定位置
              INC ESI
              ADD EDI,4      ;此时EDI存放下一个商品的首地址
              CMP ESI,5      ;5个商品的推荐度计算完毕，退出循环
              JNE LOOP3  
              ret
Recommend    ENDP

F16T10 PROC      	;十六进制字节转十进制串，EAX是入口参数，TEMP是出口参数
              MOV DWORD PTR TEMP,'0000'  
              PUSH ESI        ;保护现场
              PUSH EDI
              MOV ESI,3        
              MOV EBX,0AH     
LOOP6:  MOV EDX,0
               DIV EBX       ;双字除法，商在EAX，余数在EDX
               ADD DL,30H
               MOV TEMP[ESI],DL
               CMP EAX,0      ;商为0，结束循环
               JE F10
               DEC ESI
               JMP LOOP6 
F10:  POP EDI
         POP ESI
         RET
F16T10 ENDP      

SORT PROC
            MOV EAX,0
L2:       MOV EBX,0
L1:       MOV EDX,RECO[EBX*4]
            .IF RECO[EAX*4]<EDX
                  INC KEY[EAX]      ;KEY存放推荐度大小的位序  
            .ENDIF
            INC EBX
            CMP EBX,5
            JNE L1 
            INC EAX    
            CMP EAX,5
            JNE L2
            MOV ECX,0
            MOV EBX,0
L3:       MOV DL,KEY[EBX]
            MOVZX ESI,DL
            IMUL ESI,24
            MOV EDI,EBX
            IMUL EDI,24
L5:       MOV AL,buf2[EDI][ECX]
            MOV buf1[ESI][ECX],AL     ;按照推荐度从大到小的顺序，把buf2的商品信息复制给buf1
            INC ECX
            .IF ECX!=24
                  JMP L5
             .ELSE
                          MOV ECX,0
                          INC EBX
                          CMP EBX,5
                          JNE L3
             .ENDIF           
            MOV EAX,0
 L4:      MOV BL,buf1[EAX]
            MOV buf2[EAX],BL      ;把buf1中推荐度排序后的商品信息复制回buf2
            INC EAX
            CMP EAX,120
            JNE L4              
            RET
SORT ENDP

             end  Start
