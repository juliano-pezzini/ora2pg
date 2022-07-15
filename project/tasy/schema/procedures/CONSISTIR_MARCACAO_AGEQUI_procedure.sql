-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_marcacao_agequi ( nr_seq_paciente_p bigint, nr_seq_pend_agenda_p bigint, cd_estabelecimento_p bigint, dt_calendario_p timestamp, dt_mouse_down_p timestamp, cd_pessoa_fisica_p text, ie_utiliza_prof_ref_p text, ie_status_mouse_down_p text, ie_consiste_saldo_medic_p text, ds_erro_p INOUT text, ie_visualizar_prof_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


qt_prof_w		bigint;

BEGIN
if (trunc(dt_calendario_p) < trunc(clock_timestamp()))	or
	((clock_timestamp() > dt_mouse_down_p) and (ie_status_mouse_down_p <> 'EA')) then
	--Não é permitido realizar agendamentos anteriores a hora atual.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(286544);
end if;


if (ie_consiste_saldo_medic_p = 'S') then
	ds_erro_p := qt_verifica_saldo_material(nr_seq_paciente_p, nm_usuario_p, ds_erro_p);
end if;

if (ie_status_mouse_down_p = 'L') and (Qt_Obter_Se_Horario_Concor(nr_seq_pend_agenda_p, dt_mouse_down_p, nm_usuario_p, cd_estabelecimento_p) = 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(286548);
end if;

if (ie_status_mouse_down_p = 'L') and (ie_utiliza_prof_ref_p = 'S') then
	select	count(*)
	into STRICT	qt_prof_w
	from	qt_paciente_prof
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (qt_prof_w = 0) then
		ie_visualizar_prof_p := 'S';
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_marcacao_agequi ( nr_seq_paciente_p bigint, nr_seq_pend_agenda_p bigint, cd_estabelecimento_p bigint, dt_calendario_p timestamp, dt_mouse_down_p timestamp, cd_pessoa_fisica_p text, ie_utiliza_prof_ref_p text, ie_status_mouse_down_p text, ie_consiste_saldo_medic_p text, ds_erro_p INOUT text, ie_visualizar_prof_p INOUT text, nm_usuario_p text) FROM PUBLIC;

