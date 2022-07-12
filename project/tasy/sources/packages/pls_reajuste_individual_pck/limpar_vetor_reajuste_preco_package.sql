-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_individual_pck.limpar_vetor_reajuste_preco () AS $body$
BEGIN
tb_vl_base_w.delete;
tb_vl_reajustado_w.delete;
tb_vl_preco_nao_subsid_base_w.delete;
tb_vl_preco_nao_subsidiado_w.delete;
tb_vl_adaptacao_base_w.delete;
tb_vl_adaptacao_w.delete;
tb_vl_minimo_w.delete;
tb_vl_minimo_base_w.delete;
tb_nr_seq_preco_w.delete;
tb_pr_reajuste_w.delete;
tb_dt_reajuste_w.delete;
tb_nr_seq_reaj_tabela_w.delete;
nr_indice_reaj_preco_desf_w	:= 0;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_individual_pck.limpar_vetor_reajuste_preco () FROM PUBLIC;