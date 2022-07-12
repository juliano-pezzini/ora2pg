-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_local_same (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(300);
ds_local_w		varchar(40);
ds_setor_w		varchar(100);
ds_razao_social_w	varchar(60);
ds_armario_w		varchar(60);

 

BEGIN 
 
select	ds_local, 
	substr(obter_nome_setor(cd_setor_atendimento),1,100), 
	substr(obter_nome_pf_pj(null,cd_cgc),1,60), 
	ds_armario 
into STRICT	ds_local_w, 
	ds_setor_w, 
	ds_razao_social_w, 
	ds_armario_w 
from	same_local 
where	nr_sequencia	= nr_sequencia_p;
 
ds_retorno_w := ds_razao_social_w||' '||ds_setor_w||' '||ds_armario_w||' '||ds_local_w;
	 
return ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_local_same (nr_sequencia_p bigint) FROM PUBLIC;

