-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW localizador_resp_atendimento_v (cd_pessoa_fisica, nm_pessoa_fisica, nm_social, nm_pessoa_fisica_sem_acento, ds_fonetica, ds_fonetica_cns, nr_crm, nm_guerra, ie_corpo_clinico, ie_corpo_assist, nm_usuario, dt_atualizacao, cd_especialidade, ds_vinculo, ie_vinculo_medico, nr_cpf, nr_seq_conselho, ds_sigla_conselho, ds_conselho, cd_especialidade_medic, cd_especialidade_prof, ds_especialidade_prof) AS select distinct a.cd_pessoa_fisica,
  a.nm_pessoa_fisica,
  a.nm_social,
  a.nm_pessoa_fisica_sem_acento,
  a.ds_fonetica,
  a.ds_fonetica_cns,
  b.nr_crm,
  b.nm_guerra,
  b.ie_corpo_clinico,
  b.ie_corpo_assist,
  a.nm_usuario,
  a.dt_atualizacao,
  substr(obter_especialidades_medico(a.cd_pessoa_fisica),1,255) cd_especialidade,
  substr(obter_valor_dominio(3,b.ie_vinculo_medico),1,120) ds_vinculo,
  b.ie_vinculo_medico,
  a.nr_cpf,
  a.nr_seq_conselho,
  SubStr(Obter_Conselho_Profissional(a.nr_seq_conselho,'S'),1,100) ds_sigla_conselho,
  SubStr(Obter_Conselho_Profissional(a.nr_seq_conselho,'D'),1,100) ds_conselho,
  substr(obter_especialidade_medico(a.cd_pessoa_fisica,'CD'),1,255) cd_especialidade_medic,
  substr(Obter_Especialidades_prof(a.cd_pessoa_fisica),1,255) cd_especialidade_prof,
  substr(Obter_Especialidades_prof(a.cd_pessoa_fisica, 'DS'),1,255) ds_especialidade_prof
FROM pessoa_fisica a, medico b
LEFT OUTER JOIN medico_especialidade c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica  and b.ie_situacao = 'A'

union

select distinct a.cd_pessoa_fisica,
  a.nm_pessoa_fisica,
  a.nm_social,
  a.nm_pessoa_fisica_sem_acento,  
  a.ds_fonetica,
  a.ds_fonetica_cns,
  '',
  '',
  'N',
  'N',
  a.nm_usuario,
  a.dt_atualizacao,
  substr(obter_especialidades_medico(a.cd_pessoa_fisica),1,255) cd_especialidade,
  '' ds_vinculo,
  0,
  a.nr_cpf,
  a.nr_seq_conselho,
  SubStr(Obter_Conselho_Profissional(a.nr_seq_conselho,'S'),1,100) ds_sigla_conselho,
  SubStr(Obter_Conselho_Profissional(a.nr_seq_conselho,'D'),1,100) ds_conselho,
  substr(obter_especialidade_medico(a.cd_pessoa_fisica,'CD'),1,255) cd_especialidade_medic,
  substr(Obter_Especialidades_prof(a.cd_pessoa_fisica),1,255) cd_especialidade_prof,
  substr(Obter_Especialidades_prof(a.cd_pessoa_fisica, 'DS'),1,255) ds_especialidade_prof
from  pessoa_fisica a
where    nr_seq_conselho IS NOT null
and      not exists (select 1
                    from medico x
                    where x.cd_pessoa_fisica = a.cd_pessoa_fisica
		  and coalesce(ie_situacao,'A') = 'A');
