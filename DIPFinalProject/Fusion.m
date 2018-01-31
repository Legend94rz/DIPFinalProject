function [ f ] = Fusion( low, high,method, q, level )
	[a1,b1,c1,d1] = dwt2(low,method);
	[a2,b2,c2,d2] = dwt2(high,method);
	if (level > 1)
		a = Fusion(a1,a2,method,q,level - 1);
	else
		a = FusionLow(a1,a2);
	end
	b = FusionHigh(b1,b2,q);
	c = FusionHigh(c1,c2,q);
	d = FusionHigh(d1,d2,q);
	f = idwt2(a,b,c,d,method);
end
%% 融合双能图像低频带。
% a1: 高能图像低频子带；a2: 低能图像低频子带
function y = FusionLow(a1,a2)
	[m,n] = size(a1);
	y = zeros(m,n);
	q=0;
	for i=1:m
		D1 = FractalDim(a1(i,:),(fix(n/2)+1)*2);
		D2 = FractalDim(a2(i,:),(fix(n/2)+1)*2);
		S1 = D1/(D1+D2);	O1 = sqrt(D1)/(sqrt(D1)+sqrt(D2));
		S2 = 1-S1;			O2 = 1-O1;
		q = q+(S1+O1);
		y(i,:) = 0.5*(S1+O1)*a1(i,:) ...
				+0.5*(S2+O2)*a2(i,:);
	end
	%fprintf("%f  %f\n",q/m,1-q/m);
	%y = a1*0.5+a2*0.5;
end
%% 融合双能图像高频子带
% b1：高能图像高频子带；b2：低能图像高频子带；q：融合参数
function y = FusionHigh(b1,b2,q)
	[x1,y1] = gradient(b1);
	[x2,y2] = gradient(b2);
	g1 = x1+y1;
	g2 = x2+y2;
	y = b1.*(g1>=g2)+b2.*(g1<g2);
	y = y*q;
end
