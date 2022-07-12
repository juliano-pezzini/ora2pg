-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_calcular_recorr ( dt_inicio_p timestamp, qt_total_recorr_p bigint, ie_forma_geracao_p text, ie_final_semana_p text, ds_dia_semana_p text) RETURNS timestamp AS $body$
DECLARE


qt_dia_w		bigint;
dt_inicio_w		timestamp;
ie_dia_semana_w	varchar(3);
dt_diaria_w		timestamp;
ds_dia_semana_w varchar(2000);


BEGIN

ds_dia_semana_w := REPLACE(ds_dia_semana_p,' ','');

if	(ie_forma_geracao_p	= 'D' AND ds_dia_semana_w IS NOT NULL AND ds_dia_semana_w::text <> '') or (coalesce(ie_forma_geracao_p,'X')	= 'X' and
	ie_final_semana_p	= 'S') then
	qt_dia_w	:= 0;
else
	qt_dia_w	:= 1;
end if;
dt_inicio_w	:= dt_inicio_p;

while(qt_dia_w	< qt_total_recorr_p) loop
	begin
	if (ie_forma_geracao_p	= 'D') then
		if (coalesce(ds_dia_semana_w::text, '') = '') then
			qt_dia_w	:= qt_dia_w + 1;
			dt_inicio_w		:= dt_inicio_w + 1;
		else
			ie_dia_semana_w	:= obter_cod_dia_semana(dt_inicio_w);			
			if (obter_se_contido_char(ie_dia_Semana_w, ds_dia_semana_w)	= 'S') then
				dt_diaria_w	:= dt_inicio_w;
				qt_dia_w	:= qt_dia_w	+ 1;								
			end if;			
			dt_inicio_w		:= dt_inicio_w + 1;
		end if;
	elsif (coalesce(ie_forma_geracao_p,'X') = 'X') and (ie_final_semana_p	= 'S') then
		ie_dia_semana_w	:= obter_cod_dia_semana(dt_inicio_w);
		if (ie_dia_semana_w = '7') or (ie_dia_semana_w = '1') then
			dt_diaria_w	:= dt_inicio_w;
			qt_dia_w	:= qt_dia_w	+ 1;								
		end if;
		dt_inicio_w		:= dt_inicio_w + 1;
	else
		dt_inicio_w	:= dt_inicio_w	+ 7;
		qt_dia_w	:= qt_dia_w + 1;
	end if;
	end;
end loop;

if (dt_diaria_w IS NOT NULL AND dt_diaria_w::text <> '') then
	dt_inicio_w	:= dt_diaria_w;
end if;

return	dt_inicio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_calcular_recorr ( dt_inicio_p timestamp, qt_total_recorr_p bigint, ie_forma_geracao_p text, ie_final_semana_p text, ds_dia_semana_p text) FROM PUBLIC;

