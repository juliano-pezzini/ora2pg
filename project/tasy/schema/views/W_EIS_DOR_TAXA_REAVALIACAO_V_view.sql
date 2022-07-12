-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_dor_taxa_reavaliacao_v (cd_setor, ds_setor_atendimento, ds_unidade, ie_sexo, ds_sexo, ie_faixa_etaria, dt_sinal_vital, qt_avaliacao, qt_avaliacao_dor, qt_avaliacao_sem_dor, qt_max_intensidade, nr_atendimento, cd_pessoa_fisica, qt_paciente_dor, nr_seq_result_dor, qt_reavaliacao_com_dor, ds_result_dor, nr_turno, ds_turno) AS select	distinct	
	e.cd_setor_atendimento cd_Setor, 
	obter_nome_setor(e.cd_setor_atendimento) ds_setor_atendimento, 
	obter_unidade_atendimento(e.nr_atendimento,'A','U') ds_unidade, 
	obter_sexo_pf(e.cd_pessoa_fisica,'C') ie_sexo, 
	coalesce(obter_sexo_pf(e.cd_pessoa_fisica,'D'),'Não informado') ds_sexo,	 
	substr(obter_idade(obter_data_nascto_pf(e.cd_pessoa_fisica),LOCALTIMESTAMP,'E'),1,10) ie_faixa_etaria,	 
	e.dt_sinal_vital,			 
	e.qt_avaliacao, 
	e.qt_avaliacao_dor, 
	e.qt_avaliacao_sem_dor,	 
	e.qt_max_intensidade,	 
	e.nr_atendimento, 
	e.cd_pessoa_fisica, 
	e.qt_paciente_dor, 
	e.nr_seq_result_dor, 
	e.qt_reavaliacao_com_dor,	 
	substr(obter_desc_result_dor(e.nr_seq_result_dor,'D'),1,150) ds_result_dor, 
	e.nr_seq_turno_atend nr_turno, 
	substr(obter_desc_result_dor(e.nr_seq_turno_atend,'T'),1,150) ds_turno 
FROM 	w_eis_escala_dor e 
where 	e.qt_avaliacao <> 0	;

