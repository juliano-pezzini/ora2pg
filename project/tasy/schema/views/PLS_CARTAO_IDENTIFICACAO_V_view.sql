-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_cartao_identificacao_v (ie_tipo_reg, cd_usuario_plano, ie_plano_regulamentado, nr_contrato, nm_segurado, ds_acomodacao, ds_plano, produto_1, produto_2, produto_3, produto_4, nr_seq_lote, ds_estipulante, ds_reg_ans, ds_abrang, dt_validade_carteira, ds_doc, cd_cod_interno, ds_atendimento, ds_urgencia, cd_carteira_mascara, nr_cartao_nac_sus, dt_nascimento, ds_segmentacao, ds_tipo_contratacao, ds_cd_estipulante) AS select	1 ie_tipo_reg,
	substr(somente_numero_char(d.cd_usuario_plano),1,20) cd_usuario_plano,
	1 ie_plano_regulamentado,
	b.nr_contrato,
	e.nm_pessoa_fisica nm_segurado ,
	coalesce(substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',substr(pls_obter_dados_produto(c.nr_seq_plano,'AP'),1,255)),1,255),'') ds_acomodacao,
	a.DS_PLANO,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,1),1,255),'') produto_1,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,2),1,255),'') produto_2,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,3),1,255),'') produto_3,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,4),1,255),'') produto_4,
	g.nr_sequencia nr_seq_lote,
	CASE WHEN a.ie_tipo_contratacao='I' THEN ''  ELSE (substr(pls_obter_dados_segurado(c.nr_sequencia,'ES'),1,255)) END  ds_estipulante,
	'REG. ANS 36.048-1' ds_reg_ans,
	'ABRAMGE : 0542' ds_abrang,
	d.dt_validade_carteira,
	'RG' ds_doc,
	'0542' cd_cod_interno,
	'Campinas e Região' ds_atendimento,
	'Rede Nacional Abrange.' ds_urgencia,
	substr(d.cd_usuario_plano,1,3)||'-'||substr(d.cd_usuario_plano,4,7)||'.'||substr(d.cd_usuario_plano,11,2)||'-'||substr(d.cd_usuario_plano,13,1) cd_carteira_mascara,
	e.nr_cartao_nac_sus,
	e.dt_nascimento,
	obter_valor_dominio(1665,a.ie_segmentacao) ds_segmentacao,
	obter_valor_dominio(1666,a.ie_tipo_contratacao) ds_tipo_contratacao,
	obter_nome_pf_pj(b.cd_pf_estipulante, b.cd_cgc_estipulante) ds_cd_estipulante 
FROM pessoa_fisica e, pls_segurado_carteira d, pls_segurado c, pls_contrato b, pls_plano a, pls_carteira_emissao f
LEFT OUTER JOIN pls_lote_carteira g ON (f.nr_seq_lote = g.nr_sequencia)
WHERE d.nr_seq_segurado		= c.nr_sequencia and c.nr_seq_contrato		= b.nr_sequencia and c.nr_seq_plano			= a.nr_sequencia and c.cd_pessoa_fisica		= e.cd_pessoa_fisica and a.ie_regulamentacao		= 'P' and f.nr_seq_seg_carteira		= d.nr_sequencia  and b.cd_cgc_estipulante is null and not exists (	select	1
			from	pls_contrato_plano	x,
				pls_contrato		y,
				pls_plano		z
			where	x.nr_seq_contrato	= y.nr_sequencia
			and	y.nr_sequencia		= b.nr_contrato_principal
			and	x.nr_seq_plano		= z.nr_sequencia
			and	z.ie_regulamentacao	= 'R'
			and	y.dt_rescisao_contrato is null
			and	a.cd_codigo_ant		= '14') /*Essa condição é padrão para o cliente Vera Cruz de Campinas, no qual apenas o produto Amblutatorial não irá gerar o arquivo de regulametação caso houver produto nao regulammentado em seu contrato principal*/
 
union

-- CONTRATO DE PESSOA JURÍDICA

