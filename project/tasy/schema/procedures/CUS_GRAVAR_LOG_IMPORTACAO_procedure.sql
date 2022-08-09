-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_gravar_log_importacao ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_centro_controle_p bigint, cd_natureza_gasto_p bigint, ie_tipo_importacao_p bigint, ds_importacao_p text, vl_orcado_p bigint, nm_usuario_p text, nr_seq_mes_ref_p bigint default null) AS $body$
BEGIN

insert into orcamento_custo_import(
	nr_sequencia,
	cd_estabelecimento,
	cd_tabela_custo,
	cd_centro_controle,
	cd_natureza_gasto,
	ie_tipo_importacao,
	ds_importacao,
	dt_importacao,
	dt_atualizacao,
	nm_usuario,
	vl_orcado,
	nr_seq_mes_ref)
values (	nextval('orcamento_custo_import_seq'),
	cd_estabelecimento_p,
	cd_tabela_custo_p,
	cd_centro_controle_p,
	cd_natureza_gasto_p,
	ie_tipo_importacao_p,
	ds_importacao_p,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	vl_orcado_p,
	nr_seq_mes_ref_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_gravar_log_importacao ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_centro_controle_p bigint, cd_natureza_gasto_p bigint, ie_tipo_importacao_p bigint, ds_importacao_p text, vl_orcado_p bigint, nm_usuario_p text, nr_seq_mes_ref_p bigint default null) FROM PUBLIC;
