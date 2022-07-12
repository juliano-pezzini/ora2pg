-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_elimina_carac_espec_zero (ds_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_retorno_ww		varchar(255);
i			integer;
ie_inicio_numero_w	varchar(1)	:= 'N';


BEGIN

select	substr(replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	Elimina_Acentuacao(ds_campo_p),
					'&','e'),
					'<',''),
					'º',''),
					'°',''),
					'ª',''),
					'"',''),
					'>',''),1,255)
into STRICT	ds_retorno_w
;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	begin

	for	i in 1 .. length(ds_retorno_w) loop
		begin
		if	not(substr(ds_retorno_w,i,1) in ('-','.',',','/','\','''')) then
			if (substr(ds_retorno_w,i,1) = '0') and (ie_inicio_numero_w = 'N') then
				ds_retorno_ww := ds_retorno_ww;
			else
				ds_retorno_ww		:= ds_retorno_ww || substr(ds_retorno_w,i,1);
				ie_inicio_numero_w 	:= 'S';
			end if;
		end if;
		end;
	end loop;
	end;
end if;

return	ds_retorno_ww;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_elimina_carac_espec_zero (ds_campo_p text) FROM PUBLIC;

