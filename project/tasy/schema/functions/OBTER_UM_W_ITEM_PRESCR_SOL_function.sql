-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_um_w_item_prescr_sol (cd_protocolo_p bigint, nr_seq_item_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_solucao_p bigint, ie_Origem_inf_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := null;


BEGIN
if (ie_origem_inf_p in ('SOL','M')) then
	select  cd_unidade_medida
	into STRICT	ds_retorno_w
	from 	W_item_prescr
	where	cd_protocolo  = cd_protocolo_p
	and		nr_seq_item   = nr_seq_item_p
	and		nr_prescricao = nr_prescricao_p
	and 	nr_seq_material = nr_seq_material_p
	and 	ie_Origem_inf = ie_Origem_inf_p
	and		nm_usuario = nm_usuario_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_um_w_item_prescr_sol (cd_protocolo_p bigint, nr_seq_item_p bigint, nr_prescricao_p bigint, nr_seq_material_p bigint, nr_seq_solucao_p bigint, ie_Origem_inf_p text, nm_usuario_p text) FROM PUBLIC;