select	2 ie_tipo_reg,
	substr(somente_numero_char(d.cd_usuario_plano),1,20) cd_usuario_plano,
	2 ie_plano_regulamentado,
	b.nr_contrato,
	e.nm_pessoa_fisica nm_segurado,
	coalesce(substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',substr(pls_obter_dados_produto(c.nr_seq_plano,'AP'),1,255)),1,255),'') ds_acomodacao,
	a.DS_PLANO,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,1),1,255),'') produto_1,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,2),1,255),'') produto_2,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,3),1,255),'') produto_3,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,4),1,255),'') produto_4,
	g.nr_sequencia nr_seq_lote,
	CASE WHEN a.ie_tipo_contratacao='I' THEN ''  ELSE (substr(pls_obter_dados_segurado(c.nr_sequencia,'ES'),1,255)) END  ds_estipulante,
	'REG. ANS 36.048-1' ds_reg_ans,
	'ABRAMGE : 0542' ds_abrang,
	d.dt_validade_carteira,
	'RG' ds_doc,
	'0542' cd_cod_interno,
	'Campinas e Região' ds_atendimento,
	'Rede Nacional Abrange.' ds_urgencia,
	substr(d.cd_usuario_plano,1,3)||'-'||substr(d.cd_usuario_plano,4,7)||'.'||substr(d.cd_usuario_plano,11,2)||'-'||substr(d.cd_usuario_plano,13,1) cd_carteira_mascara,
	e.nr_cartao_nac_sus,
	e.dt_nascimento,
	obter_valor_dominio(1665,a.ie_segmentacao) ds_segmentacao, 
	obter_valor_dominio(1666,a.ie_tipo_contratacao) ds_tipo_contratacao,
	obter_nome_pf_pj(b.cd_pf_estipulante, b.cd_cgc_estipulante) ds_cd_estipulante
FROM pessoa_fisica e, pls_segurado_carteira d, pls_segurado c, pls_contrato b, pls_plano a, pls_carteira_emissao f
LEFT OUTER JOIN pls_lote_carteira g ON (f.nr_seq_lote = g.nr_sequencia)
WHERE d.nr_seq_segurado		= c.nr_sequencia and c.nr_seq_contrato		= b.nr_sequencia and c.nr_seq_plano			= a.nr_sequencia and c.cd_pessoa_fisica		= e.cd_pessoa_fisica and f.nr_seq_seg_carteira		= d.nr_sequencia  and b.cd_cgc_estipulante is not null
 
union

select	1 ie_tipo_reg,
	substr(somente_numero_char(d.cd_usuario_plano),1,20) cd_usuario_plano,
	3 ie_plano_regulamentado,
	b.nr_contrato,
	e.nm_pessoa_fisica nm_segurado,
	coalesce(substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',substr(pls_obter_dados_produto(c.nr_seq_plano,'AP'),1,255)),1,255),'') ds_acomodacao,
	a.DS_PLANO,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,1),1,255),'') produto_1,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,2),1,255),'') produto_2,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,3),1,255),'') produto_3,
	coalesce(substr(pls_obter_sca_orderm(c.nr_sequencia,4),1,255),'') produto_4,
	g.nr_sequencia nr_seq_lote,
	CASE WHEN a.ie_tipo_contratacao='I' THEN ''  ELSE (substr(pls_obter_dados_segurado(c.nr_sequencia,'ES'),1,255)) END  ds_estipulante,
	'REG. ANS 36.048-1' ds_reg_ans,
	'ABRAMGE : 0542' ds_abrang,
	d.dt_validade_carteira,
	'RG' ds_doc,
	'0542' cd_cod_interno,
	'Campinas e Região' ds_atendimento,
	'Rede Nacional Abrange.' ds_urgencia,
	substr(d.cd_usuario_plano,1,3)||'-'||substr(d.cd_usuario_plano,4,7)||'.'||substr(d.cd_usuario_plano,11,2)||'-'||substr(d.cd_usuario_plano,13,1) cd_carteira_mascara,
	e.nr_cartao_nac_sus,
	e.dt_nascimento,
	a.ie_segmentacao,
	a.ie_tipo_contratacao,
	obter_nome_pf_pj(b.cd_pf_estipulante, b.cd_cgc_estipulante) ds_cd_estipulante
