-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_pck.limpar_vetor_inserir_pos_estab () AS $body$
BEGIN
tb_nr_seq_regra_pos_estab_w.delete;
tb_nr_seq_reaj_pos_estab_w.delete;
tb_vl_reajustado_w.delete;
current_setting('pls_reajuste_pck.tb_nr_seq_intercambio_w')::pls_util_cta_pck.t_number_table.delete;
tb_nr_seq_contrato_w.delete;
tb_ie_cobranca_w.delete;
tb_tx_administracao_w.delete;
tb_ie_autorizacao_previa_w.delete;
tb_nr_seq_grupo_servico_w.delete;
tb_nr_seq_grupo_material_w.delete;
tb_ie_repassa_medico_w.delete;
nr_indice_regra_pos_estab_w	:= 1;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_pck.limpar_vetor_inserir_pos_estab () FROM PUBLIC;