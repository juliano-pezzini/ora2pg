-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_quimio_dur_agecons (dt_agenda_p timestamp, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


qt_agenda_w		bigint;
qt_tempo_agenda_w	bigint;


BEGIN

qt_tempo_agenda_w := obter_param_usuario(821, 433, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_tempo_agenda_w);

if (qt_tempo_agenda_w IS NOT NULL AND qt_tempo_agenda_w::text <> '') then
	select 	count(*)
	into STRICT	qt_agenda_w
	from 	agenda_quimio
	where   cd_pessoa_fisica = cd_pessoa_fisica_p
	and	dt_agenda between trunc(dt_agenda_p) and trunc(dt_agenda_p) + 86399/86400
	and	dt_agenda_p between dt_agenda and (dt_agenda + (nr_minuto_duracao - 1)/ 1440) + (coalesce(qt_tempo_agenda_w,0) / 1440)
	and	ie_status_agenda not in ('C','F','S');

	if (qt_agenda_w > 0) then
		CALL wheb_mensagem_pck.Exibir_mensagem_abort(214101);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_quimio_dur_agecons (dt_agenda_p timestamp, cd_pessoa_fisica_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

