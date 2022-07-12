-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_reserva ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select	coalesce(max(ie_reserva),'S')
	into STRICT	ds_retorno_w
	from	prescr_medica a,
		prescr_solic_bco_sangue b
	where	a.nr_prescricao	= b.nr_prescricao
	and	b.nr_prescricao	= nr_prescricao_p;
else
	ds_retorno_w	:= 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_reserva ( nr_prescricao_p bigint) FROM PUBLIC;
