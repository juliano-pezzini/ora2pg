-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE virada_saldo ( dt_mesano_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_virada_p text default 'N') AS $body$
DECLARE


cd_estabelecimento_w	smallint	:= 0;
cd_local_estoque_w 	smallint	:= 0;
cd_material_w		integer	:= 0;
nm_usuario_w		varchar(15);
qt_estoque_w		double precision    := 0;
vl_estoque_w		double precision    := 0;
vl_custo_medio_w		double precision;
vl_preco_ult_compra_w	double precision;
dt_ult_compra_w		timestamp;
ie_erro_w			varchar(1);
cd_fornecedor_w		varchar(14);
nr_seq_lote_w		bigint;
ds_erro_w		varchar(255);
dt_mes_base_w		timestamp;
dt_novo_mes_w		timestamp;
qt_reg_base_w		bigint;
qt_reg_ant_w		bigint;
qt_reg_pos_w		bigint;
ie_bloqueio_inventario_w	varchar(1);
ie_virada_saldo_zero_w	varchar(1);
qt_meses_saldo_zero_w	parametro_estoque.qt_meses_sem_movto_saldo_zero%type;
dt_mes_movto_w		timestamp;
qt_estoque_consignado_w	fornecedor_mat_consignado.qt_estoque%type;

c00 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p

union all

select	a.cd_estabelecimento
from	estabelecimento a
where	a.ie_situacao = 'A'
and	cd_estabelecimento_p = 0
and	exists (select 	1
		from	parametro_estoque x
		where	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.ie_situacao = 'A');

c01 CURSOR FOR
SELECT	cd_local_estoque,
	cd_material,
	qt_estoque,
	vl_estoque,
	vl_custo_medio,
	vl_preco_ult_compra,
	dt_ult_compra,
	ie_bloqueio_inventario
from	saldo_estoque a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento	= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'N'
and	((qt_estoque <> 0) or (vl_estoque <> 0) or
	((obter_dados_material(cd_material,'EST') = cd_material) and (obter_saldo_disp_estoque(cd_estabelecimento, cd_material, cd_local_estoque, dt_mesano_referencia, null, ie_virada_p) > 0)) or
	exists (	select	1
		from	saldo_estoque_lote x
		where	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia = a.dt_mesano_referencia
		and	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material))
and	not exists (
	SELECT	1
	from	saldo_estoque b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.dt_mesano_referencia	= dt_novo_mes_w)

union all

select	cd_local_estoque,
	cd_material,
	qt_estoque,
	vl_estoque,
	vl_custo_medio,
	vl_preco_ult_compra,
	dt_ult_compra,
	ie_bloqueio_inventario
from	saldo_estoque a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento		= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'S'
and	qt_meses_saldo_zero_w = 0
and	not exists (
	select	1
	from	saldo_estoque b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.dt_mesano_referencia	= dt_novo_mes_w)

union all

select	cd_local_estoque,
	cd_material,
	qt_estoque,
	vl_estoque,
	vl_custo_medio,
	vl_preco_ult_compra,
	dt_ult_compra,
	ie_bloqueio_inventario
from	saldo_estoque a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento		= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'S'
and	qt_meses_saldo_zero_w > 0
and	not exists (
	select	1
	from	saldo_estoque b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.dt_mesano_referencia	= dt_novo_mes_w)
and	((qt_estoque <> 0) or (vl_estoque <> 0) or
	((obter_dados_material(cd_material,'EST') = cd_material) and (obter_saldo_disp_estoque(cd_estabelecimento, cd_material, cd_local_estoque, dt_mesano_referencia, null, ie_virada_p) > 0)) or
	exists (select	1
		from	resumo_movto_estoque x
		where	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material
		and	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia between dt_mes_movto_w and dt_novo_mes_w) or
	exists (	select	1
		from	saldo_estoque_lote x
		where	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia = a.dt_mesano_referencia
		and	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material));

c02 CURSOR FOR
SELECT	cd_local_estoque,
	cd_fornecedor,
	cd_material,
	qt_estoque,
	ie_bloqueio_inventario
from	fornecedor_mat_consignado a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento	= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'N'
and	((qt_estoque <> 0) or
	exists (	select	1
		from	fornecedor_mat_consig_lote x
		where	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia = a.dt_mesano_referencia
		and	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material
		and	x.cd_fornecedor = a.cd_fornecedor))
and	not exists (
	SELECT 1
	from	fornecedor_mat_consignado b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.cd_fornecedor		= a.cd_fornecedor
	and	b.dt_mesano_referencia	= dt_novo_mes_w)

union all

select	cd_local_estoque,
	cd_fornecedor,
	cd_material,
	qt_estoque,
	ie_bloqueio_inventario
