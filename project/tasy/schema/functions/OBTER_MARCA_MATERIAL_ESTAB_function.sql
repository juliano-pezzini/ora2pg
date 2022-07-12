-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_marca_material_estab ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_cod_desc_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_marca_w		bigint;
ds_marca_w		varchar(80);
ds_marca_ref_w		varchar(255);

c01 CURSOR FOR
SELECT	b.nr_sequencia,
	b.ds_marca,
	substr(CASE WHEN a.cd_referencia='' THEN b.ds_marca  ELSE b.ds_marca || '(' || a.cd_referencia || ')' END ,1,255)
from	marca b,
	material_marca a
where	a.cd_material		= cd_material_p
and	a.nr_sequencia		= b.nr_sequencia
and	coalesce(a.ie_situacao,'A') 	= 'A'
and	b.ie_situacao		= 'A'
and	coalesce(a.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
order by	coalesce(qt_prioridade, 0);


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_marca_w,
	ds_marca_w,
	ds_marca_ref_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	nr_seq_marca_w	:= nr_seq_marca_w;
	ds_marca_w	:= ds_marca_w;

	end;
end loop;
close c01;

if (ie_cod_desc_p = 'C') then
	return	nr_seq_marca_w;
elsif (ie_cod_desc_p = 'DR') then
	return ds_marca_ref_w;
else
	return	ds_marca_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_marca_material_estab ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_cod_desc_p text) FROM PUBLIC;

