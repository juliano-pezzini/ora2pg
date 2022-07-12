-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cons_mensal_mat_com_cc ( IE_TIPO_P text, CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, DT_MESANO_REFERENCIA_P timestamp) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			double precision;
qt_consumo_w			double precision;
vl_consumo_w			double precision;
dt_mesano_referencia_w		timestamp;


BEGIN

if (coalesce(dt_mesano_referencia_p::text, '') = '') then
	dt_mesano_referencia_w	:= trunc(clock_timestamp(),'mm');
else
	dt_mesano_referencia_w	:= trunc(dt_mesano_referencia_p,'mm');
end if;

select	sum(coalesce(a.qt_consumo,0)) qt_estoque,
	sum(coalesce(a.vl_consumo,0)) vl_consumo
into STRICT	qt_consumo_w,
	vl_consumo_w
from	movto_estoque_operacao_v a
where	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_material		= cd_material_p
and	(a.cd_centro_custo IS NOT NULL AND a.cd_centro_custo::text <> '')
and	trunc(a.dt_mesano_referencia,'mm') = trunc(dt_mesano_referencia_w,'mm');

if (ie_tipo_p = 'Q') then
	ds_retorno_w := qt_consumo_w;
elsif (ie_tipo_p = 'V') then
	ds_retorno_w := vl_consumo_w;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cons_mensal_mat_com_cc ( IE_TIPO_P text, CD_ESTABELECIMENTO_P bigint, CD_MATERIAL_P bigint, DT_MESANO_REFERENCIA_P timestamp) FROM PUBLIC;
