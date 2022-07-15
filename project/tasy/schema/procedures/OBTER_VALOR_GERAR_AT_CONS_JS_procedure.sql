-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_valor_gerar_at_cons_js ( cd_agenda_p bigint, cd_estabelecimento_p bigint, ie_clinica_p INOUT bigint, ie_tipo_atendimento_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ie_clinica_w			integer;
ds_resp_agenda_w		varchar(50);
ie_tipo_atendimento_w	smallint;


BEGIN 
 
if (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') then 
	begin 
	select	coalesce(max(ie_clinica),0), 
			coalesce(max(ie_tipo_atendimento),0) 
	into STRICT	ie_clinica_w, 
			ie_tipo_atendimento_w 
	from	agenda 
	where	cd_agenda = cd_agenda_p;
	end;
end if;
 
 
ie_clinica_p			:= ie_clinica_w;
ie_tipo_atendimento_p	:= ie_tipo_atendimento_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_valor_gerar_at_cons_js ( cd_agenda_p bigint, cd_estabelecimento_p bigint, ie_clinica_p INOUT bigint, ie_tipo_atendimento_p INOUT text, nm_usuario_p text) FROM PUBLIC;

