-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reservar_hora_agenda_pac_js ( nr_seq_agenda_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE

ie_reservado_w	varchar(1);

BEGIN
if (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	ie_reservado_w := reservar_horario_agenda_exame(
			nr_seq_agenda_p, nm_usuario_p, ie_reservado_w);
	if (ie_reservado_w = 'N') then
		begin
		ds_erro_p := obter_texto_tasy(90372, wheb_usuario_pck.get_nr_seq_idioma);
		end;
	end if;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reservar_hora_agenda_pac_js ( nr_seq_agenda_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

