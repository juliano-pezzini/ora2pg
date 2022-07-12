-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*---------------------------------------------------------------------PROCEDURE--------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_mens_pagador_pck.inserir_mensalidade_pagador ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
pls_contrato_pagador_fin_w	pls_contrato_pagador_fin%rowtype;
dt_referencia_lote_w		timestamp;
dt_referencia_w			timestamp;
dt_referencia_fimdia_w		timestamp;
ie_log_erro_w			varchar(1);
nr_parcela_w			bigint;
nr_seq_contrato_plano_w		pls_contrato_plano.nr_sequencia%type;
nr_seq_intercambio_plano_w	pls_intercambio_plano.nr_sequencia%type;
ie_preco_w			pls_plano.ie_preco%type;
ie_tipo_contratacao_w		pls_plano.ie_tipo_contratacao%type;
ie_contrato_w			varchar(1);
dt_contrato_w			timestamp;
ie_tipo_contrato_w		pls_intercambio.ie_tipo_contrato%type;
ie_mensalidade_suspensa_w	varchar(1);
nr_seq_motivo_susp_w		pls_motivo_susp_cobr_mens.nr_sequencia%type;
ie_tipo_estipulante_w		varchar(2);
ie_mensalidade_anterior_w	varchar(1);
qt_inicial_w			smallint;
qt_registro_w			integer;
qt_inf_finc_futura_w		bigint;

qt_interv_mes_mensalidade_w	pls_regra_mens_contrato.qt_interv_mes_mensalidade%type;
ie_agrupar_valor_w		pls_regra_mens_contrato.ie_agrupar_valor%type;

nr_indice_w			integer;
qt_meses_futuros_w		integer;
qt_meses_anterior_w		integer;
qt_meses_mensalidade_w		integer;

nr_seq_regra_limite_w		pls_regra_mens_contrato.nr_sequencia%type;
ie_agrupar_valor_lim_w		pls_regra_mens_contrato.ie_agrupar_valor%type;
qt_dias_vencimento_w		pls_regra_mens_contrato.qt_dias_vencimento%type;
ie_primeira_mensalidade_w	pls_regra_mens_contrato.ie_primeira_mensalidade%type;
ie_data_base_adesao_w		pls_regra_mens_contrato.ie_data_base_adesao%type;

-- Matriz pagador

tb_nr_seq_pagador_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_pagador_fin_w		pls_util_cta_pck.t_number_table;
tb_dt_referencia_w		pls_util_cta_pck.t_date_table;
tb_dt_vencimento_w		pls_util_cta_pck.t_date_table;
tb_nr_seq_forma_cobranca_w	pls_util_cta_pck.t_number_table;
tb_cd_banco_w			pls_util_cta_pck.t_number_table;
tb_cd_agencia_bancaria_w	pls_util_cta_pck.t_varchar2_table_10;
tb_ie_digito_agencia_w		pls_util_cta_pck.t_varchar2_table_2;
tb_cd_conta_w			pls_util_cta_pck.t_varchar2_table_20;
tb_ie_digito_conta_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ie_endereco_boleto_w		pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_conta_banco_w		pls_util_cta_pck.t_number_table;
tb_ie_gerar_cobr_escrit_w	pls_util_cta_pck.t_varchar2_table_2;
tb_nr_seq_conta_banco_deb_au_w	pls_util_cta_pck.t_number_table;
tb_ie_proporcional_w		pls_util_cta_pck.t_varchar2_table_1;
tb_nr_seq_compl_pf_tel_adic_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_compl_pj_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_tipo_compl_adic_w	pls_util_cta_pck.t_number_table;
tb_ie_nota_titulo_w		pls_util_cta_pck.t_varchar2_table_2;
tb_ie_tipo_formacao_preco_w	pls_util_cta_pck.t_varchar2_table_1;
tb_nr_serie_mensalidade_w	pls_util_cta_pck.t_varchar2_table_50;
tb_nr_parcela_w			pls_util_cta_pck.t_number_table;
tb_nr_seq_motivo_susp_w		pls_util_cta_pck.t_number_table;
tb_ie_tipo_estipulante_w	pls_util_cta_pck.t_varchar2_table_2;
tb_ie_indice_correcao_w		pls_util_cta_pck.t_varchar2_table_2;
--Fim matriz pagador


