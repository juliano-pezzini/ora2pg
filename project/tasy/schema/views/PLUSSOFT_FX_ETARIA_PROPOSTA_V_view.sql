-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_fx_etaria_proposta_v (nr_seq_proposta, ds_faixa_etaria, qt_idade_inicial, qt_idade_final, qt_vidas, vl_unitario, vl_total) AS select	a.nr_seq_proposta,
		'Faixa etária de '|| b.qt_idade_inicial || ' à ' || b.qt_idade_final || ' anos' ds_faixa_etaria,
		b.qt_idade_inicial,
		b.qt_idade_final,
		count(1) qt_vidas,
		max(pls_obter_faixa_etaria_prop(a.nr_sequencia,b.nr_sequencia)) vl_unitario,
		sum(pls_obter_faixa_etaria_prop(a.nr_sequencia,b.nr_sequencia)) vl_total
	FROM  	pls_proposta_beneficiario	a,
		pls_plano_preco			b,
		pessoa_fisica			c
	where 	a.nr_seq_tabela = b.nr_seq_tabela
	and	a.cd_beneficiario = c.cd_pessoa_fisica
	and	trunc(months_between(LOCALTIMESTAMP, dt_nascimento) / 12) between b.qt_idade_inicial and b.qt_idade_final
	group by a.nr_seq_proposta, b.qt_idade_inicial, b.qt_idade_final
	order by 2;
