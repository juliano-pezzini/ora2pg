-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


---------------------------------------------------------------
--- atualizar os saldos do produto nos varios depositos
---------------------------------------------------------------
CREATE OR REPLACE PROCEDURE val_estoque_media_ponderada.val_saldo ( cd_material_p bigint, cd_estabelecimento_p bigint , dt_mesano_referencia_p timestamp, qt_estoque_p bigint, vl_estoque_p bigint, vl_custo_medio_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_local_estoque_w		integer;
qt_estoque_w			double precision;
vl_estoque_total_w		double precision;
vl_diferenca_w			double precision;
ds_erro_w			varchar(255)   := '';


BEGIN
update	saldo_estoque
set	vl_estoque		= coalesce(coalesce(qt_estoque,0) * coalesce(vl_custo_medio_p,0),0),
	vl_custo_medio		= coalesce(vl_custo_medio_p,0),
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp(),
	ie_status_valorizacao	= 'C'
where	cd_material		= cd_material_p
and	dt_mesano_referencia	= dt_mesano_referencia_p
and	cd_estabelecimento	= cd_estabelecimento_p;

select	coalesce(sum(vl_estoque),0)
into STRICT	vl_estoque_total_w
from	saldo_estoque
where	cd_material		= cd_material_p
and	dt_mesano_referencia	= dt_mesano_referencia_p
and	cd_estabelecimento	= cd_estabelecimento_p;

vl_diferenca_w := (vl_estoque_total_w - vl_estoque_p);

if (vl_diferenca_w <> 0) then
	begin
	select	max(qt_estoque)
	into STRICT	qt_estoque_w
	from	saldo_estoque
	where	cd_material		= cd_material_p
	and	dt_mesano_referencia	= dt_mesano_referencia_p
	and	cd_estabelecimento	= cd_estabelecimento_p
	and	qt_estoque <> 0;

	if (qt_estoque_w IS NOT NULL AND qt_estoque_w::text <> '') then
		select	max(cd_local_estoque)
		into STRICT	cd_local_estoque_w
		from	saldo_estoque
		where	cd_material		= cd_material_p
		and	dt_mesano_referencia	= dt_mesano_referencia_p
		and	cd_estabelecimento	= cd_estabelecimento_p
		and	qt_estoque		= qt_estoque_w;


		update	saldo_estoque
		set	vl_estoque		= (vl_estoque - vl_diferenca_w)
		where	cd_material		= cd_material_p
		and	cd_local_estoque	= cd_local_estoque_w
		and	dt_mesano_referencia	= dt_mesano_referencia_p
		and	cd_estabelecimento	= cd_estabelecimento_p;
	end if;
	end;
end if;

delete	FROM custo_mensal_material
where	cd_estabelecimento	= cd_estabelecimento_p
and	dt_referencia		= dt_mesano_referencia_p
and	cd_material		= cd_material_p
and	ie_tipo_custo		= 'E';

begin
insert into custo_mensal_material(
	cd_estabelecimento,
	dt_referencia,
	cd_material,
	ie_tipo_custo,
	dt_atualizacao,
	nm_usuario,
	vl_custo)
values (cd_estabelecimento_p,
	dt_mesano_referencia_p,
	cd_material_p,
	'E',
	clock_timestamp(),
	nm_usuario_p,
	vl_custo_medio_p);
exception
    when others then
        ds_erro_w   := 'Erro Insert Custo_mensal_material';
end;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE val_estoque_media_ponderada.val_saldo ( cd_material_p bigint, cd_estabelecimento_p bigint , dt_mesano_referencia_p timestamp, qt_estoque_p bigint, vl_estoque_p bigint, vl_custo_medio_p bigint, nm_usuario_p text) FROM PUBLIC;