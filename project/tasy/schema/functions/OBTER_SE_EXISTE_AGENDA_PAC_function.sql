-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_existe_agenda_pac (cd_pessoa_fisica_p text, dt_agenda_p timestamp) RETURNS bigint AS $body$
DECLARE

 
qt_retorno_w	bigint;			
			 

BEGIN 
 
select	count(*) 
into STRICT	qt_retorno_w 
from	agenda_paciente a, 
	agenda b 
where	a.cd_agenda = b.cd_agenda 
and	b.cd_tipo_agenda = 2 
and	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
and	a.hr_inicio between trunc(dt_agenda_p) and trunc(dt_agenda_p)+86399/86400 
and	a.ie_status_agenda not in ('C','F','I','E');
 
return	qt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_existe_agenda_pac (cd_pessoa_fisica_p text, dt_agenda_p timestamp) FROM PUBLIC;

