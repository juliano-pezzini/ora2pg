-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_analise_grupo ( nr_seq_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, ie_alerta_confirmado_p text, cd_estabelecimento_p bigint, ie_commit_p text, ie_lib_automatic_p text, ie_glosa_atend_p text, ie_origem_finalizacao_p text, ds_mensagem_retorno_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Finalizar a análise do grupo auditor atual (Análise Nova)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

-------------------------------------------------------------------------------------------------------------------
Parâmetro
	ie_origem_finalizacao_p - Utilizado para identificar quando a procedure foi
	chamada diretamente na Gestão de Análise, com o parâmetro [20]

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_mensagem_retorno_w		varchar(4000);
nm_usuario_exec_w		varchar(255);
ie_forma_final_analise_w	varchar(3);
ie_fechar_contas_w		varchar(3);
ie_existe_grupo_final_w		varchar(1);
ie_existe_final_anali_w		varchar(1);
ie_pendencia_grupo_w		varchar(1)	:= 'N';
ie_fluxo_ant_w			varchar(1);
ie_analise_grupo_w		bigint;
nr_seq_grupo_analise_w		bigint;
nr_seq_grupo_w			bigint;
ie_existe_usuario_grupo_w	bigint;
ie_existe_grupos_abertos_w	bigint;
nr_seq_regra_w			bigint;
qt_grupos_analise_w		bigint;
nr_seq_fatura_w			bigint;
qt_sem_fluxo_w			bigint;
nr_seq_grupo_final_w		bigint;
nr_seq_solic_pedido_w		bigint;
nr_seq_parecer_pedido_w		bigint;
qt_ocor_impede_finalizacao_w	bigint;
nr_seq_ordem_atual_w		bigint;
nr_seq_glo_ocor_grupo_w		bigint;
nr_seq_ocor_benef_w		bigint;
dt_finalizacao_w		timestamp;
nr_seq_ordem_grupo_atual_w	bigint;
qt_consistir_w			integer	:= 0;
qt_grupo_pre_analise_w		integer	:= 0;
qt_grupo_dif_pre_analise_w	integer	:= 0;
qt_grupo_analise_w		integer	:= 0;
qt_glosa_conta_analise_w	integer	:= 0;
ie_consiste_analise_w		pls_param_analise_conta.ie_consiste_analise%type;
nr_seq_grupo_pre_analise_w	pls_parametros.nr_seq_grupo_pre_analise%type;
ie_param_51_w			funcao_parametro.vl_parametro_padrao%type := 'N';
ie_param_30_w			funcao_parametro.vl_parametro_padrao%type := 'S';
ie_analise_encerrada_w		varchar(1) := 'N';
qt_proc_pendente_w		integer := 0;
qt_mat_pendente_w		integer := 0;
qt_status_encerrada_w		integer;
ie_status_w			pls_analise_conta.ie_status%type;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.nr_sequencia
	from	pls_ocorrencia			c,
		pls_ocorrencia_benef		a,
		pls_analise_glo_ocor_grupo	b
	where	c.nr_sequencia		= a.nr_seq_ocorrencia
	and	a.nr_sequencia		= b.nr_seq_ocor_benef
	and	b.ie_status		= 'P'
	and	c.ie_auditoria_conta	= 'N'
	and	b.nr_seq_analise	= nr_seq_analise_p
	and	b.nr_seq_grupo		= nr_seq_grupo_atual_p;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta
	where	nr_seq_analise	= nr_seq_analise_p;
BEGIN
--Necessário verificar se o status da análise já não está cancelado para não retorceder o mesmo
select	max(ie_status)
into STRICT	ie_status_w
from	pls_analise_conta
where 	nr_sequencia	= nr_seq_analise_p;

if (ie_status_w	!= 'C') then
	if (nr_seq_grupo_atual_p IS NOT NULL AND nr_seq_grupo_atual_p::text <> '') then

		select	max(a.nr_seq_ordem)
		into STRICT	nr_seq_ordem_grupo_atual_w
		from	pls_auditoria_conta_grupo a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	a.nr_seq_grupo		= nr_seq_grupo_atual_p;

	else
		nr_seq_ordem_grupo_atual_w	:= null;
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_glo_ocor_grupo_w,
		nr_seq_ocor_benef_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update	pls_analise_glo_ocor_grupo
		set	ie_status	= 'M',
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_seq_glo_ocor_grupo_w;

		update	pls_ocorrencia_benef
		set	ie_situacao		= 'I',
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='S' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'U' END
		where	nr_sequencia		= nr_seq_ocor_benef_w;
		end;
	end loop;
	close C01;

	select	max(ie_consiste_analise)
	into STRICT	ie_consiste_analise_w
	from	pls_param_analise_conta
	where	cd_estabelecimento	= cd_estabelecimento_p;

	ie_consiste_analise_w	:= coalesce(ie_consiste_analise_w,'N');

	ie_forma_final_analise_w := obter_param_usuario(1365, 3, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_forma_final_analise_w);
	/*	ie_forma_final_analise_w
		I - Impedir
		A - Alertar e depois glosar
		G - Glosar itens pendentes */
	ds_mensagem_retorno_p	:= null;

	if (coalesce(ie_consistir_pendencias_p,'S') = 'S') then
		select	max(a.nr_seq_ordem)
		into STRICT	nr_seq_ordem_atual_w
		from	pls_auditoria_conta_grupo	a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	a.nr_seq_grupo		= nr_seq_grupo_atual_p
		and	coalesce(a.dt_liberacao::text, '') = '';

		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_fluxo_ant_w
		from	pls_analise_pedido_parecer	a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	a.nr_seq_grupo_atual	= nr_seq_grupo_atual_p
		and	coalesce(a.dt_finalizacao::text, '') = ''
		and	a.nr_seq_novo_fluxo < nr_seq_ordem_atual_w;

		if (ie_fluxo_ant_w = 'S') then
			select	count(1)
			into STRICT	qt_ocor_impede_finalizacao_w
			from	pls_ocorrencia_benef b,
				pls_conta a
			where	a.nr_sequencia		= b.nr_seq_conta
			and	a.nr_seq_analise	= nr_seq_analise_p
			and	ie_encaminhamento = 'S'
			and	coalesce(dt_encaminhamento::text, '') = ''  LIMIT 1;

			if (qt_ocor_impede_finalizacao_w > 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(210282);
			end if;
		end if;

		/*Se houver ocorrencias a corrigir não é possivel liberar*/

		if (coalesce(ie_lib_automatic_p,'N') = 'N') then
			if (pls_obter_se_grupo_fim_analise(nr_seq_analise_p,null,null,null,null,nr_seq_grupo_atual_p) = 'S') then
				/*Existem ocorrências ainda pendentes que não permitem finalizar a análise (Status de análise vermelho).
				É necessário corrigi-las primeiro. */
				CALL wheb_mensagem_pck.exibir_mensagem_abort(205161, null, -20012);
			end if;
		end if;
		/* Glosar primeiro para consistir depois */

		if (coalesce(ie_glosa_atend_p,'N') = 'S') or /*Parametro para quando glosar o atendimento  glosar os itens que estão pendentes*/
			((ie_forma_final_analise_w = 'G') or (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'S')) then
			CALL pls_analise_glosar_itens_pend(nr_seq_analise_p,nr_seq_grupo_atual_p,cd_estabelecimento_p,nm_usuario_p, ie_glosa_atend_p);
		end if;

		if (coalesce(ie_lib_automatic_p,'N') = 'N') then

			select 	count(1)
			into STRICT	qt_consistir_w
			from	pls_conta
			where	nr_seq_analise	= nr_seq_analise_p
			and	ie_consistir_conta_analise = 'S';


			--Verifica se é para consistir e se o parâmetro não está para automático
			if (qt_consistir_w	> 0) and (ie_consiste_analise_w = 'N') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(306851);
			end if;

			ie_pendencia_grupo_w	:= pls_obter_pend_grupo_analise(nr_seq_analise_p,null,null, null, null, nr_seq_grupo_atual_p, 'N');
			if (ie_pendencia_grupo_w = 'S') then
				/* A análise não pôde ser finalizada pois existem ocorrências ainda pendentes para seu grupo de análise (Status de análise do item amarelo).
				Você pode marcar a opção "Pendentes" para verificar quais são estes itens. */
				if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then
					ds_mensagem_retorno_p	:= 'Atenção! Há itens pendentes de análise para seu grupo.' ||
									chr(13) || chr(10) ||
									'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
				elsif (ie_forma_final_analise_w = 'I') then		--
					CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
				end if;
			end if;
		end if;

		/* Se for o último grupo do fluxo, devem verificar se há itens sem fluxo ainda pendentes */

		if (pls_obter_se_fim_fluxo_analise(nr_seq_analise_p,nr_seq_grupo_atual_p) = 'S') then

			--Caso for o último grupo da análise, então consiste caso tenha pendência
			if (qt_consistir_w	> 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(306851);
			end if;

			/*Se houver análises de ocorrencia a fazer não é possivel liberar*/

			select	max(a.nr_sequencia)
			into STRICT	qt_sem_fluxo_w
			from	pls_ocorrencia c,
				pls_ocorrencia_benef a,
				pls_conta b
			where	a.nr_seq_ocorrencia = c.nr_sequencia
			and	b.nr_sequencia = a.nr_seq_conta
			and	b.nr_seq_analise	= nr_seq_analise_p
			and (a.ie_situacao		= 'A' or coalesce(a.ie_situacao::text, '') = '')
			and (c.ie_auditoria_conta = 'S' or coalesce(c.ie_auditoria_conta::text, '') = '')
			and	((a.ie_auditoria = 'S') or (coalesce(a.ie_auditoria::text, '') = ''))
			and     not exists (	SELECT 	1
						from    pls_analise_glo_ocor_grupo g
						where   g.nr_seq_ocor_benef = a.nr_sequencia
						and (g.ie_status <> 'P' or coalesce(g.ie_status::text, '') = ''))
			and	not exists (	select	1
						from	pls_conta_proc x
						where	x.nr_sequencia = a.nr_seq_conta_proc
						and	x.ie_status = 'D')
			and (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N')
			and	not exists	(select	1
						from	tiss_motivo_glosa y,
							pls_conta_glosa x
						where	x.nr_seq_motivo_glosa = y.nr_sequencia
						and	((x.nr_sequencia = a.nr_seq_glosa) or (x.nr_seq_ocorrencia_benef = a.nr_sequencia))
						and	y.cd_motivo_tiss in ('1705','1706'))
			and (c.ie_glosar_pagamento = 'S' or coalesce(c.ie_glosar_pagamento::text, '') = '')
			and	not exists (	select	1
						from	pls_conta_pos_estabelecido	x,
							pls_conta_proc			y
						where	x.nr_seq_conta_proc		= y.nr_sequencia
						and	a.nr_seq_conta_proc		= y.nr_sequencia
						and	y.ie_status			= 'M'
						and	x.ie_status_faturamento		= 'A'
						
union all

						SELECT	1
						from	pls_conta_pos_estabelecido	x,
							pls_conta_mat			y
						where	x.nr_seq_conta_mat		= y.nr_sequencia
						and	a.nr_seq_conta_mat		= y.nr_sequencia
						and	y.ie_status			= 'M'
						and	x.ie_status_faturamento		= 'A');


			if (qt_sem_fluxo_w > 0) then

				if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then
					ds_mensagem_retorno_p	:= '(01) Atenção! Há itens sem fluxo de auditoria definido e ainda pendentes.' ||
									chr(13) || chr(10) ||
									'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
				else
					CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
				end if;
			else
				select	count(1)
				into STRICT	qt_sem_fluxo_w
				from	pls_conta b
				where	b.nr_seq_analise	= nr_seq_analise_p
				and	((exists (SELECT	1
							 from	pls_conta_proc	x
							 where	x.nr_seq_conta = b.nr_sequencia
							 and	x.ie_status not in ('D','L','S','M'))) or (exists (select	1
							 from	pls_conta_mat	x
							 where	x.nr_seq_conta = b.nr_sequencia
							 and	x.ie_status not in ('D','L','S','M'))))
				and (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') LIMIT 1;

				if (qt_sem_fluxo_w > 0) then
					for r_c02_w in C02() loop
						begin
						-- trata a liberação automática do item
						CALL pls_liberar_item_automatic(	r_c02_w.nr_sequencia, null, null, nm_usuario_p);
						commit;
						--Necessário rodar o processo para que os valores utilizados para pagamento sejam atualizados corretamente
						CALL pls_atualiza_lib_conta(	r_c02_w.nr_sequencia,'A',nm_usuario_p);
						commit;
						end;
					end loop;

					select	count(1)
					into STRICT	qt_sem_fluxo_w
					from	pls_conta b
					where	b.nr_seq_analise	= nr_seq_analise_p
					and	((exists (SELECT	1
								 from	pls_conta_proc	x
								 where	x.nr_seq_conta = b.nr_sequencia
								 and	x.ie_status not in ('D','L','S','M'))) or (exists (select	1
								 from	pls_conta_mat	x
								 where	x.nr_seq_conta = b.nr_sequencia
								 and	x.ie_status not in ('D','L','S','M'))))
					and (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') LIMIT 1;

					if (qt_sem_fluxo_w > 0) then
						if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then
							ds_mensagem_retorno_p	:= '(02) Atenção! Há itens ainda pendentes de liberação.' ||
											chr(13) || chr(10) ||
											'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
						else
							CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
						end if;
					end if;
				elsif (coalesce(ie_glosa_atend_p,'N')	!= 'S') then
						select	count(1)
						into STRICT	qt_sem_fluxo_w
						from	pls_conta_glosa	glosa,
								pls_conta	conta
						where	glosa.nr_seq_conta	= conta.nr_sequencia
						and	glosa.ie_situacao	= 'A'
						and	conta.ie_status		!= 'C'
						and	conta.nr_seq_analise	= nr_seq_analise_p
								--Caso retornar maior que zero, então quer dizer que estaria analisada a glosa, independente da mesma estar ativa ou inavita. Então
								--verifica se igual a zero, para que o select da consistência de glosa pendente possa alertar o fato de ter item pendente ainda
						and (	(SELECT	count(1)
								from	pls_analise_glo_ocor_grupo a
								where	a.nr_seq_analise		= nr_seq_analise_p
								and		a.nr_seq_conta_glosa	= glosa.nr_sequencia
								and		((coalesce(a.ie_fluxo_adic::text, '') = '') or (a.ie_fluxo_adic	= 'N'))) = 0
								)
						and	not exists (	select	1
									from	pls_conta_proc x
									where	x.nr_sequencia = glosa.nr_seq_conta_proc
									and	x.ie_status in ('D', 'M')
									
union all

									SELECT	1
									from	pls_conta_mat x
									where	x.nr_sequencia = glosa.nr_seq_conta_mat
									and	x.ie_status in ('D', 'M'))
						and	not exists (select	1
									from	tiss_motivo_glosa y
									where	glosa.nr_seq_motivo_glosa = y.nr_sequencia
									and	y.cd_motivo_tiss in ('1705','1706'))
						and     not exists (select 	1
									from    pls_analise_glo_ocor_grupo g
									where   g.nr_seq_conta_glosa = glosa.nr_sequencia
									and (g.ie_status != 'P' or coalesce(g.ie_status::text, '') = ''))
						and	not exists	(select	1
									from	pls_ocorrencia_benef	ocor
									where	1 = 1
									and	((ocor.nr_sequencia 	= glosa.nr_seq_ocorrencia_benef) or (ocor.nr_seq_glosa 	= glosa.nr_sequencia)));
						if (qt_sem_fluxo_w > 0)	then
							if (ie_forma_final_analise_w = 'A' and ie_alerta_confirmado_p = 'N') then
								ds_mensagem_retorno_p	:= '(03) Atenção! Há itens sem fluxo de auditoria definido e ainda pendentes.' ||
												chr(13) || chr(10) ||
												'Se você finalizar a análise todos esses itens serão glosados. Confirma a finalização?';
							else

								CALL wheb_mensagem_pck.exibir_mensagem_abort(205163);
							end if;
						end if;
				end if;
			end if;
		end if;
	end if;

	if (coalesce(ds_mensagem_retorno_p::text, '') = '') then
		CALL pls_analise_gerar_grupos_enc(nr_seq_analise_p, nr_seq_grupo_atual_p, 'N', cd_estabelecimento_p,1,null,null,nm_usuario_p);
		select	count(1)
		into STRICT	ie_existe_grupos_abertos_w
		from	pls_auditoria_conta_grupo a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	coalesce(a.dt_liberacao::text, '') = ''
		and	coalesce(ie_pre_analise,'N')	 = 'N'  LIMIT 1;

		--Verifica se é para consistir e se o parâmetro está para automático
		if (qt_consistir_w > 0) and (ie_consiste_analise_w = 'S') and (ie_existe_grupos_abertos_w = 1) then
			insert into pls_cta_analise_cons(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
					nr_seq_analise,ie_status)
			values (	nextval('pls_cta_analise_cons_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
					nr_seq_analise_p,'P');

			update	pls_analise_conta
			set	ie_status	= 'D'
			where	nr_sequencia	= nr_seq_analise_p;
		elsif (qt_consistir_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(306851);
		end if;

		select	max(nr_sequencia)
		into STRICT	nr_seq_parecer_pedido_w
		from	pls_analise_pedido_parecer
		where	nr_seq_grupo_parecer	= nr_seq_grupo_atual_p
		and	nr_seq_analise		= nr_seq_analise_p;

		if (nr_seq_parecer_pedido_w IS NOT NULL AND nr_seq_parecer_pedido_w::text <> '') then
			update	pls_analise_pedido_parecer
			set	dt_finalizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_parecer_pedido_w;
		end if;

		update	pls_auditoria_conta_grupo
		set	dt_liberacao 		= clock_timestamp(),
			dt_final_analise	= clock_timestamp(),
			ie_origem_finalizacao	= ie_origem_finalizacao_p,
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			nm_auditor_atual	= CASE WHEN ie_pre_analise='S' THEN  nm_usuario_p  ELSE nm_auditor_atual END
		where	nr_sequencia		= 	(SELECT	max(nr_sequencia)
							from	pls_auditoria_conta_grupo
							where	nr_seq_grupo 		= nr_seq_grupo_atual_p
							and	nr_seq_analise		= nr_seq_analise_p
							and	coalesce(dt_liberacao::text, '') = ''
							and	nr_seq_ordem 		=	(select	min(nr_seq_ordem)
												from	pls_auditoria_conta_grupo
												where	nr_seq_grupo 		= nr_seq_grupo_atual_p
												and	nr_seq_analise		= nr_seq_analise_p
												and	coalesce(dt_liberacao::text, '') = ''	));

		CALL pls_gravar_inicio_fim_analise(nr_seq_analise_p, nr_seq_grupo_atual_p, 'F', nm_usuario_p);

		select	count(1)
		into STRICT	ie_existe_grupos_abertos_w
		from	pls_auditoria_conta_grupo a
		where	a.nr_seq_analise	= nr_seq_analise_p
		and	coalesce(a.dt_liberacao::text, '') = ''
		and	coalesce(ie_pre_analise,'N')	 = 'N'  LIMIT 1;


		select 	count(1)
		into STRICT	qt_status_encerrada_w
		from	pls_analise_conta
		where 	nr_sequencia 	= nr_seq_analise_p
		and	ie_status	= 'T';

		if (qt_status_encerrada_w	> 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1024241);
		end if;
		/*Fazer verificação se existe grupos de analise ainda em aberto se não houver  fechar a analise*/

		if (ie_existe_grupos_abertos_w = 0) then
			/*Obter o grupo responsavel por fechar a conta*/

			SELECT * FROM pls_obter_grupo_fechar_analise(nr_seq_analise_p, cd_estabelecimento_p, nr_seq_regra_w, nr_seq_grupo_w) INTO STRICT nr_seq_regra_w, nr_seq_grupo_w;

			if (coalesce(nr_seq_grupo_w,0) > 0) then
				ie_existe_grupo_final_w	:= 'S';

				/*obter se este grupo já foi inserido na análise*/

				select	CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_existe_final_anali_w
				from	pls_auditoria_conta_grupo
				where	nr_seq_grupo	= nr_seq_grupo_w
				and	nr_seq_analise	= nr_seq_analise_p  LIMIT 1;
			else
				/*Caso não haja regra de grupo de finalização*/

				ie_existe_grupo_final_w	:= 'N';
			end if;

			/*Se não existe grupo de finalização na análise esta é encerrada*/

			if (ie_existe_grupo_final_w = 'N') then
				ie_analise_encerrada_w	:= 'N';
				--parâmetro 51 Encerrar atendimento ao finalizar fluxo de pré-análise(Caso não tiver nenhum fluxo que não seja o vinculado ao grupo de pré-análise)
				ie_param_51_w := Obter_Param_Usuario(1293, 51, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param_51_w);
				if (ie_param_51_w = 'S') then
					/*Se existir somente o grupo do auditor então é liberado a análise.*/

					select	max(a.nr_seq_grupo_pre_analise)
					into STRICT	nr_seq_grupo_pre_analise_w
					from	pls_parametros	a
					where	a.cd_estabelecimento	= cd_estabelecimento_p;

					--Se chegou até aqui é por que tem apenas um grupo na análise e caso esse grupo for o grupo
					--da pré-analise
					select 	count(1)
					into STRICT	qt_grupo_pre_analise_w
					from	pls_auditoria_conta_grupo a
					where 	a.nr_seq_grupo = nr_seq_grupo_pre_analise_w
					and	a.nr_seq_analise = nr_seq_analise_p;

					select 	count(1)
					into STRICT	qt_grupo_dif_pre_analise_w
					from	pls_auditoria_conta_grupo a
					where 	a.nr_seq_grupo <> nr_seq_grupo_pre_analise_w
					and	a.nr_seq_analise = nr_seq_analise_p;
				end if;

				CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'L', 'PLS_FINALIZAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);

				-- [30] - Liberar automáticamente análise quando não houver glosa e ocorrência (OPS - Controle de Produção Médica)
				ie_param_30_w := Obter_Param_Usuario(1285, 30, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_param_30_w);

				--Se somente tiver um fluxo na análise e o mesmo for vinculado ao grupo auditor da pré-análise e o parâmetro 51 ad função A500 estiver apontando que
				--deve ser encerrado atendimento, então o faz.
				--OBS: Mantenho a chamada para a rotina pls_alterar_status_analise_cta passando parâmetro L, para que faça atualização da pls_auditoria_conta_grupo e aqui nesse momento, chamo ela
				--novamente passando 'T' Atendimento encerrado,  que somente atualizará o status na pls_analise_conta
				if (qt_grupo_pre_analise_w > 0 and qt_grupo_dif_pre_analise_w = 0 and ie_param_51_w = 'S') then
					CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'T', 'PLS_FINALIZAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);
					ie_analise_encerrada_w	:= 'S';
				elsif (ie_param_30_w = 'S') then
					select 	count(1)
					into STRICT	qt_grupo_analise_w
					from	pls_auditoria_conta_grupo a
					where 	a.nr_seq_analise = nr_seq_analise_p;

					select	count(1)
					into STRICT	qt_glosa_conta_analise_w
					from	pls_conta_glosa	glosa,
						pls_conta	conta
					where	glosa.nr_seq_conta	= conta.nr_sequencia
					and	glosa.ie_situacao	= 'A'
					and	conta.ie_status		<> 'C'
					and	conta.nr_seq_analise	= nr_seq_analise_p;

					select	count(1)
					into STRICT	qt_proc_pendente_w
					from	pls_conta_proc a,
						pls_conta b
					where	b.nr_sequencia = a.nr_seq_conta
					and	b.nr_seq_analise = nr_seq_analise_p
					and	a.ie_status not in ('L','S','A','D','M');

					select	count(1)
					into STRICT	qt_mat_pendente_w
					from	pls_conta_mat a,
						pls_conta b
					where	b.nr_sequencia = a.nr_seq_conta
					and	b.nr_seq_analise = nr_seq_analise_p
					and	a.ie_status not in ('L','S','A','D','M');

					if (qt_grupo_analise_w = 0) and (qt_glosa_conta_analise_w = 0) and (qt_proc_pendente_w = 0) and (qt_mat_pendente_w = 0) then
						CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'T', 'PLS_FINALIZAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);
						ie_analise_encerrada_w	:= 'S';
					end if;
				end if;

				update	pls_analise_conta
				set	dt_liberacao_analise	= clock_timestamp(),
					dt_final_analise	= clock_timestamp()
				where	nr_sequencia		= nr_seq_analise_p;
			else
				/*Se o grupo de finalização existir na análise.*/

				if (ie_existe_final_anali_w = 'S') then
					select	count(nr_sequencia)
					into STRICT	qt_grupos_analise_w
					from	pls_auditoria_conta_grupo
					where	nr_seq_analise = nr_seq_analise_p;

					/*Se existir mais de uma grupo de analise*/

					if (qt_grupos_analise_w > 1) and (pls_obter_se_auditor_grupo(nr_seq_grupo_w, nm_usuario_p) = 'N') then
						/*Se o grupo de finalização existir na análise então seu sua liberação é desfeita. Permitindo que o mesmo se torne o fluxo da vez. */

						CALL pls_desf_final_grupo_analise(nr_seq_analise_p, nr_seq_grupo_w, null, nm_usuario_p, cd_estabelecimento_p,'N');
					else
						/*Se existir somente o grupo do auditor então é liberado a análise.*/

						CALL pls_alterar_status_analise_cta(nr_seq_analise_p, 'L', 'PLS_FINALIZAR_ANALISE_GRUPO', nm_usuario_p, cd_estabelecimento_p);

						update	pls_analise_conta
						set	dt_liberacao_analise	= clock_timestamp(),
							dt_final_analise	= clock_timestamp()
						where	nr_sequencia 		= nr_seq_analise_p;
					end if;
				else
					/*Se o grupo de finalização não existir na análise este é acrescentado*/

					CALL pls_inserir_grupo_analise(nr_seq_analise_p, nr_seq_grupo_w, 'Grupo inserido através da regra de finalização '||nr_seq_regra_w,
								nr_seq_grupo_atual_p, 'N', nm_usuario_p, cd_estabelecimento_p);
				end if;
			end if;
		end if;

		CALL pls_inserir_hist_analise(null, nr_seq_analise_p, 7, null, null, null, null, null, nr_seq_grupo_atual_p, nm_usuario_p, cd_estabelecimento_p);

		update	pls_analise_conta
		set	ie_status_pre_analise	= CASE WHEN ie_pre_analise='S' THEN 'F'  ELSE ie_status_pre_analise END
		where	nr_sequencia		= nr_seq_analise_p;

		CALL pls_atualizar_grupo_penden(nr_seq_analise_p, cd_estabelecimento_p, nm_usuario_p);

		select  max(a.nr_sequencia)
		into STRICT    nr_seq_fatura_w
		from    ptu_fatura              a,
			pls_conta               b
		where   b.nr_seq_fatura         = a.nr_sequencia
		and     b.nr_seq_analise        = nr_seq_analise_p;

		/* Atualizar valores PTU Fatura*/

		CALL pls_atualizar_valor_ptu_fatura(nr_seq_fatura_w,'N');

		if (ie_commit_p = 'S') then
			SELECT * FROM pls_tratar_cont_fluxo_analise(nr_seq_analise_p, nr_seq_grupo_atual_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_grupo_final_w, ie_fechar_contas_w) INTO STRICT nr_seq_grupo_final_w, ie_fechar_contas_w;
		end if;

		if (nr_seq_grupo_final_w IS NOT NULL AND nr_seq_grupo_final_w::text <> '') then
			ds_mensagem_retorno_w := pls_finalizar_analise_grupo(nr_seq_analise_p, nm_usuario_p, nr_seq_grupo_final_w, 'N', 'N', cd_estabelecimento_p, 'N', ie_lib_automatic_p, ie_glosa_atend_p, ie_origem_finalizacao_p, ds_mensagem_retorno_w);
		end if;

		if (ie_fechar_contas_w = 'S') or (ie_analise_encerrada_w	= 'S')then
			CALL pls_analise_fechar_contas(nr_seq_analise_p, nr_seq_grupo_final_w, cd_estabelecimento_p, nm_usuario_p, 'N');
		end if;

		if (coalesce(ie_commit_p,'S') = 'S') then
			commit;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_analise_grupo ( nr_seq_analise_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p bigint, ie_consistir_pendencias_p text, ie_alerta_confirmado_p text, cd_estabelecimento_p bigint, ie_commit_p text, ie_lib_automatic_p text, ie_glosa_atend_p text, ie_origem_finalizacao_p text, ds_mensagem_retorno_p INOUT text) FROM PUBLIC;

