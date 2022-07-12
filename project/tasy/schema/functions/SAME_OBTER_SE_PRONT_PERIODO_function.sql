-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION same_obter_se_pront_periodo ( nr_seq_prontuario_p bigint, dt_inicio_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
dt_atual_w		timestamp;
ie_retorno_w		varchar(1)	:= 'N';


BEGIN

select	dt_periodo_inicial,
	coalesce(dt_periodo_final,clock_timestamp())
into STRICT	dt_periodo_inicial_w,
	dt_periodo_final_w
from	same_prontuario
where	nr_sequencia	= nr_seq_prontuario_p;

if (dt_periodo_inicial_w IS NOT NULL AND dt_periodo_inicial_w::text <> '') then

	dt_atual_w	:= dt_inicio_p;

	while (dt_atual_w <= dt_final_p AND ie_retorno_w = 'N') loop

		if (dt_atual_w >= dt_periodo_inicial_w) and (dt_atual_w <= dt_periodo_final_w) then
			ie_retorno_w	:= 'S';
		end if;
		dt_atual_w		:= dt_atual_w + 1;

	end loop;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION same_obter_se_pront_periodo ( nr_seq_prontuario_p bigint, dt_inicio_p timestamp, dt_final_p timestamp) FROM PUBLIC;

