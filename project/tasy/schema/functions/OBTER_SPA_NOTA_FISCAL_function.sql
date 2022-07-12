-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_spa_nota_fiscal (nr_seq_spa_p bigint, nr_nota_fiscal_p bigint) RETURNS varchar AS $body$
DECLARE


ds_Spa_w		varchar(255) := '';
nr_seq_spa_w		spa.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	distinct a.nr_sequencia
	from	spa a,
		spa_movimento b
	where	a.nr_sequencia	= b.nr_seq_spa
	and	b.nr_nota_fiscal = nr_nota_fiscal_p
	and	b.nr_seq_spa <> nr_seq_spa_p
	order by 1;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_spa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	ds_spa_w := ds_spa_w || ',' || nr_seq_spa_w;

end loop;
close C01;

ds_spa_w := substr(ds_spa_w,2,254);

return	ds_Spa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_spa_nota_fiscal (nr_seq_spa_p bigint, nr_nota_fiscal_p bigint) FROM PUBLIC;
