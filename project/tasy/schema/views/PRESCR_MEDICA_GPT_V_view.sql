-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW prescr_medica_gpt_v (nm_paciente, ie_reconciliacao, ds_unidade, ds_unidade_basica, ds_unidade_comp, dt_alta, dt_atendimento, dt_alta_medico, ie_forma_reconciliacao, nr_prontuario, qt_peso, qt_altura, nr_atendimento, cd_pessoa_fisica, ie_prescr_emergencia, dt_inicio_analise_farm, dt_liberacao_farmacia, cd_classif_setor, cd_setor_atendimento, dt_inicio_prescr, dt_validade_prescr, nr_prescricao, dt_prescricao, ds_setor_atendimento, cd_prescritor) AS select	obter_nome_pf(a.cd_pessoa_fisica) nm_paciente,
	substr(obter_se_atend_reconciliacao(a.nr_atendimento),1,1) ie_reconciliacao, 
	substr(Obter_Unidade_Atendimento(nr_atendimento,'A','U'),1,100) ds_unidade, 
	substr(Obter_Unidade_Atendimento(a.nr_atendimento, 'A', 'UB'),1,40) ds_unidade_basica, 
	substr(Obter_Unidade_Atendimento(a.nr_atendimento, 'A', 'UC'),1,40) ds_unidade_comp, 
	Obter_Dados_Atendimento_dt(a.nr_atendimento,'DA') dt_alta, 
	Obter_Dados_Atendimento_dt(a.nr_atendimento,'DE') dt_atendimento, 
	Obter_Dados_Atendimento_dt(a.nr_atendimento,'DAM') dt_alta_medico, 
	substr(obter_reconciliacao_atend(a.nr_atendimento),1,1) ie_forma_reconciliacao, 
	OBTER_PRONTUARIO_PACIENTE(a.cd_pessoa_fisica) nr_prontuario, 
	obter_dados_sv_atendimento('V','QT_PESO',a.nr_atendimento) qt_peso, 
	obter_dados_sv_atendimento('V','QT_ALTURA_CM',a.nr_atendimento) qt_altura, 
	a.nr_atendimento, 
	a.cd_pessoa_fisica, 
	a.ie_prescr_emergencia, 
	a.dt_inicio_analise_farm, 
	a.dt_liberacao_farmacia, 
	substr(Obter_Unidade_Atendimento(nr_atendimento,'A','CL'),1,100) cd_classif_setor, 
	a.cd_setor_atendimento, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.nr_prescricao, 
	a.dt_prescricao, 
	substr(Obter_Unidade_Atendimento(nr_atendimento,'A','S'),1,255) ds_setor_atendimento, 
	a.cd_prescritor 
FROM	prescr_medica a 
where	coalesce(a.dt_liberacao_medico,a.dt_liberacao) is not null 
and	a.dt_suspensao is null;