from	fornecedor_mat_consignado a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento		= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'S'
and	qt_meses_saldo_zero_w = 0
and	not exists (
	select 1
	from	fornecedor_mat_consignado b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.cd_fornecedor		= a.cd_fornecedor
	and	b.dt_mesano_referencia	= dt_novo_mes_w)

union all

select	cd_local_estoque,
	cd_fornecedor,
	cd_material,
	qt_estoque,
	ie_bloqueio_inventario
from	fornecedor_mat_consignado a
where	dt_mesano_referencia	= dt_mes_base_w
and	cd_estabelecimento		= cd_estabelecimento_w
and	ie_virada_saldo_zero_w	= 'S'
and	qt_meses_saldo_zero_w > 0
and	not exists (
	select 1
	from	fornecedor_mat_consignado b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque	= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.cd_fornecedor		= a.cd_fornecedor
	and	b.dt_mesano_referencia	= dt_novo_mes_w)
and	((qt_estoque <> 0) or (exists (select	1
		from	resumo_movto_estoque x
		where	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material
		and	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia between dt_mes_movto_w and dt_novo_mes_w)) or (exists (	select	1
		from	fornecedor_mat_consig_lote x
		where	x.cd_estabelecimento = a.cd_estabelecimento
		and	x.dt_mesano_referencia = a.dt_mesano_referencia
		and	x.cd_local_estoque = a.cd_local_estoque
		and	x.cd_material = a.cd_material
		and	x.cd_fornecedor = a.cd_fornecedor)));	

c03 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.nr_seq_lote,
	a.cd_material,
	a.qt_estoque
from	saldo_estoque_lote a
where	a.dt_mesano_referencia 	= dt_mes_base_w
and	a.cd_estabelecimento 	= cd_estabelecimento_w
and (a.qt_estoque <> 0)
and	not exists (
	SELECT	1
	from	saldo_estoque_lote b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_material		= a.cd_material
	and	b.nr_seq_lote		= a.nr_seq_lote
	and	b.dt_mesano_referencia	= dt_novo_mes_w);

c04 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_fornecedor,
	a.nr_seq_lote,
	a.cd_material,
	a.qt_estoque
from	fornecedor_mat_consig_lote a
where	a.dt_mesano_referencia 	= dt_mes_base_w
and	a.cd_estabelecimento 	= cd_estabelecimento_w
and (a.qt_estoque <> 0)
and	not exists (
	SELECT	1
	from	fornecedor_mat_consig_lote b
	where	b.cd_estabelecimento	= a.cd_estabelecimento
	and	b.cd_local_estoque		= a.cd_local_estoque
	and	b.cd_fornecedor		= a.cd_fornecedor
	and	b.cd_material		= a.cd_material
	and	b.nr_seq_lote		= a.nr_seq_lote
	and	b.dt_mesano_referencia	= dt_novo_mes_w);



BEGIN
dbms_application_info.set_action('VIRADA_SALDO');

dt_mes_base_w	:= pkg_date_utils.start_of(pkg_date_utils.add_month(dt_mesano_referencia_p,-1,0),'MONTH',0);
dt_novo_mes_w	:= pkg_date_utils.start_of(dt_mesano_referencia_p,'MONTH',0);

