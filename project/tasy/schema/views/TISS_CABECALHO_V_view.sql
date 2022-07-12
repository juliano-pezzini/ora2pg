-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_cabecalho_v (ds_versao, ie_origem, dt_emissao, cd_ans, nr_seq_protocolo, nr_atendimento, cd_senha, nr_sequencia_autor, dt_validade_senha, cd_autorizacao, dt_validade, dt_autorizacao, nr_interno_conta) AS select	'2.01.01' ds_versao,
	'MED' ie_origem, 
	trunc(c.dt_entrada) dt_emissao, 
	e.cd_ans, 
	a.nr_sequencia nr_seq_protocolo, 
	c.nr_atendimento, 
	null cd_senha, 
	(null)::numeric  nr_sequencia_autor, 
	to_date(null) dt_validade_senha, 
	null cd_autorizacao, 
	to_date(null) dt_validade, 
	to_date(null) dt_autorizacao, 
	(null)::numeric  nr_interno_conta 
FROM 	pessoa_juridica e, 
	convenio d, 
	med_atendimento c, 
	med_faturamento b, 
	med_prot_convenio a 
where	b.nr_seq_protocolo	= a.nr_sequencia 
and	b.nr_atendimento	= c.nr_atendimento 
and	a.cd_convenio		= d.cd_convenio 
and	d.cd_cgc		= e.cd_cgc 

union
 
select	'2.01.01' ds_versao, 
	'AP' ie_origem, 
	trunc(a.dt_entrada) dt_emissao, 
	substr(obter_dados_pf_pj(null, c.cd_cgc,'ANS'),1,30) cd_ans, 
	(null)::numeric  nr_seq_protocolo, 
	a.nr_atendimento, 
	b.cd_senha, 
	(null)::numeric  nr_sequencia_autor, 
	to_date(null) dt_validade_senha, 
	null cd_autorizacao, 
	trunc(b.dt_validade_carteira) dt_validade, 
	trunc(a.dt_entrada) dt_autorizacao, 
	(null)::numeric  nr_interno_conta 
from 	convenio c, 
	atendimento_paciente a, 
	atend_categoria_convenio b 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.nr_seq_interno	= obter_atecaco_atendimento(b.nr_atendimento) 
and	b.cd_convenio		= c.cd_convenio 

union
 
select	'2.01.01' ds_versao, 
	'AC' ie_origem, 
	trunc(a.dt_autorizacao) dt_emissao, 
	substr(obter_dados_pf_pj(null, b.cd_cgc,'ANS'),1,30) cd_ans, 
	(null)::numeric  nr_seq_protocolo, 
	a.nr_atendimento, 
	coalesce(d.cd_senha, a.cd_senha) cd_senha, 
	a.nr_sequencia nr_sequencia_autor, 
	trunc(a.dt_fim_vigencia) dt_validade_senha, 
	a.cd_autorizacao, 
	trunc(d.dt_validade_carteira) dt_validade, 
	trunc(a.dt_autorizacao) dt_autorizacao, 
	(null)::numeric  nr_interno_conta 
from	convenio b, 
	autorizacao_convenio a, 
	atend_categoria_convenio d 
where	a.cd_convenio		= b.cd_convenio 
and	a.nr_atendimento	= d.nr_atendimento 
and	d.nr_seq_interno	= obter_atecaco_atendimento(a.nr_atendimento) 

union
 
select	'2.01.01' ds_versao, 
	'CP' ie_origem, 
	trunc(b.dt_convenio) dt_emissao, 
	substr(obter_dados_pf_pj(null, e.cd_cgc,'ANS'),1,30) cd_ans, 
	a.nr_seq_protocolo, 
	a.nr_atendimento, 
	d.cd_senha, 
	(null)::numeric  nr_sequencia_autor, 
	trunc(d.dt_final_vigencia) dt_validade_senha, 
	a.cd_autorizacao, 
	trunc(d.dt_validade_carteira) dt_validade, 
	b.dt_convenio dt_autorizacao, 
	a.nr_interno_conta 
from	convenio e, 
	conta_paciente_guia b, 
	conta_paciente a, 
	atend_categoria_convenio d 
where	a.nr_interno_conta	= b.nr_interno_conta 
and	d.cd_convenio		= e.cd_convenio 
and	a.nr_atendimento	= d.nr_atendimento 
and	d.nr_seq_interno	= obter_atecaco_atendimento(d.nr_atendimento) 

union
 
select	'2.01.01' ds_versao, 
	'PC' ie_origem, 
	trunc(b.dt_convenio) dt_emissao, 
	substr(obter_dados_pf_pj(null, e.cd_cgc,'ANS'),1,30) cd_ans, 
	g.nr_seq_protocolo, 
	a.nr_atendimento, 
	d.cd_senha, 
	(null)::numeric  nr_sequencia_autor, 
	trunc(d.dt_final_vigencia) dt_validade_senha, 
	a.cd_autorizacao, 
	trunc(d.dt_validade_carteira) dt_validade, 
	b.dt_convenio dt_autorizacao, 
	a.nr_interno_conta 
from	protocolo_convenio g, 
	conta_paciente_guia b, 
	convenio e, 
	atend_categoria_convenio d, 
	conta_paciente a 
where	a.nr_interno_conta	= b.nr_interno_conta 
and	g.nr_seq_protocolo	= a.nr_seq_protocolo 
and	d.cd_convenio		= e.cd_convenio 
and	a.nr_atendimento	= d.nr_atendimento 
and	d.nr_seq_interno	= obter_atecaco_atendimento(d.nr_atendimento);

