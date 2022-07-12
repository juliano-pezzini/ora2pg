-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gerar_item_ged ( ie_tipo_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_agrupamento_p bigint, ie_superior_p text, nr_seq_kit_p bigint, ie_agrupador_p bigint) RETURNS varchar AS $body$
DECLARE


ie_gerar_adep_w	varchar(1) := 'S';


BEGIN
if (nr_agrupamento_p IS NOT NULL AND nr_agrupamento_p::text <> '') and (ie_tipo_item_p = 'M') and (ie_agrupador_p = 1) then

	if (coalesce(ie_superior_p,'N') = 'S') then
			ie_gerar_adep_w	:= 'S';
	elsif (coalesce(nr_seq_kit_p,0) > 0) then
			ie_gerar_adep_w	:= 'N';
	else
			select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
			into STRICT	ie_gerar_adep_w
			from	prescr_material b
			where	b.nr_prescricao		= nr_prescricao_p
			and		b.nr_agrupamento	= nr_agrupamento_p
			and		b.ie_agrupador		= 1
			and		coalesce(b.ie_suspenso,'N')	<> 'S'
			and		exists (	SELECT	1
								from	prescr_material x
								where	x.nr_prescricao 	= b.nr_prescricao
								and		x.nr_sequencia		<> nr_seq_item_p
								and		x.nr_agrupamento	= b.nr_agrupamento
								and		x.ie_agrupador		= 1
								and		x.ie_item_superior		= 'S');
	end if;
end if;

return ie_gerar_adep_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gerar_item_ged ( ie_tipo_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_agrupamento_p bigint, ie_superior_p text, nr_seq_kit_p bigint, ie_agrupador_p bigint) FROM PUBLIC;
