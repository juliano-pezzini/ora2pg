-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_media_consumo_local_mat ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE

 
qt_mes_consumo_w				smallint;
IE_MES_ATUAL_CONSUMO_w			varchar(1);

dt_mesano_inicio_w				timestamp;
dt_mesano_fim_w					timestamp;

vl_retorno_w					double precision;
qt_consumo_w					double precision;
vl_consumo_w					double precision;


BEGIN 
select 	max(qt_mes_consumo), 
	max(IE_MES_ATUAL_CONSUMO) 
into STRICT	qt_mes_consumo_w, 
	IE_MES_ATUAL_CONSUMO_w 
from 	PARAMETRO_COMPRAS 
where	cd_estabelecimento = cd_estabelecimento_p;
 
if (IE_MES_ATUAL_CONSUMO_w = 'S') then 
	dt_mesano_inicio_w 	:= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),((qt_mes_consumo_w - 1) * -1), 0),'MONTH', 0);
	dt_mesano_fim_w		:= pkg_date_utils.end_of(clock_timestamp(),'MONTH',0);
else 
	dt_mesano_inicio_w	:= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),(qt_mes_consumo_w * -1), 0),'MONTH', 0);
	dt_mesano_fim_w		:= PKG_DATE_UTILS.end_of(PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(),-1, 0),'MONTH', 0);
end if;
 
if (coalesce(cd_local_estoque_p::text, '') = '') then 
	begin 
 
	select coalesce(sum(CASE WHEN b.ie_consumo='A' THEN  a.qt_estoque WHEN b.ie_consumo='D' THEN  a.qt_estoque * -1  ELSE 0 END ),0) qt_consumo, 
		coalesce(sum(CASE WHEN b.ie_consumo='A' THEN  a.vl_estoque WHEN b.ie_consumo='D' THEN  a.vl_estoque * -1  ELSE 0 END ),0) vl_consumo 
	into STRICT	qt_consumo_w, 
		vl_consumo_w 
	from 	operacao_estoque b, 
		resumo_movto_estoque a 
	where	a.cd_operacao_estoque = b.cd_operacao_estoque 
	and   a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.cd_material		= cd_material_p 
	and	a.dt_mesano_referencia between dt_mesano_inicio_w and dt_mesano_fim_w;
	end;
else 
	begin 
	select coalesce(sum(CASE WHEN b.ie_consumo='A' THEN  a.qt_estoque WHEN b.ie_consumo='D' THEN  a.qt_estoque * -1  ELSE 0 END ),0) qt_consumo, 
		coalesce(sum(CASE WHEN b.ie_consumo='A' THEN  a.vl_estoque WHEN b.ie_consumo='D' THEN  a.vl_estoque * -1  ELSE 0 END ),0) vl_consumo 
	into STRICT	qt_consumo_w, 
		vl_consumo_w 
	from 	operacao_estoque b, 
		resumo_movto_estoque a 
	where	a.cd_operacao_estoque = b.cd_operacao_estoque 
	and   a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.cd_local_estoque	= cd_local_estoque_p 
	and	a.cd_material		= cd_material_p 
	and	a.dt_mesano_referencia between dt_mesano_inicio_w and dt_mesano_fim_w;
	end;
end if;
 
qt_consumo_w 	:= dividir(qt_consumo_w,qt_mes_consumo_w);
vl_consumo_w	:= dividir(vl_consumo_w,qt_mes_consumo_w);
 
if (ie_tipo_p = 'Q') then 
	vl_retorno_w := qt_consumo_w;
elsif (ie_tipo_p = 'V') then 
	vl_retorno_w := vl_consumo_w;
end if;
 
return vl_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_media_consumo_local_mat ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, ie_tipo_p text) FROM PUBLIC;
