function direcao_sol(I, copas_mask, sombras_mask, relacao)

[row, col, ~] = size(I);
[l1, n1] = bwlabel(copas_mask);
[l2, n2] = bwlabel(sombras_mask);


% Flip the image upside down before showing it
figure; imagesc(flipdim(uint8(I),1)); axis off; hold on;

for i=1:size(relacao,1)
    copa = copas_mask;
    copa(l1 ~= relacao(i,1)) = 0;
    sombra = sombras_mask;
    sombra(l2 ~= relacao(i,2)) = 0;
    [r1, c1] = find(copa == 1);
    c_mass_copa = [mean(r1), mean(c1)];
    
    interseccao = copa & sombra;
    sombra = sombra - interseccao;
    
    [r2, c2] = find(sombra == 1);
    c_mass_sombra = [mean(r2), mean(c2)];

y = [c_mass_sombra(1), c_mass_copa(1)];
x = [c_mass_sombra(2), c_mass_copa(2)];

% linha
plot(x, row-y,'y-','linewidth',2.5);
% seta na ponta da linha
plot(x(2), row-y(2),'y>','linewidth',2.5, 'MarkerSize',20);


end

% set the y-axis back to normal.
set(gca,'ydir','normal');

end