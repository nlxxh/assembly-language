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
menuItem     db       0  ;��ǰ�˵�״̬


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
	                    invoke InvalidateRect,hWnd,0,1     ;���������ͻ���
		    invoke UpdateWindow, hWnd	      
	    .ELSEIF wParam == IDM_ACTION_LISTSORT
		    .IF menuItem == 1 
                                          CALL SORT
		    .ENDIF
                                    mov menuItem, 1
	                    invoke InvalidateRect,hWnd,0,1     ;���������ͻ���
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
              MOV BL,buf[EDI]      ;BL�����Ʒ�ۿ���
              MOVZX BX,BL
              INC EDI   
              MOV CL,buf[EDI]      ;CL�����Ʒ������
              INC EDI 
              MOV AL,buf[EDI]      ;AL�����Ʒ���ۼ�
              MOVZX AX,AL
              IMUL AX,BX
              MOV BL,0AH
              DIV BL
              MOV BL,AL      ;BL���ʵ�����ۼ۸�
              MOVZX AX,CL
              DIV BL
              MOV DL,AL      ;DL��Ž�����/ʵ�����ۼ۵���
              INC EDI
              MOV BL,buf[EDI]      ;BL��Ž�������
              SAL BL,1      ;BL���2*��������
              INC EDI
              MOV AL,buf[EDI]       ;AL�����������
              MOVZX AX,AL            
              DIV BL      ;��������/��2*�������������̴���Ĵ���AL
              ADD AL,DL
              MOVZX EAX,AL
              SAL EAX,7      ;����õ��Ƽ��ȴ���EAX��
              MOV RECO[ESI*4],EAX      ;�Ƽ����͵�RECO��Ϊ�˱Ƚϴ�С
              CALL F16T10    
              MOV EAX,DWORD PTR TEMP       ;TEMP�ǳ��ڲ���
              INC EDI
              MOV EBX,ESI
              IMUL EBX,24
              MOV DWORD PTR buf2[EBX].recommendation,EAX       ;����õ��Ƽ����ͻ�ÿ����Ʒ��Ϣ��ָ��λ��
              INC ESI
              ADD EDI,4      ;��ʱEDI�����һ����Ʒ���׵�ַ
              CMP ESI,5      ;5����Ʒ���Ƽ��ȼ�����ϣ��˳�ѭ��
              JNE LOOP3  
              ret
Recommend    ENDP

F16T10 PROC      	;ʮ�������ֽ�תʮ���ƴ���EAX����ڲ�����TEMP�ǳ��ڲ���
              MOV DWORD PTR TEMP,'0000'  
              PUSH ESI        ;�����ֳ�
              PUSH EDI
              MOV ESI,3        
              MOV EBX,0AH     
LOOP6:  MOV EDX,0
               DIV EBX       ;˫�ֳ���������EAX��������EDX
               ADD DL,30H
               MOV TEMP[ESI],DL
               CMP EAX,0      ;��Ϊ0������ѭ��
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
                  INC KEY[EAX]      ;KEY����Ƽ��ȴ�С��λ��  
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
            MOV buf1[ESI][ECX],AL     ;�����Ƽ��ȴӴ�С��˳�򣬰�buf2����Ʒ��Ϣ���Ƹ�buf1
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
            MOV buf2[EAX],BL      ;��buf1���Ƽ�����������Ʒ��Ϣ���ƻ�buf2
            INC EAX
            CMP EAX,120
            JNE L4              
            RET
SORT ENDP

             end  Start
