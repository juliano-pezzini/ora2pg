-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_item_prescr ( cd_protocolo_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_solucao_p bigint, nr_seq_gas_p bigint, nr_seq_material_p bigint, qt_dose_p bigint, ie_origem_inf_p text, cd_unidade_medida_p text) AS $body$
DECLARE


ie_inserido_w	varchar(1) := 'N';
nr_next_sequencia_w	bigint;

BEGIN

if (ie_origem_inf_p = 'SOL') then /*Solução*/
	select 	coalesce(max('S'), 'N')
	into STRICT	ie_inserido_w
	from	W_Item_Prescr
	where	cd_protocolo 	= cd_protocolo_p
	and 	nr_seq_item 	= nr_seq_item_p
	and 	nr_seq_solucao	= nr_seq_solucao_p
	and 	nr_prescricao	= nr_prescricao_p
	and		nm_usuario	    = nm_usuario_p
	and 	nr_seq_material	= nr_seq_material_p
	and 	ie_origem_inf   = ie_origem_inf_p;

	if (ie_inserido_w = 'S') then
		delete from W_Item_Prescr
		where	cd_protocolo 	= cd_protocolo_p
		and 	nr_seq_item 	= nr_seq_item_p
		and 	nr_seq_solucao	= nr_seq_solucao_p
		and 	nr_prescricao	= nr_prescricao_p
		and		nm_usuario	 	= nm_usuario_p
		and 	nr_seq_material	= nr_seq_material_p
		and 	ie_origem_inf   = ie_origem_inf_p;
		commit;
	end if;
elsif (ie_origem_inf_p = 'M') then /*Medicamentos compostos*/
	select 	coalesce(max('S'), 'N')
	into STRICT	ie_inserido_w
	from	W_Item_Prescr
	where	cd_protocolo 	= cd_protocolo_p
	and 	nr_seq_item 	= nr_seq_item_p
	and 	nr_prescricao	= nr_prescricao_p
	and		nm_usuario	    = nm_usuario_p
	and 	nr_seq_material	= nr_seq_material_p
	and 	ie_origem_inf   = ie_origem_inf_p;

	if (ie_inserido_w = 'S') then
		delete from W_Item_Prescr
		where	cd_protocolo 	= cd_protocolo_p
		and 	nr_seq_item 	= nr_seq_item_p
		and 	nr_prescricao	= nr_prescricao_p
		and		nm_usuario	 	= nm_usuario_p
		and 	nr_seq_material	= nr_seq_material_p
		and 	ie_origem_inf   = ie_origem_inf_p;
		commit;
	end if;
elsif (ie_origem_inf_p = 'O') then /* Oxigênio, Gasoterapia*/
	select 	coalesce(max('S'), 'N')
	into STRICT	ie_inserido_w
	from	W_Item_Prescr
	where	cd_protocolo 	= cd_protocolo_p
	and 	nr_seq_item 	= nr_seq_item_p
	and		nr_seq_gas		= nr_seq_gas_p
	and 	nr_prescricao	= nr_prescricao_p
	and		nm_usuario	    = nm_usuario_p
	and 	nr_seq_material	= nr_seq_material_p
	and 	ie_origem_inf   = ie_origem_inf_p;

	if (ie_inserido_w = 'S') then
		delete from W_Item_Prescr
		where	cd_protocolo 	= cd_protocolo_p
		and 	nr_seq_item 	= nr_seq_item_p
		and		nr_seq_gas		= nr_seq_gas_p
		and 	nr_prescricao	= nr_prescricao_p
		and		nm_usuario	 	= nm_usuario_p
		and 	nr_seq_material	= nr_seq_material_p
		and 	ie_origem_inf   = ie_origem_inf_p;
		commit;
	end if;
end if;

select 	nextval('w_item_prescr_seq')
into STRICT	nr_next_sequencia_w
;

Insert into W_Item_Prescr(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_prescricao,
				cd_protocolo,
				nr_seq_solucao,
				nr_seq_gas,
				nr_seq_item,
				qt_dose,
				nr_seq_material,
				ie_origem_inf,
				cd_unidade_medida)
			Values (
				nr_next_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				cd_protocolo_p,
				nr_seq_solucao_p,
				nr_seq_gas_p,
				nr_seq_item_p,
				qt_dose_p,
				nr_seq_material_p,
				ie_origem_inf_p,
				cd_unidade_medida_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_item_prescr ( cd_protocolo_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, nr_seq_solucao_p bigint, nr_seq_gas_p bigint, nr_seq_material_p bigint, qt_dose_p bigint, ie_origem_inf_p text, cd_unidade_medida_p text) FROM PUBLIC;

