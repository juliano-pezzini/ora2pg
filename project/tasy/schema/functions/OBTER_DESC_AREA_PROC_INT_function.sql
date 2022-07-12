-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_area_proc_int (nr_seq_area_int_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (coalesce(nr_seq_area_int_p,0) > 0) then
	select	max(ds_area)
	into STRICT	ds_retorno_w
	from	area_proc_interno
	where	nr_sequencia = nr_seq_area_int_p;
end if;

return	substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_area_proc_int (nr_seq_area_int_p bigint) FROM PUBLIC;

