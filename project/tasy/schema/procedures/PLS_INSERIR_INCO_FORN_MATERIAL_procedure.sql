-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_inco_forn_material ( nr_seq_fornecedor_p bigint, ie_tipo_incon_p text, ds_inconsistencia_p text, nm_usuario_p text) AS $body$
BEGIN

insert into pls_fornec_mat_fed_sc_inc(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
		nr_seq_fornecedor,ds_inconsistencia,ie_tipo_inconsistencia)
values (	nextval('pls_fornec_mat_fed_sc_inc_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
		nr_seq_fornecedor_p,ds_inconsistencia_p,ie_tipo_incon_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_inco_forn_material ( nr_seq_fornecedor_p bigint, ie_tipo_incon_p text, ds_inconsistencia_p text, nm_usuario_p text) FROM PUBLIC;
