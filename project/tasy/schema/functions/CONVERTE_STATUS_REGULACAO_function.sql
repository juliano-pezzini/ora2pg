-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_status_regulacao ( ie_status_p text, ie_conversao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(10);


BEGIN


if (ie_conversao_p = 'REG') then

	if (ie_status_p = 7) then

		ds_retorno_w := 'NG';

	elsif (ie_status_p = 1) then

		ds_retorno_w := 'EN';

	elsif (ie_status_p in (2,9))then

		ds_retorno_w := 'AT';

	elsif (ie_status_p = 3) then

		ds_retorno_w := 'CA';

	elsif (ie_status_p in (4,5,6,8)) then

		ds_retorno_w := 'AN';

	elsif (ie_status_p = 10) then

		ds_retorno_w := 'PS';

	end if;


end if;

if (ie_conversao_p = 'PLS') then

	if (ie_status_p = 'NG') then

		ds_retorno_w := 7;

	elsif (ie_status_p = 'CA') then

		ds_retorno_w := 3;

	elsif (ie_status_p = 'EN') then

		ds_retorno_w := 1;

	end if;

end if;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_status_regulacao ( ie_status_p text, ie_conversao_p text) FROM PUBLIC;

