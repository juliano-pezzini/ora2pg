-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_novo_conf (nr_prescricao_p bigint, dt_insercao_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_Retorno_W		varchar(3) := 'N';
dt_ult_lib_conf_w	timestamp;


BEGIN

select	coalesce(max(dt_lib_conferencia),clock_timestamp() + interval '1 days')
into STRICT	dt_ult_lib_conf_w
from	prescr_lib_conf_hist
where	nr_prescricao	= nr_prescricao_p;

if (coalesce(dt_insercao_p, clock_timestamp() - interval '1 days')	> dt_ult_lib_conf_w) then
	ds_retorno_W	:= 'S';
end if;

return	ds_Retorno_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_novo_conf (nr_prescricao_p bigint, dt_insercao_p timestamp) FROM PUBLIC;

