
function [leaf, leaf_mask] = leaf_detector(I)

I = double(I);

%r = I(:,:,1)-2; g = I(:,:,2)-1; b = I(:,:,3);

% apply the greenness calculation
% Greenness = G*(G-R)*(G-B)
greenness = I(:,:,2).*max(I(:,:,2)-I(:,:,1),0).*max(I(:,:,2)-I(:,:,3),0);
% to 0-1
greenness = mapminmax(greenness,0,1);

hsv = rgb2hsv(I/255);
h = hsv(:,:,1);
s = hsv(:,:,2);
v = hsv(:,:,3);

% apply thresholding to segment the foreground
leaf_mask= logical(greenness == 0);
leaf_mask(leaf_mask ~= (h > s) & leaf_mask ~= (h > v)) = 1;
leaf_mask = imcomplement(leaf_mask);

r = I(:,:,1); g = I(:,:,2); b = I(:,:,3);
r(~leaf_mask) = 0; g(~leaf_mask) = 0; b(~leaf_mask) = 0;
leaf = cat(3, r,g,b);

end