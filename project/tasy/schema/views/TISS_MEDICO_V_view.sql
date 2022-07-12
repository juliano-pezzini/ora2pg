-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_medico_v (ds_tipo_logradouro, ds_versao, nm_medico_executor, uf_crm, sg_conselho, cd_medico, nr_crm, nr_cpf, cd_cbo_saude, cd_cnes) AS select	null ds_tipo_logradouro,
	'2.01.01' ds_versao, 
	substr(TISS_ELIMINAR_CARACTERE(a.nm_pessoa_fisica),1,100) nm_medico_executor, 
	substr(obter_dados_medico(a.cd_pessoa_fisica, 'UFCRM'),1,20) uf_crm, 
	coalesce(c.ie_conselho_prof_tiss,c.sg_conselho) sg_conselho, 
	a.cd_pessoa_fisica cd_medico, 
	substr(obter_dados_medico(a.cd_pessoa_fisica, 'CRM'),1,20) nr_crm, 
	a.nr_cpf, 
	substr(obter_dados_pf(a.cd_pessoa_fisica, 'CBOS'),1,20) cd_cbo_saude, 
	a.cd_cnes 
FROM pessoa_fisica a
LEFT OUTER JOIN conselho_profissional c ON (a.nr_seq_conselho = c.nr_sequencia);
