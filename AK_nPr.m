function [ orders ] = AK_nPr( n, r )
%AK_nPr returns all unique permutations of r values selected without
%replacement from a list of values n. This is similar to nPr except that,
%rather than permuting the values 1:n, this function permutes a designated
%list of values n.
%   INPUT:
%       n: a list of doubles to be permuted
%       r: the number of values to be selected in each unique permutation
%   OUTPUT:
%       orders: a matrix containing all unique permutations of the values
%           in the list n of length r; the matrix returned should have the
%           dimensions # unique orders by r

% check input
if nargin ~= 2
    error('AK_nPr requires two arguments. Please see help documentation for details.');
end

allPerms = perms(n);

orders = unique(allPerms(:,1:r),'rows');

end

