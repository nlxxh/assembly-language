#pragma pack(1)
struct goods {
	char  name[10];		//��Ʒ����
	short int discount;		//�ۿ�
	short int num[5];	//������,���ۼ۸�,��������,��������,�Ƽ���
};
#pragma pack()

extern "C" struct goods items[];