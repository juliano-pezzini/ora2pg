-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_data_ult_reval ( nr_seq_cpoe_p bigint, ie_tipo_item_p text) RETURNS timestamp AS $body$
DECLARE


dt_validacao_w	cpoe_revalidation_events.dt_validacao%type;


BEGIN

if (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '' AND ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') then

	if (ie_tipo_item_p = 'N') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_diet = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'H') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_hemotherapy = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'D' or ie_tipo_item_p = 'DI' or ie_tipo_item_p = 'DP') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_dialysis = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'G') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_gasotherapy = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'M' or ie_tipo_item_p = 'MA') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_material = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'R') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_recomendation = nr_seq_cpoe_p;

	elsif (ie_tipo_item_p = 'P') then

		select	max(dt_validacao)
		into STRICT	dt_validacao_w
		from 	cpoe_revalidation_events
		where	nr_seq_exam = nr_seq_cpoe_p;

	end if;

end if;

return dt_validacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_data_ult_reval ( nr_seq_cpoe_p bigint, ie_tipo_item_p text) FROM PUBLIC;

