-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW usuario_estabelecimento_v (nm_usuario, nm_usuario_param, cd_estabelecimento, ds_razao_social, nm_fantasia, cd_empresa, ds_arq_logo, ds_fantasia, ie_situacao, ds_desc_estab, cd_setor_atendimento, ds_msg_barra) AS select	a.nm_usuario,
	a.nm_usuario nm_usuario_param,
	b.cd_estabelecimento,
	c.ds_razao_social,
	c.nm_fantasia,
	b.cd_empresa,
	b.ds_arq_logo,
	coalesce(b.nm_fantasia_estab, c.ds_razao_social) ds_fantasia,
	b.ie_situacao,
	CASE WHEN b.ie_razao_fantasia='R' THEN  c.ds_razao_social WHEN b.ie_razao_fantasia='E' THEN b.nm_fantasia_estab WHEN b.ie_razao_fantasia='F' THEN c.nm_fantasia END  ds_desc_estab,
	null cd_setor_atendimento,
	CASE WHEN b.ie_desc_barra_msg='RS' THEN c.ds_razao_social WHEN b.ie_desc_barra_msg='FE' THEN b.nm_fantasia_estab  ELSE c.nm_fantasia END  ds_msg_barra
FROM	Pessoa_Juridica c,
	Estabelecimento b,
	usuario a
where a.cd_estabelecimento         = b.cd_estabelecimento
  and b.cd_cgc                     = c.cd_cgc

union

select	a.nm_usuario_param,
	a.nm_usuario_param,
	b.cd_estabelecimento,
	c.ds_razao_social,
	c.nm_fantasia,
	b.cd_empresa,
	b.ds_arq_logo,
	coalesce(b.nm_fantasia_estab, c.ds_razao_social) ds_fantasia,
	b.ie_situacao,
	CASE WHEN b.ie_razao_fantasia='R' THEN  c.ds_razao_social WHEN b.ie_razao_fantasia='E' THEN b.nm_fantasia_estab WHEN b.ie_razao_fantasia='F' THEN  c.nm_fantasia END  ds_desc_estab,
	null cd_setor_padrao,
	CASE WHEN b.ie_desc_barra_msg='RS' THEN c.ds_razao_social WHEN b.ie_desc_barra_msg='FE' THEN b.nm_fantasia_estab  ELSE c.nm_fantasia END  ds_msg_barra
from	Pessoa_Juridica c,
	Estabelecimento b,
	usuario_estabelecimento a
where a.cd_estabelecimento         = b.cd_estabelecimento
  and b.cd_cgc                     = c.cd_cgc;

