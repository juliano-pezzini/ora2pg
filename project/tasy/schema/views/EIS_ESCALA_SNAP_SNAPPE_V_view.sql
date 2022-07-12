-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_escala_snap_snappe_v (cd_setor_atendimento, ds_estabelecimento, cd_convenio, ds_convenio, ds_setor_atendimento, ie_sexo, ds_sexo, nm_medico, cd_profissional, ie_faixa_etaria, ds_unidade, dt_avaliacao, qt_snap_ii, qt_snappe_ii, cd_empresa, cd_estabelecimento, nr_atendimento, pr_mortalidade) AS select	coalesce(eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao),a.cd_setor_atendimento) cd_setor_atendimento,
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	obter_convenio_atendimento(a.nr_atendimento) cd_convenio, 
	substr(obter_nome_convenio(obter_convenio_atendimento(a.nr_atendimento)),1,150) ds_convenio, 
	obter_nome_setor(coalesce(eis_obter_setor_atend_data(a.nr_atendimento, e.dt_avaliacao),a.cd_setor_atendimento)) ds_setor_atendimento, 
	obter_sexo_pf(a.cd_pessoa_fisica,'C') ie_sexo, 
	obter_sexo_pf(a.cd_pessoa_fisica,'D') ds_sexo, 
	obter_nome_pessoa_fisica(e.cd_profissional, null) nm_medico, 
	e.cd_profissional, 
	substr(obter_idade(obter_data_nascto_pf(a.cd_pessoa_fisica),LOCALTIMESTAMP,'E'),1,10) ie_faixa_etaria, 
	obter_unidade_atendimento(a.nr_atendimento,'A','U') ds_unidade, 
	e.dt_avaliacao, 
	e.qt_snap_ii, 
	e.qt_snappe_ii, 
	f.cd_empresa, 
	a.cd_estabelecimento, 
	a.nr_atendimento, 
	e.pr_mortalidade 
FROM 	escala_snapii_snappeii e, 
	estabelecimento f, 
	atendimento_paciente_v a 
where 	a.nr_atendimento= e.nr_atendimento 
and	a.cd_estabelecimento = f.cd_estabelecimento 
and	e.dt_liberacao is not null 
and	e.dt_inativacao is null;

