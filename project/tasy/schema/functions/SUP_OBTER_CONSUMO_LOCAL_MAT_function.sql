-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_consumo_local_mat ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


/* Traz o consumo do material por local de estoque ou não*/

vl_retorno_w					double precision;
qt_consumo_w					double precision;
vl_consumo_w					double precision;


BEGIN

select	sum(coalesce(a.qt_consumo,0)) qt_estoque,
	sum(coalesce(a.vl_consumo,0)) vl_consumo
into STRICT	qt_consumo_w,
	vl_consumo_w
from	movto_estoque_operacao_v a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_local_estoque	= coalesce(cd_local_estoque_p, a.cd_local_estoque)
and	a.cd_material		= cd_material_p
and	trunc(a.dt_mesano_referencia,'mm') = trunc(dt_mesano_referencia_p,'mm');

if (ie_tipo_p = 'Q') then
	vl_retorno_w := qt_consumo_w;
elsif (ie_tipo_p = 'V') then
	vl_retorno_w := vl_consumo_w;
end if;

return  vl_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_consumo_local_mat ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, dt_mesano_referencia_p timestamp, ie_tipo_p text) FROM PUBLIC;

