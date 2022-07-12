-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_conta_financ ( cd_conta_financ_p bigint, ie_identado_p text) RETURNS varchar AS $body$
DECLARE


ds_conta_financ_w		varchar(255);
cd_empresa_w		bigint;
cd_conta_apres_w		varchar(255);
qt_nivel_w		bigint;


BEGIN

select 	max(ds_conta_financ),
	max(cd_conta_apres),
	max(cd_empresa)
into STRICT	ds_conta_financ_w,
	cd_conta_apres_w,
	cd_empresa_w
from	conta_financeira
where	cd_conta_financ = cd_conta_financ_p;

select	coalesce(length(max(cd_conta_apres)), 9)
into STRICT	qt_nivel_w
from	conta_financeira
where	cd_empresa	= cd_empresa_w
and	ie_situacao	= 'A';

if (coalesce(ie_identado_p,'N') = 'S') and (cd_conta_apres_w IS NOT NULL AND cd_conta_apres_w::text <> '') and (length(cd_conta_apres_w) > 8) then

	/* edgar 02/08/2004 - os 9996 fiz o tratamento do 4 nivel da conta */

	if (qt_nivel_w = 9) then
		if (substr(cd_conta_apres_w,7,3) <> '000') then
			ds_conta_financ_w		:= '     - ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,4,2) <> '00') then
			ds_conta_financ_w		:= '  + ' || ds_conta_financ_w;
		end if;
	elsif (qt_nivel_w = 15) then
		if (substr(cd_conta_apres_w,13,3) <> '000') then
			ds_conta_financ_w	:= '               - ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,10,2) <> '00') then
			ds_conta_financ_w	:= '        +++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,7,2) <> '00') then
			ds_conta_financ_w	:= '     ++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,4,2) <> '00') then
			ds_conta_financ_w	:= '  + ' || ds_conta_financ_w;
		end if;
	elsif (qt_nivel_w = 18) then
		if (substr(cd_conta_apres_w,16,3) <> '000') then
			ds_conta_financ_w	:= '                  - ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,13,2) <> '00') then
			ds_conta_financ_w	:= '           +++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,10,2) <> '00') then
			ds_conta_financ_w	:= '        +++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,7,2) <> '00') then
			ds_conta_financ_w	:= '     ++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,4,2) <> '00') then
			ds_conta_financ_w	:= '  + ' || ds_conta_financ_w;
		end if;
	else
		if (substr(cd_conta_apres_w,10,3) <> '000') then
			ds_conta_financ_w	:= '          - ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,7,2) <> '00') then
			ds_conta_financ_w	:= '     ++ ' || ds_conta_financ_w;
		elsif (substr(cd_conta_apres_w,4,2) <> '00') then
			ds_conta_financ_w	:= '  + ' || ds_conta_financ_w;
		end if;
	end if;

end if;

return ds_conta_financ_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_conta_financ ( cd_conta_financ_p bigint, ie_identado_p text) FROM PUBLIC;

