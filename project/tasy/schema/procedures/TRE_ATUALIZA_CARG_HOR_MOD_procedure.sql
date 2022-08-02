-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_atualiza_carg_hor_mod (nr_seq_evento_p bigint) AS $body$
DECLARE


qt_carga_horaria_w	bigint;


BEGIN
select	coalesce(sum(qt_carga_horaria),0)
into STRICT	qt_carga_horaria_w
from	tre_evento_modulo
where	nr_seq_evento = nr_seq_evento_p;

update   tre_evento
set      qt_carga_horaria = qt_carga_horaria_w
where    nr_sequencia = nr_seq_evento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_atualiza_carg_hor_mod (nr_seq_evento_p bigint) FROM PUBLIC;

