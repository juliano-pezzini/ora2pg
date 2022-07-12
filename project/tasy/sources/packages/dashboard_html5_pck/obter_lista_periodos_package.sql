-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dashboard_html5_pck.obter_lista_periodos (dt_ref_p timestamp, ie_periodo_p text, qt_periodo_p integer, periodos_p INOUT def_tabela) AS $body$
DECLARE

        nr_periodo_w             integer;
        nr_ult_semana_mes_dt_ref integer;
        nr_ult_semana_ano_dt_ref integer;
        nr_semana_inicio_mes     integer;
        nr_semana_fim_mes        integer;
        dt_periodo_w             timestamp;

        /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Finalidade:  Obter lista de periodos para inserir na tabela funcoes_hml5_over_semana
        ---------------------------------------------------------------------------------------------------------------------------------------------

        Locais de chamada direta: 
        [  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [X] Outros: Procedure gera_overview_tela
         --------------------------------------------------------------------------------------------------------------------------------------------

        Pontos de atencao:
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

    
BEGIN
        periodos_p := def_tabela();

        if (ie_periodo_p = 'S') then
            --numero da semana da data inicial

            nr_periodo_w             := to_char(dt_ref_p, 'iw');
            nr_ult_semana_ano_dt_ref := to_char(to_date('31/12/' || to_char(dt_ref_p, 'yyyy')), 'iw');

            dt_periodo_w := dt_ref_p;
            for i in 1 .. qt_periodo_p loop
                periodos_p.extend;
                periodos_p[i].ds_periodo := ie_periodo_p || nr_periodo_w;
                if nr_periodo_w > nr_ult_semana_ano_dt_ref then
                    periodos_p[i].nr_periodo_ini := nr_periodo_w - nr_ult_semana_ano_dt_ref;
                    periodos_p[i].nr_periodo_fim := nr_periodo_w - nr_ult_semana_ano_dt_ref;
                else
                    periodos_p[i].nr_periodo_ini := nr_periodo_w;
                    periodos_p[i].nr_periodo_fim := nr_periodo_w;
                end if;
                periodos_p[i].dt_ini_periodo := dashboard_html5_pck.obter_data_inicio_periodo(dt_periodo_w, nr_periodo_w);
                periodos_p[i].dt_fim_periodo := periodos_p[i].dt_ini_periodo + 6;

                --incrementa semana

                nr_periodo_w := nr_periodo_w + 1;
            end loop;
        end if;

        if (ie_periodo_p = 'M') then
            nr_ult_semana_mes_dt_ref := to_char(last_day(dt_ref_p), 'iw');

            for i in 1 .. qt_periodo_p loop
                /*incrementa mes*/


                dt_periodo_w := add_months(trunc(dt_ref_p, 'mm'), i);

                nr_semana_inicio_mes := to_char(dt_periodo_w, 'iw');
                nr_semana_fim_mes    := to_char(last_day(dt_periodo_w), 'iw');

                if nr_ult_semana_mes_dt_ref = nr_semana_inicio_mes then
                    nr_semana_inicio_mes := nr_semana_inicio_mes + 1;
                end if;

                dt_periodo_w         := dashboard_html5_pck.obter_data_inicio_periodo(dt_periodo_w, nr_semana_inicio_mes);
                nr_semana_inicio_mes := to_char(dt_periodo_w, 'iw');

                periodos_p.extend;
                periodos_p[i].ds_periodo := ie_periodo_p || i;
                periodos_p[i].dt_ini_periodo := dt_periodo_w;
                periodos_p[i].nr_periodo_ini := nr_semana_inicio_mes;
                periodos_p[i].nr_periodo_fim := nr_semana_fim_mes;

                periodos_p[i].dt_fim_periodo := dashboard_html5_pck.obter_data_inicio_periodo(dt_periodo_w, nr_semana_fim_mes);
                periodos_p[i].dt_fim_periodo := periodos_p[i].dt_fim_periodo + 6;

                nr_ult_semana_mes_dt_ref := to_char(last_day(dt_periodo_w), 'iw');
            end loop;
        end if;
    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_html5_pck.obter_lista_periodos (dt_ref_p timestamp, ie_periodo_p text, qt_periodo_p integer, periodos_p INOUT def_tabela) FROM PUBLIC;