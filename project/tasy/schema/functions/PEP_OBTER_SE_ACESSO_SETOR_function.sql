-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pep_obter_se_acesso_setor (nr_atendimento_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE

 
cd_setor_atend_w	bigint;
ie_permite_acesso_w	varchar(1) := 'N';


BEGIN 
if (coalesce(nr_atendimento_p,0) > 0) then 
	select	max(coalesce(obter_setor_atendimento(nr_atendimento_p),0)) 
	into STRICT	cd_setor_atend_w 
	;
 
	if (cd_setor_atend_w > 0) then 
		select	max(coalesce(ie_permite_acesso,'N')) -- ie_permite_acesso = (Impedir o acesso ao prontuário) 
		into STRICT	ie_permite_acesso_w 
		from	pep_setor_perfil 
		where	cd_perfil = cd_perfil_p 
		and	cd_setor_atendimento = cd_setor_atend_w;
	end if;
end if;
 
return	ie_permite_acesso_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pep_obter_se_acesso_setor (nr_atendimento_p bigint, cd_perfil_p bigint) FROM PUBLIC;
