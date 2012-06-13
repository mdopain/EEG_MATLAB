% Function to overlay our hand sensitivity maps
%
% input is in the form of images in a cell array. Output will be a
% twodimensional array that can be plotted as a sensitivity map.

function [outputImage] = handOverlay(inputArray)
outputImage = zeros(480,398);
n = length(inputArray);

for i=1:n
    currentImage = inputArray{i};
    for x=1:398
        for y=1:480
                if ~isnan(currentImage(y,x))
                outputImage(y,x)= outputImage(y,x) + currentImage(y,x);
                else
                outputImage(y,x)=NaN;
            end
            
        end
    end
end

outputImage = outputImage./n;

