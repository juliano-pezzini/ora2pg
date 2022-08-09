-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_inserir_mod_agenda (nr_sequencia_p bigint, nr_seq_curso_p bigint, nm_usuario_p text, dt_inicio_p timestamp, dt_termino_p timestamp) AS $body$
DECLARE



qt_carga_horaria_w	double precision;
nr_seq_modulo_w		bigint;
nr_seq_evento_cont_w	bigint;


c01 CURSOR FOR
SELECT	nr_sequencia,
	qt_carga_horaria
from	tre_curso_modulo
where	nr_seq_curso	= nr_seq_curso_p;


BEGIN

open c01;
loop
	fetch c01 into
		nr_seq_modulo_w,
		qt_carga_horaria_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	begin

	insert into tre_agenda_modulo(
		nr_sequencia,
		nr_seq_agenda,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_modulo,
		dt_inicio,
		dt_termino,
		qt_carga_horaria)
	values (nextval('tre_evento_modulo_seq'),
		nr_sequencia_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_modulo_w,
		dt_inicio_p,
		dt_termino_p,
		qt_carga_horaria_w);
	end;

end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_inserir_mod_agenda (nr_sequencia_p bigint, nr_seq_curso_p bigint, nm_usuario_p text, dt_inicio_p timestamp, dt_termino_p timestamp) FROM PUBLIC;
