-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_lancar_html ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_fim_conta_w		varchar(1);
existe_processo_w	real;
cd_setor_w		bigint;


BEGIN 
cd_setor_w	:= wheb_usuario_pck.get_cd_setor_atendimento;
 
select	ie_fim_conta 
into STRICT	ie_fim_conta_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_p;
 
if (ie_fim_conta_w = 'A')	then 
	return 'S';
else	 
	select	distinct coalesce(max(1),0) 
	into STRICT	existe_processo_w 
	from 	processo_atendimento 
	where 	nr_atendimento = nr_atendimento_p 
	and 	cd_setor_resp = cd_setor_w 
	and 	coalesce(dt_fim_real::text, '') = '';
	if (existe_processo_w = 1)	then 
		return 'S';
	else 
		select 	count(*) 
		into STRICT	existe_processo_w 
		from	processo_atendimento 
		where 	nr_atendimento = nr_atendimento_p 
		and 	cd_setor_resp = cd_setor_w;
		if (existe_processo_w = 0)	then 
			return 'S';
		else 
			return 'N';
		end if;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_lancar_html ( nr_atendimento_p bigint) FROM PUBLIC;
