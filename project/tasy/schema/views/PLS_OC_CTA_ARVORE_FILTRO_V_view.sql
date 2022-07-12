-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_oc_cta_arvore_filtro_v (nr_ordem, ds_descricao, nr_seq_visao, nr_seq_visao_imp, qt_registros, nm_tabela, nr_sequencia) AS select	-- Esta view só foi criada por que no dicionário de objetos não cabe este select.
	1 nr_ordem,
	obter_desc_expressao(284292, 'Beneficiário') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22279 nr_seq_visao,
	22280 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_BENEF' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_benef b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_benef = 'S'  group by a.nr_sequencia

union all

select	2 nr_ordem,
	obter_desc_expressao(285928, 'Conta') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22911 nr_seq_visao,
	22914 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_CONTA' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_conta b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_conta = 'S'  group by a.nr_sequencia

union all

select	3 nr_ordem,
	obter_desc_expressao(286142, 'Contrato') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22912 nr_seq_visao,
	22912 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_CONTRATO' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_contrato b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_contrato = 'S'  group by a.nr_sequencia

union all

select	4 nr_ordem,
	obter_desc_expressao(292147, 'Intercâmbio') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22913 nr_seq_visao,
	22913 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_INTERC' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_interc b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_interc = 'S'  group by a.nr_sequencia

union all

select	5 nr_ordem,
	obter_desc_expressao(292952, 'Material') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22917 nr_seq_visao,
	22917 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_MAT' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_mat b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_mat = 'S'  group by a.nr_sequencia

union all

select	6 nr_ordem,
	obter_desc_expressao(296259, 'Prestador') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22919 nr_seq_visao,
	22919 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_PREST' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_prest b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_prest = 'S'  group by a.nr_sequencia

union all

select	7  nr_ordem,
	obter_desc_expressao(296422, 'Procedimento') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22915 nr_seq_visao,
	22916 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_PROC' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_proc b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_proc = 'S'  group by a.nr_sequencia

union all

select	8  nr_ordem,
	obter_desc_expressao(296491, 'Produto') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22918 nr_seq_visao,
	22918 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_PRODUTO' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_produto b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_produto = 'S'  group by a.nr_sequencia

union all

select	9  nr_ordem,
	obter_desc_expressao(296509, 'Profissional') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22924 nr_seq_visao,
	22834 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_PROF' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_prof b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_prof = 'S'  group by a.nr_sequencia

union all

select	10 nr_ordem,
	obter_desc_expressao(296585, 'Protocolo') ||
	-- se não tem registros vai vai vazio, se não bota o count
	CASE WHEN count(b.nr_sequencia)=0 THEN  ''  ELSE ' (' || count(b.nr_sequencia) || ')' END  ds_descricao,
	22920 nr_seq_visao,
	22920 nr_seq_visao_imp,
	count(b.nr_sequencia) qt_registros,
	'PLS_OC_CTA_FILTRO_PROT' nm_tabela,
	a.nr_sequencia
FROM pls_oc_cta_filtro a
LEFT OUTER JOIN pls_oc_cta_filtro_prot b ON (a.nr_sequencia = b.nr_seq_oc_cta_filtro)
WHERE a.ie_filtro_protocolo = 'S'  group by a.nr_sequencia
order by nr_ordem, ds_descricao;

