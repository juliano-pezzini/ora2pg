-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acesso_dicom_concat (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_temp_w	varchar(4000);
ds_retorno_w 	varchar(4000);

C01 CURSOR FOR 
 
SELECT 	nr_acesso_dicom 
from	gestao_exame_v 
where 	nr_atendimento = nr_atendimento_p 
order by nr_acesso_dicom desc;


BEGIN 
open 	c01;
	loop 
	fetch 	c01 into 
		ds_temp_w;
	ds_retorno_w := ds_retorno_w || ds_temp_w||', ';
	EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
 
close c01;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acesso_dicom_concat (nr_atendimento_p bigint) FROM PUBLIC;

