-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_pck.limpar_vetor_seg_preco_origem () AS $body$
BEGIN
tb_nr_seq_segurado_w.delete;
tb_nr_seq_plano_w.delete;
tb_vl_preco_sca_w.delete;
tb_nr_seq_tabela_w.delete;
tb_nr_seq_plano_preco_w.delete;
tb_qt_idade_w.delete;
tb_vl_preco_ant_sca_w.delete;
tb_nr_seq_reajuste_sca_w.delete;
tb_nr_seq_vinculo_sca_w.delete;
nr_indice_inserir_sca_w	:= 0;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_pck.limpar_vetor_seg_preco_origem () FROM PUBLIC;