-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_retorno_convenio_glosa_v2 (ds_convenio, cd_convenio, ds_tipo_convenio, ie_tipo_convenio, dt_referencia, dt_baixa_cr, cd_empresa, ie_tipo_atendimento, ds_tipo_atendimento, cd_categoria, ds_categoria, cd_motivo_glosa, ds_motivo_glosa, cd_setor_atendimento, cd_setor_responsavel, ds_setor_atendimento, ds_setor_responsavel, vl_cobrado_unit, vl_cobrado, vl_pago, vl_total_pago, vl_repasse_item, vl_glosa) AS select	substr(obter_nome_convenio(b.cd_convenio_parametro),1,255) ds_convenio,
	b.cd_convenio_parametro cd_convenio, 
	null ds_tipo_convenio, 
	null ie_tipo_convenio, 
	trunc(c.dt_retorno) dt_referencia, 
	trunc(c.dt_baixa_cr) dt_baixa_cr, 
	substr(obter_empresa_estab(b.cd_estabelecimento),1,255) cd_empresa, 
	e.ie_tipo_atendimento, 
	substr(obter_valor_dominio(12,ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	f.cd_categoria, 
	(substr(obter_nome_convenio(b.cd_convenio_parametro),1,150) || ' - ' || f.ds_categoria) ds_categoria, 
	g.cd_motivo_glosa, 
	coalesce(h.ds_motivo_glosa,'Não Informado') ds_motivo_glosa, 
	g.cd_setor_atendimento, 
	g.cd_setor_responsavel, 
	substr(obter_dados_setor(g.cd_setor_atendimento,'DS'),1,255) ds_setor_atendimento, 
	substr(obter_dados_setor(g.cd_setor_responsavel,'DS'),1,255) ds_setor_responsavel, 
	(obter_dados_ret_movto_glosa(g.nr_sequencia, 6))::numeric  vl_cobrado_unit, 
	g.vl_cobrado vl_cobrado, 
	(obter_dados_ret_movto_glosa(g.nr_sequencia, 7))::numeric  vl_pago, 
	coalesce(vl_pago_digitado,(obter_dados_ret_movto_glosa(g.nr_sequencia, 3))::numeric ) vl_total_pago, 
	g.vl_repasse_item vl_repasse_item, 
	g.vl_glosa 
FROM categoria_convenio f, atendimento_paciente e, convenio_retorno c, conta_paciente b, convenio_retorno_item a, convenio_retorno_glosa g
LEFT OUTER JOIN motivo_glosa h ON (g.cd_motivo_glosa = h.cd_motivo_glosa)
WHERE a.nr_interno_conta 	= b.nr_interno_conta and c.cd_convenio		= b.cd_convenio_parametro and a.nr_Seq_retorno 		= c.nr_sequencia and b.nr_atendimento		= e.nr_atendimento and c.cd_convenio		= f.cd_convenio and b.cd_categoria_parametro 	= f.cd_categoria and g.nr_seq_ret_item		= a.nr_sequencia  
union all
 
select	null ds_convenio, 
	null cd_convenio, 
	substr(OBTER_VALOR_DOMINIO(11,d.ie_tipo_convenio),1,255) ds_tipo_convenio, 
	d.ie_tipo_convenio ie_tipo_convenio, 
	trunc(c.dt_retorno) dt_referencia, 
	trunc(c.dt_baixa_cr) dt_baixa_cr, 
	substr(obter_empresa_estab(b.cd_estabelecimento),1,255) cd_empresa, 
	e.ie_tipo_atendimento, 
	substr(obter_valor_dominio(12,ie_tipo_atendimento),1,255) ds_tipo_atendimento, 
	f.cd_categoria, 
	(substr(obter_nome_convenio(b.cd_convenio_parametro),1,150) || ' - ' || f.ds_categoria) ds_categoria, 
	g.cd_motivo_glosa, 
	coalesce(h.ds_motivo_glosa,'Não Informado') ds_motivo_glosa, 
	g.cd_setor_atendimento, 
	g.cd_setor_responsavel, 
	substr(obter_dados_setor(g.cd_setor_atendimento,'DS'),1,255) ds_setor_atendimento, 
	substr(obter_dados_setor(g.cd_setor_responsavel,'DS'),1,255) ds_setor_responsavel, 
	(obter_dados_ret_movto_glosa(g.nr_sequencia, 6))::numeric  vl_cobrado_unit, 
	g.vl_cobrado vl_cobrado, 
	(obter_dados_ret_movto_glosa(g.nr_sequencia, 7))::numeric  vl_pago, 
	coalesce(vl_pago_digitado,(obter_dados_ret_movto_glosa(g.nr_sequencia, 3))::numeric ) vl_total_pago, 
	g.vl_repasse_item vl_repasse_item, 
	g.vl_glosa 
FROM categoria_convenio f, atendimento_paciente e, convenio d, convenio_retorno c, conta_paciente b, convenio_retorno_item a, convenio_retorno_glosa g
LEFT OUTER JOIN motivo_glosa h ON (g.cd_motivo_glosa = h.cd_motivo_glosa)
WHERE b.cd_convenio_parametro	= d.cd_convenio and c.cd_convenio		= d.cd_convenio and a.nr_interno_conta 	= b.nr_interno_conta and a.nr_Seq_retorno 		= c.nr_sequencia and b.nr_atendimento		= e.nr_atendimento and c.cd_convenio		= f.cd_convenio and b.cd_categoria_parametro 	= f.cd_categoria and g.nr_seq_ret_item		= a.nr_sequencia;

