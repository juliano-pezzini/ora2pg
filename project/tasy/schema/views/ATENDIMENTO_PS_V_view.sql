-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atendimento_ps_v (nr_atendimento, dt_entrada, dt_alta, dt_alta_interno, cd_pessoa_fisica, nm_pessoa_fisica, nr_prontuario, nm_guerra, cd_medico_resp, cd_estabelecimento, ds_sintoma_paciente, cd_setor_atendimento, cd_unidade_basica, cd_unidade_compl, cd_unidade, ds_setor_atendimento, dt_nascimento, ds_classif_atend, ds_cor_classif_atend, ds_idade, qt_idade, qt_idade_ano_mes, qt_idade_dia, nr_telefone, hr_medicacao, hr_checagem_adep, hr_lib_medico, hr_inicio_consulta, hr_fim_consulta, hr_enfermagem, hr_fim_enfermagem, hr_chamado, hr_liberacao_enfermagem, hr_reavaliacao_medica, dt_chamada_paciente, dt_lib_medico, dt_liberacao_enfermagem, cd_medico_chamado, nm_medico_chamado, min_espera, hr_espera, hr_pa, ds_unidade, ds_anotacao, qt_prescricao, cd_classif_setor, ds_convenio, ds_breve_local, ds_cor_local_pa, ie_clinica, nr_seq_classificacao, ds_clinica, ie_internado, ie_exame_lib, ie_exame_lib_exames, ie_exame_nao_lab_lib, ie_laudo_lib, ie_exame_lib_externo_exames, ds_carater_atendimento, ds_obs_alta, cd_tipo_acomodacao, nr_atend_original, nr_seq_queixa, ds_queixa, ds_observacao_triagem, nr_seq_triagem, ds_triagem, dt_triagem, ie_prioridade, ds_cor, ds_cor_fonte, nr_seq_triagem_prioridade, ds_triagem_prioridade, ie_prioridade_classif, ds_cor_prioridade, ds_senha_qmatic, nr_seq_local_pa, cd_procedencia, cd_motivo_alta, cd_usuario_convenio, cd_convenio, cd_categoria, ds_categoria, cd_religiao, ie_permite_visita, ie_permite_visita_rel, ie_tipo_atendimento, nm_medico, nm_medico_pref, dt_saida_unidade, nr_doc_convenio, dt_inicio_atendimento, dt_atend_medico, dt_fim_consulta, dt_fim_triagem, nr_seq_tipo_acidente, dt_impressao, ds_motivo_transf, ds_obs_alta_trans, nm_hosp_destino, cd_tipo_acomod_conv, ds_necessidade_vaga, ie_status, dt_saida_prev_loc_pa, nr_atend_alta, dt_fim_conta, nm_usuario_alta, ds_tipo_atendimento, nm_medico_aux, cd_medico_aux, dt_saida_real, dt_chamada_enfermagem, ie_proced_atend, ie_paciente_isolado, ie_clinica_ant, dt_previsto_alta, dt_entrada_real, cd_pessoa_responsavel, dt_chamada_reavaliacao, dt_inicio_reavaliacao, ie_tipo_guia, ds_tipo_guia, dt_alta_medico, ie_tipo_convenio, ie_carater_inter_sus, nm_paciente, dt_entrada_unidade, cd_medico_referido, ie_probabilidade_alta, cd_motivo_alta_medica, nm_usuario_saida, dt_fim_reavaliacao, dt_inicio_observacao, dt_fim_observacao, hr_inicio_observacao, hr_fim_observacao, ie_permit_lib_med, ie_chamado, dt_cancelamento, nm_usuario, nr_seq_informacao, ds_informacao, dt_chamada_medic, dt_classif_risco, dt_chegada_medic, nm_usuario_triagem, dt_medicacao, dt_impressao_alta, dt_recebimento_senha, nr_seq_pac_senha_fila, cd_medico_preferencia, nr_seq_agrupamento, ds_nivel_urgencia, ds_senha_gerenciamento, nr_seq_classif_medico, hr_espera_senha, hr_inicio_esp_exame, hr_fim_esp_exame, dt_inicio_esp_exame, dt_fim_esp_exame, dt_inicio_prescr_pa, dt_fim_prescr_pa, dt_alta_tesouraria, ds_parecer, ie_prior_classif_atend, ie_exame_laudo_lib, ds_cor_motivo_alta_pa, ie_sexo, ie_dia_semana, ie_faixa_etaria, nm_pessoa_pesquisa, nr_seq_motivo_perm, nm_usuario_alta_medica, ds_fila, ie_retriagem, ds_cor_queixa, ds_funcao_proficional, ds_registro_conselho, nm_medico_triador, ie_funcao_profissional, dt_alta_medico_setor, ds_prioridade, ds_cor_cons_med, ds_cor_triagem_cons, ds_cor_tempo_triagem, ds_cor_tempo_fim_tri, ds_cor_esp_cons, ds_cor_esp_triagem, ie_medico_ciente, cd_senha_gerada, nr_seq_fila_espera, nr_episodio, nr_seq_interno, ie_passagem_setor) AS SELECT	/* +index(a ATEPACI_I2) */

	a.nr_atendimento,  
	a.dt_entrada,  
	a.dt_alta,  
	a.dt_alta_interno,  
	a.cd_pessoa_fisica,  
	substr(obter_nome_pf(p.cd_pessoa_fisica),1,60) nm_pessoa_fisica, 
	p.nr_prontuario,  
	SUBSTR(obter_nome_medico(cd_medico_resp,'G'),1,60) nm_guerra,  
	a.cd_medico_resp,  
	a.cd_estabelecimento,  
	a.ds_sintoma_paciente,  
	b.cd_setor_atendimento,  
	b.cd_unidade_basica,  
	b.cd_unidade_compl,  
	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl  cd_unidade,  
	s.ds_setor_atendimento,  
	p.dt_nascimento,  
	SUBSTR(OBTER_DESC_CLASSIF_ATEND(NR_SEQ_CLASSIFICACAO),1,90) DS_CLASSIF_ATEND,  
	SUBSTR(OBTER_cor_CLASSIF_ATEND(NR_SEQ_CLASSIFICACAO),1,15) DS_COR_CLASSIF_ATEND,  
	SUBSTR(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'S'),1,15) ds_idade,  
	SUBSTR(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'A'),1,15) qt_idade, 
	SUBSTR(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'AM'),1,15) qt_idade_ano_mes, 	
	TRUNC((SUBSTR(obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'DIA'),1,15))::numeric ) qt_idade_dia,  
	p.nr_telefone_celular nr_telefone,  
	TO_CHAR(a.dt_medicacao,'hh24:mi') hr_medicacao,  
	TO_CHAR(a.DT_CHECAGEM_ADEP,'hh24:mi') hr_checagem_adep,  
	TO_CHAR(a.dt_lib_medico,'hh24:mi') hr_lib_medico,  
	TO_CHAR(a.dt_atend_medico,'hh24:mi') hr_inicio_consulta,  
	TO_CHAR(a.dt_fim_consulta,'hh24:mi') hr_fim_consulta,  
	TO_CHAR(a.dt_inicio_atendimento,'hh24:mi') hr_enfermagem,  
	TO_CHAR(a.dt_fim_triagem,'hh24:mi') hr_fim_enfermagem,  
	TO_CHAR(a.dt_chamada_paciente,'hh24:mi') hr_chamado,  
	TO_CHAR(a.dt_liberacao_enfermagem,'hh24:mi') hr_liberacao_enfermagem,  
	TO_CHAR(a.dt_reavaliacao_medica,'hh24:mi') hr_reavaliacao_medica,  
	a.dt_chamada_paciente,  
	a.dt_lib_medico,  
	a.dt_liberacao_enfermagem,  
	a.cd_medico_chamado,  
	SUBSTR(obter_nome_pf(a.cd_medico_chamado),1,60) nm_medico_chamado,  
	ROUND((coalesce(a.dt_atend_medico, LOCALTIMESTAMP) - a.dt_entrada) * 1440) min_espera,  
	SUBSTR(obter_horas_minutos(ROUND((coalesce(coalesce(a.dt_atend_medico,a.dt_alta), LOCALTIMESTAMP) - a.dt_entrada) * 1440)),1,10) hr_espera,  
	SUBSTR(obter_horas_minutos(ROUND((coalesce(dt_alta, LOCALTIMESTAMP) - coalesce(a.dt_atend_medico,LOCALTIMESTAMP)) * 1440)),1,10) hr_pa,  
	--substr(obter_unidade_atendimento(a.nr_atendimento,'A','U'),1,20) ds_unidade,  

	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl ds_unidade,  
	SUBSTR(obter_anotacao_pendente(a.nr_atendimento),1,255) ds_anotacao,  
	SUBSTR(Obter_qt_prescr_Atend(a.nr_atendimento),1,255) qt_prescricao,  
	s.cd_classif_setor,  
	SUBSTR(Obter_Nome_Convenio(c.cd_convenio),1,50)  ds_convenio,  
	SUBSTR(obter_desc_abrev_local_pa(nr_seq_local_pa),1,255) ds_breve_local,  
	SUBSTR(obter_cor_local_pa(nr_seq_local_pa),1,255) ds_cor_local_pa,  
	a.ie_clinica,  
	a.nr_seq_classificacao,  
	SUBSTR(obter_valor_dominio(17,a.ie_clinica),1,60) ds_clinica,  
	SUBSTR(Obter_se_pa_internado(a.nr_atendimento),1,1) ie_internado,  
	SUBSTR(Obter_se_exame_lib(a.nr_atendimento),1,1) ie_exame_lib,  
	SUBSTR(Obter_se_exame_lib_exames(a.nr_atendimento),1,1) ie_exame_lib_exames,  
	SUBSTR(Obter_se_exame_nao_lib(a.nr_atendimento),1,1) ie_exame_nao_lab_lib,  
	SUBSTR(obter_se_result_atend_lib(a.nr_atendimento),1,1) ie_laudo_lib,  
	SUBSTR(Obter_se_exame_externo_lib(a.nr_atendimento),1,1) ie_exame_lib_externo_exames,  
	SUBSTR(obter_valor_dominio(802, a.IE_CARATER_INTER_SUS),1,100)  ds_carater_atendimento,  
	a.ds_obs_alta,  
	b.cd_tipo_acomodacao,  
	a.nr_atend_original,  
	a.nr_seq_queixa,  
	SUBSTR(Obter_Queixas_Atendimento(a.nr_atendimento,a.nr_seq_queixa),1,255) ds_queixa,  
	substr(obter_inf_triagem_pa(a.nr_atendimento, 'O'),1,255) ds_observacao_triagem,
	a.nr_seq_triagem,  
	SUBSTR(coalesce(coalesce(obter_desc_triagem(a.nr_seq_triagem), obter_triagem_atendimento(a.nr_atendimento)),obter_desc_sem_triagem(a.nr_seq_triagem)),1,60) ds_triagem,  
	obter_data_triagem_atendimento(a.nr_atendimento) dt_triagem,
	obter_prioridade_tcr(a.nr_seq_triagem) ie_prioridade,  
	SUBSTR(obter_cor_tcr(a.nr_seq_triagem),1,15) ds_cor,  
	SUBSTR(obter_cor_tcr(a.nr_seq_triagem,'F'),1,15) ds_cor_fonte,  
	a.nr_seq_triagem_PRIORIDADE,  
	SUBSTR(obter_dados_tcp(a.nr_seq_triagem_prioridade,'DESC'),1,60) ds_triagem_prioridade,  
	(obter_dados_tcp(a.nr_seq_triagem_prioridade,'SEQ'))::numeric  ie_prioridade_classif,  
	SUBSTR(obter_dados_tcp(a.nr_seq_triagem_prioridade,'COR'),1,15) ds_cor_prioridade,  
	a.ds_senha_qmatic,  
	a.nr_seq_local_pa,  
	a.cd_procedencia,  
	a.cd_motivo_alta,  
	SUBSTR(c.cd_usuario_convenio,1,20) cd_usuario_convenio,  
	c.cd_convenio cd_convenio,  
	c.cd_categoria cd_categoria,  
	SUBSTR(obter_categoria_convenio(c.cd_convenio,c.cd_categoria),1,255) ds_categoria,  
	p.cd_religiao,  
	a.ie_permite_visita,  
	a.ie_permite_visita_rel,
	a.ie_tipo_atendimento,  
	SUBSTR(obter_nome_medico(cd_medico_resp,'N'),1,60) nm_medico,  
	SUBSTR(obter_nome_medico(cd_medico_preferencia,'N'),1,60) nm_medico_pref,  
	b.dt_saida_unidade,  
	c.nr_doc_convenio,  
	a.dt_inicio_atendimento,  
	a.dt_atend_medico,  
	a.dt_fim_consulta,  
	a.dt_fim_triagem,  
	a.nr_seq_tipo_acidente,  
	a.dt_impressao,  
	SUBSTR(Obter_dados_alta_transf(a.nr_atendimento,'DM'),1,60) ds_motivo_transf,  
	SUBSTR(Obter_dados_alta_transf(a.nr_atendimento,'O'),1,60) ds_obs_alta_trans,  
	SUBSTR(Obter_dados_alta_transf(a.nr_atendimento,'HD'),1,60) nm_hosp_destino,  
	c.cd_tipo_acomodacao CD_TIPO_ACOMOD_CONV,  
	SUBSTR(Obter_Dados_GV(a.nr_atendimento),1,255) ds_necessidade_vaga,  
	--substr(obter_status_atend_pa(a.nr_atendimento),1,10) ie_status,  

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
	a.ie_chamado,
	a.dt_chamada_enfermagem,
	a.dt_chamada_medic,
	a.dt_chegada_medic),1,10) ie_status,  
	a.dt_saida_prev_loc_pa,  
	a.nr_atend_alta,  
	a.dt_fim_conta,  
	a.nm_usuario_alta,  
	SUBSTR(obter_nome_tipo_atend(a.IE_TIPO_ATENDIMENTO),1,30) ds_tipo_atendimento,  
	SUBSTR(obter_medico_aux_pa(a.nr_atendimento,'N'),1,80) nm_medico_aux,  
	SUBSTR(obter_medico_aux_pa(a.nr_atendimento,'C'),1,80) cd_medico_aux,  
	a.dt_saida_real,  
	a.dt_chamada_enfermagem,  
	obter_se_prescr_proc_atend_pa(a.cd_estabelecimento,a.nr_atendimento) ie_proced_atend,  
	a.IE_PACIENTE_ISOLADO,  
	a.ie_clinica_ant,  
	a.dt_previsto_alta,  
	b.dt_entrada_real,  
	a.cd_pessoa_responsavel,  
	a.dt_chamada_reavaliacao,  
	a.dt_inicio_reavaliacao,  
	c.ie_tipo_guia,  
	SUBSTR(obter_valor_dominio(1031,c.ie_tipo_guia),1,200) ds_tipo_guia,  
	a.dt_alta_medico dt_alta_medico,  
	obter_tipo_convenio(c.cd_convenio) ie_tipo_convenio,  
	a.ie_carater_inter_sus,  
	SUBSTR(OBTER_NOME_SOCIAL_PF(a.cd_pessoa_fisica),1,100) nm_paciente,  
	b.dt_entrada_unidade,  
	a.cd_medico_referido,  
	a.ie_probabilidade_alta,  
	a.cd_motivo_alta_medica,  
	a.nm_usuario_saida,  
	a.dt_fim_reavaliacao,  
	a.dt_inicio_observacao,  
	a.dt_fim_observacao,  
	TO_CHAR(a.dt_inicio_observacao,'hh24:mi') hr_inicio_observacao,  
	TO_CHAR(a.dt_fim_observacao,'hh24:mi') hr_fim_observacao,  
	SUBSTR(Obter_se_atend_permit_lib_pa(a.nr_atendimento,a.cd_estabelecimento),1,10) ie_permit_lib_med,  
	a.ie_chamado,  
	a.dt_cancelamento,  
	a.nm_usuario,  
	a.nr_seq_informacao,  
	a.ds_informacao,  
	a.dt_chamada_medic,  
	a.dt_classif_risco, 
	a.dt_chegada_medic,  
	a.nm_usuario_triagem,  
	a.dt_medicacao,  
	a.dt_impressao_alta,  
	a.dt_recebimento_senha,  
	a.nr_seq_pac_senha_fila,  
	a.cd_medico_preferencia,  
	s.nr_seq_agrupamento,  
	SUBSTR(coalesce(obter_nivel_urgencia(a.nr_atendimento),obter_desc_expressao(309956)),1,100) ds_nivel_urgencia,
	SUBSTR(obter_letra_verifacao_senha(obter_fila_senha(a.nr_seq_pac_senha_fila)) || obter_dados_senha(a.nr_seq_pac_senha_fila, 'CD'),1,20) ds_senha_gerenciamento,  
	a.nr_seq_classif_medico,  
	SUBSTR(obter_horas_minutos(ROUND((coalesce(a.dt_fim_consulta, LOCALTIMESTAMP) - TO_DATE(obter_dados_senha(a.nr_seq_pac_senha_fila,'DG'),'dd/mm/yyyy hh24:mi:ss')) * 1440)),1,10) hr_espera_senha,  
	TO_CHAR(a.dt_inicio_esp_exame,'hh24:mi') hr_inicio_esp_exame,  
	TO_CHAR(a.dt_fim_esp_exame,'hh24:mi') hr_fim_esp_exame,  
	a.dt_inicio_esp_exame,  
	a.dt_fim_esp_exame,  
	a.dt_inicio_prescr_pa,  
	a.dt_fim_prescr_pa,  
	a.dt_alta_tesouraria,  
	SUBSTR(obter_se_atend_parecer(a.nr_atendimento),1,100) ds_parecer,  
	obter_prioridade_classif_atend(a.nr_seq_classificacao) ie_prior_classif_atend,  
	SUBSTR(Obter_se_exame_laudo_lib(a.nr_atendimento),1,1) ie_exame_laudo_lib,  
	obter_cor_motivo_alta_pa(a.cd_motivo_alta) ds_cor_motivo_alta_pa,  
	p.ie_sexo,  
	(TO_CHAR(dt_entrada, 'd'))::numeric  ie_dia_semana,  
	SUBSTR( obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'e'), 1, 10 ) ie_faixa_etaria,  
	p.nm_pessoa_pesquisa,
	b.nr_seq_motivo_perm,
	a.nm_usuario_alta_medica,
	substr(coalesce(obter_dados_fila_triagem(a.nr_atendimento,'DS'),obter_dados_senha(a.nr_seq_pac_senha_fila,'DS')),1,255) ds_fila,
	substr(manchester_obter_ie_retriagem(a.nr_atendimento),1,10) ie_retriagem,
	substr(obter_cor_queixa_paciente(a.nr_atendimento, a.nr_seq_queixa),1,50) ds_cor_queixa,
	substr(obter_triagem_atendimento(a.nr_atendimento ,'F'),1,150) ds_funcao_proficional, 
	substr(obter_triagem_atendimento(a.nr_atendimento ,'R'),1,150) ds_registro_conselho, 
	substr(obter_triagem_atendimento(a.nr_atendimento ,'M'),1,150) nm_medico_triador,
	substr(obter_triagem_atendimento(a.nr_atendimento ,'FAB'),1,150) ie_funcao_profissional,
	b.dt_alta_medico_setor,
	substr(obter_triagem_atendimento(a.nr_atendimento ,'P'),1,150) ds_prioridade,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.DT_ATEND_MEDICO,'C',a.DT_FIM_CONSULTA,'TMC'),1,50) DS_COR_CONS_MED,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.DT_FIM_TRIAGEM,'C',a.DT_ATEND_MEDICO,'TTC'),1,50) DS_COR_TRIAGEM_CONS,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.DT_INICIO_ATENDIMENTO,'C',a.DT_FIM_TRIAGEM,'TMT'),1,50) DS_COR_TEMPO_TRIAGEM,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.dt_fim_triagem,'C',a.dt_alta,'TDE'),1,50) ds_cor_tempo_fim_tri,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.DT_ENTRADA,'C',a.DT_ATEND_MEDICO,'TIC'),1,50) DS_COR_ESP_CONS,
	substr(obter_tempo_regra_espera_pa(a.ie_clinica,a.nr_seq_triagem,a.dt_entrada,'C',a.DT_INICIO_ATENDIMENTO,'ETT'),1,50) DS_COR_ESP_TRIAGEM,
	substr(obter_medico_ciente(a.nr_atendimento),1,1) ie_medico_ciente,
	substr(obter_dados_senha(a.nr_seq_pac_senha_fila,'CD'),1,100) CD_SENHA_GERADA,
	substr(obter_dados_senha(a.nr_seq_pac_senha_fila,'SF'),1,100) NR_SEQ_FILA_ESPERA,
	substr(OBTER_EPISODIO_ATEND_TELA(a.nr_atendimento),1,80) nr_episodio,
	b.nr_seq_interno,
	b.ie_passagem_setor
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
AND	EXISTS (SELECT 1  
		FROM	setor_atendimento x,  
			atend_paciente_unidade y  
		WHERE	a.nr_atendimento = y.nr_atendimento  
		AND	y.cd_setor_atendimento	= x.cd_setor_atendimento  
		AND	x.cd_classif_setor	= '1');

