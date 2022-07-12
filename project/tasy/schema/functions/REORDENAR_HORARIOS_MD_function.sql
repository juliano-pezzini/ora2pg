-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reordenar_horarios_md ( dt_Hora_Inicio_p timestamp, ds_horarios_p text ) RETURNS varchar AS $body$
DECLARE

    hr_inicio_w		integer;
    hr_prime_w		integer;
    ie_minuto_w		smallint := 0;
    hr_menor_w		integer := -1;
    ds_validos_w		varchar(20) := '1234567890: ';
    X			varchar(1);
    i			integer;
    ie_ok_w			varchar(1) := 'S';
    ds_horarios_w		varchar(2000);
    ds_horarios_ww		varchar(2000);
    ds_erro_w		varchar(2000);

BEGIN

begin

if (substr(ds_horarios_p,1,1) = ' ') and (substr(ds_horarios_p,2,1) <> ' ') then
	ds_horarios_ww  := substr(ds_horarios_p,2,length(ds_horarios_p));
else
	ds_horarios_ww	:= ds_horarios_p;
end if;

ds_horarios_w	:= limpa_espacos_entre(ds_horarios_ww);

if (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '') then
	begin
	FOR i IN 1..length(ds_horarios_w) LOOP
		X	:= substr(ds_horarios_w, i, 1);
		if (position(X in ds_validos_w) = 0) then
			ie_ok_w	:= 'N';
			exit;
		end if;
	END LOOP;
	end;
end if;

if	((ds_horarios_w <> '') or (ds_horarios_w IS NOT NULL AND ds_horarios_w::text <> '')) and (ds_horarios_w not in ('ACM','SN')) and (ds_horarios_w <> ' ') and (ie_ok_w = 'S') then

	ie_minuto_w := (position(':' in substr(ds_horarios_w,1,6)))::numeric;

	for i in 1.. 25 LOOP
		begin
		hr_inicio_w	:= (substr(ds_horarios_w,1,2))::numeric;
		if (to_char(dt_Hora_Inicio_p,'mi') <> '00') and (ie_minuto_w = 0) then
			hr_prime_w	:= (to_char(dt_Hora_Inicio_p + 1/24,'hh24'))::numeric;
		else
			hr_prime_w	:= (to_char(dt_Hora_Inicio_p,'hh24'))::numeric;
		end if;
		if (hr_inicio_w < hr_prime_w) and (length(ds_horarios_w) > 4) and (hr_menor_w < hr_inicio_w) then
			hr_menor_w	:= hr_inicio_w;
			if (ie_minuto_w = 0) then
				if (hr_inicio_w < 10) then
					ds_horarios_w := substr(ds_horarios_w,4,length(ds_horarios_w)-2) || ' 0'|| hr_inicio_w;
				else
					ds_horarios_w := substr(ds_horarios_w,4,length(ds_horarios_w)-2) || ' '|| hr_inicio_w;
				end if;
			elsif (length(ds_horarios_w) > 5) then
				if (hr_inicio_w < 10) then
					ds_horarios_w := substr(ds_horarios_w,7,length(ds_horarios_w)-5) || ' 0'|| hr_inicio_w ||substr(ds_horarios_w,3,3);
				else
					ds_horarios_w := substr(ds_horarios_w,7,length(ds_horarios_w)-5) || ' '|| hr_inicio_w ||substr(ds_horarios_w,3,3);
				end if;
			end if;
	        end if;
		end;
	end loop;
end if;

exception when others then
	ds_erro_w	:= '';
end;

RETURN ds_horarios_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reordenar_horarios_md ( dt_Hora_Inicio_p timestamp, ds_horarios_p text ) FROM PUBLIC;

