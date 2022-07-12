-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION comparar_data ( dt_um_p timestamp, dt_dois_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1) := 'N';


BEGIN

case ie_opcao_p
		when 1 then
			if (coalesce(dt_dois_p,clock_timestamp()) = coalesce(dt_um_p,clock_timestamp())) then
				ie_retorno_w:= 'S';
			else
				ie_retorno_w:= 'N';
			end if;

		when 2 then
			if (coalesce(dt_dois_p,clock_timestamp()) > coalesce(dt_um_p,clock_timestamp())) then
				ie_retorno_w:= 'S';
			else
				ie_retorno_w:= 'N';
			end if;
		when 3 then
			if (coalesce(dt_dois_p,clock_timestamp()) < coalesce(dt_um_p,clock_timestamp())) then
				ie_retorno_w:= 'S';
			else
				ie_retorno_w:= 'N';
			end if;
end case;

/*if	(nvl(dt_dois_p,sysdate) = nvl(dt_um_p,sysdate)) then
	return	'S';
else
	return	'N';
end if;
*/
return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION comparar_data ( dt_um_p timestamp, dt_dois_p timestamp, ie_opcao_p text) FROM PUBLIC;
