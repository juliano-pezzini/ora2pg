-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_cabecalho_guias_prot_v (ds_versao, cd_autorizacao, nr_interno_conta, nr_seq_protocolo, cd_cgc, cd_ans, dt_emissao_guia, cd_senha, dt_final_vigencia, nr_seq_med_guia, nr_guia_prestador) AS select	'2.01.01' ds_versao,
	c.cd_autorizacao,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	e.cd_cgc,
	e.cd_ans,
	LOCALTIMESTAMP dt_emissao_guia,
	f.cd_senha,
	f.dt_final_vigencia,
	(null)::numeric  nr_seq_med_guia,
	to_char(a.nr_interno_conta) nr_guia_prestador
FROM 	pessoa_juridica e,
	convenio d,
	conta_paciente_guia c,
	atend_categoria_convenio f,
	atendimento_paciente b,
	conta_paciente a
where	a.nr_atendimento		= b.nr_atendimento
and	a.nr_interno_conta		= c.nr_interno_conta
and	a.cd_convenio_parametro	= d.cd_convenio
and	d.cd_cgc			= e.cd_cgc
and	b.nr_atendimento		= f.nr_atendimento
and	obter_atecaco_atendimento(f.nr_atendimento) = f.nr_seq_interno

union

select	'2.01.01' ds_versao,
	'Não Informada' cd_autorizacao,
	a.nr_interno_conta,
	a.nr_seq_protocolo,
	e.cd_cgc,
	e.cd_ans,
	LOCALTIMESTAMP dt_emissao_guia,
	c.cd_senha,
	c.dt_final_vigencia,
	(null)::numeric  nr_seq_med_guia,
	to_char(a.nr_interno_conta) nr_guia_prestador
from 	pessoa_juridica e,
	convenio d,
	atend_categoria_convenio c,
	atendimento_paciente b,
	conta_paciente a
where	a.nr_atendimento		= b.nr_atendimento
and	a.cd_convenio_parametro	= d.cd_convenio
and	d.cd_cgc			= e.cd_cgc
and	b.nr_atendimento		= c.nr_atendimento
and	obter_atecaco_atendimento(c.nr_atendimento) = c.nr_seq_interno

union

select	'2.01.01' ds_versao,
	b.cd_guia cd_autorizacao,
	(null)::numeric  nr_interno_conta,
	(null)::numeric  nr_seq_protocolo,
	null cd_cgc,
	d.cd_ans,
	a.dt_entrada dt_emissao_guia,
	null cd_senha,
	to_date(null) dt_final_vigencia,
	b.nr_sequencia nr_seq_med_guia,
	b.cd_guia nr_guia_prestador
from 	pessoa_juridica d,
	convenio c,
	med_prot_convenio e,
	med_faturamento b,
	med_atendimento a
where	a.nr_atendimento		= b.nr_atendimento
and	b.nr_seq_protocolo		= e.nr_sequencia
and	e.cd_convenio			= c.cd_convenio
and	c.cd_cgc			= d.cd_cgc;

