-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_cartao_life_empresarial_v (tp_registro, cd_cartao_identificacao, nm_beneficiario, dt_nascimento, nm_empresa, ds_plano, ds_acomodacao, dt_validade, ds_carencia, dt_adesao, nm_titular, ds_departamento, nr_seq_lote, ds_carencia_1, ds_carencia_2, ds_carencia_3, ds_carencia_4, ds_carencia_5) AS select	2																		tp_registro,
	substr(d.cd_usuario_plano,1,6)||'.'||substr(d.cd_usuario_plano,7,2)||'.'||substr(d.cd_usuario_plano,9,5)||'.'||substr(d.cd_usuario_plano,14,2)	cd_cartao_identificacao, 
	f.nm_pessoa_fisica																nm_beneficiario, 
	to_char(f.dt_nascimento,'dd/mm/yyyy')														dt_nascimento, 
	substr(pls_obter_dados_segurado(e.nr_sequencia,'ES'),1,255)											nm_empresa, 
	c.nm_fantasia																	ds_plano, 
	substr(pls_obter_dados_cart_unimed(e.nr_sequencia,c.nr_sequencia,'DA',0),1,255)									ds_acomodacao, 
	to_char(d.dt_validade_carteira,'dd/mm/yyyy')													dt_validade, 
	substr(pls_se_obter_carencia_cumprida(e.nr_sequencia),1,50)											ds_carencia, 
	to_char(e.dt_contratacao,'dd/mm/yyyy')														dt_adesao, 
	CASE WHEN e.nr_seq_titular IS NULL THEN f.nm_pessoa_fisica  ELSE substr(pls_obter_dados_segurado(e.nr_sequencia,'NT'),1,255) END 					nm_titular, 
	(	select	max(x.ds_localizacao) 
		FROM	pls_localizacao_benef	x 
		where	x.nr_sequencia		= e.nr_seq_localizacao_benef)										ds_departamento, 
	a.nr_sequencia																	nr_seq_lote, 
	coalesce(substr(pls_obter_dados_carencia_life(e.nr_sequencia,1),1,255),';')										ds_carencia_1, 
	coalesce(substr(pls_obter_dados_carencia_life(e.nr_sequencia,2),1,255),';')										ds_carencia_2, 
	coalesce(substr(pls_obter_dados_carencia_life(e.nr_sequencia,3),1,255),';')										ds_carencia_3, 
	coalesce(substr(pls_obter_dados_carencia_life(e.nr_sequencia,4),1,255),';')										ds_carencia_4, 
	coalesce(substr(pls_obter_dados_carencia_life(e.nr_sequencia,5),1,255),';')										ds_carencia_5 
from	pessoa_fisica		f, 
	pls_segurado		e, 
	pls_segurado_carteira	d, 
	pls_plano		c, 
	pls_carteira_emissao	b, 
	pls_lote_carteira	a 
where	b.nr_seq_lote		= a.nr_sequencia 
and	b.nr_seq_seg_carteira	= d.nr_sequencia 
and	d.nr_seq_segurado	= e.nr_sequencia 
and	e.nr_seq_plano		= c.nr_sequencia 
and	e.cd_pessoa_fisica	= f.cd_pessoa_fisica;

