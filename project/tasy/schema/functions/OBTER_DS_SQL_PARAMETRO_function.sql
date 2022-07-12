-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_sql_parametro (CD_FUNCAO_P bigint, CD_PARAMETRO_P bigint) RETURNS bigint AS $body$
DECLARE


ds_sql_w	FUNCAO_PARAMETRO.ds_sql%TYPE;


BEGIN

IF (CD_FUNCAO_P IS NOT NULL AND CD_FUNCAO_P::text <> '' AND CD_PARAMETRO_P IS NOT NULL AND CD_PARAMETRO_P::text <> '') THEN
	BEGIN

	 select coalesce(max(ds_sql_w),'')
	 into STRICT	ds_sql_w
	 from   FUNCAO_PARAMETRO
	 where  CD_FUNCAO = CD_FUNCAO_P
	 and    NR_SEQUENCIA = CD_PARAMETRO_P;

	END;
END IF;

RETURN	ds_sql_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_sql_parametro (CD_FUNCAO_P bigint, CD_PARAMETRO_P bigint) FROM PUBLIC;
