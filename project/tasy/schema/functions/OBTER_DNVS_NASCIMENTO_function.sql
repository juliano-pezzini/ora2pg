-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dnvs_nascimento (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_dnv_w		varchar(40);
ds_dnv_w		varchar(255);

c01 CURSOR FOR
	SELECT	nr_dnv
	from 	nascimento
	where 	nr_atendimento = nr_atendimento_p;



BEGIN

open	c01;
loop
fetch	c01 into
	nr_dnv_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_dnv_w	:= substr(ds_dnv_w || nr_dnv_w || ',',1,255);

	end;
end loop;
close c01;

return ds_dnv_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dnvs_nascimento (nr_atendimento_p bigint) FROM PUBLIC;