if (pkg_date_utils.start_of(dt_mesano_referencia_p,'MONTH',0) = pkg_date_utils.start_of(clock_timestamp(),'MONTH',0)) then
	begin
	open c00;
	loop
	fetch c00 into	
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on c00 */
		begin		
		select	coalesce(max(ie_virada_saldo_zero), 'N'),
			coalesce(max(qt_meses_sem_movto_saldo_zero),0)
		into STRICT	ie_virada_saldo_zero_w,
			qt_meses_saldo_zero_w
		from	parametro_estoque
		where	cd_estabelecimento	= cd_estabelecimento_w;

		if (qt_meses_saldo_zero_w < 0) then
			qt_meses_saldo_zero_w := 0;
		end if;

		dt_mes_movto_w	:= pkg_date_utils.add_month(dt_mes_base_w,(qt_meses_saldo_zero_w-1) * -1,0);

		select	count(*)
		into STRICT	qt_reg_ant_w
		from	saldo_estoque
		where	dt_mesano_referencia	= dt_novo_mes_w
		and	cd_estabelecimento	= cd_estabelecimento_w;

		select	count(*)
		into STRICT	qt_reg_base_w
		from	saldo_estoque
		where	dt_mesano_referencia	= dt_mes_base_w
		and	cd_estabelecimento	= cd_estabelecimento_w;


		open c01;
		loop
		fetch c01 into
			cd_local_estoque_w,
			cd_material_w,
			qt_estoque_w,
			vl_estoque_w,
			vl_custo_medio_w,
			vl_preco_ult_compra_w,
			dt_ult_compra_w,
			ie_bloqueio_inventario_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			insert into saldo_estoque(
				cd_estabelecimento,
				cd_local_estoque,
				cd_material,
				dt_mesano_referencia,
				qt_estoque,
				vl_estoque,
				qt_reservada_requisicao,
				qt_reservada,
				dt_atualizacao,
				nm_usuario,
				vl_custo_medio,
				vl_preco_ult_compra,
				dt_ult_compra,
				ie_bloqueio_inventario)
			values (	cd_estabelecimento_w,
				cd_local_estoque_w,
				cd_material_w,
				dt_novo_mes_w,
				qt_estoque_w,
				vl_estoque_w,
				0,
				0,
				clock_timestamp(),
				nm_usuario_p,
				vl_custo_medio_w,
				vl_preco_ult_compra_w,
				dt_ult_compra_w,
				ie_bloqueio_inventario_w);
			exception
				when others then
					ds_erro_w	:= sqlerrm(SQLSTATE);
					insert into log_val_estoque(cd_log, ds_log, dt_atualizacao, nm_usuario, cd_estabelecimento)
					values (2, ds_erro_w, clock_timestamp(), nm_usuario_p, cd_estabelecimento_w);
			end;
		end loop;
		close c01;

		open c02;
		loop
		fetch c02 into
			cd_local_estoque_w,
			cd_fornecedor_w,
			cd_material_w,
			qt_estoque_consignado_w,
			ie_bloqueio_inventario_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			insert into fornecedor_mat_consignado(
				cd_estabelecimento,
				cd_local_estoque,
				cd_fornecedor,
				cd_material,
				dt_mesano_referencia,
				qt_estoque,
				dt_atualizacao,
				nm_usuario,
				ie_bloqueio_inventario)
			values (	cd_estabelecimento_w,
				cd_local_estoque_w,
				cd_fornecedor_w,
				cd_material_w,
				dt_novo_mes_w,
				qt_estoque_consignado_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_bloqueio_inventario_w);
			exception
				when others then
					ds_erro_w	:= sqlerrm(SQLSTATE);
					insert into log_val_estoque(cd_log, ds_log, dt_atualizacao, nm_usuario, cd_estabelecimento)
					values (2, ds_erro_w, clock_timestamp(), nm_usuario_p, cd_estabelecimento_w);
			end;
		end loop;
		close c02;


		/*estoque dos lotes de fornecedores*/

		open c03;
		loop
		fetch c03 into
			cd_local_estoque_w,
			nr_seq_lote_w,
			cd_material_w,
			qt_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			insert into saldo_estoque_lote(
				cd_estabelecimento,
				cd_local_estoque,
				cd_material,
				dt_mesano_referencia,
				nr_seq_lote,
				qt_estoque,
				dt_atualizacao,
				nm_usuario)
			values (	cd_estabelecimento_w,
				cd_local_estoque_w,
				cd_material_w,
				dt_novo_mes_w,
				nr_seq_lote_w,
				qt_estoque_w,
				clock_timestamp(),
				nm_usuario_p);
			end;
		end loop;
		close c03;

		/*estoque dos lotes de fornecedores consigandos*/

		open c04;
		loop
		fetch c04 into
			cd_local_estoque_w,
			cd_fornecedor_w,
			nr_seq_lote_w,
			cd_material_w,
			qt_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
			insert into fornecedor_mat_consig_lote(
				cd_estabelecimento,
				cd_local_estoque,
				cd_fornecedor,
				cd_material,
				dt_mesano_referencia,
				nr_seq_lote,
				qt_estoque,
				dt_atualizacao,
				nm_usuario)
			values (	cd_estabelecimento_w,
				cd_local_estoque_w,
				cd_fornecedor_w,
				cd_material_w,
				dt_novo_mes_w,
				nr_seq_lote_w,
				qt_estoque_w,
				clock_timestamp(),
				nm_usuario_p);
			end;
		end loop;
		close c04;

		commit;

		select	count(*)
		into STRICT	qt_reg_pos_w
		from	saldo_estoque
		where	dt_mesano_referencia	= dt_novo_mes_w
		and	cd_estabelecimento		= cd_estabelecimento_w;

		ds_erro_w	:= wheb_mensagem_pck.get_texto(311880,'QT_REG_BASE_W=' || qt_reg_base_w || ';' || 'QT_REG_ANT_W=' || qt_reg_ant_w ||
								';' || 'QT_REG_POS_W=' || qt_reg_pos_w);

		insert into log_val_estoque(cd_log, ds_log, dt_atualizacao, nm_usuario, cd_estabelecimento)
					values (2, ds_erro_w, clock_timestamp(), nm_usuario_p, cd_estabelecimento_w);

		commit;		
		end;
	end loop;
	close c00;
	end;

	begin
	CALL enviar_comunic_virada_estoque(nm_usuario_p, clock_timestamp(), ds_erro_w, cd_estabelecimento_p);
	exception
		when others then
			null;
	end;
end if;

dbms_application_info.set_action('');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE virada_saldo ( dt_mesano_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ie_virada_p text default 'N') FROM PUBLIC;

