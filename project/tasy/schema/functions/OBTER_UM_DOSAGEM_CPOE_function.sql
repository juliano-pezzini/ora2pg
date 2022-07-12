-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_um_dosagem_cpoe (ie_tipo_item_p text, nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w		prescr_material.nr_prescricao%type;
nr_seq_item_w		prescr_material.nr_sequencia%type;


BEGIN

if (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '') then

	nr_prescricao_w := coalesce(Obter_Nr_Prescr_Seq_Cpoe(ie_tipo_item_p, nr_seq_cpoe_p),0);

	if (nr_prescricao_w > 0) then

		if (ie_tipo_item_p in ('IAH', 'M', 'MAT', 'SOL')) then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_item_w
			from	prescr_material
			where	nr_seq_mat_cpoe = nr_seq_cpoe_p;
		elsif (ie_tipo_item_p in ('S', 'SNE')) then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_item_w
			from	prescr_material
			where	nr_seq_dieta_cpoe = nr_seq_cpoe_p;
		elsif (ie_tipo_item_p in ('P', 'L', 'HM', 'CIG', 'CCG')) then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_item_w
			from	prescr_procedimento
			where	nr_seq_proc_cpoe = nr_seq_cpoe_p;
		elsif (ie_tipo_item_p = 'O') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_item_w
			from	prescr_gasoterapia
			where	nr_seq_gas_cpoe = nr_seq_cpoe_p;
		elsif (ie_tipo_item_p = 'R') then
			select 	max(nr_sequencia)
			into STRICT	nr_seq_item_w
			from	prescr_recomendacao
			where	nr_seq_rec_cpoe = nr_seq_cpoe_p;
		elsif (ie_tipo_item_p = 'D') then
			select 	max(nr_seq_solucao)
			into STRICT	nr_seq_item_w
			from	prescr_solucao
			where	nr_seq_dialise_cpoe = nr_seq_cpoe_p;
		else
			nr_seq_item_w := 0;
		end if;

	else
		nr_seq_item_w := 0;
	end if;

else
	nr_prescricao_w := 0;
	nr_seq_item_w := 0;
end if;

return Obter_UM_Dosagem_Prescr(nr_prescricao_w, nr_seq_item_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_um_dosagem_cpoe (ie_tipo_item_p text, nr_seq_cpoe_p bigint) FROM PUBLIC;

