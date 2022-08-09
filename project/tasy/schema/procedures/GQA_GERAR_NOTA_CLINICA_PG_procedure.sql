-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gqa_gerar_nota_clinica_pg (nr_atendimento_p bigint ,ds_evolucao_p text ,cd_medico_p bigint ,cd_pessoa_fisica_p bigint ,nm_usuario_p text ,cd_perfil_ativo_p bigint) AS $body$
DECLARE

  cd_evolucao_w      bigint;
  cd_tipo_evolucao_w tipo_evolucao.cd_tipo_evolucao%TYPE;

BEGIN
  SELECT MAX(t.cd_tipo_evolucao)
    INTO STRICT cd_tipo_evolucao_w
  FROM tipo_evolucao t
 WHERE t.ie_resumo_protocolo = 'S'
   AND t.ie_situacao = 'A';

  SELECT nextval('evolucao_paciente_seq')
    INTO STRICT cd_evolucao_w
;

  INSERT INTO evolucao_paciente(cd_evolucao
    ,nr_atendimento
    ,ds_evolucao
    ,cd_medico
    ,cd_pessoa_fisica
    ,nm_usuario_nrec
    ,nm_usuario
    ,cd_perfil_ativo
    ,ie_evolucao_clinica
    ,ie_tipo_evolucao
    ,ie_situacao
    ,ie_evolucao_dor
    ,ie_relev_resumo_alta
    ,ie_recem_nato
    ,ie_avaliador_aux
    ,ie_nivel_atencao
    ,ie_restricao_visualizacao
    ,dt_liberacao
    ,dt_evolucao
    ,dt_atualizacao
    ,dt_atualizacao_nrec)
  VALUES (cd_evolucao_w
    ,nr_atendimento_p
    ,ds_evolucao_p
    ,cd_medico_p
    ,cd_pessoa_fisica_p
    ,nm_usuario_p
    ,nm_usuario_p
    ,cd_perfil_ativo_p
    ,cd_tipo_evolucao_w
    ,0
    ,'A'
    ,'N'
    ,'N'
    ,'N'
    ,'N'
    ,'T'
    ,'T'
    ,clock_timestamp()
    ,clock_timestamp()
    ,clock_timestamp()
    ,clock_timestamp());

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gqa_gerar_nota_clinica_pg (nr_atendimento_p bigint ,ds_evolucao_p text ,cd_medico_p bigint ,cd_pessoa_fisica_p bigint ,nm_usuario_p text ,cd_perfil_ativo_p bigint) FROM PUBLIC;
