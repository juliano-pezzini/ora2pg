-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_coop_segurado () AS $body$
DECLARE


nr_seq_congenere_w	bigint;
nr_seq_repasse_w	bigint;
cd_cooperativa_w	varchar(10);

C01 CURSOR FOR
	SELECT	nr_seq_congenere,
		nr_sequencia
	from	pls_segurado_repasse
	where	coalesce(cd_cooperativa::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_congenere_w,
	nr_seq_repasse_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	begin
	select	max(cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;
	exception
	when others then
		cd_cooperativa_w := '';
	end;

	if (cd_cooperativa_w IS NOT NULL AND cd_cooperativa_w::text <> '') then
		update	pls_segurado_repasse
		set	cd_cooperativa	= cd_cooperativa_w
		where	nr_sequencia	= nr_seq_repasse_w;
	end if;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_coop_segurado () FROM PUBLIC;
