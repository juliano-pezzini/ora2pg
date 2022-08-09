-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_alterar_turno_agenda () AS $body$
DECLARE

 
nr_sequencia_w bigint;
qt_registro_w bigint := 0;	
		 
c01 CURSOR FOR 
SELECT	nr_sequencia 
from	agenda_paciente a, 
	agenda b 
where	a.cd_turno <> 3 
and	a.cd_agenda = b.cd_agenda 
and	(to_char(a.hr_inicio,'hh24'))::numeric  >= 19 
and	a.ie_status_agenda <> 'L' 
and	b.cd_tipo_agenda = 1 
and	b.ie_situacao = 'A';
			

BEGIN 
 
open c01;
loop 
fetch c01 into nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	begin 
	update	agenda_paciente 
	set	cd_turno = 3 
	where	nr_sequencia = nr_sequencia_w;
	 
	if (qt_registro_w = 1000) then 
		qt_registro_w := 0;
		commit;
	else 
		qt_registro_w := qt_registro_w + 1;
	end if;
	 
	end;
end loop;
close c01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_alterar_turno_agenda () FROM PUBLIC;
