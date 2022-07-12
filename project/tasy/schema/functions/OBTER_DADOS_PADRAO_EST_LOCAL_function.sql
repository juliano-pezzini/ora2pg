-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_padrao_est_local ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE



/*
M = QT_ESTOQUE_MINIMO
A - QT_ESTOQUE_MAXIMO
*/
qt_estoque_minimo_w		double precision;
qt_estoque_maximo_w		double precision;


BEGIN

select	coalesce(qt_estoque_minimo,0),
	coalesce(qt_estoque_maximo,0)
into STRICT	qt_estoque_minimo_w,
	qt_estoque_maximo_w
from	padrao_estoque_local
where	cd_local_estoque = cd_local_estoque_p
and	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p;

if (ie_opcao_p = 'M') then
	return qt_estoque_minimo_w;
elsif (ie_opcao_p = 'A') then
	return qt_estoque_maximo_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_padrao_est_local ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;
