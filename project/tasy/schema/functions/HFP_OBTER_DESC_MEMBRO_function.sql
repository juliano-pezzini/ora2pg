-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hfp_obter_desc_membro ( nr_seq_membro_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
if (coalesce(nr_seq_membro_p,0) > 0) then
	begin
	select	max(ds_membro)
	into STRICT	ds_retorno_w
	from	hfp_membro
	where	nr_sequencia = nr_seq_membro_p;

	end;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hfp_obter_desc_membro ( nr_seq_membro_p bigint) FROM PUBLIC;
