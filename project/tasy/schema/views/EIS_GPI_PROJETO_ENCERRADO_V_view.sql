-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_gpi_projeto_encerrado_v (nr_sequencia, nm_projeto, nr_seq_tipo, cd_pf_gestor, cd_gestor_funcional, cd_setor_atendimento, cd_centro_custo, nm_pf_gestor, nm_gestor_funcional, dt_referencia, ds_setor_atendimento) AS select	a.nr_sequencia,
	a.nm_projeto, 
	a.nr_seq_tipo, 
	a.cd_pf_gestor, 
	a.cd_gestor_funcional, 
	a.cd_setor_atendimento, 
	a.cd_centro_custo, 
	substr(obter_nome_pf(a.cd_pf_gestor),1,255) nm_pf_gestor, 
	substr(obter_nome_pf(a.cd_gestor_funcional),1,255) nm_gestor_funcional, 
	trunc(gpi_obter_dt_conclusao_proj(a.nr_sequencia, a.nr_seq_estagio)) dt_referencia, 
	substr(obter_nome_setor(a.cd_setor_Atendimento),1,255) ds_setor_atendimento 
FROM	gpi_estagio b, 
	gpi_projeto a 
where	a.nr_seq_estagio	= b.nr_sequencia 
and	b.ie_tipo_estagio	= 'C';

