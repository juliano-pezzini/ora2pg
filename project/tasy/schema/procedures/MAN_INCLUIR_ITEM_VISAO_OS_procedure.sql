-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_incluir_item_visao_os ( nr_seq_item_p bigint, cd_perfil_p bigint, nm_usuario_visao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_apres_w		bigint;


BEGIN

if (coalesce(nr_seq_item_p,0) <> 0) then
	begin
	select	coalesce(max(nr_seq_apres),0) + 5
	into STRICT	nr_seq_apres_w
	from	man_ordem_serv_visao;

	insert into man_ordem_serv_visao(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_apres,
			nr_seq_item,
			nm_usuario_visao,
			cd_perfil)
		values (	nextval('man_ordem_serv_visao_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_apres_w,
			nr_seq_item_p,
			nm_usuario_visao_p,
			cd_perfil_p);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_incluir_item_visao_os ( nr_seq_item_p bigint, cd_perfil_p bigint, nm_usuario_visao_p text, nm_usuario_p text) FROM PUBLIC;