FROM pessoa_fisica e, pls_segurado_carteira d, pls_segurado c, pls_contrato b, pls_plano a, pls_carteira_emissao f
LEFT OUTER JOIN pls_lote_carteira g ON (f.nr_seq_lote = g.nr_sequencia)
WHERE d.nr_seq_segurado		= c.nr_sequencia and c.nr_seq_contrato		= b.nr_sequencia and c.nr_seq_plano			= a.nr_sequencia and c.cd_pessoa_fisica		= e.cd_pessoa_fisica and f.nr_seq_seg_carteira		= d.nr_sequencia  and a.ie_regulamentacao		= 'R' and c.dt_rescisao is null and b.cd_cgc_estipulante is null and not exists (	select	1
			from	pls_segurado		w,
				pls_contrato		x,
				pls_contrato_plano	y,
				pls_plano		z
			where	w.nr_seq_contrato	= x.nr_sequencia
			and	y.nr_seq_contrato	= x.nr_sequencia
			and	y.nr_seq_plano		= z.nr_sequencia
			and	x.nr_contrato_principal	= b.nr_sequencia
			and	w.cd_pessoa_fisica	= c.cd_pessoa_fisica
			and	z.ie_regulamentacao	= 'P')
 
union all

-- CONTRATO PRINCIPAL 						<<<<<<<< COMENTEI ESTE SELECT PARA ATENDER A OS 1103619 >>>>>>>>

/*select	2 ie_tipo_reg,							
	substr(somente_numero_char(j.cd_usuario_plano),1,20) cd_usuario_plano,
	3 ie_plano_regulamentado,
	g.nr_contrato,
	l.nm_pessoa_fisica nm_segurado ,
	nvl(substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',substr(pls_obter_dados_produto(h.nr_seq_plano,'AP'),1,255)),1,255),'') ds_acomodacao,
	i.DS_PLANO,
	substr(somente_numero_char(c.cd_usuario_plano),1,20) || ' - ' || f.ds_plano produto_1,
	nvl(substr(pls_obter_sca_orderm(h.nr_sequencia,1),1,255),'') produto_2,
	nvl(substr(pls_obter_sca_orderm(h.nr_sequencia,2),1,255),'') produto_3,
	nvl(substr(pls_obter_sca_orderm(h.nr_sequencia,3),1,255),'') produto_4,
	a.nr_sequencia nr_seq_lote,
	decode(i.ie_tipo_contratacao,'I','',(substr(pls_obter_dados_segurado(h.nr_sequencia,'ES'),1,255))) ds_estipulante,
	'REG. ANS 36.048-1' ds_reg_ans,
	'ABRAMGE : 0542' ds_abrang,
	c.dt_validade_carteira,
	'RG' ds_doc,
	'0542' cd_cod_interno,
	'Campinas e Região' ds_atendimento,
	'Rede Nacional Abrange.' ds_urgencia,
	substr(c.cd_usuario_plano,1,3)||'-'||substr(c.cd_usuario_plano,4,7)||'.'||substr(c.cd_usuario_plano,11,2)||'-'||substr(c.cd_usuario_plano,13,1) cd_carteira_mascara,
	l.nr_cartao_nac_sus
from	pls_lote_carteira	a,
	pls_carteira_emissao	b,
	pls_segurado_carteira	c,
	pls_segurado		d,
	pls_contrato		e,
	pls_plano		f,
	pls_contrato		g,
	pls_segurado		h,
	pls_plano		i,
	pls_segurado_carteira	j,
	pessoa_fisica		l
where	b.nr_seq_lote		= a.nr_sequencia(+)
and	b.nr_seq_seg_carteira	= c.nr_sequencia
and	c.nr_seq_segurado	= d.nr_sequencia
and	d.nr_seq_contrato	= e.nr_sequencia
and	d.nr_seq_plano		= f.nr_sequencia
and	f.ie_regulamentacao	= 'P'
and	e.nr_contrato_principal	= g.nr_sequencia
and	d.cd_pessoa_fisica	= h.cd_pessoa_fisica
and	h.nr_seq_contrato	= g.nr_sequencia
and	h.nr_seq_plano		= i.nr_sequencia
and	j.nr_seq_segurado	= h.nr_sequencia
and	h.cd_pessoa_fisica	= l.cd_pessoa_fisica
and	i.ie_regulamentacao	= 'R'
and	e.cd_cgc_estipulante is null
and	d.dt_rescisao is null
union all*/

