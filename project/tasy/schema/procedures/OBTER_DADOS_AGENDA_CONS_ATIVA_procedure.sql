-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_agenda_cons_ativa ( ie_dia_semana_p text, ie_diario_p text, cd_diaria_p text, ie_turno_p text, cd_where_p text, dt_agenda_p timestamp, ie_feriado_p text, cd_agenda_p bigint, cd_estabelecimento_p bigint, ds_dia_semana_p INOUT text, ds_feriado_p INOUT text, ds_horario_dia_semana_p INOUT text, ie_informa_exame_lab_p INOUT text) AS $body$
DECLARE


nr_seq_agenda_w			agenda_consulta.nr_sequencia%type;
nm_usuario_w			usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	agenda_consulta
	where	cd_agenda = cd_agenda_p
	and     trunc(dt_agenda) = trunc(dt_agenda_p)
	and     ie_status_agenda = 'N'
	and     coalesce(cd_pessoa_fisica, 0) = 0
	and     coalesce(nm_paciente::text, '') = '';


BEGIN

ds_horario_dia_semana_p	:= obter_dia_semana_agenda_cons(ie_diario_p, dt_agenda_p, cd_agenda_p, cd_diaria_p, ie_turno_p, cd_where_p);

if (ie_dia_semana_p IS NOT NULL AND ie_dia_semana_p::text <> '') and (ie_dia_semana_p = 'S') then
	select	substr(obter_dia_semana(dt_agenda_p), 1,20)
	into STRICT	ds_dia_semana_p
	;
else
	ds_dia_semana_p	:= substr(obter_texto_tasy(47061, wheb_usuario_pck.get_nr_seq_idioma),1,255);
end if;

if (ie_feriado_p IS NOT NULL AND ie_feriado_p::text <> '') and (ie_feriado_p = 'S') then
	select	substr(obter_feriado(dt_agenda_p, cd_estabelecimento_p), 1,40)
	into STRICT	ds_feriado_p
	;
end if;

if (obtain_user_locale(nm_usuario_w) = 'en_AU')	then
/*
	This cursor data is used to reset the interrupted schedule creation by same user
*/
	open	C01;
	loop
	fetch	C01	into
		nr_seq_agenda_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			CALL liberar_horario_reserv_agecons(nr_seq_agenda_w, nm_usuario_w);
		end;
	end loop;
	close C01;
end if;

CALL alterar_status_agenda_regra(cd_estabelecimento_p, 'A');

if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then
	begin
	select	coalesce(max(ie_informa_exame_lab), 'S')
	into STRICT	ie_informa_exame_lab_p
	from	agenda
	where	cd_agenda = cd_agenda_p;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_agenda_cons_ativa ( ie_dia_semana_p text, ie_diario_p text, cd_diaria_p text, ie_turno_p text, cd_where_p text, dt_agenda_p timestamp, ie_feriado_p text, cd_agenda_p bigint, cd_estabelecimento_p bigint, ds_dia_semana_p INOUT text, ds_feriado_p INOUT text, ds_horario_dia_semana_p INOUT text, ie_informa_exame_lab_p INOUT text) FROM PUBLIC;

