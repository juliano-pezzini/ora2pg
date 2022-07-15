-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE call_bifrost_content ( ds_event_p text, ds_json_function_p text, nm_usuario_p text) AS $body$
DECLARE


ie_use_integration_w	varchar(10);
ds_comando_w		varchar(4000);
ds_guampa_w		varchar(10)	:= chr(39);
jobno 			bigint;
		

BEGIN

ie_use_integration_w := obter_param_usuario(9041, 10, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_use_integration_w);


if (ie_use_integration_w = 'S') then
	begin
	ds_comando_w	:= '  declare '||
			   '   ds_result_w clob; '||
			   '   ds_params_w clob; '||
			   '  begin '||
			   '  philips_param_pck.set_nr_seq_idioma('||coalesce(coalesce(philips_param_pck.get_nr_seq_idioma(),Obter_Nr_Seq_Idioma(nm_usuario_p)),1)||');' ||
			   '  wheb_usuario_pck.set_cd_estabelecimento('||obter_estabelecimento_ativo||');' ||
			   '  wheb_usuario_pck.set_nm_usuario('||ds_guampa_w||nm_usuario_p||ds_guampa_w||');' ||
			   '  pkg_i18n.set_user_locale('|| ds_guampa_w || pkg_i18n.get_user_locale|| ds_guampa_w|| ' ); '||
			   '  ds_params_w :=  '||ds_json_function_p||';' ||
			   '  if (ds_params_w is not null) then '||
			   '  	ds_result_w := bifrost.send_integration_content('	||ds_guampa_w||ds_event_p|| ds_guampa_w
										||',ds_params_w '
										||','||ds_guampa_w||nm_usuario_p||ds_guampa_w
										||','||ds_guampa_w||'N'||ds_guampa_w||');' ||
			   '  end if; '||
			   '  end; ';
			
	dbms_job.submit(jobno,ds_comando_w);
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE call_bifrost_content ( ds_event_p text, ds_json_function_p text, nm_usuario_p text) FROM PUBLIC;

