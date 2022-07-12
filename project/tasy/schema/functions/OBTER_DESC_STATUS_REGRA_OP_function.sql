-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_status_regra_op (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(255);

BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then
	select max(SUBSTR(ds_status,1,255))
	into STRICT   ds_retorno_w
	from   regra_status_op
	where  coalesce(ie_situacao,'A') = 'A'
	and 	 nr_sequencia = nr_sequencia_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_status_regra_op (nr_sequencia_p bigint) FROM PUBLIC;
