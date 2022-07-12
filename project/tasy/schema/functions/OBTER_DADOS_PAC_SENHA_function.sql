-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pac_senha (NR_SEQUENCIA_P bigint) RETURNS varchar AS $body$
DECLARE

  CD_PESSOA_FISICA_W PESSOA_FISICA.CD_PESSOA_FISICA%TYPE;

BEGIN

  SELECT MAX(CD_PESSOA_FISICA)
    INTO STRICT CD_PESSOA_FISICA_W
    FROM PACIENTE_SENHA_FILA P
   WHERE P.NR_SEQUENCIA = NR_SEQUENCIA_P;

  RETURN CD_PESSOA_FISICA_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pac_senha (NR_SEQUENCIA_P bigint) FROM PUBLIC;
