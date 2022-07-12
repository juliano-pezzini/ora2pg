-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_clinica (CD_CLINICA_P bigint) RETURNS varchar AS $body$
DECLARE


DS_RESULTADO_W			varchar(100);


BEGIN

IF (CD_CLINICA_P IS NOT NULL AND CD_CLINICA_P::text <> '') THEN
	SELECT	DS_CLINICA
	INTO STRICT	DS_RESULTADO_W
	FROM	CIH_CLINICA
	WHERE	CD_CLINICA = CD_CLINICA_P;
END IF;

RETURN DS_RESULTADO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_clinica (CD_CLINICA_P bigint) FROM PUBLIC;
