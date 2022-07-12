-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_limite_regra_proc_agenda (dt_agenda_p timestamp, ie_regra_p text, ie_periodo_p text) RETURNS timestamp AS $body$
DECLARE


dt_limite_w     timestamp;


BEGIN
if (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (ie_regra_p IS NOT NULL AND ie_regra_p::text <> '') then

	if (ie_periodo_p = 'I') then
		if (ie_regra_p = 'D') then
        	        dt_limite_w := trunc(dt_agenda_p,'dd');

	        elsif (ie_regra_p = 'S') then
        	        dt_limite_w := obter_inicio_fim_semana(dt_agenda_p,'I');

	        elsif (ie_regra_p = 'M') then
        	        dt_limite_w := trunc(dt_agenda_p,'mm');
        	end if;
	elsif (ie_periodo_p = 'F') then
		if (ie_regra_p = 'D') then
        	        dt_limite_w := trunc(dt_agenda_p,'dd');

	        elsif (ie_regra_p = 'S') then
        	        dt_limite_w := obter_inicio_fim_semana(dt_agenda_p,'F');

	        elsif (ie_regra_p = 'M') then
        	        dt_limite_w := trunc(last_day(dt_agenda_p),'dd');
        	end if;

	end if;
end if;

return  dt_limite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_limite_regra_proc_agenda (dt_agenda_p timestamp, ie_regra_p text, ie_periodo_p text) FROM PUBLIC;

