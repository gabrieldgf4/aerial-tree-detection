
% [I_copas, copas_seg, copas_mask, copas_bordas, I_sombras, sombras_seg,
% sombras_mask, sombras_bordas, relacao] = main(I, , [3000 90000], 9, 35, 10, 10);

function [I_copas, copas_seg, copas_mask, copas_bordas, I_sombras, sombras_seg, sombras_mask, sombras_bordas, relacao] = ...
    main(I, s_disk, area, th_circularity, filter_size, seed_tol, crescimento_tol)

I = double(I);

[I_copas, copas_seg, copas_mask, copas_bordas] = copas_arvores(I, s_disk, area, th_circularity);

[I_sombras, sombras_seg, sombras_mask, sombras_bordas] = sombras_arvores(I, filter_size, seed_tol, crescimento_tol);

relacao = copa_sombra(copas_mask, sombras_mask);

direcao_sol(I,copas_mask, sombras_mask, relacao);

%plot_centro_massa(copas_mask, sombras_mask, relacao);

% remove a interseccao entre copa e sombra
%interseccao = copas_mask & sombras_mask;
%sombras_mask = sombras_mask - interseccao;
%sombras_bordas = bwmorph(sombras_mask, 'remove');

% Sombras segmentadas
%r = I(:,:,1); g = I(:,:,2); b = I(:,:,3);
%r(~sombras_mask) = 0; g(~sombras_mask) = 0; b(~sombras_mask) = 0;
%sombras_seg = cat(3,r,g,b);

end