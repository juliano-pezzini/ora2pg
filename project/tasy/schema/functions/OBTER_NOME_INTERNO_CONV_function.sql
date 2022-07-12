-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_interno_conv ( cd_convenio_p bigint, ie_tipo_item_p bigint, cd_item_p bigint, ie_origem_proced_p bigint, ie_estrutura_completa_p text, cd_especialidade_med_p bigint, cd_medico_p text, ie_tipo_atendimento_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


/* tipo do item    1-Procedimentos/serviços 2-Materiais/Medicamentos */

/* estrutura completa S-Sim (validade toda estrutura) N-Não (valida só proc) */

ds_item_convenio_w	varchar(240);
cd_grupo_proc_w		bigint;
cd_espec_proc_w		bigint;
cd_area_proc_w		bigint;
cd_grupo_mat_w		smallint;
cd_subgrupo_mat_w	smallint;
cd_classe_mat_w		integer;
ie_tipo_mat_w		varchar(03);
ds_item_w		varchar(240);
cd_especial_medica_w	integer;
ie_tipo_atendimento_w	integer;
qt_reg_w			integer;


C01 CURSOR FOR
	SELECT		/* +index(a CONPRCO_I2) */
			coalesce(ds_proc_convenio,ds_item_w)
	from		conversao_proc_convenio a
	where		cd_convenio							= cd_convenio_p
	and		coalesce(cd_procedimento,cd_item_p) 			= cd_item_p
	and		coalesce(ie_origem_proced,ie_origem_proced_p)		= ie_origem_proced_p
	and		coalesce(cd_area_proced,cd_area_proc_w)			= cd_area_proc_w
	and		coalesce(cd_especial_proced,cd_espec_proc_w)		= cd_espec_proc_w
	and		coalesce(cd_grupo_proced,cd_grupo_proc_w)		= cd_grupo_proc_w
	and (coalesce(cd_especialidade_medica, cd_especial_medica_w) = cd_especial_medica_w)
	and (coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)    = ie_tipo_atendimento_w)
	and		coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0))	= coalesce(nr_seq_proc_interno_p,0)
	and		ie_situacao					= 'A'
	order by	coalesce(nr_seq_proc_interno,0),
			coalesce(cd_procedimento,0),
			coalesce(cd_grupo_proced,0),
			coalesce(cd_especial_proced,0),
			coalesce(cd_area_proced,0);

C02 CURSOR FOR
	SELECT	coalesce(ds_material_convenio,ds_item_w)
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

cd_especial_medica_w		:= coalesce(cd_especialidade_med_p, 0);
ie_tipo_atendimento_w		:= coalesce(ie_tipo_atendimento_p, 0);


if (ie_tipo_item_p	= 1) then
	BEGIN
	/* busca estrutura procedimento */

	begin
	select		max(ds_proc_convenio),
			count(*)
	into STRICT		ds_item_convenio_w,
			qt_reg_w
	from		conversao_proc_convenio a
	where		cd_convenio				= cd_convenio_p
	and		cd_procedimento				= cd_item_p
	and		ie_origem_proced			= ie_origem_proced_p
	and		ie_situacao					= 'A';

	if (qt_reg_w <> 1) or (coalesce(ds_item_convenio_w::text, '') = '') then
		begin
		select	/* +index(a procedi_pk) */
			a.cd_grupo_proc,
			b.cd_especialidade,
			c.cd_area_procedimento,
			a.ds_procedimento
		into STRICT	cd_grupo_proc_w,
			cd_espec_proc_w,
			cd_area_proc_w,
			ds_item_w
		from	grupo_proc b,
			especialidade_proc c,
			area_procedimento d,
			procedimento a
		where	a.cd_grupo_proc		= b.cd_grupo_proc
		and	b.cd_especialidade	= c.cd_especialidade
		and	c.cd_area_procedimento	= d.cd_area_procedimento
		and	a.cd_procedimento 	= cd_item_p
		and	a.ie_origem_proced	= ie_origem_proced_p;
		exception
				when others then
				cd_grupo_proc_w	:= 0;
		end;

		if (ie_estrutura_completa_p	= 'N') then
			begin
			cd_grupo_proc_w	:= 99999999;
			cd_espec_proc_w	:= 99999999;
			cd_area_proc_w	:= 99999999;
			end;
		end if;

		ds_item_convenio_w	:= ds_item_w;

		/* busca descriçao do procedimento para o convênio */

		begin
		OPEN C01;
		LOOP
		FETCH C01 into
			ds_item_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			ds_item_convenio_w	:= ds_item_convenio_w;
			end;
		END LOOP;
		CLOSE C01;
		end;
	end if;
	end;
	END;
else
	BEGIN
	/* busca estrutura material */

	begin
	select 	cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			substr(ds_material,1,240),
			ie_tipo_material
	into STRICT		cd_grupo_mat_w,
			cd_subgrupo_mat_w,
			cd_classe_mat_w,
			ds_item_w,
			ie_tipo_mat_w
	from 		estrutura_material_v
	where 	cd_material		= cd_item_p;
	exception
     			when others then
			cd_grupo_mat_w			:= 0;
	end;

	ds_item_convenio_w	:= ds_item_w;

	/* busca descriçao do material para o convênio */

	begin
	OPEN C02;
	LOOP
	FETCH C02 into
		ds_item_convenio_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		ds_item_convenio_w	:= ds_item_convenio_w;
		end;
	END LOOP;
	CLOSE C02;
	end;
	END;
end if;
RETURN ds_item_convenio_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_interno_conv ( cd_convenio_p bigint, ie_tipo_item_p bigint, cd_item_p bigint, ie_origem_proced_p bigint, ie_estrutura_completa_p text, cd_especialidade_med_p bigint, cd_medico_p text, ie_tipo_atendimento_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;

