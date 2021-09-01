function plot_interseccao(copas_mask, sombras_mask)

uniao = copas_mask | sombras_mask;
interseccao = copas_mask & sombras_mask;
sombras = sombras_mask - interseccao;

I_final = imoverlay(uniao, interseccao, 'red');
I_final = imoverlay(I_final, sombras, [128/255,128/255,128/255]);

figure; imagesc(I_final); colormap gray; axis off; 

end