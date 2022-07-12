-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION apap_pck.obter_totais ( nr_dia_p bigint, horarios_p INOUT vetor_horarios, t_objeto_row_p INOUT t_objeto_row) AS $body$
DECLARE


qt_media_w	double precision	:= null;
qt_minima_w	double precision	:= null;
qt_maxima_w	double precision	:= null;
qt_total_w	double precision	:= 0;
qt_registros_w  bigint	:= 0;
ie_possui_reg_w	varchar(2)	:= 'N';

retorno_w	totais_t;
BEGIN

for i in 1..horarios_p.count loop
	begin
	
	if	((nr_dia_p	= 0) or --Todos os dias
		(horarios_p[i].nr_dia	= nr_dia_p)) then
		

		if (horarios_p[i](.vl_resultado IS NOT NULL AND .vl_resultado::text <> '')) then
			qt_registros_w	:= qt_registros_w  + 1;
			ie_possui_reg_w	:= 'S';
			if (coalesce(qt_minima_w::text, '') = '') or (horarios_p[i].vl_resultado	< qt_minima_w) then
				qt_minima_w	:= horarios_p[i].vl_resultado;
			end if;
			
			if (coalesce(qt_maxima_w::text, '') = '') or (horarios_p[i].vl_resultado	> qt_maxima_w) then
				qt_maxima_w	:= horarios_p[i].vl_resultado;
			end if;
			
			qt_total_w	:= qt_total_w + horarios_p[i].vl_resultado;
		elsif (horarios_p[i](.ds_resultado IS NOT NULL AND .ds_resultado::text <> '')) then
			ie_possui_reg_w	:= 'S';
		end if;
	end if;
	
	end;
end loop;

retorno_w.ie_possui_informacao	:= ie_possui_reg_w;

if (t_objeto_row_p.ie_maxima	= 'S') then
	retorno_w.qt_maxima		:= qt_maxima_w;
end if;

if (t_objeto_row_p.ie_minima	= 'S') then
	retorno_w.qt_minima		:= qt_minima_w;
end if;

if (t_objeto_row_p.ie_media	= 'S') and (qt_registros_w	> 0)then
	retorno_w.qt_media		:= dividir(qt_total_w,qt_registros_w);
end if;


if (t_objeto_row_p.ie_total	= 'S') and (qt_registros_w	> 0)then
	retorno_w.qt_total		:= qt_total_w;
end if;


return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION apap_pck.obter_totais ( nr_dia_p bigint, horarios_p INOUT vetor_horarios, t_objeto_row_p INOUT t_objeto_row) FROM PUBLIC;
