-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_conta_aberto (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_conta_atend_w	bigint;
ie_conta_aberto_w	varchar(1) := 'S';
ie_perm_conta_def_w	varchar(1);

BEGIN
 
ie_perm_conta_def_w := Obter_param_Usuario(866, 173, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_perm_conta_def_w);
 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	if	((obter_funcao_ativa <> 866 and obter_funcao_ativa <> 281) or (ie_perm_conta_def_w = 'N')) then 
		/* obter se atend conta */
 
		select	count(*) 
		into STRICT	qt_conta_atend_w 
		from	conta_paciente 
		where	nr_atendimento = nr_atendimento_p;
 
		/* obter se conta aberto atend */
 
		if (qt_conta_atend_w > 0) then 
			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
			into STRICT	ie_conta_aberto_w 
			from	conta_paciente 
			where	nr_atendimento = nr_atendimento_p 
			and	ie_status_acerto = 1;
		else 
			ie_conta_aberto_w := 'S';
		end if;
	end if;
end if;
 
return ie_conta_aberto_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_conta_aberto (nr_atendimento_p bigint) FROM PUBLIC;

