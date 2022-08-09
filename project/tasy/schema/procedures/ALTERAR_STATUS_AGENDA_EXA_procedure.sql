-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_agenda_exa (nr_seq_agenda_p bigint, ie_status_agenda_p text) AS $body$
DECLARE


ie_status_valido_w	varchar(1);


BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_status_agenda_p IS NOT NULL AND ie_status_agenda_p::text <> '') then
	/* validar dominio */

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_status_valido_w
	from	valor_dominio
	where	cd_dominio = 83
	and	vl_dominio = ie_status_agenda_p;

	if (ie_status_valido_w = 'S') then
		update	agenda_paciente
		set	ie_status_agenda = ie_status_agenda_p
		where	nr_sequencia = nr_seq_agenda_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_agenda_exa (nr_seq_agenda_p bigint, ie_status_agenda_p text) FROM PUBLIC;
