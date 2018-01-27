f = 'bag_1.mat';
load(f);
img = uint16( zeros(size(img0)) );

mask1 = img0>3000;
img(mask1) = 60000;		%低密度

mask2 = img1<1000;
img(mask2) = 30000;		%高密度
figure;
imshow(img);
