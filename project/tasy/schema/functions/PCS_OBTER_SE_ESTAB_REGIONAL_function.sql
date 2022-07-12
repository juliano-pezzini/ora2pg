-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_se_estab_regional ( cd_estabelecimento_p bigint, nr_seq_regional_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
qt_existe_w	integer;



BEGIN

select	count(*)
into STRICT	qt_existe_w
from	pcs_estab_regionais
where	nr_seq_regional = nr_seq_regional_p
and	cd_estab_vinculado = cd_estabelecimento_p;

if (coalesce(qt_existe_w,0) > 0) then
	ds_retorno_w := 'S';
else
	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_se_estab_regional ( cd_estabelecimento_p bigint, nr_seq_regional_p bigint) FROM PUBLIC;
