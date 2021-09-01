% Relacao copa e sombra

function relacao = copa_sombra(copas_mask, sombras_mask)

[l1, n1] = bwlabel(copas_mask);
[l2, n2] = bwlabel(sombras_mask);

% relacao, coluna(1) = copas e coluna(2) = sombras, coluna(3) = interseccao
relacao = zeros(n1,3);

for i=1:n1
    copa = copas_mask;
    copa(l1 ~= i) = 0;
    for j=1:n2
        sombra = sombras_mask;
        sombra(l2 ~= j) = 0;
        interseccao = (copa & sombra);
        interseccao_soma = sum(sum(interseccao));
        if sum(sum(interseccao)) >= 1
            uniao = copa | sombra;
            diff = sum(sum(abs(uniao - copa)));
            if diff > 0 % se a uniao e total, entao nao e sombra da arvore
                if relacao(i,1) ~= 0 % se existe mais de uma entre sombra e arvore, entao pegamos a de maior interseccao
                    if interseccao_soma < relacao(i,3)
                        continue;
                    else
                        relacao(i,1) = i;
                        relacao(i,2) = j;
                        relacao(i,3) = interseccao_soma;
                        continue;
                    end
                else
                    relacao(i,1) = i;
                    relacao(i,2) = j;
                    relacao(i,3) = interseccao_soma;
                    continue;
                end
            end
        end
    end
end
    

end