C01 CURSOR FOR
	SELECT	a.nr_seq_pagador,
		b.nr_seq_contrato,
		b.nr_seq_pagador_intercambio nr_seq_intercambio,
		b.ie_calc_primeira_mens,
		b.dt_primeira_mensalidade,
		b.ie_situacao_trabalhista,
		b.nr_seq_classif_itens,
		b.cd_pessoa_fisica,
		b.ie_endereco_boleto,
		b.nr_seq_compl_pf_tel_adic,
		b.nr_seq_compl_pj,
		b.nr_seq_tipo_compl_adic,
		b.ie_primeira_mensalidade_gerada,
		b.ie_tipo_pagador
	from	pls_mens_benef_pag_tmp	a,
		pls_contrato_pagador	b
	where	b.nr_sequencia	= a.nr_seq_pagador
	group by a.nr_seq_pagador,
		b.nr_seq_contrato,
		b.nr_seq_pagador_intercambio,
		b.ie_calc_primeira_mens,
		b.dt_primeira_mensalidade,
		b.ie_situacao_trabalhista,
		b.nr_seq_classif_itens,
		b.cd_pessoa_fisica,
		b.ie_endereco_boleto,
		b.nr_seq_compl_pf_tel_adic,
		b.nr_seq_compl_pj,
		b.nr_seq_tipo_compl_adic,
		b.ie_primeira_mensalidade_gerada,
		b.ie_tipo_pagador;

