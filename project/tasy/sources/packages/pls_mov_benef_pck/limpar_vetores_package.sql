-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_benef_pck.limpar_vetores () AS $body$
BEGIN
		nr_indice_w := 0;
		tb_nr_seq_mov_contrato_w.delete;
		tb_nr_seq_plano_w.delete;
		tb_cd_plano_intercambio_w.delete;
		tb_cd_segmentacao_w.delete;
		tb_cd_plano_origem_w.delete;
		tb_nr_protocolo_ans_w.delete;
		tb_ds_plano_origem_w.delete;
		tb_ie_tipo_contratacao_w.delete;
		tb_ie_abrangencia_w.delete;
		tb_ie_regulamentacao_w.delete;
		tb_cd_operadora_ans_w.delete;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_pck.limpar_vetores () FROM PUBLIC;
