-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_cirurgia_opcao ( cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS timestamp AS $body$
DECLARE

 
dt_hr_inicio_W	timestamp;
ds_retorno_w	timestamp;

/*ie_opcao 
T - Todas as cirurgias 
N - Não iniciadas 
*/
 
 
C01 CURSOR FOR 
SELECT	a.hr_inicio 
from	agenda_paciente_v a 
where	clock_timestamp()			< a.hr_inicio 
and	a.cd_tipo_agenda		= 1 
and	a.ie_status_agenda	not in ('L','I','C','B','F') 
and	a.cd_pessoa_fisica 		= cd_pessoa_fisica_p 
and	ie_opcao_p		= 'N' 

union all
 
SELECT	a.hr_inicio 
from	agenda_paciente_v a 
where	a.cd_tipo_agenda		= 1 
and	a.ie_status_agenda	not in ('L','I','C','B','F') 
and	a.cd_pessoa_fisica 		= cd_pessoa_fisica_p 
and	ie_opcao_p		= 'T' 
order by	hr_inicio desc;


BEGIN 
 
OPEN	C01;
LOOP 
FETCH	C01	into 
	dt_hr_inicio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	ds_retorno_w	:= dt_hr_inicio_w;
 
END LOOP;
CLOSE C01;
 
RETURN	ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_cirurgia_opcao ( cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
