-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_a500_analise_pend_gerar_v (nr_seq_fatura, cd_estabelecimento, nm_usuario, dt_vencimento_fatura, vl_total_fatura) AS select	a.nr_sequencia nr_seq_fatura,
	a.cd_estabelecimento,
	a.nm_usuario,
	a.dt_vencimento_fatura,	
	a.vl_total_fatura
FROM	ptu_fatura		a,
	ptu_processo_fatura	b
where	b.nr_seq_fatura		= a.nr_sequencia
and	a.ie_status		= 'EI' -- a fatura precisa estar com o status "Em importacao"
and	b.ie_tipo_processo	= 'GC' -- tem que possuir a etapa "Geracao de contas medicas"
and	b.ie_status_processo	= 'GA' -- a etapa tem que estar aguardando geracao da analise
and	b.dt_fim		is not null -- a etapa de geracao de contas medicas ja foi executada
and	a.ie_tipo_cobranca_fatura	= 'C' -- somente fatura de cobranca
-- Somente para os estabelecimentos que estao com a nova importacao ativa
and	exists (	select	1
			from	pls_visible_false	x
			where	x.ie_novo_imp_a500	= 'S'
			and	x.cd_estabelecimento	= a.cd_estabelecimento);

