-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_estoque_excedente ( dt_mesano_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_local_estoque_w	smallint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
cd_material_w		integer;
dt_mes_ref_w		timestamp;
vl_custo_medio_w		double precision;
qt_estoque_w		double precision;
vl_estoque_w		double precision;
qt_estoque_maximo_w	double precision;
qt_estoque_maximo_ww	double precision;
vl_estoque_maximo_w	double precision;
qt_excedente_w		double precision;
vl_excedente_w		double precision;

qt_estoque_geral_w	double precision;
vl_estoque_geral_w	double precision;


/*Materiais com estoque*/

c01 CURSOR FOR
SELECT	distinct
	cd_material
from	saldo_estoque
where	cd_estabelecimento		= cd_estabelecimento_p
and	dt_mesano_referencia	= dt_mes_ref_w
order by cd_material;

/*Locais de estoque e o saldo*/

c02 CURSOR FOR
SELECT	distinct
	cd_local_estoque,
	coalesce(qt_estoque,0),
	coalesce(vl_estoque,0)
from	saldo_estoque
where	cd_estabelecimento		= cd_estabelecimento_p
and	dt_mesano_referencia	= dt_mes_ref_w
and	cd_material		= cd_material_w;


BEGIN

dt_mes_ref_w		:= trunc(dt_mesano_referencia_p,'mm');

delete
from	saldo_estoque_excedente
where	cd_estabelecimento		= cd_estabelecimento_p
and	dt_referencia		= dt_mes_ref_w;

open c01;
loop
fetch c01 into
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material = cd_material_w;

	select	sum(qt_estoque),
		sum(vl_estoque)
	into STRICT	qt_estoque_geral_w,
		vl_estoque_geral_w
	from	saldo_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	dt_mesano_referencia	= dt_mes_ref_w
	and	cd_material		= cd_material_w;

	select	coalesce(obter_mat_estabelecimento(cd_estabelecimento_p, cd_estabelecimento_p, cd_material_w, 'MA'),0)
	into STRICT	qt_estoque_maximo_w
	;

	open c02;
	loop
	fetch c02 into
		cd_local_estoque_w,
		qt_estoque_w,
		vl_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		select	round((obter_custo_medio_material(cd_estabelecimento_p, dt_mes_ref_w, cd_material_w))::numeric,4)
		into STRICT	vl_custo_medio_w
		;

		vl_estoque_maximo_w		:= 0;
		vl_excedente_w			:= 0;

		begin
		qt_estoque_maximo_ww	:=	vl_estoque_w / 	vl_estoque_geral_w * qt_estoque_maximo_w;
		exception
		when others then
			qt_estoque_maximo_ww	:= 0;
		end;

		vl_estoque_maximo_w 	:= round((qt_estoque_maximo_ww * vl_custo_medio_w)::numeric,4);

		vl_excedente_w		:= vl_estoque_w - vl_estoque_maximo_w;
		qt_excedente_w		:= qt_estoque_w - qt_estoque_maximo_ww;

		insert into saldo_estoque_excedente(
			dt_atualizacao,
			nm_usuario,
			cd_estabelecimento,
			dt_referencia,
			cd_local_estoque,
			cd_grupo_material,
			cd_subgrupo_material,
			cd_classe_material,
			cd_material,
			vl_custo_medio,
			qt_estoque,
			vl_estoque,
			qt_estoque_maximo,
			vl_estoque_maximo,
			qt_excedente,
			vl_excedente)
		values (	clock_timestamp(),
			nm_usuario_p,
			cd_estabelecimento_p,
			dt_mes_ref_w,
			cd_local_estoque_w,
			cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w,
			cd_material_w,
			vl_custo_medio_w,
			qt_estoque_w,
			vl_estoque_w,
			qt_estoque_maximo_ww,
			vl_estoque_maximo_w,
			qt_excedente_w,
			vl_excedente_w);
		end;
	end loop;
	close c02;
end;
end loop;
close c01;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_estoque_excedente ( dt_mesano_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

