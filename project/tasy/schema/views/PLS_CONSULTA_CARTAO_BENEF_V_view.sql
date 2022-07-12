-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_consulta_cartao_benef_v (ds_tipo_origem, ie_tipo_origem, cd_usuario_plano, nm_segurado, nm_pagador, nm_estipulante, nr_seq_pagador, nr_seq_contrato, nr_contrato, ie_tipo_estipulante, dt_inicio_vigencia, dt_solicitacao, dt_validade_carteira, nr_lote_emissao, nr_lote_vencimento, nr_seq_segurado, ds_estagio, nr_seq_carteira, nr_carteira_emissao, nr_carteira_vencimento, dt_lote) AS select	'Carteira emissão' ds_tipo_origem,
	1 ie_tipo_origem,
	substr(c.cd_usuario_plano,1,255) cd_usuario_plano,
	substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_segurado,
	substr(pls_obter_dados_segurado(d.nr_sequencia,'PG'),1,255) nm_pagador,
	(	select	y.nm_pessoa_fisica
		FROM	pessoa_fisica y
		where	y.cd_pessoa_fisica = e.cd_pf_estipulante
		
UNION ALL

		select	y.ds_razao_social
		from	pessoa_juridica y
		where	y.cd_cgc = e.cd_cgc_estipulante) nm_estipulante,
	d.nr_seq_pagador,
	d.nr_seq_contrato,
	e.nr_contrato,
	CASE WHEN e.cd_pf_estipulante IS NULL THEN 'PJ'  ELSE 'PF' END  ie_tipo_estipulante,
	c.dt_inicio_vigencia,
	to_char(c.dt_solicitacao,'dd/mm/yyyy') dt_solicitacao,
	c.dt_validade_carteira,
	a.nr_sequencia nr_lote_emissao,
	null nr_lote_vencimento,
	d.nr_sequencia nr_seq_segurado,
	substr(pls_obter_estagio_carteira(c.nr_sequencia,'D'),1,255) ds_estagio,
	c.nr_sequencia nr_seq_carteira,
	b.nr_sequencia nr_carteira_emissao,
	null nr_carteira_vencimento,
	c.dt_inicio_vigencia dt_lote
FROM pls_segurado_carteira c, pls_carteira_emissao b, pls_lote_carteira a, pls_segurado d
LEFT OUTER JOIN pls_contrato e ON (d.nr_seq_contrato = e.nr_sequencia)
WHERE c.nr_seq_segurado	= d.nr_sequencia and b.nr_seq_seg_carteira	= c.nr_sequencia and b.nr_seq_lote		= a.nr_sequencia  and a.ie_tipo_lote		= 'E'

union

select	'Carteira vencimento' ds_tipo_origem,
	2 ie_tipo_origem,
	substr(c.cd_usuario_plano,1,255) cd_usuario_plano,
	substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_segurado,
	substr(pls_obter_dados_segurado(d.nr_sequencia,'PG'),1,255) nm_pagador,
	(	select	y.nm_pessoa_fisica
		from	pessoa_fisica y
		where	y.cd_pessoa_fisica = e.cd_pf_estipulante
		
UNION ALL

		select	y.ds_razao_social
		from	pessoa_juridica y
		where	y.cd_cgc = e.cd_cgc_estipulante) nm_estipulante,
	d.nr_seq_pagador,
	d.nr_seq_contrato,
	e.nr_contrato,
	CASE WHEN e.cd_pf_estipulante IS NULL THEN 'PJ'  ELSE 'PF' END  ie_tipo_estipulante,
	c.dt_inicio_vigencia,
	to_char(c.dt_solicitacao,'dd/mm/yyyy') dt_solicitacao,
	c.dt_validade_carteira,
	null nr_lote_emissao,
	a.nr_sequencia	nr_lote_vencimento,
	d.nr_sequencia nr_seq_segurado,
	substr(pls_obter_estagio_carteira(c.nr_sequencia,'D'),1,255) ds_estagio,
	c.nr_sequencia nr_seq_carteira,
	null nr_carteira_emissao,
	b.nr_sequencia  nr_carteira_vencimento,
	a.dt_referencia_venc dt_lote
FROM pls_segurado_carteira c, pls_carteira_vencimento b, pls_lote_carteira a, pls_segurado d
LEFT OUTER JOIN pls_contrato e ON (d.nr_seq_contrato = e.nr_sequencia)
WHERE c.nr_seq_segurado	= d.nr_sequencia and b.nr_seq_seg_carteira	= c.nr_sequencia and b.nr_seq_lote		= a.nr_sequencia  and a.ie_tipo_lote		= 'V'
 
union

select	'Carteira devolução' ds_tipo_origem,
	3 ie_tipo_origem,
	b.cd_usuario_plano,
	substr(obter_nome_pf(d.cd_pessoa_fisica),1,255) nm_segurado,
	substr(pls_obter_dados_carteira(null,b.cd_usuario_plano,'P'),1,255) nm_pagador,
	(	select	y.nm_pessoa_fisica
		from	pessoa_fisica y
		where	y.cd_pessoa_fisica = e.cd_pf_estipulante
		
UNION ALL

		select	y.ds_razao_social
		from	pessoa_juridica y
		where	y.cd_cgc = e.cd_cgc_estipulante) nm_estipulante,
	d.nr_seq_pagador,
	d.nr_seq_contrato,
	e.nr_contrato,
	CASE WHEN e.cd_pf_estipulante IS NULL THEN 'PJ'  ELSE 'PF' END  ie_tipo_estipulante,
	c.dt_inicio_vigencia,
	to_char(c.dt_solicitacao,'dd/mm/yyyy') dt_solicitacao,
	c.dt_validade_carteira,
	null nr_lote_emissao,
	a.nr_sequencia	nr_lote_vencimento,
	d.nr_sequencia nr_seq_segurado,
	substr(pls_obter_estagio_carteira(c.nr_sequencia,'D'),1,255) ds_estagio,
	c.nr_sequencia nr_seq_carteira,
	null nr_carteira_emissao,
	null  nr_carteira_vencimento,
	dt_referencia dt_lote
FROM pls_segurado_carteira c, pls_carteira_devolucao b, pls_cart_lote_devolucao a, pls_segurado d
LEFT OUTER JOIN pls_contrato e ON (d.nr_seq_contrato = e.nr_sequencia)
WHERE c.nr_seq_segurado	= d.nr_sequencia and b.cd_usuario_plano	= c.cd_usuario_plano and a.nr_sequencia		= b.nr_seq_lote;

