-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_pergunta_os_sup ( nr_seq_pergunta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
ds_retorno_ww			varchar(255);
nr_seq_superior_w			bigint;


BEGIN

select	ds_pergunta,
	nr_seq_superior
into STRICT	ds_retorno_w,
	nr_seq_superior_w
from	pergunta_os
where	nr_sequencia	= nr_seq_pergunta_p;

if (coalesce(nr_seq_superior_w,0)	> 0) then
	select	ds_pergunta
	into STRICT	ds_retorno_ww
	from	pergunta_os
	where	nr_sequencia	= nr_seq_superior_w;

	ds_retorno_w	:= substr(ds_retorno_w || ' - ' || ds_retorno_ww,1,255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_pergunta_os_sup ( nr_seq_pergunta_p bigint) FROM PUBLIC;

