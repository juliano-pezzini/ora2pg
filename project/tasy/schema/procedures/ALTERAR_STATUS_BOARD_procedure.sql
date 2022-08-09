-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_board ( nr_sequencia_p bigint, ie_opcao_p text) AS $body$
DECLARE

ie_status_agenda_w agenda_paciente.ie_status_agenda%type;


BEGIN

	if ie_opcao_p = 'I' then
		ie_status_agenda_w := 'IN';
		UPDATE agenda_paciente
			SET ie_status_agenda = ie_status_agenda_w
		WHERE nr_sequencia = nr_sequencia_p;
	elsif ie_opcao_p = 'F' then
		ie_status_agenda_w := 'FI';
		UPDATE agenda_paciente
			SET ie_status_agenda = ie_status_agenda_w
		WHERE nr_sequencia = nr_sequencia_p;
	elsif ie_opcao_p = 'IPP' then
		ie_status_agenda_w := 'IPP';
		UPDATE agenda_paciente
			SET ie_status_agenda = ie_status_agenda_w
		WHERE nr_sequencia = nr_sequencia_p;
	end if;

commit;

	if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
		CALL generate_sch_log_cb(nr_sequencia_p, ie_status_agenda_w);
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_board ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
