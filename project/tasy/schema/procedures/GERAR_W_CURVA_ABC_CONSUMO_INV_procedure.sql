-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_curva_abc_consumo_inv ( cd_estabelecimento_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ie_curva_p text, ie_curva_local_p text, ie_somente_com_saldo_p text, cd_local_estoque_p bigint, ie_consignado_p text, dt_mesano_referencia_p timestamp) AS $body$
DECLARE



ie_tipo_curva_w			varchar(1);
ie_tipo_curva_local_w		varchar(1);
ie_curva_w			varchar(1);
dt_mes_curva_w			timestamp;
cd_material_estoque_w		integer;
cd_local_estoque_w		integer;
cd_fornecedor_w			varchar(14);
nr_sequencia_w			bigint;
qt_saldo_w			double precision;
qt_saldo_consig_w		double precision;
dt_mesano_referencia_w		timestamp;
ie_bloqueio_inventario_w	varchar(1);
ie_local_valido_w		varchar(1);
qt_existe_w			bigint;
nr_seq_localizacao_w		bigint;
ie_material_estrut_loc_w	varchar(1);

/*cursor para itens não consignados e ambos*/

c01 CURSOR FOR
	SELECT	b.cd_material_estoque
	from	estrutura_material_v a,
		material b
	where	a.cd_material		= b.cd_material
	and	a.cd_classe_material	= coalesce(cd_classe_material_p, a.cd_classe_material)
	and	a.cd_grupo_material	= coalesce(cd_grupo_material_p, a.cd_grupo_material)
	and	a.cd_subgrupo_material	= coalesce(cd_subgrupo_material_p, a.cd_subgrupo_material)
	and	substr(obter_situacao_material(b.cd_material_estoque),1,1) = 'A'
	and	b.ie_situacao = 'A'
	and	b.ie_consignado	in ('0','2')
	and	((ie_tipo_curva_w = 'N')or (substr(obter_curva_abc_estab(cd_estabelecimento_p, b.cd_material, 'N', dt_mesano_referencia_w),1,1) = ie_tipo_curva_w))
	and	((ie_tipo_curva_local_w = 'N')or (obter_curva_abc_local(b.cd_material, null, cd_local_estoque_p, dt_mesano_referencia_w) = ie_tipo_curva_local_w))
	and (substr(obter_se_material_estoque(cd_estabelecimento_p, 0, b.cd_material),1,1) = 'S')
	group by b.cd_material_estoque;

/*Cursor para itens Consignados e Ambos*/

c02 CURSOR FOR
	SELECT	b.cd_material_estoque,
		x.cd_fornecedor
	from	fornecedor_mat_consignado x,
		estrutura_material_v a,
		material b
	where	a.cd_material		= b.cd_material
	and	a.cd_classe_material	= coalesce(cd_classe_material_p, a.cd_classe_material)
	and	a.cd_grupo_material	= coalesce(cd_grupo_material_p, a.cd_grupo_material)
	and	a.cd_subgrupo_material	= coalesce(cd_subgrupo_material_p, a.cd_subgrupo_material)
	and	b.ie_situacao = 'A'
	and	substr(obter_situacao_material(b.cd_material_estoque),1,1) = 'A'
	and	b.ie_consignado in ('1','2')
	and	((ie_tipo_curva_w = 'N')or (substr(obter_curva_abc_estab(cd_estabelecimento_p, b.cd_material, 'N', dt_mesano_referencia_w),1,1) = ie_tipo_curva_w))
	and	((ie_tipo_curva_local_w = 'N')or (obter_curva_abc_local(b.cd_material, null, cd_local_estoque_p, dt_mesano_referencia_w) = ie_tipo_curva_local_w))
	and (substr(obter_se_material_estoque(cd_estabelecimento_p, 0, b.cd_material),1,1) = 'S')
	and	x.cd_material = b.cd_material
	and	x.dt_mesano_referencia	= dt_mesano_referencia_w
	and	x.cd_local_estoque	= cd_local_estoque_p
	and	x.cd_estabelecimento	= cd_estabelecimento_p
	group by b.cd_material_estoque,
		x.cd_fornecedor;


BEGIN

delete 	FROM w_curva_abc_estoque;

dt_mesano_referencia_w := dt_mesano_referencia_p;

if (ie_curva_p = '0') then
	ie_tipo_curva_w	:= 'N';
elsif (ie_curva_p = '1') then
	ie_tipo_curva_w	:= 'A';
elsif (ie_curva_p = '2') then
	ie_tipo_curva_w	:= 'B';
elsif (ie_curva_p = '3') then
	ie_tipo_curva_w	:= 'C';
elsif (ie_curva_p = '4') then
	ie_tipo_curva_w	:= 'X';
end if;

if (ie_curva_local_p = '0') then
	ie_tipo_curva_local_w	:= 'N';
elsif (ie_curva_local_p = '1') then
	ie_tipo_curva_local_w	:= 'A';
elsif (ie_curva_local_p = '2') then
	ie_tipo_curva_local_w	:= 'B';
