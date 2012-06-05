%   Script to generate sensitivity maps 


%% First, load the images

base = imread('hand_normal.png');
mask = imread('hand_mask.png');

%% Now evaluate points

imshow(base);
[x1,y1]=ginput(14);