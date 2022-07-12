-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_visualiza_recado ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
qt_registro_w	bigint;			
			 

BEGIN 
 
select 	count(*) 
into STRICT	qt_registro_w 
from 	RECADO_MEDICO a 
Where 	(((ie_particular = 'S') and (obter_se_pessoa_recado(nr_sequencia,cd_pessoa_fisica_p) = 'S')) or (ie_particular <> 'S'))  
and 	cd_medico = cd_pessoa_fisica_p 
and 	cd_estabelecimento		= cd_estabelecimento_p 
and	coalesce(ie_recado_lido,'N')	<> 'S';
 
if (qt_registro_w	> 0) then 
	return 'S';
else 
	return 'N';
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_visualiza_recado ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

