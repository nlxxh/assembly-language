.386
.model flat,stdcall
;option casemap:none



.data


.code
goods	struct
		name		db 10 dup(0)  ;��Ʒ����
		discount	dw 0		  ;�ۿ�
		num			dw 5 dup(0)	  ;������,ʵ�����ۼ۸�,��������,��������,�Ƽ���
goods	ends

public F3
extrn items:dword


F3 proc key:word
        lea ebx, items
		movzx ecx,key
		imul ecx,22
		mov ax,[ebx+ecx].goods.num+8*2
		inc ax     ;����������1
		mov [ebx+ecx].goods.num+8*2,ax
		ret
F3 endp
end