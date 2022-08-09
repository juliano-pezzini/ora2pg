-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_agenda_dia (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_status_p text, cd_pessoa_fisica_p text, nm_usuario_p text) AS $body$
DECLARE


ie_altera_status_confirmada_w parametro_agenda.ie_altera_status_confirmada%type;
						

BEGIN
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (dt_agenda_p IS NOT NULL AND dt_agenda_p::text <> '') and (ie_status_p IS NOT NULL AND ie_status_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	if (ie_status_p = 'A') then
		update	agenda_paciente
		set	ie_status_agenda		= ie_status_p,
			dt_chegada			= clock_timestamp(),
			nm_usuario			= nm_usuario_p
        where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda_p)
		and	ie_status_agenda		= 'N'
		and	coalesce(dt_chegada::text, '') = ''
		and	cd_pessoa_fisica		= cd_pessoa_fisica_p
		and	nr_sequencia			<> nr_seq_agenda_p;
	elsif (ie_status_p = 'O') then
		update	agenda_paciente
		set	ie_status_agenda		= ie_status_p,
			dt_atendimento		= clock_timestamp(),
			nm_usuario			= nm_usuario_p
		where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda_p)
		and	ie_status_agenda		= 'A'
		and	coalesce(dt_atendimento::text, '') = ''
		and	cd_pessoa_fisica		= cd_pessoa_fisica_p
		and	nr_sequencia			<> nr_seq_agenda_p;
	elsif (ie_status_p = 'AC') then
		select 	coalesce(max(ie_altera_status_confirmada),'N')
		into STRICT 	ie_altera_status_confirmada_w
		from 	parametro_agenda
		where	cd_estabelecimento = obter_estabelecimento_ativo;
			
		update	agenda_paciente
		set	dt_confirmacao		= clock_timestamp(),
			nm_usuario_confirm	= nm_usuario_p,
			nm_usuario			= nm_usuario_p,
			ie_status_agenda	= CASE WHEN ie_altera_status_confirmada_w='S' THEN 'CN'  ELSE ie_status_agenda END
		where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda_p)
		and	ie_status_agenda	= 'N'
		and	coalesce(dt_confirmacao::text, '') = ''
		and	cd_pessoa_fisica	= cd_pessoa_fisica_p
		and	nr_sequencia		<> nr_seq_agenda_p;
	elsif (ie_status_p = 'AD') then
		update	agenda_paciente
		set		dt_atendido				= clock_timestamp(),			
				nm_usuario				= nm_usuario_p,
				ie_status_agenda		= ie_status_p
		where	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda)	= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_agenda_p)
		and		ie_status_agenda		= 'O'
		and		coalesce(dt_atendido::text, '') = ''
		and		cd_pessoa_fisica		= cd_pessoa_fisica_p
		and		nr_sequencia			<> nr_seq_agenda_p;
	end if;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_agenda_dia (cd_agenda_p bigint, nr_seq_agenda_p bigint, dt_agenda_p timestamp, ie_status_p text, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;
