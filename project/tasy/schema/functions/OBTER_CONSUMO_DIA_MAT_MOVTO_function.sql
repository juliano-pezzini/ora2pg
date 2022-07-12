-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_consumo_dia_mat_movto ( cd_material_p bigint, cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, dt_dia_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_mesano_referencia_w	timestamp;
dt_dia_w			timestamp;
ds_retorno_w		double precision;


BEGIN

dt_mesano_referencia_w	:= TRUNC(dt_mesano_referencia_p,'mm');
dt_dia_w			:= TRUNC(dt_dia_p,'dd');

SELECT	coalesce(SUM(m.qt_consumo),0)
INTO STRICT	ds_retorno_w
FROM	movimento_estoque_v m,
		material n
WHERE	(m.dt_processo IS NOT NULL AND m.dt_processo::text <> '')
AND		m.cd_material 	 	 	= n.cd_material
AND		m.dt_mesano_referencia	= dt_mesano_referencia_w
AND		m.cd_material_estoque	= cd_material_p
AND		m.cd_estabelecimento	= cd_estabelecimento_p
AND		TRUNC(m.dt_movimento_estoque,'dd') 	= dt_dia_w;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_consumo_dia_mat_movto ( cd_material_p bigint, cd_estabelecimento_p bigint, dt_mesano_referencia_p timestamp, dt_dia_p timestamp) FROM PUBLIC;
