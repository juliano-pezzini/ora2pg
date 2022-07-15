-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_exclui_local_ressup_cons ( cd_local_estoque_p bigint, ie_gravar_excluir_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_gravar_excluir_p = 'G') then

	insert into w_loc_est_gestao_consig(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_local_estoque,
		dt_atualizacao)
	values (	nextval('w_loc_est_gestao_consig_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_local_estoque_p,
		clock_timestamp());

elsif (ie_gravar_excluir_p = 'E') then

	delete from w_loc_est_gestao_consig
	where	nm_usuario = nm_usuario_p
	and	cd_local_estoque = cd_local_estoque_p;

elsif (ie_gravar_excluir_p = 'T') then
	delete from w_loc_est_gestao_consig
	where	nm_usuario = nm_usuario_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_exclui_local_ressup_cons ( cd_local_estoque_p bigint, ie_gravar_excluir_p text, nm_usuario_p text) FROM PUBLIC;

