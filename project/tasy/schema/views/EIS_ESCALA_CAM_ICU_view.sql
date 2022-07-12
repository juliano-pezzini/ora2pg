-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_escala_cam_icu (cd_setor_atendimento, ds_estabelecimento, cd_convenio, ds_convenio, ds_setor_atendimento, ie_sexo, ds_sexo, nm_medico, cd_profissional, cd_medico_resp, ie_faixa_etaria, ds_unidade, dt_avaliacao, cd_empresa, ds_gradacao, cd_estabelecimento, nr_atendimento, cd_paciente) AS SELECT
	eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao) cd_setor_atendimento, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio, 
	SUBSTR(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,150) ds_convenio, 
	obter_nome_setor(eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao) ) ds_setor_atendimento, 
	obter_sexo_pf(a.cd_pessoa_fisica,'C') ie_sexo, 
	obter_sexo_pf(a.cd_pessoa_fisica,'D') ds_sexo, 
	obter_nome_pessoa_fisica(e.CD_PROFISSIONAL, NULL) nm_medico, 
	e.CD_PROFISSIONAL, 
	a.cd_medico_resp, 
	SUBSTR(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),LOCALTIMESTAMP,'E'),1,10) ie_faixa_etaria, 
	SUBSTR(obter_unidade_atend_data(a.nr_atendimento, e.dt_avaliacao),1,255) ds_unidade, 
	TRUNC(e.dt_avaliacao) dt_avaliacao, 
	f.cd_empresa, 
	--SUBSTR(obter_result_CAM_ICU(ie_alt_estado_mental,ie_comport_anormal,ie_focar_atencao,ie_distraido,ie_desorganizado,ie_consiencia),1,255)ds_gradacao, 
	substr(obter_result_CAM_ICU(ie_alt_estado_mental,ie_comport_anormal,ie_focar_atencao,ie_distraido,null,null,'S',ie_pedra_flutuam,ie_peixe_mar,ie_quilograma,ie_martelo_madeira,ie_agitado,ie_letagico,ie_estuporoso,ie_camatoso),1,255) ds_gradacao, 
	a.cd_estabelecimento, 
	a.nr_atendimento, 
	a.cd_pessoa_fisica cd_paciente 
FROM 	ESCALA_CAM_ICU e, 
		estabelecimento f, 
		atendimento_paciente a 
WHERE 	a.nr_atendimento= e.nr_atendimento 
AND	a.cd_estabelecimento = f.cd_estabelecimento 
AND	e.dt_liberacao IS NOT NULL;

