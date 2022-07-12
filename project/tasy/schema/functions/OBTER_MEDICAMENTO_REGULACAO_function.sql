-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medicamento_regulacao (CD_MATERIAL_P bigint) RETURNS varchar AS $body$
DECLARE

  DS_RETORNO_W varchar(255);

BEGIN
  IF (coalesce(CD_MATERIAL_P::text, '') = '') THEN
    DS_RETORNO_W := ' ';
  ELSE
    BEGIN
      SELECT MAX(M.DS_MATERIAL)
        INTO STRICT DS_RETORNO_W
        FROM MATERIAL M
       WHERE M.CD_MATERIAL = CD_MATERIAL_P  LIMIT 1;
    EXCEPTION
      WHEN OTHERS THEN
        DS_RETORNO_W := '';
    END;
  END IF;
  RETURN DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medicamento_regulacao (CD_MATERIAL_P bigint) FROM PUBLIC;
