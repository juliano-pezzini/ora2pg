-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_exclusao_turno ( cd_agenda_p bigint, cd_tipo_agenda_p bigint, nr_seq_turno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_agendamentos_w	bigint;


BEGIN

ds_erro_p	:= '';

if (cd_tipo_agenda_p = 2) then

	select	count(*)
	into STRICT	qt_agendamentos_w
	from	agenda_paciente
	where	cd_agenda = cd_agenda_p
	and	nr_seq_horario = nr_seq_turno_p
	and	dt_agenda <= clock_timestamp()
	and	ie_status_agenda <> 'L';

	if (qt_agendamentos_w > 0) then
		ds_erro_p := wheb_mensagem_pck.get_texto(281754,null);
	end if;
else
	select	count(*)
	into STRICT	qt_agendamentos_w
	from	agenda_consulta
	where	cd_agenda = cd_agenda_p
	and	nr_seq_turno = nr_seq_turno_p
	and	dt_agenda <= clock_timestamp()
	and	ie_status_agenda <> 'L';

	if (qt_agendamentos_w > 0) then
		ds_erro_p := wheb_mensagem_pck.get_texto(281754,null);
	end if;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_exclusao_turno ( cd_agenda_p bigint, cd_tipo_agenda_p bigint, nr_seq_turno_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

