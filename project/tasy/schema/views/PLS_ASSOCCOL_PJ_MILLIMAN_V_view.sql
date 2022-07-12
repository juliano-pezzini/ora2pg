-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_assoccol_pj_milliman_v (nr_sequencia, ds_razao_social, nr_cnpj, nr_matricula_benef, nm_beneficiario, ie_sexo, dt_nascimento, nm_municipio, dt_ingresso, nr_matricula_pj, ie_tipo_contratacao, ie_tipo_garantia, dt_saida, cd_ramo_atividade, cd_produto_ans, ie_grau_dependencia, nr_matricula_titular, nr_cpf_titular, nm_lote, tp_registro, cd_estabelecimento) AS select	c.nr_sequencia,
	b.ds_razao_social					ds_razao_social,
	b.cd_cgc						nr_cnpj,
	e.cd_usuario_plano					nr_matricula_benef,
	d.nm_pessoa_fisica					nm_beneficiario,
	d.ie_sexo						ie_sexo,
	d.dt_nascimento						dt_nascimento,
	substr(CASE WHEN obter_compl_pf(c.cd_pessoa_fisica,1,'DM')='' THEN
	c.dt_contratacao		dt_ingresso,
	a.cd_operadora_empresa		nr_matricula_pj,
	g.ie_tipo_contratacao		ie_tipo_contratacao,
	CASE WHEN g.ie_segmentacao='3' THEN  '1' WHEN g.ie_segmentacao='7' THEN  '2' WHEN g.ie_segmentacao='1' THEN  '3' WHEN g.ie_segmentacao='2' THEN  '4' WHEN g.ie_segmentacao='11' THEN  '5' WHEN g.ie_segmentacao='5' THEN  '6' WHEN g.ie_segmentacao='12' THEN  '7' WHEN g.ie_segmentacao='10' THEN  '8' WHEN g.ie_segmentacao='8' THEN  '9' WHEN g.ie_segmentacao='9' THEN  '10' WHEN g.ie_segmentacao='4' THEN  '11' WHEN g.ie_segmentacao='6' THEN  '12' END  ie_tipo_garantia,
	c.dt_rescisao			dt_saida,
	substr(b.nr_seq_cnae||' '||obter_desc_cnae(b.nr_seq_cnae),1,255)	cd_ramo_atividade,	
	CASE WHEN g.ie_regulamentacao='R' THEN  g.cd_scpa  ELSE g.nr_protocolo_ans END 	cd_produto_ans,
	CASE WHEN c.nr_seq_titular IS NULL THEN  '1'  ELSE CASE WHEN c.nr_seq_parentesco=125 THEN '3'  ELSE '2' END  END 	ie_grau_dependencia,
	CASE WHEN c.nr_seq_titular IS NULL THEN  e.cd_usuario_plano  ELSE (	select	y.cd_usuario_plano
	CASE WHEN c.nr_seq_titular IS NULL THEN  d.nr_cpf  ELSE (	select	x.nr_cpf
	' '	nm_lote,
	' '	tp_registro,
	d.cd_estabelecimento
from	pessoa_fisica		d,
	pls_segurado		c,
	pls_segurado_carteira	e,
	pls_plano		g,	
	pessoa_juridica		b,
	pls_contrato		a
where	c.cd_pessoa_fisica	= d.cd_pessoa_fisica
and	c.nr_sequencia 		= e.nr_seq_segurado
and	a.cd_cgc_estipulante 	= b.cd_cgc
and	a.nr_sequencia 		= c.nr_seq_contrato
and	c.nr_seq_plano		= g.nr_sequencia
and	g.ie_tipo_contratacao 	in ('CE','CA')
and	c.ie_tipo_segurado	= 'B'
and	a.cd_operadora_empresa <> 57;
