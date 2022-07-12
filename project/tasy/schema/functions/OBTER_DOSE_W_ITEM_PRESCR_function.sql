-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_w_item_prescr (nr_seq_item_p bigint, nr_prescricao_p bigint, ie_Origem_inf_p text) RETURNS bigint AS $body$
DECLARE

qt_retorno_w	double precision := null;


BEGIN
if (ie_origem_inf_p in ('P', 'PI', 'PVPi')) then
	select  max(qt_dose)
	into STRICT	qt_retorno_w
	from 	W_item_prescr
	where	nr_seq_item   = nr_seq_item_p
	and	nr_prescricao = nr_prescricao_p
	and	ie_Origem_inf = ie_Origem_inf_p;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_w_item_prescr (nr_seq_item_p bigint, nr_prescricao_p bigint, ie_Origem_inf_p text) FROM PUBLIC;
