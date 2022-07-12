-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_campo_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_bomba_infusao_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_obrigar_w	varchar(1) := 'N';
ie_unico_componente_w varchar(1);
cd_material_w	bigint;
cont_w			bigint;

c01 CURSOR FOR
SELECT	count(nr_sequencia),
		cd_material
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia_solucao	= nr_seq_solucao_p
group by cd_material;


BEGIN

if (ie_opcao_p = 'J') then
	open C01;
	loop
	fetch C01 into
		cont_w,
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */

		select	max(ie_obrigar),
				coalesce(max(ie_unico_componente),'N')
		into STRICT	ie_obrigar_w,
				ie_unico_componente_w
		from	ragra_obriga_campo_sol
		where	coalesce(cd_material,cd_material_w)	= cd_material_w
		and	ie_bomba_infusao		= ie_bomba_infusao_p
		and	ie_campo				= 'J'
		and	((coalesce(ie_unico_componente,'N') = 'N') or (coalesce(ie_unico_componente,'N') = 'S' and cont_w = 1));

		if (ie_obrigar_w = 'S') and (ie_unico_componente_w = 'N') then
			exit;
		end if;

	end loop;
	close C01;
end if;

return	ie_obrigar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_campo_sol ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_bomba_infusao_p text, ie_opcao_p text) FROM PUBLIC;

