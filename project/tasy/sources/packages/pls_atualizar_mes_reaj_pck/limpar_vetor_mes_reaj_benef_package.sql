-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.limpar_vetor_mes_reaj_benef () AS $body$
BEGIN
current_setting('pls_atualizar_mes_reaj_pck.tb_nr_seq_segurado_w')::pls_util_cta_pck.t_number_table.delete;
current_setting('pls_atualizar_mes_reaj_pck.tb_nr_mes_reajuste_w')::pls_util_cta_pck.t_number_table.delete;
PERFORM set_config('pls_atualizar_mes_reaj_pck.nr_indice_att_mes_benef_w', 0, false);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.limpar_vetor_mes_reaj_benef () FROM PUBLIC;
