-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_ofuse_key ( cd_funcao_p bigint, ie_checksum_p text, ds_key_p text) RETURNS varchar AS $body$
DECLARE


ds_key_w	varchar(255);
ds_return_w	varchar(255);


BEGIN
if (coalesce(cd_funcao_p,0) <> 0) then
	select	substr((to_char(clock_timestamp(),'ddmmyyyy'))::numeric /cd_funcao_p,1,8)
	into STRICT	ds_key_w
	;

	if (ie_checksum_p = 'S') then

		ds_key_w := ds_key_w||pfcs_OFUSE_checksum(substr(ds_key_w,1,8));

	end if;

	ds_return_w	:= ds_key_w;
else

	select	round((to_char(clock_timestamp(),'ddmmyyyy'))::numeric  / (substr(ds_key_p,1,length(ds_key_p)-1))::numeric )
	into STRICT	ds_return_w
	;

	if (ie_checksum_p = 'S') then

		if (pfcs_OFUSE_checksum(substr(ds_key_p,1,length(ds_key_p)-1)) <> substr(ds_key_p,length(ds_key_p),1)) then
			ds_return_w := null;
		end if;
	end if;

end if;

return ds_return_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_ofuse_key ( cd_funcao_p bigint, ie_checksum_p text, ds_key_p text) FROM PUBLIC;

