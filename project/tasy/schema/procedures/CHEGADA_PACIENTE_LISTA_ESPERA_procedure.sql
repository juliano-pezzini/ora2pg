-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chegada_paciente_lista_espera ( nr_seq_lista_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_w         agenda_lista_espera.nr_seq_agenda%type;
					

BEGIN
if (nr_seq_lista_p IS NOT NULL AND nr_seq_lista_p::text <> '') then
	begin
	/* Verifica se o agendamento na lista de espera ja esta agendado na agenda de exames */

	select	coalesce(max(nr_seq_agenda),0)
	into STRICT	nr_seq_agenda_w
	from	agenda_lista_espera
	where	nr_sequencia	= nr_seq_lista_p;
	
	/* Se ja estiver, ao dar chegada do paciente na lista de espera, dara chegada do paciente na agenda de exames */

	if (nr_seq_agenda_w <> 0) then
		update	agenda_paciente
		set	ie_status_agenda	= 'A',
			dt_chegada		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia	= nr_seq_agenda_w;
	end if;
	
	/* Da chegada do paciente na lista de espera */

	update	agenda_lista_espera
	set	ie_status_espera	= 'A',
		dt_chegada	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_lista_p;	
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chegada_paciente_lista_espera ( nr_seq_lista_p bigint, nm_usuario_p text) FROM PUBLIC;