-- CONTRATO PRINCIPAL

select	2 ie_tipo_reg,
	substr(somente_numero_char(c.cd_usuario_plano),1,20) cd_usuario_plano,
	3 ie_plano_regulamentado,
	e.nr_contrato,
	l.nm_pessoa_fisica nm_segurado ,
	coalesce(substr(obter_descricao_padrao('PLS_TIPO_ACOMODACAO','DS_TIPO_ACOMODACAO',substr(pls_obter_dados_produto(f.nr_sequencia,'AP'),1,255)),1,255),'') ds_acomodacao,
	f.ds_plano,
	CASE WHEN h.dt_rescisao IS NULL THEN  substr(somente_numero_char(j.cd_usuario_plano),1,20) || ' - ' || i.ds_plano  ELSE '' END  produto_1, 
	coalesce(substr(pls_obter_sca_orderm(d.nr_sequencia,1),1,255),'') produto_2,
	coalesce(substr(pls_obter_sca_orderm(d.nr_sequencia,2),1,255),'') produto_3,
	coalesce(substr(pls_obter_sca_orderm(d.nr_sequencia,3),1,255),'') produto_4,
	a.nr_sequencia nr_seq_lote,
	CASE WHEN f.ie_tipo_contratacao='I' THEN ''  ELSE (substr(pls_obter_dados_segurado(d.nr_sequencia,'ES'),1,255)) END  ds_estipulante,
	'REG. ANS 36.048-1' ds_reg_ans,
	'ABRAMGE : 0542' ds_abrang,
	c.dt_validade_carteira,
	'RG' ds_doc,
	'0542' cd_cod_interno,
	'Campinas e Região' ds_atendimento,
	'Rede Nacional Abrange.' ds_urgencia,
	substr(c.cd_usuario_plano,1,3)||'-'||substr(c.cd_usuario_plano,4,7)||'.'||substr(c.cd_usuario_plano,11,2)||'-'||substr(c.cd_usuario_plano,13,1) cd_carteira_mascara,
	l.nr_cartao_nac_sus,
	l.dt_nascimento,
	obter_valor_dominio(1665,f.ie_segmentacao) ds_segmentacao, 
	obter_valor_dominio(1666,f.ie_tipo_contratacao) ds_tipo_contratacao,
	obter_nome_pf_pj(e.cd_pf_estipulante, e.cd_cgc_estipulante) ds_cd_estipulante
FROM pessoa_fisica l, pls_segurado_carteira j, pls_plano i, pls_segurado h, pls_contrato g, pls_plano f, pls_contrato e, pls_segurado d, pls_segurado_carteira c, pls_carteira_emissao b
LEFT OUTER JOIN pls_lote_carteira a ON (b.nr_seq_lote = a.nr_sequencia)
WHERE b.nr_seq_seg_carteira	= c.nr_sequencia and c.nr_seq_segurado	= d.nr_sequencia and d.nr_seq_contrato	= e.nr_sequencia and d.nr_seq_plano		= f.nr_sequencia and f.ie_regulamentacao	= 'R' and e.nr_sequencia		= g.nr_contrato_principal and d.cd_pessoa_fisica	= h.cd_pessoa_fisica and h.nr_seq_contrato	= g.nr_sequencia and h.nr_seq_plano		= i.nr_sequencia and j.nr_seq_segurado	= h.nr_sequencia and h.cd_pessoa_fisica	= l.cd_pessoa_fisica and i.ie_regulamentacao	= 'P' and e.cd_cgc_estipulante is null and d.dt_rescisao is null order by nr_seq_lote;

