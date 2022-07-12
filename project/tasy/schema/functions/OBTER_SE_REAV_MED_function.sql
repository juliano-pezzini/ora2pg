-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_reav_med ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_prescricao_w		bigint;
ie_permite_w		varchar(1) := 'S';
dt_checagem_adep_w	timestamp;
qt_evolucao_w		bigint;


BEGIN 
select	count(*) 
into STRICT	qt_prescricao_w 
from	prescr_medica 
where	nr_atendimento = nr_atendimento_p;
 
if (qt_prescricao_w > 0) then 
	begin 
	ie_permite_w := 'N';
	 
	select	dt_checagem_adep 
	into STRICT	dt_checagem_adep_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_p;
	 
	if (dt_checagem_adep_w IS NOT NULL AND dt_checagem_adep_w::text <> '') then 
		begin 
		select	count(*) 
		into STRICT	qt_evolucao_w 
		from	evolucao_paciente 
		where	nr_atendimento = nr_atendimento_p;
		 
		if (qt_evolucao_w > 0) then 
			ie_permite_w := 'S';
		end if;
		end;	
	end if;
	end;
end if;
	 
return	ie_permite_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_reav_med ( nr_atendimento_p bigint) FROM PUBLIC;
