-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_vol_alter ( nr_seq_prod_reserva_p bigint, ie_tipo_volume_p text) RETURNS bigint AS $body$
DECLARE

qt_volume_w		double precision;

/*
Tipos de volume
VINF	= Volume infundido
VDESP	= Volume desprezado
VFASE	= Volume por etapa
*/
BEGIN

if (ie_tipo_volume_p = 'VINF') then

	select	sum(coalesce(qt_vol_infundido,0))
	into STRICT	qt_volume_w
	from	prescr_solucao_evento
	where	nr_seq_prod_reserva = nr_seq_prod_reserva_p
	and	ie_evento_valido = 'S';

elsif (ie_tipo_volume_p = 'VDESP') then

	select	sum(coalesce(qt_vol_desprezado,0))
	into STRICT	qt_volume_w
	from	prescr_solucao_evento
	where	nr_seq_prod_reserva = nr_seq_prod_reserva_p
	and	ie_evento_valido = 'S';

elsif (ie_tipo_volume_p = 'VFASE') then

	select	coalesce(max(qt_volume_fase),0)
	into STRICT	qt_volume_w
	from	prescr_solucao_evento
	where	nr_seq_prod_reserva = nr_seq_prod_reserva_p
	and	ie_evento_valido = 'S';

end if;

return	coalesce(qt_volume_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_vol_alter ( nr_seq_prod_reserva_p bigint, ie_tipo_volume_p text) FROM PUBLIC;

