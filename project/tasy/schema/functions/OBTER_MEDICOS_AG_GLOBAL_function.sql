-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medicos_ag_global (cd_agenda_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


cd_medico_w		varchar(10);
ds_retorno_w	varchar(4000);

c01 CURSOR FOR
	SELECT	coalesce(cd_medico_agenda,0)
	from 	agenda_global
	where 	cd_agenda = cd_agenda_p
	and 	nr_seq_proc_interno = nr_seq_proc_interno_p;



BEGIN

open	c01;
loop
fetch	c01 into cd_medico_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	ds_retorno_w	:= ds_retorno_w || cd_medico_w|| ',';

	end;
end loop;
close c01;

ds_retorno_w	:= substr(ds_retorno_w, 1, length(ds_retorno_w) - 1);


if (ds_retorno_w = '') then
	ds_retorno_w := '0';
end if;


return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medicos_ag_global (cd_agenda_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;

