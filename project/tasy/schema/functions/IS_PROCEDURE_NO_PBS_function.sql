-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_procedure_no_pbs ( CD_PROCEDIMENTO_P PROCEDIMENTO.CD_PROCEDIMENTO%TYPE, IE_ORIGEM_PROCED_P PROCEDIMENTO.IE_ORIGEM_PROCED%TYPE ) RETURNS varchar AS $body$
DECLARE

  IE_NOPBS_W MATERIAL.IE_NOPBS%TYPE;

BEGIN
  SELECT  coalesce(MAX(A.IE_NOPBS), 'N')
  INTO STRICT    IE_NOPBS_W
  FROM    PROCEDIMENTO A
  WHERE   A.CD_PROCEDIMENTO = CD_PROCEDIMENTO_P
  AND     A.IE_ORIGEM_PROCED = IE_ORIGEM_PROCED_P;

  RETURN IE_NOPBS_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_procedure_no_pbs ( CD_PROCEDIMENTO_P PROCEDIMENTO.CD_PROCEDIMENTO%TYPE, IE_ORIGEM_PROCED_P PROCEDIMENTO.IE_ORIGEM_PROCED%TYPE ) FROM PUBLIC;

