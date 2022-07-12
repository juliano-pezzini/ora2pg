-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_motivo_atend ( cd_material_p bigint, nr_seq_tipo_baixa_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w		numeric(20);
cd_classe_material_w	integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
nr_sequencia_w		regra_motivo_atend_prescr.nr_sequencia%type;
ie_retorno_w		varchar(1) := 'S';


BEGIN

select	count(1)
into STRICT	qt_existe_w
from	motivo_baixa_atend_prescr b,
	regra_motivo_atend_prescr a
where	a.nr_sequencia = b.nr_seq_mot_atend_presc
and	((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento));

if (qt_existe_w > 0) then

	select	max(cd_grupo_material),
		max(cd_subgrupo_material),
		max(cd_classe_material)
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;
	
	select	coalesce(max(nr_sequencia), 0)
	into STRICT	nr_sequencia_w
	from	regra_motivo_atend_prescr
	where	coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
	and	coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
	and	coalesce(cd_material, cd_material_p) = cd_material_p
	and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento));
	
	if (nr_sequencia_w > 0) then
		
		select	count(1)
		into STRICT	qt_existe_w
		from	motivo_baixa_atend_prescr
		where	nr_seq_mot_atend_presc = nr_sequencia_w;
		
		if (qt_existe_w > 0 and (nr_seq_tipo_baixa_p IS NOT NULL AND nr_seq_tipo_baixa_p::text <> '')) then
			
			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	motivo_baixa_atend_prescr
			where	nr_seq_mot_atend_presc = nr_sequencia_w
			and	nr_seq_tipo_baixa = nr_seq_tipo_baixa_p;

		end if;
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_motivo_atend ( cd_material_p bigint, nr_seq_tipo_baixa_p bigint) FROM PUBLIC;
