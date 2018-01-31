function D=FractalDim(y,cellmax)
	%求输入一维信号的计盒分形维数
	%y是一维信号
	%cellmax:方格子的最大边长, 可以取2的偶数次幂次(1,2,4,8...),取大于数据长度的偶数
	%D是y 的计盒维数（一般情况下D>=1）,D=lim(log(N(e))/log(k/e)),
	if cellmax<length(y)
		error('cellmax must be larger than input signal!')
	end
	L=length(y);%输入样点的个数
	y_min=min(y);
	%移位操作，将y_min移到坐标0点
	y_shift=y-y_min;
	%重采样，使总点数等于cellmax+1
	x_ord=[0:L-1]./(L-1);
	xx_ord=[0:cellmax]./(cellmax);
	y_interp=interp1(x_ord,y_shift,xx_ord);
	%按比例缩放y ，使最大值为2^^c
	ys_max=max(y_interp);
	factory=cellmax/ys_max;
	yy=abs(y_interp*factory);
	t=log2(cellmax)+1;%叠代次数
	for e=1:t
		Ne=0;%累积覆盖信号的格子的总数
		cellsize=2^(e-1);%每次的格子大小
		NumSeg(e)=cellmax/cellsize;%横轴划分成的段数
		for j=1:NumSeg(e) %由横轴第一个段起通过计算纵轴跨越的格子数累积N(e)
			begin=cellsize*(j-1)+1;%每一段的起始
			tail=cellsize*j+1;
			seg=[begin:tail];%段坐标
			yy_max=max(yy(seg));
			yy_min=min(yy(seg));
			up=ceil(yy_max/cellsize);
			down=floor(yy_min/cellsize);
			Ns=up-down;% 本段曲线占有的格子数
			Ne=Ne+Ns;%累加每一段覆盖曲线的格子数
		end
		N(e)=Ne;%记录每e下的N(e)
	end
	%对log(N(e))和log(k/e)进行最小二乘的一次曲线拟合,斜率就是D
	r=-diff(log2(N));%去掉r超过2和小于1的野点数据
	id=find(r<=2&r>=1);%保留的数据点
	Ne=N(id);
	e=NumSeg(id);
	P=polyfit(log2(e),log2(Ne),1);%一次曲线拟合返回斜率和截距
	D=P(1);
end