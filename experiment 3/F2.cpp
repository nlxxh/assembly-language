#include <iostream>
#include <stdio.h>
#include<string.h>
#include "apply.h"
using namespace std;



short int F2(char s[])
{
	const char* error = "Good Not Found\n";
	short int i;
	int k = 0;
	for (i = 0; i < 5; i++)
	{
		if (strcmp(s, items[i].name) == 0) {     //判断输入商品名称是否存在
			k=1; break;
		}
	}
	if (k == 0) {
		printf(error); i = 6;
	}
	else {    //输出商品信息
		printf("商品名称：%s\n", items[i].name);
		printf("折扣：%d\n", items[i].discount);
		printf("销售价：%d\n", items[i].num[1]);
		printf("进货数量：%d\n", items[i].num[2]);
		printf("已售数量：%d\n", items[i].num[3]);
		printf("推荐度：%d\n", items[i].num[4]);
	}
	return i;
}