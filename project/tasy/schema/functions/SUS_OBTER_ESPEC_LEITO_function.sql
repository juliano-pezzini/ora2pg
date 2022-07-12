-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_espec_leito (nr_seq_espec_leito_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_espec_leito_w	bigint;
ds_espec_leito_w	varchar(60);


BEGIN

select	max(cd_espec_leito),
	max(ds_espec_leito)
into STRICT	cd_espec_leito_w,
	ds_espec_leito_w
from	sus_espec_leito
where	nr_sequencia	= nr_seq_espec_leito_p;

if (ie_tipo_retorno_p = 'C') then
	ds_retorno_w	:= cd_espec_leito_w;
else
	ds_retorno_w	:= ds_espec_leito_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_espec_leito (nr_seq_espec_leito_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;

