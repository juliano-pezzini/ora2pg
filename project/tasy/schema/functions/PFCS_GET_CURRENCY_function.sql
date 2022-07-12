-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_currency (ds_locale_p text) RETURNS varchar AS $body$
DECLARE

						
ds_currency_w	varchar(10);

BEGIN

if (ds_locale_p = 'en_US') then
	ds_currency_w := '$';
else
	ds_currency_w := 'R$';
end if;

return ds_currency_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_currency (ds_locale_p text) FROM PUBLIC;

