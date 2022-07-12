-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_convenio_lista_esp (nr_seq_lista_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_convenio_w		bigint;
nr_seq_plano_w		bigint;
ds_convenio_w		varchar(255);
ds_plano_w		varchar(40);


BEGIN

select	coalesce(max(cd_convenio),0),
	coalesce(max(nr_seq_plano),0)
into STRICT	cd_convenio_w,
	nr_seq_plano_w
from	med_lista_espera
where	nr_sequencia	= nr_seq_lista_p;

if (cd_convenio_w > 0) then
	select	substr(ds_convenio,1,255)
	into STRICT	ds_convenio_w
	from	convenio
	where	cd_convenio	= cd_convenio_w;

	select	substr(ds_plano,1,40)
	into STRICT	ds_plano_w
	from	med_plano
	where	nr_sequencia	= nr_seq_plano_w;

end if;

if (ds_plano_w IS NOT NULL AND ds_plano_w::text <> '') then
	ds_retorno_w	:= substr(ds_convenio_w || '  ' || ds_plano_w,1,255);
else
	ds_retorno_w	:= substr(ds_convenio_w,1,255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_convenio_lista_esp (nr_seq_lista_p bigint) FROM PUBLIC;
