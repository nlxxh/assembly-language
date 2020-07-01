#include <iostream>
#include <stdio.h>
#include "apply.h"
using namespace std;


void F4()
{
	int i;
	short int dis,inpr,oupr,innu,ounu,repr,reco;
	for (i = 0; i < 5; i++)
	{
		dis = items[i].discount;
		inpr = items[i].num[0];
		oupr = items[i].num[1];
		innu = items[i].num[2];
		ounu = items[i].num[3];
		repr = oupr* dis / 10 ;
		reco = 128 * (inpr / repr+ (ounu / (2 * innu)));
		items[i].num[4] = reco;
	}
	return;
}