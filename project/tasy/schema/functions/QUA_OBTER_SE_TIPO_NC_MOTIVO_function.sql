-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_tipo_nc_motivo ( nr_seq_tipo_nc_p bigint, nr_seq_motivo_nc_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1):= 'S';
qt_w		integer;


BEGIN
if (nr_seq_tipo_nc_p > 0) and (nr_seq_motivo_nc_p > 0) then
	begin
	select	count(*)
	into STRICT	qt_w
	from	qua_nc_motivo_lib
	where	nr_seq_motivo = nr_seq_motivo_nc_p;

	if (qt_w > 0) then
		begin
		select	'S'
		into STRICT	ds_retorno_w
		from	qua_nc_motivo_lib
		where	nr_seq_tipo_nc 	= nr_seq_tipo_nc_p
		and	nr_seq_motivo 	= nr_seq_motivo_nc_p  LIMIT 1;
		exception
		when others then
			ds_retorno_w := 'N';
		end;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_tipo_nc_motivo ( nr_seq_tipo_nc_p bigint, nr_seq_motivo_nc_p bigint) FROM PUBLIC;
