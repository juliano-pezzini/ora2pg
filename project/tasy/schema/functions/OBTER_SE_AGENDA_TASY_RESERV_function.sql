-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_tasy_reserv ( nm_usuario_p text, hr_agenda_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_reservada_w		varchar(1) := 'N';
dt_atual_w		timestamp;
ds_datas_ocupadas_w	varchar(2000) := null;


BEGIN
if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (hr_agenda_p IS NOT NULL AND hr_agenda_p::text <> '') and (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then
	begin
	dt_atual_w	:= to_date(to_char(dt_inicial_p,'dd/mm/yyyy') || ' ' || to_char(hr_agenda_p,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

	while 	--(ie_reservada_w = 'N') and
		(dt_atual_w <= dt_final_p) loop
		begin
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_reservada_w
		from	agenda_tasy
		where	nm_usuario_agenda	= nm_usuario_p
		and	dt_agenda 		= dt_atual_w
		and	ie_status 		= 'M';

		if (ie_reservada_w = 'S') then
			begin
			if (coalesce(ds_datas_ocupadas_w::text, '') = '') then
				begin
				ds_datas_ocupadas_w	:= to_char(dt_atual_w,'dd/mm');
				end;
			else
				begin
				ds_datas_ocupadas_w	:= ds_datas_ocupadas_w || '  ' || to_char(dt_atual_w,'dd/mm');
				end;
			end if;
			end;
		end if;

		dt_atual_w	:= dt_atual_w + 1;
		end;
	end loop;
	end;
end if;

return ds_datas_ocupadas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_tasy_reserv ( nm_usuario_p text, hr_agenda_p timestamp, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;
