-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_tipo_entrega_medic_item (nr_seq_fa_entrega_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE

ie_entrega_pmc_w	varchar(2)  := 'N';
ie_tipo_entrega_w	varchar(3) := 'N';

BEGIN
if (nr_seq_fa_entrega_p IS NOT NULL AND nr_seq_fa_entrega_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	SELECT 	CASE WHEN coalesce(nr_seq_paciente_pmc::text, '') = '' THEN 'N'  ELSE 'S' END
	into STRICT	ie_entrega_pmc_w
	FROM 	fa_paciente_entrega b,
		fa_entrega_medicacao a
	WHERE 	b.nr_sequencia = a.nr_seq_paciente_entrega
	AND	a.nr_sequencia = nr_seq_fa_entrega_p;

	if (ie_entrega_pmc_w = 'S') then

		select	CASE WHEN coalesce(ie_medicamento_pmc,'N')='S' THEN 'PMC'  ELSE CASE WHEN coalesce(ie_nutricao,'N')='S' THEN 'PNC'  ELSE substr(fa_obter_se_medic_pac_pmc(nr_seq_fa_entrega_p,cd_material_p),1,1) END  END
		into STRICT	ie_tipo_entrega_w
		from	fa_medic_farmacia_amb
		where	cd_material	= cd_material_p;

	end if;


end if;

return	ie_tipo_entrega_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_tipo_entrega_medic_item (nr_seq_fa_entrega_p bigint, cd_material_p bigint) FROM PUBLIC;

