-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_prescr_proc_obs (NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint, DS_ARQUIVO_P text, NM_USUARIO_P text) AS $body$
DECLARE


nr_seq_prescr_compl_w bigint;


BEGIN
  SELECT coalesce(MAX(nr_sequencia),0) + 1
  INTO STRICT nr_seq_prescr_compl_w
  FROM prescr_procedimento_obs;

  INSERT INTO prescr_procedimento_obs(nr_sequencia,
                  dt_atualizacao,
                  nm_usuario,
                  dt_atualizacao_nrec,
                  nm_usuario_nrec,
                  nr_prescricao,
                  nr_seq_prescricao,
                  ds_observacao)
  VALUES (nr_seq_prescr_compl_w,
    clock_timestamp(),
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario_p,
    nr_prescricao_p,
    nr_seq_prescricao_p,
    ds_arquivo_p);

  UPDATE prescr_procedimento
  SET ie_status_execucao = '22'
  WHERE nr_prescricao = nr_prescricao_p
  AND nr_sequencia = nr_seq_prescricao_p;

  COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_prescr_proc_obs (NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint, DS_ARQUIVO_P text, NM_USUARIO_P text) FROM PUBLIC;

