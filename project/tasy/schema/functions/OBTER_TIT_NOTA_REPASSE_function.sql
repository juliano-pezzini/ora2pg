-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tit_nota_repasse (NR_REPASSE_TERCEIRO_P bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000):= '';
nr_titulo_w		bigint;

/*Títulos das notas fiscais do repasse*/

c01 CURSOR FOR
	SELECT	b.nr_titulo
	from	titulo_pagar b,
		repasse_nota_fiscal a
	where	a.nr_seq_nota_fiscal = b.nr_seq_nota_fiscal
	and	a.nr_repasse_terceiro = nr_repasse_terceiro_p
	order by
		b.nr_titulo;


BEGIN
open c01;
loop
fetch c01 into	nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	if (coalesce(ds_retorno_w::text, '') = '') then
		ds_retorno_w := nr_titulo_w;
	else
		ds_retorno_w := ds_retorno_w || ', ' || nr_titulo_w;
	end if;
end loop;
close c01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tit_nota_repasse (NR_REPASSE_TERCEIRO_P bigint) FROM PUBLIC;
