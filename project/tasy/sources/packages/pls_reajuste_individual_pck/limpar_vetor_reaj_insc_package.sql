-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_individual_pck.limpar_vetor_reaj_insc () AS $body$
BEGIN
tb_vl_base_insc_w.delete;
tb_vl_reajustado_insc_w.delete;
tb_tx_reajuste_insc_w.delete;
tb_nr_seq_lote_reaj_insc_w.delete;
tb_nr_seq_regra_inscricao_w.delete;
tb_ie_origem_inscricao_w.delete;
nr_indice_desf_reajuste_insc_w	:= 0;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_individual_pck.limpar_vetor_reaj_insc () FROM PUBLIC;
