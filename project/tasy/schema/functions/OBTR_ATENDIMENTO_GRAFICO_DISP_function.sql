-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obtr_atendimento_grafico_disp ( nr_atendimento_p bigint, cd_pessoa_fisica_p bigint) RETURNS bigint AS $body$
DECLARE

 
ie_retorno_w	bigint;


BEGIN 
 
select	 
 CASE 
 WHEN(select count(dt_instalacao) from atend_pac_dispositivo where nr_atendimento = nr_atendimento_p) > 0 THEN 
  nr_atendimento_p 
 ELSE 
  a.nr_atendimento  
 END 
 INTO STRICT	ie_retorno_w 
from	atend_pac_dispositivo a, atendimento_paciente b 
where a.nr_atendimento = b.nr_atendimento 
and b.cd_pessoa_fisica = cd_pessoa_fisica_p  
order by a.nr_atendimento LIMIT 1;
 
return	ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obtr_atendimento_grafico_disp ( nr_atendimento_p bigint, cd_pessoa_fisica_p bigint) FROM PUBLIC;
