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
		if (strcmp(s, items[i].name) == 0) {     //�ж�������Ʒ�����Ƿ����
			k=1; break;
		}
	}
	if (k == 0) {
		printf(error); i = 6;
	}
	else {    //�����Ʒ��Ϣ
		printf("��Ʒ���ƣ�%s\n", items[i].name);
		printf("�ۿۣ�%d\n", items[i].discount);
		printf("���ۼۣ�%d\n", items[i].num[1]);
		printf("����������%d\n", items[i].num[2]);
		printf("����������%d\n", items[i].num[3]);
		printf("�Ƽ��ȣ�%d\n", items[i].num[4]);
	}
	return i;
}