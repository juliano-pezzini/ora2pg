-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_relatorio_vera_cruz_v (ie_tipo, cd_usuario_plano, nm_segurado, nr_seq_protocolo, nm_prestador, nm_prestador_executor, cd_item, ds_item, ds_tipo_guia, ie_tipo_protocolo, dt_entrada, dt_alta, nm_medico_solicitante, vl_liberado, dt_item, nr_seq_segurado) AS select	'P' ie_tipo,
	pls_obter_dados_segurado(a.nr_seq_segurado,'C') cd_usuario_plano, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'N') nm_segurado, 
	a.nr_seq_protocolo, 
	substr(pls_obter_dados_prestador(c.nr_seq_prestador,'N'),1,100) nm_prestador, 
	substr(pls_obter_dados_prestador(a.nr_seq_prestador_exec,'N'),1,100) nm_prestador_executor, 
	to_char(b.cd_procedimento) cd_item, 
	substr(obter_descricao_procedimento(b.cd_procedimento,b.ie_origem_proced),1,255)  ds_item, 
 	substr(obter_valor_dominio(1746,a.ie_tipo_guia),1,150) ds_tipo_guia, 
 	'NÃO' ie_tipo_protocolo, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_entrada  ELSE b.dt_procedimento END  dt_entrada, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_alta  ELSE '' END  dt_alta, 
  	substr(obter_nome_pf(a.cd_medico_solicitante),1,100) nm_medico_solicitante, 
	b.vl_liberado, 
	a.dt_emissao dt_item, 
	a.nr_seq_segurado 
FROM	pls_protocolo_conta c, 
 	pls_conta_proc  b, 
 	pls_conta  a 
where 	a.nr_sequencia	= b.nr_seq_conta 
and 	c.ie_tipo_protocolo 	= 'C' 
and  	a.nr_seq_protocolo 	= c.nr_sequencia 

union all
 
select 	'P' ie_tipo, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'C') cd_usuario_plano, 
  	pls_obter_dados_segurado(a.nr_seq_segurado,'N') nm_segurado, 
  	a.nr_seq_protocolo, 
  	obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc) nm_prestador, 
  	substr(pls_obter_dados_prestador(a.nr_seq_prestador_exec,'N'),1,100) nm_prestador_executor, 
	to_char(b.cd_procedimento) cd_item, 
 	substr(obter_descricao_procedimento(b.cd_procedimento,b.ie_origem_proced),1,255)  ds_item, 
 	substr(obter_valor_dominio(1746,a.ie_tipo_guia),1,150) ds_tipo_guia, 
 	'SIM' ie_tipo_protocolo, 
 	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_entrada  ELSE b.dt_procedimento END  dt_entrada, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_alta  ELSE '' END  dt_alta, 
  	substr(obter_nome_pf(a.cd_medico_solicitante),1,100) nm_medico_solicitante, 
	b.vl_liberado, 
	a.dt_emissao dt_item, 
	a.nr_seq_segurado 
from 	pls_protocolo_conta c, 
 	pls_conta_proc  b, 
 	pls_conta  a 
where 	a.nr_sequencia	= b.nr_seq_conta 
and 	c.ie_tipo_protocolo 	= 'R' 
and  	a.nr_seq_protocolo	= c.nr_sequencia 

union all
 
select	'M' ie_tipo, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'C') cd_usuario_plano, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'N') nm_segurado, 
	a.nr_seq_protocolo, 
	substr(pls_obter_dados_prestador(c.nr_seq_prestador,'N'),1,100) nm_prestador, 
	substr(pls_obter_dados_prestador(a.nr_seq_prestador_exec,'N'),1,100) nm_prestador_executor, 
	coalesce(d.cd_material_ops,to_char(b.nr_seq_material)) cd_item, 
 	substr(pls_obter_dados_conta_mat(b.nr_sequencia,'D'),1,255)  ds_item, 
 	substr(obter_valor_dominio(1746,a.ie_tipo_guia),1,150) ds_tipo_guia, 
 	'NÃO' ie_tipo_protocolo, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_entrada  ELSE b.dt_atendimento END  dt_entrada, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_alta  ELSE '' END  dt_alta, 
  	substr(obter_nome_pf(a.cd_medico_solicitante),1,100) nm_medico_solicitante, 
	b.vl_liberado, 
	a.dt_emissao dt_item, 
	a.nr_seq_segurado 
from	pls_material	d, 
	pls_protocolo_conta c, 
 	pls_conta_mat  b, 
 	pls_conta  a 
where 	a.nr_sequencia	= b.nr_seq_conta 
and 	c.ie_tipo_protocolo 	= 'C' 
and  	a.nr_seq_protocolo 	= c.nr_sequencia 
and	d.nr_sequencia	= b.nr_seq_material 

union all
 
select 	'M' ie_tipo, 
	pls_obter_dados_segurado(a.nr_seq_segurado,'C') cd_usuario_plano, 
  	pls_obter_dados_segurado(a.nr_seq_segurado,'N') nm_segurado, 
  	a.nr_seq_protocolo, 
  	obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc) nm_prestador, 
  	substr(pls_obter_dados_prestador(a.nr_seq_prestador_exec,'N'),1,100) nm_prestador_executor, 
	coalesce(d.cd_material_ops,to_char(b.nr_seq_material)) cd_item, 
 	substr(pls_obter_dados_conta_mat(b.nr_sequencia,'D'),1,255)  ds_item, 
 	substr(obter_valor_dominio(1746,a.ie_tipo_guia),1,150) ds_tipo_guia, 
 	'SIM' ie_tipo_protocolo, 
 	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_entrada  ELSE b.dt_atendimento END  dt_entrada, 
  	CASE WHEN a.ie_tipo_guia='5' THEN a.dt_alta  ELSE '' END  dt_alta, 
  	substr(obter_nome_pf(a.cd_medico_solicitante),1,100) nm_medico_solicitante, 
	b.vl_liberado, 
	a.dt_emissao dt_item, 
	a.nr_seq_segurado 
from 	pls_material	d, 
	pls_protocolo_conta c, 
 	pls_conta_mat  b, 
 	pls_conta  a 
where 	a.nr_sequencia	= b.nr_seq_conta 
and 	c.ie_tipo_protocolo 	= 'R' 
and  	a.nr_seq_protocolo	= c.nr_sequencia 
and	d.nr_sequencia	= b.nr_seq_material 
order by 	nm_prestador_executor, nm_segurado;

