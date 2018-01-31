function Pkg=loadPkg(filename)
	fid = fopen(filename,'r');
	head = fread(fid,5,'int32');
	switch head(4)
		case 1
			precision = 'uint8';
		case 2
			precision = 'uint16';
		case 4
			precision = 'uint32';
		otherwise
			precision = 'uint64';
	end
	Pkg = zeros(head(2),head(3),head(1));
	for i = 1:head(1)
		Pkg(:,:,i) = fread(fid,[head(2),head(3)],precision);
	end
	fclose(fid);
end