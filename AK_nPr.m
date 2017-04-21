function [ orders ] = AK_nPr( Ns, r )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

allPerms = perms(Ns);

orders = unique(allPerms(:,1:r),'rows');

end

