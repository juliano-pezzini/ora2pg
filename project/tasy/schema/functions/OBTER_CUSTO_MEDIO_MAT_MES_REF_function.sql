-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_custo_medio_mat_mes_ref ( cd_estabelecimento_p bigint, qt_meses_p bigint, dt_mesano_referencia_p timestamp, cd_material_p bigint) RETURNS bigint AS $body$
DECLARE


vl_custo_medio_w		double precision;
vl_custo_w			double precision;
vl_custo_soma_w			double precision;
dt_mesano_referencia_w		timestamp;
qt_divide_w			smallint;

C01 CURSOR FOR
	SELECT	max(vl_custo_medio),
		dt_mesano_referencia
	from	saldo_estoque
	where	cd_estabelecimento = cd_estabelecimento_p
	and	dt_mesano_referencia between pkg_date_utils.add_month(pkg_date_utils.start_of(dt_mesano_referencia_p,'MONTH', 0), - qt_meses_p, 0) and pkg_date_utils.start_of(dt_mesano_referencia_p,'MONTH', 0)
	and	cd_material = cd_material_p
	group by dt_mesano_referencia;


BEGIN
vl_custo_soma_w		:= 0;
qt_divide_w		:= 0;

open c01;
loop
fetch c01 into
	vl_custo_w,
	dt_mesano_referencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	vl_custo_soma_w	:= vl_custo_soma_w + vl_custo_w;
	qt_divide_w	:= qt_divide_w + 1;
	end;
end loop;
close c01;

if (vl_custo_soma_w > 0) and (qt_divide_w > 0) then
	vl_custo_medio_w	:= dividir(vl_custo_soma_w, qt_divide_w);
end if;

return	vl_custo_medio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_custo_medio_mat_mes_ref ( cd_estabelecimento_p bigint, qt_meses_p bigint, dt_mesano_referencia_p timestamp, cd_material_p bigint) FROM PUBLIC;

