-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_os_revisao_testes_migr ( nr_seq_projeto_p bigint, ie_prioridade_revisao_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_os_proj_migr_w		bigint;
cd_funcao_projeto_w		integer;
nr_seq_grupo_des_w		bigint;
nm_usuario_testes_w		varchar(15);
nr_seq_os_teste_w		bigint;
ds_dano_w			varchar(4000);
ie_res_tes_anal_migr_w		varchar(1);
nr_seq_os_tes_anal_migr_w	bigint;

dt_atualizacao_w		timestamp;
nm_usuario_w			varchar(15);
ds_relat_tecnico_w		text;
cd_versao_tasy_w		varchar(15);
dt_historico_w			timestamp;
ie_origem_w			varchar(1);
nr_seq_tipo_w			bigint;
dt_liberacao_w			timestamp;
nm_usuario_lib_w		varchar(15);
ie_grau_satisfacao_w		varchar(3);
dt_envio_w			timestamp;

c01 CURSOR FOR
SELECT	dt_atualizacao,
	nm_usuario,
	ds_relat_tecnico,
	cd_versao_tasy,
	dt_historico,
	ie_origem,
	nr_seq_tipo,
	dt_liberacao,
	nm_usuario_lib,
	ie_grau_satisfacao,
	dt_envio
from	man_ordem_serv_tecnico
where	nr_seq_ordem_serv = nr_seq_os_tes_anal_migr_w
and	nr_seq_tipo = 52;

c02 CURSOR FOR
SELECT	u.nm_usuario
from	usuario u,
	proj_equipe_papel ep
where	u.cd_pessoa_fisica = ep.cd_pessoa_fisica
and	ep.ie_funcao_rec_migr = 'T'
and	exists (
		SELECT	1
		from	proj_equipe e,
			proj_projeto p
		where	ep.nr_seq_equipe = e.nr_sequencia
		and	e.nr_seq_proj = p.nr_sequencia
		and	p.nr_seq_gerencia = 9
		and	p.nr_seq_classif = 14
		and	p.nr_sequencia = nr_seq_projeto_p);


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	select	nr_seq_ordem_serv,
		cd_funcao,
		nr_seq_grupo_des
	into STRICT	nr_seq_os_proj_migr_w,
		cd_funcao_projeto_w,
		nr_seq_grupo_des_w
	from	proj_projeto
	where	nr_sequencia = nr_seq_projeto_p;

	ds_dano_w	:= 'Migração: revisão referente ao projeto: ' ||
			cd_funcao_projeto_w || ' - ' || obter_desc_funcao(cd_funcao_projeto_w) || ' (' || obter_form_funcao(cd_funcao_projeto_w) || ').' || chr(13) || chr(10) || chr(13) || chr(10);

	ds_dano_w	:= 'Realizar a revisão do projeto em questão para permitir a execução adequadada dos testes pelos analistas responsáveis pelo mesmo em seguida. ' || chr(13) || chr(10) ||
			'Aspectos a serem considerados na revisão:' || chr(13) || chr(10) ||
			'- Solicitar a configuração de parâmetros do analista Delphi responsável pelo projeto a fim de garantir uma verificação mais adequada;' || chr(13) || chr(10) ||
			'- Compatibilidade entre os ambientes Delphi e Java: realizar a verificação/validação a fim de observar e garantir o funcionamento/utilização idêntico nos dois ambientes;' ||
			' Testar e adequar o sistema neste sentido, caso necessário;' || chr(13) || chr(10) ||
			'- Dependências/Documentações: realizar a verificação/validação das dependências e/ou documentações registradas em relação ao projeto;' ||
			' Testar e adequar o sistema neste sentido, caso necessário, e atualizar o estágio/situação destes registros, inclusive em relação ao cronograma;' || chr(13) || chr(10) ||
			'- Utilização: independentemente de existirem registros de dependências/documentações realizar o processo básico a fim de verificar a existência de erros,' ||
			' e, ajustar as possíveis situações encontradas;' || chr(13) || chr(10) ||
			'- Performance;' || chr(13) || chr(10) ||
			'- Layout;' || chr(13) || chr(10) || chr(13) || chr(10) ||
			'Após a realização deste processo, documentar as atividades realizadas e um histórico referente a cada um dos tópicos acima, bem como, referente a outras situações possíveis identificadas,'||
			' e, encerrar esta Ordem de Serviço.';

	select	nextval('man_ordem_servico_seq')
	into STRICT	nr_seq_os_teste_w
	;

	insert into man_ordem_servico(
		nr_sequencia,
		dt_ordem_servico,
		cd_pessoa_solicitante,
		nr_seq_localizacao,
		nr_seq_equipamento,
		ds_dano_breve,
		ie_prioridade,
		ds_dano,
		cd_funcao,
		nr_seq_grupo_des,
		ie_classificacao,
		ie_tipo_ordem,
		ie_status_ordem,
		dt_inicio_previsto,
		dt_fim_previsto,
		dt_inicio_desejado,
		dt_conclusao_desejada,
		nr_seq_estagio,
		nr_grupo_trabalho,
		nr_grupo_planej,
		nm_usuario,
		dt_atualizacao,
		ie_parado,
		ie_obriga_news,
		ie_exclusiva,
		ie_origem_os,
		nr_seq_classif,
		nr_seq_nivel_valor,
		nr_seq_origem,
		ie_prioridade_desen)
	values (
		nr_seq_os_teste_w,
		coalesce(dt_referencia_p,clock_timestamp()),
		'4464',
		1272,
		41,
		'Migração: revisão do projeto ' || obter_form_funcao(cd_funcao_projeto_w),
		'A',
		ds_dano_w,
		cd_funcao_projeto_w,
		nr_seq_grupo_des_w,
		'S',
		4,
		'2',
		coalesce(dt_referencia_p,clock_timestamp()),
		coalesce(dt_referencia_p,clock_timestamp()) + 1,
		coalesce(dt_referencia_p,clock_timestamp()),
		coalesce(dt_referencia_p,clock_timestamp()) + 1,
		732,
		2,
		1,
		nm_usuario_p,
		coalesce(dt_referencia_p,clock_timestamp()),
		'N',
		'N',
		'P',
		'1',
		22,
		1,
		nr_seq_os_proj_migr_w,
		ie_prioridade_revisao_p);

	delete
	from	man_ordem_servico_exec
	where	nr_seq_ordem = nr_seq_os_teste_w;

	delete
	from	man_ordem_ativ_prev
	where	nr_seq_ordem_serv = nr_seq_os_teste_w;

	/*insert into man_ordem_servico_exec (
		nr_sequencia,
		nr_seq_ordem,
		dt_atualizacao,
		nm_usuario,
		nm_usuario_exec,
		qt_min_prev,
		dt_ult_visao,
		nr_seq_funcao,
		dt_recebimento,
		nr_seq_tipo_exec)
	values (
		man_ordem_servico_exec_seq.nextval,
		nr_seq_os_teste_w,
		sysdate,
		nm_usuario_p,
		'Rafael',
		null,
		null,
		null,
		null,
		3);*/
	open c02;
	loop
	fetch c02 into nm_usuario_testes_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		insert into man_ordem_servico_exec(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			nm_usuario_exec,
			qt_min_prev,
			dt_ult_visao,
			nr_seq_funcao,
			dt_recebimento,
			nr_seq_tipo_exec)
		values (
			nextval('man_ordem_servico_exec_seq'),
			nr_seq_os_teste_w,
			coalesce(dt_referencia_p,clock_timestamp()),
			nm_usuario_p,
			nm_usuario_testes_w,
			60,
			null,
			null,
			null,
			2);
		end;
	end loop;
	close c02;

	insert into proj_ordem_servico(
		nr_sequencia,
		nr_seq_proj,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_ordem,
		ie_tipo_ordem)
	values (
		nextval('proj_ordem_servico_seq'),
		nr_seq_projeto_p,
		coalesce(dt_referencia_p,clock_timestamp()),
		nm_usuario_p,
		coalesce(dt_referencia_p,clock_timestamp()),
		nm_usuario_p,
		nr_seq_os_teste_w,
		'U');

	select	coalesce(max(ie_result_testes_analista_migr),'N')
	into STRICT	ie_res_tes_anal_migr_w
	from	w_plan_teste_migr_proj
	where	nr_seq_projeto = nr_seq_projeto_p;

	--if	(ie_res_tes_anal_migr_w = 'O') then
		begin
		select	max(nr_seq_os)
		into STRICT	nr_seq_os_tes_anal_migr_w
		from	os_teste_analista_migracao_v
		where	nr_seq_projeto = nr_seq_projeto_p;

		open c01;
		loop
		fetch c01 into	dt_atualizacao_w,
				nm_usuario_w,
				ds_relat_tecnico_w,
				cd_versao_tasy_w,
				dt_historico_w,
				ie_origem_w,
				nr_seq_tipo_w,
				dt_liberacao_w,
				nm_usuario_lib_w,
				ie_grau_satisfacao_w,
				dt_envio_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			insert into man_ordem_serv_tecnico(
				nr_sequencia,
				nr_seq_ordem_serv,
				dt_atualizacao,
				nm_usuario,
				ds_relat_tecnico,
				cd_versao_tasy,
				dt_historico,
				ie_origem,
				nr_seq_tipo,
				dt_liberacao,
				nm_usuario_lib,
				ie_grau_satisfacao,
				dt_envio,
				ie_relevante_teste)
			values (
				nextval('man_ordem_serv_tecnico_seq'),
				nr_seq_os_teste_w,
				dt_atualizacao_w,
				nm_usuario_w,
				ds_relat_tecnico_w,
				cd_versao_tasy_w,
				dt_historico_w,
				ie_origem_w,
				nr_seq_tipo_w,
				dt_liberacao_w,
				nm_usuario_lib_w,
				ie_grau_satisfacao_w,
				dt_envio_w,
				'N');
			end;
		end loop;
		close c01;

		insert into man_ordem_serv_arq(
			nr_sequencia,
			nr_seq_ordem,
			dt_atualizacao,
			nm_usuario,
			ds_arquivo,
			ie_anexar_email,
			ie_status_anexo,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		SELECT	nextval('man_ordem_serv_arq_seq'),
			nr_seq_os_teste_w,
			dt_atualizacao,
			nm_usuario,
			ds_arquivo,
			ie_anexar_email,
			ie_status_anexo,
			dt_atualizacao_nrec,
			nm_usuario_nrec
		from	man_ordem_serv_arq
		where	nr_seq_ordem = nr_seq_os_tes_anal_migr_w;
		end;
	--end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_os_revisao_testes_migr ( nr_seq_projeto_p bigint, ie_prioridade_revisao_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

