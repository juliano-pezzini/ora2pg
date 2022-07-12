-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exige_anamnese ( nr_prescricao_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

		 
ie_exige_anamnese_w	varchar(1) := 'N';
ie_obriga_anamnese_w	varchar(1) := 'N';


BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	begin 
	ie_obriga_anamnese_w	:= verifica_se_obriga_anamnese(nr_prescricao_p);
	 
	if (ie_obriga_anamnese_w = 'S') then 
		begin 
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
		into STRICT	ie_exige_anamnese_w 
		from	anamnese_paciente 
		where	nr_atendimento = nr_atendimento_p 
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
		end;
	end if;
	end;
end if;
return ie_exige_anamnese_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exige_anamnese ( nr_prescricao_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
