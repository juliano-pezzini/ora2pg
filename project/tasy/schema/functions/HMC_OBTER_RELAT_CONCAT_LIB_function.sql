-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hmc_obter_relat_concat_lib ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp ) RETURNS varchar AS $body$
DECLARE


ds_temp_w		varchar(4000);
ds_retorno_w 	varchar(4000);
posicao_w 		varchar(4000);

C01 CURSOR FOR
SELECT 	w.nr_prescricao
from	prescr_medica w
WHERE w.nr_atendimento = nr_atendimento_p
AND	((w.dt_inicio_prescr BETWEEN dt_inicio_p AND dt_fim_p) OR (w.dt_validade_prescr BETWEEN dt_inicio_p AND dt_fim_p))
and w.dt_liberacao is  null
and coalesce(w.dt_liberacao_medico::text, '') = ''
order by w.nr_prescricao desc;

BEGIN

open 	c01;
	loop
	fetch 	c01 into
	ds_temp_w;

	if	((coalesce(ds_retorno_w::text, '') = '') or (position(ds_temp_w in ds_retorno_w) = 0)) then
		ds_retorno_w := ds_retorno_w ||','|| ds_temp_w;
	end if;
	EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

select length(ds_retorno_w)
into STRICT posicao_w
;

return	substr(ds_retorno_w,2,posicao_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hmc_obter_relat_concat_lib ( nr_atendimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp ) FROM PUBLIC;
