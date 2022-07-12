-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_tap_reserva ( nr_prescricao_p bigint, ie_tipo_tap_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	double precision;
-- T = TAP em %

-- I = INR
BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ie_tipo_tap_p IS NOT NULL AND ie_tipo_tap_p::text <> '') then
	if (ie_tipo_tap_p = 'T') then
	select	max(qt_tap)
		into STRICT	ds_retorno_w
		from	prescr_solic_bco_sangue
		where	nr_prescricao = nr_prescricao_p;
	elsif (ie_tipo_tap_p = 'I') then
		select	max(qt_tap_inr)
		into STRICT	ds_retorno_w
		from	prescr_solic_bco_sangue
		where	nr_prescricao = nr_prescricao_p;
	end if;
end if;	

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_tap_reserva ( nr_prescricao_p bigint, ie_tipo_tap_p text) FROM PUBLIC;

