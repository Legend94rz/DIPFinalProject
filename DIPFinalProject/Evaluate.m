function [metrics]=Evaluate(I)
	ent = entropy(I);
	[x,y] = gradient(im2double(I));
	metrics = [ent,mean2( (abs( x )+abs(y))/2 )];
end
