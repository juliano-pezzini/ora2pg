-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_inf_pf_agenda_consulta ( cd_agenda_p bigint, dt_referencia_p timestamp, cd_pessoa_fisica_p text, qt_idade_p INOUT bigint, dt_nascimento_p INOUT timestamp, ds_msg_p INOUT text, cd_medico_solic_p INOUT text) AS $body$
DECLARE

 
ds_perm_pf_classif_p	varchar(80);
cd_medico_solic_w	varchar(255);

BEGIN
 
select	max(substr(obter_se_perm_pf_classif(866, cd_agenda_p, cd_pessoa_fisica_p, dt_referencia_p, 'DS'), 1,80)) 
into STRICT	ds_perm_pf_classif_p
;
 
if (ds_perm_pf_classif_p <> '') then 
	begin 
	ds_msg_p	:= substr(obter_texto_tasy(47964, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	ds_msg_p	:= replace(ds_msg_p, '#@DS_PERM_AGENDAR_CLASSIF#@', ds_perm_pf_classif_p);
	end;
else 
	begin 
	select	max(obter_idade(dt_nascimento, clock_timestamp(), 'A')), 
		max(dt_nascimento) 
	into STRICT	qt_idade_p, 
		dt_nascimento_p 
	from	pessoa_fisica 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p;
	end;
end if;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
	begin 
	 
	cd_medico_solic_w	:= substr(agserv_obter_med_solic(cd_pessoa_fisica_p,dt_referencia_p),1,255);
	 
	end;
end if;
 
cd_medico_solic_p	:= cd_medico_solic_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_inf_pf_agenda_consulta ( cd_agenda_p bigint, dt_referencia_p timestamp, cd_pessoa_fisica_p text, qt_idade_p INOUT bigint, dt_nascimento_p INOUT timestamp, ds_msg_p INOUT text, cd_medico_solic_p INOUT text) FROM PUBLIC;
