#include <iostream>
#include <stdio.h>
#include "apply.h"
using namespace std;

void F6(short int l)
{
	//输出商品信息
	printf("当前浏览商品名称：%s\n", items[l].name);
	printf("折扣：%d\n", items[l].discount);
	printf("进货价：%d\n", items[l].num[0]);
	printf("销售价：%d\n", items[l].num[1]);
	printf("进货数量：%d\n", items[l].num[2]);
	printf("输入新的数值：\n");
	printf("折扣：%d>>", items[l].discount);
	scanf_s("%hd", &items[l].discount);
	printf("进货价：%d>>", items[l].num[0]);
	scanf_s("%hd", &items[l].num[0]);
	printf("销售价：%d>>", items[l].num[1]);
	scanf_s("%hd", &items[l].num[1]);
	printf("进货数量：%d>>", items[l].num[2]);
	scanf_s("%hd", &items[l].num[2]);
	return;
}