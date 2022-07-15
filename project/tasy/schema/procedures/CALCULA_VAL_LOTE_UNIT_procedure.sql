-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_val_lote_unit (cd_estabelecimento_p bigint, cd_material_p bigint, dt_validade_p INOUT timestamp, ds_erro_p INOUT text) AS $body$
DECLARE


cd_subgrupo_mat_w	integer;
cd_grupo_mat_w		integer;
cd_classe_mat_w		integer;
pr_aplicar_w		double precision;
dt_validade_w		timestamp;
qt_dia_max_w		bigint;
qt_dia_validade_w		bigint;
qt_dia_calc_w		bigint;
qt_dia_final_w		bigint;

c01 CURSOR FOR
	SELECT	coalesce(pr_aplicar,0),
		qt_dia_max
	from	regra_calculo_validade
	where	cd_estabelecimento				= cd_estabelecimento_p
	and	coalesce(cd_material,cd_material_p)			= cd_material_p
	and	coalesce(cd_grupo_mat,cd_grupo_mat_w)		= cd_grupo_mat_w
	and	coalesce(cd_subgrupo_mat,cd_subgrupo_mat_w)	= cd_subgrupo_mat_w
	and	coalesce(cd_classe_mat,cd_classe_mat_w)		= cd_classe_mat_w
	and	ie_processo = 'U'
	and	(qt_dia_max IS NOT NULL AND qt_dia_max::text <> '')
	order by	coalesce(cd_material,0) desc,
		coalesce(cd_classe_mat,0) desc,
		coalesce(cd_subgrupo_mat,0) desc,
		coalesce(cd_grupo_mat,0) desc,
		pr_aplicar desc,
		qt_dia_max desc;


BEGIN
dt_validade_w	:= dt_validade_p;

if (dt_validade_p IS NOT NULL AND dt_validade_p::text <> '') then
	begin
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_mat_w,
		cd_subgrupo_mat_w,
		cd_classe_mat_w
	from	estrutura_material_v
	where	cd_material = cd_material_p;

	open c01;
	loop
	fetch c01 into
		pr_aplicar_w,
		qt_dia_max_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		pr_aplicar_w	:= pr_aplicar_w;
		qt_dia_max_w	:= qt_dia_max_w;
		end;
	end loop;
	close c01;

	qt_dia_validade_w	:= dt_validade_w - clock_timestamp();

	qt_dia_calc_w		:= qt_dia_validade_w - (qt_dia_validade_w * coalesce(pr_aplicar_w,0) / 100);
	qt_dia_calc_w		:= coalesce(qt_dia_calc_w,0);
	qt_dia_max_w		:= coalesce(qt_dia_max_w,0);

	if (qt_dia_calc_w < qt_dia_max_w) then
		ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(279155) || qt_dia_calc_w || WHEB_MENSAGEM_PCK.get_texto(279156) || qt_dia_max_w || WHEB_MENSAGEM_PCK.get_texto(279157) || chr(13) ||
			WHEB_MENSAGEM_PCK.get_texto(279158);
	end if;

	dt_validade_p := clock_timestamp() + qt_dia_calc_w;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_val_lote_unit (cd_estabelecimento_p bigint, cd_material_p bigint, dt_validade_p INOUT timestamp, ds_erro_p INOUT text) FROM PUBLIC;

