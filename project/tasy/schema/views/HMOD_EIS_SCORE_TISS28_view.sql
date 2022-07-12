-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hmod_eis_score_tiss28 (qt_atendimento, dt_alta, dt_avaliacao, qt_pontuacao, ie_clinica, cd_pessoa_fisica, cd_medico_resp, cd_setor_usuario, ds_setor_usuario, ds_clinica, ds_espec_medico, nm_medico, nm_pessoa_fisica, nm_usuario) AS select  count(b.nr_atendimento)qt_atendimento,
 b.dt_alta,
        a.dt_avaliacao,
     a.qt_pontuacao,
     b.ie_clinica,
        b.cd_pessoa_fisica,
        b.cd_medico_resp,
 substr(obter_setor_usuario(a.nm_usuario),1,20)cd_setor_usuario,
     substr(obter_nome_setor(obter_setor_usuario(a.nm_usuario)),1,60) ds_setor_usuario,
        substr(obter_valor_dominio(17,b.ie_clinica),1,15)ds_clinica,
        substr(obter_especialidades_medico(b.cd_medico_resp),1,20)ds_espec_medico,
        substr(obter_nome_pf_pj(b.cd_medico_resp,null),1,30)nm_medico,
        substr(obter_nome_pf_pj(b.cd_pessoa_fisica,null),1,30)nm_pessoa_fisica,
        substr(obter_nome_pf_pj(a.cd_pessoa_fisica,null),1,30)nm_usuario
 FROM   Tiss_interv_terapeutica a,
        atendimento_paciente b
 where  a.nr_atendimento = b.nr_atendimento
 group by  b.dt_alta,
             a.dt_avaliacao,
      a.qt_pontuacao,
      a.nm_usuario,
      b.ie_clinica,
             b.cd_pessoa_fisica,
      a.cd_pessoa_fisica,
             b.cd_medico_resp
;
