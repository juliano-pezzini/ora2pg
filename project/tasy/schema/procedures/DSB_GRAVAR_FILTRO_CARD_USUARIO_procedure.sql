-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dsb_gravar_filtro_card_usuario ( nr_seq_card_p bigint, nm_usuario_p text, ds_filtro_p text, nm_filtro_p text, ds_sql_filtro_p text, cd_perfil_p text, ie_processo_p text default null) AS $body$
BEGIN

if (length(ds_filtro_p) > 4000) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(109994);
end if;

insert	into dsb_usuario_filtro_ind(nr_sequencia,
	nr_seq_card,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_filtro,
	ds_sql_filtro,
	nm_filtro,
	cd_perfil)
values (nextval('dsb_usuario_filtro_ind_seq'),
	nr_seq_card_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_filtro_p,
	ds_sql_filtro_p,
	nm_filtro_p,
	cd_perfil_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dsb_gravar_filtro_card_usuario ( nr_seq_card_p bigint, nm_usuario_p text, ds_filtro_p text, nm_filtro_p text, ds_sql_filtro_p text, cd_perfil_p text, ie_processo_p text default null) FROM PUBLIC;

