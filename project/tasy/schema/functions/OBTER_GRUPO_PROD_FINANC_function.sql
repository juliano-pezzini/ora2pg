-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupo_prod_financ (nr_seq_produto_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
	1 - NR_SEQUENCIA
	2 - DS_GRUPO
*/
nr_seq_grupo_w		bigint;
ds_grupo_w		varchar(255);
ds_retorno_w		varchar(255);
nr_seq_grupo_sup_w	bigint;


BEGIN

select	max(nr_seq_grupo) --Subgrupo
into STRICT	nr_seq_grupo_w
from	produto_financeiro
where	nr_sequencia		= nr_seq_produto_p;

select 	max(nr_seq_grupo_sup) --Grupo
into STRICT	nr_seq_grupo_sup_w
from 	grupo_prod_financ
where 	nr_sequencia	= nr_seq_grupo_w;

if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
	if (ie_opcao_p = 1) then
		ds_retorno_w	:= nr_seq_grupo_sup_w;
	elsif (ie_opcao_p = 2) then
		select	ds_grupo
		into STRICT	ds_grupo_w
		from	grupo_prod_financ
		where	nr_sequencia	= coalesce(nr_seq_grupo_sup_w,nr_seq_grupo_w);
		ds_retorno_w	:= ds_grupo_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupo_prod_financ (nr_seq_produto_p bigint, ie_opcao_p text) FROM PUBLIC;
