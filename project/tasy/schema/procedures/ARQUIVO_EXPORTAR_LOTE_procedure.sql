-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE arquivo_exportar_lote ( NR_SEQUENCIA_P bigint, NM_USUARIO_P text, DS_ARQUIVO_P text) AS $body$
BEGIN
  IF (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') THEN
    UPDATE LAB_LOTE_RESULT_EXTERNO
    SET NM_USUARIO     = NM_USUARIO_P,
      DT_ATUALIZACAO   = clock_timestamp() ,
      DS_ARQUIVO       = DS_ARQUIVO_P
    WHERE NR_SEQUENCIA = NR_SEQUENCIA_P;
  END IF;
  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE arquivo_exportar_lote ( NR_SEQUENCIA_P bigint, NM_USUARIO_P text, DS_ARQUIVO_P text) FROM PUBLIC;
