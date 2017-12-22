#include <opencv.hpp>
#include <cstdio>
#include <vector>
#include <string>
using namespace cv;
using namespace std;
struct GraphicHeader
{
	int channels;
	int width;
	int height;
	int depth;
	int maximum;
};
char* content[2];
string filename= "F:\\Workshop\\DIPFinalProject\\DIPFinalProject\\bag_1.pkg";

void ReadHeader(GraphicHeader* header)
{
	FILE* file = fopen(filename.c_str(),"rb");
	fread(header,1,sizeof(GraphicHeader),file);
	fclose(file);
}
void ReadData(char* target, size_t size,int offset)
{
	FILE* file = fopen(filename.c_str(),"rb");
	fseek(file, offset, 0);
	fread(target,1,size,file);
	fclose(file);
}
int main()
{
	GraphicHeader header;
	ReadHeader(&header);
	vector<Mat> imgs(header.channels);
	namedWindow("1");
	namedWindow("2");
	for (int i = 0; i < header.channels; i++)
	{
		int size = header.width*header.height*header.depth;
		content[i] = (char*)malloc(size);
		ReadData(content[i], size, size*i + 5 * sizeof(int));
		imgs[i] = Mat(header.height, header.width, CV_16UC1, content[i]);
	}
	imshow("1", imgs[0]*8);
	imshow("2", imgs[1]*8);
	waitKey(0);
}
