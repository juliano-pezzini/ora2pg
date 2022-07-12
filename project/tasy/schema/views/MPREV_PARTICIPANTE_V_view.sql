-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW mprev_participante_v (nm_pessoa_fisica, nr_sequencia, nr_cpf, dt_nascimento, ds_idade, ds_programas, ds_campanhas, nr_carteirinha, ds_area_atend, ds_tipo_atend, ie_sit, cd_pessoa_fisica, nm_social) AS select	substr(obter_nome_pf(p.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
		x.nr_sequencia, 
		p.nr_cpf, 
		p.dt_nascimento, 
		obter_idade(p.dt_nascimento, LOCALTIMESTAMP, 'S') ds_idade, 
		mprev_obter_dados_partic(x.nr_sequencia, LOCALTIMESTAMP, 'PR', x.cd_pessoa_fisica) ds_programas, 
		mprev_obter_dados_partic(x.nr_sequencia, LOCALTIMESTAMP, 'CN', x.cd_pessoa_fisica) ds_campanhas, 
		mprev_obter_dados_partic(x.nr_sequencia, LOCALTIMESTAMP, 'CR', x.cd_pessoa_fisica) nr_carteirinha, 
		mprev_obter_dados_partic(x.nr_sequencia, LOCALTIMESTAMP, 'AD', x.cd_pessoa_fisica) ds_area_atend, 
		mprev_obter_dados_partic(x.nr_sequencia, LOCALTIMESTAMP, 'TA', null) ds_tipo_atend, 
		x.ie_situacao ie_sit, 
		x.cd_pessoa_fisica, 
		p.nm_social 
FROM  	pessoa_fisica p, 
		mprev_participante x 
where 	p.cd_pessoa_fisica = x.cd_pessoa_fisica;

