-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_interv_item_rep (nr_prescricao_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


cd_intervalo_w	varchar(7);


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') then

	if (ie_tipo_item_p in ('S','M','MAT','IA','IAG')) then

		select	coalesce(max(cd_intervalo),'XPTO')
		into STRICT	cd_intervalo_w
		from	prescr_material
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	elsif (ie_tipo_item_p in ('P','G','C','I','HM','H')) then

		select	coalesce(max(cd_intervalo),'XPTO')
		into STRICT	cd_intervalo_w
		from	prescr_procedimento
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	elsif (ie_tipo_item_p = 'R') then

		select	coalesce(max(cd_intervalo),'XPTO')
		into STRICT	cd_intervalo_w
		from	prescr_recomendacao
		where	nr_prescricao 	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	elsif (ie_tipo_item_p = 'E') then

		select	coalesce(max(cd_intervalo),'XPTO')
		into STRICT	cd_intervalo_w
		from	pe_prescr_proc
		where	nr_seq_prescr	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;
		
	elsif (ie_tipo_item_p = 'D') then

		select	coalesce(max(cd_intervalo),'XPTO')
		into STRICT	cd_intervalo_w
		from	prescr_dieta
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia	= nr_seq_item_p;

	end if;

end if;

return cd_intervalo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_interv_item_rep (nr_prescricao_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text) FROM PUBLIC;
