-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_macro_junit (texto_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(4000);

function get_tipo_operacao(spplited_texto_p text)
return text as
;
BEGIN
return coalesce(REGEXP_SUBSTR(spplited_texto_p, '[+-/*//]',1,1),'N');
end;

begin
/*
case get_tipo_operacao(texto_p)
	when '+' then
	when '-' then
	when '*' then
	when '/' then
	else
end case;
*/
if (position('@' in texto_p) >  0) then

	case
		when(position('@DATA_HORA' in texto_p) > 0) then
			case get_tipo_operacao(texto_p)
				when '+' then
					return to_char(clock_timestamp() + SUBSTR( texto_p ,position('+' in texto_p )+1,LENGTH(texto_p)),'DD/MM/YYYY HH24:MI:SS');
				when '-' then
					return to_char(clock_timestamp() - SUBSTR( texto_p ,position('-' in texto_p )+1,LENGTH(texto_p)),'DD/MM/YYYY HH24:MI:SS');
				else
					return to_char(clock_timestamp(),'DD/MM/YYYY HH24:MI:SS');
			end case;

		when(position('@DATA' in texto_p) > 0) then
			case get_tipo_operacao(texto_p)
				when '+' then
					return to_char(clock_timestamp() + SUBSTR( texto_p ,position('+' in texto_p )+1,LENGTH(texto_p)),'DD/MM/YYYY');
				when '-' then
					return to_char(clock_timestamp() - SUBSTR( texto_p ,position('-' in texto_p )+1,LENGTH(texto_p)),'DD/MM/YYYY');
				else
					return to_char(clock_timestamp(),'DD/MM/YYYY');
			end case;

		else
			return texto_p;
		end case;

end if;

return texto_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_macro_junit (texto_p text) FROM PUBLIC;

