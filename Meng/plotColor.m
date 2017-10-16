function [ out ] = plotColor( ArrayFrame, row, col, v1, v2, v3 )
%plotColor Plots the colors RGB in a RGB frame
    ArrayFrame(row,col,1) = v1;
    ArrayFrame(row,col,2) = v2;
    ArrayFrame(row,col,3) = v3;
    out = ArrayFrame;
end
