-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cgc_congenere ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_razao_social_w		varchar(255);
nr_sequencia_w			bigint;
	

BEGIN 
 
select	nr_sequencia, 
	substr(obter_nome_pf_pj(null, cd_cgc),1,254) 
into STRICT	nr_sequencia_w, 
	ds_razao_social_w 
from	pls_congenere 
where	nr_sequencia	= nr_sequencia_p;
 
return	ds_razao_social_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cgc_congenere ( nr_sequencia_p bigint) FROM PUBLIC;

