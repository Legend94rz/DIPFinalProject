function saveToMat(filename,g,method)
	if strcmp( method,'append')
		save(filename,'g','--append');
	else
		save(filename,'g');
	end
end