-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atendimento_pa_js_v (cd_categoria, cd_convenio, cd_estabelecimento, cd_medico_referido, cd_medico_resp, cd_medico_chamado, cd_medico_preferencia, cd_pessoa_fisica, cd_pessoa_responsavel, cd_setor_atendimento, ds_informacao, ds_senha_qmatic, ds_setor_atendimento, ds_sintoma_paciente, ds_unidade, dt_alta, dt_alta_interno, dt_chamada_enfermagem, dt_chamada_paciente, dt_chamada_reavaliacao, dt_chegada_medic, dt_chamada_medic, dt_entrada, dt_fim_consulta, dt_fim_observacao, dt_fim_triagem, dt_impressao, dt_inicio_atendimento, dt_inicio_observacao, dt_inicio_reavaliacao, dt_fim_reavaliacao, dt_recebimento_senha, ie_chamado, dt_cancelamento, ie_clinica, ie_clinica_ant, ie_carater_inter_sus, ie_tipo_atendimento, ie_tipo_guia, nm_pessoa_fisica, nr_atendimento, nr_atend_alta, nr_atend_original, nr_seq_informacao, nr_seq_local_pa, nr_prontuario, nr_seq_classificacao, nr_seq_pac_senha_fila, nr_seq_queixa, nr_seq_triagem, nr_seq_triagem_prioridade, dt_medicacao, nm_pessoa_pesquisa, nm_usuario, dt_lib_medico, dt_liberacao_enfermagem, ie_prioridade, ie_prioridade_classif, ie_status, hr_chamado, hr_checagem_adep, hr_enfermagem, dt_atend_medico, hr_fim_consulta, hr_fim_enfermagem, hr_fim_esp_exame, hr_inicio_consulta, hr_inicio_esp_exame, hr_liberacao_enfermagem, hr_lib_medico, hr_medicacao, hr_reavaliacao_medica, cd_medico_aux, ds_convenio, ds_cor, ds_cor_fonte, ds_cor_queixa, ds_cor_local_pa, ds_idade, ie_exame_lib, ie_exame_lib_exames, ie_proced_atend, ie_internado, qt_idade, ds_fila, ie_permit_lib_med, dt_inicio_prescr_pa, dt_fim_prescr_pa, dt_inicio_esp_exame, dt_fim_esp_exame, dt_nascimento, ds_categoria, hr_espera_senha, ds_cor_classif_atend, ds_cor_motivo_alta_pa) AS SELECT	/* +index(a ATEPACI_I2) */
	c.cd_categoria, 
	c.cd_convenio, 
	a.cd_estabelecimento, 
	a.cd_medico_referido, 
	a.cd_medico_resp, 
	a.cd_medico_chamado, 
	a.cd_medico_preferencia, 
	a.cd_pessoa_fisica, 
	a.cd_pessoa_responsavel, 
	s.cd_setor_atendimento, 
	a.ds_informacao, 
	a.ds_senha_qmatic, 
	s.ds_setor_atendimento, 
	a.ds_sintoma_paciente, 
	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl ds_unidade, 
	a.dt_alta, 
	a.dt_alta_interno, 
	a.dt_chamada_enfermagem, 
	a.dt_chamada_paciente, 
	a.dt_chamada_reavaliacao, a.dt_chegada_medic, 
	a.dt_chamada_medic, 
	a.dt_entrada, 
	a.dt_fim_consulta, 
	a.dt_fim_observacao, 
	a.dt_fim_triagem, 
	a.dt_impressao, 
	a.dt_inicio_atendimento, 
	a.dt_inicio_observacao, 
	a.dt_inicio_reavaliacao, 
	a.dt_fim_reavaliacao, 
	a.dt_recebimento_senha, 
	a.ie_chamado, 
	a.dt_cancelamento, 
	a.ie_clinica, 
	a.ie_clinica_ant, 
	a.ie_carater_inter_sus, 
	a.ie_tipo_atendimento, 
	c.ie_tipo_guia, 
	p.nm_pessoa_fisica, 
	a.nr_atendimento, 
	a.nr_atend_alta, 
	a.nr_atend_original, 
	a.nr_seq_informacao, 
	a.nr_seq_local_pa, 
	p.nr_prontuario, 
	a.nr_seq_classificacao, 
	a.nr_seq_pac_senha_fila, 
	a.nr_seq_queixa, 
	a.nr_seq_triagem, 
	a.nr_seq_triagem_prioridade, 
	a.dt_medicacao, 
	p.nm_pessoa_pesquisa, 
	a.nm_usuario, 
	a.dt_lib_medico, 
	a.dt_liberacao_enfermagem, 
	obter_prioridade_tcr(a.nr_seq_triagem) ie_prioridade, 
	(obter_dados_tcp(a.nr_seq_triagem_prioridade,'SEQ'))::numeric  ie_prioridade_classif, 
	SUBSTR(obter_status_atend_pa_nova(	a.nr_Atendimento,a.dt_alta,  
	a.dt_medicacao,  
	a.dt_lib_medico,  
	a.dt_atend_medico,  
	a.dt_fim_consulta,  
	a.dt_inicio_atendimento	,  
	a.dt_fim_triagem,  
	a.dt_chamada_paciente,  
	a.dt_liberacao_enfermagem,  
	a.dt_reavaliacao_medica,  
	a.nr_atend_alta,  
	a.cd_estabelecimento,  
	a.dt_fim_reavaliacao,  
	a.dt_inicio_observacao,  
	a.dt_fim_observacao, 
	a.dt_chamada_reavaliacao, 
	a.dt_inicio_reavaliacao, 
	a.ie_chamado),1,10) ie_status,  
	TO_CHAR(a.dt_chamada_paciente,'hh24:mi') hr_chamado, 
	TO_CHAR(a.DT_CHECAGEM_ADEP,'hh24:mi') hr_checagem_adep, 
	TO_CHAR(a.dt_inicio_atendimento,'hh24:mi') hr_enfermagem, 
	a.dt_atend_medico, 
	TO_CHAR(a.dt_fim_consulta,'hh24:mi') hr_fim_consulta, 
	TO_CHAR(a.dt_fim_triagem,'hh24:mi') hr_fim_enfermagem, 
	TO_CHAR(a.dt_fim_esp_exame,'hh24:mi') hr_fim_esp_exame, 
	TO_CHAR(a.dt_atend_medico,'hh24:mi') hr_inicio_consulta, 
	TO_CHAR(a.dt_inicio_esp_exame,'hh24:mi') hr_inicio_esp_exame, 
	TO_CHAR(a.dt_liberacao_enfermagem,'hh24:mi') hr_liberacao_enfermagem, 
	TO_CHAR(a.dt_lib_medico,'hh24:mi') hr_lib_medico, 
	TO_CHAR(a.dt_medicacao,'hh24:mi') hr_medicacao, 
	TO_CHAR(a.dt_reavaliacao_medica,'hh24:mi') hr_reavaliacao_medica, 
	substr(obter_medico_aux_pa(a.nr_atendimento,'C'),1,80) cd_medico_aux, 
	substr(obter_nome_convenio(c.cd_convenio),1,50) ds_convenio, 
	substr(obter_cor_tcr(a.nr_seq_triagem),1,15) ds_cor, 
	substr(obter_cor_tcr(a.nr_seq_triagem,'F'),1,15) ds_cor_fonte, 
	substr(obter_cor_queixa_paciente(a.nr_atendimento, a.nr_seq_queixa),1,50) ds_cor_queixa, 
	substr(obter_cor_local_pa(a.nr_seq_local_pa),1,255) ds_cor_local_pa, 
	substr(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'S'),1,15) ds_idade, 
	substr(obter_se_exame_lib(a.nr_atendimento),1,1) ie_exame_lib, 
	substr(obter_se_exame_lib_exames(a.nr_atendimento),1,1) ie_exame_lib_exames, 
	obter_se_prescr_proc_atend_pa(a.cd_estabelecimento,a.nr_atendimento) ie_proced_atend, 
	substr(obter_se_pa_internado(a.nr_atendimento),1,1) ie_internado, 
	substr(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'A'),1,15) qt_idade, 
	substr(coalesce(obter_dados_fila_triagem(a.nr_atendimento,'DS'),obter_dados_senha(a.nr_seq_pac_senha_fila,'DS')),1,255) ds_fila, 
	SUBSTR(Obter_se_atend_permit_lib_pa(a.nr_atendimento,a.cd_estabelecimento),1,10) ie_permit_lib_med, 
	a.dt_inicio_prescr_pa, 
	a.dt_fim_prescr_pa, 
    a.dt_inicio_esp_exame, 	 
	a.dt_fim_esp_exame, 
	p.dt_nascimento, 
	SUBSTR(obter_categoria_convenio(c.cd_convenio,c.cd_categoria),1,255) ds_categoria,  
	SUBSTR(obter_horas_minutos(ROUND((coalesce(a.dt_fim_consulta, LOCALTIMESTAMP) - TO_DATE(obter_dados_senha(a.nr_seq_pac_senha_fila,'DG'),'dd/mm/yyyy hh24:mi:ss')) * 1440)),1,10) hr_espera_senha, 
	substr(obter_cor_classif_atend(a.nr_seq_classificacao),1,15) ds_cor_classif_atend, 
	obter_cor_motivo_alta_pa(a.cd_motivo_alta) ds_cor_motivo_alta_pa 
FROM	setor_atendimento s,  
	pessoa_fisica p,  
	atend_categoria_convenio c,  
	atend_paciente_unidade b,  
	atendimento_paciente a  
WHERE	a.nr_atendimento 	= b.nr_atendimento  
AND	b.nr_seq_interno 	= obter_atepacu_paciente(a.nr_atendimento, 'A')  
AND	a.nr_Atendimento 	= c.nr_atendimento  
AND	c.nr_seq_interno	= obter_atecaco_atendimento(a.nr_atendimento)  
AND	b.cd_setor_atendimento		= s.cd_setor_atendimento  
AND	a.cd_pessoa_fisica		= p.cd_pessoa_fisica  
AND	a.nr_atendimento	> 0 
AND	EXISTS (SELECT 1  
		FROM	setor_atendimento x,  
			atend_paciente_unidade y  
		WHERE	a.nr_atendimento = y.nr_atendimento  
		AND	y.cd_setor_atendimento	= x.cd_setor_atendimento  
		AND	x.cd_classif_setor	= '1');

