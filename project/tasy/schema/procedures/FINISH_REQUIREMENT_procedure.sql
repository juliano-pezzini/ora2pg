-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finish_requirement ( nr_sequencia_p LATAM_REQUISITO.NR_SEQUENCIA%type, nm_usuario_p LATAM_REQUISITO.NM_USUARIO%type ) AS $body$
BEGIN

IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') THEN
   UPDATE LATAM_REQUISITO SET
          IE_LIBERAR_DESENV = 'I',
          DT_ATUALIZACAO    = clock_timestamp(),
          NM_USUARIO        = nm_usuario_p
   WHERE  NR_SEQUENCIA      = nr_sequencia_p;

   COMMIT;
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finish_requirement ( nr_sequencia_p LATAM_REQUISITO.NR_SEQUENCIA%type, nm_usuario_p LATAM_REQUISITO.NM_USUARIO%type ) FROM PUBLIC;
