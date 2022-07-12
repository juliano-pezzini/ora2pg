-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consumo_dias_ressup ( cd_estabelecimento_p bigint, cd_material_p bigint, qt_dias_consumo_p bigint, qt_dias_fixo_p bigint) RETURNS bigint AS $body$
DECLARE


qt_consumo_w		movimento_estoque.qt_estoque%type;
qt_resultado_w		movimento_estoque.qt_estoque%type := 0;


BEGIN

select	coalesce(sum(qt_consumo),0) qt_movimento
into STRICT	qt_consumo_w
from   	movimento_estoque_v a,
       	material m
where  	a.cd_material_estoque	= m.cd_material_estoque
and  	m.cd_material         	= cd_material_p
and  	dt_mesano_referencia  	>= trunc(clock_timestamp() - qt_dias_consumo_p,'mm')
and  	a.cd_estabelecimento 	= cd_estabelecimento_p
and 	not exists (   SELECT	1
			from	operacao_nota x
			where	x.cd_operacao_estoque = a.cd_operacao_estoque
			and	coalesce(x.ie_transferencia_estab, 'N') = 'S')
and 	trunc(dt_movimento_estoque,'dd') between trunc(clock_timestamp(),'dd') - qt_dias_consumo_p and clock_timestamp() - interval '1 days';

qt_resultado_w := (dividir(qt_consumo_w, qt_dias_consumo_p) * qt_dias_fixo_p);

return  qt_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consumo_dias_ressup ( cd_estabelecimento_p bigint, cd_material_p bigint, qt_dias_consumo_p bigint, qt_dias_fixo_p bigint) FROM PUBLIC;

