-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reservar_horario_checkup (nr_seq_agenda_p bigint, nm_usuario_p text, ie_reservado_p INOUT text) AS $body$
DECLARE


qt_agenda_w		bigint;
ie_reservado_w	varchar(1) := 'S';

qt_w			bigint;

BEGIN

begin
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') then

	select	1
	into STRICT	qt_w
	from	checkup
	where	nr_sequencia = nr_seq_agenda_p
	for update;

	select	coalesce(count(*),0)
	into STRICT	qt_agenda_w
	from	checkup
	where	nr_sequencia			= nr_seq_agenda_p
	and	coalesce(ie_status_agenda,'L')	= 'L';

	if (qt_agenda_w > 0) then
		update	checkup
		set	ie_status_agenda	= 'N',
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_agenda_p;
		commit;
		ie_reservado_w := 'S';
	else
		begin
		select	coalesce(count(*),0)
		into STRICT	qt_agenda_w
		from	checkup
		where	nr_sequencia			= nr_seq_agenda_p
		and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');

		if (qt_agenda_w > 0) then
			ie_reservado_w := 'S';
		else
			ie_reservado_w := 'N';
		end if;
		end;
	end if;
end if;
exception
	when others then
	commit;
end;

commit;

ie_reservado_p := ie_reservado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reservar_horario_checkup (nr_seq_agenda_p bigint, nm_usuario_p text, ie_reservado_p INOUT text) FROM PUBLIC;
