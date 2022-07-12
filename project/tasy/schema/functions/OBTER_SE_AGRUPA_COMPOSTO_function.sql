-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agrupa_composto ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_agrupamento_p bigint, cd_material_p bigint) RETURNS char AS $body$
DECLARE


ie_retorno_w		char(1) := 'N';



BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (nr_agrupamento_p IS NOT NULL AND nr_agrupamento_p::text <> '') then

	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	prescr_material where		ie_agrupador	= 1
	and		nr_agrupamento	= nr_agrupamento_p
	and		nr_sequencia	<> nr_seq_material_p
	and		nr_prescricao	= nr_prescricao_p LIMIT 1;

	if (ie_retorno_w = 'S') then
		select	coalesce(max('S'), 'N')
		into STRICT	ie_retorno_w
		from	prescr_material where		nr_agrupamento	<> nr_agrupamento_p
		and		nr_sequencia	<> nr_seq_material_p
		and		obter_se_medic_composto(nr_prescricao_p, nr_sequencia, nr_agrupamento) = 'N'
		and		ie_agrupador	= 1
		and		cd_material	= cd_material_p
		and		nr_prescricao	= nr_prescricao_p LIMIT 1;
	end if;

end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agrupa_composto ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_agrupamento_p bigint, cd_material_p bigint) FROM PUBLIC;
