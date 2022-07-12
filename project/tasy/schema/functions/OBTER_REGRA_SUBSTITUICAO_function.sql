-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_substituicao ( cd_material_p bigint, nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_regra_w		integer;
cd_material_prescr_w	bigint;
ds_retorno_w		varchar(1) := 'N';
qt_prescrito_w		integer;

C01 CURSOR FOR
	SELECT	cd_material
	from	regra_mat_subst_atend
	where	cd_material_subst = cd_material_p
	and	ie_situacao = 'A'
	and	ie_prescricao = 'S'
  and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
  or coalesce(cd_estabelecimento::text, '') = '');


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	regra_mat_subst_atend
where	cd_material_subst = cd_material_p
and	ie_situacao = 'A'
and	ie_prescricao = 'S'
and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
or coalesce(cd_estabelecimento::text, '') = '');

if (qt_regra_w > 0) then

	open C01;
	loop
	fetch C01 into	
		cd_material_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	count(*)
		into STRICT	qt_prescrito_w
		from	prescr_material
		where	nr_prescricao = nr_prescricao_p
		and	cd_material = cd_material_prescr_w
		and	cd_motivo_baixa = 0;
	
		if (qt_prescrito_w > 0) then

		ds_retorno_w := 'S';

		end if;

		end;
	end loop;
	close C01;
	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_substituicao ( cd_material_p bigint, nr_prescricao_p bigint) FROM PUBLIC;

