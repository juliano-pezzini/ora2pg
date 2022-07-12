-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_carteira_mascara (ds_mascara_p text, cd_carteira_p text) RETURNS varchar AS $body$
DECLARE


i		integer;
char_carteira	varchar(1);
char_mascara	varchar(1);
ie_carteira_valida_w	varchar(1)	:= 'S';


BEGIN

ie_carteira_valida_w	:= 'S';

if (ds_mascara_p IS NOT NULL AND ds_mascara_p::text <> '') and (cd_carteira_p IS NOT NULL AND cd_carteira_p::text <> '') then

	for i in 1..length(cd_carteira_p) loop
		char_carteira	:= substr(cd_carteira_p,i,1);
		char_mascara	:= substr(ds_mascara_p,i,1);

		if (coalesce(char_mascara,'X')	<> 'X') then
			if (char_carteira <> char_mascara) then
				ie_carteira_valida_w	:= 'N';
			end if;
		end if;
	end loop;
end if;

return	ie_carteira_valida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_carteira_mascara (ds_mascara_p text, cd_carteira_p text) FROM PUBLIC;

