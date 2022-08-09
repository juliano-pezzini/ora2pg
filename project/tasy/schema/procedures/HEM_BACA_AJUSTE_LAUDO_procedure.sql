-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_baca_ajuste_laudo ( nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_seq_proc
	from	hem_laudo;

nr_seq_proc_w	bigint;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL hem_gerar_laudo(nr_seq_proc_w, nm_usuario_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_baca_ajuste_laudo ( nm_usuario_p text) FROM PUBLIC;
