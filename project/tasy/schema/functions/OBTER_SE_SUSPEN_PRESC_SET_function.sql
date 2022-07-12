-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_suspen_presc_set (cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

--Informar se o setor pode suspender prescricoes ao fazer a transferencias de setor
			
ie_suspende_pres_w	varchar(1) := null;	
		


BEGIN

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
	select coalesce(max(ie_susp_rep_transf),'N')
	into STRICT   ie_suspende_pres_w
	from   setor_atendimento
	where  cd_setor_atendimento = cd_setor_atendimento_p;
end if;


return	ie_suspende_pres_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_suspen_presc_set (cd_setor_atendimento_p bigint) FROM PUBLIC;
