-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION intpd_rest_utils_pck.get_pipelined_number (TB_NUMBER_P TB_NUMBER) RETURNS SETOF TB_NUMBER_TABLE AS $body$
BEGIN
    FOR I IN 1 .. TB_NUMBER_P.COUNT LOOP
        RETURN NEXT TB_NUMBER_P(I);
    END LOOP;

    RETURN;
  END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION intpd_rest_utils_pck.get_pipelined_number (TB_NUMBER_P TB_NUMBER) FROM PUBLIC;
