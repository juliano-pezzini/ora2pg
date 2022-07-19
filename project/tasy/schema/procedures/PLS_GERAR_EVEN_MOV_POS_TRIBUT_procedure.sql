-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_even_mov_pos_tribut (nr_seq_pagamento_p pls_pagamento_prestador.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_incidencia_lanc_prog_w	pls_evento.ie_incidencia_lanc_prog%type;
nr_seq_tipo_prestador_w		pls_prestador.nr_seq_tipo_prestador%type;
nr_seq_prestador_orig_w		pls_prestador.nr_sequencia%type;
nr_seq_prestador_pgto_w		pls_prestador.nr_sequencia%type;
nr_seq_classificacao_w		pls_prestador.nr_seq_classificacao%type;
vl_liquido_estornar_w		pls_pag_prest_vencimento.vl_liquido%type;
vl_liquido_original_w		pls_pag_prest_vencimento.vl_liquido%type;
nr_seq_evento_movto_w		pls_evento_movimento.nr_sequencia%type;
nr_seq_periodo_pag_w		pls_periodo_pagamento.nr_sequencia%type;
nr_seq_prest_princ_w		pls_prestador.nr_seq_prest_princ%type;
dt_mes_competencia_w		pls_lote_evento.dt_competencia%type;
nr_seq_evento_lote_w		pls_lote_evento.nr_seq_evento%type;
nr_seq_lote_evento_w		pls_lote_evento.nr_sequencia%type;
cd_conta_contabil_w		pls_evento_movimento.cd_conta_contabil%type;
nr_seq_regra_fixo_w		pls_evento_regra_fixo.nr_sequencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
ie_complementar_w		pls_periodo_pagamento.ie_complementar%type;
nr_seq_lote_pag_w		pls_lote_pagamento.nr_sequencia%type;
dt_inicio_comp_w		pls_lote_pagamento.dt_inicio_comp%type;
nr_seq_regra_w			pls_prestador_crit_receb.nr_sequencia%type;
dt_fim_comp_w			pls_lote_pagamento.dt_fim_comp%type;
ie_situacao_w			pls_prestador.ie_situacao%type;
qt_registro_w			integer;
vl_regra_w			pls_evento_regra_fixo.vl_regra%type;
ie_gerar_w			varchar(5);

c01 CURSOR(	nr_seq_prestador_pc		pls_prestador.nr_sequencia%type,
		nr_seq_tipo_prestador_pc	pls_prestador.nr_seq_tipo_prestador%type,
		ie_situacao_pc			pls_prestador.ie_situacao%type,
		dt_competencia_pc		pls_lote_evento.dt_competencia%type,
		nr_seq_evento_lote_pc		pls_evento.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia nr_seq_evento,
		b.ie_forma_incidencia,
		CASE WHEN coalesce(b.ie_forma_valor, 'I')='I' THEN  coalesce(b.vl_regra, 0)  ELSE null END  vl_regra,
		b.nr_sequencia nr_seq_regra_fixo,
		substr(b.ds_observacao,1,2000) ds_observacao,
		b.cd_condicao_pagamento,
		b.nr_seq_periodo,
		b.nr_seq_classe_titulo,
		b.qt_dia_venc,
		coalesce(a.ie_incidencia_lanc_prog,'N') ie_incidencia_lanc_prog,
		coalesce(b.ie_prestador_matriz,'N') ie_prestador_matriz,
		b.dt_movimento,
		coalesce(b.ie_titulo_pagar, 'N') ie_titulo_pagar,
		b.cd_pf_titulo_pagar,
		b.cd_cgc_titulo_pagar,
		b.nr_seq_trans_fin_baixa,
		b.nr_seq_trans_fin_contab,
		coalesce(a.ie_consiste_periodo_pag, 'S') ie_consiste_periodo_pag,
		b.cd_centro_custo,
		coalesce(b.ie_forma_valor,'I') ie_forma_valor,
		abs(c.pr_valor) pr_valor,
		abs(c.vl_maximo) vl_maximo,
		abs(c.vl_fixo) vl_fixo
	FROM pls_evento a, pls_evento_regra_fixo b
LEFT OUTER JOIN pls_evento_fixo_valor c ON (b.nr_sequencia = c.nr_seq_regra_fixo)
WHERE a.nr_sequencia = b.nr_seq_evento  and a.ie_situacao = 'A' and a.ie_natureza = 'D' and a.ie_tipo_evento = 'F' and coalesce(b.ie_gerar_apos_tributacao,'N') = 'S' and coalesce(b.nr_seq_prestador,nr_seq_prestador_pc) = nr_seq_prestador_pc and coalesce(b.nr_seq_tipo_prestador,nr_seq_tipo_prestador_pc) = nr_seq_tipo_prestador_pc and ((coalesce(b.ie_situacao_prest,ie_situacao_pc) = ie_situacao_pc) or (b.ie_situacao_prest = 'T')) and (exists	(SELECT	1
			from	pls_prestador x
			where	x.nr_sequencia = nr_seq_prestador_pc
			and	((pls_obter_situacao_coop_prest(x.cd_pessoa_fisica,x.cd_cgc) = b.nr_seq_sit_coop) or (coalesce(b.nr_seq_sit_coop::text, '') = ''))
			and	substr(pls_obter_se_cooperado(x.cd_pessoa_fisica,x.cd_cgc),1,1) = 'S') or (coalesce(b.ie_cooperado,'N') = 'N')) and b.ie_forma_incidencia <> 'U' and dt_competencia_pc between trunc(b.dt_inicio_vigencia,'month') and coalesce(trunc(b.dt_fim_vigencia,'month'),dt_competencia_pc) and a.nr_sequencia = coalesce(nr_seq_evento_lote_pc,a.nr_sequencia) order by coalesce(b.nr_ordem_execucao,0) desc,
		coalesce(b.nr_seq_ordem,0),
		a.nr_sequencia;

BEGIN

-- Busca o valor líquido do vencimento do pagamento do prestaodr
select	coalesce(max(vl_liquido),0)
into STRICT	vl_liquido_original_w
from	pls_pag_prest_vencimento
where	nr_seq_pag_prestador = nr_seq_pagamento_p;

-- Só gera eventos que devem ser gerados após a tributação se o valor líquido de pagamento for positivo
if (vl_liquido_original_w > 0) then

	-- Armazena o valor líquido do pagamento em uma variável a qual terá seu valor diminuido conforme geração dos itens
	vl_liquido_estornar_w := vl_liquido_original_w;

	-- Busca informações do pagamento do prestador
	select	nr_seq_lote,
		nr_seq_prestador
	into STRICT	nr_seq_lote_pag_w,
		nr_seq_prestador_w
	from	pls_pagamento_prestador
	where	nr_sequencia = nr_seq_pagamento_p;

	-- Busca informações do prestador do pagamento
	select	coalesce(nr_seq_tipo_prestador,0),
		coalesce(ie_situacao,'A'),
		nr_seq_classificacao
	into STRICT	nr_seq_tipo_prestador_w,
		ie_situacao_w,
		nr_seq_classificacao_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_w;

	-- Busca informações do lote de pagamento
	select	dt_inicio_comp,
		dt_fim_comp,
		dt_mes_competencia
	into STRICT	dt_inicio_comp_w,
		dt_fim_comp_w,
		dt_mes_competencia_w
	from	pls_lote_pagamento
	where	nr_sequencia = nr_seq_lote_pag_w;

	-- Variável que controla se o lote de pagamento é complementar
	ie_complementar_w := 'N';

	-- Busca o período do lote de pagamento
	select	max(nr_seq_periodo)
	into STRICT	nr_seq_periodo_pag_w
	from	pls_lote_pagamento a
	where	a.nr_sequencia = nr_seq_lote_pag_w;

	-- Busca se o período do pagamento em questão é lote complementar
	if (nr_seq_periodo_pag_w IS NOT NULL AND nr_seq_periodo_pag_w::text <> '') then
		select	coalesce(ie_complementar,'N')
		into STRICT	ie_complementar_w
		from	pls_periodo_pagamento
		where	nr_sequencia = nr_seq_periodo_pag_w;
	end if;

	-- Busca todas as regras de lançamentos programados (periódicos) que devem ser lançados após a tributação
	for r_C01_w in C01(nr_seq_prestador_w, nr_seq_tipo_prestador_w, ie_situacao_w, dt_mes_competencia_w, nr_seq_evento_lote_w) loop

		vl_regra_w := 0;
		-- O campo 'vl_liquido_estornar_w' irá permitir a execução do loop e calculo dos valores enquanto houver valor líquido
		if (vl_liquido_estornar_w > 0) then
			-- Define que até o momento a regra é válida e pode ser gerada na movimentação
			ie_gerar_w := 'S';

			-- Busca o prestador principal
			if (r_C01_w.ie_prestador_matriz = 'S') then
				select	nr_seq_prest_princ
				into STRICT	nr_seq_prest_princ_w
				from	pls_prestador
				where	nr_sequencia = nr_seq_prestador_w;

				-- Se encontra prestador principal, passa a utiliza-lo
				if (nr_seq_prest_princ_w IS NOT NULL AND nr_seq_prest_princ_w::text <> '') then
					nr_seq_prestador_w := nr_seq_prest_princ_w;
				end if;
			end if;

			if (ie_complementar_w = 'N') then
				if	((r_C01_w.ie_consiste_periodo_pag = 'S') or (nr_seq_lote_pag_w IS NOT NULL AND nr_seq_lote_pag_w::text <> '')) then
					ie_gerar_w := pls_obter_se_evento_inside_per(nr_seq_periodo_pag_w, r_C01_w.nr_seq_evento, nr_seq_prestador_w, dt_mes_competencia_w, coalesce(r_C01_w.dt_movimento,trunc(dt_mes_competencia_w,'dd')));
				end if;
			else
				ie_gerar_w := pls_obter_se_entra_pgto_compl(nr_seq_lote_pag_w, r_C01_w.nr_seq_evento, nr_seq_prestador_w, nr_seq_tipo_prestador_w, nr_seq_classificacao_w);
			end if;

			nr_seq_prestador_pgto_w := null;
			nr_seq_prestador_orig_w := nr_seq_prestador_w;

			SELECT * FROM pls_obter_prest_pgto_prof( 	nr_seq_prestador_w, null, null, null, nm_usuario_p, null, clock_timestamp(), nr_seq_prestador_pgto_w, nr_seq_regra_w) INTO STRICT nr_seq_prestador_pgto_w, nr_seq_regra_w;

			if (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
				nr_seq_prestador_w := nr_seq_prestador_pgto_w;
			end if;

			if (ie_gerar_w = 'S') then
				if (r_C01_w.ie_forma_incidencia = 'S') then -- Verifica se já existe uma ocorrência dentro da semana
					select	count(1)
					into STRICT	qt_registro_w
					from	pls_evento_movimento
					where	nr_seq_evento = r_C01_w.nr_seq_evento
					and	nr_seq_prestador in (nr_seq_prestador_w, nr_seq_prestador_orig_w)
					and	dt_movimento	between(trunc(dt_mes_competencia_w,'dd') - (to_char(dt_mes_competencia_w,'d'))::numeric  + 1) and (trunc(dt_mes_competencia_w,'dd') - (to_char(dt_mes_competencia_w,'d'))::numeric  + 8)
					and	coalesce(ie_cancelamento::text, '') = ''  LIMIT 1;

					if (qt_registro_w > 0) then
						ie_gerar_w := 'N';
					end if;
				elsif (r_C01_w.ie_forma_incidencia = 'M') then -- Verifica se já existe uma ocorrência dentro do mês
					select	count(1)
					into STRICT	qt_registro_w
					from	pls_evento_movimento
					where	nr_seq_evento = r_C01_w.nr_seq_evento
					and	nr_seq_prestador in (nr_seq_prestador_w, nr_seq_prestador_orig_w)
					and	dt_movimento between trunc(dt_mes_competencia_w,'month') and last_day(dt_mes_competencia_w)
					and	((ie_incidencia_lanc_prog_w = 'S' and nr_seq_regra_fixo = nr_seq_regra_fixo_w) or (ie_incidencia_lanc_prog_w = 'N'))
					and	coalesce(ie_cancelamento::text, '') = ''  LIMIT 1;

					if (qt_registro_w > 0) then
						ie_gerar_w := 'N';
					end if;
				elsif (r_C01_w.ie_forma_incidencia = 'A') then -- Verifica se já existe uma ocorrência dentro do Ano
					select	count(1)
					into STRICT	qt_registro_w
					from	pls_evento_movimento
					where	nr_seq_evento = r_C01_w.nr_seq_evento
					and	nr_seq_prestador in (nr_seq_prestador_w, nr_seq_prestador_orig_w)
					and	dt_movimento between  trunc(dt_mes_competencia_w,'yy') and (last_day(add_months(trunc(dt_mes_competencia_w,'year'),11)))
					and	coalesce(ie_cancelamento::text, '') = ''  LIMIT 1;

					if (qt_registro_w > 0) then
						ie_gerar_w := 'N';
					end if;
				end if;
			end if;

			if (ie_gerar_w = 'S') then -- Gerar ocorrências financeira
				-- Se a 'Forma valor' da regra for 'Informado' o valor do movimento recebe o valor informado na regra
				if (r_C01_w.ie_forma_valor = 'I') then
					vl_regra_w := r_C01_w.vl_regra;
				-- Se a 'Forma valor' da regra for 'Regra' o valor do movimento é calculado
				elsif (r_C01_w.ie_forma_valor = 'R') then
					-- Se a 'Regra valor' está configurada com um valor fixo, o valor do movimento recebe o valor fixo da regra
					if (r_c01_w.vl_fixo IS NOT NULL AND r_c01_w.vl_fixo::text <> '') then
						vl_regra_w := r_c01_w.vl_fixo;
					-- Se a 'Regra valor' está configurada com um '% valor', o valor do movimento é calculado sobre o líquido
					elsif (r_c01_w.pr_valor IS NOT NULL AND r_c01_w.pr_valor::text <> '') then
						vl_regra_w := (vl_liquido_original_w/100) * r_c01_w.pr_valor;
					end if;

					-- Se a 'Regra valor' teve um 'Vl máximo' configurado e o valor da movimentação ultrapassa o 'Vl máximo' a movimentação será gerada com o 'Vl máximo'
					if (r_c01_w.vl_maximo IS NOT NULL AND r_c01_w.vl_maximo::text <> '') and (r_c01_w.vl_maximo < vl_regra_w) then
						vl_regra_w := r_c01_w.vl_maximo;
					end if;
				end if;

				-- Verifica ainda se o valor líquido atual do pagamento ainda consegue cobrir a geração de mais uma movimentação
				if (vl_regra_w < vl_liquido_estornar_w) then
					-- Desconto do valor líquido restante a movimentação que será gerada
					vl_liquido_estornar_w := vl_liquido_estornar_w - vl_regra_w;
				else
					-- A movimentação será gerada com o restante do valor líquido
					vl_regra_w := vl_liquido_estornar_w;

					-- Zera o valor líquido restante
					vl_liquido_estornar_w := 0;
				end if;

				if (vl_regra_w > 0) then
					-- Formata o valor calculado para que o mesmo seja gerado em formato negativo
					vl_regra_w := abs(vl_regra_w) * (-1);

					-- Busca se já há um lote de evento para o lote de pagamento em questão (lote de evento de lançamentos pós tributação)
					select	max(nr_sequencia)
					into STRICT	nr_seq_lote_evento_w
					from	pls_lote_evento
					where	nr_seq_pgto_desc_liq = nr_seq_lote_pag_w;

					-- Se não encontrou lote de evento para o lote de pagamento em questão (lote de evento de lançamentos pós tributação) é gerado um lote
					if (coalesce(nr_seq_lote_evento_w::text, '') = '') then
						insert into pls_lote_evento(nr_sequencia,			nm_usuario,		dt_atualizacao,
							nm_usuario_nrec,		dt_atualizacao_nrec,	ie_origem,
							dt_inicio_comp,			dt_fim_comp,		dt_liberacao,
							dt_competencia,			cd_estabelecimento,	nr_seq_pgto_desc_liq,
							ds_observacao)
						values (nextval('pls_lote_evento_seq'),	nm_usuario_p,		clock_timestamp(),
							nm_usuario_p,			clock_timestamp(),		'A',
							dt_inicio_comp_w,		dt_fim_comp_w,		clock_timestamp(),
							dt_mes_competencia_w,		cd_estabelecimento_p,	nr_seq_lote_pag_w,
							'Lote gerado com movimentação de valores negativos, com os lançamentos pós tributação, ou seja, lançamento que foram lançados sobre o valor líquido do pagamento.') returning nr_sequencia into nr_seq_lote_evento_w;
					end if;

					insert into pls_evento_movimento(
						nr_sequencia, dt_atualizacao, nm_usuario,
						dt_atualizacao_nrec, nm_usuario_nrec, dt_movimento,
						nr_seq_evento, nr_seq_lote, nr_seq_prestador,
						vl_movimento, nr_seq_regra_fixo, ds_observacao,
						nr_seq_periodo, nr_seq_classe_tit_rec, ie_titulo_pagar,
						cd_pf_titulo_pagar, cd_cgc_titulo_pagar, nr_seq_trans_fin_baixa,
						nr_seq_trans_fin_contab, cd_centro_custo)
					values (	nextval('pls_evento_movimento_seq'), clock_timestamp(), nm_usuario_p,
						clock_timestamp(), nm_usuario_p, coalesce(r_C01_w.dt_movimento,trunc(dt_mes_competencia_w,'dd')),
						r_C01_w.nr_seq_evento, nr_seq_lote_evento_w, nr_seq_prestador_w,
						vl_regra_w, r_C01_w.nr_seq_regra_fixo, r_C01_w.ds_observacao,
						r_C01_w.nr_seq_periodo, r_C01_w.nr_seq_classe_titulo, r_C01_w.ie_titulo_pagar,
						r_C01_w.cd_pf_titulo_pagar, r_C01_w.cd_cgc_titulo_pagar, r_C01_w.nr_seq_trans_fin_baixa,
						r_C01_w.nr_seq_trans_fin_contab, r_C01_w.cd_centro_custo) returning nr_sequencia into nr_seq_evento_movto_w;

					-- Obtem a conta contábil comforme regra OPS - Critérios Contábeis item Regra contábil de eventos financeiros (pagamento produção)
					cd_conta_contabil_w := pls_obter_conta_contab_eve_fin(nr_seq_evento_movto_w, cd_conta_contabil_w);

					update	pls_evento_movimento
					set	cd_conta_contabil = cd_conta_contabil_w
					where	nr_sequencia = nr_seq_evento_movto_w;
				end if;
			end if;
		end if;
	end loop;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_even_mov_pos_tribut (nr_seq_pagamento_p pls_pagamento_prestador.nr_sequencia%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

