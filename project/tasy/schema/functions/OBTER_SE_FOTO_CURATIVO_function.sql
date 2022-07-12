-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_foto_curativo (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


qt_foto_w	bigint;
ds_retorno_w	varchar(5) := 'N';


BEGIN

select count(*)
into STRICT   qt_foto_w
from   cur_ferida b,
       cur_foto c
where  c.nr_seq_ferida = b.nr_sequencia
and    b.nr_sequencia = nr_sequencia_p;

if (qt_foto_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_foto_curativo (nr_sequencia_p bigint) FROM PUBLIC;

