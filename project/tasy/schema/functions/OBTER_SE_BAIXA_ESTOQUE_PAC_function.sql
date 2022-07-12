-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_baixa_estoque_pac ( cd_setor_atendimento_p bigint, cd_material_p bigint, nr_seq_ordem_p bigint default null, nr_seq_cabine_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ie_resultado_w			varchar(1);
cd_estabelecimento_w		smallint;
cd_grupo_mat_w			smallint	:= 0;
cd_subgrupo_mat_w		smallint	:= 0;
cd_classe_mat_w			integer	:= 0;
cd_material_w			integer	:= 0;
qt_regra_w			integer	:= 0;
nr_seq_familia_w		bigint	:= 0;
ie_somente_quimio_w		varchar(1);

C01 CURSOR FOR
SELECT	ie_baixa_estoq_pac,
		ie_somente_quimioterapia
from	material_setor
where	cd_setor_atendimento				= cd_setor_atendimento_p
and 	coalesce(nr_seq_familia, nr_seq_familia_w)		= nr_seq_familia_w
and	coalesce(cd_grupo_mat, cd_grupo_mat_w)		= cd_grupo_mat_w
and	coalesce(cd_subgrupo_mat,cd_subgrupo_mat_w)		= cd_subgrupo_mat_w
and	coalesce(cd_classe_mat,cd_classe_mat_w)		= cd_classe_mat_w
and	coalesce(cd_material,cd_material_p)			= cd_material_p
and coalesce(nr_seq_cabine,nr_seq_cabine_p) = nr_seq_cabine_p
order by
	coalesce(cd_material,0),
	coalesce(cd_classe_mat,0),
	coalesce(cd_subgrupo_mat,0),
	coalesce(cd_grupo_mat,0),
	coalesce(nr_seq_familia,0),
	coalesce(nr_seq_cabine,0);


BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

ie_resultado_w		:= 'X';
select count(*)
into STRICT	qt_regra_w
from	material_setor
where	cd_setor_atendimento	= cd_setor_atendimento_p;

if (qt_regra_w > 0) and (coalesce(cd_material_p,0) > 0) then
	begin
	select	coalesce(max(cd_grupo_material),0),
		coalesce(max(cd_subgrupo_material),0),
		coalesce(max(cd_classe_material),0),
		coalesce(max(nr_seq_familia),0)
	into STRICT	cd_grupo_mat_w,
		cd_subgrupo_mat_w,
		cd_classe_mat_w,
		nr_seq_familia_w
	from	estrutura_material_v
	where	cd_material	= cd_material_p;

	OPEN C01;
	LOOP
	FETCH C01 into ie_resultado_w,
				   ie_somente_quimio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		if (coalesce(ie_somente_quimio_w,'N')  = 'S') and (coalesce(nr_seq_ordem_p::text, '') = '') then
			ie_resultado_w := 'S';
		else
			ie_resultado_w	:= ie_resultado_w;
		end if;
	END LOOP;
	CLOSE C01;
	end;
end if;

if (ie_resultado_w = 'X') then
	select	/*nvl(max(ie_baixa_estoq_pac),'N') Fabio - 23/06/2004 Alterei para buscar da function*/
		coalesce(max(substr(obter_material_baixa_estoq_pac(cd_estabelecimento_w, 0, cd_material),1,1)),'N')
	into STRICT	ie_resultado_w
	from	material
	where	cd_material = coalesce(cd_material_p,0);
end if;

return ie_resultado_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_baixa_estoque_pac ( cd_setor_atendimento_p bigint, cd_material_p bigint, nr_seq_ordem_p bigint default null, nr_seq_cabine_p bigint default 0) FROM PUBLIC;
