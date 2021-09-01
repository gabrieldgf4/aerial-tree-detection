
% [I_sombras, sombras_seg, sombras_mask, sombras_bordas] = sombras_arvores(img, 15, 10, 10);

function [I_sombras, sombras_seg, sombras_mask, sombras_bordas] = ...
    sombras_arvores(I, filter_size, seed_tol, crescimento_tol)

I = double(I);
[row, col, ~] = size(I);

r1 = I(:,:,1); g1 = I(:,:,2); b1 = I(:,:,3);
r1 = colfilt(r1, [filter_size filter_size], 'sliding', @median);
g1 = colfilt(g1, [filter_size filter_size], 'sliding', @median);
b1 = colfilt(b1, [filter_size filter_size], 'sliding', @median);

rgb = cat(3,r1,g1,b1);
%figure; imagesc(uint8(rgb)); colormap gray

% ajuste
r1(r1==0) = 255;
g1(g1==0) = 255;
b1(b1==0) = 255;
moldura = 10;
r1(1:moldura,:) = 255; r1(end-moldura:end,:) = 255; r1(:,1:moldura) = 255; r1(:,end-moldura:end) = 255;
g1(1:moldura,:) = 255; g1(end-moldura:end,:) = 255; g1(:,1:moldura) = 255; g1(:,end-moldura:end) = 255;
b1(1:moldura,:) = 255; b1(end-moldura:end,:) = 255; b1(:,1:moldura) = 255; b1(:,end-moldura:end) = 255;

% seeds
min_r1 = min(r1(:));
min_g1 = min(g1(:));
min_b1 = min(b1(:));

[x_r1, y_r1] = find(r1 <= min_r1+seed_tol);
[x_g1, y_g1] = find(g1 <= min_g1+seed_tol);
[x_b1, y_b1] = find(b1 <= min_b1+seed_tol);

x = [x_r1;x_g1;x_b1];
y = [y_r1;y_g1;y_b1];

% algoritmo de crescimento
bw = zeros(row, col);
seed_x = [];
seed_y = [];
for i=1:length(x)
    if bw(x(i),y(i)) == 0
        bw_r1 = grayconnected(r1,x(i),y(i),crescimento_tol);
        bw_g1 = grayconnected(g1,x(i),y(i),crescimento_tol);
        bw_b1 = grayconnected(b1,x(i),y(i),crescimento_tol);
        bw = bw | bw_r1 | bw_g1 | bw_b1;
        seed_x = [seed_x; x(i)];
        seed_y = [seed_y; y(i)];
    end
end

% plotar os seed_points
%figure; imagesc(uint8(rgb)); colormap gray; hold on
%plot(seed_y,seed_x, 'mo', 'MarkerFaceColor', 'magenta', 'MarkerSize',10)

sombras_mask = imfill(bw,'holes');

sombras_bordas = bwmorph(sombras_mask, 'remove');
I_sombras = imoverlay(uint8(I), sombras_bordas, 'blue');

% Sombras segmentadas
r = I(:,:,1); g = I(:,:,2); b = I(:,:,3);
r(~sombras_mask) = 0; g(~sombras_mask) = 0; b(~sombras_mask) = 0;
sombras_seg = cat(3,r,g,b);

%figure; imagesc(I_sombras); colormap gray;
%figure; imagesc(uint8(sombras_seg)); colormap gray;
%figure; imagesc(sombras_mask); colormap gray;

% para colocar a borda mais larga
%P = imdilate(sombras_mask, strel('disk',10));
%sombras_bordas = P - sombras_mask;
%I_sombras = imoverlay(uint8(I), sombras_bordas, 'blue');

end