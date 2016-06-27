function [ values ] = update_values( vals )
%UPDATE_VALUES Update values in the vals array
%   In this case, this function is just a shifting of the values in the
% 	array. However in a real RT algorithm, it should be the one in 
% 	charge of reading the values from the sensors and update them in the
% 	vectors of the algorithm

	values = [1, vals(2:end)];
end

