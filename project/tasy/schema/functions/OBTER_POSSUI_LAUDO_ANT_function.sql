-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_possui_laudo_ant (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w	varchar(1)	:= 'N';
qt_laudo_w		bigint;


BEGIN 
	 
select	count(*) 
into STRICT		qt_laudo_w 
from  	laudo_paciente		b, 
		atendimento_paciente	a 
where		a.nr_atendimento		= b.nr_atendimento	  
and		a.cd_pessoa_fisica	= cd_pessoa_fisica_p 
and		(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');
 
if (qt_laudo_w	> 0) then 
		ds_retorno_w	:=	'S';
 
end if;
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_possui_laudo_ant (cd_pessoa_fisica_p text) FROM PUBLIC;

