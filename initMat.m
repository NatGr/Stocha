function mat = initMat(rows, columns, valueAt)
% valueAt is a function taking two arguments: the row and the columns

mat = zeros(rows, columns);

for i = 1:rows
	for j = 1:columns
		mat(i,j) = valueAt(i,j);
	end
end

end
