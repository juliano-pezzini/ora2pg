-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_grupo_produto ( nr_seq_grupo_produto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_grupo_w	pls_grupo_produto.ds_grupo%type;


BEGIN

if (nr_seq_grupo_produto_p IS NOT NULL AND nr_seq_grupo_produto_p::text <> '') then
	select	max(ds_grupo)
	into STRICT	ds_grupo_w
	from	pls_grupo_produto
	where	nr_sequencia = nr_seq_grupo_produto_p;
end if;

return	ds_grupo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_grupo_produto ( nr_seq_grupo_produto_p bigint) FROM PUBLIC;
