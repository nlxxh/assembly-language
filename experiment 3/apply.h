#pragma pack(1)
struct goods {
	char  name[10];		//商品名称
	short int discount;		//折扣
	short int num[5];	//进货价,销售价格,进货数量,已售数量,推荐度
};
#pragma pack()

extern "C" struct goods items[];