-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_se_possui_prescr ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
ie_resultado_w varchar(1);
cd_pessoa_fisica_w varchar(10);
			

BEGIN 
select 	cd_pessoa_fisica 
into STRICT	cd_pessoa_fisica_w 
from 	atendimento_paciente 
where 	nr_atendimento = nr_atendimento_p;
 
if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_resultado_w 
	from	hd_prescricao a, 
		prescr_medica b 
	where	a.nr_prescricao = b.nr_prescricao 
	and	((b.ie_hemodialise = 'S') or (b.ie_hemodialise = 'E')) 
	and	(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '') 
	and	b.cd_pessoa_fisica = cd_pessoa_fisica_w;
end if;
 
return	ie_resultado_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_se_possui_prescr ( nr_atendimento_p bigint) FROM PUBLIC;