BEGIN
nr_indice_w	:= 0;
tb_nr_seq_pagador_w.delete; --Garantir que o vetor vai estar vazio e so vai limpar os vetores na primeira execucao
SELECT * FROM pls_mens_pagador_pck.atualizar_pls_mensalidade(	tb_nr_seq_pagador_w, tb_nr_seq_pagador_fin_w, tb_dt_referencia_w, tb_dt_vencimento_w, tb_nr_seq_forma_cobranca_w, tb_cd_banco_w, tb_cd_agencia_bancaria_w, tb_ie_digito_agencia_w, tb_cd_conta_w, tb_ie_digito_conta_w, tb_ie_endereco_boleto_w, tb_nr_seq_conta_banco_w, tb_ie_gerar_cobr_escrit_w, tb_nr_seq_conta_banco_deb_au_w, tb_ie_proporcional_w, tb_nr_seq_compl_pf_tel_adic_w, tb_nr_seq_compl_pj_w, tb_nr_seq_tipo_compl_adic_w, tb_ie_nota_titulo_w, tb_ie_tipo_formacao_preco_w, tb_nr_serie_mensalidade_w, tb_nr_parcela_w, tb_nr_seq_motivo_susp_w, tb_ie_tipo_estipulante_w, tb_ie_indice_correcao_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_nr_seq_pagador_w := _ora2pg_r.tb_nr_seq_pagador_p; tb_nr_seq_pagador_fin_w := _ora2pg_r.tb_nr_seq_pagador_fin_p; tb_dt_referencia_w := _ora2pg_r.tb_dt_referencia_p; tb_dt_vencimento_w := _ora2pg_r.tb_dt_vencimento_p; tb_nr_seq_forma_cobranca_w := _ora2pg_r.tb_nr_seq_forma_cobranca_p; tb_cd_banco_w := _ora2pg_r.tb_cd_banco_p; tb_cd_agencia_bancaria_w := _ora2pg_r.tb_cd_agencia_bancaria_p; tb_ie_digito_agencia_w := _ora2pg_r.tb_ie_digito_agencia_p; tb_cd_conta_w := _ora2pg_r.tb_cd_conta_p; tb_ie_digito_conta_w := _ora2pg_r.tb_ie_digito_conta_p; tb_ie_endereco_boleto_w := _ora2pg_r.tb_ie_endereco_boleto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p; tb_ie_gerar_cobr_escrit_w := _ora2pg_r.tb_ie_gerar_cobr_escrit_p; tb_nr_seq_conta_banco_deb_au_w := _ora2pg_r.tb_nr_seq_conta_banco_deb_au_p; tb_ie_proporcional_w := _ora2pg_r.tb_ie_proporcional_p; tb_nr_seq_compl_pf_tel_adic_w := _ora2pg_r.tb_nr_seq_compl_pf_tel_adic_p; tb_nr_seq_compl_pj_w := _ora2pg_r.tb_nr_seq_compl_pj_p; tb_nr_seq_tipo_compl_adic_w := _ora2pg_r.tb_nr_seq_tipo_compl_adic_p; tb_ie_nota_titulo_w := _ora2pg_r.tb_ie_nota_titulo_p; tb_ie_tipo_formacao_preco_w := _ora2pg_r.tb_ie_tipo_formacao_preco_p; tb_nr_serie_mensalidade_w := _ora2pg_r.tb_nr_serie_mensalidade_p; tb_nr_parcela_w := _ora2pg_r.tb_nr_parcela_p; tb_nr_seq_motivo_susp_w := _ora2pg_r.tb_nr_seq_motivo_susp_p; tb_ie_tipo_estipulante_w := _ora2pg_r.tb_ie_tipo_estipulante_p; tb_ie_indice_correcao_w := _ora2pg_r.tb_ie_indice_correcao_p;

PERFORM set_config('pls_mens_pagador_pck.pls_lote_mensalidade_w', pls_mens_selecao_benef_pck.get_lote_mensalidade, false);
dt_referencia_lote_w	:= trunc(current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.dt_mesano_referencia,'month');

for r_c01_w in C01 loop
	begin
	ie_log_erro_w		:= 'N';
	
	if (r_c01_w.nr_seq_contrato IS NOT NULL AND r_c01_w.nr_seq_contrato::text <> '') then
		select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN 'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_estipulante_w
		from	pls_contrato
		where	nr_sequencia	= r_c01_w.nr_seq_contrato;
	elsif (r_c01_w.nr_seq_intercambio IS NOT NULL AND r_c01_w.nr_seq_intercambio::text <> '') then
		select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN 'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_estipulante_w
		from	pls_intercambio
		where	nr_sequencia	= r_c01_w.nr_seq_intercambio;
	end if;
	
	SELECT * FROM pls_mens_pagador_pck.consiste_suspensao_mensalidade(r_c01_w.nr_seq_contrato, r_c01_w.nr_seq_pagador, dt_referencia_lote_w, r_c01_w.ie_tipo_pagador, nr_seq_motivo_susp_w, ie_mensalidade_suspensa_w) INTO STRICT nr_seq_motivo_susp_w, ie_mensalidade_suspensa_w;
	
	if (ie_mensalidade_suspensa_w = 'N') and (pls_mens_pagador_pck.obter_se_restricao_uma_mens(r_c01_w.nr_seq_pagador, r_c01_w.nr_seq_contrato, r_c01_w.nr_seq_intercambio, ie_tipo_estipulante_w, dt_referencia_lote_w) = 'N') then
		
		qt_inicial_w	:= 0;
		if (current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.ie_mensalidade_mes_anterior = 'S') then
			if (current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.ie_mens_ant_agrupar = 'N') then
				qt_meses_futuros_w	:= 0;
				qt_meses_anterior_w	:= pls_mensalidade_util_pck.get_qt_meses_ant;
				if (current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.ie_mens_ant_mes_atual = 'N') then
					qt_inicial_w	:= 1;
				end if;
			else
				qt_meses_futuros_w	:= 0;
				qt_meses_anterior_w	:= 0;
			end if;
		else
			if (current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.ie_gerar_mensalidade_futura = 'S') then
				qt_meses_futuros_w	:= coalesce(current_setting('pls_mens_pagador_pck.pls_lote_mensalidade_w')::pls_lote_mensalidade%rowtype.qt_meses_mensalidade_futura,1)-1;
			else
				SELECT * FROM pls_mensalidade_util_pck.obter_regra_mens_futura(r_c01_w.nr_seq_contrato, r_c01_w.nr_seq_intercambio, ie_tipo_estipulante_w, dt_referencia_lote_w, qt_interv_mes_mensalidade_w, ie_agrupar_valor_w) INTO STRICT qt_interv_mes_mensalidade_w, ie_agrupar_valor_w;
				
				if (ie_agrupar_valor_w = 'N') and (qt_interv_mes_mensalidade_w > 0) then
					qt_meses_futuros_w	:= qt_interv_mes_mensalidade_w-1;
				else
					qt_meses_futuros_w	:= 0;
				end if;
			end if;
			
			SELECT * FROM pls_mensalidade_util_pck.obter_regra_data_limite(r_c01_w.nr_seq_contrato, r_c01_w.nr_seq_intercambio, ie_tipo_estipulante_w, dt_referencia_lote_w, nr_seq_regra_limite_w, ie_agrupar_valor_lim_w, qt_dias_vencimento_w, ie_primeira_mensalidade_w, ie_data_base_adesao_w) INTO STRICT nr_seq_regra_limite_w, ie_agrupar_valor_lim_w, qt_dias_vencimento_w, ie_primeira_mensalidade_w, ie_data_base_adesao_w;
			if (ie_agrupar_valor_lim_w = 'N') and (nr_seq_regra_limite_w IS NOT NULL AND nr_seq_regra_limite_w::text <> '') and (pls_mensalidade_util_pck.get_qt_meses_ant > 0) then
				qt_meses_anterior_w	:= pls_mensalidade_util_pck.get_qt_meses_ant;
			else
				qt_meses_anterior_w	:= 0;
			end if;
		end if;
		
		qt_meses_mensalidade_w	:= qt_meses_futuros_w + qt_meses_anterior_w;
		for i in qt_inicial_w..qt_meses_mensalidade_w loop
			begin
			if (i <= qt_meses_futuros_w) then
				dt_referencia_w			:= add_months(dt_referencia_lote_w, i);
				ie_mensalidade_anterior_w	:= 'N';
			else
				ie_mensalidade_anterior_w	:= 'S';
				dt_referencia_w			:= add_months(dt_referencia_lote_w, -(i-qt_meses_futuros_w));
			end if;
			dt_referencia_fimdia_w	:= fim_dia(dt_referencia_w);
			
			begin
			select	*
			into STRICT	pls_contrato_pagador_fin_w
			from	pls_contrato_pagador_fin
			where	nr_seq_pagador	= r_c01_w.nr_seq_pagador
			and	dt_inicio_vigencia <= dt_referencia_fimdia_w
			and	((dt_fim_vigencia >= dt_referencia_fimdia_w) or (coalesce(dt_fim_vigencia::text, '') = ''));
			exception
			when too_many_rows then
				ie_log_erro_w	:= 'S';
				
				CALL pls_gerar_mens_log_erro(nr_seq_lote_p,r_c01_w.nr_seq_pagador,null,null,
							wheb_mensagem_pck.get_texto(1180009),cd_estabelecimento_p,nm_usuario_p);
			when others then
				begin --Se nao encontrar a informacao financeira pela data, procura truncando a data inicial por mes
				select	*
				into STRICT	pls_contrato_pagador_fin_w
				from	pls_contrato_pagador_fin
				where	nr_seq_pagador	= r_c01_w.nr_seq_pagador
				and	trunc(dt_inicio_vigencia,'month') <= dt_referencia_fimdia_w
				and	((dt_fim_vigencia >= dt_referencia_fimdia_w) or (coalesce(dt_fim_vigencia::text, '') = ''));
				exception
				when others then
					ie_log_erro_w	:= 'S';
					
					select	count(1)
					into STRICT	qt_inf_finc_futura_w
					from	pls_contrato_pagador_fin
					where	nr_seq_pagador = r_c01_w.nr_seq_pagador
					and	dt_inicio_vigencia > dt_referencia_fimdia_w;
					
					if (ie_mensalidade_anterior_w = 'N') and
						((pls_mensalidade_util_pck.get_ie_consis_inf_fin_pag = 'N' AND qt_inf_finc_futura_w = 0) or (pls_mensalidade_util_pck.get_ie_consis_inf_fin_pag = 'S')) then
						CALL pls_gerar_mens_log_erro(nr_seq_lote_p,r_c01_w.nr_seq_pagador,null,null,
									wheb_mensagem_pck.get_texto(1180010),cd_estabelecimento_p,nm_usuario_p);
					end if;
				end;
			end;
			
			if (ie_log_erro_w = 'N') and (pls_mens_pagador_pck.obter_se_restringe_pagador(pls_contrato_pagador_fin_w) = 'N') then
				if (r_c01_w.nr_seq_contrato IS NOT NULL AND r_c01_w.nr_seq_contrato::text <> '') then
					ie_contrato_w	:= 'O';
					select	dt_contrato
					into STRICT	dt_contrato_w
					from	pls_contrato
					where	nr_sequencia	= r_c01_w.nr_seq_contrato;
					
					nr_parcela_w	:=	(trunc(months_between(dt_referencia_w,trunc(dt_contrato_w,'month'))) + 1);
					
					select	max(nr_sequencia)
					into STRICT	nr_seq_contrato_plano_w
					from	pls_contrato_plano
					where	nr_seq_contrato	= r_c01_w.nr_seq_contrato
					and	ie_situacao	= 'A';
					
					if (coalesce(nr_seq_contrato_plano_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_contrato_plano_w
						from	pls_contrato_plano
						where	nr_seq_contrato	= r_c01_w.nr_seq_contrato
						and	ie_situacao	= 'I';
					end if;
					
					select	max(b.ie_preco),
						max(b.ie_tipo_contratacao)
					into STRICT	ie_preco_w,
						ie_tipo_contratacao_w
					from	pls_contrato_plano	a,
						pls_plano		b
					where	a.nr_seq_plano		= b.nr_sequencia
					and	a.nr_sequencia		= nr_seq_contrato_plano_w;
				elsif (r_c01_w.nr_seq_intercambio IS NOT NULL AND r_c01_w.nr_seq_intercambio::text <> '') then
					select	dt_inclusao,
						ie_tipo_contrato
					into STRICT	dt_contrato_w,
						ie_tipo_contrato_w
					from	pls_intercambio
					where	nr_sequencia	= r_c01_w.nr_seq_intercambio;
					
					nr_parcela_w	:=	(trunc(months_between(dt_referencia_w,trunc(dt_contrato_w,'month'))) + 1);
					
					if (ie_tipo_contrato_w = 'I') then
						ie_contrato_w	:= 'I';
					else
						ie_contrato_w	:= 'A';
					end if;
					
					select	max(nr_sequencia)
					into STRICT	nr_seq_intercambio_plano_w
					from	pls_intercambio_plano
					where	nr_seq_intercambio	= r_c01_w.nr_seq_intercambio
					and	ie_situacao	= 'A';
					
					if (coalesce(nr_seq_contrato_plano_w::text, '') = '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_contrato_plano_w
						from	pls_intercambio_plano
						where	nr_seq_intercambio	= r_c01_w.nr_seq_intercambio
						and	ie_situacao		= 'I';
					end if;
					
					select	max(b.ie_preco),
						max(b.ie_tipo_contratacao)
					into STRICT	ie_preco_w,
						ie_tipo_contratacao_w
					from	pls_intercambio_plano	a,
						pls_plano		b
					where	a.nr_seq_plano		= b.nr_sequencia
					and	a.nr_sequencia		= nr_seq_intercambio_plano_w;
				end if;
				
				tb_nr_seq_pagador_w(nr_indice_w)		:= r_c01_w.nr_seq_pagador;
				tb_nr_seq_pagador_fin_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.nr_sequencia;
				tb_dt_referencia_w(nr_indice_w)			:= dt_referencia_w;
				tb_dt_vencimento_w(nr_indice_w)			:= pls_mens_pagador_pck.obter_dt_vencimento_mens(r_c01_w.nr_seq_pagador, pls_contrato_pagador_fin_w.dt_dia_vencimento, pls_contrato_pagador_fin_w.ie_mes_vencimento,
														dt_referencia_w, r_c01_w.dt_primeira_mensalidade, r_c01_w.ie_primeira_mensalidade_gerada, cd_estabelecimento_p,
														pls_contrato_pagador_fin_w.qt_meses_vencimento);
				tb_nr_seq_forma_cobranca_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.nr_seq_forma_cobranca;
				tb_cd_banco_w(nr_indice_w)			:= pls_contrato_pagador_fin_w.cd_banco;
				tb_cd_agencia_bancaria_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.cd_agencia_bancaria;
				tb_ie_digito_agencia_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.ie_digito_agencia;
				tb_cd_conta_w(nr_indice_w)			:= pls_contrato_pagador_fin_w.cd_conta;
				tb_ie_digito_conta_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.ie_digito_conta;
				tb_ie_endereco_boleto_w(nr_indice_w)		:= r_c01_w.ie_endereco_boleto;
				tb_nr_seq_conta_banco_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.nr_seq_conta_banco;
				tb_ie_gerar_cobr_escrit_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.ie_gerar_cobr_escrit;
				tb_nr_seq_conta_banco_deb_au_w(nr_indice_w)	:= pls_contrato_pagador_fin_w.nr_seq_conta_banco_deb_aut;
				tb_ie_proporcional_w(nr_indice_w)		:= pls_mens_pagador_pck.obter_se_proporcional(r_c01_w.ie_calc_primeira_mens);
				tb_nr_seq_compl_pf_tel_adic_w(nr_indice_w)	:= r_c01_w.nr_seq_compl_pf_tel_adic;
				tb_nr_seq_compl_pj_w(nr_indice_w)		:= r_c01_w.nr_seq_compl_pj;
				tb_nr_seq_tipo_compl_adic_w(nr_indice_w)	:= r_c01_w.nr_seq_tipo_compl_adic;
				tb_ie_nota_titulo_w(nr_indice_w)		:= pls_mens_pagador_pck.obter_geracao_nota_titulo(pls_contrato_pagador_fin_w.ie_geracao_nota_titulo, r_c01_w.cd_pessoa_fisica);
				tb_ie_tipo_formacao_preco_w(nr_indice_w)	:= pls_mens_pagador_pck.obter_tipo_formacao_preco(ie_preco_w);
				tb_nr_serie_mensalidade_w(nr_indice_w)		:= pls_mens_pagador_pck.obter_serie_mensalidade(ie_contrato_w, ie_tipo_contratacao_w, ie_preco_w, r_c01_w.ie_situacao_trabalhista, r_c01_w.nr_seq_classif_itens);
				tb_nr_parcela_w(nr_indice_w)			:= nr_parcela_w;
				tb_nr_seq_motivo_susp_w(nr_indice_w)		:= nr_seq_motivo_susp_w;
				tb_ie_tipo_estipulante_w(nr_indice_w)		:= ie_tipo_estipulante_w;
				tb_ie_indice_correcao_w(nr_indice_w)		:= pls_contrato_pagador_fin_w.ie_indice_correcao;
				
				if	(nr_indice_w >= (pls_util_pck.qt_registro_transacao_w-1)) then
					SELECT * FROM pls_mens_pagador_pck.atualizar_pls_mensalidade(	tb_nr_seq_pagador_w, tb_nr_seq_pagador_fin_w, tb_dt_referencia_w, tb_dt_vencimento_w, tb_nr_seq_forma_cobranca_w, tb_cd_banco_w, tb_cd_agencia_bancaria_w, tb_ie_digito_agencia_w, tb_cd_conta_w, tb_ie_digito_conta_w, tb_ie_endereco_boleto_w, tb_nr_seq_conta_banco_w, tb_ie_gerar_cobr_escrit_w, tb_nr_seq_conta_banco_deb_au_w, tb_ie_proporcional_w, tb_nr_seq_compl_pf_tel_adic_w, tb_nr_seq_compl_pj_w, tb_nr_seq_tipo_compl_adic_w, tb_ie_nota_titulo_w, tb_ie_tipo_formacao_preco_w, tb_nr_serie_mensalidade_w, tb_nr_parcela_w, tb_nr_seq_motivo_susp_w, tb_ie_tipo_estipulante_w, tb_ie_indice_correcao_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_nr_seq_pagador_w := _ora2pg_r.tb_nr_seq_pagador_p; tb_nr_seq_pagador_fin_w := _ora2pg_r.tb_nr_seq_pagador_fin_p; tb_dt_referencia_w := _ora2pg_r.tb_dt_referencia_p; tb_dt_vencimento_w := _ora2pg_r.tb_dt_vencimento_p; tb_nr_seq_forma_cobranca_w := _ora2pg_r.tb_nr_seq_forma_cobranca_p; tb_cd_banco_w := _ora2pg_r.tb_cd_banco_p; tb_cd_agencia_bancaria_w := _ora2pg_r.tb_cd_agencia_bancaria_p; tb_ie_digito_agencia_w := _ora2pg_r.tb_ie_digito_agencia_p; tb_cd_conta_w := _ora2pg_r.tb_cd_conta_p; tb_ie_digito_conta_w := _ora2pg_r.tb_ie_digito_conta_p; tb_ie_endereco_boleto_w := _ora2pg_r.tb_ie_endereco_boleto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p; tb_ie_gerar_cobr_escrit_w := _ora2pg_r.tb_ie_gerar_cobr_escrit_p; tb_nr_seq_conta_banco_deb_au_w := _ora2pg_r.tb_nr_seq_conta_banco_deb_au_p; tb_ie_proporcional_w := _ora2pg_r.tb_ie_proporcional_p; tb_nr_seq_compl_pf_tel_adic_w := _ora2pg_r.tb_nr_seq_compl_pf_tel_adic_p; tb_nr_seq_compl_pj_w := _ora2pg_r.tb_nr_seq_compl_pj_p; tb_nr_seq_tipo_compl_adic_w := _ora2pg_r.tb_nr_seq_tipo_compl_adic_p; tb_ie_nota_titulo_w := _ora2pg_r.tb_ie_nota_titulo_p; tb_ie_tipo_formacao_preco_w := _ora2pg_r.tb_ie_tipo_formacao_preco_p; tb_nr_serie_mensalidade_w := _ora2pg_r.tb_nr_serie_mensalidade_p; tb_nr_parcela_w := _ora2pg_r.tb_nr_parcela_p; tb_nr_seq_motivo_susp_w := _ora2pg_r.tb_nr_seq_motivo_susp_p; tb_ie_tipo_estipulante_w := _ora2pg_r.tb_ie_tipo_estipulante_p; tb_ie_indice_correcao_w := _ora2pg_r.tb_ie_indice_correcao_p;
					nr_indice_w	:= 0;
				else
					nr_indice_w	:= nr_indice_w + 1;
				end if;
			end if;
			end;
		end loop;
	end if;
	end;
end loop;

-- se sobrou alguma coisa manda para o banco

SELECT * FROM pls_mens_pagador_pck.atualizar_pls_mensalidade(	tb_nr_seq_pagador_w, tb_nr_seq_pagador_fin_w, tb_dt_referencia_w, tb_dt_vencimento_w, tb_nr_seq_forma_cobranca_w, tb_cd_banco_w, tb_cd_agencia_bancaria_w, tb_ie_digito_agencia_w, tb_cd_conta_w, tb_ie_digito_conta_w, tb_ie_endereco_boleto_w, tb_nr_seq_conta_banco_w, tb_ie_gerar_cobr_escrit_w, tb_nr_seq_conta_banco_deb_au_w, tb_ie_proporcional_w, tb_nr_seq_compl_pf_tel_adic_w, tb_nr_seq_compl_pj_w, tb_nr_seq_tipo_compl_adic_w, tb_ie_nota_titulo_w, tb_ie_tipo_formacao_preco_w, tb_nr_serie_mensalidade_w, tb_nr_parcela_w, tb_nr_seq_motivo_susp_w, tb_ie_tipo_estipulante_w, tb_ie_indice_correcao_w, nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_nr_seq_pagador_w := _ora2pg_r.tb_nr_seq_pagador_p; tb_nr_seq_pagador_fin_w := _ora2pg_r.tb_nr_seq_pagador_fin_p; tb_dt_referencia_w := _ora2pg_r.tb_dt_referencia_p; tb_dt_vencimento_w := _ora2pg_r.tb_dt_vencimento_p; tb_nr_seq_forma_cobranca_w := _ora2pg_r.tb_nr_seq_forma_cobranca_p; tb_cd_banco_w := _ora2pg_r.tb_cd_banco_p; tb_cd_agencia_bancaria_w := _ora2pg_r.tb_cd_agencia_bancaria_p; tb_ie_digito_agencia_w := _ora2pg_r.tb_ie_digito_agencia_p; tb_cd_conta_w := _ora2pg_r.tb_cd_conta_p; tb_ie_digito_conta_w := _ora2pg_r.tb_ie_digito_conta_p; tb_ie_endereco_boleto_w := _ora2pg_r.tb_ie_endereco_boleto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p; tb_ie_gerar_cobr_escrit_w := _ora2pg_r.tb_ie_gerar_cobr_escrit_p; tb_nr_seq_conta_banco_deb_au_w := _ora2pg_r.tb_nr_seq_conta_banco_deb_au_p; tb_ie_proporcional_w := _ora2pg_r.tb_ie_proporcional_p; tb_nr_seq_compl_pf_tel_adic_w := _ora2pg_r.tb_nr_seq_compl_pf_tel_adic_p; tb_nr_seq_compl_pj_w := _ora2pg_r.tb_nr_seq_compl_pj_p; tb_nr_seq_tipo_compl_adic_w := _ora2pg_r.tb_nr_seq_tipo_compl_adic_p; tb_ie_nota_titulo_w := _ora2pg_r.tb_ie_nota_titulo_p; tb_ie_tipo_formacao_preco_w := _ora2pg_r.tb_ie_tipo_formacao_preco_p; tb_nr_serie_mensalidade_w := _ora2pg_r.tb_nr_serie_mensalidade_p; tb_nr_parcela_w := _ora2pg_r.tb_nr_parcela_p; tb_nr_seq_motivo_susp_w := _ora2pg_r.tb_nr_seq_motivo_susp_p; tb_ie_tipo_estipulante_w := _ora2pg_r.tb_ie_tipo_estipulante_p; tb_ie_indice_correcao_w := _ora2pg_r.tb_ie_indice_correcao_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_pagador_pck.inserir_mensalidade_pagador ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;