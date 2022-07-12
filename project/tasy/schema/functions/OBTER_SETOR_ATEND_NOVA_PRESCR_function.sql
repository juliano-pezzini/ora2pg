-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_atend_nova_prescr ( ie_pac_usu_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) RETURNS bigint AS $body$
DECLARE

 
cd_setor_atendimento_w	integer;
ie_registro_w		varchar(1);

BEGIN
 
if (ie_pac_usu_p	= 'R') then 
	begin 
	cd_setor_atendimento_w := (obter_setor_prescr_regra(cd_perfil_p))::numeric;
	end;
elsif (ie_pac_usu_p	= 'U') and (nr_atendimento_p > 0) then 
	begin 
	select	CASE WHEN coalesce(count(*),0)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_registro_w 
	from	setor_atendimento a 
	where	a.cd_setor_atendimento in ( 
			SELECT	b.cd_setor_atendimento 
			from	atend_paciente_unidade b 
			where	b.nr_atendimento	= nr_atendimento_p 
			and	b.cd_setor_atendimento	= cd_setor_atendimento_p);
	 
	if (ie_registro_w = 'S') then 
		begin 
		cd_setor_atendimento_w	:= cd_setor_atendimento_p;
		end;
	end if;
	end;
end if;
if (coalesce(cd_setor_atendimento_w::text, '') = '') and (nr_atendimento_p > 0) then 
	begin 
	select	coalesce(obter_unidade_atendimento(nr_atendimento_p,'IA','CS'),obter_unidade_atendimento(nr_atendimento_p,'A','CS')) 
	into STRICT	cd_setor_atendimento_w 
	;
	end;
end if;
return	cd_setor_atendimento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_atend_nova_prescr ( ie_pac_usu_p text, nr_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint) FROM PUBLIC;

