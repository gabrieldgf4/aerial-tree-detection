function plot_centro_massa(copas_mask, sombras_mask, relacao)

uniao = copas_mask | sombras_mask;
interseccao = copas_mask & sombras_mask;
sombras = sombras_mask - interseccao;

[l1, n1] = bwlabel(copas_mask);
[l2, n2] = bwlabel(sombras_mask);

I_final = imoverlay(uniao, sombras, [128/255,128/255,128/255]);

figure; imagesc(I_final); colormap gray; axis off; hold on

for i=1:size(relacao,1)
    copa = copas_mask;
    copa(l1 ~= relacao(i,1)) = 0;
    sombra = sombras_mask;
    sombra(l2 ~= relacao(i,2)) = 0;
    [r1, c1] = find(copa == 1);
    c_mass_copa = [mean(r1), mean(c1)];
    
    inters = copa & sombra;
    sombra = sombra - inters;
    
    [r2, c2] = find(sombra == 1);
    c_mass_sombra = [mean(r2), mean(c2)];

    % linha
    plot([c_mass_copa(2) c_mass_sombra(2)], [c_mass_copa(1) c_mass_sombra(1)],'g-','linewidth',2.5);
    
    % copa
    plot(c_mass_copa(2), c_mass_copa(1),'r*','MarkerSize',15);
    % seta na ponta da linha
    plot(c_mass_sombra(2), c_mass_sombra(1),'b*','MarkerSize',15);

end

end