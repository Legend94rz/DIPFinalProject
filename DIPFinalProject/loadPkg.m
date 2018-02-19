function Pkg=loadPkg(filename)
	fid = fopen(filename,'r');
	head = fread(fid,5,'int32');
	precision = strcat('uint',int2str(head(4)*8));
	Pkg = zeros(head(2),head(3),head(1),strcat('uint',int2str(head(4)*8)));
	for i = 1:head(1)
		Pkg(:,:,i) = fread(fid,[head(2),head(3)],precision);
	end
	fclose(fid);
end