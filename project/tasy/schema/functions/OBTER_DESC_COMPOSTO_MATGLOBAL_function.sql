-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_composto_matglobal ( cd_composto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

IF (cd_composto_p IS NOT NULL AND cd_composto_p::text <> '') THEN
	SELECT 	SUBSTR(DS_COMPOSTO,1,255)
	INTO STRICT	ds_retorno_w
	FROM composto_matglobal
	WHERE 	cd_composto =  cd_composto_p;
END IF;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_composto_matglobal ( cd_composto_p bigint) FROM PUBLIC;

