-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cp_copiar_fat_rel_ris ( nr_seq_pr_diag_ant_p bigint, nr_seq_pr_diag_new_p bigint, nm_usuario_p text) AS $body$
DECLARE


  nr_seq_fat_rel_new_w PE_PRESCR_DIAG_FAT_REL.nr_sequencia%type;
  nr_seq_fat_ris_new_w PE_PRESCR_DIAG_FAT_RIS.nr_sequencia%type;

  c_fat_rel_ant CURSOR FOR
    SELECT * FROM PE_PRESCR_DIAG_FAT_REL WHERE nr_seq_diag = nr_seq_pr_diag_ant_p;

  c_fat_ris_ant CURSOR FOR
    SELECT * FROM PE_PRESCR_DIAG_FAT_RIS WHERE nr_seq_diag = nr_seq_pr_diag_ant_p;

BEGIN

  -- FATORES RELACIONADOS
  
  FOR r_c_fat_rel_ant IN c_fat_rel_ant
  LOOP
    SELECT nextval('pe_prescr_diag_fat_rel_seq') INTO STRICT nr_seq_fat_rel_new_w;

    INSERT
    INTO PE_PRESCR_DIAG_FAT_REL(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_diag,
        nr_seq_fat_rel,
        nr_seq_compl,
        ds_observacao
      )
      VALUES (
        nr_seq_fat_rel_new_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_pr_diag_new_p,
        r_c_fat_rel_ant.nr_seq_fat_rel,
        r_c_fat_rel_ant.nr_seq_compl,
        r_c_fat_rel_ant.ds_observacao
      );
  END LOOP;

  -- FATORES DE RISCO
  
  FOR r_c_fat_ris_ant IN c_fat_ris_ant
  LOOP
    SELECT nextval('pe_prescr_diag_fat_ris_seq') INTO STRICT nr_seq_fat_ris_new_w;

    INSERT
    INTO PE_PRESCR_DIAG_FAT_RIS(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        nr_seq_diag,
        nr_seq_fat_ris
      )
      VALUES (
        nr_seq_fat_ris_new_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        nr_seq_pr_diag_new_p,
        r_c_fat_ris_ant.nr_seq_fat_ris
      );
  END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cp_copiar_fat_rel_ris ( nr_seq_pr_diag_ant_p bigint, nr_seq_pr_diag_new_p bigint, nm_usuario_p text) FROM PUBLIC;

