-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_hem_proc_hem_laudo ( nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_proc
	from	hem_laudo
	order by nr_sequencia;


nr_seq_laudo_w	bigint;
nr_seq_proc_w	bigint;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_laudo_w,
	nr_seq_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	hem_manometria_completa
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_analise_manometria
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_coronariografia
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_ventriculografia_proc
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_cineangiocard_proc
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_circulacao_colateral
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	update	hem_conclusao_coron
	set	nr_seq_proc = nr_seq_proc_w
	where	nr_seq_laudo = nr_seq_laudo_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_hem_proc_hem_laudo ( nm_usuario_p text) FROM PUBLIC;
