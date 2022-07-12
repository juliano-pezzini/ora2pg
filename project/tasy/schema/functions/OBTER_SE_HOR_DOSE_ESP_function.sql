-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_hor_dose_esp (ie_tipo_item_p text, nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ie_dose_especial_w varchar(1) := 'N';


BEGIN
if (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then
	if (ie_tipo_item_p = 'P') then
		select	coalesce(max(ie_dose_especial),'N')
		into STRICT	ie_dose_especial_w
		from	prescr_proc_hor
		where	nr_sequencia = nr_seq_horario_p
		and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
	end if;
end if;

return ie_dose_especial_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_hor_dose_esp (ie_tipo_item_p text, nr_seq_horario_p bigint) FROM PUBLIC;

