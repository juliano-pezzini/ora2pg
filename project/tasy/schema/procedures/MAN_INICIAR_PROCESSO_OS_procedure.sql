-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_iniciar_processo_os ( nr_seq_ordem_serv_p bigint, ie_exclusiva_p text, nr_seq_complex_p bigint, ie_resp_teste_p text, nr_seq_classif_p bigint, nr_seq_nivel_valor_p bigint, ie_obriga_news_p text, ds_just_ret_news_p text, nr_seq_estagio_p bigint, ie_prioridade_desen_p bigint, nm_usuario_exec_p text, qt_minutos_exec_p bigint, ie_encerrar_ativ_p text, ds_historico_p text, nm_usuario_p text, ds_motivo_prior_p text, ie_teste_performance_p text, nr_seq_tipo_ocor_p bigint, nr_seq_grupo_des_p bigint, cd_funcao_p text, ie_eu_solicitante_p text, ds_palavra_chave_p text, ie_nec_atual_migr_p text, nr_seq_severidade_wheb_p bigint, ie_obrigar_avaliacao_p text, nr_seq_integracao_p bigint, ie_exige_hist_analise_os_p text, nr_seq_skill_p text default '', ie_plataforma_p text DEFAULT NULL, ie_ambiente_p text default 'P', nr_versao_cli_abertura_p text default '', ds_erro_p INOUT text DEFAULT NULL, nm_campo_focus_p INOUT text DEFAULT NULL) AS $body$
DECLARE


ie_prioridade_desen_w		smallint;
nr_seq_tipo_exec_w		bigint;
ds_hist_padrao_w		varchar(4000);
dt_inicio_desejado_w		timestamp;
qt_registro_w			bigint;
qt_min_prev_w			bigint;
cd_pessoa_fisica_w		varchar(10);
cd_funcao_w			bigint;
qt_exec_w			integer;
nr_seq_ativ_program_w		bigint;
nr_seq_tipo_hist_pad_w		bigint;
qt_registro_ww			bigint;
nr_seq_pacote_w			bigint;
nr_seq_pacote_os_w		bigint;
dt_entrega_pac_w		timestamp;
ie_origem_w			varchar(15);
ds_obs_pacote_w			varchar(4000);
nr_seq_gerencia_w		bigint;
nr_seq_ativ_prev_w		bigint;
dt_prevista_w			timestamp;
ie_programacao_w		varchar(1);
nr_seq_proj_cron_etapa_w	man_ordem_Servico.nr_seq_proj_cron_etapa%type;
ie_classificacao_w		man_ordem_Servico.ie_classificacao%type;
qt_proj_migracao_andamento_w	bigint;
ie_os_adicional_pacote_w	varchar(1);
qt_pacote_atual_w		bigint;
ds_out_w			varchar(50);
ds_historico_p_w		varchar(4000);
ie_atualizacao_migracao_w	varchar(1);


BEGIN

nr_seq_ativ_program_w := coalesce(obter_valor_param_usuario(297,79,obter_perfil_ativo,nm_usuario_p,null),11);
nr_seq_tipo_hist_pad_w	:= coalesce(obter_valor_param_usuario(297,80,obter_perfil_ativo,nm_usuario_p,null),7);


if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then

	select	max(ds_hist_padrao)
	into STRICT	ds_hist_padrao_w
	from	usuario
	where	nm_usuario	= nm_usuario_p;

	ds_out_w := converte_rtf_string('select max(ds_hist_padrao) from usuario where	nm_usuario = :nm_usuario', nm_usuario_p, nm_usuario_p, ds_out_w);
	select ds_texto
	into STRICT ds_hist_padrao_w
	from tasy_conversao_rtf
	where nr_sequencia = ds_out_w;

	ds_historico_p_w:= replace(replace(ds_historico_p, chr(10),''),chr(13),'');
	ds_hist_padrao_w:= replace(replace(ds_hist_padrao_w, chr(10),''),chr(13),'');


