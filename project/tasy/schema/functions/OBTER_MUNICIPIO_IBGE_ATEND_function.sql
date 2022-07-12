-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_municipio_ibge_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_municipio_ibge_w		varchar(100);
cd_pessoa_fisica_w		varchar(10);
				

BEGIN 
 
select 	coalesce(max(cd_pessoa_fisica),0) 
into STRICT	cd_pessoa_fisica_w 
from 	atendimento_paciente 
where 	nr_atendimento = nr_atendimento_p;
 
select 	coalesce(obter_compl_pf(cd_pessoa_fisica_w,1,'DM'),Wheb_mensagem_pck.get_texto(305785))  
into STRICT	ds_municipio_ibge_w
;
 
return	ds_municipio_ibge_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_municipio_ibge_atend (nr_atendimento_p bigint) FROM PUBLIC;

