-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rothman_pacientes_medico ( cd_medico_p text) RETURNS varchar AS $body$
DECLARE

nr_atendimento_w	bigint;
ds_retorno_w		varchar(4000);
cd_estabelecimento_w	bigint;

C01 CURSOR FOR 
	SELECT	c.nr_atendimento 
	from  	atendimento_paciente c, 
			unidade_atendimento b 
	where 	b.nr_atendimento    		= c.nr_atendimento 
	and  	c.cd_estabelecimento 		= cd_estabelecimento_w 
	and		c.cd_medico_resp			 = cd_medico_p;


BEGIN 
 
cd_estabelecimento_w	:= obter_estabelecimento_ativo;
 
 
open C01;
loop 
fetch C01 into	 
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_retorno_w	:= ds_retorno_w||','||nr_atendimento_w;
	end;
end loop;
close C01;
 
 
return	substr(ds_retorno_w,2,4000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rothman_pacientes_medico ( cd_medico_p text) FROM PUBLIC;
