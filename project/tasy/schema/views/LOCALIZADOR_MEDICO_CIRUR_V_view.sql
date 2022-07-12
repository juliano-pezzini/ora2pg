-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW localizador_medico_cirur_v (cd_pessoa_fisica, nm_pessoa_fisica, ds_fonetica, ds_fonetica_cns, nr_crm, nm_guerra, ie_corpo_clinico, ie_corpo_assist, nm_usuario, dt_atualizacao, ds_especialidade, ie_agenda_cirurgiao, nm_pessoa_fisica_sem_acento, nm_social) AS select	a.cd_pessoa_fisica,
    	a.nm_pessoa_fisica, 
	a.ds_fonetica, 
    	a.ds_fonetica_cns, 
    	b.nr_crm, 
    	b.nm_guerra, 
    	b.ie_corpo_clinico, 
    	b.ie_corpo_assist, 
    	a.nm_usuario, 
    	a.dt_atualizacao, 
	substr(obter_especialidade_medico(a.cd_pessoa_fisica,'d'),1,40) ds_especialidade, 
	obter_se_agendamento_lib('',b.cd_pessoa_fisica,null, '', null, 'S') ie_agenda_cirurgiao, 
	a.nm_pessoa_fisica_sem_acento, 
	a.nm_social 
FROM 	pessoa_fisica a, medico b 
where 	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
and 	b.ie_situacao = 'A' 
order by a.nm_pessoa_fisica;

