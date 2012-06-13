%   Script to generate sensitivity maps

clear all
close all
disp('Running script..')
tic

%% First, load the images

images={'hand_daniel_l.png','hand_daniel_r.png','hand_paul_l.png','hand_paul_r.png','hand_reinco_l.png','hand_reinco_r.png','hand_thijs_l.png','hand_thijs_r.png'};

for i=1:length(images)
    eval_images{i}=imread(images{i});
end

mask = double(rgb2gray(imread('hand_mask.png')));
norm = imread('hand_normal.png');
mirror = imread('hand_normal_mirror.png');

if exist('savedPts.mat','file')
    load('savedPts.mat','pts');
    savedNum = size(pts);
else
    savedNum=[0,0,0];
end
imageNum = length(eval_images);
%% Now evaluate points
%{
!!ik denk dat we hier deze punten ook moeten gebruiken om gelijk dat stuk
specifiek aan te kunnen geven. Dat de griddata zo groot moet worden en dat
deze er overheen kan!!!
pts = zeros(14,2,imageNum);
%}

if savedNum(3)<=imageNum
for i=(savedNum(3)+1):imageNum;
imshow(eval_images{i});
    title(['Evaluate points for image ' images{i}])
    for loc=1:14;
    [pts(loc,1,i),pts(loc,2,i)]=ginput(1);
    hold on
    plot(pts(loc,1,i),pts(loc,2,i),'g*');
    end
end

save('savedPts.mat','pts');
end

%% Import data from excel sheet and load points

% This is the baseline measurement of the first of June, with Daniël en
% Paul as test subjects.

% The data is structured, row after row, like this: 1. daniel_l 2. daniel_r
% 3. paul_l 4. paul_r

importdata = xlsread('importfile_lokaties_PT.xlsx', 'Sheet1', 'B1:O8');
load('savedPts.mat','pts');

%% relativeren per hand

for i=1:imageNum
    rij = importdata(i,:);
    gemiddelde = sum(rij)/14;
    %zmax = max(rij);
    nieuwerij = rij./gemiddelde;
    relatievedata(i,:) = nieuwerij;
end

%% Now to combine the positions with the perceptual thresholds

% The following loop results in a threedimensional array 'data' which
% contains X and Y coordinates in the first two columns, and a
% corresponding perceptual threshold value in the third column in [mA]. The
% third dimension is for selecting other hands. The indices are the same as
% in the 'images' variable above. 

for i=1:imageNum
data(:,:,i) = [pts(:,:,i),transpose(relatievedata(i,:))];
end

%% Stuk van Ruurd

for i=1:imageNum
    % Determine the minimum and the maximum x and y values:
    x = data(:,1,i);
    y = data(:,2,i);
    z = data(:,3,i);
    xmin = 0; ymin = 0;
    xmax = 398; ymax = 480; 


    % Define the resolution of the grid:
    xres=398;
    yres=480;


    % Define the range and spacing of the x- and y-coordinates,
    % and then fit them into X and Y
    xv = linspace(xmin, xmax, xres);
    yv = linspace(ymin, ymax, yres);
    [Xinterp,Yinterp] = meshgrid(xv,yv); 


    % Calculate Z in the X-Y interpolation space, which is an 
    % evenly spaced grid:
    Zinterp = griddata(x,y,z,Xinterp,Yinterp); 
    
    % Generate the mesh plot (CONTOUR can also be used):
    subplot(3,3,i)
    colormap(hot);
    xlabel X; ylabel Y; zlabel Z;
    % figure(i)
    imagesc(Zinterp);
    hold on
    
    
    
    if mod(i,2)==1;
        imshow(mirror);
        sensMapsRight{1+((i-1)/2)}=Zinterp;
    else
        imshow(norm);
        sensMapsLeft{i/2}=Zinterp;
    end
    
    
    alpha(0.5);   
    caxis([0 1]);
    title([num2str(i) ':' images(i)]);
    hold off

end

%% Overlay hands of the same side

rightHands = handOverlay(sensMapsRight);
leftHands = handOverlay(sensMapsLeft);
gemiddeldealles = 0.479196429;

alphaRight = zeros(480,398);
alphaLeft = alphaRight;

for x=1:398
        for y=1:480
            if ~isnan(rightHands(y,x))
                alphaRight(y,x)=1;
                rightHands(y,x) = rightHands(y,x) .* gemiddeldealles;
                % Is de regel hierboven wel nodig, aangezien imagesc
                % schaalt naar de data?
            end
            if ~isnan(leftHands(y,x))
                alphaLeft(y,x)=1;
                leftHands(y,x) = leftHands(y,x) .* gemiddeldealles;
            end            
        end
end

B = imagesc(leftHands);
set(B,'AlphaData',alphaLeft);
imwrite(B,'leftHands.png');

imageLeft = imread('leftHands.png');
figure;
imshow(norm)
hold on
D = imshow(imageLeft)
set(imageLeft,'AlphaData',alphaLeft)


toc

