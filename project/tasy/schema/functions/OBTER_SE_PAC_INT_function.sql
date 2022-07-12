-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_int (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ie_retorno_w	varchar(1);			
			 

BEGIN 
 
select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_retorno_w 
from  setor_atendimento c, 
	atendimento_paciente b, 
	unidade_atendimento a 
where  a.nr_atendimento    = b.nr_atendimento 
and   a.cd_setor_atendimento = c.cd_setor_atendimento 
and   c.cd_classif_setor   in (3,4,8) 
and   b.cd_pessoa_fisica   = cd_pessoa_fisica_p;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_int (cd_pessoa_fisica_p text) FROM PUBLIC;

