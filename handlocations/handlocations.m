%   Script to generate sensitivity maps 



%% First, load the images

daniel_r = imread('hand_daniel_r.png');
daniel_l = imread('hand_daniel_l.png');
paul_r = imread('hand_paul_r.png');
paul_l = imread('hand_paul_l.png');
mask = imread('hand_mask.png');

eval_images = {daniel_r,daniel_l,paul_r,paul_l};

%% Now evaluate points
pts = zeros(14,2,4);

for ptnr=1:4;
imshow(eval_images{ptnr});
for loc=1:14;
[pts(loc,1,ptnr),pts(loc,2,ptnr)]=ginput(1);
hold on
plot(x(ptnr,loc),y(ptnr,loc),'g*');
end
end

%% Import data from excel sheet

% This is the baseline measurement of the first of June, with Daniël en
% Paul as test subjects.

% The data is structured, row after row, like this:
% 1. daniel_l 
% 2. daniel_r 
% 3. paul_l 
% 4. paul_r

importdata = xlsread('importfile_lokaties_PT.xlsx');

%% Now to combine the positions with the perceptual thresholds
[X Y] = meshgrid(1:398,1:480);

for i=1:4
Z(i) = 
end


