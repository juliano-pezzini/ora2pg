-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_cooperativa_conta ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_w			bigint;
cd_cooperativa_w		smallint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		substr(obter_cooperativa_benef(nr_seq_segurado,cd_estabelecimento),1,4)
	from	pls_conta
	where	coalesce(cd_cooperativa::text, '') = '';


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_conta_w,
	cd_cooperativa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	update	pls_conta
	set	cd_cooperativa	= cd_cooperativa_w,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_conta_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_cooperativa_conta ( nm_usuario_p text) FROM PUBLIC;

