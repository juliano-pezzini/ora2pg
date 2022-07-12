-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_monta_grupo_js ( ie_tipo_item_p text, cd_item_p bigint, cd_mat_aux_p bigint, cd_pessoa_fisica_p text, nr_prescricao_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
qt_w		bigint := 0;
cd_material_w	bigint;
ie_tipo_item_w	varchar(5) := '';


BEGIN

ie_tipo_item_w := ie_tipo_item_p;

if (ie_tipo_item_p <> 'PROC') and (cd_item_p > 0) then

	if (cd_item_p <> cd_mat_aux_p) or (ie_tipo_item_p = 'PA') then

		if (ie_tipo_item_p = 'G') then

			select 	max(cd_material_generico)
			into STRICT	cd_material_w
			from 	material
			where 	cd_material = cd_item_p;

		else
			select 	max(nr_seq_ficha_tecnica)
			into STRICT	cd_material_w
			from 	material
			where 	cd_material = cd_item_p;

		end if;
	else
		cd_material_w := cd_item_p;
		ie_tipo_item_w := 'M';
	end if;


	select  count(*)
	into STRICT	qt_w
	from    material
	where   (
		(ie_tipo_item_w = 'M' AND cd_material = cd_material_w) or
		((ie_tipo_item_w = 'G') and (cd_material in (	SELECT 	c.cd_material
						from	   material c
						where	   c.cd_material_generico = cd_material_w
				   and      c.cd_material <> cd_mat_aux_p
				   and      exists (  SELECT  1
						     from    prescr_material e,
							     prescr_medica f
						     where   e.nr_prescricao = f.nr_prescricao
						     and     e.cd_material = c.cd_material
						     and     f.cd_pessoa_fisica = cd_pessoa_fisica_p)))) or
		 ((ie_tipo_item_w = 'PA') and (cd_material in (	select 	max(d.cd_material)
						from	   material d
						where	   d.nr_seq_ficha_tecnica = cd_material_w))));
elsif (cd_item_p > 0)	 then

	select  count(*)
	into STRICT	qt_w
	from    prescr_proc_hor
	where   ((cd_procedimento = cd_item_p) or (cd_item_p = 0))
	and     ie_origem_proced >= 0
	and     nr_prescricao = nr_prescricao_p
	and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
	group by cd_procedimento;

end if;

if (qt_w > 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_monta_grupo_js ( ie_tipo_item_p text, cd_item_p bigint, cd_mat_aux_p bigint, cd_pessoa_fisica_p text, nr_prescricao_p bigint ) FROM PUBLIC;

