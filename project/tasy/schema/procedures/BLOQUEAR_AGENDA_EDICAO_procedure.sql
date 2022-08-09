-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bloquear_agenda_edicao (nr_seq_agenda_p bigint, ie_bloq_desbloqueia_p text, nm_usuario_p text) AS $body$
DECLARE

/*
ie_bloq_desbloqueia_p:
B = Bloqueia
D =Desbloqueia via fonte
T =Desbloqueia via trigger
*/
nr_serial_session_w				v$session.serial#%type;
nr_sid_session_w				v$session.sid%type;
ie_bloq_simult_agenda_cir_w		parametro_agenda.ie_bloq_simult_agenda_cir%type;


BEGIN

ie_bloq_simult_agenda_cir_w := obter_parametro_agenda(wheb_usuario_pck.get_cd_estabelecimento, 'IE_BLOQ_SIMULT_AGENDA_CIR', 'N');

if (coalesce(ie_bloq_desbloqueia_p, 'N') = 'B'
	and (coalesce(ie_bloq_simult_agenda_cir_w,'N') = 'S')) then

	select	max(serial#),
			max(sid)
	into STRICT	nr_serial_session_w,
			nr_sid_session_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );

	insert into agenda_paciente_edicao(nr_seq_agenda,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_serial_session,
			nr_sid_session)
	values (nr_seq_agenda_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_serial_session_w,
			nr_sid_session_w);

	commit;
elsif (coalesce(ie_bloq_desbloqueia_p, 'N') = 'D') then

	delete	FROM agenda_paciente_edicao
	where	nr_seq_agenda = nr_seq_agenda_p;

	commit;

elsif (coalesce(ie_bloq_desbloqueia_p, 'N') = 'T'
	and (coalesce(ie_bloq_simult_agenda_cir_w,'N') = 'S')) then /*Desbloqueio via trigger - NAO COLOCAR COMMIT*/
	delete	FROM agenda_paciente_edicao
	where	nr_seq_agenda = nr_seq_agenda_p
	and		upper(nm_usuario_nrec) = upper(nm_usuario_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bloquear_agenda_edicao (nr_seq_agenda_p bigint, ie_bloq_desbloqueia_p text, nm_usuario_p text) FROM PUBLIC;
