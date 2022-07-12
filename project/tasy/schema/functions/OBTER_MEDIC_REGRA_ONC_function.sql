-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medic_regra_onc (cd_material_p bigint, cd_material_generico_p bigint, nr_atendimento_p bigint, ie_tipo_material_p bigint, nr_seq_ficha_tecnica_p bigint) RETURNS bigint AS $body$
DECLARE

			
ie_tipo_material_w		varchar(14);
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_convenio_w			bigint;
nr_sequencia_regra_w		bigint;
ie_regra_w			varchar(15);
cd_medicamento_w		                bigint;
cd_classe_material_w		integer;

c00 CURSOR FOR
SELECT	ie_regra,
	nr_sequencia
from	regra_apresentacao_quimio
where	coalesce(cd_material,cd_material_p)				= cd_material_p
and	coalesce(cd_grupo_material, cd_grupo_material_w)		= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w)	= cd_subgrupo_material_w
and	coalesce(cd_convenio,cd_convenio_w)				= cd_convenio_w
and          coalesce(ie_situacao,'A') = 'A'
and (clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp()))
and	coalesce(ie_tipo_material,ie_tipo_material_p)		= ie_tipo_material_p
and	coalesce(cd_classe_material,cd_classe_material_w)		= cd_classe_material_w
and 	((coalesce(ie_regra_aplicacao,'D') = 'G') or (coalesce(ie_regra_aplicacao,'D') = 'A'))
and ((obtain_user_locale(wheb_usuario_pck.get_nm_usuario) <> 'es_CO')
or (coalesce(ie_nopbs, 'N') = obter_se_nao_pbs_material(cd_material_p, nr_atendimento_p)))
order by
	coalesce(cd_material,0),	
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_grupo_material,0),
	coalesce(cd_convenio,0),
	coalesce(ie_tipo_material,0);
	

BEGIN
cd_medicamento_w := cd_material_p;

select	max(cd_grupo_material),
	max(cd_subgrupo_material),
	max(cd_classe_material)
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	estrutura_material_v	
where	cd_material = cd_medicamento_w;

select 	obter_convenio_atendimento(nr_atendimento_p)
into STRICT 	cd_convenio_w
;

ie_regra_w := null;

open C00;
loop
fetch C00 into	
	ie_regra_w,
	nr_sequencia_regra_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	ie_regra_w := ie_regra_w;
	end;
end loop;
close C00;

if (ie_regra_w = 'MF') or (ie_regra_w = 'MG') THEN
	
	if (ie_regra_w = 'MF') then 
		select 	coalesce(max(cd_material),0)
		into STRICT 	cd_medicamento_w
		from 	material
		where 	ie_tipo_material = 8
		and 	nr_seq_ficha_tecnica = nr_seq_ficha_tecnica_p;
		
		if (cd_medicamento_w = 0) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(196339, 'DS_FICHA_TECNICA_W='||nr_seq_ficha_tecnica_p);
		end if;
	else
		cd_medicamento_w := coalesce(cd_material_generico_p,cd_material_p);
	end if;
elsif (ie_regra_w = 'ME') THEN

	select 	coalesce(max(cd_material_especifico),0)
	into STRICT	cd_medicamento_w
	from	regra_apresentacao_quimio
	where 	nr_sequencia = nr_sequencia_regra_w;

	if (cd_medicamento_w = 0) then
		 CALL wheb_mensagem_pck.exibir_mensagem_abort(196338);
	end if;
end if;

return	cd_medicamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medic_regra_onc (cd_material_p bigint, cd_material_generico_p bigint, nr_atendimento_p bigint, ie_tipo_material_p bigint, nr_seq_ficha_tecnica_p bigint) FROM PUBLIC;

