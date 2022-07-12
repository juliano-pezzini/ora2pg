-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW siscolo_cito_anamnese_v (nr_atendimento, cd_estabelecimento, cd_profissional, dt_atualizacao, dt_emissao, dt_liberacao, nm_usuario, nr_sequencia, nr_cns, cd_sexo, nm_paciente1, nm_paciente2, ds_apelido, nm_mae, nr_identidade, ds_orgao_emissor, ds_uf1, nr_cpf, dt_nasc_dia, dt_nasc_mes, dt_nasc_ano, nr_idade, ds_cor, ds_logradouro, nr_logradouro, ds_complemento1, ds_complemento2, ds_bairro, ds_uf2, cd_municipio_ibge, ds_municipio, nr_cep1, nr_cep2, nr_ddd_telefone, nr_telefone1, nr_telefone2, ds_grau_intrucao, ds_nacionalidade) AS select	a.nr_atendimento,
	a.cd_estabelecimento, 
	a.cd_profissional, 
	a.dt_atualizacao, 
	a.dt_emissao, 
	a.dt_liberacao, 
	a.nm_usuario, 
	a.nr_sequencia, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'CNS'),1,200) nr_cns, 
	substr(obter_sexo_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'C'),1,15) cd_sexo, 
	substr(obter_nome_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP')),1,35) nm_paciente1, 
	substr(obter_nome_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP')),36,50) nm_paciente2, 
	substr(obter_apelido_pessoa(Obter_Dados_Atendimento(a.nr_atendimento,'CP')),1,20) ds_apelido, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),5,'N'),1,35) nm_mae, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'RG'),1,10) nr_identidade, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'O'),1,6) ds_orgao_emissor, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'UF'),1,5) ds_uf1, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'CPF'),1,12) nr_cpf, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'DN'),1,2) dt_nasc_dia, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'DN'),4,2) dt_nasc_mes, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'DN'),7,4) dt_nasc_ano, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'I'),1,4) nr_idade, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'CP'),1,20) ds_cor, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'EN'),1,35) ds_logradouro, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'NR'),1,6) nr_logradouro, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'CO'),1,27) ds_complemento1, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'CO'),28,43) ds_complemento2, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'B'),1,15) ds_bairro, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'UF'),1,5) ds_uf2, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'CDM'),1,7) cd_municipio_ibge, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'DM'),1,15) ds_municipio, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'CEP'),1,5) nr_cep1, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'CEP'),6,9) nr_cep2, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'DDT'),1,3) nr_ddd_telefone, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'T'),1,4) nr_telefone1, 
	substr(obter_compl_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),1,'T'),5,8) nr_telefone2, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'GI'),1,50) ds_grau_intrucao, 
	substr(obter_dados_pf(Obter_Dados_Atendimento(a.nr_atendimento,'CP'),'N'),1,50) ds_nacionalidade 
FROM	siscolo_atendimento a;
