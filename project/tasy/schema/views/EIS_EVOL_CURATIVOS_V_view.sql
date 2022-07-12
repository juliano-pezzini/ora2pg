-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_evol_curativos_v (cd_pessoa_fisica, dt_mes_entrada, cd_setor_atendimento, ds_setor_atendimento, ie_clinica, ds_clinica, ie_evolucao_clinica, ds_tipo_evolucao, cd_estabelecimento) AS SELECT 	b.cd_pessoa_fisica,
	TRUNC(a.dt_evolucao, 'mm') dt_mes_entrada, 
	cd_setor_Atendimento, 
	SUBSTR(obter_nome_setor(cd_setor_Atendimento),1,255) ds_setor_atendimento, 
	b.ie_clinica, 
	SUBSTR(obter_valor_dominio(17,b.ie_clinica),1,80) ds_clinica, 
	a.ie_evolucao_clinica, 
	SUBSTR(obter_desc_tipo_evolucao(a.ie_evolucao_clinica),1,255) ds_tipo_evolucao, 
	b.cd_estabelecimento 
FROM  	cur_evolucao a, 
	cur_ferida b 
WHERE 	b.nr_sequencia = a.nr_seq_ferida 
AND	a.ie_situacao = 'A';

