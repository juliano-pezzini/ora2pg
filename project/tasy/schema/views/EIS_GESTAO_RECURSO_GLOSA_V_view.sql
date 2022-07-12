-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_gestao_recurso_glosa_v (vl_pago, vl_naceito, vl_aceito, vl_glosa, vl_pago_recurso, vl_conta, ds_convenio, cd_convenio_parametro, ds_tipo_convenio, ie_tipo_convenio, dt_referencia, dt_baixa_cr, cd_empresa, ie_tipo_atendimento, ds_tipo_atendimento, cd_categoria, ds_categoria, cd_estabelecimento, nm_usuario_glosa, dt_mesano_referencia) AS select	/*+ RULE */	obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VP') vl_pago, 
	obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VA') vl_naceito, 
	obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VG') vl_aceito, 
	(obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VA') + 
	obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VG')) vl_glosa, 
	obter_valores_guia_grc(c.nr_seq_lote_hist,c.nr_interno_conta,c.cd_autorizacao,'VPR') vl_pago_recurso, 
	d.vl_conta, 
	substr(obter_nome_convenio(d.cd_convenio_parametro),1,255) ds_convenio, 
	d.cd_convenio_parametro, 
	substr(obter_valor_dominio(11,e.ie_tipo_convenio),1,255) ds_tipo_convenio, 
	e.ie_tipo_convenio, 
	trunc(a.dt_lote) dt_referencia, 
	trunc(b.dt_baixa_glosa) dt_baixa_cr, 
	substr(obter_empresa_estab(d.cd_estabelecimento),1,255) cd_empresa, 
	f.ie_tipo_atendimento, 
	substr(obter_valor_dominio(12,f.ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	g.cd_categoria, 
	(substr(obter_nome_convenio(d.cd_convenio_parametro),1,150) || ' - ' || g.ds_categoria) ds_categoria, 
	a.cd_estabelecimento, 
	c.nm_usuario nm_usuario_glosa, 
	d.dt_mesano_referencia 
FROM	categoria_convenio g, 
	atendimento_paciente f, 
	convenio e, 
	conta_paciente d, 
	lote_audit_hist_guia c, 
	lote_audit_hist b, 
	lote_auditoria a 
where	d.cd_convenio_parametro		= g.cd_convenio 
and	d.cd_categoria_parametro	= g.cd_categoria 
and	d.nr_atendimento		= f.nr_atendimento 
and	d.cd_convenio_parametro		= e.cd_convenio 
and	c.nr_interno_conta		= d.nr_interno_conta 
and	b.nr_sequencia			= c.nr_seq_lote_hist 
and	a.nr_sequencia			= b.nr_seq_lote_audit;
