-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_medispan_duration ( dt_inicio_p cpoe_material.dt_inicio%type, dt_fim_p cpoe_material.dt_fim%type, ie_duracao_p cpoe_material.ie_duracao%type ) RETURNS bigint AS $body$
DECLARE

	qt_days_w	double precision;

/*
	Duration:
		return number of days, if duration is not programmed, returns zero and the API takes on 30 days
*/
BEGIN
	qt_days_w := 0;
	
	if (coalesce(ie_duracao_p, 'C') = 'P') then
		qt_days_w := coalesce(obter_dif_data(dt_inicio_p, dt_fim_p, 'TM')/60/24, 1);

		if ((qt_days_w - trunc(qt_days_w, 0)) > 0) then
			qt_days_w := trunc(qt_days_w,0 ) + 1;
		end if;

	end if;

	return qt_days_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_medispan_duration ( dt_inicio_p cpoe_material.dt_inicio%type, dt_fim_p cpoe_material.dt_fim%type, ie_duracao_p cpoe_material.ie_duracao%type ) FROM PUBLIC;

