-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_lib_agenda_medico ( cd_agenda_p bigint, cd_medico_p text) RETURNS varchar AS $body$
DECLARE

 
ie_libera_w		varchar(1);
ds_especialidade_w	varchar(255);

BEGIN
 
select	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  
into STRICT	ie_libera_w 
from	agenda_medico 
where	cd_agenda = cd_agenda_p;
 
if (ie_libera_w = 'N') then 
		 
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_libera_w 
	from	agenda_medico 
	where	cd_agenda 			= cd_agenda_p 
	and	coalesce(cd_medico,cd_medico_p) 	= cd_medico_p 
	and	((coalesce(cd_especialidade::text, '') = '') or (obter_se_especialidade_medico(cd_medico_p,cd_especialidade) = 'S'));
end if;
 
return	ie_libera_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_lib_agenda_medico ( cd_agenda_p bigint, cd_medico_p text) FROM PUBLIC;

