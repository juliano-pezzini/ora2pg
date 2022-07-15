-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_pf_encaixe_ageserv ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, ds_msg_p INOUT text, nr_sessao_atual_p INOUT bigint, nr_sessao_total_p INOUT bigint) AS $body$
DECLARE

 
ds_perm_pf_classif_p	varchar(80);


BEGIN 
 
select	max(substr(obter_se_perm_pf_classif(866, cd_agenda_p, cd_pessoa_fisica_p, dt_referencia_p, 'DS'), 1,80)) 
into STRICT	ds_perm_pf_classif_p
;
 
if (ds_perm_pf_classif_p <> '') then 
	begin 
	ds_msg_p	:= substr(obter_texto_tasy(47964, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	ds_msg_p	:= replace(ds_msg_p, '#@DS_PERM_AGENDAR_CLASSIF#@', ds_perm_pf_classif_p);
	end;
end if;
 
if (coalesce(ds_msg_p::text, '') = '') then 
	begin 
	select	obter_sessao_agenda_servico(cd_pessoa_fisica_p, cd_agenda_p, 1), 
		obter_sessao_agenda_servico(cd_pessoa_fisica_p, cd_agenda_p, 2) 
	into STRICT	nr_sessao_atual_p, 
		nr_sessao_total_p 
	;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_pf_encaixe_ageserv ( cd_agenda_p bigint, cd_pessoa_fisica_p text, dt_referencia_p timestamp, ds_msg_p INOUT text, nr_sessao_atual_p INOUT bigint, nr_sessao_total_p INOUT bigint) FROM PUBLIC;

