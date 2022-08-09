-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_agenda_consultorio ( nr_seq_agenda_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin

	update	agenda_consulta
	set	cd_pessoa_fisica	= cd_pessoa_fisica_p,
		ie_necessita_contato	= 'N',
		ie_status_agenda	= 'N',
		ie_status_paciente	= '1',
		nm_usuario_origem	= nm_usuario_p
	where	nr_sequencia		= nr_seq_agenda_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_agenda_consultorio ( nr_seq_agenda_p bigint, cd_medico_p text, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
