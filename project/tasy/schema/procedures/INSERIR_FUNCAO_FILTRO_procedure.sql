-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_funcao_filtro (cd_funcao_p bigint, ds_campo_p text, ds_filtro_p text, nr_seq_filtro_p bigint, vl_campo_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into funcao_filtro(
		nr_sequencia,
		cd_estabelecimento,
		cd_funcao,
		ds_campo,
		ie_tipo_campo,
		ie_tipo_filtro,
		ds_filtro,
		nr_seq_filtro,
		vl_campo,
		--cd_perfil,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nm_usuario_ref)
values (nextval('funcao_filtro_seq'),
		cd_estabelecimento_p,
		cd_funcao_p,
		ds_campo_p,
		'N',
		'D',
		ds_filtro_p,
		nr_seq_filtro_p,
		vl_campo_p,
		--cd_perfil_p,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_funcao_filtro (cd_funcao_p bigint, ds_campo_p text, ds_filtro_p text, nr_seq_filtro_p bigint, vl_campo_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
