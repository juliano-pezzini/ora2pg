-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ocupacao_medico_v2 (cd_estabelecimento, dt_referencia, cd_medico, nm_medico, ie_periodo, nr_unidades_setor, qt_disponiveis, nr_leitos_ocupados, nr_leitos_livres, nr_admissoes, nr_altas, nr_obitos, nr_transf_entrada, nr_transf_saida, nr_dias_periodo, cd_setor_atendimento, ie_clinica, ie_tipo_atendimento, ie_clinica_alta, nr_seq_origem, ie_sexo, cd_cid_principal, ie_tipo_convenio, cd_especialidade, qt_hora_alta, cd_procedencia, cd_tipo_acomodacao, hr_alta, cd_unidade_compl, cd_unidade_basica) AS select	a.cd_estabelecimento,
	a.dt_referencia, 
	a.CD_MEDICO, 
	obter_nome_medico(a.cd_medico, 'N') nm_medico, 
	a.ie_periodo, 
	count(*) nr_unidades_setor, 
	sum(CASE WHEN obter_se_leito_disp(a.cd_setor_atendimento, a.cd_unidade_basica, a.cd_unidade_compl)='S' THEN 1  ELSE 0 END ) qt_disponiveis, 
	sum(CASE WHEN a.ie_situacao='P' THEN nr_pacientes  ELSE 0 END ) nr_leitos_ocupados, 
	sum(coalesce(qt_leito_livre,0)) nr_leitos_livres, 
	sum(nr_admissoes) nr_admissoes, 
	sum(nr_altas) nr_altas, 
	sum(nr_obitos) nr_obitos, 
	sum(nr_transf_entrada) nr_transf_entrada, 
	sum(nr_transf_saida) nr_transf_saida, 
	avg(CASE WHEN a.ie_periodo='M' THEN (to_char(last_day(a.dt_referencia),'DD'))::numeric   ELSE 1 END ) nr_dias_periodo, 
	a.cd_setor_atendimento, 
	a.ie_clinica, 
	a.ie_tipo_atendimento, 
	a.ie_clinica_alta, 
	a.nr_seq_origem, 
	b.ie_sexo, 
	a.cd_cid_principal, 
	obter_tipo_convenio(a.cd_convenio) ie_tipo_convenio, 
	obter_especialidade_medico(a.cd_medico,'C') cd_especialidade, 
	to_char(a.hr_alta,'00') qt_hora_alta, 
	a.cd_procedencia, 
	a.cd_tipo_acomodacao, 
	a.hr_alta, 
	a.cd_unidade_compl, 
	a.cd_unidade_basica 
FROM eis_ocupacao_hospitalar a
LEFT OUTER JOIN pessoa_fisica b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica) group BY	 
	a.cd_estabelecimento, 
	a.dt_referencia, 
	a.cd_medico, 
	obter_nome_medico(a.cd_medico,'N'), 
	a.ie_periodo, 
	a.cd_setor_atendimento, 
	a.ie_clinica, 
	a.ie_tipo_atendimento, 
	a.ie_clinica_alta, 
	a.nr_seq_origem, 
	b.ie_sexo, 
	a.cd_cid_principal, 
	obter_tipo_convenio(a.cd_convenio), 
	obter_especialidade_medico(a.cd_medico,'C'), 
	to_char(a.hr_alta,'00'), 
	a.cd_procedencia, 
	a.cd_tipo_acomodacao, 
	a.hr_alta, 
	a.cd_unidade_compl, 
	a.cd_unidade_basica;
