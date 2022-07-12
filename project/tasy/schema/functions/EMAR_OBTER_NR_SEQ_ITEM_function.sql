-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION emar_obter_nr_seq_item ( nr_seq_cpoe_p bigint, nr_prescricao_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w	bigint	:= null;


BEGIN

if (coalesce(nr_prescricao_p,0) > 0) and (coalesce(nr_seq_cpoe_p,0) > 0 ) and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '')then

	if (ie_tipo_item_p in ('M','SOL','MAT')) then

		select	max(nr_sequencia)
		into STRICT 	nr_sequencia_w
		from 	prescr_material
		where 	nr_prescricao 	= nr_prescricao_p
		and 	nr_seq_mat_cpoe	= nr_seq_cpoe_p;

	elsif (ie_tipo_item_p in ('AP','P')) then --'Procedimento, Anatomia Patológica';

		select	max(nr_sequencia)
		into STRICT 	nr_sequencia_w
		from 	prescr_procedimento
		where 	nr_prescricao 		= nr_prescricao_p
		and 	nr_seq_proc_cpoe	= nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'D') then --Dieta Oral
		select	max(nr_sequencia)
		into STRICT 	nr_sequencia_w
		from 	prescr_dieta
		where 	nr_prescricao 		= nr_prescricao_p
		and 	nr_seq_dieta_cpoe	= nr_seq_cpoe_p;

	elsif (ie_tipo_item_p in ('SNE','S')) then --Dienta Enteral/'Suplemento

		select	max(nr_sequencia)
		into 	nr_sequencia_w
		from 	prescr_material
		where 	nr_prescricao	= nr_prescricao_p
		and 	nr_seq_mat_cpoe = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'LD') then --'Leites e derivados';

		select	max(nr_sequencia)
		into 	nr_sequencia_w
		from	prescr_leite_deriv
		where 	nr_prescricao 		= nr_prescricao_p
		and 	nr_seq_dieta_cpoe	= nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'DI') then --Diálise
		select	max(nr_sequencia)
		into 	nr_sequencia_w
		from 	hd_prescricao
		where 	nr_prescricao 		= nr_prescricao_p
		and 	nr_seq_dialise_cpoe	= nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'R') then --'Recomendação';

		select	max(nr_sequencia)
		into 	nr_sequencia_w
		from 	prescr_recomendacao
		where 	nr_prescricao	= nr_prescricao_p
		and 	nr_seq_rec_cpoe = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'G') then --'Gasoterapia';

		select	max(nr_sequencia)
		into STRICT 	nr_sequencia_w
		from 	prescr_gasoterapia
		where 	nr_prescricao	= nr_prescricao_p
		and 	nr_seq_gas_cpoe	= nr_seq_cpoe_p;

	end if;

end if;

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION emar_obter_nr_seq_item ( nr_seq_cpoe_p bigint, nr_prescricao_p bigint, ie_tipo_item_p text) FROM PUBLIC;