elsif (ie_curva_local_p = '3') then
	ie_tipo_curva_local_w	:= 'C';
elsif (ie_curva_local_p = '4') then
	ie_tipo_curva_local_w	:= 'X';
end if;

if (coalesce(ie_consignado_p,'N') = 'N') then
	begin
	open c01;
	loop
	fetch c01 into
		cd_material_estoque_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select 	max(dt_mesano_referencia)
		into STRICT	dt_mes_curva_w
		from	material_abc
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	cd_material		= cd_material_estoque_w
		and	dt_mesano_referencia	<= dt_mesano_referencia_w;

		ie_curva_w	:= substr(obter_curva_abc_estab(cd_estabelecimento_p, cd_material_estoque_w, 'N', dt_mesano_referencia_w),1,1);

		select	coalesce(sum(qt_estoque), 0)
		into STRICT	qt_saldo_w
		from	saldo_estoque
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_p
		and	cd_material		= cd_material_estoque_w
		and	dt_mesano_referencia	= dt_mesano_referencia_w;

		ie_bloqueio_inventario_w := coalesce(obter_se_material_bloqueio_inv(
						cd_estabelecimento_p,
						cd_material_estoque_w,
						cd_local_estoque_p),'N');

		if	((qt_saldo_w > 0 AND ie_somente_com_saldo_p = 'S') or (ie_somente_com_saldo_p = 'N')) and (ie_bloqueio_inventario_w = 'N') then
			begin

			select	nextval('inventario_material_seq')
			into STRICT	nr_sequencia_w
			;

			insert into w_curva_abc_estoque(
				nr_sequencia,
				cd_estabelecimento,
				cd_local_estoque,
				cd_material,
				dt_mesano_referencia,
				qt_estoque,
				vl_estoque,
				vl_acumulado,
				ie_curva,
				pr_estoque,
				pr_acumulado)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_local_estoque_p,
				cd_material_estoque_w,
				dt_mes_curva_w,
				coalesce(obter_consumo_mensal_material('Q',cd_estabelecimento_p,cd_material_estoque_w,dt_mes_curva_w),0),
				coalesce(obter_consumo_mensal_material('V',cd_estabelecimento_p,cd_material_estoque_w,dt_mes_curva_w),0),
				0,
				ie_curva_w,
				0,
				0);
			end;
		end if;
		end;
	end loop;
	close c01;
	end;
else
	begin
	open c02;
	loop
	fetch c02 into
		cd_material_estoque_w,
		cd_fornecedor_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		select	coalesce(sum(qt_estoque), 0)
		into STRICT	qt_saldo_consig_w
		from	fornecedor_mat_consignado
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_p
		and	cd_material		= cd_material_estoque_w
		and	dt_mesano_referencia	= dt_mesano_referencia_w
		and	cd_fornecedor		= cd_fornecedor_w;

		select 	max(dt_mesano_referencia)
		into STRICT	dt_mes_curva_w
		from	material_abc
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	cd_material		= cd_material_estoque_w
		and	dt_mesano_referencia	<= dt_mesano_referencia_w;

		ie_curva_w	:= substr(obter_curva_abc_estab(cd_estabelecimento_p, cd_material_estoque_w, 'N', dt_mesano_referencia_w),1,1);

		ie_bloqueio_inventario_w := coalesce(obter_Se_Material_Bloqueio_Inv(
						cd_estabelecimento_p,
						cd_material_estoque_w,
						cd_local_estoque_p),'N');

		if	((qt_saldo_consig_w > 0 AND ie_somente_com_saldo_p = 'S') or (ie_somente_com_saldo_p = 'N')) and (ie_bloqueio_inventario_w = 'N') then
			begin
			select	nextval('inventario_material_seq')
			into STRICT	nr_sequencia_w
			;

			insert into w_curva_abc_estoque(
				nr_sequencia,
				cd_estabelecimento,
				cd_local_estoque,
				cd_material,
				dt_mesano_referencia,
				qt_estoque,
				vl_estoque,
				vl_acumulado,
				ie_curva,
				pr_estoque,
				pr_acumulado)
			values (	nr_sequencia_w,
				cd_estabelecimento_p,
				cd_local_estoque_p,
				cd_material_estoque_w,
				dt_mes_curva_w,
				coalesce(obter_consumo_mensal_material('Q',cd_estabelecimento_p,cd_material_estoque_w,dt_mes_curva_w),0),
				coalesce(obter_consumo_mensal_material('V',cd_estabelecimento_p,cd_material_estoque_w,dt_mes_curva_w),0),
				null,
				ie_curva_w,
				null,
				null);
			end;
		end if;
		end;
	end loop;
	close c02;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_curva_abc_consumo_inv ( cd_estabelecimento_p bigint, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ie_curva_p text, ie_curva_local_p text, ie_somente_com_saldo_p text, cd_local_estoque_p bigint, ie_consignado_p text, dt_mesano_referencia_p timestamp) FROM PUBLIC;
