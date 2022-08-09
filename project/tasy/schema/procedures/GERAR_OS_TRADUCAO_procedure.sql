-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_os_traducao ( nm_usuario_p text, ds_dano_breve_p text, ds_dano_p text, cd_funcao_p bigint, ds_historico_p text, nr_seq_ordem_p INOUT bigint) AS $body$
DECLARE


nr_seq_ordem_w		bigint;
nm_usuario_exec_w	varchar(255);
cd_pessoa_fisica_w	bigint;


BEGIN
	select	nextval('man_ordem_servico_seq')
	into STRICT	nr_seq_ordem_w
	;

	select	coalesce(obter_pessoa_fisica_usuario(nm_usuario_p, 'C'), obter_pessoa_fisica_usuario('msftodaro', 'C'))
	into STRICT	cd_pessoa_fisica_w
	;

	insert into man_ordem_servico(
		nr_sequencia,
		cd_pessoa_solicitante,
		dt_ordem_servico,
		ie_prioridade,
		ie_parado,
		ds_dano_breve,
		dt_atualizacao,
		nm_usuario,
		ds_dano,
		ie_tipo_ordem,
		ie_plataforma,
		ie_classificacao,
		nr_seq_estagio,
		nr_seq_complex,
		nr_seq_equipamento,
		nr_seq_localizacao,
		nr_grupo_trabalho,
		nr_grupo_planej,
		ie_resp_teste,
		cd_funcao,
		nr_seq_grupo_des,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_status_ordem,
		ie_origem_os)
	values (	nr_seq_ordem_w,
			cd_pessoa_fisica_w,
			clock_timestamp(),
			'M',
			'N',
			ds_dano_breve_p,
			clock_timestamp(),
			nm_usuario_p,
			ds_dano_p,
			1,
			'H',
			'S',
			1051,
			2,
			1395,
			1272,
			2,
			2,
			'A',
			(SELECT cd_funcao from funcao where cd_funcao = cd_funcao_p),
			374,
			clock_timestamp(),
			nm_usuario_p,
			1,
			1 );

	insert into man_ordem_serv_tecnico(
		nr_sequencia,
		nr_seq_ordem_serv,
		dt_atualizacao,
		nm_usuario,
		dt_historico,
		dt_liberacao,
		nm_usuario_lib,
		ds_relat_tecnico,
		nr_seq_tipo)
	values (	nextval('man_ordem_serv_tecnico_seq'),
			nr_seq_ordem_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			ds_historico_p,
			1);

nr_seq_ordem_p := nr_seq_ordem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_os_traducao ( nm_usuario_p text, ds_dano_breve_p text, ds_dano_p text, cd_funcao_p bigint, ds_historico_p text, nr_seq_ordem_p INOUT bigint) FROM PUBLIC;
