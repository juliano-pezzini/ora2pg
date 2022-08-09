-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_autor_afterpost_agecons (nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_proc_adic_w	bigint;
					
C01 CURSOR FOR 
	SELECT	nr_sequencia 
	from	agenda_consulta_proc 
	where	nr_seq_agenda = nr_seq_agenda_p 
	and	(cd_procedimento IS NOT NULL AND cd_procedimento::text <> '');
					

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_seq_proc_adic_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL gerar_autor_regra(null, 
			null, 
			null, 
			null, 
			null, 
			null, 
			'AC', 
			nm_usuario_p, 
			null, 
			null, 
			null, 
			nr_seq_agenda_p, 
			null, 
			nr_seq_proc_adic_w, 
			null, 
			null, 
			null);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_autor_afterpost_agecons (nr_seq_agenda_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
