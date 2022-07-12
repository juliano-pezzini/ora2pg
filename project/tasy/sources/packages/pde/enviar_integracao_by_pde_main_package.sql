-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pde.enviar_integracao_by_pde_main (NR_SEQ_PDE_MAIN_P bigint DEFAULT NULL) AS $body$
DECLARE


  L RECORD;

BEGIN
    FOR L IN (SELECT PL.NR_SEQUENCIA, PL.NM_USUARIO
                FROM PDE_LOG PL
               WHERE (coalesce(NR_SEQ_PDE_MAIN_P, 0) = 0 OR
                     PL.NR_SEQ_PDE_MAIN = NR_SEQ_PDE_MAIN_P)
                 AND (PL.DT_JSON IS NOT NULL AND PL.DT_JSON::text <> '')
                 AND coalesce(PL.DT_ENVIO::text, '') = ''
               ORDER BY PL.NR_SEQUENCIA) LOOP
      CALL_JOB_SEND_INTEGRATION(L.NR_SEQUENCIA,
                                coalesce(WHEB_USUARIO_PCK.GET_NM_USUARIO,
                                    L.NM_USUARIO));
    END LOOP;

    COMMIT;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pde.enviar_integracao_by_pde_main (NR_SEQ_PDE_MAIN_P bigint DEFAULT NULL) FROM PUBLIC;