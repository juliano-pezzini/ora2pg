-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_form (CD_FUNCAO_P bigint) RETURNS varchar AS $body$
DECLARE


DS_FORM_W		varchar(200);


BEGIN

IF (CD_FUNCAO_P IS NOT NULL AND CD_FUNCAO_P::text <> '') THEN
	BEGIN

	SELECT	DS_FORM
	INTO STRICT	DS_FORM_W
	FROM	FUNCAO
	WHERE 	CD_FUNCAO = CD_FUNCAO_P;

	END;
END IF;

RETURN	DS_FORM_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_form (CD_FUNCAO_P bigint) FROM PUBLIC;
