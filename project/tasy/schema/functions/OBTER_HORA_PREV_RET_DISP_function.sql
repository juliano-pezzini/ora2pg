-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hora_prev_ret_disp ( nr_seq_disp_pac_p bigint) RETURNS varchar AS $body$
DECLARE


ds_horario_w		varchar(40) := null;
dt_retirada_prev_w	timestamp;
dt_retirada_w		timestamp;


BEGIN

select	dt_retirada_prev,
	dt_retirada
into STRICT	dt_retirada_prev_w,
	dt_retirada_w
from	atend_pac_dispositivo
where	nr_sequencia	= nr_seq_disp_pac_p;

if (coalesce(dt_retirada_w::text, '') = '') and (dt_retirada_prev_w IS NOT NULL AND dt_retirada_prev_w::text <> '') and (dt_retirada_prev_w > clock_timestamp()) then
	ds_horario_w := substr(obter_dif_data(clock_timestamp(), dt_retirada_prev_w,'A'),1,40);
end if;

return	ds_horario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hora_prev_ret_disp ( nr_seq_disp_pac_p bigint) FROM PUBLIC;
