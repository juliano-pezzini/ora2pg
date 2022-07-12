-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_data_prev_intervalo (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_origem_p bigint, dt_prev_execucao_p timestamp, ie_opcao_p bigint) RETURNS timestamp AS $body$
DECLARE

ds_retorno_w			timestamp;
qt_origem_prescr_w		integer;

BEGIN

if (nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '') then

	ds_retorno_w := dt_prev_execucao_p;

else

	select 	count(*)
	into STRICT	qt_origem_prescr_w
	from	prescr_Procedimento
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_seq_origem	= nr_seq_prescr_p;

	if (qt_origem_prescr_w > 0) then
		ds_retorno_w := dt_prev_execucao_p;
	end if;

end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_data_prev_intervalo (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_origem_p bigint, dt_prev_execucao_p timestamp, ie_opcao_p bigint) FROM PUBLIC;

