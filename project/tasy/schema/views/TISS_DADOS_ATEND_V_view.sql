-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_dados_atend_v (ds_versao, ie_origem, cd_procedimento, vl_item, ds_item, dt_entrada, nr_atendimento, cd_convenio, ie_tipo_atendimento, ds_tipo_saida, cd_edicao) AS select	'2.1.02' ds_versao,
	'MED' ie_origem,
	substr(med_obter_cod_item_convenio(a.nr_atendimento, a.nr_seq_item),1,254) cd_procedimento,
	a.vl_item,
	e.ds_item,
	trunc(d.dt_entrada) dt_entrada,
	a.nr_atendimento,
	c.cd_convenio,
	null ie_tipo_atendimento,
	null ds_tipo_saida,
	null cd_edicao
FROM	med_item e,
	med_atendimento d,
	convenio c,
	med_prot_convenio b,
	med_faturamento a
where	a.nr_seq_protocolo	= b.nr_sequencia
and	b.cd_convenio		= c.cd_convenio
and	a.nr_atendimento	= d.nr_atendimento
and	a.nr_seq_item		= e.nr_sequencia

union

select	'2.1.02' ds_versao,
	'AP' ie_origem,
	to_char(coalesce(c.cd_procedimento_convenio, c.cd_procedimento)) cd_procedimento,
	0 vl_item,
	null ds_item,
	a.dt_entrada,
	c.nr_atendimento,
	b.cd_convenio,
	CASE WHEN a.ie_tipo_atendimento=1 THEN  '7' WHEN a.ie_tipo_atendimento=3 THEN  '4' WHEN a.ie_tipo_atendimento=7 THEN  '6' WHEN a.ie_tipo_atendimento=8 THEN '4' END  ie_tipo_atendimento,
	'5' ds_tipo_saida,
	coalesce(substr(tiss_obter_tabela(c.cd_edicao_amb, d.cd_estabelecimento, b.cd_convenio, b.cd_categoria,
				 c.dt_conta, 'R', OBTER_CLASSIF_MATERIAL_PROCED(null, c.cd_procedimento, c.ie_origem_proced),
				 c.cd_procedimento, c.ie_origem_proced, null, null,a.nr_atendimento,c.nr_seq_proc_interno,
				 c.nr_seq_exame, c.cd_procedimento_tuss),1,80),'00') cd_edicao
from	conta_paciente d,
	atend_categoria_convenio b,
	atendimento_paciente a,
	procedimento_paciente c
where	a.nr_atendimento				= b.nr_atendimento
and	obter_atecaco_atendimento(a.nr_atendimento) 	= b.nr_seq_interno
and	a.nr_atendimento				= d.nr_atendimento
and	d.nr_interno_conta				= c.nr_interno_conta
and	b.cd_convenio					= d.cd_convenio_parametro
and	d.ie_cancelamento				is null
and	c.ie_proc_princ_atend				= 'S'

union

select	'2.1.02' ds_versao,
	'AP' ie_origem,
	null cd_procedimento,
	0 vl_item,
	null ds_item,
	a.dt_entrada,
	a.nr_atendimento,
	b.cd_convenio,
	CASE WHEN a.ie_tipo_atendimento=1 THEN  '7' WHEN a.ie_tipo_atendimento=3 THEN  '4' WHEN a.ie_tipo_atendimento=7 THEN  '6' WHEN a.ie_tipo_atendimento=8 THEN '4' END  ie_tipo_atendimento,
	'5' ds_tipo_saida,
	null cd_edicao
from	atend_categoria_convenio b,
	atendimento_paciente a
where	a.nr_atendimento				= b.nr_atendimento
and	obter_atecaco_atendimento(a.nr_atendimento) 	= b.nr_seq_interno
and	not exists (	select	1
			from	procedimento_paciente x,
				conta_paciente y
			where	y.nr_interno_conta	= x.nr_interno_conta
			and	y.nr_atendimento	= a.nr_atendimento
			and	y.cd_convenio_parametro	= b.cd_convenio
			and	y.ie_cancelamento	is null
			and	x.ie_proc_princ_atend	= 'S');
