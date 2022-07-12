-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_se_tipo_nc_estab ( nr_seq_tipo_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';
qt_existe_w		bigint;


BEGIN

begin
select	count(*)
into STRICT	qt_existe_w
from	qua_tipo_nao_conform_estab
where	nr_seq_tipo_nao_conform = nr_seq_tipo_p;

if (qt_existe_w > 0) then
	select	'S'
	into STRICT	ds_retorno_w
	from	qua_tipo_nao_conform_estab
	where	nr_seq_tipo_nao_conform = nr_seq_tipo_p
	and	cd_estabelecimento = cd_estabelecimento_p  LIMIT 1;
end if;
exception
when others then
	ds_retorno_w := 'N';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_se_tipo_nc_estab ( nr_seq_tipo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
