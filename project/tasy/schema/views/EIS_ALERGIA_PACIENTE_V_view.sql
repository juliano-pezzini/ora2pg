-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_alergia_paciente_v (cd_setor_atendimento, ds_estabelecimento, cd_convenio, ds_convenio, ds_setor_atendimento, ie_sexo, ds_sexo, cd_pessoa_fisica, ie_faixa_etaria, dt_avaliacao, cd_empresa, cd_estabelecimento, nr_atendimento, cd_paciente, ds_alergeno, nr_seq_tipo) AS select	distinct
	obter_setor_atendimento(e.nr_atendimento) cd_setor_atendimento,
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento,
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio,
	substr(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,150) ds_convenio,
	obter_nome_setor(obter_setor_atendimento(e.nr_atendimento)) ds_setor_atendimento,
	obter_sexo_pf(a.cd_pessoa_fisica,'c') ie_sexo,
	obter_sexo_pf(a.cd_pessoa_fisica,'d') ds_sexo,
	e.cd_pessoa_fisica,
	substr(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),LOCALTIMESTAMP,'e'),1,10) ie_faixa_etaria,
	trunc(a.dt_entrada) dt_avaliacao,
	f.cd_empresa,
	a.cd_estabelecimento,
	a.nr_atendimento,
	a.cd_pessoa_fisica cd_paciente,
	substr(obter_desc_alergeno(e.nr_seq_tipo) || CASE WHEN coalesce(e.ie_classificacao,'A')='A' THEN  ' '   ELSE ' (' || obter_texto_tasy(1195481,philips_param_pck.get_nr_seq_idioma) || ')' END ,1,80) ds_alergeno,
	e.nr_seq_tipo
FROM 	paciente_alergia e,
		estabelecimento f,
		atendimento_paciente a
where 	a.cd_pessoa_fisica= e.cd_pessoa_fisica
and	a.cd_estabelecimento = f.cd_estabelecimento
and	e.dt_liberacao is not null
and	e.dt_inativacao is null
and	a.nr_atendimento = obter_ultimo_atendimento(e.cd_pessoa_fisica)
and	coalesce(ie_nega_alergias,'N') = 'N';

