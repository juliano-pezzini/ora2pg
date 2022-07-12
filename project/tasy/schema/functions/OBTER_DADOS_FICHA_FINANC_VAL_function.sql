-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ficha_financ_val ( ds_valor_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

select	max(ds_titulo)
into STRICT	ds_retorno_w
from 	capa_ficha_financ_campos_v
where 	nm_atributo	= ds_valor_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ficha_financ_val ( ds_valor_p text) FROM PUBLIC;
