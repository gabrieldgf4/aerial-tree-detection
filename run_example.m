
% It is an example of using the code

img = imread('tree.png');

[I_copas, copas_seg, copas_mask, copas_bordas] = copas_arvores(img, 2, [3000 90000], 10);
figure; imagesc(I_copas); colormap gray

[I_sombras, sombras_seg, sombras_mask, sombras_bordas] = sombras_arvores(img, 15, 10, 10);
figure; imagesc(I_sombras); colormap gray

plot_interseccao(copas_mask, sombras_mask)

relacao = copa_sombra(copas_mask, sombras_mask);

plot_centro_massa(copas_mask, sombras_mask, relacao)

direcao_sol(img,copas_mask, sombras_mask, relacao);

