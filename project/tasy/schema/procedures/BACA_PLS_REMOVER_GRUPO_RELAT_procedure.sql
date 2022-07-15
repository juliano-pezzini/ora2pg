-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_remover_grupo_relat () AS $body$
DECLARE


nr_seq_regra_relat_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_regra_relatorio 	a,
		pls_regra_relat_grupo	b
	where	b.nr_sequencia		= a.nr_seq_grupo
	and	b.nr_seq_grupo_relat	= 29;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_regra_relat_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	delete from pls_regra_relatorio where nr_sequencia = nr_seq_regra_relat_w;
	end;
end loop;
close C01;

delete from pls_regra_relat_grupo where	nr_seq_grupo_relat = 29;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_remover_grupo_relat () FROM PUBLIC;

