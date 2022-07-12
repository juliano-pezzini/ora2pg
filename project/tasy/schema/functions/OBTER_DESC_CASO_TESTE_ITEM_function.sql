-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_caso_teste_item ( nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (coalesce(nr_seq_item_p,0) > 0) then
	select	a.ds_caso_teste
	into STRICT	ds_retorno_w
	from	teste_caso_teste_item b,
		teste_caso_teste a
	where	a.nr_sequencia = b.nr_seq_caso_teste
	and	b.nr_sequencia = nr_seq_item_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_caso_teste_item ( nr_seq_item_p bigint) FROM PUBLIC;
