#include <iostream>
#include <stdio.h>
#include "apply.h"
using namespace std;

void F6(short int l)
{
	//�����Ʒ��Ϣ
	printf("��ǰ�����Ʒ���ƣ�%s\n", items[l].name);
	printf("�ۿۣ�%d\n", items[l].discount);
	printf("�����ۣ�%d\n", items[l].num[0]);
	printf("���ۼۣ�%d\n", items[l].num[1]);
	printf("����������%d\n", items[l].num[2]);
	printf("�����µ���ֵ��\n");
	printf("�ۿۣ�%d>>", items[l].discount);
	scanf_s("%hd", &items[l].discount);
	printf("�����ۣ�%d>>", items[l].num[0]);
	scanf_s("%hd", &items[l].num[0]);
	printf("���ۼۣ�%d>>", items[l].num[1]);
	scanf_s("%hd", &items[l].num[1]);
	printf("����������%d>>", items[l].num[2]);
	scanf_s("%hd", &items[l].num[2]);
	return;
}