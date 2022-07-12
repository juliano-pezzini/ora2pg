-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION qt_prescricao_md_pck.calcular_prescricao (dose bigint, tolerancia bigint, tabela qt_prescricao_pck.tabela_prescricao) RETURNS QT_PRESCRICAO_PCK.PRESCRICAO AS $body$
DECLARE

        prescricao_w qt_prescricao_pck.prescricao;
        prescricao_candidata_w qt_prescricao_pck.prescricao;
        restante_w bigint;
        restante_auxiliar_w bigint;
        retorno_w qt_prescricao_pck.prescricao;
        ultima_prescricao_w qt_prescricao_pck.prescricao;
        medicamento_candidato_w qt_prescricao_pck.medicamento;
        medicamento_prescricao_w qt_prescricao_pck.medicamento;
        medicamento_sobra_w qt_prescricao_pck.medicamento;
        menor_sobra_w bigint;
        quantidade_w bigint;

        prescricoes_candidatas_w qt_prescricao_pck.prescricao_vetor;
        prescricao_retorno_w qt_prescricao_pck.prescricao := null;

BEGIN
        restante_w := dose;

        -- percorrer a tabela de prescricoes
        -- da maior dose para menor dose
        for indice in reverse tabela.prescricoes.first..tabela.prescricoes.last loop
            prescricao_w := tabela.prescricoes(indice);

            -- neste caso, existe uma entrada na tabela com a dose
            -- basta retornar esta entrada, 
            -- pois ela possui os medicamentos combinados
            if (restante_w >= qt_prescricao_md_pck.prescricao_dose_total(prescricao_w)
                and restante_w <= qt_prescricao_md_pck.prescricao_dose_total(prescricao_w) + tolerancia) then
                restante_w := restante_w - qt_prescricao_md_pck.prescricao_dose_total(prescricao_w);
                retorno_w := qt_prescricao_md_pck.combinar_prescricao(retorno_w, prescricao_w);

                retorno_w.perda := 0;
                return retorno_w;
            end if;

            -- caso onde a dose nao bate com nenhuma entrada da tabela
            -- mas esta entre duas entradas
            -- como as entradas sao os medicamentos necessarios para a prescricao, vai ter uma sobra
            -- eh necessario calcular a escolha para a menor dose (a) e para a maior (b)
            -- e inserir na lista de prescricoes candidatas
            -- ex: 
            --      dose 30
            --      medicamentos: 12mg, 27mg, 36mg
            -- candidatos:
            --      a) 12mg + 27mg => 39mg com 9mg de sobra
            --      b) 36mg => 36mg com 6mg de sobra (melhor escolha)
            if (ultima_prescricao_w.medicamentos.count > 0
                and restante_w > 0
                and qt_prescricao_md_pck.prescricao_dose_total(ultima_prescricao_w) > restante_w
                and qt_prescricao_md_pck.prescricao_dose_total(prescricao_w) < restante_w) then

                restante_auxiliar_w := restante_w;
                prescricao_candidata_w.medicamentos.delete;
                prescricao_candidata_w.perda := 0;

                for indice_medic in ultima_prescricao_w.medicamentos.first..ultima_prescricao_w.medicamentos.last loop
                    medicamento_candidato_w := ultima_prescricao_w.medicamentos(indice_medic);

                    if (qt_prescricao_md_pck.medicamento_dose_total(medicamento_candidato_w) < restante_auxiliar_w) then
                        prescricao_candidata_w.medicamentos(prescricao_candidata_w.medicamentos.count) := medicamento_candidato_w;
                        restante_auxiliar_w := restante_auxiliar_w - qt_prescricao_md_pck.medicamento_dose_total(medicamento_candidato_w);
                    else
                        -- aqui temos o medicamento que ira servir para preencher o restante da dose
                        medicamento_prescricao_w := medicamento_candidato_w;
                        medicamento_prescricao_w.quantidade := restante_auxiliar_w / medicamento_candidato_w.dose;
                        prescricao_candidata_w.medicamentos(prescricao_candidata_w.medicamentos.count) := medicamento_prescricao_w;

                        prescricao_candidata_w.perda := qt_prescricao_md_pck.medicamento_dose_total(medicamento_candidato_w) - restante_auxiliar_w;
                        restante_auxiliar_w := 0;

                        exit;
                    end if;
                end loop;
                prescricoes_candidatas_w(prescricoes_candidatas_w.count) := qt_prescricao_md_pck.combinar_prescricao(retorno_w, prescricao_candidata_w);
            end if;

            if (qt_prescricao_md_pck.prescricao_dose_total(prescricao_w) < restante_w) then
                restante_w := restante_w - qt_prescricao_md_pck.prescricao_dose_total(prescricao_w);
                retorno_w := qt_prescricao_md_pck.combinar_prescricao(retorno_w, prescricao_w);
            end if;

            ultima_prescricao_w := prescricao_w;
        end loop;

        -- se ainda houver sobra
        -- nos resta encontrar o medicamento mais adequado para preencher
        if (restante_w > 0) then
            menor_sobra_w := restante_w;

            -- procurar nos medicamentos
            --o que possui a dose logo acima desta sobra
            medicamento_sobra_w := null;
            for indice in tabela.medicamentos.first..tabela.medicamentos.last loop
                medicamento_candidato_w := tabela.medicamentos(indice);
                restante_auxiliar_w := qt_prescricao_md_pck.medicamento_dose_total(medicamento_candidato_w) - restante_w;
                if (coalesce(medicamento_sobra_w.codigo::text, '') = '' or (restante_auxiliar_w < menor_sobra_w and qt_prescricao_md_pck.medicamento_dose_total(medicamento_candidato_w) > restante_w)) then
                    menor_sobra_w := restante_auxiliar_w;
                    medicamento_sobra_w := medicamento_candidato_w;
                end if;
            end loop;

            if (medicamento_sobra_w.codigo IS NOT NULL AND medicamento_sobra_w.codigo::text <> '') then
                quantidade_w := restante_w / qt_prescricao_md_pck.medicamento_dose_total(medicamento_sobra_w);
                retorno_w.perda := qt_prescricao_md_pck.medicamento_dose_total(medicamento_sobra_w) - quantidade_w * qt_prescricao_md_pck.medicamento_dose_total(medicamento_sobra_w);

                medicamento_prescricao_w := medicamento_sobra_w;
                medicamento_prescricao_w.quantidade := quantidade_w;

                retorno_w.medicamentos(retorno_w.medicamentos.count) := medicamento_prescricao_w;

                restante_w := 0;
            end if;
        end if;

        prescricoes_candidatas_w(prescricoes_candidatas_w.count) := retorno_w;

        -- a partir da lista de prescricoes candidatas
        -- buscar a que possui:
        --      menor perda
        --      menor quantidade de frascos
        for indice in prescricoes_candidatas_w.first..prescricoes_candidatas_w.last loop
            prescricao_candidata_w := prescricoes_candidatas_w(indice);

            -- primeira
            if (indice = prescricoes_candidatas_w.first) then
                prescricao_retorno_w := prescricao_candidata_w;
            -- menor perda
            elsif (prescricao_candidata_w.perda < prescricao_retorno_w.perda) then
                prescricao_retorno_w := prescricao_candidata_w;
            -- menor quantidade de frascos
            elsif (prescricao_candidata_w.perda = prescricao_retorno_w.perda
                and qt_prescricao_md_pck.prescricao_quantidade_total(prescricao_candidata_w) < qt_prescricao_md_pck.prescricao_quantidade_total(prescricao_retorno_w)) then
                prescricao_retorno_w := prescricao_candidata_w;
            end if;
        end loop;

        return prescricao_retorno_w;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qt_prescricao_md_pck.calcular_prescricao (dose bigint, tolerancia bigint, tabela qt_prescricao_pck.tabela_prescricao) FROM PUBLIC;
