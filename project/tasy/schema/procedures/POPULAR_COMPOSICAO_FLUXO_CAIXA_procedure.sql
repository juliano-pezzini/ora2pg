-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE popular_composicao_fluxo_caixa (nr_seq_regra_p bigint, ds_composicao_p text, vl_composicao_p bigint, nr_ordem_apres_p bigint, nm_usuario_p text, ie_commit_p text, cd_moeda_p bigint default null) AS $body$
BEGIN

insert	into composicao_fluxo_caixa(ds_composicao,
	dt_atualizacao,
	dt_atualizacao_nrec,
	nm_usuario,
	nm_usuario_nrec,
	nr_ordem_apres,
	nr_seq_regra,
	vl_composicao,
	cd_moeda)
values (ds_composicao_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nm_usuario_p,
	nr_ordem_apres_p,
	nr_seq_regra_p,
	vl_composicao_p,
	cd_moeda_p);

if (coalesce(ie_commit_p,'N')	= 'S') then

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE popular_composicao_fluxo_caixa (nr_seq_regra_p bigint, ds_composicao_p text, vl_composicao_p bigint, nr_ordem_apres_p bigint, nm_usuario_p text, ie_commit_p text, cd_moeda_p bigint default null) FROM PUBLIC;
