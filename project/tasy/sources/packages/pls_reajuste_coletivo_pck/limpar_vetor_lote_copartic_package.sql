-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_coletivo_pck.limpar_vetor_lote_copartic () AS $body$
BEGIN
tb_tx_reajuste_copartic_w.delete;
tb_tx_reajuste_vl_maximo_w.delete;
tb_ie_vinculo_coparticipacao_w.delete;
tb_nr_seq_contrato_copartic_w.delete;
tb_nr_seq_interc_copartic_w.delete;
nr_indice_lote_copartic_w	:= 0;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_coletivo_pck.limpar_vetor_lote_copartic () FROM PUBLIC;