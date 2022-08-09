-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_saldo_estoque ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp) AS $body$
DECLARE


 cd_estabelecimento_w		smallint;
 cd_local_estoque_w		smallint;
 cd_material_w			integer;
 dt_mesano_referencia_w		timestamp;
 cd_operacao_estoque_w		smallint;
 qt_estoque_atual_w		double precision;
 qt_estoque_anterior_w		double precision;
 qt_saidas_w			double precision;
 qt_entradas_w			double precision;
 qt_diferenca_w			double precision;

c000 CURSOR FOR
SELECT 	cd_estabelecimento,
	cd_local_estoque,
	cd_material,
	dt_mesano_referencia,
	qt_estoque
from	saldo_estoque
where	cd_local_estoque between CASE WHEN cd_local_estoque_p=9999 THEN  0  ELSE cd_local_estoque_p END  and cd_local_estoque_p
and	cd_material between CASE WHEN cd_material_p=999999 THEN  0  ELSE cd_material_p END  and cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p
and	dt_mesano_referencia = dt_mesano_referencia_p;


BEGIN

open c000;
loop
fetch c000 into
	cd_estabelecimento_w,
	cd_local_estoque_w,
	cd_material_w,
	dt_mesano_referencia_w,
	qt_estoque_atual_w;
EXIT WHEN NOT FOUND; /* apply on c000 */
	begin
	begin
	select	qt_estoque
	into STRICT	qt_estoque_anterior_w
	from	saldo_estoque
	where	cd_local_estoque 		= cd_local_estoque_w
	and	cd_material 		= cd_material_w
	and	cd_estabelecimento		= cd_estabelecimento_w
	and	dt_mesano_referencia 	= PKG_DATE_UTILS.ADD_MONTH(dt_mesano_referencia_p, -1, 0);
	exception
	when others then
		qt_estoque_anterior_w := 0;
	end;
	begin
	qt_entradas_w 	:= 0;
	qt_saidas_w		:= 0;

	select /*+ index(a movesto_i7) */		sum(CASE WHEN ie_entrada_saida='E' THEN 		CASE WHEN cd_acao=2 THEN  qt_estoque * -1  ELSE qt_estoque END   ELSE 0 END ),
		sum(CASE WHEN ie_entrada_saida='S' THEN 		CASE WHEN cd_acao=2 THEN  qt_estoque * -1  ELSE qt_estoque END   ELSE 0 END )
	into STRICT	qt_entradas_w,
		qt_saidas_w
	from	operacao_estoque b, movimento_estoque a
	where	a.cd_local_estoque 	= cd_local_estoque_w
	and	a.cd_material_estoque	= cd_material_w
	and	a.cd_estabelecimento	= cd_estabelecimento_w
	and	a.dt_mesano_referencia 	= dt_mesano_referencia_p
	and	a.cd_operacao_estoque	= b.cd_operacao_estoque
	and	(a.dt_processo IS NOT NULL AND a.dt_processo::text <> '');
	exception
	when others then
		qt_entradas_w 	:= 0;
		qt_saidas_w		:= 0;
	end;


	qt_diferenca_w	:= 	qt_estoque_anterior_w + qt_entradas_w - qt_saidas_w - qt_estoque_atual_w;

	if (qt_diferenca_w <> 0) then
		insert into w_saldo_estoque(
			cd_estabelecimento,
			cd_local_estoque,
			cd_material,
			dt_mesano_referencia,
			qt_estoque_atual,
			qt_estoque_anterior,
			qt_entrada,
			qt_saida,
			qt_diferenca,
			qt_emprestimo,
			qt_estoque_lote)
		values (	cd_estabelecimento_w,
			cd_local_estoque_w,
			cd_material_w,
			dt_mesano_referencia_w,
			qt_estoque_atual_w,
			qt_estoque_anterior_w,
			qt_entradas_w,
			qt_saidas_w,
			qt_diferenca_w,
			0,
			0);
	end if;
	commit;
	end;
end loop;
close c000;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_saldo_estoque ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp) FROM PUBLIC;
