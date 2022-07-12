-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eo_controle_de_imunizacoes_v (nr_seq, nr_atendimento, cd_pessoa_fisica, nm_pf, ds_idade_pf, ds_faixa_etaria, ie_sexo, ds_sexo, nr_seq_vacina, ds_vacina, ie_dose, ds_dose, cd_procedimento, ds_procedimento, ie_via_aplicacao, ds_via_aplicacao, cd_profissional, ds_profissional, cd_setor_atendimento, nm_setor_atendimento, nr_seq_topografia, ds_topografia, ie_executado, ds_executado, qt_dose, dt_vacina, dt_filtro) AS select	1 nr_seq,
	x.nr_atendimento, 
	x.cd_pessoa_fisica, 
	substr(coalesce(obter_nome_pf(x.cd_pessoa_fisica),obter_dados_atendimento(x.nr_atendimento,'NP')),1,100) nm_pf, 
	substr(coalesce(obter_idade_pf(x.cd_pessoa_fisica,LOCALTIMESTAMP,'A'),obter_idade_pf(obter_dados_atendimento(x.nr_atendimento,'CP'),LOCALTIMESTAMP,'A')),1,3) ds_idade_pf, 
	substr(coalesce(obter_faixa_etaria_pf(x.cd_pessoa_fisica),obter_faixa_etaria_pf(obter_dados_atendimento(x.nr_atendimento,'CP'))),1,10) ds_faixa_etaria, 
	substr(coalesce(obter_sexo_pf(x.cd_pessoa_fisica,'C'),obter_sexo_pf(obter_dados_atendimento(x.nr_atendimento,'CP'),'C')),1,15) ie_sexo, 
	substr(coalesce(obter_sexo_pf(x.cd_pessoa_fisica,'D'),obter_sexo_pf(obter_dados_atendimento(x.nr_atendimento,'CP'),'D')),1,15) ds_sexo,	 
	x.nr_seq_vacina, 
	substr(obter_desc_vacina(x.nr_seq_vacina),1,255) ds_vacina,	 
	x.ie_dose, 
	substr(obter_valor_dominio(1018, x.ie_dose),1,150) ds_dose, 
	x.cd_procedimento, 
	substr(coalesce(obter_descricao_procedimento(x.cd_procedimento,x.ie_origem_proced),'Não informado'),1,100) ds_procedimento, 
	x.ie_via_aplicacao, 
	substr(coalesce(obter_via_aplicacao(x.ie_via_aplicacao,'D'),'Não informado'),1,150) ds_via_aplicacao, 
	x.cd_profissional, 
	substr(obter_nome_pf(x.cd_profissional),1,100) ds_profissional, 
	x.cd_setor_atendimento, 
	substr(coalesce(obter_nome_setor(x.cd_setor_atendimento),'Não informado'),1,100) nm_setor_atendimento, 
	x.nr_seq_topografia, 
	substr(coalesce(obter_desc_topografia(x.nr_seq_topografia),'Não informado'),1,100) ds_topografia, 
	x.ie_executado, 
	CASE WHEN coalesce(x.ie_executado,'N')='N' THEN 'Não executado'  ELSE 'Executado' END  ds_executado,	 
	x.qt_dose, 
	x.dt_vacina, 
	x.dt_vacina dt_filtro 
FROM 	paciente_vacina x 
where	x.dt_vacina is not null 
order by	substr(coalesce(obter_nome_pf(x.cd_pessoa_fisica),obter_dados_atendimento(x.nr_atendimento,'NP')),1,100);
