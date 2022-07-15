-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_transferir_agenda ( nr_seq_agenda_orig_p agenda_paciente.nr_sequencia%type, nr_seq_agenda_dest_p agenda_paciente.nr_sequencia%type) AS $body$
DECLARE


qt_reg_w	bigint;


BEGIN

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_procedimento
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_procedimento
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_material
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_material
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_gasoterapia
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_gasoterapia
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;


	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_recomendacao
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_recomendacao
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_dialise
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_dialise
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_dieta
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_dieta
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_hemoterapia
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_hemoterapia
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

	select	count(*)
	into STRICT	qt_reg_w
	from	cpoe_anatomia_patologica
	where	nr_seq_agenda = nr_seq_agenda_orig_p;

	if (qt_reg_w > 0) then
		update	cpoe_anatomia_patologica
		set		nr_seq_agenda	= nr_seq_agenda_dest_p
		where	nr_seq_agenda	= nr_seq_agenda_orig_p;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_transferir_agenda ( nr_seq_agenda_orig_p agenda_paciente.nr_sequencia%type, nr_seq_agenda_dest_p agenda_paciente.nr_sequencia%type) FROM PUBLIC;

