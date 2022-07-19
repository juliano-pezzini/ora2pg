-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_os_field_marketing ( nr_seq_projeto_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_gerencia_p bigint, nr_ordem_servico_p INOUT text, nr_seq_ficha_p bigint default null) AS $body$
DECLARE


ds_titulo_w		varchar(255);
nm_usuario_exec_w	varchar(255);
qt_os_finalizacao_w	bigint;
nr_seq_grupo_des_w	bigint;
qt_registro_w		bigint;
ie_marketing_w		varchar(1);


BEGIN

if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') then
	select	ds_titulo
	into STRICT	ds_titulo_w
	from	proj_projeto
	where	nr_sequencia	= nr_seq_projeto_p;

	select	nextval('man_ordem_servico_seq')
	into STRICT	nr_ordem_servico_p
	;

	select	c.nr_seq_grupo,
		b.nm_usuario
	into STRICT	nr_seq_grupo_des_w,
		nm_usuario_exec_w
	from	usuario_grupo_des c,
		usuario b,
		gerencia_wheb a
	where	a.nr_sequencia     = nr_seq_gerencia_p
	and	a.cd_responsavel   = b.cd_pessoa_fisica
	and	c.nm_usuario_grupo = b.nm_usuario;

	select	count(*)
	into STRICT	qt_registro_w
	from	man_equipamento
	where	nr_sequencia = 41
	and	ie_situacao = 'A';

	if (qt_registro_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248391);
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	man_localizacao
	where	nr_sequencia = 1272
	and	ie_situacao = 'A';

	if (qt_registro_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248392);
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	man_estagio_processo
	where	nr_sequencia = 402
	and	ie_situacao = 'A';

	if (qt_registro_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248404);
	end if;

	insert into man_ordem_servico(ds_dano_breve,
		ds_dano,
		nr_sequencia,
		cd_pessoa_solicitante /*Usuário*/
,
		ie_classificacao,
		ie_tipo_ordem,
		nr_seq_localizacao,
		nr_seq_equipamento,
		dt_ordem_servico,
		ie_prioridade,
		ie_parado,
		dt_atualizacao,
		nm_usuario,
		nr_seq_estagio,
		nr_seq_grupo_des,
		ie_origem_os,
		ie_status_ordem,
		nr_grupo_trabalho,
		nr_grupo_planej)
	values (substr('Proj.' || nr_seq_projeto_p ||' - ' || ds_titulo_w || ' - Necessidade marketing',1,80),
		'Projeto: ' || ds_titulo_w || '.'|| chr(13) || 'Insira nesta ordem as informações relevantes do projeto encerrado, como anexos, news, etc.',
		nr_ordem_servico_p,
		cd_pessoa_fisica_p,
		'S',
		'3',
		1272, /*Localização do projeto logado   1272*/
		41, /* Sistema Tasy */
		clock_timestamp(),
		'B',
		'N',
		clock_timestamp(),
		nm_usuario_p,
		402, /*1251 - Treinamento      402 - Mark*/
		nr_seq_grupo_des_w,
		1,
		1,
		54, /* 53 - Treinamento,    54 Mark*/
		61 /*61 Planejamento*/
);

	insert into proj_ordem_servico(nr_sequencia,
		nr_seq_ordem,
		nr_seq_proj,
		ie_os_finalizacao,
		nm_usuario,
		dt_atualizacao)
	values (nextval('proj_ordem_servico_seq'),
		nr_ordem_servico_p,
		nr_seq_projeto_p,
		'S',
		nm_usuario_p,
		clock_timestamp());

	insert into man_ordem_servico_exec(nr_seq_ordem,
		nm_usuario,
		nm_usuario_exec,
		nr_sequencia,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		qt_min_prev)
	values (nr_ordem_servico_p,
		nm_usuario_p,
		nm_usuario_exec_w,
		nextval('man_ordem_servico_exec_seq'),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		45);

		update	proj_ficha_projeto
		set		nr_ordem_field_marketing = nr_ordem_servico_p
		where	nr_sequencia = nr_seq_ficha_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_os_field_marketing ( nr_seq_projeto_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_seq_gerencia_p bigint, nr_ordem_servico_p INOUT text, nr_seq_ficha_p bigint default null) FROM PUBLIC;

