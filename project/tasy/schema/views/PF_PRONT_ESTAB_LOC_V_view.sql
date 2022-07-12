-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pf_pront_estab_loc_v (cd_pessoa_fisica, nm_pessoa_fisica_sem_acento, nr_prontuario, dt_nascimento, ds_apelido, cd_funcionario, ie_funcionario, ie_func_grid, ie_func_assistencial, ds_setor_atendimento, ie_func_assist_grid, dt_ultima_alta, nr_identidade) AS SELECT a.cd_pessoa_fisica,
       a.nm_pessoa_fisica_sem_acento,
       CASE WHEN obter_valor_param_usuario(0, 120, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento)='ESTAB' THEN  b.nr_prontuario  ELSE a.nr_prontuario END  nr_prontuario,
       a.dt_nascimento,
       a.ds_apelido,
       a.cd_funcionario,
       coalesce(a.ie_funcionario, 'N') ie_funcionario,
       coalesce(a.ie_funcionario, 'N') ie_func_grid,
       SUBSTR(Obter_se_func_assistencial(a.cd_pessoa_fisica), 1, 10) ie_func_assistencial,
       SUBSTR(Obter_PESSOA_FISICA_LOC_TRAB(a.cd_pessoa_fisica), 1, 200) ds_setor_atendimento,
       SUBSTR(Obter_se_func_assistencial(a.cd_pessoa_fisica), 1, 10) ie_func_assist_grid,
       obter_dados_ultimo_atend_dt(a.cd_pessoa_fisica, NULL, 1, 'DA') dt_ultima_alta,
       a.nr_identidade
  FROM pessoa_fisica a left join pessoa_fisica_pront_estab b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica
                                                              and wheb_usuario_pck.get_cd_estabelecimento = b.cd_estabelecimento);

