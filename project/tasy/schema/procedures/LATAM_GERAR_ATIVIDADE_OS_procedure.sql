-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE latam_gerar_atividade_os ( nr_ordem_servico_p CADASTRO_SPRINT_ATIVIDADE.NR_ORDEM_SERVICO%TYPE, cd_pessoa_responsavel_p CADASTRO_SPRINT_ATIVIDADE.CD_PESSOA_RESPONSAVEL%TYPE, nr_seq_cadastro_sprint_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_CADASTRO_SPRINT%TYPE, nm_usuario_p CADASTRO_SPRINT_ATIVIDADE.NM_USUARIO%TYPE, dt_inicio_p CADASTRO_SPRINT_ATIVIDADE.DT_INICIO_ATIVIDADE%TYPE, dt_fim_p CADASTRO_SPRINT_ATIVIDADE.DT_PREVISTA_ATIVIDADE%TYPE, nr_seq_requisito_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_REQUISITO%TYPE DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w                    MAN_ORDEM_SERVICO.NR_SEQUENCIA%TYPE;
ie_ordem_serv_defeito_w           MAN_ORDEM_SERVICO.IE_CLASSIFICACAO%TYPE;
ds_dano_w                         MAN_ORDEM_SERVICO.DS_DANO%TYPE;
ie_classificacao_sprint_s         CONSTANT CADASTRO_SPRINT_ATIVIDADE.IE_CLASSIFICACAO%TYPE := 2;
const_situacao_pendente           CONSTANT CADASTRO_SPRINT_ATIVIDADE.IE_SITUACAO%TYPE := 'C';
			

BEGIN

  SELECT MAX(a.NR_SEQUENCIA),
         CASE WHEN MAX(a.IE_CLASSIFICACAO)='E' THEN  'S' WHEN MAX(a.IE_CLASSIFICACAO)='S' THEN  'S'  ELSE 'N' END ,
         MAX(a.DS_DANO)
  INTO STRICT   nr_sequencia_w,
         ie_ordem_serv_defeito_w,
         ds_dano_w
  FROM   MAN_ORDEM_SERVICO a
  WHERE  a.NR_SEQUENCIA = nr_ordem_servico_p;

  IF (ie_ordem_serv_defeito_w = 'N') THEN
    CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(1204295);
  END IF;

  INSERT INTO CADASTRO_SPRINT_ATIVIDADE(
      NR_SEQUENCIA,
      NR_SEQ_CADASTRO_SPRINT,
      DS_ATIVIDADE,
      DT_ATUALIZACAO,
      NM_USUARIO,
      NR_ORDEM_SERVICO,
      CD_PESSOA_RESPONSAVEL,
      IE_SITUACAO,
      IE_CLASSIFICACAO,
      DT_INICIO_ATIVIDADE,
      DT_PREVISTA_ATIVIDADE,
      NR_SEQ_REQUISITO
  ) VALUES (
      nextval('cadastro_sprint_atividade_seq'),
      nr_seq_cadastro_sprint_p,
      nr_sequencia_w,
      clock_timestamp(),
      nm_usuario_p,
      nr_sequencia_w,
      cd_pessoa_responsavel_p,
      const_situacao_pendente,
      ie_classificacao_sprint_s,
      dt_inicio_p,
      dt_fim_p,
      nr_seq_requisito_p
  );

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE latam_gerar_atividade_os ( nr_ordem_servico_p CADASTRO_SPRINT_ATIVIDADE.NR_ORDEM_SERVICO%TYPE, cd_pessoa_responsavel_p CADASTRO_SPRINT_ATIVIDADE.CD_PESSOA_RESPONSAVEL%TYPE, nr_seq_cadastro_sprint_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_CADASTRO_SPRINT%TYPE, nm_usuario_p CADASTRO_SPRINT_ATIVIDADE.NM_USUARIO%TYPE, dt_inicio_p CADASTRO_SPRINT_ATIVIDADE.DT_INICIO_ATIVIDADE%TYPE, dt_fim_p CADASTRO_SPRINT_ATIVIDADE.DT_PREVISTA_ATIVIDADE%TYPE, nr_seq_requisito_p CADASTRO_SPRINT_ATIVIDADE.NR_SEQ_REQUISITO%TYPE DEFAULT NULL) FROM PUBLIC;
