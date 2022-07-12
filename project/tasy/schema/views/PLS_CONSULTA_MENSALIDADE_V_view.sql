-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_consulta_mensalidade_v (nr_seq_mensalidade_seg, nr_seq_segurado, cd_pessoa_fisica, nr_seq_contrato, dt_rescisao, dt_contratacao, nr_seq_lote, vl_mensalidade, qt_idade, dt_mesano_referencia, nr_titulo, ie_status, dt_liquidacao, nr_parcela, ie_sem_mensalidade, dt_geracao, nr_seq_pagador, nr_seq_plano, nr_seq_mensalidade, nr_seq_titular, nr_seq_subestipulante, nr_contrato, nr_seq_intercambio, ie_tipo_lote, cd_grupo_intercambio, dt_liberacao, ie_situacao_trabalhista, cd_estabelecimento, dt_inicio_geracao, dt_fim_geracao, nm_usuario_geracao) AS select	a.nr_sequencia nr_seq_mensalidade_seg,
	a.nr_seq_segurado,
	b.cd_pessoa_fisica,
	b.nr_seq_contrato,
	b.dt_rescisao,
	b.dt_contratacao,
	c.nr_seq_lote,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	a.qt_idade,
	a.dt_mesano_referencia,
	j.nr_titulo nr_titulo,
	CASE WHEN c.ie_cancelamento='C' THEN 'Cancelada' WHEN c.ie_cancelamento='E' THEN 'Estornada'  ELSE 'Normal' END  ie_status,
	j.dt_liquidacao dt_liquidacao,
	a.nr_parcela,
	'N' ie_sem_mensalidade,
	e.dt_geracao,
	c.nr_seq_pagador,
	b.nr_seq_plano,
	c.nr_sequencia nr_seq_mensalidade,
	b.nr_seq_titular,
	b.nr_seq_subestipulante,
	f.nr_contrato,
	null nr_seq_intercambio,
	e.ie_tipo_lote ie_tipo_lote,
	c.cd_grupo_intercambio cd_grupo_intercambio,
	b.dt_liberacao,
	b.ie_situacao_trabalhista,
	b.cd_estabelecimento,
	e.dt_inicio_geracao,
	e.dt_fim_geracao,
	e.nm_usuario_geracao
FROM pls_contrato f, pls_lote_mensalidade e, pls_segurado b, pls_mensalidade_segurado a, pls_mensalidade c
LEFT OUTER JOIN titulo_receber j ON (c.nr_sequencia = j.nr_seq_mensalidade)
WHERE c.nr_sequencia		= a.nr_seq_mensalidade and b.nr_sequencia		= a.nr_seq_segurado and e.nr_sequencia		= c.nr_seq_lote and f.nr_sequencia		= b.nr_seq_contrato
UNION ALL

select	null nr_seq_mensalidade_seg,
	b.nr_sequencia nr_seq_segurado,
	b.cd_pessoa_fisica,
	b.nr_seq_contrato,
	b.dt_rescisao,
	b.dt_contratacao,
	null nr_seq_lote,
	0 vl_mensalidade,
	0 qt_idade,
	null dt_mesano_referencia,
	null nr_titulo,
	null ie_status,
	null dt_liquidacao,
	null nr_parcela,
	'S' ie_sem_mensalidade,
	null dt_geracao,
	b.nr_seq_pagador,
	b.nr_seq_plano,
	null nr_seq_mensalidade,
	b.nr_seq_titular,
	b.nr_seq_subestipulante,
	d.nr_contrato,
	null nr_seq_intercambio,
	null ie_tipo_lote,
	null cd_grupo_intercambio,
	b.dt_liberacao,
	b.ie_situacao_trabalhista,
	b.cd_estabelecimento,
	null dt_inicio_geracao,
	null dt_fim_geracao,
	null nm_usuario_geracao
from	pls_segurado		b,	
	pls_contrato		d
where	b.nr_seq_contrato	= d.nr_sequencia

UNION ALL

select	a.nr_sequencia nr_seq_mensalidade_seg,
	a.nr_seq_segurado,
	b.cd_pessoa_fisica,
	b.nr_seq_contrato,
	b.dt_rescisao,
	b.dt_contratacao,
	c.nr_seq_lote,
	coalesce(a.vl_mensalidade,0) vl_mensalidade,
	a.qt_idade,
	a.dt_mesano_referencia,
	j.nr_titulo nr_titulo,
	CASE WHEN c.ie_cancelamento='C' THEN 'Cancelada' WHEN c.ie_cancelamento='E' THEN 'Estornada'  ELSE 'Normal' END  ie_status,
	j.dt_liquidacao dt_liquidacao,
	a.nr_parcela,
	'N' ie_sem_mensalidade,
	e.dt_geracao,
	c.nr_seq_pagador,
	b.nr_seq_plano,
	c.nr_sequencia nr_seq_mensalidade,
	b.nr_seq_titular,
	b.nr_seq_subestipulante,
	null nr_contrato,
	f.nr_sequencia nr_seq_intercambio,
	e.ie_tipo_lote ie_tipo_lote,
	c.cd_grupo_intercambio cd_grupo_intercambio,
	b.dt_liberacao,
	b.ie_situacao_trabalhista,
	b.cd_estabelecimento,
	e.dt_inicio_geracao,
	e.dt_fim_geracao,
	e.nm_usuario_geracao
FROM pls_intercambio f, pls_lote_mensalidade e, pls_segurado b, pls_mensalidade_segurado a, pls_mensalidade c
LEFT OUTER JOIN titulo_receber j ON (c.nr_sequencia = j.nr_seq_mensalidade)
WHERE c.nr_sequencia		= a.nr_seq_mensalidade and b.nr_sequencia		= a.nr_seq_segurado and e.nr_sequencia		= c.nr_seq_lote and f.nr_sequencia		= b.nr_seq_intercambio  
UNION ALL

select	null nr_seq_mensalidade_seg,
	b.nr_sequencia nr_seq_segurado,
	b.cd_pessoa_fisica,
	b.nr_seq_contrato,
	b.dt_rescisao,
	b.dt_contratacao,
	null nr_seq_lote,
	0 vl_mensalidade,
	0 qt_idade,
	null dt_mesano_referencia,
	null nr_titulo,
	null ie_status,
	null dt_liquidacao,
	null nr_parcela,
	'S' ie_sem_mensalidade,
	null dt_geracao,
	b.nr_seq_pagador,
	b.nr_seq_plano,
	null nr_seq_mensalidade,
	b.nr_seq_titular,
	b.nr_seq_subestipulante,
	null nr_contrato,
	d.nr_sequencia nr_seq_intercambio,
	null ie_tipo_lote,
	null cd_grupo_intercambio,
	b.dt_liberacao,
	b.ie_situacao_trabalhista,
	b.cd_estabelecimento,
	null dt_inicio_geracao,
	null dt_fim_geracao,
	null nm_usuario_geracao
from	pls_segurado		b,
	pls_intercambio		d
where	b.nr_seq_intercambio	= d.nr_sequencia;
