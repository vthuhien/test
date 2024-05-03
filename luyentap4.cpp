#include<iostream>
using namespace std;

//int main()
//{
//	int n;
//	cout << "nhap vao 1 so nguyen n" << endl;
//	cin >> n;
//	if (n % 2 == 0) {
//		cout << "day la so chan";
//	}
//	else
//	{
//		cout << "day la so le";
//	}
//	cout << endl;
//	if (n >= 0) {
//		cout << "day la so duong";
//	}
//	else {
//		cout << "day la so am";
//	}
//	return 0;
//
//	
//}

//int sum(int x, int y) {
//	return x + y;
//}
//int main() 
//{
//	int x, y;
//	cout << "moi nhap vao 2 so nguyen" << endl;
//	cin >> x >> y;
//	int kq = sum(x, y);
//	cout << "tong cua 2 so la" << kq << endl;
//	return 0;
//}

//int main()
//{
//	int x, y;
//	cout << "nhap vao 2 so nguyen";
//	cin >> x >> y;
//	if (x>y) {
//		cout << x << ">" << y << endl;
//
//	}
//	else if (x == y) {
//		cout << x << "=" << y << endl;
//	}
//	else {
//		cout << x << "<" << y;
//	}
//}

int main()
{
	int a, b, c, d;
	cout << "nhap vao 4 so";
	cin >> a >> b >> c >> d;
	int max = a;// gán cho số a là số số lớn nhất
	if (b>max) {
		max = b;
	}
	if (c > max) {
		max = c;
	}
	if (d > max) {
		max = d;
	}
	if (a == b && b == c && c == d && d == a) {
		cout << "khong co so nao la so lon nhat";
	}
	cout << "so lon nhat la" << max << endl;
}