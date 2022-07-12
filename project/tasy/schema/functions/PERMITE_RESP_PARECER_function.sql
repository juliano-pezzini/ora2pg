-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION permite_resp_parecer ( cd_medico_p text, nr_seq_equipe_p bigint, cd_especialidade_p bigint) RETURNS char AS $body$
DECLARE

 
ie_equipe_w	char(1)		:= 'N';
ie_esp_med_w char(1)	:= 'N';
retorno char(1) 		:= 'N';


BEGIN 
if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then 
	 
	if (nr_seq_equipe_p IS NOT NULL AND nr_seq_equipe_p::text <> '') then 
 
		select	coalesce(max('S'),'N') 
		into STRICT	ie_equipe_w 
		from	pf_equipe_partic 
		where	cd_pessoa_fisica	= cd_medico_p 
		and		nr_seq_equipe	= nr_seq_equipe_p;
	 
	end if;
	 
	if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then 
	 
		select	coalesce(max('S'),'N') 
		into STRICT	ie_esp_med_w 
		from	medico_especialidade 
		where		cd_pessoa_fisica	= cd_medico_p 
		and		cd_especialidade	= cd_especialidade_p;
		 
	end if;
 
end if;
 
 
if (ie_equipe_w = 'S') or (ie_esp_med_w = 'S') then 
	 
	retorno := 'S';
	 
end if;
 
return retorno;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION permite_resp_parecer ( cd_medico_p text, nr_seq_equipe_p bigint, cd_especialidade_p bigint) FROM PUBLIC;
