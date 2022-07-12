-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION paf_requisito_vii_item_8_e2 (cd_material_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);
cd_cgc_w	varchar(20);
qt_estoque_w	double precision;
ie_positivo_w	varchar(1);



BEGIN

select 	cd_cgc
into STRICT	cd_cgc_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

select 	sum(qt_estoque)
into STRICT	qt_estoque_w
from	saldo_estoque
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p
and	dt_mesano_referencia = trunc(clock_timestamp(),'mm');


if (qt_estoque_w >= 0) then
	ie_positivo_w := 'S';
else
	ie_positivo_w := 'N';
end if;


select	'E2' ||
	substr(lpad(cd_cgc_w,14,'0'),1,14) ||
	substr(lpad(m.cd_material,14,'0'),1,14) ||
	substr(rpad(m.ds_material,50,' '),1,50) ||
	substr(rpad(coalesce(b.cd_unidade_venda,' '),06,' '),1,6) ||
	CASE WHEN ie_positivo_w='S' THEN '+'  ELSE '-' END  ||
	lpad(replace(campo_mascara(coalesce(qt_estoque_w,'0'),2),'.',''),9,0) ||
	to_char(clock_timestamp(),'YYYYMMDD')
into STRICT	ds_retorno_w
from	material m,
	material_estab b
where	m.cd_material = b.cd_material
and	m.cd_material = cd_material_p
and	b.cd_estabelecimento = cd_estabelecimento_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION paf_requisito_vii_item_8_e2 (cd_material_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
