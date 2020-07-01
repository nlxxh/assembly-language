#include <iostream>
#include <stdio.h>
#include "apply.h"


extern void F1();     //定义在F1.cpp
extern short int F2(char s[]);     //定义在F2.cpp     
extern "C" long __stdcall F3(short int);    //定义在F3.asm
extern void F4();     //定义在F4.cpp
extern void F6(short int l);     //定义在F6.cpp


struct goods items[5] = {
	{'P','E','N',  0,0,0,0,0,0,0, 10,  35,56,70,25,0},
	{'B','O','O','K',0,0,0,0,0,0,  9,  12,30,25, 5,0},
	{ 'B','A','L','L',0,0,0,0,0,0,  6,  60,40,25, 20,0},
	{ 'G','L','U','E',0,0,0,0,0,0,  7,  50,20,25, 10,0},
	{'B','A','G',  0,0,0,0,0,0,0,  8,  10,20,30,10,0},
};

int main()
{
	
	const char *szMsg = "User Name:(Boss or Customer)\nCurrent Good Name:(Blank is Allowed)\n"
		"Please Input Number 1-9:\n1.Log in / Log in Again\n2.Seek a Specific Good and Show Information\n" 
		"3.Place an Order\n4.Calculate Good Recommendation Index\n5.Rank\n6.Correct Information\n"
		"7.Transfer to Another Operating Environment\n8.Show Current Code Segment Address\n9.Exit\n";
	const char *error = "Input Error!Try Again!\n";
	const char *gan = "Input Good Name:(Max 9 characters)\n";
	const char *err = "Error!\n";
	char in_good[10];
	int x;
	short int l = 6;
	while (1)
	{
		printf(szMsg);
		scanf_s("%d", &x);
		if (x > 9 || x < 1) { printf(error); continue; }
		switch (x)
		{
		case 1:
			F1();
			break;
		case 2:
			printf(gan);
			scanf_s("%s",in_good,sizeof(in_good));
			getchar();
			l=F2(in_good);
			break;
		case 3:
			if (l == 6) printf(err);
			else if(items[l].num[2]<=items[l].num[3])  printf(err);
			else {
				F3(l); F4();
			}
			break;
		case 4:
			F4();
			break;
		case 6:
			if (l == 6) printf(err);
			else F6(l);
			break;
		default:
			getchar();
			return 0;
		}

	}
	return 0;
}
