-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_guia_geap (nr_guia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_guia_aux_w		varchar(15);
vl_resto_w		bigint;
ds_digito_w		varchar(01);


BEGIN

select	mod(nr_guia_p, 11)
into STRICT	vl_resto_w
;

if (vl_resto_w > 9) then
	ds_digito_w	:= '0';
else
	ds_digito_w	:= to_char(vl_resto_w);
end if;

nr_guia_aux_w	:= to_char(nr_guia_p) || ds_digito_w;

return	(nr_guia_aux_w)::numeric;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_guia_geap (nr_guia_p bigint) FROM PUBLIC;
