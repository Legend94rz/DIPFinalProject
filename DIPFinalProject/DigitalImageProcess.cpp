#define _CRT_SECURE_NO_WARNINGS
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
	void Output()
	{
		printf("channels: %d, size: %d*%d, bit depth: %d, maximum: %d\n",channels,width,height,depth,maximum);
	}
};
class GraphicPkg
{
public:
	GraphicHeader header;
	vector<Mat> imgs;		//先高能后低能。
	GraphicPkg(string filename)
	{
		FILE* f = fopen(filename.c_str(), "rb");
		fread(&header,1, sizeof(GraphicHeader), f);
		char* content;
		int size = header.width*header.height*header.depth;
		int w = (1 << 8 * header.depth) / header.maximum - 1;
		for (int i = 0; i < header.channels; i++)
		{
			Mat m;
			content = (char*)malloc(size);
			fread(content, 1, size, f);
			if (header.depth == 2)
				m = Mat(header.height, header.width, CV_16UC1, content);
			else
				m = Mat(header.height, header.width, CV_8UC1, content);
			imgs.push_back(m*w);
		}
		fclose(f);
	}
	void Export(string filename)
	{
		for (int i = 0; i < imgs.size(); i++)
		{
			char buf[255];
			sprintf(buf, "%s-%d.txt", filename.c_str(), i);
			FILE* f = fopen(buf, "w");
			for (int j = 0; j < imgs[i].rows; j++)
			{
				//ignore depth==8
				auto p = imgs[i].ptr<uint16_t>(j);
				for (int k = 0; k < imgs[i].cols; k++)
				{
					fprintf(f, "%d ", p[k]);
				}fprintf(f,"\n");
			}

			fclose(f);
		}
	}
};
string filename[] = { "bag_1.pkg","bag_2.pkg","bag_3.pkg","bag_4.pkg","pc_board.pkg" };

int main()
{
	char* win[] = {"1","2"};
	//namedWindow(win[0]);
	//namedWindow(win[1]);
	for (int j = 0; j < 5; j++)
	{
		GraphicPkg g(filename[j]);
		g.Export(filename[j]);
	}
	waitKey(0);
}
