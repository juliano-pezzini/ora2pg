-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_calc_valores_sol_md_pck.calcular_etapas_e_tfase_md (qt_solucao_total_out_p bigint, qt_volume_p bigint, qt_tempo_aplicacao_p bigint, nr_etapas_interv_p INOUT bigint, nr_etapas_val_sol_p INOUT bigint, qt_hora_fase_interv_p INOUT bigint, qt_hora_fase_val_sol_p INOUT text ) AS $body$
BEGIN
    nr_etapas_interv_p     := dividir_md(qt_solucao_total_out_p,qt_volume_p);
    nr_etapas_val_sol_p    := ceil(nr_etapas_interv_p);

    qt_hora_fase_interv_p		:= dividir_md(qt_tempo_aplicacao_p,ceil(nr_etapas_interv_p));

    qt_hora_fase_val_sol_p	:= trunc(qt_hora_fase_interv_p) || ':' || substr(numtodsinterval(qt_hora_fase_interv_p, 'HOUR'), 15,2);
  end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_calc_valores_sol_md_pck.calcular_etapas_e_tfase_md (qt_solucao_total_out_p bigint, qt_volume_p bigint, qt_tempo_aplicacao_p bigint, nr_etapas_interv_p INOUT bigint, nr_etapas_val_sol_p INOUT bigint, qt_hora_fase_interv_p INOUT bigint, qt_hora_fase_val_sol_p INOUT text ) FROM PUBLIC;
