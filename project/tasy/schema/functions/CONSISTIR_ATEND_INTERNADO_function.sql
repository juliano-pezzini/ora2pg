-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_atend_internado ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

					 
qt_registros_w		integer;
ie_retorno_w		varchar(1);
ie_internado_w		varchar(10);


BEGIN 
 
/* Obter parâmetro 15 da gestão de vagas que diz se deve obter pacientes com atendimento internado */
 
ie_internado_w := obter_param_usuario(1002, 15, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_internado_w);
 
if (ie_internado_w = 'S') then 
	ie_retorno_w	:= ie_internado_w;
elsif (ie_internado_w = 'N') then 
 
	select	count(*) 
	into STRICT	qt_registros_w 
	from	atendimento_paciente 
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p 
	and	coalesce(coalesce(dt_alta, dt_saida_real)::text, '') = '' 
	and	obter_se_atend_internado(nr_atendimento) = 'S';
	 
	if (qt_registros_w > 0) then 
		ie_retorno_w	:= 'N';
	else 
		ie_retorno_w	:= 'S';
	end if;
			 
end if;
	 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_atend_internado ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
