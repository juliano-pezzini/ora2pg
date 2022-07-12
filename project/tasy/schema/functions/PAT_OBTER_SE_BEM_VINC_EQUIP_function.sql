-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pat_obter_se_bem_vinc_equip ( nr_seq_bem_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(1);
qt_registro_w				smallint;


BEGIN

select 	count(*)
into STRICT	qt_registro_w
from	man_equipamento
where 	nr_seq_bem = nr_seq_bem_p;

ds_retorno_w := 'N';

if (qt_registro_w > 0) then
	select	max('S')
	into STRICT	ds_retorno_w
	from	man_equipamento
	where	nr_seq_bem = nr_seq_bem_p;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pat_obter_se_bem_vinc_equip ( nr_seq_bem_p bigint) FROM PUBLIC;
