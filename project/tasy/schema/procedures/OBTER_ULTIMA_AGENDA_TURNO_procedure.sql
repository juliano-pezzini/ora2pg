-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_ultima_agenda_turno (cd_agenda_p text, nr_seq_turno_p text, dt_final_vigencia_p text, ie_possui_agenda_p INOUT text, mensagem_403289_p INOUT text, mensagem_403436_p INOUT text, dt_ultima_agenda_p INOUT text) AS $body$
DECLARE


dt_agenda_w					timestamp;
dif_datas_w					bigint := 0;
dt_final_vigencia_w			timestamp;
ie_consistir_fim_turno_w	parametro_agenda.ie_consistir_fim_turno%type;


BEGIN

ie_possui_agenda_p := 'N';

select 	coalesce(max(ie_consistir_fim_turno),'N')
into STRICT	ie_consistir_fim_turno_w
from	parametro_agenda
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_consistir_fim_turno_w = 'S') then

	select 	max(dt_agenda)
	into STRICT	dt_agenda_w
	from 	agenda_consulta
	where 	cd_agenda = cd_agenda_p
	and		nr_seq_turno = nr_seq_turno_p
	and		ie_status_agenda NOT IN ('C','LF','F','I','L');

	dt_final_vigencia_w := to_date(dt_final_vigencia_p,'dd/mm/yyyy hh24:mi:ss');

	if (dt_agenda_w IS NOT NULL AND dt_agenda_w::text <> '')then
		dif_datas_w := Obter_Dias_Entre_Datas(to_date(dt_final_vigencia_w,'dd/mm/yyyy'),to_date(dt_agenda_w,'dd/mm/yyyy'));
	end if;

	dt_ultima_agenda_p := to_char(dt_agenda_w,'dd/mm/yyyy');

	if (dif_datas_w > 0)then
		ie_possui_agenda_p := 'S';
		mensagem_403289_p  := WHEB_MENSAGEM_PCK.get_texto(403289,'DATA='||trunc(dt_agenda_w));
		mensagem_403436_p  := WHEB_MENSAGEM_PCK.get_texto(403436,'DATA_INI='||to_date(dt_final_vigencia_w,'dd/mm/yyyy')||';DATA_FIN='||trunc(dt_agenda_w));
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_ultima_agenda_turno (cd_agenda_p text, nr_seq_turno_p text, dt_final_vigencia_p text, ie_possui_agenda_p INOUT text, mensagem_403289_p INOUT text, mensagem_403436_p INOUT text, dt_ultima_agenda_p INOUT text) FROM PUBLIC;

