-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_dispositivo ( nr_sequencia_p bigint, qt_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_disp_w	varchar(1);
dt_retirada_w	timestamp;
dt_retirada_prev_w	timestamp;


BEGIN

select	dt_retirada,
	dt_retirada_prev
into STRICT	dt_retirada_w,
	dt_retirada_prev_w
from	atend_pac_dispositivo
where	nr_sequencia = nr_sequencia_p;

if (coalesce(dt_retirada_w::text, '') = '') and (dt_retirada_prev_w IS NOT NULL AND dt_retirada_prev_w::text <> '') and (dt_retirada_prev_w <= clock_timestamp()) then
	ie_status_disp_w	:= 'V';
elsif (coalesce(dt_retirada_w::text, '') = '') and (dt_retirada_prev_w IS NOT NULL AND dt_retirada_prev_w::text <> '') and (dt_retirada_prev_w > clock_timestamp()) and (dt_retirada_prev_w <= (clock_timestamp() + (qt_horario_p/24))) then
	ie_status_disp_w	:= 'E';
elsif (coalesce(dt_retirada_w::text, '') = '') then
	ie_status_disp_w	:= 'A';
elsif (dt_retirada_w IS NOT NULL AND dt_retirada_w::text <> '') then
	ie_status_disp_w	:= 'R';
end if;

return	ie_status_disp_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_dispositivo ( nr_sequencia_p bigint, qt_horario_p bigint) FROM PUBLIC;

