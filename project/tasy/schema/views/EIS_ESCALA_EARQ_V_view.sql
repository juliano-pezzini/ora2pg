-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_escala_earq_v (cd_setor_atendimento, ds_estabelecimento, cd_convenio, ds_convenio, ds_setor_atendimento, ie_sexo, ds_sexo, nm_medico, cd_pessoa_fisica, cd_medico_resp, ie_faixa_etaria, ds_unidade, dt_avaliacao, qt_ponto, cd_empresa, cd_estabelecimento, ds_gradacao, nr_atendimento, cd_paciente, ds_pac_unid) AS SELECT	DISTINCT
	--obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao) cd_setor_atendimento, 
	eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao) cd_setor_atendimento, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio, 
	SUBSTR(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,150) ds_convenio, 
	--obter_nome_setor(obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao) ) ds_setor_atendimento, 
	obter_nome_setor(eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao)) ds_setor_atendimento, 
	obter_sexo_pf(a.cd_pessoa_fisica,'C') ie_sexo, 
	obter_sexo_pf(a.cd_pessoa_fisica,'D') ds_sexo, 
	--obter_nome_pessoa_fisica(a.cd_pessoa_fisica, NULL) nm_medico, 
	obter_nome_pessoa_fisica(e.CD_PROFISSIONAL, NULL) nm_medico, 
	a.cd_pessoa_fisica, 
	CD_PROFISSIONAL cd_medico_resp, 
	SUBSTR(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),LOCALTIMESTAMP,'E'),1,10) ie_faixa_etaria, 
	SUBSTR(obter_unidade_atend_data(a.nr_atendimento, e.dt_avaliacao),1,255) ds_unidade, 
	e.dt_avaliacao, 
	e.QT_PONTUACAO qt_ponto, 
	f.cd_empresa, 
	a.cd_estabelecimento, 
	substr(obter_descr_escala_earq(QT_PONTUACAO),1,255) ds_gradacao, 
	a.nr_atendimento, 
	a.cd_pessoa_fisica cd_paciente, 
	obter_nome_pf(a.cd_pessoa_fisica) || ' ' || obter_unidade_atendimento(a.nr_atendimento,'A','U') ds_pac_unid 
FROM 	ESCALA_EARQ e, 
	estabelecimento f, 
	atendimento_paciente a 
WHERE 	a.nr_atendimento= e.nr_atendimento 
AND	a.cd_estabelecimento = f.cd_estabelecimento 
AND	e.dt_liberacao IS NOT NULL;

