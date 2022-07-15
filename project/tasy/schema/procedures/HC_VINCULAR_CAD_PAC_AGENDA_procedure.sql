-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_vincular_cad_pac_agenda ( nr_seq_agenda_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


nr_seq_paciente_w		paciente_home_care.nr_sequencia%type;
nr_seq_paciente_hc_w	agenda_hc_paciente.nr_seq_paciente_hc%type;
qt_reg_w				bigint;
			

BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_paciente_w
	from	paciente_home_care
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	((coalesce(dt_final::text, '') = '') or (dt_final < clock_timestamp()))
	and	ie_situacao = 'A';

	select	max(nr_seq_paciente_hc)
	into STRICT	nr_seq_paciente_hc_w
	from	agenda_hc_paciente
	where	nr_sequencia = nr_seq_agenda_p;
	
	if (nr_seq_paciente_hc_w IS NOT NULL AND nr_seq_paciente_hc_w::text <> '') then
	
		select	count(*)
		into STRICT	qt_reg_w
		from	paciente_home_care
		where	cd_pessoa_fisica = cd_pessoa_fisica_p
		and		nr_sequencia = nr_seq_paciente_hc_w;
		
		if (qt_reg_w <> 0) then
			nr_seq_paciente_w := null;
		end if;
	end if;
	
	if (nr_seq_paciente_w IS NOT NULL AND nr_seq_paciente_w::text <> '') then	
		update	agenda_hc_paciente
		set	nr_seq_paciente_hc = nr_seq_paciente_w
		where	nr_sequencia = nr_seq_agenda_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_vincular_cad_pac_agenda ( nr_seq_agenda_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

