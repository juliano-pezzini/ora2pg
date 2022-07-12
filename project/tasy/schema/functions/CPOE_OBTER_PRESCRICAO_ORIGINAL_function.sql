-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_prescricao_original (nr_sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_prescr_retorno_w bigint := 0;
nr_pres_original_w	bigint := 0;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_sequencia_p > 0 ) and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_atendimento_p > 0) then
		
	if (ie_tipo_item_p = 'M') or (ie_tipo_item_p = 'MA')then --Medicamento
		select  coalesce(min(a.nr_prescricao),0)
		into STRICT	nr_pres_original_w
		from  	prescr_material a
		where  	a.nr_seq_mat_cpoe = nr_sequencia_p;

	elsif (ie_tipo_item_p = 'N') then --Nutricao
		select	coalesce(min(a.nr_prescricao),0)		--Oral
		into STRICT	nr_pres_original_w
		from	prescr_dieta a
		where	a.nr_seq_dieta_cpoe = nr_sequencia_p;
		
		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0)	--Enteral
				into STRICT	nr_pres_original_w
				from	prescr_material	a
				where   nr_seq_dieta_cpoe = nr_sequencia_p
				and		a.ie_agrupador = 8;
		end if;		

		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0) --Jejum
				into STRICT	nr_pres_original_w
				from	rep_jejum a
				where	a.nr_seq_dieta_cpoe = nr_sequencia_p;

		end if;				
		
		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0) --Suplemento
				into STRICT	nr_pres_original_w
				from	prescr_material a
				where   a.nr_seq_dieta_cpoe = nr_sequencia_p
				and		a.ie_agrupador = 12;

		end if;
		
		
		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0) --Leites e Derivados
				into STRICT	nr_pres_original_w
				from	prescr_leite_deriv a
				where   a.nr_seq_dieta_cpoe = nr_sequencia_p;	

		end if;
		
		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0) --Parenteral Infantil 
				into STRICT	nr_pres_original_w
				from	nut_pac a
				where   a.nr_seq_npt_cpoe = nr_sequencia_p
				and 	a.ie_npt_adulta = 'P';
		end if;
		
		if (coalesce(nr_pres_original_w::text, '') = '') or (nr_pres_original_w = 0) then

				select	coalesce(min(a.nr_prescricao),0)	--Parenteral Adulto
				into STRICT	nr_pres_original_w
				from	nut_pac a,
						prescr_medica b		
				where   a.nr_seq_npt_cpoe = nr_sequencia_p
				and 	a.ie_npt_adulta = 'S';

		end if;		

		
	elsif (ie_tipo_item_p = 'R') then	

		select	coalesce(min(a.nr_prescricao),0)		--Recomendacao
		into STRICT	nr_pres_original_w
		from	prescr_recomendacao a
		where   a.nr_seq_rec_cpoe = nr_sequencia_p;

	elsif (ie_tipo_item_p = 'G') then --Gasoterapia
		select	coalesce(min(a.nr_prescricao),0)	
		into STRICT	nr_pres_original_w
		from	prescr_gasoterapia a
		where   a.nr_seq_gas_cpoe = nr_sequencia_p;

	elsif (ie_tipo_item_p = 'P') then --Procedimento
		select	coalesce(min(a.nr_prescricao),0)	
		into STRICT	nr_pres_original_w
		from	prescr_procedimento a
		where   a.nr_seq_proc_cpoe = nr_sequencia_p;

	elsif (ie_tipo_item_p = 'D') then --Dialise
		select	coalesce(min(a.nr_prescricao),0)	
		into STRICT	nr_pres_original_w
		from	hd_prescricao a
		where   a.nr_seq_dialise_cpoe = nr_sequencia_p;

	end if;
	
	if (nr_pres_original_w > 0 ) then		
		nr_prescr_retorno_w := nr_pres_original_w;
	else
		nr_prescr_retorno_w := null;
	end if;
	
end if;	

return	nr_prescr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_prescricao_original (nr_sequencia_p bigint, ie_tipo_item_p text, nr_atendimento_p bigint) FROM PUBLIC;
