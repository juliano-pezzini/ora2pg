-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_necessita_contato_tel ( nr_seq_agenda_p bigint, ie_necessita_contato_p text) AS $body$
BEGIN

if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_necessita_contato_p IS NOT NULL AND ie_necessita_contato_p::text <> '') then
	update	agenda_consulta
	set	ie_necessita_contato	= ie_necessita_contato_p
	where	nr_sequencia		= nr_seq_agenda_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_necessita_contato_tel ( nr_seq_agenda_p bigint, ie_necessita_contato_p text) FROM PUBLIC;

