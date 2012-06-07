%   Script to generate sensitivity maps



%% First, load the images

daniel_r = imread('hand_daniel_r.png');
daniel_l = imread('hand_daniel_l.png');
paul_r = imread('hand_paul_r.png');
paul_l = imread('hand_paul_l.png');
mask = double(rgb2gray(imread('hand_mask.png')));
 
eval_images = {daniel_r,daniel_l,paul_r,paul_l};

%% Now evaluate points
pts = zeros(14,2,4);

for i=1:4;
imshow(eval_images{i});
    for loc=1:14;
    [pts(loc,1,i),pts(loc,2,i)]=ginput(1);
    hold on
    plot(pts(loc,1,i),pts(loc,2,i),'g*');
    end
end

%% Import data from excel sheet

% This is the baseline measurement of the first of June, with Daniël en
% Paul as test subjects.

% The data is structured, row after row, like this: 1. daniel_l 2. daniel_r
% 3. paul_l 4. paul_r

importdata = xlsread('importfile_lokaties_PT.xlsx');

%% Now to combine the positions with the perceptual thresholds

% The following loop results in a threedimensional array 'data' which
% contains X and Y coordinates in the first two columns, and a
% corresponding perceptual threshold value in the third column in [mA]. The
% third dimension is for selecting other hands. The indices are as
% follows:

% 1. daniel_l 
% 2. daniel_r
% 3. paul_l 
% 4. paul_r

for i=1:4
data(:,:,i) = [pts(:,:,i),transpose(importdata(i,:))];
end
%% 
tic
[xr,yr,zr]=gridfit(data(:,1,1),data(:,2,1),data(:,3,1),1:398,1:480);
toc
%% Try to plot
image = imagesc(xr);
alpha(mask,'color');
hold on
image(image.*mask);

axis equal


