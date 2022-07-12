-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conversao_material ( cd_material_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/* 	EC	- Estoque x Consumo
	CE	- Compra x Estoque */
qt_conversao_w	double precision;


BEGIN

select	max(CASE WHEN ie_opcao_p='CE' THEN qt_conv_compra_estoque  ELSE qt_conv_estoque_consumo END )
into STRICT	qt_conversao_w
from	material
where	cd_material	= cd_material_p;

return qt_conversao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conversao_material ( cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;
