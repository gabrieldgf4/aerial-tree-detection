
% [I_copas, copas_seg, copas_mask, copas_bordas] = copas_arvores(img, 2, [3000 90000], 10);

function [I_copas, copas_seg, copas_mask, copas_bordas] = copas_arvores(I, s_disk, area, th_circularity)

I = double(I);
[row, col, ~] = size(I);

borda = I(:,:,3) > 240;

I = punch_green(I);

[~, m] = nongreen_detector(I);
m(borda) = 1;

se = strel('disk', s_disk);
bw = imclose(~m, se);
bw = imfill(bw,'holes');
bw = imopen(bw, se);
b = bwareafilt(bw, [area(1), area(2)]);

labeledImage = bwlabel(b);
measurements = regionprops(labeledImage, 'Area', 'Perimeter');
allAreas = [measurements.Area];
allPerims = [measurements.Perimeter];
circularities = allPerims .^ 2 ./ (4*pi*allAreas); %(4*pi*allAreas) ./ allPerims .^ 2 ;
keeperIndexes = find(circularities < th_circularity);
keeperBlobsImage = ismember(labeledImage,keeperIndexes);

stats = regionprops('table',keeperBlobsImage,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;
%figure; imshow(uint8(I)); viscircles(centers,radii);

copas_bordas = zeros(row,col);
for i=1:length(radii)
    copas_bordas = insertShape(copas_bordas,'circle',[centers(i,1), centers(i,2), radii(i)], 'Color', 'white');
end

[~, ~, ch] = size(copas_bordas);
if ch==3
    copas_bordas = logical(copas_bordas(:,:,2));
else
    copas_bordas = logical(copas_bordas);
end

I_copas = imoverlay(uint8(I), copas_bordas, 'red');

% ajustando as bordas para fechar os circulos
copas_bordas(1,5:end-1) = 1; copas_bordas(5:end-1,1) = 1; copas_bordas(end,5:end-1) = 1; copas_bordas(5:end-1,end) = 1;
copas_mask = imfill(copas_bordas, 'holes');
copas_bordas(1,5:end-1) = 0; copas_bordas(5:end-1,1) = 0; copas_bordas(end,5:end-1) = 0; copas_bordas(5:end-1,end) = 0;
copas_mask(1,5:end-1) = 0; copas_mask(5:end-1,1) = 0; copas_mask(end,5:end-1) = 0; copas_mask(5:end-1,end) = 0;

% Copas segmentadas
r = I(:,:,1); g = I(:,:,2); b = I(:,:,3);
r(~copas_mask) = 0; g(~copas_mask) = 0; b(~copas_mask) = 0;
copas_seg = cat(3,r,g,b);

%figure; imagesc(I_copas); colormap gray;
%figure; imagesc(uint8(copas_seg)); colormap gray;
%figure; imagesc(copas_mask); colormap gray;

% para colocar a borda mais larga
%P = imdilate(copas_mask, strel('disk',10));
%copas_bordas = P - copas_mask;
%I_copas = imoverlay(uint8(I), copas_bordas, 'red');

end