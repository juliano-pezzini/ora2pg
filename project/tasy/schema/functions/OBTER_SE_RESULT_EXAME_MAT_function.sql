-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_result_exame_mat ( nr_atendimento_p bigint, cd_material_p bigint, nr_seq_lab_result_p bigint, nr_seq_resultado_p bigint) RETURNS varchar AS $body$
DECLARE


qt_resultado_w				exame_lab_result_item.qt_resultado%type;
ds_resultado_w				exame_lab_result_item.ds_resultado%type;
pr_resultado_w				exame_lab_result_item.pr_resultado%type;
nr_seq_exame_w				exame_lab_result_item.nr_seq_exame%type;
nr_seq_resultado_w			exame_lab_result_item.nr_seq_resultado%type;
dt_resultado_w				timestamp;
cd_subgrupo_material_w		bigint;
cd_grupo_material_w			bigint;
cd_classe_material_w		bigint;
ie_retorno_w				varchar(1) := 'N';
nr_seq_ficha_tecnica_w		mat_exame_lab_result.nr_seq_ficha_tecnica%type;

c01 CURSOR FOR
SELECT	distinct b.qt_resultado,
		b.ds_resultado,
		b.pr_resultado,
		b.nr_seq_exame
from	exame_lab_result_item b
where	b.nr_sequencia = nr_seq_lab_result_p
and		b.nr_seq_resultado = nr_seq_resultado_p
and		exists  ( select 1
				  from	exame_lab_resultado a
				  where a.nr_atendimento = nr_atendimento_p
				  and	a.nr_seq_resultado = b.nr_seq_resultado
				  and	a.dt_resultado = (
							SELECT	max(c.dt_resultado)
							from	exame_lab_resultado c
							where	c.nr_seq_resultado = a.nr_seq_resultado
							and		c.nr_atendimento = a.nr_atendimento
							and		c.dt_resultado > clock_timestamp() - interval '7 days'));

BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then


	select	coalesce(max(b.cd_subgrupo_material),0),
			coalesce(max(b.cd_grupo_material),0),
			coalesce(max(b.cd_classe_material),0),
			coalesce(max(b.nr_seq_ficha_tecnica),0)
	into STRICT	cd_subgrupo_material_w,
			cd_grupo_material_w,
			cd_classe_material_w,
			nr_seq_ficha_tecnica_w
	from	estrutura_material_v b
	where 	b.cd_material  = cd_material_p;

	open c01;
	loop
	fetch c01 into	qt_resultado_w,
					ds_resultado_w,
					pr_resultado_w,
					nr_seq_exame_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		if (qt_resultado_w IS NOT NULL AND qt_resultado_w::text <> '') then
			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	mat_exame_lab_result
			where	nr_seq_exame = nr_seq_exame_w
			and		ie_formato_resultado = 'V'
			and		coalesce(cd_material,cd_material_p) = cd_material_p
			and		coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
			and		coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
			and		coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
			and		coalesce(nr_seq_ficha_tecnica, nr_seq_ficha_tecnica_w) = nr_seq_ficha_tecnica_w
			and		qt_resultado_w between qt_minima and qt_maxima;
		elsif (pr_resultado_w IS NOT NULL AND pr_resultado_w::text <> '') then
			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	mat_exame_lab_result
			where	nr_seq_exame = nr_seq_exame_w
			and		ie_formato_resultado = 'P'
			and		coalesce(cd_material,cd_material_p) = cd_material_p
			and		coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
			and		coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
			and		coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
			and		coalesce(nr_seq_ficha_tecnica, nr_seq_ficha_tecnica_w) = nr_seq_ficha_tecnica_w
			and		pr_resultado_w between qt_percent_min and qt_percent_max;
		elsif (ds_resultado_w IS NOT NULL AND ds_resultado_w::text <> '') then
			select	coalesce(max('S'),'N')
			into STRICT	ie_retorno_w
			from	mat_exame_lab_result
			where	nr_seq_exame = nr_seq_exame_w
			and		ie_formato_resultado = 'D'
			and		coalesce(cd_material,cd_material_p) = cd_material_p
			and		coalesce(cd_classe_material, cd_classe_material_w) = cd_classe_material_w
			and		coalesce(cd_subgrupo_material, cd_subgrupo_material_w) = cd_subgrupo_material_w
			and		coalesce(cd_grupo_material, cd_grupo_material_w) = cd_grupo_material_w
			and		coalesce(nr_seq_ficha_tecnica, nr_seq_ficha_tecnica_w) = nr_seq_ficha_tecnica_w
			and		ds_resultado = ds_resultado_w;
		end if;

		if (ie_retorno_w = 'S') then
			exit;
		end if;

		end;
	end loop;
	close c01;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_result_exame_mat ( nr_atendimento_p bigint, cd_material_p bigint, nr_seq_lab_result_p bigint, nr_seq_resultado_p bigint) FROM PUBLIC;
