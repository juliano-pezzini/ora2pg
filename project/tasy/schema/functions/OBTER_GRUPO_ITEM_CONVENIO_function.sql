-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_item_convenio ( cd_convenio_p bigint, ie_tipo_item_p bigint, cd_item_p bigint, ie_origem_proced_p bigint, cd_especialidade_med_p bigint, cd_medico_p text, ie_tipo_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


/* tipo do item    1-Procedimentos/serviços 2-Materiais/Medicamentos */

cd_grupo_convenio_w	varchar(10);
cd_grupo_proc_w		bigint;
cd_espec_proc_w		bigint;
cd_area_proc_w		bigint;
cd_grupo_mat_w		smallint;
cd_subgrupo_mat_w		smallint;
cd_classe_mat_w		integer;
ie_tipo_mat_w		varchar(03);

C01 CURSOR FOR
	SELECT	cd_grupo
	from		conversao_proc_convenio
	where		cd_convenio							= cd_convenio_p
	and		coalesce(cd_procedimento,cd_item_p) 			= cd_item_p
	and		coalesce(ie_origem_proced,ie_origem_proced_p)		= ie_origem_proced_p
	and		coalesce(cd_area_proced,cd_area_proc_w)			= cd_area_proc_w
	and		coalesce(cd_especial_proced,cd_espec_proc_w)		= cd_espec_proc_w
	and		coalesce(cd_grupo_proced,cd_grupo_proc_w)		= cd_grupo_proc_w
	and		ie_situacao					= 'A'
	order by
			coalesce(cd_procedimento,0),
			coalesce(cd_grupo_proced,0),
			coalesce(cd_especial_proced,0),
			coalesce(cd_area_proced,0);

C02 CURSOR FOR
	SELECT	cd_grupo
	from		conversao_material_convenio
	where		cd_convenio							= cd_convenio_p
	and		coalesce(cd_material,cd_item_p) 				= cd_item_p
	and		coalesce(cd_grupo_material,cd_grupo_mat_w) 		= cd_grupo_mat_w
	and		coalesce(cd_subgrupo_material,cd_subgrupo_mat_w) 	= cd_subgrupo_mat_w
	and		coalesce(cd_classe_material,cd_classe_mat_w) 		= cd_classe_mat_w
	and		coalesce(ie_tipo_material,ie_tipo_mat_w) 	= ie_tipo_mat_w
	order by
			coalesce(cd_material,0),
			coalesce(cd_grupo_material,0),
			coalesce(cd_subgrupo_material,0),
			coalesce(cd_classe_material,0),
			coalesce(ie_tipo_material,'0');


BEGIN
if (ie_tipo_item_p	= 1) then
	BEGIN
	/* busca estrutura procedimento */

	begin
	select 	cd_grupo_proc,
			cd_especialidade,
			cd_area_procedimento
	into STRICT		cd_grupo_proc_w,
			cd_espec_proc_w,
			cd_area_proc_w
	from		Estrutura_Procedimento_V
	where		cd_procedimento 	= cd_item_p
	and		ie_origem_proced	= ie_origem_proced_p;
	exception
     			when others then
			cd_grupo_proc_w	:= 0;
	end;

	/* busca descriçao do procedimento para o convênio */

	begin
	OPEN C01;
	LOOP
	FETCH C01 into
		cd_grupo_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		cd_grupo_convenio_w	:= cd_grupo_convenio_w;
		end;
	END LOOP;
	CLOSE C01;
	end;
	END;
else
	BEGIN
	/* busca estrutura material */

	begin
	select 	cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			ie_tipo_material
	into STRICT		cd_grupo_mat_w,
			cd_subgrupo_mat_w,
			cd_classe_mat_w,
			ie_tipo_mat_w
	from 		estrutura_material_v
	where 	cd_material		= cd_item_p;
	exception
     			when others then
			cd_grupo_mat_w			:= 0;
	end;

	/* busca descriçao do material para o convênio */

	begin
	OPEN C02;
	LOOP
	FETCH C02 into
		cd_grupo_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		cd_grupo_convenio_w	:= cd_grupo_convenio_w;
		end;
	END LOOP;
	CLOSE C02;
	end;
	END;
end if;
RETURN cd_grupo_convenio_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_item_convenio ( cd_convenio_p bigint, ie_tipo_item_p bigint, cd_item_p bigint, ie_origem_proced_p bigint, cd_especialidade_med_p bigint, cd_medico_p text, ie_tipo_atendimento_p bigint) FROM PUBLIC;
