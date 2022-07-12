-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_gerar_rubrica_excl (nr_seq_coluna_p bigint, nr_seq_demo_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(2);


BEGIN

select 	coalesce(max('S'),'T')
into STRICT	ds_retorno_w
from	ctb_demonstrativo a,
		ctb_demo_mes 	  b,
		ctb_demo_col_rubrica c
where	a.nr_sequencia  = b.nr_seq_demo
and		c.nr_seq_coluna = b.nr_sequencia
and		a.nr_sequencia  = nr_seq_demo_p;


if (ds_retorno_w = 'S') then

	select coalesce(max('S'),'N')
	into STRICT   ds_retorno_w
	from   ctb_demo_col_rubrica
	where  nr_seq_coluna	=	nr_seq_coluna_p;

end if;



return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_gerar_rubrica_excl (nr_seq_coluna_p bigint, nr_seq_demo_p bigint) FROM PUBLIC;
