-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_carrega_guias_lote_apres (nr_seq_cta_regra_apres_aut_p pls_cta_regra_apres_aut.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	tornar o processo de geração do lote de apresentação automatico automatizado.
	Esta rotina verifica as guias disponíveis e cria o lote de apresentação automática.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
hr_exec_w		varchar(10);
ie_permite_analise_w	varchar(2);
ie_consiste_valor_w	varchar(2);
ie_consiste_qtd_w	varchar(2);
ie_executa_job_w	varchar(1);
ie_valido_w		varchar(1);
nr_lote_gerado_w	integer;
dt_mes_competencia_w	timestamp;
dt_execucao_w		timestamp;
dt_proxima_exec_w	timestamp;
qt_item_regra_w		integer;
dt_inicio_ref_w		pls_lote_apres_automatica.dt_ref_inicial%type;
dt_fim_ref_w		pls_lote_apres_automatica.dt_ref_final%type;
ie_tipo_guia_w		pls_lote_apres_automatica.ie_tipo_guia%type;
nr_seq_lote_apres_w	pls_lote_apres_automatica.nr_sequencia%type;
ie_referencia_data_w	pls_lote_apres_automatica.ie_referencia_data%type;
nr_dia_geracao_w	pls_cta_regra_apres_aut.nr_dia_geracao%type;
ie_forma_geracao_w	pls_cta_regra_apres_aut.ie_forma_geracao%type;
qt_max_conta_w		pls_cta_regra_apres_aut.qt_max_conta%type;
ie_data_competencia_w	pls_cta_regra_apres_aut.ie_data_competencia%type;
dt_inicio_fluxo_w	pls_cta_regra_apres_aut.dt_inicio_fluxo%type;
dt_fim_fluxo_w		pls_cta_regra_apres_aut.dt_fim_fluxo%type;
dt_exec_proc_w		pls_cta_regra_apres_aut.dt_exec_proc%type;
nr_ultimo_dia_w		pls_cta_regra_apres_item.dt_fim_fluxo%type;
nr_seq_lote_apres_min_w pls_lote_apres_automatica.nr_sequencia%type;
qt_filas_paralelo_w	pls_parametros.qt_filas_paralelo%type;
nr_seq_prestador_ant_w	pls_guia_plano.nr_seq_prestador%type;

C01 CURSOR(	ie_referencia_data_pc		pls_lote_apres_automatica.ie_referencia_data%type,
		dt_inicio_ref_pc		pls_lote_apres_automatica.dt_ref_inicial%type,
		dt_fim_ref_pc			pls_lote_apres_automatica.dt_ref_final%type,
		cd_estabelecimento_pc		estabelecimento.cd_estabelecimento%type,
		ie_tipo_guia_pc			pls_conta.ie_tipo_guia%type,
		nr_seq_regra_apres_aut_pc	pls_lote_apres_automatica.nr_seq_regra_apres_aut%type) FOR  --cursor das guias
	SELECT	a.nr_seq_prestador nr_seq_prestador,
		a.ie_tipo_guia,
		(SELECT count(1) from pls_conta conta where conta.nr_seq_guia = a.nr_sequencia and ie_status <> 'C') qt_conta,
		(select count(1) from pls_apres_automatica_guia g where g.nr_seq_guia = a.nr_sequencia and not exists (select 1 from pls_conta c where c.nr_seq_guia = g.nr_seq_guia and c.ie_status = 'C')) qt_guia,
		(select	max(x.nr_seq_tipo_prestador) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_tipo_prestador,
		(select	max(x.nr_seq_classificacao) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_classificacao
	from	pls_guia_plano	a
	where	a.ie_status = '1'
	and	a.ie_pagamento_automatico	= 'PA'
	and	a.cd_estabelecimento		= cd_estabelecimento_pc
	and	ie_referencia_data_pc = 'E'
	and 	exists (	select 	1
			from	pls_execucao_requisicao b
			where	b.nr_seq_guia = a.nr_sequencia
			and	b.dt_execucao between dt_inicio_ref_pc and dt_fim_ref_pc)
	and	((a.ie_tipo_guia  = ie_tipo_guia_pc) or (coalesce(ie_tipo_guia_pc::text, '') = '' and a.ie_tipo_guia in ('1','2','3')))
	and	((coalesce(nr_seq_regra_apres_aut_pc::text, '') = '') or (nr_seq_regra_apres_aut_pc = a.nr_seq_pgto_aut))
	
union all

	select	a.nr_seq_prestador nr_seq_prestador,
		a.ie_tipo_guia,
		(select count(1) from pls_conta conta where conta.nr_seq_guia = a.nr_sequencia and ie_status <> 'C') qt_conta,
		(select count(1) from pls_apres_automatica_guia g where g.nr_seq_guia = a.nr_sequencia and not exists (select 1 from pls_conta c where c.nr_seq_guia = g.nr_seq_guia and c.ie_status = 'C')) qt_guia,
		(select	max(x.nr_seq_tipo_prestador) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_tipo_prestador,
		(select	max(x.nr_seq_classificacao) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_classificacao
	from	pls_guia_plano	a
	where	a.ie_status = '1'
	and	a.ie_pagamento_automatico	= 'PA'
	and	a.cd_estabelecimento		= cd_estabelecimento_pc
	and	ie_referencia_data_pc = 'S'
	and	a.dt_solicitacao between dt_inicio_ref_pc and dt_fim_ref_pc
	and	((a.ie_tipo_guia  = ie_tipo_guia_pc) or (coalesce(ie_tipo_guia_pc::text, '') = '' and a.ie_tipo_guia in ('1','2','3')))
	and	((coalesce(nr_seq_regra_apres_aut_pc::text, '') = '') or (nr_seq_regra_apres_aut_pc = a.nr_seq_pgto_aut))
	
union all

	select	a.nr_seq_prestador nr_seq_prestador,
		a.ie_tipo_guia,
		(select count(1) from pls_conta conta where conta.nr_seq_guia = a.nr_sequencia and ie_status <> 'C') qt_conta,
		(select count(1) from pls_apres_automatica_guia g where g.nr_seq_guia = a.nr_sequencia and not exists (select 1 from pls_conta c where c.nr_seq_guia = g.nr_seq_guia and c.ie_status = 'C')) qt_guia,
		(select	max(x.nr_seq_tipo_prestador) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_tipo_prestador,
		(select	max(x.nr_seq_classificacao) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_classificacao
	from	pls_guia_plano	a
	where	a.ie_status = '1'
	and	a.ie_pagamento_automatico	= 'PA'
	and	a.cd_estabelecimento		= cd_estabelecimento_pc
	and	ie_referencia_data_pc = 'N'
	and	((a.ie_tipo_guia  = ie_tipo_guia_pc) or (coalesce(ie_tipo_guia_pc::text, '') = '' and a.ie_tipo_guia in ('1','2','3')))
	and	((coalesce(nr_seq_regra_apres_aut_pc::text, '') = '') or (nr_seq_regra_apres_aut_pc = a.nr_seq_pgto_aut))
	
union all

	select	a.nr_seq_prestador nr_seq_prestador,
		a.ie_tipo_guia,
		(select count(1) from pls_conta conta where conta.nr_seq_guia = a.nr_sequencia and ie_status <> 'C') qt_conta,
		(select count(1) from pls_apres_automatica_guia g where g.nr_seq_guia = a.nr_sequencia and not exists (select 1 from pls_conta c where c.nr_seq_guia = g.nr_seq_guia and c.ie_status = 'C')) qt_guia,
		(select	max(x.nr_seq_tipo_prestador) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_tipo_prestador,
		(select	max(x.nr_seq_classificacao) from pls_prestador x where x.nr_sequencia = a.nr_seq_prestador) nr_seq_classificacao
	from	pls_guia_plano	a
	where	a.ie_status = '1'
	and	a.ie_pagamento_automatico	= 'PA'
	and	a.cd_estabelecimento		= cd_estabelecimento_pc
	and	ie_referencia_data_pc = 'A'
	and	a.dt_autorizacao between dt_inicio_ref_pc and dt_fim_ref_pc
	and	((a.ie_tipo_guia  = ie_tipo_guia_pc) or (coalesce(ie_tipo_guia_pc::text, '') = '' and a.ie_tipo_guia in ('1','2','3')))
	and	((coalesce(nr_seq_regra_apres_aut_pc::text, '') = '') or (nr_seq_regra_apres_aut_pc = a.nr_seq_pgto_aut))
	order by nr_seq_prestador;

C02 CURSOR(nr_seq_lote_apres_pc	pls_lote_apres_automatica.nr_sequencia%type)FOR
	SELECT 	distinct p.nr_seq_lote_conta
	from	pls_protocolo_conta	p
	where	p.nr_seq_lote_apres_autom >= nr_seq_lote_apres_pc
	and	not exists (SELECT	1
				from	pls_lote_protocolo_conta l
				where	l.nr_sequencia	= p.nr_seq_lote_conta
				and	l.ie_status 	in ('A','X','G'));

C03 CURSOR(	nr_seq_regra_pc		pls_cta_regra_apres_aut.nr_sequencia%type) FOR
	SELECT	coalesce(dt_inicio_fluxo,1) dt_inicio_fluxo,
		coalesce(dt_fim_fluxo,31) dt_fim_fluxo,
		CASE WHEN ie_tipo_guia='5' THEN '1' WHEN ie_tipo_guia='4' THEN '2'  ELSE ie_tipo_guia END  ie_tipo_guia,
		nr_seq_grupo_prestador,
		nr_seq_tipo_prestador,
		nr_seq_regra_apres_aut
	from	pls_cta_regra_apres_item
	where	nr_seq_regra = nr_seq_regra_pc
	and	ie_situacao = 'A'
	order by
		coalesce(dt_inicio_fluxo,1),
		coalesce(dt_fim_fluxo,31),
		ie_tipo_guia,
		coalesce(nr_seq_grupo_prestador,0),
		coalesce(nr_seq_tipo_prestador,0);

C04 CURSOR(	nr_seq_lote_apres_autom_pc	pls_lote_apres_automatica.nr_sequencia%type) FOR
	SELECT 	nr_seq_lote_conta nr_seq_lote
	from  	pls_protocolo_conta
	where  	nr_seq_lote_apres_autom = nr_seq_lote_apres_autom_pc
	group by nr_seq_lote_conta;
BEGIN

select 	coalesce(max(qt_filas_paralelo),0)
into STRICT	qt_filas_paralelo_w
from	pls_parametros
where 	cd_estabelecimento = cd_estabelecimento_p;

ie_executa_job_w := 'S';
--obtém a forma de geração e o número maximo de contas por protocolo da regra
select	max(ie_forma_geracao),
	max(qt_max_conta),
	coalesce(max(ie_referencia_data),'S'),
	max(ie_data_competencia),
	coalesce(max(dt_inicio_fluxo),1),
	coalesce(max(dt_fim_fluxo),30)
into STRICT	ie_forma_geracao_w,
	qt_max_conta_w,
	ie_referencia_data_w,
	ie_data_competencia_w,
	dt_inicio_fluxo_w,
	dt_fim_fluxo_w
from	pls_cta_regra_apres_aut
where	nr_sequencia = nr_seq_cta_regra_apres_aut_p;

select	count(1)
into STRICT	qt_item_regra_w
from	pls_cta_regra_apres_item
where	ie_situacao = 'A';

if (coalesce(ie_data_competencia_w, 'N') = 'N') then
	dt_mes_competencia_w 	:= trunc(clock_timestamp(),'month'); --dt_mes_competencia recebe o mes atual
else
	dt_mes_competencia_w 	:= clock_timestamp(); --dt_mes_competencia recebe o mes atual
end if;

if (ie_forma_geracao_w = 'D') then
	--caso a geração seja diária, inicio e fim referencia será o dia atual
	dt_inicio_ref_w 	:= trunc(clock_timestamp()) - 30; --Tratativa realizada para buscar todas as contas do último mês, Caso tenha gerado no dia anterior somente pegará do dia, caso não pega as que ficaram de fora
	dt_fim_ref_w		:= fim_dia(clock_timestamp());
else
	--caso a geração seja mensal, inicio e fim referencia será o inicio e o fim do mes competencia
	dt_inicio_ref_w := dt_mes_competencia_w;
	dt_fim_ref_w	:= last_day(dt_mes_competencia_w);
end if;

if (dt_exec_proc_w IS NOT NULL AND dt_exec_proc_w::text <> '') then
	hr_exec_w := to_char(dt_exec_proc_w, 'hh24:mi:ss');
else
	hr_exec_w := to_char((fim_dia(clock_timestamp()) - 1/3072), 'hh24:mi:ss');
end if;

if (qt_item_regra_w > 0) and (ie_forma_geracao_w = 'D') then

	for r_C03_w in C03(nr_seq_cta_regra_apres_aut_p) loop

		nr_ultimo_dia_w := (to_char(fim_mes(clock_timestamp()),'dd'))::numeric;
		nr_seq_prestador_ant_w	:= 0;
		if (nr_ultimo_dia_w > r_C03_w.dt_fim_fluxo) then
			nr_ultimo_dia_w := r_C03_w.dt_fim_fluxo;
		end if;

		if (trunc(clock_timestamp()) >= to_date(r_C03_w.dt_inicio_fluxo || '/' || to_char(clock_timestamp(), 'mm/yyyy'))) and (trunc(clock_timestamp()) <= fim_dia(to_date(nr_ultimo_dia_w || '/' || to_char(clock_timestamp(), 'mm/yyyy')))) then
			for r_C01_w in C01(ie_referencia_data_w, dt_inicio_ref_w, dt_fim_ref_w, cd_estabelecimento_p, r_C03_w.ie_tipo_guia, r_c03_w.nr_seq_regra_apres_aut) loop

				if (r_C01_w.qt_conta = 0 and r_C01_w.qt_guia = 0) then

					ie_valido_w := 'S';

					if (r_C03_w.nr_seq_grupo_prestador IS NOT NULL AND r_C03_w.nr_seq_grupo_prestador::text <> '') then
						ie_valido_w := pls_se_grupo_preco_prestador(r_C03_w.nr_seq_grupo_prestador, r_C01_w.nr_seq_prestador, r_C01_w.nr_seq_classificacao);
					end if;

					if (r_C03_w.nr_seq_tipo_prestador IS NOT NULL AND r_C03_w.nr_seq_tipo_prestador::text <> '') and (ie_valido_w = 'S') then
						ie_valido_w := 'N';
						if (r_C03_w.nr_seq_tipo_prestador = r_C01_w.nr_seq_tipo_prestador) then
							ie_valido_w := 'S';
						end if;
					end if;

					if (ie_valido_w = 'S') and (nr_seq_prestador_ant_w != r_c01_w.nr_seq_prestador)then
						--tratativa realizada pois no lote de apresentação somente são aceitas guias de internação, solicitação e consulta
						if (r_c01_w.ie_tipo_guia = '1') then --Guia de solicitação internação
							ie_tipo_guia_w := '5'; --Guia de Resumo de Internação
						elsif (r_c01_w.ie_tipo_guia = '2') then --Guia de solicitação SP/SADT
							ie_tipo_guia_w := '4'; --Guia de SP/SADT
						elsif (r_c01_w.ie_tipo_guia = '3') then --Guia de consulta
							ie_tipo_guia_w := '3'; --Guia de consulta
						end if;

						--Verifica se ja existe lote de apresetação automática para a guia
						select	count(1)
						into STRICT	nr_lote_gerado_w
						from	pls_lote_apres_automatica a
						where	a.dt_mes_competencia 	between inicio_dia(dt_mes_competencia_w) and fim_dia(last_day(dt_mes_competencia_w))
						and	a.dt_ref_inicial	between inicio_dia(dt_inicio_ref_w) and fim_dia(dt_inicio_ref_w)
						and 	a.dt_ref_final 		between inicio_dia(dt_fim_ref_w) and fim_dia(dt_fim_ref_w)
						and (coalesce(a.nr_seq_prestador::text, '') = '' or a.nr_seq_prestador = r_c01_w.nr_seq_prestador)
						and (coalesce(a.ie_tipo_guia::text, '') = '' or a.ie_tipo_guia = ie_tipo_guia_w)  LIMIT 1;

							--caso não, gera um novo lote
						if (nr_lote_gerado_w = 0) then
							nr_seq_prestador_ant_w	:= r_c01_w.nr_seq_prestador;

							insert	into	pls_lote_apres_automatica(	nr_sequencia,nm_usuario,dt_atualizacao,
									cd_estabelecimento,nm_usuario_nrec,dt_atualizacao_nrec,
									dt_integracao,dt_mes_competencia,dt_ref_final,
									dt_ref_inicial,ie_guia_apresentada,ie_preco,
									ie_referencia_data,ie_situacao_cid,ie_tipo_guia,
									ie_tipo_repasse,nr_seq_cta_regra_apres_aut,nr_seq_prestador,
									ie_status)
								values (	nextval('pls_lote_apres_automatica_seq'),nm_usuario_p,clock_timestamp(),
									cd_estabelecimento_p,nm_usuario_p,clock_timestamp(),
									null,dt_mes_competencia_w,dt_fim_ref_w,
									dt_inicio_ref_w,null,null,
									ie_referencia_data_w,'A',ie_tipo_guia_w,
									null,nr_seq_cta_regra_apres_aut_p,r_c01_w.nr_seq_prestador,
									'2')
								returning nr_sequencia into nr_seq_lote_apres_w;

							if (coalesce(nr_seq_lote_apres_min_w::text, '') = '') then
								nr_seq_lote_apres_min_w := nr_seq_lote_apres_w;
							end if;
							--Gera as guias no lote de apresentação automática
							CALL pls_w_pls_guias_gera_conta(nr_seq_lote_apres_w, nm_usuario_p, cd_estabelecimento_p);

							-- Após a geração da guia, integra as guias do lote
							CALL pls_gerar_guia_conta_lote(nr_seq_lote_apres_w, null, cd_estabelecimento_p, nm_usuario_p, qt_max_conta_w);

							--Se quantidade de filas for maior que zero, entao registro no processamento paralelo para posterior geração automática via  job.
							if (qt_filas_paralelo_w > 0) then

								for r_c04_w in C04(nr_seq_lote_apres_w) loop
									insert into pls_cta_lt_ger_lote_compl(nr_sequencia,dt_atualizacao,nm_usuario,
												dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_lote_protocolo,
												dt_solicitacao,ie_status)
									values (  	nextval('pls_cta_lt_ger_lote_compl_seq'),clock_timestamp(),nm_usuario_p,
												clock_timestamp(),nm_usuario_p, r_c04_w.nr_seq_lote,
												clock_timestamp(),'P' );
								end loop;
							end if;

						end if;
					end if;
				end if;
			end loop;
		end if;
	end loop;

	--Se quantidade de filas for maior que zero, entao não irá gerar aqui as análises e sim automaticamente via job.
	if (qt_filas_paralelo_w = 0) then
		-- Verifica se o usuario tem permissão para gerar análise
		ie_permite_analise_w := pls_obter_se_gera_analise(nr_seq_lote_apres_min_w, cd_estabelecimento_p, nm_usuario_p);

		if (coalesce(ie_permite_analise_w,'S') = 'S') then
			--Parametro "[13] - Consistir o valor apresentado do protocolo com o total apresentado das contas" da função "OPS - Controle de Produção Médica"
			ie_consiste_valor_w := obter_valor_param_usuario(1285, 13, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);
			--Parametro "[17] - Consistir a quantidade máxima de contas com o total de contas do protocolo" da função "OPS - Controle de Produção Médica"
			ie_consiste_qtd_w := obter_valor_param_usuario(1285, 17, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);

			for r_C02_w in C02(nr_seq_lote_apres_min_w)loop
				CALL pls_gerar_analise_lote(r_C02_w.nr_seq_lote_conta, ie_consiste_valor_w, ie_consiste_qtd_w,
							cd_estabelecimento_p, nm_usuario_p, null,
							'S', null);
			end loop;
		end if;
	end if;
else
	for r_C01_w in C01(ie_referencia_data_w, dt_inicio_ref_w, dt_fim_ref_w, cd_estabelecimento_p, null,null) loop

		if (r_C01_w.qt_conta = 0 and r_C01_w.qt_guia = 0) then

			--tratativa realizada pois no lote de apresentação somente são aceitas guias de internação, solicitação e consulta
			if (r_c01_w.ie_tipo_guia = '1') then --Guia de solicitação internação
				ie_tipo_guia_w := '5'; --Guia de Resumo de Internação
			elsif (r_c01_w.ie_tipo_guia = '2') then --Guia de solicitação SP/SADT
				ie_tipo_guia_w := '4'; --Guia de SP/SADT
			elsif (r_c01_w.ie_tipo_guia = '3') then --Guia de consulta
				ie_tipo_guia_w := '3'; --Guia de consulta
			end if;

			--Verifica se ja existe lote de apresetação automática para a guia
			select	count(1)
			into STRICT	nr_lote_gerado_w
			from	pls_lote_apres_automatica a
			where	a.dt_mes_competencia 	between inicio_dia(dt_mes_competencia_w) and fim_dia(last_day(dt_mes_competencia_w))
			and	a.dt_ref_inicial	between inicio_dia(dt_inicio_ref_w) and fim_dia(dt_inicio_ref_w)
			and 	a.dt_ref_final 		between inicio_dia(dt_fim_ref_w) and fim_dia(dt_fim_ref_w)
			and (coalesce(a.nr_seq_prestador::text, '') = '' or a.nr_seq_prestador = r_c01_w.nr_seq_prestador)
			and (coalesce(a.ie_tipo_guia::text, '') = '' or a.ie_tipo_guia = ie_tipo_guia_w)  LIMIT 1;

				--caso não, gera um novo lote
			if (nr_lote_gerado_w = 0) then

				insert	into	pls_lote_apres_automatica(	nr_sequencia,nm_usuario,dt_atualizacao,
						cd_estabelecimento,nm_usuario_nrec,dt_atualizacao_nrec,
						dt_integracao,dt_mes_competencia,dt_ref_final,
						dt_ref_inicial,ie_guia_apresentada,ie_preco,
						ie_referencia_data,ie_situacao_cid,ie_tipo_guia,
						ie_tipo_repasse,nr_seq_cta_regra_apres_aut,nr_seq_prestador,
						ie_status)
					values (	nextval('pls_lote_apres_automatica_seq'),nm_usuario_p,clock_timestamp(),
						cd_estabelecimento_p,nm_usuario_p,clock_timestamp(),
						null,dt_mes_competencia_w,dt_fim_ref_w,
						dt_inicio_ref_w,null,null,
						ie_referencia_data_w,'A',ie_tipo_guia_w,
						null,nr_seq_cta_regra_apres_aut_p,r_c01_w.nr_seq_prestador,
						'2')
					returning nr_sequencia into nr_seq_lote_apres_w;

				if (coalesce(nr_seq_lote_apres_min_w::text, '') = '') then
					nr_seq_lote_apres_min_w := nr_seq_lote_apres_w;
				end if;
				--Gera as guias no lote de apresentação automática
				CALL pls_w_pls_guias_gera_conta(nr_seq_lote_apres_w, nm_usuario_p, cd_estabelecimento_p);

				-- Após a geração da guia, integra as guias do lote
				CALL pls_gerar_guia_conta_lote(nr_seq_lote_apres_w, null, cd_estabelecimento_p, nm_usuario_p, qt_max_conta_w);

				--Se quantidade de filas for maior que zero, entao registro no processamento paralelo para posterior geração automática via  job.
				if (qt_filas_paralelo_w > 0) then

					for r_c04_w in C04( nr_seq_lote_apres_w ) loop
						insert into pls_cta_lt_ger_lote_compl(nr_sequencia,dt_atualizacao,nm_usuario,
									dt_atualizacao_nrec,nm_usuario_nrec,nr_seq_lote_protocolo,
									dt_solicitacao,ie_status)
						values (  	nextval('pls_cta_lt_ger_lote_compl_seq'),clock_timestamp(),nm_usuario_p,
									clock_timestamp(),nm_usuario_p, r_c04_w.nr_seq_lote,
									clock_timestamp(),'P' );
					end loop;
				end if;

			end if;
		end if;
	end loop;
	-- Verifica se o usuario tem permissão para gerar análise
	ie_permite_analise_w := pls_obter_se_gera_analise(nr_seq_lote_apres_min_w, cd_estabelecimento_p, nm_usuario_p);

	--Se quantidade de filas for maior que zero, entao não irá gerar aqui as análises e sim automaticamente via job.
	if (qt_filas_paralelo_w = 0) then
		if (coalesce(ie_permite_analise_w,'S') = 'S') then
			--Parametro "[13] - Consistir o valor apresentado do protocolo com o total apresentado das contas" da função "OPS - Controle de Produção Médica"
			ie_consiste_valor_w := obter_valor_param_usuario(1285, 13, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);
			--Parametro "[17] - Consistir a quantidade máxima de contas com o total de contas do protocolo" da função "OPS - Controle de Produção Médica"
			ie_consiste_qtd_w := obter_valor_param_usuario(1285, 17, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);

			for r_C02_w in C02(nr_seq_lote_apres_min_w)loop
				CALL pls_gerar_analise_lote(r_C02_w.nr_seq_lote_conta, ie_consiste_valor_w, ie_consiste_qtd_w,
							cd_estabelecimento_p, nm_usuario_p, null,
							'S', null);
			end loop;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_carrega_guias_lote_apres (nr_seq_cta_regra_apres_aut_p pls_cta_regra_apres_aut.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

