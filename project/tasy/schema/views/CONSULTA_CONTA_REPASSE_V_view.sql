-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_conta_repasse_v (proc_mate_item, ds_terceiro, cd_convenio, ds_convenio, nm_paciente, nm_medico, nr_atendimento, nr_seq_protocolo, dt_mesano_referencia, ds_proc_mat, ds_setor, dt_proc_mat, nr_interno_conta, vl_repasse, vl_procedimento, nr_seq_terceiro, ie_status_protocolo, ie_sintetico, cd_setor_atendimento, ie_tipo_protocolo) AS select  proc_mate_item,
  ds_terceiro, 
  cd_convenio, 
  ds_convenio, 
  nm_paciente, 
  nm_medico, 
  nr_atendimento, 
  nr_seq_protocolo,     
  dt_mesano_referencia, 
  substr(ds_proc_mat, 1,200) ds_proc_mat, 
  substr(obter_dados_setor(cd_setor_atendimento,'DS'),1,50) ds_setor, 
  dt_proc_mat, 
  nr_interno_conta, 
  vl_repasse, 
  vl_procedimento, 
  nr_seq_terceiro, 
  ie_status_protocolo, 
  ie_sintetico, 
  cd_setor_atendimento, 
	ie_tipo_protocolo 
FROM ( 
select  'Procedimento' proc_mate_item,   
  substr(obter_nome_terceiro(d.nr_seq_terceiro),1,100) ds_terceiro, 
  c.cd_convenio, 
  obter_nome_convenio(c.cd_convenio) ds_convenio, 
  substr(obter_pessoa_atendimento(c.nr_atendimento,'N'),1,100) nm_paciente, 
  substr(obter_nome_medico(d.cd_medico,'NC'),1,255) nm_medico, 
  c.nr_atendimento, 
  a.nr_seq_protocolo, 
  a.dt_mesano_referencia, 
  substr(obter_descricao_procedimento(c.cd_procedimento,c.ie_origem_proced),1,100) ds_proc_mat, 
  c.dt_procedimento dt_proc_mat, 
  b.nr_interno_conta, 
  c.cd_setor_atendimento, 
  sum(d.vl_repasse) vl_repasse, 
  sum(c.vl_procedimento) vl_procedimento, 
  d.nr_seq_terceiro, 
  a.ie_status_protocolo, 
  'N' ie_sintetico, 
  a.ie_tipo_protocolo 
from  procedimento_repasse d, 
  procedimento_paciente c, 
  conta_paciente b, 
  protocolo_convenio a 
where  a.nr_seq_protocolo  = b.nr_seq_protocolo 
and  a.cd_estabelecimento  = 1 
and  b.nr_interno_conta  = c.nr_interno_conta 
and  c.nr_sequencia    = d.nr_seq_procedimento 
and  c.cd_motivo_exc_conta   is null 
group by  c.nr_atendimento, 
  c.cd_convenio, 
  c.cd_procedimento, 
  c.ie_origem_proced, 
  c.dt_procedimento, 
  b.nr_interno_conta, 
  c.cd_setor_atendimento, 
  d.vl_repasse, 
  d.nr_seq_terceiro, 
  d.cd_medico, 
  a.nr_seq_protocolo, 
  a.dt_mesano_referencia, 
  a.ie_status_protocolo, 
  a.ie_tipo_protocolo 

union all
 
select  'Material' proc_mate_item,   
  substr(obter_nome_terceiro(d.nr_seq_terceiro),1,100) ds_terceiro, 
  c.cd_convenio, 
  substr(obter_nome_convenio(c.cd_convenio),1,255) ds_convenio, 
  substr(obter_pessoa_atendimento(c.nr_atendimento,'N'),1,100) nm_paciente, 
  substr(obter_nome_medico(d.cd_medico,'NC'),1,255) nm_medico, 
  c.nr_atendimento,   
  a.nr_seq_protocolo, 
  a.dt_mesano_referencia, 
  obter_desc_estrut_mat(null, null, null, c.cd_material) ds_proc_mat, 
  c.dt_atendimento dt_proc_mat, 
  c.nr_interno_conta, 
  c.cd_setor_atendimento,   
  sum(d.vl_repasse) vl_repasse, 
  sum(c.vl_material) vl_procedimento, 
  d.nr_seq_terceiro, 
  a.ie_status_protocolo, 
  'N' ie_sintetico, 
  a.ie_tipo_protocolo 
from  material_repasse d, 
  material_atend_paciente c, 
  conta_paciente b, 
  protocolo_convenio a 
where  a.nr_seq_protocolo  = b.nr_seq_protocolo 
and  a.cd_estabelecimento  = 1 
and  b.nr_interno_conta  = c.nr_interno_conta 
and  c.nr_sequencia    = d.nr_seq_material 
and  c.cd_motivo_exc_conta   is null 
group by  c.nr_atendimento, 
  c.cd_convenio, 
  c.cd_material, 
  c.dt_atendimento, 
  c.nr_interno_conta, 
  c.cd_setor_atendimento,   
  d.vl_repasse, 
  d.nr_seq_terceiro, 
  d.cd_medico, 
  a.nr_seq_protocolo, 
  a.dt_mesano_referencia, 
  a.ie_status_protocolo, 
  a.ie_tipo_protocolo/* 
union	all 
select	'Itens de repasse' proc_mate_item, 
	substr(obter_nome_terceiro(a.nr_seq_terceiro),1,100) ds_terceiro, 
	a.cd_convenio, 
	substr(obter_nome_convenio(a.cd_convenio),1,255) ds_convenio, 
	substr(obter_pessoa_atendimento(c.nr_atendimento,'N'),1,100) nm_paciente, 
	substr(obter_nome_medico(a.cd_medico,'NC'),1,255) nm_medico, 
	c.nr_atendimento,   
	f.nr_seq_protocolo, 
	f.dt_mesano_referencia, 
	nvl(substr(Obter_Desc_Procedimento(a.cd_procedimento,a.ie_origem_proced),1,255),substr(Obter_Desc_Material(a.cd_material),1,255))	ds_proc_mat, 
	c.dt_entrada dt_proc_mat, 
	d.nr_interno_conta, 
	null cd_setor_atendimento,   
	sum(a.vl_repasse) vl_repasse, 
	0 vl_procedimento, 
	a.nr_seq_terceiro, 
	f.ie_status_protocolo, 
	'N' ie_sintetico 
from	protocolo_convenio f, 
	conta_paciente d, 
	pessoa_fisica e, 
	atendimento_paciente c, 
	terceiro g, 
	repasse_terceiro_item a 
where	e.cd_pessoa_fisica	= c.cd_pessoa_fisica 
and	c.nr_atendimento	= a.nr_atendimento 
and	g.nr_sequencia		= a.nr_seq_terceiro 
and	c.nr_atendimento	= d.nr_atendimento 
and	d.nr_seq_protocolo	= f.nr_seq_protocolo 
and	c.cd_estabelecimento	= 1 
group by a.cd_convenio, 
	a.nr_seq_terceiro, 
	c.nr_atendimento, 
	a.cd_medico, 
	f.nr_seq_protocolo, 
	f.dt_mesano_referencia, 
	c.dt_entrada, 
	d.nr_interno_conta, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_material, 
	f.ie_status_protocolo*/
 
) alias25 
order by   1,2, 4,5;

