-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mov_benef_imp_pck.inserir_inconsistencia (nr_seq_lote_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, nr_seq_beneficiario_p bigint, nr_seq_carencia_p bigint, nr_seq_sca_p bigint, nr_seq_complemento_p bigint, nr_seq_inconsistencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
insert	into	pls_mov_benef_lote_incons(	nr_sequencia, nr_seq_lote, dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_seq_contrato, nr_seq_plano, nr_seq_beneficiario, nr_seq_carencia,
		nr_seq_sca, nr_seq_complemento, nr_seq_inconsistencia)
	values (	nextval('pls_mov_benef_lote_incons_seq'), nr_seq_lote_p, clock_timestamp(), nm_usuario_p, clock_timestamp(), 
		nm_usuario_p, nr_seq_contrato_p, nr_seq_plano_p, nr_seq_beneficiario_p, nr_seq_carencia_p,
		nr_seq_sca_p, nr_seq_complemento_p, nr_seq_inconsistencia_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_imp_pck.inserir_inconsistencia (nr_seq_lote_p bigint, nr_seq_contrato_p bigint, nr_seq_plano_p bigint, nr_seq_beneficiario_p bigint, nr_seq_carencia_p bigint, nr_seq_sca_p bigint, nr_seq_complemento_p bigint, nr_seq_inconsistencia_p bigint, nm_usuario_p text) FROM PUBLIC;
