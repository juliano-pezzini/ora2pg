-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cd_agenda_acesso_ext ( cd_pessoa_fisica_p bigint, nm_usuario_p text, cd_pf_usuario_p bigint, cd_estab_p bigint, cd_perfil_ativo_p bigint, ie_estab_user_p text, ie_perfil_user_p text, ie_setor_user_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(20);			
			 

BEGIN 
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then 
 
	select 	max(cd_agenda) 
	into STRICT	ds_retorno_w 
	from  	agenda                 
	where  	cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   	cd_tipo_agenda = 3 
	and 	coalesce(ie_tipo_agenda_consulta, 'A') <> 'T' 
	and 	obter_se_perm_config_agecons( cd_pf_usuario_p, cd_perfil_ativo_p, cd_agenda) = 'S' 
	and	((cd_estabelecimento = cd_estab_p AND ie_estab_user_p = 'S') or ((cd_estabelecimento in ( 	SELECT  	x.cd_estabelecimento 
												from   	usuario_estabelecimento_v x 
												where  	x.nm_usuario_param = nm_usuario_p)) and (ie_estab_user_p = 'N'))) 
	and	(((cd_perfil_exclusivo in (	SELECT  	x.cd_perfil 
					from   	usuario_perfil x 
					where  	x.nm_usuario = nm_usuario_p)) and (ie_perfil_user_p = 'S')) or ((coalesce(cd_perfil_exclusivo::text, '') = '') and (ie_perfil_user_p = 'N')) or (ie_perfil_user_p not in ('S','N'))) 
	and	(((cd_setor_exclusivo in (	select  	x.cd_setor_atendimento 
					from   	usuario_setor_v x 
					where  	x.nm_usuario = nm_usuario_p)) and (ie_setor_user_p = 'S')) or ((coalesce(cd_setor_exclusivo::text, '') = '') and (ie_setor_user_p = 'N')) or (ie_setor_user_p not in ('S','N')));
 
 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cd_agenda_acesso_ext ( cd_pessoa_fisica_p bigint, nm_usuario_p text, cd_pf_usuario_p bigint, cd_estab_p bigint, cd_perfil_ativo_p bigint, ie_estab_user_p text, ie_perfil_user_p text, ie_setor_user_p text) FROM PUBLIC;

