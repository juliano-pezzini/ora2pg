-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_param_visita () AS $body$
BEGIN

insert into 	FUNCAO_PARAM_ESTAB(
		nr_sequencia,
		cd_funcao,
		nr_seq_param,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		dt_atualizacao_nrec,
		nm_usuario_nrec)
 	SELECT	nextval('funcao_param_estab_seq'),
		8014,
		nr_seq_param,
		cd_estabelecimento,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		dt_atualizacao_nrec,
		nm_usuario_nrec
	from 	FUNCAO_PARAM_ESTAB
	where	cd_funcao = -1009;


insert into 	FUNCAO_PARAM_HIST(
		nr_sequencia,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		cd_funcao,
		nr_seq_param,
		ds_objetivo,
		ds_tecnica)
 	SELECT	nextval('funcao_param_hist_seq'),
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_atualizacao,
		nm_usuario,
		8014,
		nr_seq_param,
		ds_objetivo,
		ds_tecnica
	from 	FUNCAO_PARAM_HIST
	where	cd_funcao = -1009;

insert into	FUNCAO_PARAM_PERFIL(
		cd_funcao,
		nr_sequencia,
		cd_perfil,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		ds_observacao)
	SELECT	8014,
		nr_sequencia,
		cd_perfil,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		ds_observacao
	from	FUNCAO_PARAM_PERFIL
	where	cd_funcao = -1009;

insert into 	FUNCAO_PARAM_USUARIO(
		cd_funcao,
		nr_sequencia,
		nm_usuario_param,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		ds_observacao)
	SELECT	8014,
		nr_sequencia,
		nm_usuario_param,
		dt_atualizacao,
		nm_usuario,
		vl_parametro,
		ds_observacao
	from	FUNCAO_PARAM_USUARIO
	where	cd_funcao = -1009;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_param_visita () FROM PUBLIC;

