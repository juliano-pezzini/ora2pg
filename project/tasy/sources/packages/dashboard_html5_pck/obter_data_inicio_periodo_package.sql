-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dashboard_html5_pck.obter_data_inicio_periodo (dt_ref_p timestamp, nr_periodo_p bigint) RETURNS timestamp AS $body$
DECLARE

        /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Finalidade:  Obter data do primeiro dia de um periodo (semana ou mes) com base na data de referencia
        ---------------------------------------------------------------------------------------------------------------------------------------------

        Locais de chamada direta: 
        [  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [X] Outros: Procedure gera_overview_tela e '
         --------------------------------------------------------------------------------------------------------------------------------------------

        Pontos de atencao:
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

        dt_periodo_w       timestamp;
        qt_periodos_w      integer;
        qt_dif_dias_w      integer;
        nr_dia_semana_w    integer;
        nr_periodo_ref_w   integer;
        dt_ini_periodo_ref timestamp;

BEGIN
    
        /*obtem dia da semana da data de referencia*/


        nr_dia_semana_w := to_char(dt_ref_p, 'd');

        /*obtem diferenca de dias entre data referencia e inicio da semana (segunda-feira) */


        case
            when nr_dia_semana_w = 1 then
                qt_dif_dias_w := 6;
            when nr_dia_semana_w = 2 then
                qt_dif_dias_w := 0;
            when nr_dia_semana_w = 3 then
                qt_dif_dias_w := 1;
            when nr_dia_semana_w = 4 then
                qt_dif_dias_w := 2;
            when nr_dia_semana_w = 5 then
                qt_dif_dias_w := 3;
            when nr_dia_semana_w = 6 then
                qt_dif_dias_w := 4;
            when nr_dia_semana_w = 7 then
                qt_dif_dias_w := 5;
        end case;

        /*obtem data inicial do periodo de referencia*/


        dt_ini_periodo_ref := (dt_ref_p - qt_dif_dias_w);

        /*obtem numero do periodo da data de referencia*/


        nr_periodo_ref_w := to_char(dt_ref_p, 'iw');

        if (nr_periodo_p > nr_periodo_ref_w) then
            --obtem qt periodos 

            qt_periodos_w := (nr_periodo_p - nr_periodo_ref_w);

            --Obtem primeira data do periodo

            dt_periodo_w := dt_ini_periodo_ref + (qt_periodos_w * 7);
        elsif (nr_periodo_p < nr_periodo_ref_w) then
            qt_periodos_w := (nr_periodo_ref_w - nr_periodo_p);

            --Obtem primeira data do periodo

            dt_periodo_w := dt_ini_periodo_ref - (qt_periodos_w * 7);
        else
            --Obtem primeira data do periodo

            dt_periodo_w := dt_ini_periodo_ref;
        end if;

        return dt_periodo_w;

    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION dashboard_html5_pck.obter_data_inicio_periodo (dt_ref_p timestamp, nr_periodo_p bigint) FROM PUBLIC;