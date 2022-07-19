-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_atendimento_grupo ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (pkg_i18n.get_user_locale() = 'ja_JP') then
	insert into pac_grupo_atend(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_grupo,
		nr_atendimento,
		ie_situacao,
		dt_entrada,
		cd_pessoa_fisica)
	SELECT	nextval('pac_grupo_atend_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_grupo_p,
		CASE WHEN ie_opcao_p=0 THEN nr_atendimento_p END ,
		'A',
		clock_timestamp(),
		cd_pessoa_fisica_p
	
	where	not exists (	SELECT	1
				from	pac_grupo_atend
				where	nr_atendimento 	= nr_atendimento_p
				and	nr_seq_grupo	= nr_seq_grupo_p
				and	coalesce(dt_saida::text, '') = ''
				and 	ie_opcao_p = 0
				
union

				select	1 
				from	pac_grupo_atend
				where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
				and	nr_seq_grupo		= nr_seq_grupo_p
				and	coalesce(dt_saida::text, '') = ''
				and 	ie_opcao_p = 1);
else
	insert into pac_grupo_atend(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_grupo,
		nr_atendimento,
		ie_situacao,
		dt_entrada,
		cd_pessoa_fisica)
	SELECT	nextval('pac_grupo_atend_seq'),
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_grupo_p,
		CASE WHEN ie_opcao_p=0 THEN nr_atendimento_p END ,
		'A',
		clock_timestamp(),
		cd_pessoa_fisica_p
	
	where	not exists (	SELECT	1
				from	pac_grupo_atend
				where	nr_atendimento 	= nr_atendimento_p
				and	nr_seq_grupo	= nr_seq_grupo_p
				and	coalesce(dt_saida::text, '') = ''
				
union

				select	1 
				from	pac_grupo_atend
				where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
				and	nr_seq_grupo		= nr_seq_grupo_p
				and	coalesce(dt_saida::text, '') = '');
end if;
				
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_atendimento_grupo ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text) FROM PUBLIC;

