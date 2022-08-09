-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_pe_prescr_diag ( nr_avaliacao_anterior_p bigint, nr_seq_prescr_atual_p bigint, nm_usuario_p text) AS $body$
BEGIN
  INSERT
  INTO pe_prescr_diag(
      nr_sequencia,
      nr_seq_prescr,
      nr_seq_diag,
      nm_usuario,
      dt_atualizacao,
      nm_usuario_nrec,
      dt_atualizacao_nrec
    )
  SELECT nextval('pe_prescr_diag_seq'),
    nr_seq_prescr_atual_p,
    nr_seq_diag,
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario,
    dt_atualizacao
  FROM pe_prescr_diag
  WHERE nr_seq_prescr  = nr_avaliacao_anterior_p
  AND coalesce(dt_end::text, '') = ''
  AND coalesce(dt_cancelamento::text, '') = ''
  AND nr_seq_diag NOT IN (SELECT nr_seq_diag
    FROM pe_prescr_diag
    WHERE nr_seq_prescr = nr_seq_prescr_atual_p
    );
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_pe_prescr_diag ( nr_avaliacao_anterior_p bigint, nr_seq_prescr_atual_p bigint, nm_usuario_p text) FROM PUBLIC;
