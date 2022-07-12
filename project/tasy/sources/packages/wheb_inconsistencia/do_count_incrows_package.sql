-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_inconsistencia.do_count_incrows (integridade_referencial_p INTEGRIDADE_REFERENCIAL) RETURNS bigint AS $body$
DECLARE

    count_linhas_inconsistentes_w bigint;

BEGIN
    IF NOT WHEB_DB.IS_ROWTYPE_VALID(integridade_referencial_p) THEN
      RETURN 0;
    END IF;

    EXECUTE wheb_inconsistencia.getsql_count_incrows(integridade_referencial_p)
                 INTO STRICT count_linhas_inconsistentes_w;

    RETURN count_linhas_inconsistentes_w;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_inconsistencia.do_count_incrows (integridade_referencial_p INTEGRIDADE_REFERENCIAL) FROM PUBLIC;