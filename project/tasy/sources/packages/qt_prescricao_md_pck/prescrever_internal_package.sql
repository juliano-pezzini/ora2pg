-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE qt_prescricao_md_pck.prescrever_internal (nr_particao_p qt_prescricao_resultado.nr_particao%type, dose bigint, medicamentos qt_prescricao_pck.medicamento_vetor, tolerancia bigint) AS $body$
DECLARE


    tabela_calculo_prescricao qt_prescricao_pck.tabela_prescricao;
    melhor_prescricao qt_prescricao_pck.prescricao;
    medicamento_w qt_prescricao_pck.medicamento;
    dt_criacao_w timestamp;


BEGIN
        dt_criacao_w := clock_timestamp();
        tabela_calculo_prescricao := qt_prescricao_md_pck.calcular_tabela(dose, medicamentos);
        melhor_prescricao := qt_prescricao_md_pck.calcular_prescricao(dose, tolerancia, tabela_calculo_prescricao);

        for indice in melhor_prescricao.medicamentos.first..melhor_prescricao.medicamentos.last loop
            medicamento_w := melhor_prescricao.medicamentos(indice);
            insert into qt_prescricao_resultado(nr_sequencia, nr_particao, dt_criacao,
                cd_material,
                qt_dose,
                cd_unidade_medida,
                qt_quantidade)
            values (nextval('qt_prescricao_resultado_seq'), nr_particao_p, dt_criacao_w,
                medicamento_w.codigo,
                medicamento_w.dose,
                medicamento_w.unidade_medida,
                medicamento_w.quantidade);
        end loop;
    end;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_prescricao_md_pck.prescrever_internal (nr_particao_p qt_prescricao_resultado.nr_particao%type, dose bigint, medicamentos qt_prescricao_pck.medicamento_vetor, tolerancia bigint) FROM PUBLIC;