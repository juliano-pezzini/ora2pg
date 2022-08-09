-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_prescr_mipres_alteracao ( nr_sequencia_p prescr_mipres.nr_sequencia%type, ie_alteracao_p prescr_mipres_alteracao.ie_alteracao%type, ds_alteracao_p prescr_mipres_alteracao.ds_alteracao%type, ds_justificativa_p prescr_mipres_alteracao.ds_justificativa%type, ie_commit_p text default 'N') AS $body$
DECLARE


	dt_atual_s		constant prescr_mipres.dt_atualizacao%type := clock_timestamp();
	nm_usuario_w 	prescr_mipres.nm_usuario%type;


BEGIN
	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	insert into prescr_mipres_alteracao(
		nr_sequencia,
		nr_seq_prescr_mipres,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_alteracao,
		ds_alteracao,
        ds_justificativa)
	values (
		obter_nextval_sequence('PRESCR_MIPRES_ALTERACAO'),
		nr_sequencia_p,
		dt_atual_s,
		nm_usuario_w,
		dt_atual_s,
		nm_usuario_w,
		ie_alteracao_p,
		ds_alteracao_p,
        ds_justificativa_p);

	if (ie_commit_p = 'S') then
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_prescr_mipres_alteracao ( nr_sequencia_p prescr_mipres.nr_sequencia%type, ie_alteracao_p prescr_mipres_alteracao.ie_alteracao%type, ds_alteracao_p prescr_mipres_alteracao.ds_alteracao%type, ds_justificativa_p prescr_mipres_alteracao.ds_justificativa%type, ie_commit_p text default 'N') FROM PUBLIC;
