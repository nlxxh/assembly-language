#include <iostream>
#include <stdio.h>
using namespace std;


void F1()
{
	short int auth = 0;
	char in_name[20];
	char in_pwd[20];
	const char *bname = "RONGYUETONG";
	const char *bpass = "TEST00";
	const char *bname1 = "Input Name:(Max 12 Characters)\n";
	const char *bpass1 = "Input Password:(Max 6 characters)\n";
	const char *err1 = "Log in Failed!Try Again!\n";
exhibit:
	printf(bname1);     //提示输入姓名
	scanf_s("%s", in_name,sizeof(in_name));     //输入姓名
	if (in_name[0] == '\n') return;
	printf(bpass1);     //提示输入密码
	scanf_s("%s", in_pwd,sizeof(in_pwd));     //输入密码
	int i = 0;
	if (strlen(in_name) != strlen(bname) || strlen(in_pwd) != strlen(bpass)) {
		printf(err1);    //提示错误信息
		goto exhibit;
	}
	
	while (i < 11)
	{
		if (in_name[i] == bname[i]) i++;    //输入姓名和正确姓名比较
		else {
			printf(err1);
			goto exhibit;
		}
	}
	
	i = 0;
	while (i < 6)
	{
		if (in_pwd[i] == bpass[i]) i++;
		else {
			printf(err1);
			goto exhibit;
		}
	}
	auth = 1;
	return;
}

