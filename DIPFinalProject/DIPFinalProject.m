filename = 'pc_board';
pkg = loadPkg(strcat(filename,'.pkg'));
std = imread(strcat(filename,'.jpg'));
std = imresize(std,size(pkg(:,:,1)));
std = std(:,:,1);
%%
if(size(pkg,3)==2)
	LoImg = imadjust(pkg(:,:,2));
	HiImg = imadjust(pkg(:,:,1));
	img = uint16( Fusion(LoImg,HiImg,'haar',1.2,2) );
	%img = imadjust(img);
	img = imsharpen(img);
	M = zeros(4,2);
	M(1,:) = Evaluate(HiImg);
	M(2,:) = Evaluate(LoImg);
	M(3,:) = Evaluate(img);
	M(4,:) = Evaluate(std);
	disp(M);
else
	img = pkg(:,:,1);
end
s =[LoImg, HiImg; img, im2uint16(std) ];
%s = img;
imshow(s);
imwrite(img,strcat(filename,'.tiff'),'tiff');
