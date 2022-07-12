-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpro_atendimento_v (cd_pessoa_fisica, dt_entrada, dt_alta, nm_medico_resp, nm_medico_assistente, ds_setor, ds_unidade) AS select	cd_pessoa_fisica,
	dt_entrada,
	dt_alta,
	substr(obter_nome_medico(cd_medico_resp,'P'),1,60) nm_medico_resp,
	substr(obter_nome_medico(cd_medico_atendimento,'P'),1,60) nm_medico_assistente,
	substr(obter_nome_setor(obter_setor_Atendimento(nr_atendimento)),1,100) ds_setor,
	substr(obter_unidade_atendimento(nr_atendimento,'IAA','U'),1,60) ds_unidade
FROM	atendimento_paciente;
