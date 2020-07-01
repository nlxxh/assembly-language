.386
.model flat,stdcall
;option casemap:none



.data


.code
goods	struct
		name		db 10 dup(0)  ;商品名称
		discount	dw 0		  ;折扣
		num			dw 5 dup(0)	  ;进货价,实际销售价格,进货数量,已售数量,推荐度
goods	ends

public F3
extrn items:dword


F3 proc key:word
        lea ebx, items
		movzx ecx,key
		imul ecx,22
		mov ax,[ebx+ecx].goods.num+8*2
		inc ax     ;已售数量加1
		mov [ebx+ecx].goods.num+8*2,ax
		ret
F3 endp
end