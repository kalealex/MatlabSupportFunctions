function [ nanPadMat ] = AK_nanPad( mat, dimensions, insertMatCoords )
%AK_nanPad returns a nan-padded version of the given matrix with the given
%dimensions.
%   INPUT:
%       mat: the matrix to be nan-padded
%       dimensions: the desired dimensions (number of rows, columns, etc.
%           desired) for the output matrix
%       insertMatCoords: the coordinates designating the upper left corner
%           of where the given matrix (mat) should be inserted into the
%           output matrix; should match the size of dimensions; defaults to
%           ones
%   OUTPUT:
%       nanPadMat: a nan-padded version of the given matrix, meeting the
%           specifications of the function arguments

% check inputs
if nargin < 2; 
    error('AK_nanPad requires at least two arguments.')
end
if nargin < 3
    insertMatCoords = ones(size(dimensions));
end

% create function output
nanPadMat = nan(dimensions);

% insert Matrix into output
nanPadMat(insertMatCoords(1):length(mat(:,1)),insertMatCoords(2):length(mat(1,:))) = mat;

end

