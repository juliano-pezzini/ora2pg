-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION spa_obter_se_movimento_conv ( nr_seq_spa_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


qt_convenio_w		bigint;
ds_retorno_w		varchar(1);


BEGIN

ds_retorno_w	:= 'N';

select	count(*)
into STRICT	qt_convenio_w
from	spa_movimento
where	nr_seq_spa = nr_seq_spa_p
and	cd_convenio = cd_convenio_p
and	(cd_convenio IS NOT NULL AND cd_convenio::text <> '');

if (coalesce(qt_convenio_w,0) > 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION spa_obter_se_movimento_conv ( nr_seq_spa_p bigint, cd_convenio_p bigint) FROM PUBLIC;

