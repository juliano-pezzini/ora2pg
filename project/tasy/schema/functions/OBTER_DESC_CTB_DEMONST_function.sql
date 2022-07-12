-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_ctb_demonst (NR_SEQUENCIA_P bigint) RETURNS varchar AS $body$
DECLARE


DS_RESULTADO_W			varchar(100);


BEGIN

IF (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') THEN
	SELECT DS_MODELO DS
	INTO STRICT DS_RESULTADO_W
	FROM CTB_MODELO_RELAT
	WHERE NR_SEQUENCIA = NR_SEQUENCIA_P;
END IF;

RETURN DS_RESULTADO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_ctb_demonst (NR_SEQUENCIA_P bigint) FROM PUBLIC;

