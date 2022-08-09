-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_atender_reserva ( nr_seq_reserva_p bigint) AS $body$
BEGIN
if (nr_seq_reserva_p IS NOT NULL AND nr_seq_reserva_p::text <> '') then
	update	nut_reserva_pf
	set	ie_status = 'A',
		dt_atendido = clock_timestamp()
	where	nr_sequencia = nr_seq_reserva_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_atender_reserva ( nr_seq_reserva_p bigint) FROM PUBLIC;
