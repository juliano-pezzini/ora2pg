-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_identificacao ( cd_cgc_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  varchar(255);


BEGIN

if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then
 select  CD_CODIGO_IDENTIFICACAO
 into STRICT 	ds_retorno_w
 from  	PESSOA_JURIDICA_CONTA
 where  cd_cgc = cd_cgc_p;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_identificacao ( cd_cgc_p text) FROM PUBLIC;
