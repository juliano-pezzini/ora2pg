-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_permanencia_flebite_v (cd_setor_atendimento, ds_setor_atendimento, dt_evento, cd_empresa, cd_estabelecimento, ie_origem, ds_unidade, ie_faixa_etaria, ds_dias_avp, nr_atendimento, dt_atualizacao_nrec) AS select	distinct
	b.cd_setor_atendimento, 
	substr(obter_nome_setor(b.cd_setor_atendimento),1,255) ds_Setor_Atendimento,	 
	b.dt_evento, 
	f.cd_empresa, 
	a.cd_estabelecimento,	 
	e.ie_origem, 
	obter_unidade_atendimento(b.nr_atendimento,'A','U') ds_unidade, 
	substr(obter_idade(obter_data_nascto_pf(b.cd_pessoa_fisica),LOCALTIMESTAMP,'E'),1,10) ie_faixa_etaria, 
	substr(obter_desc_resultados_flebite(null,e.nr_sequencia,null,'AVP'),1,80) ds_dias_avp, 
	b.nr_atendimento, 
	e.dt_atualizacao_nrec	 
FROM	qua_evento_paciente b, 
	qua_evento_flebite e, 
	estabelecimento f, 
	atendimento_paciente a 
where	e.nr_seq_evento = b.nr_sequencia 
and	b.dt_inativacao is null 
and	a.nr_atendimento = b.nr_atendimento 
and	a.cd_estabelecimento = f.cd_estabelecimento 
and	e.ie_origem = '1';