/*	if	(ie_exclusiva_p is null) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279160);
		nm_campo_focus_p	:= 'IE_EXCLUSIVA';*/
	if (coalesce(nr_seq_complex_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279161);
		nm_campo_focus_p	:= 'NR_SEQ_COMPLEX';
	elsif (coalesce(ie_resp_teste_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279162);
		nm_campo_focus_p	:= 'IE_RESP_TESTE';
/*	elsif	(nr_seq_classif_p is null) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279164);
		nm_campo_focus_p	:= 'NR_SEQ_CLASSIF';*
	elsif	(nr_seq_nivel_valor_p is null) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279165);
		nm_campo_focus_p	:= 'NR_SEQ_NIVEL_VALOR';*/
	elsif (ie_obriga_news_p = 'N') and (coalesce(ds_just_ret_news_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279167);
		nm_campo_focus_p	:= 'DS_JUST_RET_NEWS';
	elsif (coalesce(nr_seq_estagio_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279170);
		nm_campo_focus_p	:= 'NR_SEQ_ESTAGIO';
	elsif (nr_seq_estagio_p in (2)) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279171);
		nm_campo_focus_p	:= '';
	elsif (coalesce(nm_usuario_exec_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279172);
		nm_campo_focus_p	:= 'NM_USUARIO_EXEC';
	elsif (coalesce(nr_seq_severidade_wheb_p::text, '') = '') and (coalesce(Obter_Descricao_Padrao('MAN_ORDEM_SERVICO','IE_CLASSIFICACAO',nr_seq_ordem_serv_p),'X') in ('E', 'S')) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(708124);
		nm_campo_focus_p	:= 'NR_SEQ_SEVERIDADE_WHEB';
	/*elsif	(qt_minutos_exec_p = 0) then
		ds_erro_p		:= 'Não foi informada a quantidade de minutos previstos para execução da OS!';
		nm_campo_focus_p	:= 'QT_MINUTOS_EXEC';*/
	elsif (coalesce(ie_ambiente_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(496074);
		nm_campo_focus_p	:= 'IE_AMBIENTE';
	elsif (coalesce(nr_versao_cli_abertura_p::text, '') = '') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(496077);
		nm_campo_focus_p	:= 'NR_VERSAO_CLIENTE';
	elsif	((coalesce(ds_historico_p_w::text, '') = '') or (ds_historico_p_w = ds_hist_padrao_w)) and (nm_usuario_exec_p <> nm_usuario_p) then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279176);
		nm_campo_focus_p	:= 'DS_HISTORICO';
	end if;

	if (coalesce(ds_erro_p::text, '') = '') then

		select	CASE WHEN a.ie_prioridade='E' THEN coalesce(a.ie_prioridade_desen,10)  ELSE CASE WHEN a.ie_classificacao='E' THEN 					coalesce(a.ie_prioridade_desen,10)  ELSE coalesce(a.ie_prioridade_desen,0) END  END
		into STRICT	ie_prioridade_desen_w
		from	man_ordem_servico a
		where	nr_sequencia	= nr_seq_ordem_serv_p;

		select	max(dt_inicio_desejado)
		into STRICT	dt_inicio_desejado_w
		from	man_ordem_servico
		where	nr_sequencia	= nr_seq_ordem_serv_p;

		/* COLOCAR ORDEM EM PROCESSO */

		update	man_ordem_servico
		set	ie_status_ordem		= 2,
			dt_aceite_os		= clock_timestamp(),
			dt_inicio_previsto	= dt_inicio_desejado_w,
			dt_inicio_real		= clock_timestamp()
		where	nr_sequencia	= nr_seq_ordem_serv_p;

		begin
		select	cd_funcao,
			nr_seq_proj_cron_etapa,
			ie_classificacao
		into STRICT	cd_funcao_w,
			nr_seq_proj_cron_etapa_w,
			ie_classificacao_w
		from	man_ordem_servico
		where	nr_sequencia	= nr_seq_ordem_serv_p;
		exception
		when others then
			null;
		end;

		select	max(ie_atualizacao_migracao)
		into STRICT	ie_atualizacao_migracao_w
		from	man_ordem_servico
		where	nr_sequencia = nr_seq_ordem_serv_p;

		/* Francisco - 11/10/2013 - Tratamento exclusivo para os projetos de migração do OPS */

		if (coalesce(ie_nec_atual_migr_p,'P') = 'P') and (cd_funcao_w IS NOT NULL AND cd_funcao_w::text <> '') then
			select	count(1)
			into STRICT	qt_proj_migracao_andamento_w
			from	proj_projeto a
			where	a.cd_funcao = cd_funcao_w
			and	a.nr_seq_gerencia = 7 /* Consistir somente gerência OPS por enquanto */
			and	a.nr_seq_classif = 14 /* Migração */
			and	a.pr_realizacao > 0;

			/* Se já tem projeto em andamento para a função ou já concluído */

			if (qt_proj_migracao_andamento_w > 0) then
				ds_erro_p	:= WHEB_MENSAGEM_PCK.get_texto(279177);
			end if;
		end if;

		if (ie_nec_atual_migr_p = 'N') and (ie_atualizacao_migracao_w = 'R') then
			ie_atualizacao_migracao_w := 'R';
		else
			ie_atualizacao_migracao_w := ie_nec_atual_migr_p;
		end if;

		/* MUDAR CAMPOS DA OS QUE NÃO POSSUEM TRATAMENTO  INDIVIDUAL*/

		update	man_ordem_servico
		set	ie_exclusiva		= ie_exclusiva_p,
			nr_seq_complex		= nr_seq_complex_p,
			ie_resp_teste		= ie_resp_teste_p,
			nr_seq_classif		= nr_seq_classif_p,
			nr_seq_nivel_valor	= nr_seq_nivel_valor_p,
			ie_obriga_news		= ie_obriga_news_p,
			ds_just_ret_news	= ds_just_ret_news_p,
			nr_seq_estagio		= nr_seq_estagio_p,
			ie_teste_performance	= ie_teste_performance_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			nr_seq_tipo_ocor	= nr_seq_tipo_ocor_p,
			nr_seq_grupo_des	= nr_seq_grupo_des_p,
			cd_funcao		= coalesce(cd_funcao_p,cd_funcao),
			ds_palavra_chave	= ds_palavra_chave_p,
			ie_atualizacao_migracao	= ie_atualizacao_migracao_w,
			nm_usuario_atual_migr	= nm_usuario_p,
			dt_atualizacao_migracao	= clock_timestamp(),
			nr_seq_severidade_wheb 	= nr_seq_severidade_wheb_p,
			ie_obrigar_avaliacao	= coalesce(ie_obrigar_avaliacao_p,'N'),
			nr_seq_integracao	= nr_seq_integracao_p,
			ie_exige_aval_cliente	= ie_exige_hist_analise_os_p,
			ie_plataforma		= ie_plataforma_p,
			ie_ambiente		= ie_ambiente_p,
			nr_versao_cliente_abertura		= coalesce(nr_versao_cli_abertura_p, nr_versao_cliente_abertura)
		where	nr_sequencia		= nr_seq_ordem_serv_p;

		if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (cd_funcao_w <> cd_funcao_p) then
			delete
			from	man_ordem_servico_exec
			where	nr_seq_ordem	= nr_seq_ordem_serv_p
			and	nm_usuario_exec	= nm_usuario_p;
		end if;

		if (coalesce(nr_seq_skill_p,0) > 0) then
			insert into man_ordem_serv_skill(	nr_sequencia,
					nr_seq_skill,
					nr_seq_ordem_serv,
					nm_usuario,
					dt_atualizacao)
				values (	nextval('man_ordem_serv_skill_seq'),
					nr_seq_skill_p,
					nr_seq_ordem_serv_p,
					nm_usuario_p,
					clock_timestamp());
		else
			select	count(*)
			into STRICT	qt_registro_ww
			from	cadastro_fila
			where	nm_usuario_fila	= nm_usuario_exec_p;

			if (qt_registro_ww > 0) then
				ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(279178);
			end if;
		end if;

		/* MUDAR CAMPOS DA OS QUE POSSUEM TRATAMENTO */

		/* PRIORIDADE */

		/*if	(ie_prioridade_desen_p <> ie_prioridade_desen_w) then

			if	((ie_prioridade_desen_p < ie_prioridade_desen_w) or
				(ie_prioridade_desen_p >= 8)) and
				(ds_motivo_prior_p is null) then
				'Para diminuir a prioridade da OS ou colocar prioridade acima de 8 deve ser informada justificativa!#@#@');
			end if;

			update	man_ordem_servico
			set	ie_prioridade_desen	= ie_prioridade_desen_p
			where	nr_sequencia	= nr_seq_ordem_serv_p;

			man_gerar_hist_prioridade(nr_seq_ordem_serv_p,
						1,
						ie_prioridade_desen_w,
						ie_prioridade_desen_p,
						ds_motivo_prior_p,
						nm_usuario_p,
						7);
		end if;*/
		/* INSERIR USUÁRIO EXECUTOR */

		select 	count(*)
		into STRICT	qt_exec_w
		from	man_ordem_servico_exec
		where	nm_usuario_exec = nm_usuario_exec_p
		and	nr_seq_ordem	= nr_seq_ordem_serv_p;

		if (nm_usuario_exec_p <> nm_usuario_p) or
			(nm_usuario_exec_p = nm_usuario_p AND qt_exec_w = 0)then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_tipo_exec_w
			from	man_tipo_executor a
			where	a.ie_tipo_executor	= '1';

			select	sum(qt_min_prev)
			into STRICT	qt_min_prev_w
                        from	man_ordem_ativ_prev
                        where	nr_seq_ordem_serv  = nr_seq_ordem_serv_p
                        and	nm_usuario_prev    = nm_usuario_exec_p;

			insert into man_ordem_servico_exec(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nr_seq_ordem,
				nm_usuario_exec,
				qt_min_prev,
				nr_seq_tipo_exec,
				nr_seq_funcao)
			values (nextval('man_ordem_servico_exec_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_ordem_serv_p,
				nm_usuario_exec_p,
				qt_min_prev_w,
				nr_seq_tipo_exec_w,
				nr_seq_ativ_program_w);
		else
			select	sum(qt_min_prev)
			into STRICT	qt_min_prev_w
                        from	man_ordem_ativ_prev
                        where	nr_seq_ordem_serv  = nr_seq_ordem_serv_p
                        and	nm_usuario_prev    = nm_usuario_p;

			update	man_ordem_servico_exec
			set	qt_min_prev	= qt_min_prev_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_seq_ordem	= nr_seq_ordem_serv_p
			and	nm_usuario_exec	= nm_usuario_exec_p;
		end if;

		/* FINALIZAR EXECUCAO ANALISTA CASO MARCADO */

		if (ie_encerrar_ativ_p = 'S') then
			update	man_ordem_servico_exec
			set	dt_fim_execucao	= clock_timestamp()
			where	nr_seq_ordem	= nr_seq_ordem_serv_p
			and	nm_usuario_exec	= nm_usuario_p;

			select	count(*)
			into STRICT	qt_registro_w
			from	usuario_grupo_des b,
				man_ordem_servico_exec a
			where	a.nm_usuario_exec = b.nm_usuario_grupo
			and	a.nr_seq_ordem	= nr_seq_ordem_serv_p
			and	coalesce(a.dt_fim_execucao::text, '') = '';

			if (qt_registro_w = 0) then
				CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(187461);
			end if;
		end if;

		/* FINALIZAR ATIVIDADE REALIZADA CASO INICIADA */

		/*update	man_ordem_serv_ativ
		set	dt_fim_atividade	= sysdate,
			qt_minuto		= obter_min_entre_datas(dt_atividade,sysdate,null),
			qt_minuto_cobr	= obter_min_entre_datas(dt_atividade,sysdate,null)
		where	nr_seq_ordem_serv	= nr_seq_ordem_serv_p
		and	nm_usuario_exec	= nm_usuario_p
		and	qt_minuto		= 0;*/
		/* INSERIR HISTÓRICO DE INÍCIO DO PROCESSO */

		/*insert into man_ordem_serv_tecnico(
			nr_sequencia,
			nr_seq_ordem_serv,
			dt_atualizacao,
			nm_usuario,
			dt_historico,
			ds_relat_tecnico,
			dt_liberacao,
			nm_usuario_lib,
			ie_origem,
			nr_seq_tipo)
		values	(man_ordem_serv_tecnico_seq.nextval,
			nr_seq_ordem_serv_p,
			sysdate,
			nm_usuario_p,
			sysdate,
			'Ordem de serviço aceita e triada.',
			sysdate,
			nm_usuario_p,
			'I',
			7);*/
		/* INSERIR HISTÓRICO PARA USUÁRIO EXECUTOR */

		if (ds_historico_p_w IS NOT NULL AND ds_historico_p_w::text <> '') and (ds_historico_p_w <> coalesce(ds_hist_padrao_w,'XPTO')) then
			insert into man_ordem_serv_tecnico(
				nr_sequencia,
				nr_seq_ordem_serv,
				dt_atualizacao,
				nm_usuario,
				dt_historico,
				ds_relat_tecnico,
				dt_liberacao,
				nm_usuario_lib,
				ie_origem,
				nr_seq_tipo)
			values (nextval('man_ordem_serv_tecnico_seq'),
				nr_seq_ordem_serv_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				ds_historico_p,
				clock_timestamp(),
				nm_usuario_p,
				'I',
				nr_seq_tipo_hist_pad_w);
		end if;

		if (ie_eu_solicitante_p = 'S') then
			select	cd_pessoa_fisica
			into STRICT	cd_pessoa_fisica_w
			from	usuario
			where	nm_usuario = nm_usuario_p;

			update	man_ordem_servico
			set	cd_pessoa_solicitante = cd_pessoa_fisica_w
			where	nr_sequencia	= nr_seq_ordem_serv_p;
		end if;

		/*Controle pacote */

		select	count(*)
		into STRICT	qt_registro_ww
		from	cadastro_fila b
		where	b.nm_usuario_fila	= nm_usuario_exec_p;

		ie_programacao_w	:= substr(coalesce(des_obter_se_estagio_os_progr(nr_seq_ordem_serv_p),'N'),1,1);

		if (coalesce(nr_seq_proj_cron_etapa_w::text, '') = '') and (ie_classificacao_w <> 'E') and (qt_registro_ww = 0) and (ie_programacao_w = 'S') then

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_gerencia_w
			from	grupo_desenvolvimento a,
				man_ordem_Servico b
			where	b.nr_seq_grupo_des	= a.nr_Sequencia
			and	b.nr_sequencia	= nr_seq_ordem_serv_p;

			if (coalesce(nr_seq_gerencia_w::text, '') = '') then
				select	max(nr_seq_gerencia)
				into STRICT	nr_seq_gerencia_w
				from	grupo_desenvolvimento a,
					usuario_grupo_des b
				where	a.nr_sequencia	= b.nr_seq_grupo
				and	b.nm_usuario_grupo	= nm_usuario_exec_p;
			end if;

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_ativ_prev_w
			from	man_ordem_ativ_prev a
			where	a.nr_seq_ordem_serv	= nr_seq_ordem_serv_p
			and	a.nm_usuario_prev	= nm_usuario_exec_p
			and	coalesce(a.dt_real::text, '') = '';

			select	max(dt_prevista)
			into STRICT	dt_prevista_w
			from	man_Ordem_ativ_prev a
			where	a.nr_sequencia	= nr_seq_ativ_prev_w;

			select	coalesce(max(a.nr_sequencia),0)
			into STRICT	nr_seq_pacote_w
			from	cadastro_fila b,
				des_pacote_versao a
			where	a.nr_seq_fila		= b.nr_sequencia
			and	b.nr_seq_gerencia	= a.nr_seq_gerencia
			and	b.ie_pacote_entrega	= 'S'
			and	b.nr_seq_gerencia	= nr_seq_gerencia_w
			and	dt_prevista_w between a.dt_inicial and a.dt_final;

			select	coalesce(max(a.nr_seq_pacote),0)
			into STRICT	nr_seq_pacote_os_w
			from	des_pacote_versao b,
				des_pacote_ordem_serv a
			where	b.nr_sequencia		= a.nr_seq_pacote
			and	a.nr_seq_ordem_serv	= nr_seq_ordem_serv_p;

			ie_origem_w	:= 'ANM';
			if (nr_seq_pacote_os_w = 0) then
				ie_origem_w	:= 'USU';
			end if;

			select	count(*)
			into STRICT	qt_registro_ww
			from	des_pacote_ordem_serv
			where	nr_seq_pacote		= nr_seq_pacote_w
			and	nr_seq_ordem_serv	= nr_seq_ordem_serv_p;

			if (qt_registro_ww = 0) and (coalesce(nr_seq_pacote_w,0) <> 0) and (ie_origem_w IS NOT NULL AND ie_origem_w::text <> '') then
				begin
				ds_obs_pacote_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(279179) || nm_usuario_p,1,4000);

				if (nr_seq_pacote_os_w <> 0) then
					select	max(dt_entrega)
					into STRICT	dt_entrega_pac_w
					from	des_pacote_versao
					where	nr_sequencia	= nr_seq_pacote_os_w;

					ds_obs_pacote_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(279180) || to_char(dt_entrega_pac_w,'dd/mm/yyyy'),1,4000);
				end if;

				-- Verifica se o pacote que se está incluindo a OS é o pacote atual de entrega, desta forma a OS será considerada adicional
				select	count(*)
				into STRICT	qt_pacote_atual_w
				from	des_pacote_versao a
				where	a.nr_sequencia = nr_seq_pacote_w
				and	clock_timestamp() between a.dt_inicial and a.dt_final;

				ie_os_adicional_pacote_w := 'N';
				if (qt_pacote_atual_w > 0) then
					ie_os_adicional_pacote_w := 'S';
				end if;

				delete	FROM des_pacote_ordem_serv
				where	nr_seq_pacote		= nr_seq_pacote_os_w
				and	nr_seq_ordem_serv	= nr_seq_ordem_serv_p;

				insert into des_pacote_ordem_serv(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_pacote,
					nr_seq_ordem_serv,
					ds_observacao,
					ie_origem,
					nr_seq_pacote_orig,
					ie_os_adicional)
				values (	nextval('des_pacote_ordem_serv_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_pacote_w,
					nr_seq_ordem_serv_p,
					ds_obs_pacote_w,
					ie_origem_w,
					nr_seq_pacote_os_w,
					ie_os_adicional_pacote_w);

				end;
			end if;

		end if;

		update	man_ordem_servico
		set	dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_ordem_serv_p;

		CALL man_atualizar_ult_visao(nr_seq_ordem_serv_p,nm_usuario_p,'A');

		commit;
	end if;
else
	CALL wheb_mensagem_pck.EXIBIR_MENSAGEM_ABORT(187460);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_iniciar_processo_os ( nr_seq_ordem_serv_p bigint, ie_exclusiva_p text, nr_seq_complex_p bigint, ie_resp_teste_p text, nr_seq_classif_p bigint, nr_seq_nivel_valor_p bigint, ie_obriga_news_p text, ds_just_ret_news_p text, nr_seq_estagio_p bigint, ie_prioridade_desen_p bigint, nm_usuario_exec_p text, qt_minutos_exec_p bigint, ie_encerrar_ativ_p text, ds_historico_p text, nm_usuario_p text, ds_motivo_prior_p text, ie_teste_performance_p text, nr_seq_tipo_ocor_p bigint, nr_seq_grupo_des_p bigint, cd_funcao_p text, ie_eu_solicitante_p text, ds_palavra_chave_p text, ie_nec_atual_migr_p text, nr_seq_severidade_wheb_p bigint, ie_obrigar_avaliacao_p text, nr_seq_integracao_p bigint, ie_exige_hist_analise_os_p text, nr_seq_skill_p text default '', ie_plataforma_p text DEFAULT NULL, ie_ambiente_p text default 'P', nr_versao_cli_abertura_p text default '', ds_erro_p INOUT text DEFAULT NULL, nm_campo_focus_p INOUT text DEFAULT NULL) FROM PUBLIC;
