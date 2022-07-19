-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_definir_fase_cron ( nr_seq_cronograma_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_etapa_w	bigint;
qt_inferior_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	proj_cron_etapa
	where	nr_seq_cronograma = nr_seq_cronograma_p
	order by
		nr_sequencia;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_etapa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	count(*)
	into STRICT	qt_inferior_w
	from	proj_cron_etapa
	where	nr_seq_superior = nr_seq_etapa_w;

	if (qt_inferior_w > 0) then

		update	proj_cron_etapa
		set 	ie_fase = 'S'
		where 	nr_sequencia = nr_seq_etapa_w;

	elsif (qt_inferior_w = 0) then

		update	proj_cron_etapa
		set 	ie_fase = 'N'
		where 	nr_sequencia = nr_seq_etapa_w;

	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_definir_fase_cron ( nr_seq_cronograma_p bigint, nm_usuario_p text) FROM PUBLIC;

