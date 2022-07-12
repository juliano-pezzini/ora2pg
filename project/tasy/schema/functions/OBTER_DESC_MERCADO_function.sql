-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_mercado (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


nm_mercado_w	varchar(255);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select 	substr(obter_desc_expressao(cd_exp_mercado, ds_mercado),1,255)
	into STRICT	nm_mercado_w
	from	mkt_mercado
	where	nr_sequencia = nr_sequencia_p;

end if;

return	nm_mercado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_mercado (nr_sequencia_p bigint) FROM PUBLIC;

