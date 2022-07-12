-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_guia_solic_internacao_v (ds_tipo_transacao, nr_lote, ie_tipo_dado, nr_atendimento, nr_seq_autorizacao, cd_ans, cd_autorizacao, dt_autorizacao, cd_usuario_convenio, nm_pessoa_fisica, ds_plano, dt_validade_carteira, nm_titular, nr_cartao_nac_sus, cd_cpf_solicitante, nm_pessoa_solicitante, cd_cnes, nr_crm, sg_conselho, cd_cbo_sus, ds_tipo_logradouro, ds_endereco, nr_endereco, ds_complemento, ds_municipio, sg_estado, cd_municipio_ibge, cd_cep, cd_cgc_prestador, ds_razao_social_prestador, ie_carater_inter_sus, ie_tipo_internacao, ds_indicacao, cd_cid10, ie_tipo_doenca, qt_tempo_doenca, cd_cid10_2, cd_cid10_3, cd_cid10_4, ds_diagnostico, ds_diagnostico_2, cd_edicao, cd_procedimento, ds_procedimento, qt_procedimento, cd_tabela_opm, cd_opm, ds_opm, ds_fabricante_opm, qt_opm) AS select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao,
	1 nr_lote, 
	-- dados beneficiário 
	1 ie_tipo_dado, 
	d.nr_atendimento, 
	d.nr_seq_autorizacao, 
	substr(Obter_Valor_Conv_Estab(v.cd_convenio, f.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_ans, 
	d.cd_autorizacao, 
	d.dt_autorizacao, 
	b.cd_usuario_convenio, 
	e.nm_pessoa_fisica, 
	c.ds_plano, 
	b.dt_validade_carteira, 
	e.nm_pessoa_fisica nm_titular, 
	e.nr_cartao_nac_sus, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	f.cd_cgc cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	CASE WHEN a.ie_carater_inter_sus=1 THEN  'E'  ELSE 'U' END  ie_carater_inter_sus, 
	a.ie_clinica ie_tipo_internacao, 
	d.ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
FROM convenio v, estabelecimento f, pessoa_fisica e, autorizacao_convenio d, atendimento_paciente a, atend_categoria_convenio b
LEFT OUTER JOIN convenio_plano c ON (b.cd_plano_convenio = c.cd_plano AND b.cd_convenio = c.cd_convenio)
WHERE a.nr_atendimento	= b.nr_atendimento   and a.nr_atendimento	= d.nr_atendimento and a.cd_pessoa_fisica	= e.cd_pessoa_fisica and a.cd_estabelecimento	= f.cd_estabelecimento and b.cd_convenio		= v.cd_convenio 
 
union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- dados solicitante 
	2 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	e.nr_cpf cd_cpf_solicitante, 
	e.nm_pessoa_fisica nm_pessoa_solicitante, 
	g.cd_cnes, 
	f.nr_crm, 
	h.sg_conselho, 
	e.cd_cbo_sus, 
	'' ds_tipo_logradouro, 
	d.ds_endereco, 
	d.nr_endereco, 
	d.ds_complemento, 
	d.ds_municipio, 
	d.sg_estado, 
	'' cd_municipio_ibge, 
	d.cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	null ie_carater_inter_sus, 
	null ie_tipo_internacao, 
	null ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
FROM sus_parametros g, medico f, pessoa_juridica d, estabelecimento c, atendimento_paciente b, autorizacao_convenio a, pessoa_fisica e
LEFT OUTER JOIN conselho_profissional h ON (e.nr_seq_conselho = h.nr_sequencia)
WHERE a.nr_atendimento	= b.nr_atendimento and b.cd_estabelecimento	= c.cd_estabelecimento and c.cd_cgc		= d.cd_cgc and e.cd_pessoa_fisica	= a.cd_medico_solicitante and e.cd_pessoa_fisica	= f.cd_pessoa_fisica and b.cd_estabelecimento	= g.cd_estabelecimento  
union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- dados prestador solicitado 
	3 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	null ie_carater_inter_sus, 
	null ie_tipo_internacao, 
	null ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
from	pessoa_juridica d, 
	estabelecimento c, 
	atendimento_paciente b, 
	autorizacao_convenio a 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.cd_estabelecimento	= c.cd_estabelecimento 
and	c.cd_cgc		= d.cd_cgc 

union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- dados internação 
	4 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	b.ie_carater_inter_sus, 
	b.ie_clinica ie_tipo_internacao, 
	a.ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
from	atendimento_paciente b, 
	autorizacao_convenio a 
where	a.nr_atendimento	= b.nr_atendimento 

union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- hipóteses diagnósticas 
	5 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	null ie_carater_inter_sus, 
	null ie_tipo_internacao, 
	null ds_indicacao, 
	d.cd_doenca cd_cid10, 
	'' ie_tipo_doenca, 
	'' qt_tempo_doenca, 
	e.cd_doenca cd_cid10_2, 
	'' cd_cid10_3, 
	'' cd_cid10_4, 
	d.ds_diagnostico, 
	e.ds_diagnostico ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
FROM diagnostico_doenca d, atendimento_paciente b, autorizacao_convenio a, diagnostico_medico c
LEFT OUTER JOIN diagnostico_doenca e ON (c.nr_atendimento = e.nr_atendimento AND c.dt_diagnostico = e.dt_diagnostico)
WHERE a.nr_atendimento	= b.nr_atendimento and b.nr_atendimento	= c.nr_atendimento and c.nr_atendimento	= d.nr_atendimento and c.dt_diagnostico	= d.dt_diagnostico   and d.ie_classificacao_doenca		= 'P' and coalesce(e.ie_classificacao_doenca,'S')	= 'S' 
 
union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- procedimentos solicitados 
	6 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	null ie_carater_inter_sus, 
	null ie_tipo_internacao, 
	null ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	substr(OBTER_EDICAO_AMB(b.cd_estabelecimento, a.cd_convenio, e.cd_categoria, a.dt_autorizacao),1,20) cd_edicao, 
	d.cd_procedimento, 
	f.ds_procedimento, 
	d.qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
from	procedimento f, 
	prescr_procedimento d, 
	prescr_medica c, 
	atend_categoria_convenio e, 
	atendimento_paciente b, 
	autorizacao_convenio a 
where	a.nr_atendimento	= b.nr_atendimento 
and	b.cd_estabelecimento	= c.cd_estabelecimento 
and	b.nr_atendimento	= c.nr_atendimento 
and	c.nr_prescricao		= d.nr_prescricao 
and	e.nr_seq_interno	= OBTER_ATECACO_ATENDIMENTO(b.nr_atendimento) 
and	d.cd_procedimento	= f.cd_procedimento 
and	d.ie_origem_proced	= f.ie_origem_proced 

union all
 
select	'ENVIO_LOTE_GUIAS' ds_tipo_transacao, 
	1 nr_lote, 
	-- OPM solicitadas 
	7 ie_tipo_dado, 
	a.nr_atendimento, 
	a.nr_seq_autorizacao, 
	null cd_ans, 
	null cd_autorizacao, 
	null dt_autorizacao, 
	null cd_usuario_convenio, 
	null nm_pessoa_fisica, 
	null ds_plano, 
	null dt_validade_carteira, 
	null nm_titular, 
	null, 
	null cd_cpf_solicitante, 
	null nm_pessoa_solicitante, 
	null cd_cnes, 
	null nr_crm, 
	null sg_conselho, 
	null cd_cbo_sus, 
	null ds_tipo_logradouro, 
	null ds_endereco, 
	null nr_endereco, 
	null ds_complemento, 
	null ds_municipio, 
	null sg_estado, 
	null cd_municipio_ibge, 
	null cd_cep, 
	null cd_cgc_prestador, 
	null ds_razao_social_prestador, 
	null ie_carater_inter_sus, 
	null ie_tipo_internacao, 
	null ds_indicacao, 
	null cd_cid10, 
	null ie_tipo_doenca, 
	null qt_tempo_doenca, 
	null cd_cid10_2, 
	null cd_cid10_3, 
	null cd_cid10_4, 
	null ds_diagnostico, 
	null ds_diagnostico_2, 
	null cd_edicao, 
	null cd_procedimento, 
	null ds_procedimento, 
	null qt_procedimento, 
	null cd_tabela_opm, 
	null cd_opm, 
	null ds_opm, 
	null ds_fabricante_opm, 
	null qt_opm 
from	atendimento_paciente b, 
	autorizacao_convenio a 
where	a.nr_atendimento	= b.nr_atendimento;

