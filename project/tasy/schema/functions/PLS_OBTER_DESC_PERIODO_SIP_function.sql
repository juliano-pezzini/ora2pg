-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_periodo_sip ( nr_ano_p text, nr_periodo_tps_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_periodo_w		varchar(255);



BEGIN

select	ds_periodo
into STRICT	ds_periodo_w
from	pls_periodo_sip
where	nr_sequencia	= nr_periodo_tps_p;

if (ds_periodo_w IS NOT NULL AND ds_periodo_w::text <> '') then
	ds_retorno_w:= ds_periodo_w;
else
	ds_retorno_w := '';
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_periodo_sip ( nr_ano_p text, nr_periodo_tps_p bigint) FROM PUBLIC;

