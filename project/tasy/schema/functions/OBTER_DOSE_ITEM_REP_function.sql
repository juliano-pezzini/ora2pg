-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dose_item_rep ( nr_prescricao_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, ie_dose_especial_p text) RETURNS bigint AS $body$
DECLARE


qt_dose_w		double precision;
qt_dose_especial_w	double precision;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') then

	if (ie_tipo_item_p in ('S','M','MAT','IA','IAG')) then

		select	coalesce(max(qt_dose),1),
			coalesce(max(qt_dose_especial),1)
		into STRICT	qt_dose_w,
			qt_dose_especial_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	elsif (ie_tipo_item_p in ('P','G','C','I')) then

		select	coalesce(max(qt_procedimento),1)
		into STRICT	qt_dose_w
		from	prescr_procedimento
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	elsif (ie_tipo_item_p = 'R') then

		select	coalesce(max(qt_recomendacao),1)
		into STRICT	qt_dose_w
		from	prescr_recomendacao
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	end if;

end if;
if (coalesce(ie_dose_especial_p,'N')	= 'S') then
	return qt_dose_especial_w;
else
	return qt_dose_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dose_item_rep ( nr_prescricao_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, ie_dose_especial_p text) FROM PUBLIC;

