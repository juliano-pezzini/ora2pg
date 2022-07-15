-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancel_agenda_consulta_ageserv ( nr_seq_agenda_p bigint, ie_cancel_fut_obito_p text, cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_motivo_p text, ds_observacao_p text, nm_usuario_p text, ie_pac_age_futura_p INOUT text, ds_msg_p INOUT text) AS $body$
BEGIN
 
if (ie_cancel_fut_obito_p IS NOT NULL AND ie_cancel_fut_obito_p::text <> '') and (ie_cancel_fut_obito_p = 'S') then 
	begin 
	CALL cancelar_agenda_fut_obito( 
		nr_seq_agenda_p, 
		cd_pessoa_fisica_p, 
		dt_agenda_p, 
		cd_motivo_p, 
		ds_observacao_p, 
		nm_usuario_p);
	end;
else 
	begin 
	select	substr(obter_se_pac_age_futura(nr_seq_agenda_p), 1,1) 
	into STRICT	ie_pac_age_futura_p 
	;
 
	ds_msg_p	:= substr(obter_texto_tasy(49956, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancel_agenda_consulta_ageserv ( nr_seq_agenda_p bigint, ie_cancel_fut_obito_p text, cd_pessoa_fisica_p text, dt_agenda_p timestamp, cd_motivo_p text, ds_observacao_p text, nm_usuario_p text, ie_pac_age_futura_p INOUT text, ds_msg_p INOUT text) FROM PUBLIC;

