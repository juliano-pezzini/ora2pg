-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_w_item_prescr_gas (cd_protocolo_p bigint, nr_seq_item_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_gas_p bigint, ie_Origem_inf_p text, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	double precision := null;


BEGIN
if (ie_origem_inf_p = 'O') then
	select  coalesce(max(qt_dose),0)
	into STRICT	qt_retorno_w
	from 	W_item_prescr
	where	cd_protocolo  	= cd_protocolo_p
	and		nr_seq_item   	= nr_seq_item_p
	and		nr_prescricao 	= nr_prescricao_p
	and 	nr_seq_material = nr_seq_material_p
	and 	ie_origem_inf 	= ie_origem_inf_p
	and		nm_usuario 		= nm_usuario_p;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_w_item_prescr_gas (cd_protocolo_p bigint, nr_seq_item_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_gas_p bigint, ie_Origem_inf_p text, nm_usuario_p text) FROM PUBLIC;

