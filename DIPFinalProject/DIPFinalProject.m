filename = 'bag_1';
pkg=loadPkg(strcat(filename,'.pkg'));
std = imread(strcat(filename,'.jpg'));
std = permute(std,[2,1,3]);
std = imresize(std,size(img0));
%%
if(size(pkg,3)==2)
	img1 = pkg(:,:,2);
	img0 = pkg(:,:,1);
	img = uint16( Fusion(img1,img0,'haar',1.0,2) );
	img = imsharpen(img);
else
	img = pkg(:,:,1);
end
%s =[img0 * 16, img1 * 16  ; uint16(img), im2uint16(std(:,:,1)) ];
img = imadjust(img);
s = img;
imshow(s);

