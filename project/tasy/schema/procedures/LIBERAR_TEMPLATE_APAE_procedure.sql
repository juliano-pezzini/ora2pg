-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_template_apae (nm_usuario_p text, nr_seq_aval_pre_p bigint) AS $body$
DECLARE


nr_seq_registro_w bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	ehr_registro
	where	 nr_seq_aval_pre = nr_seq_aval_pre_p;


BEGIN

if (nr_seq_aval_pre_p IS NOT NULL AND nr_seq_aval_pre_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		nr_seq_registro_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		update 	ehr_reg_template
		set	dt_liberacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where   nr_seq_reg = nr_seq_registro_w
		  and	coalesce(dt_liberacao::text, '') = '';
		end;
	end loop;
	close C01;

	update 	ehr_registro
	set	dt_liberacao 	= clock_timestamp(),
		nm_usuario_liberacao	= nm_usuario_p
	where   nr_seq_aval_pre = nr_seq_aval_pre_p
	  and 	coalesce(dt_liberacao::text, '') = '';

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_template_apae (nm_usuario_p text, nr_seq_aval_pre_p bigint) FROM PUBLIC;
